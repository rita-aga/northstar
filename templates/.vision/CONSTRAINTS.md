# Project Constraints

**Type:** STABLE
**Created:** [DATE]
**Last Updated:** [DATE]

---

## Purpose

This document defines non-negotiable rules for this project. These are outcomes we must achieve, not prescriptions for how to achieve them.

---

## Core Constraints

### 1. Simulation-First Development (MANDATORY)

Every feature MUST be developed and tested through the deterministic simulation harness BEFORE being considered complete.

**What Simulation-First IS:**
- Running the **full system** in a deterministic simulation harness
- Injecting faults (network failures, disk errors, timeouts, crashes, service unavailability)
- Stress testing (high concurrency, large data volumes, resource exhaustion)
- Storm testing (chaos scenarios, cascading failures)
- Finding bugs **before** production code is "done"
- Verifying determinism (same seed = same outcome, always)

**What Simulation-First is NOT:**
- Just adding unit tests (useful, but not the same)
- Creating mocks/fakes for testing (useful, but not the same)
- Integration tests against real services (useful, but not the same)
- "Good test coverage" (necessary, but not sufficient)

**The Rule:** If you cannot run `Simulation::run()` (or equivalent harness) with fault injection against your feature, you are not doing simulation-first development.

**Harness Extension Rule:** If the feature requires fault types the harness doesn't support:
1. **STOP** implementation work
2. **Extend the harness** to support those faults FIRST
3. **THEN** implement the feature
4. **THEN** test through simulation with fault injection

**The Simulation-First Workflow:**

```
┌─────────────────────────────────────────────────────────────────┐
│  1. HARNESS CHECK                                               │
│     Does the simulation harness support the faults this         │
│     feature will encounter? (network, disk, timeouts, etc.)     │
│                                                                 │
│     NO → Extend harness FIRST, then continue                    │
│     YES → Continue                                              │
├─────────────────────────────────────────────────────────────────┤
│  2. WRITE SIMULATION TEST                                       │
│     Write the DST test that exercises the feature under:        │
│     - Normal conditions                                         │
│     - Fault injection (e.g., 30% failure rate)                  │
│     - Stress/storm conditions (high concurrency)                │
│     - Edge cases (empty inputs, max sizes, etc.)                │
│                                                                 │
│     This test will FAIL initially (feature doesn't exist)       │
├─────────────────────────────────────────────────────────────────┤
│  3. IMPLEMENT FEATURE                                           │
│     Write the actual production code                            │
├─────────────────────────────────────────────────────────────────┤
│  4. RUN SIMULATION                                              │
│     Execute with multiple seeds, find failures                  │
│     The simulation WILL find bugs you didn't anticipate         │
├─────────────────────────────────────────────────────────────────┤
│  5. FIX & ITERATE                                               │
│     Fix bugs found by simulation                                │
│     Re-run until deterministically passing                      │
├─────────────────────────────────────────────────────────────────┤
│  6. VERIFY DETERMINISM                                          │
│     Same seed = same behavior, always                           │
└─────────────────────────────────────────────────────────────────┘
```

**Example - Right vs Wrong:**

```rust
// WRONG: Unit test with mocks (useful, but NOT simulation-first)
#[test]
fn test_remember_calls_embedder() {
    let mock = MockEmbedder::new();
    // ... unit test ...
}

// RIGHT: DST harness with fault injection (this IS simulation-first)
#[tokio::test]
async fn test_remember_with_embedding_faults() {
    let sim = Simulation::new(SimConfig::with_seed(42))
        .with_fault(FaultConfig::new(FaultType::EmbeddingTimeout, 0.3));

    sim.run(|env| async move {
        let memory = Memory::new(env.llm, env.embedder, env.storage);

        // Feature works EVEN when embeddings fail 30% of the time
        let result = memory.remember("test", Default::default()).await?;
        assert!(result.is_ok()); // Graceful degradation verified
        Ok(())
    }).await.unwrap();
}
```

**Enforcement Checklist:**
- [ ] Feature has DST test using simulation harness (`Simulation::run()` or equivalent)
- [ ] Test includes fault injection for relevant failure modes
- [ ] Test runs with multiple seeds
- [ ] Test verifies behavior under stress
- [ ] Same seed produces identical results (determinism verified)

---

### 2. Supplementary Testing (Encouraged)

Other forms of testing are valuable and encouraged as **supplements** to simulation-first:

- **Unit tests** - Fast, focused tests for individual functions/modules
- **Mocks/fakes** - Useful for isolating components in unit tests
- **Integration tests** - Test real workflows with actual services
- **Property-based tests** - Discover edge cases through randomized inputs
- **End-to-end tests** - Verify complete user journeys

These forms of testing provide value and should be used where appropriate. They are **not replacements** for simulation-first - they are **complements** to it.

**The Testing Hierarchy:**
1. **Simulation-first (mandatory)** - Full system, fault injection, deterministic
2. **Integration tests (encouraged)** - Real workflows, real services
3. **Unit tests (encouraged)** - Fast feedback, isolated components
4. **E2E tests (encouraged)** - Complete user journeys

### 3. No Placeholders in Production

Code that gets committed should be complete, not placeholder.

- No TODO, FIXME, HACK, XXX left unaddressed
- No commented-out code blocks
- No stub functions that don't actually work
- No silent failures (errors caught but not handled)

### 4. Explicit Over Implicit

Make the code's behavior clear and obvious.

- Handle errors explicitly, don't swallow them
- Use clear naming that reveals intent
- Document non-obvious decisions
- Avoid magic numbers and strings

### 5. Quality Over Speed

It's better to ship less, done well, than more with issues.

- Don't cut corners on error handling
- Don't skip tests to meet deadlines
- Fix root causes, not symptoms

### 6. Changes Are Traceable

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
