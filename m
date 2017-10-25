Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:37231 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751901AbdJYCzG (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 24 Oct 2017 22:55:06 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 3/6] btrfs: qgroup: Make qgroup_reserve and its callers to use separate reservation type
Date: Wed, 25 Oct 2017 10:54:42 +0800
Message-Id: <20171025025445.16617-4-wqu@suse.com>
In-Reply-To: <20171025025445.16617-1-wqu@suse.com>
References: <20171025025445.16617-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since most caller of qgroup_reserve() is already defined by type,
converting qgroup_reserve() is quite an easy work.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 161f16c40264..2c690aa19d84 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2401,17 +2401,18 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 static bool qgroup_check_limits(const struct btrfs_qgroup *qg, u64 num_bytes)
 {
 	if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
-	    qg->reserved + (s64)qg->rfer + num_bytes > qg->max_rfer)
+	    qgroup_rsv_total(qg) + (s64)qg->rfer + num_bytes > qg->max_rfer)
 		return false;
 
 	if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_EXCL) &&
-	    qg->reserved + (s64)qg->excl + num_bytes > qg->max_excl)
+	    qgroup_rsv_total(qg) + (s64)qg->excl + num_bytes > qg->max_excl)
 		return false;
 
 	return true;
 }
 
-static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes, bool enforce)
+static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes, bool enforce,
+			  enum btrfs_qgroup_rsv_type type)
 {
 	struct btrfs_root *quota_root;
 	struct btrfs_qgroup *qgroup;
@@ -2463,7 +2464,7 @@ static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes, bool enforce)
 			 * Commit the tree and retry, since we may have
 			 * deletions which would free up space.
 			 */
-			if (!retried && qg->reserved > 0) {
+			if (!retried && qgroup_rsv_total(qg) > 0) {
 				struct btrfs_trans_handle *trans;
 
 				spin_unlock(&fs_info->qgroup_lock);
@@ -2503,7 +2504,7 @@ static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes, bool enforce)
 		qg = unode_aux_to_qgroup(unode);
 
 		trace_qgroup_update_reserve(fs_info, qg, num_bytes);
-		qg->reserved += num_bytes;
+		qgroup_rsv_add(qg, num_bytes, type);
 	}
 
 out:
@@ -2550,10 +2551,7 @@ void btrfs_qgroup_free_refroot(struct btrfs_fs_info *fs_info,
 		qg = unode_aux_to_qgroup(unode);
 
 		trace_qgroup_update_reserve(fs_info, qg, -(s64)num_bytes);
-		if (qg->reserved < num_bytes)
-			report_reserved_underflow(fs_info, qg, num_bytes);
-		else
-			qg->reserved -= num_bytes;
+		qgroup_rsv_release(qg, num_bytes, type);
 
 		list_for_each_entry(glist, &qg->groups, next_group) {
 			ret = ulist_add(fs_info->qgroup_ulist,
@@ -2941,7 +2939,7 @@ int btrfs_qgroup_reserve_data(struct inode *inode,
 					to_reserve, QGROUP_RESERVE);
 	if (ret < 0)
 		goto cleanup;
-	ret = qgroup_reserve(root, to_reserve, true);
+	ret = qgroup_reserve(root, to_reserve, true, BTRFS_QGROUP_RSV_DATA);
 	if (ret < 0)
 		goto cleanup;
 
@@ -3095,7 +3093,7 @@ int btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
 
 	BUG_ON(num_bytes != round_down(num_bytes, fs_info->nodesize));
 	trace_qgroup_meta_reserve(root, (s64)num_bytes);
-	ret = qgroup_reserve(root, num_bytes, enforce);
+	ret = qgroup_reserve(root, num_bytes, enforce, BTRFS_QGROUP_RSV_META);
 	if (ret < 0)
 		return ret;
 	atomic64_add(num_bytes, &root->qgroup_meta_rsv);
-- 
2.14.2

