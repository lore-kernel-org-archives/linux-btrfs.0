Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:63678 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751039AbbCLIdx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Mar 2015 04:33:53 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t2C8WWwU005915
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Mar 2015 16:32:32 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: qgroup: Cleanup open-coded old/new_refcnt update and read.
Date: Thu, 12 Mar 2015 16:33:27 +0800
Message-ID: <1426149207-7534-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use inline functions to do such things, to improve readability.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 102 ++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 65 insertions(+), 37 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 97159a8..3f2a1e7 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -84,11 +84,58 @@ struct btrfs_qgroup {
 
 	/*
 	 * temp variables for accounting operations
+	 * Refer to qgroup_shared_accouting() for details.
 	 */
 	u64 old_refcnt;
 	u64 new_refcnt;
 };
 
+static void update_qg_refcnt(struct btrfs_qgroup *qg, u64 seq, int mod,
+			     int update_old)
+{
+	if (update_old) {
+		if (qg->old_refcnt < seq)
+			qg->old_refcnt = seq;
+		qg->old_refcnt += mod;
+	} else {
+		if (qg->new_refcnt < seq)
+			qg->new_refcnt = seq;
+		qg->new_refcnt += mod;
+	}
+}
+
+static void update_qg_old_refcnt(struct btrfs_qgroup *qg, u64 seq, int mod)
+{
+	update_qg_refcnt(qg, seq, mod, 1);
+}
+
+static void update_qg_new_refcnt(struct btrfs_qgroup *qg, u64 seq, int mod)
+{
+	update_qg_refcnt(qg, seq, mod, 0);
+}
+
+static inline u64 get_qg_refcnt(struct btrfs_qgroup *qg, u64 seq, int get_old)
+{
+	if (get_old) {
+		if (qg->old_refcnt < seq)
+			return 0;
+		return qg->old_refcnt - seq;
+	}
+	if (qg->new_refcnt < seq)
+		return 0;
+	return qg->new_refcnt - seq;
+}
+
+static inline u64 get_qg_old_refcnt(struct btrfs_qgroup *qg, u64 seq)
+{
+	return get_qg_refcnt(qg, seq, 1);
+}
+
+static inline u64 get_qg_new_refcnt(struct btrfs_qgroup *qg, u64 seq)
+{
+	return get_qg_refcnt(qg, seq, 0);
+}
+
 /*
  * glue structure to represent the relations between qgroups.
  */
@@ -1497,6 +1544,7 @@ static int qgroup_calc_old_refcnt(struct btrfs_fs_info *fs_info,
 		ULIST_ITER_INIT(&tmp_uiter);
 		while ((tmp_unode = ulist_next(tmp, &tmp_uiter))) {
 			struct btrfs_qgroup_list *glist;
+			int mod;
 
 			qg = u64_to_ptr(tmp_unode->aux);
 			/*
@@ -1508,20 +1556,15 @@ static int qgroup_calc_old_refcnt(struct btrfs_fs_info *fs_info,
 			 * upper level qgroups in order to determine exclusive
 			 * counts.
 			 *
-			 * For rescan we want to set old_refcnt to seq so our
-			 * exclusive calculations end up correct.
+			 * For rescan none of the extent is recorded before so
+			 * we just don't add old_refcnt.
 			 */
 			if (rescan)
-				qg->old_refcnt = seq;
-			else if (qg->old_refcnt < seq)
-				qg->old_refcnt = seq + 1;
+				mod = 0;
 			else
-				qg->old_refcnt++;
-
-			if (qg->new_refcnt < seq)
-				qg->new_refcnt = seq + 1;
-			else
-				qg->new_refcnt++;
+				mod = 1;
+			update_qg_old_refcnt(qg, seq, mod);
+			update_qg_new_refcnt(qg, seq, 1);
 			list_for_each_entry(glist, &qg->groups, next_group) {
 				ret = ulist_add(qgroups, glist->group->qgroupid,
 						ptr_to_u64(glist->group),
@@ -1619,10 +1662,8 @@ next:
 			qg->old_refcnt = seq + 1;
 		else
 			qg->old_refcnt++;
-		if (qg->new_refcnt < seq)
-			qg->new_refcnt = seq + 1;
-		else
-			qg->new_refcnt++;
+		update_qg_old_refcnt(qg, seq, 1);
+		update_qg_new_refcnt(qg, seq, 1);
 		list_for_each_entry(glist, &qg->groups, next_group) {
 			ret = ulist_add(qgroups, glist->group->qgroupid,
 					ptr_to_u64(glist->group), GFP_ATOMIC);
@@ -1663,17 +1704,10 @@ static int qgroup_calc_new_refcnt(struct btrfs_fs_info *fs_info,
 		struct btrfs_qgroup_list *glist;
 
 		qg = u64_to_ptr(unode->aux);
-		if (oper->type == BTRFS_QGROUP_OPER_ADD_SHARED) {
-			if (qg->new_refcnt < seq)
-				qg->new_refcnt = seq + 1;
-			else
-				qg->new_refcnt++;
-		} else {
-			if (qg->old_refcnt < seq)
-				qg->old_refcnt = seq + 1;
-			else
-				qg->old_refcnt++;
-		}
+		if (oper->type == BTRFS_QGROUP_OPER_ADD_SHARED)
+			update_qg_new_refcnt(qg, seq, 1);
+		else
+			update_qg_old_refcnt(qg, seq, 1);
 		list_for_each_entry(glist, &qg->groups, next_group) {
 			ret = ulist_add(tmp, glist->group->qgroupid,
 					ptr_to_u64(glist->group), GFP_ATOMIC);
@@ -1706,11 +1740,14 @@ static int qgroup_adjust_counters(struct btrfs_fs_info *fs_info,
 		bool dirty = false;
 
 		qg = u64_to_ptr(unode->aux);
+		cur_old_count = get_qg_old_refcnt(qg, seq);
+		cur_new_count = get_qg_new_refcnt(qg, seq);
+
 		/*
 		 * Wasn't referenced before but is now, add to the reference
 		 * counters.
 		 */
-		if (qg->old_refcnt <= seq && qg->new_refcnt > seq) {
+		if (cur_old_count == 0 && cur_new_count > 0) {
 			qg->rfer += num_bytes;
 			qg->rfer_cmpr += num_bytes;
 			dirty = true;
@@ -1720,21 +1757,12 @@ static int qgroup_adjust_counters(struct btrfs_fs_info *fs_info,
 		 * Was referenced before but isn't now, subtract from the
 		 * reference counters.
 		 */
-		if (qg->old_refcnt > seq && qg->new_refcnt <= seq) {
+		if (cur_old_count > 0 && cur_new_count == 0) {
 			qg->rfer -= num_bytes;
 			qg->rfer_cmpr -= num_bytes;
 			dirty = true;
 		}
 
-		if (qg->old_refcnt < seq)
-			cur_old_count = 0;
-		else
-			cur_old_count = qg->old_refcnt - seq;
-		if (qg->new_refcnt < seq)
-			cur_new_count = 0;
-		else
-			cur_new_count = qg->new_refcnt - seq;
-
 		/*
 		 * If our refcount was the same as the roots previously but our
 		 * new count isn't the same as the number of roots now then we
-- 
2.3.1

