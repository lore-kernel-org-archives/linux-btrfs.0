Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:15682 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752119AbdLLEf3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Dec 2017 23:35:29 -0500
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH v14.5 02/14] btrfs: Introduce COMPRESS reserve type to fix false enospc for compression
Date: Tue, 12 Dec 2017 12:34:01 +0800
Message-ID: <20171212043413.16637-3-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20171212043413.16637-1-lufq.fnst@cn.fujitsu.com>
References: <20171212043413.16637-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

When testing btrfs compression, sometimes we got ENOSPC error, though fs
still has much free space, xfstests generic/171, generic/172, generic/173,
generic/174, generic/175 can reveal this bug in my test environment when
compression is enabled.

After some debugging work, we found that it's
btrfs_delalloc_reserve_metadata() which sometimes tries to reserve too
much metadata space, even for very small data range.

In btrfs_delalloc_reserve_metadata(), the number of metadata bytes to
reserve is calculated by the difference between outstanding extents and
reserved extents.
But due to bad designed drop_outstanding_extent() function, it can make
the difference too big, and cause problem.

The problem happens in the following flow with compression enabled.

1) Buffered write 128M data with 128K blocksize
   outstanding_extents = 1
   reserved_extents = 1024 (128M / 128K, one blocksize will get one
                            reserved_extent)

   Note: it's btrfs_merge_extent_hook() to merge outstanding extents.
         But reserved extents are still 1024.

2) Allocate extents for dirty range
   cow_file_range_async() split above large extent into small 128K
   extents.
   Let's assume 2 compressed extents have been split.

   So we have:
   outstanding_extents = 3
   reserved_extents = 1024

   range [0, 256K) has extents allocated

3) One ordered extent get finished
   btrfs_finish_ordered_io()
   |- btrfs_delalloc_release_metadata()
      |- drop_outstanding_extent()

   drop_outstanding_extent() will free *ALL* redundant reserved extents.
   So we have:
   outstanding_extents = 2 (One has finished)
   reserved_extents = 2

4) Continue allocating extents for dirty range
   cow_file_range_async() continue handling the remaining range.

   When the whole 128M range is done and assume no more ordered extents
   have finished.
   outstanding_extents = 1023 (One has finished in Step 3)
   reserved_extents = 2 (*ALL* freed in Step 3)

5) Another buffered write happens to the file
   btrfs_delalloc_reserve_metadata() will calculate metadata space.

   The calculation is:
   meta_to_reserve = (outstanding_extents - reserved_extents) * \
		     nodesize * max_tree_level(8) * 2

   If nodesize is 16K, it's 1021 * 16K * 8 * 2, near 256M.
   If nodesize is 64K, it's about 1G.

   That's totally insane.

The fix is to introduce new reserve type, COMPRESSION, to info outstanding
extents calculation algorithm, to get correct outstanding_extents based
extent size.

So in Step 1), outstanding_extents = 1024 reserved_extents = 1024
Step 2): outstanding_extents = 1024 reserved_extents = 1024
Step 3): outstanding_extents = 1023 reserved_extents = 1023

And in Step 5) we reserve correct amount of metadata space.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       |  2 ++
 fs/btrfs/extent-tree.c |  2 ++
 fs/btrfs/extent_io.c   |  7 +++--
 fs/btrfs/extent_io.h   |  1 +
 fs/btrfs/file.c        |  3 ++
 fs/btrfs/inode.c       | 81 ++++++++++++++++++++++++++++++++++++++++++--------
 fs/btrfs/ioctl.c       |  2 ++
 fs/btrfs/relocation.c  |  3 ++
 8 files changed, 86 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 5f77ab437d12..233a95dc2417 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -115,9 +115,11 @@ static inline u32 count_max_extents(u64 size, u64 max_extent_size)
  */
 enum btrfs_metadata_reserve_type {
 	BTRFS_RESERVE_NORMAL,
+	BTRFS_RESERVE_COMPRESS,
 };
 
 u64 btrfs_max_extent_size(enum btrfs_metadata_reserve_type reserve_type);
+int inode_need_compress(struct inode *inode, u64 start, u64 end);
 
 struct btrfs_mapping_tree {
 	struct extent_map_tree map_tree;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 564b8e54f45a..a018423c7024 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6046,6 +6046,8 @@ u64 btrfs_max_extent_size(enum btrfs_metadata_reserve_type reserve_type)
 {
 	if (reserve_type == BTRFS_RESERVE_NORMAL)
 		return BTRFS_MAX_EXTENT_SIZE;
+	else if (reserve_type == BTRFS_RESERVE_COMPRESS)
+		return SZ_128K;
 
 	ASSERT(0);
 	return BTRFS_MAX_EXTENT_SIZE;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 012d63870b99..4ee862fff7b9 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -597,7 +597,7 @@ static int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	btrfs_debug_check_extent_io_range(tree, start, end);
 
 	if (bits & EXTENT_DELALLOC)
-		bits |= EXTENT_NORESERVE;
+		bits |= EXTENT_NORESERVE | EXTENT_COMPRESS;
 
 	if (delete)
 		bits |= ~EXTENT_CTLBITS;
@@ -1488,6 +1488,7 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 	u64 cur_start = *start;
 	u64 found = 0;
 	u64 total_bytes = 0;
+	unsigned int pre_state;
 
 	spin_lock(&tree->lock);
 
@@ -1505,7 +1506,8 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 	while (1) {
 		state = rb_entry(node, struct extent_state, rb_node);
 		if (found && (state->start != cur_start ||
-			      (state->state & EXTENT_BOUNDARY))) {
+			      (state->state & EXTENT_BOUNDARY) ||
+			      (state->state ^ pre_state) & EXTENT_COMPRESS)) {
 			goto out;
 		}
 		if (!(state->state & EXTENT_DELALLOC)) {
@@ -1521,6 +1523,7 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 		found++;
 		*end = state->end;
 		cur_start = state->end + 1;
+		pre_state = state->state;
 		node = rb_next(node);
 		total_bytes += state->end - state->start + 1;
 		if (total_bytes >= max_bytes)
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 93dcae0c3183..9751791de55a 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -24,6 +24,7 @@
 #define EXTENT_QGROUP_RESERVED	(1U << 16)
 #define EXTENT_CLEAR_DATA_RESV	(1U << 17)
 #define EXTENT_DELALLOC_NEW	(1U << 18)
+#define EXTENT_COMPRESS		(1U << 19)
 #define EXTENT_IOBITS		(EXTENT_LOCKED | EXTENT_WRITEBACK)
 #define EXTENT_DO_ACCOUNTING    (EXTENT_CLEAR_META_RESV | \
 				 EXTENT_CLEAR_DATA_RESV)
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 5f5bc8e82045..b84257024000 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1610,6 +1610,9 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 	if (!pages)
 		return -ENOMEM;
 
+	if (inode_need_compress(inode, -1, 0))
+		reserve_type = BTRFS_RESERVE_COMPRESS;
+
 	while (iov_iter_count(i) > 0) {
 		size_t offset = pos & (PAGE_SIZE - 1);
 		size_t sector_offset;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0746ee22ab38..52f3c626664d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -404,7 +404,7 @@ static noinline int add_async_extent(struct async_cow *cow,
 	return 0;
 }
 
-static inline int inode_need_compress(struct inode *inode, u64 start, u64 end)
+int inode_need_compress(struct inode *inode, u64 start, u64 end)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 
@@ -1194,7 +1194,8 @@ static noinline void async_cow_free(struct btrfs_work *work)
 static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 				u64 start, u64 end, int *page_started,
 				unsigned long *nr_written,
-				unsigned int write_flags)
+				unsigned int write_flags,
+				enum btrfs_metadata_reserve_type reserve_type)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct async_cow *async_cow;
@@ -1213,10 +1214,8 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 		async_cow->start = start;
 		async_cow->write_flags = write_flags;
 
-		if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS &&
-		    !btrfs_test_opt(fs_info, FORCE_COMPRESS))
-			cur_end = end;
-		else
+		cur_end = end;
+		if (reserve_type == BTRFS_RESERVE_COMPRESS)
 			cur_end = min(end, start + SZ_512K - 1);
 
 		async_cow->end = cur_end;
@@ -1588,6 +1587,14 @@ static int run_delalloc_range(void *private_data, struct page *locked_page,
 	int ret;
 	int force_cow = need_force_cow(inode, start, end);
 	unsigned int write_flags = wbc_to_write_flags(wbc);
+	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
+	int need_compress;
+	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
+
+	need_compress = test_range_bit(io_tree, start, end,
+				       EXTENT_COMPRESS, 1, NULL);
+	if (need_compress)
+		reserve_type = BTRFS_RESERVE_COMPRESS;
 
 	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW && !force_cow) {
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
@@ -1595,7 +1602,7 @@ static int run_delalloc_range(void *private_data, struct page *locked_page,
 	} else if (BTRFS_I(inode)->flags & BTRFS_INODE_PREALLOC && !force_cow) {
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 0, nr_written);
-	} else if (!inode_need_compress(inode, start, end)) {
+	} else if (!need_compress) {
 		ret = cow_file_range(inode, locked_page, start, end, end,
 				      page_started, nr_written, 1, NULL);
 	} else {
@@ -1603,7 +1610,7 @@ static int run_delalloc_range(void *private_data, struct page *locked_page,
 			&BTRFS_I(inode)->runtime_flags);
 		ret = cow_file_range_async(inode, locked_page, start, end,
 					   page_started, nr_written,
-					   write_flags);
+					   write_flags, reserve_type);
 	}
 	if (ret)
 		btrfs_cleanup_ordered_extents(inode, start, end - start + 1);
@@ -1622,6 +1629,9 @@ static void btrfs_split_extent_hook(void *private_data,
 	if (!(orig->state & EXTENT_DELALLOC))
 		return;
 
+	if (orig->state & EXTENT_COMPRESS)
+		reserve_type = BTRFS_RESERVE_COMPRESS;
+
 	max_extent_size = btrfs_max_extent_size(reserve_type);
 
 	size = orig->end - orig->start + 1;
@@ -1666,6 +1676,9 @@ static void btrfs_merge_extent_hook(void *private_data,
 	if (!(other->state & EXTENT_DELALLOC))
 		return;
 
+	if (other->state & EXTENT_COMPRESS)
+		reserve_type = BTRFS_RESERVE_COMPRESS;
+
 	max_extent_size = btrfs_max_extent_size(reserve_type);
 
 	if (new->start > other->start)
@@ -1783,6 +1796,8 @@ static void btrfs_set_bit_hook(void *private_data,
 							BTRFS_RESERVE_NORMAL;
 		bool do_list = !btrfs_is_free_space_inode(BTRFS_I(inode));
 
+		if (*bits & EXTENT_COMPRESS)
+			reserve_type = BTRFS_RESERVE_COMPRESS;
 		max_extent_size = btrfs_max_extent_size(reserve_type);
 		num_extents = count_max_extents(len, max_extent_size);
 
@@ -1844,6 +1859,8 @@ static void btrfs_clear_bit_hook(void *private_data,
 		struct btrfs_root *root = inode->root;
 		bool do_list = !btrfs_is_free_space_inode(inode);
 
+		if (state->state & EXTENT_COMPRESS)
+			reserve_type = BTRFS_RESERVE_COMPRESS;
 		max_extent_size = btrfs_max_extent_size(reserve_type);
 		num_extents = count_max_extents(len, max_extent_size);
 
@@ -2051,14 +2068,31 @@ static noinline int add_pending_csums(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
+/*
+ * Normally flag should be 0, but if a data range will go through compress path,
+ * set flag to 1. Note: here we should ensure enum btrfs_metadata_reserve_type
+ * and flag's values are consistent.
+ */
 int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
 			      unsigned int extra_bits,
 			      struct extent_state **cached_state,
 			      enum btrfs_metadata_reserve_type reserve_type)
 {
+	int ret;
+	unsigned int bits;
+
+	/* compression path */
+	if (reserve_type == BTRFS_RESERVE_COMPRESS)
+		bits = EXTENT_DELALLOC | EXTENT_COMPRESS | EXTENT_UPTODATE |
+			extra_bits;
+	else
+		bits = EXTENT_DELALLOC | EXTENT_UPTODATE | extra_bits;
+
 	WARN_ON((end & (PAGE_SIZE - 1)) == 0);
-	return set_extent_delalloc(&BTRFS_I(inode)->io_tree, start, end,
-				   extra_bits, cached_state);
+	ret = set_extent_bit(&BTRFS_I(inode)->io_tree, start, end,
+			     bits, NULL, cached_state, GFP_NOFS);
+
+	return ret;
 }
 
 
@@ -2066,9 +2100,20 @@ int btrfs_set_extent_defrag(struct inode *inode, u64 start, u64 end,
 			    struct extent_state **cached_state,
 			    enum btrfs_metadata_reserve_type reserve_type)
 {
+	int ret;
+	unsigned int bits;
+
 	WARN_ON((end & (PAGE_SIZE - 1)) == 0);
-	return set_extent_defrag(&BTRFS_I(inode)->io_tree, start, end,
-				 cached_state);
+	if (reserve_type == BTRFS_RESERVE_COMPRESS)
+		bits = EXTENT_DELALLOC | EXTENT_UPTODATE | EXTENT_DEFRAG |
+				EXTENT_COMPRESS;
+	else
+		bits = EXTENT_DELALLOC | EXTENT_UPTODATE | EXTENT_DEFRAG;
+
+	ret = set_extent_bit(&BTRFS_I(inode)->io_tree, start, end,
+			     bits, NULL, cached_state, GFP_NOFS);
+
+	return ret;
 }
 
 /* see btrfs_writepage_start_hook for details on why this is required */
@@ -2121,6 +2166,8 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 		goto again;
 	}
 
+	if (inode_need_compress(inode, page_start, page_end))
+		reserve_type = BTRFS_RESERVE_COMPRESS;
 	ret = btrfs_delalloc_reserve_space(inode, &data_reserved, page_start,
 					   PAGE_SIZE, reserve_type);
 	if (ret) {
@@ -3034,8 +3081,11 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 
 	trans->block_rsv = &BTRFS_I(inode)->block_rsv;
 
-	if (test_bit(BTRFS_ORDERED_COMPRESSED, &ordered_extent->flags))
+	if (test_bit(BTRFS_ORDERED_COMPRESSED, &ordered_extent->flags)) {
 		compress_type = ordered_extent->compress_type;
+		reserve_type = BTRFS_RESERVE_COMPRESS;
+	}
+
 	if (test_bit(BTRFS_ORDERED_PREALLOC, &ordered_extent->flags)) {
 		BUG_ON(compress_type);
 		btrfs_qgroup_free_data(inode, NULL, ordered_extent->file_offset,
@@ -4778,6 +4828,9 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 	u64 block_end;
 	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
 
+	if (inode_need_compress(inode, -1, 0))
+		reserve_type = BTRFS_RESERVE_COMPRESS;
+
 	if ((offset & (blocksize - 1)) == 0 &&
 	    (!len || ((len & (blocksize - 1)) == 0)))
 		goto out;
@@ -9132,6 +9185,8 @@ int btrfs_page_mkwrite(struct vm_fault *vmf)
 	page_end = page_start + PAGE_SIZE - 1;
 	end = page_end;
 
+	if (inode_need_compress(inode, page_start, page_end))
+		reserve_type = BTRFS_RESERVE_COMPRESS;
 	/*
 	 * Reserving delalloc space after obtaining the page lock can lead to
 	 * deadlock. For example, if a dirty page is locked by this function
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 36a257dd4ed9..5a0c66ba57f8 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1106,6 +1106,8 @@ static int cluster_pages_for_defrag(struct inode *inode,
 
 	page_cnt = min_t(u64, (u64)num_pages, (u64)file_end - start_index + 1);
 
+	if (inode_need_compress(inode, -1, 0))
+		reserve_type = BTRFS_RESERVE_COMPRESS;
 	ret = btrfs_delalloc_reserve_space(inode, &data_reserved,
 			start_index << PAGE_SHIFT,
 			page_cnt << PAGE_SHIFT, reserve_type);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 6104b2d9f4de..b5cde7a7f56c 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3195,6 +3195,9 @@ static int relocate_file_extent_cluster(struct inode *inode,
 	if (!cluster->nr)
 		return 0;
 
+	if (inode_need_compress(inode, -1, 0))
+		reserve_type = BTRFS_RESERVE_COMPRESS;
+
 	ra = kzalloc(sizeof(*ra), GFP_NOFS);
 	if (!ra)
 		return -ENOMEM;
-- 
2.15.1



