Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37469 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbcCJEuJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Mar 2016 23:50:09 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] btrfs: move btrfs_compression_type to compression.h
Date: Thu, 10 Mar 2016 12:49:57 +0800
Message-Id: <1457585397-6499-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So that its better organized.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/compression.h  | 9 +++++++++
 fs/btrfs/ctree.h        | 8 --------
 fs/btrfs/disk-io.c      | 1 +
 fs/btrfs/extent_map.c   | 1 +
 fs/btrfs/file-item.c    | 1 +
 fs/btrfs/file.c         | 1 +
 fs/btrfs/ioctl.c        | 1 +
 fs/btrfs/ordered-data.c | 1 +
 fs/btrfs/props.c        | 1 +
 fs/btrfs/send.c         | 1 +
 fs/btrfs/tree-log.c     | 1 +
 11 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 13a4dc0..f49d8b8 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -48,6 +48,15 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 void btrfs_clear_biovec_end(struct bio_vec *bvec, int vcnt,
 				   unsigned long pg_index,
 				   unsigned long pg_offset);
+
+enum btrfs_compression_type {
+	BTRFS_COMPRESS_NONE  = 0,
+	BTRFS_COMPRESS_ZLIB  = 1,
+	BTRFS_COMPRESS_LZO   = 2,
+	BTRFS_COMPRESS_TYPES = 2,
+	BTRFS_COMPRESS_LAST  = 3,
+};
+
 struct btrfs_compress_op {
 	struct list_head *(*alloc_workspace)(void);
 
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 3e706ff..f46d520 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -707,14 +707,6 @@ struct btrfs_timespec {
 	__le32 nsec;
 } __attribute__ ((__packed__));
 
-enum btrfs_compression_type {
-	BTRFS_COMPRESS_NONE  = 0,
-	BTRFS_COMPRESS_ZLIB  = 1,
-	BTRFS_COMPRESS_LZO   = 2,
-	BTRFS_COMPRESS_TYPES = 2,
-	BTRFS_COMPRESS_LAST  = 3,
-};
-
 struct btrfs_inode_item {
 	/* nfs style generation number */
 	__le64 generation;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index de4c514..e95b02b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -49,6 +49,7 @@
 #include "raid56.h"
 #include "sysfs.h"
 #include "qgroup.h"
+#include "compression.h"
 
 #ifdef CONFIG_X86
 #include <asm/cpufeature.h>
diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 6a98bdd..234cdab 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -4,6 +4,7 @@
 #include <linux/hardirq.h>
 #include "ctree.h"
 #include "extent_map.h"
+#include "compression.h"
 
 
 static struct kmem_cache *extent_map_cache;
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 58ece65..c49d0c1 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -25,6 +25,7 @@
 #include "transaction.h"
 #include "volumes.h"
 #include "print-tree.h"
+#include "compression.h"
 
 #define __MAX_CSUM_ITEMS(r, size) ((unsigned long)(((BTRFS_LEAF_DATA_SIZE(r) - \
 				   sizeof(struct btrfs_item) * 2) / \
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index b823fac..052b361 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -41,6 +41,7 @@
 #include "locking.h"
 #include "volumes.h"
 #include "qgroup.h"
+#include "compression.h"
 
 static struct kmem_cache *btrfs_inode_defrag_cachep;
 /*
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f3aa37c..07cda56 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -59,6 +59,7 @@
 #include "props.h"
 #include "sysfs.h"
 #include "qgroup.h"
+#include "compression.h"
 
 #ifdef CONFIG_64BIT
 /* If we have a 32-bit userspace and 64-bit kernel, then the UAPI
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 52170cf..82759bd 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -25,6 +25,7 @@
 #include "btrfs_inode.h"
 #include "extent_io.h"
 #include "disk-io.h"
+#include "compression.h"
 
 static struct kmem_cache *btrfs_ordered_extent_cache;
 
diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index dca137b..bcef516 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -22,6 +22,7 @@
 #include "hash.h"
 #include "transaction.h"
 #include "xattr.h"
+#include "compression.h"
 
 #define BTRFS_PROP_HANDLERS_HT_BITS 8
 static DEFINE_HASHTABLE(prop_handlers_ht, BTRFS_PROP_HANDLERS_HT_BITS);
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index aa72bfd..47940b3 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -34,6 +34,7 @@
 #include "disk-io.h"
 #include "btrfs_inode.h"
 #include "transaction.h"
+#include "compression.h"
 
 static int g_verbose = 0;
 
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c3f9a9c..6bfc138 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -26,6 +26,7 @@
 #include "print-tree.h"
 #include "backref.h"
 #include "hash.h"
+#include "compression.h"
 
 /* magic values for the inode_only field in btrfs_log_inode:
  *
-- 
2.6.3

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo
