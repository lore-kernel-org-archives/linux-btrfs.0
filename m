Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17474 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750987AbdCPH7V (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Mar 2017 03:59:21 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v14.2 02/16] btrfs: introduce type based delalloc metadata reserve
Date: Thu, 16 Mar 2017 15:58:40 +0800
Message-ID: <20170316075854.15788-3-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170316075854.15788-1-quwenruo@cn.fujitsu.com>
References: <20170316075854.15788-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Introduce type based metadata reserve parameter for delalloc space
reservation/freeing function.

The problem we are going to solve is, btrfs use different max extent
size for different mount options.

For compression, the max extent size is 128K, while for non-compress write
it's 128M.
And further more, split/merge extent hook highly depends that max extent
size.

Such situation contributes to quite a lot of false ENOSPC.

So this patch introduce the facility to help solve these false ENOSPC
related to different max extent size.

Currently only normal 128M extent size is supported. More types will
follow soon.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/ctree.h             |  38 ++++++++++++----
 fs/btrfs/extent-tree.c       |  43 +++++++++++++-----
 fs/btrfs/file.c              |  21 +++++----
 fs/btrfs/free-space-cache.c  |   5 ++-
 fs/btrfs/inode-map.c         |   6 ++-
 fs/btrfs/inode.c             | 105 ++++++++++++++++++++++++++++---------------
 fs/btrfs/ioctl.c             |  10 +++--
 fs/btrfs/relocation.c        |  10 +++--
 fs/btrfs/tests/inode-tests.c |  15 ++++---
 9 files changed, 172 insertions(+), 81 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 73612ca10fd5..67a291bd3374 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -101,11 +101,24 @@ static const int btrfs_csum_sizes[] = { 4 };
 /*
  * Count how many BTRFS_MAX_EXTENT_SIZE cover the @size
  */
-static inline u32 count_max_extents(u64 size)
+static inline u32 count_max_extents(u64 size, u64 max_extent_size)
 {
-	return div_u64(size + BTRFS_MAX_EXTENT_SIZE - 1, BTRFS_MAX_EXTENT_SIZE);
+	return div_u64(size + max_extent_size - 1, max_extent_size);
 }
 
+/*
+ * Type based metadata reserve type
+ * This affects how btrfs reserve metadata space for buffered write.
+ *
+ * This is caused by the different max extent size for normal COW
+ * and compression, and further in-band dedupe
+ */
+enum btrfs_metadata_reserve_type {
+	BTRFS_RESERVE_NORMAL,
+};
+
+u64 btrfs_max_extent_size(enum btrfs_metadata_reserve_type reserve_type);
+
 struct btrfs_mapping_tree {
 	struct extent_map_tree map_tree;
 };
@@ -2704,10 +2717,14 @@ int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 				     u64 *qgroup_reserved, bool use_global_rsv);
 void btrfs_subvolume_release_metadata(struct btrfs_fs_info *fs_info,
 				      struct btrfs_block_rsv *rsv);
-int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes);
-void btrfs_delalloc_release_metadata(struct btrfs_inode *inode, u64 num_bytes);
-int btrfs_delalloc_reserve_space(struct inode *inode, u64 start, u64 len);
-void btrfs_delalloc_release_space(struct inode *inode, u64 start, u64 len);
+int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes,
+			enum btrfs_metadata_reserve_type reserve_type);
+void btrfs_delalloc_release_metadata(struct btrfs_inode *inode, u64 num_bytes,
+			enum btrfs_metadata_reserve_type reserve_type);
+int btrfs_delalloc_reserve_space(struct inode *inode, u64 start, u64 len,
+			enum btrfs_metadata_reserve_type reserve_type);
+void btrfs_delalloc_release_space(struct inode *inode, u64 start, u64 len,
+			enum btrfs_metadata_reserve_type reserve_type);
 void btrfs_init_block_rsv(struct btrfs_block_rsv *rsv, unsigned short type);
 struct btrfs_block_rsv *btrfs_alloc_block_rsv(struct btrfs_fs_info *fs_info,
 					      unsigned short type);
@@ -3147,9 +3164,11 @@ int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput);
 int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, int delay_iput,
 			       int nr);
 int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
-			      struct extent_state **cached_state, int dedupe);
+			      struct extent_state **cached_state,
+			      enum btrfs_metadata_reserve_type reserve_type);
 int btrfs_set_extent_defrag(struct inode *inode, u64 start, u64 end,
-			    struct extent_state **cached_state);
+			    struct extent_state **cached_state,
+			    enum btrfs_metadata_reserve_type reserve_type);
 int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *new_root,
 			     struct btrfs_root *parent_root,
@@ -3241,7 +3260,8 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 int btrfs_release_file(struct inode *inode, struct file *file);
 int btrfs_dirty_pages(struct inode *inode, struct page **pages,
 		      size_t num_pages, loff_t pos, size_t write_bytes,
-		      struct extent_state **cached);
+		      struct extent_state **cached,
+		      enum btrfs_metadata_reserve_type reserve_type);
 int btrfs_fdatawrite_range(struct inode *inode, loff_t start, loff_t end);
 int btrfs_clone_file_range(struct file *file_in, loff_t pos_in,
 			   struct file *file_out, loff_t pos_out, u64 len);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index be5477676cc8..a86af07462d2 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5848,13 +5848,14 @@ void btrfs_subvolume_release_metadata(struct btrfs_fs_info *fs_info,
  * BTRFS_I(inode)->lock held.
  */
 static unsigned drop_outstanding_extent(struct btrfs_inode *inode,
-		u64 num_bytes)
+		u64 num_bytes, enum btrfs_metadata_reserve_type reserve_type)
 {
 	unsigned drop_inode_space = 0;
 	unsigned dropped_extents = 0;
 	unsigned num_extents;
+	u64 max_extent_size = btrfs_max_extent_size(reserve_type);
 
-	num_extents = count_max_extents(num_bytes);
+	num_extents = count_max_extents(num_bytes, max_extent_size);
 	ASSERT(num_extents);
 	ASSERT(inode->outstanding_extents >= num_extents);
 	inode->outstanding_extents -= num_extents;
@@ -5921,7 +5922,17 @@ static u64 calc_csum_metadata_size(struct btrfs_inode *inode, u64 num_bytes,
 	return btrfs_calc_trans_metadata_size(fs_info, old_csums - num_csums);
 }
 
-int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
+u64 btrfs_max_extent_size(enum btrfs_metadata_reserve_type reserve_type)
+{
+	if (reserve_type == BTRFS_RESERVE_NORMAL)
+		return BTRFS_MAX_EXTENT_SIZE;
+
+	ASSERT(0);
+	return BTRFS_MAX_EXTENT_SIZE;
+}
+
+int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes,
+			enum btrfs_metadata_reserve_type reserve_type)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
 	struct btrfs_root *root = inode->root;
@@ -5933,6 +5944,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
 	int ret = 0;
 	bool delalloc_lock = true;
 	u64 to_free = 0;
+	u64 max_extent_size = btrfs_max_extent_size(reserve_type);
 	unsigned dropped;
 	bool release_extra = false;
 
@@ -5961,7 +5973,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
 	num_bytes = ALIGN(num_bytes, fs_info->sectorsize);
 
 	spin_lock(&inode->lock);
-	nr_extents = count_max_extents(num_bytes);
+	nr_extents = count_max_extents(num_bytes, max_extent_size);
 	inode->outstanding_extents += nr_extents;
 
 	nr_extents = 0;
@@ -6011,7 +6023,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
 
 out_fail:
 	spin_lock(&inode->lock);
-	dropped = drop_outstanding_extent(inode, num_bytes);
+	dropped = drop_outstanding_extent(inode, num_bytes, reserve_type);
 	/*
 	 * If the inodes csum_bytes is the same as the original
 	 * csum_bytes then we know we haven't raced with any free()ers
@@ -6077,12 +6089,15 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
  * btrfs_delalloc_release_metadata - release a metadata reservation for an inode
  * @inode: the inode to release the reservation for
  * @num_bytes: the number of bytes we're releasing
+ * @reserve_type: the type when we reserve delalloc space for this range.
+ *                must be the same passed to btrfs_delalloc_reserve_metadata()
  *
  * This will release the metadata reservation for an inode.  This can be called
  * once we complete IO for a given set of bytes to release their metadata
  * reservations.
  */
-void btrfs_delalloc_release_metadata(struct btrfs_inode *inode, u64 num_bytes)
+void btrfs_delalloc_release_metadata(struct btrfs_inode *inode, u64 num_bytes,
+			enum btrfs_metadata_reserve_type reserve_type)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
 	u64 to_free = 0;
@@ -6090,7 +6105,7 @@ void btrfs_delalloc_release_metadata(struct btrfs_inode *inode, u64 num_bytes)
 
 	num_bytes = ALIGN(num_bytes, fs_info->sectorsize);
 	spin_lock(&inode->lock);
-	dropped = drop_outstanding_extent(inode, num_bytes);
+	dropped = drop_outstanding_extent(inode, num_bytes, reserve_type);
 
 	if (num_bytes)
 		to_free = calc_csum_metadata_size(inode, num_bytes, 0);
@@ -6113,6 +6128,8 @@ void btrfs_delalloc_release_metadata(struct btrfs_inode *inode, u64 num_bytes)
  * @inode: inode we're writing to
  * @start: start range we are writing to
  * @len: how long the range we are writing to
+ * @reserve_type: the type of write we're reserving for.
+ *		  determine the max extent size.
  *
  * This will do the following things
  *
@@ -6130,14 +6147,15 @@ void btrfs_delalloc_release_metadata(struct btrfs_inode *inode, u64 num_bytes)
  * Return 0 for success
  * Return <0 for error(-ENOSPC or -EQUOT)
  */
-int btrfs_delalloc_reserve_space(struct inode *inode, u64 start, u64 len)
+int btrfs_delalloc_reserve_space(struct inode *inode, u64 start, u64 len,
+				 enum btrfs_metadata_reserve_type reserve_type)
 {
 	int ret;
 
 	ret = btrfs_check_data_free_space(inode, start, len);
 	if (ret < 0)
 		return ret;
-	ret = btrfs_delalloc_reserve_metadata(BTRFS_I(inode), len);
+	ret = btrfs_delalloc_reserve_metadata(BTRFS_I(inode), len, reserve_type);
 	if (ret < 0)
 		btrfs_free_reserved_data_space(inode, start, len);
 	return ret;
@@ -6148,6 +6166,8 @@ int btrfs_delalloc_reserve_space(struct inode *inode, u64 start, u64 len)
  * @inode: inode we're releasing space for
  * @start: start position of the space already reserved
  * @len: the len of the space already reserved
+ * @reserve_type: the type of write we're releasing for
+ *		  must match the type passed to btrfs_delalloc_reserve_space()
  *
  * This must be matched with a call to btrfs_delalloc_reserve_space.  This is
  * called in the case that we don't need the metadata AND data reservations
@@ -6158,9 +6178,10 @@ int btrfs_delalloc_reserve_space(struct inode *inode, u64 start, u64 len)
  * list if there are no delalloc bytes left.
  * Also it will handle the qgroup reserved space.
  */
-void btrfs_delalloc_release_space(struct inode *inode, u64 start, u64 len)
+void btrfs_delalloc_release_space(struct inode *inode, u64 start, u64 len,
+			enum btrfs_metadata_reserve_type reserve_type)
 {
-	btrfs_delalloc_release_metadata(BTRFS_I(inode), len);
+	btrfs_delalloc_release_metadata(BTRFS_I(inode), len, reserve_type);
 	btrfs_free_reserved_data_space(inode, start, len);
 }
 
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 520cb7230b2d..ee8f3a2a1d7a 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -487,7 +487,8 @@ static void btrfs_drop_pages(struct page **pages, size_t num_pages)
  */
 int btrfs_dirty_pages(struct inode *inode, struct page **pages,
 		      size_t num_pages, loff_t pos, size_t write_bytes,
-		      struct extent_state **cached)
+		      struct extent_state **cached,
+		      enum btrfs_metadata_reserve_type reserve_type)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	int err = 0;
@@ -504,7 +505,7 @@ int btrfs_dirty_pages(struct inode *inode, struct page **pages,
 
 	end_of_last_block = start_pos + num_bytes - 1;
 	err = btrfs_set_extent_delalloc(inode, start_pos, end_of_last_block,
-					cached, 0);
+					cached, reserve_type);
 	if (err)
 		return err;
 
@@ -1538,6 +1539,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 	bool only_release_metadata = false;
 	bool force_page_uptodate = false;
 	bool need_unlock;
+	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
 
 	nrptrs = min(DIV_ROUND_UP(iov_iter_count(i), PAGE_SIZE),
 			PAGE_SIZE / (sizeof(struct page *)));
@@ -1602,7 +1604,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 		}
 
 		ret = btrfs_delalloc_reserve_metadata(BTRFS_I(inode),
-				reserve_bytes);
+				reserve_bytes, reserve_type);
 		if (ret) {
 			if (!only_release_metadata)
 				btrfs_free_reserved_data_space(inode, pos,
@@ -1681,7 +1683,8 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 			}
 			if (only_release_metadata) {
 				btrfs_delalloc_release_metadata(BTRFS_I(inode),
-								release_bytes);
+								release_bytes,
+								reserve_type);
 			} else {
 				u64 __pos;
 
@@ -1689,7 +1692,8 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 						   fs_info->sectorsize) +
 					(dirty_pages << PAGE_SHIFT);
 				btrfs_delalloc_release_space(inode, __pos,
-							     release_bytes);
+							     release_bytes,
+							     reserve_type);
 			}
 		}
 
@@ -1698,7 +1702,8 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 
 		if (copied > 0)
 			ret = btrfs_dirty_pages(inode, pages, dirty_pages,
-						pos, copied, NULL);
+						pos, copied, NULL,
+						reserve_type);
 		if (need_unlock)
 			unlock_extent_cached(&BTRFS_I(inode)->io_tree,
 					     lockstart, lockend, &cached_state,
@@ -1742,11 +1747,11 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 		if (only_release_metadata) {
 			btrfs_end_write_no_snapshoting(root);
 			btrfs_delalloc_release_metadata(BTRFS_I(inode),
-					release_bytes);
+					release_bytes, reserve_type);
 		} else {
 			btrfs_delalloc_release_space(inode,
 						round_down(pos, fs_info->sectorsize),
-						release_bytes);
+						release_bytes, reserve_type);
 		}
 	}
 
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index da6841efac26..2e802d9b6272 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1309,7 +1309,8 @@ static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 
 	/* Everything is written out, now we dirty the pages in the file. */
 	ret = btrfs_dirty_pages(inode, io_ctl->pages, io_ctl->num_pages, 0,
-				i_size_read(inode), &cached_state);
+				i_size_read(inode), &cached_state,
+				BTRFS_RESERVE_NORMAL);
 	if (ret)
 		goto out_nospc;
 
@@ -3547,7 +3548,7 @@ int btrfs_write_out_ino_cache(struct btrfs_root *root,
 	if (ret) {
 		if (release_metadata)
 			btrfs_delalloc_release_metadata(BTRFS_I(inode),
-					inode->i_size);
+					inode->i_size, BTRFS_RESERVE_NORMAL);
 #ifdef DEBUG
 		btrfs_err(fs_info,
 			  "failed to write free ino cache for root %llu",
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index 5c6c20ec64d8..c2f37469919f 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -492,14 +492,16 @@ int btrfs_save_ino_cache(struct btrfs_root *root,
 	/* Just to make sure we have enough space */
 	prealloc += 8 * PAGE_SIZE;
 
-	ret = btrfs_delalloc_reserve_space(inode, 0, prealloc);
+	ret = btrfs_delalloc_reserve_space(inode, 0, prealloc,
+					   BTRFS_RESERVE_NORMAL);
 	if (ret)
 		goto out_put;
 
 	ret = btrfs_prealloc_file_range_trans(inode, trans, 0, 0, prealloc,
 					      prealloc, prealloc, &alloc_hint);
 	if (ret) {
-		btrfs_delalloc_release_metadata(BTRFS_I(inode), prealloc);
+		btrfs_delalloc_release_metadata(BTRFS_I(inode), prealloc,
+						BTRFS_RESERVE_NORMAL);
 		goto out_put;
 	}
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c7bcb658e891..f32e3792eaca 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -316,7 +316,8 @@ static noinline int cow_file_range_inline(struct btrfs_root *root,
 	}
 
 	set_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &BTRFS_I(inode)->runtime_flags);
-	btrfs_delalloc_release_metadata(BTRFS_I(inode), end + 1 - start);
+	btrfs_delalloc_release_metadata(BTRFS_I(inode), end + 1 - start,
+					BTRFS_RESERVE_NORMAL);
 	btrfs_drop_extent_cache(BTRFS_I(inode), start, aligned_end - 1, 0);
 out:
 	/*
@@ -1516,6 +1517,8 @@ static void btrfs_split_extent_hook(struct inode *inode,
 				    struct extent_state *orig, u64 split)
 {
 	u64 size;
+	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
+	u64 max_extent_size;
 
 	/* not delalloc, ignore it */
 	if (!(orig->state & EXTENT_DELALLOC))
@@ -1524,8 +1527,10 @@ static void btrfs_split_extent_hook(struct inode *inode,
 	if (btrfs_is_free_space_inode(BTRFS_I(inode)))
 		return;
 
+	max_extent_size = btrfs_max_extent_size(reserve_type);
+
 	size = orig->end - orig->start + 1;
-	if (size > BTRFS_MAX_EXTENT_SIZE) {
+	if (size > max_extent_size) {
 		u32 num_extents;
 		u64 new_size;
 
@@ -1534,10 +1539,10 @@ static void btrfs_split_extent_hook(struct inode *inode,
 		 * applies here, just in reverse.
 		 */
 		new_size = orig->end - split + 1;
-		num_extents = count_max_extents(new_size);
+		num_extents = count_max_extents(new_size, max_extent_size);
 		new_size = split - orig->start;
-		num_extents += count_max_extents(new_size);
-		if (count_max_extents(size) >= num_extents)
+		num_extents += count_max_extents(new_size, max_extent_size);
+		if (count_max_extents(size, max_extent_size) >= num_extents)
 			return;
 	}
 
@@ -1557,7 +1562,9 @@ static void btrfs_merge_extent_hook(struct inode *inode,
 				    struct extent_state *other)
 {
 	u64 new_size, old_size;
+	u64 max_extent_size;
 	u32 num_extents;
+	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
 
 	/* not delalloc, ignore it */
 	if (!(other->state & EXTENT_DELALLOC))
@@ -1566,13 +1573,15 @@ static void btrfs_merge_extent_hook(struct inode *inode,
 	if (btrfs_is_free_space_inode(BTRFS_I(inode)))
 		return;
 
+	max_extent_size = btrfs_max_extent_size(reserve_type);
+
 	if (new->start > other->start)
 		new_size = new->end - other->start + 1;
 	else
 		new_size = other->end - new->start + 1;
 
 	/* we're not bigger than the max, unreserve the space and go */
-	if (new_size <= BTRFS_MAX_EXTENT_SIZE) {
+	if (new_size <= max_extent_size) {
 		spin_lock(&BTRFS_I(inode)->lock);
 		BTRFS_I(inode)->outstanding_extents--;
 		spin_unlock(&BTRFS_I(inode)->lock);
@@ -1598,10 +1607,10 @@ static void btrfs_merge_extent_hook(struct inode *inode,
 	 * this case.
 	 */
 	old_size = other->end - other->start + 1;
-	num_extents = count_max_extents(old_size);
+	num_extents = count_max_extents(old_size, max_extent_size);
 	old_size = new->end - new->start + 1;
-	num_extents += count_max_extents(old_size);
-	if (count_max_extents(new_size) >= num_extents)
+	num_extents += count_max_extents(old_size, max_extent_size);
+	if (count_max_extents(new_size, max_extent_size) >= num_extents)
 		return;
 
 	spin_lock(&BTRFS_I(inode)->lock);
@@ -1673,10 +1682,15 @@ static void btrfs_set_bit_hook(struct inode *inode,
 	if (!(state->state & EXTENT_DELALLOC) && (*bits & EXTENT_DELALLOC)) {
 		struct btrfs_root *root = BTRFS_I(inode)->root;
 		u64 len = state->end + 1 - state->start;
-		u64 num_extents = div64_u64(len + BTRFS_MAX_EXTENT_SIZE - 1,
-					    BTRFS_MAX_EXTENT_SIZE);
+		u64 max_extent_size;
+		u64 num_extents;
+		enum btrfs_metadata_reserve_type reserve_type =
+					BTRFS_RESERVE_NORMAL;
 		bool do_list = !btrfs_is_free_space_inode(BTRFS_I(inode));
 
+		max_extent_size = btrfs_max_extent_size(reserve_type);
+		num_extents = count_max_extents(len, max_extent_size);
+
 		if (*bits & EXTENT_FIRST_DELALLOC)
 			*bits &= ~EXTENT_FIRST_DELALLOC;
 
@@ -1711,8 +1725,10 @@ static void btrfs_clear_bit_hook(struct btrfs_inode *inode,
 				 unsigned *bits)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
+	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
 	u64 len = state->end + 1 - state->start;
-	u32 num_extents = count_max_extents(len);
+	u64 max_extent_size;
+	u32 num_extents;
 
 	spin_lock(&inode->lock);
 	if ((state->state & EXTENT_DEFRAG) && (*bits & EXTENT_DEFRAG))
@@ -1728,6 +1744,9 @@ static void btrfs_clear_bit_hook(struct btrfs_inode *inode,
 		struct btrfs_root *root = inode->root;
 		bool do_list = !btrfs_is_free_space_inode(inode);
 
+		max_extent_size = btrfs_max_extent_size(reserve_type);
+		num_extents = count_max_extents(len, max_extent_size);
+
 		if (*bits & EXTENT_FIRST_DELALLOC) {
 			*bits &= ~EXTENT_FIRST_DELALLOC;
 		} else if (!(*bits & EXTENT_DO_ACCOUNTING)) {
@@ -1743,7 +1762,8 @@ static void btrfs_clear_bit_hook(struct btrfs_inode *inode,
 		 */
 		if (*bits & EXTENT_DO_ACCOUNTING &&
 		    root != fs_info->tree_root)
-			btrfs_delalloc_release_metadata(inode, len);
+			btrfs_delalloc_release_metadata(inode, len,
+							reserve_type);
 
 		/* For sanity tests. */
 		if (btrfs_is_testing(fs_info))
@@ -1926,11 +1946,13 @@ static noinline int add_pending_csums(struct btrfs_trans_handle *trans,
 }
 
 int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
-			      struct extent_state **cached_state, int dedupe)
+			      struct extent_state **cached_state,
+			      enum btrfs_metadata_reserve_type reserve_type)
 {
 	int ret;
-	u64 num_extents = div64_u64(end - start + BTRFS_MAX_EXTENT_SIZE,
-				    BTRFS_MAX_EXTENT_SIZE);
+	u64 max_extent_size = btrfs_max_extent_size(reserve_type);
+	u64 num_extents = div64_u64(end - start + max_extent_size,
+				    max_extent_size);
 
 	WARN_ON((end & (PAGE_SIZE - 1)) == 0);
 	ret = set_extent_delalloc(&BTRFS_I(inode)->io_tree, start, end,
@@ -1957,11 +1979,13 @@ int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
 }
 
 int btrfs_set_extent_defrag(struct inode *inode, u64 start, u64 end,
-			    struct extent_state **cached_state)
+			    struct extent_state **cached_state,
+			    enum btrfs_metadata_reserve_type reserve_type)
 {
 	int ret;
-	u64 num_extents = div64_u64(end - start + BTRFS_MAX_EXTENT_SIZE,
-				    BTRFS_MAX_EXTENT_SIZE);
+	u64 max_extent_size = btrfs_max_extent_size(reserve_type);
+	u64 num_extents = div64_u64(end - start + max_extent_size,
+				    max_extent_size);
 
 	WARN_ON((end & (PAGE_SIZE - 1)) == 0);
 	ret = set_extent_defrag(&BTRFS_I(inode)->io_tree, start, end,
@@ -1992,6 +2016,7 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 	u64 page_start;
 	u64 page_end;
 	int ret;
+	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
 
 	fixup = container_of(work, struct btrfs_writepage_fixup, work);
 	page = fixup->page;
@@ -2025,7 +2050,7 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 	}
 
 	ret = btrfs_delalloc_reserve_space(inode, page_start,
-					   PAGE_SIZE);
+					   PAGE_SIZE, reserve_type);
 	if (ret) {
 		mapping_set_error(page->mapping, ret);
 		end_extent_writepage(page, ret, page_start, page_end);
@@ -2034,7 +2059,7 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 	 }
 
 	btrfs_set_extent_delalloc(inode, page_start, page_end, &cached_state,
-				  0);
+				  reserve_type);
 	ClearPageChecked(page);
 	set_page_dirty(page);
 out:
@@ -2842,6 +2867,7 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 	u64 logical_len = ordered_extent->len;
 	bool nolock;
 	bool truncated = false;
+	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
 
 	nolock = btrfs_is_free_space_inode(BTRFS_I(inode));
 
@@ -2966,7 +2992,7 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 out:
 	if (root != fs_info->tree_root)
 		btrfs_delalloc_release_metadata(BTRFS_I(inode),
-				ordered_extent->len);
+				ordered_extent->len, reserve_type);
 	if (trans)
 		btrfs_end_transaction(trans);
 
@@ -4702,13 +4728,14 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 	int ret = 0;
 	u64 block_start;
 	u64 block_end;
+	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
 
 	if ((offset & (blocksize - 1)) == 0 &&
 	    (!len || ((len & (blocksize - 1)) == 0)))
 		goto out;
 
 	ret = btrfs_delalloc_reserve_space(inode,
-			round_down(from, blocksize), blocksize);
+			round_down(from, blocksize), blocksize, reserve_type);
 	if (ret)
 		goto out;
 
@@ -4717,7 +4744,7 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 	if (!page) {
 		btrfs_delalloc_release_space(inode,
 				round_down(from, blocksize),
-				blocksize);
+				blocksize, reserve_type);
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -4760,7 +4787,7 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 			  0, 0, &cached_state, GFP_NOFS);
 
 	ret = btrfs_set_extent_delalloc(inode, block_start, block_end,
-					&cached_state, 0);
+					&cached_state, reserve_type);
 	if (ret) {
 		unlock_extent_cached(io_tree, block_start, block_end,
 				     &cached_state, GFP_NOFS);
@@ -4788,7 +4815,7 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 out_unlock:
 	if (ret)
 		btrfs_delalloc_release_space(inode, block_start,
-					     blocksize);
+					     blocksize, reserve_type);
 	unlock_page(page);
 	put_page(page);
 out:
@@ -7604,7 +7631,8 @@ static void adjust_dio_outstanding_extents(struct inode *inode,
 					   struct btrfs_dio_data *dio_data,
 					   const u64 len)
 {
-	unsigned num_extents = count_max_extents(len);
+	u64 max_extent_size = btrfs_max_extent_size(BTRFS_RESERVE_NORMAL);
+	unsigned num_extents = count_max_extents(len, max_extent_size);
 
 	/*
 	 * If we have an outstanding_extents count still set then we're
@@ -8635,6 +8663,7 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	bool wakeup = true;
 	bool relock = false;
 	ssize_t ret;
+	u64 max_extent_size = btrfs_max_extent_size(BTRFS_RESERVE_NORMAL);
 
 	if (check_direct_IO(fs_info, iocb, iter, offset))
 		return 0;
@@ -8665,10 +8694,12 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 			inode_unlock(inode);
 			relock = true;
 		}
-		ret = btrfs_delalloc_reserve_space(inode, offset, count);
+		ret = btrfs_delalloc_reserve_space(inode, offset, count,
+						   BTRFS_RESERVE_NORMAL);
 		if (ret)
 			goto out;
-		dio_data.outstanding_extents = count_max_extents(count);
+		dio_data.outstanding_extents = count_max_extents(count,
+							max_extent_size);
 
 		/*
 		 * We need to know how many extents we reserved so that we can
@@ -8698,7 +8729,7 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 		if (ret < 0 && ret != -EIOCBQUEUED) {
 			if (dio_data.reserve)
 				btrfs_delalloc_release_space(inode, offset,
-							     dio_data.reserve);
+					dio_data.reserve, BTRFS_RESERVE_NORMAL);
 			/*
 			 * On error we might have left some ordered extents
 			 * without submitting corresponding bios for them, so
@@ -8714,7 +8745,8 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 					0);
 		} else if (ret >= 0 && (size_t)ret < count)
 			btrfs_delalloc_release_space(inode, offset,
-						     count - (size_t)ret);
+						     count - (size_t)ret,
+						     BTRFS_RESERVE_NORMAL);
 	}
 out:
 	if (wakeup)
@@ -8953,6 +8985,7 @@ int btrfs_page_mkwrite(struct vm_fault *vmf)
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct btrfs_ordered_extent *ordered;
 	struct extent_state *cached_state = NULL;
+	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
 	char *kaddr;
 	unsigned long zero_start;
 	loff_t size;
@@ -8979,7 +9012,7 @@ int btrfs_page_mkwrite(struct vm_fault *vmf)
 	 * being processed by btrfs_page_mkwrite() function.
 	 */
 	ret = btrfs_delalloc_reserve_space(inode, page_start,
-					   reserved_space);
+					   reserved_space, reserve_type);
 	if (!ret) {
 		ret = file_update_time(vmf->vma->vm_file);
 		reserved = 1;
@@ -9033,7 +9066,8 @@ int btrfs_page_mkwrite(struct vm_fault *vmf)
 			BTRFS_I(inode)->outstanding_extents++;
 			spin_unlock(&BTRFS_I(inode)->lock);
 			btrfs_delalloc_release_space(inode, page_start,
-						PAGE_SIZE - reserved_space);
+						PAGE_SIZE - reserved_space,
+						reserve_type);
 		}
 	}
 
@@ -9050,7 +9084,7 @@ int btrfs_page_mkwrite(struct vm_fault *vmf)
 			  0, 0, &cached_state, GFP_NOFS);
 
 	ret = btrfs_set_extent_delalloc(inode, page_start, end,
-					&cached_state, 0);
+					&cached_state, reserve_type);
 	if (ret) {
 		unlock_extent_cached(io_tree, page_start, page_end,
 				     &cached_state, GFP_NOFS);
@@ -9088,7 +9122,8 @@ int btrfs_page_mkwrite(struct vm_fault *vmf)
 	}
 	unlock_page(page);
 out:
-	btrfs_delalloc_release_space(inode, page_start, reserved_space);
+	btrfs_delalloc_release_space(inode, page_start, reserved_space,
+				     reserve_type);
 out_noreserve:
 	sb_end_pagefault(inode->i_sb);
 	return ret;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index cc7382ec820f..e1bd2ffabdc9 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1127,6 +1127,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 	struct btrfs_ordered_extent *ordered;
 	struct extent_state *cached_state = NULL;
 	struct extent_io_tree *tree;
+	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
 	gfp_t mask = btrfs_alloc_write_mask(inode->i_mapping);
 
 	file_end = (isize - 1) >> PAGE_SHIFT;
@@ -1137,7 +1138,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 
 	ret = btrfs_delalloc_reserve_space(inode,
 			start_index << PAGE_SHIFT,
-			page_cnt << PAGE_SHIFT);
+			page_cnt << PAGE_SHIFT, reserve_type);
 	if (ret)
 		return ret;
 	i_done = 0;
@@ -1228,11 +1229,12 @@ static int cluster_pages_for_defrag(struct inode *inode,
 		spin_unlock(&BTRFS_I(inode)->lock);
 		btrfs_delalloc_release_space(inode,
 				start_index << PAGE_SHIFT,
-				(page_cnt - i_done) << PAGE_SHIFT);
+				(page_cnt - i_done) << PAGE_SHIFT,
+				reserve_type);
 	}
 
 	btrfs_set_extent_defrag(inode, page_start,
-				page_end - 1, &cached_state);
+				page_end - 1, &cached_state, reserve_type);
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree,
 			     page_start, page_end - 1, &cached_state,
 			     GFP_NOFS);
@@ -1253,7 +1255,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 	}
 	btrfs_delalloc_release_space(inode,
 			start_index << PAGE_SHIFT,
-			page_cnt << PAGE_SHIFT);
+			page_cnt << PAGE_SHIFT, reserve_type);
 	return ret;
 
 }
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index d60df51959f7..cb7c65b430d4 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3178,6 +3178,7 @@ static int relocate_file_extent_cluster(struct inode *inode,
 	unsigned long last_index;
 	struct page *page;
 	struct file_ra_state *ra;
+	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
 	gfp_t mask = btrfs_alloc_write_mask(inode->i_mapping);
 	int nr = 0;
 	int ret = 0;
@@ -3204,7 +3205,7 @@ static int relocate_file_extent_cluster(struct inode *inode,
 	last_index = (cluster->end - offset) >> PAGE_SHIFT;
 	while (index <= last_index) {
 		ret = btrfs_delalloc_reserve_metadata(BTRFS_I(inode),
-				PAGE_SIZE);
+				PAGE_SIZE, reserve_type);
 		if (ret)
 			goto out;
 
@@ -3217,7 +3218,7 @@ static int relocate_file_extent_cluster(struct inode *inode,
 						   mask);
 			if (!page) {
 				btrfs_delalloc_release_metadata(BTRFS_I(inode),
-							PAGE_SIZE);
+						PAGE_SIZE, reserve_type);
 				ret = -ENOMEM;
 				goto out;
 			}
@@ -3236,7 +3237,7 @@ static int relocate_file_extent_cluster(struct inode *inode,
 				unlock_page(page);
 				put_page(page);
 				btrfs_delalloc_release_metadata(BTRFS_I(inode),
-							PAGE_SIZE);
+						PAGE_SIZE, reserve_type);
 				ret = -EIO;
 				goto out;
 			}
@@ -3257,7 +3258,8 @@ static int relocate_file_extent_cluster(struct inode *inode,
 			nr++;
 		}
 
-		btrfs_set_extent_delalloc(inode, page_start, page_end, NULL, 0);
+		btrfs_set_extent_delalloc(inode, page_start, page_end, NULL,
+					  reserve_type);
 		set_page_dirty(page);
 
 		unlock_extent(&BTRFS_I(inode)->io_tree,
diff --git a/fs/btrfs/tests/inode-tests.c b/fs/btrfs/tests/inode-tests.c
index 8c91d03cc82d..88354c639c43 100644
--- a/fs/btrfs/tests/inode-tests.c
+++ b/fs/btrfs/tests/inode-tests.c
@@ -944,6 +944,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	struct btrfs_fs_info *fs_info = NULL;
 	struct inode *inode = NULL;
 	struct btrfs_root *root = NULL;
+	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
 	int ret = -ENOMEM;
 
 	inode = btrfs_new_test_inode();
@@ -970,7 +971,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	/* [BTRFS_MAX_EXTENT_SIZE] */
 	BTRFS_I(inode)->outstanding_extents++;
 	ret = btrfs_set_extent_delalloc(inode, 0, BTRFS_MAX_EXTENT_SIZE - 1,
-					NULL, 0);
+					NULL, reserve_type);
 	if (ret) {
 		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
 		goto out;
@@ -986,7 +987,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	BTRFS_I(inode)->outstanding_extents++;
 	ret = btrfs_set_extent_delalloc(inode, BTRFS_MAX_EXTENT_SIZE,
 					BTRFS_MAX_EXTENT_SIZE + sectorsize - 1,
-					NULL, 0);
+					NULL, reserve_type);
 	if (ret) {
 		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
 		goto out;
@@ -1021,7 +1022,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	ret = btrfs_set_extent_delalloc(inode, BTRFS_MAX_EXTENT_SIZE >> 1,
 					(BTRFS_MAX_EXTENT_SIZE >> 1)
 					+ sectorsize - 1,
-					NULL, 0);
+					NULL, reserve_type);
 	if (ret) {
 		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
 		goto out;
@@ -1044,7 +1045,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	ret = btrfs_set_extent_delalloc(inode,
 			BTRFS_MAX_EXTENT_SIZE + 2 * sectorsize,
 			(BTRFS_MAX_EXTENT_SIZE << 1) + 3 * sectorsize - 1,
-			NULL, 0);
+			NULL, reserve_type);
 	if (ret) {
 		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
 		goto out;
@@ -1062,7 +1063,8 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	BTRFS_I(inode)->outstanding_extents++;
 	ret = btrfs_set_extent_delalloc(inode,
 			BTRFS_MAX_EXTENT_SIZE + sectorsize,
-			BTRFS_MAX_EXTENT_SIZE + 2 * sectorsize - 1, NULL, 0);
+			BTRFS_MAX_EXTENT_SIZE + 2 * sectorsize - 1, NULL,
+			reserve_type);
 	if (ret) {
 		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
 		goto out;
@@ -1099,7 +1101,8 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	BTRFS_I(inode)->outstanding_extents++;
 	ret = btrfs_set_extent_delalloc(inode,
 			BTRFS_MAX_EXTENT_SIZE + sectorsize,
-			BTRFS_MAX_EXTENT_SIZE + 2 * sectorsize - 1, NULL, 0);
+			BTRFS_MAX_EXTENT_SIZE + 2 * sectorsize - 1, NULL,
+			reserve_type);
 	if (ret) {
 		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
 		goto out;
-- 
2.12.0



