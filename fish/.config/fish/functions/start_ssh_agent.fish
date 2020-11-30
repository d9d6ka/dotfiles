function start_ssh_agent
    setenv SSH_ENV $HOME/.ssh/environment
    if test -f $SSH_ENV
        chmod 600 $SSH_ENV
        source $SSH_ENV > /dev/null
    end
    ssh-add -l &> /dev/null
    set -l ssh_status $status
    if test -z "$SSH_AUTH_SOCK" -o $ssh_status -eq 2
        ssh-agent -c > $SSH_ENV
        chmod 600 $SSH_ENV
        source $SSH_ENV > /dev/null
        ssh-add
    else if test -n "$SSH_AUTH_SOCK" -a $ssh_status -eq 1
        ssh-add
    end
end

