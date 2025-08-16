# Docker Permission Issue Quick Fix

## The Problem
After installing Docker CLI in WSL, you see this error:
```
permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock
```

## Quick Solutions (Pick One)

### Option 1: Immediate Fix (Current Session Only)
```bash
newgrp docker
```
This applies the docker group to your current session immediately.

### Option 2: Permanent Fix - Restart WSL
```bash
# In WSL terminal
exit

# In PowerShell (Windows)
wsl --shutdown

# Wait 5 seconds, then restart WSL
wsl

# Test
docker ps
```

### Option 3: Permanent Fix - Log Out and Back In
1. Close WSL completely
2. Close Windows Terminal
3. Reopen WSL
4. Test with `docker ps`

## Automated Fix Script
```bash
# Run our automated fix script
bash ~/projects/claude/scripts/fix-docker-permissions.sh
```

## Why This Happens
- The setup script adds your user to the `docker` group
- Group membership changes don't take effect until you restart your session
- This is normal behavior in Linux/WSL

## Verification
After applying any fix, test with:
```bash
docker ps
docker version
```

Both commands should work without permission errors.

## Additional Requirements
Make sure Docker Desktop is:
1. ✅ Running on Windows
2. ✅ Has WSL2 integration enabled
3. ✅ Has your WSL distribution selected

Check these in Docker Desktop Settings → Resources → WSL Integration
