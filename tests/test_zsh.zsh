set -e
source "${0:A:h:h}/shbin.plugin.zsh"
local_dir="$(mktemp -d)"
trap 'rm -rf -- "$local_dir"' EXIT
mkdir -p "$local_dir/bin"
cat > "$local_dir/bin/shbin" <<'STUB'
#!/bin/sh
case "$1" in
  ls) printf 'notes.txt\nfolder/code.py\n' ;;
  preview) printf 'preview of %s\n' "$2" ;;
  dl) printf 'downloaded %s\n' "$2" ;;
  *) exit 1 ;;
esac
STUB
cat > "$local_dir/bin/fzf" <<'STUB'
#!/bin/sh
cat >/dev/null
printf 'folder/code.py\n'
STUB
chmod +x "$local_dir/bin/shbin" "$local_dir/bin/fzf"
export PATH="$local_dir/bin:$PATH"
rehash
[[ "$(shbin-pick)" == 'downloaded folder/code.py' ]]
[[ "$(command shbin preview notes.txt)" == 'preview of notes.txt' ]]
print 'zsh plugin: PASS'
