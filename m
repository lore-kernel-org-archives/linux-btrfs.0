Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:34043 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751455AbcDFCHg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Apr 2016 22:07:36 -0400
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 61BD44056401
	for <linux-btrfs@vger.kernel.org>; Wed,  6 Apr 2016 10:06:54 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: qgroup: Fix qgroup accounting when creating snapshot
Date: Wed,  6 Apr 2016 10:04:54 +0800
Message-Id: <1459908294-11200-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Current btrfs qgroup design implies a requirement that after calling
btrfs_qgroup_account_extents() there must be a commit root switch.

Normally this is OK, as btrfs_qgroup_accounting_extents() is only called
inside btrfs_commit_transaction() just be commit_cowonly_roots().

However there is a exception at create_pending_snapshot(), which will
call btrfs_qgroup_account_extents() but no any commit root switch.

In case of creating a snapshot whose parent root is itself (create a
snapshot of fs tree), it will corrupt qgroup by the following trace:
(skipped unrelated data)
======
btrfs_qgroup_account_extent: bytenr = 29786112, num_bytes = 16384, nr_old_roots = 0, nr_new_roots = 1
qgroup_update_counters: qgid = 5, cur_old_count = 0, cur_new_count = 1, rfer = 0, excl = 0
qgroup_update_counters: qgid = 5, cur_old_count = 0, cur_new_count = 1, rfer = 16384, excl = 16384
btrfs_qgroup_account_extent: bytenr = 29786112, num_bytes = 16384, nr_old_roots = 0, nr_new_roots = 0
======

The problem here is in first qgroup_account_extent(), the
nr_new_roots of the extent is 1, which means its reference got
increased, and qgroup increased its rfer and excl.

But at second qgroup_account_extent(), its reference got decreased, but
between these two qgroup_account_extent(), there is no switch roots.
This leads to the same nr_old_roots, and this extent just got ignored by
qgroup, which means this extent is wrongly accounted.

Fix it by call commit_cowonly_roots() after qgroup_account_extent() in
create_pending_snapshot(), with needed preparation.

Reported-by: Mark Fasheh <mfasheh@suse.de>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/transaction.c | 66 +++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 49 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 43885e5..a3eb8ac 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1516,6 +1516,55 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 		goto fail;
 	}
 
+	/*
+	 * Account qgroups before insert the dir item
+	 * As such dir item insert will modify parent_root, which could be
+	 * src root. If we don't do it now, wrong accounting may be inherited
+	 * to snapshot qgroup.
+	 *
+	 * For reason locking tree_log_mutex, see btrfs_commit_transaction()
+	 * comment
+	 */
+	mutex_lock(&root->fs_info->tree_log_mutex);
+
+	ret = commit_fs_roots(trans, root);
+	if (ret) {
+		mutex_unlock(&root->fs_info->tree_log_mutex);
+		goto fail;
+	}
+
+	btrfs_apply_pending_changes(root->fs_info);
+
+	ret = btrfs_qgroup_prepare_account_extents(trans, root->fs_info);
+	if (ret < 0) {
+		mutex_unlock(&root->fs_info->tree_log_mutex);
+		goto fail;
+	}
+	ret = btrfs_qgroup_account_extents(trans, root->fs_info);
+	if (ret < 0) {
+		mutex_unlock(&root->fs_info->tree_log_mutex);
+		goto fail;
+	}
+	/*
+	 * Now qgroup are all updated, we can inherit it to new qgroups
+	 */
+	ret = btrfs_qgroup_inherit(trans, fs_info,
+				   root->root_key.objectid,
+				   objectid, pending->inherit);
+	if (ret < 0) {
+		mutex_unlock(&root->fs_info->tree_log_mutex);
+		goto fail;
+	}
+	/*
+	 * qgroup_account_extents() must be followed by a
+	 * switch_commit_roots(), or next qgroup_account_extents() will
+	 * be corrupted
+	 */
+	ret = commit_cowonly_roots(trans, root);
+	mutex_unlock(&root->fs_info->tree_log_mutex);
+	if (ret)
+		goto fail;
+
 	ret = btrfs_insert_dir_item(trans, parent_root,
 				    dentry->d_name.name, dentry->d_name.len,
 				    parent_inode, &key,
@@ -1559,23 +1608,6 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 		goto fail;
 	}
 
-	/*
-	 * account qgroup counters before qgroup_inherit()
-	 */
-	ret = btrfs_qgroup_prepare_account_extents(trans, fs_info);
-	if (ret)
-		goto fail;
-	ret = btrfs_qgroup_account_extents(trans, fs_info);
-	if (ret)
-		goto fail;
-	ret = btrfs_qgroup_inherit(trans, fs_info,
-				   root->root_key.objectid,
-				   objectid, pending->inherit);
-	if (ret) {
-		btrfs_abort_transaction(trans, root, ret);
-		goto fail;
-	}
-
 fail:
 	pending->error = ret;
 dir_item_existed:
-- 
2.8.0



