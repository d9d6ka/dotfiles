# Void Linux

- Openbox Arc themes (c) @dglava under GNU GPL v3.0
- Openbox Shiki themes from @vloup
- Icewm Arc Dark theme (c) @Aethusx

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
