# Installation Instructions for Claude Code /new-project Command

## Overview
This directory contains a custom `/new-project` slash command for Claude Code that creates standardized project structures. The installation scripts are designed to work properly with WSL2 Ubuntu environments and use relative paths.

## Installation Methods

### Method 1: WSL2/Ubuntu (Recommended)
```bash
# Navigate to the project directory from WSL2
cd /mnt/c/Users/adminuser/projects/claude

# Make the script executable and run it
chmod +x scripts/install-new-project.sh
./scripts/install-new-project.sh
```

### Method 2: Windows PowerShell
```powershell
# Navigate to the project directory
cd C:\Users\adminuser\projects\claude

# Run the PowerShell installer
.\install.ps1
```

### Method 3: Manual Installation
1. Copy `commands/new-project.md` to `~/.claude/commands/`
2. Copy all files from `templates/` to `~/.claude/templates/`
3. Restart Claude Code

## How It Works

### The Script Logic
- **WSL2 Script**: Uses `$(dirname "${BASH_SOURCE[0]}")` to find script location, then calculates relative paths
- **PowerShell Script**: Uses `Split-Path -Parent $MyInvocation.MyCommand.Path` for the same purpose
- Both scripts copy files from relative locations (not hardcoded paths)

### File Locations After Installation
```
~/.claude/
├── commands/
│   └── new-project.md        # The slash command
└── templates/
    ├── settings.json         # Project settings template
    ├── CLAUDE.md            # Memory template
    ├── .gitignore           # Git ignore template
    ├── README.md            # Main docs template
    ├── getting-started.md   # User docs template
    └── development-notes.md # Working docs template
```

## Usage
After installation and restarting Claude Code:
```bash
/new-project my-awesome-project
# or
/new-project
```

## Project Structure Created
```
~/projects/[project-name]/
├── .claude/
│   ├── settings.json
│   ├── CLAUDE.md
│   └── commands/
├── docs/
│   └── getting-started.md
├── working-docs/
│   └── development-notes.md
├── src/
├── tests/
├── README.md
└── .gitignore
```

## Key Improvements
- ✅ Scripts work from any location (use relative paths)
- ✅ Proper error handling and user feedback
- ✅ WSL2-optimized paths and assumptions
- ✅ Follows existing script patterns in the repository
- ✅ Color-coded output for better user experience
