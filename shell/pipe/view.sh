#!/bin/bash
rm -f dummy.img
rm -f dummy.img.gz
rm -f dummy2.img
rm -f out.tgz

# generate a dummy big file
fallocate -l 1G dummy.img

# Add ETA to pipeline with pipe viewer (pv)
# https://catonmat.net/unix-utilities-pipe-viewer

# pv can read FS and send to stdout
echo "fs -> pv -> stdout"
pv dummy.img | gzip > dummy.img.gz

# pv can be in the middle of a pipeline
echo "stdin -> pv -> stdout"
gzip -d --to-stdout dummy.img.gz | pv | cat > dummy2.img

# pv can read from stdin and write to FS
echo "stdout -> pv -> fs"
tar -czf - dummy.img | pv > out.tgz

rm -f dummy.img
rm -f dummy.img.gz
rm -f dummy2.img
rm -f out.tgz
