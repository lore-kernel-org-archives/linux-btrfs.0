From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 09/12 v5] Btrfs: fix a bug of log check
Date: Sat, 6 Aug 2011 17:37:44 +0800
Message-ID: <1312623467-31487-10-git-send-email-liubo2009@cn.fujitsu.com>
References: <1312623467-31487-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <chris.mason@oracle.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1312623467-31487-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

The current code uses struct root's last_log_commit to check if an inode
has been logged, but the problem is that this root->last_log_commit is
shared among files.  Say we have N inodes to be logged, after the first
inode, root-last_log_commit is updated and the N-1 remains will not be
logged.

As we've introduce sub transaction and filled inode's last_trans and
logged_trans with sub_transid instead of transaction id, we can just
compare last_trans with logged_trans to determine if the processing inode
is logged.  And the more important thing is these two values are
inode-individual, so it will not interfere with others.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/btrfs_inode.h |    5 -----
 fs/btrfs/ctree.h       |    1 -
 fs/btrfs/disk-io.c     |    2 --
 fs/btrfs/inode.c       |    2 --
 fs/btrfs/transaction.h |    1 -
 fs/btrfs/tree-log.c    |   16 +++-------------
 6 files changed, 3 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index ba768b0..918a51b 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -98,11 +98,6 @@ struct btrfs_inode {
 	u64 last_trans;
 
 	/*
-	 * log transid when this inode was last modified
-	 */
-	u64 last_sub_trans;
-
-	/*
 	 * transid that last logged this inode
 	 */
 	u64 logged_trans;
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index a8336e7..896a443 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1161,7 +1161,6 @@ struct btrfs_root {
 	atomic_t log_writers;
 	atomic_t log_commit[2];
 	unsigned long log_transid;
-	unsigned long last_log_commit;
 	unsigned long log_batch;
 	pid_t log_start_pid;
 	bool log_multiple_pids;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 50e74b1..7572b2e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1099,7 +1099,6 @@ static int __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 	atomic_set(&root->log_writers, 0);
 	root->log_batch = 0;
 	root->log_transid = 0;
-	root->last_log_commit = 0;
 	extent_io_tree_init(&root->dirty_log_pages,
 			     fs_info->btree_inode->i_mapping);
 
@@ -1236,7 +1235,6 @@ int btrfs_add_log_tree(struct btrfs_trans_handle *trans,
 	WARN_ON(root->log_root);
 	root->log_root = log_root;
 	root->log_transid = 0;
-	root->last_log_commit = 0;
 	return 0;
 }
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a30b611..a1f9155 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6484,7 +6484,6 @@ again:
 	spin_unlock(&BTRFS_I(inode)->sub_trans_lock);
 
 	BTRFS_I(inode)->last_trans = root->fs_info->sub_generation;
-	BTRFS_I(inode)->last_sub_trans = BTRFS_I(inode)->root->log_transid;
 
 	unlock_extent_cached(io_tree, page_start, page_end, &cached_state, GFP_NOFS);
 
@@ -6718,7 +6717,6 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	ei->sequence = 0;
 	ei->first_sub_trans = 0;
 	ei->last_trans = 0;
-	ei->last_sub_trans = 0;
 	ei->logged_trans = 0;
 	ei->delalloc_bytes = 0;
 	ei->reserved_bytes = 0;
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index f5ca0fd..fd2474a 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -89,7 +89,6 @@ static inline void btrfs_set_inode_last_trans(struct btrfs_trans_handle *trans,
 	spin_unlock(&BTRFS_I(inode)->sub_trans_lock);
 
 	BTRFS_I(inode)->last_trans = trans->transid;
-	BTRFS_I(inode)->last_sub_trans = BTRFS_I(inode)->root->log_transid;
 }
 
 int btrfs_end_transaction(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 15b6f71..e02b8d3 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1989,7 +1989,6 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	int ret;
 	struct btrfs_root *log = root->log_root;
 	struct btrfs_root *log_root_tree = root->fs_info->log_root_tree;
-	unsigned long log_transid = 0;
 
 	mutex_lock(&root->log_mutex);
 	index1 = root->log_transid % 2;
@@ -2024,8 +2023,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
-	log_transid = root->log_transid;
-	if (log_transid % 2 == 0)
+	if (root->log_transid % 2 == 0)
 		mark = EXTENT_DIRTY;
 	else
 		mark = EXTENT_NEW;
@@ -2132,11 +2130,6 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	btrfs_scrub_continue_super(root);
 	ret = 0;
 
-	mutex_lock(&root->log_mutex);
-	if (root->last_log_commit < log_transid)
-		root->last_log_commit = log_transid;
-	mutex_unlock(&root->log_mutex);
-
 out_wake_log_root:
 	atomic_set(&log_root_tree->log_commit[index2], 0);
 	smp_mb();
@@ -3076,14 +3069,11 @@ out:
 static int inode_in_log(struct btrfs_trans_handle *trans,
 		 struct inode *inode)
 {
-	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret = 0;
 
-	mutex_lock(&root->log_mutex);
-	if (BTRFS_I(inode)->logged_trans == trans->transid &&
-	    BTRFS_I(inode)->last_sub_trans <= root->last_log_commit)
+	if (BTRFS_I(inode)->logged_trans >= trans->transaction->transid &&
+	    BTRFS_I(inode)->last_trans <= BTRFS_I(inode)->logged_trans)
 		ret = 1;
-	mutex_unlock(&root->log_mutex);
 	return ret;
 }
 
-- 
1.6.5.2

