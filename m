From: Jeff Mahoney <jeffm@jeffreymahoney.com>
Subject: [patch 1/5] btrfs-progs: convert to autotools
Date: Fri, 13 Jun 2008 16:09:07 -0400
Message-ID: <20080613201007.641785953@suse.com>
References: <20080613200906.180149089@suse.com>
Cc: Btrfs Development List <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 This patch converts the btrfs-progs build system from a single Makefile
 to the autotools suite.

 The advantages are:
 Easier construction of Makefiles
 Easier to breakout the source into separate directories for easier management
 Easier to build shared libraries automatically
 Automatic checking for optional libraries, like libext2fs for btrfs-convert
 Automatic infrastructure for installing and testing

 The caveats are:
 Opinions on autotools are... mixed.
 make C=1 no longer works, but is replaced by make check.

 A later patch will use the advantages to create a libbtrfs and separate
 the source and headers into separate directories.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>

---
 AUTHORS      |    1 
 ChangeLog    |    1 
 Makefile     |   69 -----------------------------------------------------------
 Makefile.am  |   35 +++++++++++++++++++++++++++++
 NEWS         |    1 
 README       |    1 
 configure.ac |   41 +++++++++++++++++++++++++++++++++++
 predef.h.in  |    4 +++
 8 files changed, 84 insertions(+), 69 deletions(-)

--- /dev/null
+++ b/AUTHORS
@@ -0,0 +1 @@
+
--- /dev/null
+++ b/ChangeLog
@@ -0,0 +1 @@
+
--- a/Makefile
+++ /dev/null
@@ -1,69 +0,0 @@
-CC=gcc
-AM_CFLAGS = -Wall -fno-strict-aliasing -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2
-CFLAGS = -g -Werror -Os
-objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
-	  root-tree.o dir-item.o hash.o file-item.o inode-item.o \
-	  inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o \
-	  volumes.o utils.o
-#
-CHECKFLAGS=-D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise \
-		-Wuninitialized -Wshadow -Wundef
-DEPFLAGS = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
-
-INSTALL= install
-prefix ?= /usr/local
-bindir = $(prefix)/bin
-LIBS=-luuid
-
-progs = btrfsctl btrfsck mkfs.btrfs debug-tree btrfs-show btrfs-vol
-
-# make C=1 to enable sparse
-ifdef C
-	check=sparse $(CHECKFLAGS)
-else
-	check=ls
-endif
-
-.c.o:
-	$(check) $<
-	$(CC) $(DEPFLAGS) $(AM_CFLAGS) $(CFLAGS) -c $<
-
-
-all: $(progs)
-
-btrfsctl: $(objects) btrfsctl.o
-	gcc $(CFLAGS) -o btrfsctl btrfsctl.o $(objects) $(LDFLAGS) $(LIBS)
-
-btrfs-vol: $(objects) btrfs-vol.o
-	gcc $(CFLAGS) -o btrfs-vol btrfs-vol.o $(objects) $(LDFLAGS) $(LIBS)
-
-btrfs-show: $(objects) btrfs-show.o
-	gcc $(CFLAGS) -o btrfs-show btrfs-show.o $(objects) $(LDFLAGS) $(LIBS)
-
-btrfsck: $(objects) btrfsck.o bit-radix.o
-	gcc $(CFLAGS) -o btrfsck btrfsck.o $(objects) bit-radix.o $(LDFLAGS) $(LIBS)
-
-mkfs.btrfs: $(objects) mkfs.o
-	gcc $(CFLAGS) -o mkfs.btrfs $(objects) mkfs.o $(LDFLAGS) $(LIBS)
-
-debug-tree: $(objects) debug-tree.o
-	gcc $(CFLAGS) -o debug-tree $(objects) debug-tree.o $(LDFLAGS) $(LIBS)
-
-dir-test: $(objects) dir-test.o
-	gcc $(CFLAGS) -o dir-test $(objects) dir-test.o $(LDFLAGS) $(LIBS)
-
-quick-test: $(objects) quick-test.o
-	gcc $(CFLAGS) -o quick-test $(objects) quick-test.o $(LDFLAGS) $(LIBS)
-
-convert: $(objects) convert.o
-	gcc $(CFLAGS) -o btrfs-convert $(objects) convert.o -lext2fs $(LDFLAGS) $(LIBS)
-
-clean :
-	rm -f $(progs) cscope.out *.o .*.d btrfs-convert
-
-install: $(progs)
-	$(INSTALL) -m755 -d $(DESTDIR)$(bindir)
-	$(INSTALL) $(progs) $(DESTDIR)$(bindir)
-	if [ -e btrfs-convert ]; then $(INSTALL) btrfs-convert $(DESTDIR)$(bindir); fi
-
--include .*.d
--- /dev/null
+++ b/Makefile.am
@@ -0,0 +1,35 @@
+sbin_PROGRAMS = btrfsctl btrfs-vol btrfs-show btrfsck mkfs.btrfs debug-tree \
+	       $(BTRFS_CONVERT)
+sbin_SCRIPTS = show-blocks bcp
+
+EXTRA_PROGRAMS = btrfs-convert quick-test dir-test
+
+COMMON_SOURCES = ctree.c disk-io.c radix-tree.c extent-tree.c print-tree.c \
+	      root-tree.c dir-item.c hash.c file-item.c inode-item.c \
+	      inode-map.c crc32c.c rbtree.c extent-cache.c extent_io.c \
+	      volumes.c utils.c
+
+btrfsctl_SOURCES = btrfsctl.c $(COMMON_SOURCES)
+btrfs_vol_SOURCES = btrfs-vol.c $(COMMON_SOURCES)
+btrfs_show_SOURCES = btrfs-show.c $(COMMON_SOURCES)
+btrfsck_SOURCES = btrfsck.c bit-radix.c $(COMMON_SOURCES)
+mkfs_btrfs_SOURCES = mkfs.c $(COMMON_SOURCES)
+debug_tree_SOURCES = debug-tree.c $(COMMON_SOURCES)
+dir_test_SOURCES = dir-test.c $(COMMON_SOURCES)
+quick_test_SOURCES = quick-test.c $(COMMON_SOURCES)
+btrfs_convert_SOURCES = convert.c $(COMMON_SOURCES)
+
+btrfs_convert_CFLAGS = $(libext2fs_CFLAGS)
+btrfs_convert_LDADD = $(libext2fs_LIBS)
+
+PROGS_SRCS = $(COMMON_SOURCES) btrfsctl.c btrfs-vol.c btrfs-show.c \
+		btrfsck.c bit-radix.c mkfs.c debug-tree.c dir-test.c \
+		quick-test.c convert.c
+
+CHECKFLAGS=-Wbitwise -Wuninitialized -Wshadow -Wundef
+SPARSE = sparse
+
+TESTS = $(PROGS_SRCS)
+TESTS_ENVIRONMENT = \
+	$(SPARSE) $(CHECKFLAGS) $(DEFS) $(DEFAULT_INCLUDES) $(INCLUDES) \
+		  $(AM_CPPFLAGS) $(CPPFLAGS) -include $(top_builddir)/predef.h
--- /dev/null
+++ b/NEWS
@@ -0,0 +1 @@
+
--- /dev/null
+++ b/README
@@ -0,0 +1 @@
+
--- /dev/null
+++ b/configure.ac
@@ -0,0 +1,41 @@
+AC_INIT()
+AC_CANONICAL_HOST
+AC_PREREQ(2.50)
+
+AM_INIT_AUTOMAKE(btrfs-progs, 0.15)
+AC_PROG_CC
+AM_PROG_CC_C_O
+AC_PROG_INSTALL
+AC_PROG_MAKE_SET
+
+AC_HEADER_STDC
+AC_HEADER_MAJOR
+
+AC_C_CONST
+AC_C_INLINE
+AC_SYS_LARGEFILE
+
+CFLAGS="$CFLAGS -Wall -fno-strict-aliasing -D_FORTIFY_SOURCE=2 -g -Werror -Os"
+
+AC_ARG_ENABLE(convert-ext2fs, [  --enable-convert-ext2fs	enable ext2fs support in convert tool (yes)], convert_ext2fs=$enableval, convert_ext2fs=yes)
+
+PKG_CHECK_MODULES(uuid, uuid)
+CFLAGS="$CFLAGS $uuid_CFLAGS"
+LIBS="$LIBS $uuid_LIBS"
+
+if test "$convert_ext2fs" = "yes"; then
+	PKG_CHECK_MODULES(libext2fs, ext2fs >= 1.40, , true)
+fi
+
+
+if test -z "$libext2fs_LIBS" ; then
+	AC_WARN(Will not build btrfs-convert: Nothing to do.)
+else
+	BTRFS_CONVERT="btrfs-convert"
+	AC_SUBST(BTRFS_CONVERT)
+fi
+
+PREDEFINED_MACROS=$(echo | gcc -dM -E - )
+AC_SUBST(PREDEFINED_MACROS)
+
+AC_OUTPUT(Makefile predef.h)
--- /dev/null
+++ b/predef.h.in
@@ -0,0 +1,4 @@
+#ifndef _PREDEF_H_
+#define _PREDEF_H_
+@PREDEFINED_MACROS@
+#endif _PREDEF_H_


