# Claude Code Quick Setup Scripts

One-command installation scripts for Claude Code across different platforms.

## 🚀 Quick Start

### Personal Setup (Recommended for seanGSISG)

Pre-configured with Git credentials and all features:

```bash
curl -sSL https://raw.githubusercontent.com/seanGSISG/claude/main/setup/setup-personal.sh | bash
```

### Standard WSL2 Setup (Ubuntu on Windows)

For general users or custom Git configuration:

```bash
curl -sSL https://raw.githubusercontent.com/seanGSISG/claude/main/setup/setup-claude-wsl.sh | bash
```

## 📋 Prerequisites

### For WSL2 Setup
- Windows 11 with WSL2 installed
- Ubuntu 24.04 LTS (or compatible version) in WSL
- Docker Desktop configured for WSL2 integration
- Internet connection for package downloads

## 🛠️ What Gets Installed

The setup script automatically installs and configures:

- **Development Tools**
  - Python 3 with pip and pipx (Ubuntu 24.04 compatible)
  - Node.js 20 LTS with npm
  - Bun (latest) - Fast JavaScript runtime
  - Rust (1.70.0+) with Cargo package manager
  - Git with WSL-optimized settings
  - Essential build tools

- **Claude Code**
  - Latest version via npm
  - WSL-specific configurations
  - Memory files for context awareness
  - Helpful aliases and shortcuts
  - `/new-project` command for quick project scaffolding

- **Docker Integration**
  - Docker CLI for WSL
  - Configuration to work with Docker Desktop
  - User permissions setup

## 📖 Manual Installation

If you prefer to review the script before running:

```bash
# Download the script
curl -o setup-claude-wsl.sh https://raw.githubusercontent.com/seanGSISG/claude/main/setup/setup-claude-wsl.sh

# Review it
less setup-claude-wsl.sh

# Make executable and run
chmod +x setup-claude-wsl.sh
./setup-claude-wsl.sh
```

### Automated Installation with Git Config

You can pre-configure Git credentials using environment variables:

```bash
# With Git configuration
GIT_USER_NAME="Your Name" GIT_USER_EMAIL="your.email@example.com" \
  curl -sSL https://raw.githubusercontent.com/seanGSISG/claude/main/setup/setup-claude-wsl.sh | bash

# Skip Docker installation
SKIP_DOCKER=1 curl -sSL https://raw.githubusercontent.com/seanGSISG/claude/main/setup/setup-claude-wsl.sh | bash

# Skip Git configuration prompts
SKIP_GIT_CONFIG=1 curl -sSL https://raw.githubusercontent.com/seanGSISG/claude/main/setup/setup-claude-wsl.sh | bash
```

## ✅ Verify Installation

After setup, verify everything is working:

### Quick Test
```bash
claude --version
docker ps
bun --version
rustc --version
```

### Comprehensive Verification
```bash
# Download and run verification script
curl -sSL https://raw.githubusercontent.com/seanGSISG/claude/main/scripts/verify-setup.sh | bash

# Or use local verification with auto-fix
bash scripts/verify-and-fix.sh
```

### Fix Common Issues
```bash
# Fix Docker permissions specifically
bash scripts/fix-docker-permissions.sh

# Or run comprehensive verification and fixes
bash scripts/verify-and-fix.sh
```

## 🔧 Configuration

After installation, Claude Code configuration files are located at:
- Settings: `~/.claude/settings.json`
- Memory: `~/.claude/CLAUDE.md`

### Project Scaffolding Command

The setup includes a `/new-project` command that creates a standardized project structure:

```bash
# In Claude Code, create a new project:
/new-project my-awesome-app

# This creates:
~/projects/my-awesome-app/
├── .claude/              # Claude Code configuration
│   ├── settings.json     # Project settings
│   ├── CLAUDE.md        # Project memory
│   └── commands/        # Custom commands
├── docs/                # User documentation
├── working-docs/        # Development notes
├── src/                 # Source code
├── tests/               # Test files
├── README.md           # Project readme
└── .gitignore          # Git ignore rules
```

### Git Configuration

The setup script automatically configures Git for WSL with:
- Line endings set to LF (Linux style)
- Default branch name set to `main`
- Optional user credentials configuration

To configure or update Git settings after installation:

```bash
# Run the Git configuration script
bash <(curl -sSL https://raw.githubusercontent.com/seanGSISG/claude/main/scripts/configure-git.sh)

# Or for automatic configuration
curl -sSL https://raw.githubusercontent.com/seanGSISG/claude/main/scripts/configure-git.sh | bash -s -- --auto "Your Name" "your.email@example.com"
```

## 🆘 Troubleshooting

### Docker Permission Issues
If you see "permission denied" errors with Docker:

**Quick Fix (Immediate):**
```bash
newgrp docker
```

**Permanent Fix (Recommended):**
```bash
# Exit WSL
exit

# In PowerShell: shutdown and restart WSL
wsl --shutdown
wsl

# Test
docker ps
```

**Automated Fix:**
```bash
bash scripts/fix-docker-permissions.sh
```

**Other Docker Issues:**
1. Ensure Docker Desktop is running
2. Check WSL2 integration in Docker Desktop settings
3. Verify your WSL distribution is selected in Docker Desktop

### Permission Issues
If you see permission errors:
```bash
# Reload your shell configuration
source ~/.bashrc

# Or restart your WSL terminal
```

### Python pip Issues (Ubuntu 24.04)
If you see "externally-managed-environment" errors:
- The script now handles this automatically by using system packages
- Use `pipx` for installing Python applications (included in setup)
- For Python development, create virtual environments with `python -m venv`

### Claude Code Issues
```bash
# Update to latest version
npm update -g @anthropic-ai/claude-code

# Reinstall if needed
npm uninstall -g @anthropic-ai/claude-code
npm install -g @anthropic-ai/claude-code
```

## 📚 Documentation

- [Claude Code Official Docs](https://docs.anthropic.com/en/docs/claude-code/overview)
- [Setup Guide Details](./setup/README.md)
- [Configuration Examples](./configs/)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

MIT License - See [LICENSE](LICENSE) file for details

## ⚠️ Disclaimer

These scripts are provided as-is. Always review scripts before running them on your system.

---

**Maintained by:** [@seanGSISG](https://github.com/seanGSISG)  
**Last Updated:** December 2024
