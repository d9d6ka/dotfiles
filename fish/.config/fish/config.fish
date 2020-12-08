# set EDITOR
set -x EDITOR nvim

# set abbreviations
abbr -a -U lf lfcd

# Let gpg2 work properly
export GPG_TTY=(tty)

# start SSH Agent
start_ssh_agent

