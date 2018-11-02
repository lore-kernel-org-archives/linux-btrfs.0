Return-Path: <SRS0=Mp4+=NN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF5AEC6786F
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 01:40:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A9212081B
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 01:40:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8A9212081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbeKBKpV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 2 Nov 2018 06:45:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:44514 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725961AbeKBKpV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Nov 2018 06:45:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 15C7AAD5D;
        Fri,  2 Nov 2018 01:39:58 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     dsterba@suse.cz, josef@toxicpanda.com
Subject: [PATCH v5 1/4] btrfs: Introduce find_free_extent_ctl structure for later rework
Date:   Fri,  2 Nov 2018 09:39:47 +0800
Message-Id: <20181102013950.30293-2-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181102013950.30293-1-wqu@suse.com>
References: <20181102013950.30293-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Instead of tons of different local variables in find_free_extent(),
extract them into find_free_extent_ctl structure, and add better
explanation for them.

Some modification may looks redundant, but will later greatly simplify
function parameter list during find_free_extent() refactor.

Also add two comments to co-operate with fb5c39d7a887 ("btrfs: don't use
ctl->free_space for max_extent_size"), to make ffe_ctl->max_extent_size
update more reader-friendly.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
[Updated with conflicts with fb5c39d7a887 ("btrfs: don't use ctl->free_space for max_extent_size")]
---
 fs/btrfs/extent-tree.c | 265 ++++++++++++++++++++++++++---------------
 1 file changed, 170 insertions(+), 95 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a1febf155747..7b25e039fe80 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7238,6 +7238,58 @@ btrfs_release_block_group(struct btrfs_block_group_cache *cache,
 	btrfs_put_block_group(cache);
 }
 
+/*
+ * Internal used structure for find_free_extent() function.
+ * Wraps needed parameters.
+ */
+struct find_free_extent_ctl {
+	/* Basic allocation info */
+	u64 ram_bytes;
+	u64 num_bytes;
+	u64 empty_size;
+	u64 flags;
+	int delalloc;
+
+	/* Where to start the search inside the bg */
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
+	/* Current loop number */
+	int loop;
+
+	/*
+	 * Whether we're refilling a cluster, if true we need to re-search
+	 * current block group but don't try to refill the cluster again.
+	 */
+	bool retry_clustered;
+
+	/*
+	 * Whether we're updating free space cache, if true we need to re-search
+	 * current block group but don't try updating free space cache again.
+	 */
+	bool retry_unclustered;
+
+	/* If current block group is cached */
+	int cached;
+
+	/* Max contiguous hole found */
+	u64 max_extent_size;
+
+	/* Total free space from free space cache, not always contiguous */
+	u64 total_free_space;
+
+	/* Found result */
+	u64 found_offset;
+};
+
 /*
  * walks the btree of allocated extents and find a hole of a given size.
  * The key ins is changed to record the hole:
@@ -7258,21 +7310,26 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 	struct btrfs_root *root = fs_info->extent_root;
 	struct btrfs_free_cluster *last_ptr = NULL;
 	struct btrfs_block_group_cache *block_group = NULL;
-	u64 search_start = 0;
-	u64 max_extent_size = 0;
-	u64 max_free_space = 0;
-	u64 empty_cluster = 0;
+	struct find_free_extent_ctl ffe_ctl = {0};
 	struct btrfs_space_info *space_info;
-	int loop = 0;
-	int index = btrfs_bg_flags_to_raid_index(flags);
-	bool failed_cluster_refill = false;
-	bool failed_alloc = false;
 	bool use_cluster = true;
-	bool have_caching_bg = false;
-	bool orig_have_caching_bg = false;
 	bool full_search = false;
 
 	WARN_ON(num_bytes < fs_info->sectorsize);
+
+	ffe_ctl.ram_bytes = ram_bytes;
+	ffe_ctl.num_bytes = num_bytes;
+	ffe_ctl.empty_size = empty_size;
+	ffe_ctl.flags = flags;
+	ffe_ctl.search_start = 0;
+	ffe_ctl.retry_clustered = false;
+	ffe_ctl.retry_unclustered = false;
+	ffe_ctl.delalloc = delalloc;
+	ffe_ctl.index = btrfs_bg_flags_to_raid_index(flags);
+	ffe_ctl.have_caching_bg = false;
+	ffe_ctl.orig_have_caching_bg = false;
+	ffe_ctl.found_offset = 0;
+
 	ins->type = BTRFS_EXTENT_ITEM_KEY;
 	ins->objectid = 0;
 	ins->offset = 0;
@@ -7308,7 +7365,8 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 		spin_unlock(&space_info->lock);
 	}
 
-	last_ptr = fetch_cluster_info(fs_info, space_info, &empty_cluster);
+	last_ptr = fetch_cluster_info(fs_info, space_info,
+				      &ffe_ctl.empty_cluster);
 	if (last_ptr) {
 		spin_lock(&last_ptr->lock);
 		if (last_ptr->block_group)
@@ -7325,10 +7383,12 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 		spin_unlock(&last_ptr->lock);
 	}
 
-	search_start = max(search_start, first_logical_byte(fs_info, 0));
-	search_start = max(search_start, hint_byte);
-	if (search_start == hint_byte) {
-		block_group = btrfs_lookup_block_group(fs_info, search_start);
+	ffe_ctl.search_start = max(ffe_ctl.search_start,
+				   first_logical_byte(fs_info, 0));
+	ffe_ctl.search_start = max(ffe_ctl.search_start, hint_byte);
+	if (ffe_ctl.search_start == hint_byte) {
+		block_group = btrfs_lookup_block_group(fs_info,
+						       ffe_ctl.search_start);
 		/*
 		 * we don't want to use the block group if it doesn't match our
 		 * allocation bits, or if its not cached.
@@ -7350,7 +7410,7 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 				btrfs_put_block_group(block_group);
 				up_read(&space_info->groups_sem);
 			} else {
-				index = btrfs_bg_flags_to_raid_index(
+				ffe_ctl.index = btrfs_bg_flags_to_raid_index(
 						block_group->flags);
 				btrfs_lock_block_group(block_group, delalloc);
 				goto have_block_group;
@@ -7360,21 +7420,19 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 		}
 	}
 search:
-	have_caching_bg = false;
-	if (index == 0 || index == btrfs_bg_flags_to_raid_index(flags))
+	ffe_ctl.have_caching_bg = false;
+	if (ffe_ctl.index == btrfs_bg_flags_to_raid_index(flags) ||
+	    ffe_ctl.index == 0)
 		full_search = true;
 	down_read(&space_info->groups_sem);
-	list_for_each_entry(block_group, &space_info->block_groups[index],
-			    list) {
-		u64 offset;
-		int cached;
-
+	list_for_each_entry(block_group,
+			    &space_info->block_groups[ffe_ctl.index], list) {
 		/* If the block group is read-only, we can skip it entirely. */
 		if (unlikely(block_group->ro))
 			continue;
 
 		btrfs_grab_block_group(block_group, delalloc);
-		search_start = block_group->key.objectid;
+		ffe_ctl.search_start = block_group->key.objectid;
 
 		/*
 		 * this can happen if we end up cycling through all the
@@ -7398,9 +7456,9 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 		}
 
 have_block_group:
-		cached = block_group_cache_done(block_group);
-		if (unlikely(!cached)) {
-			have_caching_bg = true;
+		ffe_ctl.cached = block_group_cache_done(block_group);
+		if (unlikely(!ffe_ctl.cached)) {
+			ffe_ctl.have_caching_bg = true;
 			ret = cache_block_group(block_group, 0);
 			BUG_ON(ret < 0);
 			ret = 0;
@@ -7428,20 +7486,23 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 
 			if (used_block_group != block_group &&
 			    (used_block_group->ro ||
-			     !block_group_bits(used_block_group, flags)))
+			     !block_group_bits(used_block_group,
+					       ffe_ctl.flags)))
 				goto release_cluster;
 
-			offset = btrfs_alloc_from_cluster(used_block_group,
+			ffe_ctl.found_offset = btrfs_alloc_from_cluster(
+						used_block_group,
 						last_ptr,
 						num_bytes,
 						used_block_group->key.objectid,
-						&max_extent_size);
-			if (offset) {
+						&ffe_ctl.max_extent_size);
+			if (ffe_ctl.found_offset) {
 				/* we have a block, we're done */
 				spin_unlock(&last_ptr->refill_lock);
 				trace_btrfs_reserve_extent_cluster(
 						used_block_group,
-						search_start, num_bytes);
+						ffe_ctl.search_start,
+						num_bytes);
 				if (used_block_group != block_group) {
 					btrfs_release_block_group(block_group,
 								  delalloc);
@@ -7467,7 +7528,7 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 			 * first, so that we stand a better chance of
 			 * succeeding in the unclustered
 			 * allocation.  */
-			if (loop >= LOOP_NO_EMPTY_SIZE &&
+			if (ffe_ctl.loop >= LOOP_NO_EMPTY_SIZE &&
 			    used_block_group != block_group) {
 				spin_unlock(&last_ptr->refill_lock);
 				btrfs_release_block_group(used_block_group,
@@ -7485,18 +7546,19 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 				btrfs_release_block_group(used_block_group,
 							  delalloc);
 refill_cluster:
-			if (loop >= LOOP_NO_EMPTY_SIZE) {
+			if (ffe_ctl.loop >= LOOP_NO_EMPTY_SIZE) {
 				spin_unlock(&last_ptr->refill_lock);
 				goto unclustered_alloc;
 			}
 
 			aligned_cluster = max_t(unsigned long,
-						empty_cluster + empty_size,
-					      block_group->full_stripe_len);
+					ffe_ctl.empty_cluster + empty_size,
+					block_group->full_stripe_len);
 
 			/* allocate a cluster in this block group */
 			ret = btrfs_find_space_cluster(fs_info, block_group,
-						       last_ptr, search_start,
+						       last_ptr,
+						       ffe_ctl.search_start,
 						       num_bytes,
 						       aligned_cluster);
 			if (ret == 0) {
@@ -7504,26 +7566,28 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 				 * now pull our allocation out of this
 				 * cluster
 				 */
-				offset = btrfs_alloc_from_cluster(block_group,
-							last_ptr,
-							num_bytes,
-							search_start,
-							&max_extent_size);
-				if (offset) {
+				ffe_ctl.found_offset = btrfs_alloc_from_cluster(
+						block_group, last_ptr,
+						num_bytes, ffe_ctl.search_start,
+						&ffe_ctl.max_extent_size);
+				if (ffe_ctl.found_offset) {
 					/* we found one, proceed */
 					spin_unlock(&last_ptr->refill_lock);
 					trace_btrfs_reserve_extent_cluster(
-						block_group, search_start,
+						block_group,
+						ffe_ctl.search_start,
 						num_bytes);
 					goto checks;
 				}
-			} else if (!cached && loop > LOOP_CACHING_NOWAIT
-				   && !failed_cluster_refill) {
+			} else if (!ffe_ctl.cached && ffe_ctl.loop >
+				   LOOP_CACHING_NOWAIT
+				   && !ffe_ctl.retry_clustered) {
 				spin_unlock(&last_ptr->refill_lock);
 
-				failed_cluster_refill = true;
+				ffe_ctl.retry_clustered = true;
 				wait_block_group_cache_progress(block_group,
-				       num_bytes + empty_cluster + empty_size);
+				       num_bytes + ffe_ctl.empty_cluster +
+				       empty_size);
 				goto have_block_group;
 			}
 
@@ -7549,89 +7613,96 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 			last_ptr->fragmented = 1;
 			spin_unlock(&last_ptr->lock);
 		}
-		if (cached) {
+		if (ffe_ctl.cached) {
 			struct btrfs_free_space_ctl *ctl =
 				block_group->free_space_ctl;
 
 			spin_lock(&ctl->tree_lock);
 			if (ctl->free_space <
-			    num_bytes + empty_cluster + empty_size) {
-				max_free_space = max(max_free_space,
-						     ctl->free_space);
+			    num_bytes + ffe_ctl.empty_cluster + empty_size) {
+				ffe_ctl.total_free_space = max(ctl->free_space,
+						ffe_ctl.total_free_space);
 				spin_unlock(&ctl->tree_lock);
 				goto loop;
 			}
 			spin_unlock(&ctl->tree_lock);
 		}
 
-		offset = btrfs_find_space_for_alloc(block_group, search_start,
-						    num_bytes, empty_size,
-						    &max_extent_size);
+		ffe_ctl.found_offset = btrfs_find_space_for_alloc(block_group,
+				ffe_ctl.search_start, num_bytes, empty_size,
+				&ffe_ctl.max_extent_size);
 		/*
 		 * If we didn't find a chunk, and we haven't failed on this
 		 * block group before, and this block group is in the middle of
 		 * caching and we are ok with waiting, then go ahead and wait
-		 * for progress to be made, and set failed_alloc to true.
+		 * for progress to be made, and set ffe_ctl.retry_unclustered to
+		 * true.
 		 *
-		 * If failed_alloc is true then we've already waited on this
-		 * block group once and should move on to the next block group.
+		 * If ffe_ctl.retry_unclustered is true then we've already
+		 * waited on this block group once and should move on to the
+		 * next block group.
 		 */
-		if (!offset && !failed_alloc && !cached &&
-		    loop > LOOP_CACHING_NOWAIT) {
+		if (!ffe_ctl.found_offset && !ffe_ctl.retry_unclustered &&
+		    !ffe_ctl.cached && ffe_ctl.loop > LOOP_CACHING_NOWAIT) {
 			wait_block_group_cache_progress(block_group,
 						num_bytes + empty_size);
-			failed_alloc = true;
+			ffe_ctl.retry_unclustered = true;
 			goto have_block_group;
-		} else if (!offset) {
+		} else if (!ffe_ctl.found_offset) {
 			goto loop;
 		}
 checks:
-		search_start = round_up(offset, fs_info->stripesize);
+		ffe_ctl.search_start = round_up(ffe_ctl.found_offset,
+					     fs_info->stripesize);
 
 		/* move on to the next group */
-		if (search_start + num_bytes >
+		if (ffe_ctl.search_start + num_bytes >
 		    block_group->key.objectid + block_group->key.offset) {
-			btrfs_add_free_space(block_group, offset, num_bytes);
+			btrfs_add_free_space(block_group, ffe_ctl.found_offset,
+					     num_bytes);
 			goto loop;
 		}
 
-		if (offset < search_start)
-			btrfs_add_free_space(block_group, offset,
-					     search_start - offset);
+		if (ffe_ctl.found_offset < ffe_ctl.search_start)
+			btrfs_add_free_space(block_group, ffe_ctl.found_offset,
+				ffe_ctl.search_start - ffe_ctl.found_offset);
 
 		ret = btrfs_add_reserved_bytes(block_group, ram_bytes,
 				num_bytes, delalloc);
 		if (ret == -EAGAIN) {
-			btrfs_add_free_space(block_group, offset, num_bytes);
+			btrfs_add_free_space(block_group, ffe_ctl.found_offset,
+					     num_bytes);
 			goto loop;
 		}
 		btrfs_inc_block_group_reservations(block_group);
 
 		/* we are all good, lets return */
-		ins->objectid = search_start;
+		ins->objectid = ffe_ctl.search_start;
 		ins->offset = num_bytes;
 
-		trace_btrfs_reserve_extent(block_group, search_start, num_bytes);
+		trace_btrfs_reserve_extent(block_group, ffe_ctl.search_start,
+					   num_bytes);
 		btrfs_release_block_group(block_group, delalloc);
 		break;
 loop:
-		failed_cluster_refill = false;
-		failed_alloc = false;
+		ffe_ctl.retry_clustered = false;
+		ffe_ctl.retry_unclustered = false;
 		BUG_ON(btrfs_bg_flags_to_raid_index(block_group->flags) !=
-		       index);
+		       ffe_ctl.index);
 		btrfs_release_block_group(block_group, delalloc);
 		cond_resched();
 	}
 	up_read(&space_info->groups_sem);
 
-	if ((loop == LOOP_CACHING_NOWAIT) && have_caching_bg
-		&& !orig_have_caching_bg)
-		orig_have_caching_bg = true;
+	if ((ffe_ctl.loop == LOOP_CACHING_NOWAIT) && ffe_ctl.have_caching_bg
+		&& !ffe_ctl.orig_have_caching_bg)
+		ffe_ctl.orig_have_caching_bg = true;
 
-	if (!ins->objectid && loop >= LOOP_CACHING_WAIT && have_caching_bg)
+	if (!ins->objectid && ffe_ctl.loop >= LOOP_CACHING_WAIT &&
+	    ffe_ctl.have_caching_bg)
 		goto search;
 
-	if (!ins->objectid && ++index < BTRFS_NR_RAID_TYPES)
+	if (!ins->objectid && ++ffe_ctl.index < BTRFS_NR_RAID_TYPES)
 		goto search;
 
 	/*
@@ -7642,23 +7713,23 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 	 * LOOP_NO_EMPTY_SIZE, set empty_size and empty_cluster to 0 and try
 	 *			again
 	 */
-	if (!ins->objectid && loop < LOOP_NO_EMPTY_SIZE) {
-		index = 0;
-		if (loop == LOOP_CACHING_NOWAIT) {
+	if (!ins->objectid && ffe_ctl.loop < LOOP_NO_EMPTY_SIZE) {
+		ffe_ctl.index = 0;
+		if (ffe_ctl.loop == LOOP_CACHING_NOWAIT) {
 			/*
 			 * We want to skip the LOOP_CACHING_WAIT step if we
 			 * don't have any uncached bgs and we've already done a
 			 * full search through.
 			 */
-			if (orig_have_caching_bg || !full_search)
-				loop = LOOP_CACHING_WAIT;
+			if (ffe_ctl.orig_have_caching_bg || !full_search)
+				ffe_ctl.loop = LOOP_CACHING_WAIT;
 			else
-				loop = LOOP_ALLOC_CHUNK;
+				ffe_ctl.loop = LOOP_ALLOC_CHUNK;
 		} else {
-			loop++;
+			ffe_ctl.loop++;
 		}
 
-		if (loop == LOOP_ALLOC_CHUNK) {
+		if (ffe_ctl.loop == LOOP_ALLOC_CHUNK) {
 			struct btrfs_trans_handle *trans;
 			int exist = 0;
 
@@ -7681,7 +7752,7 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 			 * case.
 			 */
 			if (ret == -ENOSPC)
-				loop = LOOP_NO_EMPTY_SIZE;
+				ffe_ctl.loop = LOOP_NO_EMPTY_SIZE;
 
 			/*
 			 * Do not bail out on ENOSPC since we
@@ -7697,18 +7768,18 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 				goto out;
 		}
 
-		if (loop == LOOP_NO_EMPTY_SIZE) {
+		if (ffe_ctl.loop == LOOP_NO_EMPTY_SIZE) {
 			/*
 			 * Don't loop again if we already have no empty_size and
 			 * no empty_cluster.
 			 */
 			if (empty_size == 0 &&
-			    empty_cluster == 0) {
+			    ffe_ctl.empty_cluster == 0) {
 				ret = -ENOSPC;
 				goto out;
 			}
 			empty_size = 0;
-			empty_cluster = 0;
+			ffe_ctl.empty_cluster = 0;
 		}
 
 		goto search;
@@ -7724,12 +7795,16 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 	}
 out:
 	if (ret == -ENOSPC) {
-		if (!max_extent_size)
-			max_extent_size = max_free_space;
+		/*
+		 * Use ffe_ctl->total_free_space as fallback if we can't find
+		 * any contiguous hole.
+		 */
+		if (!ffe_ctl.max_extent_size)
+			ffe_ctl.max_extent_size = ffe_ctl.total_free_space;
 		spin_lock(&space_info->lock);
-		space_info->max_extent_size = max_extent_size;
+		space_info->max_extent_size = ffe_ctl.max_extent_size;
 		spin_unlock(&space_info->lock);
-		ins->offset = max_extent_size;
+		ins->offset = ffe_ctl.max_extent_size;
 	}
 	return ret;
 }
-- 
2.19.1

