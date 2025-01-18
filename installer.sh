#!/usr/bin/env bash

SCRIPT_DIR=$PWD
GREEN="\033[32m"
RED="\033[31m"
NC="\033[0m"

# read greeting.sh
./scripts/greeting.sh

print_success() {
    echo -e "${GREEN} ${1} {NC}\n"
}
print_error() {
    echo -e "${RED} ${1} ${NC}\n"
}

# install zsh
if [ ! -f /usr/bin/zsh ]; then
    echo "Do you want to install zsh? (y/n)"
    read -r answer
    if [ "${answer}" != "${answer#[Yy]}" ]; then
        cd "$HOME" || exit
        sudo apt update
        echo "Installing zsh..."
        sudo apt install -y zsh
        print_success "SUCCESS: Done!"
    else
        print_error "We are not wanted."
        exit 1
    fi
fi

# install curl
if [ ! -f /usr/bin/curl ]; then
    cd "$HOME" || exit
    echo "Installing curl..."
    sudo apt install -y curl
    print_success "SUCCESS: Done!"
fi

# install zinit
if [ ! -f "$HOME/.local/share/zinit/zinit.git/zinit.zsh" ]; then
    cd "$HOME" || exit
    echo "Installing zinit..."
    bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
    cat <<EOF >> "$HOME/.zshrc"
zinit ice depth=1
## plugins
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light agkozak/zsh-z
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
EOF
    print_success "SUCCESS: Done!"
fi

# install Meslo font
cd "$HOME" || exit
echo "Installing Meslo font..."
sudo apt install fontconfig
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
mkdir -p .local/share/fonts
unzip Meslo.zip -d .local/share/fonts
rm Meslo.zip
cd ".local/share/fonts" || exit
rm "*Windows*"
cd "$HOME" || exit
fc-cache -fv
print_success "SUCCESS: Done!"

#install p10k theme
cd "$HOME" || exit
echo "Installing p10k theme..."
cat <<EOF >> "$HOME/.zshrc"
zinit light romkatv/powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOF
print_success "SUCCESS: Done!"

# set up zshrc
echo "Setting up .zshrc..."
mkdir -p "$HOME/.config/zsh/functions"
cp "${SCRIPT_DIR}/config/style.zsh" "$HOME/.config/zsh/"
cp "${SCRIPT_DIR}/config/aliases.zsh" "$HOME/.config/zsh/"
cp "${SCRIPT_DIR}/config/ubuntu.zsh" "$HOME/.config/zsh/"
cp "${SCRIPT_DIR}/config/history.zsh" "$HOME/.config/zsh/"
cp "${SCRIPT_DIR}/config/git.zsh" "$HOME/.config/zsh/"
cp "${SCRIPT_DIR}/config/functions_tmux.zsh" "$HOME/.config/zsh/functions/"
cp "${SCRIPT_DIR}/config/python.zsh" "$HOME/.config/zsh/"
cp "${SCRIPT_DIR}/config/rust.zsh" "$HOME/.config/zsh/"

cat <<EOF >> "$HOME/.zshrc"

# zsh settings
source ~/.config/zsh/style.zsh
source ~/.config/zsh/aliases.zsh
source ~/.config/zsh/ubuntu.zsh
source ~/.config/zsh/history.zsh
source ~/.config/zsh/git.zsh
source ~/.config/zsh/functions/functions_tmux.zsh
source ~/.config/zsh/python.zsh
source ~/.config/zsh/rust.zsh
EOF

cd "$HOME" || exit
rm -rf "${SCRIPT_DIR}"
print_success "SUCCESS: Done!"
print_success "If you want to set as default shell, type 'chsh -s /usr/bin/zsh'"
