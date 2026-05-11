<#
.SYNOPSIS
    Launch Claude Code with the dk-agentic plugin loaded.

.DESCRIPTION
    Source this script into your PowerShell profile, then run dk-agentic
    in any repo whose .claude/settings.json clones the plugin on SessionStart.

.EXAMPLE
    . "C:\Home\Projects\dk-agentic\scripts\dk-agentic.ps1"
    dk-agentic
#>

function dk-agentic {
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    $PluginDir = ".claude-plugins\dk-agentic"
    $PluginRepo = "https://github.com/danfking/dk-agentic.git"

    if (-not (Test-Path $PluginDir)) {
        Write-Host "dk-agentic: plugin not found, cloning..." -ForegroundColor Yellow
        $parent = Split-Path $PluginDir -Parent
        if (-not (Test-Path $parent)) {
            New-Item -ItemType Directory -Path $parent -Force | Out-Null
        }
        git clone --quiet $PluginRepo $PluginDir
        if ($LASTEXITCODE -ne 0) {
            Write-Host "dk-agentic: clone failed, running plain claude" -ForegroundColor Red
            claude @Arguments
            return
        }
    }
    else {
        # Pull latest. Quiet, non-blocking-ish.
        Push-Location $PluginDir
        git pull --quiet 2>$null
        Pop-Location
    }

    # Re-source self so launcher updates take effect.
    . "$PluginDir\scripts\dk-agentic.ps1"
    _dk-agentic-impl @Arguments
}

function _dk-agentic-impl {
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    $PluginDir = ".claude-plugins\dk-agentic"
    $sha = git -C $PluginDir rev-parse --short HEAD 2>$null
    if (-not $sha) { $sha = "unknown" }
    Write-Host "dk-agentic plugin: $sha" -ForegroundColor DarkGray
    claude --plugin-dir $PluginDir @Arguments
}
