#!/bin/sh

sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

sed -e 's/^plugins.*)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions)/' -e 's,^ZSH_THEME=.*,ZSH_THEME="powerlevel10k/powerlevel10k",' -i ~/.zshrc

wget -O ~/.p10k.zsh https://gist.githubusercontent.com/zouguangxian/e483426c616b577f1ab0c7dd12b83286/raw/.p10k.zsh

echo "[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh" >> ~/.zshrc

chsh -s $(command -v zsh)
