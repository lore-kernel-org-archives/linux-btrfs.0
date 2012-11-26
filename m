Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:22262 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753996Ab2KZIlH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Nov 2012 03:41:07 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id qAQ8f5nj006536
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2012 16:41:05 +0800
Message-ID: <50B32B39.2020908@cn.fujitsu.com>
Date: Mon, 26 Nov 2012 16:41:29 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/9] Btrfs: don't start a new transaction when starting sync
References: <50B32ABF.7040803@cn.fujitsu.com>
In-Reply-To: <50B32ABF.7040803@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If there is no running transaction in the fs, we needn't start a new one when
we want to start sync.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c       | 14 ++++++++++----
 fs/btrfs/transaction.c | 13 ++++++++-----
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index fd3fff5..5102747 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3045,16 +3045,22 @@ static noinline long btrfs_ioctl_start_sync(struct btrfs_root *root,
 	u64 transid;
 	int ret;
 
-	trans = btrfs_start_transaction(root, 0);
-	if (IS_ERR(trans))
-		return PTR_ERR(trans);
+	trans = btrfs_attach_transaction(root);
+	if (IS_ERR(trans)) {
+		if (PTR_ERR(trans) != -ENOENT)
+			return PTR_ERR(trans);
+
+		/* No running transaction, don't bother */
+		transid = root->fs_info->last_trans_committed;
+		goto out;
+	}
 	transid = trans->transid;
 	ret = btrfs_commit_transaction_async(trans, root, 0);
 	if (ret) {
 		btrfs_end_transaction(trans, root);
 		return ret;
 	}
-
+out:
 	if (argp)
 		if (copy_to_user(argp, &transid, sizeof(transid)))
 			return -EFAULT;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 04bbfb1..350e9c4 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1309,9 +1309,10 @@ static void do_async_commit(struct work_struct *work)
 	 * We've got freeze protection passed with the transaction.
 	 * Tell lockdep about it.
 	 */
-	rwsem_acquire_read(
-		&ac->root->fs_info->sb->s_writers.lock_map[SB_FREEZE_FS-1],
-		0, 1, _THIS_IP_);
+	if (ac->newtrans->type < TRANS_JOIN_NOLOCK)
+		rwsem_acquire_read(
+		     &ac->root->fs_info->sb->s_writers.lock_map[SB_FREEZE_FS-1],
+		     0, 1, _THIS_IP_);
 
 	current->journal_info = ac->newtrans;
 
@@ -1349,8 +1350,10 @@ int btrfs_commit_transaction_async(struct btrfs_trans_handle *trans,
 	 * Tell lockdep we've released the freeze rwsem, since the
 	 * async commit thread will be the one to unlock it.
 	 */
-	rwsem_release(&root->fs_info->sb->s_writers.lock_map[SB_FREEZE_FS-1],
-		      1, _THIS_IP_);
+	if (trans->type < TRANS_JOIN_NOLOCK)
+		rwsem_release(
+			&root->fs_info->sb->s_writers.lock_map[SB_FREEZE_FS-1],
+			1, _THIS_IP_);
 
 	schedule_delayed_work(&ac->work, 0);
 
-- 
1.7.11.7

