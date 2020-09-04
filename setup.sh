#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR
cp .vimrc ~

git config --global user.email "powellquiring@gmail.com"
git config --global user.name "Powell Quiring"

mkdir -p ~/.ssh
chmod 700 ~/.ssh
echo 'pbcopy < ~/.ssh/id_rsa'
cat > ~/.ssh/id_rsa
chmod 400 ~/.ssh/id_rsa

