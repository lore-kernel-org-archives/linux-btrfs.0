Return-Path: <SRS0=Mp4+=NN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B3AAC6786F
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 01:40:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9BC62081B
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 01:40:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E9BC62081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbeKBKpX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 2 Nov 2018 06:45:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:44546 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725961AbeKBKpX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Nov 2018 06:45:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C3DA6AD5D;
        Fri,  2 Nov 2018 01:40:00 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     dsterba@suse.cz, josef@toxicpanda.com
Subject: [PATCH v5 2/4] btrfs: Refactor clustered extent allocation into find_free_extent_clustered()
Date:   Fri,  2 Nov 2018 09:39:48 +0800
Message-Id: <20181102013950.30293-3-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181102013950.30293-1-wqu@suse.com>
References: <20181102013950.30293-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We have two main methods to find free extents inside a block group:
1) clustered allocation
2) unclustered allocation

This patch will extract the clustered allocation into
find_free_extent_clustered() to make it a little easier to read.

Instead of jumping between different labels in find_free_extent(), the
helper function will use return value to indicate different behavior.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 245 ++++++++++++++++++++---------------------
 1 file changed, 122 insertions(+), 123 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 7b25e039fe80..7b0c93cf280e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7290,6 +7290,116 @@ struct find_free_extent_ctl {
 	u64 found_offset;
 };
 
+
+/*
+ * Helper function for find_free_extent().
+ *
+ * Return -ENOENT to inform caller that we need fallback to unclustered mode.
+ * Return -EAGAIN to inform caller that we need to re-search this block group
+ * Return >0 to inform caller that we find nothing
+ * Return 0 means we have found a location and set ffe_ctl->found_offset.
+ */
+static int find_free_extent_clustered(struct btrfs_block_group_cache *bg,
+		struct btrfs_free_cluster *last_ptr,
+		struct find_free_extent_ctl *ffe_ctl,
+		struct btrfs_block_group_cache **cluster_bg_ret)
+{
+	struct btrfs_fs_info *fs_info = bg->fs_info;
+	struct btrfs_block_group_cache *cluster_bg;
+	u64 aligned_cluster;
+	u64 offset;
+	int ret;
+
+	cluster_bg = btrfs_lock_cluster(bg, last_ptr, ffe_ctl->delalloc);
+	if (!cluster_bg)
+		goto refill_cluster;
+	if (cluster_bg != bg && (cluster_bg->ro ||
+	    !block_group_bits(cluster_bg, ffe_ctl->flags)))
+		goto release_cluster;
+
+	offset = btrfs_alloc_from_cluster(cluster_bg, last_ptr,
+			ffe_ctl->num_bytes, cluster_bg->key.objectid,
+			&ffe_ctl->max_extent_size);
+	if (offset) {
+		/* we have a block, we're done */
+		spin_unlock(&last_ptr->refill_lock);
+		trace_btrfs_reserve_extent_cluster(cluster_bg,
+				ffe_ctl->search_start, ffe_ctl->num_bytes);
+		*cluster_bg_ret = cluster_bg;
+		ffe_ctl->found_offset = offset;
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
+	if (ffe_ctl->loop >= LOOP_NO_EMPTY_SIZE && cluster_bg != bg) {
+		spin_unlock(&last_ptr->refill_lock);
+		btrfs_release_block_group(cluster_bg, ffe_ctl->delalloc);
+		return -ENOENT;
+	}
+
+	/* This cluster didn't work out, free it and start over */
+	btrfs_return_cluster_to_free_space(NULL, last_ptr);
+
+	if (cluster_bg != bg)
+		btrfs_release_block_group(cluster_bg, ffe_ctl->delalloc);
+
+refill_cluster:
+	if (ffe_ctl->loop >= LOOP_NO_EMPTY_SIZE) {
+		spin_unlock(&last_ptr->refill_lock);
+		return -ENOENT;
+	}
+
+	aligned_cluster = max_t(u64,
+			ffe_ctl->empty_cluster + ffe_ctl->empty_size,
+			bg->full_stripe_len);
+	ret = btrfs_find_space_cluster(fs_info, bg, last_ptr,
+			ffe_ctl->search_start, ffe_ctl->num_bytes,
+			aligned_cluster);
+	if (ret == 0) {
+		/* now pull our allocation out of this cluster */
+		offset = btrfs_alloc_from_cluster(bg, last_ptr,
+				ffe_ctl->num_bytes,
+				ffe_ctl->search_start,
+				&ffe_ctl->max_extent_size);
+		if (offset) {
+			/* we found one, proceed */
+			spin_unlock(&last_ptr->refill_lock);
+			trace_btrfs_reserve_extent_cluster(bg,
+					ffe_ctl->search_start,
+					ffe_ctl->num_bytes);
+			ffe_ctl->found_offset = offset;
+			return 0;
+		}
+	} else if (!ffe_ctl->cached && ffe_ctl->loop > LOOP_CACHING_NOWAIT &&
+		   !ffe_ctl->retry_clustered) {
+		spin_unlock(&last_ptr->refill_lock);
+
+		ffe_ctl->retry_clustered = true;
+		wait_block_group_cache_progress(bg, ffe_ctl->num_bytes +
+				ffe_ctl->empty_cluster + ffe_ctl->empty_size);
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
@@ -7472,137 +7582,26 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
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
-			     !block_group_bits(used_block_group,
-					       ffe_ctl.flags)))
-				goto release_cluster;
-
-			ffe_ctl.found_offset = btrfs_alloc_from_cluster(
-						used_block_group,
-						last_ptr,
-						num_bytes,
-						used_block_group->key.objectid,
-						&ffe_ctl.max_extent_size);
-			if (ffe_ctl.found_offset) {
-				/* we have a block, we're done */
-				spin_unlock(&last_ptr->refill_lock);
-				trace_btrfs_reserve_extent_cluster(
-						used_block_group,
-						ffe_ctl.search_start,
-						num_bytes);
-				if (used_block_group != block_group) {
-					btrfs_release_block_group(block_group,
-								  delalloc);
-					block_group = used_block_group;
-				}
-				goto checks;
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
-			if (ffe_ctl.loop >= LOOP_NO_EMPTY_SIZE &&
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
-			if (ffe_ctl.loop >= LOOP_NO_EMPTY_SIZE) {
-				spin_unlock(&last_ptr->refill_lock);
-				goto unclustered_alloc;
-			}
+			struct btrfs_block_group_cache *cluster_bg = NULL;
 
-			aligned_cluster = max_t(unsigned long,
-					ffe_ctl.empty_cluster + empty_size,
-					block_group->full_stripe_len);
+			ret = find_free_extent_clustered(block_group, last_ptr,
+							 &ffe_ctl, &cluster_bg);
 
-			/* allocate a cluster in this block group */
-			ret = btrfs_find_space_cluster(fs_info, block_group,
-						       last_ptr,
-						       ffe_ctl.search_start,
-						       num_bytes,
-						       aligned_cluster);
 			if (ret == 0) {
-				/*
-				 * now pull our allocation out of this
-				 * cluster
-				 */
-				ffe_ctl.found_offset = btrfs_alloc_from_cluster(
-						block_group, last_ptr,
-						num_bytes, ffe_ctl.search_start,
-						&ffe_ctl.max_extent_size);
-				if (ffe_ctl.found_offset) {
-					/* we found one, proceed */
-					spin_unlock(&last_ptr->refill_lock);
-					trace_btrfs_reserve_extent_cluster(
-						block_group,
-						ffe_ctl.search_start,
-						num_bytes);
-					goto checks;
+				if (cluster_bg && cluster_bg != block_group) {
+					btrfs_release_block_group(block_group,
+								  delalloc);
+					block_group = cluster_bg;
 				}
-			} else if (!ffe_ctl.cached && ffe_ctl.loop >
-				   LOOP_CACHING_NOWAIT
-				   && !ffe_ctl.retry_clustered) {
-				spin_unlock(&last_ptr->refill_lock);
-
-				ffe_ctl.retry_clustered = true;
-				wait_block_group_cache_progress(block_group,
-				       num_bytes + ffe_ctl.empty_cluster +
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
+			/* ret == -ENOENT case falls through */
 		}
 
-unclustered_alloc:
 		/*
 		 * We are doing an unclustered alloc, set the fragmented flag so
 		 * we don't bother trying to setup a cluster again until we get
-- 
2.19.1

