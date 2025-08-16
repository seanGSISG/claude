#!/bin/bash

# Install New Project Command for Claude Code (WSL2 Ubuntu)
# This script sets up the /new-project slash command

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo "================================================"
echo "    Installing Claude Code /new-project Command"
echo "    (WSL2 Ubuntu Environment)"
echo "================================================"
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo -e "${BLUE}[i]${NC} Script location: $SCRIPT_DIR"

# Create commands directory if it doesn't exist
COMMANDS_DIR="$HOME/.claude/commands"
mkdir -p "$COMMANDS_DIR"
echo -e "${BLUE}[i]${NC} Commands directory: $COMMANDS_DIR"

# Copy the new-project command
if [ -f "$SCRIPT_DIR/commands/new-project.md" ]; then
    cp "$SCRIPT_DIR/commands/new-project.md" "$COMMANDS_DIR/"
    echo -e "${GREEN}✓${NC} Installed /new-project command"
else
    echo -e "${RED}✗${NC} Error: commands/new-project.md not found in $SCRIPT_DIR"
    exit 1
fi

# Create templates directory if it doesn't exist
TEMPLATES_DIR="$HOME/.claude/templates"
mkdir -p "$TEMPLATES_DIR"
echo -e "${BLUE}[i]${NC} Templates directory: $TEMPLATES_DIR"

# Copy all template files
for template in settings.json CLAUDE.md .gitignore README.md getting-started.md development-notes.md; do
    if [ -f "$SCRIPT_DIR/templates/$template" ]; then
        cp "$SCRIPT_DIR/templates/$template" "$TEMPLATES_DIR/"
        echo -e "${GREEN}✓${NC} Copied $template"
    else
        echo -e "${YELLOW}⚠${NC} Warning: templates/$template not found"
    fi
done


# Ensure projects directory exists
mkdir -p "$HOME/projects"
echo -e "${GREEN}✓${NC} Ensured ~/projects directory exists"

echo ""
echo "================================================"
echo -e "${GREEN}Installation Complete!${NC}"
echo "================================================"
echo ""
echo "The /new-project command has been installed!"
echo ""
echo "Usage in Claude Code:"
echo "  /new-project my-awesome-project"
echo "  or"
echo "  /new-project (and enter project name when prompted)"
echo ""
echo "This will create a new project at ~/projects/[project-name]/"
echo "with the following structure:"
echo "  ├── .claude/              # Claude Code configuration"
echo "  ├── docs/                 # End-user documentation"
echo "  ├── working-docs/         # Development notes"
echo "  ├── src/                  # Source code"
echo "  ├── tests/                # Test files"
echo "  ├── README.md             # Main documentation"
echo "  └── .gitignore            # Git ignore rules"
echo ""
echo -e "${YELLOW}Note:${NC} Restart Claude Code to see the new command in /help"
