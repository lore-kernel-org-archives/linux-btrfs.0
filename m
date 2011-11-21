From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 3/5] Btrfs: fix inconsistent tree
Date: Mon, 21 Nov 2011 18:10:22 +0800
Message-ID: <1321870224-20241-4-git-send-email-liubo2009@cn.fujitsu.com>
References: <1321870224-20241-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <chris.mason@oracle.com>, <sensille@gmx.net>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1321870224-20241-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/ctree.c       |   17 ++++++++++++++++-
 fs/btrfs/ctree.h       |    2 ++
 fs/btrfs/transaction.c |    8 ++++++++
 3 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 4a96337..2b38acd 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -571,10 +571,25 @@ static inline int should_cow_block(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root,
 				   struct extent_buffer *buf)
 {
+	/* ensure we can see the force_cow */
+	smp_rmb();
+
+	/*
+	 * We do not need to cow a block if
+	 * 1) this block is not created or changed in this transaction;
+	 * 2) this block does not belong to TREE_RELOC tree;
+	 * 3) the root is not forced COW.
+	 *
+	 * What is forced COW:
+	 *    when we create snapshot during commiting the transaction,
+	 *    after we've finished coping src root, we must COW the shared
+	 *    block to ensure the metadata consistency.
+	 */
 	if (btrfs_header_generation(buf) >= trans->transaction->transid &&
 	    !btrfs_header_flag(buf, BTRFS_HEADER_FLAG_WRITTEN) &&
 	    !(root->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID &&
-	      btrfs_header_flag(buf, BTRFS_HEADER_FLAG_RELOC)))
+	      btrfs_header_flag(buf, BTRFS_HEADER_FLAG_RELOC)) &&
+	    !root->force_cow)
 		return 0;
 	return 1;
 }
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 346ad08..a635f1c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1271,6 +1271,8 @@ struct btrfs_root {
 	 * for stat.  It may be used for more later
 	 */
 	dev_t anon_dev;
+
+	int force_cow;
 };
 
 struct btrfs_ioctl_defrag_range_args {
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index e31cdef..ee3db16 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -784,6 +784,10 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans,
 
 			btrfs_save_ino_cache(root, trans);
 
+			/* see comments in should_cow_block() */
+			root->force_cow = 0;
+			smp_wmb();
+
 			if (root->commit_root != root->node) {
 				mutex_lock(&root->fs_commit_mutex);
 				switch_commit_root(root);
@@ -947,6 +951,10 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	btrfs_tree_unlock(old);
 	free_extent_buffer(old);
 
+	/* see comments in should_cow_block() */
+	root->force_cow = 1;
+	smp_wmb();
+
 	btrfs_set_root_node(new_root_item, tmp);
 	/* record when the snapshot was created in key.offset */
 	key.offset = trans->transid;
-- 
1.6.5.2

