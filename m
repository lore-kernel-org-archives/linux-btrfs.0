From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 04/12 v3] Btrfs: introduce first sub trans
Date: Tue, 21 Jun 2011 16:49:45 +0800
Message-ID: <1308646193-7086-5-git-send-email-liubo2009@cn.fujitsu.com>
References: <1308646193-7086-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <dave@jikos.cz>, <chris.mason@oracle.com>, <josef@redhat.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1308646193-7086-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

In multi-thread situations, writeback of a file may span across several
sub transactions, and we need to introduce first_sub_trans to get sub_transid of
teh first sub transaction recorded, so that log code can skip file extents which
have been logged or committed onto disk.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/btrfs_inode.h |    9 +++++++++
 fs/btrfs/inode.c       |   13 ++++++++++++-
 fs/btrfs/transaction.h |   17 ++++++++++++++++-
 3 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 52d7eca..8eca5de 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -80,6 +80,15 @@ struct btrfs_inode {
 	/* sequence number for NFS changes */
 	u64 sequence;
 
+	/* used to avoid race of first_sub_trans */
+	spinlock_t sub_trans_lock;
+
+	/*
+	 * sub transid of the trans that first modified this inode before
+	 * a trans commit or a log sync
+	 */
+	u64 first_sub_trans;
+
 	/*
 	 * transid of the trans_handle that last modified this inode
 	 */
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ff9d4d1..93c9d22 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6468,7 +6468,16 @@ again:
 	set_page_dirty(page);
 	SetPageUptodate(page);
 
-	BTRFS_I(inode)->last_trans = root->fs_info->generation;
+	spin_lock(&BTRFS_I(inode)->sub_trans_lock);
+
+	if (BTRFS_I(inode)->first_sub_trans > root->fs_info->sub_generation ||
+	    BTRFS_I(inode)->last_trans <= BTRFS_I(inode)->logged_trans ||
+	    BTRFS_I(inode)->last_trans <= root->fs_info->last_trans_committed)
+		BTRFS_I(inode)->first_sub_trans = root->fs_info->sub_generation;
+
+	spin_unlock(&BTRFS_I(inode)->sub_trans_lock);
+
+	BTRFS_I(inode)->last_trans = root->fs_info->sub_generation;
 	BTRFS_I(inode)->last_sub_trans = BTRFS_I(inode)->root->log_transid;
 
 	unlock_extent_cached(io_tree, page_start, page_end, &cached_state, GFP_NOFS);
@@ -6714,6 +6723,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	ei->space_info = NULL;
 	ei->generation = 0;
 	ei->sequence = 0;
+	ei->first_sub_trans = 0;
 	ei->last_trans = 0;
 	ei->last_sub_trans = 0;
 	ei->logged_trans = 0;
@@ -6740,6 +6750,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	extent_io_tree_init(&ei->io_tree, &inode->i_data);
 	extent_io_tree_init(&ei->io_failure_tree, &inode->i_data);
 	mutex_init(&ei->log_mutex);
+	spin_lock_init(&ei->sub_trans_lock);
 	btrfs_ordered_inode_tree_init(&ei->ordered_tree);
 	INIT_LIST_HEAD(&ei->i_orphan);
 	INIT_LIST_HEAD(&ei->delalloc_inodes);
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 45876b0..f5ca0fd 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -73,7 +73,22 @@ struct btrfs_pending_snapshot {
 static inline void btrfs_set_inode_last_trans(struct btrfs_trans_handle *trans,
 					      struct inode *inode)
 {
-	BTRFS_I(inode)->last_trans = trans->transaction->transid;
+	spin_lock(&BTRFS_I(inode)->sub_trans_lock);
+
+	/*
+	 * We have joined in a transaction, so btrfs_commit_transaction will
+	 * definitely wait for us and it does not need to add a extra
+	 * trans_mutex lock here.
+	 */
+	if (BTRFS_I(inode)->first_sub_trans > trans->transid ||
+	    BTRFS_I(inode)->last_trans <= BTRFS_I(inode)->logged_trans ||
+	    BTRFS_I(inode)->last_trans <=
+			 BTRFS_I(inode)->root->fs_info->last_trans_committed)
+		BTRFS_I(inode)->first_sub_trans = trans->transid;
+
+	spin_unlock(&BTRFS_I(inode)->sub_trans_lock);
+
+	BTRFS_I(inode)->last_trans = trans->transid;
 	BTRFS_I(inode)->last_sub_trans = BTRFS_I(inode)->root->log_transid;
 }
 
-- 
1.6.5.2

