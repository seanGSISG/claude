#!/bin/bash

# Git Configuration Script for WSL
# Can be run independently to configure or update Git settings

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
    echo -e "${YELLOW}[i]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

echo "================================================"
echo "         Git Configuration for WSL"
echo "================================================"
echo ""

# Check if git is installed
if ! command -v git &> /dev/null; then
    print_error "Git is not installed. Please run the setup script first."
    exit 1
fi

# Function to configure Git user
configure_git_user() {
    echo "Configuring Git user credentials..."
    echo ""
    
    # Get current values
    CURRENT_NAME=$(git config --global user.name || echo "")
    CURRENT_EMAIL=$(git config --global user.email || echo "")
    
    if [ ! -z "$CURRENT_NAME" ]; then
        echo "Current Git username: $CURRENT_NAME"
        read -p "Enter new username (or press Enter to keep current): " NEW_NAME
    else
        read -p "Enter your Git username: " NEW_NAME
    fi
    
    if [ ! -z "$NEW_NAME" ]; then
        git config --global user.name "$NEW_NAME"
        print_status "Git username set to: $NEW_NAME"
    fi
    
    if [ ! -z "$CURRENT_EMAIL" ]; then
        echo "Current Git email: $CURRENT_EMAIL"
        read -p "Enter new email (or press Enter to keep current): " NEW_EMAIL
    else
        read -p "Enter your Git email: " NEW_EMAIL
    fi
    
    if [ ! -z "$NEW_EMAIL" ]; then
        git config --global user.email "$NEW_EMAIL"
        print_status "Git email set to: $NEW_EMAIL"
    fi
}

# Function to configure common Git settings
configure_git_settings() {
    echo ""
    echo "Configuring Git settings for WSL..."
    
    # Line endings
    git config --global core.autocrlf input
    print_status "Line endings: LF (Linux style)"
    
    # Default branch
    git config --global init.defaultBranch main
    print_status "Default branch: main"
    
    # Pull strategy
    git config --global pull.rebase false
    print_status "Pull strategy: merge"
    
    # Auto-prune on fetch
    git config --global fetch.prune true
    print_status "Auto-prune: enabled"
    
    # Better diffs
    git config --global diff.colorMoved zebra
    print_status "Color moved lines in diffs: enabled"
    
    # Optional: Configure merge tool
    if command -v code &> /dev/null; then
        git config --global merge.tool vscode
        git config --global mergetool.vscode.cmd 'code --wait $MERGED'
        print_status "Merge tool: VS Code"
    fi
}

# Function to configure Git aliases
configure_git_aliases() {
    echo ""
    echo "Would you like to set up useful Git aliases? (y/N)"
    read -r SETUP_ALIASES
    
    if [[ "$SETUP_ALIASES" =~ ^[Yy]$ ]]; then
        echo "Setting up Git aliases..."
        
        # Status and log aliases
        git config --global alias.st status
        git config --global alias.co checkout
        git config --global alias.br branch
        git config --global alias.ci commit
        git config --global alias.unstage 'reset HEAD --'
        git config --global alias.last 'log -1 HEAD'
        git config --global alias.visual '!gitk'
        
        # Pretty log
        git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
        
        # Show all aliases
        git config --global alias.aliases "config --get-regexp alias"
        
        print_status "Git aliases configured"
        echo ""
        echo "Available aliases:"
        echo "  git st     → git status"
        echo "  git co     → git checkout"
        echo "  git br     → git branch"
        echo "  git ci     → git commit"
        echo "  git unstage → git reset HEAD --"
        echo "  git last   → git log -1 HEAD"
        echo "  git lg     → pretty log with graph"
        echo "  git aliases → show all aliases"
    fi
}

# Function to configure SSH for Git
configure_git_ssh() {
    echo ""
    echo "Would you like to set up SSH for Git? (y/N)"
    read -r SETUP_SSH
    
    if [[ "$SETUP_SSH" =~ ^[Yy]$ ]]; then
        echo ""
        print_info "Setting up SSH for Git..."
        
        # Check for existing SSH key
        if [ -f ~/.ssh/id_rsa ] || [ -f ~/.ssh/id_ed25519 ]; then
            print_status "SSH key already exists"
        else
            echo "No SSH key found. Would you like to generate one? (y/N)"
            read -r GEN_SSH
            
            if [[ "$GEN_SSH" =~ ^[Yy]$ ]]; then
                read -p "Enter your email for the SSH key: " SSH_EMAIL
                ssh-keygen -t ed25519 -C "$SSH_EMAIL"
                print_status "SSH key generated"
            fi
        fi
        
        # Start SSH agent
        eval "$(ssh-agent -s)" > /dev/null
        
        # Add SSH key to agent
        if [ -f ~/.ssh/id_ed25519 ]; then
            ssh-add ~/.ssh/id_ed25519 2>/dev/null || true
        elif [ -f ~/.ssh/id_rsa ]; then
            ssh-add ~/.ssh/id_rsa 2>/dev/null || true
        fi
        
        # Display public key
        echo ""
        echo "Your SSH public key (add this to GitHub/GitLab/etc.):"
        echo ""
        if [ -f ~/.ssh/id_ed25519.pub ]; then
            cat ~/.ssh/id_ed25519.pub
        elif [ -f ~/.ssh/id_rsa.pub ]; then
            cat ~/.ssh/id_rsa.pub
        fi
        echo ""
        echo "Copy the above key and add it to your Git hosting service."
        echo "GitHub: https://github.com/settings/keys"
        echo "GitLab: https://gitlab.com/-/profile/keys"
    fi
}

# Function to show current Git configuration
show_git_config() {
    echo ""
    echo "Current Git Configuration:"
    echo "=========================="
    echo -e "${BLUE}User:${NC}"
    echo "  Name:  $(git config --global user.name || echo 'Not set')"
    echo "  Email: $(git config --global user.email || echo 'Not set')"
    echo ""
    echo -e "${BLUE}Core Settings:${NC}"
    echo "  Editor:       $(git config --global core.editor || echo 'default')"
    echo "  Autocrlf:     $(git config --global core.autocrlf || echo 'not set')"
    echo "  Default branch: $(git config --global init.defaultBranch || echo 'master')"
    echo ""
    echo -e "${BLUE}Aliases:${NC}"
    git config --global --get-regexp alias || echo "  No aliases configured"
}

# Main menu
main_menu() {
    while true; do
        echo ""
        echo "================================================"
        echo "         Git Configuration Menu"
        echo "================================================"
        echo "1) Configure Git user (name & email)"
        echo "2) Configure WSL-optimized settings"
        echo "3) Set up Git aliases"
        echo "4) Configure SSH for Git"
        echo "5) Show current configuration"
        echo "6) Run all configurations"
        echo "0) Exit"
        echo ""
        read -p "Select an option: " choice
        
        case $choice in
            1)
                configure_git_user
                ;;
            2)
                configure_git_settings
                ;;
            3)
                configure_git_aliases
                ;;
            4)
                configure_git_ssh
                ;;
            5)
                show_git_config
                ;;
            6)
                configure_git_user
                configure_git_settings
                configure_git_aliases
                configure_git_ssh
                show_git_config
                ;;
            0)
                echo "Exiting..."
                exit 0
                ;;
            *)
                print_error "Invalid option"
                ;;
        esac
    done
}

# Check for command line arguments
if [ "$1" == "--auto" ]; then
    # Auto mode with predefined values (useful for CI/CD)
    if [ ! -z "$2" ] && [ ! -z "$3" ]; then
        git config --global user.name "$2"
        git config --global user.email "$3"
        print_status "Git configured with: $2 <$3>"
    fi
    configure_git_settings
    show_git_config
elif [ "$1" == "--help" ]; then
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --auto NAME EMAIL  Configure Git automatically with provided name and email"
    echo "  --help            Show this help message"
    echo ""
    echo "Without options, runs in interactive mode."
else
    # Interactive mode
    main_menu
fi
