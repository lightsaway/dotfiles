# dotfiles

Cross-platform development environment managed with **Nix** (primary) and **Homebrew** (macOS GUI apps). Supports **macOS** (Apple Silicon) and **Linux** (x86_64 / aarch64).

## Quick Start

### New Machine (Nix - recommended)

```bash
# Clone the repo
git clone https://github.com/atoshi/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Run the bootstrap script (installs Nix, builds everything)
./bootstrap.sh
```

This single command will:
1. Install Nix via the [Determinate Systems installer](https://github.com/DeterminateSystems/nix-installer)
2. Detect your OS (macOS or Linux)
3. Build and activate the full configuration

On **macOS**, it uses [nix-darwin](https://github.com/LnL7/nix-darwin) + [home-manager](https://github.com/nix-community/home-manager), which also manages Homebrew casks declaratively.

On **Linux**, it uses standalone home-manager.

### Legacy Install (Homebrew only, macOS)

If you prefer the traditional approach without Nix:

```bash
git clone https://github.com/atoshi/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./legacy/install.sh
```

This installs Homebrew packages from `.brewfile`, symlinks configs, and sets up oh-my-zsh.

### Updating

```bash
cd ~/.dotfiles
make update         # Update brew packages + vim plugins + cleanup
make nix-switch     # Rebuild Nix config (macOS)
```

### Makefile Commands

```
make help             Show all commands
make install          Run legacy installer (Homebrew path)
make bootstrap        Run Nix bootstrap (new machines)
make update           Update everything (brew + vim plugins)
make brew-sync        Install/upgrade from .brewfile
make brew-cleanup     Remove packages not in .brewfile
make brew-diff        Dry run — show what would be removed
make brew-outdated    Show outdated packages
make nix-switch       Rebuild Nix config (macOS)
make nix-switch-linux Rebuild Nix config (Linux)
make nix-update       Update Nix flake inputs
make nix-gc           Garbage collect old Nix generations
make vim-plugins      Sync vim plugins
make omz-update       Update oh-my-zsh + plugins
make clean            Full cleanup (brew + nix gc)
```

---

## Repository Structure

```
~/.dotfiles/
|
|-- flake.nix                    # Nix flake entry point
|-- bootstrap.sh                 # Cross-platform setup script (Nix)
|-- .brewfile                    # Homebrew packages (macOS)
|
|-- nix/
|   |-- home/
|   |   |-- common.nix          # Shared packages & program configs
|   |   |-- darwin.nix           # macOS-specific home-manager
|   |   |-- linux.nix            # Linux-specific home-manager
|   |-- hosts/
|   |   |-- darwin.nix           # nix-darwin system config + Homebrew casks
|   |-- overlays/
|       |-- default.nix          # Custom Nix package overlays
|
|-- shell/
|   |-- env.sh                   # Consolidated PATH & environment variables
|   |-- aliases/
|   |   |-- common.sh            # Cross-platform aliases
|   |   |-- darwin.sh            # macOS-only aliases
|   |   |-- linux.sh             # Linux-only aliases
|   |-- functions/
|       |-- common.sh            # Cross-platform shell functions
|       |-- darwin.sh            # macOS-only functions (Finder, osascript)
|
|-- terminals/
|   |-- ghostty/config           # Ghostty terminal emulator config
|   |-- tmux/tmux.conf           # Tmux multiplexer config
|   |-- zellij/config.kdl        # Zellij multiplexer config
|
|-- git/config                   # Git configuration (aliases, colors, urls)
|-- vim/vimrc                    # Vim configuration (vim-plug, plugins, theme)
|-- vscode/settings.json         # VSCode settings
|-- iterm2/                      # iTerm2 exported preferences
|-- mac/                         # macOS defaults & keyboard shortcuts
|-- predef.sc                    # Ammonite (Scala) REPL prelude
|-- cargo_packages               # Rust packages to install via cargo
|
|-- .zshrc                       # Zsh config (entrypoint, sources shell/env.sh)
|-- .bash_profile                # Bash config (entrypoint, sources .profile)
|-- .profile                     # Shared profile (entrypoint, sources shell/env.sh)
|
|-- legacy/
|   |-- install.sh               # Legacy setup script (Homebrew + symlinks)
|   |-- .aliases                 # Old aliases (replaced by shell/aliases/)
|   |-- .functions               # Old functions (replaced by shell/functions/)
|   |-- .env_default             # Old env vars (replaced by shell/env.sh)
|   |-- .gitconfig               # Old git config (replaced by git/config)
|   |-- .vimrc                   # Old vim config (replaced by vim/vimrc)
```

### Legacy vs New Files

The root-level dotfiles (`.zshrc`, `.aliases`, `.functions`, etc.) are the **legacy** versions kept for backward compatibility with `install.sh`. The **new** versions live in `shell/`, `git/`, `vim/`, and `terminals/`. When using Nix, home-manager generates configs from `nix/home/common.nix` and sources the `shell/` files automatically.

---

## What's Included

### Packages

Managed declaratively through Nix (`nix/home/common.nix`) or Homebrew (`.brewfile`).

| Category | Tools |
|---|---|
| **Core utils** | coreutils, findutils, gnu-tar, gnu-sed, moreutils, grep |
| **Search** | ripgrep, fzf, fd, tree, autojump (transitioning to zoxide) |
| **Git** | git, git-crypt, git-lfs, git-extras, tig, gh, lazygit, delta |
| **Shell** | zsh + oh-my-zsh, bash, thefuck, direnv, atuin (history) |
| **Modern CLI** | eza (ls), bat (cat), dust (du), duf (df), btop (top), tldr, curlie |
| **Languages** | go, python3/uv, rust/rustup, zig, bun, scala/sbt/maven/ammonite, jenv, nvm |
| **Cloud/Infra** | awscli, terraform (tfenv), helm, kustomize, kubectl |
| **Data** | jq, yq, postgresql, mysql-client, librdkafka |
| **Media** | ffmpeg, flac, imagemagick |
| **Network** | wget, gnupg, nmap, socat, mkcert, openssh |
| **AI** | aichat |

### Terminal Emulators

Both are included as macOS casks. Choose whichever you prefer:

| Terminal | Config Location | Highlights |
|---|---|---|
| **Ghostty** | `terminals/ghostty/config` | GPU-accelerated, native macOS tabs, built-in splits, quick terminal on `` Cmd+` `` |
| **iTerm2** | `iterm2/com.googlecode.iterm2.plist` | Mature, feature-rich, extensive customization |

### Terminal Multiplexers

Both are installed and configured. Use either depending on your preference:

| Multiplexer | Config Location | Style | Best For |
|---|---|---|---|
| **Tmux** | `terminals/tmux/tmux.conf` | Prefix-based (`Ctrl-a`) | Remote servers, established workflows, plugin ecosystem |
| **Zellij** | `terminals/zellij/config.kdl` | Direct keys (`Alt+key`) | Modern UX, session persistence, no prefix needed |

#### Tmux Keybindings

All keybindings use the `Ctrl-a` prefix (instead of the default `Ctrl-b`).

| Action | Keys |
|---|---|
| Split horizontal | `Ctrl-a` then `\|` |
| Split vertical | `Ctrl-a` then `-` |
| Navigate panes | `Ctrl-a` then `h/j/k/l` |
| Resize panes | `Ctrl-a` then `H/J/K/L` |
| Next/prev window | `Shift+Right` / `Shift+Left` |
| New window | `Ctrl-a` then `c` |
| Reload config | `Ctrl-a` then `r` |
| Copy mode (vim) | `Ctrl-a` then `[`, select with `v`, yank with `y` |

#### Zellij Keybindings

No prefix needed - all keys use `Alt` modifier directly.

| Action | Keys |
|---|---|
| Split right | `Alt+\|` |
| Split down | `Alt+-` |
| Navigate panes | `Alt+h/j/k/l` |
| Resize panes | `Alt+H/J/K/L` |
| New tab | `Alt+t` |
| Switch tabs | `Alt+1-5` or `Alt+[/]` |
| Close pane | `Alt+w` |
| Fullscreen | `Alt+f` |
| Floating pane | `Alt+F` |
| Scroll mode | `Alt+s` (then `j/k/d/u` to scroll) |
| Detach | `Alt+d` |

### Shell

**Zsh** with oh-my-zsh is the primary shell. Prompt is powered by [Starship](https://starship.rs/).

#### Starship Prompt

Config: `terminals/starship.toml`

The prompt shows contextual info only when relevant:

```
~/projects/myapp  main !2+1 ?3  18.x  3.12  5s
❯
                                                                    14:30
```

- **Directory** — truncated to repo root, with icons for known folders
- **Git** — branch, dirty state (`!` modified, `+` staged, `?` untracked), ahead/behind
- **Languages** — version shown only when detected (Scala, Java, Node, TypeScript, Python, Go, Rust, Zig)
- **Infra** — Docker context, Kubernetes cluster/namespace, Terraform workspace, Nix shell, AWS profile
- **Duration** — command execution time (shown if >3s)
- **Time** — clock in right prompt
- **Prompt char** — `❯` (magenta on success, red on failure, `❮` green in vim mode)

#### Shell Configuration

- `shell/env.sh` - Central entry point. Sets up XDG directories, PATH, and sources the right alias/function files based on `uname -s`.
- `shell/aliases/common.sh` - Navigation (`..`, `...`), modern ls via eza, colored grep, git/kubectl shortcuts, audio processing.
- `shell/aliases/darwin.sh` - macOS-specific: `flush` (DNS), `show`/`hide` (Finder), `afk` (lock screen), `emptytrash`, Chrome/Sublime/VSCode launchers.
- `shell/aliases/linux.sh` - Linux equivalents: `open` (xdg-open), `pbcopy`/`pbpaste` (xclip), `flush` (systemd-resolve), `afk` (loginctl).
- `shell/functions/common.sh` - `mkd`, `targz`, `fs`, `server` (python3 HTTP), `json`, `gz`, `digga`, `getcertnames`, `tre`, Kafka helpers.
- `shell/functions/darwin.sh` - `cdf` (cd to Finder window), `s` (open in Sublime), `o` (open in Finder).

**Oh-my-zsh plugins**: git, kubectl, docker, dotenv, docker-compose, tmux.

**Additional integrations**: thefuck (command correction), atuin (searchable shell history), zoxide (smart cd), direnv (per-directory env), fzf (fuzzy finder).

### Git

Configured declaratively in `nix/home/common.nix` under `programs.git`. Key features:

- **Delta** as the pager (side-by-side diffs with syntax highlighting)
- **20+ aliases** - `git l` (log graph), `git s` (short status), `git d` (diff with stat), `git go <branch>` (checkout or create), `git ca` (add all + commit), `git dm` (delete merged branches), `git pushall` (push to all remotes)
- **URL shorthands** - `gh:user/repo` expands to `git@github.com:user/repo`
- **Auto-correct** enabled for typos
- **LFS** enabled
- **Conditional config** - separate `.gitconfig-originlines` for work repos matching `~/**/originlines/**`

### Vim

Configured with [vim-plug](https://github.com/junegunn/vim-plug). Theme: **Catppuccin Mocha**. Leader key: `,`.

Plugins are auto-installed on first launch. Run `:PlugInstall` if you add new ones.

**Plugins:**

| Plugin | Purpose |
|---|---|
| **fzf.vim** | Fuzzy finder for files, buffers, grep, git |
| **NERDTree** | File explorer sidebar |
| **vim-fugitive** | Git integration (`:Git`, `:Gdiffsplit`, `:Git blame`) |
| **vim-gitgutter** | Show git diff in sign column |
| **vim-surround** | Change surrounding quotes/brackets (`cs"'`, `ysiw)`) |
| **vim-commentary** | Toggle comments (`gcc` line, `gc` selection) |
| **vim-visual-multi** | Multiple cursors (`Ctrl-n`) |
| **auto-pairs** | Auto-close brackets and quotes |
| **lightline** | Status line with git branch |
| **coc.nvim** | LSP client - autocomplete, go-to-def, diagnostics, hover, rename |
| **vim-go** | Go development (goimports, highlights) |
| **rust.vim** | Rust development (auto rustfmt on save) |
| **vim-scala** | Scala syntax |
| **typescript-vim** | TypeScript/TSX syntax and highlighting |
| **zig.vim** | Zig syntax |

**Keybindings (Leader = `,`):**

| Keys | Action |
|---|---|
| `,f` | Find files (FZF) |
| `,r` | Ripgrep search across files |
| `,b` | Switch buffer |
| `,/` | Search current buffer lines |
| `,h` | File history |
| `K` | Grep word under cursor |
| `,n` | Toggle NERDTree |
| `,j` | Reveal current file in NERDTree |
| `,w` | Save file |
| `,q` | Close buffer |
| `,<space>` | Clear search highlight |
| `Ctrl+h/j/k/l` | Navigate splits |
| `Shift+h/l` | Previous/next buffer |
| `jj` | Escape (insert mode) |
| `Space` | Enter command mode |
| `,gg` | Git status |
| `,gd` | Git diff split |
| `,gl` | Git log |
| `,gb` | Git blame |
| `,ga` | Stage hunk |
| `,gu` | Undo hunk |
| `,gp` | Preview hunk |
| `]g` / `[g` | Next/previous git hunk |
| **LSP (CoC)** | |
| `gd` | Go to definition |
| `gy` | Go to type definition |
| `gi` | Go to implementation |
| `gr` | Find references |
| `K` | Hover documentation |
| `,rn` | Rename symbol |
| `,ca` | Code actions |
| `,cf` | Quick fix |
| `,F` | Format file/selection |
| `[d` / `]d` | Previous/next diagnostic |
| `,d` | List all diagnostics |
| `,o` | Outline (symbols in file) |
| `,s` | Search workspace symbols |
| `Tab` / `Shift+Tab` | Navigate completion menu |
| `Enter` | Confirm completion |
| `Ctrl+Space` | Trigger completion manually |

**LSP languages (auto-installed via CoC extensions):**
- **TypeScript/JavaScript** — `coc-tsserver` (auto-imports, refactoring, diagnostics)
- **Scala** — `coc-metals` (Metals LSP, worksheet support, implicit hints)
- **Go** — `coc-go` (gopls)
- **Rust** — `coc-rust-analyzer` (clippy on save)
- **Python** — `coc-pyright`
- **JSON/HTML/CSS** — schema validation, completions

**Features:**
- Relative line numbers, persistent undo, system clipboard integration
- ripgrep as grep backend, smart case search
- Auto-strip trailing whitespace on save
- 4-space indent default, 2-space for JS/TS/JSON/YAML/HTML/CSS/Nix
- Auto-close NERDTree when it's the last window
- Cursor shape changes per mode (block/line/underline)

---

## Nix Architecture

```
flake.nix
  |
  |-- darwinConfigurations."atoshi-mac"     (macOS)
  |     |-- nix/hosts/darwin.nix            System config, macOS defaults, Homebrew casks
  |     |-- nix/home/common.nix             Shared packages & programs
  |     |-- nix/home/darwin.nix             macOS-specific home config
  |
  |-- homeConfigurations."atoshi-linux"     (Linux x86_64)
  |     |-- nix/home/common.nix             Shared packages & programs
  |     |-- nix/home/linux.nix              Linux-specific (xclip, xdg-utils)
  |
  |-- homeConfigurations."atoshi-linux-arm" (Linux aarch64)
        |-- nix/home/common.nix
        |-- nix/home/linux.nix
```

### How Nix and Homebrew Coexist

- **Nix** manages all cross-platform CLI tools. These work identically on macOS and Linux.
- **Homebrew** (via nix-darwin) manages macOS GUI apps (casks), JVM tooling (sbt/scala/maven), version managers (pyenv/jenv/nvm/tfenv), and a few macOS-specific formulae.
- Both are declared in code. Running `darwin-rebuild switch` updates everything: Nix packages, Homebrew formulae, casks, macOS system defaults, and dotfile symlinks.

### Adding a New Package

#### Step 1: Find the package name

Nix package names don't always match brew names. Search for the right name:

```bash
# Search by name
nix search nixpkgs redis
nix search nixpkgs nodejs

# Or browse https://search.nixos.org/packages
```

The output shows the attribute name (e.g., `legacyPackages.x86_64-linux.redis`) — the part after the last dot is what you use (`redis`).

#### Step 2: Decide where it goes

| What | Where to add | File |
|---|---|---|
| CLI tool (cross-platform) | `home.packages` | `nix/home/common.nix` |
| CLI tool (macOS only) | `home.packages` | `nix/home/darwin.nix` |
| CLI tool (Linux only) | `home.packages` | `nix/home/linux.nix` |
| macOS brew formula | `homebrew.brews` | `nix/hosts/darwin.nix` |
| macOS GUI app (cask) | `homebrew.casks` | `nix/hosts/darwin.nix` |
| Tool with its own config | `programs.<name>` | `nix/home/common.nix` |

#### Step 3: Add it

**Cross-platform CLI tool** — add to the `home.packages` list:

```nix
# nix/home/common.nix
home.packages = with pkgs; [
  # ... existing packages ...
  redis       # <-- just add the package name
  mongosh
];
```

**Tool with home-manager integration** — some tools have dedicated config modules (check [home-manager options](https://nix-community.github.io/home-manager/options.xhtml)):

```nix
# nix/home/common.nix
programs.tmux = {
  enable = true;       # Installs the package AND manages its config
  extraConfig = "...";
};
```

Common `programs.*` modules: git, zsh, fzf, bat, eza, direnv, atuin, zoxide, starship, tmux, vim, gh, htop, btop. These are preferred over raw `home.packages` because they integrate config management.

**macOS brew formula** (things that don't work well in Nix — GUI apps, JVM version managers, etc.):

```nix
# nix/hosts/darwin.nix
homebrew.brews = [
  # ... existing ...
  "your-formula"
];
```

**macOS GUI app (cask):**

```nix
# nix/hosts/darwin.nix
homebrew.casks = [
  # ... existing ...
  "your-app"
];
```

#### Step 4: Apply

```bash
cd ~/.dotfiles

# macOS
darwin-rebuild switch --flake .#atoshi-mac

# Linux
home-manager switch --flake .#atoshi-linux
```

If the build fails, Nix tells you exactly what's wrong — usually a typo in the package name. Nothing changes on your system until the build fully succeeds.

#### Step 5: Commit

```bash
git add -A && git commit -m "add <package-name>"
```

### Quick Reference: Common Operations

```bash
# Try a package without installing permanently
nix shell nixpkgs#k6
nix shell nixpkgs#aircrack-ng

# Try multiple packages at once
nix shell nixpkgs#k6 nixpkgs#hey nixpkgs#wrk

# Run a command from a package without even entering a shell
nix run nixpkgs#cowsay -- "hello"

# See what would change before applying
darwin-rebuild build --flake .#atoshi-mac  # builds but doesn't activate

# Rollback if something breaks
darwin-rebuild switch --rollback           # macOS
home-manager generations                   # list previous states (Linux)

# Update all Nix packages to latest versions
cd ~/.dotfiles
nix flake update                           # updates flake.lock
darwin-rebuild switch --flake .#atoshi-mac # rebuild with new versions

# Garbage collect old generations (free disk space)
nix-collect-garbage -d
```

### Project-Specific Environments

Instead of installing dev tools globally, use per-project Nix shells. Create a `flake.nix` in any project:

```nix
# myproject/flake.nix
{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { nixpkgs, ... }:
    let pkgs = nixpkgs.legacyPackages.aarch64-darwin;
    in {
      devShells.aarch64-darwin.default = pkgs.mkShell {
        packages = with pkgs; [ nodejs_22 pnpm typescript ];
      };
    };
}
```

Then: `cd myproject && nix develop` — you get those tools, scoped to that project. When using `direnv` (already configured), add a `.envrc` with `use flake` and it loads automatically when you `cd` into the project.

### Rollback

Both nix-darwin and home-manager keep generations. If something breaks:

```bash
# List previous generations
darwin-rebuild --list-generations   # macOS
home-manager generations            # Linux

# Switch back to a previous generation
darwin-rebuild switch --rollback
```

---

## macOS System Defaults

Managed declaratively in `nix/hosts/darwin.nix` under `system.defaults`:

- Finder: show all extensions, show POSIX path in title bar
- Dock: auto-hide, no recent apps, 48px tile size
- Trackpad: tap to click, three-finger drag
- Global: no auto-capitalize, no auto-correct

Additional macOS settings and keyboard shortcuts are exported in `mac/`.

---

## Customization

### Fork and Personalize

1. Fork this repo
2. Update `flake.nix` with your username in the configuration names
3. Update `nix/home/common.nix`:
   - `programs.git.userName` and `programs.git.userEmail`
   - Add/remove packages from `home.packages`
4. Update `nix/hosts/darwin.nix`:
   - Homebrew casks for your preferred apps
   - `system.defaults` for your macOS preferences
5. Update `bootstrap.sh` with your repo URL

### Adding OS-Specific Aliases

Add to the appropriate file in `shell/aliases/`:
- Both platforms: `shell/aliases/common.sh`
- macOS only: `shell/aliases/darwin.sh`
- Linux only: `shell/aliases/linux.sh`

The OS detection in `shell/env.sh` automatically sources the right files.

### Switching Default Terminal/Multiplexer

All terminal and multiplexer configs are independent. Just open whichever you prefer:

```bash
# Terminal emulators (macOS)
open -a Ghostty
open -a iTerm

# Multiplexers
tmux                    # Start tmux
tmux attach             # Reattach to existing session
zellij                  # Start zellij
zellij attach           # Reattach to existing session
```

---

## Useful Aliases & Commands

### Navigation
| Alias | Command |
|---|---|
| `..` / `...` / `....` | Navigate up directories |
| `p` | `cd ~/projects` |
| `dl` | `cd ~/Downloads` |

### Git
| Alias | Command |
|---|---|
| `g` | `git` |
| `git l` | Pretty log graph (last 20 commits) |
| `git s` | Short status |
| `git d` | Diff with stat |
| `git go <branch>` | Checkout or create branch |
| `git ca` | Add all + commit |
| `git dm` | Delete merged branches |

### Kubernetes
| Alias | Command |
|---|---|
| `k` | `kubectl` |
| `pods` | `kubectl get pods` |

### Files & Search
| Alias/Tool | What it does |
|---|---|
| `l` / `la` / `ls` | List files via eza (colorized, icons) |
| `rg <pattern>` | Search file contents (ripgrep) |
| `fd <name>` | Find files by name |
| `fzf` | Fuzzy find anything |
| `bat <file>` | Cat with syntax highlighting |
| `dust` | Disk usage (visual) |
| `duf` | Disk free (visual) |
| `tldr <command>` | Quick command examples |
| `lazygit` | Git TUI |

### macOS Only
| Alias | Command |
|---|---|
| `flush` | Flush DNS cache |
| `show` / `hide` | Show/hide hidden files in Finder |
| `afk` | Lock screen |
| `emptytrash` | Empty Trash + system logs |
| `chromekill` | Kill Chrome renderer processes |
| `stfu` / `pumpitup` | Mute / max volume |

### Audio Processing
| Alias | Command |
|---|---|
| `wav2mp3` | Convert all WAV to MP3 in current directory |
| `wav2ogg` | Convert all WAV to OGG in current directory |
| `wavDrop` | Delete all WAV files recursively |
