From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: [PATCH/RFC] Btrfs: Add conditional ENOSPC debugging.
Date: Thu,  9 Feb 2012 15:38:41 -0600
Message-ID: <1328823521-8487-1-git-send-email-mitch.harder@sabayonlinux.org>
Mime-Version: 1.0
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch isn't intended for inclusion in the kernel, but is provided
to facilitate ENOSPC debugging in a framework that will have no
impact on Btrfs unless compiled conditionally.

Debugging printk statements are wrapped in #ifdef macros
to allow btrfs to be built in its original form unless debugging
is explicitly requested when the kernel is built.

The debugging can be enabled as follows:
KCFLAGS="-DBTRFS_DEBUG_ENOSPC" \
KCPPFLAGS="-DBTRFS_DEBUG_ENOSPC" \
make

The patch was constructed by searching the Btrfs code for "ENOSPC",
and inserting printk statements as appropriate if the occurance
was a generation point for an ENOSPC.

I initially developed this patch to track down where ENOSPC errors were being
generated when using zlib compression.

This patch will occasionally generate some false positives, since ENOSPC
conditions are sometimes corrected before returning an error to the caller.

It is also interesting for highlighting all the places in Btrfs where an
ENOSPC can be generated.

Signed-off-by: Mitch Harder <mitch.harder@sabayonlinux.org>
---
 fs/btrfs/delayed-inode.c    |   10 ++++
 fs/btrfs/extent-tree.c      |   84 +++++++++++++++++++++++++++++++++
 fs/btrfs/free-space-cache.c |  109 +++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/inode-map.c        |   17 +++++++
 fs/btrfs/inode.c            |   53 +++++++++++++++++++++
 fs/btrfs/volumes.c          |   58 +++++++++++++++++++++++
 fs/btrfs/xattr.c            |   10 ++++
 7 files changed, 341 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index fe4cd0f..31b717f 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -656,8 +656,18 @@ static int btrfs_delayed_inode_reserve_metadata(
 		 * EAGAIN to make us stop the transaction we have, so return
 		 * ENOSPC instead so that btrfs_dirty_inode knows what to do.
 		 */
+#ifdef BTRFS_DEBUG_ENOSPC
+		if (unlikely(ret == -EAGAIN)) {
+			ret = -ENOSPC;
+			if (printk_ratelimit())
+				printk(KERN_WARNING
+				       "btrfs: ENOSPC set in "
+				       "btrfs_delayed_inode_reserve_metadata\n");
+		}
+#else
 		if (ret == -EAGAIN)
 			ret = -ENOSPC;
+#endif
 		if (!ret) {
 			node->bytes_reserved = num_bytes;
 			trace_btrfs_space_reservation(root->fs_info,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 283af7a..aeb1b4f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3308,6 +3308,12 @@ commit_trans:
 			goto again;
 		}
 
+#ifdef BTRFS_DEBUG_ENOSPC
+		if (printk_ratelimit())
+			printk(KERN_WARNING
+			       "btrfs: ENOSPC returned from "
+			       "btrfs_check_data_free_space\n");
+#endif
 		return -ENOSPC;
 	}
 	data_sinfo->bytes_may_use += bytes;
@@ -3608,20 +3614,46 @@ static int may_commit_transaction(struct btrfs_root *root,
 	 * See if there is some space in the delayed insertion reservation for
 	 * this reservation.
 	 */
+#ifdef BTRFS_DEBUG_ENOSPC
+	if (unlikely(space_info != delayed_rsv->space_info)) {
+		if (printk_ratelimit())
+			printk(KERN_WARNING
+			       "btrfs: ENOSPC returned from "
+			       "may_commit_transaction(1)\n");
+		return -ENOSPC;
+	}
+#else
 	if (space_info != delayed_rsv->space_info)
 		return -ENOSPC;
+#endif
 
 	spin_lock(&delayed_rsv->lock);
 	if (delayed_rsv->size < bytes) {
 		spin_unlock(&delayed_rsv->lock);
+#ifdef BTRFS_DEBUG_ENOSPC
+		if (printk_ratelimit())
+			printk(KERN_WARNING
+			       "btrfs: ENOSPC returned from "
+			       "may_commit_transaction(2)\n");
+#endif
 		return -ENOSPC;
 	}
 	spin_unlock(&delayed_rsv->lock);
 
 commit:
 	trans = btrfs_join_transaction(root);
+#ifdef BTRFS_DEBUG_ENOSPC
+	if (unlikely(IS_ERR(trans))) {
+		if (printk_ratelimit())
+			printk(KERN_WARNING
+			       "btrfs: ENOSPC returned from "
+			       "may_commit_transaction(3)\n");
+		return -ENOSPC;
+	}
+#else
 	if (IS_ERR(trans))
 		return -ENOSPC;
+#endif
 
 	return btrfs_commit_transaction(trans, root);
 }
@@ -3828,6 +3860,13 @@ out:
 		wake_up_all(&space_info->wait);
 		spin_unlock(&space_info->lock);
 	}
+#ifdef BTRFS_DEBUG_ENOSPC
+	if (unlikely(ret == -ENOSPC))
+		if (printk_ratelimit())
+			printk(KERN_WARNING
+			       "btrfs: ENOSPC returned from "
+			       "reserve_metadata_bytes\n");
+#endif
 	return ret;
 }
 
@@ -3860,6 +3899,13 @@ static int block_rsv_use_bytes(struct btrfs_block_rsv *block_rsv,
 		ret = 0;
 	}
 	spin_unlock(&block_rsv->lock);
+#ifdef BTRFS_DEBUG_ENOSPC
+	if (unlikely(ret == -ENOSPC))
+		if (printk_ratelimit())
+			printk(KERN_WARNING
+			       "btrfs: ENOSPC returned from "
+			       "block_rsv_use_bytes\n");
+#endif
 	return ret;
 }
 
@@ -4009,6 +4055,13 @@ int btrfs_block_rsv_check(struct btrfs_root *root,
 		ret = 0;
 	spin_unlock(&block_rsv->lock);
 
+#ifdef BTRFS_DEBUG_ENOSPC
+	if (unlikely(ret == -ENOSPC))
+		if (printk_ratelimit())
+			printk(KERN_WARNING
+			       "btrfs: ENOSPC returned from "
+			       "btrfs_block_rsv_check\n");
+#endif
 	return ret;
 }
 
@@ -4039,6 +4092,13 @@ static inline int __btrfs_block_rsv_refill(struct btrfs_root *root,
 		return 0;
 	}
 
+#ifdef BTRFS_DEBUG_ENOSPC
+	if (unlikely(ret == -ENOSPC))
+		if (printk_ratelimit())
+			printk(KERN_WARNING
+			       "btrfs: ENOSPC returned from "
+			       "__btrfs_block_rsv_refill\n");
+#endif
 	return ret;
 }
 
@@ -5306,7 +5366,12 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 
 	space_info = __find_space_info(root->fs_info, data);
 	if (!space_info) {
+#ifdef BTRFS_DEBUG_ENOSPC
+		printk(KERN_ERR "No space info for %llu "
+				"(ENOSPC in find_free_extent)\n", data);
+#else
 		printk(KERN_ERR "No space info for %llu\n", data);
+#endif
 		return -ENOSPC;
 	}
 
@@ -5735,6 +5800,12 @@ loop:
 
 		goto search;
 	} else if (!ins->objectid) {
+#ifdef BTRFS_DEBUG_ENOSPC
+		if (printk_ratelimit())
+			printk(KERN_WARNING
+			       "btrfs: ENOSPC returned in "
+			       "find_free_extent\n");
+#endif
 		ret = -ENOSPC;
 	} else if (ins->objectid) {
 		ret = 0;
@@ -6173,6 +6244,12 @@ use_block_rsv(struct btrfs_trans_handle *trans,
 		}
 	}
 
+#ifdef BTRFS_DEBUG_ENOSPC
+	if (printk_ratelimit())
+		printk(KERN_WARNING
+		       "btrfs: ENOSPC returned in "
+		       "use_block_rsv\n");
+#endif
 	return ERR_PTR(-ENOSPC);
 }
 
@@ -7083,6 +7160,13 @@ static int set_block_group_ro(struct btrfs_block_group_cache *cache, int force)
 out:
 	spin_unlock(&cache->lock);
 	spin_unlock(&sinfo->lock);
+#ifdef BTRFS_DEBUG_ENOSPC
+	if (unlikely(ret == -ENOSPC))
+		if (printk_ratelimit())
+			printk(KERN_WARNING
+			       "btrfs: ENOSPC returned from "
+			       "set_block_group_ro\n");
+#endif
 	return ret;
 }
 
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 5802b147..b3fea25 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -210,11 +210,23 @@ int btrfs_truncate_free_space_cache(struct btrfs_root *root,
 		btrfs_calc_trans_metadata_size(root, 1);
 
 	spin_lock(&trans->block_rsv->lock);
+#ifdef BTRFS_DEBUG_ENOSPC
+	if (unlikely(trans->block_rsv->reserved < needed_bytes)) {
+		spin_unlock(&trans->block_rsv->lock);
+		trans->block_rsv = rsv;
+		if (printk_ratelimit())
+			printk(KERN_WARNING
+			       "btrfs: ENOSPC returned from "
+			       "btrfs_truncate_free_space_cache\n");
+		return -ENOSPC;
+	}
+#else
 	if (trans->block_rsv->reserved < needed_bytes) {
 		spin_unlock(&trans->block_rsv->lock);
 		trans->block_rsv = rsv;
 		return -ENOSPC;
 	}
+#endif
 	spin_unlock(&trans->block_rsv->lock);
 
 	oldsize = i_size_read(inode);
@@ -475,8 +487,18 @@ static int io_ctl_add_entry(struct io_ctl *io_ctl, u64 offset, u64 bytes,
 {
 	struct btrfs_free_space_entry *entry;
 
+#ifdef BTRFS_DEBUG_ENOSPC
+	if (unlikely(!io_ctl->cur)) {
+		if (printk_ratelimit())
+			printk(KERN_WARNING
+			       "btrfs: ENOSPC returned from "
+			       "io_ctl_add_entry\n");
+		return -ENOSPC;
+	}
+#else
 	if (!io_ctl->cur)
 		return -ENOSPC;
+#endif
 
 	entry = io_ctl->cur;
 	entry->offset = cpu_to_le64(offset);
@@ -502,8 +524,18 @@ static int io_ctl_add_entry(struct io_ctl *io_ctl, u64 offset, u64 bytes,
 
 static int io_ctl_add_bitmap(struct io_ctl *io_ctl, void *bitmap)
 {
+#ifdef BTRFS_DEBUG_ENOSPC
+	if (unlikely(!io_ctl->cur)) {
+		if (printk_ratelimit())
+			printk(KERN_WARNING
+			       "btrfs: ENOSPC returned from "
+			       "io_ctl_add_bitmap(1)\n");
+		return -ENOSPC;
+	}
+#else
 	if (!io_ctl->cur)
 		return -ENOSPC;
+#endif
 
 	/*
 	 * If we aren't at the start of the current page, unmap this one and
@@ -511,8 +543,18 @@ static int io_ctl_add_bitmap(struct io_ctl *io_ctl, void *bitmap)
 	 */
 	if (io_ctl->cur != io_ctl->orig) {
 		io_ctl_set_crc(io_ctl, io_ctl->index - 1);
+#ifdef BTRFS_DEBUG_ENOSPC
+		if (unlikely(io_ctl->index >= io_ctl->num_pages)) {
+			if (printk_ratelimit())
+				printk(KERN_WARNING
+				       "btrfs: ENOSPC returned from "
+				       "io_ctl_add_bitmap(2)\n");
+			return -ENOSPC;
+		}
+#else
 		if (io_ctl->index >= io_ctl->num_pages)
 			return -ENOSPC;
+#endif
 		io_ctl_map_page(io_ctl, 0);
 	}
 
@@ -2322,8 +2364,18 @@ again:
 		i = next_zero;
 	}
 
+#ifdef BTRFS_DEBUG_ENOSPC
+	if (unlikely(!found_bits)) {
+		if (printk_ratelimit())
+			printk(KERN_WARNING
+			       "btrfs: ENOSPC set in "
+			       "btrfs_bitmap_cluster\n");
+		return -ENOSPC;
+	}
+#else
 	if (!found_bits)
 		return -ENOSPC;
+#endif
 
 	if (!total_found) {
 		start = i;
@@ -2374,8 +2426,18 @@ setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 	u64 total_size = 0;
 
 	entry = tree_search_offset(ctl, offset, 0, 1);
+#ifdef BTRFS_DEBUG_ENOSPC
+	if (unlikely(!entry)) {
+		if (printk_ratelimit())
+			printk(KERN_WARNING
+			       "btrfs: ENOSPC Returned in "
+			       "setup_cluster_no_bitmap(1)\n");
+		return -ENOSPC;
+	}
+#else
 	if (!entry)
 		return -ENOSPC;
+#endif
 
 	/*
 	 * We don't want bitmaps, so just move along until we find a normal
@@ -2385,8 +2447,18 @@ setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 		if (entry->bitmap && list_empty(&entry->list))
 			list_add_tail(&entry->list, bitmaps);
 		node = rb_next(&entry->offset_index);
+#ifdef BTRFS_DEBUG_ENOSPC
+		if (unlikely(!node)) {
+			if (printk_ratelimit())
+				printk(KERN_WARNING
+				       "btrfs: ENOSPC Returned in "
+				       "setup_cluster_no_bitmap(2)\n");
+			return -ENOSPC;
+		}
+#else
 		if (!node)
 			return -ENOSPC;
+#endif
 		entry = rb_entry(node, struct btrfs_free_space, offset_index);
 	}
 
@@ -2415,8 +2487,18 @@ setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
 			max_extent = entry->bytes;
 	}
 
+#ifdef BTRFS_DEBUG_ENOSPC
+	if (unlikely(window_free < bytes || max_extent < cont1_bytes)) {
+		if (printk_ratelimit())
+			printk(KERN_WARNING
+			       "btrfs: ENOSPC Returned in "
+			       "setup_cluster_no_bitmap(3)\n");
+		return -ENOSPC;
+	}
+#else
 	if (window_free < bytes || max_extent < cont1_bytes)
 		return -ENOSPC;
+#endif
 
 	cluster->window_start = first->offset;
 
@@ -2461,8 +2543,18 @@ setup_cluster_bitmap(struct btrfs_block_group_cache *block_group,
 	int ret = -ENOSPC;
 	u64 bitmap_offset = offset_to_bitmap(ctl, offset);
 
+#ifdef BTRFS_DEBUG_ENOSPC
+	if (unlikely(ctl->total_bitmaps == 0)) {
+		if (printk_ratelimit())
+			printk(KERN_WARNING
+			       "btrfs: ENOSPC returned from "
+			       "setup_cluster_bitmap(1)\n");
+		return -ENOSPC;
+	}
+#else
 	if (ctl->total_bitmaps == 0)
 		return -ENOSPC;
+#endif
 
 	/*
 	 * The bitmap that covers offset won't be in the list unless offset
@@ -2488,6 +2580,12 @@ setup_cluster_bitmap(struct btrfs_block_group_cache *block_group,
 	 * The bitmaps list has all the bitmaps that record free space
 	 * starting after offset, so no more search is required.
 	 */
+#ifdef BTRFS_DEBUG_ENOSPC
+	if (printk_ratelimit())
+		printk(KERN_WARNING
+		       "btrfs: ENOSPC returned from "
+		       "setup_cluster_bitmap(2)\n");
+#endif
 	return -ENOSPC;
 }
 
@@ -2534,10 +2632,21 @@ int btrfs_find_space_cluster(struct btrfs_trans_handle *trans,
 	 * If we know we don't have enough space to make a cluster don't even
 	 * bother doing all the work to try and find one.
 	 */
+#ifdef BTRFS_DEBUG_ENOSPC
+	if (unlikely(ctl->free_space < bytes)) {
+		spin_unlock(&ctl->tree_lock);
+		if (printk_ratelimit())
+			printk(KERN_WARNING
+			       "btrfs: ENOSPC returned from "
+			       "btrfs_find_space_cluster\n");
+		return -ENOSPC;
+	}
+#else
 	if (ctl->free_space < bytes) {
 		spin_unlock(&ctl->tree_lock);
 		return -ENOSPC;
 	}
+#endif
 
 	spin_lock(&cluster->lock);
 
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index 213ffa8..34007da 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -198,9 +198,20 @@ again:
 		   root->cached == BTRFS_CACHE_FINISHED ||
 		   root->free_ino_ctl->free_space > 0);
 
+#ifdef BTRFS_DEBUG_ENOSPC
+	if (unlikely(root->cached == BTRFS_CACHE_FINISHED &&
+		     root->free_ino_ctl->free_space == 0)) {
+		if (printk_ratelimit())
+			printk(KERN_WARNING
+			       "btrfs: ENOSPC returned from "
+			       "btrfs_find_free_ino\n");
+		return -ENOSPC;
+	}
+#else
 	if (root->cached == BTRFS_CACHE_FINISHED &&
 	    root->free_ino_ctl->free_space == 0)
 		return -ENOSPC;
+#endif
 	else
 		goto again;
 }
@@ -559,6 +570,12 @@ int btrfs_find_free_objectid(struct btrfs_root *root, u64 *objectid)
 	}
 
 	if (unlikely(root->highest_objectid >= BTRFS_LAST_FREE_OBJECTID)) {
+#ifdef BTRFS_DEBUG_ENOSPC
+		if (printk_ratelimit())
+			printk(KERN_WARNING
+			       "btrfs: ENOSPC set in "
+			       "btrfs_find_free_objectid\n");
+#endif
 		ret = -ENOSPC;
 		goto out;
 	}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d8e4a6d..005e87a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2702,18 +2702,59 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir,
 	if (!IS_ERR(trans) || PTR_ERR(trans) != -ENOSPC)
 		return trans;
 
+#ifdef BTRFS_DEBUG_ENOSPC
+	if (unlikely(ino == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)) {
+		if (printk_ratelimit())
+			printk(KERN_WARNING
+			       "btrfs: ENOSPC returned from "
+			       "__unlink_start_trans(1)\n");
+		return ERR_PTR(-ENOSPC);
+	}
+#else
 	if (ino == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)
 		return ERR_PTR(-ENOSPC);
+#endif
 
 	/* check if there is someone else holds reference */
+#ifdef BTRFS_DEBUG_ENOSPC
+	if (unlikely(S_ISDIR(inode->i_mode)
+		     && atomic_read(&inode->i_count) > 1)) {
+		if (printk_ratelimit())
+			printk(KERN_WARNING
+			       "btrfs: ENOSPC returned from "
+			       "__unlink_start_trans(2)\n");
+		return ERR_PTR(-ENOSPC);
+	}
+#else
 	if (S_ISDIR(inode->i_mode) && atomic_read(&inode->i_count) > 1)
 		return ERR_PTR(-ENOSPC);
+#endif
 
+#ifdef BTRFS_DEBUG_ENOSPC
+	if (unlikely(atomic_read(&inode->i_count) > 2)) {
+		if (printk_ratelimit())
+			printk(KERN_WARNING
+			       "btrfs: ENOSPC returned from "
+			       "__unlink_start_trans(3)\n");
+		return ERR_PTR(-ENOSPC);
+	}
+#else
 	if (atomic_read(&inode->i_count) > 2)
 		return ERR_PTR(-ENOSPC);
+#endif
 
+#ifdef BTRFS_DEBUG_ENOSPC
+	if (unlikely(xchg(&root->fs_info->enospc_unlink, 1))) {
+		if (printk_ratelimit())
+			printk(KERN_WARNING
+			       "btrfs: ENOSPC returned from "
+			       "__unlink_start_trans(4)\n");
+		return ERR_PTR(-ENOSPC);
+	}
+#else
 	if (xchg(&root->fs_info->enospc_unlink, 1))
 		return ERR_PTR(-ENOSPC);
+#endif
 
 	path = btrfs_alloc_path();
 	if (!path) {
@@ -2833,11 +2874,23 @@ out:
 				&root->fs_info->global_block_rsv,
 				trans->bytes_reserved);
 
+#ifdef BTRFS_DEBUG_ENOSPC
+	if (unlikely(err)) {
+		btrfs_end_transaction(trans, root);
+		root->fs_info->enospc_unlink = 0;
+		if ((err == -ENOSPC) && (printk_ratelimit()))
+			printk(KERN_WARNING
+			       "btrfs: ENOSPC returned from "
+			       "__unlink_start_trans(5)\n");
+		return ERR_PTR(err);
+	}
+#else
 	if (err) {
 		btrfs_end_transaction(trans, root);
 		root->fs_info->enospc_unlink = 0;
 		return ERR_PTR(err);
 	}
+#endif
 
 	trans->block_rsv = &root->fs_info->global_block_rsv;
 	return trans;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9c4b8ed..23f7911 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -983,6 +983,13 @@ error:
 	*start = max_hole_start;
 	if (len)
 		*len = max_hole_size;
+#ifdef BTRFS_DEBUG_ENOSPC
+	if (ret == -ENOSPC)
+		if (printk_ratelimit())
+			printk(KERN_WARNING
+			       "btrfs: ENOSPC set in "
+			       "find_free_dev_extent\n");
+#endif
 	return ret;
 }
 
@@ -1933,8 +1940,18 @@ static int btrfs_relocate_chunk(struct btrfs_root *root,
 	em_tree = &root->fs_info->mapping_tree.map_tree;
 
 	ret = btrfs_can_relocate(extent_root, chunk_offset);
+#ifdef BTRFS_DEBUG_ENOSPC
+	if (unlikely(ret)) {
+		if (printk_ratelimit())
+			printk(KERN_WARNING
+			       "btrfs: ENOSPC returned from "
+			       "btrfs_relocate_chunk\n");
+		return -ENOSPC;
+	}
+#else
 	if (ret)
 		return -ENOSPC;
+#endif
 
 	/* step one, relocate all the extents inside this chunk */
 	ret = btrfs_relocate_block_group(extent_root, chunk_offset);
@@ -2069,6 +2086,13 @@ again:
 	}
 error:
 	btrfs_free_path(path);
+#ifdef BTRFS_DEBUG_ENOSPC
+	if (ret == -ENOSPC)
+		if (printk_ratelimit())
+			printk(KERN_WARNING
+			       "btrfs: ENOSPC returned from "
+			       "btrfs_relocate_sys_chunks\n");
+#endif
 	return ret;
 }
 
@@ -2581,8 +2605,18 @@ error:
 	if (enospc_errors) {
 		printk(KERN_INFO "btrfs: %d enospc errors during balance\n",
 		       enospc_errors);
+#ifdef BTRFS_DEBUG_ENOSPC
+		if (!ret) {
+			if (printk_ratelimit())
+				printk(KERN_WARNING
+				       "btrfs: ENOSPC returned from "
+				       "__btrfs_balance\n");
+			ret = -ENOSPC;
+		}
+#else
 		if (!ret)
 			ret = -ENOSPC;
+#endif
 	}
 
 	return ret;
@@ -3039,6 +3073,13 @@ again:
 	btrfs_end_transaction(trans, root);
 done:
 	btrfs_free_path(path);
+#ifdef BTRFS_DEBUG_ENOSPC
+	if (unlikely(ret == -ENOSPC))
+		if (printk_ratelimit())
+			printk(KERN_WARNING
+			       "btrfs: ENOSPC returned from "
+			       "btrfs_shrink_device\n");
+#endif
 	return ret;
 }
 
@@ -3125,8 +3166,18 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		type &= ~BTRFS_BLOCK_GROUP_DUP;
 	}
 
+#ifdef BTRFS_DEBUG_ENOSPC
+	if (unlikely(list_empty(&fs_devices->alloc_list))) {
+		return -ENOSPC;
+		if (printk_ratelimit())
+			printk(KERN_WARNING
+			       "btrfs: ENOSPC returned from "
+			       "__btrfs_alloc_chunk(1)\n");
+	}
+#else
 	if (list_empty(&fs_devices->alloc_list))
 		return -ENOSPC;
+#endif
 
 	sub_stripes = 1;
 	dev_stripes = 1;
@@ -3347,6 +3398,13 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 error:
 	kfree(map);
 	kfree(devices_info);
+#ifdef BTRFS_DEBUG_ENOSPC
+	if (ret == -ENOSPC)
+		if (printk_ratelimit())
+			printk(KERN_WARNING
+			       "btrfs: ENOSPC returned from "
+			       "__btrfs_alloc_chunk(2)\n");
+#endif
 	return ret;
 }
 
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index e7a5659..a880f87 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -95,8 +95,18 @@ static int do_setxattr(struct btrfs_trans_handle *trans,
 	size_t name_len = strlen(name);
 	int ret = 0;
 
+#ifdef BTRFS_DEBUG_ENOSPC
+	if (unlikely(name_len + size > BTRFS_MAX_XATTR_SIZE(root))) {
+		if (printk_ratelimit())
+			printk(KERN_WARNING
+			       "btrfs: ENOSPC returned from "
+			       "do_setxattr\n");
+		return -ENOSPC;
+	}
+#else
 	if (name_len + size > BTRFS_MAX_XATTR_SIZE(root))
 		return -ENOSPC;
+#endif
 
 	path = btrfs_alloc_path();
 	if (!path)
-- 
1.7.3.4

