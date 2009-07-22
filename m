From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] btrfs: prefer cached block groups when allocating
Date: Wed, 22 Jul 2009 16:19:09 -0400
Message-ID: <20090722201909.GA6336@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch makes find_free_extent much more complicated by adding three extra
loops to the allocator.  First, we look for nothing but cached block groups.  If
the block group is not cached or in the middle of caching we skip it and move on
to the next one.  The next loop is to go ahead and look through partially cached
block groups, but if there is not enough free space in that block group then
move on to the next one instead of waiting for the block group to finish
caching.  The final straw is to look at every block group, and then if we didn't
find space in it and its still caching, wait for it to finish caching, and look
at the block group again.  Then if all of these steps fail, go back to our old
faithfull loops of adding a new block group and changing empty_size to 0 and see
if we can find stuff.

In order to keep us from tripping a caching kthread for _every_ block group we
have on the disk the first go around, if we are in one of those "don't wait"
loops, only kick off a new thread if there are less than 2 threads.  This will
keep us from kicking off so many caching kthreads that everything else on the
box comes to a screeching halt.

In my performance tests I fill up the disk with fs_mark and then unmount.  Then
I do the following

mount /dev/sda1 /mnt/btrfs
time touch /mnt/btrfs/file
umount /dev/sda1
mount /dev/sda1 /mnt/btrfs
time dd /mnt/btrfs/file
time umount /mnt/btrfs

The timing of the umount I think is the most interesting because it is the time
we have to wait for all of the caching kthreads to stop before we can finish.
The three times without this patch are

real    0m0.810s
user    0m0.000s
sys     0m0.000s

real    0m0.448s
user    0m0.000s
sys     0m0.004s

real    0m12.224s
user    0m0.008s

And the three times with this patch are

real    0m0.308s
user    0m0.000s
sys     0m0.012s

real    0m0.030s
user    0m0.000s
sys     0m0.012s

real    0m5.705s
user    0m0.000s
sys     0m0.044s

So a significant advantage on the unmount front, we haven't started as many
caching kthreads so it takes us less time to wait for them to finish, and we are
much smarter about doing our allocations so the touch and dd take less time as
well.  Thanks,

Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 fs/btrfs/extent-tree.c |   65 +++++++++++++++++++++++++++++++++++++----------
 1 files changed, 51 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f0da696..8fd3669 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3660,6 +3660,7 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 	struct btrfs_space_info *space_info;
 	int last_ptr_loop = 0;
 	int loop = 0;
+	bool found_uncached_bg = false;
 
 	WARN_ON(num_bytes < root->sectorsize);
 	btrfs_set_key_type(ins, BTRFS_EXTENT_ITEM_KEY);
@@ -3699,7 +3700,12 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
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
@@ -3729,11 +3735,30 @@ search:
 
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
+			if (loop > 1 ||
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
+			/*
+			 * if loop == 0 we only want cached bgs, so keep going
+			 */
+			if (loop == 0)
+				goto loop;
+		}
 
 		if (unlikely(block_group->ro))
 			goto loop;
@@ -3813,7 +3838,7 @@ refill_cluster:
 					spin_unlock(&last_ptr->refill_lock);
 					goto checks;
 				}
-			} else if (!cached) {
+			} else if (!cached && loop > 1) {
 				spin_unlock(&last_ptr->refill_lock);
 
 				wait_block_group_cache_progress(block_group,
@@ -3827,7 +3852,7 @@ refill_cluster:
 			 * cluster.  Free the cluster we've been trying
 			 * to use, and go to the next block group
 			 */
-			if (loop < 2) {
+			if (loop < 4) {
 				btrfs_return_cluster_to_free_space(NULL,
 								   last_ptr);
 				spin_unlock(&last_ptr->refill_lock);
@@ -3838,9 +3863,9 @@ refill_cluster:
 
 		offset = btrfs_find_space_for_alloc(block_group, search_start,
 						    num_bytes, empty_size);
-		if (!offset && cached) {
+		if (!offset && (cached || (!cached && loop == 1))) {
 			goto loop;
-		} else if (!offset) {
+		} else if (!offset && (!cached && loop > 1)) {
 			wait_block_group_cache_progress(block_group,
 					num_bytes + empty_size);
 			goto have_block_group;
@@ -3892,13 +3917,25 @@ loop:
 	}
 	up_read(&space_info->groups_sem);
 
-	/* loop == 0, try to find a clustered alloc in every block group
-	 * loop == 1, try again after forcing a chunk allocation
-	 * loop == 2, set empty_size and empty_cluster to 0 and try again
+	/* loop == 0, only search fully cached block groups
+	 * loop == 1, search partially cached block groups, but dont wait for
+	 *	      them to finish caching
+	 * loop == 2, search everything, and wait if our bg is caching
+	 * loop == 3, force a chunk allocation and try again
+	 * loop == 4, set empty_size and empty_cluster to 0 and try again
 	 */
-	if (!ins->objectid && loop < 3 &&
-	    (empty_size || empty_cluster || allowed_chunk_alloc)) {
-		if (loop >= 2) {
+	if (!ins->objectid && loop < 4 &&
+	    (found_uncached_bg || empty_size || empty_cluster ||
+	     allowed_chunk_alloc)) {
+		if (found_uncached_bg) {
+			found_uncached_bg = false;
+			if (loop < 2) {
+				loop++;
+				goto search;
+			}
+		}
+
+		if (loop == 3) {
 			empty_size = 0;
 			empty_cluster = 0;
 		}
@@ -3911,7 +3948,7 @@ loop:
 			space_info->force_alloc = 1;
 		}
 
-		if (loop < 3) {
+		if (loop < 4) {
 			loop++;
 			goto search;
 		}
-- 
1.5.4.3

