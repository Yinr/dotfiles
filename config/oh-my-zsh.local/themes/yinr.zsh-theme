# vim:ft=zsh ts=2 sw=2 sts=2
#
# from amuse & agnoster
# https://github.com/zakaziko99/agnosterzak-ohmyzsh-theme
#

rvm_current() {
  rvm current 2>/dev/null
}

rbenv_version() {
  rbenv version 2>/dev/null | awk '{print $1}'
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  RETVAL=$?
  local symbols
  symbols=""
  [[ $RETVAL -ne 0 ]] && symbols+="%{$fg[red]%}✘ "
  [[ $UID -eq 0 ]] && symbols+="%{$fg[yellow]%}⚡ "
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{$fg[cyan]%}⚙ "

  # [[ -n "$symbols" ]] && prompt_segment black default "$symbols"
  [[ -n ${symbols} ]] && echo "${symbols}%{$reset_color%}"
}
PROMPT='$(prompt_status)%{$fg_bold[green]%}%1~%{$reset_color%}$(git_prompt_info) $ '

# Must use Powerline font, for \uE0A0 to render.
ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%}\ue0a0 "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""

if [ -e ~/.rvm/bin/rvm-prompt ]; then
  RPROMPT='%{$fg_bold[red]%}‹$(rvm_current)›%{$reset_color%}'
else
  if which rbenv &> /dev/null; then
    RPROMPT='%{$fg_bold[red]%}$(rbenv_version)%{$reset_color%}'
  fi
fi

RPROMPT='${RPROMRT} ⌚ %{$fg_bold[red]%}%*%{$reset_color%}'
