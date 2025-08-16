# Setup Scripts Documentation

## WSL2 Setup Script

### What It Does

The `setup-claude-wsl.sh` script automates the complete setup of Claude Code in WSL2 environments.

### Installation Steps

1. **System Updates**
   - Updates Ubuntu package lists
   - Upgrades all installed packages
   - Installs essential build tools

2. **Python Setup**
   - Installs Python 3 with pip
   - Creates convenient symlinks
   - Installs development headers

3. **Node.js Setup**
   - Adds NodeSource repository
   - Installs Node.js 20 LTS
   - Configures npm for WSL

4. **Docker Configuration**
   - Installs Docker CLI
   - Configures Docker group permissions
   - Sets up Docker Desktop integration

5. **Claude Code Installation**
   - Installs via npm
   - Creates configuration directory
   - Sets up WSL-specific settings

6. **Environment Configuration**
   - Creates memory files
   - Sets up Git for proper line endings
   - Adds helpful aliases

### Customization

You can customize the installation by setting environment variables:

```bash
# Custom Node.js version
NODE_VERSION=22 curl -sSL https://raw.githubusercontent.com/seanGSISG/claude/main/setup/setup-claude-wsl.sh | bash

# Skip Docker installation
SKIP_DOCKER=1 curl -sSL https://raw.githubusercontent.com/seanGSISG/claude/main/setup/setup-claude-wsl.sh | bash
```

### Post-Installation

After installation completes:

1. Restart your terminal or run `source ~/.bashrc`
2. Start Claude Code with `claude`
3. Complete authentication when prompted

### Created Files and Directories

```
~/
├── .claude/
│   ├── settings.json    # Claude Code settings
│   ├── CLAUDE.md       # Memory file
│   └── commands/       # Custom commands directory
├── projects/           # Recommended project directory
└── scripts/           # Utility scripts
    └── test-environment.sh
```

## Platform-Specific Notes

### WSL2 Considerations

- **Performance**: Store projects in Linux filesystem (`~/projects/`) not Windows mounts (`/mnt/c/`)
- **Line Endings**: Script configures Git to use LF endings
- **Docker**: Requires Docker Desktop with WSL2 integration enabled
- **Terminal**: Use WSL terminal, not Windows Command Prompt

### Network Proxy

If behind a corporate proxy, set before running:

```bash
export HTTP_PROXY=http://proxy.company.com:8080
export HTTPS_PROXY=http://proxy.company.com:8080
```

## Troubleshooting

See main [README](../README.md#troubleshooting) for common issues and solutions.
