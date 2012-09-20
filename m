Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:28248 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753351Ab2ITHyC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Sep 2012 03:54:02 -0400
Message-ID: <505ACB98.3060400@cn.fujitsu.com>
Date: Thu, 20 Sep 2012 15:54:00 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] Btrfs: fix orphan transaction on the freezed filesystem
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With the following debug patch:

 static int btrfs_freeze(struct super_block *sb)
 {
+ 	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
+	struct btrfs_transaction *trans;
+
+	spin_lock(&fs_info->trans_lock);
+	trans = fs_info->running_transaction;
+	if (trans) {
+		printk("Transid %llu, use_count %d, num_writer %d\n",
+			trans->transid, atomic_read(&trans->use_count),
+			atomic_read(&trans->num_writers));
+	}
+	spin_unlock(&fs_info->trans_lock);
 	return 0;
 }

I found there was a orphan transaction after the freeze operation was done.

It is because the transaction may not be committed when the transaction handle
end even though it is the last handle of the current transaction. This design
avoid committing the transaction frequently, but also introduce the above
problem.

So I add btrfs_attach_transaction() which can catch the current transaction
and commit it. If there is no transaction, it will return ENOENT, and do not
anything.

This function also can be used to instead of btrfs_join_transaction_freeze()
because it don't increase the writer counter and don't start a new transaction,
so it also can fix the deadlock between sync and freeze.

Besides that, it is used to instead of btrfs_join_transaction() in
transaction_kthread(), because if there is no transaction, the transaction
kthread needn't anything.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
This patch is based on btrfs-next tree.
---
 fs/btrfs/disk-io.c     |    5 +++--
 fs/btrfs/super.c       |   18 ++++++++++++++----
 fs/btrfs/transaction.c |   45 ++++++++++++++++++++++++++++++---------------
 fs/btrfs/transaction.h |    4 ++--
 4 files changed, 49 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 34717ac..e8dd01d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1667,9 +1667,10 @@ static int transaction_kthread(void *arg)
 		spin_unlock(&root->fs_info->trans_lock);
 
 		/* If the file system is aborted, this will always fail. */
-		trans = btrfs_join_transaction(root);
+		trans = btrfs_attach_transaction(root);
 		if (IS_ERR(trans)) {
-			cannot_commit = true;
+			if (PTR_ERR(trans) != -ENOENT)
+				cannot_commit = true;
 			goto sleep;
 		}
 		if (transid == trans->transid) {
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 4be4758..a6afb42 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -854,10 +854,10 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
 
 	btrfs_wait_ordered_extents(root, 0, 0);
 
-	trans = btrfs_join_transaction_freeze(root);
+	trans = btrfs_attach_transaction(root);
 	if (IS_ERR(trans)) {
-		/* Frozen, don't bother */
-		if (PTR_ERR(trans) == -EPERM)
+		/* no transaction, don't bother */
+		if (PTR_ERR(trans) == -ENOENT)
 			return 0;
 		return PTR_ERR(trans);
 	}
@@ -1511,7 +1511,17 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 
 static int btrfs_freeze(struct super_block *sb)
 {
-	return 0;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *root = btrfs_sb(sb)->tree_root;
+
+	trans = btrfs_attach_transaction(root);
+	if (IS_ERR(trans)) {
+		/* no transaction, don't bother */
+		if (PTR_ERR(trans) == -ENOENT)
+			return 0;
+		return PTR_ERR(trans);
+	}
+	return btrfs_commit_transaction(trans, root);
 }
 
 static int btrfs_unfreeze(struct super_block *sb)
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 5eb4adf..577f636 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -53,7 +53,7 @@ static noinline void switch_commit_root(struct btrfs_root *root)
 /*
  * either allocate a new transaction or hop into the existing one
  */
-static noinline int join_transaction(struct btrfs_root *root, int nofail)
+static noinline int join_transaction(struct btrfs_root *root, int type)
 {
 	struct btrfs_transaction *cur_trans;
 	struct btrfs_fs_info *fs_info = root->fs_info;
@@ -67,7 +67,13 @@ loop:
 	}
 
 	if (fs_info->trans_no_join) {
-		if (!nofail) {
+		/* 
+		 * If we are JOIN_NOLOCK we're already committing a current
+		 * transaction, we just need a handle to deal with something
+		 * when committing the transaction, such as inode cache and
+		 * space cache. It is a special case.
+		 */
+		if (type != TRANS_JOIN_NOLOCK) {
 			spin_unlock(&fs_info->trans_lock);
 			return -EBUSY;
 		}
@@ -87,6 +93,13 @@ loop:
 	}
 	spin_unlock(&fs_info->trans_lock);
 
+	/*
+	 * If we are ATTACH, we just want to catch the current transaction,
+	 * and commit it. If there is no transaction, just return ENOENT.
+	 */
+	if (type == TRANS_ATTACH)
+		return -ENOENT;
+
 	cur_trans = kmem_cache_alloc(btrfs_transaction_cachep, GFP_NOFS);
 	if (!cur_trans)
 		return -ENOMEM;
@@ -340,27 +353,28 @@ again:
 	 * because we're already holding a ref.  We need this because we could
 	 * have raced in and did an fsync() on a file which can kick a commit
 	 * and then we deadlock with somebody doing a freeze.
+	 *
+	 * If we are ATTACH, it means we just want to catch the current
+	 * transaction and commit it, so we needn't do sb_start_intwrite(). 
 	 */
-	if (type != TRANS_JOIN_NOLOCK &&
-	    !__sb_start_write(root->fs_info->sb, SB_FREEZE_FS, false)) {
-		if (type == TRANS_JOIN_FREEZE) {
-			kmem_cache_free(btrfs_trans_handle_cachep, h);
-			return ERR_PTR(-EPERM);
-		}
+	if (type < TRANS_JOIN_NOLOCK)
 		sb_start_intwrite(root->fs_info->sb);
-	}
 
 	if (may_wait_transaction(root, type))
 		wait_current_trans(root);
 
 	do {
-		ret = join_transaction(root, type == TRANS_JOIN_NOLOCK);
+		ret = join_transaction(root, type);
 		if (ret == -EBUSY)
 			wait_current_trans(root);
 	} while (ret == -EBUSY);
 
 	if (ret < 0) {
-		sb_end_intwrite(root->fs_info->sb);
+		/* We must get the transaction if we are JOIN_NOLOCK. */
+		BUG_ON(type == TRANS_JOIN_NOLOCK);
+
+		if (type < TRANS_JOIN_NOLOCK)
+			sb_end_intwrite(root->fs_info->sb);
 		kmem_cache_free(btrfs_trans_handle_cachep, h);
 		return ERR_PTR(ret);
 	}
@@ -431,9 +445,9 @@ struct btrfs_trans_handle *btrfs_start_ioctl_transaction(struct btrfs_root *root
 	return start_transaction(root, 0, TRANS_USERSPACE, 0);
 }
 
-struct btrfs_trans_handle *btrfs_join_transaction_freeze(struct btrfs_root *root)
+struct btrfs_trans_handle *btrfs_attach_transaction(struct btrfs_root *root)
 {
-	return start_transaction(root, 0, TRANS_JOIN_FREEZE, 0);
+	return start_transaction(root, 0, TRANS_ATTACH, 0);
 }
 
 /* wait for a transaction commit to be fully complete */
@@ -598,7 +612,7 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 		}
 	}
 
-	if (lock)
+	if (trans->type < TRANS_JOIN_NOLOCK)
 		sb_end_intwrite(root->fs_info->sb);
 
 	WARN_ON(cur_trans != info->running_transaction);
@@ -1650,7 +1664,8 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	put_transaction(cur_trans);
 	put_transaction(cur_trans);
 
-	sb_end_intwrite(root->fs_info->sb);
+	if (trans->type < TRANS_JOIN_NOLOCK)
+		sb_end_intwrite(root->fs_info->sb);
 
 	trace_btrfs_transaction_commit(root);
 
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 1052397..9303e37 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -52,7 +52,7 @@ enum btrfs_trans_type {
 	TRANS_JOIN,
 	TRANS_USERSPACE,
 	TRANS_JOIN_NOLOCK,
-	TRANS_JOIN_FREEZE,
+	TRANS_ATTACH,
 };
 
 struct btrfs_trans_handle {
@@ -107,7 +107,7 @@ struct btrfs_trans_handle *btrfs_start_transaction_noflush(
 					struct btrfs_root *root, int num_items);
 struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_join_transaction_nolock(struct btrfs_root *root);
-struct btrfs_trans_handle *btrfs_join_transaction_freeze(struct btrfs_root *root);
+struct btrfs_trans_handle *btrfs_attach_transaction(struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_start_ioctl_transaction(struct btrfs_root *root);
 int btrfs_wait_for_commit(struct btrfs_root *root, u64 transid);
 int btrfs_write_and_wait_transaction(struct btrfs_trans_handle *trans,
-- 
1.7.6.5
