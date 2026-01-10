# User Experience

**Type:** STABLE
**Created:** [DATE]
**Last Updated:** [DATE]

---

## Experience Principles

*How should it feel to use this? These apply whether it's a CLI, API, or UI.*

### 1. [Principle Name]

[Description of this principle - what it means in practice]

**Do:** [Example of following this principle]
**Don't:** [Example of violating this principle]

### 2. [Principle Name]

[Description of this principle]

**Do:** [Example]
**Don't:** [Example]

### 3. [Principle Name]

[Description of this principle]

**Do:** [Example]
**Don't:** [Example]

---

## Interface Type

*What kind of interface does this project have?*

- [ ] **CLI** - Command-line interface
- [ ] **API** - Developer-facing programmatic interface
- [ ] **Web UI** - Browser-based interface
- [ ] **Desktop App** - Native desktop application
- [ ] **Mobile App** - Native mobile application
- [ ] **Library/SDK** - Code that developers integrate
- [ ] **Other:** [Describe]

---

## For CLI Projects

### Command Philosophy

- Commands should be [discoverable/memorable/composable]
- Output should be [human-readable/machine-parseable/both]
- Errors should [guide to solution/be specific/suggest next steps]

### Example Interaction

```bash
$ [example command]
[example output]

$ [example error case]
[example error message with helpful guidance]
```

---

## For API Projects

### Developer Experience

- API should be [RESTful/GraphQL/RPC-style]
- Responses should be [consistent/predictable/well-documented]
- Errors should [include codes/be actionable/suggest fixes]

### Example Request/Response

```
[HTTP method] /example/endpoint
{
  "field": "value"
}

Response:
{
  "result": "value"
}
```

---

## For UI Projects

### Visual Design Principles

- **Aesthetic:** [Minimal/Rich/Playful/Professional/etc.]
- **Color Palette:** [Description or specific colors]
- **Typography:** [Description - readable/expressive/etc.]
- **Density:** [Spacious/Compact/Adaptive]

### Interaction Patterns

- **Navigation:** [How users move around]
- **Feedback:** [How system responds to actions]
- **Loading:** [How waiting states are handled]
- **Errors:** [How problems are communicated]

---

## Anti-Patterns

*What should we explicitly avoid?*

| Anti-Pattern | Why It's Bad | Instead Do |
|--------------|--------------|------------|
| [Bad pattern] | [Why it hurts UX] | [Better approach] |
| [Bad pattern] | [Why it hurts UX] | [Better approach] |
| [Bad pattern] | [Why it hurts UX] | [Better approach] |

---

## Accessibility

*How do we ensure this is usable by everyone?*

- [ ] [Accessibility consideration 1]
- [ ] [Accessibility consideration 2]
- [ ] [Accessibility consideration 3]

---

## Performance Expectations

*How fast should things feel?*

| Action | Expected Response Time |
|--------|----------------------|
| [Common action] | [Target time] |
| [Another action] | [Target time] |

---

## Example User Journeys

### Journey 1: [Name]

1. User wants to [goal]
2. They [action]
3. System [response]
4. User [next action]
5. Outcome: [result]

---

*This document defines how the product should feel. These are outcomes, not prescriptions for specific implementations.*
