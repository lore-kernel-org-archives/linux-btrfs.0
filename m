Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:33879 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752472Ab3LRDNm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 22:13:42 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: Cleanup the unused btrfs_check_super_valid.
Date: Wed, 18 Dec 2013 11:14:28 +0800
Message-Id: <1387336468-28785-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since in David's commit 1104a8855, there is nothing really check the
super block now, the btrfs_check_super_valid function can be removed if
no one else needs the function.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/disk-io.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8072cfa..3bda365 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -56,8 +56,6 @@
 static struct extent_io_ops btree_extent_io_ops;
 static void end_workqueue_fn(struct btrfs_work *work);
 static void free_fs_root(struct btrfs_root *root);
-static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
-				    int read_only);
 static void btrfs_destroy_ordered_operations(struct btrfs_transaction *t,
 					     struct btrfs_root *root);
 static void btrfs_destroy_ordered_extents(struct btrfs_root *root);
@@ -2354,13 +2352,6 @@ int open_ctree(struct super_block *sb,
 
 	memcpy(fs_info->fsid, fs_info->super_copy->fsid, BTRFS_FSID_SIZE);
 
-	ret = btrfs_check_super_valid(fs_info, sb->s_flags & MS_RDONLY);
-	if (ret) {
-		printk(KERN_ERR "btrfs: superblock contains fatal errors\n");
-		err = -EINVAL;
-		goto fail_alloc;
-	}
-
 	disk_super = fs_info->super_copy;
 	if (!btrfs_super_root(disk_super))
 		goto fail_alloc;
@@ -3705,15 +3696,6 @@ int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid)
 	return btree_read_extent_buffer_pages(root, buf, 0, parent_transid);
 }
 
-static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
-			      int read_only)
-{
-	/*
-	 * Placeholder for checks
-	 */
-	return 0;
-}
-
 static void btrfs_error_commit_super(struct btrfs_root *root)
 {
 	mutex_lock(&root->fs_info->cleaner_mutex);
-- 
1.8.5.1

