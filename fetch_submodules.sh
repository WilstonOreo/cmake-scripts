#!/bin/bash
git submodule init
git submodule update --recursive
git pull --recurse-submodules
git submodule foreach git pull origin master



