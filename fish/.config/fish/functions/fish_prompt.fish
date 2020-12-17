function __git_status
    # Check if in git repo
    git rev-parse --absolute-git-dir > /dev/null 2>&1
    if test $status -ne 0
        return 1
    end

    # Set prefix for git part
    set -l git_prefix ' on '

    set -l git_correct
    set -l git_remote (git remote -v | grep '(push)' | head -n1 | awk '{print $1}')
    set -l git_branch (git branch --show-current)
    set -l git_remote_branch
    set -l git_dirty
    set -l git_color

    if set -q git_remote
        set git_correct 0
    else
        set git_correct 1
        set git_dirty "?"
    end

    if test (git branch --all | grep -c "remotes") -eq 0
        set git_correct 1
        set git_dirty "?"
    end

    if test $git_correct -eq 0
        # Verify remote branch
        if test $git_correct -eq 0 -a (git branch --all | grep -c "remotes/$git_remote/$git_branch\$") -gt 0
            set git_remote_branch $git_branch
        else if test $git_correct -eq 0 -a (git branch --all | grep -c "remotes/$git_remote/main\$") -gt 0
            set git_remote_branch main
        else
            set git_remote_branch master
        end

        # Check dirty/unpushed
        if test (git log $git_branch..$git_remote/$git_remote_branch | grep -c "commit") -gt 0
            set git_color yellow
            set git_dirty '<'
        else if test (git status -unormal --porcelain | wc -l) -gt 0
            set git_color $fish_color_status
            set git_dirty '*'
        else if test (git log $git_remote/$git_remote_branch..$git_branch | grep -c "commit") -gt 0
            set git_color $fish_color_user
            set git_dirty '>'
        else
            set git_color $fish_color_user
        end
    end
    
    # Print git branch info
    echo -n -s (set_color normal) "$git_prefix" (set_color $git_color) "$git_branch$git_dirty" (set_color normal) 
end

function fish_prompt --description 'Write out the prompt'
    # Save our status
    set -l last_pipestatus $pipestatus
    
    # Set colors
    set -l color_cwd
    set -l color_usr
    set -l suffix
    switch "$USER"
        case root toor
            if set -q fish_color_cwd_root
                set color_cwd $fish_color_cwd_root
                set color_usr $fish_color_cwd_root
            else
                set color_cwd $fish_color_cwd
                set color_usr $fish_color_user
            end
            set suffix '#'
        case '*'
            set color_cwd $fish_color_cwd
            set color_usr $fish_color_user
            set suffix '>'
    end

    echo -n -s -e '\n' \
        (set_color $color_usr) "$USER" (set_color normal) @ (prompt_hostname) (__git_status) '\n' \
        (set_color $color_cwd) (prompt_pwd) ' ' (__fish_print_pipestatus " [" "]" "|" (set_color $fish_color_status) (set_color --bold $fish_color_status) $last_pipestatus) \
        (set_color normal) "$suffix "
end
