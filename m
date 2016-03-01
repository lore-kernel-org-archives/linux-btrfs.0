Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:22037 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbcCAIKp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Mar 2016 03:10:45 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id F12844056403
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Mar 2016 16:10:21 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: Output more info for enospc_debug mount option
Date: Tue,  1 Mar 2016 16:08:21 +0800
Message-Id: <1456819701-21067-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As one user in mail list report reproducible balance ENOSPC error, it's
better to add more debug info for enospc_debug mount option.

Reported-by: Marc Haber <mh+linux-btrfs@zugschlus.de>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 083783b..a95d247 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9386,15 +9386,23 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
 	u64 dev_min = 1;
 	u64 dev_nr = 0;
 	u64 target;
+	int debug;
 	int index;
 	int full = 0;
 	int ret = 0;
 
+	debug = btrfs_test_opt(root, ENOSPC_DEBUG);
+
 	block_group = btrfs_lookup_block_group(root->fs_info, bytenr);
 
 	/* odd, couldn't find the block group, leave it alone */
-	if (!block_group)
+	if (!block_group) {
+		if (debug)
+			btrfs_warn(root->fs_info,
+				   "Can't find block group %llu\n",
+				   bytenr);
 		return -1;
+	}
 
 	min_free = btrfs_block_group_used(&block_group->item);
 
@@ -9448,8 +9456,11 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
 		 * this is just a balance, so if we were marked as full
 		 * we know there is no space for a new chunk
 		 */
-		if (full)
+		if (full) {
+			if (debug)
+				btrfs_warn(root->fs_info, "space info full");
 			goto out;
+		}
 
 		index = get_block_group_index(block_group);
 	}
@@ -9496,6 +9507,8 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
 			ret = -1;
 		}
 	}
+	if (debug && ret == -1)
+		btrfs_warn(root->fs_info, "no space to allocate a new chunk");
 	mutex_unlock(&root->fs_info->chunk_mutex);
 	btrfs_end_transaction(trans, root);
 out:
-- 
2.7.2



