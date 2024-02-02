#!/bin/bash

usage() {
  echo "USAGE: $0 --path <path_to_dir> [--confirm]"
}

if [ $# -lt 2 ]; then
  usage
  exit 1
fi

CONFIRM='no'

while [ $# -gt 0 ]; do
  COMMAND=$1
  case $COMMAND in
    --path)
      DIRECTORY=$2
      shift 2
      ;;
    --confirm)
      CONFIRM='yes'
      shift
      ;;
    *)
      break
      ;;
  esac
done

if [[ ! -d $DIRECTORY ]]; then
  echo "Directory ${DIRECTORY} does not exists."
  usage
  exit 1
fi

set -euo pipefail

echo "The cleaning process has started, it may take a few minutes."
echo ""

pushd $DIRECTORY >/dev/null 2>&1

exec 5>&1
folders=()

IFS=$'\n'
for dir in $(find . -type d | grep 'obj$\|bin$'); do
  FILESIZE=$(du "$dir" -s -h | tee /dev/fd/5)
  FILENAME=$(echo $FILESIZE | awk '{for (i=2; i<NF; i++) printf $i " "; print $NF}')

  folders+=($FILENAME)
done

echo ""

for value in ${folders[@]}; do
  if [[ "$CONFIRM" == 'yes' ]]; then
    printf "[${value}] Would you like to remove it [Y/n]? "
    read n

    if [[ $n == 'q' ]]; then
      break
    fi

    if [[ ! $n =~ [Yy] ]]; then
      continue
    fi
  fi

  rm -rf $value
  printf "[${value}] Removed.\n"
done

popd >/dev/null 2>&1
