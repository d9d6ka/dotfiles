# set EDITOR
set -x EDITOR nvim

# Let gpg2 work properly
set -x GPG_TTY (tty)

# set abbreviations
abbr -a -U lf lfcd

# start SSH Agent
start_ssh_agent

