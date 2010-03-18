From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix ENOSPC accounting when max_extent is not maxed
	out V2
Date: Thu, 18 Mar 2010 11:47:31 -0400
Message-ID: <20100318154730.GA20818@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

A user reported a bug a few weeks back where if he set max_extent=1m and then
did a dd and then stopped it, we would panic.  This is because I miscalculated
how many extents would be needed for splits/merges.  Turns out I didn't actually
take max_extent into account properly, since we only ever add 1 extent for a
write, which isn't quite right for the case that say max_extent is 4k and we do
8k writes.  That would result in more than 1 extent.  So this patch makes us
properly figure out how many extents are needed for the amount of data that is
being written, and deals with splitting and merging better.  I've tested this ad
nauseum and it works well.  This version doesn't depend on my per-cpu stuff.
Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.h        |    8 ++++
 fs/btrfs/extent-tree.c  |    4 +-
 fs/btrfs/file.c         |    5 +-
 fs/btrfs/inode.c        |   95 +++++++++++++++++++++++++++++++---------------
 fs/btrfs/ordered-data.c |    6 ++-
 5 files changed, 81 insertions(+), 37 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 1111584..7d478b4 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1960,6 +1960,14 @@ static inline struct dentry *fdentry(struct file *file)
 	return file->f_path.dentry;
 }
 
+static inline int calculate_extents(struct btrfs_root *root, u64 bytes)
+{
+	if (bytes <= root->fs_info->max_extent)
+		return 1;
+	return (int)div64_u64(bytes + root->fs_info->max_extent -1,
+			      root->fs_info->max_extent);
+}
+
 /* extent-tree.c */
 void btrfs_put_block_group(struct btrfs_block_group_cache *cache);
 int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 826120f..7bb97de 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2848,7 +2848,7 @@ int btrfs_unreserve_metadata_for_delalloc(struct btrfs_root *root,
 	}
 	spin_unlock(&BTRFS_I(inode)->accounting_lock);
 
-	BTRFS_I(inode)->reserved_extents--;
+	BTRFS_I(inode)->reserved_extents -= num_items;
 	BUG_ON(BTRFS_I(inode)->reserved_extents < 0);
 
 	if (meta_sinfo->bytes_delalloc < num_bytes) {
@@ -3110,7 +3110,7 @@ again:
 		return -ENOSPC;
 	}
 
-	BTRFS_I(inode)->reserved_extents++;
+	BTRFS_I(inode)->reserved_extents += num_items;
 	check_force_delalloc(meta_sinfo);
 	spin_unlock(&meta_sinfo->lock);
 
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index d146dde..a457a94 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -838,6 +838,7 @@ static ssize_t btrfs_file_write(struct file *file, const char __user *buf,
 	unsigned long first_index;
 	unsigned long last_index;
 	int will_write;
+	int reserved = calculate_extents(root, count);
 
 	will_write = ((file->f_flags & O_SYNC) || IS_SYNC(inode) ||
 		      (file->f_flags & O_DIRECT));
@@ -855,7 +856,7 @@ static ssize_t btrfs_file_write(struct file *file, const char __user *buf,
 	/* do the reserve before the mutex lock in case we have to do some
 	 * flushing.  We wouldn't deadlock, but this is more polite.
 	 */
-	err = btrfs_reserve_metadata_for_delalloc(root, inode, 1);
+	err = btrfs_reserve_metadata_for_delalloc(root, inode, reserved);
 	if (err)
 		goto out_nolock;
 
@@ -975,7 +976,7 @@ out:
 	mutex_unlock(&inode->i_mutex);
 	if (ret)
 		err = ret;
-	btrfs_unreserve_metadata_for_delalloc(root, inode, 1);
+	btrfs_unreserve_metadata_for_delalloc(root, inode, reserved);
 
 out_nolock:
 	kfree(pages);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2a337a0..52cb47f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1235,19 +1235,37 @@ static int btrfs_split_extent_hook(struct inode *inode,
 
 	size = orig->end - orig->start + 1;
 	if (size > root->fs_info->max_extent) {
-		u64 num_extents;
-		u64 new_size;
+		u64 left_extents, right_extents;
+		u64 orig_extents;
+		u64 left_size, right_size;
 
-		new_size = orig->end - split + 1;
-		num_extents = div64_u64(size + root->fs_info->max_extent - 1,
-					root->fs_info->max_extent);
+		left_size = orig->end - split + 1;
+		right_size = split - orig->start;
+		left_extents = calculate_extents(root, left_size);
+		right_extents = calculate_extents(root, right_size);
+		orig_extents = calculate_extents(root, size);
 
 		/*
-		 * if we break a large extent up then leave oustanding_extents
-		 * be, since we've already accounted for the large extent.
+		 * If we are splitting off a max_extent multiple of space, then
+		 * we don't need to account for another extent.  However if we
+		 * take off less than a max_extent, we need to add another
+		 * outstanding_extent, because we will likely still have the
+		 * original amount of extents needed for the big chunk left
+		 * over.
+		 *
+		 * Think of it this way.  We have 4 outstanding extents for the
+		 * original giant chunk of data.  If we split off a max_extent
+		 * sized chunk, then the remaining chunk has 3 outstanding
+		 * extens, and the new little chunk has 1 outstanding extents
+		 * worth, so we're even.
+		 *
+		 * But if we carve off < max_extent, thats its own extent still.
+		 * So the left over chunk still needs 4 extents to describe it
+		 * on disk, and the chunk we just split off needs 1 extent, so
+		 * thats 5 total extents, so we need to add 1 to
+		 * outstanding_extents.
 		 */
-		if (div64_u64(new_size + root->fs_info->max_extent - 1,
-			      root->fs_info->max_extent) < num_extents)
+		if (left_extents + right_extents == orig_extents)
 			return 0;
 	}
 
@@ -1269,18 +1287,16 @@ static int btrfs_merge_extent_hook(struct inode *inode,
 				   struct extent_state *other)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	u64 new_size, old_size;
-	u64 num_extents;
+	u64 new_size, size1, size2;
+	u64 extents1, extents2;
 
 	/* not delalloc, ignore it */
 	if (!(other->state & EXTENT_DELALLOC))
 		return 0;
 
-	old_size = other->end - other->start + 1;
-	if (new->start < other->start)
-		new_size = other->end - new->start + 1;
-	else
-		new_size = new->end - other->start + 1;
+	size1 = other->end - other->start + 1;
+	size2 = new->end - new->start + 1;
+	new_size = size1 + size2;
 
 	/* we're not bigger than the max, unreserve the space and go */
 	if (new_size <= root->fs_info->max_extent) {
@@ -1290,14 +1306,20 @@ static int btrfs_merge_extent_hook(struct inode *inode,
 		return 0;
 	}
 
+	extents1 = calculate_extents(root, size1);
+	extents2 = calculate_extents(root, size2);
+
 	/*
-	 * If we grew by another max_extent, just return, we want to keep that
-	 * reserved amount.
+	 * So if the number of extents required for the two chunks of space we
+	 * are merging equals the number of extents we need for the entire space
+	 * we now have, just return.
+	 *
+	 * The idea here is if max extent is say 1M, and the first chunk was
+	 * exactly 1M and the second chunk was 4k, we now need 2 extents to
+	 * cover that area, so we keep the reservation we got from adding the 4k
+	 * extent.
 	 */
-	num_extents = div64_u64(old_size + root->fs_info->max_extent - 1,
-				root->fs_info->max_extent);
-	if (div64_u64(new_size + root->fs_info->max_extent - 1,
-		      root->fs_info->max_extent) > num_extents)
+	if (calculate_extents(root, new_size) == extents1 + extents2)
 		return 0;
 
 	spin_lock(&BTRFS_I(inode)->accounting_lock);
@@ -1323,11 +1345,13 @@ static int btrfs_set_bit_hook(struct inode *inode, u64 start, u64 end,
 	 */
 	if (!(old & EXTENT_DELALLOC) && (bits & EXTENT_DELALLOC)) {
 		struct btrfs_root *root = BTRFS_I(inode)->root;
+		int extents = calculate_extents(root, end - start + 1);
 
 		spin_lock(&BTRFS_I(inode)->accounting_lock);
-		BTRFS_I(inode)->outstanding_extents++;
+		BTRFS_I(inode)->outstanding_extents += extents;
 		spin_unlock(&BTRFS_I(inode)->accounting_lock);
 		btrfs_delalloc_reserve_space(root, inode, end - start + 1);
+
 		spin_lock(&root->fs_info->delalloc_lock);
 		BTRFS_I(inode)->delalloc_bytes += end - start + 1;
 		root->fs_info->delalloc_bytes += end - start + 1;
@@ -1355,10 +1379,15 @@ static int btrfs_clear_bit_hook(struct inode *inode,
 		struct btrfs_root *root = BTRFS_I(inode)->root;
 
 		if (bits & EXTENT_DO_ACCOUNTING) {
+			int extents = calculate_extents(root, state->end -
+							state->start + 1);
+
 			spin_lock(&BTRFS_I(inode)->accounting_lock);
-			BTRFS_I(inode)->outstanding_extents--;
+			WARN_ON(BTRFS_I(inode)->outstanding_extents < extents);
+			BTRFS_I(inode)->outstanding_extents -= extents;
 			spin_unlock(&BTRFS_I(inode)->accounting_lock);
-			btrfs_unreserve_metadata_for_delalloc(root, inode, 1);
+			btrfs_unreserve_metadata_for_delalloc(root, inode,
+							      extents);
 		}
 
 		spin_lock(&root->fs_info->delalloc_lock);
@@ -3106,7 +3135,8 @@ static int btrfs_truncate_page(struct address_space *mapping, loff_t from)
 	if (ret)
 		goto out;
 
-	ret = btrfs_reserve_metadata_for_delalloc(root, inode, 1);
+	ret = btrfs_reserve_metadata_for_delalloc(root, inode,
+				calculate_extents(root, PAGE_CACHE_SIZE));
 	if (ret)
 		goto out;
 
@@ -3115,7 +3145,8 @@ again:
 	page = grab_cache_page(mapping, index);
 	if (!page) {
 		btrfs_free_reserved_data_space(root, inode, PAGE_CACHE_SIZE);
-		btrfs_unreserve_metadata_for_delalloc(root, inode, 1);
+		btrfs_unreserve_metadata_for_delalloc(root, inode,
+				calculate_extents(root, PAGE_CACHE_SIZE));
 		goto out;
 	}
 
@@ -3179,7 +3210,8 @@ again:
 out_unlock:
 	if (ret)
 		btrfs_free_reserved_data_space(root, inode, PAGE_CACHE_SIZE);
-	btrfs_unreserve_metadata_for_delalloc(root, inode, 1);
+	btrfs_unreserve_metadata_for_delalloc(root, inode,
+				calculate_extents(root, PAGE_CACHE_SIZE));
 	unlock_page(page);
 	page_cache_release(page);
 out:
@@ -5098,7 +5130,8 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 		goto out;
 	}
 
-	ret = btrfs_reserve_metadata_for_delalloc(root, inode, 1);
+	ret = btrfs_reserve_metadata_for_delalloc(root, inode,
+				calculate_extents(root, PAGE_CACHE_SIZE));
 	if (ret) {
 		btrfs_free_reserved_data_space(root, inode, PAGE_CACHE_SIZE);
 		ret = VM_FAULT_SIGBUS;
@@ -5182,7 +5215,8 @@ again:
 	unlock_extent_cached(io_tree, page_start, page_end, &cached_state, GFP_NOFS);
 
 out_unlock:
-	btrfs_unreserve_metadata_for_delalloc(root, inode, 1);
+	btrfs_unreserve_metadata_for_delalloc(root, inode,
+				calculate_extents(root, PAGE_CACHE_SIZE));
 	if (!ret)
 		return VM_FAULT_LOCKED;
 	unlock_page(page);
@@ -5384,7 +5418,6 @@ free:
 void btrfs_drop_inode(struct inode *inode)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-
 	if (inode->i_nlink > 0 && btrfs_root_refs(&root->root_item) == 0)
 		generic_delete_inode(inode);
 	else
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index a8ffecd..5c99882 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -303,6 +303,7 @@ static int __btrfs_remove_ordered_extent(struct inode *inode,
 				struct btrfs_ordered_extent *entry)
 {
 	struct btrfs_ordered_inode_tree *tree;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct rb_node *node;
 
 	tree = &BTRFS_I(inode)->ordered_tree;
@@ -312,12 +313,13 @@ static int __btrfs_remove_ordered_extent(struct inode *inode,
 	set_bit(BTRFS_ORDERED_COMPLETE, &entry->flags);
 
 	spin_lock(&BTRFS_I(inode)->accounting_lock);
+	WARN_ON(!BTRFS_I(inode)->outstanding_extents);
 	BTRFS_I(inode)->outstanding_extents--;
 	spin_unlock(&BTRFS_I(inode)->accounting_lock);
 	btrfs_unreserve_metadata_for_delalloc(BTRFS_I(inode)->root,
 					      inode, 1);
 
-	spin_lock(&BTRFS_I(inode)->root->fs_info->ordered_extent_lock);
+	spin_lock(&root->fs_info->ordered_extent_lock);
 	list_del_init(&entry->root_extent_list);
 
 	/*
@@ -329,7 +331,7 @@ static int __btrfs_remove_ordered_extent(struct inode *inode,
 	    !mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY)) {
 		list_del_init(&BTRFS_I(inode)->ordered_operations);
 	}
-	spin_unlock(&BTRFS_I(inode)->root->fs_info->ordered_extent_lock);
+	spin_unlock(&root->fs_info->ordered_extent_lock);
 
 	return 0;
 }
-- 
1.6.6

