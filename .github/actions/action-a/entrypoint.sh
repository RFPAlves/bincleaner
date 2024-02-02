#!/bin/bash

set -e

dotnet new console -o sample1

cd sample1

dotnet build -c Release
dotnet build -c Debug

bash ${GITHUB_WORKSPACE}/binclear.sh --path ${GITHUB_WORKSPACE}/sample1
