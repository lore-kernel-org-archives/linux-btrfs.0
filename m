Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50751 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750752AbeBUUT1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Feb 2018 15:19:27 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CBE85ADBD
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Feb 2018 20:19:25 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH] btrfs: qgroups, properly handle no reservations
Date: Wed, 21 Feb 2018 15:19:21 -0500
Message-Id: <20180221201921.17944-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

There are several places where we call btrfs_qgroup_reserve_meta and
assume that a return value of 0 means that the reservation was successful.

Later, we use the original bytes value passed to that call to free
bytes during error handling or to pass the number of bytes reserved to
the caller.

This patch returns -ENODATA when we don't perform a reservation so that
callers can make the distinction.  This also lets call sites not
necessarily care whether qgroups are enabled.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent-tree.c | 33 ++++++++++++++++-----------------
 fs/btrfs/qgroup.c      |  4 ++--
 fs/btrfs/transaction.c |  5 ++++-
 3 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c1618ab9fecf..2d5e963fae88 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5988,20 +5988,18 @@ int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 				     u64 *qgroup_reserved,
 				     bool use_global_rsv)
 {
-	u64 num_bytes;
 	int ret;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
+	/* One for parent inode, two for dir entries */
+	u64 num_bytes = 3 * fs_info->nodesize;
 
-	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags)) {
-		/* One for parent inode, two for dir entries */
-		num_bytes = 3 * fs_info->nodesize;
-		ret = btrfs_qgroup_reserve_meta(root, num_bytes, true);
-		if (ret)
-			return ret;
-	} else {
+	ret = btrfs_qgroup_reserve_meta(root, num_bytes, true);
+	if (ret == -ENODATA) {
 		num_bytes = 0;
-	}
+		ret = 0;
+	} else if (ret)
+		return ret;
 
 	*qgroup_reserved = num_bytes;
 
@@ -6057,6 +6055,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
 	enum btrfs_reserve_flush_enum flush = BTRFS_RESERVE_FLUSH_ALL;
 	int ret = 0;
 	bool delalloc_lock = true;
+	u64 qgroup_reserved;
 
 	/* If we are a free space inode we need to not flush since we will be in
 	 * the middle of a transaction commit.  We also don't need the delalloc
@@ -6090,17 +6089,17 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
 	btrfs_calculate_inode_block_rsv_size(fs_info, inode);
 	spin_unlock(&inode->lock);
 
-	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags)) {
-		ret = btrfs_qgroup_reserve_meta(root,
-				nr_extents * fs_info->nodesize, true);
-		if (ret)
-			goto out_fail;
-	}
+	qgroup_reserved = nr_extents * fs_info->nodesize;
+	ret = btrfs_qgroup_reserve_meta(root, qgroup_reserved, true);
+	if (ret == -ENODATA) {
+		ret = 0;
+		qgroup_reserved = 0;
+	} if (ret)
+		goto out_fail;
 
 	ret = btrfs_inode_rsv_refill(inode, flush);
 	if (unlikely(ret)) {
-		btrfs_qgroup_free_meta(root,
-				       nr_extents * fs_info->nodesize);
+		btrfs_qgroup_free_meta(root, qgroup_reserved);
 		goto out_fail;
 	}
 
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index aa259d6986e1..5d9e011243c6 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3025,7 +3025,7 @@ int btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
 
 	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags) ||
 	    !is_fstree(root->objectid) || num_bytes == 0)
-		return 0;
+		return -ENODATA;
 
 	BUG_ON(num_bytes != round_down(num_bytes, fs_info->nodesize));
 	trace_qgroup_meta_reserve(root, (s64)num_bytes);
@@ -3057,7 +3057,7 @@ void btrfs_qgroup_free_meta(struct btrfs_root *root, int num_bytes)
 	struct btrfs_fs_info *fs_info = root->fs_info;
 
 	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags) ||
-	    !is_fstree(root->objectid))
+	    !is_fstree(root->objectid) || num_bytes == 0)
 		return;
 
 	BUG_ON(num_bytes != round_down(num_bytes, fs_info->nodesize));
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 04f07144b45c..ab67b73bd7fa 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -510,7 +510,10 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
 		qgroup_reserved = num_items * fs_info->nodesize;
 		ret = btrfs_qgroup_reserve_meta(root, qgroup_reserved,
 						enforce_qgroups);
-		if (ret)
+		if (ret == -ENODATA) {
+			ret = 0;
+			qgroup_reserved = 0;
+		} else if (ret)
 			return ERR_PTR(ret);
 
 		num_bytes = btrfs_calc_trans_metadata_size(fs_info, num_items);
-- 
2.15.1

