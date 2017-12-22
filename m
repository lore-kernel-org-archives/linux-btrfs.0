Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:33086 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752347AbdLVGTQ (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 22 Dec 2017 01:19:16 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 09/10] btrfs: qgroup: Commit transaction in advance to reduce early EDQUOT
Date: Fri, 22 Dec 2017 14:18:46 +0800
Message-Id: <20171222061847.13158-10-wqu@suse.com>
In-Reply-To: <20171222061847.13158-1-wqu@suse.com>
References: <20171222061847.13158-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Unlike previous method to try commit transaction inside
qgroup_reserve(), this time we will try to commit transaction using
fs_info->transaction_kthread to avoid nested transaction and no need to
worry about lock context.

Since it's an asynchronous function call and we won't wait transaction
commit, unlike previous method, we must call it before we hit qgroup
limit.

So this patch will use the ratio and size of qgroup meta_pertrans
reservation as indicator to check if we should trigger a transaction
commitment.
(meta_prealloc won't be cleaned in transaction commitment, it's useless
anyway)

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c | 43 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 41 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 6d5b476feb08..02eed4250815 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 #include <linux/btrfs.h>
+#include <linux/sizes.h>
 
 #include "ctree.h"
 #include "transaction.h"
@@ -2395,8 +2396,21 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static bool qgroup_check_limits(const struct btrfs_qgroup *qg, u64 num_bytes)
+/*
+ * Two limits to commit transaction in advance.
+ *
+ * For RATIO, it will be 1/RATIO of the remaining limit
+ * (excluding data and prealloc meta) as threshold.
+ * For SIZE, it will be in byte unit as threshold.
+ */
+#define QGROUP_PERTRANS_RATIO		32
+#define QGROUP_PERTRANS_SIZE		SZ_16M
+static bool qgroup_check_limits(struct btrfs_fs_info *fs_info,
+				const struct btrfs_qgroup *qg, u64 num_bytes)
 {
+	u64 limit;
+	u64 threshold;
+
 	if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
 	    qgroup_rsv_total(qg) + (s64)qg->rfer + num_bytes > qg->max_rfer)
 		return false;
@@ -2405,6 +2419,31 @@ static bool qgroup_check_limits(const struct btrfs_qgroup *qg, u64 num_bytes)
 	    qgroup_rsv_total(qg) + (s64)qg->excl + num_bytes > qg->max_excl)
 		return false;
 
+	/*
+	 * Even if we passed the check, it's better to check if reservation
+	 * for meta_pertrans is pushing us near limit.
+	 * If there is too much pertrans reservation or it's near the limit,
+	 * let's try commit transaction to free some, using transaction_kthread
+	 */
+	if ((qg->lim_flags & (BTRFS_QGROUP_LIMIT_MAX_RFER |
+			      BTRFS_QGROUP_LIMIT_MAX_EXCL))) {
+		if (qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_EXCL)
+			limit = qg->max_excl;
+		else
+			limit = qg->max_rfer;
+		threshold = (limit - qg->rsv.values[BTRFS_QGROUP_RSV_DATA] -
+			    qg->rsv.values[BTRFS_QGROUP_RSV_META_PREALLOC]) /
+			    QGROUP_PERTRANS_RATIO;
+		threshold = min_t(u64, threshold, QGROUP_PERTRANS_SIZE);
+
+		/*
+		 * Use transaction_kthread to commit transaction, so we no
+		 * longer need to bother nested transaction nor lock context.
+		 */
+		if (qg->rsv.values[BTRFS_QGROUP_RSV_META_PERTRANS] > threshold)
+			wake_up_process(fs_info->transaction_kthread);
+	}
+
 	return true;
 }
 
@@ -2454,7 +2493,7 @@ static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes, bool enforce,
 
 		qg = unode_aux_to_qgroup(unode);
 
-		if (enforce && !qgroup_check_limits(qg, num_bytes)) {
+		if (enforce && !qgroup_check_limits(fs_info, qg, num_bytes)) {
 			ret = -EDQUOT;
 			goto out;
 		}
-- 
2.15.1

