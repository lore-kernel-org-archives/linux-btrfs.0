Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45081 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752674AbcLBFHv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Dec 2016 00:07:51 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 868F9ABD1
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Dec 2016 05:07:50 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 16/18] btrfs: simplify btrfs_wait_cache_io prototype
Date: Fri,  2 Dec 2016 00:07:36 -0500
Message-Id: <1480655258-15400-17-git-send-email-jeffm@suse.com>
In-Reply-To: <1480655258-15400-1-git-send-email-jeffm@suse.com>
References: <1480655258-15400-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

With the exception of the one case where btrfs_wait_cache_io is called
without a block group, it's called with the same arguments.  The root
argument is only used in the special case, so let's factor out the core
and simplify the call in the normal case to require a trans, block group,
and path.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent-tree.c      | 15 ++++-----------
 fs/btrfs/free-space-cache.c | 40 ++++++++++++++++++++++++++++------------
 fs/btrfs/free-space-cache.h |  6 ++----
 3 files changed, 34 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a358aaa..d0c5d5d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3610,9 +3610,7 @@ int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans,
 		 */
 		if (!list_empty(&cache->io_list)) {
 			list_del_init(&cache->io_list);
-			btrfs_wait_cache_io(root, trans, cache,
-					    &cache->io_ctl, path,
-					    cache->key.objectid);
+			btrfs_wait_cache_io(trans, cache, path);
 			btrfs_put_block_group(cache);
 		}
 
@@ -3767,9 +3765,7 @@ int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
 		if (!list_empty(&cache->io_list)) {
 			spin_unlock(&cur_trans->dirty_bgs_lock);
 			list_del_init(&cache->io_list);
-			btrfs_wait_cache_io(root, trans, cache,
-					    &cache->io_ctl, path,
-					    cache->key.objectid);
+			btrfs_wait_cache_io(trans, cache, path);
 			btrfs_put_block_group(cache);
 			spin_lock(&cur_trans->dirty_bgs_lock);
 		}
@@ -3839,8 +3835,7 @@ int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
 		cache = list_first_entry(io, struct btrfs_block_group_cache,
 					 io_list);
 		list_del_init(&cache->io_list);
-		btrfs_wait_cache_io(root, trans, cache,
-				    &cache->io_ctl, path, cache->key.objectid);
+		btrfs_wait_cache_io(trans, cache, path);
 		btrfs_put_block_group(cache);
 	}
 
@@ -10383,9 +10378,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 		WARN_ON(!IS_ERR(inode) && inode != block_group->io_ctl.inode);
 
 		spin_unlock(&trans->transaction->dirty_bgs_lock);
-		btrfs_wait_cache_io(root, trans, block_group,
-				    &block_group->io_ctl, path,
-				    block_group->key.objectid);
+		btrfs_wait_cache_io(trans, block_group, path);
 		btrfs_put_block_group(block_group);
 		spin_lock(&trans->transaction->dirty_bgs_lock);
 	}
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index e937636..ab7e2b9 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -42,6 +42,10 @@ static int link_free_space(struct btrfs_free_space_ctl *ctl,
 			   struct btrfs_free_space *info);
 static void unlink_free_space(struct btrfs_free_space_ctl *ctl,
 			      struct btrfs_free_space *info);
+static int btrfs_wait_cache_io_root(struct btrfs_root *root,
+			     struct btrfs_trans_handle *trans,
+			     struct btrfs_io_ctl *io_ctl,
+			     struct btrfs_path *path);
 
 static struct inode *__lookup_free_space_inode(struct btrfs_root *root,
 					       struct btrfs_path *path,
@@ -244,9 +248,7 @@ int btrfs_truncate_free_space_cache(struct btrfs_root *root,
 		if (!list_empty(&block_group->io_list)) {
 			list_del_init(&block_group->io_list);
 
-			btrfs_wait_cache_io(root, trans, block_group,
-					    &block_group->io_ctl, path,
-					    block_group->key.objectid);
+			btrfs_wait_cache_io(trans, block_group, path);
 			btrfs_put_block_group(block_group);
 		}
 
@@ -1139,11 +1141,11 @@ cleanup_write_cache_enospc(struct inode *inode,
 			     GFP_NOFS);
 }
 
-int btrfs_wait_cache_io(struct btrfs_root *root,
-			struct btrfs_trans_handle *trans,
-			struct btrfs_block_group_cache *block_group,
-			struct btrfs_io_ctl *io_ctl,
-			struct btrfs_path *path, u64 offset)
+static int __btrfs_wait_cache_io(struct btrfs_root *root,
+				 struct btrfs_trans_handle *trans,
+				 struct btrfs_block_group_cache *block_group,
+				 struct btrfs_io_ctl *io_ctl,
+				 struct btrfs_path *path, u64 offset)
 {
 	int ret;
 	struct inode *inode = io_ctl->inode;
@@ -1154,9 +1156,6 @@ int btrfs_wait_cache_io(struct btrfs_root *root,
 
 	fs_info = btrfs_sb(inode->i_sb);
 
-	if (block_group)
-		root = fs_info->tree_root;
-
 	/* Flush the dirty pages in the cache file. */
 	ret = flush_dirty_cache(inode);
 	if (ret)
@@ -1207,6 +1206,23 @@ int btrfs_wait_cache_io(struct btrfs_root *root,
 
 }
 
+static int btrfs_wait_cache_io_root(struct btrfs_root *root,
+				    struct btrfs_trans_handle *trans,
+				    struct btrfs_io_ctl *io_ctl,
+				    struct btrfs_path *path)
+{
+	return __btrfs_wait_cache_io(root, trans, NULL, io_ctl, path, 0);
+}
+
+int btrfs_wait_cache_io(struct btrfs_trans_handle *trans,
+			struct btrfs_block_group_cache *block_group,
+			struct btrfs_path *path)
+{
+	return __btrfs_wait_cache_io(block_group->fs_info->tree_root, trans,
+				     block_group, &block_group->io_ctl,
+				     path, block_group->key.objectid);
+}
+
 /**
  * __btrfs_write_out_cache - write out cached info to an inode
  * @root - the root the inode belongs to
@@ -3541,7 +3557,7 @@ int btrfs_write_out_ino_cache(struct btrfs_root *root,
 		 * with or without an error.
 		 */
 		release_metadata = false;
-		ret = btrfs_wait_cache_io(root, trans, NULL, &io_ctl, path, 0);
+		ret = btrfs_wait_cache_io_root(root, trans, &io_ctl, path);
 	}
 
 	if (ret) {
diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index 70e7a7c..f39ba85 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -67,11 +67,9 @@ int btrfs_truncate_free_space_cache(struct btrfs_root *root,
 				    struct inode *inode);
 int load_free_space_cache(struct btrfs_fs_info *fs_info,
 			  struct btrfs_block_group_cache *block_group);
-int btrfs_wait_cache_io(struct btrfs_root *root,
-			struct btrfs_trans_handle *trans,
+int btrfs_wait_cache_io(struct btrfs_trans_handle *trans,
 			struct btrfs_block_group_cache *block_group,
-			struct btrfs_io_ctl *io_ctl,
-			struct btrfs_path *path, u64 offset);
+			struct btrfs_path *path);
 int btrfs_write_out_cache(struct btrfs_fs_info *fs_info,
 			  struct btrfs_trans_handle *trans,
 			  struct btrfs_block_group_cache *block_group,
-- 
2.7.1

