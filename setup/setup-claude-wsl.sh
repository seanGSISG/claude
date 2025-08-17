#!/bin/bash

# Claude Code WSL2 Setup Script
# This script sets up a complete development environment with Claude Code in WSL2
#
# Environment variables for automation:
#   GIT_USER_NAME="Your Name"     - Set Git username automatically
#   GIT_USER_EMAIL="you@email.com" - Set Git email automatically
#   SKIP_DOCKER=1                  - Skip Docker installation
#   SKIP_GIT_CONFIG=1              - Skip Git configuration prompts
#
# Example:
#   GIT_USER_NAME="John Doe" GIT_USER_EMAIL="john@example.com" ./setup-claude-wsl.sh

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_info() {
    echo -e "${YELLOW}[i]${NC} $1"
}

# Header
echo "================================================"
echo "     Claude Code WSL2 Development Setup"
echo "================================================"
echo ""

# Step 1: Update Ubuntu
print_info "Updating Ubuntu packages..."
sudo apt update && sudo apt upgrade -y

# Step 2: Install essential tools
print_info "Installing essential build tools and utilities..."
sudo apt install -y \
    build-essential \
    curl \
    wget \
    git \
    vim \
    nano \
    zip \
    unzip \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    jq

print_status "Essential tools installed"

# Step 3: Install Python
print_info "Installing Python and development tools..."
sudo apt install -y \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    python3-setuptools \
    python3-wheel

# Create python symlinks if they don't exist
if [ ! -f /usr/bin/python ]; then
    sudo ln -sf /usr/bin/python3 /usr/bin/python
fi
if [ ! -f /usr/bin/pip ]; then
    sudo ln -sf /usr/bin/pip3 /usr/bin/pip
fi

# Upgrade pip - handle PEP 668 restrictions
# Ubuntu 24.04 restricts system-wide pip installations
if python -m pip install --upgrade pip 2>/dev/null; then
    print_status "pip upgraded successfully"
else
    # Try with --user flag
    if python -m pip install --user --upgrade pip 2>/dev/null; then
        print_status "pip upgraded for user"
    else
        # Use system package manager instead
        sudo apt install -y python3-pip
        print_info "Using system pip (upgrade via apt if needed)"
    fi
fi

# Install pipx for Python application management (recommended for Ubuntu 24.04)
sudo apt install -y pipx
pipx ensurepath

print_status "Python $(python --version) installed"
print_info "pipx installed for Python application management"

# Step 4: Install Node.js
print_info "Installing Node.js 20 LTS..."

# Check if Node.js is already installed and the version
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version | grep -oP '\d+' | head -1)
    if [ "$NODE_VERSION" -ge 20 ]; then
        print_status "Node.js $(node --version) already installed"
    else
        print_info "Upgrading Node.js from $(node --version) to v20.x"
        # Add NodeSource repository and install
        curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - > /dev/null 2>&1
        sudo apt install -y nodejs > /dev/null 2>&1
        print_status "Node.js upgraded to $(node --version)"
    fi
else
    # Add NodeSource repository quietly
    print_info "Adding NodeSource repository..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - > /dev/null 2>&1
    
    # Install Node.js
    print_info "Installing Node.js package..."
    sudo apt install -y nodejs
    
    print_status "Node.js $(node --version) installed"
fi

# Install yarn globally if not already installed
if ! command -v yarn &> /dev/null; then
    print_info "Installing Yarn package manager..."
    sudo npm install -g yarn > /dev/null 2>&1
    print_status "Yarn installed"
else
    print_status "Yarn already installed"
fi

print_status "Node.js $(node --version) and npm $(npm --version) ready"

# Step 4.5: Install Bun
print_info "Installing Bun (JavaScript runtime)..."
if command -v bun &> /dev/null; then
    print_status "Bun $(bun --version) already installed"
else
    # Install Bun using the official installer
    curl -fsSL https://bun.sh/install | bash > /dev/null 2>&1
    
    # Add Bun to PATH for current session
    export PATH="$HOME/.bun/bin:$PATH"
    
    # Add Bun to .bashrc if not already there
    if ! grep -q ".bun/bin" ~/.bashrc; then
        echo 'export PATH="$HOME/.bun/bin:$PATH"' >> ~/.bashrc
    fi
    
    if command -v bun &> /dev/null; then
        print_status "Bun $(bun --version) installed"
    else
        print_error "Bun installation failed"
    fi
fi

# Step 4.6: Install Rust
print_info "Installing Rust (1.70.0 or later)..."
if command -v rustc &> /dev/null; then
    RUST_VERSION=$(rustc --version | grep -oP '\d+\.\d+\.\d+')
    RUST_MAJOR=$(echo $RUST_VERSION | cut -d. -f1)
    RUST_MINOR=$(echo $RUST_VERSION | cut -d. -f2)
    
    # Check if version is 1.70.0 or later
    if [ "$RUST_MAJOR" -gt 1 ] || ([ "$RUST_MAJOR" -eq 1 ] && [ "$RUST_MINOR" -ge 70 ]); then
        print_status "Rust $RUST_VERSION already installed (meets 1.70.0+ requirement)"
    else
        print_info "Rust $RUST_VERSION found, but 1.70.0+ required. Updating..."
        rustup update > /dev/null 2>&1
        print_status "Rust updated to $(rustc --version | grep -oP '\d+\.\d+\.\d+')"
    fi
else
    # Install Rust using rustup
    print_info "Downloading and installing Rust toolchain..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y > /dev/null 2>&1
    
    # Source cargo environment
    source $HOME/.cargo/env
    
    # Add cargo to PATH for .bashrc if not already there
    if ! grep -q ".cargo/env" ~/.bashrc; then
        echo 'source $HOME/.cargo/env' >> ~/.bashrc
    fi
    
    if command -v rustc &> /dev/null; then
        RUST_VERSION=$(rustc --version | grep -oP '\d+\.\d+\.\d+')
        print_status "Rust $RUST_VERSION installed"
        
        # Verify version meets requirement
        RUST_MAJOR=$(echo $RUST_VERSION | cut -d. -f1)
        RUST_MINOR=$(echo $RUST_VERSION | cut -d. -f2)
        if [ "$RUST_MAJOR" -gt 1 ] || ([ "$RUST_MAJOR" -eq 1 ] && [ "$RUST_MINOR" -ge 70 ]); then
            print_status "Rust version meets 1.70.0+ requirement"
        else
            print_error "Rust $RUST_VERSION installed but 1.70.0+ required"
        fi
    else
        print_error "Rust installation failed"
    fi
fi

# Step 5: Install Docker CLI (if not skipped)
if [ "$SKIP_DOCKER" != "1" ]; then
    print_info "Installing Docker CLI for WSL..."
    sudo apt install -y docker.io docker-compose
    
    # Add current user to docker group
    sudo usermod -aG docker $USER
    
    print_status "Docker CLI installed and user added to docker group"
else
    print_info "Skipping Docker installation (SKIP_DOCKER=1)"
fi

# Step 6: Configure npm for WSL
print_info "Configuring npm for WSL environment..."
npm config set os linux

# Set up local npm global directory to avoid permission issues
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'

# Add npm global bin to PATH
if ! grep -q ".npm-global/bin" ~/.bashrc; then
    echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
fi

# Also add to current session
export PATH=~/.npm-global/bin:$PATH

print_status "npm configured for WSL"

# Step 7: Install Claude Code
print_info "Installing Claude Code..."
npm install -g @anthropic-ai/claude-code

print_status "Claude Code installed"

# Step 8: Configure Claude Code settings
print_info "Configuring Claude Code for WSL..."
mkdir -p ~/.claude

# Create settings.json
cat > ~/.claude/settings.json << 'EOF'
{
  "env": {
    "CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR": "true",
    "NODE_ENV": "production"
  },
  "verbose": false,
  "theme": "dark"
}
EOF

print_status "Claude Code settings configured"

# Step 9: Create CLAUDE.md memory file
print_info "Creating Claude Code memory file..."
cat > ~/.claude/CLAUDE.md << 'EOF'
# WSL2 Ubuntu 24.04 LTS Environment

You are running in Ubuntu 24.04 LTS on WSL2 (Windows Subsystem for Linux).

## Environment Context:
- **Operating System**: Ubuntu 24.04 LTS in WSL2
- **Shell**: Bash
- **Home Directory**: /home/$(whoami)
- **Windows Filesystem Access**: /mnt/c/, /mnt/d/, etc.

## Important Guidelines:
- This is a Linux environment - use Linux commands and paths
- Python and Node.js refer to Linux versions installed in WSL
- Docker CLI connects to Docker Desktop on Windows host
- Use forward slashes (/) for paths, not backslashes
- Prefer ~/projects/ for better I/O performance over /mnt/c/

## Installed Development Tools:
- **Python**: $(python3 --version 2>/dev/null || echo "Python 3")
- **Node.js**: $(node --version 2>/dev/null || echo "v20.x")
- **npm**: $(npm --version 2>/dev/null || echo "10.x")
- **Bun**: $(bun --version 2>/dev/null || echo "latest") - Fast JavaScript runtime
- **Rust**: $(rustc --version 2>/dev/null | grep -oP '\d+\.\d+\.\d+' || echo "1.70.0+") - Systems programming language
- **Docker**: CLI connected to Docker Desktop
- **Git**: $(git --version 2>/dev/null || echo "latest")

## Docker Configuration:
- Docker daemon runs on Windows (Docker Desktop)
- Docker CLI in WSL2 communicates with Windows daemon
- All docker commands work normally
- Container networking is handled by Docker Desktop

## File System Notes:
- Linux filesystem (/home/): Fast performance, use for projects
- Windows filesystem (/mnt/): Slower I/O, use only when necessary
- Line endings: Use LF (Linux) not CRLF (Windows)

## Best Practices:
1. Store active projects in ~/projects/ for best performance
2. Use git with core.autocrlf=input for proper line endings
3. Run Claude Code from WSL terminal, not Windows terminals
4. For file watching, prefer Linux filesystem over /mnt/
EOF

print_status "Memory file created"

# Step 10: Configure Git
print_info "Configuring Git for WSL..."

# Configure line endings for WSL
git config --global core.autocrlf input
git config --global core.eol lf

# Set default branch name to main
git config --global init.defaultBranch main

# Configure Git user if not skipped
if [ "$SKIP_GIT_CONFIG" != "1" ]; then
    # Check for environment variables first
    if [ ! -z "$GIT_USER_NAME" ] && [ ! -z "$GIT_USER_EMAIL" ]; then
        # Use environment variables if provided
        git config --global user.name "$GIT_USER_NAME"
        git config --global user.email "$GIT_USER_EMAIL"
        print_status "Git configured from environment: $GIT_USER_NAME <$GIT_USER_EMAIL>"
    else
        # Check if Git user is already configured
        EXISTING_NAME=$(git config --global user.name || echo "")
        EXISTING_EMAIL=$(git config --global user.email || echo "")
        
        if [ -z "$EXISTING_NAME" ] || [ -z "$EXISTING_EMAIL" ]; then
            echo ""
            echo "Git user configuration is required for commits."
            echo "Please enter your Git credentials (or press Ctrl+C to skip):"
            
            # Prompt for Git user name
            if [ -z "$EXISTING_NAME" ]; then
                read -p "Enter your Git username (e.g., 'John Doe'): " INPUT_NAME
                if [ ! -z "$INPUT_NAME" ]; then
                    git config --global user.name "$INPUT_NAME"
                    print_status "Git username set to: $INPUT_NAME"
                fi
            else
                print_status "Git username already configured: $EXISTING_NAME"
            fi
            
            # Prompt for Git email
            if [ -z "$EXISTING_EMAIL" ]; then
                read -p "Enter your Git email (e.g., 'user@example.com'): " INPUT_EMAIL
                if [ ! -z "$INPUT_EMAIL" ]; then
                    git config --global user.email "$INPUT_EMAIL"
                    print_status "Git email set to: $INPUT_EMAIL"
                fi
            else
                print_status "Git email already configured: $EXISTING_EMAIL"
            fi
        else
            print_status "Git user already configured: $EXISTING_NAME <$EXISTING_EMAIL>"
        fi
    fi
else
    print_info "Skipping Git user configuration (SKIP_GIT_CONFIG=1)"
fi

# Optional: Configure additional Git settings
git config --global pull.rebase false  # merge (the default strategy)
git config --global fetch.prune true   # auto-prune deleted remote branches
git config --global diff.colorMoved zebra  # better diff highlighting

print_status "Git configured for WSL"

# Step 11: Create project structure
print_info "Creating project directory structure..."
mkdir -p ~/projects
mkdir -p ~/scripts
mkdir -p ~/.claude/commands

print_status "Directory structure created"

# Step 12: Create helpful aliases
print_info "Setting up helpful aliases..."
cat >> ~/.bashrc << 'EOF'

# Claude Code Aliases
alias claude-update='npm update -g @anthropic-ai/claude-code'
alias claude-config='nano ~/.claude/settings.json'
alias claude-memory='nano ~/.claude/CLAUDE.md'

# Docker Aliases
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dim='docker images'
alias dex='docker exec -it'

# Rust Aliases
alias cargo-update='rustup update'
alias rust-version='rustc --version'

# JavaScript Runtime Aliases
alias node-version='node --version && npm --version'
alias bun-version='bun --version'

# Navigation
alias projects='cd ~/projects'

# WSL Specific
alias explorer='explorer.exe .'
EOF

print_status "Aliases configured"

# Step 13: Install /new-project command for Claude Code
print_info "Installing /new-project slash command..."

# Create Claude commands directory
mkdir -p ~/.claude/commands
mkdir -p ~/.claude/templates

# Download and install the new-project command
if curl -sSL https://raw.githubusercontent.com/seanGSISG/claude/main/commands/new-project.md -o ~/.claude/commands/new-project.md 2>/dev/null; then
    print_status "/new-project command installed"
    
    # Download project templates
    TEMPLATES=("settings.json" "CLAUDE.md" ".gitignore" "README.md" "getting-started.md" "development-notes.md")
    TEMPLATE_COUNT=0
    
    for template in "${TEMPLATES[@]}"; do
        if curl -sSL "https://raw.githubusercontent.com/seanGSISG/claude/main/templates/$template" \
             -o "$HOME/.claude/templates/$template" 2>/dev/null; then
            ((TEMPLATE_COUNT++))
        fi
    done
    
    if [ $TEMPLATE_COUNT -gt 0 ]; then
        print_status "Downloaded $TEMPLATE_COUNT project templates"
    else
        print_info "Templates will be available after pushing to GitHub"
    fi
else
    print_info "Project scaffolding will be available after pushing to GitHub"
fi

# Step 14: Test installations
print_info "Running installation tests..."
echo ""
echo "Installation Summary:"
echo "===================="
echo "Python:      $(python --version 2>&1 | grep -oP '\d+\.\d+\.\d+' || echo 'Not found')"
echo "Node.js:     $(node --version 2>&1 || echo 'Not found')"
echo "npm:         $(npm --version 2>&1 || echo 'Not found')"
echo "Bun:         $(bun --version 2>&1 || echo 'Not found')"
echo "Rust:        $(rustc --version 2>&1 | grep -oP '\d+\.\d+\.\d+' || echo 'Not found')"
echo "Docker CLI:  $(docker --version 2>&1 | grep -oP '\d+\.\d+\.\d+' || echo 'Not found')"
echo "Claude Code: $(claude --version 2>&1 || echo 'Not found')"
echo ""

# Test Docker connection
print_info "Testing Docker connection..."
if docker version &>/dev/null; then
    print_status "Docker is connected to Docker Desktop"
else
    if groups | grep -q docker; then
        print_info "Docker group configured but not active yet"
        echo ""
        echo "  To activate Docker access, run ONE of these:"
        echo "    1. newgrp docker    (quickest, current session only)"
        echo "    2. Exit and reopen WSL"
        echo "    3. Log out and back in"
        echo ""
    else
        print_error "Docker connection failed. Please ensure Docker Desktop is running with WSL2 integration enabled"
    fi
fi

# Final instructions
echo ""
echo "================================================"
echo "           Setup Complete! Next Steps:"
echo "================================================"
echo ""
echo "1. IMPORTANT: Close and reopen your terminal for all changes to take effect"
echo "   Or run: source ~/.bashrc"
echo ""
echo "2. Start Claude Code:"
echo "   claude"
echo ""
echo "3. Create a new project (after restarting Claude):"
echo "   /new-project my-awesome-app"
echo ""
echo "4. Verify Docker connection:"
echo "   docker ps"
echo ""
echo "5. Your project directory is ready at:"
echo "   ~/projects"
echo ""
echo "6. To update Claude Code in the future:"
echo "   claude-update"
echo ""
echo "Available Claude Code Commands:"
echo "  /new-project - Create a new project with standard structure"
echo "  /help - Show all available commands"
echo ""
echo "================================================"
print_info "Docker Setup Note:"
print_info "If 'docker ps' shows permission denied, run: newgrp docker"
print_info "Or exit and reopen WSL for group changes to take effect"
echo ""

# Create a quick test script
cat > ~/scripts/test-environment.sh << 'EOF'
#!/bin/bash
echo "Testing Development Environment..."
echo "================================="
echo "Python: $(python --version)"
echo "Node.js: $(node --version)"
echo "npm: $(npm --version)"
echo "Bun: $(bun --version 2>&1 || echo 'Not installed')"
echo "Rust: $(rustc --version 2>&1 || echo 'Not installed')"
echo "Cargo: $(cargo --version 2>&1 || echo 'Not installed')"
echo "Docker: $(docker --version 2>&1 || echo 'Not connected')"
echo "Claude: $(claude --version 2>&1 || echo 'Not installed')"
echo ""
echo "Docker Daemon Status:"
docker version &>/dev/null && echo "✓ Connected to Docker Desktop" || echo "✗ Not connected"
echo ""
echo "Language Runtime Status:"
bun --version &>/dev/null && echo "✓ Bun runtime available" || echo "✗ Bun not available"
rustc --version &>/dev/null && echo "✓ Rust compiler available" || echo "✗ Rust not available"
EOF

chmod +x ~/scripts/test-environment.sh

print_status "Test script created at ~/scripts/test-environment.sh"
