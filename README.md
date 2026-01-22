# Proposal Execution Contract

A contract that executes governance-approved proposals, acting as the bridge
between voting outcomes and protocol state changes.

## Key Functions
- `queue-proposal` — Register an approved proposal for execution
- `execute-proposal` — Trigger proposal actions after approval
- `cancel-proposal` — Abort a queued proposal before execution
- `get-proposal` — Retrieve execution metadata and status
- `is-executed` — Check whether a proposal has been executed

Designed for DAOs, protocol upgrades, treasury actions, and automated governance workflows.
