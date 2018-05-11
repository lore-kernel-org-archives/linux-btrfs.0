Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:35109 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751705AbeEKALn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 20:11:43 -0400
Received: by mail-pl0-f65.google.com with SMTP id i5-v6so2223926plt.2
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 17:11:43 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH v2 09/12] Btrfs: get rid of root->orphan_block_rsv and root->orphan_lock
Date: Thu, 10 May 2018 17:11:19 -0700
Message-Id: <3946593616721a5569c4fa78e7e01a3e4715c376.1525997057.git.osandov@fb.com>
In-Reply-To: <cover.1525997057.git.osandov@fb.com>
References: <cover.1525997057.git.osandov@fb.com>
In-Reply-To: <cover.1525997057.git.osandov@fb.com>
References: <cover.1525997057.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Now that we don't keep long-standing reservations for orphan items,
root->orphan_block_rsv isn't used. We can git rid of it and
root->orphan_lock, which was used to protect it.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/ctree.h       |  5 -----
 fs/btrfs/disk-io.c     |  8 --------
 fs/btrfs/extent-tree.c | 38 --------------------------------------
 fs/btrfs/inode.c       | 41 ++++++-----------------------------------
 4 files changed, 6 insertions(+), 86 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2771cc56a622..d66241a35fab 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1219,9 +1219,7 @@ struct btrfs_root {
 	spinlock_t log_extents_lock[2];
 	struct list_head logged_list[2];
 
-	spinlock_t orphan_lock;
 	atomic_t orphan_inodes;
-	struct btrfs_block_rsv *orphan_block_rsv;
 	int orphan_cleanup_state;
 
 	spinlock_t inode_lock;
@@ -2764,9 +2762,6 @@ void btrfs_delalloc_release_space(struct inode *inode,
 void btrfs_free_reserved_data_space_noquota(struct inode *inode, u64 start,
 					    u64 len);
 void btrfs_trans_release_chunk_metadata(struct btrfs_trans_handle *trans);
-int btrfs_orphan_reserve_metadata(struct btrfs_trans_handle *trans,
-				  struct btrfs_inode *inode);
-void btrfs_orphan_release_metadata(struct btrfs_inode *inode);
 int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 				     struct btrfs_block_rsv *rsv,
 				     int nitems,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 60caa68c3618..24e15e2080f4 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1185,7 +1185,6 @@ static void __setup_root(struct btrfs_root *root, struct btrfs_fs_info *fs_info,
 	root->inode_tree = RB_ROOT;
 	INIT_RADIX_TREE(&root->delayed_nodes_tree, GFP_ATOMIC);
 	root->block_rsv = NULL;
-	root->orphan_block_rsv = NULL;
 
 	INIT_LIST_HEAD(&root->dirty_list);
 	INIT_LIST_HEAD(&root->root_list);
@@ -1195,7 +1194,6 @@ static void __setup_root(struct btrfs_root *root, struct btrfs_fs_info *fs_info,
 	INIT_LIST_HEAD(&root->ordered_root);
 	INIT_LIST_HEAD(&root->logged_list[0]);
 	INIT_LIST_HEAD(&root->logged_list[1]);
-	spin_lock_init(&root->orphan_lock);
 	spin_lock_init(&root->inode_lock);
 	spin_lock_init(&root->delalloc_lock);
 	spin_lock_init(&root->ordered_extent_lock);
@@ -3674,8 +3672,6 @@ static void free_fs_root(struct btrfs_root *root)
 {
 	iput(root->ino_cache_inode);
 	WARN_ON(!RB_EMPTY_ROOT(&root->inode_tree));
-	btrfs_free_block_rsv(root->fs_info, root->orphan_block_rsv);
-	root->orphan_block_rsv = NULL;
 	if (root->anon_dev)
 		free_anon_bdev(root->anon_dev);
 	if (root->subv_writers)
@@ -3766,7 +3762,6 @@ int btrfs_commit_super(struct btrfs_fs_info *fs_info)
 
 void close_ctree(struct btrfs_fs_info *fs_info)
 {
-	struct btrfs_root *root = fs_info->tree_root;
 	int ret;
 
 	set_bit(BTRFS_FS_CLOSING_START, &fs_info->flags);
@@ -3861,9 +3856,6 @@ void close_ctree(struct btrfs_fs_info *fs_info)
 	btrfs_free_stripe_hash_table(fs_info);
 	btrfs_free_ref_cache(fs_info);
 
-	__btrfs_free_block_rsv(root->orphan_block_rsv);
-	root->orphan_block_rsv = NULL;
-
 	while (!list_empty(&fs_info->pinned_chunks)) {
 		struct extent_map *em;
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 51b5e2da708c..3f2e026bc206 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5949,44 +5949,6 @@ void btrfs_trans_release_chunk_metadata(struct btrfs_trans_handle *trans)
 	trans->chunk_bytes_reserved = 0;
 }
 
-/* Can only return 0 or -ENOSPC */
-int btrfs_orphan_reserve_metadata(struct btrfs_trans_handle *trans,
-				  struct btrfs_inode *inode)
-{
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
-	struct btrfs_root *root = inode->root;
-	/*
-	 * We always use trans->block_rsv here as we will have reserved space
-	 * for our orphan when starting the transaction, using get_block_rsv()
-	 * here will sometimes make us choose the wrong block rsv as we could be
-	 * doing a reloc inode for a non refcounted root.
-	 */
-	struct btrfs_block_rsv *src_rsv = trans->block_rsv;
-	struct btrfs_block_rsv *dst_rsv = root->orphan_block_rsv;
-
-	/*
-	 * We need to hold space in order to delete our orphan item once we've
-	 * added it, so this takes the reservation so we can release it later
-	 * when we are truly done with the orphan item.
-	 */
-	u64 num_bytes = btrfs_calc_trans_metadata_size(fs_info, 1);
-
-	trace_btrfs_space_reservation(fs_info, "orphan", btrfs_ino(inode),
-			num_bytes, 1);
-	return btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes, 1);
-}
-
-void btrfs_orphan_release_metadata(struct btrfs_inode *inode)
-{
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
-	struct btrfs_root *root = inode->root;
-	u64 num_bytes = btrfs_calc_trans_metadata_size(fs_info, 1);
-
-	trace_btrfs_space_reservation(fs_info, "orphan", btrfs_ino(inode),
-			num_bytes, 0);
-	btrfs_block_rsv_release(fs_info, root->orphan_block_rsv, num_bytes);
-}
-
 /*
  * btrfs_subvolume_reserve_metadata() - reserve space for subvolume operation
  * root: the root of the parent directory
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b9a046b8c72c..50f10882a715 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3293,37 +3293,18 @@ void btrfs_run_delayed_iputs(struct btrfs_fs_info *fs_info)
 }
 
 /*
- * This is called in transaction commit time. If there are no orphan
- * files in the subvolume, it removes orphan item and frees block_rsv
- * structure.
+ * This is called in transaction commit time. If there are no orphan files in
+ * the subvolume, it removes the orphan item.
  */
 void btrfs_orphan_commit_root(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
-	struct btrfs_block_rsv *block_rsv;
 	int ret;
 
-	if (atomic_read(&root->orphan_inodes) ||
-	    root->orphan_cleanup_state != ORPHAN_CLEANUP_DONE)
-		return;
-
-	spin_lock(&root->orphan_lock);
-	if (atomic_read(&root->orphan_inodes)) {
-		spin_unlock(&root->orphan_lock);
-		return;
-	}
-
-	if (root->orphan_cleanup_state != ORPHAN_CLEANUP_DONE) {
-		spin_unlock(&root->orphan_lock);
-		return;
-	}
-
-	block_rsv = root->orphan_block_rsv;
-	root->orphan_block_rsv = NULL;
-	spin_unlock(&root->orphan_lock);
-
-	if (test_bit(BTRFS_ROOT_ORPHAN_ITEM_INSERTED, &root->state) &&
+	if (atomic_read(&root->orphan_inodes) == 0 &&
+	    root->orphan_cleanup_state == ORPHAN_CLEANUP_DONE &&
+	    test_bit(BTRFS_ROOT_ORPHAN_ITEM_INSERTED, &root->state) &&
 	    btrfs_root_refs(&root->root_item) > 0) {
 		ret = btrfs_del_orphan_item(trans, fs_info->tree_root,
 					    root->root_key.objectid);
@@ -3333,11 +3314,6 @@ void btrfs_orphan_commit_root(struct btrfs_trans_handle *trans,
 			clear_bit(BTRFS_ROOT_ORPHAN_ITEM_INSERTED,
 				  &root->state);
 	}
-
-	if (block_rsv) {
-		WARN_ON(block_rsv->size > 0);
-		btrfs_free_block_rsv(fs_info, block_rsv);
-	}
 }
 
 /*
@@ -3562,12 +3538,7 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 
 	root->orphan_cleanup_state = ORPHAN_CLEANUP_DONE;
 
-	if (root->orphan_block_rsv)
-		btrfs_block_rsv_release(fs_info, root->orphan_block_rsv,
-					(u64)-1);
-
-	if (root->orphan_block_rsv ||
-	    test_bit(BTRFS_ROOT_ORPHAN_ITEM_INSERTED, &root->state)) {
+	if (test_bit(BTRFS_ROOT_ORPHAN_ITEM_INSERTED, &root->state)) {
 		trans = btrfs_join_transaction(root);
 		if (!IS_ERR(trans))
 			btrfs_end_transaction(trans);
-- 
2.17.0

