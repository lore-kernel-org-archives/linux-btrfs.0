Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35688 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbbIATGH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Sep 2015 15:06:07 -0400
Received: by pacfv12 with SMTP id fv12so4664507pac.2
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Sep 2015 12:06:06 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: Omar Sandoval <osandov@fb.com>
Subject: [PATCH 5/6] Btrfs: wire up the free space tree to the extent tree
Date: Tue,  1 Sep 2015 12:05:55 -0700
Message-Id: <5354d2ad80625f36be4032664a7d39f4c4874119.1441131625.git.osandov@fb.com>
In-Reply-To: <cover.1441131625.git.osandov@fb.com>
References: <cover.1441131625.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

The free space tree is updated in tandem with the extent tree. There are
only a handful of places where we need to hook in:

1. Block group creation
2. Block group deletion
3. Delayed refs (extent creation and deletion)
4. Block group caching

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/extent-tree.c | 73 +++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 70 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 37179a569f40..3f10df3932f0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -33,6 +33,7 @@
 #include "raid56.h"
 #include "locking.h"
 #include "free-space-cache.h"
+#include "free-space-tree.h"
 #include "math.h"
 #include "sysfs.h"
 #include "qgroup.h"
@@ -589,7 +590,41 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
 	cache->cached = BTRFS_CACHE_FAST;
 	spin_unlock(&cache->lock);
 
-	if (fs_info->mount_opt & BTRFS_MOUNT_SPACE_CACHE) {
+	if (btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE)) {
+		if (load_cache_only) {
+			spin_lock(&cache->lock);
+			cache->caching_ctl = NULL;
+			cache->cached = BTRFS_CACHE_NO;
+			spin_unlock(&cache->lock);
+			wake_up(&caching_ctl->wait);
+		} else {
+			mutex_lock(&caching_ctl->mutex);
+			ret = load_free_space_tree(fs_info, cache);
+			if (ret) {
+				btrfs_warn(fs_info, "failed to load free space tree for %llu: %d",
+					   cache->key.objectid, ret);
+				spin_lock(&cache->lock);
+				cache->caching_ctl = NULL;
+				cache->cached = BTRFS_CACHE_ERROR;
+				spin_unlock(&cache->lock);
+				goto tree_out;
+			}
+
+			spin_lock(&cache->lock);
+			cache->caching_ctl = NULL;
+			cache->cached = BTRFS_CACHE_FINISHED;
+			cache->last_byte_to_unpin = (u64)-1;
+			caching_ctl->progress = (u64)-1;
+			spin_unlock(&cache->lock);
+			mutex_unlock(&caching_ctl->mutex);
+
+tree_out:
+			wake_up(&caching_ctl->wait);
+			put_caching_control(caching_ctl);
+			free_excluded_extents(fs_info->extent_root, cache);
+			return 0;
+		}
+	} else if (fs_info->mount_opt & BTRFS_MOUNT_SPACE_CACHE) {
 		mutex_lock(&caching_ctl->mutex);
 		ret = load_free_space_cache(fs_info, cache);
 
@@ -619,8 +654,10 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
 		}
 	} else {
 		/*
-		 * We are not going to do the fast caching, set cached to the
-		 * appropriate value and wakeup any waiters.
+		 * We're here either because we're not using the space cache or
+		 * free space tree, or because we're currently building the free
+		 * space tree. Set cached to the appropriate value and wakeup
+		 * any waiters.
 		 */
 		spin_lock(&cache->lock);
 		if (load_cache_only) {
@@ -6378,6 +6415,13 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 			}
 		}
 
+		ret = add_to_free_space_tree(trans, root->fs_info, bytenr,
+					     num_bytes);
+		if (ret) {
+			btrfs_abort_transaction(trans, extent_root, ret);
+			goto out;
+		}
+
 		ret = update_block_group(trans, root, bytenr, num_bytes, 0);
 		if (ret) {
 			btrfs_abort_transaction(trans, extent_root, ret);
@@ -7321,6 +7365,11 @@ static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(path->nodes[0]);
 	btrfs_free_path(path);
 
+	ret = remove_from_free_space_tree(trans, fs_info, ins->objectid,
+					  ins->offset);
+	if (ret)
+		return ret;
+
 	ret = update_block_group(trans, root, ins->objectid, ins->offset, 1);
 	if (ret) { /* -ENOENT, logic error */
 		btrfs_err(fs_info, "update block group failed for %llu %llu",
@@ -7402,6 +7451,11 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_free_path(path);
 
+	ret = remove_from_free_space_tree(trans, fs_info, ins->objectid,
+					  num_bytes);
+	if (ret)
+		return ret;
+
 	ret = update_block_group(trans, root, ins->objectid, root->nodesize,
 				 1);
 	if (ret) { /* -ENOENT, logic error */
@@ -9272,6 +9326,8 @@ btrfs_create_block_group_cache(struct btrfs_root *root, u64 start, u64 size)
 	cache->full_stripe_len = btrfs_full_stripe_len(root,
 					       &root->fs_info->mapping_tree,
 					       start);
+	set_free_space_tree_thresholds(cache);
+
 	atomic_set(&cache->count, 1);
 	spin_lock_init(&cache->lock);
 	init_rwsem(&cache->data_rwsem);
@@ -9535,6 +9591,13 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	add_new_free_space(cache, root->fs_info, chunk_offset,
 			   chunk_offset + size);
 
+	ret = add_block_group_free_space(trans, root->fs_info, cache);
+	if (ret) {
+		btrfs_remove_free_space_cache(cache);
+		btrfs_put_block_group(cache);
+		return ret;
+	}
+
 	free_excluded_extents(root, cache);
 
 	/*
@@ -9878,6 +9941,10 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 
 	unlock_chunks(root);
 
+	ret = remove_block_group_free_space(trans, root->fs_info, block_group);
+	if (ret)
+		goto out;
+
 	btrfs_put_block_group(block_group);
 	btrfs_put_block_group(block_group);
 
-- 
2.5.1

