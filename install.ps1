# Install New Project Command for Claude Code (PowerShell)
# This script sets up the /new-project slash command on Windows

Write-Host "================================================" -ForegroundColor Green
Write-Host "    Installing Claude Code /new-project Command" -ForegroundColor Green
Write-Host "    (Windows PowerShell)" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green
Write-Host ""

# Get the directory where this script is located
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Write-Host "Script location: $ScriptDir" -ForegroundColor Blue

# Create commands directory if it doesn't exist
$CommandsDir = "$env:USERPROFILE\.claude\commands"
if (!(Test-Path $CommandsDir)) {
    New-Item -ItemType Directory -Path $CommandsDir -Force | Out-Null
}

# Copy the new-project command
if (Test-Path "$ScriptDir\commands\new-project.md") {
    Copy-Item "$ScriptDir\commands\new-project.md" "$CommandsDir\" -Force
    Write-Host "✓ Installed /new-project command" -ForegroundColor Green
} else {
    Write-Host "✗ Error: commands\new-project.md not found" -ForegroundColor Red
    exit 1
}

# Create templates directory if it doesn't exist
$TemplatesDir = "$env:USERPROFILE\.claude\templates"
if (!(Test-Path $TemplatesDir)) {
    New-Item -ItemType Directory -Path $TemplatesDir -Force | Out-Null
}

# Copy all template files
$Templates = @(
    "settings.json",
    "CLAUDE.md",
    ".gitignore",
    "README.md",
    "getting-started.md",
    "development-notes.md"
)

foreach ($template in $Templates) {
    $sourcePath = "$ScriptDir\templates\$template"
    if (Test-Path $sourcePath) {
        Copy-Item $sourcePath "$TemplatesDir\" -Force
        Write-Host "✓ Copied $template" -ForegroundColor Green
    } else {
        Write-Host "⚠ Warning: templates\$template not found" -ForegroundColor Yellow
    }
}

# Ensure projects directory exists
$ProjectsDir = "$env:USERPROFILE\projects"
if (!(Test-Path $ProjectsDir)) {
    New-Item -ItemType Directory -Path $ProjectsDir -Force | Out-Null
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Green
Write-Host "Installation Complete!" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green
Write-Host ""
Write-Host "The /new-project command has been installed!"
Write-Host ""
Write-Host "Usage in Claude Code:"
Write-Host "  /new-project my-awesome-project"
Write-Host "  or"
Write-Host "  /new-project (and enter project name when prompted)"
Write-Host ""
Write-Host "This will create a new project at ~/projects/[project-name]/"
Write-Host "with the following structure:"
Write-Host "  ├── .claude/              # Claude Code configuration"
Write-Host "  ├── docs/                 # End-user documentation"
Write-Host "  ├── working-docs/         # Development notes"
Write-Host "  ├── src/                  # Source code"
Write-Host "  ├── tests/                # Test files"
Write-Host "  ├── README.md             # Main documentation"
Write-Host "  └── .gitignore            # Git ignore rules"
Write-Host ""
Write-Host "Note: Restart Claude Code to see the new command in /help" -ForegroundColor Yellow
