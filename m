Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42731 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756323Ab3A3Wu2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 17:50:28 -0500
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com, Anand.Jain@oracle.com, aschnell@suse.de,
        jeffm@suse.com, Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 2/5] btrfs-progs: libify some parts of btrfs-progs
Date: Wed, 30 Jan 2013 14:50:24 -0800
Message-Id: <1359586227-19762-3-git-send-email-mfasheh@suse.de>
In-Reply-To: <1359586227-19762-1-git-send-email-mfasheh@suse.de>
References: <1359586227-19762-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

External software wanting to use the functionality provided by the btrfs
send ioctl has a hard time doing so without replicating tons of work. Of
particular interest are functions like btrfs_read_and_process_send_stream()
and subvol_uuid_search(). As that functionality requires a bit more than
just send-stream.c and send-utils.c we have to pull in some other parts of
the progs package.

This patch adds code to the Makefile and headers to create a library,
libbtrfs which the btrfs command now links to.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 Makefile       |   83 ++++++++++++++++++++++++++++++++++++--------------------
 btrfs-list.h   |    4 +++
 crc32c.h       |    4 +++
 ctree.h        |    9 ++++++
 extent-cache.h |    6 ++++
 extent_io.h    |    7 +++++
 radix-tree.h   |    4 +++
 rbtree.h       |    4 +++
 send-utils.h   |    5 ++++
 9 files changed, 96 insertions(+), 30 deletions(-)

diff --git a/Makefile b/Makefile
index 4894903..4962985 100644
--- a/Makefile
+++ b/Makefile
@@ -1,14 +1,17 @@
 CC = gcc
-AM_CFLAGS = -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2
+AM_CFLAGS = -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -DBTRFS_FLAT_INCLUDES -fPIC
 CFLAGS = -g -O1
 objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
-	  root-tree.o dir-item.o file-item.o inode-item.o \
-	  inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o \
-	  volumes.o utils.o btrfs-list.o btrfslabel.o repair.o \
-	  send-stream.o send-utils.o qgroup.o
+	  root-tree.o dir-item.o file-item.o inode-item.o inode-map.o \
+	  extent-cache.o extent_io.o volumes.o utils.o btrfslabel.o repair.o \
+	  qgroup.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o
+libbtrfs_objects = send-stream.o send-utils.o rbtree.o btrfs-list.o crc32c.o
+libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
+	       crc32c.h list.h kerncompat.h radix-tree.h extent-cache.h \
+	       extent_io.h ioctl.h ctree.h
 
 CHECKFLAGS= -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise \
 	    -Wuninitialized -Wshadow -Wundef
@@ -17,13 +20,20 @@ DEPFLAGS = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
 INSTALL = install
 prefix ?= /usr/local
 bindir = $(prefix)/bin
-LIBS=-luuid -lm
+libdir = $(prefix)/lib
+incdir = $(prefix)/include/btrfs
+lib_LIBS=-luuid -lm -L.
+LIBS=$(lib_LIBS) -lbtrfs
 RESTORE_LIBS=-lz
 
 progs = btrfsctl mkfs.btrfs btrfs-debug-tree btrfs-show btrfs-vol btrfsck \
 	btrfs btrfs-map-logical btrfs-image btrfs-zero-log btrfs-convert \
 	btrfs-find-root btrfs-restore btrfstune
 
+libs = libbtrfs.so.1.0
+lib_links = libbtrfs.so.1 libbtrfs.so
+headers = $(libbtrfs_headers)
+
 # make C=1 to enable sparse
 ifdef C
 	check = sparse $(CHECKFLAGS)
@@ -36,70 +46,77 @@ endif
 	$(CC) $(DEPFLAGS) $(AM_CFLAGS) $(CFLAGS) -c $<
 
 
-all: version $(progs) manpages
+all: version $(libs) $(progs) manpages
 
 version:
 	bash version.sh
 
-btrfs: $(objects) btrfs.o help.o common.o $(cmds_objects)
+$(libs): $(libbtrfs_objects) $(lib_links) send.h
+	$(CC) $(CFLAGS) $(libbtrfs_objects) $(lib_LIBS) -shared -Wl,-soname,libbtrfs.so.1 -o libbtrfs.so.1.0
+
+$(lib_links):
+	ln -sf libbtrfs.so.1.0 libbtrfs.so.1
+	ln -sf libbtrfs.so.1.0 libbtrfs.so
+
+btrfs: $(objects) btrfs.o help.o common.o $(cmds_objects) $(libs)
 	$(CC) $(CFLAGS) -o btrfs btrfs.o help.o common.o $(cmds_objects) \
 		$(objects) $(LDFLAGS) $(LIBS) -lpthread
 
-calc-size: $(objects) calc-size.o
+calc-size: $(objects) $(libs) calc-size.o
 	$(CC) $(CFLAGS) -o calc-size calc-size.o $(objects) $(LDFLAGS) $(LIBS)
 
-btrfs-find-root: $(objects) find-root.o
+btrfs-find-root: $(objects) $(libs) find-root.o
 	$(CC) $(CFLAGS) -o btrfs-find-root find-root.o $(objects) $(LDFLAGS) $(LIBS)
 
-btrfs-restore: $(objects) restore.o
+btrfs-restore: $(objects) $(libs) restore.o
 	$(CC) $(CFLAGS) -o btrfs-restore restore.o $(objects) $(LDFLAGS) $(LIBS) $(RESTORE_LIBS)
 
-btrfsctl: $(objects) btrfsctl.o
+btrfsctl: $(objects) $(libs) btrfsctl.o
 	$(CC) $(CFLAGS) -o btrfsctl btrfsctl.o $(objects) $(LDFLAGS) $(LIBS)
 
-btrfs-vol: $(objects) btrfs-vol.o
+btrfs-vol: $(objects) $(libs) btrfs-vol.o
 	$(CC) $(CFLAGS) -o btrfs-vol btrfs-vol.o $(objects) $(LDFLAGS) $(LIBS)
 
-btrfs-show: $(objects) btrfs-show.o
+btrfs-show: $(objects) $(libs) btrfs-show.o
 	$(CC) $(CFLAGS) -o btrfs-show btrfs-show.o $(objects) $(LDFLAGS) $(LIBS)
 
-btrfsck: $(objects) btrfsck.o
+btrfsck: $(objects) $(libs) btrfsck.o
 	$(CC) $(CFLAGS) -o btrfsck btrfsck.o $(objects) $(LDFLAGS) $(LIBS)
 
-mkfs.btrfs: $(objects) mkfs.o
+mkfs.btrfs: $(objects) $(libs) mkfs.o
 	$(CC) $(CFLAGS) -o mkfs.btrfs $(objects) mkfs.o $(LDFLAGS) $(LIBS)
 
-btrfs-debug-tree: $(objects) debug-tree.o
+btrfs-debug-tree: $(objects) $(libs) debug-tree.o
 	$(CC) $(CFLAGS) -o btrfs-debug-tree $(objects) debug-tree.o $(LDFLAGS) $(LIBS)
 
-btrfs-zero-log: $(objects) btrfs-zero-log.o
+btrfs-zero-log: $(objects) $(libs) btrfs-zero-log.o
 	$(CC) $(CFLAGS) -o btrfs-zero-log $(objects) btrfs-zero-log.o $(LDFLAGS) $(LIBS)
 
-btrfs-select-super: $(objects) btrfs-select-super.o
+btrfs-select-super: $(objects) $(libs) btrfs-select-super.o
 	$(CC) $(CFLAGS) -o btrfs-select-super $(objects) btrfs-select-super.o $(LDFLAGS) $(LIBS)
 
-btrfstune: $(objects) btrfstune.o
+btrfstune: $(objects) $(libs) btrfstune.o
 	$(CC) $(CFLAGS) -o btrfstune $(objects) btrfstune.o $(LDFLAGS) $(LIBS)
 
-btrfs-map-logical: $(objects) btrfs-map-logical.o
+btrfs-map-logical: $(objects) $(libs) btrfs-map-logical.o
 	$(CC) $(CFLAGS) -o btrfs-map-logical $(objects) btrfs-map-logical.o $(LDFLAGS) $(LIBS)
 
-btrfs-corrupt-block: $(objects) btrfs-corrupt-block.o
+btrfs-corrupt-block: $(objects) $(libs) btrfs-corrupt-block.o
 	$(CC) $(CFLAGS) -o btrfs-corrupt-block $(objects) btrfs-corrupt-block.o $(LDFLAGS) $(LIBS)
 
-btrfs-image: $(objects) btrfs-image.o
+btrfs-image: $(objects) $(libs) btrfs-image.o
 	$(CC) $(CFLAGS) -o btrfs-image $(objects) btrfs-image.o -lpthread -lz $(LDFLAGS) $(LIBS)
 
-dir-test: $(objects) dir-test.o
+dir-test: $(objects) $(libs) dir-test.o
 	$(CC) $(CFLAGS) -o dir-test $(objects) dir-test.o $(LDFLAGS) $(LIBS)
 
-quick-test: $(objects) quick-test.o
+quick-test: $(objects) $(libs) quick-test.o
 	$(CC) $(CFLAGS) -o quick-test $(objects) quick-test.o $(LDFLAGS) $(LIBS)
 
-btrfs-convert: $(objects) convert.o
+btrfs-convert: $(objects) $(libs) convert.o
 	$(CC) $(CFLAGS) -o btrfs-convert $(objects) convert.o -lext2fs -lcom_err $(LDFLAGS) $(LIBS)
 
-ioctl-test: $(objects) ioctl-test.o
+ioctl-test: $(objects) $(libs) ioctl-test.o
 	$(CC) $(CFLAGS) -o ioctl-test $(objects) ioctl-test.o $(LDFLAGS) $(LIBS)
 
 manpages:
@@ -109,12 +126,18 @@ install-man:
 	cd man; $(MAKE) install
 
 clean :
-	rm -f $(progs) cscope.out *.o .*.d btrfs-convert btrfs-image btrfs-select-super \
-	      btrfs-zero-log btrfstune dir-test ioctl-test quick-test version.h
+	rm -f $(progs) $(libs) cscope.out *.o .*.d btrfs-convert btrfs-image \
+	      btrfs-select-super btrfs-zero-log btrfstune dir-test ioctl-test \
+	      quick-test version.h
 	cd man; $(MAKE) clean
 
-install: $(progs) install-man
+install: $(libs) $(progs) install-man
 	$(INSTALL) -m755 -d $(DESTDIR)$(bindir)
 	$(INSTALL) $(progs) $(DESTDIR)$(bindir)
+	$(INSTALL) -m755 -d $(DESTDIR)$(libdir)
+	$(INSTALL) $(libs) $(DESTDIR)$(libdir)
+	cp -a $(lib_links) $(DESTDIR)$(libdir)
+	$(INSTALL) -m755 -d $(DESTDIR)$(incdir)
+	$(INSTALL) $(headers) $(DESTDIR)$(incdir)
 
 -include .*.d
diff --git a/btrfs-list.h b/btrfs-list.h
index cde4b3c..da6bf1c 100644
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
 
 struct root_info;
 
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
index 293b24f..7a1ffce 100644
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
index a5d6bf0..4553859 100644
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
1.7.10.4

