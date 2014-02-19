Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:46803 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751851AbaBSMAJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Feb 2014 07:00:09 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1JBQ2uO026055
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Feb 2014 19:26:22 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/4] Btrfs: fix a possible deadlock between scrub and transaction committing
Date: Wed, 19 Feb 2014 19:24:16 +0800
Message-Id: <1392809059-22319-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_scrub_continue() will be called when cleaning up transaction.However,
this can only be called if btrfs_scrub_pause() is called before.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/transaction.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 34cd831..84da666 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1578,8 +1578,6 @@ static void cleanup_transaction(struct btrfs_trans_handle *trans,
 
 	trace_btrfs_transaction_commit(root);
 
-	btrfs_scrub_continue(root);
-
 	if (current->journal_info == trans)
 		current->journal_info = NULL;
 
@@ -1754,7 +1752,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	/* ->aborted might be set after the previous check, so check it */
 	if (unlikely(ACCESS_ONCE(cur_trans->aborted))) {
 		ret = cur_trans->aborted;
-		goto cleanup_transaction;
+		goto scrub_continue;
 	}
 	/*
 	 * the reloc mutex makes sure that we stop
@@ -1771,7 +1769,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	ret = create_pending_snapshots(trans, root->fs_info);
 	if (ret) {
 		mutex_unlock(&root->fs_info->reloc_mutex);
-		goto cleanup_transaction;
+		goto scrub_continue;
 	}
 
 	/*
@@ -1787,13 +1785,13 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	ret = btrfs_run_delayed_items(trans, root);
 	if (ret) {
 		mutex_unlock(&root->fs_info->reloc_mutex);
-		goto cleanup_transaction;
+		goto scrub_continue;
 	}
 
 	ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
 	if (ret) {
 		mutex_unlock(&root->fs_info->reloc_mutex);
-		goto cleanup_transaction;
+		goto scrub_continue;
 	}
 
 	/*
@@ -1823,7 +1821,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	if (ret) {
 		mutex_unlock(&root->fs_info->tree_log_mutex);
 		mutex_unlock(&root->fs_info->reloc_mutex);
-		goto cleanup_transaction;
+		goto scrub_continue;
 	}
 
 	/*
@@ -1844,7 +1842,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	if (ret) {
 		mutex_unlock(&root->fs_info->tree_log_mutex);
 		mutex_unlock(&root->fs_info->reloc_mutex);
-		goto cleanup_transaction;
+		goto scrub_continue;
 	}
 
 	/*
@@ -1855,7 +1853,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 		ret = cur_trans->aborted;
 		mutex_unlock(&root->fs_info->tree_log_mutex);
 		mutex_unlock(&root->fs_info->reloc_mutex);
-		goto cleanup_transaction;
+		goto scrub_continue;
 	}
 
 	btrfs_prepare_extent_commit(trans, root);
@@ -1891,13 +1889,13 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 		btrfs_error(root->fs_info, ret,
 			    "Error while writing out transaction");
 		mutex_unlock(&root->fs_info->tree_log_mutex);
-		goto cleanup_transaction;
+		goto scrub_continue;
 	}
 
 	ret = write_ctree_super(trans, root, 0);
 	if (ret) {
 		mutex_unlock(&root->fs_info->tree_log_mutex);
-		goto cleanup_transaction;
+		goto scrub_continue;
 	}
 
 	/*
@@ -1940,6 +1938,8 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 
 	return ret;
 
+scrub_continue:
+	btrfs_scrub_continue(root);
 cleanup_transaction:
 	btrfs_trans_release_metadata(trans, root);
 	trans->block_rsv = NULL;
-- 
1.8.3.1

