---
name: governance
description: "Stop the maker or the checker on deny, an unresolved escalate, or a check that cannot finish. USE FOR: a non-zero exit plus one trail line, scripts/governance.ps1, and the record that a shared Windows account cannot prove the maker did not write the verdict. DO NOT USE FOR: installing the Agent Governance Toolkit, editing the Laws section, editing check/SKILL.md or reflect/SKILL.md, writing the check verdict, catalog registration, or running an approved plan."
license: MIT
---

# governance

Regulate the maker and the checker with one internal stop. The Agent Governance Toolkit stays uninstalled. A shared Windows account cannot prove the maker did not write the verdict. That limit is recorded in `references/limit.md`.

Run `scripts/governance.ps1` for the procedure. SKILL.md stays short and names the script.

```powershell
pwsh -NoProfile -File scripts/governance.ps1 -Result deny -Trail skills/trails/example/block.jsonl
pwsh -NoProfile -File scripts/governance.ps1 -Result escalate -Trail skills/trails/example/block.jsonl
pwsh -NoProfile -File scripts/governance.ps1 -Result unfinished -Trail skills/trails/example/block.jsonl
pwsh -NoProfile -File scripts/governance.ps1 -Result allow -Trail skills/trails/example/block.jsonl
```

## When to Use

- A deny must stop the action
- An escalate has no resolved approval
- A check cannot finish

## When Not to Use

- Installing the Agent Governance Toolkit
- Editing the Laws section, `check/SKILL.md`, or `reflect/SKILL.md`
- Writing the check verdict, which the check skill owns
- Registering a marketplace catalog
- Running an approved plan, which the make skill owns

## Inputs

| Input | Required | Description |
| --- | --- | --- |
| Result | Yes | `deny`, `escalate`, `unfinished`, or any other result such as `allow` |
| Trail | Yes for a stop | Relative path that receives one trail line |
| Resolved | No | With `escalate`, the approval is resolved and the script exits 0 |

## Workflow

### Step 1: Read the limit

Read `references/limit.md`. A shared Windows account cannot prove the maker did not write the verdict.

### Step 2: Run the script

Run `scripts/governance.ps1`.

- `-Result deny` exits non-zero and appends one trail line.
- `-Result escalate` without `-Resolved` exits non-zero and appends one trail line that says the approval is unresolved.
- `-Result unfinished` exits non-zero and appends one trail line that says the check did not finish.
- Any other result exits 0 and appends no block line.

`scripts/validate.ps1` only checks that `scripts/`, `references/`, and `assets/` each contain a file. It does not apply deny, escalate, or an unfinished check.

## Validation

- [ ] `scripts/governance.ps1` is the script this file names
- [ ] Deny, an unresolved escalate, and a check that cannot finish each exit non-zero and append one trail line
- [ ] Any other result exits 0 and appends no block line
- [ ] `references/limit.md` records the shared-account limit
- [ ] Validation fails if `scripts/`, `references/`, or `assets/` is missing

## Common Pitfalls

| Pitfall | Solution |
| --- | --- |
| Shared-account authorship | Keep the sentence in `references/limit.md`. A shared Windows account cannot prove the maker did not write the verdict. |
| Toolkit install | Leave the Agent Governance Toolkit uninstalled. |
| Laws, check, or reflect edit | Leave those files as written. |
| Drive letter in a trail line | The block line carries the reason only. |
| Releasing an unresolved escalate | Exit non-zero and append one line that says the approval is unresolved. |
| Releasing a check that cannot finish | Exit non-zero and append one line that says the check did not finish. |
