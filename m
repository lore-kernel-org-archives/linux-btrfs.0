Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20074 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585AbcCJJ1N (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Mar 2016 04:27:13 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2] btrfs: move btrfs_compression_type to compression.h
Date: Thu, 10 Mar 2016 17:26:59 +0800
Message-Id: <1457602019-11025-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1457585397-6499-1-git-send-email-anand.jain@oracle.com>
References: <1457585397-6499-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So that its better organized.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2: Fix compile failure with other possible flags in .config.
    Thanks 0-day Bot.

 fs/btrfs/check-integrity.c   | 1 +
 fs/btrfs/compression.h       | 9 +++++++++
 fs/btrfs/ctree.h             | 8 --------
 fs/btrfs/disk-io.c           | 1 +
 fs/btrfs/extent_map.c        | 1 +
 fs/btrfs/file-item.c         | 1 +
 fs/btrfs/file.c              | 1 +
 fs/btrfs/ioctl.c             | 1 +
 fs/btrfs/ordered-data.c      | 1 +
 fs/btrfs/props.c             | 1 +
 fs/btrfs/send.c              | 1 +
 fs/btrfs/tests/inode-tests.c | 1 +
 fs/btrfs/tree-log.c          | 1 +
 13 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 861d472564c1..c63be7270d41 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -105,6 +105,7 @@
 #include "locking.h"
 #include "check-integrity.h"
 #include "rcu-string.h"
+#include "compression.h"
 
 #define BTRFSIC_BLOCK_HASHTABLE_SIZE 0x10000
 #define BTRFSIC_BLOCK_LINK_HASHTABLE_SIZE 0x10000
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 13a4dc0436c9..f49d8b8c0f00 100644
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
index b69ad1305b71..0ef28fd2bd27 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -718,14 +718,6 @@ struct btrfs_timespec {
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
index a998ef15ec6d..53525a54608b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -50,6 +50,7 @@
 #include "raid56.h"
 #include "sysfs.h"
 #include "qgroup.h"
+#include "compression.h"
 
 #ifdef CONFIG_X86
 #include <asm/cpufeature.h>
diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index cdbadeaef202..cca21ff6553b 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -4,6 +4,7 @@
 #include <linux/hardirq.h>
 #include "ctree.h"
 #include "extent_map.h"
+#include "compression.h"
 
 
 static struct kmem_cache *extent_map_cache;
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 1c50a7b09b4e..763fd170ff16 100644
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
index 03de2466db23..aa0f09c21637 100644
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
index e802e315d8b7..190a8ebeaafa 100644
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
index 988eb1513aa5..86e1688c13b2 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -25,6 +25,7 @@
 #include "btrfs_inode.h"
 #include "extent_io.h"
 #include "disk-io.h"
+#include "compression.h"
 
 static struct kmem_cache *btrfs_ordered_extent_cache;
 
diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index f9e60231f685..36992128c746 100644
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
index d2e29925f1da..19b7bf4284ee 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -34,6 +34,7 @@
 #include "disk-io.h"
 #include "btrfs_inode.h"
 #include "transaction.h"
+#include "compression.h"
 
 static int g_verbose = 0;
 
diff --git a/fs/btrfs/tests/inode-tests.c b/fs/btrfs/tests/inode-tests.c
index e2d3da02deee..863a6a3af1f8 100644
--- a/fs/btrfs/tests/inode-tests.c
+++ b/fs/btrfs/tests/inode-tests.c
@@ -22,6 +22,7 @@
 #include "../disk-io.h"
 #include "../extent_io.h"
 #include "../volumes.h"
+#include "../compression.h"
 
 static void insert_extent(struct btrfs_root *root, u64 start, u64 len,
 			  u64 ram_bytes, u64 offset, u64 disk_bytenr,
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 978c3a810893..3c0a24f289a2 100644
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
2.7.0

