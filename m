Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:15396 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932231AbcK2Enx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Nov 2016 23:43:53 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
        by cn.fujitsu.com (Postfix) with ESMTP id 053AD41B4BE1
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Nov 2016 12:42:57 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs: qgroup: Cleanup btrfs_qgroup_prepare_account_extents function
Date: Tue, 29 Nov 2016 12:42:41 +0800
Message-Id: <20161129044241.27407-4-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161129044241.27407-1-quwenruo@cn.fujitsu.com>
References: <20161129044241.27407-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quite a lot of qgroup corruption happens due to wrong timing of calling
btrfs_qgroup_prepare_account_extents().

Since the safest timing is calling it just before
btrfs_qgroup_account_extents(), there is no need to separate these 2
function.

Merging them will make code cleaner and less bug prone.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c      | 41 +++++++++--------------------------------
 fs/btrfs/qgroup.h      |  2 --
 fs/btrfs/transaction.c |  9 ---------
 3 files changed, 9 insertions(+), 43 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index b9a2fd1..00e3c16 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1419,37 +1419,6 @@ out:
 	return ret;
 }
 
-int btrfs_qgroup_prepare_account_extents(struct btrfs_trans_handle *trans,
-					 struct btrfs_fs_info *fs_info)
-{
-	struct btrfs_qgroup_extent_record *record;
-	struct btrfs_delayed_ref_root *delayed_refs;
-	struct rb_node *node;
-	u64 qgroup_to_skip;
-	int ret = 0;
-
-	delayed_refs = &trans->transaction->delayed_refs;
-	qgroup_to_skip = delayed_refs->qgroup_to_skip;
-
-	/*
-	 * No need to do lock, since this function will only be called in
-	 * btrfs_commit_transaction().
-	 */
-	node = rb_first(&delayed_refs->dirty_extent_root);
-	while (node) {
-		record = rb_entry(node, struct btrfs_qgroup_extent_record,
-				  node);
-		ret = btrfs_find_all_roots(NULL, fs_info, record->bytenr, 0,
-					   &record->old_roots);
-		if (ret < 0)
-			break;
-		if (qgroup_to_skip)
-			ulist_del(record->old_roots, qgroup_to_skip, 0);
-		node = rb_next(node);
-	}
-	return ret;
-}
-
 int btrfs_qgroup_trace_extent_nolock(struct btrfs_fs_info *fs_info,
 				struct btrfs_delayed_ref_root *delayed_refs,
 				struct btrfs_qgroup_extent_record *record)
@@ -2038,6 +2007,11 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans,
 		trace_btrfs_qgroup_account_extents(fs_info, record);
 
 		if (!ret) {
+			/* Search commit root to find old_roots */
+			ret = btrfs_find_all_roots(NULL, fs_info,
+					record->bytenr, 0, &record->old_roots);
+			if (ret < 0)
+				goto cleanup;
 			/*
 			 * Use (u64)-1 as time_seq to do special search, which
 			 * doesn't lock tree or delayed_refs and search current
@@ -2047,8 +2021,11 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans,
 					record->bytenr, (u64)-1, &new_roots);
 			if (ret < 0)
 				goto cleanup;
-			if (qgroup_to_skip)
+			if (qgroup_to_skip) {
 				ulist_del(new_roots, qgroup_to_skip, 0);
+				ulist_del(record->old_roots, qgroup_to_skip,
+					  0);
+			}
 			ret = btrfs_qgroup_account_extent(trans, fs_info,
 					record->bytenr, record->num_bytes,
 					record->old_roots, new_roots);
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 99c879d..2c7f701 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -90,8 +90,6 @@ int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
 int btrfs_read_qgroup_config(struct btrfs_fs_info *fs_info);
 void btrfs_free_qgroup_config(struct btrfs_fs_info *fs_info);
 struct btrfs_delayed_extent_op;
-int btrfs_qgroup_prepare_account_extents(struct btrfs_trans_handle *trans,
-					 struct btrfs_fs_info *fs_info);
 /*
  * Inform qgroup to trace one dirty extent, its info is recorded in @record.
  * So qgroup can account it at commit trans time.
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index f65659b..47a8f489 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1346,9 +1346,6 @@ static int qgroup_account_snapshot(struct btrfs_trans_handle *trans,
 	ret = commit_fs_roots(trans, src);
 	if (ret)
 		goto out;
-	ret = btrfs_qgroup_prepare_account_extents(trans, fs_info);
-	if (ret < 0)
-		goto out;
 	ret = btrfs_qgroup_account_extents(trans, fs_info);
 	if (ret < 0)
 		goto out;
@@ -2153,12 +2150,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 		goto scrub_continue;
 	}
 
-	ret = btrfs_qgroup_prepare_account_extents(trans, root->fs_info);
-	if (ret) {
-		mutex_unlock(&root->fs_info->reloc_mutex);
-		goto scrub_continue;
-	}
-
 	/*
 	 * Since fs roots are all committed, we can get a quite accurate
 	 * new_roots. So let's do quota accounting.
-- 
2.10.2



