Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967780AbaLLMgH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 07:36:07 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sBCCa7eU018532
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Dec 2014 07:36:07 -0500
From: Karel Zak <kzak@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Karel Zak <kzak@redhat.com>
Subject: [PATCH 05/10] btrfs-progs: check for build programs in ./configure
Date: Fri, 12 Dec 2014 13:35:19 +0100
Message-Id: <1418387724-20188-6-git-send-email-kzak@redhat.com>
In-Reply-To: <1418387724-20188-1-git-send-email-kzak@redhat.com>
References: <1418387724-20188-1-git-send-email-kzak@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Karel Zak <kzak@redhat.com>
---
 Makefile.in  | 12 ++++++------
 configure.ac |  2 ++
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/Makefile.in b/Makefile.in
index dad1685..17eea58 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -1,9 +1,9 @@
 # Export all variables to sub-makes by default
 export
 
-CC = gcc
-LN = ln
-AR = ar
+CC = @CC@
+LN_S = @LN_S@
+AR = @AR@
 AM_CFLAGS = -include config.h -Wall \
 	    -D_FILE_OFFSET_BITS=64 -DBTRFS_FLAT_INCLUDES \
 	    -fno-strict-aliasing -fPIC
@@ -25,7 +25,7 @@ libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
 	       extent_io.h ioctl.h ctree.h btrfsck.h version.h
 TESTS = fsck-tests.sh convert-tests.sh
 
-INSTALL = install
+INSTALL = @INSTALL@
 prefix ?= /usr/local
 bindir = $(prefix)/bin
 lib_LIBS = -luuid -lblkid -lm -lz -llzo2 -L.
@@ -165,8 +165,8 @@ $(libs_static): $(libbtrfs_objects)
 
 $(lib_links):
 	@echo "    [LN]     $@"
-	$(Q)$(LN) -sf libbtrfs.so.0.1 libbtrfs.so.0
-	$(Q)$(LN) -sf libbtrfs.so.0.1 libbtrfs.so
+	$(Q)$(LN_S) -f libbtrfs.so.0.1 libbtrfs.so.0
+	$(Q)$(LN_S) -f libbtrfs.so.0.1 libbtrfs.so
 
 # keep intermediate files from the below implicit rules around
 .PRECIOUS: $(addsuffix .o,$(progs))
diff --git a/configure.ac b/configure.ac
index 937d50f..662d9ff 100644
--- a/configure.ac
+++ b/configure.ac
@@ -27,6 +27,8 @@ AC_C_BIGENDIAN
 AC_SYS_LARGEFILE
 
 AC_PROG_INSTALL
+AC_PROG_LN_S
+AC_PATH_PROG([AR], [ar])
 
 AC_CHECK_FUNCS([openat], [],
 	[AC_MSG_ERROR([cannot find openat() function])])
-- 
1.9.3

