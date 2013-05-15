Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:62621 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756715Ab3EOHsm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 03:48:42 -0400
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: alex.btrfs@zadarastorage.com
Subject: [PATCH 08/17] Btrfs: introduce per-subvolume delalloc inode list
Date: Wed, 15 May 2013 15:48:22 +0800
Message-Id: <1368604111-25073-9-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
References: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we create a snapshot, we need flush all delalloc inodes in the
fs, just flushing the inodes in the source tree is OK. So we introduce
per-subvolume delalloc inode list.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       |  22 ++++---
 fs/btrfs/dev-replace.c |   2 +-
 fs/btrfs/disk-io.c     |  49 ++++++++++++---
 fs/btrfs/extent-tree.c |   6 +-
 fs/btrfs/inode.c       | 167 ++++++++++++++++++++++++++++++++++++-------------
 fs/btrfs/relocation.c  |   2 +-
 fs/btrfs/transaction.c |   2 +-
 7 files changed, 183 insertions(+), 67 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 958ce6c..067233f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1449,13 +1449,9 @@ struct btrfs_fs_info {
 	 */
 	struct list_head ordered_extents;
 
-	spinlock_t delalloc_lock;
-	/*
-	 * all of the inodes that have delalloc bytes.  It is possible for
-	 * this list to be empty even when there is still dirty data=ordered
-	 * extents waiting to finish IO.
-	 */
-	struct list_head delalloc_inodes;
+	spinlock_t delalloc_root_lock;
+	/* all fs/file tree roots that have delalloc inodes. */
+	struct list_head delalloc_roots;
 
 	/*
 	 * there is a pool of worker threads for checksumming during writes
@@ -1740,6 +1736,16 @@ struct btrfs_root {
 
 	spinlock_t root_item_lock;
 	atomic_t refs;
+
+	spinlock_t delalloc_lock;
+	/*
+	 * all of the inodes that have delalloc bytes.  It is possible for
+	 * this list to be empty even when there is still dirty data=ordered
+	 * extents waiting to finish IO.
+	 */
+	struct list_head delalloc_inodes;
+	struct list_head delalloc_root;
+	u64 nr_delalloc_inodes;
 };
 
 struct btrfs_ioctl_defrag_range_args {
@@ -3543,6 +3549,8 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 			       u32 min_type);
 
 int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput);
+int btrfs_start_all_delalloc_inodes(struct btrfs_fs_info *fs_info,
+				    int delay_iput);
 int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
 			      struct extent_state **cached_state);
 int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 7ba7b39..aca77ad 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -465,7 +465,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	 * flush all outstanding I/O and inode extent mappings before the
 	 * copy operation is declared as being finished
 	 */
-	ret = btrfs_start_delalloc_inodes(root, 0);
+	ret = btrfs_start_all_delalloc_inodes(root->fs_info, 0);
 	if (ret) {
 		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
 		return ret;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 724a0da..13dddba 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1191,6 +1191,7 @@ static void __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 	root->objectid = objectid;
 	root->last_trans = 0;
 	root->highest_objectid = 0;
+	root->nr_delalloc_inodes = 0;
 	root->name = NULL;
 	root->inode_tree = RB_ROOT;
 	INIT_RADIX_TREE(&root->delayed_nodes_tree, GFP_ATOMIC);
@@ -1199,10 +1200,13 @@ static void __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 
 	INIT_LIST_HEAD(&root->dirty_list);
 	INIT_LIST_HEAD(&root->root_list);
+	INIT_LIST_HEAD(&root->delalloc_inodes);
+	INIT_LIST_HEAD(&root->delalloc_root);
 	INIT_LIST_HEAD(&root->logged_list[0]);
 	INIT_LIST_HEAD(&root->logged_list[1]);
 	spin_lock_init(&root->orphan_lock);
 	spin_lock_init(&root->inode_lock);
+	spin_lock_init(&root->delalloc_lock);
 	spin_lock_init(&root->accounting_lock);
 	spin_lock_init(&root->log_extents_lock[0]);
 	spin_lock_init(&root->log_extents_lock[1]);
@@ -2137,9 +2141,9 @@ int open_ctree(struct super_block *sb,
 	INIT_LIST_HEAD(&fs_info->trans_list);
 	INIT_LIST_HEAD(&fs_info->dead_roots);
 	INIT_LIST_HEAD(&fs_info->delayed_iputs);
-	INIT_LIST_HEAD(&fs_info->delalloc_inodes);
+	INIT_LIST_HEAD(&fs_info->delalloc_roots);
 	INIT_LIST_HEAD(&fs_info->caching_block_groups);
-	spin_lock_init(&fs_info->delalloc_lock);
+	spin_lock_init(&fs_info->delalloc_root_lock);
 	spin_lock_init(&fs_info->trans_lock);
 	spin_lock_init(&fs_info->fs_roots_radix_lock);
 	spin_lock_init(&fs_info->delayed_iput_lock);
@@ -3801,24 +3805,49 @@ static void btrfs_destroy_delalloc_inodes(struct btrfs_root *root)
 
 	INIT_LIST_HEAD(&splice);
 
-	spin_lock(&root->fs_info->delalloc_lock);
-	list_splice_init(&root->fs_info->delalloc_inodes, &splice);
+	spin_lock(&root->delalloc_lock);
+	list_splice_init(&root->delalloc_inodes, &splice);
 
 	while (!list_empty(&splice)) {
-		btrfs_inode = list_entry(splice.next, struct btrfs_inode,
-				    delalloc_inodes);
+		btrfs_inode = list_first_entry(&splice, struct btrfs_inode,
+					       delalloc_inodes);
 
 		list_del_init(&btrfs_inode->delalloc_inodes);
 		clear_bit(BTRFS_INODE_IN_DELALLOC_LIST,
 			  &btrfs_inode->runtime_flags);
-		spin_unlock(&root->fs_info->delalloc_lock);
+		spin_unlock(&root->delalloc_lock);
 
 		btrfs_invalidate_inodes(btrfs_inode->root);
 
-		spin_lock(&root->fs_info->delalloc_lock);
+		spin_lock(&root->delalloc_lock);
 	}
 
-	spin_unlock(&root->fs_info->delalloc_lock);
+	spin_unlock(&root->delalloc_lock);
+}
+
+static void btrfs_destroy_all_delalloc_inodes(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_root *root;
+	struct list_head splice;
+
+	INIT_LIST_HEAD(&splice);
+
+	spin_lock(&fs_info->delalloc_root_lock);
+	list_splice_init(&fs_info->delalloc_roots, &splice);
+	while (!list_empty(&splice)) {
+		root = list_first_entry(&splice, struct btrfs_root,
+					 delalloc_root);
+		list_del_init(&root->delalloc_root);
+		root = btrfs_grab_fs_root(root);
+		BUG_ON(!root);
+		spin_unlock(&fs_info->delalloc_root_lock);
+
+		btrfs_destroy_delalloc_inodes(root);
+		btrfs_put_fs_root(root);
+
+		spin_lock(&fs_info->delalloc_root_lock);
+	}
+	spin_unlock(&fs_info->delalloc_root_lock);
 }
 
 static int btrfs_destroy_marked_extents(struct btrfs_root *root,
@@ -3972,7 +4001,7 @@ static int btrfs_cleanup_transaction(struct btrfs_root *root)
 		btrfs_destroy_delayed_inodes(root);
 		btrfs_assert_delayed_root_empty(root);
 
-		btrfs_destroy_delalloc_inodes(root);
+		btrfs_destroy_all_delalloc_inodes(root->fs_info);
 
 		spin_lock(&root->fs_info->trans_lock);
 		root->fs_info->running_transaction = NULL;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 08f9862..455117a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3897,7 +3897,7 @@ static void btrfs_writeback_inodes_sb_nr(struct btrfs_root *root,
 		 * the filesystem is readonly(all dirty pages are written to
 		 * the disk).
 		 */
-		btrfs_start_delalloc_inodes(root, 0);
+		btrfs_start_all_delalloc_inodes(root->fs_info, 0);
 		if (!current->journal_info)
 			btrfs_wait_ordered_extents(root, 0);
 	}
@@ -5026,14 +5026,14 @@ static int update_block_group(struct btrfs_root *root,
 	int factor;
 
 	/* block accounting for super block */
-	spin_lock(&info->delalloc_lock);
+	spin_lock(&info->delalloc_root_lock);
 	old_val = btrfs_super_bytes_used(info->super_copy);
 	if (alloc)
 		old_val += num_bytes;
 	else
 		old_val -= num_bytes;
 	btrfs_set_super_bytes_used(info->super_copy, old_val);
-	spin_unlock(&info->delalloc_lock);
+	spin_unlock(&info->delalloc_root_lock);
 
 	while (total) {
 		cache = btrfs_lookup_block_group(info, bytenr);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index bf5c399..a270083 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1524,6 +1524,46 @@ static void btrfs_merge_extent_hook(struct inode *inode,
 	spin_unlock(&BTRFS_I(inode)->lock);
 }
 
+static void btrfs_add_delalloc_inodes(struct btrfs_root *root,
+				      struct inode *inode)
+{
+	spin_lock(&root->delalloc_lock);
+	if (list_empty(&BTRFS_I(inode)->delalloc_inodes)) {
+		list_add_tail(&BTRFS_I(inode)->delalloc_inodes,
+			      &root->delalloc_inodes);
+		set_bit(BTRFS_INODE_IN_DELALLOC_LIST,
+			&BTRFS_I(inode)->runtime_flags);
+		root->nr_delalloc_inodes++;
+		if (root->nr_delalloc_inodes == 1) {
+			spin_lock(&root->fs_info->delalloc_root_lock);
+			BUG_ON(!list_empty(&root->delalloc_root));
+			list_add_tail(&root->delalloc_root,
+				      &root->fs_info->delalloc_roots);
+			spin_unlock(&root->fs_info->delalloc_root_lock);
+		}
+	}
+	spin_unlock(&root->delalloc_lock);
+}
+
+static void btrfs_del_delalloc_inode(struct btrfs_root *root,
+				     struct inode *inode)
+{
+	spin_lock(&root->delalloc_lock);
+	if (!list_empty(&BTRFS_I(inode)->delalloc_inodes)) {
+		list_del_init(&BTRFS_I(inode)->delalloc_inodes);
+		clear_bit(BTRFS_INODE_IN_DELALLOC_LIST,
+			  &BTRFS_I(inode)->runtime_flags);
+		root->nr_delalloc_inodes--;
+		if (!root->nr_delalloc_inodes) {
+			spin_lock(&root->fs_info->delalloc_root_lock);
+			BUG_ON(list_empty(&root->delalloc_root));
+			list_del_init(&root->delalloc_root);
+			spin_unlock(&root->fs_info->delalloc_root_lock);
+		}
+	}
+	spin_unlock(&root->delalloc_lock);
+}
+
 /*
  * extent_io.c set_bit_hook, used to track delayed allocation
  * bytes in this file, and to maintain the list of inodes that
@@ -1556,16 +1596,8 @@ static void btrfs_set_bit_hook(struct inode *inode,
 		spin_lock(&BTRFS_I(inode)->lock);
 		BTRFS_I(inode)->delalloc_bytes += len;
 		if (do_list && !test_bit(BTRFS_INODE_IN_DELALLOC_LIST,
-					 &BTRFS_I(inode)->runtime_flags)) {
-			spin_lock(&root->fs_info->delalloc_lock);
-			if (list_empty(&BTRFS_I(inode)->delalloc_inodes)) {
-				list_add_tail(&BTRFS_I(inode)->delalloc_inodes,
-					      &root->fs_info->delalloc_inodes);
-				set_bit(BTRFS_INODE_IN_DELALLOC_LIST,
-					&BTRFS_I(inode)->runtime_flags);
-			}
-			spin_unlock(&root->fs_info->delalloc_lock);
-		}
+					 &BTRFS_I(inode)->runtime_flags))
+			btrfs_add_delalloc_inodes(root, inode);
 		spin_unlock(&BTRFS_I(inode)->lock);
 	}
 }
@@ -1608,15 +1640,8 @@ static void btrfs_clear_bit_hook(struct inode *inode,
 		BTRFS_I(inode)->delalloc_bytes -= len;
 		if (do_list && BTRFS_I(inode)->delalloc_bytes == 0 &&
 		    test_bit(BTRFS_INODE_IN_DELALLOC_LIST,
-			     &BTRFS_I(inode)->runtime_flags)) {
-			spin_lock(&root->fs_info->delalloc_lock);
-			if (!list_empty(&BTRFS_I(inode)->delalloc_inodes)) {
-				list_del_init(&BTRFS_I(inode)->delalloc_inodes);
-				clear_bit(BTRFS_INODE_IN_DELALLOC_LIST,
-					  &BTRFS_I(inode)->runtime_flags);
-			}
-			spin_unlock(&root->fs_info->delalloc_lock);
-		}
+			     &BTRFS_I(inode)->runtime_flags))
+			btrfs_del_delalloc_inode(root, inode);
 		spin_unlock(&BTRFS_I(inode)->lock);
 	}
 }
@@ -8319,7 +8344,7 @@ void btrfs_wait_and_free_delalloc_work(struct btrfs_delalloc_work *work)
  * some fairly slow code that needs optimization. This walks the list
  * of all the inodes with pending delalloc and forces them to disk.
  */
-int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput)
+static int __start_delalloc_inodes(struct btrfs_root *root, int delay_iput)
 {
 	struct btrfs_inode *binode;
 	struct inode *inode;
@@ -8328,30 +8353,23 @@ int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput)
 	struct list_head splice;
 	int ret = 0;
 
-	if (root->fs_info->sb->s_flags & MS_RDONLY)
-		return -EROFS;
-
 	INIT_LIST_HEAD(&works);
 	INIT_LIST_HEAD(&splice);
 
-	spin_lock(&root->fs_info->delalloc_lock);
-	list_splice_init(&root->fs_info->delalloc_inodes, &splice);
+	spin_lock(&root->delalloc_lock);
+	list_splice_init(&root->delalloc_inodes, &splice);
 	while (!list_empty(&splice)) {
 		binode = list_entry(splice.next, struct btrfs_inode,
 				    delalloc_inodes);
 
-		list_del_init(&binode->delalloc_inodes);
-
+		list_move_tail(&binode->delalloc_inodes,
+			       &root->delalloc_inodes);
 		inode = igrab(&binode->vfs_inode);
 		if (!inode) {
-			clear_bit(BTRFS_INODE_IN_DELALLOC_LIST,
-				  &binode->runtime_flags);
+			cond_resched_lock(&root->delalloc_lock);
 			continue;
 		}
-
-		list_add_tail(&binode->delalloc_inodes,
-			      &root->fs_info->delalloc_inodes);
-		spin_unlock(&root->fs_info->delalloc_lock);
+		spin_unlock(&root->delalloc_lock);
 
 		work = btrfs_alloc_delalloc_work(inode, 0, delay_iput);
 		if (unlikely(!work)) {
@@ -8363,16 +8381,39 @@ int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput)
 				   &work->work);
 
 		cond_resched();
-		spin_lock(&root->fs_info->delalloc_lock);
+		spin_lock(&root->delalloc_lock);
 	}
-	spin_unlock(&root->fs_info->delalloc_lock);
+	spin_unlock(&root->delalloc_lock);
 
 	list_for_each_entry_safe(work, next, &works, list) {
 		list_del_init(&work->list);
 		btrfs_wait_and_free_delalloc_work(work);
 	}
+	return 0;
+out:
+	list_for_each_entry_safe(work, next, &works, list) {
+		list_del_init(&work->list);
+		btrfs_wait_and_free_delalloc_work(work);
+	}
+
+	if (!list_empty_careful(&splice)) {
+		spin_lock(&root->delalloc_lock);
+		list_splice_tail(&splice, &root->delalloc_inodes);
+		spin_unlock(&root->delalloc_lock);
+	}
+	return ret;
+}
 
-	/* the filemap_flush will queue IO into the worker threads, but
+int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput)
+{
+	int ret;
+
+	if (root->fs_info->sb->s_flags & MS_RDONLY)
+		return -EROFS;
+
+	ret = __start_delalloc_inodes(root, delay_iput);
+	/*
+	 * the filemap_flush will queue IO into the worker threads, but
 	 * we have to make sure the IO is actually started and that
 	 * ordered extents get created before we return
 	 */
@@ -8384,17 +8425,55 @@ int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput)
 		    atomic_read(&root->fs_info->async_delalloc_pages) == 0));
 	}
 	atomic_dec(&root->fs_info->async_submit_draining);
-	return 0;
-out:
-	list_for_each_entry_safe(work, next, &works, list) {
-		list_del_init(&work->list);
-		btrfs_wait_and_free_delalloc_work(work);
+	return ret;
+}
+
+int btrfs_start_all_delalloc_inodes(struct btrfs_fs_info *fs_info,
+				    int delay_iput)
+{
+	struct btrfs_root *root;
+	struct list_head splice;
+	int ret;
+
+	if (fs_info->sb->s_flags & MS_RDONLY)
+		return -EROFS;
+
+	INIT_LIST_HEAD(&splice);
+
+	spin_lock(&fs_info->delalloc_root_lock);
+	list_splice_init(&fs_info->delalloc_roots, &splice);
+	while (!list_empty(&splice)) {
+		root = list_first_entry(&splice, struct btrfs_root,
+					delalloc_root);
+		root = btrfs_grab_fs_root(root);
+		BUG_ON(!root);
+		list_move_tail(&root->delalloc_root,
+			       &fs_info->delalloc_roots);
+		spin_unlock(&fs_info->delalloc_root_lock);
+
+		ret = __start_delalloc_inodes(root, delay_iput);
+		btrfs_put_fs_root(root);
+		if (ret)
+			goto out;
+
+		spin_lock(&fs_info->delalloc_root_lock);
 	}
+	spin_unlock(&fs_info->delalloc_root_lock);
 
+	atomic_inc(&fs_info->async_submit_draining);
+	while (atomic_read(&fs_info->nr_async_submits) ||
+	      atomic_read(&fs_info->async_delalloc_pages)) {
+		wait_event(fs_info->async_submit_wait,
+		   (atomic_read(&fs_info->nr_async_submits) == 0 &&
+		    atomic_read(&fs_info->async_delalloc_pages) == 0));
+	}
+	atomic_dec(&fs_info->async_submit_draining);
+	return 0;
+out:
 	if (!list_empty_careful(&splice)) {
-		spin_lock(&root->fs_info->delalloc_lock);
-		list_splice_tail(&splice, &root->fs_info->delalloc_inodes);
-		spin_unlock(&root->fs_info->delalloc_lock);
+		spin_lock(&fs_info->delalloc_root_lock);
+		list_splice_tail(&splice, &fs_info->delalloc_roots);
+		spin_unlock(&fs_info->delalloc_root_lock);
 	}
 	return ret;
 }
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index baaa66b..247fc71 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4153,7 +4153,7 @@ int btrfs_relocate_block_group(struct btrfs_root *extent_root, u64 group_start)
 	       (unsigned long long)rc->block_group->key.objectid,
 	       (unsigned long long)rc->block_group->flags);
 
-	ret = btrfs_start_delalloc_inodes(fs_info->tree_root, 0);
+	ret = btrfs_start_all_delalloc_inodes(fs_info, 0);
 	if (ret < 0) {
 		err = ret;
 		goto out;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index f157752..4b63111 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1502,7 +1502,7 @@ static int btrfs_flush_all_pending_stuffs(struct btrfs_trans_handle *trans,
 	}
 
 	if (flush_on_commit || snap_pending) {
-		ret = btrfs_start_delalloc_inodes(root, 1);
+		ret = btrfs_start_all_delalloc_inodes(root->fs_info, 1);
 		if (ret)
 			return ret;
 		btrfs_wait_ordered_extents(root, 1);
-- 
1.8.1.4

