Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:36751 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751949AbdJYCzG (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 24 Oct 2017 22:55:06 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 4/6] btrfs: qgroup: Fix wrong qgroup reservation update for relationship modification
Date: Wed, 25 Oct 2017 10:54:43 +0800
Message-Id: <20171025025445.16617-5-wqu@suse.com>
In-Reply-To: <20171025025445.16617-1-wqu@suse.com>
References: <20171025025445.16617-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When modifying qgroup relationship, for qgroup which only owns exclusive
extents, we will go through quick update path.

In quick update path, we will adding/substracting exclusive and reference
number for parent qgroup, since the source (child) qgroup only have
exclusive extents, destination (parent) qgroup will also own or lose these
extents exclusively.

So should be the same for reservation, since later reservation
adding/releasing will also affect parent qgroup, without the servation
carried from child, parent will underflow reservation or have dead
reservation which will never be freed.

However original code doesn't do the same thing for reservation.
It handles qgroup reservation quite differently:

It removes qgroup reservation, as it's allocating space from the
reserved qgroup for relationship adding.
But does nothing for qgroup reservation if we're removing a qgroup
relationship.

According to the original code, it looks just like because we're adding
qgroup->rfer, the code assumes we're writing new data, so it's follows
the normal write routine, by reducing qgroup->reserved and adding
qgroup->rfer/excl.

This old behavior is wrong, and should be fixed to follow the same
excl/rfer behavior.

Just fix it by using the correct behavior described above.

Fixes: 31193213f1f9 ("Btrfs: qgroup: Introduce a may_use to account space_info->bytes_may_use.")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c | 44 +++++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 2c690aa19d84..cbc31cfabf44 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1071,21 +1071,30 @@ static void report_reserved_underflow(struct btrfs_fs_info *fs_info,
 #endif
 	qgroup->reserved = 0;
 }
+
 /*
- * The easy accounting, if we are adding/removing the only ref for an extent
- * then this qgroup and all of the parent qgroups get their reference and
- * exclusive counts adjusted.
+ * The easy accounting, we're updating qgroup relationship whose child qgroup
+ * only has exclusive extents.
+ *
+ * In this case, all exclsuive extents will also be exlusive for parent, so
+ * excl/rfer just get added/removed.
+ *
+ * So is qgroup reservation space, which should also be added/removed to
+ * parent.
+ * Or when child tries to release reservation space, parent will underflow its
+ * reservation (for relationship adding case).
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
@@ -1098,13 +1107,11 @@ static int __qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
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
+	if (sign > 0)
+		qgroup_rsv_add_by_qgroup(qgroup, src);
+	else
+		qgroup_rsv_release_by_qgroup(qgroup, src);
 
 	qgroup_dirty(fs_info, qgroup);
 
@@ -1124,15 +1131,10 @@ static int __qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
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
+			qgroup_rsv_add_by_qgroup(qgroup, src);
+		else
+			qgroup_rsv_release_by_qgroup(qgroup, src);
 		qgroup->excl_cmpr += sign * num_bytes;
 		qgroup_dirty(fs_info, qgroup);
 
@@ -1175,7 +1177,7 @@ static int quick_update_accounting(struct btrfs_fs_info *fs_info,
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

