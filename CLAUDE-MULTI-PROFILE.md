# Claude Multi-Profile Setup

Setup for running multiple Claude instances with separate configurations (different accounts, memories, settings, MCP servers, etc.).

## Overview

| Alias | Config Dir | Use case |
|---|---|---|
| `claude` | `~/.claude` (default) | Personal profile |
| `claudep` | `~/.claude-private` | Private/alternate profile |

## How it works

Claude Code reads its configuration from the directory set in `CLAUDE_CONFIG_DIR`. By overriding this env var per alias, each alias gets a fully isolated environment: separate memory, settings, MCP servers, and permissions.

## Setup

### `~/.bashrc` or `~/.bash_profile`

```bash
alias claudep='CLAUDE_CONFIG_DIR=$HOME/.claude-private claude'
```

### Initialize the private profile

On first run, Claude will create the config directory automatically:

```bash
claudep
```

## What gets isolated

Each config directory maintains its own:
- `settings.json` — model, permissions, hooks, MCP servers
- `memory/` — persistent memory across conversations
- `projects/` — per-project Claude settings and memory
- `CLAUDE.md` — global instructions for that profile

## Workflow

**Personal tasks:**
```bash
claude
```

**Private/alternate profile:**
```bash
claudep
```

## Why this approach

- No wrapper scripts or complex tooling — just a shell alias
- Fully isolated: settings, memory, MCP servers, and permissions don't bleed between profiles
- Works in any terminal, any directory
