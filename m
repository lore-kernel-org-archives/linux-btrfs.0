From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix enospc problems with delalloc
Date: Fri, 15 Jul 2011 11:16:44 -0400
Message-ID: <1310743004-11349-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

So I had this brilliant idea to use atomic counters for outstanding and reserved
extents, but this turned out to be a bad idea.  Consider this where we have 1
outstanding extent and 1 reserved extent

Reserver				Releaser
					atomic_dec(outstanding) now 0
atomic_read(outstanding)+1 get 1
atomic_read(reserved) get 1
don't actually reserve anything because
they are the same
					atomic_cmpxchg(reserved, 1, 0)
atomic_inc(outstanding)
atomic_add(0, reserved)
					free reserved space for 1 extent

Then the reserver now has no actual space reserved for it, and when it goes to
finish the ordered IO it won't have enough space to do it's allocation and you
get those lovely warnings.

Secondly we've been adding the size of the checksum items required for the
extents as part of our reservation, so for 4k blocks we get 512 bytes, which
isn't right because we need to reserve the space for cow'ing the blocks in the
tree just like anything else.  So instead just take the number of extent's we're
reserving and multiply by 2 and hope and pray thats enough.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/btrfs_inode.h |    7 ++-
 fs/btrfs/ctree.h       |    2 +-
 fs/btrfs/extent-tree.c |  106 +++++++++++++++++++++++++++---------------------
 fs/btrfs/file.c        |    8 ++-
 fs/btrfs/inode.c       |   35 ++++++++++-----
 fs/btrfs/ioctl.c       |    4 +-
 6 files changed, 97 insertions(+), 65 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 25e2ceb..717951b 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -34,6 +34,9 @@ struct btrfs_inode {
 	 */
 	struct btrfs_key location;
 
+	/* Lock for counters */
+	spinlock_t lock;
+
 	/* the extent_tree has caches of all the extent mappings to disk */
 	struct extent_map_tree extent_tree;
 
@@ -129,8 +132,8 @@ struct btrfs_inode {
 	 * items we think we'll end up using, and reserved_extents is the number
 	 * of extent items we've reserved metadata for.
 	 */
-	atomic_t outstanding_extents;
-	atomic_t reserved_extents;
+	unsigned outstanding_extents;
+	unsigned reserved_extents;
 
 	/*
 	 * ordered_data_close is set by truncate when a file that used
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index be02cae..3ba4d5f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2133,7 +2133,7 @@ static inline bool btrfs_mixed_space_info(struct btrfs_space_info *space_info)
 
 /* extent-tree.c */
 static inline u64 btrfs_calc_trans_metadata_size(struct btrfs_root *root,
-						 int num_items)
+						 unsigned num_items)
 {
 	return (root->leafsize + root->nodesize * (BTRFS_MAX_LEVEL - 1)) *
 		3 * num_items;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 33e5205..c6a2daa 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3725,7 +3725,6 @@ int btrfs_block_rsv_check(struct btrfs_trans_handle *trans,
 	if (commit_trans) {
 		if (trans)
 			return -EAGAIN;
-
 		trans = btrfs_join_transaction(root);
 		BUG_ON(IS_ERR(trans));
 		ret = btrfs_commit_transaction(trans, root);
@@ -3945,18 +3944,36 @@ int btrfs_snap_reserve_metadata(struct btrfs_trans_handle *trans,
 	return block_rsv_migrate_bytes(src_rsv, dst_rsv, num_bytes);
 }
 
-static u64 calc_csum_metadata_size(struct inode *inode, u64 num_bytes)
+static unsigned drop_outstanding_extent(struct inode *inode)
 {
-	return num_bytes >>= 3;
+	unsigned dropped_extents = 0;
+
+	spin_lock(&BTRFS_I(inode)->lock);
+	BUG_ON(!BTRFS_I(inode)->outstanding_extents);
+	BTRFS_I(inode)->outstanding_extents--;
+
+	/*
+	 * If we have more or the same amount of outsanding extents than we have
+	 * reserved then we need to leave the reserved extents count alone.
+	 */
+	if (BTRFS_I(inode)->outstanding_extents >=
+	    BTRFS_I(inode)->reserved_extents)
+		goto out;
+
+	dropped_extents = BTRFS_I(inode)->reserved_extents -
+		BTRFS_I(inode)->outstanding_extents;
+	BTRFS_I(inode)->reserved_extents -= dropped_extents;
+out:
+	spin_unlock(&BTRFS_I(inode)->lock);
+	return dropped_extents;
 }
 
 int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_block_rsv *block_rsv = &root->fs_info->delalloc_block_rsv;
-	u64 to_reserve;
-	int nr_extents;
-	int reserved_extents;
+	u64 to_reserve = 0;
+	unsigned nr_extents = 0;
 	int ret;
 
 	if (btrfs_transaction_in_commit(root->fs_info))
@@ -3964,24 +3981,41 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 
 	num_bytes = ALIGN(num_bytes, root->sectorsize);
 
-	nr_extents = atomic_read(&BTRFS_I(inode)->outstanding_extents) + 1;
-	reserved_extents = atomic_read(&BTRFS_I(inode)->reserved_extents);
+	spin_lock(&BTRFS_I(inode)->lock);
+	BTRFS_I(inode)->outstanding_extents++;
+
+	if (BTRFS_I(inode)->outstanding_extents >
+	    BTRFS_I(inode)->reserved_extents) {
+		nr_extents = BTRFS_I(inode)->outstanding_extents -
+			BTRFS_I(inode)->reserved_extents;
+		BTRFS_I(inode)->reserved_extents += nr_extents;
 
-	if (nr_extents > reserved_extents) {
-		nr_extents -= reserved_extents;
+		/* For checksums we'll just reserve 2 leaves worth of metadata
+		 * and hope that works out right.
+		 *
+		 * NOTE:
+		 * The more correct way to do this would be to figure out how
+		 * much space we are going to write and figure out how many
+		 * checksums that comes out to and then adjust whenever we cross
+		 * a leafsize barrier.  But thats a huge pain in the ass, so
+		 * wing it and hope it comes out right :).
+		 */
+		nr_extents += nr_extents * 2;
 		to_reserve = btrfs_calc_trans_metadata_size(root, nr_extents);
-	} else {
-		nr_extents = 0;
-		to_reserve = 0;
 	}
+	spin_unlock(&BTRFS_I(inode)->lock);
 
-	to_reserve += calc_csum_metadata_size(inode, num_bytes);
 	ret = reserve_metadata_bytes(NULL, root, block_rsv, to_reserve, 1);
-	if (ret)
+	if (ret) {
+		unsigned dropped;
+		/*
+		 * We don't need the return value since our reservation failed,
+		 * we just need to clean up our counter.
+		 */
+		dropped = drop_outstanding_extent(inode);
+		WARN_ON(dropped > 1);
 		return ret;
-
-	atomic_add(nr_extents, &BTRFS_I(inode)->reserved_extents);
-	atomic_inc(&BTRFS_I(inode)->outstanding_extents);
+	}
 
 	block_rsv_add_bytes(block_rsv, to_reserve, 1);
 
@@ -3994,36 +4028,16 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	u64 to_free;
-	int nr_extents;
-	int reserved_extents;
+	u64 to_free = 0;
+	unsigned dropped;
 
 	num_bytes = ALIGN(num_bytes, root->sectorsize);
-	atomic_dec(&BTRFS_I(inode)->outstanding_extents);
-	WARN_ON(atomic_read(&BTRFS_I(inode)->outstanding_extents) < 0);
-
-	reserved_extents = atomic_read(&BTRFS_I(inode)->reserved_extents);
-	do {
-		int old, new;
-
-		nr_extents = atomic_read(&BTRFS_I(inode)->outstanding_extents);
-		if (nr_extents >= reserved_extents) {
-			nr_extents = 0;
-			break;
-		}
-		old = reserved_extents;
-		nr_extents = reserved_extents - nr_extents;
-		new = reserved_extents - nr_extents;
-		old = atomic_cmpxchg(&BTRFS_I(inode)->reserved_extents,
-				     reserved_extents, new);
-		if (likely(old == reserved_extents))
-			break;
-		reserved_extents = old;
-	} while (1);
+	dropped = drop_outstanding_extent(inode);
 
-	to_free = calc_csum_metadata_size(inode, num_bytes);
-	if (nr_extents > 0)
-		to_free += btrfs_calc_trans_metadata_size(root, nr_extents);
+	/* See btrfs_delalloc_reserve_metadata for an explanation */
+	dropped += dropped * 2;
+	if (dropped > 0)
+		to_free += btrfs_calc_trans_metadata_size(root, dropped);
 
 	btrfs_block_rsv_release(root, &root->fs_info->delalloc_block_rsv,
 				to_free);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 3c8c435..a35e51c 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1239,9 +1239,11 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 		 * managed to copy.
 		 */
 		if (num_pages > dirty_pages) {
-			if (copied > 0)
-				atomic_inc(
-					&BTRFS_I(inode)->outstanding_extents);
+			if (copied > 0) {
+				spin_lock(&BTRFS_I(inode)->lock);
+				BTRFS_I(inode)->outstanding_extents++;
+				spin_unlock(&BTRFS_I(inode)->lock);
+			}
 			btrfs_delalloc_release_space(inode,
 					(num_pages - dirty_pages) <<
 					PAGE_CACHE_SHIFT);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3a32131..2a37080 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1298,7 +1298,9 @@ static int btrfs_split_extent_hook(struct inode *inode,
 	if (!(orig->state & EXTENT_DELALLOC))
 		return 0;
 
-	atomic_inc(&BTRFS_I(inode)->outstanding_extents);
+	spin_lock(&BTRFS_I(inode)->lock);
+	BTRFS_I(inode)->outstanding_extents++;
+	spin_unlock(&BTRFS_I(inode)->lock);
 	return 0;
 }
 
@@ -1316,7 +1318,9 @@ static int btrfs_merge_extent_hook(struct inode *inode,
 	if (!(other->state & EXTENT_DELALLOC))
 		return 0;
 
-	atomic_dec(&BTRFS_I(inode)->outstanding_extents);
+	spin_lock(&BTRFS_I(inode)->lock);
+	BTRFS_I(inode)->outstanding_extents--;
+	spin_unlock(&BTRFS_I(inode)->lock);
 	return 0;
 }
 
@@ -1339,10 +1343,13 @@ static int btrfs_set_bit_hook(struct inode *inode,
 		u64 len = state->end + 1 - state->start;
 		bool do_list = !is_free_space_inode(root, inode);
 
-		if (*bits & EXTENT_FIRST_DELALLOC)
+		if (*bits & EXTENT_FIRST_DELALLOC) {
 			*bits &= ~EXTENT_FIRST_DELALLOC;
-		else
-			atomic_inc(&BTRFS_I(inode)->outstanding_extents);
+		} else {
+			spin_lock(&BTRFS_I(inode)->lock);
+			BTRFS_I(inode)->outstanding_extents++;
+			spin_unlock(&BTRFS_I(inode)->lock);
+		}
 
 		spin_lock(&root->fs_info->delalloc_lock);
 		BTRFS_I(inode)->delalloc_bytes += len;
@@ -1372,10 +1379,13 @@ static int btrfs_clear_bit_hook(struct inode *inode,
 		u64 len = state->end + 1 - state->start;
 		bool do_list = !is_free_space_inode(root, inode);
 
-		if (*bits & EXTENT_FIRST_DELALLOC)
+		if (*bits & EXTENT_FIRST_DELALLOC) {
 			*bits &= ~EXTENT_FIRST_DELALLOC;
-		else if (!(*bits & EXTENT_DO_ACCOUNTING))
-			atomic_dec(&BTRFS_I(inode)->outstanding_extents);
+		} else if (!(*bits & EXTENT_DO_ACCOUNTING)) {
+			spin_lock(&BTRFS_I(inode)->lock);
+			BTRFS_I(inode)->outstanding_extents--;
+			spin_unlock(&BTRFS_I(inode)->lock);
+		}
 
 		if (*bits & EXTENT_DO_ACCOUNTING)
 			btrfs_delalloc_release_metadata(inode, len);
@@ -6776,8 +6786,9 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	ei->index_cnt = (u64)-1;
 	ei->last_unlink_trans = 0;
 
-	atomic_set(&ei->outstanding_extents, 0);
-	atomic_set(&ei->reserved_extents, 0);
+	spin_lock_init(&ei->lock);
+	ei->outstanding_extents = 0;
+	ei->reserved_extents = 0;
 
 	ei->ordered_data_close = 0;
 	ei->orphan_meta_reserved = 0;
@@ -6815,8 +6826,8 @@ void btrfs_destroy_inode(struct inode *inode)
 
 	WARN_ON(!list_empty(&inode->i_dentry));
 	WARN_ON(inode->i_data.nrpages);
-	WARN_ON(atomic_read(&BTRFS_I(inode)->outstanding_extents));
-	WARN_ON(atomic_read(&BTRFS_I(inode)->reserved_extents));
+	WARN_ON(BTRFS_I(inode)->outstanding_extents);
+	WARN_ON(BTRFS_I(inode)->reserved_extents);
 
 	/*
 	 * This can happen where we create an inode, but somebody else also
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 09c9a8d..fd252ff 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -938,7 +938,9 @@ again:
 			  GFP_NOFS);
 
 	if (i_done != num_pages) {
-		atomic_inc(&BTRFS_I(inode)->outstanding_extents);
+		spin_lock(&BTRFS_I(inode)->lock);
+		BTRFS_I(inode)->outstanding_extents++;
+		spin_unlock(&BTRFS_I(inode)->lock);
 		btrfs_delalloc_release_space(inode,
 				     (num_pages - i_done) << PAGE_CACHE_SHIFT);
 	}
-- 
1.7.5.2

