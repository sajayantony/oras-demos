#!/bin/bash
# MiIT License
# 
# Copyright (c) 2023 Sajay Antony
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


. $(dirname ${BASH_SOURCE})/../util.sh


desc "Lets copy an OCI image to the registry"
run "oras copy zothub.io/tools/busybox:stable localhost:5000/busybox:stable"

desc "There are 3 files we are going to attach to the image"

export REPO="localhost:5000/busybox"
run "oras attach "$REPO":stable --artifact-type application/demo --annotation level=1"

desc "To the last digest attach another annotation manifest"
run "oras attach $REPO@$(oras discover localhost:5000/busybox:stable -o tree | sed -n 's/.*\(sha256:[a-f0-9]\+\)$/\1/p' | tail -1) \\
    --artifact-type application/demo --annotation level=2"

desc "Lets repeat that for one more level"
run "oras attach $REPO@$(oras discover localhost:5000/busybox:stable -o tree | sed -n 's/.*\(sha256:[a-f0-9]\+\)$/\1/p' | tail -1) \\
    --artifact-type application/demo --annotation level=2"

desc "Lets view the state of the attachments using discover"
run "oras discover -v -o tree localhost:5000/busybox:stable"

desc "Lets copy the image and attachements to a new repository" 
run " oras copy --recursive localhost:5000/busybox:stable localhost:5000/busybox-prod:stable"

desc "Lets view the tree in the new repository"
run "oras discover -v -o tree localhost:5000/busybox-prod:stable"