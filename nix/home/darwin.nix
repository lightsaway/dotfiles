{ config, pkgs, lib, ... }:

{
  # macOS-specific packages
  home.packages = with pkgs; [
    # macOS doesn't have these in coreutils path by default
    gnugrep
    gawk
  ];

  # macOS-specific shell config
  programs.zsh.initExtra = lib.mkAfter ''
    # Homebrew paths (Apple Silicon)
    if [[ -d "/opt/homebrew/bin" ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
  '';
}
