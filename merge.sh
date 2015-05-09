#!/bin/bash
set -x

base64 --decode -i butfly-adblock-plain.txt -o butfly-adblock.txt

# refresh gfw-list, to be migrate to github.
svn cat https://autoproxy-gfwlist.googlecode.com/svn/trunk/gfwlist.txt > proxy-gfw.txt
base64 --decode -i proxy-gfw.txt -o proxy-gfw-plain.txt

# encode bf-list.
base64 -i butfly-gfw-plain.txt -o butfly-gfw.txt

#merge bf & gfw list.
cat butfly-gfw-plain.txt  proxy-gfw-plain.txt  > butfly-merge-gfw-plain.txt
base64 -i butfly-merge-gfw-plain.txt -o butfly-merge-gfw.txt

svn ci . -m "update revision of bf-list"
