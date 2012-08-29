Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:18162 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab2H2HJ2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Aug 2012 03:09:28 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fusionio.com
Subject: [PATCH 1/2] Btrfs: fix a bug in checking whether a inode is already in log
Date: Wed, 29 Aug 2012 15:07:55 +0800
Message-Id: <1346224076-17573-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is based on Josef's "Btrfs: turbo charge fsync".

The current btrfs checks if an inode is in log by comparing
root's last_log_commit to inode's last_sub_trans[2].

But the problem is that this root->last_log_commit is shared among
inodes.

Say we have N inodes to be logged, after the first inode,
root's last_log_commit is updated and the N-1 remained files will
be skipped.

This fixes the bug by keeping a local copy of root's last_log_commit
inside each inode and this local copy will be maintained itself.

[1]: we regard each log transaction as a subset of btrfs's transaction,
i.e. sub_trans

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/btrfs_inode.h |   14 ++++++--------
 fs/btrfs/inode.c       |    2 ++
 fs/btrfs/transaction.h |    1 +
 fs/btrfs/tree-log.c    |    1 +
 4 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 7c7bf81..ed8ca7c 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -144,6 +144,9 @@ struct btrfs_inode {
 	/* flags field from the on disk inode */
 	u32 flags;
 
+	/* a local copy of root's last_log_commit */
+	unsigned long last_log_commit;
+
 	/*
 	 * Counters to keep track of the number of extent item's we may use due
 	 * to delalloc and such.  outstanding_extents is the number of extent
@@ -203,15 +206,10 @@ static inline bool btrfs_is_free_space_inode(struct inode *inode)
 
 static inline int btrfs_inode_in_log(struct inode *inode, u64 generation)
 {
-	struct btrfs_root *root = BTRFS_I(inode)->root;
-	int ret = 0;
-
-	mutex_lock(&root->log_mutex);
 	if (BTRFS_I(inode)->logged_trans == generation &&
-	    BTRFS_I(inode)->last_sub_trans <= root->last_log_commit)
-		ret = 1;
-	mutex_unlock(&root->log_mutex);
-	return ret;
+	    BTRFS_I(inode)->last_sub_trans <= BTRFS_I(inode)->last_log_commit)
+		return 1;
+	return 0;
 }
 
 #endif
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8879e46e..8fb6cb7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6757,6 +6757,7 @@ again:
 
 	BTRFS_I(inode)->last_trans = root->fs_info->generation;
 	BTRFS_I(inode)->last_sub_trans = BTRFS_I(inode)->root->log_transid;
+	BTRFS_I(inode)->last_log_commit = BTRFS_I(inode)->root->last_log_commit;
 
 	unlock_extent_cached(io_tree, page_start, page_end, &cached_state, GFP_NOFS);
 
@@ -7010,6 +7011,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	ei->csum_bytes = 0;
 	ei->index_cnt = (u64)-1;
 	ei->last_unlink_trans = 0;
+	ei->last_log_commit = 0;
 
 	spin_lock_init(&ei->lock);
 	ei->outstanding_extents = 0;
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index e8b8416..1a138bf 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -88,6 +88,7 @@ static inline void btrfs_set_inode_last_trans(struct btrfs_trans_handle *trans,
 {
 	BTRFS_I(inode)->last_trans = trans->transaction->transid;
 	BTRFS_I(inode)->last_sub_trans = BTRFS_I(inode)->root->log_transid;
+	BTRFS_I(inode)->last_log_commit = BTRFS_I(inode)->root->last_log_commit;
 }
 
 int btrfs_end_transaction(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index e70cdad..03af7f7 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3185,6 +3185,7 @@ next_slot:
 		}
 	}
 	BTRFS_I(inode)->logged_trans = trans->transid;
+	BTRFS_I(inode)->last_log_commit = BTRFS_I(inode)->last_sub_trans;
 out_unlock:
 	mutex_unlock(&BTRFS_I(inode)->log_mutex);
 
-- 
1.7.7.6

