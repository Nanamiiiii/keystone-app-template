#!/bin/bash

RUNTIME_VER=2023.05.21-master

# Check pre-requisite
if (! $(command -v git > /dev/null))
then
    echo "error: git is not installed"
    exit 1
fi

# Check existing runtime directory
if [ -e ./runtime ]; then
    read -p "Runtime may already exist. Are you sure re-downloading? (y/N): " yn
    case "$yn" in
      [yY]*) 
          echo "Removing existing runtime..."
          rm -rf ./runtime
          ;;
      *) 
          echo "Runtime is not downloaded. Process ends."
          exit 0
          ;;
    esac
fi

# Clone only runtime to tmp directory
echo "Cloning keystone eyrie runtime..."
echo "Version: $RUNTIME_VER"
if [ -e ./.tmp ]; then
    rm -rf ./.tmp
fi
git clone --filter=blob:none --no-checkout https://github.com/Nanamiiiii/keystone.git ./.tmp/keystone 2> /dev/null
git -C ./.tmp/keystone sparse-checkout init --cone 2> /dev/null
git -C ./.tmp/keystone sparse-checkout add runtime 2> /dev/null
git -C ./.tmp/keystone checkout $RUNTIME_VER 2> /dev/null

# Move runtime source to top-level
cp -r ./.tmp/keystone/runtime ./

# clean up
rm -rf ./.tmp

echo "Runtime setup completed."
echo "The source is located at ./runtime"

