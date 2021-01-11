#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
bash -x $DIR/setup2.sh
cat /tmp/.bashrc
source /tmp/.bashrc
cat /tmp/.bashrc >> ~/.bashrc
rm /tmp/.bashrc
