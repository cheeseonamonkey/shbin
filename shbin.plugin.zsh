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

if [[ -o interactive ]]; then
  _shbin_upload_buffer() {
    [[ -n "$BUFFER" ]] || { zle -M 'shbin: empty command line'; return; }
    local url
    url="$(print -rn -- "$BUFFER" | command shbin - -n -f "shell-$(date +%Y%m%d-%H%M%S).sh")" ||
      { zle -M 'shbin: upload failed'; return 1; }
    zle -M "$url"
  }

  _shbin_insert_download() {
    local remote_path
    [[ -z "$BUFFER" ]] || { zle -M 'shbin: clear the command line first'; return; }
    remote_path="$(_shbin_select_remote)" || return 1
    [[ -n "$remote_path" ]] || return 1
    BUFFER="shbin dl ${(q)remote_path}"
    CURSOR=${#BUFFER}
    zle -R
  }

  zle -N shbin-upload-buffer _shbin_upload_buffer
  zle -N shbin-insert-download _shbin_insert_download
fi
