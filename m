Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34483 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756942AbbICToo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Sep 2015 15:44:44 -0400
Received: by padfa1 with SMTP id fa1so13301453pad.1
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Sep 2015 12:44:44 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v2 8/9] Btrfs: wire up the free space tree to the extent tree
Date: Thu,  3 Sep 2015 12:44:26 -0700
Message-Id: <16e7941616c2f9e647cb93367889c407cfa8bc51.1441309178.git.osandov@fb.com>
In-Reply-To: <cover.1441309178.git.osandov@fb.com>
In-Reply-To: <cover.1441309178.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <cover.1441309178.git.osandov@fb.com>

The free space tree is updated in tandem with the extent tree. There are
only a handful of places where we need to hook in:

1. Block group creation
2. Block group deletion
3. Delayed refs (extent creation and deletion)
4. Block group caching

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/extent-tree.c | 40 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 37 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 418c0eca9bb4..1c007e858787 100644
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
@@ -520,7 +521,10 @@ static noinline void caching_thread(struct btrfs_work *work)
 	mutex_lock(&caching_ctl->mutex);
 	down_read(&fs_info->commit_root_sem);
 
-	ret = load_extent_tree_free(caching_ctl);
+	if (btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE))
+		ret = load_free_space_tree(caching_ctl);
+	else
+		ret = load_extent_tree_free(caching_ctl);
 
 	spin_lock(&block_group->lock);
 	block_group->caching_ctl = NULL;
@@ -626,8 +630,8 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
 		}
 	} else {
 		/*
-		 * We are not going to do the fast caching, set cached to the
-		 * appropriate value and wakeup any waiters.
+		 * We're either using the free space tree or no caching at all.
+		 * Set cached to the appropriate value and wakeup any waiters.
 		 */
 		spin_lock(&cache->lock);
 		if (load_cache_only) {
@@ -6385,6 +6389,13 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
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
@@ -7328,6 +7339,11 @@ static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
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
@@ -7409,6 +7425,11 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
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
@@ -9279,6 +9300,8 @@ btrfs_create_block_group_cache(struct btrfs_root *root, u64 start, u64 size)
 	cache->full_stripe_len = btrfs_full_stripe_len(root,
 					       &root->fs_info->mapping_tree,
 					       start);
+	set_free_space_tree_thresholds(cache);
+
 	atomic_set(&cache->count, 1);
 	spin_lock_init(&cache->lock);
 	init_rwsem(&cache->data_rwsem);
@@ -9542,6 +9565,13 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
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
@@ -9885,6 +9915,10 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 
 	unlock_chunks(root);
 
+	ret = remove_block_group_free_space(trans, root->fs_info, block_group);
+	if (ret)
+		goto out;
+
 	btrfs_put_block_group(block_group);
 	btrfs_put_block_group(block_group);
 
-- 
2.5.1

