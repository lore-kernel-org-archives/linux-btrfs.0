Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA68CC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 03:04:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AD5D2086B
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 03:04:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6AD5D2086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbeK1OET (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 09:04:19 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:19247 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727209AbeK1OET (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 09:04:19 -0500
X-IronPort-AV: E=Sophos;i="5.56,289,1539619200"; 
   d="scan'208";a="48766250"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 28 Nov 2018 11:04:14 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id E04F84B734D8
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2018 11:04:14 +0800 (CST)
Received: from localhost.localdomain (10.167.226.22) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 28 Nov 2018 11:04:20 +0800
From:   Su Yue <suy.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     <suy.fnst@cn.fujitsu.com>
Subject: [RFC PATCH 13/17] btrfs: priority alloc: modify find_free_extent() to fit priority allocator
Date:   Wed, 28 Nov 2018 11:11:44 +0800
Message-ID: <20181128031148.357-14-suy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181128031148.357-1-suy.fnst@cn.fujitsu.com>
References: <20181128031148.357-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.22]
X-yoursite-MailScanner-ID: E04F84B734D8.AAF16
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Add member priority_tree to find_free_extent_ctl to represents the
tree using.

Modify find_free_extent to use find_free_extent_search, so it can
work in default mount option and priorit aware allocator.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 114 ++++++++++++++++++++++++++++++++---------
 1 file changed, 91 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5484256169dd..4c76677a54a9 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7328,6 +7328,8 @@ struct find_free_extent_ctl {
 
 	/* Found result */
 	u64 found_offset;
+
+	struct btrfs_priority_tree *priority_tree;
 };
 
 
@@ -7692,6 +7694,10 @@ static int find_free_extent_update_loop(struct btrfs_fs_info *fs_info,
 	return -ENOSPC;
 }
 
+static inline bool
+is_priority_alloc_enabled(struct btrfs_fs_info *fs_info);
+
+static long compute_block_group_priority(struct btrfs_block_group_cache *bg);
 /*
  * walks the btree of allocated extents and find a hole of a given size.
  * The key ins is changed to record the hole:
@@ -7729,6 +7735,7 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 	struct btrfs_space_info *space_info;
 	bool use_cluster = true;
 	bool full_search = false;
+	bool use_priority = is_priority_alloc_enabled(fs_info);
 
 	WARN_ON(num_bytes < fs_info->sectorsize);
 
@@ -7744,6 +7751,7 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 	ffe_ctl.have_caching_bg = false;
 	ffe_ctl.orig_have_caching_bg = false;
 	ffe_ctl.found_offset = 0;
+	ffe_ctl.priority_tree = NULL;
 
 	ins->type = BTRFS_EXTENT_ITEM_KEY;
 	ins->objectid = 0;
@@ -7813,40 +7821,82 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 		 */
 		if (block_group && block_group_bits(block_group, flags) &&
 		    block_group->cached != BTRFS_CACHE_NO) {
-			down_read(&space_info->groups_sem);
-			if (list_empty(&block_group->list) ||
-			    block_group->ro) {
-				/*
-				 * someone is removing this block group,
-				 * we can't jump into the have_block_group
-				 * target because our list pointers are not
-				 * valid
-				 */
-				btrfs_put_block_group(block_group);
-				up_read(&space_info->groups_sem);
+			if (use_priority) {
+				spin_lock(&block_group->lock);
+				if (block_group->priority ==
+						    PRIORITY_BG_DELETED ||
+				    block_group->priority ==
+						    PRIORITY_BG_BUSY ||
+				    block_group->ro) {
+					spin_unlock(&block_group->lock);
+					btrfs_put_block_group(block_group);
+					goto search;
+				}
+
+				block_group->priority = PRIORITY_BG_BUSY;
+				spin_unlock(&block_group->lock);
+				ffe_ctl.priority_tree =
+					block_group->priority_tree;
+				down_read(&ffe_ctl.priority_tree->groups_sem);
 			} else {
-				ffe_ctl.index = btrfs_bg_flags_to_raid_index(
-						block_group->flags);
-				btrfs_lock_block_group(block_group, delalloc);
-				goto have_block_group;
+				down_read(&space_info->groups_sem);
+				if (list_empty(&block_group->list) ||
+				    block_group->ro) {
+					/*
+					 * someone is removing this block
+					 * group, we can't jump into the
+					 * have_block_group target because our
+					 * list pointers are not valid
+					 */
+					btrfs_put_block_group(block_group);
+					up_read(&space_info->groups_sem);
+					goto search;
+				}
 			}
+			ffe_ctl.index = btrfs_bg_flags_to_raid_index(
+				block_group->flags);
+			btrfs_lock_block_group(block_group, delalloc);
+			goto have_block_group;
 		} else if (block_group) {
 			btrfs_put_block_group(block_group);
 		}
 	}
 search:
+	ffe_ctl.priority_tree = NULL;
+	block_group = NULL;
 	ffe_ctl.have_caching_bg = false;
 	if (ffe_ctl.index == btrfs_bg_flags_to_raid_index(flags) ||
 	    ffe_ctl.index == 0)
 		full_search = true;
-	down_read(&space_info->groups_sem);
-	list_for_each_entry(block_group,
-			    &space_info->block_groups[ffe_ctl.index], list) {
+	if (!use_priority)
+		down_read(&space_info->groups_sem);
+	while (1) {
+		block_group = find_free_extent_search(space_info,
+				      ffe_ctl.index, block_group, use_priority,
+				      &ffe_ctl.priority_tree);
+
+		if (block_group == NULL)
+			break;
 		/* If the block group is read-only, we can skip it entirely. */
 		if (unlikely(block_group->ro))
 			continue;
 
 		btrfs_grab_block_group(block_group, delalloc);
+
+		if (use_priority) {
+			spin_lock(&block_group->lock);
+			/* someone the block group is unavaiable now */
+			if (block_group->priority == PRIORITY_BG_DELETED ||
+			    block_group->priority == PRIORITY_BG_UPDATING ||
+			    block_group->priority == PRIORITY_BG_BUSY) {
+				spin_unlock(&block_group->lock);
+				goto loop;
+			}
+
+			block_group->priority = PRIORITY_BG_BUSY;
+			spin_unlock(&block_group->lock);
+		}
+
 		ffe_ctl.search_start = block_group->key.objectid;
 
 		/*
@@ -7945,9 +7995,20 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 
 		trace_btrfs_reserve_extent(block_group, ffe_ctl.search_start,
 					   num_bytes);
-		btrfs_release_block_group(block_group, delalloc);
-		break;
+		goto out;
 loop:
+		if (use_priority) {
+			long priority;
+
+			spin_lock(&block_group->lock);
+			if (block_group->priority == PRIORITY_BG_BUSY) {
+				priority = compute_block_group_priority(
+					block_group);
+				block_group->priority = priority;
+			}
+			spin_unlock(&block_group->lock);
+		}
+
 		ffe_ctl.retry_clustered = false;
 		ffe_ctl.retry_unclustered = false;
 		BUG_ON(btrfs_bg_flags_to_raid_index(block_group->flags) !=
@@ -7955,8 +8016,16 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 		btrfs_release_block_group(block_group, delalloc);
 		cond_resched();
 	}
-	up_read(&space_info->groups_sem);
-
+	if (!use_priority)
+		up_read(&space_info->groups_sem);
+out:
+	if (ins->objectid) {
+		if (use_priority)
+			up_read(&ffe_ctl.priority_tree->groups_sem);
+		else
+			up_read(&space_info->groups_sem);
+		btrfs_release_block_group(block_group, delalloc);
+	}
 	ret = find_free_extent_update_loop(fs_info, last_ptr, ins, &ffe_ctl,
 					   full_search, use_cluster);
 	if (ret > 0)
@@ -10194,7 +10263,6 @@ static int check_chunk_block_group_mappings(struct btrfs_fs_info *fs_info)
 	return ret;
 }
 
-static long compute_block_group_priority(struct btrfs_block_group_cache *bg);
 static void add_block_group_priority(struct btrfs_block_group_cache *cache);
 int btrfs_read_block_groups(struct btrfs_fs_info *info)
 {
-- 
2.19.1



