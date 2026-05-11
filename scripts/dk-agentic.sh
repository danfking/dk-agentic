#!/bin/bash
#
# Launch Claude Code with the dk-agentic plugin loaded.
#
# Usage:
#   # Add to your .bashrc / .zshrc:
#   source "/path/to/dk-agentic/scripts/dk-agentic.sh"
#
#   # Then in any repo that has the SessionStart hook set up:
#   dk-agentic
#

dk-agentic() {
    local PluginDir=".claude-plugins/dk-agentic"
    local PluginRepo="https://github.com/danfking/dk-agentic.git"

    if [ ! -d "$PluginDir" ]; then
        echo "dk-agentic: plugin not found, cloning..."
        mkdir -p "$(dirname "$PluginDir")"
        git clone --quiet "$PluginRepo" "$PluginDir" || {
            echo "dk-agentic: clone failed, running plain claude" >&2
            claude "$@"
            return
        }
    else
        # Pull latest in the background so startup stays snappy.
        (cd "$PluginDir" && git pull --quiet 2>/dev/null) &
    fi

    # Re-source self so launcher updates take effect.
    source "$PluginDir/scripts/dk-agentic.sh"
    _dk-agentic-impl "$@"
}

_dk-agentic-impl() {
    local PluginDir=".claude-plugins/dk-agentic"
    local sha
    sha=$(git -C "$PluginDir" rev-parse --short HEAD 2>/dev/null || echo "unknown")
    echo "dk-agentic plugin: ${sha}"
    claude --plugin-dir "$PluginDir" "$@"
}
