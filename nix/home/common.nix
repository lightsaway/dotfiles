{ config, pkgs, lib, ... }:

{
  home.stateVersion = "24.05";

  # XDG Base Directories
  xdg.enable = true;

  # =========================================================================
  # Packages (cross-platform CLI tools)
  # =========================================================================
  home.packages = with pkgs; [
    # Core utilities
    coreutils
    findutils
    gnutar
    gnused
    moreutils
    gnugrep

    # Search & navigation
    ripgrep
    fd
    tree

    # Compression
    p7zip
    xz

    # Network
    wget
    gnupg
    openssh
    curlie          # better curl for API work

    # Dev tools
    jq
    yq-go
    watch
    zellij
    btop
    lazygit         # TUI for git

    # Modern CLI replacements
    dust            # better du
    duf             # better df
    tldr            # quick command reference
    sd              # intuitive sed alternative
    procs           # modern ps replacement
    choose          # human-friendly cut/awk
    doggo           # user-friendly dig alternative
    gping           # ping with graph

    # Languages & build tools
    go
    rustup
    uv        # Python toolchain (replaces pyenv + pip + venv + pipx)
    python3   # Default Python (uv can install others: uv python install 3.12)
    bun

    # Cloud & infra
    awscli2
    kubectl

    # Media
    ffmpeg
    imagemagick

    # Rust tools (installed via Nix instead of cargo)
    aichat

    # Misc
    bc
    hyperfine       # CLI benchmarking
    glow            # terminal markdown renderer
    difftastic      # structural/syntax-aware diffs
  ];

  # =========================================================================
  # Program configurations
  # =========================================================================

  programs.home-manager.enable = true;

  # Git
  programs.git = {
    enable = true;
    userName = "Anton Serhiienko";
    userEmail = "a.a.sergienko@gmail.com";

    lfs.enable = true;

    aliases = {
      l = "log --pretty=oneline -n 20 --graph --abbrev-commit";
      ls = ''log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate'';
      ll = ''log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --numstat'';
      lds = ''log --pretty=format:"%C(yellow)%h\\ %ad%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --date=short'';
      s = "status -s";
      d = "!git diff-index --quiet HEAD -- || clear; git --no-pager diff --patch-with-stat";
      di = ''!d() { git diff --patch-with-stat HEAD~$1; }; git diff-index --quiet HEAD -- || clear; d'';
      p = "!git pull; git submodule foreach git pull origin master";
      cp = "cherry-pick";
      cl = "clone";
      ci = "commit";
      co = "checkout";
      br = "branch";
      diff = "diff --word-diff";
      dc = "diff --cached";
      cm = "checkout master";
      r = "reset";
      r1 = "reset HEAD^";
      r2 = "reset HEAD^^";
      rh = "reset --hard";
      rh1 = "reset HEAD^ --hard";
      rh2 = "reset HEAD^^ --hard";
      c = "clone --recursive";
      ca = "!git add -A && git commit -av";
      go = ''!f() { git checkout -b "$1" 2> /dev/null || git checkout "$1"; }; f'';
      tags = "tag -l";
      branches = "branch -a";
      remotes = "remote -v";
      aliases = "config --get-regexp alias";
      amend = "commit --amend --reuse-message=HEAD";
      credit = ''!f() { git commit --amend --author "$1 <$2>" -C HEAD; }; f'';
      reb = "!r() { git rebase -i HEAD~$1; }; r";
      retag = "!r() { git tag -d $1 && git push origin :refs/tags/$1 && git tag $1; }; r";
      pushall = "!f() { git remote | xargs -L1 git push --all;}; f";
      fb = "!f() { git branch -a --contains $1; }; f";
      ft = "!f() { git describe --always --contains $1; }; f";
      fc = ''!f() { git log --pretty=format:'%C(yellow)%h  %Cblue%ad  %Creset%s%Cgreen  [%cn] %Cred%d' --decorate --date=short -S$1; }; f'';
      fm = ''!f() { git log --pretty=format:'%C(yellow)%h  %Cblue%ad  %Creset%s%Cgreen  [%cn] %Cred%d' --decorate --date=short --grep=$1; }; f'';
      dm = "!git branch --merged | grep -v '\\\\*' | xargs -n 1 git branch -d";
      contributors = "shortlog --summary --numbered";
    };

    extraConfig = {
      push = {
        default = "current";
        followTags = true;
      };
      apply.whitespace = "fix";
      core = {
        whitespace = "space-before-tab,-indent-with-non-tab,trailing-space";
        trustctime = false;
        precomposeunicode = false;
        untrackedCache = true;
        editor = "vim";
      };
      color = {
        ui = "auto";
        branch = {
          current = "yellow reverse";
          local = "yellow";
          remote = "green";
        };
        diff = {
          meta = "yellow bold";
          frag = "magenta bold";
          old = "red";
          new = "green";
        };
        status = {
          added = "yellow";
          changed = "green";
          untracked = "cyan";
        };
      };
      diff = {
        renames = "copies";
        bin.textconv = "hexdump -v -C";
      };
      help.autocorrect = 1;
      merge.log = true;
      branch.autoSetupMerge = "always";
      credential.helper = "store";
      url = {
        "git@github.com:" = {
          insteadOf = "gh:";
          pushInsteadOf = [ "github:" "git://github.com/" ];
        };
        "git://github.com/" = {
          insteadOf = "github:";
        };
        "git@gist.github.com:" = {
          insteadOf = "gst:";
          pushInsteadOf = [ "gist:" "git://gist.github.com/" ];
        };
        "git://gist.github.com/" = {
          insteadOf = "gist:";
        };
        "https://" = {
          insteadOf = "git://";
        };
      };
    };

    # Local/private overrides (not in git)
    # Create ~/.gitconfig-local for work includes, signing keys, etc.
    includes = [
      { path = "~/.gitconfig-local"; }
    ];
  };

  # Zsh
  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "kubectl" "docker" "dotenv" "docker-compose" "tmux" ];
      # Theme handled by Starship (no oh-my-zsh theme)
    };

    initExtra = ''
      # Source consolidated environment
      source "${config.home.homeDirectory}/.dotfiles/shell/env.sh"

      # Key bindings
      bindkey "\e\e[D" backward-word
      bindkey "\e\e[C" forward-word

      # Autojump (until migrated to zoxide)
      if command -v brew &>/dev/null; then
        [[ -s "$(brew --prefix)/etc/autojump.sh" ]] && source "$(brew --prefix)/etc/autojump.sh"
      fi

      # thefuck
      if command -v thefuck &>/dev/null; then
        eval $(thefuck --alias)
      fi

      # pnpm
      export PNPM_HOME="$HOME/.local/share/pnpm"
      case ":$PATH:" in
        *":$PNPM_HOME:"*) ;;
        *) export PATH="$PNPM_HOME:$PATH" ;;
      esac

      # bun
      [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
      if [[ -d "$HOME/.bun" ]]; then
        export BUN_INSTALL="$HOME/.bun"
        export PATH="$BUN_INSTALL/bin:$PATH"
      fi

      # Claude
      [[ -x "$HOME/.claude/local/claude" ]] && alias claude="$HOME/.claude/local/claude"

      # .hushlogin
      [ ! -f "$HOME/.hushlogin" ] && touch "$HOME/.hushlogin"

      # Machine-specific secrets/config (not in git)
      [[ -f "$HOME/.extra" ]] && source "$HOME/.extra"
    '';
  };

  # FZF
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # Bat (better cat)
  programs.bat = {
    enable = true;
  };

  # Eza (modern ls, replaces exa)
  programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
    extraOptions = [
      "--group-directories-first"
    ];
  };

  # Shell aliases
  home.shellAliases = {
    # eza
    l = "eza -lF";
    la = "eza -laF";
    lt = "eza --tree --level=2 --git-ignore";
    ll = "eza -lahF --git --icons --group-directories-first";
    # modern CLI replacements
    du = "dust";
    df = "duf";
    ps = "procs";
    dig = "doggo";
    f = "fd";
    # fzf + bat preview
    preview = "fzf --preview 'bat --color=always {}'";
    # serve current dir
    serve = "python3 -m http.server";
    # git shortcuts
    gs = "git status";
    gd = "git diff";
    gl = "git log --oneline -20";
    gp = "git push";
    # docker shortcuts
    dc = "docker compose";
    dps = "docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'";
    # copy working directory
    cpwd = "pwd | tr -d '\\n' | pbcopy";
  };

  # Direnv
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Atuin (shell history)
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };
  home.file.".config/atuin/config.toml".source = ../../terminals/atuin/config.toml;

  # Zoxide (modern cd, replaces autojump)
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # Starship prompt
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
  home.file.".config/starship.toml".source = ../../terminals/starship.toml;

  # Htop
  programs.htop.enable = true;

  # Vim
  programs.vim = {
    enable = true;
    defaultEditor = false;  # We set EDITOR in env.sh
    extraConfig = builtins.readFile ../../vim/vimrc;
  };

  # CoC.nvim settings (LSP client for vim)
  home.file.".vim/coc-settings.json".source = ../../vim/coc-settings.json;

  # Ammonite Scala REPL predef
  home.file.".ammonite/predef.sc".source = ../../predef.sc;

  # Node.js (required by CoC.nvim)
  home.packages = lib.mkAfter [ pkgs.nodejs_22 ];

  # GitHub CLI
  programs.gh = {
    enable = true;
  };

  # =========================================================================
  # Terminal multiplexers
  # =========================================================================

  # Tmux
  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ../../terminals/tmux/tmux.conf;
  };

  # Zellij (config managed via xdg file link)
  home.file.".config/zellij/config.kdl".source = ../../terminals/zellij/config.kdl;

  # =========================================================================
  # Terminal emulator configs
  # =========================================================================

  # Ghostty (config managed via xdg file link)
  home.file.".config/ghostty/config".source = ../../terminals/ghostty/config;

  # Delta (better git diffs)
  programs.git.delta = {
    enable = true;
    options = {
      navigate = true;
      side-by-side = true;
      line-numbers = true;
    };
  };
}
