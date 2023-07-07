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

desc "Lets build a simple OCI image"

run "cat $(relative Dockerfile)"
run "docker buildx build --output=type=oci,dest=$(relative image.tar) \\
    -t localhost:5000/hello-world:latest \\
    -f $(relative Dockerfile) ."


desc "Lets push the image to the registry"
run "oras copy --from-oci-layout $(relative image.tar):latest \\
    localhost:5000/hello-world:latest"


desc "Lets create a simple artifact to attach"
run "echo 'Hello World' > $(relative hello.txt)"

desc "Lets now specify the artifact and push to the registry" 
run "oras attach localhost:5000/hello:latest \\
    --artifact-type application\example \\
    $(relative hello.txt)"

desc "Lets view the state of the attachments using discover"
run "oras discover -o tree localhost:5000/hello:latest"
