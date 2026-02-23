#!/usr/bin/env bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Zed Editor Setup Script ===${NC}\n"

# Check if Zed is installed
if ! command -v zed &> /dev/null; then
    echo -e "${RED}Zed is not installed. Please run 'home-manager switch' first.${NC}"
    exit 1
fi

mkdir -p "$HOME/.config/zed"

if [ -f "zed-settings.json" ]; then
    echo -e "${YELLOW}Installing Zed settings...${NC}"
    cp zed-settings.json "$HOME/.config/zed/settings.json"
    echo -e "${GREEN}Zed settings installed!${NC}"
else
    echo -e "${YELLOW}zed-settings.json not found in current directory${NC}"
    echo -e "${YELLOW}Creating default settings...${NC}"
    
    cat > "$HOME/.config/zed/settings.json" << 'EOF'
{
  "theme": "One Dark",
  "ui_font_size": 16,
  "buffer_font_size": 14,
  "buffer_font_family": "JetBrains Mono",
  "relative_line_numbers": true,
  "vim_mode": true,
  "autosave": "on_focus_change",
  "format_on_save": "on",
  "tab_size": 2,
  "terminal": {
    "font_family": "JetBrains Mono",
    "shell": {
      "program": "zsh"
    }
  }
}
EOF
fi

# Create keymap file
cat > "$HOME/.config/zed/keymap.json" << 'EOF'
[
  {
    "context": "Editor",
    "bindings": {
      "ctrl-/": "editor::ToggleComments"
    }
  }
]
EOF

echo -e "${GREEN}Zed setup complete!${NC}\n"
echo -e "${YELLOW}Launch Zed with: ${GREEN}zed${NC}"
echo -e "${YELLOW}Or open a directory: ${GREEN}zed /path/to/project${NC}\n"
echo -e "${YELLOW}First launch will:${NC}"
echo "  - Download and install language servers"
echo "  - Set up Git integration"
echo "  - Configure Vim mode (if enabled)"
echo ""
echo -e "${YELLOW}Useful Zed shortcuts (Vim mode):${NC}"
echo "  Ctrl-P          - File picker"
echo "  Ctrl-Shift-P    - Command palette"
echo "  Ctrl-Shift-F    - Project-wide search"
echo "  Ctrl-/          - Toggle comments"
echo "  Ctrl-`          - Toggle terminal"
