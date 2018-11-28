Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2288CC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 03:04:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF6E12086B
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 03:04:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DF6E12086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727274AbeK1OEV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 09:04:21 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:54216 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727262AbeK1OEU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 09:04:20 -0500
X-IronPort-AV: E=Sophos;i="5.56,289,1539619200"; 
   d="scan'208";a="48766255"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 28 Nov 2018 11:04:16 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 7F3774B734A1
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2018 11:04:15 +0800 (CST)
Received: from localhost.localdomain (10.167.226.22) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 28 Nov 2018 11:04:20 +0800
From:   Su Yue <suy.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     <suy.fnst@cn.fujitsu.com>
Subject: [RFC PATCH 14/17] btrfs: priority alloc: introduce btrfs_set_bg_updating and call btrfs_update_block_group_prioriy
Date:   Wed, 28 Nov 2018 11:11:45 +0800
Message-ID: <20181128031148.357-15-suy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181128031148.357-1-suy.fnst@cn.fujitsu.com>
References: <20181128031148.357-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.22]
X-yoursite-MailScanner-ID: 7F3774B734A1.A9774
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

For usage as priority, the varaiables in block groups we concered are
reserved, bytes_super and btrfs_block_group_used(&cache->item).

This patch calls btrfs_set_bg_updating() in locations where above three
varaiables changed to mark block groups needs to be updated, then
calls btrfs_update_block_group() to update priority tree if needed.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 fs/btrfs/ctree.h            |  2 ++
 fs/btrfs/extent-tree.c      | 40 +++++++++++++++++++++++++++++++++++++
 fs/btrfs/free-space-cache.c |  3 +++
 3 files changed, 45 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 091b878e326c..f1ab0310da08 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2753,6 +2753,8 @@ u64 btrfs_metadata_alloc_profile(struct btrfs_fs_info *fs_info);
 u64 btrfs_system_alloc_profile(struct btrfs_fs_info *fs_info);
 void btrfs_clear_space_info_full(struct btrfs_fs_info *info);
 void btrfs_remove_block_group_priority(struct btrfs_block_group_cache *cache);
+void btrfs_set_bg_priority_updating(struct btrfs_block_group_cache *cache);
+void btrfs_update_block_group_priority(struct btrfs_block_group_cache *cache);
 
 enum btrfs_reserve_flush_enum {
 	/* If we are in the transaction, we can't flush anything.*/
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4c76677a54a9..f530a4344368 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6183,6 +6183,7 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 			cache->space_info->bytes_reserved -= num_bytes;
 			cache->space_info->bytes_used += num_bytes;
 			cache->space_info->disk_used += num_bytes * factor;
+			btrfs_set_bg_priority_updating(cache);
 			spin_unlock(&cache->lock);
 			spin_unlock(&cache->space_info->lock);
 		} else {
@@ -6192,6 +6193,7 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 			update_bytes_pinned(cache->space_info, num_bytes);
 			cache->space_info->bytes_used -= num_bytes;
 			cache->space_info->disk_used -= num_bytes * factor;
+			btrfs_set_bg_priority_updating(cache);
 			spin_unlock(&cache->lock);
 			spin_unlock(&cache->space_info->lock);
 
@@ -6205,6 +6207,7 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 					 bytenr, bytenr + num_bytes - 1,
 					 GFP_NOFS | __GFP_NOFAIL);
 		}
+		btrfs_update_block_group_priority(cache);
 
 		spin_lock(&trans->transaction->dirty_bgs_lock);
 		if (list_empty(&cache->dirty_list)) {
@@ -6264,6 +6267,7 @@ static int pin_down_extent(struct btrfs_fs_info *fs_info,
 	if (reserved) {
 		cache->reserved -= num_bytes;
 		cache->space_info->bytes_reserved -= num_bytes;
+		btrfs_set_bg_priority_updating(cache);
 	}
 	spin_unlock(&cache->lock);
 	spin_unlock(&cache->space_info->lock);
@@ -6274,6 +6278,8 @@ static int pin_down_extent(struct btrfs_fs_info *fs_info,
 		    num_bytes, BTRFS_TOTAL_BYTES_PINNED_BATCH);
 	set_extent_dirty(fs_info->pinned_extents, bytenr,
 			 bytenr + num_bytes - 1, GFP_NOFS | __GFP_NOFAIL);
+
+	btrfs_update_block_group_priority(cache);
 	return 0;
 }
 
@@ -6472,6 +6478,12 @@ static int btrfs_add_reserved_bytes(struct btrfs_block_group_cache *cache,
 		update_bytes_may_use(space_info, -ram_bytes);
 		if (delalloc)
 			cache->delalloc_bytes += num_bytes;
+		/*
+		 * Since it's called in find_free_extent(),
+		 * call btrfs_update_block_group_priority() in outter to
+		 * avoid dead lock.
+		 */
+		btrfs_set_bg_priority_updating(cache);
 	}
 	spin_unlock(&cache->lock);
 	spin_unlock(&space_info->lock);
@@ -6502,11 +6514,14 @@ static void btrfs_free_reserved_bytes(struct btrfs_block_group_cache *cache,
 	cache->reserved -= num_bytes;
 	space_info->bytes_reserved -= num_bytes;
 	space_info->max_extent_size = 0;
+	btrfs_set_bg_priority_updating(cache);
 
 	if (delalloc)
 		cache->delalloc_bytes -= num_bytes;
 	spin_unlock(&cache->lock);
 	spin_unlock(&space_info->lock);
+
+	btrfs_update_block_group_priority(cache);
 }
 void btrfs_prepare_extent_commit(struct btrfs_fs_info *fs_info)
 {
@@ -8025,6 +8040,7 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 		else
 			up_read(&space_info->groups_sem);
 		btrfs_release_block_group(block_group, delalloc);
+		btrfs_update_block_group_priority(block_group);
 	}
 	ret = find_free_extent_update_loop(fs_info, last_ptr, ins, &ffe_ctl,
 					   full_search, use_cluster);
@@ -8434,9 +8450,12 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 	spin_lock(&block_group->lock);
 	space_info->bytes_reserved += ins->offset;
 	block_group->reserved += ins->offset;
+	btrfs_set_bg_priority_updating(block_group);
 	spin_unlock(&block_group->lock);
 	spin_unlock(&space_info->lock);
 
+	btrfs_update_block_group_priority(block_group);
+
 	ret = alloc_reserved_file_extent(trans, 0, root_objectid, 0, owner,
 					 offset, ins, 1);
 	btrfs_put_block_group(block_group);
@@ -11706,3 +11725,24 @@ void btrfs_update_block_group_priority(struct btrfs_block_group_cache *cache)
 	up_write(front_sem);
 	up_write(back_sem);
 }
+
+/* Caller must hold cache->lock */
+void
+btrfs_set_bg_priority_updating(struct btrfs_block_group_cache *cache)
+{
+	long priority;
+	int new_level;
+
+	if (!is_priority_alloc_enabled(cache->fs_info))
+		return;
+	if (cache->priority == PRIORITY_BG_DELETED)
+		return;
+
+	priority = compute_block_group_priority(cache);
+	new_level = compute_priority_level(cache->fs_info, priority);
+
+	if (cache->priority_tree->level != new_level)
+		priority = PRIORITY_BG_UPDATING;
+
+	cache->priority = priority;
+}
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 74aa552f4793..ff28a26c9104 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -3149,6 +3149,7 @@ static int do_trimming(struct btrfs_block_group_cache *block_group,
 		block_group->reserved += reserved_bytes;
 		space_info->bytes_reserved += reserved_bytes;
 		update = 1;
+		btrfs_set_bg_priority_updating(block_group);
 	}
 	spin_unlock(&block_group->lock);
 	spin_unlock(&space_info->lock);
@@ -3169,10 +3170,12 @@ static int do_trimming(struct btrfs_block_group_cache *block_group,
 			space_info->bytes_readonly += reserved_bytes;
 		block_group->reserved -= reserved_bytes;
 		space_info->bytes_reserved -= reserved_bytes;
+		btrfs_set_bg_priority_updating(block_group);
 		spin_unlock(&space_info->lock);
 		spin_unlock(&block_group->lock);
 	}
 
+	btrfs_update_block_group_priority(block_group);
 	return ret;
 }
 
-- 
2.19.1



