@echo off
REM Quick WSL Claude Code Setup Launcher for Windows
REM This script launches the setup in WSL

echo ================================================
echo     Claude Code WSL Setup Launcher
echo ================================================
echo.

REM Check if WSL is installed
wsl --status >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] WSL is not installed or not available.
    echo Please install WSL2 first: wsl --install
    pause
    exit /b 1
)

REM Get the default WSL distribution
for /f "tokens=1" %%i in ('wsl -l -q ^| findstr /r "^[a-zA-Z]"') do (
    set WSL_DISTRO=%%i
    goto :found
)

:found
if "%WSL_DISTRO%"=="" (
    echo [ERROR] No WSL distribution found.
    echo Please install Ubuntu: wsl --install -d Ubuntu
    pause
    exit /b 1
)

echo Using WSL distribution: %WSL_DISTRO%
echo.
echo This will install Claude Code in your WSL environment.
echo.
pause

REM Run the setup script in WSL
wsl -d %WSL_DISTRO% bash -c "curl -sSL https://raw.githubusercontent.com/seanGSISG/claude/main/setup/setup-claude-wsl.sh | bash"

echo.
echo ================================================
echo Setup complete! 
echo.
echo To start Claude Code:
echo 1. Open WSL: wsl
echo 2. Run: claude
echo ================================================
pause
