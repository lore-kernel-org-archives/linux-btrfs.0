Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34409 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbaAMLyI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jan 2014 06:54:08 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id s0DBs7vk009783
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Jan 2014 11:54:07 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s0DBs6Z7028241
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Jan 2014 11:54:06 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id s0DBs626009112
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Jan 2014 11:54:06 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix extent state leak on transaction abortion
Date: Mon, 13 Jan 2014 19:53:53 +0800
Message-Id: <1389614033-31706-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When transaction is aborted, we fail to commit transaction, instead we do
cleanup work.  After that when we umount btrfs, we get to free fs roots' log
trees respectively, but that happens after we unpin extents, so those extents
pinned by freeing log trees will remain in memory and lead to the leak.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/disk-io.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8072cfa..aef0d96 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2080,6 +2080,12 @@ static void del_fs_roots(struct btrfs_fs_info *fs_info)
 		for (i = 0; i < ret; i++)
 			btrfs_drop_and_free_fs_root(fs_info, gang[i]);
 	}
+
+	if (test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state)) {
+		btrfs_free_log_root_tree(NULL, fs_info);
+		btrfs_destroy_pinned_extent(fs_info->tree_root,
+					    fs_info->pinned_extents);
+	}
 }
 
 int open_ctree(struct super_block *sb,
@@ -3455,10 +3461,8 @@ void btrfs_drop_and_free_fs_root(struct btrfs_fs_info *fs_info,
 	if (btrfs_root_refs(&root->root_item) == 0)
 		synchronize_srcu(&fs_info->subvol_srcu);
 
-	if (test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state)) {
+	if (test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state))
 		btrfs_free_log(NULL, root);
-		btrfs_free_log_root_tree(NULL, fs_info);
-	}
 
 	__btrfs_remove_free_space_cache(root->free_ino_pinned);
 	__btrfs_remove_free_space_cache(root->free_ino_ctl);
@@ -3569,8 +3573,6 @@ int close_ctree(struct btrfs_root *root)
 	if (test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state))
 		btrfs_error_commit_super(root);
 
-	btrfs_put_block_group_cache(fs_info);
-
 	kthread_stop(fs_info->transaction_kthread);
 	kthread_stop(fs_info->cleaner_kthread);
 
@@ -3586,6 +3588,8 @@ int close_ctree(struct btrfs_root *root)
 
 	del_fs_roots(fs_info);
 
+	btrfs_put_block_group_cache(fs_info);
+
 	btrfs_free_block_groups(fs_info);
 
 	btrfs_stop_all_workers(fs_info);
-- 
1.8.1.4

