#!/usr/bin/env bash
set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== LazyVim Setup Script ===${NC}\n"

if ! command -v nvim &> /dev/null; then
    echo -e "${RED}Neovim is not installed. Please run 'home-manager switch' first.${NC}"
    exit 1
fi

if [ -d "$HOME/.config/nvim" ]; then
    backup_dir="$HOME/.config/nvim.backup-$(date +%Y%m%d-%H%M%S)"
    echo -e "${YELLOW}Backing up existing Neovim config to $backup_dir${NC}"
    mv "$HOME/.config/nvim" "$backup_dir"
fi

if [ -d "$HOME/.local/share/nvim" ]; then
    backup_dir="$HOME/.local/share/nvim.backup-$(date +%Y%m%d-%H%M%S)"
    echo -e "${YELLOW}Backing up existing Neovim data to $backup_dir${NC}"
    mv "$HOME/.local/share/nvim" "$backup_dir"
fi

if [ -d "$HOME/.local/state/nvim" ]; then
    backup_dir="$HOME/.local/state/nvim.backup-$(date +%Y%m%d-%H%M%S)"
    echo -e "${YELLOW}Backing up existing Neovim state to $backup_dir${NC}"
    mv "$HOME/.local/state/nvim" "$backup_dir"
fi

if [ -d "$HOME/.cache/nvim" ]; then
    rm -rf "$HOME/.cache/nvim"
fi

echo -e "${GREEN}Installing LazyVim starter...${NC}"

git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"

rm -rf "$HOME/.config/nvim/.git"

mkdir -p "$HOME/.config/nvim/lua/plugins"

echo -e "${YELLOW}Creating custom plugin configurations...${NC}"

# Go configuration
cat > "$HOME/.config/nvim/lua/plugins/go.lua" << 'EOF'
return {
  -- Go support
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = { "CmdlineEnter" },
    ft = { "go", 'gomod' },
    build = ':lua require("go.install").update_all_sync()'
  },
}
EOF

# Kubernetes YAML support
cat > "$HOME/.config/nvim/lua/plugins/kubernetes.lua" << 'EOF'
return {
  -- Better YAML support for Kubernetes
  {
    "someone-stole-my-name/yaml-companion.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("telescope").load_extension("yaml_schema")
    end,
  },
}
EOF

# Docker support
cat > "$HOME/.config/nvim/lua/plugins/docker.lua" << 'EOF'
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "dockerfile" })
      end
    end,
  },
}
EOF

# Custom keymaps
cat > "$HOME/.config/nvim/lua/config/keymaps.lua" << 'EOF'
-- Custom keymaps
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Go specific
keymap.set("n", "<leader>gsj", "<cmd> GoTagAdd json <CR>", { desc = "Add json struct tags" })
keymap.set("n", "<leader>gsy", "<cmd> GoTagAdd yaml <CR>", { desc = "Add yaml struct tags" })

-- Kubectl from within Neovim (requires kubectl in PATH)
keymap.set("n", "<leader>kp", ":!kubectl get pods<CR>", { desc = "Get pods" })
keymap.set("n", "<leader>ks", ":!kubectl get services<CR>", { desc = "Get services" })
keymap.set("n", "<leader>kd", ":!kubectl get deployments<CR>", { desc = "Get deployments" })
EOF

# Custom options
cat > "$HOME/.config/nvim/lua/config/options.lua" << 'EOF'
-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

local opt = vim.opt

opt.relativenumber = true
opt.clipboard = "unnamedplus"
opt.swapfile = false
EOF

echo -e "${GREEN}LazyVim installed successfully!${NC}\n"
echo -e "${YELLOW}First launch will install plugins automatically.${NC}"
echo -e "${YELLOW}Start Neovim with: ${GREEN}nvim${NC}\n"
echo -e "${YELLOW}Useful LazyVim commands:${NC}"
echo "  :Lazy                  - Plugin manager"
echo "  :LazyExtras            - Install language extras"
echo "  :Mason                 - LSP/formatter installer"
echo "  <leader>ff             - Find files"
echo "  <leader>sg             - Search (grep)"
echo "  <leader>l              - Lazy menu"
echo ""
echo -e "${YELLOW}After first launch, run inside nvim:${NC}"
echo "  :LazyExtras            - Then enable 'lang.go' and 'lang.docker'"
