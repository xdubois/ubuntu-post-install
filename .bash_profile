# Custom Bash Profile Configuration
# Source this file in your ~/.bashrc or copy its contents

# Export environment variables
export EDITOR=vim
export BROWSER=firefox

# Custom aliases and functions
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias bat='batcat'
alias sail="./vendor/bin/sail"
# alias ls="eza --icons --group-directories-first"
# alias ll="eza --icons --group-directories-first -l"


# Custom functions
extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

