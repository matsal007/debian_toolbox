
INFO_COLOR='\033[1;34m'
NO_COLOR='\033[0m'
DOWNLOAD_COLOR='\033[1;35m'
SUCCESS_COLOR='\033[1;32m'

echo_info(){
    echo -e "${INFO_COLOR}[INFO] | $1${NO_COLOR}"
}

echo_download(){
    echo -e "${DOWNLOAD_COLOR}[DOWNLOAD] | $1${NO_COLOR}"
}

echo_succes(){
    echo -e "${SUCCESS_COLOR}[SUCCESS] | $1${NO_COLOR}"
}

indeb(){
    package_name=$(echo $1 | rev | cut -d'/' -f1 | rev | cut -d'_' -f1)
    cd /tmp/deb/installation
    mv $1 /tmp/deb/installation

    echo_info "Unpacking $package_name"

    ar -x *.deb
    tar -xvf data.tar.xz

    echo_info "Moving $package_name to $HOME/.local/bin"
    mv usr/bin/* "$HOME"/.local/bin && echo_succes "$package_name installed"
    rm -rf * 
}

downloadBig5(){
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.local/bin/fzf
    "$HOME"/.local/bin/fzf/install

    echo_download "tree"
    wget http://ftp.debian.org/debian/pool/main/t/tree/tree_1.8.0-1+b1_amd64.deb -P /tmp/deb/
    echo_download "fd"
    wget https://github.com/sharkdp/fd/releases/download/v10.1.0/fd_10.1.0_amd64.deb -P /tmp/deb/
    echo_download "bat"
    wget https://github.com/sharkdp/bat/releases/download/v0.24.0/bat_0.24.0_amd64.deb -P /tmp/deb/
    echo_download "ripgrep"
    wget https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep_14.1.0-1_amd64.deb -P /tmp/deb/
}

downloadNeovim(){
    echo_download "neovim-nightly"
    wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage -O "$HOME"/.local/bin/nvim
    chmod +x "$HOME"/.local/bin/nvim && echo_succes "neovim-nightly installed"
}

downloadNeovim
mkdir -p /tmp/deb/installation

[ cd /tmp/deb/ ] && cd /tmp/deb || mkdir -p /tmp/deb && cd /tmp/deb
downloadBig5

for i in /tmp/deb/*.deb
do
    package=$(echo $i | rev | cut -d'/' -f1 | rev | cut -d'_' -f1)
    echo_info "Installing $package"
    indeb $i
done

[[ ! "$PATH" =~ "$HOME/.local/bin" ]] && echo "export PATH='$PATH:$HOME/.local/bin'" >> ~/.bashrc

$SHELL
