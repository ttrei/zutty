#!/usr/bin/env sh

set -e

mkdir -p testimages

./waf

test_font() {
    size=$1
    ./build/src/zutty.dbg -font DejaVuSansMono -fontsize $size -e exit && mv test.bmp testimages/dejavu-$size.bmp
}

test_font 12
test_font 13
test_font 14
test_font 15
test_font 16
test_font 17
test_font 18
test_font 19
test_font 20
test_font 21
test_font 22
test_font 23
test_font 24
