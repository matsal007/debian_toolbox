
BIN_PATH=$HOME/.local/bin
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
    configdir="$HOME/.config/bat"

    mkdir -p "$configdir/themes" && echo_succes "Created ~/.config/bat/themes"

    echo_download "Downloading themes"
    wget -P "$configdir/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Latte.tmTheme
    wget -P "$configdir/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Frappe.tmTheme
    wget -P "$configdir/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme
    wget -P "$configdir/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme

    configfile=$HOME/.config/bat/config
    touch "$configfile"

    echo_info "Building cache"
    ~/.local/bin/bat cache --build && echo_succes "Built cache" || echo_error "Failed to build cache"
    echo '--theme="Catppuccin Mocha"' >> "$configfile" && echo_succes "Added theme to config" || echo_error "Failed to add theme to config"
}

download_xcfe4_terminal_theme(){
    echo_info "Creating ~/.local/share/xfce4/terminal/colorschemes/"
    mkdir -p ~/.local/share/xfce4/terminal/colorschemes/ && echo_succes "Created ~/.local/share/xfce4/terminal/colorschemes/" || echo_error "Failed to create ~/.local/share/xfce4/terminal/colorschemes/"

    echo_download "Downloading themes"
    wget -P ~/.local/share/xfce4/terminal/colorschemes/ https://github.com/catppuccin/xfce4-terminal/blob/main/themes/catppuccin-frappe.theme && echo_succes "Downloaded frappe for xfce4 terminal" || echo_error "Failed to download"
    wget -P ~/.local/share/xfce4/terminal/colorschemes/ https://github.com/catppuccin/xfce4-terminal/blob/main/themes/catppuccin-latte.theme && echo_succes "Downloaded latte for xfce4 terminal" || echo_error "Failed to download"
    wget -P ~/.local/share/xfce4/terminal/colorschemes/ https://github.com/catppuccin/xfce4-terminal/blob/main/themes/catppuccin-mocha.theme && echo_succes "Downloaded mocha for xfce4 terminal" || echo_error "Failed to download"
    wget -P ~/.local/share/xfce4/terminal/colorschemes/ https://github.com/catppuccin/xfce4-terminal/blob/main/themes/catppuccin-macchiato.theme && echo_succes "Downloaded macchiato for xfce4 terminal" || echo_error "Failed to download"
}

config_neovim(){
    file=$(<./templates/init.lua) || echo_error "Failed to read init.lua"
    mkdir -p ~/.config/nvim && echo_info "Created ~/.config/nvim"
    touch ~/.config/nvim/init.lua && echo_info "Created ~/.config/nvim/init.lua" || echo_error "Failed to create ~/.config/nvim/init.lua"
    echo "$file" >> "$HOME/.config/nvim/init.lua" && echo_succes "Configured neovim" || echo_error "Failed to write to init.lua"
}

config_shell(){
    sed -i 's/OSH_THEME="font"/OSH_THEME="robbyrussell"/g' ~/.bashrc
    file=$(cat ./templates/aliases.sh) || echo_error "Failed to read aliaeses.sh"
    echo "$file" >> "$HOME/.bashrc" && echo_succes "Configured shell" || echo_error "Failed to write to bashrc"
    file=$(cat ./templates/functions.sh) || echo_error "Failed to read functions.sh"
    echo "$file" >> "$HOME/.bashrc" && echo_succes "Configured shell" || echo_error "Failed to write to bashrc"
    cd Downloads || mkdir ~/Downloads && cd Downloads

    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip && echo_succes "Downloaded JetBrainsMono"
    mkdir -p ~/.fonts && echo_info "Extracting fonts"
    unzip "*.zip" "*.ttf" "*.otf" -d ${HOME}/.fonts && fc-cache -f -v && echo_succes "Extracted fonts" || echo_error "Failed to extract fonts"
}

echo_info "Installing catppuccin for xfce4 terminal"
download_xcfe4_terminal_theme

echo_info "Configuring neovim"
config_neovim

echo_info "Configuring shell"
config_shell

echo_info "Installing catppuccin for bat"
download_batppuccin

