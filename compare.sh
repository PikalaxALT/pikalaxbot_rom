#!/bin/sh
# Compares baserom.gbc and pikalaxbot.gbc

# create baserom.txt if necessary
if [ ! -f baserom.txt ]; then
    hexdump -C baserom.gbc > baserom.txt
fi

hexdump -C pikalaxbot.gbc > pikalaxbot.txt

diff -u baserom.txt pikalaxbot.txt | less
