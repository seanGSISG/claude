#!/bin/bash
# Ultra-quick Docker permission fix
echo "🔧 Quick Docker Permission Fix"
echo "=============================="
if groups | grep -q docker; then
    echo "✓ User is in docker group"
    if docker ps &>/dev/null; then
        echo "✓ Docker is working!"
    else
        echo "⚠ Applying docker group to current session..."
        exec newgrp docker
    fi
else
    echo "⚠ Adding user to docker group..."
    sudo usermod -aG docker $USER
    echo "✓ Added to group. Run: newgrp docker"
fi
