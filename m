Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:55030 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031401AbbD2CbY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Apr 2015 22:31:24 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t3T2U8ai018323
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2015 10:30:08 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 07/18] btrfs: qgroup: Add function qgroup_update_counters().
Date: Wed, 29 Apr 2015 10:29:00 +0800
Message-ID: <1430274551-9277-8-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1430274551-9277-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1430274551-9277-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add function qgroup_update_counters(), which will update related
qgroups' rfer/excl according to old/new_roots.

This is one of the two core functions for the new qgroup implement.

This is based on btrfs_adjust_coutners() but with clearer logic and
comment.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  None
---
 fs/btrfs/qgroup.c | 120 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 120 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 17a974c..a780f8f 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1761,6 +1761,126 @@ static int qgroup_update_refcnt(struct btrfs_fs_info *fs_info,
 }
 
 /*
+ * Update qgroup rfer/excl counters.
+ * Rfer update is easy, codes can explain themselves.
+ * Excl update is tricky, the update is split into 2 part.
+ * Part 1: Possible exclusive <-> sharing detect:
+ *	|	A	|	!A	|
+ *  -------------------------------------
+ *  B	|	*	|	-	|
+ *  -------------------------------------
+ *  !B	|	+	|	**	|
+ *  -------------------------------------
+ *
+ * Conditions:
+ * A:	cur_old_roots < nr_old_roots	(not exclusive before)
+ * !A:	cur_old_roots == nr_old_roots	(possible exclusive before)
+ * B:	cur_new_roots < nr_new_roots	(not exclusive now)
+ * !B:	cur_new_roots == nr_new_roots	(possible exclsuive now)
+ *
+ * Results:
+ * +: Possible sharing -> exclusive	-: Possible exclusive -> sharing
+ * *: Definitely not changed.		**: Possible unchanged.
+ *
+ * For !A and !B condition, the exception is cur_old/new_roots == 0 case.
+ *
+ * To make the logic clear, we first use condition A and B to split
+ * combination into 4 results.
+ *
+ * Then, for result "+" and "-", check old/new_roots == 0 case, as in them
+ * only on variant maybe 0.
+ *
+ * Lastly, check result **, since there are 2 variants maybe 0, split them
+ * again(2x2).
+ * But this time we don't need to consider other things, the codes and logic
+ * is easy to understand now.
+ */
+static int qgroup_update_counters(struct btrfs_fs_info *fs_info,
+				  struct ulist *qgroups,
+				  u64 nr_old_roots,
+				  u64 nr_new_roots,
+				  u64 num_bytes, u64 seq)
+{
+	struct ulist_node *unode;
+	struct ulist_iterator uiter;
+	struct btrfs_qgroup *qg;
+	u64 cur_new_count, cur_old_count;
+
+	ULIST_ITER_INIT(&uiter);
+	while ((unode = ulist_next(qgroups, &uiter))) {
+		bool dirty = false;
+
+		qg = u64_to_ptr(unode->aux);
+		cur_old_count = btrfs_qgroup_get_old_refcnt(qg, seq);
+		cur_new_count = btrfs_qgroup_get_new_refcnt(qg, seq);
+
+		/* Rfer update part */
+		if (cur_old_count == 0 && cur_new_count > 0) {
+			qg->rfer += num_bytes;
+			qg->rfer_cmpr += num_bytes;
+			dirty = true;
+		}
+		if (cur_old_count > 0 && cur_new_count == 0) {
+			qg->rfer -= num_bytes;
+			qg->rfer_cmpr -= num_bytes;
+			dirty = true;
+		}
+
+		/* Excl update part */
+		/* Exclusive/none -> shared case */
+		if (cur_old_count == nr_old_roots &&
+		    cur_new_count < nr_new_roots) {
+			/* Exclusive -> shared */
+			if (cur_old_count != 0) {
+				qg->excl -= num_bytes;
+				qg->excl_cmpr -= num_bytes;
+				dirty = true;
+			}
+		}
+
+		/* Shared -> exclusive/none case */
+		if (cur_old_count < nr_old_roots &&
+		    cur_new_count == nr_new_roots) {
+			/* Shared->exclusive */
+			if (cur_new_count != 0) {
+				qg->excl += num_bytes;
+				qg->excl_cmpr += num_bytes;
+				dirty = true;
+			}
+		}
+
+		/* Exclusive/none -> exclusive/none case */
+		if (cur_old_count == nr_old_roots &&
+		    cur_new_count == nr_new_roots) {
+			if (cur_old_count == 0) {
+				/* None -> exclusive/none */
+
+				if (cur_new_count != 0) {
+					/* None -> exclusive */
+					qg->excl += num_bytes;
+					qg->excl_cmpr += num_bytes;
+					dirty = true;
+				}
+				/* None -> none, nothing changed */
+			} else {
+				/* Exclusive -> exclusive/none */
+
+				if (cur_new_count == 0) {
+					/* Exclusive -> none */
+					qg->excl -= num_bytes;
+					qg->excl_cmpr -= num_bytes;
+					dirty = true;
+				}
+				/* Exclusive -> exclusive, nothing changed */
+			}
+		}
+		if (dirty)
+			qgroup_dirty(fs_info, qg);
+	}
+	return 0;
+}
+
+/*
  * This adjusts the counters for all referenced qgroups if need be.
  */
 static int qgroup_adjust_counters(struct btrfs_fs_info *fs_info,
-- 
2.3.6

