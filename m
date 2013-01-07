Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46808 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758979Ab3BLXYc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 18:24:32 -0500
Received: from relay1.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 63042A5358
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Feb 2013 00:24:31 +0100 (CET)
In-Reply-To: <20130212231526.GE12339@twin.jikos.cz>
References: <20130212231526.GE12339@twin.jikos.cz>
From: Mark Fasheh <mfasheh@suse.de>
Date: Mon, 7 Jan 2013 14:24:35 -0800
Subject: [PATCH 17/21] btrfs-progs: libify some parts of btrfs-progs
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
Message-Id: <S1759003Ab3BLXYd/20130212232433Z+1441@vger.kernel.org>
To: unlisted-recipients:; (no To-header on input)

External software wanting to use the functionality provided by the btrfs
send ioctl has a hard time doing so without replicating tons of work. Of
particular interest are functions like btrfs_read_and_process_send_stream()
and subvol_uuid_search(). As that functionality requires a bit more than
just send-stream.c and send-utils.c we have to pull in some other parts of
the progs package.

This patch adds code to the Makefile and headers to create a library,
libbtrfs which the btrfs command now links to.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 Makefile       | 80 ++++++++++++++++++++++++++++++++++++++--------------------
 btrfs-list.h   |  4 +++
 crc32c.h       |  4 +++
 ctree.h        |  9 +++++++
 extent-cache.h |  6 +++++
 extent_io.h    |  7 +++++
 radix-tree.h   |  4 +++
 rbtree.h       |  4 +++
 send-utils.h   |  5 ++++
 9 files changed, 96 insertions(+), 27 deletions(-)

diff --git a/Makefile b/Makefile
index e83cf5b..1dc24e3 100644
--- a/Makefile
+++ b/Makefile
@@ -1,16 +1,20 @@
 CC = gcc
 LN = ln
-AM_CFLAGS = -Wall -D_FILE_OFFSET_BITS=64 -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2
+AM_CFLAGS = -Wall -D_FILE_OFFSET_BITS=64 -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2 -DBTRFS_FLAT_INCLUDES -fPIC
 CFLAGS = -g -O1
 objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o \
-	  inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o \
+	  inode-map.o extent-cache.o extent_io.o \
 	  volumes.o utils.o btrfs-list.o btrfslabel.o repair.o \
-	  send-stream.o send-utils.o qgroup.o raid6.o
+	  qgroup.o raid6.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
 	       cmds-restore.o
+libbtrfs_objects = send-stream.o send-utils.o rbtree.o btrfs-list.o crc32c.o
+libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
+	       crc32c.h list.h kerncompat.h radix-tree.h extent-cache.h \
+	       extent_io.h ioctl.h ctree.h
 
 CHECKFLAGS= -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise \
 	    -Wuninitialized -Wshadow -Wundef
@@ -19,7 +23,10 @@ DEPFLAGS = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
 INSTALL = install
 prefix ?= /usr/local
 bindir = $(prefix)/bin
-LIBS=-luuid -lm -lz
+libdir = $(prefix)/lib
+incdir = $(prefix)/include/btrfs
+lib_LIBS = -luuid -lm -lz -L.
+LIBS = $(lib_LIBS) -lbtrfs
 
 ifeq ("$(origin V)", "command line")
   BUILD_VERBOSE = $(V)
@@ -50,6 +57,10 @@ STATIC_CFLAGS = $(CFLAGS) -ffunction-sections -fdata-sections
 STATIC_LDFLAGS = -static -Wl,--gc-sections
 STATIC_LIBS = $(LIBS) -lpthread
 
+libs = libbtrfs.so.0.1
+lib_links = libbtrfs.so.0 libbtrfs.so
+headers = $(libbtrfs_headers)
+
 # make C=1 to enable sparse
 ifdef C
 	check = sparse $(CHECKFLAGS)
@@ -72,38 +83,47 @@ all: version.h $(progs) manpages
 # NOTE: For static compiles, you need to have all the required libs
 # 	static equivalent available
 #
-static: version.h btrfs.static
+static: version.h $(libs) btrfs.static
 
 version.h:
 	$(Q)bash version.sh
 
-btrfs: $(objects) btrfs.o help.o $(cmds_objects)
+$(libs): $(libbtrfs_objects) $(lib_links) send.h
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) $(libbtrfs_objects) $(lib_LIBS) -shared -Wl,-soname,libbtrfs.so -o libbtrfs.so.0.1
+
+$(lib_links):
+	@echo "    [LN]     $@"
+	$(Q)$(LN) -sf libbtrfs.so.0.1 libbtrfs.so.0
+	$(Q)$(LN) -sf libbtrfs.so.0.1 libbtrfs.so
+
+btrfs: $(objects) btrfs.o help.o $(cmds_objects) $(libs)
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o btrfs btrfs.o help.o $(cmds_objects) \
 		$(objects) $(LDFLAGS) $(LIBS) -lpthread
 
-btrfs.static: $(static_objects) btrfs.static.o help.static.o $(static_cmds_objects)
+btrfs.static: $(static_objects) $(libs) btrfs.static.o help.static.o $(static_cmds_objects)
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(STATIC_CFLAGS) -o btrfs.static btrfs.static.o help.static.o $(static_cmds_objects) \
 		$(static_objects) $(STATIC_LDFLAGS) $(STATIC_LIBS)
 
-calc-size: $(objects) calc-size.o
+calc-size: $(objects) $(libs) calc-size.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o calc-size calc-size.o $(objects) $(LDFLAGS) $(LIBS)
 
-btrfs-find-root: $(objects) find-root.o
+btrfs-find-root: $(objects) $(libs) find-root.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o btrfs-find-root find-root.o $(objects) $(LDFLAGS) $(LIBS)
 
-btrfsctl: $(objects) btrfsctl.o
+btrfsctl: $(objects) $(libs) btrfsctl.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o btrfsctl btrfsctl.o $(objects) $(LDFLAGS) $(LIBS)
 
-btrfs-vol: $(objects) btrfs-vol.o
+btrfs-vol: $(objects) $(libs) btrfs-vol.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o btrfs-vol btrfs-vol.o $(objects) $(LDFLAGS) $(LIBS)
 
-btrfs-show: $(objects) btrfs-show.o
+btrfs-show: $(objects) $(libs) btrfs-show.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o btrfs-show btrfs-show.o $(objects) $(LDFLAGS) $(LIBS)
 
@@ -112,55 +132,55 @@ btrfsck: btrfs
 	@echo "    [LN]     $@"
 	$(Q)$(LN) -f btrfs btrfsck
 
-mkfs.btrfs: $(objects) mkfs.o
+mkfs.btrfs: $(objects) $(libs) mkfs.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o mkfs.btrfs $(objects) mkfs.o $(LDFLAGS) $(LIBS) -lblkid
 
-btrfs-debug-tree: $(objects) debug-tree.o
+btrfs-debug-tree: $(objects) $(libs) debug-tree.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o btrfs-debug-tree $(objects) debug-tree.o $(LDFLAGS) $(LIBS)
 
-btrfs-zero-log: $(objects) btrfs-zero-log.o
+btrfs-zero-log: $(objects) $(libs) btrfs-zero-log.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o btrfs-zero-log $(objects) btrfs-zero-log.o $(LDFLAGS) $(LIBS)
 
-btrfs-show-super: $(objects) btrfs-show-super.o
+btrfs-show-super: $(objects) $(libs) btrfs-show-super.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o btrfs-show-super $(objects) btrfs-show-super.o $(LDFLAGS) $(LIBS)
 
-btrfs-select-super: $(objects) btrfs-select-super.o
+btrfs-select-super: $(objects) $(libs) btrfs-select-super.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o btrfs-select-super $(objects) btrfs-select-super.o $(LDFLAGS) $(LIBS)
 
-btrfstune: $(objects) btrfstune.o
+btrfstune: $(objects) $(libs) btrfstune.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o btrfstune $(objects) btrfstune.o $(LDFLAGS) $(LIBS)
 
-btrfs-map-logical: $(objects) btrfs-map-logical.o
+btrfs-map-logical: $(objects) $(libs) btrfs-map-logical.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o btrfs-map-logical $(objects) btrfs-map-logical.o $(LDFLAGS) $(LIBS)
 
-btrfs-corrupt-block: $(objects) btrfs-corrupt-block.o
+btrfs-corrupt-block: $(objects) $(libs) btrfs-corrupt-block.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o btrfs-corrupt-block $(objects) btrfs-corrupt-block.o $(LDFLAGS) $(LIBS)
 
-btrfs-image: $(objects) btrfs-image.o
+btrfs-image: $(objects) $(libs) btrfs-image.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o btrfs-image $(objects) btrfs-image.o -lpthread -lz $(LDFLAGS) $(LIBS)
 
-dir-test: $(objects) dir-test.o
+dir-test: $(objects) $(libs) dir-test.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o dir-test $(objects) dir-test.o $(LDFLAGS) $(LIBS)
 
-quick-test: $(objects) quick-test.o
+quick-test: $(objects) $(libs) quick-test.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o quick-test $(objects) quick-test.o $(LDFLAGS) $(LIBS)
 
-btrfs-convert: $(objects) convert.o
+btrfs-convert: $(objects) $(libs) convert.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o btrfs-convert $(objects) convert.o -lext2fs -lcom_err $(LDFLAGS) $(LIBS)
 
-ioctl-test: $(objects) ioctl-test.o
+ioctl-test: $(objects) $(libs) ioctl-test.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o ioctl-test $(objects) ioctl-test.o $(LDFLAGS) $(LIBS)
 
@@ -174,11 +194,17 @@ clean :
 	@echo "Cleaning"
 	$(Q)rm -f $(progs) cscope.out *.o .*.d btrfs-convert btrfs-image btrfs-select-super \
 	      btrfs-zero-log btrfstune dir-test ioctl-test quick-test btrfs.static btrfsck \
-	      version.h
+	      version.h \
+	      $(libs) libbtrfs.so libbtrfs.so.0 libbtrfs.so.0.1
 	$(Q)$(MAKE) $(MAKEOPTS) -C man $@
 
-install: $(progs) install-man
+install: $(libs) $(progs) install-man
 	$(INSTALL) -m755 -d $(DESTDIR)$(bindir)
 	$(INSTALL) $(progs) $(DESTDIR)$(bindir)
+	$(INSTALL) -m755 -d $(DESTDIR)$(libdir)
+	$(INSTALL) $(libs) $(DESTDIR)$(libdir)
+	cp -a $(lib_links) $(DESTDIR)$(libdir)
+	$(INSTALL) -m755 -d $(DESTDIR)$(incdir)
+	$(INSTALL) -m644 $(headers) $(DESTDIR)$(incdir)
 
 -include .*.d
diff --git a/btrfs-list.h b/btrfs-list.h
index 5d87454..397f06c 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -16,7 +16,11 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#if BTRFS_FLAT_INCLUDES
 #include "kerncompat.h"
+#else
+#include <btrfs/kerncompat.h>
+#endif /* BTRFS_FLAT_INCLUDES */
 
 #define BTRFS_LIST_LAYOUT_DEFAULT	0
 #define BTRFS_LIST_LAYOUT_TABLE	1
diff --git a/crc32c.h b/crc32c.h
index 7f12e77..c552ef6 100644
--- a/crc32c.h
+++ b/crc32c.h
@@ -19,7 +19,11 @@
 #ifndef __CRC32C__
 #define __CRC32C__
 
+#if BTRFS_FLAT_INCLUDES
 #include "kerncompat.h"
+#else
+#include <btrfs/kerncompat.h>
+#endif /* BTRFS_FLAT_INCLUDES */
 
 u32 crc32c_le(u32 seed, unsigned char const *data, size_t length);
 void crc32c_optimization_init(void);
diff --git a/ctree.h b/ctree.h
index 12f8fe3..0aed2fc 100644
--- a/ctree.h
+++ b/ctree.h
@@ -19,12 +19,21 @@
 #ifndef __BTRFS__
 #define __BTRFS__
 
+#if BTRFS_FLAT_INCLUDES
 #include "list.h"
 #include "kerncompat.h"
 #include "radix-tree.h"
 #include "extent-cache.h"
 #include "extent_io.h"
 #include "ioctl.h"
+#else
+#include <btrfs/list.h>
+#include <btrfs/kerncompat.h>
+#include <btrfs/radix-tree.h>
+#include <btrfs/extent-cache.h>
+#include <btrfs/extent_io.h>
+#include <btrfs/ioctl.h>
+#endif /* BTRFS_FLAT_INCLUDES */
 
 struct btrfs_root;
 struct btrfs_trans_handle;
diff --git a/extent-cache.h b/extent-cache.h
index 7f2f2a6..4cd0f79 100644
--- a/extent-cache.h
+++ b/extent-cache.h
@@ -18,8 +18,14 @@
 
 #ifndef __PENDING_EXTENT__
 #define __PENDING_EXTENT__
+
+#if BTRFS_FLAT_INCLUDES
 #include "kerncompat.h"
 #include "rbtree.h"
+#else
+#include <btrfs/kerncompat.h>
+#include <btrfs/rbtree.h>
+#endif /* BTRFS_FLAT_INCLUDES */
 
 struct cache_tree {
 	struct rb_root root;
diff --git a/extent_io.h b/extent_io.h
index 5df44f7..feedfc3 100644
--- a/extent_io.h
+++ b/extent_io.h
@@ -18,9 +18,16 @@
 
 #ifndef __EXTENTMAP__
 #define __EXTENTMAP__
+
+#if BTRFS_FLAT_INCLUDES
 #include "kerncompat.h"
 #include "extent-cache.h"
 #include "list.h"
+#else
+#include <btrfs/kerncompat.h>
+#include <btrfs/extent-cache.h>
+#include <btrfs/list.h>
+#endif /* BTRFS_FLAT_INCLUDES */
 
 #define EXTENT_DIRTY 1
 #define EXTENT_WRITEBACK (1 << 1)
diff --git a/radix-tree.h b/radix-tree.h
index d99ea7e..bf96d83 100644
--- a/radix-tree.h
+++ b/radix-tree.h
@@ -37,7 +37,11 @@
 #ifndef _LINUX_RADIX_TREE_H
 #define _LINUX_RADIX_TREE_H
 
+#if BTRFS_FLAT_INCLUDES
 #include "kerncompat.h"
+#else
+#include <btrfs/kerncompat.h>
+#endif /* BTRFS_FLAT_INCLUDES */
 
 #define RADIX_TREE_MAX_TAGS 2
 
diff --git a/rbtree.h b/rbtree.h
index bed054d..b636ddd 100644
--- a/rbtree.h
+++ b/rbtree.h
@@ -93,7 +93,11 @@ static inline struct page * rb_insert_page_cache(struct inode * inode,
 
 #ifndef	_LINUX_RBTREE_H
 #define	_LINUX_RBTREE_H
+#if BTRFS_FLAT_INCLUDES
 #include "kerncompat.h"
+#else
+#include <btrfs/kerncompat.h>
+#endif /* BTRFS_FLAT_INCLUDES */
 struct rb_node
 {
 	unsigned long  rb_parent_color;
diff --git a/send-utils.h b/send-utils.h
index da407eb..8040c50 100644
--- a/send-utils.h
+++ b/send-utils.h
@@ -18,8 +18,13 @@
 #ifndef SEND_UTILS_H_
 #define SEND_UTILS_H_
 
+#if BTRFS_FLAT_INCLUDES
 #include "ctree.h"
 #include "rbtree.h"
+#else
+#include <btrfs/ctree.h>
+#include <btrfs/rbtree.h>
+#endif /* BTRFS_FLAT_INCLUDES */
 
 enum subvol_search_type {
 	subvol_search_by_root_id,
-- 
1.8.0.2

