#!/bin/bash

# Personal Quick Setup Script for seanGSISG
# This script runs the main setup with pre-configured Git credentials

echo "================================================"
echo "     Claude Code WSL Quick Setup"
echo "     Configured for: seanGSISG"
echo "================================================"
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
echo "================================================"
