@echo off
set "VSC_USER=%APPDATA%\Code\User"
set "TARGET_DIR=C:\Users\%USERNAME%\AppData\Local\nvim\vscode"

:: 1. 创建目标目录（如果不存在）
if not exist "%TARGET_DIR%" mkdir "%TARGET_DIR%"

:: 2. 删除原有的普通文件（避免冲突）
if exist "%VSC_USER%\settings.json" del /f "%VSC_USER%\settings.json"
if exist "%VSC_USER%\keybindings.json" del /f "%VSC_USER%\keybindings.json"

:: 3. 创建符号链接
cmd /c mklink "%VSC_USER%\settings.json" "%TARGET_DIR%\settings.json"
cmd /c mklink "%VSC_USER%\keybindings.json" "%TARGET_DIR%\keybindings.json"

echo Done!
pause