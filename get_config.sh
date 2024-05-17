INFO_COLOR='\033[1;34m'
NO_COLOR='\033[0m'
DOWNLOAD_COLOR='\033[1;35m'
SUCCESS_COLOR='\033[1;32m'
ERROR_COLOR='\033[1;31m'

echo_info(){
    echo -e "${INFO_COLOR}[INFO] | $1${NO_COLOR}"
}

echo_download(){
    echo -e "${DOWNLOAD_COLOR}[DOWNLOAD] | $1${NO_COLOR}"
}

echo_succes(){
    echo -e "${SUCCESS_COLOR}[SUCCESS] | $1${NO_COLOR}"
}

echo_error(){
    echo -e "${ERROR_COLOR}[ERROR] | $1${NO_COLOR}"
}

download_batppuccin(){
    echo_info "Creating ~/.config/bat/config"
    mkdir -p "$(bat --config-dir)/themes" && echo_succes "Created ~/.config/bat/themes"

    echo_download "Downloading themes"
    wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Latte.tmTheme
    wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Frappe.tmTheme
    wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme
    wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme

    configfile=$(bat --config-file)
    touch "$configfile"

    echo_info "Building cache"
    bat cache --build && echo_succes "Built cache"
    echo '--theme="Catppuccin Mocha"' >> ~/.config/bat/config && echo_succes "Added theme to config" || echo_error "Failed to add theme to config"
}

download_xcfe4_terminal_theme(){
    echo_info "Creating ~/.local/share/xfce4/terminal/colorschemes/"
    mkdir -p ~/.local/share/xfce4/terminal/colorschemes/ && echo_succes "Created ~/.local/share/xfce4/terminal/colorschemes/" || echo_error "Failed to create ~/.local/share/xfce4/terminal/colorschemes/"

    echo_download "Downloading themes"
    wget -P ~/.local/share/xfce4/terminal/colorschemes/ https://github.com/catppuccin/xfce4-terminal/blob/main/themes/catppuccin-frappe.theme
    wget -P ~/.local/share/xfce4/terminal/colorschemes/ https://github.com/catppuccin/xfce4-terminal/blob/main/themes/catppuccin-latte.theme
    wget -P ~/.local/share/xfce4/terminal/colorschemes/ https://github.com/catppuccin/xfce4-terminal/blob/main/themes/catppuccin-mocha.theme
    wget -P ~/.local/share/xfce4/terminal/colorschemes/ https://github.com/catppuccin/xfce4-terminal/blob/main/themes/catppuccin-macchiato.theme && echo_succes "Downloaded themes for xfce4 terminal"
}

config_neovim(){
    file=$(<./templates/init.lua) || echo_error "Failed to read init.lua"
    touch ~/.config/nvim/init.lua
    echo "$file" > "$HOME/.config/nvim/init.lua" && echo_succes "Configured neovim"
}

config_shell(){
    sed -i 's/OSH_THEME="font"/OSH_THEME="robbyrussell"/g' ~/.bashrc
    file=$(<./templates/aliases.sh) || echo_error "Failed to read aliaeses.sh"
    echo "$file" > "$HOME/.bashrc" && echo_succes "Configured shell" || echo_error "Failed to write to bashrc"
    file=$(<./templates/functions.sh) || echo_error "Failed to read functions.sh"
    echo "$file" > "$HOME/.bashrc" && echo_succes "Configured shell" || echo_error "Failed to write to bashrc"
}

echo_info "Installing catppuccin for bat"
download_batppuccin

echo_info "Installing catppuccin for xfce4 terminal"
download_xcfe4_terminal_theme

echo_info "Configuring neovim"
config_neovim

echo_info "Configuring shell"
config_shell

