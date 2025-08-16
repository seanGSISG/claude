#!/bin/bash

# Personal Quick Setup Script for seanGSISG
# This script runs the main setup with pre-configured Git credentials
# and installs the /new-project command for quick project scaffolding

echo "================================================"
echo "     Claude Code WSL Quick Setup"
echo "     Configured for: seanGSISG"
echo "================================================"
echo ""
echo "This will install:"
echo "  ✓ Claude Code with WSL optimizations"
echo "  ✓ Git configured with your credentials"
echo "  ✓ /new-project command for scaffolding"
echo "  ✓ Docker CLI integration"
echo "  ✓ Python, Node.js, and dev tools"
echo ""

# Set Git configuration
export GIT_USER_NAME="seanGSISG"
export GIT_USER_EMAIL="sswanson@gsisg.com"

# Run the main setup script
curl -sSL https://raw.githubusercontent.com/seanGSISG/claude/main/setup/setup-claude-wsl.sh | bash

echo ""
echo "================================================"
echo "Personal setup complete!"
echo "Git configured as: $GIT_USER_NAME <$GIT_USER_EMAIL>"
echo ""
echo "Quick Start:"
echo "  1. Restart your terminal or run: source ~/.bashrc"
echo "  2. Start Claude Code: claude"
echo "  3. Create a new project: /new-project my-app"
echo "================================================"
