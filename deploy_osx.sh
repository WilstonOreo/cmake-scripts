#!/bin/bash
make clean
rm -rf bin/Release/omnidome.app bin/Release/omnidome.dmg
cmake . -DCMAKE_BUILD_TYPE=Release
make -j8
../../Qt/5.6/clang_64/bin/macdeployqt bin/Release/omnidome.app -dmg

