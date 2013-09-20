Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:43729 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668Ab3ITNns (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Sep 2013 09:43:48 -0400
Received: by mail-bk0-f44.google.com with SMTP id mz10so191261bkb.31
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Sep 2013 06:43:47 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: remove duplicated ino cache's inode lookup
Date: Fri, 20 Sep 2013 14:43:28 +0100
Message-Id: <1379684608-18825-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We're doing a unnecessary extra lookup of the ino cache's
inode when we already have it (and holding a reference)
during the process of saving the ino cache contents to disk.
Therefore remove this extra lookup.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/free-space-cache.c |    9 ++-------
 fs/btrfs/free-space-cache.h |    3 ++-
 fs/btrfs/inode-map.c        |    2 +-
 3 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 4f419ba..38e3779 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2969,19 +2969,15 @@ out:
 
 int btrfs_write_out_ino_cache(struct btrfs_root *root,
 			      struct btrfs_trans_handle *trans,
-			      struct btrfs_path *path)
+			      struct btrfs_path *path,
+			      struct inode *inode)
 {
 	struct btrfs_free_space_ctl *ctl = root->free_ino_ctl;
-	struct inode *inode;
 	int ret;
 
 	if (!btrfs_test_opt(root, INODE_MAP_CACHE))
 		return 0;
 
-	inode = lookup_free_ino_inode(root, path);
-	if (IS_ERR(inode))
-		return 0;
-
 	ret = __btrfs_write_out_cache(root, inode, ctl, NULL, trans, path, 0);
 	if (ret) {
 		btrfs_delalloc_release_metadata(inode, inode->i_size);
@@ -2992,7 +2988,6 @@ int btrfs_write_out_ino_cache(struct btrfs_root *root,
 #endif
 	}
 
-	iput(inode);
 	return ret;
 }
 
diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index e737f92..ba8d5a1 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -76,7 +76,8 @@ int load_free_ino_cache(struct btrfs_fs_info *fs_info,
 			struct btrfs_root *root);
 int btrfs_write_out_ino_cache(struct btrfs_root *root,
 			      struct btrfs_trans_handle *trans,
-			      struct btrfs_path *path);
+			      struct btrfs_path *path,
+			      struct inode *inode);
 
 void btrfs_init_free_space_ctl(struct btrfs_block_group_cache *block_group);
 int __btrfs_add_free_space(struct btrfs_free_space_ctl *ctl,
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index d11e1c6..b863e45 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -503,7 +503,7 @@ again:
 	}
 	btrfs_free_reserved_data_space(inode, prealloc);
 
-	ret = btrfs_write_out_ino_cache(root, trans, path);
+	ret = btrfs_write_out_ino_cache(root, trans, path, inode);
 out_put:
 	iput(inode);
 out_release:
-- 
1.7.9.5

