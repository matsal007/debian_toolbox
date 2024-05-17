
indeb(){
    mv $1 /tmp/deb/installation && /
    cd /tmp/deb/installation && /
    ar -x *.deb && /
    tar -xvf data.tar.gz && /
    mv usr/bin/* "$HOME"/.local/bin && /
    rm -rf * 
}

downloadBig5(){
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.local/bin/fzf
    "$HOME"/.local/bin/fzf/install

    wget http://ftp.debian.org/debian/pool/main/t/tree/tree_1.8.0-1+b1_amd64.deb -P /tmp/deb/
    wget https://github.com/sharkdp/fd/releases/download/v10.1.0/fd_10.1.0_amd64.deb -P /tmp/deb/
    wget https://github.com/sharkdp/bat/releases/download/v0.24.0/bat_0.24.0_amd64.deb -P /tmp/deb/
    wget https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep_14.1.0-1_amd64.deb -P /tmp/deb/
    wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage -P /tmp/deb/

}

downloadNeovim(){
    wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage -O "$HOME"/.local/bin/nvim
    chmod +x "$HOME"/.local/bin/nvim
}

downloadNeovim
mkdir -p /tmp/deb/installation

[ cd /tmp/deb/ ] || mkdir -p /tmp/deb
downloadBig5

for i in *.deb
do
    indeb $i

done

