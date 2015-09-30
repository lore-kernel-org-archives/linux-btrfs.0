Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:35603 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbbI3Dux (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 23:50:53 -0400
Received: by pacfv12 with SMTP id fv12so26675828pac.2
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2015 20:50:52 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v4 8/9] Btrfs: wire up the free space tree to the extent tree
Date: Tue, 29 Sep 2015 20:50:37 -0700
Message-Id: <726e6f83f0c6a98e2b2bbd005900e063dce886a5.1443583874.git.osandov@osandov.com>
In-Reply-To: <cover.1443583874.git.osandov@osandov.com>
References: <cover.1443583874.git.osandov@osandov.com>
In-Reply-To: <cover.1443583874.git.osandov@osandov.com>
References: <cover.1443583874.git.osandov@osandov.com>
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
 fs/btrfs/extent-tree.c | 36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a3b84ee8a28d..4ff8aeb621cc 100644
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
@@ -518,7 +519,10 @@ static noinline void caching_thread(struct btrfs_work *work)
 	mutex_lock(&caching_ctl->mutex);
 	down_read(&fs_info->commit_root_sem);
 
-	ret = load_extent_tree_free(caching_ctl);
+	if (btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE))
+		ret = load_free_space_tree(caching_ctl);
+	else
+		ret = load_extent_tree_free(caching_ctl);
 
 	spin_lock(&block_group->lock);
 	block_group->caching_ctl = NULL;
@@ -624,8 +628,8 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
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
@@ -6475,6 +6479,13 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
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
@@ -7418,6 +7429,11 @@ static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
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
@@ -7499,6 +7515,11 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
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
@@ -9366,6 +9387,8 @@ btrfs_create_block_group_cache(struct btrfs_root *root, u64 start, u64 size)
 	cache->full_stripe_len = btrfs_full_stripe_len(root,
 					       &root->fs_info->mapping_tree,
 					       start);
+	set_free_space_tree_thresholds(cache);
+
 	atomic_set(&cache->count, 1);
 	spin_lock_init(&cache->lock);
 	init_rwsem(&cache->data_rwsem);
@@ -9586,6 +9609,8 @@ void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans,
 					       key.objectid, key.offset);
 		if (ret)
 			btrfs_abort_transaction(trans, extent_root, ret);
+		add_block_group_free_space(trans, root->fs_info, block_group);
+		/* already aborted the transaction if it failed. */
 next:
 		list_del_init(&block_group->bg_list);
 	}
@@ -9615,6 +9640,7 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	cache->flags = type;
 	cache->last_byte_to_unpin = (u64)-1;
 	cache->cached = BTRFS_CACHE_FINISHED;
+	cache->needs_free_space = 1;
 	ret = exclude_super_stripes(root, cache);
 	if (ret) {
 		/*
@@ -9977,6 +10003,10 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 
 	unlock_chunks(root);
 
+	ret = remove_block_group_free_space(trans, root->fs_info, block_group);
+	if (ret)
+		goto out;
+
 	btrfs_put_block_group(block_group);
 	btrfs_put_block_group(block_group);
 
-- 
2.6.0

