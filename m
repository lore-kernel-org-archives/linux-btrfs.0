Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:49498 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752365AbcAGBIs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jan 2016 20:08:48 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id 4BF224092565
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Jan 2016 09:08:24 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v3 09/16] btrfs: ordered-extent: Add support for dedup
Date: Thu, 7 Jan 2016 09:08:10 +0800
Message-ID: <1452128897-5433-10-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1452128897-5433-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1452128897-5433-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Add ordered-extent support for dedup.

Note, current ordered-extent support only supports non-compressed source
extent.
Support for compressed source extent will be added later.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/ordered-data.c | 33 +++++++++++++++++++++++++++++----
 fs/btrfs/ordered-data.h | 13 +++++++++++++
 2 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 8c27292..46493f5 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -25,6 +25,7 @@
 #include "btrfs_inode.h"
 #include "extent_io.h"
 #include "disk-io.h"
+#include "dedup.h"
 
 static struct kmem_cache *btrfs_ordered_extent_cache;
 
@@ -183,12 +184,14 @@ static inline struct rb_node *tree_search(struct btrfs_ordered_inode_tree *tree,
  */
 static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 				      u64 start, u64 len, u64 disk_len,
-				      int type, int dio, int compress_type)
+				      int type, int dio, int compress_type,
+				      struct btrfs_dedup_hash *hash)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_ordered_inode_tree *tree;
 	struct rb_node *node;
 	struct btrfs_ordered_extent *entry;
+	struct btrfs_dedup_info *dedup_info = root->fs_info->dedup_info;
 
 	tree = &BTRFS_I(inode)->ordered_tree;
 	entry = kmem_cache_zalloc(btrfs_ordered_extent_cache, GFP_NOFS);
@@ -203,6 +206,20 @@ static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 	entry->inode = igrab(inode);
 	entry->compress_type = compress_type;
 	entry->truncated_len = (u64)-1;
+	entry->hash = NULL;
+	if (hash && dedup_info) {
+		entry->hash = btrfs_dedup_alloc_hash(dedup_info->hash_type);
+		if (!entry->hash) {
+			kmem_cache_free(btrfs_ordered_extent_cache, entry);
+			return -ENOMEM;
+		}
+		/* Hash contains locks, only copy what we need */
+		entry->hash->bytenr = hash->bytenr;
+		entry->hash->num_bytes = hash->num_bytes;
+		memcpy(entry->hash->hash, hash->hash,
+		       btrfs_dedup_sizes[dedup_info->hash_type]);
+	}
+
 	if (type != BTRFS_ORDERED_IO_DONE && type != BTRFS_ORDERED_COMPLETE)
 		set_bit(type, &entry->flags);
 
@@ -249,15 +266,23 @@ int btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 {
 	return __btrfs_add_ordered_extent(inode, file_offset, start, len,
 					  disk_len, type, 0,
-					  BTRFS_COMPRESS_NONE);
+					  BTRFS_COMPRESS_NONE, NULL);
 }
 
+int btrfs_add_ordered_extent_dedup(struct inode *inode, u64 file_offset,
+				   u64 start, u64 len, u64 disk_len, int type,
+				   struct btrfs_dedup_hash *hash)
+{
+	return __btrfs_add_ordered_extent(inode, file_offset, start, len,
+					  disk_len, type, 0,
+					  BTRFS_COMPRESS_NONE, hash);
+}
 int btrfs_add_ordered_extent_dio(struct inode *inode, u64 file_offset,
 				 u64 start, u64 len, u64 disk_len, int type)
 {
 	return __btrfs_add_ordered_extent(inode, file_offset, start, len,
 					  disk_len, type, 1,
-					  BTRFS_COMPRESS_NONE);
+					  BTRFS_COMPRESS_NONE, NULL);
 }
 
 int btrfs_add_ordered_extent_compress(struct inode *inode, u64 file_offset,
@@ -266,7 +291,7 @@ int btrfs_add_ordered_extent_compress(struct inode *inode, u64 file_offset,
 {
 	return __btrfs_add_ordered_extent(inode, file_offset, start, len,
 					  disk_len, type, 0,
-					  compress_type);
+					  compress_type, NULL);
 }
 
 /*
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 23c9605..58519ce 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -139,6 +139,16 @@ struct btrfs_ordered_extent {
 	struct completion completion;
 	struct btrfs_work flush_work;
 	struct list_head work_list;
+
+	/*
+	 * For inband deduplication
+	 * If hash is NULL, no deduplication.
+	 * If hash->bytenr is zero, means this is a dedup miss, hash will
+	 * be added into dedup tree.
+	 * If hash->bytenr is non-zero, this is a dedup hit. Extent ref is
+	 * *ALREADY* increased.
+	 */
+	struct btrfs_dedup_hash *hash;
 };
 
 /*
@@ -172,6 +182,9 @@ int btrfs_dec_test_first_ordered_pending(struct inode *inode,
 				   int uptodate);
 int btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 			     u64 start, u64 len, u64 disk_len, int type);
+int btrfs_add_ordered_extent_dedup(struct inode *inode, u64 file_offset,
+				   u64 start, u64 len, u64 disk_len, int type,
+				   struct btrfs_dedup_hash *hash);
 int btrfs_add_ordered_extent_dio(struct inode *inode, u64 file_offset,
 				 u64 start, u64 len, u64 disk_len, int type);
 int btrfs_add_ordered_extent_compress(struct inode *inode, u64 file_offset,
-- 
2.6.4



