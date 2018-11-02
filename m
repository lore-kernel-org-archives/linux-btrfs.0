Return-Path: <SRS0=Mp4+=NN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF529C6786F
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 01:40:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4F9D2081B
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 01:40:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B4F9D2081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbeKBKp3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 2 Nov 2018 06:45:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:44562 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725961AbeKBKp3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Nov 2018 06:45:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 58774AD5D;
        Fri,  2 Nov 2018 01:40:06 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     dsterba@suse.cz, josef@toxicpanda.com
Subject: [PATCH v5 4/4] btrfs: Refactor find_free_extent() loops update into find_free_extent_update_loop()
Date:   Fri,  2 Nov 2018 09:39:50 +0800
Message-Id: <20181102013950.30293-5-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181102013950.30293-1-wqu@suse.com>
References: <20181102013950.30293-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We have a complex loop design for find_free_extent(), that has different
behavior for each loop, some even includes new chunk allocation.

Instead of putting such a long code into find_free_extent() and makes it
harder to read, just extract them into find_free_extent_update_loop().

With all the cleanups, the main find_free_extent() should be pretty
barebone:

find_free_extent()
|- Iterate through all block groups
|  |- Get a valid block group
|  |- Try to do clustered allocation in that block group
|  |- Try to do unclustered allocation in that block group
|  |- Check if the result is valid
|  |  |- If valid, then exit
|  |- Jump to next block group
|
|- Push harder to find free extents
   |- If not found, re-iterate all block groups

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 217 ++++++++++++++++++++++-------------------
 1 file changed, 117 insertions(+), 100 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 2c9f00cb8f26..c3f57dc30ab5 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7262,7 +7262,9 @@ struct find_free_extent_ctl {
 	/* RAID index, converted from flags */
 	int index;
 
-	/* Current loop number */
+	/*
+	 * Current loop number, check find_free_extent_update_loop() for details
+	 */
 	int loop;
 
 	/*
@@ -7463,6 +7465,117 @@ static int find_free_extent_unclustered(struct btrfs_block_group_cache *bg,
 	return 0;
 }
 
+/*
+ * Return >0 means caller needs to re-search for free extent
+ * Return 0 means we have the needed free extent.
+ * Return <0 means we failed to locate any free extent.
+ */
+static int find_free_extent_update_loop(struct btrfs_fs_info *fs_info,
+					struct btrfs_free_cluster *last_ptr,
+					struct btrfs_key *ins,
+					struct find_free_extent_ctl *ffe_ctl,
+					int full_search, bool use_cluster)
+{
+	struct btrfs_root *root = fs_info->extent_root;
+	int ret;
+
+	if ((ffe_ctl->loop == LOOP_CACHING_NOWAIT) &&
+	    ffe_ctl->have_caching_bg && !ffe_ctl->orig_have_caching_bg)
+		ffe_ctl->orig_have_caching_bg = true;
+
+	if (!ins->objectid && ffe_ctl->loop >= LOOP_CACHING_WAIT &&
+	     ffe_ctl->have_caching_bg)
+		return 1;
+
+	if (!ins->objectid && ++(ffe_ctl->index) < BTRFS_NR_RAID_TYPES)
+		return 1;
+
+	if (ins->objectid) {
+		if (!use_cluster && last_ptr) {
+			spin_lock(&last_ptr->lock);
+			last_ptr->window_start = ins->objectid;
+			spin_unlock(&last_ptr->lock);
+		}
+		return 0;
+	}
+
+	/*
+	 * LOOP_CACHING_NOWAIT, search partially cached block groups, kicking
+	 *			caching kthreads as we move along
+	 * LOOP_CACHING_WAIT, search everything, and wait if our bg is caching
+	 * LOOP_ALLOC_CHUNK, force a chunk allocation and try again
+	 * LOOP_NO_EMPTY_SIZE, set empty_size and empty_cluster to 0 and try
+	 *			again
+	 */
+	if (ffe_ctl->loop < LOOP_NO_EMPTY_SIZE) {
+		ffe_ctl->index = 0;
+		if (ffe_ctl->loop == LOOP_CACHING_NOWAIT) {
+			/*
+			 * We want to skip the LOOP_CACHING_WAIT step if we
+			 * don't have any uncached bgs and we've already done a
+			 * full search through.
+			 */
+			if (ffe_ctl->orig_have_caching_bg || !full_search)
+				ffe_ctl->loop = LOOP_CACHING_WAIT;
+			else
+				ffe_ctl->loop = LOOP_ALLOC_CHUNK;
+		} else {
+			ffe_ctl->loop++;
+		}
+
+		if (ffe_ctl->loop == LOOP_ALLOC_CHUNK) {
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
+			ret = do_chunk_alloc(trans, ffe_ctl->flags,
+					     CHUNK_ALLOC_FORCE);
+
+			/*
+			 * If we can't allocate a new chunk we've already looped
+			 * through at least once, move on to the NO_EMPTY_SIZE
+			 * case.
+			 */
+			if (ret == -ENOSPC)
+				ffe_ctl->loop = LOOP_NO_EMPTY_SIZE;
+
+			/* Do not bail out on ENOSPC since we can do more. */
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
+		if (ffe_ctl->loop == LOOP_NO_EMPTY_SIZE) {
+			/*
+			 * Don't loop again if we already have no empty_size and
+			 * no empty_cluster.
+			 */
+			if (ffe_ctl->empty_size == 0 &&
+			    ffe_ctl->empty_cluster == 0)
+				return -ENOSPC;
+			ffe_ctl->empty_size = 0;
+			ffe_ctl->empty_cluster = 0;
+		}
+		return 1;
+	}
+	return -ENOSPC;
+}
+
 /*
  * walks the btree of allocated extents and find a hole of a given size.
  * The key ins is changed to record the hole:
@@ -7480,7 +7593,6 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 				u64 flags, int delalloc)
 {
 	int ret = 0;
-	struct btrfs_root *root = fs_info->extent_root;
 	struct btrfs_free_cluster *last_ptr = NULL;
 	struct btrfs_block_group_cache *block_group = NULL;
 	struct find_free_extent_ctl ffe_ctl = {0};
@@ -7715,106 +7827,11 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 	}
 	up_read(&space_info->groups_sem);
 
-	if ((ffe_ctl.loop == LOOP_CACHING_NOWAIT) && ffe_ctl.have_caching_bg
-		&& !ffe_ctl.orig_have_caching_bg)
-		ffe_ctl.orig_have_caching_bg = true;
-
-	if (!ins->objectid && ffe_ctl.loop >= LOOP_CACHING_WAIT &&
-	    ffe_ctl.have_caching_bg)
-		goto search;
-
-	if (!ins->objectid && ++ffe_ctl.index < BTRFS_NR_RAID_TYPES)
+	ret = find_free_extent_update_loop(fs_info, last_ptr, ins, &ffe_ctl,
+					   full_search, use_cluster);
+	if (ret > 0)
 		goto search;
 
-	/*
-	 * LOOP_CACHING_NOWAIT, search partially cached block groups, kicking
-	 *			caching kthreads as we move along
-	 * LOOP_CACHING_WAIT, search everything, and wait if our bg is caching
-	 * LOOP_ALLOC_CHUNK, force a chunk allocation and try again
-	 * LOOP_NO_EMPTY_SIZE, set empty_size and empty_cluster to 0 and try
-	 *			again
-	 */
-	if (!ins->objectid && ffe_ctl.loop < LOOP_NO_EMPTY_SIZE) {
-		ffe_ctl.index = 0;
-		if (ffe_ctl.loop == LOOP_CACHING_NOWAIT) {
-			/*
-			 * We want to skip the LOOP_CACHING_WAIT step if we
-			 * don't have any uncached bgs and we've already done a
-			 * full search through.
-			 */
-			if (ffe_ctl.orig_have_caching_bg || !full_search)
-				ffe_ctl.loop = LOOP_CACHING_WAIT;
-			else
-				ffe_ctl.loop = LOOP_ALLOC_CHUNK;
-		} else {
-			ffe_ctl.loop++;
-		}
-
-		if (ffe_ctl.loop == LOOP_ALLOC_CHUNK) {
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
-			ret = do_chunk_alloc(trans, flags, CHUNK_ALLOC_FORCE);
-
-			/*
-			 * If we can't allocate a new chunk we've already looped
-			 * through at least once, move on to the NO_EMPTY_SIZE
-			 * case.
-			 */
-			if (ret == -ENOSPC)
-				ffe_ctl.loop = LOOP_NO_EMPTY_SIZE;
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
-		if (ffe_ctl.loop == LOOP_NO_EMPTY_SIZE) {
-			/*
-			 * Don't loop again if we already have no empty_size and
-			 * no empty_cluster.
-			 */
-			if (empty_size == 0 &&
-			    ffe_ctl.empty_cluster == 0) {
-				ret = -ENOSPC;
-				goto out;
-			}
-			empty_size = 0;
-			ffe_ctl.empty_cluster = 0;
-		}
-
-		goto search;
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
 		/*
 		 * Use ffe_ctl->total_free_space as fallback if we can't find
-- 
2.19.1

