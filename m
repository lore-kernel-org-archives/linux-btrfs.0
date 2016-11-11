Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:9727 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S934522AbcKKIrf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Nov 2016 03:47:35 -0500
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, holger@applied-asynchrony.com,
        s.priebe@profihost.ag, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH 3/3] btrfs: Introduce COMPRESS reserve type to fix false enospc for compression
Date: Fri, 11 Nov 2016 16:39:47 +0800
Message-Id: <1478853587-28717-4-git-send-email-wangxg.fnst@cn.fujitsu.com>
In-Reply-To: <1478853587-28717-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
References: <1478853587-28717-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When testing btrfs compression, sometimes we got ENOSPC error, though fs
still has much free space, xfstests generic/171, generic/172, generic/173,
generic/174, generic/175 can reveal this bug in my test environment when
compression is enabled.

After some debuging work, we found that it's
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
---
 fs/btrfs/ctree.h       |  2 ++
 fs/btrfs/extent-tree.c |  2 ++
 fs/btrfs/extent_io.c   | 61 ++++++++++++++++++++++++++++++++--
 fs/btrfs/extent_io.h   |  5 +++
 fs/btrfs/file.c        |  3 ++
 fs/btrfs/inode.c       | 89 ++++++++++++++++++++++++++++++++++++++++++--------
 fs/btrfs/ioctl.c       |  2 ++
 fs/btrfs/relocation.c  |  3 ++
 8 files changed, 152 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 64c63c2..6097bf0 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -109,9 +109,11 @@ static const int btrfs_csum_sizes[] = { 4 };
  */
 enum btrfs_metadata_reserve_type {
 	BTRFS_RESERVE_NORMAL,
+	BTRFS_RESERVE_COMPRESS,
 };
 
 u64 btrfs_max_extent_size(enum btrfs_metadata_reserve_type reserve_type);
+int inode_need_compress(struct inode *inode);
 
 struct btrfs_mapping_tree {
 	struct extent_map_tree map_tree;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index bd99f25..d5691b0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5924,6 +5924,8 @@ u64 btrfs_max_extent_size(enum btrfs_metadata_reserve_type reserve_type)
 {
 	if (reserve_type == BTRFS_RESERVE_NORMAL)
 		return BTRFS_MAX_EXTENT_SIZE;
+	else if (reserve_type == BTRFS_RESERVE_COMPRESS)
+		return SZ_128K;
 
 	ASSERT(0);
 	return BTRFS_MAX_EXTENT_SIZE;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8ed05d9..854379d 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -603,7 +603,7 @@ static int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	btrfs_debug_check_extent_io_range(tree, start, end);
 
 	if (bits & EXTENT_DELALLOC)
-		bits |= EXTENT_NORESERVE;
+		bits |= EXTENT_NORESERVE | EXTENT_COMPRESS;
 
 	if (delete)
 		bits |= ~EXTENT_CTLBITS;
@@ -742,6 +742,60 @@ out:
 
 }
 
+static void adjust_one_outstanding_extent(struct inode *inode, u64 len,
+				enum btrfs_metadata_reserve_type reserve_type)
+{
+	unsigned old_extents, new_extents;
+	u64 max_extent_size = btrfs_max_extent_size(reserve_type);
+
+	old_extents = div64_u64(len + max_extent_size - 1, max_extent_size);
+	new_extents = div64_u64(len + BTRFS_MAX_EXTENT_SIZE - 1,
+				BTRFS_MAX_EXTENT_SIZE);
+	if (old_extents <= new_extents)
+		return;
+
+	spin_lock(&BTRFS_I(inode)->lock);
+	BTRFS_I(inode)->outstanding_extents -= old_extents - new_extents;
+	spin_unlock(&BTRFS_I(inode)->lock);
+}
+
+/*
+ * For a extent with EXTENT_COMPRESS flag, if later it does not go through
+ * compress path, we need to adjust the number of outstanding_extents.
+ * It's because for extent with EXTENT_COMPRESS flag, its number of outstanding
+ * extents is calculated by 128KB, so here we need to adjust it.
+ */
+void adjust_outstanding_extents(struct inode *inode, u64 start, u64 end,
+				enum btrfs_metadata_reserve_type reserve_type)
+{
+	struct rb_node *node;
+	struct extent_state *state;
+	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
+
+	spin_lock(&tree->lock);
+	node = tree_search(tree, start);
+	if (!node)
+		goto out;
+
+	while (1) {
+		state = rb_entry(node, struct extent_state, rb_node);
+		if (state->start > end)
+			goto out;
+		/*
+		 * The whole range is locked, so we can safely clear
+		 * EXTENT_COMPRESS flag.
+		 */
+		state->state &= ~EXTENT_COMPRESS;
+		adjust_one_outstanding_extent(inode,
+				state->end - state->start + 1, reserve_type);
+		node = rb_next(node);
+		if (!node)
+			break;
+	}
+out:
+	spin_unlock(&tree->lock);
+}
+
 static void wait_on_state(struct extent_io_tree *tree,
 			  struct extent_state *state)
 		__releases(tree->lock)
@@ -1504,6 +1558,7 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 	u64 cur_start = *start;
 	u64 found = 0;
 	u64 total_bytes = 0;
+	unsigned pre_state;
 
 	spin_lock(&tree->lock);
 
@@ -1521,7 +1576,8 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 	while (1) {
 		state = rb_entry(node, struct extent_state, rb_node);
 		if (found && (state->start != cur_start ||
-			      (state->state & EXTENT_BOUNDARY))) {
+			      (state->state & EXTENT_BOUNDARY) ||
+			      (state->state ^ pre_state) & EXTENT_COMPRESS)) {
 			goto out;
 		}
 		if (!(state->state & EXTENT_DELALLOC)) {
@@ -1537,6 +1593,7 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 		found++;
 		*end = state->end;
 		cur_start = state->end + 1;
+		pre_state = state->state;
 		node = rb_next(node);
 		total_bytes += state->end - state->start + 1;
 		if (total_bytes >= max_bytes)
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index ab31d14..09dbdd7 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -21,6 +21,7 @@
 #define EXTENT_NORESERVE	(1U << 15)
 #define EXTENT_QGROUP_RESERVED	(1U << 16)
 #define EXTENT_CLEAR_DATA_RESV	(1U << 17)
+#define EXTENT_COMPRESS		(1U << 18)
 #define EXTENT_IOBITS		(EXTENT_LOCKED | EXTENT_WRITEBACK)
 #define EXTENT_CTLBITS		(EXTENT_DO_ACCOUNTING | EXTENT_FIRST_DELALLOC)
 
@@ -248,6 +249,10 @@ int clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		     unsigned bits, int wake, int delete,
 		     struct extent_state **cached, gfp_t mask);
 
+enum btrfs_metadata_reserve_type;
+void adjust_outstanding_extents(struct inode *inode, u64 start, u64 end,
+		enum btrfs_metadata_reserve_type reserve_type);
+
 static inline int unlock_extent(struct extent_io_tree *tree, u64 start, u64 end)
 {
 	return clear_extent_bit(tree, start, end, EXTENT_LOCKED, 1, 0, NULL,
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f174381..4abd280 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1532,6 +1532,9 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 	if (!pages)
 		return -ENOMEM;
 
+	if (inode_need_compress(inode))
+		reserve_type = BTRFS_RESERVE_COMPRESS;
+
 	while (iov_iter_count(i) > 0) {
 		size_t offset = pos & (PAGE_SIZE - 1);
 		size_t sector_offset;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 906ab27..f3ea0e0 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -372,7 +372,7 @@ static noinline int add_async_extent(struct async_cow *cow,
 	return 0;
 }
 
-static inline int inode_need_compress(struct inode *inode)
+int inode_need_compress(struct inode *inode)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 
@@ -711,6 +711,17 @@ retry:
 					 async_extent->start +
 					 async_extent->ram_size - 1);
 
+			/*
+			 * We use 128KB as max extent size to calculate number
+			 * of outstanding extents for this extent before, now
+			 * it'll go throuth uncompressed IO, we need to use
+			 * 128MB as max extent size to re-calculate number of
+			 * outstanding extents for this extent.
+			 */
+			adjust_outstanding_extents(inode, async_extent->start,
+						   async_extent->start +
+						   async_extent->ram_size - 1,
+						   BTRFS_RESERVE_COMPRESS);
 			/* allocate blocks */
 			ret = cow_file_range(inode, async_cow->locked_page,
 					     async_extent->start,
@@ -1153,7 +1164,8 @@ static noinline void async_cow_free(struct btrfs_work *work)
 
 static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 				u64 start, u64 end, int *page_started,
-				unsigned long *nr_written)
+				unsigned long *nr_written,
+				enum btrfs_metadata_reserve_type reserve_type)
 {
 	struct async_cow *async_cow;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -1171,11 +1183,10 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 		async_cow->locked_page = locked_page;
 		async_cow->start = start;
 
-		if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS &&
-		    !btrfs_test_opt(root->fs_info, FORCE_COMPRESS))
-			cur_end = end;
-		else
+		if (reserve_type == BTRFS_RESERVE_COMPRESS)
 			cur_end = min(end, start + SZ_512K - 1);
+		else
+			ASSERT(0);
 
 		async_cow->end = cur_end;
 		INIT_LIST_HEAD(&async_cow->extents);
@@ -1574,21 +1585,37 @@ static int run_delalloc_range(struct inode *inode, struct page *locked_page,
 {
 	int ret;
 	int force_cow = need_force_cow(inode, start, end);
+	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
+	int need_compress;
+	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
+
+	need_compress = test_range_bit(io_tree, start, end,
+				       EXTENT_COMPRESS, 1, NULL);
+	if (need_compress)
+		reserve_type = BTRFS_RESERVE_COMPRESS;
 
 	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW && !force_cow) {
+		if (need_compress)
+			adjust_outstanding_extents(inode, start, end,
+						   reserve_type);
+
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 1, nr_written);
 	} else if (BTRFS_I(inode)->flags & BTRFS_INODE_PREALLOC && !force_cow) {
+		if (need_compress)
+			adjust_outstanding_extents(inode, start, end,
+						   reserve_type);
+
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 0, nr_written);
-	} else if (!inode_need_compress(inode)) {
+	} else if (!need_compress) {
 		ret = cow_file_range(inode, locked_page, start, end, end,
 				      page_started, nr_written, 1, NULL);
 	} else {
 		set_bit(BTRFS_INODE_HAS_ASYNC_EXTENT,
 			&BTRFS_I(inode)->runtime_flags);
 		ret = cow_file_range_async(inode, locked_page, start, end,
-					   page_started, nr_written);
+				page_started, nr_written, reserve_type);
 	}
 	return ret;
 }
@@ -1607,6 +1634,8 @@ static void btrfs_split_extent_hook(struct inode *inode,
 	if (btrfs_is_free_space_inode(inode))
 		return;
 
+	if (orig->state & EXTENT_COMPRESS)
+		reserve_type = BTRFS_RESERVE_COMPRESS;
 	max_extent_size = btrfs_max_extent_size(reserve_type);
 
 	size = orig->end - orig->start + 1;
@@ -1656,6 +1685,8 @@ static void btrfs_merge_extent_hook(struct inode *inode,
 	if (btrfs_is_free_space_inode(inode))
 		return;
 
+	if (other->state & EXTENT_COMPRESS)
+		reserve_type = BTRFS_RESERVE_COMPRESS;
 	max_extent_size = btrfs_max_extent_size(reserve_type);
 
 	if (new->start > other->start)
@@ -1769,6 +1800,8 @@ static void btrfs_set_bit_hook(struct inode *inode,
 		u64 num_extents;
 		bool do_list = !btrfs_is_free_space_inode(inode);
 
+		if (*bits & EXTENT_COMPRESS)
+			reserve_type = BTRFS_RESERVE_COMPRESS;
 		max_extent_size = btrfs_max_extent_size(reserve_type);
 		num_extents = div64_u64(len + max_extent_size - 1,
 					max_extent_size);
@@ -1825,6 +1858,8 @@ static void btrfs_clear_bit_hook(struct inode *inode,
 		struct btrfs_root *root = BTRFS_I(inode)->root;
 		bool do_list = !btrfs_is_free_space_inode(inode);
 
+		if (state->state & EXTENT_COMPRESS)
+			reserve_type = BTRFS_RESERVE_COMPRESS;
 		max_extent_size = btrfs_max_extent_size(reserve_type);
 		num_extents = div64_u64(len + max_extent_size - 1,
 					max_extent_size);
@@ -2027,18 +2062,30 @@ static noinline int add_pending_csums(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
+/*
+ * Normally flag should be 0, but if a data range will go through compress path,
+ * set flag to 1. Note: here we should ensure enum btrfs_metadata_reserve_type
+ * and flag's values are consistent.
+ */
 int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
 			      struct extent_state **cached_state,
 			      enum btrfs_metadata_reserve_type reserve_type)
 {
 	int ret;
+	unsigned bits;
 	u64 max_extent_size = btrfs_max_extent_size(reserve_type);
 	u64 num_extents = div64_u64(end - start + max_extent_size,
 				    max_extent_size);
 
+	/* compression path */
+	if (reserve_type == BTRFS_RESERVE_COMPRESS)
+		bits = EXTENT_DELALLOC | EXTENT_COMPRESS | EXTENT_UPTODATE;
+	else
+		bits = EXTENT_DELALLOC | EXTENT_UPTODATE;
+
 	WARN_ON((end & (PAGE_SIZE - 1)) == 0);
-	ret = set_extent_delalloc(&BTRFS_I(inode)->io_tree, start, end,
-				  cached_state);
+	ret = set_extent_bit(&BTRFS_I(inode)->io_tree, start, end,
+			     bits, NULL, cached_state, GFP_NOFS);
 
 	/*
 	 * btrfs_delalloc_reserve_metadata() will first add number of
@@ -2065,14 +2112,20 @@ int btrfs_set_extent_defrag(struct inode *inode, u64 start, u64 end,
 			    enum btrfs_metadata_reserve_type reserve_type)
 {
 	int ret;
+	unsigned bits;
 	u64 max_extent_size = btrfs_max_extent_size(reserve_type);
 	u64 num_extents = div64_u64(end - start + max_extent_size,
 				    max_extent_size);
 
 	WARN_ON((end & (PAGE_SIZE - 1)) == 0);
-	ret = set_extent_defrag(&BTRFS_I(inode)->io_tree, start, end,
-				cached_state);
+	if (reserve_type == BTRFS_RESERVE_COMPRESS)
+		bits = EXTENT_DELALLOC | EXTENT_UPTODATE | EXTENT_DEFRAG |
+				EXTENT_COMPRESS;
+	else
+		bits = EXTENT_DELALLOC | EXTENT_UPTODATE | EXTENT_DEFRAG;
 
+	ret = set_extent_bit(&BTRFS_I(inode)->io_tree, start, end,
+			     bits, NULL, cached_state, GFP_NOFS);
 	if (ret == 0 && !btrfs_is_free_space_inode(inode)) {
 		spin_lock(&BTRFS_I(inode)->lock);
 		BTRFS_I(inode)->outstanding_extents -= num_extents;
@@ -2131,6 +2184,8 @@ again:
 		goto again;
 	}
 
+	if (inode_need_compress(inode))
+		reserve_type = BTRFS_RESERVE_COMPRESS;
 	ret = btrfs_delalloc_reserve_space(inode, page_start,
 					   PAGE_SIZE, reserve_type);
 	if (ret) {
@@ -3029,8 +3084,11 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 
 	trans->block_rsv = &root->fs_info->delalloc_block_rsv;
 
-	if (test_bit(BTRFS_ORDERED_COMPRESSED, &ordered_extent->flags))
+	if (test_bit(BTRFS_ORDERED_COMPRESSED, &ordered_extent->flags)) {
 		compress_type = ordered_extent->compress_type;
+		reserve_type = BTRFS_RESERVE_COMPRESS;
+	}
+
 	if (test_bit(BTRFS_ORDERED_PREALLOC, &ordered_extent->flags)) {
 		BUG_ON(compress_type);
 		ret = btrfs_mark_extent_written(trans, inode,
@@ -4792,6 +4850,9 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 	u64 block_end;
 	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
 
+	if (inode_need_compress(inode))
+		reserve_type = BTRFS_RESERVE_COMPRESS;
+
 	if ((offset & (blocksize - 1)) == 0 &&
 	    (!len || ((len & (blocksize - 1)) == 0)))
 		goto out;
@@ -9079,6 +9140,8 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	page_end = page_start + PAGE_SIZE - 1;
 	end = page_end;
 
+	if (inode_need_compress(inode))
+		reserve_type = BTRFS_RESERVE_COMPRESS;
 	/*
 	 * Reserving delalloc space after obtaining the page lock can lead to
 	 * deadlock. For example, if a dirty page is locked by this function
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 870737b..492ec2e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1140,6 +1140,8 @@ static int cluster_pages_for_defrag(struct inode *inode,
 
 	page_cnt = min_t(u64, (u64)num_pages, (u64)file_end - start_index + 1);
 
+	if (inode_need_compress(inode))
+		reserve_type = BTRFS_RESERVE_COMPRESS;
 	ret = btrfs_delalloc_reserve_space(inode,
 			start_index << PAGE_SHIFT,
 			page_cnt << PAGE_SHIFT, reserve_type);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 0e4b370..08cfb47 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3156,6 +3156,9 @@ static int relocate_file_extent_cluster(struct inode *inode,
 	if (!cluster->nr)
 		return 0;
 
+	if (inode_need_compress(inode))
+		reserve_type = BTRFS_RESERVE_COMPRESS;
+
 	ra = kzalloc(sizeof(*ra), GFP_NOFS);
 	if (!ra)
 		return -ENOMEM;
-- 
2.7.4



