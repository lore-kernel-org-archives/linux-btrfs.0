Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:18117 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbcBEBY5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Feb 2016 20:24:57 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v6 08/19] btrfs: ordered-extent: Add support for dedup
Date: Fri,  5 Feb 2016 09:22:28 +0800
Message-Id: <1454635359-10013-9-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1454635359-10013-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1454635359-10013-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
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
 fs/btrfs/ordered-data.c | 43 +++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/ordered-data.h | 13 +++++++++++++
 2 files changed, 52 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 8c27292..973014b 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -25,6 +25,7 @@
 #include "btrfs_inode.h"
 #include "extent_io.h"
 #include "disk-io.h"
+#include "dedup.h"
 
 static struct kmem_cache *btrfs_ordered_extent_cache;
 
@@ -183,7 +184,8 @@ static inline struct rb_node *tree_search(struct btrfs_ordered_inode_tree *tree,
  */
 static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 				      u64 start, u64 len, u64 disk_len,
-				      int type, int dio, int compress_type)
+				      int type, int dio, int compress_type,
+				      struct btrfs_dedup_hash *hash)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_ordered_inode_tree *tree;
@@ -203,6 +205,30 @@ static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 	entry->inode = igrab(inode);
 	entry->compress_type = compress_type;
 	entry->truncated_len = (u64)-1;
+	entry->hash = NULL;
+	/*
+	 * Hash hit must go through dedup routine or we will screw
+	 * delayed refs
+	 */
+	if (hash && (hash->bytenr || root->fs_info->dedup_enabled)) {
+		struct btrfs_dedup_info *dedup_info = root->fs_info->dedup_info;
+
+		if (WARN_ON(dedup_info == NULL)) {
+			kmem_cache_free(btrfs_ordered_extent_cache,
+					entry);
+			return -EINVAL;
+		}
+		entry->hash = btrfs_dedup_alloc_hash(dedup_info->hash_type);
+		if (!entry->hash) {
+			kmem_cache_free(btrfs_ordered_extent_cache, entry);
+			return -ENOMEM;
+		}
+		entry->hash->bytenr = hash->bytenr;
+		entry->hash->num_bytes = hash->num_bytes;
+		memcpy(entry->hash->hash, hash->hash,
+		       btrfs_dedup_sizes[dedup_info->hash_type]);
+	}
+
 	if (type != BTRFS_ORDERED_IO_DONE && type != BTRFS_ORDERED_COMPLETE)
 		set_bit(type, &entry->flags);
 
@@ -249,15 +275,23 @@ int btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
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
@@ -266,7 +300,7 @@ int btrfs_add_ordered_extent_compress(struct inode *inode, u64 file_offset,
 {
 	return __btrfs_add_ordered_extent(inode, file_offset, start, len,
 					  disk_len, type, 0,
-					  compress_type);
+					  compress_type, NULL);
 }
 
 /*
@@ -576,6 +610,7 @@ void btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry)
 			list_del(&sum->list);
 			kfree(sum);
 		}
+		kfree(entry->hash);
 		kmem_cache_free(btrfs_ordered_extent_cache, entry);
 	}
 }
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
2.7.0



