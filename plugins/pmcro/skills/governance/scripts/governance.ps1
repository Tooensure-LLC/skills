# governance.ps1 — stop on deny, an unresolved escalate, or a check that cannot finish.
# One trail line per stop. Any other result exits 0 and appends no block line.
# A shared Windows account cannot prove the maker did not write the verdict.
[CmdletBinding()]
param(
    [string]$Result = '',
    [string]$Trail = '',
    [switch]$Resolved
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Add-OneTrailLine {
    param(
        [Parameter(Mandatory = $true)]
        [string]$TrailPath,
        [Parameter(Mandatory = $true)]
        [string]$Reason
    )

    if ([string]::IsNullOrWhiteSpace($TrailPath)) {
        [Console]::Error.WriteLine('A block requires a trail path.')
        exit 1
    }

    if ($Reason -match '[A-Za-z]:') {
        [Console]::Error.WriteLine('Refusing a trail line that contains a drive letter.')
        exit 1
    }

    $line = '{"block":true,"reason":"' + $Reason + '"}'
    if ($line -match '[A-Za-z]:') {
        [Console]::Error.WriteLine('Refusing a trail line that contains a drive letter.')
        exit 1
    }

    $parent = Split-Path -Parent $TrailPath
    if (-not [string]::IsNullOrWhiteSpace($parent) -and -not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }

    $utf8 = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::AppendAllText($TrailPath, ($line + [Environment]::NewLine), $utf8)
}

$kind = $Result.Trim().ToLowerInvariant()

if ($kind -eq 'deny') {
    Add-OneTrailLine -TrailPath $Trail -Reason 'deny'
    exit 1
}

if ($kind -eq 'unresolved escalate' -or $kind -eq 'unresolved-escalate') {
    Add-OneTrailLine -TrailPath $Trail -Reason 'the approval is unresolved'
    exit 1
}

if ($kind -eq 'escalate') {
    if ($Resolved) {
        exit 0
    }
    Add-OneTrailLine -TrailPath $Trail -Reason 'the approval is unresolved'
    exit 1
}

if (
    $kind -eq 'unfinished' -or
    $kind -eq 'cannot-finish' -or
    $kind -eq 'check-did-not-finish' -or
    $kind -eq 'check that cannot finish' -or
    $kind -eq 'a check that cannot finish'
) {
    Add-OneTrailLine -TrailPath $Trail -Reason 'the check did not finish'
    exit 1
}

exit 0
