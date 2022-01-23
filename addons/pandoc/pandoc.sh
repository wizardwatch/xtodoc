#/usr/bin/env bash
#pandoc -s $1 -o $2 --highlight-style=./addons/pandoc/theme/dracula/dracula.theme --css=./addons/pandoc/theme/wizardwatch.css --self-contained -H ./addons/pandoc/theme/header.html --lua-filter ./addons/pandoc/theme/root.lua
pandoc -s $1 -o $2
