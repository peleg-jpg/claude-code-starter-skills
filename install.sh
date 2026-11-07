#!/usr/bin/env bash
# Installs the starter skills into ~/.claude/skills and the 4 official plugins.
set -e
cd "$(dirname "$0")"
DEST="$HOME/.claude/skills"
mkdir -p "$DEST"
for dir in skills/*/; do
  name=$(basename "$dir")
  if [ -e "$DEST/$name" ]; then
    mv "$DEST/$name" "$DEST/$name.backup-$(date +%Y%m%d%H%M%S)"
    echo "backed up existing $name"
  fi
  cp -R "$dir" "$DEST/$name"
  echo "installed skill: $name"
done

PLUGINS="superpowers skill-creator claude-md-management frontend-design"
if command -v claude >/dev/null 2>&1; then
  claude plugin marketplace add anthropics/claude-plugins-official >/dev/null 2>&1 || true
  claude plugin marketplace update claude-plugins-official >/dev/null 2>&1 || true
  for p in $PLUGINS; do
    if claude plugin install "$p@claude-plugins-official" 2>&1 | grep -q "Successfully"; then
      echo "installed plugin: $p"
    else
      echo "plugin $p failed. Inside Claude Code run: /plugin install $p@claude-plugins-official"
    fi
  done
else
  echo "claude CLI not found. Inside Claude Code run:"
  echo "  /plugin marketplace add anthropics/claude-plugins-official"
  for p in $PLUGINS; do echo "  /plugin install $p@claude-plugins-official"; done
fi
echo "Done. Restart Claude Code."
