Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35677 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751214AbcLONiY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Dec 2016 08:38:24 -0500
Received: by mail-wm0-f68.google.com with SMTP id a20so6565815wme.2
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Dec 2016 05:38:23 -0800 (PST)
From: Seraphime Kirkovski <kirkseraph@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, jbacik@fb.com, clm@fb.com,
        Seraphime Kirkovski <kirkseraph@gmail.com>
Subject: [PATCH 3/4] Btrfs: ACCESS_ONCE cleanup
Date: Thu, 15 Dec 2016 14:38:16 +0100
Message-Id: <20161215133816.25735-1-kirkseraph@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This replaces ACCESS_ONCE macro with the corresponding
READ|WRITE macros

Signed-off-by: Seraphime Kirkovski <kirkseraph@gmail.com>
---
 fs/btrfs/delayed-inode.c |  4 ++--
 fs/btrfs/super.c         |  2 +-
 fs/btrfs/transaction.c   | 10 +++++-----
 fs/btrfs/tree-log.h      |  4 ++--
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 6b23ef8..68e0e09 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -85,7 +85,7 @@ static struct btrfs_delayed_node *btrfs_get_delayed_node(struct inode *inode)
 	u64 ino = btrfs_ino(inode);
 	struct btrfs_delayed_node *node;
 
-	node = ACCESS_ONCE(btrfs_inode->delayed_node);
+	node = READ_ONCE(btrfs_inode->delayed_node);
 	if (node) {
 		atomic_inc(&node->refs);
 		return node;
@@ -1294,7 +1294,7 @@ void btrfs_remove_delayed_node(struct inode *inode)
 {
 	struct btrfs_delayed_node *delayed_node;
 
-	delayed_node = ACCESS_ONCE(BTRFS_I(inode)->delayed_node);
+	delayed_node = READ_ONCE(BTRFS_I(inode)->delayed_node);
 	if (!delayed_node)
 		return;
 
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 3e25cfe..a445d4cd 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -271,7 +271,7 @@ void __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
 			   function, line, errstr);
 		return;
 	}
-	ACCESS_ONCE(trans->transaction->aborted) = errno;
+	WRITE_ONCE(trans->transaction->aborted, errno);
 	/* Wake up anybody who may be waiting on this transaction */
 	wake_up(&fs_info->transaction_wait);
 	wake_up(&fs_info->transaction_blocked_wait);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 1bddef0..e340db1 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -859,14 +859,14 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 
 	if (lock && !atomic_read(&root->fs_info->open_ioctl_trans) &&
 	    should_end_transaction(trans, root) &&
-	    ACCESS_ONCE(cur_trans->state) == TRANS_STATE_RUNNING) {
+	    READ_ONCE(cur_trans->state) == TRANS_STATE_RUNNING) {
 		spin_lock(&info->trans_lock);
 		if (cur_trans->state == TRANS_STATE_RUNNING)
 			cur_trans->state = TRANS_STATE_BLOCKED;
 		spin_unlock(&info->trans_lock);
 	}
 
-	if (lock && ACCESS_ONCE(cur_trans->state) == TRANS_STATE_BLOCKED) {
+	if (lock && READ_ONCE(cur_trans->state) == TRANS_STATE_BLOCKED) {
 		if (throttle)
 			return btrfs_commit_transaction(trans, root);
 		else
@@ -1919,7 +1919,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	int ret;
 
 	/* Stop the commit early if ->aborted is set */
-	if (unlikely(ACCESS_ONCE(cur_trans->aborted))) {
+	if (unlikely(READ_ONCE(cur_trans->aborted))) {
 		ret = cur_trans->aborted;
 		btrfs_end_transaction(trans, root);
 		return ret;
@@ -2059,7 +2059,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 		   atomic_read(&cur_trans->num_writers) == 1);
 
 	/* ->aborted might be set after the previous check, so check it */
-	if (unlikely(ACCESS_ONCE(cur_trans->aborted))) {
+	if (unlikely(READ_ONCE(cur_trans->aborted))) {
 		ret = cur_trans->aborted;
 		goto scrub_continue;
 	}
@@ -2173,7 +2173,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	 * The tasks which save the space cache and inode cache may also
 	 * update ->aborted, check it.
 	 */
-	if (unlikely(ACCESS_ONCE(cur_trans->aborted))) {
+	if (unlikely(READ_ONCE(cur_trans->aborted))) {
 		ret = cur_trans->aborted;
 		mutex_unlock(&root->fs_info->tree_log_mutex);
 		mutex_unlock(&root->fs_info->reloc_mutex);
diff --git a/fs/btrfs/tree-log.h b/fs/btrfs/tree-log.h
index ab858e3..127eae0 100644
--- a/fs/btrfs/tree-log.h
+++ b/fs/btrfs/tree-log.h
@@ -48,13 +48,13 @@ static inline void btrfs_init_log_ctx(struct btrfs_log_ctx *ctx,
 static inline void btrfs_set_log_full_commit(struct btrfs_fs_info *fs_info,
 					     struct btrfs_trans_handle *trans)
 {
-	ACCESS_ONCE(fs_info->last_trans_log_full_commit) = trans->transid;
+	WRITE_ONCE(fs_info->last_trans_log_full_commit, trans->transid);
 }
 
 static inline int btrfs_need_log_full_commit(struct btrfs_fs_info *fs_info,
 					     struct btrfs_trans_handle *trans)
 {
-	return ACCESS_ONCE(fs_info->last_trans_log_full_commit) ==
+	return READ_ONCE(fs_info->last_trans_log_full_commit) ==
 		trans->transid;
 }
 
-- 
2.10.2

