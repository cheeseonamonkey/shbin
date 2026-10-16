# Oh My Zsh integration for the existing Python shbin CLI.

_shbin_select_remote() {
  command -v fzf >/dev/null 2>&1 || { print -u2 'shbin: fzf is not installed'; return 1; }
  setopt localoptions pipefail
  command shbin ls --recursive |
    command fzf --prompt='shbin> ' --preview='shbin preview {}' \
      --preview-window='right:50%:wrap'
}

# Choose and preview a file before downloading it.
shbin-pick() {
  local remote_path
  remote_path="$(_shbin_select_remote)" || return 1
  [[ -n "$remote_path" ]] || return 1
  command shbin dl "$remote_path"
}
