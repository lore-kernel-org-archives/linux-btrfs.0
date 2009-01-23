From: Sage Weil <sage@newdream.net>
Subject: [PATCH] btrfs: flushoncommit mount option
Date: Fri, 23 Jan 2009 13:09:09 -0800
Message-ID: <1232744949-25011-2-git-send-email-sage@newdream.net>
References: <1232744949-25011-1-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1232744949-25011-1-git-send-email-sage@newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

The 'flushoncommit' mount option forces any data dirtied by a write in a
prior transaction to commit as part of the current commit.  This makes
the committed state a fully consistent view of the file system from the
application's perspective (i.e., it includes all completed file system
operations).  This was previously the behavior only when a snapshot is
created.

While we're at it, make sync_fs also commit a consistent view (even
without 'flushoncommit') by moving the start_delalloc and
wait_ordered_extents into commit_transaction.

This is used by Ceph to ensure that completed writes make it to the
platter along with the metadata operations they are bound to (by
BTRFS_IOC_TRANS_{START,END}).

I'm not entirely sure why previously a snapshot creation didn't require
a start_delalloc_inodes but sync_fs did.  I suspect that the call is
either also desirable if snap_pending in commit_transaction, or is not
needed by sync_fs either...?

Let me know if this looks reasonable, or if you would prefer a different
approach.

Thanks-

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/ctree.h       |    1 +
 fs/btrfs/disk-io.c     |    6 +++---
 fs/btrfs/extent-tree.c |    6 +++---
 fs/btrfs/file.c        |    4 ++--
 fs/btrfs/inode.c       |    2 +-
 fs/btrfs/ioctl.c       |    8 ++++----
 fs/btrfs/super.c       |   15 ++++++++-------
 fs/btrfs/transaction.c |   12 +++++++++---
 fs/btrfs/transaction.h |    3 ++-
 fs/btrfs/tree-log.c    |    2 +-
 fs/btrfs/volumes.c     |    4 ++--
 11 files changed, 36 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 471fa67..019e7a7 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -951,6 +951,7 @@ struct btrfs_root {
 #define BTRFS_MOUNT_DEGRADED		(1 << 4)
 #define BTRFS_MOUNT_COMPRESS		(1 << 5)
 #define BTRFS_MOUNT_NOTREELOG           (1 << 6)
+#define BTRFS_MOUNT_FLUSHONCOMMIT       (1 << 7)
 
 #define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
 #define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7feac5a..2d4e7c0 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1443,7 +1443,7 @@ static int transaction_kthread(void *arg)
 		}
 		mutex_unlock(&root->fs_info->trans_mutex);
 		trans = btrfs_start_transaction(root, 1);
-		ret = btrfs_commit_transaction(trans, root);
+		ret = btrfs_commit_transaction(trans, root, 0);
 sleep:
 		wake_up_process(root->fs_info->cleaner_kthread);
 		mutex_unlock(&root->fs_info->transaction_kthread_mutex);
@@ -2192,11 +2192,11 @@ int btrfs_commit_super(struct btrfs_root *root)
 	btrfs_clean_old_snapshots(root);
 	mutex_unlock(&root->fs_info->cleaner_mutex);
 	trans = btrfs_start_transaction(root, 1);
-	ret = btrfs_commit_transaction(trans, root);
+	ret = btrfs_commit_transaction(trans, root, 0);
 	BUG_ON(ret);
 	/* run commit again to drop the original snapshot */
 	trans = btrfs_start_transaction(root, 1);
-	btrfs_commit_transaction(trans, root);
+	btrfs_commit_transaction(trans, root, 0);
 	ret = btrfs_write_and_wait_transaction(NULL, root);
 	BUG_ON(ret);
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3b26f09..b06d857 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5021,7 +5021,7 @@ int btrfs_cleanup_reloc_trees(struct btrfs_root *root)
 	if (found) {
 		trans = btrfs_start_transaction(root, 1);
 		BUG_ON(!trans);
-		ret = btrfs_commit_transaction(trans, root);
+		ret = btrfs_commit_transaction(trans, root, 0);
 		BUG_ON(ret);
 	}
 
@@ -5642,7 +5642,7 @@ again:
 	cur_byte = key.objectid;
 
 	trans = btrfs_start_transaction(info->tree_root, 1);
-	btrfs_commit_transaction(trans, info->tree_root);
+	btrfs_commit_transaction(trans, info->tree_root, 0);
 
 	mutex_lock(&root->fs_info->cleaner_mutex);
 	btrfs_clean_old_snapshots(info->tree_root);
@@ -5728,7 +5728,7 @@ next:
 
 	/* unpin extents in this range */
 	trans = btrfs_start_transaction(info->tree_root, 1);
-	btrfs_commit_transaction(trans, info->tree_root);
+	btrfs_commit_transaction(trans, info->tree_root, 0);
 
 	spin_lock(&block_group->lock);
 	WARN_ON(block_group->pinned > 0);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 3e8023e..158963a 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1160,7 +1160,7 @@ out_nolock:
 				btrfs_sync_log(trans, root);
 				btrfs_end_transaction(trans, root);
 			} else {
-				btrfs_commit_transaction(trans, root);
+				btrfs_commit_transaction(trans, root, 0);
 			}
 		}
 		if (file->f_flags & O_DIRECT) {
@@ -1248,7 +1248,7 @@ int btrfs_sync_file(struct file *file, struct dentry *dentry, int datasync)
 	mutex_unlock(&file->f_dentry->d_inode->i_mutex);
 
 	if (ret > 0) {
-		ret = btrfs_commit_transaction(trans, root);
+		ret = btrfs_commit_transaction(trans, root, 0);
 	} else {
 		btrfs_sync_log(trans, root);
 		ret = btrfs_end_transaction(trans, root);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 288c2cd..553278c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3285,7 +3285,7 @@ int btrfs_write_inode(struct inode *inode, int wait)
 	if (wait) {
 		trans = btrfs_join_transaction(root, 1);
 		btrfs_set_trans_block_group(trans, inode);
-		ret = btrfs_commit_transaction(trans, root);
+		ret = btrfs_commit_transaction(trans, root, 0);
 	}
 	return ret;
 }
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 988fdc8..f793814 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -166,7 +166,7 @@ static noinline int create_subvol(struct btrfs_root *root,
 
 	BUG_ON(ret);
 
-	ret = btrfs_commit_transaction(trans, root);
+	ret = btrfs_commit_transaction(trans, root, 0);
 	if (ret)
 		goto fail_commit;
 
@@ -183,7 +183,7 @@ static noinline int create_subvol(struct btrfs_root *root,
 
 fail:
 	nr = trans->blocks_used;
-	err = btrfs_commit_transaction(trans, new_root);
+	err = btrfs_commit_transaction(trans, new_root, 0);
 	if (err && !ret)
 		ret = err;
 fail_commit:
@@ -226,7 +226,7 @@ static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
 	pending_snapshot->root = root;
 	list_add(&pending_snapshot->list,
 		 &trans->transaction->pending_snapshots);
-	err = btrfs_commit_transaction(trans, root);
+	err = btrfs_commit_transaction(trans, root, 0);
 
 fail_unlock:
 	btrfs_btree_balance_dirty(root, nr);
@@ -538,7 +538,7 @@ static int btrfs_ioctl_resize(struct btrfs_root *root, void __user *arg)
 	if (new_size > old_size) {
 		trans = btrfs_start_transaction(root, 1);
 		ret = btrfs_grow_device(trans, device, new_size);
-		btrfs_commit_transaction(trans, root);
+		btrfs_commit_transaction(trans, root, 0);
 	} else {
 		ret = btrfs_shrink_device(device, new_size);
 	}
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index d8c664c..4c9f661 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -67,7 +67,7 @@ enum {
 	Opt_degraded, Opt_subvol, Opt_device, Opt_nodatasum, Opt_nodatacow,
 	Opt_max_extent, Opt_max_inline, Opt_alloc_start, Opt_nobarrier,
 	Opt_ssd, Opt_thread_pool, Opt_noacl,  Opt_compress, Opt_notreelog,
-	Opt_err,
+	Opt_flushoncommit, Opt_err,
 };
 
 static match_table_t tokens = {
@@ -85,6 +85,7 @@ static match_table_t tokens = {
 	{Opt_ssd, "ssd"},
 	{Opt_noacl, "noacl"},
 	{Opt_notreelog, "notreelog"},
+	{Opt_flushoncommit, "flushoncommit"},
 	{Opt_err, NULL},
 };
 
@@ -228,6 +229,10 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			printk(KERN_INFO "btrfs: disabling tree log\n");
 			btrfs_set_opt(info->mount_opt, NOTREELOG);
 			break;
+		case Opt_flushoncommit:
+			printk(KERN_INFO "btrfs: turning on flush-on-commit\n");
+			btrfs_set_opt(info->mount_opt, FLUSHONCOMMIT);
+			break;
 		default:
 			break;
 		}
@@ -369,9 +374,8 @@ fail_close:
 int btrfs_sync_fs(struct super_block *sb, int wait)
 {
 	struct btrfs_trans_handle *trans;
-	struct btrfs_root *root;
+	struct btrfs_root *root = btrfs_sb(sb);
 	int ret;
-	root = btrfs_sb(sb);
 
 	if (sb->s_flags & MS_RDONLY)
 		return 0;
@@ -382,12 +386,9 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
 		return 0;
 	}
 
-	btrfs_start_delalloc_inodes(root);
-	btrfs_wait_ordered_extents(root, 0);
-
 	btrfs_clean_old_snapshots(root);
 	trans = btrfs_start_transaction(root, 1);
-	ret = btrfs_commit_transaction(trans, root);
+	ret = btrfs_commit_transaction(trans, root, 1);
 	sb->s_dirt = 0;
 	return ret;
 }
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 919172d..f687e66 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -881,7 +881,8 @@ static noinline int finish_pending_snapshots(struct btrfs_trans_handle *trans,
 }
 
 int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *root)
+			     struct btrfs_root *root,
+			     int ordered)
 {
 	unsigned long joined = 0;
 	unsigned long timeout = 1;
@@ -893,6 +894,9 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	DEFINE_WAIT(wait);
 	int ret;
 
+	if (btrfs_test_opt(root, FLUSHONCOMMIT))
+		ordered = 1;
+
 	INIT_LIST_HEAD(&dirty_fs_roots);
 	mutex_lock(&root->fs_info->trans_mutex);
 	if (trans->transaction->in_commit) {
@@ -951,8 +955,10 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 			timeout = 1;
 
 		mutex_unlock(&root->fs_info->trans_mutex);
-
-		if (snap_pending) {
+		
+		if (ordered || snap_pending) {
+			if (ordered)
+				ret = btrfs_start_delalloc_inodes(root);
 			ret = btrfs_wait_ordered_extents(root, 1);
 			BUG_ON(ret);
 		}
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index ea29211..e167b70 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -96,7 +96,8 @@ int btrfs_add_dead_root(struct btrfs_root *root, struct btrfs_root *latest);
 int btrfs_defrag_root(struct btrfs_root *root, int cacheonly);
 int btrfs_clean_old_snapshots(struct btrfs_root *root);
 int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *root);
+			     struct btrfs_root *root,
+			     int ordered);
 int btrfs_end_transaction_throttle(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root);
 void btrfs_throttle(struct btrfs_root *root);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index ac58991..b01d6c2 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2877,7 +2877,7 @@ again:
 	fs_info->log_root_recovering = 0;
 
 	/* step 4: commit the transaction, which also unpins the blocks */
-	btrfs_commit_transaction(trans, fs_info->tree_root);
+	btrfs_commit_transaction(trans, fs_info->tree_root, 0);
 
 	kfree(log_root_tree);
 	return 0;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index fd0bedb..6cfec73 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -964,7 +964,7 @@ static int btrfs_rm_dev_item(struct btrfs_root *root,
 out:
 	btrfs_free_path(path);
 	unlock_chunks(root);
-	btrfs_commit_transaction(trans, root);
+	btrfs_commit_transaction(trans, root, 0);
 	return ret;
 }
 
@@ -1368,7 +1368,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	}
 
 	unlock_chunks(root);
-	btrfs_commit_transaction(trans, root);
+	btrfs_commit_transaction(trans, root, 0);
 
 	if (seeding_dev) {
 		mutex_unlock(&uuid_mutex);
-- 
1.5.6.5

