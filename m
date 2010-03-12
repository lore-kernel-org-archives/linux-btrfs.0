From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix ENOSPC accounting when max_extent is not maxed
	out
Date: Fri, 12 Mar 2010 14:29:44 -0500
Message-ID: <20100312192943.GB2332@localhost.localdomain>
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
nauseum and it works well.  It depends on all of the other patches I've sent
recently, including the per-cpu pools patch.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.h        |    8 ++++
 fs/btrfs/extent-tree.c  |    6 +-
 fs/btrfs/file.c         |    5 +-
 fs/btrfs/inode.c        |   99 +++++++++++++++++++++++++++++++---------------
 fs/btrfs/ordered-data.c |   13 ++++--
 5 files changed, 90 insertions(+), 41 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index f12fe00..2f5c01f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1965,6 +1965,14 @@ static inline struct dentry *fdentry(struct file *file)
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
index 73ac69b..0085dcb 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2837,7 +2837,7 @@ int btrfs_unreserve_metadata_for_delalloc(struct btrfs_root *root,
 		spin_unlock(&BTRFS_I(inode)->accounting_lock);
 		return 0;
 	}
-	BTRFS_I(inode)->reserved_extents--;
+	BTRFS_I(inode)->reserved_extents -= num_items;
 	spin_unlock(&BTRFS_I(inode)->accounting_lock);
 
 	btrfs_unreserve_metadata_space(root, num_items);
@@ -3059,7 +3059,7 @@ again:
 	if (realloc_bytes >= num_bytes) {
 		pool->total_bytes += realloc_bytes;
 		spin_lock(&BTRFS_I(inode)->accounting_lock);
-		BTRFS_I(inode)->reserved_extents++;
+		BTRFS_I(inode)->reserved_extents += num_items;
 		spin_unlock(&BTRFS_I(inode)->accounting_lock);
 		spin_unlock(&pool->lock);
 		return 0;
@@ -3074,7 +3074,7 @@ again:
 	 */
 	if (pool->reserved_bytes + pool->used_bytes <= pool->total_bytes) {
 		spin_lock(&BTRFS_I(inode)->accounting_lock);
-		BTRFS_I(inode)->reserved_extents++;
+		BTRFS_I(inode)->reserved_extents += num_items;
 		spin_unlock(&BTRFS_I(inode)->accounting_lock);
 		spin_unlock(&pool->lock);
 		return 0;
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
index b4056ca..09f18b9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1231,19 +1231,37 @@ static int btrfs_split_extent_hook(struct inode *inode,
 
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
 
@@ -1265,18 +1283,16 @@ static int btrfs_merge_extent_hook(struct inode *inode,
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
@@ -1286,14 +1302,20 @@ static int btrfs_merge_extent_hook(struct inode *inode,
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
@@ -1319,11 +1341,13 @@ static int btrfs_set_bit_hook(struct inode *inode, u64 start, u64 end,
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
@@ -1351,11 +1375,18 @@ static int btrfs_clear_bit_hook(struct inode *inode,
 		struct btrfs_root *root = BTRFS_I(inode)->root;
 
 		if (bits & EXTENT_DO_ACCOUNTING) {
+			int extents = calculate_extents(root, state->end -
+							state->start + 1);
+			int bug = 0;
+
 			spin_lock(&BTRFS_I(inode)->accounting_lock);
-			BUG_ON(!BTRFS_I(inode)->outstanding_extents);
-			BTRFS_I(inode)->outstanding_extents--;
+			if (BTRFS_I(inode)->outstanding_extents >= extents)
+				BTRFS_I(inode)->outstanding_extents -= extents;
+			else
+				bug = 1;
 			spin_unlock(&BTRFS_I(inode)->accounting_lock);
-			btrfs_unreserve_metadata_for_delalloc(root, inode, 1);
+			BUG_ON(bug);
+			btrfs_unreserve_metadata_for_delalloc(root, inode, extents);
 		}
 
 		spin_lock(&root->fs_info->delalloc_lock);
@@ -3103,7 +3134,8 @@ static int btrfs_truncate_page(struct address_space *mapping, loff_t from)
 	if (ret)
 		goto out;
 
-	ret = btrfs_reserve_metadata_for_delalloc(root, inode, 1);
+	ret = btrfs_reserve_metadata_for_delalloc(root, inode,
+				calculate_extents(root, PAGE_CACHE_SIZE));
 	if (ret)
 		goto out;
 
@@ -3112,7 +3144,8 @@ again:
 	page = grab_cache_page(mapping, index);
 	if (!page) {
 		btrfs_free_reserved_data_space(root, inode, PAGE_CACHE_SIZE);
-		btrfs_unreserve_metadata_for_delalloc(root, inode, 1);
+		btrfs_unreserve_metadata_for_delalloc(root, inode,
+				calculate_extents(root, PAGE_CACHE_SIZE));
 		goto out;
 	}
 
@@ -3176,7 +3209,8 @@ again:
 out_unlock:
 	if (ret)
 		btrfs_free_reserved_data_space(root, inode, PAGE_CACHE_SIZE);
-	btrfs_unreserve_metadata_for_delalloc(root, inode, 1);
+	btrfs_unreserve_metadata_for_delalloc(root, inode,
+				calculate_extents(root, PAGE_CACHE_SIZE));
 	unlock_page(page);
 	page_cache_release(page);
 out:
@@ -5092,7 +5126,8 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 		goto out;
 	}
 
-	ret = btrfs_reserve_metadata_for_delalloc(root, inode, 1);
+	ret = btrfs_reserve_metadata_for_delalloc(root, inode,
+				calculate_extents(root, PAGE_CACHE_SIZE));
 	if (ret) {
 		btrfs_free_reserved_data_space(root, inode, PAGE_CACHE_SIZE);
 		ret = VM_FAULT_SIGBUS;
@@ -5176,7 +5211,8 @@ again:
 	unlock_extent_cached(io_tree, page_start, page_end, &cached_state, GFP_NOFS);
 
 out_unlock:
-	btrfs_unreserve_metadata_for_delalloc(root, inode, 1);
+	btrfs_unreserve_metadata_for_delalloc(root, inode,
+				calculate_extents(root, PAGE_CACHE_SIZE));
 	if (!ret)
 		return VM_FAULT_LOCKED;
 	unlock_page(page);
@@ -5378,7 +5414,6 @@ free:
 void btrfs_drop_inode(struct inode *inode)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-
 	if (inode->i_nlink > 0 && btrfs_root_refs(&root->root_item) == 0)
 		generic_delete_inode(inode);
 	else
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 2aace81..fd366da 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -303,7 +303,9 @@ static int __btrfs_remove_ordered_extent(struct inode *inode,
 				struct btrfs_ordered_extent *entry)
 {
 	struct btrfs_ordered_inode_tree *tree;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct rb_node *node;
+	int bug = 0;
 
 	tree = &BTRFS_I(inode)->ordered_tree;
 	node = &entry->rb_node;
@@ -312,13 +314,16 @@ static int __btrfs_remove_ordered_extent(struct inode *inode,
 	set_bit(BTRFS_ORDERED_COMPLETE, &entry->flags);
 
 	spin_lock(&BTRFS_I(inode)->accounting_lock);
-	BUG_ON(!BTRFS_I(inode)->outstanding_extents);
-	BTRFS_I(inode)->outstanding_extents--;
+	if (BTRFS_I(inode)->outstanding_extents)
+		BTRFS_I(inode)->outstanding_extents--;
+	else
+		bug = 1;
 	spin_unlock(&BTRFS_I(inode)->accounting_lock);
+	BUG_ON(bug);
 	btrfs_unreserve_metadata_for_delalloc(BTRFS_I(inode)->root,
 					      inode, 1);
 
-	spin_lock(&BTRFS_I(inode)->root->fs_info->ordered_extent_lock);
+	spin_lock(&root->fs_info->ordered_extent_lock);
 	list_del_init(&entry->root_extent_list);
 
 	/*
@@ -330,7 +335,7 @@ static int __btrfs_remove_ordered_extent(struct inode *inode,
 	    !mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY)) {
 		list_del_init(&BTRFS_I(inode)->ordered_operations);
 	}
-	spin_unlock(&BTRFS_I(inode)->root->fs_info->ordered_extent_lock);
+	spin_unlock(&root->fs_info->ordered_extent_lock);
 
 	return 0;
 }
-- 
1.6.6

