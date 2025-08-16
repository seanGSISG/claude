#!/bin/bash

# Install New Project Command for Claude Code (WSL2)
# This script sets up the /new-project slash command

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[i]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

echo "================================================"
echo "    Installing Claude Code /new-project Command"
echo "    (WSL2 Ubuntu Environment)"
echo "================================================"
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

print_info "Script location: $SCRIPT_DIR"
print_info "Project root: $PROJECT_ROOT"

# Create commands directory if it doesn't exist
COMMANDS_DIR="$HOME/.claude/commands"
mkdir -p "$COMMANDS_DIR"
print_info "Commands directory: $COMMANDS_DIR"

# Copy the new-project command
if [ -f "$PROJECT_ROOT/commands/new-project.md" ]; then
    cp "$PROJECT_ROOT/commands/new-project.md" "$COMMANDS_DIR/"
    print_status "Installed /new-project command"
else
    print_error "commands/new-project.md not found in $PROJECT_ROOT"
    exit 1
fi

# Create templates directory if it doesn't exist
TEMPLATES_DIR="$HOME/.claude/templates"
mkdir -p "$TEMPLATES_DIR"
print_info "Templates directory: $TEMPLATES_DIR"

# Copy all template files
TEMPLATES=(
    "settings.json"
    "CLAUDE.md"
    ".gitignore"
    "README.md"
    "getting-started.md"
    "development-notes.md"
)

for template in "${TEMPLATES[@]}"; do
    if [ -f "$PROJECT_ROOT/templates/$template" ]; then
        cp "$PROJECT_ROOT/templates/$template" "$TEMPLATES_DIR/"
        print_status "Copied $template"
    else
        echo -e "${YELLOW}[⚠]${NC} Warning: templates/$template not found"
    fi
done

# Ensure projects directory exists
mkdir -p "$HOME/projects"
print_status "Ensured ~/projects directory exists"

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
