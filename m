Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57386 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752338AbdBOV2l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2017 16:28:41 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 65803AD95
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Feb 2017 21:28:40 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 4/8] btrfs: free-space-cache, clean up unnecessary root arguments
Date: Wed, 15 Feb 2017 16:28:30 -0500
Message-Id: <1487194114-12786-5-git-send-email-jeffm@suse.com>
In-Reply-To: <1487194114-12786-1-git-send-email-jeffm@suse.com>
References: <1487194114-12786-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

The free space cache APIs accept a root but always use the tree root.

Also, btrfs_truncate_free_space_cache accepts a root AND an inode but
the inode always points to the root anyway, so let's just pass the inode.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent-tree.c      |  9 +++++----
 fs/btrfs/free-space-cache.c | 25 +++++++++++--------------
 fs/btrfs/free-space-cache.h |  7 +++----
 fs/btrfs/inode-map.c        |  2 +-
 fs/btrfs/relocation.c       |  5 ++---
 5 files changed, 22 insertions(+), 26 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 20bedc7..a557249 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3372,7 +3372,7 @@ static int cache_save_setup(struct btrfs_block_group_cache *block_group,
 	if (trans->aborted)
 		return 0;
 again:
-	inode = lookup_free_space_inode(root, block_group, path);
+	inode = lookup_free_space_inode(fs_info, block_group, path);
 	if (IS_ERR(inode) && PTR_ERR(inode) != -ENOENT) {
 		ret = PTR_ERR(inode);
 		btrfs_release_path(path);
@@ -3386,7 +3386,8 @@ static int cache_save_setup(struct btrfs_block_group_cache *block_group,
 		if (block_group->ro)
 			goto out_free;
 
-		ret = create_free_space_inode(root, trans, block_group, path);
+		ret = create_free_space_inode(fs_info, trans, block_group,
+					      path);
 		if (ret)
 			goto out_free;
 		goto again;
@@ -3428,7 +3429,7 @@ static int cache_save_setup(struct btrfs_block_group_cache *block_group,
 		if (ret)
 			goto out_put;
 
-		ret = btrfs_truncate_free_space_cache(root, trans, NULL, inode);
+		ret = btrfs_truncate_free_space_cache(trans, NULL, inode);
 		if (ret)
 			goto out_put;
 	}
@@ -10319,7 +10320,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	 * get the inode first so any iput calls done for the io_list
 	 * aren't the final iput (no unlinks allowed now)
 	 */
-	inode = lookup_free_space_inode(tree_root, block_group, path);
+	inode = lookup_free_space_inode(fs_info, block_group, path);
 
 	mutex_lock(&trans->transaction->cache_write_mutex);
 	/*
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 7015892..61a72fb 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -94,12 +94,11 @@ static struct inode *__lookup_free_space_inode(struct btrfs_root *root,
 	return inode;
 }
 
-struct inode *lookup_free_space_inode(struct btrfs_root *root,
+struct inode *lookup_free_space_inode(struct btrfs_fs_info *fs_info,
 				      struct btrfs_block_group_cache
 				      *block_group, struct btrfs_path *path)
 {
 	struct inode *inode = NULL;
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	u32 flags = BTRFS_INODE_NODATASUM | BTRFS_INODE_NODATACOW;
 
 	spin_lock(&block_group->lock);
@@ -109,7 +108,7 @@ struct inode *lookup_free_space_inode(struct btrfs_root *root,
 	if (inode)
 		return inode;
 
-	inode = __lookup_free_space_inode(root, path,
+	inode = __lookup_free_space_inode(fs_info->tree_root, path,
 					  block_group->key.objectid);
 	if (IS_ERR(inode))
 		return inode;
@@ -192,7 +191,7 @@ static int __create_free_space_inode(struct btrfs_root *root,
 	return 0;
 }
 
-int create_free_space_inode(struct btrfs_root *root,
+int create_free_space_inode(struct btrfs_fs_info *fs_info,
 			    struct btrfs_trans_handle *trans,
 			    struct btrfs_block_group_cache *block_group,
 			    struct btrfs_path *path)
@@ -200,11 +199,11 @@ int create_free_space_inode(struct btrfs_root *root,
 	int ret;
 	u64 ino;
 
-	ret = btrfs_find_free_objectid(root, &ino);
+	ret = btrfs_find_free_objectid(fs_info->tree_root, &ino);
 	if (ret < 0)
 		return ret;
 
-	return __create_free_space_inode(root, trans, path, ino,
+	return __create_free_space_inode(fs_info->tree_root, trans, path, ino,
 					 block_group->key.objectid);
 }
 
@@ -227,11 +226,11 @@ int btrfs_check_trunc_cache_free_space(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
-int btrfs_truncate_free_space_cache(struct btrfs_root *root,
-				    struct btrfs_trans_handle *trans,
+int btrfs_truncate_free_space_cache(struct btrfs_trans_handle *trans,
 				    struct btrfs_block_group_cache *block_group,
 				    struct inode *inode)
 {
+	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret = 0;
 	struct btrfs_path *path = btrfs_alloc_path();
 	bool locked = false;
@@ -828,7 +827,6 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 			  struct btrfs_block_group_cache *block_group)
 {
 	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
-	struct btrfs_root *root = fs_info->tree_root;
 	struct inode *inode;
 	struct btrfs_path *path;
 	int ret = 0;
@@ -852,7 +850,7 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 	path->search_commit_root = 1;
 	path->skip_locking = 1;
 
-	inode = lookup_free_space_inode(root, block_group, path);
+	inode = lookup_free_space_inode(fs_info, block_group, path);
 	if (IS_ERR(inode)) {
 		btrfs_free_path(path);
 		return 0;
@@ -1378,7 +1376,6 @@ int btrfs_write_out_cache(struct btrfs_fs_info *fs_info,
 			  struct btrfs_block_group_cache *block_group,
 			  struct btrfs_path *path)
 {
-	struct btrfs_root *root = fs_info->tree_root;
 	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct inode *inode;
 	int ret = 0;
@@ -1390,12 +1387,12 @@ int btrfs_write_out_cache(struct btrfs_fs_info *fs_info,
 	}
 	spin_unlock(&block_group->lock);
 
-	inode = lookup_free_space_inode(root, block_group, path);
+	inode = lookup_free_space_inode(fs_info, block_group, path);
 	if (IS_ERR(inode))
 		return 0;
 
-	ret = __btrfs_write_out_cache(root, inode, ctl, block_group,
-				      &block_group->io_ctl, trans,
+	ret = __btrfs_write_out_cache(fs_info->tree_root, inode, ctl,
+				      block_group, &block_group->io_ctl, trans,
 				      path, block_group->key.objectid);
 	if (ret) {
 #ifdef DEBUG
diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index 6f3c025..79eca4c 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -51,18 +51,17 @@ struct btrfs_free_space_op {
 
 struct btrfs_io_ctl;
 
-struct inode *lookup_free_space_inode(struct btrfs_root *root,
+struct inode *lookup_free_space_inode(struct btrfs_fs_info *fs_info,
 				      struct btrfs_block_group_cache
 				      *block_group, struct btrfs_path *path);
-int create_free_space_inode(struct btrfs_root *root,
+int create_free_space_inode(struct btrfs_fs_info *fs_info,
 			    struct btrfs_trans_handle *trans,
 			    struct btrfs_block_group_cache *block_group,
 			    struct btrfs_path *path);
 
 int btrfs_check_trunc_cache_free_space(struct btrfs_fs_info *fs_info,
 				       struct btrfs_block_rsv *rsv);
-int btrfs_truncate_free_space_cache(struct btrfs_root *root,
-				    struct btrfs_trans_handle *trans,
+int btrfs_truncate_free_space_cache(struct btrfs_trans_handle *trans,
 				    struct btrfs_block_group_cache *block_group,
 				    struct inode *inode);
 int load_free_space_cache(struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index 144b119..3bbb8f0 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -467,7 +467,7 @@ int btrfs_save_ino_cache(struct btrfs_root *root,
 	}
 
 	if (i_size_read(inode) > 0) {
-		ret = btrfs_truncate_free_space_cache(root, trans, NULL, inode);
+		ret = btrfs_truncate_free_space_cache(trans, NULL, inode);
 		if (ret) {
 			if (ret != -ENOSPC)
 				btrfs_abort_transaction(trans, ret);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 2e9deb9..bee4b5b 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3543,7 +3543,7 @@ static int delete_block_group_cache(struct btrfs_fs_info *fs_info,
 		goto out;
 	}
 
-	ret = btrfs_truncate_free_space_cache(root, trans, block_group, inode);
+	ret = btrfs_truncate_free_space_cache(trans, block_group, inode);
 
 	btrfs_end_transaction(trans);
 	btrfs_btree_balance_dirty(fs_info);
@@ -4347,8 +4347,7 @@ int btrfs_relocate_block_group(struct btrfs_fs_info *fs_info, u64 group_start)
 		goto out;
 	}
 
-	inode = lookup_free_space_inode(fs_info->tree_root, rc->block_group,
-					path);
+	inode = lookup_free_space_inode(fs_info, rc->block_group, path);
 	btrfs_free_path(path);
 
 	if (!IS_ERR(inode))
-- 
2.7.1

