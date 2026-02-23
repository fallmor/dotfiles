# Dotfiles

Nix + Home Manager dotfiles for a reproducible development setup for linux and mac.

## Requirements

- Nix with flakes enabled
- Home Manager 

## Install

**Linux** change username in flake.nix 

```bash
home-manager switch --flake .#debian
```

**macOS** change username and homeDirectory in flake.nix:

```bash
home-manager switch --flake .#macos
```