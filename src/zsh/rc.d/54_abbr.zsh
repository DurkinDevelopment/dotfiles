ABBR_USER_ABBREVIATIONS_FILE="${ZDOTDIR}/plugins/abbreviations-store"
source "${ZDOTDIR}/plugins/zsh-abbr/zsh-abbr.zsh"

# monkey patch abbr for better autosuggestion compatibility
_abbr_widget_expand_and_space() {
  emulate -LR zsh
  _abbr_widget_expand
  'builtin' 'command' -v _zsh_autosuggest_fetch &>/dev/null && _zsh_autosuggest_fetch
  zle self-insert
}
