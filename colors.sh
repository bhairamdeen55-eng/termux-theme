#!/data/data/com.termux/files/usr/bin/bash
# ============================================
#  PROMPT + OUTPUT COLOR THEME
# ============================================

# ---- Full green hacker-style terminal ----
# Sets default text/background color for the whole session
echo -e "\e[1;32m\e[40m"
clear

# ---- Custom colored prompt (PS1) ----
# Shows: TEAMVB >>>  (all green)
export PS1='\[\e[1;32m\]TEAMVB \[\e[1;32m\]>>>\[\e[0m\e[1;32m\] '

# ---- ls colors (all green shades, hacker style) ----
export LS_COLORS='di=1;32:ln=1;32:ex=1;32:*.zip=1;32:*.tar=1;32'
alias ls='ls --color=auto'

# ---- grep colors (green highlight) ----
export GREP_COLOR='1;32'
export GREP_COLORS='mt=1;32'
alias grep='grep --color=auto'

# ---- grc for colorized command output (ping, netstat, etc) ----
if command -v grc >/dev/null; then
    alias ping='grc ping'
    alias netstat='grc netstat'
    alias ps='grc ps'
fi

# ---- Simple color helper functions you can use in scripts ----
green() { echo -e "\e[1;32m$1\e[0m"; }
red()   { echo -e "\e[1;31m$1\e[0m"; }
cyan()  { echo -e "\e[1;36m$1\e[0m"; }
yellow(){ echo -e "\e[1;33m$1\e[0m"; }
