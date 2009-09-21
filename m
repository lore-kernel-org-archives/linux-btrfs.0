From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: rework how we deal with metadata space used by
	delalloc
Date: Mon, 21 Sep 2009 17:29:20 -0400
Message-ID: <20090921212918.GA15097@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch fixes a few problems with how we currently deal with metadata
allocations required by delalloc.  This patch makes it so we track how much
metadata we need for an inode's delayed allocation extents by tracking how many
extents are currently waiting for allocation.  It introduces two new callbacks
for the extent_io tree's, merge_extent_hook and split_extent_hook.  These help
us keep track of when we merge delalloc extents together and split them up.
Reservations are handled prior to any actually dirty'ing occurs, and then we
unreserve after we dirty.  btrfs_unreserve_metadata_for_delalloc() will make the
appropriate unreservations as needed based on the number of reservations we
currently have and the number of extents we currently have.  Doing the
reservation outside of doing any of the actual dirty'ing lets us do things like
filemap_flush() the inode to try and force delalloc to happen, or as a last
resort actually start allocation on all delalloc inodes in the fs.  This has
survived dbench, fs_mark and an fsx torture test.  Thanks,

Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 fs/btrfs/btrfs_inode.h |    8 +++
 fs/btrfs/ctree.h       |    4 ++
 fs/btrfs/extent-tree.c |  124 +++++++++++++++++++++++++++++++++++++++++------
 fs/btrfs/extent_io.c   |   51 ++++++++------------
 fs/btrfs/extent_io.h   |    4 +-
 fs/btrfs/file.c        |   11 ++++
 fs/btrfs/inode.c       |  123 ++++++++++++++++++++++--------------------------
 7 files changed, 210 insertions(+), 115 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index ea1ea0a..9874da8 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -128,6 +128,14 @@ struct btrfs_inode {
 	u64 last_unlink_trans;
 
 	/*
+	 * These two counters are for delalloc metadata reservations.  We keep
+	 * track of how many extents we've accounted for vs how many extents we
+	 * have.
+	 */
+	int delalloc_reserved_extents;
+	int delalloc_extents;
+
+	/*
 	 * ordered_data_close is set by truncate when a file that used
 	 * to have good data has been truncated to zero.  When it is set
 	 * the btrfs file release call will add this inode to the
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 81d3d44..0805971 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2013,6 +2013,10 @@ void btrfs_clear_space_info_full(struct btrfs_fs_info *info);
 
 int btrfs_reserve_metadata_space(struct btrfs_root *root, int num_items);
 int btrfs_unreserve_metadata_space(struct btrfs_root *root, int num_items);
+int btrfs_unreserve_metadata_for_delalloc(struct btrfs_root *root,
+					  struct inode *inode, int num_items);
+int btrfs_reserve_metadata_for_delalloc(struct btrfs_root *root,
+					struct inode *inode, int num_items);
 int btrfs_check_data_free_space(struct btrfs_root *root, struct inode *inode,
 				u64 bytes);
 void btrfs_free_reserved_data_space(struct btrfs_root *root,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b259db3..7919050 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2795,6 +2795,103 @@ static u64 calculate_bytes_needed(struct btrfs_root *root, int num_items)
 }
 
 /*
+ * Unreserve metadata space for delalloc.  If we have less reserved credits than
+ * we have extents, this function does nothing.
+ */
+int btrfs_unreserve_metadata_for_delalloc(struct btrfs_root *root,
+					  struct inode *inode, int num_items)
+{
+	struct btrfs_fs_info *info = root->fs_info;
+	struct btrfs_space_info *meta_sinfo;
+	u64 num_bytes;
+	u64 alloc_target;
+	bool bug = false;
+
+	/* get the space info for where the metadata will live */
+	alloc_target = btrfs_get_alloc_profile(root, 0);
+	meta_sinfo = __find_space_info(info, alloc_target);
+
+	num_bytes = calculate_bytes_needed(root, num_items);
+
+	spin_lock(&meta_sinfo->lock);
+	if (BTRFS_I(inode)->delalloc_reserved_extents <=
+	    BTRFS_I(inode)->delalloc_extents) {
+		spin_unlock(&meta_sinfo->lock);
+		return 0;
+	}
+
+	BTRFS_I(inode)->delalloc_reserved_extents--;
+	BUG_ON(BTRFS_I(inode)->delalloc_reserved_extents < 0);
+
+	if (meta_sinfo->bytes_delalloc < num_bytes) {
+		bug = true;
+		meta_sinfo->bytes_delalloc = 0;
+	} else {
+		meta_sinfo->bytes_delalloc -= num_bytes;
+	}
+	spin_unlock(&meta_sinfo->lock);
+
+	BUG_ON(bug);
+
+	return 0;
+}
+
+/*
+ * Reserve metadata space for delalloc.
+ */
+int btrfs_reserve_metadata_for_delalloc(struct btrfs_root *root,
+					struct inode *inode, int num_items)
+{
+	struct btrfs_fs_info *info = root->fs_info;
+	struct btrfs_space_info *meta_sinfo;
+	u64 num_bytes;
+	u64 used;
+	u64 alloc_target;
+	int flushed = 0;
+
+	/* get the space info for where the metadata will live */
+	alloc_target = btrfs_get_alloc_profile(root, 0);
+	meta_sinfo = __find_space_info(info, alloc_target);
+
+	num_bytes = calculate_bytes_needed(root, num_items);
+again:
+	spin_lock(&meta_sinfo->lock);
+
+	if (unlikely(!meta_sinfo->bytes_root))
+		meta_sinfo->bytes_root = calculate_bytes_needed(root, 6);
+
+	used = meta_sinfo->bytes_used + meta_sinfo->bytes_reserved +
+		meta_sinfo->bytes_pinned + meta_sinfo->bytes_readonly +
+		meta_sinfo->bytes_super + meta_sinfo->bytes_root +
+		meta_sinfo->bytes_may_use + meta_sinfo->bytes_delalloc;
+
+	if (used + num_bytes > meta_sinfo->total_bytes) {
+		spin_unlock(&meta_sinfo->lock);
+		if (!flushed) {
+			flushed++;
+			filemap_flush(inode->i_mapping);
+			goto again;
+		} if (flushed == 1) {
+			btrfs_start_delalloc_inodes(root);
+			btrfs_wait_ordered_extents(root, 0);
+			flushed++;
+			goto again;
+		}
+		spin_unlock(&meta_sinfo->lock);
+		printk(KERN_ERR "enospc, has %d, reserved %d\n",
+		       BTRFS_I(inode)->delalloc_extents,
+		       BTRFS_I(inode)->delalloc_reserved_extents);
+		dump_space_info(meta_sinfo, 0, 0);
+		return -ENOSPC;
+	}
+
+	meta_sinfo->bytes_delalloc += num_bytes;
+	BTRFS_I(inode)->delalloc_reserved_extents++;
+	spin_unlock(&meta_sinfo->lock);
+
+	return 0;
+}
+/*
  * unreserve num_items number of items worth of metadata space.  This needs to
  * be paired with btrfs_reserve_metadata_space.
  *
@@ -2850,17 +2947,10 @@ int btrfs_reserve_metadata_space(struct btrfs_root *root, int num_items)
 	struct btrfs_space_info *meta_sinfo;
 	u64 num_bytes;
 	u64 used;
-	u64 alloc_target, thresh;
+	u64 alloc_target;
 	int ret;
 	bool committed = false;
 
-	/*
-	 * if we are inside a transaction, we don't want to force a commit since
-	 * it will cause us to deadlock.
-	 */
-	if (current->journal_info)
-		committed = true;
-
 	/* get the space info for where the metadata will live */
 	alloc_target = btrfs_get_alloc_profile(root, 0);
 	meta_sinfo = __find_space_info(info, alloc_target);
@@ -2875,7 +2965,7 @@ again:
 	used = meta_sinfo->bytes_used + meta_sinfo->bytes_reserved +
 		meta_sinfo->bytes_pinned + meta_sinfo->bytes_readonly +
 		meta_sinfo->bytes_super + meta_sinfo->bytes_root +
-		meta_sinfo->bytes_may_use;
+		meta_sinfo->bytes_may_use + meta_sinfo->bytes_delalloc;
 
 	if (used + num_bytes > meta_sinfo->total_bytes) {
 		spin_unlock(&meta_sinfo->lock);
@@ -2883,6 +2973,13 @@ again:
 		if (!committed) {
 			struct btrfs_trans_handle *trans;
 			committed = true;
+
+			btrfs_start_delalloc_inodes(root);
+			btrfs_wait_ordered_extents(root, 0);
+
+			if (current->journal_info)
+				goto again;
+
 			trans = btrfs_join_transaction(root, 1);
 			if (!trans)
 				return -ENOMEM;
@@ -2895,13 +2992,6 @@ again:
 		return -ENOSPC;
 	}
 
-	if (!meta_sinfo->full && !meta_sinfo->force_alloc) {
-		thresh = meta_sinfo->total_bytes * 80;
-		do_div(thresh, 100);
-		if (thresh < used)
-			meta_sinfo->force_alloc = 1;
-	}
-
 	meta_sinfo->bytes_may_use += num_bytes;
 	spin_unlock(&meta_sinfo->lock);
 
@@ -4137,6 +4227,7 @@ static void dump_space_info(struct btrfs_space_info *info, u64 bytes,
 {
 	struct btrfs_block_group_cache *cache;
 
+	spin_lock(&info->lock);
 	printk(KERN_INFO "space_info has %llu free, is %sfull\n",
 	       (unsigned long long)(info->total_bytes - info->bytes_used -
 				    info->bytes_pinned - info->bytes_reserved -
@@ -4153,6 +4244,7 @@ static void dump_space_info(struct btrfs_space_info *info, u64 bytes,
 	       (unsigned long long)info->bytes_root,
 	       (unsigned long long)info->bytes_super,
 	       (unsigned long long)info->bytes_reserved);
+	spin_unlock(&info->lock);
 
 	if (!dump_block_groups)
 		return;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b1b8831..9d3949d 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -126,8 +126,6 @@ static struct extent_state *alloc_extent_state(gfp_t mask)
 	state->state = 0;
 	state->private = 0;
 	state->tree = NULL;
-	state->split_start = 0;
-	state->split_end = 0;
 #if LEAK_DEBUG
 	spin_lock_irqsave(&leak_lock, flags);
 	list_add(&state->leak_list, &states);
@@ -283,10 +281,11 @@ static struct extent_buffer *buffer_search(struct extent_io_tree *tree,
 }
 
 static void merge_cb(struct extent_io_tree *tree, struct extent_state *new,
-		     struct extent_state *old)
+		     struct extent_state *other)
 {
 	if (tree->ops && tree->ops->merge_extent_hook)
-		tree->ops->merge_extent_hook(tree->mapping->host, new, old);
+		tree->ops->merge_extent_hook(tree->mapping->host, new,
+					     other);
 }
 
 /*
@@ -332,10 +331,6 @@ static int merge_state(struct extent_io_tree *tree,
 			state = NULL;
 		}
 	}
-	if (state) {
-		state->split_start = 0;
-		state->split_end = 0;
-	}
 
 	return 0;
 }
@@ -409,6 +404,15 @@ static int insert_state(struct extent_io_tree *tree,
 	return 0;
 }
 
+static int split_cb(struct extent_io_tree *tree, struct extent_state *orig,
+		     u64 split)
+{
+	if (tree->ops && tree->ops->split_extent_hook)
+		return tree->ops->split_extent_hook(tree->mapping->host,
+						    orig, split);
+	return 0;
+}
+
 /*
  * split a given extent state struct in two, inserting the preallocated
  * struct 'prealloc' as the newly created second half.  'split' indicates an
@@ -427,6 +431,9 @@ static int split_state(struct extent_io_tree *tree, struct extent_state *orig,
 		       struct extent_state *prealloc, u64 split)
 {
 	struct rb_node *node;
+
+	split_cb(tree, orig, split);
+
 	prealloc->start = orig->start;
 	prealloc->end = split - 1;
 	prealloc->state = orig->state;
@@ -503,8 +510,6 @@ int clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	struct rb_node *next_node;
 	struct rb_node *node;
 	u64 last_end;
-	u64 split_start = 0;
-	u64 split_end = 0;
 	int err;
 	int set = 0;
 
@@ -560,15 +565,12 @@ hit_next:
 	if (state->start < start) {
 		if (!prealloc)
 			prealloc = alloc_extent_state(GFP_ATOMIC);
-		split_start = state->start;
 		err = split_state(tree, state, prealloc, start);
 		BUG_ON(err == -EEXIST);
 		prealloc = NULL;
 		if (err)
 			goto out;
 		if (state->end <= end) {
-			state->split_start = split_start;
-			split_start = 0;
 			set |= clear_state_bit(tree, state, bits, wake,
 					       delete);
 			if (last_end == (u64)-1)
@@ -588,13 +590,8 @@ hit_next:
 	if (state->start <= end && state->end > end) {
 		if (!prealloc)
 			prealloc = alloc_extent_state(GFP_ATOMIC);
-		split_end = state->end;
 		err = split_state(tree, state, prealloc, end + 1);
 		BUG_ON(err == -EEXIST);
-		prealloc->split_start = split_start;
-		prealloc->split_end = split_end;
-		split_start = 0;
-		split_end = 0;
 		if (wake)
 			wake_up(&state->wq);
 		set |= clear_state_bit(tree, prealloc, bits, wake, delete);
@@ -749,8 +746,6 @@ static int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	int err = 0;
 	u64 last_start;
 	u64 last_end;
-	u64 split_start = 0;
-	u64 split_end = 0;
 
 again:
 	if (!prealloc && (mask & __GFP_WAIT)) {
@@ -839,15 +834,12 @@ hit_next:
 			err = -EEXIST;
 			goto out;
 		}
-		split_start = state->start;
 		err = split_state(tree, state, prealloc, start);
 		BUG_ON(err == -EEXIST);
 		prealloc = NULL;
 		if (err)
 			goto out;
 		if (state->end <= end) {
-			state->split_start = split_start;
-			split_start = 0;
 			err = set_state_bits(tree, state, bits);
 			if (err)
 				goto out;
@@ -876,11 +868,13 @@ hit_next:
 			this_end = last_start - 1;
 		err = insert_state(tree, prealloc, start, this_end,
 				   bits);
-		cache_state(prealloc, cached_state);
-		prealloc = NULL;
 		BUG_ON(err == -EEXIST);
-		if (err)
+		if (err) {
+			prealloc = NULL;
 			goto out;
+		}
+		cache_state(prealloc, cached_state);
+		prealloc = NULL;
 		start = this_end + 1;
 		goto search_again;
 	}
@@ -896,14 +890,9 @@ hit_next:
 			err = -EEXIST;
 			goto out;
 		}
-		split_end = state->end;
 		err = split_state(tree, state, prealloc, end + 1);
 		BUG_ON(err == -EEXIST);
 
-		prealloc->split_start = split_start;
-		prealloc->split_end = split_end;
-		split_start = 0;
-		split_end = 0;
 		err = set_state_bits(tree, prealloc, bits);
 		if (err) {
 			prealloc = NULL;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 5d4b140..4794ec8 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -64,7 +64,9 @@ struct extent_io_ops {
 			      unsigned long bits);
 	int (*merge_extent_hook)(struct inode *inode,
 				 struct extent_state *new,
-				 struct extent_state *old);
+				 struct extent_state *other);
+	int (*split_extent_hook)(struct inode *inode,
+				 struct extent_state *orig, u64 split);
 	int (*write_cache_pages_lock_hook)(struct page *page);
 };
 
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 7b9f09a..4279ed7 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -980,10 +980,18 @@ static ssize_t btrfs_file_write(struct file *file, const char __user *buf,
 		if (ret)
 			goto out;
 
+		ret = btrfs_reserve_metadata_for_delalloc(root, inode, 1);
+		if (ret) {
+			btrfs_free_reserved_data_space(root, inode,
+						       write_bytes);
+			goto out;
+		}
+
 		ret = prepare_pages(root, file, pages, num_pages,
 				    pos, first_index, last_index,
 				    write_bytes);
 		if (ret) {
+			btrfs_unreserve_metadata_for_delalloc(root, inode, 1);
 			btrfs_free_reserved_data_space(root, inode,
 						       write_bytes);
 			goto out;
@@ -992,6 +1000,7 @@ static ssize_t btrfs_file_write(struct file *file, const char __user *buf,
 		ret = btrfs_copy_from_user(pos, num_pages,
 					   write_bytes, pages, buf);
 		if (ret) {
+			btrfs_unreserve_metadata_for_delalloc(root, inode, 1);
 			btrfs_free_reserved_data_space(root, inode,
 						       write_bytes);
 			btrfs_drop_pages(pages, num_pages);
@@ -1002,6 +1011,7 @@ static ssize_t btrfs_file_write(struct file *file, const char __user *buf,
 					      num_pages, pos, write_bytes);
 		btrfs_drop_pages(pages, num_pages);
 		if (ret) {
+			btrfs_unreserve_metadata_for_delalloc(root, inode, 1);
 			btrfs_free_reserved_data_space(root, inode,
 						       write_bytes);
 			goto out;
@@ -1019,6 +1029,7 @@ static ssize_t btrfs_file_write(struct file *file, const char __user *buf,
 				btrfs_btree_balance_dirty(root, 1);
 			btrfs_throttle(root);
 		}
+		btrfs_unreserve_metadata_for_delalloc(root, inode, 1);
 
 		buf += write_bytes;
 		count -= write_bytes;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5ac052e..c22075d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1151,6 +1151,38 @@ static int run_delalloc_range(struct inode *inode, struct page *locked_page,
 	return ret;
 }
 
+static int btrfs_split_extent_hook(struct inode *inode,
+				    struct extent_state *orig, u64 split)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	u64 size;
+
+	if (!(orig->state & EXTENT_DELALLOC))
+		return 0;
+
+	size = orig->end - orig->start + 1;
+	if (size > root->fs_info->max_extent) {
+		u64 num_extents;
+		u64 new_size;
+
+		new_size = orig->end - split + 1;
+		num_extents = div64_u64(size + root->fs_info->max_extent - 1,
+					root->fs_info->max_extent);
+
+		/*
+		 * if we break a large extent up then leave delalloc_extents be,
+		 * since we've already accounted for the large extent.
+		 */
+		if (div64_u64(new_size + root->fs_info->max_extent - 1,
+			      root->fs_info->max_extent) < num_extents)
+			return 0;
+	}
+
+	BTRFS_I(inode)->delalloc_extents++;
+
+	return 0;
+}
+
 /*
  * extent_io.c merge_extent_hook, used to track merged delayed allocation
  * extents so we can keep track of new extents that are just merged onto old
@@ -1159,32 +1191,25 @@ static int run_delalloc_range(struct inode *inode, struct page *locked_page,
  */
 static int btrfs_merge_extent_hook(struct inode *inode,
 				   struct extent_state *new,
-				   struct extent_state *old)
+				   struct extent_state *other)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	u64 old_size, new_size, num_extents;
+	u64 new_size, old_size;
+	u64 num_extents;
 
 	/* not delalloc, ignore it */
-	if (!(old->state & EXTENT_DELALLOC))
+	if (!(other->state & EXTENT_DELALLOC))
 		return 0;
 
-	/*
-	 * we're merging an extent that existed before and was split off the
-	 * extent we are merging it onto, so don't do anything.
-	 */
-	if (new->split_end || new->split_start)
-		return 0;
-
-	old_size = old->end - old->start + 1;
-
-	if (new->start < old->start)
-		new_size = old->end - new->start + 1;
+	old_size = other->end - other->start + 1;
+	if (new->start < other->start)
+		new_size = other->end - new->start + 1;
 	else
-		new_size = new->end - old->start + 1;
+		new_size = new->end - other->start + 1;
 
 	/* we're not bigger than the max, unreserve the space and go */
 	if (new_size <= root->fs_info->max_extent) {
-		btrfs_unreserve_metadata_space(root, 1);
+		BTRFS_I(inode)->delalloc_extents--;
 		return 0;
 	}
 
@@ -1198,7 +1223,7 @@ static int btrfs_merge_extent_hook(struct inode *inode,
 		      root->fs_info->max_extent) > num_extents)
 		return 0;
 
-	btrfs_unreserve_metadata_space(root, 1);
+	BTRFS_I(inode)->delalloc_extents--;
 
 	return 0;
 }
@@ -1211,7 +1236,6 @@ static int btrfs_merge_extent_hook(struct inode *inode,
 static int btrfs_set_bit_hook(struct inode *inode, u64 start, u64 end,
 		       unsigned long old, unsigned long bits)
 {
-	int ret;
 
 	/*
 	 * set_bit and clear bit hooks normally require _irqsave/restore
@@ -1221,9 +1245,7 @@ static int btrfs_set_bit_hook(struct inode *inode, u64 start, u64 end,
 	if (!(old & EXTENT_DELALLOC) && (bits & EXTENT_DELALLOC)) {
 		struct btrfs_root *root = BTRFS_I(inode)->root;
 
-		ret = btrfs_reserve_metadata_space(root, 1);
-		if (ret)
-			return ret;
+		BTRFS_I(inode)->delalloc_extents++;
 		btrfs_delalloc_reserve_space(root, inode, end - start + 1);
 		spin_lock(&root->fs_info->delalloc_lock);
 		BTRFS_I(inode)->delalloc_bytes += end - start + 1;
@@ -1251,52 +1273,8 @@ static int btrfs_clear_bit_hook(struct inode *inode,
 	if ((state->state & EXTENT_DELALLOC) && (bits & EXTENT_DELALLOC)) {
 		struct btrfs_root *root = BTRFS_I(inode)->root;
 
-		/*
-		 * Ok we're freeing up a part of a larger extent, we need to
-		 * figure out if it warrants unreserving the metadata space for
-		 * this extent.
-		 */
-		if (state->split_start || state->split_end) {
-			u64 old_size, new_size, max_extent;
-
-			max_extent = root->fs_info->max_extent;
-			if (state->split_start && state->split_end)
-				old_size = state->split_end -
-					state->split_start + 1;
-			else if (state->split_start)
-				old_size = state->end - state->split_start + 1;
-			else
-				old_size = state->split_end - state->start + 1;
-
-			new_size = old_size - (state->end - state->state + 1);
-
-			/*
-			 * the only way we want to unreserve metadata space is
-			 * if this extent was larger than a max extent, and we
-			 * made it smaller than a max_extent multiple.  The idea
-			 * here is we only need 1 item worth of metadata space
-			 * reserved per max_extent range of data.  So if we've
-			 * taken a big extent and made it smaller than a
-			 * multiple of max_extent, we don't have to worry about
-			 * its reserved space anymore
-			 */
-			if (old_size > max_extent) {
-				u64 num_extents;
-
-				num_extents =
-					div64_u64(old_size + max_extent - 1,
-						  max_extent);
-				if (div64_u64(new_size + max_extent - 1,
-					      max_extent) < num_extents)
-					btrfs_unreserve_metadata_space(root, 1);
-			}
-		} else {
-			/*
-			 * if this state was not split off of a larger node, we
-			 * need to unreserve its metadata space.
-			 */
-			btrfs_unreserve_metadata_space(root, 1);
-		}
+		BTRFS_I(inode)->delalloc_extents--;
+		btrfs_unreserve_metadata_for_delalloc(root, inode, 1);
 
 		spin_lock(&root->fs_info->delalloc_lock);
 		if (state->end - state->start + 1 >
@@ -4650,6 +4628,13 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 		goto out;
 	}
 
+	ret = btrfs_reserve_metadata_for_delalloc(root, inode, 1);
+	if (ret) {
+		btrfs_free_reserved_data_space(root, inode, PAGE_CACHE_SIZE);
+		ret = VM_FAULT_SIGBUS;
+		goto out;
+	}
+
 	ret = VM_FAULT_NOPAGE; /* make the VM retry the fault */
 again:
 	lock_page(page);
@@ -4709,6 +4694,7 @@ again:
 	unlock_extent(io_tree, page_start, page_end, GFP_NOFS);
 
 out_unlock:
+	btrfs_unreserve_metadata_for_delalloc(root, inode, 1);
 	if (!ret)
 		return VM_FAULT_LOCKED;
 	unlock_page(page);
@@ -4826,6 +4812,8 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 		return NULL;
 	ei->last_trans = 0;
 	ei->logged_trans = 0;
+	ei->delalloc_extents = 0;
+	ei->delalloc_reserved_extents = 0;
 	btrfs_ordered_inode_tree_init(&ei->ordered_tree);
 	INIT_LIST_HEAD(&ei->i_orphan);
 	INIT_LIST_HEAD(&ei->ordered_operations);
@@ -5452,6 +5440,7 @@ static struct extent_io_ops btrfs_extent_io_ops = {
 	.set_bit_hook = btrfs_set_bit_hook,
 	.clear_bit_hook = btrfs_clear_bit_hook,
 	.merge_extent_hook = btrfs_merge_extent_hook,
+	.split_extent_hook = btrfs_split_extent_hook,
 };
 
 /*
-- 
1.5.4.3

