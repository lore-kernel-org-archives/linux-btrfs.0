Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39263 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751469AbbDUGVo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Apr 2015 02:21:44 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t3L6KUPg025404
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Apr 2015 14:20:30 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 06/18] btrfs: qgroup: Add function qgroup_update_refcnt().
Date: Tue, 21 Apr 2015 14:21:22 +0800
Message-ID: <1429597294-11875-7-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1429597294-11875-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1429597294-11875-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function is used to update refcnt for qgroups.
And is one of the two core functions used in the new qgroup implement.

This is based on the old update_old/new_refcnt, but provides a unified
logic and behavior.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 58 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 9625644..17a974c 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1702,6 +1702,64 @@ static int qgroup_calc_new_refcnt(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
+#define UPDATE_NEW	0
+#define UPDATE_OLD	1
+/*
+ * Walk all of the roots that points to the bytenr and adjust their refcnts.
+ */
+static int qgroup_update_refcnt(struct btrfs_fs_info *fs_info,
+				struct ulist *roots, struct ulist *tmp,
+				struct ulist *qgroups, u64 seq, int update_old)
+{
+	struct ulist_node *unode;
+	struct ulist_iterator uiter;
+	struct ulist_node *tmp_unode;
+	struct ulist_iterator tmp_uiter;
+	struct btrfs_qgroup *qg;
+	int ret = 0;
+
+	if (!roots)
+		return 0;
+	ULIST_ITER_INIT(&uiter);
+	while ((unode = ulist_next(roots, &uiter))) {
+		qg = find_qgroup_rb(fs_info, unode->val);
+		if (!qg)
+			continue;
+
+		ulist_reinit(tmp);
+		ret = ulist_add(qgroups, qg->qgroupid, ptr_to_u64(qg),
+				GFP_ATOMIC);
+		if (ret < 0)
+			return ret;
+		ret = ulist_add(tmp, qg->qgroupid, ptr_to_u64(qg), GFP_ATOMIC);
+		if (ret < 0)
+			return ret;
+		ULIST_ITER_INIT(&tmp_uiter);
+		while ((tmp_unode = ulist_next(tmp, &tmp_uiter))) {
+			struct btrfs_qgroup_list *glist;
+
+			qg = u64_to_ptr(tmp_unode->aux);
+			if (update_old)
+				btrfs_qgroup_update_old_refcnt(qg, seq, 1);
+			else
+				btrfs_qgroup_update_new_refcnt(qg, seq, 1);
+			list_for_each_entry(glist, &qg->groups, next_group) {
+				ret = ulist_add(qgroups, glist->group->qgroupid,
+						ptr_to_u64(glist->group),
+						GFP_ATOMIC);
+				if (ret < 0)
+					return ret;
+				ret = ulist_add(tmp, glist->group->qgroupid,
+						ptr_to_u64(glist->group),
+						GFP_ATOMIC);
+				if (ret < 0)
+					return ret;
+			}
+		}
+	}
+	return 0;
+}
+
 /*
  * This adjusts the counters for all referenced qgroups if need be.
  */
-- 
2.3.5

