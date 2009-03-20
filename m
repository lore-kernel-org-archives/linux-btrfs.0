From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH 4/4] Btrfs: kill the pinned_mutex
Date: Fri, 20 Mar 2009 14:59:53 -0400
Message-ID: <1237575593-21101-5-git-send-email-jbacik@redhat.com>
Cc: Josef Bacik <jbacik@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <>
List-ID: <linux-btrfs.vger.kernel.org>

This patch removes the pinned_mutex.  The extent io map has an internal tree
lock that protects the tree itself, and since we only copy the extent io map
when we are committing the transaction we don't need it there.  We also don't
need it when caching the block group since searching through the tree is also
protected by the internal map spin lock.

Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 fs/btrfs/ctree.h       |    1 -
 fs/btrfs/disk-io.c     |    1 -
 fs/btrfs/extent-tree.c |   11 -----------
 fs/btrfs/tree-log.c    |    5 +----
 4 files changed, 1 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index bb9b78b..2b15a74 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -716,7 +716,6 @@ struct btrfs_fs_info {
 	struct mutex tree_log_mutex;
 	struct mutex transaction_kthread_mutex;
 	struct mutex cleaner_mutex;
-	struct mutex pinned_mutex;
 	struct mutex chunk_mutex;
 	struct mutex drop_mutex;
 	struct mutex volume_mutex;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 9244cd7..fe6dcd5 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1645,7 +1645,6 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	mutex_init(&fs_info->trans_mutex);
 	mutex_init(&fs_info->tree_log_mutex);
 	mutex_init(&fs_info->drop_mutex);
-	mutex_init(&fs_info->pinned_mutex);
 	mutex_init(&fs_info->chunk_mutex);
 	mutex_init(&fs_info->transaction_kthread_mutex);
 	mutex_init(&fs_info->cleaner_mutex);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4913a94..48f5294 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -166,7 +166,6 @@ static int add_new_free_space(struct btrfs_block_group_cache *block_group,
 	u64 extent_start, extent_end, size;
 	int ret;
 
-	mutex_lock(&info->pinned_mutex);
 	while (start < end) {
 		ret = find_first_extent_bit(&info->pinned_extents, start,
 					    &extent_start, &extent_end,
@@ -192,7 +191,6 @@ static int add_new_free_space(struct btrfs_block_group_cache *block_group,
 		ret = btrfs_add_free_space(block_group, start, size);
 		BUG_ON(ret);
 	}
-	mutex_unlock(&info->pinned_mutex);
 
 	return 0;
 }
@@ -2047,7 +2045,6 @@ int btrfs_update_pinned_extents(struct btrfs_root *root,
 	struct btrfs_block_group_cache *cache;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 
-	WARN_ON(!mutex_is_locked(&root->fs_info->pinned_mutex));
 	if (pin) {
 		set_extent_dirty(&fs_info->pinned_extents,
 				bytenr, bytenr + num - 1, GFP_NOFS);
@@ -2055,7 +2052,6 @@ int btrfs_update_pinned_extents(struct btrfs_root *root,
 		clear_extent_dirty(&fs_info->pinned_extents,
 				bytenr, bytenr + num - 1, GFP_NOFS);
 	}
-	mutex_unlock(&root->fs_info->pinned_mutex);
 
 	while (num > 0) {
 		cache = btrfs_lookup_block_group(fs_info, bytenr);
@@ -2127,7 +2123,6 @@ int btrfs_copy_pinned(struct btrfs_root *root, struct extent_io_tree *copy)
 	struct extent_io_tree *pinned_extents = &root->fs_info->pinned_extents;
 	int ret;
 
-	mutex_lock(&root->fs_info->pinned_mutex);
 	while (1) {
 		ret = find_first_extent_bit(pinned_extents, last,
 					    &start, &end, EXTENT_DIRTY);
@@ -2136,7 +2131,6 @@ int btrfs_copy_pinned(struct btrfs_root *root, struct extent_io_tree *copy)
 		set_extent_dirty(copy, start, end, GFP_NOFS);
 		last = end + 1;
 	}
-	mutex_unlock(&root->fs_info->pinned_mutex);
 	return 0;
 }
 
@@ -2149,7 +2143,6 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 	int ret;
 
 	while (1) {
-		mutex_lock(&root->fs_info->pinned_mutex);
 		ret = find_first_extent_bit(unpin, 0, &start, &end,
 					    EXTENT_DIRTY);
 		if (ret)
@@ -2163,7 +2156,6 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 
 		cond_resched();
 	}
-	mutex_unlock(&root->fs_info->pinned_mutex);
 	return ret;
 }
 
@@ -2205,7 +2197,6 @@ static int pin_down_bytes(struct btrfs_trans_handle *trans,
 	free_extent_buffer(buf);
 pinit:
 	btrfs_set_path_blocking(path);
-	mutex_lock(&root->fs_info->pinned_mutex);
 	/* unlocks the pinned mutex */
 	btrfs_update_pinned_extents(root, bytenr, num_bytes, 1);
 
@@ -2507,8 +2498,6 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 	 */
 	if (root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID &&
 	    owner_objectid < BTRFS_FIRST_FREE_OBJECTID) {
-		mutex_lock(&root->fs_info->pinned_mutex);
-
 		/* unlocks the pinned mutex */
 		btrfs_update_pinned_extents(root, bytenr, num_bytes, 1);
 		update_reserved_extents(root, bytenr, num_bytes, 0);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 9c462fb..7b19c65 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -199,12 +199,9 @@ static int process_one_buffer(struct btrfs_root *log,
 			      struct extent_buffer *eb,
 			      struct walk_control *wc, u64 gen)
 {
-	if (wc->pin) {
-		mutex_lock(&log->fs_info->pinned_mutex);
+	if (wc->pin)
 		btrfs_update_pinned_extents(log->fs_info->extent_root,
 					    eb->start, eb->len, 1);
-		mutex_unlock(&log->fs_info->pinned_mutex);
-	}
 
 	if (btrfs_buffer_uptodate(eb, gen)) {
 		if (wc->write)
-- 
1.5.4.3

