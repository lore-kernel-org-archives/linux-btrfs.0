From: Jeff Mahoney <jeffm@jeffreymahoney.com>
Subject: [patch 3/5] btrfs-progs: Restructure code layout, create libbtrfs
Date: Fri, 13 Jun 2008 16:09:09 -0400
Message-ID: <20080613201007.897018898@suse.com>
References: <20080613200906.180149089@suse.com>
Cc: Btrfs Development List <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 This patch creates the automake infrastructure to build after
 restructure.sh is executed. The final result is the following:

 $(COMMON_OBJS) will become libbtrfs.so, with the source in lib/
 includes will be split out into include/
 Groups of programs will be split out into
 src/{convert,debug,fsck,mkfs,test,util}

 Make install will cause the library and includes to be installed
 at expected locations.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 Makefile.am             |   32 +-------------------------------
 configure.ac            |    8 ++++++--
 lib/Makefile.am         |   16 ++++++++++++++++
 src/Makefile.am         |    1 +
 src/convert/Makefile.am |   14 ++++++++++++++
 src/debug/Makefile.am   |   12 ++++++++++++
 src/fsck/Makefile.am    |   12 ++++++++++++
 src/mkfs/Makefile.am    |   12 ++++++++++++
 src/test/Makefile.am    |   18 ++++++++++++++++++
 src/util/Makefile.am    |   14 ++++++++++++++
 10 files changed, 106 insertions(+), 33 deletions(-)

--- a/Makefile.am
+++ b/Makefile.am
@@ -1,32 +1,2 @@
-sbin_PROGRAMS = btrfsctl btrfs-vol btrfs-show btrfsck mkfs.btrfs debug-tree \
-	       $(BTRFS_CONVERT)
+SUBDIRS=lib src
 sbin_SCRIPTS = show-blocks bcp
-
-EXTRA_PROGRAMS = btrfs-convert quick-test dir-test
-
-COMMON_SOURCES = ctree.c disk-io.c radix-tree.c extent-tree.c print-tree.c \
-	      root-tree.c dir-item.c hash.c file-item.c inode-item.c \
-	      inode-map.c crc32c.c rbtree.c extent-cache.c extent_io.c \
-	      volumes.c utils.c
-
-btrfsctl_SOURCES = btrfsctl.c $(COMMON_SOURCES)
-btrfs_vol_SOURCES = btrfs-vol.c $(COMMON_SOURCES)
-btrfs_show_SOURCES = btrfs-show.c $(COMMON_SOURCES)
-btrfsck_SOURCES = btrfsck.c bit-radix.c $(COMMON_SOURCES)
-mkfs_btrfs_SOURCES = mkfs.c $(COMMON_SOURCES)
-debug_tree_SOURCES = debug-tree.c $(COMMON_SOURCES)
-dir_test_SOURCES = dir-test.c $(COMMON_SOURCES)
-quick_test_SOURCES = quick-test.c $(COMMON_SOURCES)
-btrfs_convert_SOURCES = convert.c $(COMMON_SOURCES)
-
-btrfs_convert_CFLAGS = $(libext2fs_CFLAGS)
-btrfs_convert_LDADD = $(libext2fs_LIBS)
-
-PROGS_SRCS = $(COMMON_SOURCES) btrfsctl.c btrfs-vol.c btrfs-show.c \
-		btrfsck.c bit-radix.c mkfs.c debug-tree.c dir-test.c \
-		quick-test.c convert.c
-
-if HAVE_SPARSE
-TESTS = $(PROGS_SRCS)
-TESTS_ENVIRONMENT = @SPARSE@
-endif
--- a/configure.ac
+++ b/configure.ac
@@ -7,6 +7,7 @@ AC_PROG_CC
 AM_PROG_CC_C_O
 AC_PROG_INSTALL
 AC_PROG_MAKE_SET
+AC_PROG_LIBTOOL
 
 AC_HEADER_STDC
 AC_HEADER_MAJOR
@@ -44,6 +45,9 @@ AM_CONDITIONAL(HAVE_SPARSE, test "$spars
 CHECKFLAGS="-Wbitwise -Wuninitialized -Wshadow -Wundef"
 SPARSE='sparse $(CHECKFLAGS) $(DEFS) $(DEFAULT_INCLUDES) $(INCLUDES) \
 		  $(AM_CPPFLAGS) $(CPPFLAGS) \
-		  -include $(top_builddir)/predef.h'
+		  -include $(top_builddir)/include/predef.h'
 AC_SUBST(SPARSE)
-AC_OUTPUT(Makefile predef.h)
+AC_OUTPUT(Makefile lib/Makefile lib/predef.h \
+	  src/Makefile src/test/Makefile src/mkfs/Makefile \
+	  src/convert/Makefile src/debug/Makefile src/fsck/Makefile \
+	  src/util/Makefile)
--- /dev/null
+++ b/lib/Makefile.am
@@ -0,0 +1,16 @@
+btrfsdir = $(includedir)/btrfs
+btrfs_HEADERS = bit-radix.h crc32c.h ctree.h disk-io.h extent-cache.h \
+                extent_io.h hash.h ioctl.h kerncompat.h list.h print-tree.h \
+		radix-tree.h rbtree.h transaction.h utils.h volumes.h
+lib_LTLIBRARIES = libbtrfs.la
+
+libbtrfs_la_SOURCES = ctree.c disk-io.c radix-tree.c extent-tree.c \
+		      print-tree.c root-tree.c dir-item.c hash.c \
+		      file-item.c inode-item.c inode-map.c crc32c.c \
+		      rbtree.c extent-cache.c extent_io.c volumes.c utils.c
+libbtrfs_la_LDFLAGS = -release @VERSION@
+
+if HAVE_SPARSE
+TESTS = $(libbtrfs_la_SOURCES)
+TESTS_ENVIRONMENT = @SPARSE@
+endif
--- /dev/null
+++ b/src/Makefile.am
@@ -0,0 +1 @@
+SUBDIRS = test mkfs convert debug fsck util
--- /dev/null
+++ b/src/convert/Makefile.am
@@ -0,0 +1,14 @@
+INCLUDES=-I$(top_srcdir)/lib
+
+sbin_PROGRAMS = $(BTRFS_CONVERT)
+EXTRA_PROGRAMS = btrfs-convert
+
+btrfs_convert_SOURCES = convert.c
+
+AM_CFLAGS = $(libext2fs_CFLAGS)
+LDADD = $(top_builddir)/lib/libbtrfs.la $(libext2fs_LIBS)
+
+if HAVE_SPARSE
+TESTS = $(btrfs_convert_SOURCES)
+TESTS_ENVIRONMENT = @SPARSE@
+endif
--- /dev/null
+++ b/src/debug/Makefile.am
@@ -0,0 +1,12 @@
+INCLUDES = -I$(top_srcdir)/lib
+
+sbin_PROGRAMS = debug-tree
+
+debug_tree_SOURCES = debug-tree.c
+
+LDADD = $(top_builddir)/lib/libbtrfs.la
+
+if HAVE_SPARSE
+TESTS = $(debug_tree_SOURCES)
+TESTS_ENVIRONMENT = @SPARSE@
+endif
--- /dev/null
+++ b/src/fsck/Makefile.am
@@ -0,0 +1,12 @@
+INCLUDES = -I$(top_srcdir)/lib
+
+sbin_PROGRAMS = btrfsck
+
+btrfsck_SOURCES = btrfsck.c bit-radix.c
+
+LDADD = $(top_builddir)/lib/libbtrfs.la
+
+if HAVE_SPARSE
+TESTS = $(btrfsck_SOURCES)
+TESTS_ENVIRONMENT = @SPARSE@
+endif
--- /dev/null
+++ b/src/mkfs/Makefile.am
@@ -0,0 +1,12 @@
+INCLUDES = -I$(top_srcdir)/lib
+
+sbin_PROGRAMS = mkfs.btrfs
+
+mkfs_btrfs_SOURCES = mkfs.c
+
+LDADD = $(top_builddir)/lib/libbtrfs.la
+
+if HAVE_SPARSE
+TESTS = $(mkfs_btrfs_SOURCES)
+TESTS_ENVIRONMENT = @SPARSE@
+endif
--- /dev/null
+++ b/src/test/Makefile.am
@@ -0,0 +1,18 @@
+INCLUDES = -I$(top_srcdir)/lib
+
+#bin_PROGRAMS = hasher dir-test quick-test random-test
+
+EXTRA_PROGRAMS = hasher dir-test quick-test random-test
+
+hasher_SOURCES = hasher.c
+dir_test_SOURCES = dir-test.c
+quick_test_SOURCES = quick-test.c
+random_test_SOURCES = random-test.c
+
+LDADD = $(top_builddir)/lib/libbtrfs.la
+
+if HAVE_SPARSE
+TESTS = $(hasher_SOURCES) $(dir_test_SOURCES) $(quick_test_SOURCES) \
+        $(random_test_SOURCES)
+TESTS_ENVIRONMENT = @SPARSE@
+endif
--- /dev/null
+++ b/src/util/Makefile.am
@@ -0,0 +1,14 @@
+INCLUDES = -I$(top_srcdir)/lib
+
+sbin_PROGRAMS = btrfsctl btrfs-vol btrfs-show
+
+btrfsctl_SOURCES = btrfsctl.c
+btrfs_vol_SOURCES = btrfs-vol.c
+btrfs_show_SOURCES = btrfs-show.c
+
+LDADD = $(top_builddir)/lib/libbtrfs.la
+
+if HAVE_SPARSE
+TESTS =	$(btrfsctl_SOURCES) $(btrfs_vol_SOURCES) $(btrfs_show_SOURCES)
+TESTS_ENVIRONMENT = @SPARSE@
+endif


