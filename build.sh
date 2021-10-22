#!/usr/bin/env sh

mkdir -p  build/src

CXXFLAGS="\
    -std=c++14 \
    -fno-omit-frame-pointer \
    -fsigned-char \
    -Wall \
    -Wextra \
    -Wsign-compare \
    -Wno-unused-parameter \
    -DLINUX \
    -Werror \
    -O3 \
    -march=native \
    -mtune=native \
    -flto \
    -I/usr/include/freetype2 \
    -I/usr/include/libpng16 \
    -DHAVE_FT=1 \
    -DHAVE_XMU=1 \
    -DHAVE_EGL_EGL_H=1 \
    -DHAVE_GLES3_GL31_H=1"

LFLAGS="\
    -Wl,-Bstatic \
    -Wl,-Bdynamic \
    -lEGL \
    -lfreetype \
    -lGLESv2 \
    -lpthread \
    -lXmu \
    -lXt \
    -lX11 \
    -flto"

g++ $CXXFLAGS -DZUTTY_VERSION='"0.10-test"' src/main.cc -c -o build/src/main.o
g++ $CXXFLAGS -DZUTTY_VERSION='"0.10-test"' src/fontpack.cc -c -o build/src/fontpack.o
g++ $CXXFLAGS -DZUTTY_VERSION='"0.10-test"' src/charvdev.cc -c -o build/src/charvdev.o
g++ $CXXFLAGS -DZUTTY_VERSION='"0.10-test"' src/log.cc -c -o build/src/log.o
g++ $CXXFLAGS -DZUTTY_VERSION='"0.10-test"' src/font.cc -c -o build/src/font.o
g++ $CXXFLAGS -DZUTTY_VERSION='"0.10-test"' src/renderer.cc -c -o build/src/renderer.o
g++ $CXXFLAGS -DZUTTY_VERSION='"0.10-test"' src/frame.cc -c -o build/src/frame.o
g++ $CXXFLAGS -DZUTTY_VERSION='"0.10-test"' src/vterm.cc -c -o build/src/vterm.o
g++ $CXXFLAGS -DZUTTY_VERSION='"0.10-test"' src/options.cc -c -o build/src/options.o
g++ $CXXFLAGS -DZUTTY_VERSION='"0.10-test"' src/gl.cc -c -o build/src/gl.o
g++ $CXXFLAGS -DZUTTY_VERSION='"0.10-test"' src/selmgr.cc -c -o build/src/selmgr.o
g++ $CXXFLAGS -DZUTTY_VERSION='"0.10-test"' src/pty.cc -c -o build/src/pty.o

g++ \
    build/src/charvdev.o \
    build/src/font.o \
    build/src/fontpack.o \
    build/src/frame.o \
    build/src/gl.o \
    build/src/log.o \
    build/src/main.o \
    build/src/options.o \
    build/src/pty.o \
    build/src/renderer.o \
    build/src/selmgr.o \
    build/src/vterm.o \
    -o build/src/zutty \
    $LFLAGS
