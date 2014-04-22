Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46007 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752753AbaDVJMt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Apr 2014 05:12:49 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s3M9CjPa022161
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Apr 2014 17:12:45 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: Add check to avoid cleanup roots already in fs_info->dead_roots.
Date: Tue, 22 Apr 2014 17:13:51 +0800
Message-ID: <1398158031-1616-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Current btrfs_orphan_cleanup will also cleanup roots which is already in
fs_info->dead_roots without protection.
This will have conditional race with fs_info->cleaner_kthread.

This patch will use refs in root->root_item to detect roots in
dead_roots and avoid conflicts.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c | 37 ++++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 029d46c..ddfec98 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3533,28 +3533,51 @@ int btrfs_cleanup_fs_roots(struct btrfs_fs_info *fs_info)
 {
 	u64 root_objectid = 0;
 	struct btrfs_root *gang[8];
-	int i;
-	int ret;
+	int i = 0;
+	int err = 0;
+	unsigned int ret = 0;
+	int index;
 
 	while (1) {
+		index = srcu_read_lock(&fs_info->subvol_srcu);
 		ret = radix_tree_gang_lookup(&fs_info->fs_roots_radix,
 					     (void **)gang, root_objectid,
 					     ARRAY_SIZE(gang));
-		if (!ret)
+		if (!ret) {
+			srcu_read_unlock(&fs_info->subvol_srcu, index);
 			break;
-
+		}
 		root_objectid = gang[ret - 1]->root_key.objectid + 1;
+
 		for (i = 0; i < ret; i++) {
-			int err;
+			/* Avoid to grab roots in dead_roots */
+			if (btrfs_root_refs(&gang[i]->root_item) == 0) {
+				gang[i] = NULL;
+				continue;
+			}
+			/* grab all the search result for later use */
+			gang[i] = btrfs_grab_fs_root(gang[i]);
+		}
+		srcu_read_unlock(&fs_info->subvol_srcu, index);
 
+		for (i = 0; i < ret; i++) {
+			if (!gang[i])
+				continue;
 			root_objectid = gang[i]->root_key.objectid;
 			err = btrfs_orphan_cleanup(gang[i]);
 			if (err)
-				return err;
+				break;
+			btrfs_put_fs_root(gang[i]);
 		}
 		root_objectid++;
 	}
-	return 0;
+
+	/* release the uncleaned roots due to error */
+	for (; i < ret; i++) {
+		if (gang[i])
+			btrfs_put_fs_root(gang[i]);
+	}
+	return err;
 }
 
 int btrfs_commit_super(struct btrfs_root *root)
-- 
1.9.2

