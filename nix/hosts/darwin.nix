{ pkgs, ... }:

{
  # Nix configuration
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    # Trusted users for remote builds
    trusted-users = [ "atoshi" ];
  };

  # System-level packages (available to all users)
  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # macOS system defaults
  system.defaults = {
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      AppleInterfaceStyleSwitchesAutomatically = true;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
    };
    finder = {
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = false;
      _FXShowPosixPathInTitle = true;
    };
    dock = {
      autohide = true;
      show-recents = false;
      tilesize = 48;
    };
    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
    };
  };

  # Register shells
  environment.shells = [ pkgs.zsh pkgs.bash ];
  programs.zsh.enable = true;

  # Homebrew integration (for casks that Nix can't manage well)
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      # "zap" removes formulae/casks not listed here. Use "uninstall" for less aggressive cleanup.
      cleanup = "uninstall";
    };

    taps = [];

    # Homebrew formulae that are macOS-only or better managed by brew
    brews = [
      "mas"
      "thefuck"
      "autojump"

      # Version managers
      "jenv"
      "nvm"
      "tfenv"

      # Programming (JVM ecosystem)
      "sbt"
      "maven"
      "scala"
      "ammonite-repl"

      # Shell
      "bash"
      "bash-completion@2"
      "zsh"
      "zsh-completions"
      "zsh-autosuggestions"
      "zsh-syntax-highlighting"

      # Cloud & infra
      "helm"
      "kustomize"

      # Dev tools
      "direnv"
      "gh"
      "mkcert"

      # Databases
      "postgresql@14"
      "mysql-client"
      "librdkafka"
    ];

    casks = [
      "font-hack-nerd-font"
      "font-fira-code"
      "iterm2"
      "appcleaner"
      "betterdisplay"
      "ghostty"
      "lookaway"
      "openmtp"
      "rsyncui"
      "stretchly"
      "utm"
    ];
  };

  # Used for backwards compatibility
  system.stateVersion = 5;
}
