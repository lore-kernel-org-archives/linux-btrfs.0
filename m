Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55896 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726641AbeHUME6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 08:04:58 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B0F23B067
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Aug 2018 08:44:40 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/4] btrfs: Refactor unclustered extent allocation into find_free_extent_unclustered()
Date: Tue, 21 Aug 2018 16:44:25 +0800
Message-Id: <20180821084426.7858-4-wqu@suse.com>
In-Reply-To: <20180821084426.7858-1-wqu@suse.com>
References: <20180821084426.7858-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch will extract unclsutered extent allocation code into
find_free_extent_unclustered().

And this helper function will use return value to indicate what to do
next.

This should make find_free_extent() a little easier to read.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent-tree.c | 112 ++++++++++++++++++++++++-----------------
 1 file changed, 66 insertions(+), 46 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a603900e0eb8..5bc8919edac2 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7546,6 +7546,67 @@ static int find_free_extent_clustered(struct btrfs_block_group_cache *bg,
 	return 1;
 }
 
+/*
+ * Return >0 to inform caller that we find nothing
+ * Return -EAGAIN to inform caller that we need to re-search this block group
+ */
+static int find_free_extent_unclustered(struct btrfs_block_group_cache *bg,
+		struct btrfs_free_cluster *last_ptr,
+		struct find_free_extent_ctrl *ctrl)
+{
+	u64 offset;
+
+	/*
+	 * We are doing an unclustered alloc, set the fragmented flag so we
+	 * don't bother trying to setup a cluster again until we get more space.
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
+	 * If we didn't find a chunk, and we haven't failed on this block group
+	 * before, and this block group is in the middle of caching and we are
+	 * ok with waiting, then go ahead and wait for progress to be made, and
+	 * set @retry_unclustered to true.
+	 *
+	 * If @retry_unclustered is true then we've already waited on this block
+	 * group once and should move on to the next block group.
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
 /*
  * walks the btree of allocated extents and find a hole of a given size.
  * The key ins is changed to record the hole:
@@ -7747,54 +7808,13 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 			/* ret == -ENOENT case falss through */
 		}
 
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
-		if (ctrl.cached) {
-			struct btrfs_free_space_ctl *ctl =
-				block_group->free_space_ctl;
-
-			spin_lock(&ctl->tree_lock);
-			if (ctl->free_space <
-			    num_bytes + ctrl.empty_cluster + empty_size) {
-				if (ctl->free_space > ctrl.max_extent_size)
-					ctrl.max_extent_size = ctl->free_space;
-				spin_unlock(&ctl->tree_lock);
-				goto loop;
-			}
-			spin_unlock(&ctl->tree_lock);
-		}
-
-		ctrl.found_offset = btrfs_find_space_for_alloc(block_group,
-				ctrl.search_start, num_bytes, empty_size,
-				&ctrl.max_extent_size);
-		/*
-		 * If we didn't find a chunk, and we haven't failed on this
-		 * block group before, and this block group is in the middle of
-		 * caching and we are ok with waiting, then go ahead and wait
-		 * for progress to be made, and set ctrl.retry_unclustered to
-		 * true.
-		 *
-		 * If ctrl.retry_unclustered is true then we've already waited
-		 * on this block group once and should move on to the next block
-		 * group.
-		 */
-		if (!ctrl.found_offset && !ctrl.retry_unclustered &&
-		    !ctrl.cached && ctrl.loop > LOOP_CACHING_NOWAIT) {
-			wait_block_group_cache_progress(block_group,
-						num_bytes + empty_size);
-			ctrl.retry_unclustered = true;
+		ret = find_free_extent_unclustered(block_group, last_ptr,
+						   &ctrl);
+		if (ret == -EAGAIN)
 			goto have_block_group;
-		} else if (!ctrl.found_offset) {
+		else if (ret > 0)
 			goto loop;
-		}
+		/* ret == 0 case falls through */
 checks:
 		ctrl.search_start = round_up(ctrl.found_offset,
 					     fs_info->stripesize);
-- 
2.18.0
