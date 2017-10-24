Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:35517 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751712AbdJXIkK (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 24 Oct 2017 04:40:10 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, jeffm@suse.com
Subject: [PATCH 4/6] btrfs: qgroup: Fix wrong qgroup reservation inheritance for relationship update
Date: Tue, 24 Oct 2017 16:39:39 +0800
Message-Id: <20171024083941.21428-5-wqu@suse.com>
In-Reply-To: <20171024083941.21428-1-wqu@suse.com>
References: <20171024083941.21428-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When modifying qgroup relationship, for qgroup which only owns exclusive
extents, we will go through quick update path.

In quick update path, we will just adding/removing exclusive and reference
number.

However we did the opposite for qgroup reservation from the very
beginning.

In fact, we should also inherit the qgroup reservation space, just like
exclusive and reference numbers.

Fix by using the newly introduced
qgroup_rsv_increase/decrease_by_qgroup() function call.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c | 39 ++++++++++++++++++---------------------
 1 file changed, 18 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 7b89da9589c1..ba6f60fd0e96 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1069,21 +1069,24 @@ static void report_reserved_underflow(struct btrfs_fs_info *fs_info,
 #endif
 	qgroup->reserved = 0;
 }
+
 /*
- * The easy accounting, if we are adding/removing the only ref for an extent
- * then this qgroup and all of the parent qgroups get their reference and
- * exclusive counts adjusted.
+ * The easy accounting, we're updating qgroup relationship whose child qgroup
+ * only have exclusive extents.
+ * In this case, we only need to update the rfer/excl, and inherit rsv from
+ * child qgroup (@src)
  *
  * Caller should hold fs_info->qgroup_lock.
  */
 static int __qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
 				    struct ulist *tmp, u64 ref_root,
-				    u64 num_bytes, int sign)
+				    struct btrfs_qgroup *src, int sign)
 {
 	struct btrfs_qgroup *qgroup;
 	struct btrfs_qgroup_list *glist;
 	struct ulist_node *unode;
 	struct ulist_iterator uiter;
+	u64 num_bytes = src->excl;
 	int ret = 0;
 
 	qgroup = find_qgroup_rb(fs_info, ref_root);
@@ -1096,13 +1099,12 @@ static int __qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
 	WARN_ON(sign < 0 && qgroup->excl < num_bytes);
 	qgroup->excl += sign * num_bytes;
 	qgroup->excl_cmpr += sign * num_bytes;
-	if (sign > 0) {
-		trace_qgroup_update_reserve(fs_info, qgroup, -(s64)num_bytes);
-		if (qgroup->reserved < num_bytes)
-			report_reserved_underflow(fs_info, qgroup, num_bytes);
-		else
-			qgroup->reserved -= num_bytes;
-	}
+
+	/* *Inherit* qgroup rsv info from @src */
+	if (sign > 0)
+		qgroup_rsv_increase_by_qgroup(qgroup, src);
+	else
+		qgroup_rsv_decrease_by_qgroup(qgroup, src);
 
 	qgroup_dirty(fs_info, qgroup);
 
@@ -1122,15 +1124,10 @@ static int __qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
 		qgroup->rfer_cmpr += sign * num_bytes;
 		WARN_ON(sign < 0 && qgroup->excl < num_bytes);
 		qgroup->excl += sign * num_bytes;
-		if (sign > 0) {
-			trace_qgroup_update_reserve(fs_info, qgroup,
-						    -(s64)num_bytes);
-			if (qgroup->reserved < num_bytes)
-				report_reserved_underflow(fs_info, qgroup,
-							  num_bytes);
-			else
-				qgroup->reserved -= num_bytes;
-		}
+		if (sign > 0)
+			qgroup_rsv_increase_by_qgroup(qgroup, src);
+		else
+			qgroup_rsv_decrease_by_qgroup(qgroup, src);
 		qgroup->excl_cmpr += sign * num_bytes;
 		qgroup_dirty(fs_info, qgroup);
 
@@ -1173,7 +1170,7 @@ static int quick_update_accounting(struct btrfs_fs_info *fs_info,
 	if (qgroup->excl == qgroup->rfer) {
 		ret = 0;
 		err = __qgroup_excl_accounting(fs_info, tmp, dst,
-					       qgroup->excl, sign);
+					       qgroup, sign);
 		if (err < 0) {
 			ret = err;
 			goto out;
-- 
2.14.2

