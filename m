From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: find ideal block group for caching
Date: Mon, 2 Nov 2009 14:42:04 -0500
Message-ID: <20091102194200.GC3382@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch changes a few things.  Hopefully the comments are helpfull, but
I'll try and be as verbose here.

Problem:

My fedora box was taking 1 minute and 21 seconds to boot with btrfs as root.
Part of this problem was we pick the first block group we can find and start
caching it, even if it may not have enough free space.  The other problem is
we only search for cached block groups the first time around, which we won't
find any cached block groups because this is a newly mounted fs, so we end up
caching several block groups during bootup, which with alot of fragmentation
takes around 30-45 seconds to complete, which bogs down the system.  So

Solution:

1) Don't cache block groups willy-nilly at first.  Instead try and figure out
which block group has the most free, and therefore will take the least amount
of time to cache.

2) Don't be so picky about cached block groups.  The other problem is once
we've filled up a cluster, if the block group isn't finished caching the next
time we try and do the allocation we'll completely ignore the cluster and
start searching from the beginning of the space, which makes us cache more
block groups, which slows us down even more.  So instead of skipping block
groups that are not finished caching when we have a hint, only skip the block
group if it hasn't started caching yet.

There is one other tweak in here.  Before if we allocated a chunk and still
couldn't find new space, we'd end up switching the space info to force another
chunk allocation.  This could make us end up with way too many chunks, so keep
track of this particular case.

With this patch and my previous cluster fixes my fedora box now boots in 43
seconds, and according to the bootchart is not held up by our block group
caching at all.

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |  109 +++++++++++++++++++++++++++++++++++++----------
 1 files changed, 86 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c56f916..2a4cdce 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4101,7 +4101,7 @@ wait_block_group_cache_done(struct btrfs_block_group_cache *cache)
 }
 
 enum btrfs_loop_type {
-	LOOP_CACHED_ONLY = 0,
+	LOOP_FIND_IDEAL = 0,
 	LOOP_CACHING_NOWAIT = 1,
 	LOOP_CACHING_WAIT = 2,
 	LOOP_ALLOC_CHUNK = 3,
@@ -4130,12 +4130,15 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 	struct btrfs_block_group_cache *block_group = NULL;
 	int empty_cluster = 2 * 1024 * 1024;
 	int allowed_chunk_alloc = 0;
+	int done_chunk_alloc = 0;
 	struct btrfs_space_info *space_info;
 	int last_ptr_loop = 0;
 	int loop = 0;
 	bool found_uncached_bg = false;
 	bool failed_cluster_refill = false;
 	bool failed_alloc = false;
+	u64 ideal_cache_percent = 0;
+	u64 ideal_cache_offset = 0;
 
 	WARN_ON(num_bytes < root->sectorsize);
 	btrfs_set_key_type(ins, BTRFS_EXTENT_ITEM_KEY);
@@ -4171,14 +4174,19 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 		empty_cluster = 0;
 
 	if (search_start == hint_byte) {
+ideal_cache:
 		block_group = btrfs_lookup_block_group(root->fs_info,
 						       search_start);
 		/*
 		 * we don't want to use the block group if it doesn't match our
 		 * allocation bits, or if its not cached.
+		 *
+		 * However if we are re-searching with an ideal block group
+		 * picked out then we don't care that the block group is cached.
 		 */
 		if (block_group && block_group_bits(block_group, data) &&
-		    block_group_cache_done(block_group)) {
+		    (block_group->cached != BTRFS_CACHE_NO ||
+		     search_start == ideal_cache_offset)) {
 			down_read(&space_info->groups_sem);
 			if (list_empty(&block_group->list) ||
 			    block_group->ro) {
@@ -4190,13 +4198,13 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 				 */
 				btrfs_put_block_group(block_group);
 				up_read(&space_info->groups_sem);
-			} else
+			} else {
 				goto have_block_group;
+			}
 		} else if (block_group) {
 			btrfs_put_block_group(block_group);
 		}
 	}
-
 search:
 	down_read(&space_info->groups_sem);
 	list_for_each_entry(block_group, &space_info->block_groups, list) {
@@ -4208,28 +4216,45 @@ search:
 
 have_block_group:
 		if (unlikely(block_group->cached == BTRFS_CACHE_NO)) {
+			u64 free_percent;
+
+			free_percent = btrfs_block_group_used(&block_group->item);
+			free_percent *= 100;
+			free_percent = div64_u64(free_percent,
+						 block_group->key.offset);
+			free_percent = 100 - free_percent;
+			if (free_percent > ideal_cache_percent &&
+			    likely(!block_group->ro)) {
+				ideal_cache_offset = block_group->key.objectid;
+				ideal_cache_percent = free_percent;
+			}
+
 			/*
-			 * we want to start caching kthreads, but not too many
-			 * right off the bat so we don't overwhelm the system,
-			 * so only start them if there are less than 2 and we're
-			 * in the initial allocation phase.
+			 * We only want to start kthread caching if we are at
+			 * the point where we will wait for caching to make
+			 * progress, or if our ideal search is over and we've
+			 * found somebody to start caching.
 			 */
 			if (loop > LOOP_CACHING_NOWAIT ||
-			    atomic_read(&space_info->caching_threads) < 2) {
+			    (loop > LOOP_FIND_IDEAL &&
+			     atomic_read(&space_info->caching_threads) < 2)) {
 				ret = cache_block_group(block_group);
 				BUG_ON(ret);
 			}
-		}
-
-		cached = block_group_cache_done(block_group);
-		if (unlikely(!cached)) {
 			found_uncached_bg = true;
 
-			/* if we only want cached bgs, loop */
-			if (loop == LOOP_CACHED_ONLY)
+			/*
+			 * If loop is set for cached only, try the next block
+			 * group.
+			 */
+			if (loop == LOOP_FIND_IDEAL)
 				goto loop;
 		}
 
+		cached = block_group_cache_done(block_group);
+		if (unlikely(!cached))
+			found_uncached_bg = true;
+
 		if (unlikely(block_group->ro))
 			goto loop;
 
@@ -4409,9 +4434,11 @@ loop:
 	}
 	up_read(&space_info->groups_sem);
 
-	/* LOOP_CACHED_ONLY, only search fully cached block groups
-	 * LOOP_CACHING_NOWAIT, search partially cached block groups, but
-	 *			dont wait foR them to finish caching
+	/* LOOP_FIND_IDEAL, only search caching/cached bg's, and don't wait for
+	 *			for them to make caching progress.  Also
+	 *			determine the best possible bg to cache
+	 * LOOP_CACHING_NOWAIT, search partially cached block groups, kicking
+	 *			caching kthreads as we move along
 	 * LOOP_CACHING_WAIT, search everything, and wait if our bg is caching
 	 * LOOP_ALLOC_CHUNK, force a chunk allocation and try again
 	 * LOOP_NO_EMPTY_SIZE, set empty_size and empty_cluster to 0 and try
@@ -4420,12 +4447,47 @@ loop:
 	if (!ins->objectid && loop < LOOP_NO_EMPTY_SIZE &&
 	    (found_uncached_bg || empty_size || empty_cluster ||
 	     allowed_chunk_alloc)) {
-		if (found_uncached_bg) {
+		if (loop == LOOP_FIND_IDEAL && found_uncached_bg) {
 			found_uncached_bg = false;
-			if (loop < LOOP_CACHING_WAIT) {
-				loop++;
+			loop++;
+			if (!ideal_cache_percent &&
+			    atomic_read(&space_info->caching_threads))
 				goto search;
-			}
+
+			/*
+			 * 1 of the following 2 things have happened so far
+			 *
+			 * 1) We found an ideal block group for caching that
+			 * is mostly full and will cache quickly, so we might
+			 * as well wait for it.
+			 *
+			 * 2) We searched for cached only and we didn't find
+			 * anything, and we didn't start any caching kthreads
+			 * either, so chances are we will loop through and
+			 * start a couple caching kthreads, and then come back
+			 * around and just wait for them.  This will be slower
+			 * because we will have 2 caching kthreads reading at
+			 * the same time when we could have just started one
+			 * and waited for it to get far enough to give us an
+			 * allocation, so go ahead and go to the wait caching
+			 * loop.
+			 */
+			loop = LOOP_CACHING_WAIT;
+			search_start = ideal_cache_offset;
+			ideal_cache_percent = 0;
+			goto ideal_cache;
+		} else if (loop == LOOP_FIND_IDEAL) {
+			/*
+			 * Didn't find a uncached bg, wait on anything we find
+			 * next.
+			 */
+			loop = LOOP_CACHING_WAIT;
+			goto search;
+		}
+
+		if (loop < LOOP_CACHING_WAIT) {
+			loop++;
+			goto search;
 		}
 
 		if (loop == LOOP_ALLOC_CHUNK) {
@@ -4437,7 +4499,8 @@ loop:
 			ret = do_chunk_alloc(trans, root, num_bytes +
 					     2 * 1024 * 1024, data, 1);
 			allowed_chunk_alloc = 0;
-		} else {
+			done_chunk_alloc = 1;
+		} else if (!done_chunk_alloc) {
 			space_info->force_alloc = 1;
 		}
 
-- 
1.6.2.5

