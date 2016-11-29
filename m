Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:15396 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752561AbcK2Env (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Nov 2016 23:43:51 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
        by cn.fujitsu.com (Postfix) with ESMTP id EAFA241B4BE0
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Nov 2016 12:42:56 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs: qgroup: Add quick exit for non-fs extents
Date: Tue, 29 Nov 2016 12:42:40 +0800
Message-Id: <20161129044241.27407-3-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161129044241.27407-1-quwenruo@cn.fujitsu.com>
References: <20161129044241.27407-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For btrfs_qgroup_account_extent(), modify make it exit quicker for
non-fs extents.

This will also reduce the noise in trace_btrfs_qgroup_account_extent
event.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 41 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index e97f304..b9a2fd1 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1904,6 +1904,33 @@ static int qgroup_update_counters(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
+/*
+ * Helper to check if the @roots is a list of fs tree roots
+ * Return 0 for definitely not a fs/subvol tree roots ulist
+ * Return 1 for possible fs/subvol tree roots ulist(including empty)
+ */
+static int maybe_fs_roots(struct ulist *roots)
+{
+	struct ulist_node *unode;
+	struct ulist_iterator uiter;
+
+	/* Empty one, still possible for fs roots */
+	if (!roots || roots->nnodes == 0)
+		return 1;
+
+	ULIST_ITER_INIT(&uiter);
+	unode = ulist_next(roots, &uiter);
+	if (!unode)
+		return 1;
+
+	/*
+	 * If it contains fs tree roots, then it must belongs to fs/subvol
+	 * trees.
+	 * If it contains non-fs tree, it won't be shared to fs/subvol trees.
+	 */
+	return is_fstree(unode->val);
+}
+
 int
 btrfs_qgroup_account_extent(struct btrfs_trans_handle *trans,
 			    struct btrfs_fs_info *fs_info,
@@ -1917,10 +1944,20 @@ btrfs_qgroup_account_extent(struct btrfs_trans_handle *trans,
 	u64 nr_old_roots = 0;
 	int ret = 0;
 
-	if (new_roots)
+	if (new_roots) {
+		if (!maybe_fs_roots(new_roots))
+			goto out_free;
 		nr_new_roots = new_roots->nnodes;
-	if (old_roots)
+	}
+	if (old_roots) {
+		if (!maybe_fs_roots(old_roots))
+			goto out_free;
 		nr_old_roots = old_roots->nnodes;
+	}
+
+	/* Quick exit, either not fs tree roots, or won't affect any qgroup */
+	if (nr_old_roots == 0 && nr_new_roots == 0)
+		goto out_free;
 
 	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags))
 		goto out_free;
-- 
2.10.2



