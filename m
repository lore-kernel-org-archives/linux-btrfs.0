Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:9634 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752521AbbDUGVv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Apr 2015 02:21:51 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t3L6KcRA025463
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Apr 2015 14:20:38 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 17/18] btrfs: qgroup: Add the ability to skip given qgroup for old/new_roots.
Date: Tue, 21 Apr 2015 14:21:33 +0800
Message-ID: <1429597294-11875-18-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1429597294-11875-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1429597294-11875-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is used by later qgroup fix patches for snapshot.

As current snapshot accounting is done by btrfs_qgroup_inherit(), but
new extent oriented quota mechanism will account extent from
btrfs_copy_root() and other snapshot things, causing wrong result.

So add this ability to handle snapshot accounting.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/delayed-ref.h |  8 ++++++++
 fs/btrfs/qgroup.c      |  8 ++++++++
 fs/btrfs/transaction.c |  1 +
 fs/btrfs/transaction.h | 23 +++++++++++++++++++++++
 4 files changed, 40 insertions(+)

diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index 6481de2..07b701c 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -165,6 +165,14 @@ struct btrfs_delayed_ref_root {
 	int flushing;
 
 	u64 run_delayed_start;
+
+	/*
+	 * To make qgroup to skip given root.
+	 * This is for snapshot, as btrfs_qgroup_inherit() will manully
+	 * modify counters for snapshot and its source, so we should skip
+	 * the snapshot in new_root/old_roots or it will get calculated twice
+	 */
+	u64 qgroup_to_skip;
 };
 
 extern struct kmem_cache *btrfs_delayed_ref_head_cachep;
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 01612d7..029a695 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1244,9 +1244,11 @@ int btrfs_qgroup_prepare_account_extents(struct btrfs_trans_handle *trans,
 	struct btrfs_qgroup_extent_record *record;
 	struct btrfs_delayed_ref_root *delayed_refs;
 	struct rb_node *node;
+	u64 qgroup_to_skip;
 	int ret = 0;
 
 	delayed_refs = &trans->transaction->delayed_refs;
+	qgroup_to_skip = delayed_refs->qgroup_to_skip;
 
 	/*
 	 * No need to do lock, since this function will only be called in
@@ -1260,6 +1262,8 @@ int btrfs_qgroup_prepare_account_extents(struct btrfs_trans_handle *trans,
 					   &record->old_roots);
 		if (ret < 0)
 			break;
+		if (qgroup_to_skip)
+			ulist_del(record->old_roots, qgroup_to_skip, 0);
 		node = rb_next(node);
 	}
 	return ret;
@@ -1552,9 +1556,11 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans,
 	struct btrfs_delayed_ref_root *delayed_refs;
 	struct ulist *new_roots = NULL;
 	struct rb_node *node;
+	u64 qgroup_to_skip;
 	int ret = 0;
 
 	delayed_refs = &trans->transaction->delayed_refs;
+	qgroup_to_skip = delayed_refs->qgroup_to_skip;
 	while ((node = rb_first(&delayed_refs->dirty_extent_root))) {
 		record = rb_entry(node, struct btrfs_qgroup_extent_record,
 				  node);
@@ -1569,6 +1575,8 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans,
 					record->bytenr, (u64)-1, &new_roots);
 			if (ret < 0)
 				goto cleanup;
+			if (qgroup_to_skip)
+				ulist_del(new_roots, qgroup_to_skip, 0);
 			ret = btrfs_qgroup_account_extent(trans, fs_info,
 					record->bytenr, record->num_bytes,
 					record->old_roots, new_roots);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index eaea170..2b50ce4 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -230,6 +230,7 @@ loop:
 	cur_trans->delayed_refs.num_heads = 0;
 	cur_trans->delayed_refs.flushing = 0;
 	cur_trans->delayed_refs.run_delayed_start = 0;
+	cur_trans->delayed_refs.qgroup_to_skip = 0;
 
 	/*
 	 * although the tree mod log is per file system and not per transaction,
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 937050a..c7cb8aa 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -141,6 +141,29 @@ static inline void btrfs_set_inode_last_trans(struct btrfs_trans_handle *trans,
 	BTRFS_I(inode)->last_log_commit = BTRFS_I(inode)->root->last_log_commit;
 }
 
+/*
+ * Make qgroup codes to skip given qgroupid, means the old/new_roots for
+ * qgroup won't contain the qgroupid in it.
+ */
+static inline void btrfs_set_skip_qgroup(struct btrfs_trans_handle *trans,
+					 u64 qgroupid)
+{
+	struct btrfs_delayed_ref_root *delayed_refs;
+
+	delayed_refs = &trans->transaction->delayed_refs;
+	WARN_ON(delayed_refs->qgroup_to_skip);
+	delayed_refs->qgroup_to_skip = qgroupid;
+}
+
+static inline void btrfs_clear_skip_qgroup(struct btrfs_trans_handle *trans)
+{
+	struct btrfs_delayed_ref_root *delayed_refs;
+
+	delayed_refs = &trans->transaction->delayed_refs;
+	WARN_ON(!delayed_refs->qgroup_to_skip);
+	delayed_refs->qgroup_to_skip = 0;
+}
+
 int btrfs_end_transaction(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_start_transaction(struct btrfs_root *root,
-- 
2.3.5

