# Project Constraints

**Type:** STABLE
**Created:** [DATE]
**Last Updated:** [DATE]

---

## Purpose

This document defines non-negotiable rules for this project. These are outcomes we must achieve, not prescriptions for how to achieve them.

---

## Core Constraints

### 1. Tests Prove It Works

Every feature, bug fix, or behavior change should have tests that prove it works.

- If it's worth building, it's worth testing
- Tests should verify behavior, not implementation details
- Prefer integration tests that test real workflows

### 2. No Placeholders in Production

Code that gets committed should be complete, not placeholder.

- No TODO, FIXME, HACK, XXX left unaddressed
- No commented-out code blocks
- No stub functions that don't actually work
- No silent failures (errors caught but not handled)

### 3. Explicit Over Implicit

Make the code's behavior clear and obvious.

- Handle errors explicitly, don't swallow them
- Use clear naming that reveals intent
- Document non-obvious decisions
- Avoid magic numbers and strings

### 4. Quality Over Speed

It's better to ship less, done well, than more with issues.

- Don't cut corners on error handling
- Don't skip tests to meet deadlines
- Fix root causes, not symptoms

### 5. Changes Are Traceable

Every significant change should be traceable to a decision.

- Document why, not just what
- Link commits to plans or issues
- Keep decision log in plan files

---

## Development Process Constraints

### Planning Required for Non-Trivial Work

Before starting work that touches multiple files or takes more than a few minutes:
1. Create a plan in `.progress/`
2. Document options considered
3. Note trade-offs of chosen approach

### Verification Before Completion

Before marking work complete:
1. Run tests
2. Check for placeholders (`/no-cap`)
3. Verify alignment with these constraints
4. Update plan status

---

## Anti-Patterns (What NOT to Do)

| Anti-Pattern | Why It's Bad |
|--------------|--------------|
| "Works on my machine" | Ship tested, verified code |
| Quick hacks | They become permanent debt |
| Skipping tests | You'll regret it later |
| Copy-paste coding | Creates maintenance burden |
| Ignoring errors | Silent failures are the worst |

---

## Enforcement

These constraints are enforced through:
- Pre-commit hooks (check for placeholders, debug statements)
- CI pipeline (run tests, code review)
- `/no-cap` verification command
- Plan review before implementation

---

## Adding Project-Specific Constraints

Add your project's specific constraints below:

### [Your Constraint Name]

[Description of what must be true and why]

---

*Note: This document should be STABLE - change it rarely and deliberately.*
