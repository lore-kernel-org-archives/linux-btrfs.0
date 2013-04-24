Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:37766 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757854Ab3DXUty (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Apr 2013 16:49:54 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 105D59A068E
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Apr 2013 14:49:54 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id uffUA0JzM7wzynNB (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 24 Apr 2013 14:49:53 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: cleanup fs roots if we fail to mount
Date: Wed, 24 Apr 2013 16:49:51 -0400
Message-ID: <1366836591-1980-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can run the tree logging recovery or the orphan cleanup on mount, so we'll
end up looking up a random fs tree in the meantime.  So we need to clean this up
so we don't leave extent buffers hanging around on the cache.  With this patch
we no longer leak extent buffers on failure to mount.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/disk-io.c |   62 ++++++++++++++++++++++++++--------------------------
 1 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 4605cc7..8be8d5e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2049,6 +2049,36 @@ static void free_root_pointers(struct btrfs_fs_info *info, int chunk_root)
 	}
 }
 
+static void del_fs_roots(struct btrfs_fs_info *fs_info)
+{
+	int ret;
+	struct btrfs_root *gang[8];
+	int i;
+
+	while (!list_empty(&fs_info->dead_roots)) {
+		gang[0] = list_entry(fs_info->dead_roots.next,
+				     struct btrfs_root, root_list);
+		list_del(&gang[0]->root_list);
+
+		if (gang[0]->in_radix) {
+			btrfs_free_fs_root(fs_info, gang[0]);
+		} else {
+			free_extent_buffer(gang[0]->node);
+			free_extent_buffer(gang[0]->commit_root);
+			kfree(gang[0]);
+		}
+	}
+
+	while (1) {
+		ret = radix_tree_gang_lookup(&fs_info->fs_roots_radix,
+					     (void **)gang, 0,
+					     ARRAY_SIZE(gang));
+		if (!ret)
+			break;
+		for (i = 0; i < ret; i++)
+			btrfs_free_fs_root(fs_info, gang[i]);
+	}
+}
 
 int open_ctree(struct super_block *sb,
 	       struct btrfs_fs_devices *fs_devices,
@@ -2852,6 +2882,7 @@ fail_qgroup:
 	btrfs_free_qgroup_config(fs_info);
 fail_trans_kthread:
 	kthread_stop(fs_info->transaction_kthread);
+	del_fs_roots(fs_info);
 fail_cleaner:
 	kthread_stop(fs_info->cleaner_kthread);
 
@@ -3380,37 +3411,6 @@ static void free_fs_root(struct btrfs_root *root)
 	kfree(root);
 }
 
-static void del_fs_roots(struct btrfs_fs_info *fs_info)
-{
-	int ret;
-	struct btrfs_root *gang[8];
-	int i;
-
-	while (!list_empty(&fs_info->dead_roots)) {
-		gang[0] = list_entry(fs_info->dead_roots.next,
-				     struct btrfs_root, root_list);
-		list_del(&gang[0]->root_list);
-
-		if (gang[0]->in_radix) {
-			btrfs_free_fs_root(fs_info, gang[0]);
-		} else {
-			free_extent_buffer(gang[0]->node);
-			free_extent_buffer(gang[0]->commit_root);
-			kfree(gang[0]);
-		}
-	}
-
-	while (1) {
-		ret = radix_tree_gang_lookup(&fs_info->fs_roots_radix,
-					     (void **)gang, 0,
-					     ARRAY_SIZE(gang));
-		if (!ret)
-			break;
-		for (i = 0; i < ret; i++)
-			btrfs_free_fs_root(fs_info, gang[i]);
-	}
-}
-
 int btrfs_cleanup_fs_roots(struct btrfs_fs_info *fs_info)
 {
 	u64 root_objectid = 0;
-- 
1.7.7.6

