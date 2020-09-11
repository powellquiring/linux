#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR
cp .vimrc ~

git config --global user.email "powellquiring@gmail.com"
git config --global user.name "Powell Quiring"

mkdir -p ~/.ssh
chmod 700 ~/.ssh
rm -f  ~/.ssh/id_rsa
echo 'pbcopy < ~/.ssh/id_rsa'
cat > ~/.ssh/id_rsa
chmod 400 ~/.ssh/id_rsa
ssh -o StrictHostKeyChecking=no github.com

git remote rm origin 
git remote add origin git@github.com:powellquiring/linux.git
git push --set-upstream origin master
git config --global push.default simple

cat $DIR/.bashrc >> ~/.bashrc
source .bashrc

mkdir -p ~/bin
curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | BINDIR=~/bin bash
