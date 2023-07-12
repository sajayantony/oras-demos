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
desc "Get the digest of the image using the registry API"
run "curl -s -I -H 'Accept: application/vnd.oci.image.manifest.v1+json' http://localhost:5000/v2/hello-world/manifests/latest"

export digest="$(curl -s -I -H 'Accept: application/vnd.oci.image.manifest.v1+json' http://localhost:5000/v2/hello-world/manifests/latest  | sed -n 's/Docker-Content-Digest: sha256:\(.*\)/\1/p')"
export URL="http://localhost:5000/v2/hello-world/manifests/${digest}"
desc "Lets now call the referrers API using the digest $digest"
run  "curl -sq  $url | jq ."