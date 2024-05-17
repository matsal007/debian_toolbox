
[[ ! "$PATH" =~ $BIN_PATH ]] && echo "export PATH='$PATH:$BIN_PATH'" >> ~/.bashrc

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

indeb(){
    package_name=$(echo $1 | rev | cut -d'/' -f1 | rev | cut -d'_' -f1)
    cd /tmp/deb/installation
    mv $1 /tmp/deb/installation

    echo_info "Unpacking $package_name"

    ar -x *.deb || echo_error "$package_name unpacking failed"
    tar -xvf data.tar.xz || echo_error "$package_name unpacking data.tar.xz failed"

    echo_info "Moving $package_name to ~/.local/bin"
    mv usr/bin/* ~/.local/bin && echo_succes "$package_name installed"
    rm -rf * 
}

downloadBig5(){
    echo_download "fzf"
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf || echo_error "fzf download failed"
    ~/.fzf/install && echo_succes "fzf installed" || echo_error "fzf install failed"

    echo_download "tree"
    wget http://ftp.debian.org/debian/pool/main/t/tree/tree_1.8.0-1+b1_amd64.deb -P /tmp/deb/ || echo_error "tree download failed"
    echo_download "fd"
    wget https://github.com/sharkdp/fd/releases/download/v10.1.0/fd_10.1.0_amd64.deb -P /tmp/deb/ || echo_error "fd download failed"
    echo_download "bat"
    wget https://github.com/sharkdp/bat/releases/download/v0.24.0/bat_0.24.0_amd64.deb -P /tmp/deb/ || echo_error "bat download failed"
    echo_download "ripgrep"
    wget https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep_14.1.0-1_amd64.deb -P /tmp/deb/ || echo_error "ripgrep download failed"

}

downloadNeovim(){
    echo_download "neovim-nightly"
    nvim="$HOME/.local/bin/nvim"
    nvimurl="https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage"
    mkdir -p "$(dirname "$nvim")"
    curl -fL "$nvimurl" -o "$nvim" -z "$nvim" || echo_error "neovim-nightly download failed"
    chmod u+x "$nvim" && echo_succes "neovim-nightly installed"
}


mkdir -p $BIN_PATH

downloadNeovim
mkdir -p /tmp/deb/installation

cd /tmp/deb || mkdir -p /tmp/deb && cd /tmp/deb
downloadBig5

for i in /tmp/deb/*.deb
do
    package=$(echo $i | rev | cut -d'/' -f1 | rev | cut -d'_' -f1)
    echo_info "Installing $package"
    indeb $i
done

$SHELL
