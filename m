Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:34878 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab3ITNrN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Sep 2013 09:47:13 -0400
Received: by mail-bk0-f48.google.com with SMTP id my13so195360bkb.21
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Sep 2013 06:47:12 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: remove path arg from btrfs_truncate_free_space_cache
Date: Fri, 20 Sep 2013 14:46:51 +0100
Message-Id: <1379684811-27102-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Not used for anything, and removing it avoids caller's need to
allocate a path structure.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/extent-tree.c      |    3 +--
 fs/btrfs/free-space-cache.c |    1 -
 fs/btrfs/free-space-cache.h |    1 -
 fs/btrfs/inode-map.c        |    2 +-
 fs/btrfs/relocation.c       |   11 +----------
 5 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d58bef1..55b537f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3197,8 +3197,7 @@ again:
 		if (ret)
 			goto out_put;
 
-		ret = btrfs_truncate_free_space_cache(root, trans, path,
-						      inode);
+		ret = btrfs_truncate_free_space_cache(root, trans, inode);
 		if (ret)
 			goto out_put;
 	}
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 38e3779..7fd48df 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -218,7 +218,6 @@ int btrfs_check_trunc_cache_free_space(struct btrfs_root *root,
 
 int btrfs_truncate_free_space_cache(struct btrfs_root *root,
 				    struct btrfs_trans_handle *trans,
-				    struct btrfs_path *path,
 				    struct inode *inode)
 {
 	loff_t oldsize;
diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index ba8d5a1..0cf4977 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -58,7 +58,6 @@ int btrfs_check_trunc_cache_free_space(struct btrfs_root *root,
 				       struct btrfs_block_rsv *rsv);
 int btrfs_truncate_free_space_cache(struct btrfs_root *root,
 				    struct btrfs_trans_handle *trans,
-				    struct btrfs_path *path,
 				    struct inode *inode);
 int load_free_space_cache(struct btrfs_fs_info *fs_info,
 			  struct btrfs_block_group_cache *block_group);
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index b863e45..014de49 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -466,7 +466,7 @@ again:
 	}
 
 	if (i_size_read(inode) > 0) {
-		ret = btrfs_truncate_free_space_cache(root, trans, path, inode);
+		ret = btrfs_truncate_free_space_cache(root, trans, inode);
 		if (ret) {
 			if (ret != -ENOSPC)
 				btrfs_abort_transaction(trans, root, ret);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index a5a2632..5ca7ea9 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3407,7 +3407,6 @@ static int delete_block_group_cache(struct btrfs_fs_info *fs_info,
 				    struct inode *inode, u64 ino)
 {
 	struct btrfs_key key;
-	struct btrfs_path *path;
 	struct btrfs_root *root = fs_info->tree_root;
 	struct btrfs_trans_handle *trans;
 	int ret = 0;
@@ -3432,22 +3431,14 @@ truncate:
 	if (ret)
 		goto out;
 
-	path = btrfs_alloc_path();
-	if (!path) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
 	trans = btrfs_join_transaction(root);
 	if (IS_ERR(trans)) {
-		btrfs_free_path(path);
 		ret = PTR_ERR(trans);
 		goto out;
 	}
 
-	ret = btrfs_truncate_free_space_cache(root, trans, path, inode);
+	ret = btrfs_truncate_free_space_cache(root, trans, inode);
 
-	btrfs_free_path(path);
 	btrfs_end_transaction(trans, root);
 	btrfs_btree_balance_dirty(root);
 out:
-- 
1.7.9.5

