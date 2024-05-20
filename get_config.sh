
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
    echo -e "${DOWNLOAD_COLOR}[DOWNLOADING] | $1${NO_COLOR}"
}

echo_succes(){
    echo -e "${SUCCESS_COLOR}[SUCCESS] | $1${NO_COLOR}"
}

echo_error(){
    echo -e "${ERROR_COLOR}[ERROR] | $1${NO_COLOR}"
}

ask() {
    message=$1
    read -p "$message ([y]/n) " answer
    if [[ $answer =~ ^[[:space:]]*$ ]]; then
        return 0
    else
        return 1
    fi
}

download(){
    path=$1
    link=$2
    success_message=$3
    name=$(echo $link | rev | cut -d'/' -f1 | rev | cut -d'.' -f1)

    echo_download "$name"
    wget -P $path $link >> /dev/null && echo_succes "$success_message" || echo_error "Failed to download $name"
}

download_batppuccin(){
    echo_info "Creating ~/.config/bat/config"
    configdir="$HOME/.config/bat"

    mkdir -p "$configdir/themes" && echo_succes "Created ~/.config/bat/themes"

    download "$configdir/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Latte.tmTheme "Latte downloaded"
    download "$configdir/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Frappe.tmTheme "Frappe downloaded"
    download "$configdir/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme "Macchiato downloaded"
    download "$configdir/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme "Mocha downloaded"

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
    download ~/.local/share/xfce4/terminal/colorschemes/ https://github.com/catppuccin/xfce4-terminal/blob/main/themes/catppuccin-frappe.theme "Downloaded frappe for xfce4 terminal"
    download ~/.local/share/xfce4/terminal/colorschemes/ https://github.com/catppuccin/xfce4-terminal/blob/main/themes/catppuccin-latte.theme "Downloaded latte for xfce4 terminal"
    download ~/.local/share/xfce4/terminal/colorschemes/ https://github.com/catppuccin/xfce4-terminal/blob/main/themes/catppuccin-mocha.theme "Downloaded mocha for xfce4 terminal"
    download ~/.local/share/xfce4/terminal/colorschemes/ https://github.com/catppuccin/xfce4-terminal/blob/main/themes/catppuccin-macchiato.theme "Downloaded macchiato for xfce4 terminal"
}

config_neovim(){
    file=$(<./templates/init.lua) || echo_error "Failed to read init.lua"
    mkdir -p ~/.config/nvim && echo_info "Created ~/.config/nvim"
    touch ~/.config/nvim/init.lua && echo_info "Created ~/.config/nvim/init.lua" || echo_error "Failed to create ~/.config/nvim/init.lua"
    echo "$file" >> "$HOME/.config/nvim/init.lua" && echo_succes "Configured neovim" || echo_error "Failed to write to init.lua"
}

config_shell(){
    sed -i 's/OSH_THEME="font"/OSH_THEME="robbyrussell"/g' ~/.bashrc
    echo "set -o vi" >> ~/.bashrc
    file=$(cat ./templates/aliases.sh) || echo_error "Failed to read aliaeses.sh"
    echo "$file" >> "$HOME/.bashrc" && echo_succes "Configured shell" || echo_error "Failed to write to bashrc"
    file=$(cat ./templates/functions.sh) || echo_error "Failed to read functions.sh"
    echo "$file" >> "$HOME/.bashrc" && echo_succes "Configured shell" || echo_error "Failed to write to bashrc"
}

if ask "Install catppuccin for xfce4 terminal?"; then
    echo_info "Installing catppuccin for xfce4 terminal"
    download_xcfe4_terminal_theme
fi

if ask "Configure neovim?"; then
    echo_info "Configuring neovim"
    config_neovim
fi

if ask "Configure shell?"; then
    echo_info "Configuring shell"
    config_shell
fi

if ask "Install catppuccin for bat?"; then
    echo_info "Installing catppuccin for bat"
    download_batppuccin
fi

