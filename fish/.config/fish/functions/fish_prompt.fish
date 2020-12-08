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

    # Get git status
    set -l git_branch
    set -l git_dirty
    set -l git_color
    set -l git_prefix
    if test -d .git
        set git_prefix ' on '
        set git_branch (git branch --show-current)
        if test (git status --short | wc -l) -gt 0
            set git_color $fish_color_status
            set git_dirty '*'
        else
            set git_color $fish_color_user
        end
    end

    echo -n -s -e '\n' \
        (set_color $color_usr) "$USER" (set_color normal) @ (prompt_hostname) "$git_prefix" (set_color $git_color) "$git_branch$git_dirty" '\n' \
        (set_color $color_cwd) (prompt_pwd) ' ' (__fish_print_pipestatus " [" "]" "|" (set_color $fish_color_status) (set_color --bold $fish_color_status) $last_pipestatus) \
        (set_color normal) "$suffix "
end
