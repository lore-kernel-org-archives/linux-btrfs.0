Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34180 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751015AbdALOBN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jan 2017 09:01:13 -0500
Received: by mail-wm0-f65.google.com with SMTP id c85so3882324wmi.1
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Jan 2017 06:01:12 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCH 14/24] btrfs: Make btrfs_log_changed_extents take btrfs_inode
Date: Thu, 12 Jan 2017 16:00:40 +0200
Message-Id: <1484229650-24554-15-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484229650-24554-1-git-send-email-n.borisov.lkml@gmail.com>
References: <1484229650-24554-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
---
 fs/btrfs/tree-log.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 657c118aed63..5abe54963049 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4052,7 +4052,7 @@ static int wait_ordered_extents(struct btrfs_trans_handle *trans,
 }
 
 static int log_one_extent(struct btrfs_trans_handle *trans,
-			  struct inode *inode, struct btrfs_root *root,
+			  struct btrfs_inode *inode, struct btrfs_root *root,
 			  const struct extent_map *em,
 			  struct btrfs_path *path,
 			  const struct list_head *logged_list,
@@ -4069,7 +4069,7 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 	int extent_inserted = 0;
 	bool ordered_io_err = false;
 
-	ret = wait_ordered_extents(trans, inode, root, em, logged_list,
+	ret = wait_ordered_extents(trans, &inode->vfs_inode, root, em, logged_list,
 				   &ordered_io_err);
 	if (ret)
 		return ret;
@@ -4081,14 +4081,14 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 
 	btrfs_init_map_token(&token);
 
-	ret = __btrfs_drop_extents(trans, log, inode, path, em->start,
+	ret = __btrfs_drop_extents(trans, log, &inode->vfs_inode, path, em->start,
 				   em->start + em->len, NULL, 0, 1,
 				   sizeof(*fi), &extent_inserted);
 	if (ret)
 		return ret;
 
 	if (!extent_inserted) {
-		key.objectid = btrfs_ino(BTRFS_I(inode));
+		key.objectid = btrfs_ino(inode);
 		key.type = BTRFS_EXTENT_DATA_KEY;
 		key.offset = em->start;
 
@@ -4147,7 +4147,7 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 
 static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 				     struct btrfs_root *root,
-				     struct inode *inode,
+				     struct btrfs_inode *inode,
 				     struct btrfs_path *path,
 				     struct list_head *logged_list,
 				     struct btrfs_log_ctx *ctx,
@@ -4156,14 +4156,14 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 {
 	struct extent_map *em, *n;
 	struct list_head extents;
-	struct extent_map_tree *tree = &BTRFS_I(inode)->extent_tree;
+	struct extent_map_tree *tree = &inode->extent_tree;
 	u64 test_gen;
 	int ret = 0;
 	int num = 0;
 
 	INIT_LIST_HEAD(&extents);
 
-	down_write(&BTRFS_I(inode)->dio_sem);
+	down_write(&inode->dio_sem);
 	write_lock(&tree->lock);
 	test_gen = root->fs_info->last_trans_committed;
 
@@ -4192,7 +4192,7 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 	}
 
 	list_sort(NULL, &extents, extent_cmp);
-	btrfs_get_logged_extents(BTRFS_I(inode), logged_list, start, end);
+	btrfs_get_logged_extents(inode, logged_list, start, end);
 	/*
 	 * Some ordered extents started by fsync might have completed
 	 * before we could collect them into the list logged_list, which
@@ -4203,7 +4203,7 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 	 * without writing to the log tree and the fsync must report the
 	 * file data write error and not commit the current transaction.
 	 */
-	ret = filemap_check_errors(inode->i_mapping);
+	ret = filemap_check_errors(inode->vfs_inode.i_mapping);
 	if (ret)
 		ctx->io_err = ret;
 process:
@@ -4232,7 +4232,7 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 	}
 	WARN_ON(!list_empty(&extents));
 	write_unlock(&tree->lock);
-	up_write(&BTRFS_I(inode)->dio_sem);
+	up_write(&inode->dio_sem);
 
 	btrfs_release_path(path);
 	return ret;
@@ -4931,7 +4931,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 			goto out_unlock;
 	}
 	if (fast_search) {
-		ret = btrfs_log_changed_extents(trans, root, inode, dst_path,
+		ret = btrfs_log_changed_extents(trans, root, BTRFS_I(inode), dst_path,
 						&logged_list, ctx, start, end);
 		if (ret) {
 			err = ret;
-- 
2.7.4

