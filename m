From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: remove the ideal caching code
Date: Wed, 18 Jan 2012 10:57:32 -0500
Message-ID: <1326902252-3052-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a relic from before we had the disk space cache and it was to make
bootup times when you had btrfs as root not be so damned slow.  Now that we have
the disk space cache this isn't a problem anymore and really having this code
casues uneeded fragmentation and complexity, so just remove it.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |   93 ++++-------------------------------------------
 1 files changed, 8 insertions(+), 85 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e0ad5f0..2288674 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5250,11 +5250,10 @@ static int get_block_group_index(struct btrfs_block_group_cache *cache)
 }
 
 enum btrfs_loop_type {
-	LOOP_FIND_IDEAL = 0,
-	LOOP_CACHING_NOWAIT = 1,
-	LOOP_CACHING_WAIT = 2,
-	LOOP_ALLOC_CHUNK = 3,
-	LOOP_NO_EMPTY_SIZE = 4,
+	LOOP_CACHING_NOWAIT = 0,
+	LOOP_CACHING_WAIT = 1,
+	LOOP_ALLOC_CHUNK = 2,
+	LOOP_NO_EMPTY_SIZE = 3,
 };
 
 /*
@@ -5290,8 +5289,6 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 	bool failed_alloc = false;
 	bool use_cluster = true;
 	bool have_caching_bg = false;
-	u64 ideal_cache_percent = 0;
-	u64 ideal_cache_offset = 0;
 
 	WARN_ON(num_bytes < root->sectorsize);
 	btrfs_set_key_type(ins, BTRFS_EXTENT_ITEM_KEY);
@@ -5341,7 +5338,6 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 		empty_cluster = 0;
 
 	if (search_start == hint_byte) {
-ideal_cache:
 		block_group = btrfs_lookup_block_group(root->fs_info,
 						       search_start);
 		used_block_group = block_group;
@@ -5353,8 +5349,7 @@ ideal_cache:
 		 * picked out then we don't care that the block group is cached.
 		 */
 		if (block_group && block_group_bits(block_group, data) &&
-		    (block_group->cached != BTRFS_CACHE_NO ||
-		     search_start == ideal_cache_offset)) {
+		    block_group->cached != BTRFS_CACHE_NO) {
 			down_read(&space_info->groups_sem);
 			if (list_empty(&block_group->list) ||
 			    block_group->ro) {
@@ -5408,44 +5403,12 @@ search:
 have_block_group:
 		cached = block_group_cache_done(block_group);
 		if (unlikely(!cached)) {
-			u64 free_percent;
-
 			found_uncached_bg = true;
 			ret = cache_block_group(block_group, trans,
-						orig_root, 1);
-			if (block_group->cached == BTRFS_CACHE_FINISHED)
-				goto alloc;
-
-			free_percent = btrfs_block_group_used(&block_group->item);
-			free_percent *= 100;
-			free_percent = div64_u64(free_percent,
-						 block_group->key.offset);
-			free_percent = 100 - free_percent;
-			if (free_percent > ideal_cache_percent &&
-			    likely(!block_group->ro)) {
-				ideal_cache_offset = block_group->key.objectid;
-				ideal_cache_percent = free_percent;
-			}
-
-			/*
-			 * The caching workers are limited to 2 threads, so we
-			 * can queue as much work as we care to.
-			 */
-			if (loop > LOOP_FIND_IDEAL) {
-				ret = cache_block_group(block_group, trans,
-							orig_root, 0);
-				BUG_ON(ret);
-			}
-
-			/*
-			 * If loop is set for cached only, try the next block
-			 * group.
-			 */
-			if (loop == LOOP_FIND_IDEAL)
-				goto loop;
+						orig_root, 0);
+			BUG_ON(ret);
 		}
 
-alloc:
 		if (unlikely(block_group->ro))
 			goto loop;
 
@@ -5651,9 +5614,7 @@ loop:
 	if (!ins->objectid && ++index < BTRFS_NR_RAID_TYPES)
 		goto search;
 
-	/* LOOP_FIND_IDEAL, only search caching/cached bg's, and don't wait for
-	 *			for them to make caching progress.  Also
-	 *			determine the best possible bg to cache
+	/*
 	 * LOOP_CACHING_NOWAIT, search partially cached block groups, kicking
 	 *			caching kthreads as we move along
 	 * LOOP_CACHING_WAIT, search everything, and wait if our bg is caching
@@ -5663,45 +5624,7 @@ loop:
 	 */
 	if (!ins->objectid && loop < LOOP_NO_EMPTY_SIZE) {
 		index = 0;
-		if (loop == LOOP_FIND_IDEAL && found_uncached_bg) {
-			found_uncached_bg = false;
-			loop++;
-			if (!ideal_cache_percent)
-				goto search;
-
-			/*
-			 * 1 of the following 2 things have happened so far
-			 *
-			 * 1) We found an ideal block group for caching that
-			 * is mostly full and will cache quickly, so we might
-			 * as well wait for it.
-			 *
-			 * 2) We searched for cached only and we didn't find
-			 * anything, and we didn't start any caching kthreads
-			 * either, so chances are we will loop through and
-			 * start a couple caching kthreads, and then come back
-			 * around and just wait for them.  This will be slower
-			 * because we will have 2 caching kthreads reading at
-			 * the same time when we could have just started one
-			 * and waited for it to get far enough to give us an
-			 * allocation, so go ahead and go to the wait caching
-			 * loop.
-			 */
-			loop = LOOP_CACHING_WAIT;
-			search_start = ideal_cache_offset;
-			ideal_cache_percent = 0;
-			goto ideal_cache;
-		} else if (loop == LOOP_FIND_IDEAL) {
-			/*
-			 * Didn't find a uncached bg, wait on anything we find
-			 * next.
-			 */
-			loop = LOOP_CACHING_WAIT;
-			goto search;
-		}
-
 		loop++;
-
 		if (loop == LOOP_ALLOC_CHUNK) {
 		       if (allowed_chunk_alloc) {
 				ret = do_chunk_alloc(trans, root, num_bytes +
-- 
1.7.5.2

