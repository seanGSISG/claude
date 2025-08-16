#!/bin/bash

# Claude Code Update Script
# Updates Claude Code to the latest version

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "================================================"
echo "        Claude Code Update Script"
echo "================================================"
echo ""

# Check if npm is available
if ! command -v npm &> /dev/null; then
    echo -e "${RED}[✗]${NC} npm is not installed. Please run the setup script first."
    exit 1
fi

# Get current version
CURRENT_VERSION=$(claude --version 2>&1 || echo "Not installed")
echo -e "${YELLOW}[i]${NC} Current version: $CURRENT_VERSION"

# Update Claude Code
echo -e "${YELLOW}[i]${NC} Updating Claude Code..."
npm update -g @anthropic-ai/claude-code

# Get new version
NEW_VERSION=$(claude --version 2>&1 || echo "Update failed")
echo -e "${GREEN}[✓]${NC} New version: $NEW_VERSION"

echo ""
echo "================================================"
echo -e "${GREEN}Claude Code has been updated successfully!${NC}"
echo "================================================"
