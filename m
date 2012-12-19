Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:34192 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751110Ab2LSG6g (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Dec 2012 01:58:36 -0500
Message-ID: <50D165B7.9060300@cn.fujitsu.com>
Date: Wed, 19 Dec 2012 14:59:03 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] Btrfs: cleanup similar code in delayed inode
References: <1355863917-16932-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1355863917-16932-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The delayed item commit code in several functions is similar, so
cleanup it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/delayed-inode.c | 83 +++++++++++++++++++++---------------------------
 1 file changed, 37 insertions(+), 46 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 3483603..4e204bb 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1110,6 +1110,25 @@ static int btrfs_update_delayed_inode(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
+static inline int
+__btrfs_commit_inode_delayed_items(struct btrfs_trans_handle *trans,
+				   struct btrfs_path *path,
+				   struct btrfs_delayed_node *node)
+{
+	int ret;
+
+	ret = btrfs_insert_delayed_items(trans, path, node->root, node);
+	if (ret)
+		return ret;
+
+	ret = btrfs_delete_delayed_items(trans, path, node->root, node);
+	if (ret)
+		return ret;
+
+	ret = btrfs_update_delayed_inode(trans, node->root, path, node);
+	return ret;
+}
+
 /*
  * Called when committing the transaction.
  * Returns 0 on success.
@@ -1119,7 +1138,6 @@ static int btrfs_update_delayed_inode(struct btrfs_trans_handle *trans,
 static int __btrfs_run_delayed_items(struct btrfs_trans_handle *trans,
 				     struct btrfs_root *root, int nr)
 {
-	struct btrfs_root *curr_root = root;
 	struct btrfs_delayed_root *delayed_root;
 	struct btrfs_delayed_node *curr_node, *prev_node;
 	struct btrfs_path *path;
@@ -1142,15 +1160,8 @@ static int __btrfs_run_delayed_items(struct btrfs_trans_handle *trans,
 
 	curr_node = btrfs_first_delayed_node(delayed_root);
 	while (curr_node && (!count || (count && nr--))) {
-		curr_root = curr_node->root;
-		ret = btrfs_insert_delayed_items(trans, path, curr_root,
-						 curr_node);
-		if (!ret)
-			ret = btrfs_delete_delayed_items(trans, path,
-						curr_root, curr_node);
-		if (!ret)
-			ret = btrfs_update_delayed_inode(trans, curr_root,
-						path, curr_node);
+		ret = __btrfs_commit_inode_delayed_items(trans, path,
+							 curr_node);
 		if (ret) {
 			btrfs_release_delayed_node(curr_node);
 			curr_node = NULL;
@@ -1183,36 +1194,12 @@ int btrfs_run_delayed_items_nr(struct btrfs_trans_handle *trans,
 	return __btrfs_run_delayed_items(trans, root, nr);
 }
 
-static int __btrfs_commit_inode_delayed_items(struct btrfs_trans_handle *trans,
-					      struct btrfs_delayed_node *node)
-{
-	struct btrfs_path *path;
-	struct btrfs_block_rsv *block_rsv;
-	int ret;
-
-	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
-	path->leave_spinning = 1;
-
-	block_rsv = trans->block_rsv;
-	trans->block_rsv = &node->root->fs_info->delayed_block_rsv;
-
-	ret = btrfs_insert_delayed_items(trans, path, node->root, node);
-	if (!ret)
-		ret = btrfs_delete_delayed_items(trans, path, node->root, node);
-	if (!ret)
-		ret = btrfs_update_delayed_inode(trans, node->root, path, node);
-	btrfs_free_path(path);
-
-	trans->block_rsv = block_rsv;
-	return ret;
-}
-
 int btrfs_commit_inode_delayed_items(struct btrfs_trans_handle *trans,
 				     struct inode *inode)
 {
 	struct btrfs_delayed_node *delayed_node = btrfs_get_delayed_node(inode);
+	struct btrfs_path *path;
+	struct btrfs_block_rsv *block_rsv;
 	int ret;
 
 	if (!delayed_node)
@@ -1226,8 +1213,20 @@ int btrfs_commit_inode_delayed_items(struct btrfs_trans_handle *trans,
 	}
 	mutex_unlock(&delayed_node->mutex);
 
-	ret = __btrfs_commit_inode_delayed_items(trans, delayed_node);
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+	path->leave_spinning = 1;
+
+	block_rsv = trans->block_rsv;
+	trans->block_rsv = &delayed_node->root->fs_info->delayed_block_rsv;
+
+	ret = __btrfs_commit_inode_delayed_items(trans, path, delayed_node);
+
 	btrfs_release_delayed_node(delayed_node);
+	btrfs_free_path(path);
+	trans->block_rsv = block_rsv;
+
 	return ret;
 }
 
@@ -1258,7 +1257,6 @@ static void btrfs_async_run_delayed_node_done(struct btrfs_work *work)
 	struct btrfs_root *root;
 	struct btrfs_block_rsv *block_rsv;
 	int need_requeue = 0;
-	int ret;
 
 	async_node = container_of(work, struct btrfs_async_delayed_node, work);
 
@@ -1277,14 +1275,7 @@ static void btrfs_async_run_delayed_node_done(struct btrfs_work *work)
 	block_rsv = trans->block_rsv;
 	trans->block_rsv = &root->fs_info->delayed_block_rsv;
 
-	ret = btrfs_insert_delayed_items(trans, path, root, delayed_node);
-	if (!ret)
-		ret = btrfs_delete_delayed_items(trans, path, root,
-						 delayed_node);
-
-	if (!ret)
-		btrfs_update_delayed_inode(trans, root, path, delayed_node);
-
+	__btrfs_commit_inode_delayed_items(trans, path, delayed_node);
 	/*
 	 * Maybe new delayed items have been inserted, so we need requeue
 	 * the work. Besides that, we must dequeue the empty delayed nodes
-- 
1.7.11.7

