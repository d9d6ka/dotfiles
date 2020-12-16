# Void Linux

## Stow Script

To stow config files use `dotstow` script.

## Bare Repository (**not used**)

New:
```bash
git init --bare $HOME/.dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
echo ".dotfiles" >> $HOME/.gitignore
```

Clone:
```bash
git clone --bare <URL> $HOME/.dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
echo ".dotfiles" >> $HOME/.gitignore
```
