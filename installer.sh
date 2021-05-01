#!/usr/bin/env bash

function script-init()
{
    set -e

    if [ -z "$DOTFILES_ROOT" ]; then
        DOTFILES_ROOT=$HOME/.dotfiles
    fi

    if [ -z "$DOTFILES_REPO" ]; then
        DOTFILES_REPO=https://github.com/noymer/dotfiles
    fi
}

function dotfiles-install()
{
    if [ -d $DOTFILES_ROOT ]; then
        cd $DOTFILES_ROOT
        git pull origin master
    else
        git clone $DOTFILES_REPO $DOTFILES_ROOT
    fi
}

script-init
dotfiles-install

# make symlinks
function make-symbolic-link()
{
    local SOURCE_PATH=$1
    local TARGET_PATH=$2

    if [ -L $TARGET_PATH ]; then
        unlink $TARGET_PATH
        ln -s $SOURCE_PATH $TARGET_PATH
    elif [ -f $TARGET_PATH ]; then
        # -b option not exist in BSD ln
        # ln -sb $SOURCE_PATH $TARGET_PATH
        mv $TARGET_PATH $TARGET_PATH.bak
        ln -s $SOURCE_PATH $TARGET_PATH
    else
        ln -s $SOURCE_PATH $TARGET_PATH
    fi
}

ETC_DIR=$DOTFILES_ROOT/etc
cd $ETC_DIR

for d in $(find . -type d); do
    mkdir -p $HOME/$d
done

for f in $(find . -type f); do
    make-symbolic-link $ETC_DIR/$f $HOME/$f
done



