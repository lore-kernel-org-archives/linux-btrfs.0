From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: proper -ENOSPC handling v2
Date: Wed, 9 Sep 2009 10:37:52 -0400
Message-ID: <20090909143751.GE22784@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is vastly different from the original patch.  Now instead of checking for
enough space when starting each transaction, we simply do a
btrfs_reserve_metadata_space() and specify how many items we plan on modifying.
Then once we've done our modifications and such, just call
btrfs_unreserve_metadata_space() for the same number of items we reserved.

For keeping track of metadata needed for data I've had to add an extent_io op
for when we merge extents.  This lets us track space properly when we are doing
sequential writes, so we don't end up reserving way more metadata space than
what we need.

The only place where the metadata space accounting is not done is in the
relocation code.  This is because Yan is going to be reworking that code in the
near future, so running btrfs-vol -b could still possibly result in a ENOSPC
related panic.  This patch also turns off the metadata_ratio stuff in order to
allow users to more efficiently use their disk space.

Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 fs/btrfs/ctree.h       |   14 ++--
 fs/btrfs/disk-io.c     |    2 +-
 fs/btrfs/extent-tree.c |  161 ++++++++++++++++++++++++++-------
 fs/btrfs/extent_io.c   |   96 +++++++++++++++----
 fs/btrfs/extent_io.h   |   11 ++-
 fs/btrfs/file.c        |    5 +-
 fs/btrfs/inode.c       |  237 +++++++++++++++++++++++++++++++++++++++++-------
 fs/btrfs/ioctl.c       |   19 ++++-
 fs/btrfs/transaction.c |   10 ++
 9 files changed, 455 insertions(+), 100 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index ef3e426..0723ab9 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -673,13 +673,12 @@ struct btrfs_space_info {
 				   current allocations */
 	u64 bytes_readonly;	/* total bytes that are read only */
 	u64 bytes_super;	/* total bytes reserved for the super blocks */
-
-	/* delalloc accounting */
-	u64 bytes_delalloc;	/* number of bytes reserved for allocation,
-				   this space is not necessarily reserved yet
-				   by the allocator */
+	u64 bytes_root;		/* the number of bytes needed to commit a
+				   transaction */
 	u64 bytes_may_use;	/* number of bytes that may be used for
-				   delalloc */
+				   delalloc/allocations */
+	u64 bytes_delalloc;	/* number of bytes currently reserved for
+				   delayed allocation */
 
 	int full;		/* indicates that we cannot allocate any more
 				   chunks for this space */
@@ -2014,7 +2013,8 @@ u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags);
 void btrfs_set_inode_space_info(struct btrfs_root *root, struct inode *ionde);
 void btrfs_clear_space_info_full(struct btrfs_fs_info *info);
 
-int btrfs_check_metadata_free_space(struct btrfs_root *root);
+int btrfs_reserve_metadata_space(struct btrfs_root *root, int num_items);
+int btrfs_unreserve_metadata_space(struct btrfs_root *root, int num_items);
 int btrfs_check_data_free_space(struct btrfs_root *root, struct inode *inode,
 				u64 bytes);
 void btrfs_free_reserved_data_space(struct btrfs_root *root,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c17da03..f822ad8 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1574,7 +1574,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	fs_info->btree_inode = new_inode(sb);
 	fs_info->btree_inode->i_ino = 1;
 	fs_info->btree_inode->i_nlink = 1;
-	fs_info->metadata_ratio = 8;
+	fs_info->metadata_ratio = 0;
 
 	fs_info->thread_pool_size = min_t(unsigned long,
 					  num_online_cpus() + 2, 8);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 36f33bc..d430939 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -68,6 +68,8 @@ static int pin_down_bytes(struct btrfs_trans_handle *trans,
 			  struct extent_buffer **must_clean);
 static int find_next_key(struct btrfs_path *path, int level,
 			 struct btrfs_key *key);
+static void dump_space_info(struct btrfs_space_info *info, u64 bytes,
+			    int dump_block_groups);
 
 static noinline int
 block_group_cache_done(struct btrfs_block_group_cache *cache)
@@ -2764,51 +2766,123 @@ void btrfs_set_inode_space_info(struct btrfs_root *root, struct inode *inode)
 						       alloc_target);
 }
 
+static u64 calculate_bytes_needed(struct btrfs_root *root, int num_items)
+{
+	u64 num_bytes;
+
+	/*
+	 * NOTE: these calculations are absolutely the worst possible case.
+	 * This assumes that _every_ item we insert will require a new leaf, and
+	 * that the tree has grown to its maximum level size.
+	 */
+
+	/*
+	 * for every item we insert we could insert both an extent item and a
+	 * extent ref item.  Then for ever item we insert, we will need to cow
+	 * both the original leaf, plus the leaf to the left and right of it.
+	 */
+	num_bytes = (num_items + (2 * num_items)) * 3;
+
+	/*
+	 * num_bytes is total number of leaves we could need times the leaf
+	 * size, and then for every leaf we could end up cow'ing 2 nodes per
+	 * level, down to the leaf level.
+	 */
+	num_bytes = (num_bytes * root->leafsize) +
+		(num_bytes * ((BTRFS_MAX_LEVEL - 1) * 2)) * root->nodesize;
+
+	return num_bytes;
+}
+
+/*
+ * unreserve num_items number of items worth of metadata space.  This needs to
+ * be paired with btrfs_reserve_metadata_space.
+ *
+ * NOTE: if you have the option, run this _AFTER_ you do a
+ * btrfs_end_transaction, since btrfs_end_transaction will run delayed ref
+ * oprations which will result in more used metadata, so we want to make sure we
+ * can do that without issue.
+ */
+int btrfs_unreserve_metadata_space(struct btrfs_root *root, int num_items)
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
+	if (meta_sinfo->bytes_may_use < num_bytes) {
+		bug = true;
+		meta_sinfo->bytes_may_use = 0;
+	} else {
+		meta_sinfo->bytes_may_use -= num_bytes;
+	}
+	spin_unlock(&meta_sinfo->lock);
+
+	BUG_ON(bug);
+
+	return 0;
+}
+
 /*
- * for now this just makes sure we have at least 5% of our metadata space free
- * for use.
+ * Reserve some metadata space for use.  We'll calculate the worste case number
+ * of bytes that would be needed to modify num_items number of items.  If we
+ * have space, fantastic, if not, you get -ENOSPC.  Please call
+ * btrfs_unreserve_metadata_space when you are done for the _SAME_ number of
+ * items you reserved, since whatever metadata you needed should have already
+ * been allocated.
+ *
+ * This will commit the transaction to make more space if we don't have enough
+ * metadata space.  THe only time we don't do this is if we're reserving space
+ * inside of a transaction, then we will just return -ENOSPC and it is the
+ * callers responsibility to handle it properly.
  */
-int btrfs_check_metadata_free_space(struct btrfs_root *root)
+int btrfs_reserve_metadata_space(struct btrfs_root *root, int num_items)
 {
 	struct btrfs_fs_info *info = root->fs_info;
 	struct btrfs_space_info *meta_sinfo;
+	u64 num_bytes;
+	u64 used;
 	u64 alloc_target, thresh;
-	int committed = 0, ret;
+	int ret;
+	bool committed = false;
+
+	/*
+	 * if we are inside a transaction, we don't want to force a commit since
+	 * it will cause us to deadlock.
+	 */
+	if (current->journal_info)
+		committed = true;
 
 	/* get the space info for where the metadata will live */
 	alloc_target = btrfs_get_alloc_profile(root, 0);
 	meta_sinfo = __find_space_info(info, alloc_target);
 
+	num_bytes = calculate_bytes_needed(root, num_items);
 again:
 	spin_lock(&meta_sinfo->lock);
-	if (!meta_sinfo->full)
-		thresh = meta_sinfo->total_bytes * 80;
-	else
-		thresh = meta_sinfo->total_bytes * 95;
 
-	do_div(thresh, 100);
-
-	if (meta_sinfo->bytes_used + meta_sinfo->bytes_reserved +
-	    meta_sinfo->bytes_pinned + meta_sinfo->bytes_readonly +
-	    meta_sinfo->bytes_super > thresh) {
-		struct btrfs_trans_handle *trans;
-		if (!meta_sinfo->full) {
-			meta_sinfo->force_alloc = 1;
-			spin_unlock(&meta_sinfo->lock);
+	if (unlikely(!meta_sinfo->bytes_root))
+		meta_sinfo->bytes_root = calculate_bytes_needed(root, 6);
 
-			trans = btrfs_start_transaction(root, 1);
-			if (!trans)
-				return -ENOMEM;
+	used = meta_sinfo->bytes_used + meta_sinfo->bytes_reserved +
+		meta_sinfo->bytes_pinned + meta_sinfo->bytes_readonly +
+		meta_sinfo->bytes_super + meta_sinfo->bytes_root +
+		meta_sinfo->bytes_may_use;
 
-			ret = do_chunk_alloc(trans, root->fs_info->extent_root,
-					     2 * 1024 * 1024, alloc_target, 0);
-			btrfs_end_transaction(trans, root);
-			goto again;
-		}
+	if (used + num_bytes > meta_sinfo->total_bytes) {
 		spin_unlock(&meta_sinfo->lock);
 
 		if (!committed) {
-			committed = 1;
+			struct btrfs_trans_handle *trans;
+			committed = true;
 			trans = btrfs_join_transaction(root, 1);
 			if (!trans)
 				return -ENOMEM;
@@ -2817,8 +2891,18 @@ again:
 				return ret;
 			goto again;
 		}
+		dump_space_info(meta_sinfo, 0, 0);
 		return -ENOSPC;
 	}
+
+	if (!meta_sinfo->full && !meta_sinfo->force_alloc) {
+		thresh = meta_sinfo->total_bytes * 80;
+		do_div(thresh, 100);
+		if (thresh < used)
+			meta_sinfo->force_alloc = 1;
+	}
+
+	meta_sinfo->bytes_may_use += num_bytes;
 	spin_unlock(&meta_sinfo->lock);
 
 	return 0;
@@ -2901,7 +2985,7 @@ again:
 	BTRFS_I(inode)->reserved_bytes += bytes;
 	spin_unlock(&data_sinfo->lock);
 
-	return btrfs_check_metadata_free_space(root);
+	return 0;
 }
 
 /*
@@ -3010,7 +3094,7 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 	}
 
 	thresh = space_info->total_bytes - space_info->bytes_readonly;
-	thresh = div_factor(thresh, 6);
+	thresh = div_factor(thresh, 8);
 	if (!force &&
 	   (space_info->bytes_used + space_info->bytes_pinned +
 	    space_info->bytes_reserved + alloc_bytes) < thresh) {
@@ -3024,7 +3108,7 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 	 * we keep a reasonable number of metadata chunks allocated in the
 	 * FS as well.
 	 */
-	if (flags & BTRFS_BLOCK_GROUP_DATA) {
+	if (flags & BTRFS_BLOCK_GROUP_DATA && fs_info->metadata_ratio) {
 		fs_info->data_chunk_allocations++;
 		if (!(fs_info->data_chunk_allocations %
 		      fs_info->metadata_ratio))
@@ -4057,21 +4141,30 @@ loop:
 	return ret;
 }
 
-static void dump_space_info(struct btrfs_space_info *info, u64 bytes)
+static void dump_space_info(struct btrfs_space_info *info, u64 bytes,
+			    int dump_block_groups)
 {
 	struct btrfs_block_group_cache *cache;
 
 	printk(KERN_INFO "space_info has %llu free, is %sfull\n",
 	       (unsigned long long)(info->total_bytes - info->bytes_used -
-				    info->bytes_pinned - info->bytes_reserved),
+				    info->bytes_pinned - info->bytes_reserved -
+				    info->bytes_super),
 	       (info->full) ? "" : "not ");
 	printk(KERN_INFO "space_info total=%llu, pinned=%llu, delalloc=%llu,"
-	       " may_use=%llu, used=%llu\n",
+	       " may_use=%llu, used=%llu, root=%llu, super=%llu, reserved=%llu"
+	       "\n",
 	       (unsigned long long)info->total_bytes,
 	       (unsigned long long)info->bytes_pinned,
 	       (unsigned long long)info->bytes_delalloc,
 	       (unsigned long long)info->bytes_may_use,
-	       (unsigned long long)info->bytes_used);
+	       (unsigned long long)info->bytes_used,
+	       (unsigned long long)info->bytes_root,
+	       (unsigned long long)info->bytes_super,
+	       (unsigned long long)info->bytes_reserved);
+
+	if (!dump_block_groups)
+		return;
 
 	down_read(&info->groups_sem);
 	list_for_each_entry(cache, &info->block_groups, list) {
@@ -4139,7 +4232,7 @@ again:
 		printk(KERN_ERR "btrfs allocation failed flags %llu, "
 		       "wanted %llu\n", (unsigned long long)data,
 		       (unsigned long long)num_bytes);
-		dump_space_info(sinfo, num_bytes);
+		dump_space_info(sinfo, num_bytes, 1);
 	}
 
 	return ret;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 7b3cf19..4d0d05d 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -126,6 +126,8 @@ static struct extent_state *alloc_extent_state(gfp_t mask)
 	state->state = 0;
 	state->private = 0;
 	state->tree = NULL;
+	state->split_start = 0;
+	state->split_end = 0;
 #if LEAK_DEBUG
 	spin_lock_irqsave(&leak_lock, flags);
 	list_add(&state->leak_list, &states);
@@ -280,6 +282,13 @@ static struct extent_buffer *buffer_search(struct extent_io_tree *tree,
 	return NULL;
 }
 
+static void merge_cb(struct extent_io_tree *tree, struct extent_state *new,
+		     struct extent_state *old)
+{
+	if (tree->ops && tree->ops->merge_extent_hook)
+		tree->ops->merge_extent_hook(tree->mapping->host, new, old);
+}
+
 /*
  * utility function to look for merge candidates inside a given range.
  * Any extents with matching state are merged together into a single
@@ -303,6 +312,7 @@ static int merge_state(struct extent_io_tree *tree,
 		other = rb_entry(other_node, struct extent_state, rb_node);
 		if (other->end == state->start - 1 &&
 		    other->state == state->state) {
+			merge_cb(tree, state, other);
 			state->start = other->start;
 			other->tree = NULL;
 			rb_erase(&other->rb_node, &tree->state);
@@ -314,33 +324,41 @@ static int merge_state(struct extent_io_tree *tree,
 		other = rb_entry(other_node, struct extent_state, rb_node);
 		if (other->start == state->end + 1 &&
 		    other->state == state->state) {
+			merge_cb(tree, state, other);
 			other->start = state->start;
 			state->tree = NULL;
 			rb_erase(&state->rb_node, &tree->state);
 			free_extent_state(state);
+			state = NULL;
 		}
 	}
+	if (state) {
+		state->split_start = 0;
+		state->split_end = 0;
+	}
+
 	return 0;
 }
 
-static void set_state_cb(struct extent_io_tree *tree,
+static int set_state_cb(struct extent_io_tree *tree,
 			 struct extent_state *state,
 			 unsigned long bits)
 {
 	if (tree->ops && tree->ops->set_bit_hook) {
-		tree->ops->set_bit_hook(tree->mapping->host, state->start,
-					state->end, state->state, bits);
+		return tree->ops->set_bit_hook(tree->mapping->host,
+					       state->start, state->end,
+					       state->state, bits);
 	}
+
+	return 0;
 }
 
 static void clear_state_cb(struct extent_io_tree *tree,
 			   struct extent_state *state,
 			   unsigned long bits)
 {
-	if (tree->ops && tree->ops->clear_bit_hook) {
-		tree->ops->clear_bit_hook(tree->mapping->host, state->start,
-					  state->end, state->state, bits);
-	}
+	if (tree->ops && tree->ops->clear_bit_hook)
+		tree->ops->clear_bit_hook(tree->mapping->host, state, bits);
 }
 
 /*
@@ -358,6 +376,7 @@ static int insert_state(struct extent_io_tree *tree,
 			int bits)
 {
 	struct rb_node *node;
+	int ret;
 
 	if (end < start) {
 		printk(KERN_ERR "btrfs end < start %llu %llu\n",
@@ -365,11 +384,14 @@ static int insert_state(struct extent_io_tree *tree,
 		       (unsigned long long)start);
 		WARN_ON(1);
 	}
-	if (bits & EXTENT_DIRTY)
-		tree->dirty_bytes += end - start + 1;
 	state->start = start;
 	state->end = end;
-	set_state_cb(tree, state, bits);
+	ret = set_state_cb(tree, state, bits);
+	if (ret)
+		return ret;
+
+	if (bits & EXTENT_DIRTY)
+		tree->dirty_bytes += end - start + 1;
 	state->state |= bits;
 	node = tree_insert(&tree->state, end, &state->rb_node);
 	if (node) {
@@ -481,6 +503,8 @@ int clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	struct rb_node *next_node;
 	struct rb_node *node;
 	u64 last_end;
+	u64 split_start = 0;
+	u64 split_end = 0;
 	int err;
 	int set = 0;
 
@@ -536,14 +560,17 @@ hit_next:
 	if (state->start < start) {
 		if (!prealloc)
 			prealloc = alloc_extent_state(GFP_ATOMIC);
+		split_start = state->start;
 		err = split_state(tree, state, prealloc, start);
 		BUG_ON(err == -EEXIST);
 		prealloc = NULL;
 		if (err)
 			goto out;
 		if (state->end <= end) {
-			set |= clear_state_bit(tree, state, bits,
-					wake, delete);
+			state->split_start = split_start;
+			split_start = 0;
+			set |= clear_state_bit(tree, state, bits, wake,
+					       delete);
 			if (last_end == (u64)-1)
 				goto out;
 			start = last_end + 1;
@@ -561,13 +588,16 @@ hit_next:
 	if (state->start <= end && state->end > end) {
 		if (!prealloc)
 			prealloc = alloc_extent_state(GFP_ATOMIC);
+		split_end = state->end;
 		err = split_state(tree, state, prealloc, end + 1);
 		BUG_ON(err == -EEXIST);
-
+		prealloc->split_start = split_start;
+		prealloc->split_end = split_end;
+		split_start = 0;
+		split_end = 0;
 		if (wake)
 			wake_up(&state->wq);
-		set |= clear_state_bit(tree, prealloc, bits,
-				       wake, delete);
+		set |= clear_state_bit(tree, prealloc, bits, wake, delete);
 		prealloc = NULL;
 		goto out;
 	}
@@ -667,16 +697,23 @@ out:
 	return 0;
 }
 
-static void set_state_bits(struct extent_io_tree *tree,
+static int set_state_bits(struct extent_io_tree *tree,
 			   struct extent_state *state,
 			   int bits)
 {
+	int ret;
+
+	ret = set_state_cb(tree, state, bits);
+	if (ret)
+		return ret;
+
 	if ((bits & EXTENT_DIRTY) && !(state->state & EXTENT_DIRTY)) {
 		u64 range = state->end - state->start + 1;
 		tree->dirty_bytes += range;
 	}
-	set_state_cb(tree, state, bits);
 	state->state |= bits;
+
+	return 0;
 }
 
 static void cache_state(struct extent_state *state,
@@ -712,6 +749,9 @@ static int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	int err = 0;
 	u64 last_start;
 	u64 last_end;
+	u64 split_start = 0;
+	u64 split_end = 0;
+
 again:
 	if (!prealloc && (mask & __GFP_WAIT)) {
 		prealloc = alloc_extent_state(mask);
@@ -756,7 +796,9 @@ hit_next:
 			err = -EEXIST;
 			goto out;
 		}
-		set_state_bits(tree, state, bits);
+		err = set_state_bits(tree, state, bits);
+		if (err)
+			goto out;
 		cache_state(state, cached_state);
 		merge_state(tree, state);
 		if (last_end == (u64)-1)
@@ -797,13 +839,18 @@ hit_next:
 			err = -EEXIST;
 			goto out;
 		}
+		split_start = state->start;
 		err = split_state(tree, state, prealloc, start);
 		BUG_ON(err == -EEXIST);
 		prealloc = NULL;
 		if (err)
 			goto out;
 		if (state->end <= end) {
-			set_state_bits(tree, state, bits);
+			state->split_start = split_start;
+			split_start = 0;
+			err = set_state_bits(tree, state, bits);
+			if (err)
+				goto out;
 			cache_state(state, cached_state);
 			merge_state(tree, state);
 			if (last_end == (u64)-1)
@@ -849,10 +896,19 @@ hit_next:
 			err = -EEXIST;
 			goto out;
 		}
+		split_end = state->end;
 		err = split_state(tree, state, prealloc, end + 1);
 		BUG_ON(err == -EEXIST);
 
-		set_state_bits(tree, prealloc, bits);
+		prealloc->split_start = split_start;
+		prealloc->split_end = split_end;
+		split_start = 0;
+		split_end = 0;
+		err = set_state_bits(tree, prealloc, bits);
+		if (err) {
+			prealloc = NULL;
+			goto out;
+		}
 		cache_state(prealloc, cached_state);
 		merge_state(tree, prealloc);
 		prealloc = NULL;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 75d4445..6ac57db 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -60,8 +60,11 @@ struct extent_io_ops {
 				      struct extent_state *state, int uptodate);
 	int (*set_bit_hook)(struct inode *inode, u64 start, u64 end,
 			    unsigned long old, unsigned long bits);
-	int (*clear_bit_hook)(struct inode *inode, u64 start, u64 end,
-			    unsigned long old, unsigned long bits);
+	int (*clear_bit_hook)(struct inode *inode, struct extent_state *state,
+			      unsigned long bits);
+	int (*merge_extent_hook)(struct inode *inode,
+				 struct extent_state *new,
+				 struct extent_state *old);
 	int (*write_cache_pages_lock_hook)(struct page *page);
 };
 
@@ -79,10 +82,14 @@ struct extent_state {
 	u64 start;
 	u64 end; /* inclusive */
 	struct rb_node rb_node;
+
+	/* ADD NEW ELEMENTS AFTER THIS */
 	struct extent_io_tree *tree;
 	wait_queue_head_t wq;
 	atomic_t refs;
 	unsigned long state;
+	u64 split_start;
+	u64 split_end;
 
 	/* for use by the FS */
 	u64 private;
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index ef66c3d..c1c11f5 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -124,7 +124,10 @@ static noinline int dirty_and_release_pages(struct btrfs_trans_handle *trans,
 		    root->sectorsize - 1) & ~((u64)root->sectorsize - 1);
 
 	end_of_last_block = start_pos + num_bytes - 1;
-	btrfs_set_extent_delalloc(inode, start_pos, end_of_last_block);
+	err = btrfs_set_extent_delalloc(inode, start_pos, end_of_last_block);
+	if (err)
+		return err;
+
 	for (i = 0; i < num_pages; i++) {
 		struct page *p = pages[i];
 		SetPageUptodate(p);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3c997d1..101d5d2 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1149,6 +1149,58 @@ static int run_delalloc_range(struct inode *inode, struct page *locked_page,
 }
 
 /*
+ * extent_io.c merge_extent_hook, used to track merged delayed allocation
+ * extents so we can keep track of new extents that are just merged onto old
+ * extents, such as when we are doing sequential writes, so we can properly
+ * account for the metadata space we'll need.
+ */
+static int btrfs_merge_extent_hook(struct inode *inode,
+				   struct extent_state *new,
+				   struct extent_state *old)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	u64 old_size, new_size, num_extents;
+
+	/* not delalloc, ignore it */
+	if (!(old->state & EXTENT_DELALLOC))
+		return 0;
+
+	/*
+	 * we're merging an extent that existed before and was split off the
+	 * extent we are merging it onto, so don't do anything.
+	 */
+	if (new->split_end || new->split_start)
+		return 0;
+
+	old_size = old->end - old->start + 1;
+
+	if (new->start < old->start)
+		new_size = old->end - new->start + 1;
+	else
+		new_size = new->end - old->start + 1;
+
+	/* we're not bigger than the max, unreserve the space and go */
+	if (new_size <= root->fs_info->max_extent) {
+		btrfs_unreserve_metadata_space(root, 1);
+		return 0;
+	}
+
+	/*
+	 * If we grew by another max_extent, just return, we want to keep that
+	 * reserved amount.
+	 */
+	num_extents = div64_u64(old_size + root->fs_info->max_extent - 1,
+				root->fs_info->max_extent);
+	if (div64_u64(new_size + root->fs_info->max_extent - 1,
+		      root->fs_info->max_extent) > num_extents)
+		return 0;
+
+	btrfs_unreserve_metadata_space(root, 1);
+
+	return 0;
+}
+
+/*
  * extent_io.c set_bit_hook, used to track delayed allocation
  * bytes in this file, and to maintain the list of inodes that
  * have pending delalloc work to be done.
@@ -1156,6 +1208,8 @@ static int run_delalloc_range(struct inode *inode, struct page *locked_page,
 static int btrfs_set_bit_hook(struct inode *inode, u64 start, u64 end,
 		       unsigned long old, unsigned long bits)
 {
+	int ret;
+
 	/*
 	 * set_bit and clear bit hooks normally require _irqsave/restore
 	 * but in this case, we are only testeing for the DELALLOC
@@ -1163,6 +1217,10 @@ static int btrfs_set_bit_hook(struct inode *inode, u64 start, u64 end,
 	 */
 	if (!(old & EXTENT_DELALLOC) && (bits & EXTENT_DELALLOC)) {
 		struct btrfs_root *root = BTRFS_I(inode)->root;
+
+		ret = btrfs_reserve_metadata_space(root, 1);
+		if (ret)
+			return ret;
 		btrfs_delalloc_reserve_space(root, inode, end - start + 1);
 		spin_lock(&root->fs_info->delalloc_lock);
 		BTRFS_I(inode)->delalloc_bytes += end - start + 1;
@@ -1179,22 +1237,71 @@ static int btrfs_set_bit_hook(struct inode *inode, u64 start, u64 end,
 /*
  * extent_io.c clear_bit_hook, see set_bit_hook for why
  */
-static int btrfs_clear_bit_hook(struct inode *inode, u64 start, u64 end,
-			 unsigned long old, unsigned long bits)
+static int btrfs_clear_bit_hook(struct inode *inode,
+				struct extent_state *state, unsigned long bits)
 {
 	/*
 	 * set_bit and clear bit hooks normally require _irqsave/restore
 	 * but in this case, we are only testeing for the DELALLOC
 	 * bit, which is only set or cleared with irqs on
 	 */
-	if ((old & EXTENT_DELALLOC) && (bits & EXTENT_DELALLOC)) {
+	if ((state->state & EXTENT_DELALLOC) && (bits & EXTENT_DELALLOC)) {
 		struct btrfs_root *root = BTRFS_I(inode)->root;
 
+		/*
+		 * Ok we're freeing up a part of a larger extent, we need to
+		 * figure out if it warrants unreserving the metadata space for
+		 * this extent.
+		 */
+		if (state->split_start || state->split_end) {
+			u64 old_size, new_size, max_extent;
+
+			max_extent = root->fs_info->max_extent;
+			if (state->split_start && state->split_end)
+				old_size = state->split_end -
+					state->split_start + 1;
+			else if (state->split_start)
+				old_size = state->end - state->split_start + 1;
+			else
+				old_size = state->split_end - state->start + 1;
+
+			new_size = old_size - (state->end - state->state + 1);
+
+			/*
+			 * the only way we want to unreserve metadata space is
+			 * if this extent was larger than a max extent, and we
+			 * made it smaller than a max_extent multiple.  The idea
+			 * here is we only need 1 item worth of metadata space
+			 * reserved per max_extent range of data.  So if we've
+			 * taken a big extent and made it smaller than a
+			 * multiple of max_extent, we don't have to worry about
+			 * its reserved space anymore
+			 */
+			if (old_size > max_extent) {
+				u64 num_extents;
+
+				num_extents =
+					div64_u64(old_size + max_extent - 1,
+						  max_extent);
+				if (div64_u64(new_size + max_extent - 1,
+					      max_extent) < num_extents)
+					btrfs_unreserve_metadata_space(root, 1);
+			}
+		} else {
+			/*
+			 * if this state was not split off of a larger node, we
+			 * need to unreserve its metadata space.
+			 */
+			btrfs_unreserve_metadata_space(root, 1);
+		}
+
 		spin_lock(&root->fs_info->delalloc_lock);
-		if (end - start + 1 > root->fs_info->delalloc_bytes) {
+		if (state->end - state->start + 1 >
+		    root->fs_info->delalloc_bytes) {
 			printk(KERN_INFO "btrfs warning: delalloc account "
 			       "%llu %llu\n",
-			       (unsigned long long)end - start + 1,
+			       (unsigned long long)
+			       state->end - state->start + 1,
 			       (unsigned long long)
 			       root->fs_info->delalloc_bytes);
 			btrfs_delalloc_free_space(root, inode, (u64)-1);
@@ -1202,9 +1309,12 @@ static int btrfs_clear_bit_hook(struct inode *inode, u64 start, u64 end,
 			BTRFS_I(inode)->delalloc_bytes = 0;
 		} else {
 			btrfs_delalloc_free_space(root, inode,
-						  end - start + 1);
-			root->fs_info->delalloc_bytes -= end - start + 1;
-			BTRFS_I(inode)->delalloc_bytes -= end - start + 1;
+						  state->end -
+						  state->start + 1);
+			root->fs_info->delalloc_bytes -= state->end -
+				state->start + 1;
+			BTRFS_I(inode)->delalloc_bytes -= state->end -
+				state->start + 1;
 		}
 		if (BTRFS_I(inode)->delalloc_bytes == 0 &&
 		    !list_empty(&BTRFS_I(inode)->delalloc_inodes)) {
@@ -2777,7 +2887,12 @@ again:
 		goto again;
 	}
 
-	btrfs_set_extent_delalloc(inode, page_start, page_end);
+	ret = btrfs_set_extent_delalloc(inode, page_start, page_end);
+	if (ret) {
+		unlock_extent(io_tree, page_start, page_end, GFP_NOFS);
+		goto out_unlock;
+	}
+
 	ret = 0;
 	if (offset != PAGE_CACHE_SIZE) {
 		kaddr = kmap(page);
@@ -2808,15 +2923,11 @@ int btrfs_cont_expand(struct inode *inode, loff_t size)
 	u64 last_byte;
 	u64 cur_offset;
 	u64 hole_size;
-	int err;
+	int err = 0;
 
 	if (size <= hole_start)
 		return 0;
 
-	err = btrfs_check_metadata_free_space(root);
-	if (err)
-		return err;
-
 	btrfs_truncate_page(inode->i_mapping, inode->i_size);
 
 	while (1) {
@@ -2851,12 +2962,18 @@ int btrfs_cont_expand(struct inode *inode, loff_t size)
 						 cur_offset, &hint_byte);
 			if (err)
 				break;
+
+			err = btrfs_reserve_metadata_space(root, 1);
+			if (err)
+				break;
+
 			err = btrfs_insert_file_extent(trans, root,
 					inode->i_ino, cur_offset, 0,
 					0, hole_size, 0, hole_size,
 					0, 0, 0);
 			btrfs_drop_extent_cache(inode, hole_start,
 					last_byte - 1, 0);
+			btrfs_unreserve_metadata_space(root, 1);
 		}
 		free_extent_map(em);
 		cur_offset = last_byte;
@@ -3641,11 +3758,18 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
 	if (!new_valid_dev(rdev))
 		return -EINVAL;
 
-	err = btrfs_check_metadata_free_space(root);
+	/*
+	 * 2 for inode item and ref
+	 * 2 for dir items
+	 * 1 for xattr if selinux is on
+	 */
+	err = btrfs_reserve_metadata_space(root, 5);
 	if (err)
-		goto fail;
+		return err;
 
 	trans = btrfs_start_transaction(root, 1);
+	if (!trans)
+		goto fail;
 	btrfs_set_trans_block_group(trans, dir);
 
 	err = btrfs_find_free_objectid(trans, root, dir->i_ino, &objectid);
@@ -3684,6 +3808,7 @@ out_unlock:
 	nr = trans->blocks_used;
 	btrfs_end_transaction_throttle(trans, root);
 fail:
+	btrfs_unreserve_metadata_space(root, 5);
 	if (drop_inode) {
 		inode_dec_link_count(inode);
 		iput(inode);
@@ -3704,10 +3829,18 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 	u64 objectid;
 	u64 index = 0;
 
-	err = btrfs_check_metadata_free_space(root);
+	/*
+	 * 2 for inode item and ref
+	 * 2 for dir items
+	 * 1 for xattr if selinux is on
+	 */
+	err = btrfs_reserve_metadata_space(root, 5);
 	if (err)
-		goto fail;
+		return err;
+
 	trans = btrfs_start_transaction(root, 1);
+	if (!trans)
+		goto fail;
 	btrfs_set_trans_block_group(trans, dir);
 
 	err = btrfs_find_free_objectid(trans, root, dir->i_ino, &objectid);
@@ -3749,6 +3882,7 @@ out_unlock:
 	nr = trans->blocks_used;
 	btrfs_end_transaction_throttle(trans, root);
 fail:
+	btrfs_unreserve_metadata_space(root, 5);
 	if (drop_inode) {
 		inode_dec_link_count(inode);
 		iput(inode);
@@ -3771,10 +3905,16 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	if (inode->i_nlink == 0)
 		return -ENOENT;
 
-	btrfs_inc_nlink(inode);
-	err = btrfs_check_metadata_free_space(root);
+	/*
+	 * 1 item for inode ref
+	 * 2 items for dir items
+	 */
+	err = btrfs_reserve_metadata_space(root, 3);
 	if (err)
-		goto fail;
+		return err;
+
+	btrfs_inc_nlink(inode);
+
 	err = btrfs_set_inode_index(dir, &index);
 	if (err)
 		goto fail;
@@ -3801,6 +3941,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	btrfs_log_new_name(trans, inode, NULL, dentry->d_parent);
 	btrfs_end_transaction_throttle(trans, root);
 fail:
+	btrfs_unreserve_metadata_space(root, 3);
 	if (drop_inode) {
 		inode_dec_link_count(inode);
 		iput(inode);
@@ -3820,17 +3961,21 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	u64 index = 0;
 	unsigned long nr = 1;
 
-	err = btrfs_check_metadata_free_space(root);
+	/*
+	 * 2 items for inode and ref
+	 * 2 items for dir items
+	 * 1 for xattr if selinux is on
+	 */
+	err = btrfs_reserve_metadata_space(root, 5);
 	if (err)
-		goto out_unlock;
+		return err;
 
 	trans = btrfs_start_transaction(root, 1);
-	btrfs_set_trans_block_group(trans, dir);
-
-	if (IS_ERR(trans)) {
-		err = PTR_ERR(trans);
+	if (!trans) {
+		err = -ENOMEM;
 		goto out_unlock;
 	}
+	btrfs_set_trans_block_group(trans, dir);
 
 	err = btrfs_find_free_objectid(trans, root, dir->i_ino, &objectid);
 	if (err) {
@@ -3880,6 +4025,7 @@ out_fail:
 	btrfs_end_transaction_throttle(trans, root);
 
 out_unlock:
+	btrfs_unreserve_metadata_space(root, 5);
 	if (drop_on_err)
 		iput(inode);
 	btrfs_btree_balance_dirty(root, nr);
@@ -4416,7 +4562,12 @@ again:
 		goto again;
 	}
 
-	btrfs_set_extent_delalloc(inode, page_start, page_end);
+	ret = btrfs_set_extent_delalloc(inode, page_start, page_end);
+	if (ret) {
+		unlock_extent(io_tree, page_start, page_end, GFP_NOFS);
+		ret = VM_FAULT_SIGBUS;
+		goto out_unlock;
+	}
 	ret = 0;
 
 	/* page is wholly or partially inside EOF */
@@ -4704,9 +4855,14 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (old_inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)
 		return -EXDEV;
 
-	ret = btrfs_check_metadata_free_space(root);
+	/*
+	 * 2 items for dir items
+	 * 1 item for orphan entry
+	 * 1 item for ref
+	 */
+	ret = btrfs_reserve_metadata_space(root, 4);
 	if (ret)
-		goto out_unlock;
+		return ret;
 
 	/*
 	 * we're using rename to replace one file with another.
@@ -4787,7 +4943,7 @@ out_fail:
 	 */
 	btrfs_end_log_trans(root);
 	btrfs_end_transaction_throttle(trans, root);
-out_unlock:
+	btrfs_unreserve_metadata_space(root, 4);
 	return ret;
 }
 
@@ -4859,11 +5015,18 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 	if (name_len > BTRFS_MAX_INLINE_DATA_SIZE(root))
 		return -ENAMETOOLONG;
 
-	err = btrfs_check_metadata_free_space(root);
+	/*
+	 * 2 items for inode item and ref
+	 * 2 items for dir items
+	 * 1 item for xattr if selinux is on
+	 */
+	err = btrfs_reserve_metadata_space(root, 5);
 	if (err)
-		goto out_fail;
+		return err;
 
 	trans = btrfs_start_transaction(root, 1);
+	if (!trans)
+		goto out_fail;
 	btrfs_set_trans_block_group(trans, dir);
 
 	err = btrfs_find_free_objectid(trans, root, dir->i_ino, &objectid);
@@ -4945,6 +5108,7 @@ out_unlock:
 	nr = trans->blocks_used;
 	btrfs_end_transaction_throttle(trans, root);
 out_fail:
+	btrfs_unreserve_metadata_space(root, 5);
 	if (drop_inode) {
 		inode_dec_link_count(inode);
 		iput(inode);
@@ -4966,6 +5130,11 @@ static int prealloc_file_range(struct btrfs_trans_handle *trans,
 
 	while (num_bytes > 0) {
 		alloc_size = min(num_bytes, root->fs_info->max_extent);
+
+		ret = btrfs_reserve_metadata_space(root, 1);
+		if (ret)
+			goto out;
+
 		ret = btrfs_reserve_extent(trans, root, alloc_size,
 					   root->sectorsize, 0, alloc_hint,
 					   (u64)-1, &ins, 1);
@@ -4983,6 +5152,7 @@ static int prealloc_file_range(struct btrfs_trans_handle *trans,
 		num_bytes -= ins.offset;
 		cur_offset += ins.offset;
 		alloc_hint = ins.objectid + ins.offset;
+		btrfs_unreserve_metadata_space(root, 1);
 	}
 out:
 	if (cur_offset > start) {
@@ -5166,6 +5336,7 @@ static struct extent_io_ops btrfs_extent_io_ops = {
 	.readpage_io_failed_hook = btrfs_io_failed_hook,
 	.set_bit_hook = btrfs_set_bit_hook,
 	.clear_bit_hook = btrfs_clear_bit_hook,
+	.merge_extent_hook = btrfs_merge_extent_hook,
 };
 
 /*
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9f4db84..d26e92b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -240,7 +240,13 @@ static noinline int create_subvol(struct btrfs_root *root,
 	u64 index = 0;
 	unsigned long nr = 1;
 
-	ret = btrfs_check_metadata_free_space(root);
+	/*
+	 * 1 - inode item
+	 * 2 - refs
+	 * 1 - root item
+	 * 2 - dir items
+	 */
+	ret = btrfs_reserve_metadata_space(root, 6);
 	if (ret)
 		goto fail_commit;
 
@@ -359,6 +365,7 @@ fail:
 	err = btrfs_commit_transaction(trans, new_root);
 	if (err && !ret)
 		ret = err;
+	btrfs_unreserve_metadata_space(root, 6);
 fail_commit:
 	btrfs_btree_balance_dirty(root, nr);
 	return ret;
@@ -376,19 +383,27 @@ static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
 	if (!root->ref_cows)
 		return -EINVAL;
 
-	ret = btrfs_check_metadata_free_space(root);
+	/*
+	 * 1 - inode item
+	 * 2 - refs
+	 * 1 - root item
+	 * 2 - dir items
+	 */
+	ret = btrfs_reserve_metadata_space(root, 6);
 	if (ret)
 		goto fail_unlock;
 
 	pending_snapshot = kzalloc(sizeof(*pending_snapshot), GFP_NOFS);
 	if (!pending_snapshot) {
 		ret = -ENOMEM;
+		btrfs_unreserve_metadata_space(root, 6);
 		goto fail_unlock;
 	}
 	pending_snapshot->name = kmalloc(namelen + 1, GFP_NOFS);
 	if (!pending_snapshot->name) {
 		ret = -ENOMEM;
 		kfree(pending_snapshot);
+		btrfs_unreserve_metadata_space(root, 6);
 		goto fail_unlock;
 	}
 	memcpy(pending_snapshot->name, name, namelen);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 6ed6186..ac960cd 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -187,6 +187,9 @@ static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
 	h->alloc_exclude_start = 0;
 	h->delayed_ref_updates = 0;
 
+	if (!current->journal_info)
+		current->journal_info = h;
+
 	root->fs_info->running_transaction->use_count++;
 	record_root_in_trans(h, root);
 	mutex_unlock(&root->fs_info->trans_mutex);
@@ -318,6 +321,9 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 		wake_up(&cur_trans->writer_wait);
 	put_transaction(cur_trans);
 	mutex_unlock(&info->trans_mutex);
+
+	if (current->journal_info == trans)
+		current->journal_info = NULL;
 	memset(trans, 0, sizeof(*trans));
 	kmem_cache_free(btrfs_trans_handle_cachep, trans);
 
@@ -743,6 +749,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	memcpy(&pending->root_key, &key, sizeof(key));
 fail:
 	kfree(new_root_item);
+	btrfs_unreserve_metadata_space(root, 6);
 	return ret;
 }
 
@@ -1069,6 +1076,9 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 
 	mutex_unlock(&root->fs_info->trans_mutex);
 
+	if (current->journal_info == trans)
+		current->journal_info = NULL;
+
 	kmem_cache_free(btrfs_trans_handle_cachep, trans);
 	return ret;
 }
-- 
1.5.4.3

