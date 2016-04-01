Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:12218 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758245AbcDAGfg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Apr 2016 02:35:36 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v10 08/21] btrfs: ordered-extent: Add support for dedupe
Date: Fri,  1 Apr 2016 14:34:59 +0800
Message-Id: <1459492512-31435-9-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1459492512-31435-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1459492512-31435-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Add ordered-extent support for dedupe.

Note, current ordered-extent support only supports non-compressed source
extent.
Support for compressed source extent will be added later.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/ordered-data.c | 44 ++++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/ordered-data.h | 13 +++++++++++++
 2 files changed, 53 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 0de7da5..ef24ad1 100644
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
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_ordered_inode_tree *tree;
@@ -204,6 +206,31 @@ static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 	entry->inode = igrab(inode);
 	entry->compress_type = compress_type;
 	entry->truncated_len = (u64)-1;
+	entry->hash = NULL;
+	/*
+	 * Hash hit must go through dedupe routine at all cost, even dedupe
+	 * is disabled. As its delayed ref is already increased.
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
+		entry->hash = btrfs_dedupe_alloc_hash(dedupe_info->hash_type);
+		if (!entry->hash) {
+			kmem_cache_free(btrfs_ordered_extent_cache, entry);
+			return -ENOMEM;
+		}
+		entry->hash->bytenr = hash->bytenr;
+		entry->hash->num_bytes = hash->num_bytes;
+		memcpy(entry->hash->hash, hash->hash,
+		       btrfs_dedupe_sizes[dedupe_info->hash_type]);
+	}
+
 	if (type != BTRFS_ORDERED_IO_DONE && type != BTRFS_ORDERED_COMPLETE)
 		set_bit(type, &entry->flags);
 
@@ -250,15 +277,23 @@ int btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
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
@@ -267,7 +302,7 @@ int btrfs_add_ordered_extent_compress(struct inode *inode, u64 file_offset,
 {
 	return __btrfs_add_ordered_extent(inode, file_offset, start, len,
 					  disk_len, type, 0,
-					  compress_type);
+					  compress_type, NULL);
 }
 
 /*
@@ -577,6 +612,7 @@ void btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry)
 			list_del(&sum->list);
 			kfree(sum);
 		}
+		kfree(entry->hash);
 		kmem_cache_free(btrfs_ordered_extent_cache, entry);
 	}
 }
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 23c9605..8a54476 100644
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
+	 * If hash->bytenr is zero, means this is a dedupe miss, hash will
+	 * be added into dedupe tree.
+	 * If hash->bytenr is non-zero, this is a dedupe hit. Extent ref is
+	 * *ALREADY* increased.
+	 */
+	struct btrfs_dedupe_hash *hash;
 };
 
 /*
@@ -172,6 +182,9 @@ int btrfs_dec_test_first_ordered_pending(struct inode *inode,
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
2.7.4



