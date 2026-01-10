# Northstar

A portable development workflow for disciplined, traceable development with AI assistants.

## What It Does

Northstar helps development agents (Claude, etc.) stay focused and build iteratively on solid foundations:

- **Plan before coding** - Create timestamped plans with options/decisions/trade-offs
- **Track progress** - State machine workflow prevents rushing
- **Verify quality** - Hooks check for placeholders, missing tests, debug statements
- **Auto-fix CI failures** - GitHub Action attempts to fix failing CI automatically
- **Security scanning** - CodeQL SAST and Dependabot dependency updates

## Quick Start

```bash
# Install in your project
~/Development/northstar/setup.sh /path/to/your/project

# Test it works
/remind
```

## State Machine

```
GROUNDING → PLANNING → IMPLEMENTING → VERIFYING → COMPLETE
                           ↓              ↓
                       BLOCKED ←──────────┘
```

| State | What Happens | Gate to Exit |
|-------|--------------|--------------|
| GROUNDING | Read .vision/ docs (if they exist) | Understand context |
| PLANNING | Create plan in .progress/ | Plan file exists |
| IMPLEMENTING | Do the work, log decisions | Work complete |
| VERIFYING | Tests pass, /no-cap pass | All checks pass |
| COMPLETE | Commit and push | Done |

## Directory Structure

After installation, your project will have:

```
your-project/
├── .progress/
│   ├── templates/
│   │   └── plan.md                    # Plan template
│   ├── archive/                       # Completed plans
│   └── YYYYMMDD_task.md               # Active plans
│
├── .claude/
│   ├── commands/
│   │   ├── remind.md                  # /remind command
│   │   └── no-cap.md                  # /no-cap verification
│   ├── hooks/
│   │   ├── check-plan-reminder.sh
│   │   ├── pre-commit.sh
│   │   └── pre-push-review.sh
│   └── settings.json                  # Hook configuration
│
├── .vision/                           # Optional - your north star
│   ├── NORTHSTAR.md                   # The ambitious goal
│   ├── PHILOSOPHY.md                  # Core beliefs
│   ├── CONSTRAINTS.md                 # Non-negotiables
│   ├── ARCHITECTURE.md                # System design
│   └── UX.md                          # Experience principles
│
└── .github/                           # Optional - CI integration
    ├── dependabot.yml                 # Dependency updates
    ├── PULL_REQUEST_TEMPLATE.md       # PR template
    ├── ISSUE_TEMPLATE/                # Issue templates
    │   ├── bug_report.yml
    │   ├── feature_request.yml
    │   └── config.yml
    └── workflows/
        ├── ci.yml                     # Lint/test/build
        ├── review.yml                 # Claude code review
        ├── auto-fix-ci.yml            # Auto-fix failures
        ├── codeql.yml                 # Security scanning
        └── dependabot-auto-merge.yml  # Auto-merge safe updates
```

## Commands

| Command | What It Does |
|---------|--------------|
| `/remind` | Show workflow checklist |
| `/harness` | Invoke full workflow skill (if installed) |
| `/no-cap` | Verify no placeholders or hacks |

## What Northstar Enforces (Outcomes)

| Outcome | How |
|---------|-----|
| Decisions are traceable | Decision log in plan |
| No placeholders left | /no-cap verification |
| Vision alignment | Read whatever vision docs exist |
| Quality over speed | State machine prevents rushing |
| Security by default | CodeQL scanning, Dependabot updates |

## What Northstar Does NOT Prescribe

| Flexible | Why |
|----------|-----|
| Which vision files must exist | Projects vary |
| Testing framework | Agent chooses appropriate tools |
| Code patterns | Style is agent's choice |
| Plan detail level | Proportional to task size |

## Vision Documents (Optional)

The `.vision/` directory contains your project's north star - long-lived documents that guide development.

### Templates Included

| Template | Purpose | Type |
|----------|---------|------|
| `NORTHSTAR.md` | The ambitious goal - why this project exists | STABLE |
| `PHILOSOPHY.md` | Core beliefs and how we make decisions | STABLE |
| `CONSTRAINTS.md` | Non-negotiable rules and boundaries | STABLE |
| `ARCHITECTURE.md` | System design, components, decisions | EVOLVING |
| `UX.md` | Experience principles (CLI, API, or UI) | STABLE |

### Other Common Documents

| Document | When Useful |
|----------|-------------|
| `ROADMAP.md` | Project phases and milestones |
| `[domain].md` | Domain-specific guidance |

**Not every project needs all files.** Create what's helpful for your project.

## Plan Template

Plans include:
- **Vision Alignment** - What docs were read
- **Task Description** - What and why
- **Options & Decisions** - Trade-offs considered
- **Implementation Plan** - Phases with checkboxes
- **Checkpoints** - Gates before completion
- **Test Requirements** - What to test

## CI Workflows

Northstar includes a comprehensive set of CI/CD workflows.

### Core CI (ci.yml)

Language-specific lint/test/build workflows. During setup, you choose your language:

| Language | Linter | Tests | Build |
|----------|--------|-------|-------|
| **Node.js** | `bun run lint` | `bun test` | `bun run build` |
| **Python** | `ruff check/format` | `pytest --cov` | - |
| **Go** | `golangci-lint` | `go test -race` | `go build` |
| **Rust** | `cargo fmt/clippy` | `cargo test` | `cargo build --release` |

All workflows:
- Run lint and test in parallel
- Build only after lint and test pass
- Use concurrency groups to cancel redundant runs
- Trigger on push to main and PRs

### Claude Code Review (review.yml)

AI-powered code review on PRs:
- Reviews for bugs, security, and quality
- Checks vision alignment (reads `.vision/CONSTRAINTS.md`)
- Flags missing tests
- Detects placeholders (TODO, FIXME, HACK)

**Required GitHub Secret:** `ANTHROPIC_API_KEY`

### Auto-Fix CI Failures (auto-fix-ci.yml)

Triggered when CI fails:
- Fetches failure logs
- Attempts to identify and fix root cause
- Commits fix with `"fix: resolve CI failure [auto]"`
- If unfixable, creates GitHub issue

**Required GitHub Secret:** `ANTHROPIC_API_KEY`

### CodeQL Security Scanning (codeql.yml)

Static Application Security Testing (SAST):
- Scans for vulnerabilities (SQL injection, XSS, etc.)
- Runs on push, PRs, and weekly schedule
- Supports JavaScript, Python, Go, Java, C#, C++, Ruby, Swift

### Dependabot (dependabot.yml)

Automated dependency updates:
- Updates GitHub Actions weekly
- Template includes npm, pip, go, cargo, docker (uncomment as needed)
- Groups minor/patch updates to reduce PR noise

### Dependabot Auto-Merge (dependabot-auto-merge.yml)

Safely auto-merge dependency updates:
- Auto-merges patch updates (bug fixes, security patches)
- Only merges after all CI checks pass
- Minor/major updates require manual review

## PR & Issue Templates

Standardized templates for consistency:
- **PR Template**: Summary, changes, type of change, testing checklist
- **Bug Report**: Description, expected behavior, steps to reproduce, environment
- **Feature Request**: Problem, proposed solution, alternatives, priority

## Global Claude Instructions

For workflow to apply to ALL projects, add to `~/.claude/CLAUDE.md`:

```bash
cat ~/Development/northstar/global/CLAUDE.md.snippet >> ~/.claude/CLAUDE.md
```

## Updating

To update an existing project to latest Northstar:

```bash
~/Development/northstar/setup.sh /path/to/your/project
# Will prompt before overwriting existing files
```

## Uninstalling

```bash
~/Development/northstar/uninstall.sh /path/to/your/project
```

Note: Your plans in `.progress/` and vision docs in `.vision/` are preserved.

## License

MIT
