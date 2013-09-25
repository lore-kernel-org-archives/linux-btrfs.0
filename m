Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:13618 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755583Ab3IYNr0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Sep 2013 09:47:26 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r8PDlMZO026984
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Sep 2013 21:47:23 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] Btrfs: insert orphan roots into fs radix tree
Date: Wed, 25 Sep 2013 21:47:43 +0800
Message-Id: <1380116865-23406-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now we don't drop all the deleted snapshots/subvolumes before the space
balance. It means we have to relocate the space which is held by the dead
snapshots/subvolumes. So we must into them into fs radix tree, or we would
forget to commit the change of them when doing transaction commit, and it
would corrupt the metadata.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/root-tree.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 0b1f4ef..ec71ea4 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -299,11 +299,6 @@ int btrfs_find_orphan_roots(struct btrfs_root *tree_root)
 			continue;
 		}
 
-		if (btrfs_root_refs(&root->root_item) == 0) {
-			btrfs_add_dead_root(root);
-			continue;
-		}
-
 		err = btrfs_init_fs_root(root);
 		if (err) {
 			btrfs_free_fs_root(root);
@@ -318,6 +313,9 @@ int btrfs_find_orphan_roots(struct btrfs_root *tree_root)
 			btrfs_free_fs_root(root);
 			break;
 		}
+
+		if (btrfs_root_refs(&root->root_item) == 0)
+			btrfs_add_dead_root(root);
 	}
 
 	btrfs_free_path(path);
-- 
1.8.3.1

