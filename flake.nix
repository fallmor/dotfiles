{
  description = "My dotfiles ";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
    let
      lib = nixpkgs.lib;
      mkHomeConfig = { system, username, homeDirectory }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          modules = [
            ({ pkgs, lib, ... }: {
              home.username = username;
              home.homeDirectory = homeDirectory;
              home.stateVersion = "24.05";

              home.packages = with pkgs; [
                ghostty
                starship
                fzf
                zoxide
                eza
                bat
                ripgrep
                fd
                delta
                ovhcloud-cli

                kubectl
                kubectx
                kubernetes-helm
                k9s
                stern
                vault

                go
                gopls
                gotools
                go-tools
                delve

                git
                gh
                lazygit
                tree-sitter

                zed-editor
                vscode

                htop
                btop
              jq
              yq
              curl
              wget
              unzip
              zip
              gnumake
              gcc
              nodejs_20
	      typescript
              python311
            ] ++ lib.optionals pkgs.stdenv.isLinux [ pkgs.i3status-rust ];

            programs.zsh = {
              enable = true;
              enableCompletion = true;
              autosuggestion.enable = true;
              syntaxHighlighting.enable = true;

              shellAliases = {
                ls = "eza --icons";
                ll = "eza -l --icons";
                la = "eza -la --icons";
                cat = "bat";
                
                g = "git";
                gs = "git status";
                ga = "git add";
                gc = "git commit";
                gp = "git push";
                gl = "git log --oneline --graph";
                
                k = "kubectl";
                kgp = "kubectl get pods";
                kgs = "kubectl get services";
                kgd = "kubectl get deployments";
                kctx = "kubectx";
                kns = "kubens";
                
                ".." = "cd ..";
                "..." = "cd ../..";
                "...." = "cd ../../..";
              };

              initContent = ''
                # FZF configuration
                export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
                export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
                export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

                # Zoxide 
                eval "$(zoxide init zsh)"
                alias cd="z"

                # Starship prompt
                eval "$(starship init zsh)"

                # Kubectl completions
                source <(kubectl completion zsh)
                
                # Go env
                export GOPATH=$HOME/go
                export PATH=$PATH:$GOPATH/bin
              '';

              history = {
                size = 10000;
                path = "$HOME/.zsh_history";
                ignoreDups = true;
                share = true;
              };
            };

            programs.starship = {
              enable = true;
              settings = {
                add_newline = true;
                
                format = "$all";
                
                character = {
                  success_symbol = "[➜](bold green)";
                  error_symbol = "[➜](bold red)";
                };

                directory = {
                  truncation_length = 3;
                  truncate_to_repo = true;
                };

                git_branch = {
                  symbol = " ";
                  format = "on [$symbol$branch]($style) ";
                };

                git_status = {
                  ahead = "⇡$count";
                  diverged = "⇕⇡$ahead_count⇣$behind_count";
                  behind = "⇣$count";
                };

                golang = {
                  symbol = " ";
                  format = "via [$symbol($version )]($style)";
                };

                kubernetes = {
                  disabled = false;
                  format = "on [⛵ $context \\($namespace\\)](dimmed cyan) ";
                };

                docker_context = {
                  symbol = " ";
                  format = "via [$symbol$context]($style) ";
                };
              };
            };

            programs.git = {
              enable = true;
              settings = {
                user = {
                  name = "Mor FALL";  # Change this
                  email = "fall.mor@outlook.com";  # Change this
                };
                init.defaultBranch = "main";
                pull.rebase = true;
                core.editor = "nvim";
                diff.tool = "nvimdiff";
                merge.tool = "nvimdiff";
              };
            };

            programs.delta = {
              enable = true;
              enableGitIntegration = true;
              options = {
                navigate = true;
                light = false;
                side-by-side = true;
                line-numbers = true;
              };
            };

            programs.fzf = {
              enable = true;
              enableZshIntegration = true;
              defaultCommand = "fd --type f --hidden --follow --exclude .git";
              defaultOptions = [
                "--height 40%"
                "--layout=reverse"
                "--border"
                "--inline-info"
              ];
            };


            programs.neovim = {
              enable = true;
              defaultEditor = true;
              viAlias = true;
              vimAlias = true;
              
              extraPackages = with pkgs; [
                gopls
                lua-language-server
                nodePackages.typescript-language-server
                nodePackages.bash-language-server
                yaml-language-server
                stylua
                shfmt
                nixpkgs-fmt
                nodePackages.prettier
                tree-sitter
                ripgrep
                fd
                lazygit
              ];
            };

            programs.vscode = {
              enable = true;
              profiles.default = {
                extensions = with pkgs.vscode-extensions; [
                  golang.go
                  ms-python.python
                  ms-azuretools.vscode-docker
                  
                  jnoortheen.nix-ide
                  
                  ms-kubernetes-tools.vscode-kubernetes-tools
                  
                  eamodio.gitlens
                  
                  pkief.material-icon-theme
                  catppuccin.catppuccin-vsc
                  
                  vscodevim.vim
                  usernamehw.errorlens
                  
                ];
                
                userSettings = {
                  "editor.fontSize" = 14;
                  "editor.fontFamily" = "'JetBrains Mono', monospace";
                  "editor.fontLigatures" = true;
                  "editor.formatOnSave" = true;
                  "editor.minimap.enabled" = false;
                  "editor.lineNumbers" = "relative";
                  "workbench.colorTheme" = "Catppuccin Mocha";
                  "workbench.iconTheme" = "material-icon-theme";
                  "terminal.integrated.fontFamily" = "'JetBrains Mono'";
                  "vim.useSystemClipboard" = true;
                  "git.autofetch" = true;
                  "git.confirmSync" = false;
                  "files.autoSave" = "onFocusChange";
                  
                  # Go settings
                  "go.toolsManagement.autoUpdate" = true;
                  "go.useLanguageServer" = true;
                  "[go]" = {
                    "editor.formatOnSave" = true;
                    "editor.codeActionsOnSave" = {
                      "source.organizeImports" = "explicit";
                    };
                  };
                  
                  # Nix settings
                  "nix.enableLanguageServer" = true;
                  "nix.serverPath" = "nil";
                  "nix.serverSettings" = {
                    "nil" = {
                      "formatting" = {
                        "command" = ["nixpkgs-fmt"];
                      };
                    };
                  };
                };
              };
            };

            home.file.".config/ghostty/config".text = ''
              theme = tokyonight

              font-family = "JetBrains Mono"
              font-size = 12

              window-padding-x = 10
              window-padding-y = 10
              
              shell-integration = true
              
              cursor-style = block
              cursor-style-blink = false

              background = #1a1b26
              foreground = #c0caf5
            '';

            # ===== ZED CONFIG =====
            home.file.".config/zed/settings.json".source = ./configs/zed-settings.json;
            home.file.".config/zed/keymap.json".text = ''
              [
                {
                  "context": "Editor",
                  "bindings": {
                    "ctrl-/": "editor::ToggleComments"
                  }
                }
              ]
            '';

            # ===== I3STATUS-RUST CONFIG (Linux only) =====
            home.file.".config/i3status-rust/config.toml" = lib.mkIf pkgs.stdenv.isLinux {
              text = ''
              [theme]
              theme = "solarized-dark"
              
              [icons]
              icons = "awesome6"

              [[block]]
              block = "disk_space"
              path = "/"
              info_type = "available"
              interval = 60
              warning = 20.0
              alert = 10.0

              [[block]]
              block = "memory"
              format = " $icon $mem_used_percents "
              interval = 5

              [[block]]
              block = "cpu"
              interval = 1
              format = " $icon $utilization "

              [[block]]
              block = "load"
              interval = 1
              format = " $icon $1m "

              [[block]]
              block = "net"
              device = "wlp3s0"
              format = " $icon {$signal_strength $ssid} "
              interval = 5

              [[block]]
              block = "time"
              interval = 60
              format = " $timestamp.datetime(f:'%a %d/%m %R') "
            '';
            };

            programs.bat = {
              enable = true;
              config = {
                theme = "TwoDark";
                pager = "less -FR";
              };
            };

            programs.zoxide = {
              enable = true;
              enableZshIntegration = true;
            };

            programs.eza = {
              enable = true;
              enableZshIntegration = true;
              git = true;
              icons = "auto";
            };

            programs.direnv = {
              enable = true;
              enableZshIntegration = true;
              nix-direnv.enable = true;
            };

            programs.lazygit = {
              enable = true;
              settings = {
                git = {
                  paging = {
                    colorArg = "always";
                    pager = "delta --dark --paging=never";
                  };
                };
              };
            };

            programs.home-manager.enable = true;

            home.activation.setupLazyVim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
              ${pkgs.bash}/bin/bash ${./scripts/lazyvim-setup.sh}
            '';

            home.sessionVariables = {
              EDITOR = "nvim";
              VISUAL = "nvim";
              TERMINAL = "ghostty";
              KUBECONFIG = "$HOME/.kube/config";
            };
          })
        ];
      };

      homeConfigurations.debian = mkHomeConfig {
        system = "x86_64-linux";
        username = "debian";
        homeDirectory = "/home/debian";
      };

      homeConfigurations.macos = mkHomeConfig {
        system = "aarch64-darwin";
        username = "user";
        homeDirectory = "/Users/user";
      };
    };
}
