Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:44502 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754482AbcCVBpa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 21:45:30 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v8 25/27] btrfs: dedupe: Add support for compression and dedpue
Date: Tue, 22 Mar 2016 09:35:50 +0800
Message-Id: <1458610552-9845-26-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

The basic idea is also calculate hash before compression, and add needed
members for dedupe to record compressed file extent.

Since dedupe support dedupe_bs larger than 128K, which is the up limit
of compression file extent, in that case we will skip dedupe and prefer
compression, as in that size dedupe rate is low and compression will be
more obvious.

Current implement is far from elegant. The most elegant one should split
every data processing method into its own and independent function, and
have a unified function to co-operate them.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/dedupe.h       |   8 ++++
 fs/btrfs/inode.c        | 107 +++++++++++++++++++++++++++++++++++++-----------
 fs/btrfs/ordered-data.c |   5 ++-
 fs/btrfs/ordered-data.h |   3 +-
 4 files changed, 95 insertions(+), 28 deletions(-)

diff --git a/fs/btrfs/dedupe.h b/fs/btrfs/dedupe.h
index ac6eeb3..af488b1 100644
--- a/fs/btrfs/dedupe.h
+++ b/fs/btrfs/dedupe.h
@@ -22,6 +22,7 @@
 #include <linux/btrfs.h>
 #include <linux/wait.h>
 #include <crypto/hash.h>
+#include "compression.h"
 
 /*
  * Dedup storage backend
@@ -89,6 +90,13 @@ static inline int btrfs_dedupe_hash_hit(struct btrfs_dedupe_hash *hash)
 	return (hash && hash->bytenr);
 }
 
+static inline int
+btrfs_dedupe_hash_compressed_hit(struct btrfs_dedupe_hash *hash)
+{
+	/* This judgment implied hash->bytenr != 0 */
+	return (hash && hash->compression != BTRFS_COMPRESS_NONE);
+}
+
 static inline int btrfs_dedupe_hash_size(u16 type)
 {
 	if (WARN_ON(type >= ARRAY_SIZE(btrfs_dedupe_sizes)))
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 35d1ec4..8a2a76a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -412,13 +412,15 @@ static noinline void compress_file_range(struct inode *inode,
 					struct page *locked_page,
 					u64 start, u64 end,
 					struct async_cow *async_cow,
-					int *num_added)
+					int *num_added,
+					struct btrfs_dedupe_hash *hash)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	u64 num_bytes;
 	u64 blocksize = root->sectorsize;
 	u64 actual_end;
 	u64 isize = i_size_read(inode);
+	u64 orig_start = start;
 	int ret = 0;
 	struct page **pages = NULL;
 	unsigned long nr_pages;
@@ -618,10 +620,18 @@ cont:
 		/* the async work queues will take care of doing actual
 		 * allocation on disk for these compressed pages,
 		 * and will submit them to the elevator.
+		 *
+		 * And if we generate two or more compressed extent, we
+		 * should not go through dedup routine
+		 * TODO: freeing hash should be done by caller
 		 */
+		if (start + num_bytes < end) {
+			kfree(hash);
+			hash = NULL;
+		}
 		add_async_extent(async_cow, start, num_bytes,
 				 total_compressed, pages, nr_pages_ret,
-				 compress_type, NULL);
+				 compress_type, hash);
 
 		if (start + num_bytes < end) {
 			start += num_bytes;
@@ -645,8 +655,12 @@ cleanup_and_bail_uncompressed:
 		}
 		if (redirty)
 			extent_range_redirty_for_io(inode, start, end);
+		if (orig_start != start) {
+			kfree(hash);
+			hash = NULL;
+		}
 		add_async_extent(async_cow, start, end - start + 1,
-				 0, NULL, 0, BTRFS_COMPRESS_NONE, NULL);
+				 0, NULL, 0, BTRFS_COMPRESS_NONE, hash);
 		*num_added += 1;
 	}
 
@@ -727,7 +741,7 @@ static void end_dedupe_extent(struct inode *inode, u64 start,
  * and send them down to the disk.
  */
 static noinline void submit_compressed_extents(struct inode *inode,
-					      struct async_cow *async_cow)
+					       struct async_cow *async_cow)
 {
 	struct async_extent *async_extent;
 	u64 alloc_hint = 0;
@@ -749,8 +763,13 @@ again:
 		hash = async_extent->hash;
 
 retry:
-		/* did the compression code fall back to uncompressed IO? */
-		if (!async_extent->pages) {
+		/*
+		 * The extent doesn't contain any compressed data (from
+		 * compression or inband dedupe)
+		 * TODO: Merge this branch to compressed branch
+		 */
+		if (!(async_extent->pages ||
+		      btrfs_dedupe_hash_compressed_hit(hash))) {
 			int page_started = 0;
 			unsigned long nr_written = 0;
 
@@ -802,10 +821,15 @@ retry:
 		lock_extent(io_tree, async_extent->start,
 			    async_extent->start + async_extent->ram_size - 1);
 
-		ret = btrfs_reserve_extent(root,
+		if (btrfs_dedupe_hash_hit(hash)) {
+			ins.objectid = hash->bytenr;
+			ins.offset = hash->disk_num_bytes;
+		} else {
+			ret = btrfs_reserve_extent(root,
 					   async_extent->compressed_size,
 					   async_extent->compressed_size,
 					   0, alloc_hint, &ins, 1, 1);
+		}
 		if (ret) {
 			free_async_extent_pages(async_extent);
 
@@ -880,7 +904,8 @@ retry:
 						async_extent->ram_size,
 						ins.offset,
 						BTRFS_ORDERED_COMPRESSED,
-						async_extent->compress_type);
+						async_extent->compress_type,
+						hash);
 		if (ret) {
 			btrfs_drop_extent_cache(inode, async_extent->start,
 						async_extent->start +
@@ -897,12 +922,17 @@ retry:
 				NULL, EXTENT_LOCKED | EXTENT_DELALLOC,
 				PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
 				PAGE_SET_WRITEBACK);
-		ret = btrfs_submit_compressed_write(inode,
-				    async_extent->start,
-				    async_extent->ram_size,
-				    ins.objectid,
-				    ins.offset, async_extent->pages,
-				    async_extent->nr_pages);
+		if (btrfs_dedupe_hash_hit(hash))
+			end_dedupe_extent(inode, async_extent->start,
+					  async_extent->ram_size,
+					  PAGE_END_WRITEBACK);
+		else
+			ret = btrfs_submit_compressed_write(inode,
+					async_extent->start,
+					async_extent->ram_size,
+					ins.objectid,
+					ins.offset, async_extent->pages,
+					async_extent->nr_pages);
 		if (ret) {
 			struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
 			struct page *p = async_extent->pages[0];
@@ -1160,6 +1190,7 @@ static int hash_file_ranges(struct inode *inode, u64 start, u64 end,
 	u64 dedupe_bs;
 	u64 cur_offset = start;
 	int ret = 0;
+	int need_compress = inode_need_compress(inode);
 
 	actual_end = min_t(u64, isize, end + 1);
 	/* If dedupe is not enabled, don't split extent into dedupe_bs */
@@ -1177,7 +1208,14 @@ static int hash_file_ranges(struct inode *inode, u64 start, u64 end,
 		u64 len;
 
 		len = min(end + 1 - cur_offset, dedupe_bs);
-		if (len < dedupe_bs)
+		/*
+		 * If dedupe_size is larger than compression extent up limit
+		 * (128K), we prefer compression other than dedupe.
+		 * As larger dedupe bs will lead to much lower dedupe rate
+		 * and normally, compression is more obvious than dedupe
+		 */
+		if (len < dedupe_bs || (need_compress == 1
+					&& dedupe_bs > SZ_128K))
 			goto next;
 
 		hash = btrfs_dedupe_alloc_hash(hash_algo);
@@ -1200,10 +1238,24 @@ next:
 		    page_offset(locked_page) <= end)
 			__set_page_dirty_nobuffers(locked_page);
 
-		add_async_extent(async_cow, cur_offset, len, 0, NULL, 0,
-				 BTRFS_COMPRESS_NONE, hash);
+		if (btrfs_dedupe_hash_hit(hash)) {
+			/* Dedupe found */
+			add_async_extent(async_cow, cur_offset, len,
+					 hash->disk_num_bytes, NULL, 0,
+					 hash->compression, hash);
+			(*num_added)++;
+		} else if (need_compress) {
+			/* Compression */
+			compress_file_range(inode, locked_page, cur_offset,
+					    cur_offset + len - 1, async_cow,
+					    num_added, hash);
+		} else {
+			/* No compression, dedupe not found */
+			add_async_extent(async_cow, cur_offset, len, 0, NULL, 0,
+					 BTRFS_COMPRESS_NONE, hash);
+			(*num_added)++;
+		}
 		cur_offset += len;
-		(*num_added)++;
 	}
 out:
 	return ret;
@@ -1215,21 +1267,26 @@ out:
 static noinline void async_cow_start(struct btrfs_work *work)
 {
 	struct async_cow *async_cow;
+	struct inode *inode;
+	struct btrfs_fs_info *fs_info;
 	int num_added = 0;
 	int ret = 0;
+
 	async_cow = container_of(work, struct async_cow, work);
+	inode = async_cow->inode;
+	fs_info = BTRFS_I(inode)->root->fs_info;
 
-	if (inode_need_compress(async_cow->inode))
+	if (!inode_need_dedupe(fs_info, inode))
 		compress_file_range(async_cow->inode, async_cow->locked_page,
 				    async_cow->start, async_cow->end, async_cow,
-				    &num_added);
+				    &num_added, NULL);
 	else
-		ret = hash_file_ranges(async_cow->inode, async_cow->start,
+		ret = hash_file_ranges(inode, async_cow->start,
 				       async_cow->end, async_cow, &num_added);
 	WARN_ON(ret);
 
 	if (num_added == 0) {
-		btrfs_add_delayed_iput(async_cow->inode);
+		btrfs_add_delayed_iput(inode);
 		async_cow->inode = NULL;
 	}
 }
@@ -2313,9 +2370,9 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	/* Add missed hash into dedupe tree */
 	if (hash && hash->bytenr == 0) {
 		hash->bytenr = ins.objectid;
-		hash->num_bytes = ins.offset;
-		hash->disk_num_bytes = hash->num_bytes;
-		hash->compression = BTRFS_COMPRESS_NONE;
+		hash->num_bytes = ram_bytes;
+		hash->disk_num_bytes = ins.offset;
+		hash->compression = compression;
 		ret = btrfs_dedupe_add(trans, root->fs_info, hash);
 	}
 
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 695c0e2..052f810 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -300,11 +300,12 @@ int btrfs_add_ordered_extent_dio(struct inode *inode, u64 file_offset,
 
 int btrfs_add_ordered_extent_compress(struct inode *inode, u64 file_offset,
 				      u64 start, u64 len, u64 disk_len,
-				      int type, int compress_type)
+				      int type, int compress_type,
+				      struct btrfs_dedupe_hash *hash)
 {
 	return __btrfs_add_ordered_extent(inode, file_offset, start, len,
 					  disk_len, type, 0,
-					  compress_type, NULL);
+					  compress_type, hash);
 }
 
 /*
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 8a54476..8ff4dcb 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -189,7 +189,8 @@ int btrfs_add_ordered_extent_dio(struct inode *inode, u64 file_offset,
 				 u64 start, u64 len, u64 disk_len, int type);
 int btrfs_add_ordered_extent_compress(struct inode *inode, u64 file_offset,
 				      u64 start, u64 len, u64 disk_len,
-				      int type, int compress_type);
+				      int type, int compress_type,
+				      struct btrfs_dedupe_hash *hash);
 void btrfs_add_ordered_sum(struct inode *inode,
 			   struct btrfs_ordered_extent *entry,
 			   struct btrfs_ordered_sum *sum);
-- 
2.7.3



