#!/bin/bash

set -e

# create a simple `hello world` project and build it
# and then use binclear to remove the bin and obj folders.
dotnet new console -o sample1

cd sample1

dotnet build -c Release
dotnet build -c Debug

# execute binclear
bash ${GITHUB_WORKSPACE}/binclear.sh --path ${GITHUB_WORKSPACE}/sample1

# confirm that both folders doesn't no longer exist.
if [[ -d ./bin || -d ./obj ]]; then
  exit 1
fi
