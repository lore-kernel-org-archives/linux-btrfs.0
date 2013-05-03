Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:49540 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821Ab3ECMyu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 May 2013 08:54:50 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 88B7E7C041B
	for <linux-btrfs@vger.kernel.org>; Fri,  3 May 2013 06:54:49 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id SgHlwAgrIOA0ydmV (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 03 May 2013 06:54:48 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: free up reserved space if we fail to insert extent entry
Date: Fri, 3 May 2013 08:54:46 -0400
Message-ID: <1367585686-18020-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we are inserting an extent entry for the first allocation of an extent and
the addition fails we need to clean up the reserved space otherwise we'll get
WARN_ON()'s on unmount because we have left over reserve space.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent-tree.c |   45 +++++++++++++++++++++++++++++----------------
 1 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 2305b5c..7049bbc 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6407,16 +6407,16 @@ static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 	size = sizeof(*extent_item) + btrfs_extent_inline_ref_size(type);
 
 	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	path->leave_spinning = 1;
 	ret = btrfs_insert_empty_item(trans, fs_info->extent_root, path,
 				      ins, size);
-	if (ret) {
-		btrfs_free_path(path);
-		return ret;
-	}
+	if (ret)
+		goto out;
 
 	leaf = path->nodes[0];
 	extent_item = btrfs_item_ptr(leaf, path->slots[0],
@@ -6444,14 +6444,21 @@ static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 
 	btrfs_mark_buffer_dirty(path->nodes[0]);
 	btrfs_free_path(path);
+	path = NULL;
 
 	ret = update_block_group(root, ins->objectid, ins->offset, 1);
-	if (ret) { /* -ENOENT, logic error */
+	if (ret) {
 		btrfs_err(fs_info, "update block group failed for %llu %llu",
 			(unsigned long long)ins->objectid,
 			(unsigned long long)ins->offset);
-		BUG();
+		goto out;
 	}
+
+	return ret;
+out:
+	btrfs_free_path(path);
+	btrfs_pin_extent(root, ins->objectid, ins->offset, 1);
+	btrfs_del_csums(trans, root, ins->objectid, ins->offset);
 	return ret;
 }
 
@@ -6476,16 +6483,16 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 		size += sizeof(*block_info);
 
 	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	path->leave_spinning = 1;
 	ret = btrfs_insert_empty_item(trans, fs_info->extent_root, path,
 				      ins, size);
-	if (ret) {
-		btrfs_free_path(path);
-		return ret;
-	}
+	if (ret)
+		goto out;
 
 	leaf = path->nodes[0];
 	extent_item = btrfs_item_ptr(leaf, path->slots[0],
@@ -6517,14 +6524,20 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_free_path(path);
+	path = NULL;
 
 	ret = update_block_group(root, ins->objectid, root->leafsize, 1);
-	if (ret) { /* -ENOENT, logic error */
+	if (ret) {
 		btrfs_err(fs_info, "update block group failed for %llu %llu",
 			(unsigned long long)ins->objectid,
 			(unsigned long long)ins->offset);
-		BUG();
+		goto out;
 	}
+
+	return ret;
+out:
+	btrfs_free_path(path);
+	btrfs_pin_extent(root, ins->objectid, root->leafsize, 1);
 	return ret;
 }
 
-- 
1.7.7.6

