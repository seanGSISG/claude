#!/bin/bash

# Docker Permission Fix Script for WSL
# Resolves the common "permission denied" error when running Docker commands

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
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

print_docker_fix() {
    echo -e "${BLUE}[Docker Fix]${NC} $1"
}

echo "================================================"
echo "        Docker Permission Fix for WSL"
echo "================================================"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please run the setup script first."
    exit 1
fi

# Check if user is in docker group
if groups | grep -q docker; then
    print_status "User is in docker group"
    
    # Test Docker connection
    if docker ps &>/dev/null; then
        print_status "Docker is working correctly!"
        echo "No fix needed."
        exit 0
    else
        print_docker_fix "Docker group is configured but not active"
        echo ""
        echo "This is normal after installation. Choose a fix:"
        echo ""
        echo "1. Apply docker group to current session (recommended)"
        echo "2. Instructions for permanent fix"
        echo "3. Check Docker Desktop status"
        echo ""
        read -p "Enter your choice (1-3): " choice
        
        case $choice in
            1)
                print_docker_fix "Applying docker group to current session..."
                exec newgrp docker
                ;;
            2)
                echo ""
                print_info "For permanent fix, choose ONE of these options:"
                echo ""
                echo "Option A: Restart WSL (Recommended)"
                echo "  1. Exit WSL completely: exit"
                echo "  2. In PowerShell: wsl --shutdown"
                echo "  3. Wait 5 seconds, then: wsl"
                echo "  4. Test with: docker ps"
                echo ""
                echo "Option B: Log out and back in"
                echo "  1. Exit WSL: exit"
                echo "  2. Close Windows terminal completely"
                echo "  3. Reopen WSL"
                echo "  4. Test with: docker ps"
                echo ""
                ;;
            3)
                print_info "Checking Docker Desktop status..."
                if docker version &>/dev/null; then
                    print_status "Docker Desktop is running and accessible"
                else
                    print_error "Docker Desktop is not accessible"
                    echo ""
                    echo "Please ensure:"
                    echo "1. Docker Desktop is running on Windows"
                    echo "2. WSL2 integration is enabled in Docker Desktop settings"
                    echo "3. Your WSL distribution is selected in Docker Desktop"
                fi
                ;;
            *)
                print_error "Invalid choice"
                ;;
        esac
    fi
else
    print_error "User is not in docker group"
    print_docker_fix "Adding user to docker group..."
    
    sudo usermod -aG docker $USER
    print_status "User added to docker group"
    
    echo ""
    print_info "Group membership updated. Choose next step:"
    echo ""
    echo "1. Apply to current session: newgrp docker"
    echo "2. Exit and restart WSL (recommended for permanent fix)"
    echo ""
    read -p "Enter your choice (1-2): " choice
    
    case $choice in
        1)
            print_docker_fix "Applying docker group to current session..."
            exec newgrp docker
            ;;
        2)
            print_info "Please exit WSL and restart it for permanent fix"
            echo "  1. Type: exit"
            echo "  2. Reopen WSL"
            echo "  3. Test with: docker ps"
            ;;
        *)
            print_error "Invalid choice"
            ;;
    esac
fi

echo ""
echo "================================================"
echo "After applying the fix, test with: docker ps"
echo "================================================"
