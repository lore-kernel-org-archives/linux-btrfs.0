From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: don't keep retrying a block group if we fail to
	allocate a cluster
Date: Mon, 17 Aug 2009 14:21:35 -0400
Message-ID: <20090817182135.GB2300@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The box can get locked up in the allocator if we happen upon a block group under
these conditions:

1) During a commit, so caching threads cannot make progress
2) Our block group currently is in the middle of being cached
3) Our block group currently has plenty of free space in it
4) Our block group is so fragmented that it ends up having no free space chunks
larger than min_bytes calculated by btrfs_find_space_cluster.

What happens is we try and do btrfs_find_space_cluster, which fails because it
is unable to find enough free space chunks that are large than min_bytes and are
close enough together.  Since the block group is not cached we do a
wait_block_group_cache_progress, which waits for the number of bytes we need,
except the block group already has _plenty_ of free space, its just severely
fragmented, so we loop and try again, ad infinitum.  This patch keeps us from
waiting on the block group to finish caching if we failed to find a free space
cluster before.  It also makes sure that we don't even try to find a free space
cluster if we are on our last loop in the allocator, since we will have tried
everything at this point at it is futile.

Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 fs/btrfs/extent-tree.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 99e1073..d1ac5a1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3726,6 +3726,7 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 	int last_ptr_loop = 0;
 	int loop = 0;
 	bool found_uncached_bg = false;
+	bool failed_cluster_refill = false;
 
 	WARN_ON(num_bytes < root->sectorsize);
 	btrfs_set_key_type(ins, BTRFS_EXTENT_ITEM_KEY);
@@ -3823,7 +3824,16 @@ have_block_group:
 		if (unlikely(block_group->ro))
 			goto loop;
 
-		if (last_ptr) {
+		/*
+		 * Ok we want to try and use the cluster allocator, so lets look
+		 * there, unless we are on LOOP_NO_EMPTY_SIZE, since we will
+		 * have tried the cluster allocator plenty of times at this
+		 * point and not have found anything, so we are likely way too
+		 * fragmented for the clustering stuff to find anything, so lets
+		 * just skip it and let the allocator find whatever block it can
+		 * find
+		 */
+		if (last_ptr && loop < LOOP_NO_EMPTY_SIZE) {
 			/*
 			 * the refill lock keeps out other
 			 * people trying to start a new cluster
@@ -3898,9 +3908,11 @@ refill_cluster:
 					spin_unlock(&last_ptr->refill_lock);
 					goto checks;
 				}
-			} else if (!cached && loop > LOOP_CACHING_NOWAIT) {
+			} else if (!cached && loop > LOOP_CACHING_NOWAIT
+				   && !failed_cluster_refill) {
 				spin_unlock(&last_ptr->refill_lock);
 
+				failed_cluster_refill = true;
 				wait_block_group_cache_progress(block_group,
 				       num_bytes + empty_cluster + empty_size);
 				goto have_block_group;
@@ -3912,13 +3924,9 @@ refill_cluster:
 			 * cluster.  Free the cluster we've been trying
 			 * to use, and go to the next block group
 			 */
-			if (loop < LOOP_NO_EMPTY_SIZE) {
-				btrfs_return_cluster_to_free_space(NULL,
-								   last_ptr);
-				spin_unlock(&last_ptr->refill_lock);
-				goto loop;
-			}
+			btrfs_return_cluster_to_free_space(NULL, last_ptr);
 			spin_unlock(&last_ptr->refill_lock);
+			goto loop;
 		}
 
 		offset = btrfs_find_space_for_alloc(block_group, search_start,
@@ -3977,6 +3985,7 @@ checks:
 		/* we are all good, lets return */
 		break;
 loop:
+		failed_cluster_refill = false;
 		btrfs_put_block_group(block_group);
 	}
 	up_read(&space_info->groups_sem);
-- 
1.5.4.3

