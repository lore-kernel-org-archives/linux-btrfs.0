From: Jeff Mahoney <jeffm@jeffreymahoney.com>
Subject: [patch 2/5] btrfs-progs: Test for sparse support in configure
Date: Fri, 13 Jun 2008 16:09:08 -0400
Message-ID: <20080613201007.765555685@suse.com>
References: <20080613200906.180149089@suse.com>
Cc: Btrfs Development List <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 This patch moves the sparse defines from Makefile.am to configure.ac

 This allows us to enable sparse checking in other directories just
 by adding the following to the Makefile.am:

  TESTS = $(SOURCES)
  TESTS_ENVIRONMENT = @SPARSE@

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 Makefile.am  |    9 +++------
 configure.ac |    8 ++++++++
 2 files changed, 11 insertions(+), 6 deletions(-)

--- a/Makefile.am
+++ b/Makefile.am
@@ -26,10 +26,7 @@ PROGS_SRCS = $(COMMON_SOURCES) btrfsctl.
 		btrfsck.c bit-radix.c mkfs.c debug-tree.c dir-test.c \
 		quick-test.c convert.c
 
-CHECKFLAGS=-Wbitwise -Wuninitialized -Wshadow -Wundef
-SPARSE = sparse
-
+if HAVE_SPARSE
 TESTS = $(PROGS_SRCS)
-TESTS_ENVIRONMENT = \
-	$(SPARSE) $(CHECKFLAGS) $(DEFS) $(DEFAULT_INCLUDES) $(INCLUDES) \
-		  $(AM_CPPFLAGS) $(CPPFLAGS) -include $(top_builddir)/predef.h
+TESTS_ENVIRONMENT = @SPARSE@
+endif
--- a/configure.ac
+++ b/configure.ac
@@ -38,4 +38,12 @@ fi
 PREDEFINED_MACROS=$(echo | gcc -dM -E - )
 AC_SUBST(PREDEFINED_MACROS)
 
+AC_CHECK_PROG(sparse, sparse, yes)
+
+AM_CONDITIONAL(HAVE_SPARSE, test "$sparse" = "yes")
+CHECKFLAGS="-Wbitwise -Wuninitialized -Wshadow -Wundef"
+SPARSE='sparse $(CHECKFLAGS) $(DEFS) $(DEFAULT_INCLUDES) $(INCLUDES) \
+		  $(AM_CPPFLAGS) $(CPPFLAGS) \
+		  -include $(top_builddir)/predef.h'
+AC_SUBST(SPARSE)
 AC_OUTPUT(Makefile predef.h)


