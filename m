Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22809 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751492AbdCPH7g (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Mar 2017 03:59:36 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v14.2 11/16] btrfs: ordered-extent: Add support for dedupe
Date: Thu, 16 Mar 2017 15:58:49 +0800
Message-ID: <20170316075854.15788-12-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170316075854.15788-1-quwenruo@cn.fujitsu.com>
References: <20170316075854.15788-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Add ordered-extent support for dedupe.

Note, current ordered-extent support only supports non-compressed source
extent.
Support for compressed source extent will be added later.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Reviewed-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/ordered-data.c | 46 ++++++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/ordered-data.h | 13 +++++++++++++
 2 files changed, 55 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 9a46878ba60f..511cbb86604e 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -26,6 +26,7 @@
 #include "extent_io.h"
 #include "disk-io.h"
 #include "compression.h"
+#include "dedupe.h"
 
 static struct kmem_cache *btrfs_ordered_extent_cache;
 
@@ -184,7 +185,8 @@ static inline struct rb_node *tree_search(struct btrfs_ordered_inode_tree *tree,
  */
 static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 				      u64 start, u64 len, u64 disk_len,
-				      int type, int dio, int compress_type)
+				      int type, int dio, int compress_type,
+				      struct btrfs_dedupe_hash *hash)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -205,6 +207,33 @@ static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 	entry->inode = igrab(inode);
 	entry->compress_type = compress_type;
 	entry->truncated_len = (u64)-1;
+	entry->hash = NULL;
+	/*
+	 * A hash hit means we have already incremented the extents delayed
+	 * ref.
+	 * We must handle this even if another process is trying to
+	 * turn off dedupe, otherwise we will leak a reference.
+	 */
+	if (hash && (hash->bytenr || root->fs_info->dedupe_enabled)) {
+		struct btrfs_dedupe_info *dedupe_info;
+
+		dedupe_info = root->fs_info->dedupe_info;
+		if (WARN_ON(dedupe_info == NULL)) {
+			kmem_cache_free(btrfs_ordered_extent_cache,
+					entry);
+			return -EINVAL;
+		}
+		entry->hash = btrfs_dedupe_alloc_hash(dedupe_info->hash_algo);
+		if (!entry->hash) {
+			kmem_cache_free(btrfs_ordered_extent_cache, entry);
+			return -ENOMEM;
+		}
+		entry->hash->bytenr = hash->bytenr;
+		entry->hash->num_bytes = hash->num_bytes;
+		memcpy(entry->hash->hash, hash->hash,
+		       btrfs_hash_sizes[dedupe_info->hash_algo]);
+	}
+
 	if (type != BTRFS_ORDERED_IO_DONE && type != BTRFS_ORDERED_COMPLETE)
 		set_bit(type, &entry->flags);
 
@@ -250,15 +279,23 @@ int btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 {
 	return __btrfs_add_ordered_extent(inode, file_offset, start, len,
 					  disk_len, type, 0,
-					  BTRFS_COMPRESS_NONE);
+					  BTRFS_COMPRESS_NONE, NULL);
 }
 
+int btrfs_add_ordered_extent_dedupe(struct inode *inode, u64 file_offset,
+				   u64 start, u64 len, u64 disk_len, int type,
+				   struct btrfs_dedupe_hash *hash)
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
@@ -267,7 +304,7 @@ int btrfs_add_ordered_extent_compress(struct inode *inode, u64 file_offset,
 {
 	return __btrfs_add_ordered_extent(inode, file_offset, start, len,
 					  disk_len, type, 0,
-					  compress_type);
+					  compress_type, NULL);
 }
 
 /*
@@ -578,6 +615,7 @@ void btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry)
 			list_del(&sum->list);
 			kfree(sum);
 		}
+		kfree(entry->hash);
 		kmem_cache_free(btrfs_ordered_extent_cache, entry);
 	}
 }
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 195c93b67fe0..172c0bd03879 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -141,6 +141,16 @@ struct btrfs_ordered_extent {
 	struct completion completion;
 	struct btrfs_work flush_work;
 	struct list_head work_list;
+
+	/*
+	 * For inband deduplication
+	 * If hash is NULL, no deduplication.
+	 * If hash->bytenr is zero, means this is a dedupe miss, hash will
+	 * be added into dedupe tree.
+	 * If hash->bytenr is non-zero, this is a dedupe hit. Extent ref is
+	 * *ALREADY* increased.
+	 */
+	struct btrfs_dedupe_hash *hash;
 };
 
 /*
@@ -174,6 +184,9 @@ int btrfs_dec_test_first_ordered_pending(struct inode *inode,
 				   int uptodate);
 int btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 			     u64 start, u64 len, u64 disk_len, int type);
+int btrfs_add_ordered_extent_dedupe(struct inode *inode, u64 file_offset,
+				   u64 start, u64 len, u64 disk_len, int type,
+				   struct btrfs_dedupe_hash *hash);
 int btrfs_add_ordered_extent_dio(struct inode *inode, u64 file_offset,
 				 u64 start, u64 len, u64 disk_len, int type);
 int btrfs_add_ordered_extent_compress(struct inode *inode, u64 file_offset,
-- 
2.12.0



