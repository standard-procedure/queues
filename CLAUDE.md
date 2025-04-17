# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands
- Run all tests: `bundle exec rspec`
- Run single test: `bundle exec rspec spec/path/to/file_spec.rb`
- Run linter and automatically fix issues: `standardrb --fix`
- Start development server: `bin/dev`
- Security scan: `bin/brakeman`
- Watch files and run tests: `guard`

## Code Style
- Ruby: Follow Standard Ruby conventions (2 space indentation, no semicolons)
- Use meaningful variable/method names in snake_case
- Models: Place validations, associations, and scopes at top of class
- Tests: Write descriptive contexts and examples, use factory methods
- Error handling: Use Rails' built-in mechanisms (rescue_from in controllers)
- JavaScript: Use Stimulus controllers for interactivity
- CSS: Use Tailwind utility classes

Always run tests and linter before submitting code changes.