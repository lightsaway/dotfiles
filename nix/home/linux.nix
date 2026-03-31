{ config, pkgs, lib, ... }:

{
  # Linux-specific packages
  home.packages = with pkgs; [
    xclip
    xdg-utils
  ];

  # Linux-specific shell config
  programs.zsh.initExtra = lib.mkAfter ''
    # Linux-specific PATH additions
    [[ -d "/snap/bin" ]] && export PATH="/snap/bin:$PATH"
  '';
}
