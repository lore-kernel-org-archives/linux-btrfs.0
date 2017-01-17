Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34258 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751139AbdAQWjQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jan 2017 17:39:16 -0500
Received: by mail-wm0-f67.google.com with SMTP id c85so9423064wmi.1
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jan 2017 14:39:15 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCHv2 14/24] btrfs: Make btrfs_log_changed_extents take btrfs_inode
Date: Wed, 18 Jan 2017 00:31:40 +0200
Message-Id: <1484692310-3987-15-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484692310-3987-1-git-send-email-n.borisov.lkml@gmail.com>
References: <20170117161550.GW12081@twin.jikos.cz>
 <1484692310-3987-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
---
 fs/btrfs/tree-log.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 0e061f91055e..e293ae0e18d7 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4053,7 +4053,7 @@ static int wait_ordered_extents(struct btrfs_trans_handle *trans,
 }
 
 static int log_one_extent(struct btrfs_trans_handle *trans,
-			  struct inode *inode, struct btrfs_root *root,
+			  struct btrfs_inode *inode, struct btrfs_root *root,
 			  const struct extent_map *em,
 			  struct btrfs_path *path,
 			  const struct list_head *logged_list,
@@ -4070,7 +4070,7 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 	int extent_inserted = 0;
 	bool ordered_io_err = false;
 
-	ret = wait_ordered_extents(trans, inode, root, em, logged_list,
+	ret = wait_ordered_extents(trans, &inode->vfs_inode, root, em, logged_list,
 				   &ordered_io_err);
 	if (ret)
 		return ret;
@@ -4082,14 +4082,14 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 
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
 
@@ -4148,7 +4148,7 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 
 static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 				     struct btrfs_root *root,
-				     struct inode *inode,
+				     struct btrfs_inode *inode,
 				     struct btrfs_path *path,
 				     struct list_head *logged_list,
 				     struct btrfs_log_ctx *ctx,
@@ -4157,14 +4157,14 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
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
 
@@ -4193,7 +4193,7 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 	}
 
 	list_sort(NULL, &extents, extent_cmp);
-	btrfs_get_logged_extents(BTRFS_I(inode), logged_list, start, end);
+	btrfs_get_logged_extents(inode, logged_list, start, end);
 	/*
 	 * Some ordered extents started by fsync might have completed
 	 * before we could collect them into the list logged_list, which
@@ -4204,7 +4204,7 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 	 * without writing to the log tree and the fsync must report the
 	 * file data write error and not commit the current transaction.
 	 */
-	ret = filemap_check_errors(inode->i_mapping);
+	ret = filemap_check_errors(inode->vfs_inode.i_mapping);
 	if (ret)
 		ctx->io_err = ret;
 process:
@@ -4233,7 +4233,7 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 	}
 	WARN_ON(!list_empty(&extents));
 	write_unlock(&tree->lock);
-	up_write(&BTRFS_I(inode)->dio_sem);
+	up_write(&inode->dio_sem);
 
 	btrfs_release_path(path);
 	return ret;
@@ -4938,7 +4938,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
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

