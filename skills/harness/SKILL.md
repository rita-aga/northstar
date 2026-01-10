---
name: harness
description: TigerStyle development workflow harness. Wraps development tasks in a state machine (GROUNDING → PLANNING → IMPLEMENTING → VERIFYING → COMPLETE) with vision alignment, decision logging, and verification. Use when starting non-trivial coding tasks. Adapts to whatever vision files exist in the project.
---

# TigerStyle Development Harness

A workflow wrapper for disciplined development. Inspired by TigerBeetle's TigerStyle and FoundationDB's simulation-first approach.

## State Machine

```
GROUNDING → PLANNING → IMPLEMENTING → VERIFYING → COMPLETE
                           ↓              ↓
                       BLOCKED ←──────────┘
```

## Automatic Actions by State

### On Invocation (GROUNDING)

1. **Check for `.vision/` directory**
   - If exists: Read whatever files are there
   - If missing: Offer to help create relevant vision docs (interview user)

2. **For any EVOLVING docs found** (have `Last Updated` date):
   - If > 30 days old, ask user if it needs updating

3. **Read recent plans** in `.progress/` to understand current state

4. **Summarize relevant guidance** for this task

### On Plan Creation (PLANNING)

1. **Create plan file**: `.progress/YYYYMMDD_HHMMSS_task-name.md`
2. **Document what vision files were read** (or note none exist)
3. **Define test requirements** if applicable
4. **Get approval** (or auto-proceed for small tasks)

### During Work (IMPLEMENTING)

1. **Log significant decisions** to plan file
2. **Track what tests are needed**
3. **Update plan after each phase**

### Before Completion (VERIFYING)

1. **Run tests** if project has them
2. **Run `/no-cap`** verification
3. **Check alignment** with any documented constraints
4. **BLOCK if gates fail**

### On Completion (COMPLETE)

1. **Update plan state** to COMPLETE
2. **Commit** with clear message
3. **Push** to remote

## Gate Requirements

| State | Gate to Exit |
|-------|--------------|
| GROUNDING | Read whatever `.vision/` files exist (or acknowledge none) |
| PLANNING | Plan file exists in `.progress/` |
| IMPLEMENTING | Planned work done |
| VERIFYING | Tests pass (if applicable) + /no-cap pass |
| COMPLETE | Committed |

## Plan File Template

Use `.progress/templates/plan.md` or create with key sections:

```markdown
# Task: [Name]
**Created:** YYYY-MM-DD HH:MM:SS
**State:** GROUNDING | PLANNING | IMPLEMENTING | VERIFYING | COMPLETE

## Vision Alignment
**Vision files read:** [list files or "None"]
**Relevant guidance:** [constraints that apply]

## Options & Decisions
[Document options considered, trade-offs, decisions made]

## Checkpoints
- [ ] Plan approved
- [ ] Implemented
- [ ] Tests passing (if applicable)
- [ ] /no-cap passed
```

## What This Harness Enforces (OUTCOMES)

| Outcome | How |
|---------|-----|
| Decisions are traceable | Decision log in plan |
| No placeholders left | /no-cap verification |
| Alignment with project vision | Read whatever vision docs exist |
| Quality over speed | State machine prevents rushing |

## What This Harness Does NOT Prescribe

| Flexible | Why |
|----------|-----|
| Which vision files must exist | Projects vary - use what's there |
| Testing framework | Agent chooses appropriate tools |
| Code patterns | Style is agent's choice |
| Plan detail level | Proportional to task size |

## Offering to Create Vision Docs

If `.vision/` doesn't exist or seems incomplete, offer options:

> "I don't see vision docs for this project. Would you like me to help create any of these?"
> - **CONSTRAINTS.md** - Non-negotiable rules for this project
> - **ARCHITECTURE.md** - System design decisions
> - **PHILOSOPHY.md** - Design principles
> - **[Custom]** - Something specific to your domain
>
> Or we can proceed without them if this is a small task.

**Don't assume all files are needed.** Ask what would be helpful.

## Quick Reference

```
/harness                    # Start workflow
GROUNDING                   # Read vision (whatever exists), understand context
PLANNING                    # Create .progress/ plan, document decisions
IMPLEMENTING                # Do the work, log decisions
VERIFYING                   # Tests, /no-cap, alignment check
COMPLETE                    # Commit and push
```
