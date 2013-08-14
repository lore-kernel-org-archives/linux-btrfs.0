Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933259Ab3HNXRV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Aug 2013 19:17:21 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7ENHKFW015824
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 19:17:20 -0400
Received: from lenny.home.zabbo.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r7ENHKSk017824
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 19:17:20 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 01/15] btrfs-progs: get C=1 sparse checking working again
Date: Wed, 14 Aug 2013 16:16:31 -0700
Message-Id: <1376522205-16992-2-git-send-email-zab@redhat.com>
In-Reply-To: <1376522205-16992-1-git-send-email-zab@redhat.com>
References: <1376522205-16992-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There were a few problems that were breaking sparse checking:

- We were defining CHECK_ENDIAN late in the environment, after
  linux/fs.h has been included which defines __force and __bitwise in
  confusing ways that conflict with ours.  Define it up with __CHECKER__
  so that linux/fs.h and our copy are acting on the same input.

- We had manually set a few of gcc's internal defines to give to sparse.
  It's easier to just ask gcc for all the defines it sets and hand those
  to sparse.

- We weren't passing the same *FLAGS to sparse as we were to CC.

- glibc has so many errors with FORTIFY turned on that sparse gives up
  and doesn't show us any errors from our code.  It's a questionable
  hack to always turn on FORTIFY ourselves, so we'll just not do that
  when building with sparse.

And add a nice '[SP]' quiet output line for sparse checks.

Signed-off-by: Zach Brown <zab@redhat.com>
---
 Makefile     | 28 +++++++++++++++++++++-------
 kerncompat.h |  1 -
 2 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/Makefile b/Makefile
index fa8b34f..57cf3c8 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 CC = gcc
 LN = ln
 AR = ar
-AM_CFLAGS = -Wall -D_FILE_OFFSET_BITS=64 -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2 -DBTRFS_FLAT_INCLUDES -fPIC
+AM_CFLAGS = -Wall -D_FILE_OFFSET_BITS=64 -DBTRFS_FLAT_INCLUDES -fPIC
 CFLAGS = -g -O1
 objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o inode-map.o \
@@ -17,9 +17,6 @@ libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
 	       crc32c.h list.h kerncompat.h radix-tree.h extent-cache.h \
 	       extent_io.h ioctl.h ctree.h btrfsck.h
 
-CHECKFLAGS= -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise \
-	    -Wuninitialized -Wshadow -Wundef
-
 INSTALL = install
 prefix ?= /usr/local
 bindir = $(prefix)/bin
@@ -70,17 +67,34 @@ lib_links = libbtrfs.so.0 libbtrfs.so
 headers = $(libbtrfs_headers)
 
 # make C=1 to enable sparse
+check_defs := .cc-defines.h 
 ifdef C
-	check = sparse $(CHECKFLAGS)
+	#
+	# We're trying to use sparse against glibc headers which go wild
+	# trying to use internal compiler macros to test features.  We
+	# copy gcc's and give them to sparse.  But not __SIZE_TYPE__
+	# 'cause sparse defines that one.
+	#
+	dummy := $(shell $(CC) -dM -E -x c - < /dev/null | \
+			grep -v __SIZE_TYPE__ > $(check_defs))
+	check = sparse -include $(check_defs) -D__CHECKER__ \
+		-D__CHECK_ENDIAN__ -Wbitwise -Wuninitialized -Wshadow -Wundef
+	check_echo = echo
+	# don't use FORTIFY with sparse because glibc with FORTIFY can
+	# generate so many sparse errors that sparse stops parsing,
+	# which masks real errors that we want to see.
 else
 	check = true
+	check_echo = true
+	AM_CFLAGS += -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2
 endif
 
 %.o.d: %.c
 	$(Q)$(CC) -MM -MG -MF $@ -MT $(@:.o.d=.o) -MT $(@:.o.d=.static.o) -MT $@ $(AM_CFLAGS) $(CFLAGS) $<
 
 .c.o:
-	$(Q)$(check) $<
+	@$(check_echo) "    [SP]     $@"
+	$(Q)$(check) $(AM_CFLAGS) $(CFLAGS) $<
 	@echo "    [CC]     $@"
 	$(Q)$(CC) $(AM_CFLAGS) $(CFLAGS) -c $<
 
@@ -189,7 +203,7 @@ clean :
 	$(Q)rm -f $(progs) cscope.out *.o *.o.d btrfs-convert btrfs-image btrfs-select-super \
 	      btrfs-zero-log btrfstune dir-test ioctl-test quick-test send-test btrfsck \
 	      btrfs.static mkfs.btrfs.static btrfs-calc-size \
-	      version.h \
+	      version.h $(check_defs)\
 	      $(libs) $(lib_links)
 	$(Q)$(MAKE) $(MAKEOPTS) -C man $@
 
diff --git a/kerncompat.h b/kerncompat.h
index ebb54b1..4d78288 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -241,7 +241,6 @@ static inline long IS_ERR(const void *ptr)
         const typeof( ((type *)0)->member ) *__mptr = (ptr);    \
 	        (type *)( (char *)__mptr - offsetof(type,member) );})
 #ifdef __CHECKER__
-#define __CHECK_ENDIAN__
 #define __bitwise __bitwise__
 #else
 #define __bitwise
-- 
1.7.11.7

