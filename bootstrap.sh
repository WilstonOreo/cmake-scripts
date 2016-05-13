#!/bin/bash
echo "Bootstrapping..."
make clean

if [ "$1" == "--delete-builds" ] ; then
  echo "Delete binaries..."
  rm -rf ./bin
fi

CC=/usr/bin/clang-3.5 CXX=/usr/bin/clang++-3.5 cmake .

