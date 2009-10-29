From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: reserve space specifically for the extent root
Date: Thu, 29 Oct 2009 16:35:55 -0400
Message-ID: <20091029203554.GA3940@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If there are alot of snapshots we could conceivably end up using much more
metadata space than what the worst case calculation would come up with, so
instead of trying to figure out how many extents will be modified by changing
items, just calculate it per tree, and then reserve space specifically for the
extent root.  This patch does a max(size of extent root tree, 20% of free
metadata space) reservation for the extent root, and then tracks how much
space is used per transaction for the extent root.  Then if we get close to
this amount in our transaction we will force the commit of the transaction to
free up space.  This will help us better deal with the massive space
requirements that will come when users have alot of snapshots.  This was
tested with my normal enospc tests.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.h       |    2 +
 fs/btrfs/extent-tree.c |  115 +++++++++++++++++++++++++++++++++++++++++-------
 fs/btrfs/transaction.c |   19 +++++++-
 fs/btrfs/transaction.h |    1 +
 4 files changed, 119 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e5dd628..3e00df1 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2049,6 +2049,8 @@ void btrfs_delalloc_reserve_space(struct btrfs_root *root, struct inode *inode,
 				 u64 bytes);
 void btrfs_delalloc_free_space(struct btrfs_root *root, struct inode *inode,
 			      u64 bytes);
+int btrfs_check_reserved_extent_space(struct btrfs_trans_handle *trans,
+				      struct btrfs_root *root);
 /* ctree.c */
 int btrfs_bin_search(struct extent_buffer *eb, struct btrfs_key *key,
 		     int level, int *slot);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c56f916..7a1f1a4 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2768,6 +2768,12 @@ static u64 calculate_bytes_needed(struct btrfs_root *root, int num_items)
 	u64 num_bytes;
 	int level;
 
+	/*
+	 * The level is the number of node level's we could possibly cow.  So
+	 * since we track root item reservations seperately we don't need that,
+	 * and we don't need to count the leaf level, so the max number of
+	 * levels that could have nodes is MAX_LEVEL - 2.
+	 */
 	level = BTRFS_MAX_LEVEL - 2;
 	/*
 	 * NOTE: these calculations are absolutely the worst possible case.
@@ -2776,17 +2782,11 @@ static u64 calculate_bytes_needed(struct btrfs_root *root, int num_items)
 	 */
 
 	/*
-	 * for every item we insert we could insert both an extent item and a
-	 * extent ref item.  Then for ever item we insert, we will need to cow
-	 * both the original leaf, plus the leaf to the left and right of it.
-	 *
-	 * Unless we are talking about the extent root, then we just want the
-	 * number of items * 2, since we just need the extent item plus its ref.
+	 * For each item we need we'll assume that we're going to add a leaf for
+	 * it, and then we may cow the leaves on either side to make room for
+	 * the items we're inserting, so multiply by 3.
 	 */
-	if (root == root->fs_info->extent_root)
-		num_bytes = num_items * 2;
-	else
-		num_bytes = (num_items + (2 * num_items)) * 3;
+	num_bytes = num_items * 3;
 
 	/*
 	 * num_bytes is total number of leaves we could need times the leaf
@@ -3031,6 +3031,64 @@ out:
 }
 
 /*
+ * This checks how many bytes we've allocated for the extent tree vs. how much
+ * we reserved, and if we need to go ahead and force the transaction to commit.
+ */
+int btrfs_check_reserved_extent_space(struct btrfs_trans_handle *trans,
+				      struct btrfs_root *root)
+{
+	struct btrfs_fs_info *info = root->fs_info;
+	struct btrfs_space_info *meta_sinfo;
+	u64 used;
+	u64 alloc_target;
+
+	/* don't force a commit if this is an embedded transaction */
+	if (current->journal_info != trans)
+		return 0;
+
+	/* get the space info for where the metadata will live */
+	alloc_target = btrfs_get_alloc_profile(root, 0);
+	meta_sinfo = __find_space_info(info, alloc_target);
+
+	spin_lock(&meta_sinfo->lock);
+
+	if (unlikely(!meta_sinfo->bytes_root)) {
+		u64 bytes;
+
+		/*
+		 * somebody should have already reserved space before starting
+		 * the transaction, so WARN_ON so we can fix that person.
+		 */
+		WARN_ON(1);
+
+		used = meta_sinfo->bytes_used + meta_sinfo->bytes_reserved +
+			meta_sinfo->bytes_pinned + meta_sinfo->bytes_readonly +
+			meta_sinfo->bytes_super + meta_sinfo->bytes_root +
+			meta_sinfo->bytes_may_use + meta_sinfo->bytes_delalloc;
+
+		bytes = meta_sinfo->total_bytes - used;
+		meta_sinfo->bytes_root = calculate_bytes_needed(root, 6);
+		bytes *= 20;
+		bytes = div64_u64(bytes, 100);
+		bytes = max(bytes,
+			    btrfs_root_used(&info->extent_root->root_item));
+		meta_sinfo->bytes_root += bytes;
+	}
+
+	/* We'll set the threshold to say 5 megabytes just to be safe */
+	used = 1024 * 1024 * 5 + trans->transaction->extent_root_bytes;
+
+	if (meta_sinfo->bytes_root < used) {
+		spin_unlock(&meta_sinfo->lock);
+		btrfs_commit_transaction(trans, root);
+		return 1;
+	}
+	spin_unlock(&meta_sinfo->lock);
+
+	return 0;
+}
+
+/*
  * Reserve metadata space for delalloc.
  */
 int btrfs_reserve_metadata_for_delalloc(struct btrfs_root *root,
@@ -3055,9 +3113,6 @@ again:
 
 	force_delalloc = meta_sinfo->force_delalloc;
 
-	if (unlikely(!meta_sinfo->bytes_root))
-		meta_sinfo->bytes_root = calculate_bytes_needed(root, 6);
-
 	if (!flushed)
 		meta_sinfo->bytes_delalloc += num_bytes;
 
@@ -3066,6 +3121,17 @@ again:
 		meta_sinfo->bytes_super + meta_sinfo->bytes_root +
 		meta_sinfo->bytes_may_use + meta_sinfo->bytes_delalloc;
 
+	if (unlikely(!meta_sinfo->bytes_root)) {
+		u64 bytes = meta_sinfo->total_bytes - used;
+		meta_sinfo->bytes_root = calculate_bytes_needed(root, 6);
+		bytes *= 20;
+		bytes = div64_u64(bytes, 100);
+		bytes = max(bytes,
+			    btrfs_root_used(&info->extent_root->root_item));
+		meta_sinfo->bytes_root += bytes;
+		used += meta_sinfo->bytes_root;
+	}
+
 	if (used > meta_sinfo->total_bytes) {
 		flushed++;
 
@@ -3171,9 +3237,6 @@ int btrfs_reserve_metadata_space(struct btrfs_root *root, int num_items)
 again:
 	spin_lock(&meta_sinfo->lock);
 
-	if (unlikely(!meta_sinfo->bytes_root))
-		meta_sinfo->bytes_root = calculate_bytes_needed(root, 6);
-
 	if (!retries)
 		meta_sinfo->bytes_may_use += num_bytes;
 
@@ -3182,6 +3245,17 @@ again:
 		meta_sinfo->bytes_super + meta_sinfo->bytes_root +
 		meta_sinfo->bytes_may_use + meta_sinfo->bytes_delalloc;
 
+	if (unlikely(!meta_sinfo->bytes_root)) {
+		u64 bytes = meta_sinfo->total_bytes - used;
+		meta_sinfo->bytes_root = calculate_bytes_needed(root, 6);
+		bytes *= 20;
+		bytes = div64_u64(bytes, 100);
+		bytes = max(bytes,
+			    btrfs_root_used(&info->extent_root->root_item));
+		meta_sinfo->bytes_root += bytes;
+		used += meta_sinfo->bytes_root;
+	}
+
 	if (used > meta_sinfo->total_bytes) {
 		retries++;
 		if (retries == 1) {
@@ -3461,6 +3535,15 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 	else
 		old_val -= num_bytes;
 	btrfs_set_root_used(&root->root_item, old_val);
+
+	/*
+	 * keeping track of how many bytes we actually use for the extent tree
+	 * so we can force a transaction commit if it gets close to using the
+	 * reserved space.
+	 */
+	if (alloc && root == info->extent_root)
+		trans->transaction->extent_root_bytes += num_bytes;
+
 	spin_unlock(&info->delalloc_lock);
 
 	while (total) {
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index bca82a4..64881b7 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -68,6 +68,7 @@ static noinline int join_transaction(struct btrfs_root *root)
 		cur_trans->use_count = 1;
 		cur_trans->commit_done = 0;
 		cur_trans->start_time = get_seconds();
+		cur_trans->extent_root_bytes = 0;
 
 		cur_trans->delayed_refs.root.rb_node = NULL;
 		cur_trans->delayed_refs.num_entries = 0;
@@ -166,10 +167,14 @@ static void wait_current_trans(struct btrfs_root *root)
 static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
 					     int num_blocks, int wait)
 {
-	struct btrfs_trans_handle *h =
-		kmem_cache_alloc(btrfs_trans_handle_cachep, GFP_NOFS);
+	struct btrfs_trans_handle *h;
 	int ret;
 
+again:
+	h = kmem_cache_alloc(btrfs_trans_handle_cachep, GFP_NOFS);
+	if (!h)
+		return ERR_PTR(-ENOMEM);
+
 	mutex_lock(&root->fs_info->trans_mutex);
 	if (!root->fs_info->log_root_recovering &&
 	    ((wait == 1 && !root->fs_info->open_ioctl_trans) || wait == 2))
@@ -192,6 +197,16 @@ static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
 	root->fs_info->running_transaction->use_count++;
 	record_root_in_trans(h, root);
 	mutex_unlock(&root->fs_info->trans_mutex);
+
+	/*
+	 * If this is just a normal btrfs_start_trans then we want to check
+	 * and see if we are close to using the byte's we reserved for the
+	 * extent tree, and if so commit the transaction.
+	 */
+	if (wait == 1 && !root->fs_info->open_ioctl_trans &&
+	    btrfs_check_reserved_extent_space(h, root))
+		goto again;
+
 	return h;
 }
 
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index d4e3e7a..3ccbcae 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -41,6 +41,7 @@ struct btrfs_transaction {
 	wait_queue_head_t commit_wait;
 	struct list_head pending_snapshots;
 	struct btrfs_delayed_ref_root delayed_refs;
+	u64 extent_root_bytes;
 };
 
 struct btrfs_trans_handle {
-- 
1.5.4.3

