From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: do not do fast caching if we are allocating blocks for tree_root
Date: Wed,  8 Dec 2010 09:18:07 -0500
Message-ID: <1291817887-16217-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org, sage@newdream.net
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Since the fast caching uses normal tree locking, we can possibly deadlock if we
get to the caching via a btrfs_search_slot() on the tree_root.  So just check to
see if the root we are on is the tree root, and just don't do the fast caching.

Reported-by: Sage Weil <sage@newdream.net>
Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 03f4738..8aed05e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -434,6 +434,7 @@ err:
 
 static int cache_block_group(struct btrfs_block_group_cache *cache,
 			     struct btrfs_trans_handle *trans,
+			     struct btrfs_root *root,
 			     int load_cache_only)
 {
 	struct btrfs_fs_info *fs_info = cache->fs_info;
@@ -447,9 +448,12 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
 
 	/*
 	 * We can't do the read from on-disk cache during a commit since we need
-	 * to have the normal tree locking.
+	 * to have the normal tree locking.  Also if we are currently trying to
+	 * allocate blocks for the tree root we can't do the fast caching since
+	 * we likely hold important locks.
 	 */
-	if (!trans->transaction->in_commit) {
+	if (!trans->transaction->in_commit &&
+	    (root && root != root->fs_info->tree_root)) {
 		spin_lock(&cache->lock);
 		if (cache->cached != BTRFS_CACHE_NO) {
 			spin_unlock(&cache->lock);
@@ -4089,7 +4093,7 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 		 * space back to the block group, otherwise we will leak space.
 		 */
 		if (!alloc && cache->cached == BTRFS_CACHE_NO)
-			cache_block_group(cache, trans, 1);
+			cache_block_group(cache, trans, NULL, 1);
 
 		byte_in_group = bytenr - cache->key.objectid;
 		WARN_ON(byte_in_group > cache->key.offset);
@@ -4984,7 +4988,8 @@ have_block_group:
 		if (unlikely(block_group->cached == BTRFS_CACHE_NO)) {
 			u64 free_percent;
 
-			ret = cache_block_group(block_group, trans, 1);
+			ret = cache_block_group(block_group, trans,
+						orig_root, 1);
 			if (block_group->cached == BTRFS_CACHE_FINISHED)
 				goto have_block_group;
 
@@ -5008,7 +5013,8 @@ have_block_group:
 			if (loop > LOOP_CACHING_NOWAIT ||
 			    (loop > LOOP_FIND_IDEAL &&
 			     atomic_read(&space_info->caching_threads) < 2)) {
-				ret = cache_block_group(block_group, trans, 0);
+				ret = cache_block_group(block_group, trans,
+							orig_root, 0);
 				BUG_ON(ret);
 			}
 			found_uncached_bg = true;
@@ -5561,7 +5567,7 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 	u64 num_bytes = ins->offset;
 
 	block_group = btrfs_lookup_block_group(root->fs_info, ins->objectid);
-	cache_block_group(block_group, trans, 0);
+	cache_block_group(block_group, trans, NULL, 0);
 	caching_ctl = get_caching_control(block_group);
 
 	if (!caching_ctl) {
-- 
1.6.6.1

