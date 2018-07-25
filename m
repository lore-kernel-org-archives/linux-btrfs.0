Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56318 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728553AbeGYJXe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Jul 2018 05:23:34 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 09ABEAEE8
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jul 2018 08:12:58 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFC] btrfs: extent-tree: refactor find_free_extent()
Date: Wed, 25 Jul 2018 16:12:42 +0800
Message-Id: <20180725081242.8327-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

extent-tree.c::find_free_extent() could be one of the most
ill-structured function, it has at least 4 non-exit tags and jumps
between them.

To make it a little easier to understand, extract that big functions
into 4 parts:

1) find_free_extent()
   Do the block group iterations, still the main function.

2) find_free_extent_clustered()
   Do the clustered allocation and cluster refill if needed.

3) find_free_extent_unclustered()
   Do the unclustered allocation and free space cache update if needed.

4) find_free_extent_update_loop()
   Do the corner-case black magic handling, like allocating new chunk
   and update loop condition.

Also, for internal communication, created a new internal structure
find_free_extent_ctrl, to make the parameter list shorter for function
2~4.

Please note that this patch will try to avoid any functional/logical
modification during the refactor, so still a lot of bad practice like in
find_free_extent() we still use search/have_block_group/loop tags to
implement a custom loop.

But at least, this should provide the basis for later cleanup.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
I know such large patch is not a good practice, and there is choice to
split the patch into 4 patches (one patch for each helper function), but
that will make later rebase more error prone since new function will never
conflict with newer changes.

Thus I choose to use such large patch instead of small ones, to avoid
possible rebase errors.

Current the patch is lightly tested by fstests quick group, auto group
is still running, and it looks good so far.

Even after the basic refactor, the readability is still far from
perfect, but the change is already large enough, and it's not a good
idea to risk in such fundamental function.
---
 fs/btrfs/extent-tree.c | 700 +++++++++++++++++++++++------------------
 1 file changed, 398 insertions(+), 302 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index cb4f7d1cf8b0..0a6417bd7af6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7391,6 +7391,334 @@ btrfs_release_block_group(struct btrfs_block_group_cache *cache,
 	btrfs_put_block_group(cache);
 }
 
+struct find_free_extent_ctrl {
+	/* Basic allocation info (IN) */
+	u64 ram_bytes;
+	u64 num_bytes;
+	u64 empty_size;
+	u64 flags;
+	int delalloc;
+
+	/* Where to start the search in side the bg (IN) */
+	u64 search_start;
+
+	/* For clustered allocation */
+	u64 empty_cluster;
+
+	bool have_caching_bg;
+	bool orig_have_caching_bg;
+
+	/* RAID index, converted from flags */
+	int index;
+
+	/*
+	 * Current loop number, for details check find_free_extent_update_loop()
+	 */
+	int loop;
+
+	/* Max extent size found (OUT) */
+	u64 max_extent_size;
+
+	/*
+	 * Whether we're refilling a cluster, thus needs to re-search current
+	 * block group but don't try to refill the cluster again.
+	 */
+	bool retry_clustered;
+
+
+	/*
+	 * Whether we're updating free space cache, thus needs to re-search
+	 * current block group but don't try updating free space cache again.
+	 */
+	bool retry_unclustered;
+
+	/* If current block group is cached */
+	int cached;
+
+	/* Found result */
+	u64 found_offset;
+};
+
+/*
+ * Helper function for find_free_extent().
+ *
+ * Return -ENOENT to inform caller that we need fallback to unclustered mode.
+ * Return -EAGAIN to inform caller that we need to re-search this block group
+ * Return >0 to inform caller that we find nothing and need to continue searching
+ * Return 0 means we have found a location and set ctrl->found_offset.
+ */
+static int find_free_extent_clustered(struct btrfs_block_group_cache *bg,
+		struct btrfs_free_cluster *last_ptr,
+		struct find_free_extent_ctrl *ctrl,
+		struct btrfs_block_group_cache **cluster_bg_ret)
+{
+	struct btrfs_fs_info *fs_info = bg->fs_info;
+	struct btrfs_block_group_cache *cluster_bg;
+	u64 aligned_cluster;
+	u64 offset;
+	int ret;
+
+	cluster_bg = btrfs_lock_cluster(bg, last_ptr, ctrl->delalloc);
+	if (!cluster_bg)
+		goto refill_cluster;
+	if (cluster_bg != bg && (cluster_bg->ro ||
+	    !block_group_bits(cluster_bg, ctrl->flags)))
+		goto release_cluster;
+
+	offset = btrfs_alloc_from_cluster(cluster_bg, last_ptr,
+			ctrl->num_bytes, cluster_bg->key.objectid,
+			&ctrl->max_extent_size);
+	if (offset) {
+		/* we have a block, we're done */
+		spin_unlock(&last_ptr->refill_lock);
+		trace_btrfs_reserve_extent_cluster(cluster_bg,
+				ctrl->search_start, ctrl->num_bytes);
+		*cluster_bg_ret = cluster_bg;
+		ctrl->found_offset = offset;
+		return 0;
+	}
+	WARN_ON(last_ptr->block_group != cluster_bg);
+release_cluster:
+	/* If we are on LOOP_NO_EMPTY_SIZE, we can't set up a new clusters,
+	 * so lets just skip it and let the allocator find whatever block
+	 * it can find. If we reach this point, we will have tried the cluster
+	 * allocator plenty of times and not have found anything, so we are
+	 * likely way too fragmented for the clustering stuff to find anything.
+	 *
+	 * However, if the cluster is taken from the current block group,
+	 * release the cluster first, so that we stand a better chance of
+	 * succeeding in the unclustered allocation.
+	 */
+	if (ctrl->loop >= LOOP_NO_EMPTY_SIZE && cluster_bg != bg) {
+		spin_unlock(&last_ptr->refill_lock);
+		btrfs_release_block_group(cluster_bg, ctrl->delalloc);
+		return -ENOENT;
+	}
+
+	/* This cluster didn't work out, free it and start over */
+	btrfs_return_cluster_to_free_space(NULL, last_ptr);
+
+	if (cluster_bg != bg)
+		btrfs_release_block_group(cluster_bg, ctrl->delalloc);
+
+refill_cluster:
+	if (ctrl->loop >= LOOP_NO_EMPTY_SIZE) {
+		spin_unlock(&last_ptr->refill_lock);
+		return -ENOENT;
+	}
+
+	aligned_cluster = max_t(u64, ctrl->empty_cluster + ctrl->empty_size,
+				bg->full_stripe_len);
+	ret = btrfs_find_space_cluster(fs_info, bg, last_ptr,
+			ctrl->search_start, ctrl->num_bytes, aligned_cluster);
+	if (ret == 0) {
+		/* now pull our allocation out of this cluster */
+		offset = btrfs_alloc_from_cluster(bg, last_ptr, ctrl->num_bytes,
+				ctrl->search_start, &ctrl->max_extent_size);
+		if (offset) {
+			/* we found one, proceed */
+			spin_unlock(&last_ptr->refill_lock);
+			trace_btrfs_reserve_extent_cluster(bg,
+					ctrl->search_start, ctrl->num_bytes);
+			ctrl->found_offset = offset;
+			return 0;
+		}
+	} else if (!ctrl->cached && ctrl->loop > LOOP_CACHING_NOWAIT &&
+		   !ctrl->retry_clustered) {
+		spin_unlock(&last_ptr->refill_lock);
+
+		ctrl->retry_clustered = true;
+		wait_block_group_cache_progress(bg, ctrl->num_bytes +
+				ctrl->empty_cluster + ctrl->empty_size);
+		return -EAGAIN;
+	}
+	/*
+	 * at this point we either didn't find a cluster or we weren't able to
+	 * allocate a block from our cluster.
+	 * Free the cluster we've been trying to use, and go to the next block
+	 * group
+	 */
+	btrfs_return_cluster_to_free_space(NULL, last_ptr);
+	spin_unlock(&last_ptr->refill_lock);
+	return 1;
+}
+
+/*
+ * Return >0 to inform caller that we find nothing and need to continue searching
+ * Return -EAGAIN to inform caller that we need to re-search this block group
+ */
+static int find_free_extent_unclustered(struct btrfs_block_group_cache *bg,
+		struct btrfs_free_cluster *last_ptr,
+		struct find_free_extent_ctrl *ctrl)
+{
+	u64 offset;
+
+	/*
+	 * We are doing an unclustered alloc, set the fragmented flag so
+	 * we don't bother trying to setup a cluster again until we get
+	 * more space.
+	 */
+	if (unlikely(last_ptr)) {
+		spin_lock(&last_ptr->lock);
+		last_ptr->fragmented = 1;
+		spin_unlock(&last_ptr->lock);
+	}
+	if (ctrl->cached) {
+		struct btrfs_free_space_ctl *free_space_ctl;
+
+		free_space_ctl = bg->free_space_ctl;
+		spin_lock(&free_space_ctl->tree_lock);
+		if (free_space_ctl->free_space <
+		    ctrl->num_bytes + ctrl->empty_cluster + ctrl->empty_size) {
+			ctrl->max_extent_size = max_t(u64,
+					ctrl->max_extent_size,
+					free_space_ctl->free_space);
+			spin_unlock(&free_space_ctl->tree_lock);
+			return 1;
+		}
+		spin_unlock(&free_space_ctl->tree_lock);
+	}
+
+	offset = btrfs_find_space_for_alloc(bg, ctrl->search_start,
+			ctrl->num_bytes, ctrl->empty_size,
+			&ctrl->max_extent_size);
+
+	/*
+	 * If we didn't find a chunk, and we haven't failed on this
+	 * block group before, and this block group is in the middle of
+	 * caching and we are ok with waiting, then go ahead and wait
+	 * for progress to be made, and set failed_alloc to true.
+	 *
+	 * If failed_alloc is true then we've already waited on this
+	 * block group once and should move on to the next block group.
+	 */
+	if (!offset && !ctrl->retry_unclustered && !ctrl->cached &&
+	    ctrl->loop > LOOP_CACHING_NOWAIT) {
+		wait_block_group_cache_progress(bg, ctrl->num_bytes +
+						ctrl->empty_size);
+		ctrl->retry_unclustered = true;
+		return -EAGAIN;
+	} else if (!offset) {
+		return 1;
+	}
+	ctrl->found_offset = offset;
+	return 0;
+}
+
+/*
+ * Return >0 means caller needs to re-search for free extent
+ * Return 0 means we have the needed free extent.
+ * Return <0 means we failed to locate any free extent.
+ */
+static int find_free_extent_update_loop(struct btrfs_fs_info *fs_info,
+					struct btrfs_free_cluster *last_ptr,
+					struct btrfs_key *ins,
+					struct find_free_extent_ctrl *ctrl,
+					int full_search, bool use_cluster)
+{
+	struct btrfs_root *root = fs_info->extent_root;
+	int ret;
+
+	if ((ctrl->loop == LOOP_CACHING_NOWAIT) && ctrl->have_caching_bg
+		&& !ctrl->orig_have_caching_bg)
+		ctrl->orig_have_caching_bg = true;
+
+	if (!ins->objectid && ctrl->loop >= LOOP_CACHING_WAIT &&
+	     ctrl->have_caching_bg)
+		return 1;
+
+	if (!ins->objectid && ++(ctrl->index) < BTRFS_NR_RAID_TYPES)
+		return 1;
+
+	/*
+	 * LOOP_CACHING_NOWAIT, search partially cached block groups, kicking
+	 *			caching kthreads as we move along
+	 * LOOP_CACHING_WAIT, search everything, and wait if our bg is caching
+	 * LOOP_ALLOC_CHUNK, force a chunk allocation and try again
+	 * LOOP_NO_EMPTY_SIZE, set empty_size and empty_cluster to 0 and try
+	 *			again
+	 */
+	if (!ins->objectid && ctrl->loop < LOOP_NO_EMPTY_SIZE) {
+		ctrl->index = 0;
+		if (ctrl->loop == LOOP_CACHING_NOWAIT) {
+			/*
+			 * We want to skip the LOOP_CACHING_WAIT step if we
+			 * don't have any uncached bgs and we've already done a
+			 * full search through.
+			 */
+			if (ctrl->orig_have_caching_bg || !full_search)
+				ctrl->loop = LOOP_CACHING_WAIT;
+			else
+				ctrl->loop = LOOP_ALLOC_CHUNK;
+		} else {
+			ctrl->loop++;
+		}
+
+		if (ctrl->loop == LOOP_ALLOC_CHUNK) {
+			struct btrfs_trans_handle *trans;
+			int exist = 0;
+
+			trans = current->journal_info;
+			if (trans)
+				exist = 1;
+			else
+				trans = btrfs_join_transaction(root);
+
+			if (IS_ERR(trans)) {
+				ret = PTR_ERR(trans);
+				return ret;
+			}
+
+			ret = do_chunk_alloc(trans, fs_info, ctrl->flags,
+					     CHUNK_ALLOC_FORCE);
+
+			/*
+			 * If we can't allocate a new chunk we've already looped
+			 * through at least once, move on to the NO_EMPTY_SIZE
+			 * case.
+			 */
+			if (ret == -ENOSPC)
+				ctrl->loop = LOOP_NO_EMPTY_SIZE;
+
+			/*
+			 * Do not bail out on ENOSPC since we
+			 * can do more things.
+			 */
+			if (ret < 0 && ret != -ENOSPC)
+				btrfs_abort_transaction(trans, ret);
+			else
+				ret = 0;
+			if (!exist)
+				btrfs_end_transaction(trans);
+			if (ret)
+				return ret;
+		}
+
+		if (ctrl->loop == LOOP_NO_EMPTY_SIZE) {
+			/*
+			 * Don't loop again if we already have no empty_size and
+			 * no empty_cluster.
+			 */
+			if (ctrl->empty_size == 0 &&
+			    ctrl->empty_cluster == 0)
+				return -ENOSPC;
+			ctrl->empty_size = 0;
+			ctrl->empty_cluster = 0;
+		}
+		return 1;
+	} else if (!ins->objectid) {
+		ret = -ENOSPC;
+	} else if (ins->objectid) {
+		if (!use_cluster && last_ptr) {
+			spin_lock(&last_ptr->lock);
+			last_ptr->window_start = ins->objectid;
+			spin_unlock(&last_ptr->lock);
+		}
+		ret = 0;
+	}
+	return ret;
+}
+
 /*
  * walks the btree of allocated extents and find a hole of a given size.
  * The key ins is changed to record the hole:
@@ -7402,33 +7730,39 @@ btrfs_release_block_group(struct btrfs_block_group_cache *cache,
  * If there is no suitable free space, we will record the max size of
  * the free space extent currently.
  */
-static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
+static int find_free_extent(struct btrfs_fs_info *fs_info,
 				u64 ram_bytes, u64 num_bytes, u64 empty_size,
 				u64 hint_byte, struct btrfs_key *ins,
 				u64 flags, int delalloc)
 {
-	int ret = 0;
-	struct btrfs_root *root = fs_info->extent_root;
+	struct find_free_extent_ctrl ctrl = {0};
 	struct btrfs_free_cluster *last_ptr = NULL;
 	struct btrfs_block_group_cache *block_group = NULL;
-	u64 search_start = 0;
-	u64 max_extent_size = 0;
-	u64 empty_cluster = 0;
 	struct btrfs_space_info *space_info;
-	int loop = 0;
-	int index = btrfs_bg_flags_to_raid_index(flags);
-	bool failed_cluster_refill = false;
-	bool failed_alloc = false;
 	bool use_cluster = true;
-	bool have_caching_bg = false;
-	bool orig_have_caching_bg = false;
 	bool full_search = false;
+	int ret;
+
+	if (!IS_ALIGNED(num_bytes, fs_info->sectorsize)) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+	ctrl.ram_bytes = ram_bytes;
+	ctrl.num_bytes = num_bytes;
+	ctrl.empty_size = empty_size;
+	ctrl.flags = flags;
+	ctrl.search_start = 0;
+	ctrl.retry_unclustered = false;
+	ctrl.retry_clustered = false;
+	ctrl.delalloc = delalloc;
+	ctrl.index = btrfs_bg_flags_to_raid_index(flags);
+	ctrl.have_caching_bg = false;
+	ctrl.orig_have_caching_bg = false;
+	ctrl.found_offset = 0;
 
-	WARN_ON(num_bytes < fs_info->sectorsize);
 	ins->type = BTRFS_EXTENT_ITEM_KEY;
 	ins->objectid = 0;
 	ins->offset = 0;
-
 	trace_find_free_extent(fs_info, num_bytes, empty_size, flags);
 
 	space_info = __find_space_info(fs_info, flags);
@@ -7460,7 +7794,7 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 		spin_unlock(&space_info->lock);
 	}
 
-	last_ptr = fetch_cluster_info(fs_info, space_info, &empty_cluster);
+	last_ptr = fetch_cluster_info(fs_info, space_info, &ctrl.empty_cluster);
 	if (last_ptr) {
 		spin_lock(&last_ptr->lock);
 		if (last_ptr->block_group)
@@ -7477,10 +7811,12 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 		spin_unlock(&last_ptr->lock);
 	}
 
-	search_start = max(search_start, first_logical_byte(fs_info, 0));
-	search_start = max(search_start, hint_byte);
-	if (search_start == hint_byte) {
-		block_group = btrfs_lookup_block_group(fs_info, search_start);
+	ctrl.search_start = max(ctrl.search_start,
+				first_logical_byte(fs_info, 0));
+	ctrl.search_start = max(ctrl.search_start, hint_byte);
+	if (ctrl.search_start == hint_byte) {
+		block_group = btrfs_lookup_block_group(fs_info,
+						       ctrl.search_start);
 		/*
 		 * we don't want to use the block group if it doesn't match our
 		 * allocation bits, or if its not cached.
@@ -7502,7 +7838,7 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 				btrfs_put_block_group(block_group);
 				up_read(&space_info->groups_sem);
 			} else {
-				index = btrfs_bg_flags_to_raid_index(
+				ctrl.index = btrfs_bg_flags_to_raid_index(
 						block_group->flags);
 				btrfs_lock_block_group(block_group, delalloc);
 				goto have_block_group;
@@ -7512,21 +7848,19 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 		}
 	}
 search:
-	have_caching_bg = false;
-	if (index == 0 || index == btrfs_bg_flags_to_raid_index(flags))
+	ctrl.have_caching_bg = false;
+	if (ctrl.index == btrfs_bg_flags_to_raid_index(flags) ||
+	    ctrl.index == 0)
 		full_search = true;
 	down_read(&space_info->groups_sem);
-	list_for_each_entry(block_group, &space_info->block_groups[index],
+	list_for_each_entry(block_group, &space_info->block_groups[ctrl.index],
 			    list) {
-		u64 offset;
-		int cached;
-
 		/* If the block group is read-only, we can skip it entirely. */
 		if (unlikely(block_group->ro))
 			continue;
 
 		btrfs_grab_block_group(block_group, delalloc);
-		search_start = block_group->key.objectid;
+		ctrl.search_start = block_group->key.objectid;
 
 		/*
 		 * this can happen if we end up cycling through all the
@@ -7550,9 +7884,9 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 		}
 
 have_block_group:
-		cached = block_group_cache_done(block_group);
-		if (unlikely(!cached)) {
-			have_caching_bg = true;
+		ctrl.cached = block_group_cache_done(block_group);
+		if (unlikely(!ctrl.cached)) {
+			ctrl.have_caching_bg = true;
 			ret = cache_block_group(block_group, 0);
 			BUG_ON(ret < 0);
 			ret = 0;
@@ -7566,321 +7900,83 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 		 * lets look there
 		 */
 		if (last_ptr && use_cluster) {
-			struct btrfs_block_group_cache *used_block_group;
-			unsigned long aligned_cluster;
-			/*
-			 * the refill lock keeps out other
-			 * people trying to start a new cluster
-			 */
-			used_block_group = btrfs_lock_cluster(block_group,
-							      last_ptr,
-							      delalloc);
-			if (!used_block_group)
-				goto refill_cluster;
-
-			if (used_block_group != block_group &&
-			    (used_block_group->ro ||
-			     !block_group_bits(used_block_group, flags)))
-				goto release_cluster;
-
-			offset = btrfs_alloc_from_cluster(used_block_group,
-						last_ptr,
-						num_bytes,
-						used_block_group->key.objectid,
-						&max_extent_size);
-			if (offset) {
-				/* we have a block, we're done */
-				spin_unlock(&last_ptr->refill_lock);
-				trace_btrfs_reserve_extent_cluster(
-						used_block_group,
-						search_start, num_bytes);
-				if (used_block_group != block_group) {
+			struct btrfs_block_group_cache *cluster_bg = NULL;
+
+			ret = find_free_extent_clustered(block_group, last_ptr,
+							 &ctrl, &cluster_bg);
+			if (ret == 0) {
+				if (cluster_bg && cluster_bg != block_group) {
 					btrfs_release_block_group(block_group,
 								  delalloc);
-					block_group = used_block_group;
+					block_group = cluster_bg;
 				}
 				goto checks;
-			}
-
-			WARN_ON(last_ptr->block_group != used_block_group);
-release_cluster:
-			/* If we are on LOOP_NO_EMPTY_SIZE, we can't
-			 * set up a new clusters, so lets just skip it
-			 * and let the allocator find whatever block
-			 * it can find.  If we reach this point, we
-			 * will have tried the cluster allocator
-			 * plenty of times and not have found
-			 * anything, so we are likely way too
-			 * fragmented for the clustering stuff to find
-			 * anything.
-			 *
-			 * However, if the cluster is taken from the
-			 * current block group, release the cluster
-			 * first, so that we stand a better chance of
-			 * succeeding in the unclustered
-			 * allocation.  */
-			if (loop >= LOOP_NO_EMPTY_SIZE &&
-			    used_block_group != block_group) {
-				spin_unlock(&last_ptr->refill_lock);
-				btrfs_release_block_group(used_block_group,
-							  delalloc);
-				goto unclustered_alloc;
-			}
-
-			/*
-			 * this cluster didn't work out, free it and
-			 * start over
-			 */
-			btrfs_return_cluster_to_free_space(NULL, last_ptr);
-
-			if (used_block_group != block_group)
-				btrfs_release_block_group(used_block_group,
-							  delalloc);
-refill_cluster:
-			if (loop >= LOOP_NO_EMPTY_SIZE) {
-				spin_unlock(&last_ptr->refill_lock);
-				goto unclustered_alloc;
-			}
-
-			aligned_cluster = max_t(unsigned long,
-						empty_cluster + empty_size,
-					      block_group->full_stripe_len);
-
-			/* allocate a cluster in this block group */
-			ret = btrfs_find_space_cluster(fs_info, block_group,
-						       last_ptr, search_start,
-						       num_bytes,
-						       aligned_cluster);
-			if (ret == 0) {
-				/*
-				 * now pull our allocation out of this
-				 * cluster
-				 */
-				offset = btrfs_alloc_from_cluster(block_group,
-							last_ptr,
-							num_bytes,
-							search_start,
-							&max_extent_size);
-				if (offset) {
-					/* we found one, proceed */
-					spin_unlock(&last_ptr->refill_lock);
-					trace_btrfs_reserve_extent_cluster(
-						block_group, search_start,
-						num_bytes);
-					goto checks;
-				}
-			} else if (!cached && loop > LOOP_CACHING_NOWAIT
-				   && !failed_cluster_refill) {
-				spin_unlock(&last_ptr->refill_lock);
-
-				failed_cluster_refill = true;
-				wait_block_group_cache_progress(block_group,
-				       num_bytes + empty_cluster + empty_size);
+			} else if (ret == -EAGAIN) {
 				goto have_block_group;
-			}
-
-			/*
-			 * at this point we either didn't find a cluster
-			 * or we weren't able to allocate a block from our
-			 * cluster.  Free the cluster we've been trying
-			 * to use, and go to the next block group
-			 */
-			btrfs_return_cluster_to_free_space(NULL, last_ptr);
-			spin_unlock(&last_ptr->refill_lock);
-			goto loop;
-		}
-
-unclustered_alloc:
-		/*
-		 * We are doing an unclustered alloc, set the fragmented flag so
-		 * we don't bother trying to setup a cluster again until we get
-		 * more space.
-		 */
-		if (unlikely(last_ptr)) {
-			spin_lock(&last_ptr->lock);
-			last_ptr->fragmented = 1;
-			spin_unlock(&last_ptr->lock);
-		}
-		if (cached) {
-			struct btrfs_free_space_ctl *ctl =
-				block_group->free_space_ctl;
-
-			spin_lock(&ctl->tree_lock);
-			if (ctl->free_space <
-			    num_bytes + empty_cluster + empty_size) {
-				if (ctl->free_space > max_extent_size)
-					max_extent_size = ctl->free_space;
-				spin_unlock(&ctl->tree_lock);
+			} else if (ret > 0) {
 				goto loop;
 			}
-			spin_unlock(&ctl->tree_lock);
+			/* ret == -ENOENT case falls through */
 		}
 
-		offset = btrfs_find_space_for_alloc(block_group, search_start,
-						    num_bytes, empty_size,
-						    &max_extent_size);
-		/*
-		 * If we didn't find a chunk, and we haven't failed on this
-		 * block group before, and this block group is in the middle of
-		 * caching and we are ok with waiting, then go ahead and wait
-		 * for progress to be made, and set failed_alloc to true.
-		 *
-		 * If failed_alloc is true then we've already waited on this
-		 * block group once and should move on to the next block group.
-		 */
-		if (!offset && !failed_alloc && !cached &&
-		    loop > LOOP_CACHING_NOWAIT) {
-			wait_block_group_cache_progress(block_group,
-						num_bytes + empty_size);
-			failed_alloc = true;
+		ret = find_free_extent_unclustered(block_group, last_ptr, &ctrl);
+		if (ret == -EAGAIN) {
 			goto have_block_group;
-		} else if (!offset) {
+		} else if (ret > 0) {
 			goto loop;
 		}
+		/*
+		 *  ret == 0 cause falls through
+		 */
 checks:
-		search_start = round_up(offset, fs_info->stripesize);
+		ctrl.search_start = round_up(ctrl.found_offset, fs_info->stripesize);
 
 		/* move on to the next group */
-		if (search_start + num_bytes >
+		if (ctrl.search_start + ctrl.num_bytes >
 		    block_group->key.objectid + block_group->key.offset) {
-			btrfs_add_free_space(block_group, offset, num_bytes);
+			btrfs_add_free_space(block_group, ctrl.found_offset, num_bytes);
 			goto loop;
 		}
 
-		if (offset < search_start)
-			btrfs_add_free_space(block_group, offset,
-					     search_start - offset);
+		if (ctrl.found_offset< ctrl.search_start)
+			btrfs_add_free_space(block_group, ctrl.found_offset,
+					     ctrl.search_start - ctrl.found_offset);
 
 		ret = btrfs_add_reserved_bytes(block_group, ram_bytes,
 				num_bytes, delalloc);
 		if (ret == -EAGAIN) {
-			btrfs_add_free_space(block_group, offset, num_bytes);
+			btrfs_add_free_space(block_group, ctrl.found_offset, num_bytes);
 			goto loop;
 		}
 		btrfs_inc_block_group_reservations(block_group);
 
 		/* we are all good, lets return */
-		ins->objectid = search_start;
+		ins->objectid = ctrl.search_start;
 		ins->offset = num_bytes;
 
-		trace_btrfs_reserve_extent(block_group, search_start, num_bytes);
+		trace_btrfs_reserve_extent(block_group, ctrl.search_start,
+					   num_bytes);
 		btrfs_release_block_group(block_group, delalloc);
 		break;
 loop:
-		failed_cluster_refill = false;
-		failed_alloc = false;
+		ctrl.retry_clustered = false;
+		ctrl.retry_unclustered = false;
 		BUG_ON(btrfs_bg_flags_to_raid_index(block_group->flags) !=
-		       index);
+		       ctrl.index);
 		btrfs_release_block_group(block_group, delalloc);
 		cond_resched();
 	}
 	up_read(&space_info->groups_sem);
 
-	if ((loop == LOOP_CACHING_NOWAIT) && have_caching_bg
-		&& !orig_have_caching_bg)
-		orig_have_caching_bg = true;
-
-	if (!ins->objectid && loop >= LOOP_CACHING_WAIT && have_caching_bg)
-		goto search;
-
-	if (!ins->objectid && ++index < BTRFS_NR_RAID_TYPES)
-		goto search;
-
-	/*
-	 * LOOP_CACHING_NOWAIT, search partially cached block groups, kicking
-	 *			caching kthreads as we move along
-	 * LOOP_CACHING_WAIT, search everything, and wait if our bg is caching
-	 * LOOP_ALLOC_CHUNK, force a chunk allocation and try again
-	 * LOOP_NO_EMPTY_SIZE, set empty_size and empty_cluster to 0 and try
-	 *			again
-	 */
-	if (!ins->objectid && loop < LOOP_NO_EMPTY_SIZE) {
-		index = 0;
-		if (loop == LOOP_CACHING_NOWAIT) {
-			/*
-			 * We want to skip the LOOP_CACHING_WAIT step if we
-			 * don't have any uncached bgs and we've already done a
-			 * full search through.
-			 */
-			if (orig_have_caching_bg || !full_search)
-				loop = LOOP_CACHING_WAIT;
-			else
-				loop = LOOP_ALLOC_CHUNK;
-		} else {
-			loop++;
-		}
-
-		if (loop == LOOP_ALLOC_CHUNK) {
-			struct btrfs_trans_handle *trans;
-			int exist = 0;
-
-			trans = current->journal_info;
-			if (trans)
-				exist = 1;
-			else
-				trans = btrfs_join_transaction(root);
-
-			if (IS_ERR(trans)) {
-				ret = PTR_ERR(trans);
-				goto out;
-			}
-
-			ret = do_chunk_alloc(trans, fs_info, flags,
-					     CHUNK_ALLOC_FORCE);
-
-			/*
-			 * If we can't allocate a new chunk we've already looped
-			 * through at least once, move on to the NO_EMPTY_SIZE
-			 * case.
-			 */
-			if (ret == -ENOSPC)
-				loop = LOOP_NO_EMPTY_SIZE;
-
-			/*
-			 * Do not bail out on ENOSPC since we
-			 * can do more things.
-			 */
-			if (ret < 0 && ret != -ENOSPC)
-				btrfs_abort_transaction(trans, ret);
-			else
-				ret = 0;
-			if (!exist)
-				btrfs_end_transaction(trans);
-			if (ret)
-				goto out;
-		}
-
-		if (loop == LOOP_NO_EMPTY_SIZE) {
-			/*
-			 * Don't loop again if we already have no empty_size and
-			 * no empty_cluster.
-			 */
-			if (empty_size == 0 &&
-			    empty_cluster == 0) {
-				ret = -ENOSPC;
-				goto out;
-			}
-			empty_size = 0;
-			empty_cluster = 0;
-		}
-
+	ret = find_free_extent_update_loop(fs_info, last_ptr, ins, &ctrl,
+					   full_search, use_cluster);
+	if (ret > 0)
 		goto search;
-	} else if (!ins->objectid) {
-		ret = -ENOSPC;
-	} else if (ins->objectid) {
-		if (!use_cluster && last_ptr) {
-			spin_lock(&last_ptr->lock);
-			last_ptr->window_start = ins->objectid;
-			spin_unlock(&last_ptr->lock);
-		}
-		ret = 0;
-	}
-out:
 	if (ret == -ENOSPC) {
 		spin_lock(&space_info->lock);
-		space_info->max_extent_size = max_extent_size;
+		space_info->max_extent_size = ctrl.max_extent_size;
 		spin_unlock(&space_info->lock);
-		ins->offset = max_extent_size;
+		ins->offset = ctrl.max_extent_size;
 	}
 	return ret;
 }
-- 
2.18.0

