# validate.ps1 — confirm this skill has scripts, references, and assets, each with a file.
# Does not apply deny, escalate, or an unfinished check.
[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$skillDir = Split-Path -Parent $PSScriptRoot
$skillName = Split-Path -Leaf $skillDir
$missing = New-Object System.Collections.Generic.List[string]
foreach ($name in @('scripts', 'references', 'assets')) {
    $dir = Join-Path $skillDir $name
    if (-not (Test-Path -LiteralPath $dir -PathType Container)) {
        $missing.Add($name)
        continue
    }
    $files = @(Get-ChildItem -LiteralPath $dir -Recurse -File -Force)
    if ($files.Count -lt 1) {
        $missing.Add($name)
    }
}
if ($missing.Count -gt 0) {
    [Console]::Error.WriteLine("Missing required folder in ${skillName}: $($missing -join ', ')")
    exit 1
}
Write-Output "OK required folders present: $skillName"
exit 0
