# Development Environment Configuration

## Environment Type
- WSL2 Ubuntu 24.04 LTS
- Development machine with Docker Desktop integration

## Project Standards
- Use TypeScript for all new JavaScript projects
- Follow PEP 8 for Python code
- Use Rust formatting (rustfmt) for Rust code
- Commit messages follow Conventional Commits specification
- All code must pass linting before commit

## Preferred Tools
- JavaScript Package Managers: npm, bun (for fast execution)
- Python Virtual Environments: venv, pipx for applications
- Rust Package Manager: cargo
- Testing: Jest for JavaScript, pytest for Python, cargo test for Rust

## Security Notes
- Never commit .env files
- Always use environment variables for secrets
- Review all generated code for security issues
