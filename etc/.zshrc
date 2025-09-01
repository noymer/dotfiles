export LANG=ja_JP.UTF-8

## history
# Keep 100000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history
setopt histignorealldups
setopt share_history

## zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

## zsh-history-substring-search
# see: https://github.com/zsh-users/zsh-history-substring-search
# なんかうまく動かない。。。
# zinit snippet OMZ::plugins/git/git.plugin.zsh
# zinit load 'zsh-users/zsh-history-substring-search'
# zinit ice wait'1' atload'_history_substring_search_config'
# 以下参考にすればよい？
# https://github.com/zsh-users/zsh-history-substring-search/issues/110

zinit light zdharma-continuum/history-search-multi-word
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting

## binaries
zinit light zdharma-continuum/zinit-annex-bin-gem-node
# from: https://github.com/zdharma-continuum/zinit/wiki/Recipes-for-popular-programs
# jq
zinit for \
    from'gh-r' \
    sbin'* -> jq' \
    nocompile \
  @jqlang/jq

# ripgrep
zinit for \
    from'gh-r' \
    sbin'**/rg -> rg' \
  BurntSushi/ripgrep

# gh
zinit for \
    from'gh-r' \
    sbin'**/gh' \
  cli/cli
# from: https://cli.github.com/manual/gh_completion
eval "$(gh completion -s zsh)"


## uv for python

UV_PATH=${XDG_BIN_HOME:-${HOME}/.local/bin/uv}
if [[ ! -f $UV_PATH ]]; then
  mkdir -p "$(dirname $UV_PATH)"
  curl -LsSf https://astral.sh/uv/install.sh | env INSTALLER_NO_MODIFY_PATH=1 sh
fi

## mise
MISE_PATH=${XDG_BIN_HOME:-${HOME}/.local/bin/mise}
if [[ ! -f $MISE_PATH ]]; then
  curl https://mise.run | sh
fi

eval "$(mise activate zsh)"

## prompt
# Load powerlevel10k theme
zinit ice depth"1" # git clone depth
zinit light romkatv/powerlevel10k
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# 補完候補をカーソルで選択できるように
# from: https://zenn.dev/ttskch/articles/fb5a700b37a504#%E8%A3%9C%E5%AE%8C%E5%80%99%E8%A3%9C%E3%82%92%E3%82%AB%E3%83%BC%E3%82%BD%E3%83%AB%E3%81%A7%E9%81%B8%E6%8A%9E%E3%81%A7%E3%81%8D%E3%82%8B%E3%82%88%E3%81%86%E3%81%AB
autoload -U compinit
compinit -i
zstyle ':completion:*:default' menu select=1
# 補完をcase-insensitiveに
# from: https://zenn.dev/ttskch/articles/fb5a700b37a504#%E8%A3%9C%E5%AE%8C%E3%82%92case-insensitive%E3%81%AB
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# for machine specific settings, if file exists, load
[[ ! -f ~/.zshrc.zsh ]] || source ~/.zshrc.zsh
