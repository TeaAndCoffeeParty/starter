-- ~/.config/nvim/lua/plugins/neotest.lua
return {
  {
    "nvim-neotest/neotest",
    dependencies = { "alfaix/neotest-gtest" },
    opts = function(_, opts)
      local lib = require("neotest.lib")
      local is_win = vim.fn.has("win32") == 1

      --- 与 Neotest 内部 buffer 路径一致。
      local function to_adapter_root(p)
        if not p or p == "" then
          return nil
        end
        local r = lib.files.path.real(p) or vim.fn.fnamemodify(p, ":p")
        return r:gsub("[\\/]$", "")
      end

      --- Windows 上 D:/ 与 D:\、盘符大小写会导致 vim.startswith 失败，进而重复注册适配器。
      local function path_under(child, parent_root)
        if not parent_root or parent_root == "" then
          return true
        end
        local c = to_adapter_root(child) or child
        local p = to_adapter_root(parent_root) or parent_root
        if is_win then
          c = c:gsub("/", "\\"):lower()
          p = p:gsub("/", "\\"):lower()
        end
        if c == p then
          return true
        end
        return vim.startswith(c, p .. lib.files.sep)
      end

      if is_win then
        -- 1) patch neotest.lib.file parse_dir_from_files（Windows 路径风格统一）
        do
          local files_impl = require("neotest.lib.file")
          if not files_impl._jrpg_neotest_parse_dir_orig then
            files_impl._jrpg_neotest_parse_dir_orig = files_impl.parse_dir_from_files
            files_impl.parse_dir_from_files = function(root, files)
              local nr, nfs = root, files
              if root ~= "/" then
                nr = to_adapter_root(root) or root
                nfs = {}
                for i, f in ipairs(files or {}) do
                  nfs[i] = type(f) == "string" and (to_adapter_root(f) or f) or f
                end
              end
              return files_impl._jrpg_neotest_parse_dir_orig(nr, nfs)
            end
          end
        end

        -- 2) patch NeotestClientState.update_positions（file 树 + cwd）
        do
          local factory = require("neotest.client.state")
          if type(factory) == "function" then
            local i = 1
            while true do
              local name, cls = debug.getupvalue(factory, i)
              if not name then
                break
              end
              if
                type(cls) == "table"
                and type(cls.update_positions) == "function"
                and type(cls.new) == "function"
                and not cls._jrpg_neotest_state_patched
              then
                cls._jrpg_neotest_state_patched = true
                local logger = require("neotest.logging")
                local NeotestEvents = require("neotest.client.events").events
                function cls.update_positions(self, adapter_id, tree)
                  local root_id = tree:data().id
                  logger.debug("New positions at ID", root_id)
                  if not self._positions[adapter_id] then
                    if tree:data().type ~= "dir" then
                      logger.info("File discovered without root, using cwd (jrpg cwd normalize)", root_id)
                      local cwd = to_adapter_root(vim.loop.cwd()) or vim.loop.cwd()
                      local fp = to_adapter_root(tree:data().path) or tree:data().path
                      local root = lib.files.parse_dir_from_files(cwd, { fp })
                      tree = lib.positions.merge(tree, root)
                    end
                    self._positions[adapter_id] = tree
                  else
                    self._positions[adapter_id] = lib.positions.merge(self._positions[adapter_id], tree)
                  end
                  self._events:emit(NeotestEvents.DISCOVER_POSITIONS, adapter_id, tree)
                end
                break
              end
              i = i + 1
            end
          end
        end

        -- 3) patch neotest.Client._get_adapter：find_adapter 里用 path_under 替代 vim.startswith
        do
          local client_loader = require("neotest.client")
          if type(client_loader) == "function" then
            local i = 1
            while true do
              local name, val = debug.getupvalue(client_loader, i)
              if not name then
                break
              end
              local Client
              if type(val) == "table" and val.Client and type(val.Client._get_adapter) == "function" then
                Client = val.Client
              elseif type(val) == "table" and type(val._get_adapter) == "function" and type(val.new) == "function" then
                Client = val
              end
              if Client and type(Client._get_adapter) == "function" and not Client._jrpg_get_adapter_patched then
                Client._jrpg_get_adapter_patched = true
                function Client._get_adapter(self, position_id, adapter_id)
                  if adapter_id then
                    return adapter_id, self._adapters[adapter_id]
                  end
                  assert(position_id)
                  local function find_adapter()
                    for a_id, adapter in pairs(self._adapters) do
                      if self._state:positions(a_id, position_id) then
                        return a_id, adapter
                      end
                      local root = self._state:positions(a_id)
                      if
                        (not root or path_under(position_id, root:data().path))
                        and (lib.files.is_dir(position_id) or adapter.is_test_file(position_id))
                      then
                        return a_id, adapter
                      end
                    end
                  end
                  local found_id, found_adapter = find_adapter()
                  if found_id then
                    return found_id, found_adapter
                  end
                  if self._started then
                    local dir = lib.files.is_dir(position_id) and position_id or lib.files.parent(position_id)
                    self:_update_adapters(dir)
                    return find_adapter()
                  end
                end
                break
              end
              i = i + 1
            end
          end
        end

        -- 3.5) Windows：不能 autocmds=false，否则会跳过 BufAdd/BufWritePost 上的 _update_positions，
        -- run file / run nearest 会拿不到树。只屏蔽「CursorHold + BufEnter」那条频繁 get_nearest 的 autocmd。
        do
          local client_loader = require("neotest.client")
          if type(client_loader) == "function" then
            local i = 1
            while true do
              local name, val = debug.getupvalue(client_loader, i)
              if not name then
                break
              end
              local Client
              if type(val) == "table" and val.Client and type(val.Client._start) == "function" then
                Client = val.Client
              elseif type(val) == "table" and type(val._start) == "function" and type(val.new) == "function" then
                Client = val
              end
              if Client and type(Client._start) == "function" and not Client._jrpg_start_patched then
                Client._jrpg_start_patched = true
                local orig_start = Client._start
                local function is_cursorhold_bufenter_nearest_combo(event)
                  if type(event) ~= "table" then
                    return false
                  end
                  local hold, enter = false, false
                  for _, e in ipairs(event) do
                    if e == "CursorHold" then
                      hold = true
                    elseif e == "BufEnter" then
                      enter = true
                    end
                  end
                  return hold and enter
                end
                function Client._start(self, args)
                  args = args or {}
                  local nio_mod = require("nio")
                  local orig_create = nio_mod.api.nvim_create_autocmd
                  nio_mod.api.nvim_create_autocmd = function(event, opts)
                    if is_cursorhold_bufenter_nearest_combo(event) then
                      return
                    end
                    return orig_create(event, opts)
                  end
                  local ok, err = pcall(orig_start, self, args)
                  nio_mod.api.nvim_create_autocmd = orig_create
                  if not ok then
                    error(err)
                  end
                end
                break
              end
              i = i + 1
            end
          end
        end

        -- 4) patch AdapterGroup:adapters_matching_open_bufs 的 is_under_roots（_update_adapters 第二套根）
        do
          local adapters_loader = require("neotest.adapters")
          if type(adapters_loader) == "function" then
            local i = 1
            while true do
              local name, AdapterGroup = debug.getupvalue(adapters_loader, i)
              if not name then
                break
              end
              if
                type(AdapterGroup) == "table"
                and type(AdapterGroup.adapters_matching_open_bufs) == "function"
                and not AdapterGroup._jrpg_adapters_patched
              then
                AdapterGroup._jrpg_adapters_patched = true
                local logger = require("neotest.logging")
                local nio = require("nio")
                function AdapterGroup.adapters_matching_open_bufs(self, existing_roots)
                  local function is_under_roots(path)
                    for _, root in ipairs(existing_roots or {}) do
                      if type(root) == "string" and path_under(path, root) then
                        return true
                      end
                    end
                    return false
                  end
                  local adapters = {}
                  local buffers = nio.api.nvim_list_bufs()
                  local paths = lib.func_util.map(function(idx, buf)
                    local real
                    if nio.api.nvim_buf_is_loaded(buf) then
                      local path = nio.api.nvim_buf_get_name(buf)
                      real = lib.files.path.real(path)
                    end
                    return idx, real or false
                  end, buffers)
                  local matched_files = {}
                  for _, path in ipairs(paths) do
                    if path and not is_under_roots(path) then
                      for _, adapter in ipairs(self:_path_adapters(path)) do
                        if adapter.is_test_file(path) and not matched_files[path] then
                          logger.info("Adapter", adapter.name, "matched buffer", path)
                          matched_files[path] = true
                          table.insert(adapters, adapter)
                          break
                        end
                      end
                    end
                  end
                  return adapters
                end
                break
              end
              i = i + 1
            end
          end
        end
      end

      --- JRPG-sdk 主仓库根
      local function jrpg_sdk_root(path)
        local curr = vim.fn.fnamemodify(path, ":p"):gsub("[\\/]$", "")
        if lib.files.exists(curr) and not lib.files.is_dir(curr) then
          curr = vim.fn.fnamemodify(curr, ":h")
        end
        local function is_sdk_root(dir)
          local cmake = vim.fs.joinpath(dir, "CMakeLists.txt")
          if vim.fn.filereadable(cmake) ~= 1 then
            return false
          end
          for _, line in ipairs(vim.fn.readfile(cmake, "", 48)) do
            if line:match("project%s*%(%s*JRPG%-sdk") then
              return true
            end
          end
          return false
        end
        while curr and #curr > 1 do
          if is_sdk_root(curr) then
            return to_adapter_root(curr)
          end
          local parent = vim.fn.fnamemodify(curr, ":h")
          if parent == curr then
            break
          end
          curr = parent
        end
      end

      if is_win then
        opts.discovery = vim.tbl_extend("force", opts.discovery or {}, { concurrent = 1 })

        -- 减轻卡顿：Windows + 大 gtest 树上 Summary 渲染与 buffer 装饰频繁刷新
        -- 注意：consumer 加载条件是「无该段配置」或「config.xxx.enabled 为真」；
        -- 这里显式 enabled=true，避免 summary/status/output 不加载导致 .summary 为 nil。
        opts.summary = vim.tbl_extend("force", opts.summary or {}, {
          enabled = true,
          count = false,
          animated = false,
          follow = false,
          expand_errors = false,
        })
        opts.status = vim.tbl_extend("force", opts.status or {}, {
          enabled = true,
          virtual_text = false,
        })
        opts.output = vim.tbl_extend("force", opts.output or {}, {
          enabled = true,
          open_on_run = false,
        })
      end

      opts.adapters = opts.adapters or {}
      opts.adapters["neotest-gtest"] = {
        parsing_throttle_ms = 100,
        is_test_file = function(file_path)
          local filename = vim.fn.fnamemodify(file_path, ":t")
          return filename:match("^tst_.*%.cpp$") or filename:match("^test_.*%.cpp$")
        end,
        root = function(path)
          local sdk = jrpg_sdk_root(path)
          if sdk then
            return sdk
          end
          local default_fn = lib.files.match_root_pattern(
            "compile_commands.json",
            "compile_flags.txt",
            "WORKSPACE",
            ".clangd",
            "init.lua",
            "init.vim",
            "build",
            ".git"
          )
          local found = default_fn(path)
          if found then
            return to_adapter_root(found)
          end
        end,
      }
      return opts
    end,
    --- Neotest 在 CursorHold 里做 get_nearest；updatetime 过小会极频繁触发，加重卡顿。
    --- 必须用 init，不要用 config：LazyVim extras/test/core.lua 的 config 会
    --- require("neotest").setup(opts)。若本 spec 单独写 config 且未调用 setup，
    --- 会覆盖/挤掉上述逻辑，导致 summary 等 consumer 未注册 → E5108 summary 为 nil。
    init = function()
      if vim.fn.has("win32") == 1 and vim.o.updatetime < 500 then
        vim.o.updatetime = 500
      end
    end,
  },
}
