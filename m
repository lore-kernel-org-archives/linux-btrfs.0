From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] btrfs: prefer cached block groups when allocating
	UPDATED
Date: Wed, 22 Jul 2009 16:56:44 -0400
Message-ID: <20090722205644.GB7351@localhost.localdomain>
References: <20090722201909.GA6336@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090722201909.GA6336@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 22, 2009 at 04:19:09PM -0400, Josef Bacik wrote:
> This patch makes find_free_extent much more complicated by adding three extra
> loops to the allocator.  First, we look for nothing but cached block groups.  If
> the block group is not cached or in the middle of caching we skip it and move on
> to the next one.  The next loop is to go ahead and look through partially cached
> block groups, but if there is not enough free space in that block group then
> move on to the next one instead of waiting for the block group to finish
> caching.  The final straw is to look at every block group, and then if we didn't
> find space in it and its still caching, wait for it to finish caching, and look
> at the block group again.  Then if all of these steps fail, go back to our old
> faithfull loops of adding a new block group and changing empty_size to 0 and see
> if we can find stuff.
> 
> In order to keep us from tripping a caching kthread for _every_ block group we
> have on the disk the first go around, if we are in one of those "don't wait"
> loops, only kick off a new thread if there are less than 2 threads.  This will
> keep us from kicking off so many caching kthreads that everything else on the
> box comes to a screeching halt.
> 
> In my performance tests I fill up the disk with fs_mark and then unmount.  Then
> I do the following
> 
> mount /dev/sda1 /mnt/btrfs
> time touch /mnt/btrfs/file
> umount /dev/sda1
> mount /dev/sda1 /mnt/btrfs
> time dd /mnt/btrfs/file
> time umount /mnt/btrfs
> 
> The timing of the umount I think is the most interesting because it is the time
> we have to wait for all of the caching kthreads to stop before we can finish.
> The three times without this patch are
> 
> real    0m0.810s
> user    0m0.000s
> sys     0m0.000s
> 
> real    0m0.448s
> user    0m0.000s
> sys     0m0.004s
> 
> real    0m12.224s
> user    0m0.008s
> 
> And the three times with this patch are
> 
> real    0m0.308s
> user    0m0.000s
> sys     0m0.012s
> 
> real    0m0.030s
> user    0m0.000s
> sys     0m0.012s
> 
> real    0m5.705s
> user    0m0.000s
> sys     0m0.044s
> 
> So a significant advantage on the unmount front, we haven't started as many
> caching kthreads so it takes us less time to wait for them to finish, and we are
> much smarter about doing our allocations so the touch and dd take less time as
> well.  Thanks,
> 

Updated to use an enum instead of just magic numbers for the loop state machine.
Thanks,

Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 fs/btrfs/extent-tree.c |   78 +++++++++++++++++++++++++++++++++++++----------
 1 files changed, 61 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f0da696..925bf8e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3635,6 +3635,14 @@ wait_block_group_cache_progress(struct btrfs_block_group_cache *cache,
 	return 0;
 }
 
+enum btrfs_loop_type {
+	LOOP_CACHED_ONLY = 0,
+	LOOP_CACHING_NOWAIT = 1,
+	LOOP_CACHING_WAIT = 2,
+	LOOP_ALLOC_CHUNK = 3,
+	LOOP_NO_EMPTY_SIZE = 4,
+};
+
 /*
  * walks the btree of allocated extents and find a hole of a given size.
  * The key ins is changed to record the hole:
@@ -3660,6 +3668,7 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 	struct btrfs_space_info *space_info;
 	int last_ptr_loop = 0;
 	int loop = 0;
+	bool found_uncached_bg = false;
 
 	WARN_ON(num_bytes < root->sectorsize);
 	btrfs_set_key_type(ins, BTRFS_EXTENT_ITEM_KEY);
@@ -3691,15 +3700,18 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 	search_start = max(search_start, first_logical_byte(root, 0));
 	search_start = max(search_start, hint_byte);
 
-	if (!last_ptr) {
+	if (!last_ptr)
 		empty_cluster = 0;
-		loop = 1;
-	}
 
 	if (search_start == hint_byte) {
 		block_group = btrfs_lookup_block_group(root->fs_info,
 						       search_start);
-		if (block_group && block_group_bits(block_group, data)) {
+		/*
+		 * we don't want to use the block group if it doesn't match our
+		 * allocation bits, or if its not cached.
+		 */
+		if (block_group && block_group_bits(block_group, data) &&
+		    block_group_cache_done(block_group)) {
 			down_read(&space_info->groups_sem);
 			if (list_empty(&block_group->list) ||
 			    block_group->ro) {
@@ -3729,11 +3741,28 @@ search:
 
 have_block_group:
 		if (unlikely(block_group->cached == BTRFS_CACHE_NO)) {
-			ret = cache_block_group(block_group);
-			BUG_ON(ret);
+			/*
+			 * we want to start caching kthreads, but not too many
+			 * right off the bat so we don't overwhelm the system,
+			 * so only start them if there are less than 2 and we're
+			 * in the initial allocation phase.
+			 */
+			if (loop > LOOP_CACHING_NOWAIT ||
+			    atomic_read(&root->fs_info->async_caching_threads)
+			    < 2) {
+				ret = cache_block_group(block_group);
+				BUG_ON(ret);
+			}
 		}
 
 		cached = block_group_cache_done(block_group);
+		if (unlikely(!cached)) {
+			found_uncached_bg = true;
+
+			/* if we only want cached bgs, loop */
+			if (loop == LOOP_CACHED_ONLY)
+				goto loop;
+		}
 
 		if (unlikely(block_group->ro))
 			goto loop;
@@ -3813,7 +3842,7 @@ refill_cluster:
 					spin_unlock(&last_ptr->refill_lock);
 					goto checks;
 				}
-			} else if (!cached) {
+			} else if (!cached && loop > LOOP_CACHING_NOWAIT) {
 				spin_unlock(&last_ptr->refill_lock);
 
 				wait_block_group_cache_progress(block_group,
@@ -3827,7 +3856,7 @@ refill_cluster:
 			 * cluster.  Free the cluster we've been trying
 			 * to use, and go to the next block group
 			 */
-			if (loop < 2) {
+			if (loop < LOOP_NO_EMPTY_SIZE) {
 				btrfs_return_cluster_to_free_space(NULL,
 								   last_ptr);
 				spin_unlock(&last_ptr->refill_lock);
@@ -3838,9 +3867,11 @@ refill_cluster:
 
 		offset = btrfs_find_space_for_alloc(block_group, search_start,
 						    num_bytes, empty_size);
-		if (!offset && cached) {
+		if (!offset && (cached || (!cached &&
+					   loop == LOOP_CACHING_NOWAIT))) {
 			goto loop;
-		} else if (!offset) {
+		} else if (!offset && (!cached &&
+				       loop > LOOP_CACHING_NOWAIT)) {
 			wait_block_group_cache_progress(block_group,
 					num_bytes + empty_size);
 			goto have_block_group;
@@ -3892,13 +3923,26 @@ loop:
 	}
 	up_read(&space_info->groups_sem);
 
-	/* loop == 0, try to find a clustered alloc in every block group
-	 * loop == 1, try again after forcing a chunk allocation
-	 * loop == 2, set empty_size and empty_cluster to 0 and try again
+	/* LOOP_CACHED_ONLY, only search fully cached block groups
+	 * LOOP_CACHING_NOWAIT, search partially cached block groups, but
+	 *			dont wait foR them to finish caching
+	 * LOOP_CACHING_WAIT, search everything, and wait if our bg is caching
+	 * LOOP_ALLOC_CHUNK, force a chunk allocation and try again
+	 * LOOP_NO_EMPTY_SIZE, set empty_size and empty_cluster to 0 and try
+	 *			again
 	 */
-	if (!ins->objectid && loop < 3 &&
-	    (empty_size || empty_cluster || allowed_chunk_alloc)) {
-		if (loop >= 2) {
+	if (!ins->objectid && loop < LOOP_NO_EMPTY_SIZE &&
+	    (found_uncached_bg || empty_size || empty_cluster ||
+	     allowed_chunk_alloc)) {
+		if (found_uncached_bg) {
+			found_uncached_bg = false;
+			if (loop < LOOP_CACHING_WAIT) {
+				loop++;
+				goto search;
+			}
+		}
+
+		if (loop == LOOP_ALLOC_CHUNK) {
 			empty_size = 0;
 			empty_cluster = 0;
 		}
@@ -3911,7 +3955,7 @@ loop:
 			space_info->force_alloc = 1;
 		}
 
-		if (loop < 3) {
+		if (loop < LOOP_NO_EMPTY_SIZE) {
 			loop++;
 			goto search;
 		}
-- 
1.5.4.3

