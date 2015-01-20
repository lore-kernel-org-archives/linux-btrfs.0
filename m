Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21430 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752526AbbATJHs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Jan 2015 04:07:48 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH RFC v2 3/5] btrfs: Handle pending changes in btrfs_freeze().
Date: Tue, 20 Jan 2015 17:05:35 +0800
Message-ID: <1421744737-16586-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1421744737-16586-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1421744737-16586-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before the patch, btrfs_freeze() does not start a transaction if there
is pending changes but no transaction is running.

This will lead to deadlock if the fs is frozen but there are pending
changes, since sync_fs will start a transaction with s_umount mutex,
blocked by frozen fs. And later unfreeze will wait sync_fs to release
the s_umount mutex.

This patch will ensure the frozen fs from having pending changes, except
some one use sysfs interfaces to create pending changes again.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/super.c | 52 +++++++++++++++++++++++++---------------------------
 1 file changed, 25 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 60f7cbe..5229786 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -975,32 +975,22 @@ fail_close:
 	return err;
 }
 
-int btrfs_sync_fs(struct super_block *sb, int wait)
+static int commit_current_or_new_trans(struct btrfs_fs_info *fs_info,
+				       int freezing)
 {
 	struct btrfs_trans_handle *trans;
-	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
 	struct btrfs_root *root = fs_info->tree_root;
 
-	trace_btrfs_sync_fs(wait);
-
-	if (!wait) {
-		filemap_flush(fs_info->btree_inode->i_mapping);
-		return 0;
-	}
-
-	btrfs_wait_ordered_roots(fs_info, -1);
-
 	trans = btrfs_attach_transaction_barrier(root);
 	if (IS_ERR(trans)) {
-		/* no transaction, don't bother */
 		if (PTR_ERR(trans) == -ENOENT) {
-			/*
-			 * Exit unless we have some pending changes
-			 * that need to go through commit
-			 */
+			/* No pending changes, don't bother*/
 			if (fs_info->pending_changes == 0)
 				return 0;
-			trans = btrfs_start_transaction(root, 0);
+			if (freezing)
+				trans = btrfs_start_transaction_freeze(root, 0);
+			else
+				trans = btrfs_start_transaction(root, 0);
 		} else {
 			return PTR_ERR(trans);
 		}
@@ -1008,6 +998,22 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
 	return btrfs_commit_transaction(trans, root);
 }
 
+int btrfs_sync_fs(struct super_block *sb, int wait)
+{
+	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
+
+	trace_btrfs_sync_fs(wait);
+
+	if (!wait) {
+		filemap_flush(fs_info->btree_inode->i_mapping);
+		return 0;
+	}
+
+	btrfs_wait_ordered_roots(fs_info, -1);
+
+	return commit_current_or_new_trans(fs_info, 0);
+}
+
 static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 {
 	struct btrfs_fs_info *info = btrfs_sb(dentry->d_sb);
@@ -1935,17 +1941,9 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 
 static int btrfs_freeze(struct super_block *sb)
 {
-	struct btrfs_trans_handle *trans;
-	struct btrfs_root *root = btrfs_sb(sb)->tree_root;
+	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
 
-	trans = btrfs_attach_transaction_barrier(root);
-	if (IS_ERR(trans)) {
-		/* no transaction, don't bother */
-		if (PTR_ERR(trans) == -ENOENT)
-			return 0;
-		return PTR_ERR(trans);
-	}
-	return btrfs_commit_transaction(trans, root);
+	return commit_current_or_new_trans(fs_info, 1);
 }
 
 static int btrfs_unfreeze(struct super_block *sb)
-- 
2.2.2

