
INFO_COLOR='\033[1;34m'
NO_COLOR='\033[0m'
DOWNLOAD_COLOR='\033[1;35m'
SUCCESS_COLOR='\033[1;32m'
ERROR_COLOR='\033[1;31m'

BIN_PATH=$HOME/.local/bin


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

ask() {
    message=$1
    read -p "$message ([y]/n) " answer
    if [[ $answer =~ ^[[:space:]]*$ ]]; then
        return 0
    else
        return 1
    fi
}

downloadTmux(){
    echo_download "tmux"
    sudo pacman -Syu --noconfirm tmux

    echo_info "Installing Tmux Plugin Manager"
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm \
        && echo_succes "Installed Tmux Plugin Manager" \
        || echo_error "Failed to install Tmux Plugin Manager"

    echo_info "Changing Tmux config"

    file=$(<./templates/tmux.conf) || echo_error "Failed to read tmux.conf"

    mkdir -p ~/.config/tmux && echo_info "Created ~/.config/tmux"
    touch ~/.config/tmux/tmux.conf \
        && echo_info "Created ~/.config/tmux/tmux.conf" \
        || echo_error "Failed to create ~/.config/tmux/tmux.conf"

    echo "$file" >> "$HOME/.config/tmux/tmux.conf" \
        && echo_succes "Changed Tmux config" \
        || echo_error "Failed to write to tmux.conf"

    bindings=$(<./templates/tmux.bindings.conf) \
        || echo_error "Failed to read bindings.tmux"

    touch ~/.config/tmux/bindings.conf \
        && echo_info "Created ~/.config/tmux/bindings.conf" \
        || echo_error "Failed to create ~/.config/tmux/bindings.conf"

    echo "$bindings" >> "$HOME/.config/tmux/bindings.conf" \
        && echo_succes "Changed Tmux bindings" \
        || echo_error "Failed to write to bindings.tmux"

}

downloadBig8(){
    echo_download "fzf"
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.local/share/fzf || echo_error "fzf download failed"
    ~/.local/share/fzf/install --xdg && echo_succes "fzf installed" || echo_error "fzf install failed"
    sudo pacman -Syu --noconfirm tree lsd bat fd ripgrep neovim
}

setup_junest(){
    echo_download "junest"
    wget https://github.com/fsquillace/junest/archive/refs/heads/master.zip
    unzip master.zip
    rm -f master.zip
    mkdir -p ~/.local/share
    mv junest-master ~/.local/share/junest

    echo "export PATH=~/.local/share/junest/bin:\$PATH" >> ~/.bashrc
    echo "export SHELL=~/.junest/bin/zsh" >> ~/.bashrc
    echo '[ -z "$ZSH_VERSION" ] && exec "$SHELL" -l' >> ~/.bashrc
    echo "[ -z junest ] && junest -- /bin/zsh" >> ~/.bashrc

    export PATH=~/.local/share/junest/bin:$PATH
    junest setup

    echo_succes "Junest installed"
}

setup_mirrorlist(){
    echo_info "Changing mirror list"
    mirrors=$(cat ./templates/mirrorlist) || echo_error "Failed to read mirrorlist"
    sudo echo "$mirrors" > /etc/pacman.d/mirrorlist && echo_succes "Changed mirror list"
}

locale-setup(){
    sudo sed -i 's/#pt_BR.UTF-8/pt_BR.UTF-8' /etc/locale.gen
    sudo locale-gen
}

install_dependencies(){
    sudo pacman -Syyu archlinux-keyring
    sudo pacman -S --ignore sudo glibc base wget exa openssh ldns make\
    autoconf unzip base-devel byobu man htop zsh aria2 mosh vim nano bind git\
    python linux-headers ttf-jetbrains-mono ttf-jetbrains-mono-nerd 

    locale-setup
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

init(){
    echo_info "Installing Junest"
    setup_junest()
    junest

    echo_info "verifying root"
    user=$(sudo whoami)
    if [ "$user" != "root" ]; then
        echo_error "Error: Junest"
        exit 1
    fi

    setup_mirrorlist
    install_dependencies

    echo_info "Changing path to include local bin"

    mkdir -p $BIN_PATH
    [[ ! "$PATH" =~ $BIN_PATH ]] && echo "export PATH='\$PATH:${BIN_PATH}'" >> ~/.zshrc && echo_succes "Changed path to include local bin"

    downloadBig8
    download_tmux
}

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
init

