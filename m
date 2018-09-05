Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:59858 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725825AbeIEGFR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Sep 2018 02:05:17 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: remove confusing tracepoint in btrfs_add_reserved_bytes
Date: Wed,  5 Sep 2018 09:37:25 +0800
Message-Id: <1536111445-126664-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 fs/btrfs/extent-tree.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 41a02cbb5a4a..76ee5ebef2b9 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6401,10 +6401,6 @@ static int btrfs_add_reserved_bytes(struct btrfs_block_group_cache *cache,
 	} else {
 		cache->reserved += num_bytes;
 		space_info->bytes_reserved += num_bytes;
-
-		trace_btrfs_space_reservation(cache->fs_info,
-				"space_info", space_info->flags,
-				ram_bytes, 0);
 		space_info->bytes_may_use -= ram_bytes;
 		if (delalloc)
 			cache->delalloc_bytes += num_bytes;
-- 
1.8.3.1
