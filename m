Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:61482 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S935064AbcKKIrj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Nov 2016 03:47:39 -0500
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, holger@applied-asynchrony.com,
        s.priebe@profihost.ag, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH 2/3] btrfs: introduce type based delalloc metadata reserve
Date: Fri, 11 Nov 2016 16:39:46 +0800
Message-Id: <1478853587-28717-3-git-send-email-wangxg.fnst@cn.fujitsu.com>
In-Reply-To: <1478853587-28717-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
References: <1478853587-28717-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

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
 fs/btrfs/ctree.h             |  34 ++++++++++---
 fs/btrfs/extent-tree.c       |  50 +++++++++++++------
 fs/btrfs/file.c              |  22 ++++++---
 fs/btrfs/free-space-cache.c  |   6 ++-
 fs/btrfs/inode-map.c         |   6 ++-
 fs/btrfs/inode.c             | 114 ++++++++++++++++++++++++++++---------------
 fs/btrfs/ioctl.c             |  10 ++--
 fs/btrfs/relocation.c        |  11 +++--
 fs/btrfs/tests/inode-tests.c |  15 +++---
 9 files changed, 180 insertions(+), 88 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 766d152..64c63c2 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -100,6 +100,19 @@ static const int btrfs_csum_sizes[] = { 4 };
 
 #define BTRFS_MAX_EXTENT_SIZE SZ_128M
 
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
@@ -2693,10 +2706,14 @@ int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 void btrfs_subvolume_release_metadata(struct btrfs_root *root,
 				      struct btrfs_block_rsv *rsv,
 				      u64 qgroup_reserved);
-int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes);
-void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes);
-int btrfs_delalloc_reserve_space(struct inode *inode, u64 start, u64 len);
-void btrfs_delalloc_release_space(struct inode *inode, u64 start, u64 len);
+int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes,
+			enum btrfs_metadata_reserve_type reserve_type);
+void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes,
+			enum btrfs_metadata_reserve_type reserve_type);
+int btrfs_delalloc_reserve_space(struct inode *inode, u64 start, u64 len,
+			enum btrfs_metadata_reserve_type reserve_type);
+void btrfs_delalloc_release_space(struct inode *inode, u64 start, u64 len,
+			enum btrfs_metadata_reserve_type reserve_type);
 void btrfs_init_block_rsv(struct btrfs_block_rsv *rsv, unsigned short type);
 struct btrfs_block_rsv *btrfs_alloc_block_rsv(struct btrfs_root *root,
 					      unsigned short type);
@@ -3138,9 +3155,11 @@ int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput);
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
@@ -3233,7 +3252,8 @@ int btrfs_release_file(struct inode *inode, struct file *file);
 int btrfs_dirty_pages(struct btrfs_root *root, struct inode *inode,
 		      struct page **pages, size_t num_pages,
 		      loff_t pos, size_t write_bytes,
-		      struct extent_state **cached);
+		      struct extent_state **cached,
+		      enum btrfs_metadata_reserve_type reserve_type);
 int btrfs_fdatawrite_range(struct inode *inode, loff_t start, loff_t end);
 ssize_t btrfs_copy_file_range(struct file *file_in, loff_t pos_in,
 			      struct file *file_out, loff_t pos_out,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4607af3..bd99f25 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5841,15 +5841,16 @@ void btrfs_subvolume_release_metadata(struct btrfs_root *root,
  * reserved extents that need to be freed.  This must be called with
  * BTRFS_I(inode)->lock held.
  */
-static unsigned drop_outstanding_extent(struct inode *inode, u64 num_bytes)
+static unsigned drop_outstanding_extent(struct inode *inode, u64 num_bytes,
+				enum btrfs_metadata_reserve_type reserve_type)
 {
 	unsigned drop_inode_space = 0;
 	unsigned dropped_extents = 0;
 	unsigned num_extents = 0;
+	u64 max_extent_size = btrfs_max_extent_size(reserve_type);
 
-	num_extents = (unsigned)div64_u64(num_bytes +
-					  BTRFS_MAX_EXTENT_SIZE - 1,
-					  BTRFS_MAX_EXTENT_SIZE);
+	num_extents = (unsigned)div64_u64(num_bytes + max_extent_size - 1,
+					  max_extent_size);
 	ASSERT(num_extents);
 	ASSERT(BTRFS_I(inode)->outstanding_extents >= num_extents);
 	BTRFS_I(inode)->outstanding_extents -= num_extents;
@@ -5919,7 +5920,17 @@ static u64 calc_csum_metadata_size(struct inode *inode, u64 num_bytes,
 	return btrfs_calc_trans_metadata_size(root, old_csums - num_csums);
 }
 
-int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
+u64 btrfs_max_extent_size(enum btrfs_metadata_reserve_type reserve_type)
+{
+	if (reserve_type == BTRFS_RESERVE_NORMAL)
+		return BTRFS_MAX_EXTENT_SIZE;
+
+	ASSERT(0);
+	return BTRFS_MAX_EXTENT_SIZE;
+}
+
+int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes,
+			enum btrfs_metadata_reserve_type reserve_type)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_block_rsv *block_rsv = &root->fs_info->delalloc_block_rsv;
@@ -5930,6 +5941,7 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	int ret = 0;
 	bool delalloc_lock = true;
 	u64 to_free = 0;
+	u64 max_extent_size = btrfs_max_extent_size(reserve_type);
 	unsigned dropped;
 	bool release_extra = false;
 
@@ -5958,9 +5970,8 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	num_bytes = ALIGN(num_bytes, root->sectorsize);
 
 	spin_lock(&BTRFS_I(inode)->lock);
-	nr_extents = (unsigned)div64_u64(num_bytes +
-					 BTRFS_MAX_EXTENT_SIZE - 1,
-					 BTRFS_MAX_EXTENT_SIZE);
+	nr_extents = (unsigned)div64_u64(num_bytes + max_extent_size - 1,
+					 max_extent_size);
 	BTRFS_I(inode)->outstanding_extents += nr_extents;
 
 	nr_extents = 0;
@@ -6011,7 +6022,7 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 
 out_fail:
 	spin_lock(&BTRFS_I(inode)->lock);
-	dropped = drop_outstanding_extent(inode, num_bytes);
+	dropped = drop_outstanding_extent(inode, num_bytes, reserve_type);
 	/*
 	 * If the inodes csum_bytes is the same as the original
 	 * csum_bytes then we know we haven't raced with any free()ers
@@ -6077,12 +6088,15 @@ out_fail:
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
-void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes)
+void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes,
+			enum btrfs_metadata_reserve_type reserve_type)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	u64 to_free = 0;
@@ -6090,7 +6104,7 @@ void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes)
 
 	num_bytes = ALIGN(num_bytes, root->sectorsize);
 	spin_lock(&BTRFS_I(inode)->lock);
-	dropped = drop_outstanding_extent(inode, num_bytes);
+	dropped = drop_outstanding_extent(inode, num_bytes, reserve_type);
 
 	if (num_bytes)
 		to_free = calc_csum_metadata_size(inode, num_bytes, 0);
@@ -6114,6 +6128,8 @@ void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes)
  * @inode: inode we're writing to
  * @start: start range we are writing to
  * @len: how long the range we are writing to
+ * @reserve_type: the type of write we're reserving for.
+ *		  determine the max extent size.
  *
  * This will do the following things
  *
@@ -6131,14 +6147,15 @@ void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes)
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
-	ret = btrfs_delalloc_reserve_metadata(inode, len);
+	ret = btrfs_delalloc_reserve_metadata(inode, len, reserve_type);
 	if (ret < 0)
 		btrfs_free_reserved_data_space(inode, start, len);
 	return ret;
@@ -6149,6 +6166,8 @@ int btrfs_delalloc_reserve_space(struct inode *inode, u64 start, u64 len)
  * @inode: inode we're releasing space for
  * @start: start position of the space already reserved
  * @len: the len of the space already reserved
+ * @reserve_type: the type of write we're releasing for
+ *		  must match the type passed to btrfs_delalloc_reserve_space()
  *
  * This must be matched with a call to btrfs_delalloc_reserve_space.  This is
  * called in the case that we don't need the metadata AND data reservations
@@ -6159,9 +6178,10 @@ int btrfs_delalloc_reserve_space(struct inode *inode, u64 start, u64 len)
  * list if there are no delalloc bytes left.
  * Also it will handle the qgroup reserved space.
  */
-void btrfs_delalloc_release_space(struct inode *inode, u64 start, u64 len)
+void btrfs_delalloc_release_space(struct inode *inode, u64 start, u64 len,
+			enum btrfs_metadata_reserve_type reserve_type)
 {
-	btrfs_delalloc_release_metadata(inode, len);
+	btrfs_delalloc_release_metadata(inode, len, reserve_type);
 	btrfs_free_reserved_data_space(inode, start, len);
 }
 
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 72a180d..f174381 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -488,7 +488,8 @@ static void btrfs_drop_pages(struct page **pages, size_t num_pages)
 int btrfs_dirty_pages(struct btrfs_root *root, struct inode *inode,
 			     struct page **pages, size_t num_pages,
 			     loff_t pos, size_t write_bytes,
-			     struct extent_state **cached)
+			     struct extent_state **cached,
+			     enum btrfs_metadata_reserve_type reserve_type)
 {
 	int err = 0;
 	int i;
@@ -503,7 +504,7 @@ int btrfs_dirty_pages(struct btrfs_root *root, struct inode *inode,
 
 	end_of_last_block = start_pos + num_bytes - 1;
 	err = btrfs_set_extent_delalloc(inode, start_pos, end_of_last_block,
-					cached, 0);
+					cached, reserve_type);
 	if (err)
 		return err;
 
@@ -1521,6 +1522,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 	bool only_release_metadata = false;
 	bool force_page_uptodate = false;
 	bool need_unlock;
+	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
 
 	nrptrs = min(DIV_ROUND_UP(iov_iter_count(i), PAGE_SIZE),
 			PAGE_SIZE / (sizeof(struct page *)));
@@ -1583,7 +1585,8 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 			}
 		}
 
-		ret = btrfs_delalloc_reserve_metadata(inode, reserve_bytes);
+		ret = btrfs_delalloc_reserve_metadata(inode, reserve_bytes,
+						      reserve_type);
 		if (ret) {
 			if (!only_release_metadata)
 				btrfs_free_reserved_data_space(inode, pos,
@@ -1666,14 +1669,16 @@ again:
 			}
 			if (only_release_metadata) {
 				btrfs_delalloc_release_metadata(inode,
-								release_bytes);
+								release_bytes,
+								reserve_type);
 			} else {
 				u64 __pos;
 
 				__pos = round_down(pos, root->sectorsize) +
 					(dirty_pages << PAGE_SHIFT);
 				btrfs_delalloc_release_space(inode, __pos,
-							     release_bytes);
+							     release_bytes,
+							     reserve_type);
 			}
 		}
 
@@ -1683,7 +1688,7 @@ again:
 		if (copied > 0)
 			ret = btrfs_dirty_pages(root, inode, pages,
 						dirty_pages, pos, copied,
-						NULL);
+						NULL, reserve_type);
 		if (need_unlock)
 			unlock_extent_cached(&BTRFS_I(inode)->io_tree,
 					     lockstart, lockend, &cached_state,
@@ -1724,11 +1729,12 @@ again:
 	if (release_bytes) {
 		if (only_release_metadata) {
 			btrfs_end_write_no_snapshoting(root);
-			btrfs_delalloc_release_metadata(inode, release_bytes);
+			btrfs_delalloc_release_metadata(inode, release_bytes,
+							reserve_type);
 		} else {
 			btrfs_delalloc_release_space(inode,
 						round_down(pos, root->sectorsize),
-						release_bytes);
+						release_bytes, reserve_type);
 		}
 	}
 
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index e4b48f3..1e433f7 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1297,7 +1297,8 @@ static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 
 	/* Everything is written out, now we dirty the pages in the file. */
 	ret = btrfs_dirty_pages(root, inode, io_ctl->pages, io_ctl->num_pages,
-				0, i_size_read(inode), &cached_state);
+				0, i_size_read(inode), &cached_state,
+				BTRFS_RESERVE_NORMAL);
 	if (ret)
 		goto out_nospc;
 
@@ -3536,7 +3537,8 @@ int btrfs_write_out_ino_cache(struct btrfs_root *root,
 
 	if (ret) {
 		if (release_metadata)
-			btrfs_delalloc_release_metadata(inode, inode->i_size);
+			btrfs_delalloc_release_metadata(inode, inode->i_size,
+							BTRFS_RESERVE_NORMAL);
 #ifdef DEBUG
 		btrfs_err(root->fs_info,
 			"failed to write free ino cache for root %llu",
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index d27014b..0335862 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -491,14 +491,16 @@ again:
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
-		btrfs_delalloc_release_metadata(inode, prealloc);
+		btrfs_delalloc_release_metadata(inode, prealloc,
+						BTRFS_RESERVE_NORMAL);
 		goto out_put;
 	}
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 25e0083..906ab27 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -315,7 +315,8 @@ static noinline int cow_file_range_inline(struct btrfs_root *root,
 	}
 
 	set_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &BTRFS_I(inode)->runtime_flags);
-	btrfs_delalloc_release_metadata(inode, end + 1 - start);
+	btrfs_delalloc_release_metadata(inode, end + 1 - start,
+					BTRFS_RESERVE_NORMAL);
 	btrfs_drop_extent_cache(inode, start, aligned_end - 1, 0);
 out:
 	/*
@@ -1596,6 +1597,8 @@ static void btrfs_split_extent_hook(struct inode *inode,
 				    struct extent_state *orig, u64 split)
 {
 	u64 size;
+	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
+	u64 max_extent_size;
 
 	/* not delalloc, ignore it */
 	if (!(orig->state & EXTENT_DELALLOC))
@@ -1604,8 +1607,10 @@ static void btrfs_split_extent_hook(struct inode *inode,
 	if (btrfs_is_free_space_inode(inode))
 		return;
 
+	max_extent_size = btrfs_max_extent_size(reserve_type);
+
 	size = orig->end - orig->start + 1;
-	if (size > BTRFS_MAX_EXTENT_SIZE) {
+	if (size > max_extent_size) {
 		u64 num_extents;
 		u64 new_size;
 
@@ -1614,13 +1619,13 @@ static void btrfs_split_extent_hook(struct inode *inode,
 		 * applies here, just in reverse.
 		 */
 		new_size = orig->end - split + 1;
-		num_extents = div64_u64(new_size + BTRFS_MAX_EXTENT_SIZE - 1,
-					BTRFS_MAX_EXTENT_SIZE);
+		num_extents = div64_u64(new_size + max_extent_size - 1,
+					max_extent_size);
 		new_size = split - orig->start;
-		num_extents += div64_u64(new_size + BTRFS_MAX_EXTENT_SIZE - 1,
-					BTRFS_MAX_EXTENT_SIZE);
-		if (div64_u64(size + BTRFS_MAX_EXTENT_SIZE - 1,
-			      BTRFS_MAX_EXTENT_SIZE) >= num_extents)
+		num_extents += div64_u64(new_size + max_extent_size - 1,
+					 max_extent_size);
+		if (div64_u64(size + max_extent_size - 1,
+			      max_extent_size) >= num_extents)
 			return;
 	}
 
@@ -1641,6 +1646,8 @@ static void btrfs_merge_extent_hook(struct inode *inode,
 {
 	u64 new_size, old_size;
 	u64 num_extents;
+	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
+	u64 max_extent_size;
 
 	/* not delalloc, ignore it */
 	if (!(other->state & EXTENT_DELALLOC))
@@ -1649,13 +1656,15 @@ static void btrfs_merge_extent_hook(struct inode *inode,
 	if (btrfs_is_free_space_inode(inode))
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
@@ -1681,14 +1690,14 @@ static void btrfs_merge_extent_hook(struct inode *inode,
 	 * this case.
 	 */
 	old_size = other->end - other->start + 1;
-	num_extents = div64_u64(old_size + BTRFS_MAX_EXTENT_SIZE - 1,
-				BTRFS_MAX_EXTENT_SIZE);
+	num_extents = div64_u64(old_size + max_extent_size - 1,
+				max_extent_size);
 	old_size = new->end - new->start + 1;
-	num_extents += div64_u64(old_size + BTRFS_MAX_EXTENT_SIZE - 1,
-				 BTRFS_MAX_EXTENT_SIZE);
+	num_extents += div64_u64(old_size + max_extent_size - 1,
+				 max_extent_size);
 
-	if (div64_u64(new_size + BTRFS_MAX_EXTENT_SIZE - 1,
-		      BTRFS_MAX_EXTENT_SIZE) >= num_extents)
+	if (div64_u64(new_size + max_extent_size - 1,
+		      max_extent_size) >= num_extents)
 		return;
 
 	spin_lock(&BTRFS_I(inode)->lock);
@@ -1754,10 +1763,16 @@ static void btrfs_set_bit_hook(struct inode *inode,
 	if (!(state->state & EXTENT_DELALLOC) && (*bits & EXTENT_DELALLOC)) {
 		struct btrfs_root *root = BTRFS_I(inode)->root;
 		u64 len = state->end + 1 - state->start;
-		u64 num_extents = div64_u64(len + BTRFS_MAX_EXTENT_SIZE - 1,
-					    BTRFS_MAX_EXTENT_SIZE);
+		enum btrfs_metadata_reserve_type reserve_type =
+					BTRFS_RESERVE_NORMAL;
+		u64 max_extent_size;
+		u64 num_extents;
 		bool do_list = !btrfs_is_free_space_inode(inode);
 
+		max_extent_size = btrfs_max_extent_size(reserve_type);
+		num_extents = div64_u64(len + max_extent_size - 1,
+					max_extent_size);
+
 		if (*bits & EXTENT_FIRST_DELALLOC)
 			*bits &= ~EXTENT_FIRST_DELALLOC;
 
@@ -1792,8 +1807,9 @@ static void btrfs_clear_bit_hook(struct inode *inode,
 				 unsigned *bits)
 {
 	u64 len = state->end + 1 - state->start;
-	u64 num_extents = div64_u64(len + BTRFS_MAX_EXTENT_SIZE -1,
-				    BTRFS_MAX_EXTENT_SIZE);
+	u64 max_extent_size;
+	u64 num_extents;
+	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
 
 	spin_lock(&BTRFS_I(inode)->lock);
 	if ((state->state & EXTENT_DEFRAG) && (*bits & EXTENT_DEFRAG))
@@ -1809,6 +1825,10 @@ static void btrfs_clear_bit_hook(struct inode *inode,
 		struct btrfs_root *root = BTRFS_I(inode)->root;
 		bool do_list = !btrfs_is_free_space_inode(inode);
 
+		max_extent_size = btrfs_max_extent_size(reserve_type);
+		num_extents = div64_u64(len + max_extent_size - 1,
+					max_extent_size);
+
 		if (*bits & EXTENT_FIRST_DELALLOC) {
 			*bits &= ~EXTENT_FIRST_DELALLOC;
 		} else if (!(*bits & EXTENT_DO_ACCOUNTING) && do_list) {
@@ -1824,7 +1844,8 @@ static void btrfs_clear_bit_hook(struct inode *inode,
 		 */
 		if (*bits & EXTENT_DO_ACCOUNTING &&
 		    root != root->fs_info->tree_root)
-			btrfs_delalloc_release_metadata(inode, len);
+			btrfs_delalloc_release_metadata(inode, len,
+							reserve_type);
 
 		/* For sanity tests. */
 		if (btrfs_is_testing(root->fs_info))
@@ -2007,11 +2028,13 @@ static noinline int add_pending_csums(struct btrfs_trans_handle *trans,
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
@@ -2038,11 +2061,13 @@ int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
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
@@ -2073,6 +2098,7 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 	u64 page_start;
 	u64 page_end;
 	int ret;
+	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
 
 	fixup = container_of(work, struct btrfs_writepage_fixup, work);
 	page = fixup->page;
@@ -2106,7 +2132,7 @@ again:
 	}
 
 	ret = btrfs_delalloc_reserve_space(inode, page_start,
-					   PAGE_SIZE);
+					   PAGE_SIZE, reserve_type);
 	if (ret) {
 		mapping_set_error(page->mapping, ret);
 		end_extent_writepage(page, ret, page_start, page_end);
@@ -2115,7 +2141,7 @@ again:
 	 }
 
 	btrfs_set_extent_delalloc(inode, page_start, page_end, &cached_state,
-				  0);
+				  reserve_type);
 	ClearPageChecked(page);
 	set_page_dirty(page);
 out:
@@ -2925,6 +2951,7 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 	u64 logical_len = ordered_extent->len;
 	bool nolock;
 	bool truncated = false;
+	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
 
 	nolock = btrfs_is_free_space_inode(inode);
 
@@ -3048,7 +3075,8 @@ out_unlock:
 			     ordered_extent->len - 1, &cached_state, GFP_NOFS);
 out:
 	if (root != root->fs_info->tree_root)
-		btrfs_delalloc_release_metadata(inode, ordered_extent->len);
+		btrfs_delalloc_release_metadata(inode, ordered_extent->len,
+						reserve_type);
 	if (trans)
 		btrfs_end_transaction(trans, root);
 
@@ -4762,13 +4790,14 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
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
 
@@ -4777,7 +4806,7 @@ again:
 	if (!page) {
 		btrfs_delalloc_release_space(inode,
 				round_down(from, blocksize),
-				blocksize);
+				blocksize, reserve_type);
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -4820,7 +4849,7 @@ again:
 			  0, 0, &cached_state, GFP_NOFS);
 
 	ret = btrfs_set_extent_delalloc(inode, block_start, block_end,
-					&cached_state, 0);
+					&cached_state, reserve_type);
 	if (ret) {
 		unlock_extent_cached(io_tree, block_start, block_end,
 				     &cached_state, GFP_NOFS);
@@ -4848,7 +4877,7 @@ again:
 out_unlock:
 	if (ret)
 		btrfs_delalloc_release_space(inode, block_start,
-					     blocksize);
+					     blocksize, reserve_type);
 	unlock_page(page);
 	put_page(page);
 out:
@@ -8743,7 +8772,8 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 			inode_unlock(inode);
 			relock = true;
 		}
-		ret = btrfs_delalloc_reserve_space(inode, offset, count);
+		ret = btrfs_delalloc_reserve_space(inode, offset, count,
+						   BTRFS_RESERVE_NORMAL);
 		if (ret)
 			goto out;
 		dio_data.outstanding_extents = div64_u64(count +
@@ -8775,7 +8805,7 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 		if (ret < 0 && ret != -EIOCBQUEUED) {
 			if (dio_data.reserve)
 				btrfs_delalloc_release_space(inode, offset,
-							     dio_data.reserve);
+					dio_data.reserve, BTRFS_RESERVE_NORMAL);
 			/*
 			 * On error we might have left some ordered extents
 			 * without submitting corresponding bios for them, so
@@ -8791,7 +8821,8 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 					0);
 		} else if (ret >= 0 && (size_t)ret < count)
 			btrfs_delalloc_release_space(inode, offset,
-						     count - (size_t)ret);
+						     count - (size_t)ret,
+						     BTRFS_RESERVE_NORMAL);
 	}
 out:
 	if (wakeup)
@@ -9030,6 +9061,7 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct btrfs_ordered_extent *ordered;
 	struct extent_state *cached_state = NULL;
+	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
 	char *kaddr;
 	unsigned long zero_start;
 	loff_t size;
@@ -9056,7 +9088,7 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	 * being processed by btrfs_page_mkwrite() function.
 	 */
 	ret = btrfs_delalloc_reserve_space(inode, page_start,
-					   reserved_space);
+					   reserved_space, reserve_type);
 	if (!ret) {
 		ret = file_update_time(vma->vm_file);
 		reserved = 1;
@@ -9108,7 +9140,8 @@ again:
 			BTRFS_I(inode)->outstanding_extents++;
 			spin_unlock(&BTRFS_I(inode)->lock);
 			btrfs_delalloc_release_space(inode, page_start,
-						PAGE_SIZE - reserved_space);
+						PAGE_SIZE - reserved_space,
+						reserve_type);
 		}
 	}
 
@@ -9125,7 +9158,7 @@ again:
 			  0, 0, &cached_state, GFP_NOFS);
 
 	ret = btrfs_set_extent_delalloc(inode, page_start, end,
-					&cached_state, 0);
+					&cached_state, reserve_type);
 	if (ret) {
 		unlock_extent_cached(io_tree, page_start, page_end,
 				     &cached_state, GFP_NOFS);
@@ -9163,7 +9196,8 @@ out_unlock:
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
index eff5eae..870737b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1131,6 +1131,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 	struct btrfs_ordered_extent *ordered;
 	struct extent_state *cached_state = NULL;
 	struct extent_io_tree *tree;
+	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
 	gfp_t mask = btrfs_alloc_write_mask(inode->i_mapping);
 
 	file_end = (isize - 1) >> PAGE_SHIFT;
@@ -1141,7 +1142,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 
 	ret = btrfs_delalloc_reserve_space(inode,
 			start_index << PAGE_SHIFT,
-			page_cnt << PAGE_SHIFT);
+			page_cnt << PAGE_SHIFT, reserve_type);
 	if (ret)
 		return ret;
 	i_done = 0;
@@ -1232,11 +1233,12 @@ again:
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
@@ -1257,7 +1259,7 @@ out:
 	}
 	btrfs_delalloc_release_space(inode,
 			start_index << PAGE_SHIFT,
-			page_cnt << PAGE_SHIFT);
+			page_cnt << PAGE_SHIFT, reserve_type);
 	return ret;
 
 }
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index c4af0cd..0e4b370 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3148,6 +3148,7 @@ static int relocate_file_extent_cluster(struct inode *inode,
 	unsigned long last_index;
 	struct page *page;
 	struct file_ra_state *ra;
+	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
 	gfp_t mask = btrfs_alloc_write_mask(inode->i_mapping);
 	int nr = 0;
 	int ret = 0;
@@ -3173,7 +3174,8 @@ static int relocate_file_extent_cluster(struct inode *inode,
 	index = (cluster->start - offset) >> PAGE_SHIFT;
 	last_index = (cluster->end - offset) >> PAGE_SHIFT;
 	while (index <= last_index) {
-		ret = btrfs_delalloc_reserve_metadata(inode, PAGE_SIZE);
+		ret = btrfs_delalloc_reserve_metadata(inode, PAGE_SIZE,
+						      reserve_type);
 		if (ret)
 			goto out;
 
@@ -3186,7 +3188,7 @@ static int relocate_file_extent_cluster(struct inode *inode,
 						   mask);
 			if (!page) {
 				btrfs_delalloc_release_metadata(inode,
-							PAGE_SIZE);
+						PAGE_SIZE, reserve_type);
 				ret = -ENOMEM;
 				goto out;
 			}
@@ -3205,7 +3207,7 @@ static int relocate_file_extent_cluster(struct inode *inode,
 				unlock_page(page);
 				put_page(page);
 				btrfs_delalloc_release_metadata(inode,
-							PAGE_SIZE);
+						PAGE_SIZE, reserve_type);
 				ret = -EIO;
 				goto out;
 			}
@@ -3226,7 +3228,8 @@ static int relocate_file_extent_cluster(struct inode *inode,
 			nr++;
 		}
 
-		btrfs_set_extent_delalloc(inode, page_start, page_end, NULL, 0);
+		btrfs_set_extent_delalloc(inode, page_start, page_end, NULL,
+					  reserve_type);
 		set_page_dirty(page);
 
 		unlock_extent(&BTRFS_I(inode)->io_tree,
diff --git a/fs/btrfs/tests/inode-tests.c b/fs/btrfs/tests/inode-tests.c
index 0bf4680..6edd44d 100644
--- a/fs/btrfs/tests/inode-tests.c
+++ b/fs/btrfs/tests/inode-tests.c
@@ -942,6 +942,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	struct btrfs_fs_info *fs_info = NULL;
 	struct inode *inode = NULL;
 	struct btrfs_root *root = NULL;
+	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
 	int ret = -ENOMEM;
 
 	inode = btrfs_new_test_inode();
@@ -968,7 +969,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	/* [BTRFS_MAX_EXTENT_SIZE] */
 	BTRFS_I(inode)->outstanding_extents++;
 	ret = btrfs_set_extent_delalloc(inode, 0, BTRFS_MAX_EXTENT_SIZE - 1,
-					NULL, 0);
+					NULL, reserve_type);
 	if (ret) {
 		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
 		goto out;
@@ -984,7 +985,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	BTRFS_I(inode)->outstanding_extents++;
 	ret = btrfs_set_extent_delalloc(inode, BTRFS_MAX_EXTENT_SIZE,
 					BTRFS_MAX_EXTENT_SIZE + sectorsize - 1,
-					NULL, 0);
+					NULL, reserve_type);
 	if (ret) {
 		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
 		goto out;
@@ -1019,7 +1020,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	ret = btrfs_set_extent_delalloc(inode, BTRFS_MAX_EXTENT_SIZE >> 1,
 					(BTRFS_MAX_EXTENT_SIZE >> 1)
 					+ sectorsize - 1,
-					NULL, 0);
+					NULL, reserve_type);
 	if (ret) {
 		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
 		goto out;
@@ -1042,7 +1043,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	ret = btrfs_set_extent_delalloc(inode,
 			BTRFS_MAX_EXTENT_SIZE + 2 * sectorsize,
 			(BTRFS_MAX_EXTENT_SIZE << 1) + 3 * sectorsize - 1,
-			NULL, 0);
+			NULL, reserve_type);
 	if (ret) {
 		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
 		goto out;
@@ -1060,7 +1061,8 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	BTRFS_I(inode)->outstanding_extents++;
 	ret = btrfs_set_extent_delalloc(inode,
 			BTRFS_MAX_EXTENT_SIZE + sectorsize,
-			BTRFS_MAX_EXTENT_SIZE + 2 * sectorsize - 1, NULL, 0);
+			BTRFS_MAX_EXTENT_SIZE + 2 * sectorsize - 1, NULL,
+			reserve_type);
 	if (ret) {
 		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
 		goto out;
@@ -1097,7 +1099,8 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
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
2.7.4



