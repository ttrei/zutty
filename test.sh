#!/usr/bin/env sh

set -e

./waf
./build/src/zutty.dbg -font DejaVuSansMono -fontsize 16 -e exit && mv test.bmp dejavu-16.bmp
./build/src/zutty.dbg -font DejaVuSansMono -fontsize 20 -e exit && mv test.bmp dejavu-20.bmp
./build/src/zutty.dbg -font DejaVuSansMono -fontsize 21 -e exit && mv test.bmp dejavu-21.bmp
