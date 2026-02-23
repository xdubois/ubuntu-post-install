# SSH Multi-Account Setup (GitHub / GitLab)

Setup for managing multiple SSH keys across different Git accounts, automatically selecting the right key based on the working directory.

## Overview

| Directory | SSH Key | Git Identity |
|---|---|---|
| `~/dev/work/` | work GitHub + work GitLab keys | work email |
| anything else | personal key | personal email |

## Directory Structure

```
~/dev/
├── work/        ← work repos (work keys applied automatically)
└── personal/    ← personal repos (default keys)
```

## SSH Keys

Generate one key per account/service combination:

```bash
ssh-keygen -t ed25519 -C "you@work.com" -f ~/.ssh/id_work_github
ssh-keygen -t ed25519 -C "you@work.com" -f ~/.ssh/id_work_gitlab
```

> Use `ed25519` over RSA — smaller, faster, more secure. RSA only if legacy systems require it.

## Files

### `~/.ssh/config`

Default host mappings (personal keys) + work aliases for cloning:

```ssh-config
# Personal (default)
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_personal
    IdentitiesOnly yes

Host gitlab.com
    HostName gitlab.com
    User git
    IdentityFile ~/.ssh/id_personal
    IdentitiesOnly yes

# Work aliases — used when cloning work repos
Host github-work
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_work_github
    IdentitiesOnly yes

Host gitlab-work
    HostName gitlab.com
    User git
    IdentityFile ~/.ssh/id_work_gitlab
    IdentitiesOnly yes
```

### `~/.ssh/config-work`

Dedicated SSH config for work, overrides host key selection for repos inside the work directory:

```ssh-config
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_work_github
    IdentitiesOnly yes

Host gitlab.com
    HostName gitlab.com
    User git
    IdentityFile ~/.ssh/id_work_gitlab
    IdentitiesOnly yes
```

### `~/.gitconfig`

```ini
[user]
    name = Your Name
    email = you@personal.com

[includeIf "gitdir:~/dev/work/"]
    path = ~/.gitconfig-work
```

### `~/.gitconfig-work`

```ini
[user]
    name = Your Name
    email = you@work.com
[core]
    sshCommand = ssh -F ~/.ssh/config-work
```

The `core.sshCommand` override points to the work SSH config, which maps both `github.com` and `gitlab.com` to the correct work keys — without changing any remote URLs.

## Workflow

**Cloning a work repo** — use the host alias so the right key is used before the `.git` dir exists:

```bash
git clone git@gitlab-work:org/repo.git ~/dev/work/repo
```

**Everything after clone** — automatic. The `includeIf` kicks in for any repo under `~/dev/work/` and applies the work SSH config transparently.

**Verify the active config** in any repo:

```bash
git config user.email
git config core.sshCommand
```

**Test SSH connection:**

```bash
ssh -T git@github.com
ssh -T git@gitlab.com
```

## Why this approach

- No need to change remote URLs (`git@github.com:...` works everywhere)
- Works correctly with **submodules** (host alias approach breaks submodules with hardcoded URLs)
- One-time setup, zero per-repo configuration
- Different keys for GitHub and GitLab on the same work account
