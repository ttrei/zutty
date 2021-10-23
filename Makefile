VERSION=$(shell git describe --tags --dirty)

SOURCEDIR = src
BUILDDIR = build-make

SOURCES = $(wildcard $(SOURCEDIR)/*.cc)
OBJECTS = $(patsubst $(SOURCEDIR)/%.cc,$(BUILDDIR)/%.o,$(SOURCES))

CC = g++
CXXFLAGS = \
   -std=c++14 \
   -fno-omit-frame-pointer \
   -fsigned-char \
   -Wall \
   -Wextra \
   -Wsign-compare \
   -Wno-unused-parameter \
   -DLINUX \
   -DHAVE_EGL_EGL_H=1 \
   -DHAVE_FT=1 \
   -DHAVE_GLES3_GL31_H=1 \
   -DHAVE_XMU=1 \
   $(shell pkg-config --cflags freetype2 xmu egl glesv2)


LDFLAGS = \
	-Wl,-Bstatic \
	-Wl,-Bdynamic \
	-lpthread \
	-flto \
	$(shell pkg-config --libs freetype2 xmu egl glesv2)

zutty: $(BUILDDIR) $(BUILDDIR)/zutty

zutty.dbg: $(BUILDDIR) $(BUILDDIR)/zutty.dbg

$(BUILDDIR):
	mkdir -p $(BUILDDIR)

$(BUILDDIR)/zutty: CXXFLAGS += -Werror -O3 -march=native -mtune=native -flto -DZUTTY_VERSION='"$(VERSION)"'
$(BUILDDIR)/zutty: $(OBJECTS)
	$(CC) $^ -o $@ $(LDFLAGS)

$(BUILDDIR)/zutty.dbg: CXXFLAGS += -DDEBUG -Og -g -ggdb -DZUTTY_VERSION='"$(VERSION)-debug"'
$(BUILDDIR)/zutty.dbg: $(OBJECTS)
	$(CC) $^ -o $@ $(LDFLAGS)

$(OBJECTS): $(BUILDDIR)/%.o : $(SOURCEDIR)/%.cc
	$(CC) -c $(CXXFLAGS) $< -o $@

clean:
	rm -f $(BUILDDIR)/*o $(BUILDDIR)/zutty $(BUILDDIR)/zutty.dbg

# platform = cmd("uname -s")
# if platform == 'Linux':
#     cfg.env.append_value('CXXFLAGS', ['-DLINUX'])
# elif platform == 'FreeBSD':
#     cfg.env.append_value('CXXFLAGS',
#                          ['-DBSD', '-DFREEBSD', '-I/usr/local/include'])
#     cfg.env.append_value('LINKFLAGS', ['-L/usr/local/lib'])
# elif platform == 'OpenBSD':
#     cfg.env.append_value('CXXFLAGS',
#                          ['-DBSD', '-DOPENBSD', '-I/usr/X11R6/include'])
#     cfg.env.append_value('LINKFLAGS', ['-L/usr/X11R6/lib'])
# elif platform == 'NetBSD':
#     cfg.env.append_value('CXXFLAGS', ['-DBSD'])
# elif platform == 'Darwin':
#     cfg.env.append_value('CXXFLAGS', ['-DMACOS'])
# elif platform == 'SunOS':
#     cfg.env.append_value('CXXFLAGS', ['-DSOLARIS'])
#
# cfg.check_cfg(package='freetype2', args=['--cflags', '--libs'],
#               uselib_store='FT')
#
# cfg.check_cfg(package='xmu', args=['--cflags', '--libs'],
#               uselib_store='XMU')

