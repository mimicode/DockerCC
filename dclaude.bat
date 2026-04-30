@echo off
rem dclaude.bat - Windows Docker claude-code
setlocal EnableDelayedExpansion
set "IMAGE_NAME=claude-cc"
set "ENV_TAG=latest"
set "PASS_ARGS="
:parse
if "%~1"=="" goto :done_parse
if "%~1"=="-e" (
    set "ENV_TAG=%~2"
    shift
    shift
    goto :parse
)
if "%~1"=="--" (
    shift
    :collect
    if "%~1"=="" goto :done_parse
    set "PASS_ARGS=!PASS_ARGS! %~1"
    shift
    goto :collect
)
set "PASS_ARGS=!PASS_ARGS! %~1"
shift
goto :parse
:done_parse
set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
cd /d "%CD%" 2>/dev/null
set "WORK_DIR=%CD%"
if not "!ENV_TAG!"=="latest" (
    docker image inspect "!IMAGE_NAME!:!ENV_TAG!" >/dev/null 2>&1
    if errorlevel 1 (
        echo Mirror !IMAGE_NAME!:!ENV_TAG! not found, building...
        docker build --build-arg INSTALL_ENVS="!ENV_TAG!" -t "!IMAGE_NAME!:!ENV_TAG!" "!SCRIPT_DIR!"
    )
)
if defined ANTHROPIC_API_KEY (
    set "API_KEY_ENV=-e ANTHROPIC_API_KEY=!ANTHROPIC_API_KEY!"
) else (
    set "API_KEY_ENV="
)
echo Starting !IMAGE_NAME!:!ENV_TAG! ...
docker run -it --rm -v "!WORK_DIR!:/workspace" -v "%USERPROFILE%/.claude:/home/claude/.claude" !API_KEY_ENV! -w /workspace "!IMAGE_NAME!:!ENV_TAG!" claude --dangerously-skip-permissions !PASS_ARGS!
endlocal
