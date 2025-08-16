# React TypeScript Project with Claude Code

## Project Context
This is a React application built with TypeScript, using modern development practices.

## Technology Stack
- **Framework**: React 18 with TypeScript
- **Build Tool**: Vite
- **State Management**: Zustand
- **Styling**: Tailwind CSS
- **Testing**: Vitest + React Testing Library
- **Linting**: ESLint with TypeScript rules
- **Formatting**: Prettier

## Project Structure
```
src/
├── components/     # Reusable React components
├── pages/         # Page components (route-level)
├── hooks/         # Custom React hooks
├── services/      # API and external service integrations
├── store/         # Zustand store definitions
├── types/         # TypeScript type definitions
├── utils/         # Utility functions
└── styles/        # Global styles and Tailwind config
```

## Development Guidelines

### Component Development
- Use functional components with TypeScript
- Implement proper TypeScript interfaces for props
- Keep components small and focused (single responsibility)
- Use custom hooks for logic extraction

### Code Style
- Use arrow functions for components
- Destructure props in function parameters
- Use explicit return types for functions
- Prefer const over let, never use var

### Testing Requirements
- Write unit tests for all utilities
- Component tests should cover user interactions
- Maintain >80% code coverage
- Use data-testid attributes for test selection

### Git Workflow
- Branch naming: feature/*, bugfix/*, hotfix/*
- Commit messages: type(scope): description
- Always create PR for main branch changes
- Require code review before merge

## Common Commands
```bash
# Development
npm run dev          # Start development server
npm run build       # Build for production
npm run preview     # Preview production build

# Testing
npm run test        # Run tests in watch mode
npm run test:ci     # Run tests once with coverage
npm run test:ui     # Open Vitest UI

# Code Quality
npm run lint        # Run ESLint
npm run format      # Run Prettier
npm run typecheck   # Run TypeScript compiler checks
```

## Performance Considerations
- Implement code splitting for routes
- Use React.memo for expensive components
- Optimize images with next-gen formats
- Keep bundle size under 200KB (gzipped)

## Security Notes
- Sanitize all user inputs
- Use environment variables for sensitive data
- Implement proper CORS policies
- Keep dependencies updated (check with npm audit)
