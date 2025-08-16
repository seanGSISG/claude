# Contributing to Claude Code Setup Scripts

We love your input! We want to make contributing to this project as easy and transparent as possible, whether it's:

- Reporting a bug
- Discussing the current state of the code
- Submitting a fix
- Proposing new features
- Becoming a maintainer

## We Develop with Github

We use GitHub to host code, to track issues and feature requests, as well as accept pull requests.

## We Use [Github Flow](https://guides.github.com/introduction/flow/index.html)

Pull requests are the best way to propose changes to the codebase:

1. Fork the repo and create your branch from `main`
2. If you've added code that should be tested, add tests
3. If you've changed scripts, update the documentation
4. Ensure the scripts work in a clean WSL environment
5. Make sure your code follows the existing style
6. Issue that pull request!

## Any contributions you make will be under the MIT Software License

In short, when you submit code changes, your submissions are understood to be under the same [MIT License](LICENSE) that covers the project.

## Report bugs using Github's [issues](https://github.com/seanGSISG/claude/issues)

We use GitHub issues to track public bugs. Report a bug by [opening a new issue](https://github.com/seanGSISG/claude/issues/new).

**Great Bug Reports** tend to have:

- A quick summary and/or background
- Steps to reproduce
  - Be specific!
  - Give sample code if you can
- What you expected would happen
- What actually happens
- Notes (possibly including why you think this might be happening, or stuff you tried that didn't work)
- System information (Windows version, WSL version, Ubuntu version)

## Testing Your Changes

Before submitting a PR:

1. Test in a fresh WSL2 Ubuntu installation
2. Verify all installed components work correctly
3. Run the verification script
4. Test both online and offline scenarios (where applicable)
5. Test with and without Docker Desktop

## Script Style Guide

### Bash Scripts

- Use `#!/bin/bash` shebang
- Set `set -e` for error handling
- Use meaningful variable names
- Add comments for complex logic
- Use functions for repeated code
- Include error checking and user feedback
- Use color codes for better readability

### Documentation

- Use Markdown for all documentation
- Include code examples with proper syntax highlighting
- Keep README files updated with script changes
- Document all configuration options
- Include troubleshooting sections

## Adding New Features

When adding new features:

1. Discuss the feature in an issue first
2. Keep the script modular
3. Make features optional where possible
4. Document the feature thoroughly
5. Add to the verification script if needed

## License

By contributing, you agree that your contributions will be licensed under its MIT License.

## References

This document was adapted from the open-source contribution guidelines for [Facebook's Draft](https://github.com/facebook/draft-js/blob/a9316a723f9e918afde44dea68b5f9f39b7d9b00/CONTRIBUTING.md)
