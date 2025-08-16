#!/bin/bash

# Claude Code Installation Verification Script
# https://github.com/seanGSISG/claude

echo "🔍 Claude Code Installation Verification"
echo "========================================"
echo ""

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Verification functions
check_command() {
    if command -v $1 &> /dev/null; then
        VERSION=$($1 --version 2>&1 | head -n1)
        echo -e "${GREEN}✓${NC} $1: $VERSION"
        return 0
    else
        echo -e "${RED}✗${NC} $1: Not found"
        return 1
    fi
}

check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} $2 exists"
        return 0
    else
        echo -e "${RED}✗${NC} $2 missing"
        return 1
    fi
}

check_dir() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✓${NC} $2 exists"
        return 0
    else
        echo -e "${YELLOW}⚠${NC} $2 missing (optional)"
        return 1
    fi
}

# Check core tools
echo "Core Tools:"
echo "-----------"
check_command python
check_command node
check_command npm
check_command git
check_command claude

echo ""
echo "Docker Integration:"
echo "------------------"
check_command docker
if docker ps &> /dev/null; then
    echo -e "${GREEN}✓${NC} Docker daemon connected"
else
    echo -e "${RED}✗${NC} Docker daemon not accessible"
    echo "  → Ensure Docker Desktop is running with WSL2 integration"
fi

echo ""
echo "Claude Code Configuration:"
echo "------------------------"
check_file "$HOME/.claude/settings.json" "Settings file"
check_file "$HOME/.claude/CLAUDE.md" "Memory file"
check_dir "$HOME/.claude/commands" "Commands directory"
check_dir "$HOME/projects" "Projects directory"

echo ""
echo "Environment Variables:"
echo "--------------------"
if [ -n "$PATH" ] && echo $PATH | grep -q ".npm-global"; then
    echo -e "${GREEN}✓${NC} npm global path configured"
else
    echo -e "${YELLOW}⚠${NC} npm global path not in PATH"
fi

echo ""
echo "========================================"
if [ $? -eq 0 ]; then
    echo -e "${GREEN}All checks passed!${NC} Claude Code is ready to use."
    echo ""
    echo "Start Claude Code with: claude"
else
    echo -e "${YELLOW}Some checks failed.${NC} Review the output above."
fi
