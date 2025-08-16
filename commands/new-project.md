---
description: Create a new project with standardized folder structure and Claude Code configuration
argument-hint: <project-name>
allowed-tools: Bash, Write, Read
---

I need to create a new project with a standardized structure. Please follow these steps:

1. **Get project name**: If no project name was provided in $ARGUMENTS, ask the user for the project name
2. **Create project directory**: Create the main project folder at `~/projects/[project-name]`
3. **Set up folder structure**:
   - `.claude/` - Claude Code configuration
   - `docs/` - End-user documentation (stable markdown files)
   - `working-docs/` - Development documentation (frequently changing)
   - `src/` - Source code directory
   - `tests/` - Test files

4. **Create Claude Code configuration files**:
   - `.claude/settings.json` - Project-specific settings
   - `.claude/CLAUDE.md` - Project memory/context file
   - `.claude/commands/` - Directory for custom project commands

5. **Create template files**:
   - `README.md` - Main project documentation
   - `docs/getting-started.md` - User documentation template
   - `working-docs/development-notes.md` - Development scratch pad
   - `.gitignore` - Standard gitignore file

6. **Initialize git repository** if git is available

7. **Navigate to the new project** and confirm setup

Please create a professional project structure that I can use as a consistent starting point for all new projects.
