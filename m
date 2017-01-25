Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42668 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750765AbdAYOuh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Jan 2017 09:50:37 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B8450ACA1
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jan 2017 14:50:35 +0000 (UTC)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH] btrfs: allow unlink to exceed subvolume quota
Message-ID: <a9139e75-cf3f-301a-9de4-a2bcfa718a70@suse.com>
Date: Wed, 25 Jan 2017 09:50:33 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Once a qgroup limit is exceeded, it's impossible to restore normal
operation to the subvolume without modifying the limit or removing
the subvolume.  This is a surprising situation for many users used
to the typical workflow with quotas on other file systems where it's
possible to remove files until the used space is back under the limit.

When we go to unlink a file and start the transaction, we'll hit
the qgroup limit while trying to reserve space for the items we'll
modify while removing the file.  We discussed last month how best
to handle this situation and agreed that there is no perfect solution.
The best principle-of-least-surprise solution is to handle it similarly
to how we already handle ENOSPC when unlinking, which is to allow
the operation to succeed with the expectation that it will ultimately
release space under most circumstances.

This patch modifies the transaction start path to select whether to
honor the qgroups limits.  btrfs_start_transaction_fallback_global_rsv
is the only caller that skips enforcement.  The reservation and tracking
still happens normally -- it just skips the enforcement step.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent-tree.c |    4 ++--
 fs/btrfs/qgroup.c      |   34 ++++++++++++++++++++--------------
 fs/btrfs/qgroup.h      |    3 ++-
 fs/btrfs/transaction.c |   34 ++++++++++++++++++++++------------
 4 files changed, 46 insertions(+), 29 deletions(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5799,7 +5799,7 @@ int btrfs_subvolume_reserve_metadata(str
 	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags)) {
 		/* One for parent inode, two for dir entries */
 		num_bytes = 3 * fs_info->nodesize;
-		ret = btrfs_qgroup_reserve_meta(root, num_bytes);
+		ret = btrfs_qgroup_reserve_meta(root, num_bytes, true);
 		if (ret)
 			return ret;
 	} else {
@@ -5979,7 +5979,7 @@ int btrfs_delalloc_reserve_metadata(stru
 
 	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags)) {
 		ret = btrfs_qgroup_reserve_meta(root,
-				nr_extents * fs_info->nodesize);
+				nr_extents * fs_info->nodesize, true);
 		if (ret)
 			goto out_fail;
 	}
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2306,7 +2306,21 @@ out:
 	return ret;
 }
 
-static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
+static bool qgroup_check_limits(const struct btrfs_qgroup *qg, u64 num_bytes)
+{
+	if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
+	    qg->reserved + (s64)qg->rfer + num_bytes > qg->max_rfer)
+		return false;
+
+	if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_EXCL) &&
+	    qg->reserved + (s64)qg->excl + num_bytes > qg->max_excl)
+		return false;
+
+	return true;
+}
+
+
+static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes, bool enforce)
 {
 	struct btrfs_root *quota_root;
 	struct btrfs_qgroup *qgroup;
@@ -2347,16 +2361,7 @@ static int qgroup_reserve(struct btrfs_r
 
 		qg = unode_aux_to_qgroup(unode);
 
-		if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
-		    qg->reserved + (s64)qg->rfer + num_bytes >
-		    qg->max_rfer) {
-			ret = -EDQUOT;
-			goto out;
-		}
-
-		if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_EXCL) &&
-		    qg->reserved + (s64)qg->excl + num_bytes >
-		    qg->max_excl) {
+		if (enforce && !qgroup_check_limits(qg, num_bytes)) {
 			ret = -EDQUOT;
 			goto out;
 		}
@@ -2811,7 +2816,7 @@ int btrfs_qgroup_reserve_data(struct ino
 					QGROUP_RESERVE);
 	if (ret < 0)
 		goto cleanup;
-	ret = qgroup_reserve(root, changeset.bytes_changed);
+	ret = qgroup_reserve(root, changeset.bytes_changed, true);
 	if (ret < 0)
 		goto cleanup;
 
@@ -2892,7 +2897,8 @@ int btrfs_qgroup_release_data(struct ino
 	return __btrfs_qgroup_release_data(inode, start, len, 0);
 }
 
-int btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes)
+int btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
+			      bool enforce)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	int ret;
@@ -2902,7 +2908,7 @@ int btrfs_qgroup_reserve_meta(struct btr
 		return 0;
 
 	BUG_ON(num_bytes != round_down(num_bytes, fs_info->nodesize));
-	ret = qgroup_reserve(root, num_bytes);
+	ret = qgroup_reserve(root, num_bytes, enforce);
 	if (ret < 0)
 		return ret;
 	atomic_add(num_bytes, &root->qgroup_meta_rsv);
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -181,7 +181,8 @@ int btrfs_qgroup_reserve_data(struct ino
 int btrfs_qgroup_release_data(struct inode *inode, u64 start, u64 len);
 int btrfs_qgroup_free_data(struct inode *inode, u64 start, u64 len);
 
-int btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes);
+int btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
+			      bool enforce);
 void btrfs_qgroup_free_meta_all(struct btrfs_root *root);
 void btrfs_qgroup_free_meta(struct btrfs_root *root, int num_bytes);
 void btrfs_qgroup_check_reserved_leak(struct inode *inode);
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -474,7 +474,8 @@ static inline bool need_reserve_reloc_ro
 
 static struct btrfs_trans_handle *
 start_transaction(struct btrfs_root *root, unsigned int num_items,
-		  unsigned int type, enum btrfs_reserve_flush_enum flush)
+		  unsigned int type, enum btrfs_reserve_flush_enum flush,
+		  bool enforce_qgroups)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 
@@ -505,9 +506,10 @@ start_transaction(struct btrfs_root *roo
 	 * Do the reservation before we join the transaction so we can do all
 	 * the appropriate flushing if need be.
 	 */
-	if (num_items > 0 && root != fs_info->chunk_root) {
+	if (num_items && root != fs_info->chunk_root) {
 		qgroup_reserved = num_items * fs_info->nodesize;
-		ret = btrfs_qgroup_reserve_meta(root, qgroup_reserved);
+		ret = btrfs_qgroup_reserve_meta(root, qgroup_reserved,
+						enforce_qgroups);
 		if (ret)
 			return ERR_PTR(ret);
 
@@ -613,8 +615,9 @@ struct btrfs_trans_handle *btrfs_start_t
 						   unsigned int num_items)
 {
 	return start_transaction(root, num_items, TRANS_START,
-				 BTRFS_RESERVE_FLUSH_ALL);
+				 BTRFS_RESERVE_FLUSH_ALL, true);
 }
+
 struct btrfs_trans_handle *btrfs_start_transaction_fallback_global_rsv(
 					struct btrfs_root *root,
 					unsigned int num_items,
@@ -625,7 +628,14 @@ struct btrfs_trans_handle *btrfs_start_t
 	u64 num_bytes;
 	int ret;
 
-	trans = btrfs_start_transaction(root, num_items);
+	/*
+	 * We have two callers: unlink and block group removal.  The
+	 * former should succeed even if we will temporarily exceed
+	 * quota and the latter operates on the extent root so
+	 * qgroup enforcement is ignored anyway.
+	 */
+	trans = start_transaction(root, num_items, TRANS_START,
+				  BTRFS_RESERVE_FLUSH_ALL, false);
 	if (!IS_ERR(trans) || PTR_ERR(trans) != -ENOSPC)
 		return trans;
 
@@ -654,25 +664,25 @@ struct btrfs_trans_handle *btrfs_start_t
 					unsigned int num_items)
 {
 	return start_transaction(root, num_items, TRANS_START,
-				 BTRFS_RESERVE_FLUSH_LIMIT);
+				 BTRFS_RESERVE_FLUSH_LIMIT, true);
 }
 
 struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root)
 {
-	return start_transaction(root, 0, TRANS_JOIN,
-				 BTRFS_RESERVE_NO_FLUSH);
+	return start_transaction(root, 0, TRANS_JOIN, BTRFS_RESERVE_NO_FLUSH,
+				 true);
 }
 
 struct btrfs_trans_handle *btrfs_join_transaction_nolock(struct btrfs_root *root)
 {
 	return start_transaction(root, 0, TRANS_JOIN_NOLOCK,
-				 BTRFS_RESERVE_NO_FLUSH);
+				 BTRFS_RESERVE_NO_FLUSH, true);
 }
 
 struct btrfs_trans_handle *btrfs_start_ioctl_transaction(struct btrfs_root *root)
 {
 	return start_transaction(root, 0, TRANS_USERSPACE,
-				 BTRFS_RESERVE_NO_FLUSH);
+				 BTRFS_RESERVE_NO_FLUSH, true);
 }
 
 /*
@@ -691,7 +701,7 @@ struct btrfs_trans_handle *btrfs_start_i
 struct btrfs_trans_handle *btrfs_attach_transaction(struct btrfs_root *root)
 {
 	return start_transaction(root, 0, TRANS_ATTACH,
-				 BTRFS_RESERVE_NO_FLUSH);
+				 BTRFS_RESERVE_NO_FLUSH, true);
 }
 
 /*
@@ -707,7 +717,7 @@ btrfs_attach_transaction_barrier(struct
 	struct btrfs_trans_handle *trans;
 
 	trans = start_transaction(root, 0, TRANS_ATTACH,
-				  BTRFS_RESERVE_NO_FLUSH);
+				  BTRFS_RESERVE_NO_FLUSH, true);
 	if (IS_ERR(trans) && PTR_ERR(trans) == -ENOENT)
 		btrfs_wait_for_commit(root->fs_info, 0);
 
