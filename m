Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:24837 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757158Ab3EOHso (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 03:48:44 -0400
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: alex.btrfs@zadarastorage.com
Subject: [PATCH 09/17] Btrfs: introduce per-subvolume ordered extent list
Date: Wed, 15 May 2013 15:48:23 +0800
Message-Id: <1368604111-25073-10-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
References: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The reason we introduce per-subvolume ordered extent list is the same
as the per-subvolume delalloc inode list.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.h        |  25 ++++++++---
 fs/btrfs/dev-replace.c  |   4 +-
 fs/btrfs/disk-io.c      |  45 +++++++++++++++-----
 fs/btrfs/extent-tree.c  |   6 +--
 fs/btrfs/inode.c        |   4 +-
 fs/btrfs/ordered-data.c | 109 +++++++++++++++++++++++++++++++++---------------
 fs/btrfs/ordered-data.h |   2 +
 fs/btrfs/relocation.c   |   2 +-
 fs/btrfs/super.c        |   2 +-
 fs/btrfs/transaction.c  |   2 +-
 10 files changed, 143 insertions(+), 58 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 067233f..a7e71ff 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1437,17 +1437,18 @@ struct btrfs_fs_info {
 	atomic_t open_ioctl_trans;
 
 	/*
-	 * this is used by the balancing code to wait for all the pending
-	 * ordered extents
+	 * this is used to protect the following list -- ordered_roots.
 	 */
-	spinlock_t ordered_extent_lock;
+	spinlock_t ordered_root_lock;
 
 	/*
-	 * all of the data=ordered extents pending writeback
+	 * all fs/file tree roots in which there are data=ordered extents
+	 * pending writeback are added into this list.
+	 *
 	 * these can span multiple transactions and basically include
 	 * every dirty data page that isn't from nodatacow
 	 */
-	struct list_head ordered_extents;
+	struct list_head ordered_roots;
 
 	spinlock_t delalloc_root_lock;
 	/* all fs/file tree roots that have delalloc inodes. */
@@ -1746,6 +1747,20 @@ struct btrfs_root {
 	struct list_head delalloc_inodes;
 	struct list_head delalloc_root;
 	u64 nr_delalloc_inodes;
+	/*
+	 * this is used by the balancing code to wait for all the pending
+	 * ordered extents
+	 */
+	spinlock_t ordered_extent_lock;
+
+	/*
+	 * all of the data=ordered extents pending writeback
+	 * these can span multiple transactions and basically include
+	 * every dirty data page that isn't from nodatacow
+	 */
+	struct list_head ordered_extents;
+	struct list_head ordered_root;
+	u64 nr_ordered_extents;
 };
 
 struct btrfs_ioctl_defrag_range_args {
diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index aca77ad..4254da8 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -395,7 +395,7 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 	args->result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR;
 	btrfs_dev_replace_unlock(dev_replace);
 
-	btrfs_wait_ordered_extents(root, 0);
+	btrfs_wait_all_ordered_extents(root->fs_info, 0);
 
 	/* force writing the updated state information to disk */
 	trans = btrfs_start_transaction(root, 0);
@@ -470,7 +470,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
 		return ret;
 	}
-	btrfs_wait_ordered_extents(root, 0);
+	btrfs_wait_all_ordered_extents(root->fs_info, 0);
 
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 13dddba..44d5a86 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1192,6 +1192,7 @@ static void __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 	root->last_trans = 0;
 	root->highest_objectid = 0;
 	root->nr_delalloc_inodes = 0;
+	root->nr_ordered_extents = 0;
 	root->name = NULL;
 	root->inode_tree = RB_ROOT;
 	INIT_RADIX_TREE(&root->delayed_nodes_tree, GFP_ATOMIC);
@@ -1202,11 +1203,14 @@ static void __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 	INIT_LIST_HEAD(&root->root_list);
 	INIT_LIST_HEAD(&root->delalloc_inodes);
 	INIT_LIST_HEAD(&root->delalloc_root);
+	INIT_LIST_HEAD(&root->ordered_extents);
+	INIT_LIST_HEAD(&root->ordered_root);
 	INIT_LIST_HEAD(&root->logged_list[0]);
 	INIT_LIST_HEAD(&root->logged_list[1]);
 	spin_lock_init(&root->orphan_lock);
 	spin_lock_init(&root->inode_lock);
 	spin_lock_init(&root->delalloc_lock);
+	spin_lock_init(&root->ordered_extent_lock);
 	spin_lock_init(&root->accounting_lock);
 	spin_lock_init(&root->log_extents_lock[0]);
 	spin_lock_init(&root->log_extents_lock[1]);
@@ -2190,8 +2194,8 @@ int open_ctree(struct super_block *sb,
 	fs_info->thread_pool_size = min_t(unsigned long,
 					  num_online_cpus() + 2, 8);
 
-	INIT_LIST_HEAD(&fs_info->ordered_extents);
-	spin_lock_init(&fs_info->ordered_extent_lock);
+	INIT_LIST_HEAD(&fs_info->ordered_roots);
+	spin_lock_init(&fs_info->ordered_root_lock);
 	fs_info->delayed_root = kmalloc(sizeof(struct btrfs_delayed_root),
 					GFP_NOFS);
 	if (!fs_info->delayed_root) {
@@ -3681,7 +3685,7 @@ static void btrfs_destroy_ordered_operations(struct btrfs_transaction *t,
 	INIT_LIST_HEAD(&splice);
 
 	mutex_lock(&root->fs_info->ordered_operations_mutex);
-	spin_lock(&root->fs_info->ordered_extent_lock);
+	spin_lock(&root->fs_info->ordered_root_lock);
 
 	list_splice_init(&t->ordered_operations, &splice);
 	while (!list_empty(&splice)) {
@@ -3689,14 +3693,14 @@ static void btrfs_destroy_ordered_operations(struct btrfs_transaction *t,
 					 ordered_operations);
 
 		list_del_init(&btrfs_inode->ordered_operations);
-		spin_unlock(&root->fs_info->ordered_extent_lock);
+		spin_unlock(&root->fs_info->ordered_root_lock);
 
 		btrfs_invalidate_inodes(btrfs_inode->root);
 
-		spin_lock(&root->fs_info->ordered_extent_lock);
+		spin_lock(&root->fs_info->ordered_root_lock);
 	}
 
-	spin_unlock(&root->fs_info->ordered_extent_lock);
+	spin_unlock(&root->fs_info->ordered_root_lock);
 	mutex_unlock(&root->fs_info->ordered_operations_mutex);
 }
 
@@ -3704,15 +3708,36 @@ static void btrfs_destroy_ordered_extents(struct btrfs_root *root)
 {
 	struct btrfs_ordered_extent *ordered;
 
-	spin_lock(&root->fs_info->ordered_extent_lock);
+	spin_lock(&root->ordered_extent_lock);
 	/*
 	 * This will just short circuit the ordered completion stuff which will
 	 * make sure the ordered extent gets properly cleaned up.
 	 */
-	list_for_each_entry(ordered, &root->fs_info->ordered_extents,
+	list_for_each_entry(ordered, &root->ordered_extents,
 			    root_extent_list)
 		set_bit(BTRFS_ORDERED_IOERR, &ordered->flags);
-	spin_unlock(&root->fs_info->ordered_extent_lock);
+	spin_unlock(&root->ordered_extent_lock);
+}
+
+static void btrfs_destroy_all_ordered_extents(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_root *root;
+	struct list_head splice;
+
+	INIT_LIST_HEAD(&splice);
+
+	spin_lock(&fs_info->ordered_root_lock);
+	list_splice_init(&fs_info->ordered_roots, &splice);
+	while (!list_empty(&splice)) {
+		root = list_first_entry(&splice, struct btrfs_root,
+					ordered_root);
+		list_del_init(&root->ordered_root);
+
+		btrfs_destroy_ordered_extents(root);
+
+		cond_resched_lock(&fs_info->ordered_root_lock);
+	}
+	spin_unlock(&fs_info->ordered_root_lock);
 }
 
 int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
@@ -3975,7 +4000,7 @@ static int btrfs_cleanup_transaction(struct btrfs_root *root)
 
 		btrfs_destroy_ordered_operations(t, root);
 
-		btrfs_destroy_ordered_extents(root);
+		btrfs_destroy_all_ordered_extents(root->fs_info);
 
 		btrfs_destroy_delayed_refs(t, root);
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 455117a..3149616 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3899,7 +3899,7 @@ static void btrfs_writeback_inodes_sb_nr(struct btrfs_root *root,
 		 */
 		btrfs_start_all_delalloc_inodes(root->fs_info, 0);
 		if (!current->journal_info)
-			btrfs_wait_ordered_extents(root, 0);
+			btrfs_wait_all_ordered_extents(root->fs_info, 0);
 	}
 }
 
@@ -3929,7 +3929,7 @@ static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
 	if (delalloc_bytes == 0) {
 		if (trans)
 			return;
-		btrfs_wait_ordered_extents(root, 0);
+		btrfs_wait_all_ordered_extents(root->fs_info, 0);
 		return;
 	}
 
@@ -3957,7 +3957,7 @@ static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
 
 		loops++;
 		if (wait_ordered && !trans) {
-			btrfs_wait_ordered_extents(root, 0);
+			btrfs_wait_all_ordered_extents(root->fs_info, 0);
 		} else {
 			time_left = schedule_timeout_killable(1);
 			if (time_left)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a270083..69ca278 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7975,9 +7975,9 @@ void btrfs_destroy_inode(struct inode *inode)
 	 */
 	smp_mb();
 	if (!list_empty(&BTRFS_I(inode)->ordered_operations)) {
-		spin_lock(&root->fs_info->ordered_extent_lock);
+		spin_lock(&root->fs_info->ordered_root_lock);
 		list_del_init(&BTRFS_I(inode)->ordered_operations);
-		spin_unlock(&root->fs_info->ordered_extent_lock);
+		spin_unlock(&root->fs_info->ordered_root_lock);
 	}
 
 	if (test_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 1ddd728..665c640 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -24,6 +24,7 @@
 #include "transaction.h"
 #include "btrfs_inode.h"
 #include "extent_io.h"
+#include "disk-io.h"
 
 static struct kmem_cache *btrfs_ordered_extent_cache;
 
@@ -184,6 +185,7 @@ static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 				      u64 start, u64 len, u64 disk_len,
 				      int type, int dio, int compress_type)
 {
+	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_ordered_inode_tree *tree;
 	struct rb_node *node;
 	struct btrfs_ordered_extent *entry;
@@ -227,10 +229,18 @@ static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 		ordered_data_tree_panic(inode, -EEXIST, file_offset);
 	spin_unlock_irq(&tree->lock);
 
-	spin_lock(&BTRFS_I(inode)->root->fs_info->ordered_extent_lock);
+	spin_lock(&root->ordered_extent_lock);
 	list_add_tail(&entry->root_extent_list,
-		      &BTRFS_I(inode)->root->fs_info->ordered_extents);
-	spin_unlock(&BTRFS_I(inode)->root->fs_info->ordered_extent_lock);
+		      &root->ordered_extents);
+	root->nr_ordered_extents++;
+	if (root->nr_ordered_extents == 1) {
+		spin_lock(&root->fs_info->ordered_root_lock);
+		BUG_ON(!list_empty(&root->ordered_root));
+		list_add_tail(&root->ordered_root,
+			      &root->fs_info->ordered_roots);
+		spin_unlock(&root->fs_info->ordered_root_lock);
+	}
+	spin_unlock(&root->ordered_extent_lock);
 
 	return 0;
 }
@@ -516,8 +526,9 @@ void btrfs_remove_ordered_extent(struct inode *inode,
 	set_bit(BTRFS_ORDERED_COMPLETE, &entry->flags);
 	spin_unlock_irq(&tree->lock);
 
-	spin_lock(&root->fs_info->ordered_extent_lock);
+	spin_lock(&root->ordered_extent_lock);
 	list_del_init(&entry->root_extent_list);
+	root->nr_ordered_extents--;
 
 	trace_btrfs_ordered_extent_remove(inode, entry);
 
@@ -530,7 +541,14 @@ void btrfs_remove_ordered_extent(struct inode *inode,
 	    !mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY)) {
 		list_del_init(&BTRFS_I(inode)->ordered_operations);
 	}
-	spin_unlock(&root->fs_info->ordered_extent_lock);
+
+	if (!root->nr_ordered_extents) {
+		spin_lock(&root->fs_info->ordered_root_lock);
+		BUG_ON(list_empty(&root->ordered_root));
+		list_del_init(&root->ordered_root);
+		spin_unlock(&root->fs_info->ordered_root_lock);
+	}
+	spin_unlock(&root->ordered_extent_lock);
 	wake_up(&entry->wait);
 }
 
@@ -550,7 +568,6 @@ static void btrfs_run_ordered_extent_work(struct btrfs_work *work)
 void btrfs_wait_ordered_extents(struct btrfs_root *root, int delay_iput)
 {
 	struct list_head splice, works;
-	struct list_head *cur;
 	struct btrfs_ordered_extent *ordered, *next;
 	struct inode *inode;
 
@@ -558,35 +575,34 @@ void btrfs_wait_ordered_extents(struct btrfs_root *root, int delay_iput)
 	INIT_LIST_HEAD(&works);
 
 	mutex_lock(&root->fs_info->ordered_operations_mutex);
-	spin_lock(&root->fs_info->ordered_extent_lock);
-	list_splice_init(&root->fs_info->ordered_extents, &splice);
+	spin_lock(&root->ordered_extent_lock);
+	list_splice_init(&root->ordered_extents, &splice);
 	while (!list_empty(&splice)) {
-		cur = splice.next;
-		ordered = list_entry(cur, struct btrfs_ordered_extent,
-				     root_extent_list);
-		list_del_init(&ordered->root_extent_list);
-		atomic_inc(&ordered->refs);
-
+		ordered = list_first_entry(&splice, struct btrfs_ordered_extent,
+					   root_extent_list);
+		list_move_tail(&ordered->root_extent_list,
+			       &root->ordered_extents);
 		/*
 		 * the inode may be getting freed (in sys_unlink path).
 		 */
 		inode = igrab(ordered->inode);
+		if (!inode) {
+			cond_resched_lock(&root->ordered_extent_lock);
+			continue;
+		}
 
-		spin_unlock(&root->fs_info->ordered_extent_lock);
+		atomic_inc(&ordered->refs);
+		spin_unlock(&root->ordered_extent_lock);
 
-		if (inode) {
-			ordered->flush_work.func = btrfs_run_ordered_extent_work;
-			list_add_tail(&ordered->work_list, &works);
-			btrfs_queue_worker(&root->fs_info->flush_workers,
-					   &ordered->flush_work);
-		} else {
-			btrfs_put_ordered_extent(ordered);
-		}
+		ordered->flush_work.func = btrfs_run_ordered_extent_work;
+		list_add_tail(&ordered->work_list, &works);
+		btrfs_queue_worker(&root->fs_info->flush_workers,
+				   &ordered->flush_work);
 
 		cond_resched();
-		spin_lock(&root->fs_info->ordered_extent_lock);
+		spin_lock(&root->ordered_extent_lock);
 	}
-	spin_unlock(&root->fs_info->ordered_extent_lock);
+	spin_unlock(&root->ordered_extent_lock);
 
 	list_for_each_entry_safe(ordered, next, &works, work_list) {
 		list_del_init(&ordered->work_list);
@@ -604,6 +620,33 @@ void btrfs_wait_ordered_extents(struct btrfs_root *root, int delay_iput)
 	mutex_unlock(&root->fs_info->ordered_operations_mutex);
 }
 
+void btrfs_wait_all_ordered_extents(struct btrfs_fs_info *fs_info,
+				    int delay_iput)
+{
+	struct btrfs_root *root;
+	struct list_head splice;
+
+	INIT_LIST_HEAD(&splice);
+
+	spin_lock(&fs_info->ordered_root_lock);
+	list_splice_init(&fs_info->ordered_roots, &splice);
+	while (!list_empty(&splice)) {
+		root = list_first_entry(&splice, struct btrfs_root,
+					ordered_root);
+		root = btrfs_grab_fs_root(root);
+		BUG_ON(!root);
+		list_move_tail(&root->ordered_root,
+			       &fs_info->ordered_roots);
+		spin_unlock(&fs_info->ordered_root_lock);
+
+		btrfs_wait_ordered_extents(root, delay_iput);
+		btrfs_put_fs_root(root);
+
+		spin_lock(&fs_info->ordered_root_lock);
+	}
+	spin_unlock(&fs_info->ordered_root_lock);
+}
+
 /*
  * this is used during transaction commit to write all the inodes
  * added to the ordered operation list.  These files must be fully on
@@ -629,7 +672,7 @@ int btrfs_run_ordered_operations(struct btrfs_trans_handle *trans,
 	INIT_LIST_HEAD(&works);
 
 	mutex_lock(&root->fs_info->ordered_operations_mutex);
-	spin_lock(&root->fs_info->ordered_extent_lock);
+	spin_lock(&root->fs_info->ordered_root_lock);
 	list_splice_init(&cur_trans->ordered_operations, &splice);
 	while (!list_empty(&splice)) {
 		btrfs_inode = list_entry(splice.next, struct btrfs_inode,
@@ -648,17 +691,17 @@ int btrfs_run_ordered_operations(struct btrfs_trans_handle *trans,
 		if (!wait)
 			list_add_tail(&BTRFS_I(inode)->ordered_operations,
 				      &cur_trans->ordered_operations);
-		spin_unlock(&root->fs_info->ordered_extent_lock);
+		spin_unlock(&root->fs_info->ordered_root_lock);
 
 		work = btrfs_alloc_delalloc_work(inode, wait, 1);
 		if (!work) {
-			spin_lock(&root->fs_info->ordered_extent_lock);
+			spin_lock(&root->fs_info->ordered_root_lock);
 			if (list_empty(&BTRFS_I(inode)->ordered_operations))
 				list_add_tail(&btrfs_inode->ordered_operations,
 					      &splice);
 			list_splice_tail(&splice,
 					 &cur_trans->ordered_operations);
-			spin_unlock(&root->fs_info->ordered_extent_lock);
+			spin_unlock(&root->fs_info->ordered_root_lock);
 			ret = -ENOMEM;
 			goto out;
 		}
@@ -667,9 +710,9 @@ int btrfs_run_ordered_operations(struct btrfs_trans_handle *trans,
 				   &work->work);
 
 		cond_resched();
-		spin_lock(&root->fs_info->ordered_extent_lock);
+		spin_lock(&root->fs_info->ordered_root_lock);
 	}
-	spin_unlock(&root->fs_info->ordered_extent_lock);
+	spin_unlock(&root->fs_info->ordered_root_lock);
 out:
 	list_for_each_entry_safe(work, next, &works, list) {
 		list_del_init(&work->list);
@@ -1055,12 +1098,12 @@ void btrfs_add_ordered_operation(struct btrfs_trans_handle *trans,
 	if (last_mod < root->fs_info->last_trans_committed)
 		return;
 
-	spin_lock(&root->fs_info->ordered_extent_lock);
+	spin_lock(&root->fs_info->ordered_root_lock);
 	if (list_empty(&BTRFS_I(inode)->ordered_operations)) {
 		list_add_tail(&BTRFS_I(inode)->ordered_operations,
 			      &cur_trans->ordered_operations);
 	}
-	spin_unlock(&root->fs_info->ordered_extent_lock);
+	spin_unlock(&root->fs_info->ordered_root_lock);
 }
 
 int __init ordered_data_init(void)
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 58b0e3b..d082d43 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -204,6 +204,8 @@ void btrfs_add_ordered_operation(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root,
 				 struct inode *inode);
 void btrfs_wait_ordered_extents(struct btrfs_root *root, int delay_iput);
+void btrfs_wait_all_ordered_extents(struct btrfs_fs_info *fs_info,
+				    int delay_iput);
 void btrfs_get_logged_extents(struct btrfs_root *log, struct inode *inode);
 void btrfs_wait_logged_extents(struct btrfs_root *log, u64 transid);
 void btrfs_free_logged_extents(struct btrfs_root *log, u64 transid);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 247fc71..f04e703 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4158,7 +4158,7 @@ int btrfs_relocate_block_group(struct btrfs_root *extent_root, u64 group_start)
 		err = ret;
 		goto out;
 	}
-	btrfs_wait_ordered_extents(fs_info->tree_root, 0);
+	btrfs_wait_all_ordered_extents(fs_info, 0);
 
 	while (1) {
 		mutex_lock(&fs_info->cleaner_mutex);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index f0857e0..d36d6e6 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -866,7 +866,7 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
 		return 0;
 	}
 
-	btrfs_wait_ordered_extents(root, 1);
+	btrfs_wait_all_ordered_extents(fs_info, 0);
 
 	trans = btrfs_attach_transaction_barrier(root);
 	if (IS_ERR(trans)) {
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 4b63111..2b17213 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1505,7 +1505,7 @@ static int btrfs_flush_all_pending_stuffs(struct btrfs_trans_handle *trans,
 		ret = btrfs_start_all_delalloc_inodes(root->fs_info, 1);
 		if (ret)
 			return ret;
-		btrfs_wait_ordered_extents(root, 1);
+		btrfs_wait_all_ordered_extents(root->fs_info, 1);
 	}
 
 	ret = btrfs_run_delayed_items(trans, root);
-- 
1.8.1.4

