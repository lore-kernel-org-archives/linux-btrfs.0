Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:19696 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2403831AbeGLBdW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Jul 2018 21:33:22 -0400
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v14.8 11/14] btrfs: dedupe: Inband in-memory only de-duplication implement
Date: Thu, 12 Jul 2018 09:25:50 +0800
Message-ID: <20180712012553.29431-12-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180712012553.29431-1-lufq.fnst@cn.fujitsu.com>
References: <20180712012553.29431-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

Core implement for inband de-duplication.
It reuses the async_cow_start() facility to do the calculate dedupe hash.
And use dedupe hash to do inband de-duplication at extent level.

The workflow is as below:
1) Run delalloc range for an inode
2) Calculate hash for the delalloc range at the unit of dedupe_bs
3) For hash match(duplicated) case, just increase source extent ref
   and insert file extent.
   For hash mismatch case, go through the normal cow_file_range()
   fallback, and add hash into dedupe_tree.
   Compress for hash miss case is not supported yet.

Current implement restore all dedupe hash in memory rb-tree, with LRU
behavior to control the limit.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       |   4 +-
 fs/btrfs/dedupe.h      |  18 +++
 fs/btrfs/extent-tree.c |  31 ++++-
 fs/btrfs/extent_io.c   |   5 +-
 fs/btrfs/extent_io.h   |   1 +
 fs/btrfs/file.c        |   3 +
 fs/btrfs/inode.c       | 305 ++++++++++++++++++++++++++++++++++-------
 fs/btrfs/ioctl.c       |   1 +
 fs/btrfs/relocation.c  |  17 +++
 9 files changed, 329 insertions(+), 56 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index ad31ccac86a3..8fff17adc8d2 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -107,9 +107,11 @@ static inline u32 count_max_extents(u64 size, u64 max_extent_size)
 enum btrfs_metadata_reserve_type {
 	BTRFS_RESERVE_NORMAL,
 	BTRFS_RESERVE_COMPRESS,
+	BTRFS_RESERVE_DEDUPE,
 };
 
-u64 btrfs_max_extent_size(enum btrfs_metadata_reserve_type reserve_type);
+u64 btrfs_max_extent_size(struct btrfs_inode *inode,
+			  enum btrfs_metadata_reserve_type reserve_type);
 int inode_need_compress(struct inode *inode, u64 start, u64 end);
 
 struct btrfs_mapping_tree {
diff --git a/fs/btrfs/dedupe.h b/fs/btrfs/dedupe.h
index f19f6a8ff2ba..ebcbb89d79a0 100644
--- a/fs/btrfs/dedupe.h
+++ b/fs/btrfs/dedupe.h
@@ -9,6 +9,7 @@
 #include <linux/btrfs.h>
 #include <linux/wait.h>
 #include <crypto/hash.h>
+#include "btrfs_inode.h"
 
 static const int btrfs_hash_sizes[] = { 32 };
 
@@ -50,6 +51,23 @@ struct btrfs_dedupe_info {
 
 struct btrfs_trans_handle;
 
+static inline u64 btrfs_dedupe_blocksize(struct btrfs_inode *inode)
+{
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
+
+	return fs_info->dedupe_info->blocksize;
+}
+
+static inline int inode_need_dedupe(struct inode *inode)
+{
+	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
+
+	if (!fs_info->dedupe_enabled)
+		return 0;
+
+	return 1;
+}
+
 static inline int btrfs_dedupe_hash_hit(struct btrfs_dedupe_hash *hash)
 {
 	return (hash && hash->bytenr);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 225ebcb1fd09..7a3a9d3fb0b9 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -28,6 +28,7 @@
 #include "sysfs.h"
 #include "qgroup.h"
 #include "ref-verify.h"
+#include "dedupe.h"
 
 #undef SCRAMBLE_DELAYED_REFS
 
@@ -2612,6 +2613,17 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
 		btrfs_pin_extent(fs_info, head->bytenr,
 				 head->num_bytes, 1);
 		if (head->is_data) {
+			/*
+			 * If insert_reserved is given, it means
+			 * a new extent is revered, then deleted
+			 * in one tran, and inc/dec get merged to 0.
+			 *
+			 * In this case, we need to remove its dedupe
+			 * hash.
+			 */
+			ret = btrfs_dedupe_del(trans, fs_info, head->bytenr);
+			if (ret < 0)
+				return ret;
 			ret = btrfs_del_csums(trans, fs_info, head->bytenr,
 					      head->num_bytes);
 		}
@@ -6017,15 +6029,17 @@ static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
 	spin_unlock(&block_rsv->lock);
 }
 
-u64 btrfs_max_extent_size(enum btrfs_metadata_reserve_type reserve_type)
+u64 btrfs_max_extent_size(struct btrfs_inode *inode,
+			  enum btrfs_metadata_reserve_type reserve_type)
 {
 	if (reserve_type == BTRFS_RESERVE_NORMAL)
 		return BTRFS_MAX_EXTENT_SIZE;
 	else if (reserve_type == BTRFS_RESERVE_COMPRESS)
 		return SZ_128K;
-
-	ASSERT(0);
-	return BTRFS_MAX_EXTENT_SIZE;
+	else if (reserve_type == BTRFS_RESERVE_DEDUPE)
+		return btrfs_dedupe_blocksize(inode);
+	else
+		return BTRFS_MAX_EXTENT_SIZE;
 }
 
 int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes,
@@ -6036,7 +6050,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes,
 	enum btrfs_reserve_flush_enum flush = BTRFS_RESERVE_FLUSH_ALL;
 	int ret = 0;
 	bool delalloc_lock = true;
-	u64 max_extent_size = btrfs_max_extent_size(reserve_type);
+	u64 max_extent_size = btrfs_max_extent_size(inode, reserve_type);
 
 	/* If we are a free space inode we need to not flush since we will be in
 	 * the middle of a transaction commit.  We also don't need the delalloc
@@ -6139,7 +6153,7 @@ void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes,
 				enum btrfs_metadata_reserve_type reserve_type)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
-	u64 max_extent_size = btrfs_max_extent_size(reserve_type);
+	u64 max_extent_size = btrfs_max_extent_size(inode, reserve_type);
 	unsigned num_extents;
 
 	spin_lock(&inode->lock);
@@ -7089,6 +7103,11 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 		btrfs_release_path(path);
 
 		if (is_data) {
+			ret = btrfs_dedupe_del(trans, info, bytenr);
+			if (ret < 0) {
+				btrfs_abort_transaction(trans, ret);
+				goto out;
+			}
 			ret = btrfs_del_csums(trans, info, bytenr, num_bytes);
 			if (ret) {
 				btrfs_abort_transaction(trans, ret);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 25d1c302dd47..6a34200db0d2 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -596,7 +596,7 @@ int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	btrfs_debug_check_extent_io_range(tree, start, end);
 
 	if (bits & EXTENT_DELALLOC)
-		bits |= EXTENT_NORESERVE | EXTENT_COMPRESS;
+		bits |= EXTENT_NORESERVE | EXTENT_COMPRESS | EXTENT_DEDUPE;
 
 	if (delete)
 		bits |= ~EXTENT_CTLBITS;
@@ -1508,7 +1508,8 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 		state = rb_entry(node, struct extent_state, rb_node);
 		if (found && (state->start != cur_start ||
 			      (state->state & EXTENT_BOUNDARY) ||
-			      (state->state ^ pre_state) & EXTENT_COMPRESS)) {
+			      (state->state ^ pre_state) & (EXTENT_COMPRESS |
+			       EXTENT_DEDUPE))) {
 			goto out;
 		}
 		if (!(state->state & EXTENT_DELALLOC)) {
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 4eabbbaa17e9..efc2f58d856a 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -26,6 +26,7 @@
 #define EXTENT_CLEAR_DATA_RESV	(1U << 17)
 #define EXTENT_DELALLOC_NEW	(1U << 18)
 #define EXTENT_COMPRESS		(1U << 19)
+#define EXTENT_DEDUPE		(1U << 20)
 #define EXTENT_IOBITS		(EXTENT_LOCKED | EXTENT_WRITEBACK)
 #define EXTENT_DO_ACCOUNTING    (EXTENT_CLEAR_META_RESV | \
 				 EXTENT_CLEAR_DATA_RESV)
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index b503b255b65b..2ae77330415c 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -29,6 +29,7 @@
 #include "volumes.h"
 #include "qgroup.h"
 #include "compression.h"
+#include "dedupe.h"
 
 static struct kmem_cache *btrfs_inode_defrag_cachep;
 /*
@@ -1600,6 +1601,8 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 
 	if (inode_need_compress(inode, -1, 0))
 		reserve_type = BTRFS_RESERVE_COMPRESS;
+	else if (inode_need_dedupe(inode))
+		reserve_type = BTRFS_RESERVE_DEDUPE;
 
 	while (iov_iter_count(i) > 0) {
 		size_t offset = pos & (PAGE_SIZE - 1);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d58d984fc3af..88c3dea5ef21 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -357,6 +357,8 @@ struct async_extent {
 	struct page **pages;
 	unsigned long nr_pages;
 	int compress_type;
+	int dedupe;
+	struct btrfs_dedupe_hash *hash;
 	struct list_head list;
 };
 
@@ -369,6 +371,7 @@ struct async_cow {
 	unsigned int write_flags;
 	struct list_head extents;
 	struct btrfs_work work;
+	enum btrfs_metadata_reserve_type reserve_type;
 };
 
 static noinline int add_async_extent(struct async_cow *cow,
@@ -376,7 +379,8 @@ static noinline int add_async_extent(struct async_cow *cow,
 				     u64 compressed_size,
 				     struct page **pages,
 				     unsigned long nr_pages,
-				     int compress_type)
+				     int compress_type, int dedupe,
+				     struct btrfs_dedupe_hash *hash)
 {
 	struct async_extent *async_extent;
 
@@ -388,6 +392,8 @@ static noinline int add_async_extent(struct async_cow *cow,
 	async_extent->pages = pages;
 	async_extent->nr_pages = nr_pages;
 	async_extent->compress_type = compress_type;
+	async_extent->dedupe = dedupe;
+	async_extent->hash = hash;
 	list_add_tail(&async_extent->list, &cow->extents);
 	return 0;
 }
@@ -627,7 +633,7 @@ static noinline void compress_file_range(struct inode *inode,
 			 */
 			add_async_extent(async_cow, start, total_in,
 					total_compressed, pages, nr_pages,
-					compress_type);
+					compress_type, 0, NULL);
 
 			if (start + total_in < end) {
 				start += total_in;
@@ -673,7 +679,7 @@ static noinline void compress_file_range(struct inode *inode,
 	if (redirty)
 		extent_range_redirty_for_io(inode, start, end);
 	add_async_extent(async_cow, start, end - start + 1, 0, NULL, 0,
-			 BTRFS_COMPRESS_NONE);
+			 BTRFS_COMPRESS_NONE, 0, NULL);
 	*num_added += 1;
 
 	return;
@@ -702,6 +708,38 @@ static void free_async_extent_pages(struct async_extent *async_extent)
 	async_extent->pages = NULL;
 }
 
+static void end_dedupe_extent(struct inode *inode, u64 start,
+			      u32 len, unsigned long page_ops)
+{
+	int i;
+	unsigned int nr_pages = len / PAGE_SIZE;
+	struct page *page;
+
+	for (i = 0; i < nr_pages; i++) {
+		page = find_get_page(inode->i_mapping,
+				     start >> PAGE_SHIFT);
+		/* page should be already locked by caller */
+		if (WARN_ON(!page))
+			continue;
+
+		/* We need to do this by ourselves as we skipped IO */
+		if (page_ops & PAGE_CLEAR_DIRTY)
+			clear_page_dirty_for_io(page);
+		if (page_ops & PAGE_SET_WRITEBACK)
+			set_page_writeback(page);
+
+		end_extent_writepage(page, 0, start,
+				     start + PAGE_SIZE - 1);
+		if (page_ops & PAGE_END_WRITEBACK)
+			end_page_writeback(page);
+		if (page_ops & PAGE_UNLOCK)
+			unlock_page(page);
+
+		start += PAGE_SIZE;
+		put_page(page);
+	}
+}
+
 /*
  * phase two of compressed writeback.  This is the ordered portion
  * of the code, which only gets called in the order the work was
@@ -718,6 +756,7 @@ static noinline void submit_compressed_extents(struct inode *inode,
 	struct extent_map *em;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct extent_io_tree *io_tree;
+	struct btrfs_dedupe_hash *hash;
 	int ret = 0;
 
 again:
@@ -727,6 +766,7 @@ static noinline void submit_compressed_extents(struct inode *inode,
 		list_del(&async_extent->list);
 
 		io_tree = &BTRFS_I(inode)->io_tree;
+		hash = async_extent->hash;
 
 retry:
 		/* did the compression code fall back to uncompressed IO? */
@@ -746,7 +786,7 @@ static noinline void submit_compressed_extents(struct inode *inode,
 					     async_extent->start +
 					     async_extent->ram_size - 1,
 					     &page_started, &nr_written, 0,
-					     NULL);
+					     hash);
 
 			/* JDM XXX */
 
@@ -756,14 +796,26 @@ static noinline void submit_compressed_extents(struct inode *inode,
 			 * and IO for us.  Otherwise, we need to submit
 			 * all those pages down to the drive.
 			 */
-			if (!page_started && !ret)
-				extent_write_locked_range(inode,
-						  async_extent->start,
-						  async_extent->start +
-						  async_extent->ram_size - 1,
-						  WB_SYNC_ALL);
-			else if (ret)
+			if (!page_started && !ret) {
+				/* Skip IO for dedupe async_extent */
+				if (btrfs_dedupe_hash_hit(hash))
+					end_dedupe_extent(inode,
+						async_extent->start,
+						async_extent->ram_size,
+						PAGE_CLEAR_DIRTY |
+						PAGE_SET_WRITEBACK |
+						PAGE_END_WRITEBACK |
+						PAGE_UNLOCK);
+				else
+					extent_write_locked_range(inode,
+						async_extent->start,
+						async_extent->start +
+						async_extent->ram_size - 1,
+						WB_SYNC_ALL);
+			} else if (ret) {
 				unlock_page(async_cow->locked_page);
+			}
+			kfree(hash);
 			kfree(async_extent);
 			cond_resched();
 			continue;
@@ -867,6 +919,7 @@ static noinline void submit_compressed_extents(struct inode *inode,
 			free_async_extent_pages(async_extent);
 		}
 		alloc_hint = ins.objectid + ins.offset;
+		kfree(hash);
 		kfree(async_extent);
 		cond_resched();
 	}
@@ -887,6 +940,7 @@ static noinline void submit_compressed_extents(struct inode *inode,
 				     PAGE_SET_WRITEBACK | PAGE_END_WRITEBACK |
 				     PAGE_SET_ERROR);
 	free_async_extent_pages(async_extent);
+	kfree(hash);
 	kfree(async_extent);
 	goto again;
 }
@@ -1001,13 +1055,19 @@ static noinline int cow_file_range(struct inode *inode,
 
 	while (num_bytes > 0) {
 		cur_alloc_size = num_bytes;
-		ret = btrfs_reserve_extent(root, cur_alloc_size, cur_alloc_size,
+		if (btrfs_dedupe_hash_hit(hash)) {
+			ins.objectid = hash->bytenr;
+			ins.offset = hash->num_bytes;
+		} else {
+			ret = btrfs_reserve_extent(root, cur_alloc_size,
+					   cur_alloc_size,
 					   fs_info->sectorsize, 0, alloc_hint,
 					   &ins, 1, 1);
-		if (ret < 0)
-			goto out_unlock;
+			if (ret < 0)
+				goto out_unlock;
+			extent_reserved = true;
+		}
 		cur_alloc_size = ins.offset;
-		extent_reserved = true;
 
 		ram_size = ins.offset;
 		em = create_io_em(inode, start, ins.offset, /* len */
@@ -1024,8 +1084,9 @@ static noinline int cow_file_range(struct inode *inode,
 		}
 		free_extent_map(em);
 
-		ret = btrfs_add_ordered_extent(inode, start, ins.objectid,
-					       ram_size, cur_alloc_size, 0);
+		ret = btrfs_add_ordered_extent_dedupe(inode, start,
+				ins.objectid, cur_alloc_size, ins.offset,
+				0, hash);
 		if (ret)
 			goto out_drop_extent_cache;
 
@@ -1049,7 +1110,14 @@ static noinline int cow_file_range(struct inode *inode,
 						start + ram_size - 1, 0);
 		}
 
-		btrfs_dec_block_group_reservations(fs_info, ins.objectid);
+		/*
+		 * Hash hit didn't allocate extent, no need to dec bg
+		 * reservation.
+		 * Or we will underflow reservations and block balance.
+		 */
+		if (!btrfs_dedupe_hash_hit(hash))
+			btrfs_dec_block_group_reservations(fs_info,
+							   ins.objectid);
 
 		/* we're not doing compressed IO, don't unlock the first
 		 * page (which the caller expects to stay locked), don't
@@ -1123,6 +1191,79 @@ static noinline int cow_file_range(struct inode *inode,
 	goto out;
 }
 
+static int hash_file_ranges(struct inode *inode, u64 start, u64 end,
+			    struct async_cow *async_cow, int *num_added)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_dedupe_info *dedupe_info = fs_info->dedupe_info;
+	struct page *locked_page = async_cow->locked_page;
+	u16 hash_algo;
+	u64 dedupe_bs;
+	u64 cur_offset = start;
+	int ret = 0;
+
+	/* If dedupe is not enabled, don't split extent into dedupe_bs */
+	if (fs_info->dedupe_enabled && dedupe_info) {
+		dedupe_bs = dedupe_info->blocksize;
+		hash_algo = dedupe_info->hash_algo;
+	} else {
+		dedupe_bs = SZ_128M;
+		/* Just dummy, to avoid access NULL pointer */
+		hash_algo = BTRFS_DEDUPE_HASH_SHA256;
+	}
+
+	while (cur_offset < end) {
+		struct btrfs_dedupe_hash *hash = NULL;
+		u64 len;
+
+		len = min(end + 1 - cur_offset, dedupe_bs);
+		if (len < dedupe_bs)
+			goto next;
+
+		hash = btrfs_dedupe_alloc_hash(hash_algo);
+		if (!hash) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		ret = btrfs_dedupe_calc_hash(fs_info, inode, cur_offset, hash);
+		if (ret < 0) {
+			kfree(hash);
+			goto out;
+		}
+
+		ret = btrfs_dedupe_search(fs_info, inode, cur_offset, hash);
+		if (ret < 0) {
+			kfree(hash);
+			goto out;
+		}
+		ret = 0;
+
+next:
+		/* Redirty the locked page if it corresponds to our extent */
+		if (page_offset(locked_page) >= start &&
+		    page_offset(locked_page) <= end)
+			__set_page_dirty_nobuffers(locked_page);
+
+		add_async_extent(async_cow, cur_offset, len, 0, NULL, 0,
+				 BTRFS_COMPRESS_NONE, 1, hash);
+		cur_offset += len;
+		(*num_added)++;
+	}
+out:
+	/*
+	 * Caller won't unlock pages, so if error happens, we must unlock
+	 * pages by ourselves.
+	 */
+	if (ret)
+		extent_clear_unlock_delalloc(inode, cur_offset,
+			end, end, NULL, EXTENT_LOCKED | EXTENT_DO_ACCOUNTING |
+			EXTENT_DELALLOC | EXTENT_DEFRAG, PAGE_UNLOCK |
+			PAGE_CLEAR_DIRTY | PAGE_SET_WRITEBACK |
+			PAGE_END_WRITEBACK | PAGE_SET_ERROR);
+	return ret;
+}
+
 /*
  * work queue call back to started compression on a file and pages
  */
@@ -1130,11 +1271,17 @@ static noinline void async_cow_start(struct btrfs_work *work)
 {
 	struct async_cow *async_cow;
 	int num_added = 0;
+	int ret = 0;
 	async_cow = container_of(work, struct async_cow, work);
 
-	compress_file_range(async_cow->inode, async_cow->locked_page,
-			    async_cow->start, async_cow->end, async_cow,
-			    &num_added);
+	if (async_cow->reserve_type == BTRFS_RESERVE_COMPRESS)
+		compress_file_range(async_cow->inode, async_cow->locked_page,
+				    async_cow->start, async_cow->end, async_cow,
+				    &num_added);
+	else
+		ret = hash_file_ranges(async_cow->inode, async_cow->start,
+				       async_cow->end, async_cow, &num_added);
+
 	if (num_added == 0) {
 		btrfs_add_delayed_iput(async_cow->inode);
 		async_cow->inode = NULL;
@@ -1185,6 +1332,7 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct async_cow *async_cow;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_dedupe_info *dedupe_info = fs_info->dedupe_info;
 	unsigned long nr_pages;
 	u64 cur_end;
 
@@ -1198,10 +1346,17 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 		async_cow->locked_page = locked_page;
 		async_cow->start = start;
 		async_cow->write_flags = write_flags;
+		async_cow->reserve_type = reserve_type;
 
 		cur_end = end;
 		if (reserve_type == BTRFS_RESERVE_COMPRESS)
 			cur_end = min(end, start + SZ_512K - 1);
+		else if (reserve_type == BTRFS_RESERVE_DEDUPE) {
+			u64 len = max_t(u64, SZ_512K, dedupe_info->blocksize);
+
+			cur_end = min(end, start + len - 1);
+		} else
+			ASSERT(0);
 
 		async_cow->end = cur_end;
 		INIT_LIST_HEAD(&async_cow->extents);
@@ -1610,13 +1765,17 @@ static int run_delalloc_range(void *private_data, struct page *locked_page,
 	int force_cow = need_force_cow(inode, start, end);
 	unsigned int write_flags = wbc_to_write_flags(wbc);
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
-	int need_compress;
 	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
+	int need_compress, need_dedupe;
 
 	need_compress = test_range_bit(io_tree, start, end,
 				       EXTENT_COMPRESS, 1, NULL);
+	need_dedupe = test_range_bit(io_tree, start, end,
+				     EXTENT_DEDUPE, 1, NULL);
 	if (need_compress)
 		reserve_type = BTRFS_RESERVE_COMPRESS;
+	else if (need_dedupe)
+		reserve_type = BTRFS_RESERVE_DEDUPE;
 
 	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW && !force_cow) {
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
@@ -1624,7 +1783,7 @@ static int run_delalloc_range(void *private_data, struct page *locked_page,
 	} else if (BTRFS_I(inode)->flags & BTRFS_INODE_PREALLOC && !force_cow) {
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 0, nr_written);
-	} else if (!need_compress) {
+	} else if (!need_compress && !need_dedupe) {
 		ret = cow_file_range(inode, locked_page, start, end, end,
 				      page_started, nr_written, 1, NULL);
 	} else {
@@ -1653,8 +1812,9 @@ static void btrfs_split_extent_hook(void *private_data,
 
 	if (orig->state & EXTENT_COMPRESS)
 		reserve_type = BTRFS_RESERVE_COMPRESS;
-
-	max_extent_size = btrfs_max_extent_size(reserve_type);
+	else if (orig->state & EXTENT_DEDUPE)
+		reserve_type = BTRFS_RESERVE_DEDUPE;
+	max_extent_size = btrfs_max_extent_size(BTRFS_I(inode), reserve_type);
 
 	size = orig->end - orig->start + 1;
 	if (size > max_extent_size) {
@@ -1700,8 +1860,9 @@ static void btrfs_merge_extent_hook(void *private_data,
 
 	if (other->state & EXTENT_COMPRESS)
 		reserve_type = BTRFS_RESERVE_COMPRESS;
-
-	max_extent_size = btrfs_max_extent_size(reserve_type);
+	else if (other->state & EXTENT_DEDUPE)
+		reserve_type = BTRFS_RESERVE_DEDUPE;
+	max_extent_size = btrfs_max_extent_size(BTRFS_I(inode), reserve_type);
 
 	if (new->start > other->start)
 		new_size = new->end - other->start + 1;
@@ -1828,7 +1989,10 @@ static void btrfs_set_bit_hook(void *private_data,
 
 		if (*bits & EXTENT_COMPRESS)
 			reserve_type = BTRFS_RESERVE_COMPRESS;
-		max_extent_size = btrfs_max_extent_size(reserve_type);
+		else if (*bits & EXTENT_DEDUPE)
+			reserve_type = BTRFS_RESERVE_DEDUPE;
+		max_extent_size = btrfs_max_extent_size(BTRFS_I(inode),
+							reserve_type);
 		num_extents = count_max_extents(len, max_extent_size);
 
 		spin_lock(&BTRFS_I(inode)->lock);
@@ -1891,7 +2055,9 @@ static void btrfs_clear_bit_hook(void *private_data,
 
 		if (state->state & EXTENT_COMPRESS)
 			reserve_type = BTRFS_RESERVE_COMPRESS;
-		max_extent_size = btrfs_max_extent_size(reserve_type);
+		else if (state->state & EXTENT_DEDUPE)
+			reserve_type = BTRFS_RESERVE_DEDUPE;
+		max_extent_size = btrfs_max_extent_size(inode, reserve_type);
 		num_extents = count_max_extents(len, max_extent_size);
 
 		spin_lock(&inode->lock);
@@ -2130,6 +2296,9 @@ int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
 	if (reserve_type == BTRFS_RESERVE_COMPRESS)
 		bits = EXTENT_DELALLOC | EXTENT_COMPRESS | EXTENT_UPTODATE |
 			extra_bits;
+	else if (reserve_type == BTRFS_RESERVE_DEDUPE)
+		bits = EXTENT_DELALLOC | EXTENT_DEDUPE | EXTENT_UPTODATE |
+			extra_bits;
 	else
 		bits = EXTENT_DELALLOC | EXTENT_UPTODATE | extra_bits;
 
@@ -2213,6 +2382,9 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 
 	if (inode_need_compress(inode, page_start, page_end))
 		reserve_type = BTRFS_RESERVE_COMPRESS;
+	else if (inode_need_dedupe(inode))
+		reserve_type = BTRFS_RESERVE_DEDUPE;
+
 	ret = btrfs_delalloc_reserve_space(inode, &data_reserved, page_start,
 					   PAGE_SIZE, reserve_type);
 	if (ret) {
@@ -2287,7 +2459,8 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 				       u64 disk_bytenr, u64 disk_num_bytes,
 				       u64 num_bytes, u64 ram_bytes,
 				       u8 compression, u8 encryption,
-				       u16 other_encoding, int extent_type)
+				       u16 other_encoding, int extent_type,
+				       struct btrfs_dedupe_hash *hash)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_file_extent_item *fi;
@@ -2351,17 +2524,43 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	ins.offset = disk_num_bytes;
 	ins.type = BTRFS_EXTENT_ITEM_KEY;
 
-	/*
-	 * Release the reserved range from inode dirty range map, as it is
-	 * already moved into delayed_ref_head
-	 */
-	ret = btrfs_qgroup_release_data(inode, file_pos, ram_bytes);
-	if (ret < 0)
-		goto out;
-	qg_released = ret;
-	ret = btrfs_alloc_reserved_file_extent(trans, root,
-					       btrfs_ino(BTRFS_I(inode)),
-					       file_pos, qg_released, &ins);
+	if (btrfs_dedupe_hash_hit(hash)) {
+		/*
+		 * Hash hit won't create a new data extent, so its reserved
+		 * space won't be freed by new delayed_ref_head.
+		 * Manually free it.
+		 */
+		btrfs_free_reserved_data_space(inode, NULL, file_pos,
+					       ram_bytes);
+	} else {
+		/*
+		 * Hash miss or none-dedupe write, will create a new data
+		 * extent, we need to release the qgroup reserved data space.
+		 */
+		ret = btrfs_qgroup_release_data(inode, file_pos, ram_bytes);
+		if (ret < 0)
+			goto out;
+		qg_released = ret;
+		ret = btrfs_alloc_reserved_file_extent(trans, root,
+				btrfs_ino(BTRFS_I(inode)), file_pos,
+				qg_released, &ins);
+		if (ret < 0)
+			goto out;
+	}
+
+	/* Add missed hash into dedupe tree */
+	if (hash && hash->bytenr == 0) {
+		hash->bytenr = ins.objectid;
+		hash->num_bytes = ins.offset;
+
+		/*
+		 * Here we ignore dedupe_add error, as even it failed,
+		 * it won't corrupt the filesystem. It will only only slightly
+		 * reduce dedup rate
+		 */
+		btrfs_dedupe_add(trans, root->fs_info, hash);
+	}
+
 out:
 	btrfs_free_path(path);
 
@@ -3048,6 +3247,7 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 	bool range_locked = false;
 	bool clear_new_delalloc_bytes = false;
 	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
+	int hash_hit = btrfs_dedupe_hash_hit(ordered_extent->hash);
 
 	if (!test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags) &&
 	    !test_bit(BTRFS_ORDERED_PREALLOC, &ordered_extent->flags) &&
@@ -3135,7 +3335,8 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 	if (test_bit(BTRFS_ORDERED_COMPRESSED, &ordered_extent->flags)) {
 		compress_type = ordered_extent->compress_type;
 		reserve_type = BTRFS_RESERVE_COMPRESS;
-	}
+	} else if (ordered_extent->hash)
+		reserve_type = BTRFS_RESERVE_DEDUPE;
 
 	if (test_bit(BTRFS_ORDERED_PREALLOC, &ordered_extent->flags)) {
 		BUG_ON(compress_type);
@@ -3153,8 +3354,10 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 						ordered_extent->disk_len,
 						logical_len, logical_len,
 						compress_type, 0, 0,
-						BTRFS_FILE_EXTENT_REG);
-		if (!ret)
+						BTRFS_FILE_EXTENT_REG,
+						ordered_extent->hash);
+		/* Hash hit case doesn't reserve delalloc bytes */
+		if (!ret && !hash_hit)
 			btrfs_release_delalloc_bytes(fs_info,
 						     ordered_extent->start,
 						     ordered_extent->disk_len);
@@ -3218,8 +3421,11 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 		 * wrong we need to return the space for this ordered extent
 		 * back to the allocator.  We only free the extent in the
 		 * truncated case if we didn't write out the extent at all.
+		 *
+		 * For hash hit case, never free that extent, as it's being used
+		 * by others.
 		 */
-		if ((ret || !logical_len) &&
+		if ((ret || !logical_len) && !hash_hit &&
 		    !test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags) &&
 		    !test_bit(BTRFS_ORDERED_PREALLOC, &ordered_extent->flags))
 			btrfs_free_reserved_extent(fs_info,
@@ -3227,7 +3433,6 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 						   ordered_extent->disk_len, 1);
 	}
 
-
 	/*
 	 * This needs to be done to make sure anybody waiting knows we are done
 	 * updating everything for this ordered extent.
@@ -4969,6 +5174,8 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 
 	if (inode_need_compress(inode, -1, 0))
 		reserve_type = BTRFS_RESERVE_COMPRESS;
+	else if (inode_need_dedupe(inode))
+		reserve_type = BTRFS_RESERVE_DEDUPE;
 
 	if (IS_ALIGNED(offset, blocksize) &&
 	    (!len || IS_ALIGNED(len, blocksize)))
@@ -8998,6 +9205,9 @@ vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
 
 	if (inode_need_compress(inode, page_start, page_end))
 		reserve_type = BTRFS_RESERVE_COMPRESS;
+	else if (inode_need_dedupe(inode))
+		reserve_type = BTRFS_RESERVE_DEDUPE;
+
 	/*
 	 * Reserving delalloc space after obtaining the page lock can lead to
 	 * deadlock. For example, if a dirty page is locked by this function
@@ -10389,7 +10599,8 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 						  cur_offset, ins.objectid,
 						  ins.offset, ins.offset,
 						  ins.offset, 0, 0, 0,
-						  BTRFS_FILE_EXTENT_PREALLOC);
+						  BTRFS_FILE_EXTENT_PREALLOC,
+						  NULL);
 		if (ret) {
 			btrfs_free_reserved_extent(fs_info, ins.objectid,
 						   ins.offset, 0);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index fd0329065c4b..bd6498a9c924 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -48,6 +48,7 @@
 #include "qgroup.h"
 #include "tree-log.h"
 #include "compression.h"
+#include "dedupe.h"
 
 #ifdef CONFIG_64BIT
 /* If we have a 32-bit userspace and 64-bit kernel, then the UAPI
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 85b872278a71..3841cddef6ab 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -20,6 +20,7 @@
 #include "inode-map.h"
 #include "qgroup.h"
 #include "print-tree.h"
+#include "dedupe.h"
 
 /*
  * backref_node, mapping_node and tree_block start with this
@@ -3197,6 +3198,8 @@ static int relocate_file_extent_cluster(struct inode *inode,
 
 	if (inode_need_compress(inode, -1, 0))
 		reserve_type = BTRFS_RESERVE_COMPRESS;
+	else if (inode_need_dedupe(inode))
+		reserve_type = BTRFS_RESERVE_DEDUPE;
 
 	ra = kzalloc(sizeof(*ra), GFP_NOFS);
 	if (!ra)
@@ -4161,6 +4164,20 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
 				rc->search_start = key.objectid;
 			}
 		}
+		/*
+		 * This data extent will be replaced, but normal dedupe_del()
+		 * will only happen at run_delayed_ref() time, which is too
+		 * late, so delete dedupe_hash early to prevent its ref get
+		 * increased during relocation
+		 */
+		if (rc->stage == MOVE_DATA_EXTENTS &&
+		    (flags & BTRFS_EXTENT_FLAG_DATA)) {
+			ret = btrfs_dedupe_del(trans, fs_info, key.objectid);
+			if (ret < 0) {
+				err = ret;
+				break;
+			}
+		}
 
 		btrfs_end_transaction_throttle(trans);
 		btrfs_btree_balance_dirty(fs_info);
-- 
2.18.0



