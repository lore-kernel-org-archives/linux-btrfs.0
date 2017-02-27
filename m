Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:50398 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751678AbdB0HLN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Feb 2017 02:11:13 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.com>, <clm@fb.com>
Subject: [PATCH 4/9] btrfs: qgroup: Add quick exit for non-fs extents
Date: Mon, 27 Feb 2017 15:10:34 +0800
Message-ID: <20170227071039.8335-5-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170227071039.8335-1-quwenruo@cn.fujitsu.com>
References: <20170227071039.8335-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
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
index e46499cafdbf..bb25fb82b5c2 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1961,6 +1961,33 @@ static int qgroup_update_counters(struct btrfs_fs_info *fs_info,
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
@@ -1977,10 +2004,20 @@ btrfs_qgroup_account_extent(struct btrfs_trans_handle *trans,
 	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags))
 		return 0;
 
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
 
 	BUG_ON(!fs_info->quota_root);
 
-- 
2.11.1



