Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:22066 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933374Ab3BTJQT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Feb 2013 04:16:19 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r1K9GGSZ031326
	for <linux-btrfs@vger.kernel.org>; Wed, 20 Feb 2013 17:16:16 +0800
Message-ID: <51249492.7030907@cn.fujitsu.com>
Date: Wed, 20 Feb 2013 17:17:06 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/3] Btrfs: fix uncompleted transaction
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In some cases, we need commit the current transaction, but don't want
to start a new one if there is no running transaction, so we introduce
the function - btrfs_attach_transaction(), which can catch the current
transaction, and return -ENOENT if there is no running transaction.

But no running transaction doesn't mean the current transction completely,
because we removed the running transaction before it completes. In some
cases, it doesn't matter. But in some special cases, such as freeze fs, we
hope the transaction is fully on disk, it will introduce some bugs, for
example, we may feeze the fs and dump the data in the disk, if the transction
doesn't complete, we would dump inconsistent data. So we need fix the above
problem for those cases.

We fixes this problem by introducing a function:
	btrfs_attach_transaction_barrier()
if we hope all the transaction is fully on the disk, even they are not
running, we can use this function.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c       |    2 +-
 fs/btrfs/super.c       |    4 ++--
 fs/btrfs/transaction.c |   32 ++++++++++++++++++++++++++++++++
 fs/btrfs/transaction.h |    2 ++
 4 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a31cd93..7cbbc2a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3111,7 +3111,7 @@ static noinline long btrfs_ioctl_start_sync(struct btrfs_root *root,
 	u64 transid;
 	int ret;
 
-	trans = btrfs_attach_transaction(root);
+	trans = btrfs_attach_transaction_barrier(root);
 	if (IS_ERR(trans)) {
 		if (PTR_ERR(trans) != -ENOENT)
 			return PTR_ERR(trans);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index d8982e9..74328f7 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -876,7 +876,7 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
 
 	btrfs_wait_ordered_extents(root, 0);
 
-	trans = btrfs_attach_transaction(root);
+	trans = btrfs_attach_transaction_barrier(root);
 	if (IS_ERR(trans)) {
 		/* no transaction, don't bother */
 		if (PTR_ERR(trans) == -ENOENT)
@@ -1559,7 +1559,7 @@ static int btrfs_freeze(struct super_block *sb)
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = btrfs_sb(sb)->tree_root;
 
-	trans = btrfs_attach_transaction(root);
+	trans = btrfs_attach_transaction_barrier(root);
 	if (IS_ERR(trans)) {
 		/* no transaction, don't bother */
 		if (PTR_ERR(trans) == -ENOENT)
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 71b7e2e..257f320 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -468,11 +468,43 @@ struct btrfs_trans_handle *btrfs_start_ioctl_transaction(struct btrfs_root *root
 	return start_transaction(root, 0, TRANS_USERSPACE, 0);
 }
 
+/*
+ * btrfs_attach_transaction() - catch the running transaction
+ *
+ * It is used when we want to commit the current the transaction, but
+ * don't want to start a new one.
+ *
+ * Note: If this function return -ENOENT, it just means there is no
+ * running transaction. But it is possible that the inactive transaction
+ * is still in the memory, not fully on disk. If you hope there is no
+ * inactive transaction in the fs when -ENOENT is returned, you should
+ * invoke
+ *     btrfs_attach_transaction_barrier()
+ */
 struct btrfs_trans_handle *btrfs_attach_transaction(struct btrfs_root *root)
 {
 	return start_transaction(root, 0, TRANS_ATTACH, 0);
 }
 
+/*
+ * btrfs_attach_transaction() - catch the running transaction
+ *
+ * It is similar to the above function, the differentia is this one
+ * will wait for all the inactive transactions until they fully
+ * complete.
+ */
+struct btrfs_trans_handle *
+btrfs_attach_transaction_barrier(struct btrfs_root *root)
+{
+	struct btrfs_trans_handle *trans;
+
+	trans = start_transaction(root, 0, TRANS_ATTACH, 0);
+	if (IS_ERR(trans) && PTR_ERR(trans) == -ENOENT)
+		btrfs_wait_for_commit(root, 0);
+
+	return trans;
+}
+
 /* wait for a transaction commit to be fully complete */
 static noinline void wait_for_commit(struct btrfs_root *root,
 				    struct btrfs_transaction *commit)
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 0e8aa1e..422a865 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -110,6 +110,8 @@ struct btrfs_trans_handle *btrfs_start_transaction_lflush(
 struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_join_transaction_nolock(struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_attach_transaction(struct btrfs_root *root);
+struct btrfs_trans_handle *btrfs_attach_transaction_barrier(
+					struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_start_ioctl_transaction(struct btrfs_root *root);
 int btrfs_wait_for_commit(struct btrfs_root *root, u64 transid);
 int btrfs_write_and_wait_transaction(struct btrfs_trans_handle *trans,
-- 
1.6.5.2
