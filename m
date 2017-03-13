Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:12166 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751436AbdCMHwv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Mar 2017 03:52:51 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id C619248A294E
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Mar 2017 15:52:47 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 5/9] btrfs: qgroup: Cleanup btrfs_qgroup_prepare_account_extents function
Date: Mon, 13 Mar 2017 15:52:12 +0800
Message-ID: <20170313075216.5125-6-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170313075216.5125-1-quwenruo@cn.fujitsu.com>
References: <20170313075216.5125-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
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
 fs/btrfs/qgroup.c      | 49 ++++++++++++++++---------------------------------
 fs/btrfs/qgroup.h      |  2 --
 fs/btrfs/transaction.c | 10 ----------
 3 files changed, 16 insertions(+), 45 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 445014de924c..9535ea56b6f3 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1403,38 +1403,6 @@ int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
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
-		if (WARN_ON(!record->old_roots))
-			ret = btrfs_find_all_roots(NULL, fs_info,
-					record->bytenr, 0, &record->old_roots);
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
@@ -2051,6 +2019,18 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans,
 
 		if (!ret) {
 			/*
+			 * old roots should be searched when inserting qgroup
+			 * extent record
+			 */
+			if (WARN_ON(!record->old_roots)) {
+				/* Search commit root to find old_roots */
+				ret = btrfs_find_all_roots(NULL, fs_info,
+						record->bytenr, 0,
+						&record->old_roots);
+				if (ret < 0)
+					goto cleanup;
+			}
+			/*
 			 * Use (u64)-1 as time_seq to do special search, which
 			 * doesn't lock tree or delayed_refs and search current
 			 * root. It's safe inside commit_transaction().
@@ -2059,8 +2039,11 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans,
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
index 19188e094d0e..b3c77f029dfe 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -134,8 +134,6 @@ int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
 int btrfs_read_qgroup_config(struct btrfs_fs_info *fs_info);
 void btrfs_free_qgroup_config(struct btrfs_fs_info *fs_info);
 struct btrfs_delayed_extent_op;
-int btrfs_qgroup_prepare_account_extents(struct btrfs_trans_handle *trans,
-					 struct btrfs_fs_info *fs_info);
 /*
  * Inform qgroup to trace one dirty extent, its info is recorded in @record.
  * So qgroup can account it at transaction committing time.
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 894c4980c15c..edee58751eb3 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1376,9 +1376,6 @@ static int qgroup_account_snapshot(struct btrfs_trans_handle *trans,
 	ret = commit_fs_roots(trans, fs_info);
 	if (ret)
 		goto out;
-	ret = btrfs_qgroup_prepare_account_extents(trans, fs_info);
-	if (ret < 0)
-		goto out;
 	ret = btrfs_qgroup_account_extents(trans, fs_info);
 	if (ret < 0)
 		goto out;
@@ -2182,13 +2179,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 		goto scrub_continue;
 	}
 
-	ret = btrfs_qgroup_prepare_account_extents(trans, fs_info);
-	if (ret) {
-		mutex_unlock(&fs_info->tree_log_mutex);
-		mutex_unlock(&fs_info->reloc_mutex);
-		goto scrub_continue;
-	}
-
 	/*
 	 * Since fs roots are all committed, we can get a quite accurate
 	 * new_roots. So let's do quota accounting.
-- 
2.12.0



