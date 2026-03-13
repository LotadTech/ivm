#!/usr/bin/env bash
set -euo pipefail

IVM_DIR="${IVM_DIR:-$HOME/.ivm}"
IVM_BIN="$IVM_DIR/bin/istioctl"
IVM_VERSIONS="$IVM_DIR/versions"

_os()   { uname -s | tr '[:upper:]' '[:lower:]' | sed 's/darwin/osx/'; }
_arch() { uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/'; }

_current() {
  [[ -L "$IVM_BIN" ]] && readlink "$IVM_BIN" | sed 's|.*/versions/\([^/]*\)/.*|\1|' || echo "none"
}

cmd_install() {
  local v="$1" dest="$IVM_VERSIONS/$1"
  [[ -f "$dest/istioctl" ]] && echo "$v already installed" && return
  mkdir -p "$dest"
  echo "Downloading istioctl $v..."
  curl -fsSL "https://github.com/istio/istio/releases/download/${v}/istioctl-${v}-$(_os)-$(_arch).tar.gz" \
    | tar -xz -C "$dest"
  chmod +x "$dest/istioctl"
  echo "Installed $v"
}

cmd_use() {
  local target="$IVM_VERSIONS/$1/istioctl"
  [[ ! -f "$target" ]] && echo "$1 not installed. Run: ivm install $1" >&2 && exit 1
  mkdir -p "$(dirname "$IVM_BIN")"
  ln -sf "$target" "$IVM_BIN"
  echo "Using istioctl $1"
}

cmd_list() {
  local current; current="$(_current)"
  for v in "$IVM_VERSIONS"/*/; do
    local ver; ver="$(basename "$v")"
    [[ "$ver" == "$current" ]] && echo "* $ver" || echo "  $ver"
  done
}

cmd_list_remote() {
  curl -fsSL "https://api.github.com/repos/istio/istio/releases?per_page=${1:-20}" \
    | grep '"tag_name"' | sed 's/.*"tag_name": "\([^"]*\)".*/\1/'
}

cmd_uninstall() {
  rm -rf "$IVM_VERSIONS/$1"
  [[ "$(_current)" == "$1" ]] && rm -f "$IVM_BIN"
  echo "Uninstalled $1"
}

cmd_current() { echo "istioctl $(_current)"; }

cmd_help() {
  echo "ivm - Istio Version Manager"
  echo ""
  echo "  ivm install <version>    Install a version"
  echo "  ivm use <version>        Switch to a version"
  echo "  ivm current              Show active version"
  echo "  ivm list                 List installed versions"
  echo "  ivm list-remote [n]      List available versions"
  echo "  ivm uninstall <version>  Remove a version"
}

mkdir -p "$IVM_VERSIONS" "$(dirname "$IVM_BIN")"

case "${1:-help}" in
  install)     cmd_install "${2:?'version required'}" ;;
  use)         cmd_use "${2:?'version required'}" ;;
  current)     cmd_current ;;
  list)        cmd_list ;;
  list-remote) cmd_list_remote "${2:-}" ;;
  uninstall)   cmd_uninstall "${2:?'version required'}" ;;
  help|*)      cmd_help ;;
esac
