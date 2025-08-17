#!/bin/bash

# Post-Installation Verification and Fix Script
# Verifies Claude Code installation and fixes common issues

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}$1${NC}"
    echo "$(printf '=%.0s' {1..50})"
}

print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[⚠]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_info() {
    echo -e "${YELLOW}[i]${NC} $1"
}

check_command() {
    local cmd=$1
    local name=$2
    
    if command -v $cmd &> /dev/null; then
        local version=$($cmd --version 2>&1 | head -n1)
        print_status "$name: $version"
        return 0
    else
        print_error "$name: Not found"
        return 1
    fi
}

fix_docker_permissions() {
    print_info "Attempting to fix Docker permissions..."
    
    if groups | grep -q docker; then
        print_info "User is in docker group. Applying to current session..."
        print_info "Run this command: newgrp docker"
        print_info "Or restart WSL for permanent fix: exit, then reopen WSL"
    else
        print_info "Adding user to docker group..."
        sudo usermod -aG docker $USER
        print_info "Group added. Restart WSL for changes to take effect."
    fi
}

fix_npm_permissions() {
    print_info "Checking npm global directory..."
    
    if [ ! -d ~/.npm-global ]; then
        print_info "Creating npm global directory..."
        mkdir -p ~/.npm-global
        npm config set prefix '~/.npm-global'
    fi
    
    if ! echo $PATH | grep -q ".npm-global"; then
        print_info "Adding npm global to PATH..."
        echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
        export PATH=~/.npm-global/bin:$PATH
    fi
    
    print_status "npm configuration verified"
}

# Main verification
echo ""
print_header "Claude Code Installation Verification"
echo ""

# Check core tools
print_header "Core Development Tools"
check_command python "Python"
check_command node "Node.js"
check_command npm "npm"
check_command bun "Bun"
check_command rustc "Rust (rustc)"
check_command cargo "Cargo (Rust package manager)"
check_command git "Git"
check_command claude "Claude Code"

echo ""
print_header "Docker Integration"
check_command docker "Docker CLI"

# Test Docker daemon connection
if docker ps &> /dev/null; then
    print_status "Docker daemon: Connected"
else
    print_error "Docker daemon: Not accessible"
    echo ""
    print_info "This is usually a permission issue. Would you like to fix it? (y/N)"
    read -r FIX_DOCKER
    if [[ "$FIX_DOCKER" =~ ^[Yy]$ ]]; then
        fix_docker_permissions
    fi
fi

echo ""
print_header "Claude Code Configuration"

# Check Claude Code files
if [ -f ~/.claude/settings.json ]; then
    print_status "Settings file exists"
else
    print_error "Settings file missing"
    print_info "Creating basic settings file..."
    mkdir -p ~/.claude
    cat > ~/.claude/settings.json << 'EOF'
{
  "env": {
    "CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR": "true"
  },
  "verbose": false,
  "theme": "dark"
}
EOF
    print_status "Settings file created"
fi

if [ -f ~/.claude/CLAUDE.md ]; then
    print_status "Memory file exists"
else
    print_warning "Memory file missing"
    print_info "Consider running the setup script to create it"
fi

if [ -d ~/projects ]; then
    print_status "Projects directory exists"
else
    print_info "Creating projects directory..."
    mkdir -p ~/projects
    print_status "Projects directory created"
fi

echo ""
print_header "Environment Configuration"

# Check PATH configuration
if echo $PATH | grep -q ".npm-global"; then
    print_status "npm global path configured"
else
    print_warning "npm global path not in PATH"
    print_info "Would you like to fix npm permissions? (y/N)"
    read -r FIX_NPM
    if [[ "$FIX_NPM" =~ ^[Yy]$ ]]; then
        fix_npm_permissions
    fi
fi

# Check aliases
if grep -q "claude-update" ~/.bashrc; then
    print_status "Claude Code aliases configured"
else
    print_warning "Claude Code aliases not found"
    print_info "Would you like to add helpful aliases? (y/N)"
    read -r ADD_ALIASES
    if [[ "$ADD_ALIASES" =~ ^[Yy]$ ]]; then
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

# Navigation
alias projects='cd ~/projects'

# WSL Specific
alias explorer='explorer.exe .'
EOF
        print_status "Aliases added to ~/.bashrc"
        print_info "Run 'source ~/.bashrc' or restart terminal to activate"
    fi
fi

echo ""
print_header "Summary and Next Steps"

# Final recommendations
echo ""
print_info "Installation Status Summary:"
echo ""

TOTAL_ISSUES=0

# Count issues and provide fixes
if ! command -v claude &> /dev/null; then
    print_error "Claude Code not installed - run setup script"
    ((TOTAL_ISSUES++))
fi

if ! docker ps &> /dev/null 2>&1; then
    print_warning "Docker permissions need fixing - run: newgrp docker"
    ((TOTAL_ISSUES++))
fi

if ! echo $PATH | grep -q ".npm-global"; then
    print_warning "npm PATH needs configuration - restart terminal"
    ((TOTAL_ISSUES++))
fi

if [ $TOTAL_ISSUES -eq 0 ]; then
    print_status "All checks passed! Claude Code is ready to use."
    echo ""
    echo "Start Claude Code with: claude"
    echo "Create a new project: /new-project my-app"
    echo ""
else
    print_info "Found $TOTAL_ISSUES issues that need attention"
    echo ""
    echo "Quick fixes:"
    echo "1. For Docker: newgrp docker"
    echo "2. For PATH: source ~/.bashrc"
    echo "3. For missing tools: re-run setup script"
    echo ""
fi

print_header "Useful Commands"
echo "claude                 # Start Claude Code"
echo "claude --version       # Check version"
echo "docker ps              # Test Docker"
echo "npm list -g            # List global packages"
echo "source ~/.bashrc       # Reload shell config"
echo ""
