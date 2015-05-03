#!/bin/bash
set -x

# refresh gfw-list, to be migrate to github.
#svn cat https://autoproxy-gfwlist.googlecode.com/svn/trunk/gfwlist.txt > proxy-gfw.txt
base64 --decode -i proxy-gfw.txt -o proxy-gfw-plain.txt

# encode bf-list.
base64 -i butfly-gfw-plain.txt -o butfly-gfw.txt

#merge bf & gfw list.
cat butfly-gfw-plain.txt  proxy-gfw-plain.txt  > butfly-merge-plain.txt
base64 -i butfly-merge-plain.txt -o butfly-merge.txt

svn ci . -m "update revision of bf-list"
