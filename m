Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57606 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751775Ab2LSG7X (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Dec 2012 01:59:23 -0500
Message-ID: <50D165E7.4090102@cn.fujitsu.com>
Date: Wed, 19 Dec 2012 14:59:51 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] Btrfs: fix lots of orphan inodes when the space is not
 enough
References: <1355863917-16932-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1355863917-16932-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We're running into having 50-100 orphans left over with xfstests 83
because of ENOSPC when trying to start the transaction for the inode update.
But in fact, it makes no sense in updating the inode for the new size while
we're deleting the stupid thing. This patch fixes this problem.

Reported-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/delayed-inode.c | 90 +++++++++++++++++++++++++++++++++++++++++-------
 fs/btrfs/delayed-inode.h |  1 +
 fs/btrfs/inode.c         | 11 +++---
 3 files changed, 85 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 4e204bb..c7e7506 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1065,32 +1065,25 @@ static void btrfs_release_delayed_inode(struct btrfs_delayed_node *delayed_node)
 	}
 }
 
-static int btrfs_update_delayed_inode(struct btrfs_trans_handle *trans,
-				      struct btrfs_root *root,
-				      struct btrfs_path *path,
-				      struct btrfs_delayed_node *node)
+static int __btrfs_update_delayed_inode(struct btrfs_trans_handle *trans,
+					struct btrfs_root *root,
+					struct btrfs_path *path,
+					struct btrfs_delayed_node *node)
 {
 	struct btrfs_key key;
 	struct btrfs_inode_item *inode_item;
 	struct extent_buffer *leaf;
 	int ret;
 
-	mutex_lock(&node->mutex);
-	if (!node->inode_dirty) {
-		mutex_unlock(&node->mutex);
-		return 0;
-	}
-
 	key.objectid = node->inode_id;
 	btrfs_set_key_type(&key, BTRFS_INODE_ITEM_KEY);
 	key.offset = 0;
+
 	ret = btrfs_lookup_inode(trans, root, path, &key, 1);
 	if (ret > 0) {
 		btrfs_release_path(path);
-		mutex_unlock(&node->mutex);
 		return -ENOENT;
 	} else if (ret < 0) {
-		mutex_unlock(&node->mutex);
 		return ret;
 	}
 
@@ -1105,11 +1098,28 @@ static int btrfs_update_delayed_inode(struct btrfs_trans_handle *trans,
 
 	btrfs_delayed_inode_release_metadata(root, node);
 	btrfs_release_delayed_inode(node);
-	mutex_unlock(&node->mutex);
 
 	return 0;
 }
 
+static inline int btrfs_update_delayed_inode(struct btrfs_trans_handle *trans,
+					     struct btrfs_root *root,
+					     struct btrfs_path *path,
+					     struct btrfs_delayed_node *node)
+{
+	int ret;
+
+	mutex_lock(&node->mutex);
+	if (!node->inode_dirty) {
+		mutex_unlock(&node->mutex);
+		return 0;
+	}
+
+	ret = __btrfs_update_delayed_inode(trans, root, path, node);
+	mutex_unlock(&node->mutex);
+	return ret;
+}
+
 static inline int
 __btrfs_commit_inode_delayed_items(struct btrfs_trans_handle *trans,
 				   struct btrfs_path *path,
@@ -1230,6 +1240,60 @@ int btrfs_commit_inode_delayed_items(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+int btrfs_commit_inode_delayed_inode(struct inode *inode)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_delayed_node *delayed_node = btrfs_get_delayed_node(inode);
+	struct btrfs_path *path;
+	struct btrfs_block_rsv *block_rsv;
+	int ret;
+
+	if (!delayed_node)
+		return 0;
+
+	mutex_lock(&delayed_node->mutex);
+	if (!delayed_node->inode_dirty) {
+		mutex_unlock(&delayed_node->mutex);
+		btrfs_release_delayed_node(delayed_node);
+		return 0;
+	}
+	mutex_unlock(&delayed_node->mutex);
+
+	trans = btrfs_join_transaction(delayed_node->root);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out;
+	}
+
+	path = btrfs_alloc_path();
+	if (!path) {
+		ret = -ENOMEM;
+		goto trans_out;
+	}
+	path->leave_spinning = 1;
+
+	block_rsv = trans->block_rsv;
+	trans->block_rsv = &delayed_node->root->fs_info->delayed_block_rsv;
+
+	mutex_lock(&delayed_node->mutex);
+	if (delayed_node->inode_dirty)
+		ret = __btrfs_update_delayed_inode(trans, delayed_node->root,
+						   path, delayed_node);
+	else
+		ret = 0;
+	mutex_unlock(&delayed_node->mutex);
+
+	btrfs_free_path(path);
+	trans->block_rsv = block_rsv;
+trans_out:
+	btrfs_end_transaction(trans, delayed_node->root);
+	btrfs_btree_balance_dirty(delayed_node->root);
+out:
+	btrfs_release_delayed_node(delayed_node);
+
+	return ret;
+}
+
 void btrfs_remove_delayed_node(struct inode *inode)
 {
 	struct btrfs_delayed_node *delayed_node;
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index 4f808e1..78b6ad0 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -117,6 +117,7 @@ int btrfs_commit_inode_delayed_items(struct btrfs_trans_handle *trans,
 /* Used for evicting the inode. */
 void btrfs_remove_delayed_node(struct inode *inode);
 void btrfs_kill_delayed_inode_items(struct inode *inode);
+int btrfs_commit_inode_delayed_inode(struct inode *inode);
 
 
 int btrfs_delayed_update_inode(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 67ed24a..2a2b5e1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3855,6 +3855,12 @@ void btrfs_evict_inode(struct inode *inode)
 		goto no_delete;
 	}
 
+	ret = btrfs_commit_inode_delayed_inode(inode);
+	if (ret) {
+		btrfs_orphan_del(NULL, inode);
+		goto no_delete;
+	}
+
 	rsv = btrfs_alloc_block_rsv(root, BTRFS_BLOCK_RSV_TEMP);
 	if (!rsv) {
 		btrfs_orphan_del(NULL, inode);
@@ -3892,7 +3898,7 @@ void btrfs_evict_inode(struct inode *inode)
 			goto no_delete;
 		}
 
-		trans = btrfs_start_transaction_lflush(root, 1);
+		trans = btrfs_join_transaction(root);
 		if (IS_ERR(trans)) {
 			btrfs_orphan_del(NULL, inode);
 			btrfs_free_block_rsv(root, rsv);
@@ -3906,9 +3912,6 @@ void btrfs_evict_inode(struct inode *inode)
 			break;
 
 		trans->block_rsv = &root->fs_info->trans_block_rsv;
-		ret = btrfs_update_inode(trans, root, inode);
-		BUG_ON(ret);
-
 		btrfs_end_transaction(trans, root);
 		trans = NULL;
 		btrfs_btree_balance_dirty(root);
-- 
1.7.11.7

