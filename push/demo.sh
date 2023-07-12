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

clear
. $(dirname ${BASH_SOURCE})/../util.sh

desc "Lets create a text file to push to the registry"
run "echo 'Hello World' > hello.txt"

run "cat hello.txt"

desc "Lets push the file to the registry"
run "oras push localhost:5000/hello:latest \\
    --artifact-type application/example hello.txt"

desc "Lets verify that the repository exists"
run "oras repo list localhost:5000"

desc "Now what are the available tags for this repository"
run "oras repo tags localhost:5000/hello"

desc "Lets take a look at the manifest"
run "oras manifest get localhost:5000/hello:latest --pretty"

desc "Lets now remove the file"
run "rm hello.txt"

desc "Lets pull the file from the registry"
run "oras pull localhost:5000/hello:latest"

run "cat hello.txt"