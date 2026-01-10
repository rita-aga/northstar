# Architecture

**Type:** EVOLVING
**Created:** [DATE]
**Last Updated:** [DATE]
**Staleness Check:** Review if >30 days since last update

---

## System Overview

*One paragraph describing what this system does and how it's structured.*

[High-level description of the system]

---

## Components

*What are the major pieces and what does each do?*

| Component | Purpose | Technology |
|-----------|---------|------------|
| [Name] | [What it does] | [Stack/language] |
| [Name] | [What it does] | [Stack/language] |
| [Name] | [What it does] | [Stack/language] |

---

## Component Diagram

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│             │────▶│             │────▶│             │
│  [Name]     │     │  [Name]     │     │  [Name]     │
│             │◀────│             │◀────│             │
└─────────────┘     └─────────────┘     └─────────────┘
        │                   │                   │
        ▼                   ▼                   ▼
┌─────────────────────────────────────────────────────┐
│                     [Data Layer]                     │
└─────────────────────────────────────────────────────┘
```

*Replace with actual architecture diagram*

---

## Data Flow

*How does data move through the system?*

1. [User/trigger] initiates [action]
2. [Component A] receives and [processes]
3. [Component B] transforms/stores
4. [Result] returned to [destination]

---

## Key Decisions

*Why is the architecture shaped this way?*

### Decision 1: [Title]

**Context:** [What problem were we solving?]

**Decision:** [What we chose]

**Rationale:** [Why this approach]

**Trade-offs:** [What we gave up]

### Decision 2: [Title]

**Context:** [What problem were we solving?]

**Decision:** [What we chose]

**Rationale:** [Why this approach]

**Trade-offs:** [What we gave up]

---

## Boundaries

*What does each component own? What crosses boundaries?*

| Component | Owns | Does NOT Own |
|-----------|------|--------------|
| [Name] | [Responsibilities] | [What others handle] |
| [Name] | [Responsibilities] | [What others handle] |

---

## External Dependencies

*What external services or systems do we depend on?*

| Dependency | Purpose | Criticality |
|------------|---------|-------------|
| [Service/API] | [Why we need it] | [Critical/Important/Nice-to-have] |
| [Database] | [Why we need it] | [Critical/Important/Nice-to-have] |

---

## Deployment

*How is this system deployed and run?*

- **Environment:** [Local/Cloud/Hybrid]
- **Orchestration:** [Docker/K8s/Serverless/etc.]
- **Key services:** [What runs where]

---

## Evolution Notes

*How has this architecture changed? What might change next?*

| Date | Change | Reason |
|------|--------|--------|
| [DATE] | [What changed] | [Why] |

---

*This document should be updated as architecture evolves. Check staleness monthly.*
