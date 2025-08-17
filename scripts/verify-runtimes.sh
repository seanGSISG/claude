#!/bin/bash

# Language Runtime Verification Script
# Checks Bun and Rust installations specifically

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}$1${NC}"
    echo "$(printf '=%.0s' {1..40})"
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

echo ""

# Check GitHub CLI
print_header "GitHub CLI"
if command -v gh &> /dev/null; then
    GH_VERSION=$(gh --version | head -n1 | awk '{print $3}')
    print_status "GitHub CLI installed: $GH_VERSION"
    
    # Check if authenticated
    if gh auth status &> /dev/null; then
        print_status "GitHub authentication configured"
    else
        print_warning "GitHub CLI not authenticated"
        print_info "Run 'gh auth login' to authenticate with GitHub"
    fi
else
    print_error "GitHub CLI not installed"
    echo ""
    print_info "To install GitHub CLI manually:"
    echo "sudo apt update"
    echo "sudo apt install gh"
fi
print_header "Language Runtime Verification"
echo ""

# Check Bun
print_header "Bun JavaScript Runtime"
if command -v bun &> /dev/null; then
    BUN_VERSION=$(bun --version 2>&1)
    print_status "Bun installed: $BUN_VERSION"
    
    # Test Bun functionality
    if echo 'console.log("Bun test successful!")' | bun run - &> /dev/null; then
        print_status "Bun runtime working correctly"
    else
        print_warning "Bun installed but runtime test failed"
    fi
    
    # Check if Bun is in PATH
    if echo $PATH | grep -q ".bun/bin"; then
        print_status "Bun is in PATH"
    else
        print_warning "Bun not in PATH - may need to restart terminal"
    fi
else
    print_error "Bun not installed"
    echo ""
    print_info "To install Bun manually:"
    echo "curl -fsSL https://bun.sh/install | bash"
    echo "source ~/.bashrc"
fi

echo ""

# Check Rust
print_header "Rust Programming Language"
if command -v rustc &> /dev/null; then
    RUST_VERSION=$(rustc --version | grep -oP '\d+\.\d+\.\d+')
    print_status "Rust compiler installed: $RUST_VERSION"
    
    # Check version requirement (1.70.0+)
    RUST_MAJOR=$(echo $RUST_VERSION | cut -d. -f1)
    RUST_MINOR=$(echo $RUST_VERSION | cut -d. -f2)
    
    if [ "$RUST_MAJOR" -gt 1 ] || ([ "$RUST_MAJOR" -eq 1 ] && [ "$RUST_MINOR" -ge 70 ]); then
        print_status "Rust version meets 1.70.0+ requirement"
    else
        print_warning "Rust $RUST_VERSION found, but 1.70.0+ recommended"
        print_info "Update with: rustup update"
    fi
    
    # Check Cargo
    if command -v cargo &> /dev/null; then
        CARGO_VERSION=$(cargo --version | grep -oP '\d+\.\d+\.\d+')
        print_status "Cargo package manager: $CARGO_VERSION"
        
        # Test Cargo functionality
        if cargo --help &> /dev/null; then
            print_status "Cargo working correctly"
        else
            print_warning "Cargo installed but not working properly"
        fi
    else
        print_error "Cargo not found (should come with Rust)"
    fi
    
    # Check if Cargo is in PATH
    if echo $PATH | grep -q ".cargo/bin"; then
        print_status "Cargo is in PATH"
    else
        print_warning "Cargo not in PATH - may need to restart terminal"
    fi
else
    print_error "Rust not installed"
    echo ""
    print_info "To install Rust manually:"
    echo "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
    echo "source ~/.cargo/env"
fi

echo ""

# Summary
print_header "Runtime Summary"
TOTAL_OK=0
TOTAL_ISSUES=0

if command -v bun &> /dev/null; then
    print_status "Bun: Ready for JavaScript development"
    ((TOTAL_OK++))
else
    print_error "Bun: Not available"
    ((TOTAL_ISSUES++))
fi

if command -v rustc &> /dev/null; then
    print_status "Rust: Ready for systems programming"
    ((TOTAL_OK++))
else
    print_error "Rust: Not available"
    ((TOTAL_ISSUES++))
fi

echo ""
if [ $TOTAL_ISSUES -eq 0 ]; then
    print_status "All language runtimes are properly installed!"
    echo ""
    echo "Test commands:"
    echo "  bun run script.js     # Run JavaScript with Bun"
    echo "  cargo new my_project  # Create new Rust project"
    echo "  rustc --version       # Check Rust version"
    echo ""
else
    print_info "Found $TOTAL_ISSUES missing runtimes"
    echo ""
    echo "Quick fixes:"
    echo "1. Re-run setup script: bash setup/setup-claude-wsl.sh"
    echo "2. Install manually (see error messages above)"
    echo "3. Restart terminal: source ~/.bashrc"
    echo ""
fi

print_header "Path Configuration"
echo "Current PATH includes:"
echo $PATH | tr ':' '\n' | grep -E "(bun|cargo|rust)" | sed 's/^/  ✓ /' || echo "  ⚠ No Bun or Rust paths found"
echo ""
