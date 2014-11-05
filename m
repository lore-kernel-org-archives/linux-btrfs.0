Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:36399 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750860AbaKET4b (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Wed, 5 Nov 2014 14:56:31 -0500
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs: fix race when cleaning unused block groups
Date: Wed,  5 Nov 2014 19:56:04 +0000
Message-Id: <1415217364-32108-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have a race while deleting unused block groups that causes extents written
by past generations/transactions to be rewritten by the current transaction
before that transaction is committed. The steps that lead to this issue:

1) At transaction N one or more block groups became unused and we added them
   to the list fs_info->unused_bgs;

2) While still at transaction N we write btree extents to block group X and the
   transaction is committed;

3) The cleaner kthread is awaken and calls btrfs_delete_unused_bgs() to go through
   the list fs_info->unused_bgs and remove unused block groups;

4) Transaction N + 1 starts;

5) At transaction N + 1, block group X becomes unused and is added to the list
   fs_info->unused_bgs - this implies delayed refs were run, so we had the
   following function calls: btrfs_run_delayed_refs() -> __btrfs_free_extent()
   -> update_block_group(). The update_block_group() function grabs the lock
   fs_info->unused_bgs_lock, adds block group X to fs_info->unused_bgs and
   releases that lock;

6) The cleaner kthread, while at btrfs_delete_unused_bgs(), sees block group X
   added by transaction N + 1 because it's doing a loop that finishes only when
   the list fs_info->unused_bgs is empty and locks and unlocks the spinlock
   fs_info->unused_bgs_lock on each iteration. So it deletes the block group
   and its respective chunk is released. Even if it didn't do the lock/unlock
   per iteration, it could still see block group X in the list, because the
   cleaner kthread might call btrfs_delete_unused_bgs() multiple times (for
   example if there are several snapshots to delete);

7) A new block group X' is created for data, and it's associated to the same chunk
   that block group X was associated to;

8) Extents from block group X' are allocated for file data and for example an fsync
   makes the file data be effectively written to disk;

9) A crash/reboot happens before transaction N + 1 is committed;

10) On the next mount, we will read extents from block group/chunk X but they no
   longer have valid btree nodes/leafs - they have instead file data, and therefore
   all sorts of errors will happen.

So fix this by ensuring the cleaner kthread can never delete a block group that
became unused in the current transaction, that is, only delete block groups that
were added to the unused_bgs list by past transactions.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ctree.h       | 1 +
 fs/btrfs/disk-io.c     | 1 +
 fs/btrfs/extent-tree.c | 5 +++--
 fs/btrfs/transaction.c | 5 +++++
 4 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 36f82ba..a5e471a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1726,6 +1726,7 @@ struct btrfs_fs_info {
 
 	spinlock_t unused_bgs_lock;
 	struct list_head unused_bgs;
+	struct list_head unused_bgs_to_clean;
 
 	/* For btrfs to record security options */
 	struct security_mnt_opts security_opts;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2409718..702bbdf 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2243,6 +2243,7 @@ int open_ctree(struct super_block *sb,
 	INIT_LIST_HEAD(&fs_info->space_info);
 	INIT_LIST_HEAD(&fs_info->tree_mod_seq_list);
 	INIT_LIST_HEAD(&fs_info->unused_bgs);
+	INIT_LIST_HEAD(&fs_info->unused_bgs_to_clean);
 	btrfs_mapping_init(&fs_info->mapping_tree);
 	btrfs_init_block_rsv(&fs_info->global_block_rsv,
 			     BTRFS_BLOCK_RSV_GLOBAL);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 744b580..bc1c0b7 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8858,6 +8858,7 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 	up_write(&info->commit_root_sem);
 
 	spin_lock(&info->unused_bgs_lock);
+	list_splice_init(&info->unused_bgs_to_clean, &info->unused_bgs);
 	while (!list_empty(&info->unused_bgs)) {
 		block_group = list_first_entry(&info->unused_bgs,
 					       struct btrfs_block_group_cache,
@@ -9466,10 +9467,10 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 		return;
 
 	spin_lock(&fs_info->unused_bgs_lock);
-	while (!list_empty(&fs_info->unused_bgs)) {
+	while (!list_empty(&fs_info->unused_bgs_to_clean)) {
 		u64 start, end;
 
-		block_group = list_first_entry(&fs_info->unused_bgs,
+		block_group = list_first_entry(&fs_info->unused_bgs_to_clean,
 					       struct btrfs_block_group_cache,
 					       bg_list);
 		space_info = block_group->space_info;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 396ae8b..86d7cf5 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1937,6 +1937,11 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 
 	btrfs_prepare_extent_commit(trans, root);
 
+	spin_lock(&root->fs_info->unused_bgs_lock);
+	list_splice_init(&root->fs_info->unused_bgs,
+			 &root->fs_info->unused_bgs_to_clean);
+	spin_unlock(&root->fs_info->unused_bgs_lock);
+
 	cur_trans = root->fs_info->running_transaction;
 
 	btrfs_set_root_node(&root->fs_info->tree_root->root_item,
-- 
1.9.1

