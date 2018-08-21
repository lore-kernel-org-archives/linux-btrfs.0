Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55892 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726609AbeHUME7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 08:04:59 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E7E6DB065
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Aug 2018 08:44:37 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/4] btrfs: Refactor clustered extent allocation into find_free_extent_clustered()
Date: Tue, 21 Aug 2018 16:44:24 +0800
Message-Id: <20180821084426.7858-3-wqu@suse.com>
In-Reply-To: <20180821084426.7858-1-wqu@suse.com>
References: <20180821084426.7858-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have two main methods to find free extents inside a block group:
1) clustered allocation
2) unclustered allocation

This patch will extract the clustered allocation into
find_free_extent_clustered() to make it a little easier to read.

Instead of jumping between different labels in find_free_extent(), the
helper function will use return value to indicate different behavior.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent-tree.c | 239 ++++++++++++++++++++---------------------
 1 file changed, 117 insertions(+), 122 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 7bc0bdda99d4..a603900e0eb8 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7441,6 +7441,111 @@ struct find_free_extent_ctrl {
 	u64 found_offset;
 };
 
+
+/*
+ * Helper function for find_free_extent().
+ *
+ * Return -ENOENT to inform caller that we need fallback to unclustered mode.
+ * Return -EAGAIN to inform caller that we need to re-search this block group
+ * Return >0 to inform caller that we find nothing
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
+	/* If we are on LOOP_NO_EMPTY_SIZE, we can't set up a new clusters, so
+	 * lets just skip it and let the allocator find whatever block it can
+	 * find. If we reach this point, we will have tried the cluster
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
+	 * group.
+	 */
+	btrfs_return_cluster_to_free_space(NULL, last_ptr);
+	spin_unlock(&last_ptr->refill_lock);
+	return 1;
+}
+
 /*
  * walks the btree of allocated extents and find a hole of a given size.
  * The key ins is changed to record the hole:
@@ -7622,136 +7727,26 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
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
-			     !block_group_bits(used_block_group, ctrl.flags)))
-				goto release_cluster;
-
-			ctrl.found_offset = btrfs_alloc_from_cluster(
-						used_block_group,
-						last_ptr,
-						num_bytes,
-						used_block_group->key.objectid,
-						&ctrl.max_extent_size);
-			if (ctrl.found_offset) {
-				/* we have a block, we're done */
-				spin_unlock(&last_ptr->refill_lock);
-				trace_btrfs_reserve_extent_cluster(
-						used_block_group,
-						ctrl.search_start, num_bytes);
-				if (used_block_group != block_group) {
-					btrfs_release_block_group(block_group,
-								  delalloc);
-					block_group = used_block_group;
-				}
-				goto checks;
-			}
+			struct btrfs_block_group_cache *cluster_bg = NULL;
 
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
-			if (ctrl.loop >= LOOP_NO_EMPTY_SIZE &&
-			    used_block_group != block_group) {
-				spin_unlock(&last_ptr->refill_lock);
-				btrfs_release_block_group(used_block_group,
-							  delalloc);
-				goto unclustered_alloc;
-			}
+			ret = find_free_extent_clustered(block_group, last_ptr,
+							 &ctrl, &cluster_bg);
 
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
-			if (ctrl.loop >= LOOP_NO_EMPTY_SIZE) {
-				spin_unlock(&last_ptr->refill_lock);
-				goto unclustered_alloc;
-			}
-
-			aligned_cluster = max_t(unsigned long,
-						ctrl.empty_cluster + empty_size,
-					      block_group->full_stripe_len);
-
-			/* allocate a cluster in this block group */
-			ret = btrfs_find_space_cluster(fs_info, block_group,
-						       last_ptr,
-						       ctrl.search_start,
-						       num_bytes,
-						       aligned_cluster);
 			if (ret == 0) {
-				/*
-				 * now pull our allocation out of this
-				 * cluster
-				 */
-				ctrl.found_offset = btrfs_alloc_from_cluster(
-							block_group,
-							last_ptr,
-							num_bytes,
-							ctrl.search_start,
-							&ctrl.max_extent_size);
-				if (ctrl.found_offset) {
-					/* we found one, proceed */
-					spin_unlock(&last_ptr->refill_lock);
-					trace_btrfs_reserve_extent_cluster(
-						block_group, ctrl.search_start,
-						num_bytes);
-					goto checks;
+				if (cluster_bg && cluster_bg != block_group) {
+					btrfs_release_block_group(block_group,
+								  delalloc);
+					block_group = cluster_bg;
 				}
-			} else if (!ctrl.cached && ctrl.loop >
-				   LOOP_CACHING_NOWAIT
-				   && !ctrl.retry_clustered) {
-				spin_unlock(&last_ptr->refill_lock);
-
-				ctrl.retry_clustered = true;
-				wait_block_group_cache_progress(block_group,
-				       num_bytes + ctrl.empty_cluster +
-				       empty_size);
+				goto checks;
+			} else if (ret == -EAGAIN) {
 				goto have_block_group;
+			} else if (ret > 0) {
+				goto loop;
 			}
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
+			/* ret == -ENOENT case falss through */
 		}
 
-unclustered_alloc:
 		/*
 		 * We are doing an unclustered alloc, set the fragmented flag so
 		 * we don't bother trying to setup a cluster again until we get
-- 
2.18.0
