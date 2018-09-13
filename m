Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf1-f175.google.com ([209.85.210.175]:38424 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727365AbeIMF7Z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Sep 2018 01:59:25 -0400
Received: by mail-pf1-f175.google.com with SMTP id x17-v6so1837294pfh.5
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2018 17:52:22 -0700 (PDT)
Received: from clevo-mangix.lan (astound-69-42-16-32.ca.astound.net. [69.42.16.32])
        by smtp.gmail.com with ESMTPSA id v26-v6sm3271672pfe.57.2018.09.12.17.52.18
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 12 Sep 2018 17:52:18 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: Eliminate remaining uses of strerror(errno)
Date: Wed, 12 Sep 2018 17:52:16 -0700
Message-Id: <20180913005216.17485-1-rosenp@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

%m allows a smaller filesize. Useful on embedded systems.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 build/Documentation/Makefile |  142 +++++
 build/Makefile.inc           |   42 ++
 build/config.h               |  139 +++++
 build/config.log             |  822 ++++++++++++++++++++++++++
 build/config.status          | 1059 ++++++++++++++++++++++++++++++++++
 build/version.h              |   14 +
 cmds-qgroup.c                |    3 +-
 messages.h                   |    4 +-
 mkfs/rootdir.c               |   47 +-
 qgroup.c                     |    3 +-
 10 files changed, 2243 insertions(+), 32 deletions(-)
 create mode 100644 build/Documentation/Makefile
 create mode 100644 build/Makefile.inc
 create mode 100644 build/config.h
 create mode 100644 build/config.log
 create mode 100755 build/config.status
 create mode 100644 build/version.h

diff --git a/build/Documentation/Makefile b/build/Documentation/Makefile
new file mode 100644
index 00000000..82ee005a
--- /dev/null
+++ b/build/Documentation/Makefile
@@ -0,0 +1,142 @@
+# Guard against environment variables
+MAN8_TXT =
+
+# Top level commands
+MAN8_TXT += btrfs.asciidoc
+MAN8_TXT += btrfs-convert.asciidoc
+MAN8_TXT += btrfs-find-root.asciidoc
+MAN8_TXT += btrfs-image.asciidoc
+MAN8_TXT += btrfs-map-logical.asciidoc
+MAN8_TXT += btrfs-select-super.asciidoc
+MAN8_TXT += btrfstune.asciidoc
+MAN8_TXT += fsck.btrfs.asciidoc
+MAN8_TXT += mkfs.btrfs.asciidoc
+
+# Sub commands for btrfs
+MAN8_TXT += btrfs-subvolume.asciidoc
+MAN8_TXT += btrfs-filesystem.asciidoc
+MAN8_TXT += btrfs-balance.asciidoc
+MAN8_TXT += btrfs-device.asciidoc
+MAN8_TXT += btrfs-scrub.asciidoc
+MAN8_TXT += btrfs-check.asciidoc
+MAN8_TXT += btrfs-rescue.asciidoc
+MAN8_TXT += btrfs-inspect-internal.asciidoc
+MAN8_TXT += btrfs-send.asciidoc
+MAN8_TXT += btrfs-receive.asciidoc
+MAN8_TXT += btrfs-quota.asciidoc
+MAN8_TXT += btrfs-qgroup.asciidoc
+MAN8_TXT += btrfs-replace.asciidoc
+MAN8_TXT += btrfs-restore.asciidoc
+MAN8_TXT += btrfs-property.asciidoc
+
+# Category 5 manual page
+MAN5_TXT += btrfs-man5.asciidoc
+
+MAN3_TXT += btrfs-ioctl.asciidoc
+
+MAN_TXT = $(MAN3_TXT) $(MAN8_TXT) $(MAN5_TXT)
+MAN_XML = $(patsubst %.asciidoc,%.xml,$(MAN_TXT))
+MAN_HTML = $(patsubst %.asciidoc,%.html,$(MAN_TXT))
+GZ_MAN3 = $(patsubst %.asciidoc,%.3.gz,$(MAN3_TXT))
+GZ_MAN5 = $(patsubst %.asciidoc,%.5.gz,$(MAN5_TXT))
+GZ_MAN8 = $(patsubst %.asciidoc,%.8.gz,$(MAN8_TXT))
+
+mandir ?= $(prefix)/share/man
+man3dir = $(mandir)/man3
+man5dir = $(mandir)/man5
+man8dir = $(mandir)/man8
+
+ifeq (none,asciidoc)
+ASCIIDOC = 
+ASCIIDOC_ARGS = -abtrfs_version=$(BTRFS_VERSION) -f asciidoc.conf
+ASCIIDOC_HTML = html
+ASCIIDOC_DOCBOOK = docbook
+ASCIIDOC_DEPS = asciidoc.conf
+endif
+ifeq (none,asciidoctor)
+ASCIIDOC = 
+ASCIIDOC_ARGS = -abtrfs_version=$(BTRFS_VERSION)
+ASCIIDOC_HTML = xhtml5
+ASCIIDOC_DOCBOOK = docbook45
+ASCIIDOC_DEPS = 
+endif
+
+MANPAGE_XSL = manpage-normal.xsl
+XMLTO = 
+XMLTO_EXTRA =
+XMLTO_EXTRA = -m manpage-bold-literal.xsl
+GZIPCMD = 
+INSTALL = /usr/bin/install -c
+RM = /usr/bin/rm
+RMDIR = /usr/bin/rmdir
+LN_S = ln -s
+MV = 
+SED = 
+BTRFS_VERSION = $(shell $(SED) -n 's/.*PACKAGE_VERSION "\(.*\)"/\1/p'\
+		  ../config.h)
+
+ifneq ($(findstring $(MAKEFLAGS),s),s)
+ifndef V
+	QUIET_RM	= @
+	QUIET_ASCIIDOC	= @echo "    [ASCII]  $@";
+	QUIET_XMLTO	= @echo "    [XMLTO]  $@";
+	QUIET_GZIP	= @echo "    [GZ]     $@";
+endif
+endif
+
+all: man
+man: man3 man5 man8
+man3: $(GZ_MAN3)
+man5: $(GZ_MAN5)
+man8: $(GZ_MAN8)
+html: $(MAN_HTML)
+
+install: install-man
+
+install-man: man
+	$(INSTALL) -d -m 755 $(DESTDIR)$(man5dir)
+	$(INSTALL) -d -m 755 $(DESTDIR)$(man8dir)
+	$(INSTALL) -m 644 $(GZ_MAN5) $(DESTDIR)$(man5dir)
+	# the source file name of btrfs.5 clashes with section 8 page, but we
+	# want to keep the code generic
+	$(MV) $(DESTDIR)$(man5dir)/btrfs-man5.5.gz $(DESTDIR)$(man5dir)/btrfs.5.gz
+	$(INSTALL) -m 644 $(GZ_MAN8) $(DESTDIR)$(man8dir)
+	$(LN_S) -f btrfs-check.8.gz $(DESTDIR)$(man8dir)/btrfsck.8.gz
+
+uninstall:
+	cd $(DESTDIR)$(man8dir); rm -f btrfs-check.8.gz $(GZ_MAN8)
+	$(RMDIR) -p --ignore-fail-on-non-empty $(DESTDIR)$(man8dir)
+
+clean:
+	$(QUIET_RM)$(RM) -f *.xml *.xml+ *.3 *.3.gz *.5 *.5.gz *.8 *.8.gz *.html
+
+%.3.gz : %.3
+	$(QUIET_GZIP)$(GZIPCMD) -n -c $< > $@
+
+%.5.gz : %.5
+	$(QUIET_GZIP)$(GZIPCMD) -n -c $< > $@
+
+%.8.gz : %.8
+	$(QUIET_GZIP)$(GZIPCMD) -n -c $< > $@
+
+%.3 : %.xml
+	$(QUIET_XMLTO)$(RM) -f $@ && \
+	$(XMLTO) -m $(MANPAGE_XSL) $(XMLTO_EXTRA) man $<
+
+%.5 : %.xml
+	$(QUIET_XMLTO)$(RM) -f $@ && \
+	$(XMLTO) -m $(MANPAGE_XSL) $(XMLTO_EXTRA) man $<
+
+%.8 : %.xml
+	$(QUIET_XMLTO)$(RM) -f $@ && \
+	$(XMLTO) -m $(MANPAGE_XSL) $(XMLTO_EXTRA) man $<
+
+%.xml : %.asciidoc $(ASCIIDOC_DEPS)
+	$(QUIET_ASCIIDOC)$(RM) -f $@+ $@ && \
+	$(ASCIIDOC) $(ASCIIDOC_ARGS) -b $(ASCIIDOC_DOCBOOK) -d manpage -o $@+ $< && \
+	$(MV) $@+ $@
+
+%.html : %.asciidoc $(ASCIIDOC_DEPS)
+	$(QUIET_ASCIIDOC)$(RM) -f $@+ $@ && \
+	$(ASCIIDOC) $(ASCIIDOC_ARGS) -b $(ASCIIDOC_HTML) -d article -o $@+ $< && \
+	$(MV) $@+ $@
diff --git a/build/Makefile.inc b/build/Makefile.inc
new file mode 100644
index 00000000..3b0fde82
--- /dev/null
+++ b/build/Makefile.inc
@@ -0,0 +1,42 @@
+# Variables set during configure phase:
+# * build environment, paths
+# * features (eg. convert, documentation)
+export
+
+CC = gcc
+LN_S = ln -s
+AR = ar
+RM = /usr/bin/rm
+RMDIR = /usr/bin/rmdir
+INSTALL = /usr/bin/install -c
+DISABLE_DOCUMENTATION = 1
+DISABLE_BTRFSCONVERT = 1
+BTRFSCONVERT_EXT2 = 0
+BTRFSCONVERT_REISERFS = 0
+BTRFSRESTORE_ZSTD = 0
+PYTHON_BINDINGS = 0
+PYTHON = 
+PYTHON_CFLAGS = 
+
+SUBST_CFLAGS = -g -O1 -Wall -D_FORTIFY_SOURCE=2
+SUBST_LDFLAGS = 
+
+LIBS_BASE = -luuid  -lblkid  -L. -pthread
+LIBS_COMP = -lz  -llzo2 
+LIBS_PYTHON = 
+STATIC_LIBS_BASE = -luuid  -lblkid -luuid  -L. -pthread
+STATIC_LIBS_COMP = -lz  -llzo2 
+
+prefix ?= /usr/local
+exec_prefix = ${prefix}
+bindir = ${exec_prefix}/bin
+libdir ?= ${exec_prefix}/lib
+incdir = ${prefix}/include
+udevdir = /usr/lib/udev
+udevruledir = ${udevdir}/rules.d
+
+# external libs required by various binaries; for btrfs-foo,
+# specify btrfs_foo_libs = <list of libs>; see $($(subst...)) rules in Makefile
+btrfs_convert_libs =   
+
+MAKEFILE_INC_INCLUDED = yes
diff --git a/build/config.h b/build/config.h
new file mode 100644
index 00000000..d13d6b5d
--- /dev/null
+++ b/build/config.h
@@ -0,0 +1,139 @@
+/* config.h.  Generated from config.h.in by configure.  */
+/* config.h.in.  Generated from configure.ac by autoheader.  */
+
+/* Define if building universal (internal helper macro) */
+/* #undef AC_APPLE_UNIVERSAL_BUILD */
+
+/* disable backtrace stuff in kerncompat.h */
+/* #undef BTRFS_DISABLE_BACKTRACE */
+
+/* Define to 1 if you have the `backtrace' function. */
+#define HAVE_BACKTRACE 1
+
+/* Define to 1 if you have the `backtrace_symbols_fd' function. */
+#define HAVE_BACKTRACE_SYMBOLS_FD 1
+
+/* Define to 1 if you have the <execinfo.h> header file. */
+#define HAVE_EXECINFO_H 1
+
+/* Define to 1 if you have the <inttypes.h> header file. */
+#define HAVE_INTTYPES_H 1
+
+/* Define to 1 if you have the <memory.h> header file. */
+#define HAVE_MEMORY_H 1
+
+/* E2fsprogs does not support BIGALLOC */
+/* #undef HAVE_OLD_E2FSPROGS */
+
+/* Define to 1 if you have the `openat' function. */
+#define HAVE_OPENAT 1
+
+/* We did not define FIEMAP_EXTENT_SHARED */
+#define HAVE_OWN_FIEMAP_EXTENT_SHARED_DEFINE 0
+
+/* Define to 1 if you have the `reallocarray' function. */
+#define HAVE_REALLOCARRAY 1
+
+/* Define to 1 if you have the <stdint.h> header file. */
+#define HAVE_STDINT_H 1
+
+/* Define to 1 if you have the <stdlib.h> header file. */
+#define HAVE_STDLIB_H 1
+
+/* Define to 1 if you have the <strings.h> header file. */
+#define HAVE_STRINGS_H 1
+
+/* Define to 1 if you have the <string.h> header file. */
+#define HAVE_STRING_H 1
+
+/* Define to 1 if you have the <sys/stat.h> header file. */
+#define HAVE_SYS_STAT_H 1
+
+/* Define to 1 if you have the <sys/types.h> header file. */
+#define HAVE_SYS_TYPES_H 1
+
+/* Define to 1 if you have the <unistd.h> header file. */
+#define HAVE_UNISTD_H 1
+
+/* Define to the address where bug reports for this package should be sent. */
+#define PACKAGE_BUGREPORT "linux-btrfs@vger.kernel.org"
+
+/* Define to the full name of this package. */
+#define PACKAGE_NAME "btrfs-progs"
+
+/* Define to the full name and version of this package. */
+#define PACKAGE_STRING "btrfs-progs v4.16.1"
+
+/* Define to the one symbol short name of this package. */
+#define PACKAGE_TARNAME "btrfs-progs"
+
+/* URL */
+#define PACKAGE_URL "http://btrfs.wiki.kernel.org"
+
+/* Define to the version of this package. */
+#define PACKAGE_VERSION "v4.16.1"
+
+/* Define to 1 if you have the ANSI C header files. */
+#define STDC_HEADERS 1
+
+/* Enable extensions on AIX 3, Interix.  */
+#ifndef _ALL_SOURCE
+# define _ALL_SOURCE 1
+#endif
+/* Enable GNU extensions on systems that have them.  */
+#ifndef _GNU_SOURCE
+# define _GNU_SOURCE 1
+#endif
+/* Enable threading extensions on Solaris.  */
+#ifndef _POSIX_PTHREAD_SEMANTICS
+# define _POSIX_PTHREAD_SEMANTICS 1
+#endif
+/* Enable extensions on HP NonStop.  */
+#ifndef _TANDEM_SOURCE
+# define _TANDEM_SOURCE 1
+#endif
+/* Enable general extensions on Solaris.  */
+#ifndef __EXTENSIONS__
+# define __EXTENSIONS__ 1
+#endif
+
+
+/* Define WORDS_BIGENDIAN to 1 if your processor stores words with the most
+   significant byte first (like Motorola and SPARC, unlike Intel). */
+#if defined AC_APPLE_UNIVERSAL_BUILD
+# if defined __BIG_ENDIAN__
+#  define WORDS_BIGENDIAN 1
+# endif
+#else
+# ifndef WORDS_BIGENDIAN
+/* #  undef WORDS_BIGENDIAN */
+# endif
+#endif
+
+/* Enable large inode numbers on Mac OS X 10.5.  */
+#ifndef _DARWIN_USE_64_BIT_INODE
+# define _DARWIN_USE_64_BIT_INODE 1
+#endif
+
+/* Number of bits in a file offset, on hosts where this is settable. */
+/* #undef _FILE_OFFSET_BITS */
+
+/* Define for large files, on AIX-style hosts. */
+/* #undef _LARGE_FILES */
+
+/* Define to 1 if on MINIX. */
+/* #undef _MINIX */
+
+/* Define to 2 if the system does not provide POSIX.1 features except with
+   this defined. */
+/* #undef _POSIX_1_SOURCE */
+
+/* Define to 1 if you need to in order for `stat' and other things to work. */
+/* #undef _POSIX_SOURCE */
+
+/* Define to empty if `const' does not conform to ANSI C. */
+/* #undef const */
+
+/* Define to empty if the keyword `volatile' does not work. Warning: valid
+   code using `volatile' can become incorrect without. Disable with care. */
+/* #undef volatile */
diff --git a/build/config.log b/build/config.log
new file mode 100644
index 00000000..ee466180
--- /dev/null
+++ b/build/config.log
@@ -0,0 +1,822 @@
+This file contains any messages produced by compilers while
+running configure, to aid debugging if configure makes a mistake.
+
+It was created by btrfs-progs configure v4.16.1, which was
+generated by GNU Autoconf 2.69.  Invocation command line was
+
+  $ ../configure --disable-documentation --disable-convert --disable-zstd --disable-python
+
+## --------- ##
+## Platform. ##
+## --------- ##
+
+hostname = clevo-mangix
+uname -m = x86_64
+uname -r = 4.16.8-300.fc28.x86_64
+uname -s = Linux
+uname -v = #1 SMP Wed May 9 20:23:40 UTC 2018
+
+/usr/bin/uname -p = x86_64
+/bin/uname -X     = unknown
+
+/bin/arch              = x86_64
+/usr/bin/arch -k       = unknown
+/usr/convex/getsysinfo = unknown
+/usr/bin/hostinfo      = unknown
+/bin/machine           = unknown
+/usr/bin/oslevel       = unknown
+/bin/universe          = unknown
+
+PATH: /usr/share/Modules/bin
+PATH: /usr/local/bin
+PATH: /usr/local/sbin
+PATH: /usr/bin
+PATH: /usr/sbin
+PATH: /home/mangix/.local/bin
+PATH: /home/mangix/bin
+
+
+## ----------- ##
+## Core tests. ##
+## ----------- ##
+
+configure:2326: checking for gcc
+configure:2342: found /usr/bin/gcc
+configure:2353: result: gcc
+configure:2582: checking for C compiler version
+configure:2591: gcc --version >&5
+gcc (GCC) 8.1.1 20180502 (Red Hat 8.1.1-1)
+Copyright (C) 2018 Free Software Foundation, Inc.
+This is free software; see the source for copying conditions.  There is NO
+warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+
+configure:2602: $? = 0
+configure:2591: gcc -v >&5
+Using built-in specs.
+COLLECT_GCC=gcc
+COLLECT_LTO_WRAPPER=/usr/libexec/gcc/x86_64-redhat-linux/8/lto-wrapper
+OFFLOAD_TARGET_NAMES=nvptx-none
+OFFLOAD_TARGET_DEFAULT=1
+Target: x86_64-redhat-linux
+Configured with: ../configure --enable-bootstrap --enable-languages=c,c++,fortran,objc,obj-c++,ada,go,lto --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info --with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-shared --enable-threads=posix --enable-checking=release --enable-multilib --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions --enable-gnu-unique-object --enable-linker-build-id --with-gcc-major-version-only --with-linker-hash-style=gnu --enable-plugin --enable-initfini-array --with-isl --enable-libmpx --enable-offload-targets=nvptx-none --without-cuda-driver --enable-gnu-indirect-function --enable-cet --with-tune=generic --with-arch_32=i686 --build=x86_64-redhat-linux
+Thread model: posix
+gcc version 8.1.1 20180502 (Red Hat 8.1.1-1) (GCC) 
+configure:2602: $? = 0
+configure:2591: gcc -V >&5
+gcc: error: unrecognized command line option '-V'
+gcc: fatal error: no input files
+compilation terminated.
+configure:2602: $? = 1
+configure:2591: gcc -qversion >&5
+gcc: error: unrecognized command line option '-qversion'; did you mean '--version'?
+gcc: fatal error: no input files
+compilation terminated.
+configure:2602: $? = 1
+configure:2622: checking whether the C compiler works
+configure:2644: gcc -g -O1 -Wall -D_FORTIFY_SOURCE=2   conftest.c  >&5
+configure:2648: $? = 0
+configure:2696: result: yes
+configure:2699: checking for C compiler default output file name
+configure:2701: result: a.out
+configure:2707: checking for suffix of executables
+configure:2714: gcc -o conftest -g -O1 -Wall -D_FORTIFY_SOURCE=2   conftest.c  >&5
+configure:2718: $? = 0
+configure:2740: result: 
+configure:2762: checking whether we are cross compiling
+configure:2770: gcc -o conftest -g -O1 -Wall -D_FORTIFY_SOURCE=2   conftest.c  >&5
+configure:2774: $? = 0
+configure:2781: ./conftest
+configure:2785: $? = 0
+configure:2800: result: no
+configure:2805: checking for suffix of object files
+configure:2827: gcc -c -g -O1 -Wall -D_FORTIFY_SOURCE=2  conftest.c >&5
+configure:2831: $? = 0
+configure:2852: result: o
+configure:2856: checking whether we are using the GNU C compiler
+configure:2875: gcc -c -g -O1 -Wall -D_FORTIFY_SOURCE=2  conftest.c >&5
+configure:2875: $? = 0
+configure:2884: result: yes
+configure:2893: checking whether gcc accepts -g
+configure:2913: gcc -c -g  conftest.c >&5
+configure:2913: $? = 0
+configure:2954: result: yes
+configure:2971: checking for gcc option to accept ISO C89
+configure:3034: gcc  -c -g -O1 -Wall -D_FORTIFY_SOURCE=2  conftest.c >&5
+configure:3034: $? = 0
+configure:3047: result: none needed
+configure:3073: checking how to run the C preprocessor
+configure:3104: gcc -E  conftest.c
+configure:3104: $? = 0
+configure:3118: gcc -E  conftest.c
+conftest.c:9:10: fatal error: ac_nonexistent.h: No such file or directory
+ #include <ac_nonexistent.h>
+          ^~~~~~~~~~~~~~~~~~
+compilation terminated.
+configure:3118: $? = 1
+configure: failed program was:
+| /* confdefs.h */
+| #define PACKAGE_NAME "btrfs-progs"
+| #define PACKAGE_TARNAME "btrfs-progs"
+| #define PACKAGE_VERSION "v4.16.1"
+| #define PACKAGE_STRING "btrfs-progs v4.16.1"
+| #define PACKAGE_BUGREPORT "linux-btrfs@vger.kernel.org"
+| #define PACKAGE_URL "http://btrfs.wiki.kernel.org"
+| /* end confdefs.h.  */
+| #include <ac_nonexistent.h>
+configure:3143: result: gcc -E
+configure:3163: gcc -E  conftest.c
+configure:3163: $? = 0
+configure:3177: gcc -E  conftest.c
+conftest.c:9:10: fatal error: ac_nonexistent.h: No such file or directory
+ #include <ac_nonexistent.h>
+          ^~~~~~~~~~~~~~~~~~
+compilation terminated.
+configure:3177: $? = 1
+configure: failed program was:
+| /* confdefs.h */
+| #define PACKAGE_NAME "btrfs-progs"
+| #define PACKAGE_TARNAME "btrfs-progs"
+| #define PACKAGE_VERSION "v4.16.1"
+| #define PACKAGE_STRING "btrfs-progs v4.16.1"
+| #define PACKAGE_BUGREPORT "linux-btrfs@vger.kernel.org"
+| #define PACKAGE_URL "http://btrfs.wiki.kernel.org"
+| /* end confdefs.h.  */
+| #include <ac_nonexistent.h>
+configure:3206: checking for grep that handles long lines and -e
+configure:3264: result: /usr/bin/grep
+configure:3269: checking for egrep
+configure:3331: result: /usr/bin/grep -E
+configure:3336: checking for ANSI C header files
+configure:3356: gcc -c -g -O1 -Wall -D_FORTIFY_SOURCE=2  conftest.c >&5
+configure:3356: $? = 0
+configure:3429: gcc -o conftest -g -O1 -Wall -D_FORTIFY_SOURCE=2   conftest.c  >&5
+configure:3429: $? = 0
+configure:3429: ./conftest
+configure:3429: $? = 0
+configure:3440: result: yes
+configure:3453: checking for sys/types.h
+configure:3453: gcc -c -g -O1 -Wall -D_FORTIFY_SOURCE=2  conftest.c >&5
+configure:3453: $? = 0
+configure:3453: result: yes
+configure:3453: checking for sys/stat.h
+configure:3453: gcc -c -g -O1 -Wall -D_FORTIFY_SOURCE=2  conftest.c >&5
+configure:3453: $? = 0
+configure:3453: result: yes
+configure:3453: checking for stdlib.h
+configure:3453: gcc -c -g -O1 -Wall -D_FORTIFY_SOURCE=2  conftest.c >&5
+configure:3453: $? = 0
+configure:3453: result: yes
+configure:3453: checking for string.h
+configure:3453: gcc -c -g -O1 -Wall -D_FORTIFY_SOURCE=2  conftest.c >&5
+configure:3453: $? = 0
+configure:3453: result: yes
+configure:3453: checking for memory.h
+configure:3453: gcc -c -g -O1 -Wall -D_FORTIFY_SOURCE=2  conftest.c >&5
+configure:3453: $? = 0
+configure:3453: result: yes
+configure:3453: checking for strings.h
+configure:3453: gcc -c -g -O1 -Wall -D_FORTIFY_SOURCE=2  conftest.c >&5
+configure:3453: $? = 0
+configure:3453: result: yes
+configure:3453: checking for inttypes.h
+configure:3453: gcc -c -g -O1 -Wall -D_FORTIFY_SOURCE=2  conftest.c >&5
+configure:3453: $? = 0
+configure:3453: result: yes
+configure:3453: checking for stdint.h
+configure:3453: gcc -c -g -O1 -Wall -D_FORTIFY_SOURCE=2  conftest.c >&5
+configure:3453: $? = 0
+configure:3453: result: yes
+configure:3453: checking for unistd.h
+configure:3453: gcc -c -g -O1 -Wall -D_FORTIFY_SOURCE=2  conftest.c >&5
+configure:3453: $? = 0
+configure:3453: result: yes
+configure:3466: checking minix/config.h usability
+configure:3466: gcc -c -g -O1 -Wall -D_FORTIFY_SOURCE=2  conftest.c >&5
+conftest.c:52:10: fatal error: minix/config.h: No such file or directory
+ #include <minix/config.h>
+          ^~~~~~~~~~~~~~~~
+compilation terminated.
+configure:3466: $? = 1
+configure: failed program was:
+| /* confdefs.h */
+| #define PACKAGE_NAME "btrfs-progs"
+| #define PACKAGE_TARNAME "btrfs-progs"
+| #define PACKAGE_VERSION "v4.16.1"
+| #define PACKAGE_STRING "btrfs-progs v4.16.1"
+| #define PACKAGE_BUGREPORT "linux-btrfs@vger.kernel.org"
+| #define PACKAGE_URL "http://btrfs.wiki.kernel.org"
+| #define STDC_HEADERS 1
+| #define HAVE_SYS_TYPES_H 1
+| #define HAVE_SYS_STAT_H 1
+| #define HAVE_STDLIB_H 1
+| #define HAVE_STRING_H 1
+| #define HAVE_MEMORY_H 1
+| #define HAVE_STRINGS_H 1
+| #define HAVE_INTTYPES_H 1
+| #define HAVE_STDINT_H 1
+| #define HAVE_UNISTD_H 1
+| /* end confdefs.h.  */
+| #include <stdio.h>
+| #ifdef HAVE_SYS_TYPES_H
+| # include <sys/types.h>
+| #endif
+| #ifdef HAVE_SYS_STAT_H
+| # include <sys/stat.h>
+| #endif
+| #ifdef STDC_HEADERS
+| # include <stdlib.h>
+| # include <stddef.h>
+| #else
+| # ifdef HAVE_STDLIB_H
+| #  include <stdlib.h>
+| # endif
+| #endif
+| #ifdef HAVE_STRING_H
+| # if !defined STDC_HEADERS && defined HAVE_MEMORY_H
+| #  include <memory.h>
+| # endif
+| # include <string.h>
+| #endif
+| #ifdef HAVE_STRINGS_H
+| # include <strings.h>
+| #endif
+| #ifdef HAVE_INTTYPES_H
+| # include <inttypes.h>
+| #endif
+| #ifdef HAVE_STDINT_H
+| # include <stdint.h>
+| #endif
+| #ifdef HAVE_UNISTD_H
+| # include <unistd.h>
+| #endif
+| #include <minix/config.h>
+configure:3466: result: no
+configure:3466: checking minix/config.h presence
+configure:3466: gcc -E  conftest.c
+conftest.c:19:10: fatal error: minix/config.h: No such file or directory
+ #include <minix/config.h>
+          ^~~~~~~~~~~~~~~~
+compilation terminated.
+configure:3466: $? = 1
+configure: failed program was:
+| /* confdefs.h */
+| #define PACKAGE_NAME "btrfs-progs"
+| #define PACKAGE_TARNAME "btrfs-progs"
+| #define PACKAGE_VERSION "v4.16.1"
+| #define PACKAGE_STRING "btrfs-progs v4.16.1"
+| #define PACKAGE_BUGREPORT "linux-btrfs@vger.kernel.org"
+| #define PACKAGE_URL "http://btrfs.wiki.kernel.org"
+| #define STDC_HEADERS 1
+| #define HAVE_SYS_TYPES_H 1
+| #define HAVE_SYS_STAT_H 1
+| #define HAVE_STDLIB_H 1
+| #define HAVE_STRING_H 1
+| #define HAVE_MEMORY_H 1
+| #define HAVE_STRINGS_H 1
+| #define HAVE_INTTYPES_H 1
+| #define HAVE_STDINT_H 1
+| #define HAVE_UNISTD_H 1
+| /* end confdefs.h.  */
+| #include <minix/config.h>
+configure:3466: result: no
+configure:3466: checking for minix/config.h
+configure:3466: result: no
+configure:3487: checking whether it is safe to define __EXTENSIONS__
+configure:3505: gcc -c -g -O1 -Wall -D_FORTIFY_SOURCE=2  conftest.c >&5
+configure:3505: $? = 0
+configure:3512: result: yes
+configure:3578: checking for gcc
+configure:3605: result: gcc
+configure:3834: checking for C compiler version
+configure:3843: gcc --version >&5
+gcc (GCC) 8.1.1 20180502 (Red Hat 8.1.1-1)
+Copyright (C) 2018 Free Software Foundation, Inc.
+This is free software; see the source for copying conditions.  There is NO
+warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+
+configure:3854: $? = 0
+configure:3843: gcc -v >&5
+Using built-in specs.
+COLLECT_GCC=gcc
+COLLECT_LTO_WRAPPER=/usr/libexec/gcc/x86_64-redhat-linux/8/lto-wrapper
+OFFLOAD_TARGET_NAMES=nvptx-none
+OFFLOAD_TARGET_DEFAULT=1
+Target: x86_64-redhat-linux
+Configured with: ../configure --enable-bootstrap --enable-languages=c,c++,fortran,objc,obj-c++,ada,go,lto --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info --with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-shared --enable-threads=posix --enable-checking=release --enable-multilib --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions --enable-gnu-unique-object --enable-linker-build-id --with-gcc-major-version-only --with-linker-hash-style=gnu --enable-plugin --enable-initfini-array --with-isl --enable-libmpx --enable-offload-targets=nvptx-none --without-cuda-driver --enable-gnu-indirect-function --enable-cet --with-tune=generic --with-arch_32=i686 --build=x86_64-redhat-linux
+Thread model: posix
+gcc version 8.1.1 20180502 (Red Hat 8.1.1-1) (GCC) 
+configure:3854: $? = 0
+configure:3843: gcc -V >&5
+gcc: error: unrecognized command line option '-V'
+gcc: fatal error: no input files
+compilation terminated.
+configure:3854: $? = 1
+configure:3843: gcc -qversion >&5
+gcc: error: unrecognized command line option '-qversion'; did you mean '--version'?
+gcc: fatal error: no input files
+compilation terminated.
+configure:3854: $? = 1
+configure:3858: checking whether we are using the GNU C compiler
+configure:3886: result: yes
+configure:3895: checking whether gcc accepts -g
+configure:3956: result: yes
+configure:3973: checking for gcc option to accept ISO C89
+configure:4049: result: none needed
+configure:4073: checking build system type
+configure:4087: result: x86_64-pc-linux-gnu
+configure:4107: checking host system type
+configure:4120: result: x86_64-pc-linux-gnu
+configure:4140: checking for an ANSI C-conforming const
+configure:4206: gcc -c -g -O1 -Wall -D_FORTIFY_SOURCE=2  conftest.c >&5
+configure:4206: $? = 0
+configure:4213: result: yes
+configure:4221: checking for working volatile
+configure:4240: gcc -c -g -O1 -Wall -D_FORTIFY_SOURCE=2  conftest.c >&5
+configure:4240: $? = 0
+configure:4247: result: yes
+configure:4255: checking whether byte ordering is bigendian
+configure:4270: gcc -c -g -O1 -Wall -D_FORTIFY_SOURCE=2  conftest.c >&5
+conftest.c:25:9: error: unknown type name 'not'
+         not a universal capable compiler
+         ^~~
+conftest.c:25:15: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'universal'
+         not a universal capable compiler
+               ^~~~~~~~~
+conftest.c:25:15: error: unknown type name 'universal'
+configure:4270: $? = 1
+configure: failed program was:
+| /* confdefs.h */
+| #define PACKAGE_NAME "btrfs-progs"
+| #define PACKAGE_TARNAME "btrfs-progs"
+| #define PACKAGE_VERSION "v4.16.1"
+| #define PACKAGE_STRING "btrfs-progs v4.16.1"
+| #define PACKAGE_BUGREPORT "linux-btrfs@vger.kernel.org"
+| #define PACKAGE_URL "http://btrfs.wiki.kernel.org"
+| #define STDC_HEADERS 1
+| #define HAVE_SYS_TYPES_H 1
+| #define HAVE_SYS_STAT_H 1
+| #define HAVE_STDLIB_H 1
+| #define HAVE_STRING_H 1
+| #define HAVE_MEMORY_H 1
+| #define HAVE_STRINGS_H 1
+| #define HAVE_INTTYPES_H 1
+| #define HAVE_STDINT_H 1
+| #define HAVE_UNISTD_H 1
+| #define __EXTENSIONS__ 1
+| #define _ALL_SOURCE 1
+| #define _GNU_SOURCE 1
+| #define _POSIX_PTHREAD_SEMANTICS 1
+| #define _TANDEM_SOURCE 1
+| /* end confdefs.h.  */
+| #ifndef __APPLE_CC__
+| 	       not a universal capable compiler
+| 	     #endif
+| 	     typedef int dummy;
+| 
+configure:4315: gcc -c -g -O1 -Wall -D_FORTIFY_SOURCE=2  conftest.c >&5
+configure:4315: $? = 0
+configure:4333: gcc -c -g -O1 -Wall -D_FORTIFY_SOURCE=2  conftest.c >&5
+conftest.c: In function 'main':
+conftest.c:31:4: error: unknown type name 'not'; did you mean 'ino_t'?
+    not big endian
+    ^~~
+    ino_t
+conftest.c:31:12: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'endian'
+    not big endian
+            ^~~~~~
+configure:4333: $? = 1
+configure: failed program was:
+| /* confdefs.h */
+| #define PACKAGE_NAME "btrfs-progs"
+| #define PACKAGE_TARNAME "btrfs-progs"
+| #define PACKAGE_VERSION "v4.16.1"
+| #define PACKAGE_STRING "btrfs-progs v4.16.1"
+| #define PACKAGE_BUGREPORT "linux-btrfs@vger.kernel.org"
+| #define PACKAGE_URL "http://btrfs.wiki.kernel.org"
+| #define STDC_HEADERS 1
+| #define HAVE_SYS_TYPES_H 1
+| #define HAVE_SYS_STAT_H 1
+| #define HAVE_STDLIB_H 1
+| #define HAVE_STRING_H 1
+| #define HAVE_MEMORY_H 1
+| #define HAVE_STRINGS_H 1
+| #define HAVE_INTTYPES_H 1
+| #define HAVE_STDINT_H 1
+| #define HAVE_UNISTD_H 1
+| #define __EXTENSIONS__ 1
+| #define _ALL_SOURCE 1
+| #define _GNU_SOURCE 1
+| #define _POSIX_PTHREAD_SEMANTICS 1
+| #define _TANDEM_SOURCE 1
+| /* end confdefs.h.  */
+| #include <sys/types.h>
+| 		#include <sys/param.h>
+| 
+| int
+| main ()
+| {
+| #if BYTE_ORDER != BIG_ENDIAN
+| 		 not big endian
+| 		#endif
+| 
+|   ;
+|   return 0;
+| }
+configure:4461: result: no
+configure:4487: checking for special C compiler options needed for large files
+configure:4532: result: no
+configure:4538: checking for _FILE_OFFSET_BITS value needed for large files
+configure:4563: gcc -c -g -O1 -Wall -D_FORTIFY_SOURCE=2  conftest.c >&5
+configure:4563: $? = 0
+configure:4595: result: no
+configure:4695: checking for a BSD-compatible install
+configure:4763: result: /usr/bin/install -c
+configure:4774: checking whether ln -s works
+configure:4778: result: yes
+configure:4828: checking for ar
+configure:4844: found /usr/bin/ar
+configure:4855: result: ar
+configure:4879: checking for rm
+configure:4897: found /usr/bin/rm
+configure:4910: result: /usr/bin/rm
+configure:4920: checking for rmdir
+configure:4938: found /usr/bin/rmdir
+configure:4951: result: /usr/bin/rmdir
+configure:4963: checking for openat
+configure:4963: gcc -o conftest -g -O1 -Wall -D_FORTIFY_SOURCE=2   conftest.c  >&5
+configure:4963: $? = 0
+configure:4963: result: yes
+configure:4977: checking for reallocarray
+configure:4977: gcc -o conftest -g -O1 -Wall -D_FORTIFY_SOURCE=2   conftest.c  >&5
+configure:4977: $? = 0
+configure:4977: result: yes
+configure:5042: checking for pkg-config
+configure:5060: found /usr/bin/pkg-config
+configure:5072: result: /usr/bin/pkg-config
+configure:5097: checking pkg-config is at least version 0.9.0
+configure:5100: result: yes
+configure:5133: checking execinfo.h usability
+configure:5133: gcc -c -g -O1 -Wall -D_FORTIFY_SOURCE=2  conftest.c >&5
+configure:5133: $? = 0
+configure:5133: result: yes
+configure:5133: checking execinfo.h presence
+configure:5133: gcc -E  conftest.c
+configure:5133: $? = 0
+configure:5133: result: yes
+configure:5133: checking for execinfo.h
+configure:5133: result: yes
+configure:5146: checking for backtrace
+configure:5146: gcc -o conftest -g -O1 -Wall -D_FORTIFY_SOURCE=2   conftest.c  >&5
+configure:5146: $? = 0
+configure:5146: result: yes
+configure:5146: checking for backtrace_symbols_fd
+configure:5146: gcc -o conftest -g -O1 -Wall -D_FORTIFY_SOURCE=2   conftest.c  >&5
+configure:5146: $? = 0
+configure:5146: result: yes
+configure:6039: checking for FIEMAP_EXTENT_SHARED defined in linux/fiemap.h
+configure:6061: gcc -c -g -O1 -Wall -D_FORTIFY_SOURCE=2  conftest.c >&5
+conftest.c: In function 'main':
+conftest.c:35:7: warning: unused variable 'ok' [-Wunused-variable]
+   int ok;
+       ^~
+configure:6061: $? = 0
+configure:6068: result: yes
+configure:6091: checking for BLKID
+configure:6098: $PKG_CONFIG --exists --print-errors "blkid"
+configure:6101: $? = 0
+configure:6115: $PKG_CONFIG --exists --print-errors "blkid"
+configure:6118: $? = 0
+configure:6176: result: yes
+configure:6181: ${PKG_CONFIG} --exists --print-errors "blkid"
+configure:6184: $? = 0
+configure:6195: checking for UUID
+configure:6202: $PKG_CONFIG --exists --print-errors "uuid"
+configure:6205: $? = 0
+configure:6219: $PKG_CONFIG --exists --print-errors "uuid"
+configure:6222: $? = 0
+configure:6280: result: yes
+configure:6285: ${PKG_CONFIG} --exists --print-errors "uuid"
+configure:6288: $? = 0
+configure:6299: checking for ZLIB
+configure:6306: $PKG_CONFIG --exists --print-errors "zlib"
+configure:6309: $? = 0
+configure:6323: $PKG_CONFIG --exists --print-errors "zlib"
+configure:6326: $? = 0
+configure:6384: result: yes
+configure:6389: ${PKG_CONFIG} --exists --print-errors "zlib"
+configure:6392: $? = 0
+configure:6904: checking for lzo_version in -llzo2
+configure:6929: gcc -o conftest -g -O1 -Wall -D_FORTIFY_SOURCE=2   conftest.c -llzo2   >&5
+configure:6929: $? = 0
+configure:6938: result: yes
+configure:7081: creating ./config.status
+
+## ---------------------- ##
+## Running config.status. ##
+## ---------------------- ##
+
+This file was extended by btrfs-progs config.status v4.16.1, which was
+generated by GNU Autoconf 2.69.  Invocation command line was
+
+  CONFIG_FILES    = 
+  CONFIG_HEADERS  = 
+  CONFIG_LINKS    = 
+  CONFIG_COMMANDS = 
+  $ ./config.status 
+
+on clevo-mangix
+
+config.status:879: creating Makefile.inc
+config.status:879: creating Documentation/Makefile
+config.status:879: creating version.h
+config.status:879: creating config.h
+config.status:1039: config.h is unchanged
+configure:8272: result:
+	btrfs-progs v4.16.1
+
+	prefix:             /usr/local
+	exec prefix:        ${prefix}
+
+	bindir:             ${exec_prefix}/bin
+	libdir:             ${exec_prefix}/lib
+	includedir:         ${prefix}/include
+
+	compiler:           gcc
+	cflags:             -g -O1 -Wall -D_FORTIFY_SOURCE=2
+	ldflags:            
+
+	documentation:      no
+	doc generator:      none
+	backtrace support:  yes
+	btrfs-convert:      no 
+	btrfs-restore zstd: no
+	Python bindings:    no
+	Python interpreter: 
+
+	Type 'make' to compile.
+
+
+## ---------------- ##
+## Cache variables. ##
+## ---------------- ##
+
+ac_cv_build=x86_64-pc-linux-gnu
+ac_cv_c_bigendian=no
+ac_cv_c_compiler_gnu=yes
+ac_cv_c_const=yes
+ac_cv_c_volatile=yes
+ac_cv_defined_FIEMAP_EXTENT_SHARED_linux_fiemap_h=yes
+ac_cv_env_BLKID_CFLAGS_set=
+ac_cv_env_BLKID_CFLAGS_value=
+ac_cv_env_BLKID_LIBS_set=
+ac_cv_env_BLKID_LIBS_value=
+ac_cv_env_CC_set=
+ac_cv_env_CC_value=
+ac_cv_env_CFLAGS_set=
+ac_cv_env_CFLAGS_value=
+ac_cv_env_COM_ERR_CFLAGS_set=
+ac_cv_env_COM_ERR_CFLAGS_value=
+ac_cv_env_COM_ERR_LIBS_set=
+ac_cv_env_COM_ERR_LIBS_value=
+ac_cv_env_CPPFLAGS_set=
+ac_cv_env_CPPFLAGS_value=
+ac_cv_env_CPP_set=
+ac_cv_env_CPP_value=
+ac_cv_env_EXT2FS_CFLAGS_set=
+ac_cv_env_EXT2FS_CFLAGS_value=
+ac_cv_env_EXT2FS_LIBS_set=
+ac_cv_env_EXT2FS_LIBS_value=
+ac_cv_env_LDFLAGS_set=
+ac_cv_env_LDFLAGS_value=
+ac_cv_env_LIBS_set=
+ac_cv_env_LIBS_value=
+ac_cv_env_PKG_CONFIG_LIBDIR_set=
+ac_cv_env_PKG_CONFIG_LIBDIR_value=
+ac_cv_env_PKG_CONFIG_PATH_set=
+ac_cv_env_PKG_CONFIG_PATH_value=
+ac_cv_env_PKG_CONFIG_set=
+ac_cv_env_PKG_CONFIG_value=
+ac_cv_env_PYTHON_CFLAGS_set=
+ac_cv_env_PYTHON_CFLAGS_value=
+ac_cv_env_PYTHON_LIBS_set=
+ac_cv_env_PYTHON_LIBS_value=
+ac_cv_env_PYTHON_set=
+ac_cv_env_PYTHON_value=
+ac_cv_env_REISERFS_CFLAGS_set=
+ac_cv_env_REISERFS_CFLAGS_value=
+ac_cv_env_REISERFS_LIBS_set=
+ac_cv_env_REISERFS_LIBS_value=
+ac_cv_env_UUID_CFLAGS_set=
+ac_cv_env_UUID_CFLAGS_value=
+ac_cv_env_UUID_LIBS_set=
+ac_cv_env_UUID_LIBS_value=
+ac_cv_env_ZLIB_CFLAGS_set=
+ac_cv_env_ZLIB_CFLAGS_value=
+ac_cv_env_ZLIB_LIBS_set=
+ac_cv_env_ZLIB_LIBS_value=
+ac_cv_env_ZSTD_CFLAGS_set=
+ac_cv_env_ZSTD_CFLAGS_value=
+ac_cv_env_ZSTD_LIBS_set=
+ac_cv_env_ZSTD_LIBS_value=
+ac_cv_env_build_alias_set=
+ac_cv_env_build_alias_value=
+ac_cv_env_host_alias_set=
+ac_cv_env_host_alias_value=
+ac_cv_env_target_alias_set=
+ac_cv_env_target_alias_value=
+ac_cv_func_backtrace=yes
+ac_cv_func_backtrace_symbols_fd=yes
+ac_cv_func_openat=yes
+ac_cv_func_reallocarray=yes
+ac_cv_header_execinfo_h=yes
+ac_cv_header_inttypes_h=yes
+ac_cv_header_memory_h=yes
+ac_cv_header_minix_config_h=no
+ac_cv_header_stdc=yes
+ac_cv_header_stdint_h=yes
+ac_cv_header_stdlib_h=yes
+ac_cv_header_string_h=yes
+ac_cv_header_strings_h=yes
+ac_cv_header_sys_stat_h=yes
+ac_cv_header_sys_types_h=yes
+ac_cv_header_unistd_h=yes
+ac_cv_host=x86_64-pc-linux-gnu
+ac_cv_lib_lzo2_lzo_version=yes
+ac_cv_objext=o
+ac_cv_path_EGREP='/usr/bin/grep -E'
+ac_cv_path_GREP=/usr/bin/grep
+ac_cv_path_RM=/usr/bin/rm
+ac_cv_path_RMDIR=/usr/bin/rmdir
+ac_cv_path_ac_pt_PKG_CONFIG=/usr/bin/pkg-config
+ac_cv_path_install='/usr/bin/install -c'
+ac_cv_prog_CPP='gcc -E'
+ac_cv_prog_ac_ct_AR=ar
+ac_cv_prog_ac_ct_CC=gcc
+ac_cv_prog_cc_c89=
+ac_cv_prog_cc_g=yes
+ac_cv_safe_to_define___extensions__=yes
+ac_cv_sys_file_offset_bits=no
+ac_cv_sys_largefile_CC=no
+pkg_cv_BLKID_CFLAGS='-I/usr/include/blkid -I/usr/include/uuid '
+pkg_cv_BLKID_LIBS='-lblkid '
+pkg_cv_UUID_CFLAGS='-I/usr/include/uuid '
+pkg_cv_UUID_LIBS='-luuid '
+pkg_cv_ZLIB_CFLAGS=
+pkg_cv_ZLIB_LIBS='-lz '
+
+## ----------------- ##
+## Output variables. ##
+## ----------------- ##
+
+AR='ar'
+ASCIIDOC=''
+ASCIIDOCTOR=''
+ASCIIDOC_TOOL='none'
+BLKID_CFLAGS='-I/usr/include/blkid -I/usr/include/uuid '
+BLKID_LIBS='-lblkid '
+BLKID_LIBS_STATIC='-lblkid -luuid '
+BTRFSCONVERT_EXT2='0'
+BTRFSCONVERT_REISERFS='0'
+BTRFSRESTORE_ZSTD='0'
+CC='gcc'
+CFLAGS='-g -O1 -Wall -D_FORTIFY_SOURCE=2'
+COM_ERR_CFLAGS=''
+COM_ERR_LIBS=''
+CPP='gcc -E'
+CPPFLAGS=''
+DEFS='-DHAVE_CONFIG_H'
+DISABLE_BTRFSCONVERT='1'
+DISABLE_DOCUMENTATION='1'
+ECHO_C=''
+ECHO_N='-n'
+ECHO_T=''
+EGREP='/usr/bin/grep -E'
+EXEEXT=''
+EXT2FS_CFLAGS=''
+EXT2FS_LIBS=''
+GREP='/usr/bin/grep'
+GZIP=''
+INSTALL_DATA='${INSTALL} -m 644'
+INSTALL_PROGRAM='${INSTALL}'
+INSTALL_SCRIPT='${INSTALL}'
+LDFLAGS=''
+LIBBTRFS_MAJOR='0'
+LIBBTRFS_MINOR='1'
+LIBBTRFS_PATCHLEVEL='2'
+LIBOBJS=''
+LIBS=''
+LN_S='ln -s'
+LTLIBOBJS=''
+LZO2_CFLAGS=''
+LZO2_LIBS='-llzo2'
+LZO2_LIBS_STATIC='-llzo2'
+MV=''
+OBJEXT='o'
+PACKAGE_BUGREPORT='linux-btrfs@vger.kernel.org'
+PACKAGE_NAME='btrfs-progs'
+PACKAGE_STRING='btrfs-progs v4.16.1'
+PACKAGE_TARNAME='btrfs-progs'
+PACKAGE_URL='http://btrfs.wiki.kernel.org'
+PACKAGE_VERSION='v4.16.1'
+PATH_SEPARATOR=':'
+PKG_CONFIG='/usr/bin/pkg-config'
+PKG_CONFIG_LIBDIR=''
+PKG_CONFIG_PATH=''
+PYTHON=''
+PYTHON_BINDINGS='0'
+PYTHON_CFLAGS=''
+PYTHON_EXEC_PREFIX=''
+PYTHON_LIBS=''
+PYTHON_PLATFORM=''
+PYTHON_PREFIX=''
+PYTHON_VERSION=''
+REISERFS_CFLAGS=''
+REISERFS_LIBS=''
+RM='/usr/bin/rm'
+RMDIR='/usr/bin/rmdir'
+SED=''
+SHELL='/bin/sh'
+UDEVDIR='/usr/lib/udev'
+UUID_CFLAGS='-I/usr/include/uuid '
+UUID_LIBS='-luuid '
+UUID_LIBS_STATIC='-luuid '
+XMLTO=''
+ZLIB_CFLAGS=''
+ZLIB_LIBS='-lz '
+ZLIB_LIBS_STATIC='-lz '
+ZSTD_CFLAGS=''
+ZSTD_LIBS=''
+ZSTD_LIBS_STATIC=''
+ac_ct_CC='gcc'
+bindir='${exec_prefix}/bin'
+build='x86_64-pc-linux-gnu'
+build_alias=''
+build_cpu='x86_64'
+build_os='linux-gnu'
+build_vendor='pc'
+datadir='${datarootdir}'
+datarootdir='${prefix}/share'
+docdir='${datarootdir}/doc/${PACKAGE_TARNAME}'
+dvidir='${docdir}'
+exec_prefix='${prefix}'
+host='x86_64-pc-linux-gnu'
+host_alias=''
+host_cpu='x86_64'
+host_os='linux-gnu'
+host_vendor='pc'
+htmldir='${docdir}'
+includedir='${prefix}/include'
+infodir='${datarootdir}/info'
+libdir='${exec_prefix}/lib'
+libexecdir='${exec_prefix}/libexec'
+localedir='${datarootdir}/locale'
+localstatedir='${prefix}/var'
+mandir='${datarootdir}/man'
+oldincludedir='/usr/include'
+pdfdir='${docdir}'
+pkgpyexecdir=''
+pkgpythondir=''
+prefix='/usr/local'
+program_transform_name='s,x,x,'
+psdir='${docdir}'
+pyexecdir=''
+pythondir=''
+sbindir='${exec_prefix}/sbin'
+sharedstatedir='${prefix}/com'
+sysconfdir='${prefix}/etc'
+target_alias=''
+
+## ----------- ##
+## confdefs.h. ##
+## ----------- ##
+
+/* confdefs.h */
+#define PACKAGE_NAME "btrfs-progs"
+#define PACKAGE_TARNAME "btrfs-progs"
+#define PACKAGE_VERSION "v4.16.1"
+#define PACKAGE_STRING "btrfs-progs v4.16.1"
+#define PACKAGE_BUGREPORT "linux-btrfs@vger.kernel.org"
+#define PACKAGE_URL "http://btrfs.wiki.kernel.org"
+#define STDC_HEADERS 1
+#define HAVE_SYS_TYPES_H 1
+#define HAVE_SYS_STAT_H 1
+#define HAVE_STDLIB_H 1
+#define HAVE_STRING_H 1
+#define HAVE_MEMORY_H 1
+#define HAVE_STRINGS_H 1
+#define HAVE_INTTYPES_H 1
+#define HAVE_STDINT_H 1
+#define HAVE_UNISTD_H 1
+#define __EXTENSIONS__ 1
+#define _ALL_SOURCE 1
+#define _GNU_SOURCE 1
+#define _POSIX_PTHREAD_SEMANTICS 1
+#define _TANDEM_SOURCE 1
+#define HAVE_OPENAT 1
+#define HAVE_REALLOCARRAY 1
+#define HAVE_EXECINFO_H 1
+#define HAVE_BACKTRACE 1
+#define HAVE_BACKTRACE_SYMBOLS_FD 1
+#define HAVE_OWN_FIEMAP_EXTENT_SHARED_DEFINE 0
+
+configure: exit 0
diff --git a/build/config.status b/build/config.status
new file mode 100755
index 00000000..15e6e067
--- /dev/null
+++ b/build/config.status
@@ -0,0 +1,1059 @@
+#! /bin/sh
+# Generated by configure.
+# Run this file to recreate the current configuration.
+# Compiler output produced by configure, useful for debugging
+# configure, is in config.log if it exists.
+
+debug=false
+ac_cs_recheck=false
+ac_cs_silent=false
+
+SHELL=${CONFIG_SHELL-/bin/sh}
+export SHELL
+## -------------------- ##
+## M4sh Initialization. ##
+## -------------------- ##
+
+# Be more Bourne compatible
+DUALCASE=1; export DUALCASE # for MKS sh
+if test -n "${ZSH_VERSION+set}" && (emulate sh) >/dev/null 2>&1; then :
+  emulate sh
+  NULLCMD=:
+  # Pre-4.2 versions of Zsh do word splitting on ${1+"$@"}, which
+  # is contrary to our usage.  Disable this feature.
+  alias -g '${1+"$@"}'='"$@"'
+  setopt NO_GLOB_SUBST
+else
+  case `(set -o) 2>/dev/null` in #(
+  *posix*) :
+    set -o posix ;; #(
+  *) :
+     ;;
+esac
+fi
+
+
+as_nl='
+'
+export as_nl
+# Printing a long string crashes Solaris 7 /usr/bin/printf.
+as_echo='\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\'
+as_echo=$as_echo$as_echo$as_echo$as_echo$as_echo
+as_echo=$as_echo$as_echo$as_echo$as_echo$as_echo$as_echo
+# Prefer a ksh shell builtin over an external printf program on Solaris,
+# but without wasting forks for bash or zsh.
+if test -z "$BASH_VERSION$ZSH_VERSION" \
+    && (test "X`print -r -- $as_echo`" = "X$as_echo") 2>/dev/null; then
+  as_echo='print -r --'
+  as_echo_n='print -rn --'
+elif (test "X`printf %s $as_echo`" = "X$as_echo") 2>/dev/null; then
+  as_echo='printf %s\n'
+  as_echo_n='printf %s'
+else
+  if test "X`(/usr/ucb/echo -n -n $as_echo) 2>/dev/null`" = "X-n $as_echo"; then
+    as_echo_body='eval /usr/ucb/echo -n "$1$as_nl"'
+    as_echo_n='/usr/ucb/echo -n'
+  else
+    as_echo_body='eval expr "X$1" : "X\\(.*\\)"'
+    as_echo_n_body='eval
+      arg=$1;
+      case $arg in #(
+      *"$as_nl"*)
+	expr "X$arg" : "X\\(.*\\)$as_nl";
+	arg=`expr "X$arg" : ".*$as_nl\\(.*\\)"`;;
+      esac;
+      expr "X$arg" : "X\\(.*\\)" | tr -d "$as_nl"
+    '
+    export as_echo_n_body
+    as_echo_n='sh -c $as_echo_n_body as_echo'
+  fi
+  export as_echo_body
+  as_echo='sh -c $as_echo_body as_echo'
+fi
+
+# The user is always right.
+if test "${PATH_SEPARATOR+set}" != set; then
+  PATH_SEPARATOR=:
+  (PATH='/bin;/bin'; FPATH=$PATH; sh -c :) >/dev/null 2>&1 && {
+    (PATH='/bin:/bin'; FPATH=$PATH; sh -c :) >/dev/null 2>&1 ||
+      PATH_SEPARATOR=';'
+  }
+fi
+
+
+# IFS
+# We need space, tab and new line, in precisely that order.  Quoting is
+# there to prevent editors from complaining about space-tab.
+# (If _AS_PATH_WALK were called with IFS unset, it would disable word
+# splitting by setting IFS to empty value.)
+IFS=" ""	$as_nl"
+
+# Find who we are.  Look in the path if we contain no directory separator.
+as_myself=
+case $0 in #((
+  *[\\/]* ) as_myself=$0 ;;
+  *) as_save_IFS=$IFS; IFS=$PATH_SEPARATOR
+for as_dir in $PATH
+do
+  IFS=$as_save_IFS
+  test -z "$as_dir" && as_dir=.
+    test -r "$as_dir/$0" && as_myself=$as_dir/$0 && break
+  done
+IFS=$as_save_IFS
+
+     ;;
+esac
+# We did not find ourselves, most probably we were run as `sh COMMAND'
+# in which case we are not to be found in the path.
+if test "x$as_myself" = x; then
+  as_myself=$0
+fi
+if test ! -f "$as_myself"; then
+  $as_echo "$as_myself: error: cannot find myself; rerun with an absolute file name" >&2
+  exit 1
+fi
+
+# Unset variables that we do not need and which cause bugs (e.g. in
+# pre-3.0 UWIN ksh).  But do not cause bugs in bash 2.01; the "|| exit 1"
+# suppresses any "Segmentation fault" message there.  '((' could
+# trigger a bug in pdksh 5.2.14.
+for as_var in BASH_ENV ENV MAIL MAILPATH
+do eval test x\${$as_var+set} = xset \
+  && ( (unset $as_var) || exit 1) >/dev/null 2>&1 && unset $as_var || :
+done
+PS1='$ '
+PS2='> '
+PS4='+ '
+
+# NLS nuisances.
+LC_ALL=C
+export LC_ALL
+LANGUAGE=C
+export LANGUAGE
+
+# CDPATH.
+(unset CDPATH) >/dev/null 2>&1 && unset CDPATH
+
+
+# as_fn_error STATUS ERROR [LINENO LOG_FD]
+# ----------------------------------------
+# Output "`basename $0`: error: ERROR" to stderr. If LINENO and LOG_FD are
+# provided, also output the error to LOG_FD, referencing LINENO. Then exit the
+# script with STATUS, using 1 if that was 0.
+as_fn_error ()
+{
+  as_status=$1; test $as_status -eq 0 && as_status=1
+  if test "$4"; then
+    as_lineno=${as_lineno-"$3"} as_lineno_stack=as_lineno_stack=$as_lineno_stack
+    $as_echo "$as_me:${as_lineno-$LINENO}: error: $2" >&$4
+  fi
+  $as_echo "$as_me: error: $2" >&2
+  as_fn_exit $as_status
+} # as_fn_error
+
+
+# as_fn_set_status STATUS
+# -----------------------
+# Set $? to STATUS, without forking.
+as_fn_set_status ()
+{
+  return $1
+} # as_fn_set_status
+
+# as_fn_exit STATUS
+# -----------------
+# Exit the shell with STATUS, even in a "trap 0" or "set -e" context.
+as_fn_exit ()
+{
+  set +e
+  as_fn_set_status $1
+  exit $1
+} # as_fn_exit
+
+# as_fn_unset VAR
+# ---------------
+# Portably unset VAR.
+as_fn_unset ()
+{
+  { eval $1=; unset $1;}
+}
+as_unset=as_fn_unset
+# as_fn_append VAR VALUE
+# ----------------------
+# Append the text in VALUE to the end of the definition contained in VAR. Take
+# advantage of any shell optimizations that allow amortized linear growth over
+# repeated appends, instead of the typical quadratic growth present in naive
+# implementations.
+if (eval "as_var=1; as_var+=2; test x\$as_var = x12") 2>/dev/null; then :
+  eval 'as_fn_append ()
+  {
+    eval $1+=\$2
+  }'
+else
+  as_fn_append ()
+  {
+    eval $1=\$$1\$2
+  }
+fi # as_fn_append
+
+# as_fn_arith ARG...
+# ------------------
+# Perform arithmetic evaluation on the ARGs, and store the result in the
+# global $as_val. Take advantage of shells that can avoid forks. The arguments
+# must be portable across $(()) and expr.
+if (eval "test \$(( 1 + 1 )) = 2") 2>/dev/null; then :
+  eval 'as_fn_arith ()
+  {
+    as_val=$(( $* ))
+  }'
+else
+  as_fn_arith ()
+  {
+    as_val=`expr "$@" || test $? -eq 1`
+  }
+fi # as_fn_arith
+
+
+if expr a : '\(a\)' >/dev/null 2>&1 &&
+   test "X`expr 00001 : '.*\(...\)'`" = X001; then
+  as_expr=expr
+else
+  as_expr=false
+fi
+
+if (basename -- /) >/dev/null 2>&1 && test "X`basename -- / 2>&1`" = "X/"; then
+  as_basename=basename
+else
+  as_basename=false
+fi
+
+if (as_dir=`dirname -- /` && test "X$as_dir" = X/) >/dev/null 2>&1; then
+  as_dirname=dirname
+else
+  as_dirname=false
+fi
+
+as_me=`$as_basename -- "$0" ||
+$as_expr X/"$0" : '.*/\([^/][^/]*\)/*$' \| \
+	 X"$0" : 'X\(//\)$' \| \
+	 X"$0" : 'X\(/\)' \| . 2>/dev/null ||
+$as_echo X/"$0" |
+    sed '/^.*\/\([^/][^/]*\)\/*$/{
+	    s//\1/
+	    q
+	  }
+	  /^X\/\(\/\/\)$/{
+	    s//\1/
+	    q
+	  }
+	  /^X\/\(\/\).*/{
+	    s//\1/
+	    q
+	  }
+	  s/.*/./; q'`
+
+# Avoid depending upon Character Ranges.
+as_cr_letters='abcdefghijklmnopqrstuvwxyz'
+as_cr_LETTERS='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
+as_cr_Letters=$as_cr_letters$as_cr_LETTERS
+as_cr_digits='0123456789'
+as_cr_alnum=$as_cr_Letters$as_cr_digits
+
+ECHO_C= ECHO_N= ECHO_T=
+case `echo -n x` in #(((((
+-n*)
+  case `echo 'xy\c'` in
+  *c*) ECHO_T='	';;	# ECHO_T is single tab character.
+  xy)  ECHO_C='\c';;
+  *)   echo `echo ksh88 bug on AIX 6.1` > /dev/null
+       ECHO_T='	';;
+  esac;;
+*)
+  ECHO_N='-n';;
+esac
+
+rm -f conf$$ conf$$.exe conf$$.file
+if test -d conf$$.dir; then
+  rm -f conf$$.dir/conf$$.file
+else
+  rm -f conf$$.dir
+  mkdir conf$$.dir 2>/dev/null
+fi
+if (echo >conf$$.file) 2>/dev/null; then
+  if ln -s conf$$.file conf$$ 2>/dev/null; then
+    as_ln_s='ln -s'
+    # ... but there are two gotchas:
+    # 1) On MSYS, both `ln -s file dir' and `ln file dir' fail.
+    # 2) DJGPP < 2.04 has no symlinks; `ln -s' creates a wrapper executable.
+    # In both cases, we have to default to `cp -pR'.
+    ln -s conf$$.file conf$$.dir 2>/dev/null && test ! -f conf$$.exe ||
+      as_ln_s='cp -pR'
+  elif ln conf$$.file conf$$ 2>/dev/null; then
+    as_ln_s=ln
+  else
+    as_ln_s='cp -pR'
+  fi
+else
+  as_ln_s='cp -pR'
+fi
+rm -f conf$$ conf$$.exe conf$$.dir/conf$$.file conf$$.file
+rmdir conf$$.dir 2>/dev/null
+
+
+# as_fn_mkdir_p
+# -------------
+# Create "$as_dir" as a directory, including parents if necessary.
+as_fn_mkdir_p ()
+{
+
+  case $as_dir in #(
+  -*) as_dir=./$as_dir;;
+  esac
+  test -d "$as_dir" || eval $as_mkdir_p || {
+    as_dirs=
+    while :; do
+      case $as_dir in #(
+      *\'*) as_qdir=`$as_echo "$as_dir" | sed "s/'/'\\\\\\\\''/g"`;; #'(
+      *) as_qdir=$as_dir;;
+      esac
+      as_dirs="'$as_qdir' $as_dirs"
+      as_dir=`$as_dirname -- "$as_dir" ||
+$as_expr X"$as_dir" : 'X\(.*[^/]\)//*[^/][^/]*/*$' \| \
+	 X"$as_dir" : 'X\(//\)[^/]' \| \
+	 X"$as_dir" : 'X\(//\)$' \| \
+	 X"$as_dir" : 'X\(/\)' \| . 2>/dev/null ||
+$as_echo X"$as_dir" |
+    sed '/^X\(.*[^/]\)\/\/*[^/][^/]*\/*$/{
+	    s//\1/
+	    q
+	  }
+	  /^X\(\/\/\)[^/].*/{
+	    s//\1/
+	    q
+	  }
+	  /^X\(\/\/\)$/{
+	    s//\1/
+	    q
+	  }
+	  /^X\(\/\).*/{
+	    s//\1/
+	    q
+	  }
+	  s/.*/./; q'`
+      test -d "$as_dir" && break
+    done
+    test -z "$as_dirs" || eval "mkdir $as_dirs"
+  } || test -d "$as_dir" || as_fn_error $? "cannot create directory $as_dir"
+
+
+} # as_fn_mkdir_p
+if mkdir -p . 2>/dev/null; then
+  as_mkdir_p='mkdir -p "$as_dir"'
+else
+  test -d ./-p && rmdir ./-p
+  as_mkdir_p=false
+fi
+
+
+# as_fn_executable_p FILE
+# -----------------------
+# Test if FILE is an executable regular file.
+as_fn_executable_p ()
+{
+  test -f "$1" && test -x "$1"
+} # as_fn_executable_p
+as_test_x='test -x'
+as_executable_p=as_fn_executable_p
+
+# Sed expression to map a string onto a valid CPP name.
+as_tr_cpp="eval sed 'y%*$as_cr_letters%P$as_cr_LETTERS%;s%[^_$as_cr_alnum]%_%g'"
+
+# Sed expression to map a string onto a valid variable name.
+as_tr_sh="eval sed 'y%*+%pp%;s%[^_$as_cr_alnum]%_%g'"
+
+
+exec 6>&1
+## ----------------------------------- ##
+## Main body of $CONFIG_STATUS script. ##
+## ----------------------------------- ##
+# Save the log message, to keep $0 and so on meaningful, and to
+# report actual input values of CONFIG_FILES etc. instead of their
+# values after options handling.
+ac_log="
+This file was extended by btrfs-progs $as_me v4.16.1, which was
+generated by GNU Autoconf 2.69.  Invocation command line was
+
+  CONFIG_FILES    = $CONFIG_FILES
+  CONFIG_HEADERS  = $CONFIG_HEADERS
+  CONFIG_LINKS    = $CONFIG_LINKS
+  CONFIG_COMMANDS = $CONFIG_COMMANDS
+  $ $0 $@
+
+on `(hostname || uname -n) 2>/dev/null | sed 1q`
+"
+
+# Files that config.status was made for.
+config_files=" Makefile.inc Documentation/Makefile version.h"
+config_headers=" config.h"
+
+ac_cs_usage="\
+\`$as_me' instantiates files and other configuration actions
+from templates according to the current configuration.  Unless the files
+and actions are specified as TAGs, all are instantiated by default.
+
+Usage: $0 [OPTION]... [TAG]...
+
+  -h, --help       print this help, then exit
+  -V, --version    print version number and configuration settings, then exit
+      --config     print configuration, then exit
+  -q, --quiet, --silent
+                   do not print progress messages
+  -d, --debug      don't remove temporary files
+      --recheck    update $as_me by reconfiguring in the same conditions
+      --file=FILE[:TEMPLATE]
+                   instantiate the configuration file FILE
+      --header=FILE[:TEMPLATE]
+                   instantiate the configuration header FILE
+
+Configuration files:
+$config_files
+
+Configuration headers:
+$config_headers
+
+Report bugs to <linux-btrfs@vger.kernel.org>.
+btrfs-progs home page: <http://btrfs.wiki.kernel.org>."
+
+ac_cs_config="'--disable-documentation' '--disable-convert' '--disable-zstd' '--disable-python'"
+ac_cs_version="\
+btrfs-progs config.status v4.16.1
+configured by ../configure, generated by GNU Autoconf 2.69,
+  with options \"$ac_cs_config\"
+
+Copyright (C) 2012 Free Software Foundation, Inc.
+This config.status script is free software; the Free Software Foundation
+gives unlimited permission to copy, distribute and modify it."
+
+ac_pwd='/home/mangix/devstuff/btrfs-progs/build'
+srcdir='..'
+INSTALL='/usr/bin/install -c'
+test -n "$AWK" || AWK=awk
+# The default lists apply if the user does not specify any file.
+ac_need_defaults=:
+while test $# != 0
+do
+  case $1 in
+  --*=?*)
+    ac_option=`expr "X$1" : 'X\([^=]*\)='`
+    ac_optarg=`expr "X$1" : 'X[^=]*=\(.*\)'`
+    ac_shift=:
+    ;;
+  --*=)
+    ac_option=`expr "X$1" : 'X\([^=]*\)='`
+    ac_optarg=
+    ac_shift=:
+    ;;
+  *)
+    ac_option=$1
+    ac_optarg=$2
+    ac_shift=shift
+    ;;
+  esac
+
+  case $ac_option in
+  # Handling of the options.
+  -recheck | --recheck | --rechec | --reche | --rech | --rec | --re | --r)
+    ac_cs_recheck=: ;;
+  --version | --versio | --versi | --vers | --ver | --ve | --v | -V )
+    $as_echo "$ac_cs_version"; exit ;;
+  --config | --confi | --conf | --con | --co | --c )
+    $as_echo "$ac_cs_config"; exit ;;
+  --debug | --debu | --deb | --de | --d | -d )
+    debug=: ;;
+  --file | --fil | --fi | --f )
+    $ac_shift
+    case $ac_optarg in
+    *\'*) ac_optarg=`$as_echo "$ac_optarg" | sed "s/'/'\\\\\\\\''/g"` ;;
+    '') as_fn_error $? "missing file argument" ;;
+    esac
+    as_fn_append CONFIG_FILES " '$ac_optarg'"
+    ac_need_defaults=false;;
+  --header | --heade | --head | --hea )
+    $ac_shift
+    case $ac_optarg in
+    *\'*) ac_optarg=`$as_echo "$ac_optarg" | sed "s/'/'\\\\\\\\''/g"` ;;
+    esac
+    as_fn_append CONFIG_HEADERS " '$ac_optarg'"
+    ac_need_defaults=false;;
+  --he | --h)
+    # Conflict between --help and --header
+    as_fn_error $? "ambiguous option: \`$1'
+Try \`$0 --help' for more information.";;
+  --help | --hel | -h )
+    $as_echo "$ac_cs_usage"; exit ;;
+  -q | -quiet | --quiet | --quie | --qui | --qu | --q \
+  | -silent | --silent | --silen | --sile | --sil | --si | --s)
+    ac_cs_silent=: ;;
+
+  # This is an error.
+  -*) as_fn_error $? "unrecognized option: \`$1'
+Try \`$0 --help' for more information." ;;
+
+  *) as_fn_append ac_config_targets " $1"
+     ac_need_defaults=false ;;
+
+  esac
+  shift
+done
+
+ac_configure_extra_args=
+
+if $ac_cs_silent; then
+  exec 6>/dev/null
+  ac_configure_extra_args="$ac_configure_extra_args --silent"
+fi
+
+if $ac_cs_recheck; then
+  set X /bin/sh '../configure'  '--disable-documentation' '--disable-convert' '--disable-zstd' '--disable-python' $ac_configure_extra_args --no-create --no-recursion
+  shift
+  $as_echo "running CONFIG_SHELL=/bin/sh $*" >&6
+  CONFIG_SHELL='/bin/sh'
+  export CONFIG_SHELL
+  exec "$@"
+fi
+
+exec 5>>config.log
+{
+  echo
+  sed 'h;s/./-/g;s/^.../## /;s/...$/ ##/;p;x;p;x' <<_ASBOX
+## Running $as_me. ##
+_ASBOX
+  $as_echo "$ac_log"
+} >&5
+
+
+# Handling of arguments.
+for ac_config_target in $ac_config_targets
+do
+  case $ac_config_target in
+    "config.h") CONFIG_HEADERS="$CONFIG_HEADERS config.h" ;;
+    "Makefile.inc") CONFIG_FILES="$CONFIG_FILES Makefile.inc" ;;
+    "Documentation/Makefile") CONFIG_FILES="$CONFIG_FILES Documentation/Makefile" ;;
+    "version.h") CONFIG_FILES="$CONFIG_FILES version.h" ;;
+
+  *) as_fn_error $? "invalid argument: \`$ac_config_target'" "$LINENO" 5;;
+  esac
+done
+
+
+# If the user did not use the arguments to specify the items to instantiate,
+# then the envvar interface is used.  Set only those that are not.
+# We use the long form for the default assignment because of an extremely
+# bizarre bug on SunOS 4.1.3.
+if $ac_need_defaults; then
+  test "${CONFIG_FILES+set}" = set || CONFIG_FILES=$config_files
+  test "${CONFIG_HEADERS+set}" = set || CONFIG_HEADERS=$config_headers
+fi
+
+# Have a temporary directory for convenience.  Make it in the build tree
+# simply because there is no reason against having it here, and in addition,
+# creating and moving files from /tmp can sometimes cause problems.
+# Hook for its removal unless debugging.
+# Note that there is a small window in which the directory will not be cleaned:
+# after its creation but before its name has been assigned to `$tmp'.
+$debug ||
+{
+  tmp= ac_tmp=
+  trap 'exit_status=$?
+  : "${ac_tmp:=$tmp}"
+  { test ! -d "$ac_tmp" || rm -fr "$ac_tmp"; } && exit $exit_status
+' 0
+  trap 'as_fn_exit 1' 1 2 13 15
+}
+# Create a (secure) tmp directory for tmp files.
+
+{
+  tmp=`(umask 077 && mktemp -d "./confXXXXXX") 2>/dev/null` &&
+  test -d "$tmp"
+}  ||
+{
+  tmp=./conf$$-$RANDOM
+  (umask 077 && mkdir "$tmp")
+} || as_fn_error $? "cannot create a temporary directory in ." "$LINENO" 5
+ac_tmp=$tmp
+
+# Set up the scripts for CONFIG_FILES section.
+# No need to generate them if there are no CONFIG_FILES.
+# This happens for instance with `./config.status config.h'.
+if test -n "$CONFIG_FILES"; then
+
+
+ac_cr=`echo X | tr X '\015'`
+# On cygwin, bash can eat \r inside `` if the user requested igncr.
+# But we know of no other shell where ac_cr would be empty at this
+# point, so we can use a bashism as a fallback.
+if test "x$ac_cr" = x; then
+  eval ac_cr=\$\'\\r\'
+fi
+ac_cs_awk_cr=`$AWK 'BEGIN { print "a\rb" }' </dev/null 2>/dev/null`
+if test "$ac_cs_awk_cr" = "a${ac_cr}b"; then
+  ac_cs_awk_cr='\\r'
+else
+  ac_cs_awk_cr=$ac_cr
+fi
+
+echo 'BEGIN {' >"$ac_tmp/subs1.awk" &&
+cat >>"$ac_tmp/subs1.awk" <<\_ACAWK &&
+S["LTLIBOBJS"]=""
+S["LIBOBJS"]=""
+S["LIBBTRFS_PATCHLEVEL"]="2"
+S["LIBBTRFS_MINOR"]="1"
+S["LIBBTRFS_MAJOR"]="0"
+S["LZO2_CFLAGS"]=""
+S["LZO2_LIBS_STATIC"]="-llzo2"
+S["LZO2_LIBS"]="-llzo2"
+S["UDEVDIR"]="/usr/lib/udev"
+S["PYTHON_BINDINGS"]="0"
+S["PYTHON_LIBS"]=""
+S["PYTHON_CFLAGS"]=""
+S["pkgpyexecdir"]=""
+S["pyexecdir"]=""
+S["pkgpythondir"]=""
+S["pythondir"]=""
+S["PYTHON_PLATFORM"]=""
+S["PYTHON_EXEC_PREFIX"]=""
+S["PYTHON_PREFIX"]=""
+S["PYTHON_VERSION"]=""
+S["PYTHON"]=""
+S["BTRFSRESTORE_ZSTD"]="0"
+S["ZSTD_LIBS_STATIC"]=""
+S["ZSTD_LIBS"]=""
+S["ZSTD_CFLAGS"]=""
+S["ZLIB_LIBS_STATIC"]="-lz "
+S["ZLIB_LIBS"]="-lz "
+S["ZLIB_CFLAGS"]=""
+S["UUID_LIBS_STATIC"]="-luuid "
+S["UUID_LIBS"]="-luuid "
+S["UUID_CFLAGS"]="-I/usr/include/uuid "
+S["BLKID_LIBS_STATIC"]="-lblkid -luuid "
+S["BLKID_LIBS"]="-lblkid "
+S["BLKID_CFLAGS"]="-I/usr/include/blkid -I/usr/include/uuid "
+S["BTRFSCONVERT_REISERFS"]="0"
+S["BTRFSCONVERT_EXT2"]="0"
+S["REISERFS_LIBS"]=""
+S["REISERFS_CFLAGS"]=""
+S["COM_ERR_LIBS"]=""
+S["COM_ERR_CFLAGS"]=""
+S["EXT2FS_LIBS"]=""
+S["EXT2FS_CFLAGS"]=""
+S["DISABLE_BTRFSCONVERT"]="1"
+S["ASCIIDOC_TOOL"]="none"
+S["ASCIIDOCTOR"]=""
+S["ASCIIDOC"]=""
+S["SED"]=""
+S["MV"]=""
+S["GZIP"]=""
+S["XMLTO"]=""
+S["DISABLE_DOCUMENTATION"]="1"
+S["PKG_CONFIG_LIBDIR"]=""
+S["PKG_CONFIG_PATH"]=""
+S["PKG_CONFIG"]="/usr/bin/pkg-config"
+S["RMDIR"]="/usr/bin/rmdir"
+S["RM"]="/usr/bin/rm"
+S["AR"]="ar"
+S["LN_S"]="ln -s"
+S["INSTALL_DATA"]="${INSTALL} -m 644"
+S["INSTALL_SCRIPT"]="${INSTALL}"
+S["INSTALL_PROGRAM"]="${INSTALL}"
+S["host_os"]="linux-gnu"
+S["host_vendor"]="pc"
+S["host_cpu"]="x86_64"
+S["host"]="x86_64-pc-linux-gnu"
+S["build_os"]="linux-gnu"
+S["build_vendor"]="pc"
+S["build_cpu"]="x86_64"
+S["build"]="x86_64-pc-linux-gnu"
+S["EGREP"]="/usr/bin/grep -E"
+S["GREP"]="/usr/bin/grep"
+S["CPP"]="gcc -E"
+S["OBJEXT"]="o"
+S["EXEEXT"]=""
+S["ac_ct_CC"]="gcc"
+S["CPPFLAGS"]=""
+S["LDFLAGS"]=""
+S["CC"]="gcc"
+S["CFLAGS"]="-g -O1 -Wall -D_FORTIFY_SOURCE=2"
+S["target_alias"]=""
+S["host_alias"]=""
+S["build_alias"]=""
+S["LIBS"]=""
+S["ECHO_T"]=""
+S["ECHO_N"]="-n"
+S["ECHO_C"]=""
+S["DEFS"]="-DHAVE_CONFIG_H"
+S["mandir"]="${datarootdir}/man"
+S["localedir"]="${datarootdir}/locale"
+S["libdir"]="${exec_prefix}/lib"
+S["psdir"]="${docdir}"
+S["pdfdir"]="${docdir}"
+S["dvidir"]="${docdir}"
+S["htmldir"]="${docdir}"
+S["infodir"]="${datarootdir}/info"
+S["docdir"]="${datarootdir}/doc/${PACKAGE_TARNAME}"
+S["oldincludedir"]="/usr/include"
+S["includedir"]="${prefix}/include"
+S["localstatedir"]="${prefix}/var"
+S["sharedstatedir"]="${prefix}/com"
+S["sysconfdir"]="${prefix}/etc"
+S["datadir"]="${datarootdir}"
+S["datarootdir"]="${prefix}/share"
+S["libexecdir"]="${exec_prefix}/libexec"
+S["sbindir"]="${exec_prefix}/sbin"
+S["bindir"]="${exec_prefix}/bin"
+S["program_transform_name"]="s,x,x,"
+S["prefix"]="/usr/local"
+S["exec_prefix"]="${prefix}"
+S["PACKAGE_URL"]="http://btrfs.wiki.kernel.org"
+S["PACKAGE_BUGREPORT"]="linux-btrfs@vger.kernel.org"
+S["PACKAGE_STRING"]="btrfs-progs v4.16.1"
+S["PACKAGE_VERSION"]="v4.16.1"
+S["PACKAGE_TARNAME"]="btrfs-progs"
+S["PACKAGE_NAME"]="btrfs-progs"
+S["PATH_SEPARATOR"]=":"
+S["SHELL"]="/bin/sh"
+_ACAWK
+cat >>"$ac_tmp/subs1.awk" <<_ACAWK &&
+  for (key in S) S_is_set[key] = 1
+  FS = ""
+
+}
+{
+  line = $ 0
+  nfields = split(line, field, "@")
+  substed = 0
+  len = length(field[1])
+  for (i = 2; i < nfields; i++) {
+    key = field[i]
+    keylen = length(key)
+    if (S_is_set[key]) {
+      value = S[key]
+      line = substr(line, 1, len) "" value "" substr(line, len + keylen + 3)
+      len += length(value) + length(field[++i])
+      substed = 1
+    } else
+      len += 1 + keylen
+  }
+
+  print line
+}
+
+_ACAWK
+if sed "s/$ac_cr//" < /dev/null > /dev/null 2>&1; then
+  sed "s/$ac_cr\$//; s/$ac_cr/$ac_cs_awk_cr/g"
+else
+  cat
+fi < "$ac_tmp/subs1.awk" > "$ac_tmp/subs.awk" \
+  || as_fn_error $? "could not setup config files machinery" "$LINENO" 5
+fi # test -n "$CONFIG_FILES"
+
+# Set up the scripts for CONFIG_HEADERS section.
+# No need to generate them if there are no CONFIG_HEADERS.
+# This happens for instance with `./config.status Makefile'.
+if test -n "$CONFIG_HEADERS"; then
+cat >"$ac_tmp/defines.awk" <<\_ACAWK ||
+BEGIN {
+D["PACKAGE_NAME"]=" \"btrfs-progs\""
+D["PACKAGE_TARNAME"]=" \"btrfs-progs\""
+D["PACKAGE_VERSION"]=" \"v4.16.1\""
+D["PACKAGE_STRING"]=" \"btrfs-progs v4.16.1\""
+D["PACKAGE_BUGREPORT"]=" \"linux-btrfs@vger.kernel.org\""
+D["PACKAGE_URL"]=" \"http://btrfs.wiki.kernel.org\""
+D["STDC_HEADERS"]=" 1"
+D["HAVE_SYS_TYPES_H"]=" 1"
+D["HAVE_SYS_STAT_H"]=" 1"
+D["HAVE_STDLIB_H"]=" 1"
+D["HAVE_STRING_H"]=" 1"
+D["HAVE_MEMORY_H"]=" 1"
+D["HAVE_STRINGS_H"]=" 1"
+D["HAVE_INTTYPES_H"]=" 1"
+D["HAVE_STDINT_H"]=" 1"
+D["HAVE_UNISTD_H"]=" 1"
+D["__EXTENSIONS__"]=" 1"
+D["_ALL_SOURCE"]=" 1"
+D["_GNU_SOURCE"]=" 1"
+D["_POSIX_PTHREAD_SEMANTICS"]=" 1"
+D["_TANDEM_SOURCE"]=" 1"
+D["HAVE_OPENAT"]=" 1"
+D["HAVE_REALLOCARRAY"]=" 1"
+D["HAVE_EXECINFO_H"]=" 1"
+D["HAVE_BACKTRACE"]=" 1"
+D["HAVE_BACKTRACE_SYMBOLS_FD"]=" 1"
+D["HAVE_OWN_FIEMAP_EXTENT_SHARED_DEFINE"]=" 0"
+  for (key in D) D_is_set[key] = 1
+  FS = ""
+}
+/^[\t ]*#[\t ]*(define|undef)[\t ]+[_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ][_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789]*([\t (]|$)/ {
+  line = $ 0
+  split(line, arg, " ")
+  if (arg[1] == "#") {
+    defundef = arg[2]
+    mac1 = arg[3]
+  } else {
+    defundef = substr(arg[1], 2)
+    mac1 = arg[2]
+  }
+  split(mac1, mac2, "(") #)
+  macro = mac2[1]
+  prefix = substr(line, 1, index(line, defundef) - 1)
+  if (D_is_set[macro]) {
+    # Preserve the white space surrounding the "#".
+    print prefix "define", macro P[macro] D[macro]
+    next
+  } else {
+    # Replace #undef with comments.  This is necessary, for example,
+    # in the case of _POSIX_SOURCE, which is predefined and required
+    # on some systems where configure will not decide to define it.
+    if (defundef == "undef") {
+      print "/*", prefix defundef, macro, "*/"
+      next
+    }
+  }
+}
+{ print }
+_ACAWK
+  as_fn_error $? "could not setup config headers machinery" "$LINENO" 5
+fi # test -n "$CONFIG_HEADERS"
+
+
+eval set X "  :F $CONFIG_FILES  :H $CONFIG_HEADERS    "
+shift
+for ac_tag
+do
+  case $ac_tag in
+  :[FHLC]) ac_mode=$ac_tag; continue;;
+  esac
+  case $ac_mode$ac_tag in
+  :[FHL]*:*);;
+  :L* | :C*:*) as_fn_error $? "invalid tag \`$ac_tag'" "$LINENO" 5;;
+  :[FH]-) ac_tag=-:-;;
+  :[FH]*) ac_tag=$ac_tag:$ac_tag.in;;
+  esac
+  ac_save_IFS=$IFS
+  IFS=:
+  set x $ac_tag
+  IFS=$ac_save_IFS
+  shift
+  ac_file=$1
+  shift
+
+  case $ac_mode in
+  :L) ac_source=$1;;
+  :[FH])
+    ac_file_inputs=
+    for ac_f
+    do
+      case $ac_f in
+      -) ac_f="$ac_tmp/stdin";;
+      *) # Look for the file first in the build tree, then in the source tree
+	 # (if the path is not absolute).  The absolute path cannot be DOS-style,
+	 # because $ac_f cannot contain `:'.
+	 test -f "$ac_f" ||
+	   case $ac_f in
+	   [\\/$]*) false;;
+	   *) test -f "$srcdir/$ac_f" && ac_f="$srcdir/$ac_f";;
+	   esac ||
+	   as_fn_error 1 "cannot find input file: \`$ac_f'" "$LINENO" 5;;
+      esac
+      case $ac_f in *\'*) ac_f=`$as_echo "$ac_f" | sed "s/'/'\\\\\\\\''/g"`;; esac
+      as_fn_append ac_file_inputs " '$ac_f'"
+    done
+
+    # Let's still pretend it is `configure' which instantiates (i.e., don't
+    # use $as_me), people would be surprised to read:
+    #    /* config.h.  Generated by config.status.  */
+    configure_input='Generated from '`
+	  $as_echo "$*" | sed 's|^[^:]*/||;s|:[^:]*/|, |g'
+	`' by configure.'
+    if test x"$ac_file" != x-; then
+      configure_input="$ac_file.  $configure_input"
+      { $as_echo "$as_me:${as_lineno-$LINENO}: creating $ac_file" >&5
+$as_echo "$as_me: creating $ac_file" >&6;}
+    fi
+    # Neutralize special characters interpreted by sed in replacement strings.
+    case $configure_input in #(
+    *\&* | *\|* | *\\* )
+       ac_sed_conf_input=`$as_echo "$configure_input" |
+       sed 's/[\\\\&|]/\\\\&/g'`;; #(
+    *) ac_sed_conf_input=$configure_input;;
+    esac
+
+    case $ac_tag in
+    *:-:* | *:-) cat >"$ac_tmp/stdin" \
+      || as_fn_error $? "could not create $ac_file" "$LINENO" 5 ;;
+    esac
+    ;;
+  esac
+
+  ac_dir=`$as_dirname -- "$ac_file" ||
+$as_expr X"$ac_file" : 'X\(.*[^/]\)//*[^/][^/]*/*$' \| \
+	 X"$ac_file" : 'X\(//\)[^/]' \| \
+	 X"$ac_file" : 'X\(//\)$' \| \
+	 X"$ac_file" : 'X\(/\)' \| . 2>/dev/null ||
+$as_echo X"$ac_file" |
+    sed '/^X\(.*[^/]\)\/\/*[^/][^/]*\/*$/{
+	    s//\1/
+	    q
+	  }
+	  /^X\(\/\/\)[^/].*/{
+	    s//\1/
+	    q
+	  }
+	  /^X\(\/\/\)$/{
+	    s//\1/
+	    q
+	  }
+	  /^X\(\/\).*/{
+	    s//\1/
+	    q
+	  }
+	  s/.*/./; q'`
+  as_dir="$ac_dir"; as_fn_mkdir_p
+  ac_builddir=.
+
+case "$ac_dir" in
+.) ac_dir_suffix= ac_top_builddir_sub=. ac_top_build_prefix= ;;
+*)
+  ac_dir_suffix=/`$as_echo "$ac_dir" | sed 's|^\.[\\/]||'`
+  # A ".." for each directory in $ac_dir_suffix.
+  ac_top_builddir_sub=`$as_echo "$ac_dir_suffix" | sed 's|/[^\\/]*|/..|g;s|/||'`
+  case $ac_top_builddir_sub in
+  "") ac_top_builddir_sub=. ac_top_build_prefix= ;;
+  *)  ac_top_build_prefix=$ac_top_builddir_sub/ ;;
+  esac ;;
+esac
+ac_abs_top_builddir=$ac_pwd
+ac_abs_builddir=$ac_pwd$ac_dir_suffix
+# for backward compatibility:
+ac_top_builddir=$ac_top_build_prefix
+
+case $srcdir in
+  .)  # We are building in place.
+    ac_srcdir=.
+    ac_top_srcdir=$ac_top_builddir_sub
+    ac_abs_top_srcdir=$ac_pwd ;;
+  [\\/]* | ?:[\\/]* )  # Absolute name.
+    ac_srcdir=$srcdir$ac_dir_suffix;
+    ac_top_srcdir=$srcdir
+    ac_abs_top_srcdir=$srcdir ;;
+  *) # Relative name.
+    ac_srcdir=$ac_top_build_prefix$srcdir$ac_dir_suffix
+    ac_top_srcdir=$ac_top_build_prefix$srcdir
+    ac_abs_top_srcdir=$ac_pwd/$srcdir ;;
+esac
+ac_abs_srcdir=$ac_abs_top_srcdir$ac_dir_suffix
+
+
+  case $ac_mode in
+  :F)
+  #
+  # CONFIG_FILE
+  #
+
+  case $INSTALL in
+  [\\/$]* | ?:[\\/]* ) ac_INSTALL=$INSTALL ;;
+  *) ac_INSTALL=$ac_top_build_prefix$INSTALL ;;
+  esac
+# If the template does not know about datarootdir, expand it.
+# FIXME: This hack should be removed a few years after 2.60.
+ac_datarootdir_hack=; ac_datarootdir_seen=
+ac_sed_dataroot='
+/datarootdir/ {
+  p
+  q
+}
+/@datadir@/p
+/@docdir@/p
+/@infodir@/p
+/@localedir@/p
+/@mandir@/p'
+case `eval "sed -n \"\$ac_sed_dataroot\" $ac_file_inputs"` in
+*datarootdir*) ac_datarootdir_seen=yes;;
+*@datadir@*|*@docdir@*|*@infodir@*|*@localedir@*|*@mandir@*)
+  { $as_echo "$as_me:${as_lineno-$LINENO}: WARNING: $ac_file_inputs seems to ignore the --datarootdir setting" >&5
+$as_echo "$as_me: WARNING: $ac_file_inputs seems to ignore the --datarootdir setting" >&2;}
+  ac_datarootdir_hack='
+  s&@datadir@&${datarootdir}&g
+  s&@docdir@&${datarootdir}/doc/${PACKAGE_TARNAME}&g
+  s&@infodir@&${datarootdir}/info&g
+  s&@localedir@&${datarootdir}/locale&g
+  s&@mandir@&${datarootdir}/man&g
+  s&\${datarootdir}&${prefix}/share&g' ;;
+esac
+ac_sed_extra="
+
+:t
+/@[a-zA-Z_][a-zA-Z_0-9]*@/!b
+s|@configure_input@|$ac_sed_conf_input|;t t
+s&@top_builddir@&$ac_top_builddir_sub&;t t
+s&@top_build_prefix@&$ac_top_build_prefix&;t t
+s&@srcdir@&$ac_srcdir&;t t
+s&@abs_srcdir@&$ac_abs_srcdir&;t t
+s&@top_srcdir@&$ac_top_srcdir&;t t
+s&@abs_top_srcdir@&$ac_abs_top_srcdir&;t t
+s&@builddir@&$ac_builddir&;t t
+s&@abs_builddir@&$ac_abs_builddir&;t t
+s&@abs_top_builddir@&$ac_abs_top_builddir&;t t
+s&@INSTALL@&$ac_INSTALL&;t t
+$ac_datarootdir_hack
+"
+eval sed \"\$ac_sed_extra\" "$ac_file_inputs" | $AWK -f "$ac_tmp/subs.awk" \
+  >$ac_tmp/out || as_fn_error $? "could not create $ac_file" "$LINENO" 5
+
+test -z "$ac_datarootdir_hack$ac_datarootdir_seen" &&
+  { ac_out=`sed -n '/\${datarootdir}/p' "$ac_tmp/out"`; test -n "$ac_out"; } &&
+  { ac_out=`sed -n '/^[	 ]*datarootdir[	 ]*:*=/p' \
+      "$ac_tmp/out"`; test -z "$ac_out"; } &&
+  { $as_echo "$as_me:${as_lineno-$LINENO}: WARNING: $ac_file contains a reference to the variable \`datarootdir'
+which seems to be undefined.  Please make sure it is defined" >&5
+$as_echo "$as_me: WARNING: $ac_file contains a reference to the variable \`datarootdir'
+which seems to be undefined.  Please make sure it is defined" >&2;}
+
+  rm -f "$ac_tmp/stdin"
+  case $ac_file in
+  -) cat "$ac_tmp/out" && rm -f "$ac_tmp/out";;
+  *) rm -f "$ac_file" && mv "$ac_tmp/out" "$ac_file";;
+  esac \
+  || as_fn_error $? "could not create $ac_file" "$LINENO" 5
+ ;;
+  :H)
+  #
+  # CONFIG_HEADER
+  #
+  if test x"$ac_file" != x-; then
+    {
+      $as_echo "/* $configure_input  */" \
+      && eval '$AWK -f "$ac_tmp/defines.awk"' "$ac_file_inputs"
+    } >"$ac_tmp/config.h" \
+      || as_fn_error $? "could not create $ac_file" "$LINENO" 5
+    if diff "$ac_file" "$ac_tmp/config.h" >/dev/null 2>&1; then
+      { $as_echo "$as_me:${as_lineno-$LINENO}: $ac_file is unchanged" >&5
+$as_echo "$as_me: $ac_file is unchanged" >&6;}
+    else
+      rm -f "$ac_file"
+      mv "$ac_tmp/config.h" "$ac_file" \
+	|| as_fn_error $? "could not create $ac_file" "$LINENO" 5
+    fi
+  else
+    $as_echo "/* $configure_input  */" \
+      && eval '$AWK -f "$ac_tmp/defines.awk"' "$ac_file_inputs" \
+      || as_fn_error $? "could not create -" "$LINENO" 5
+  fi
+ ;;
+
+
+  esac
+
+done # for ac_tag
+
+
+as_fn_exit 0
diff --git a/build/version.h b/build/version.h
new file mode 100644
index 00000000..4bb00eae
--- /dev/null
+++ b/build/version.h
@@ -0,0 +1,14 @@
+#ifndef __LIBBTRFS_VERSION_H__
+#define __LIBBTRFS_VERSION_H__
+
+#define BTRFS_LIB_MAJOR		0
+#define BTRFS_LIB_MINOR		1
+#define BTRFS_LIB_PATCHLEVEL	2
+
+#define BTRFS_LIB_VERSION ( BTRFS_LIB_MAJOR * 10000 + \
+                            BTRFS_LIB_MINOR * 100 + \
+                            BTRFS_LIB_PATCHLEVEL )
+
+#define BTRFS_BUILD_VERSION "Btrfs v4.16.1"
+
+#endif
diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 7234bdc1..10859c82 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -380,8 +380,7 @@ static int cmd_qgroup_show(int argc, char **argv)
 	if (sync) {
 		err = btrfs_util_sync_fd(fd);
 		if (err)
-			warning("sync ioctl failed on '%s': %s", path,
-				strerror(errno));
+			warning("sync ioctl failed on '%s': %m", path);
 	}
 
 	if (filter_flag) {
diff --git a/messages.h b/messages.h
index 2b97aa08..ec7d9338 100644
--- a/messages.h
+++ b/messages.h
@@ -61,9 +61,9 @@
 		PRINT_TRACE_ON_ERROR;					\
 		PRINT_VERBOSE_ERROR;					\
 		if (lib_str && strcmp(errno_str, lib_str) != 0)		\
-			__btrfs_error("%s: %s", lib_str, errno_str);	\
+			__btrfs_error("%s: %m", lib_str);		\
 		else							\
-			__btrfs_error("%s", errno_str);			\
+			__btrfs_error("%m");				\
 		DO_ABORT_ON_ERROR;					\
 	} while (0)
 
diff --git a/mkfs/rootdir.c b/mkfs/rootdir.c
index c430bac6..74c46241 100644
--- a/mkfs/rootdir.c
+++ b/mkfs/rootdir.c
@@ -237,8 +237,7 @@ static int add_xattr_item(struct btrfs_trans_handle *trans,
 	if (ret < 0) {
 		if (errno == ENOTSUP)
 			return 0;
-		error("getting a list of xattr failed for %s: %s", file_name,
-				strerror(errno));
+		error("getting a list of xattr failed for %s: %m", file_name);
 		return ret;
 	}
 	if (ret == 0)
@@ -253,8 +252,8 @@ static int add_xattr_item(struct btrfs_trans_handle *trans,
 		if (ret < 0) {
 			if (errno == ENOTSUP)
 				return 0;
-			error("getting a xattr value failed for %s attr %s: %s",
-				file_name, cur_name, strerror(errno));
+			error("getting a xattr value failed for %s attr %s: %m",
+				file_name, cur_name);
 			return ret;
 		}
 
@@ -281,7 +280,7 @@ static int add_symbolic_link(struct btrfs_trans_handle *trans,
 
 	ret = readlink(path_name, buf, sizeof(buf));
 	if (ret <= 0) {
-		error("readlink failed for %s: %s", path_name, strerror(errno));
+		error("readlink failed for %s: %m", path_name);
 		goto fail;
 	}
 	if (ret >= sizeof(buf)) {
@@ -320,7 +319,7 @@ static int add_file_items(struct btrfs_trans_handle *trans,
 
 	fd = open(path_name, O_RDONLY);
 	if (fd == -1) {
-		error("cannot open %s: %s", path_name, strerror(errno));
+		error("cannot open %s: %m", path_name);
 		return ret;
 	}
 
@@ -339,10 +338,9 @@ static int add_file_items(struct btrfs_trans_handle *trans,
 
 		ret_read = pread64(fd, buffer, st->st_size, bytes_read);
 		if (ret_read == -1) {
-			error("cannot read %s at offset %llu length %llu: %s",
+			error("cannot read %s at offset %llu length %llu: %m",
 				path_name, (unsigned long long)bytes_read,
-				(unsigned long long)st->st_size,
-				strerror(errno));
+				(unsigned long long)st->st_size);
 			free(buffer);
 			goto end;
 		}
@@ -388,11 +386,10 @@ again:
 		ret_read = pread64(fd, eb->data, sectorsize, file_pos +
 				   bytes_read);
 		if (ret_read == -1) {
-			error("cannot read %s at offset %llu length %llu: %s",
+			error("cannot read %s at offset %llu length %llu: %m",
 				path_name,
 				(unsigned long long)file_pos + bytes_read,
-				(unsigned long long)sectorsize,
-				strerror(errno));
+				(unsigned long long)sectorsize);
 			goto end;
 		}
 
@@ -467,7 +464,7 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
 	dir_entry->dir_name = dir_name;
 	dir_entry->path = realpath(dir_name, NULL);
 	if (!dir_entry->path) {
-		error("realpath failed for %s: %s", dir_name, strerror(errno));
+		error("realpath failed for %s: %m", dir_name);
 		ret = -1;
 		goto fail_no_dir;
 	}
@@ -506,8 +503,8 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
 		parent_inum = parent_dir_entry->inum;
 		parent_dir_name = parent_dir_entry->dir_name;
 		if (chdir(parent_dir_entry->path)) {
-			error("chdir failed for %s: %s",
-				parent_dir_name, strerror(errno));
+			error("chdir failed for %s: %m",
+				parent_dir_name);
 			ret = -1;
 			goto fail_no_files;
 		}
@@ -515,8 +512,8 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
 		count = scandir(parent_dir_entry->path, &files,
 				directory_select, NULL);
 		if (count == -1) {
-			error("scandir failed for %s: %s",
-				parent_dir_name, strerror(errno));
+			error("scandir failed for %s: %m",
+				parent_dir_name);
 			ret = -1;
 			goto fail;
 		}
@@ -525,8 +522,8 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
 			cur_file = files[i];
 
 			if (lstat(cur_file->d_name, &st) == -1) {
-				error("lstat failed for %s: %s",
-					cur_file->d_name, strerror(errno));
+				error("lstat failed for %s: %m",
+					cur_file->d_name);
 				ret = -1;
 				goto fail;
 			}
@@ -648,7 +645,7 @@ int btrfs_mkfs_fill_dir(const char *source_dir, struct btrfs_root *root,
 
 	ret = lstat(source_dir, &root_st);
 	if (ret) {
-		error("unable to lstat %s: %s", source_dir, strerror(errno));
+		error("unable to lstat %s: %m", source_dir);
 		ret = -errno;
 		goto out;
 	}
@@ -739,8 +736,7 @@ u64 btrfs_mkfs_size_dir(const char *dir_name, u32 sectorsize, u64 min_dev_size,
 	 */
 	ret = nftw(dir_name, ftw_add_entry_size, 10, FTW_PHYS);
 	if (ret < 0) {
-		error("ftw subdir walk of %s failed: %s", dir_name,
-			strerror(errno));
+		error("ftw subdir walk of %s failed: %m", dir_name);
 		exit(1);
 	}
 
@@ -946,16 +942,15 @@ int btrfs_mkfs_shrink_fs(struct btrfs_fs_info *fs_info, u64 *new_size_ret,
 	if (shrink_file_size) {
 		ret = fstat64(device->fd, &file_stat);
 		if (ret < 0) {
-			error("failed to stat devid %llu: %s", device->devid,
-				strerror(errno));
+			error("failed to stat devid %llu: %m", device->devid);
 			return ret;
 		}
 		if (!S_ISREG(file_stat.st_mode))
 			return ret;
 		ret = ftruncate64(device->fd, new_size);
 		if (ret < 0) {
-			error("failed to truncate device file of devid %llu: %s",
-				device->devid, strerror(errno));
+			error("failed to truncate device file of devid %llu: %m",
+				device->devid);
 			return ret;
 		}
 	}
diff --git a/qgroup.c b/qgroup.c
index 3269feb2..2cfd6dbd 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -1072,8 +1072,7 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
 				error("can't list qgroups: quotas not enabled");
 				ret = -ENOTTY;
 			} else {
-				error("can't list qgroups: %s",
-				       strerror(errno));
+				error("can't list qgroups: %m");
 				ret = -errno;
 			}
 
-- 
2.17.1
