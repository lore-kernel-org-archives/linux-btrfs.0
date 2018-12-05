Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CEB0C07E85
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 06:40:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C74AA2082B
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 06:40:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C74AA2082B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbeLEGku (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 01:40:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:49786 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727161AbeLEGkt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 01:40:49 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 863E8AEB4
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Dec 2018 06:40:47 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 13/13] btrfs-progs: free-space-tree: Remove unsued function
Date:   Wed,  5 Dec 2018 14:40:18 +0800
Message-Id: <20181205064018.27755-14-wqu@suse.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181205064018.27755-1-wqu@suse.com>
References: <20181205064018.27755-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

set_free_space_tree_thresholds() is never used, just remove it to solve
the missing-prototypes warning from make W=1.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
---
 free-space-tree.c | 29 -----------------------------
 1 file changed, 29 deletions(-)

diff --git a/free-space-tree.c b/free-space-tree.c
index b3ffa90f704c..af141e6e611a 100644
--- a/free-space-tree.c
+++ b/free-space-tree.c
@@ -24,35 +24,6 @@
 #include "bitops.h"
 #include "internal.h"
 
-void set_free_space_tree_thresholds(struct btrfs_block_group_cache *cache,
-				    u64 sectorsize)
-{
-	u32 bitmap_range;
-	size_t bitmap_size;
-	u64 num_bitmaps, total_bitmap_size;
-
-	/*
-	 * We convert to bitmaps when the disk space required for using extents
-	 * exceeds that required for using bitmaps.
-	 */
-	bitmap_range = sectorsize * BTRFS_FREE_SPACE_BITMAP_BITS;
-	num_bitmaps = div_u64(cache->key.offset + bitmap_range - 1,
-			      bitmap_range);
-	bitmap_size = sizeof(struct btrfs_item) + BTRFS_FREE_SPACE_BITMAP_SIZE;
-	total_bitmap_size = num_bitmaps * bitmap_size;
-	cache->bitmap_high_thresh = div_u64(total_bitmap_size,
-					    sizeof(struct btrfs_item));
-
-	/*
-	 * We allow for a small buffer between the high threshold and low
-	 * threshold to avoid thrashing back and forth between the two formats.
-	 */
-	if (cache->bitmap_high_thresh > 100)
-		cache->bitmap_low_thresh = cache->bitmap_high_thresh - 100;
-	else
-		cache->bitmap_low_thresh = 0;
-}
-
 static struct btrfs_free_space_info *
 search_free_space_info(struct btrfs_trans_handle *trans,
 		       struct btrfs_fs_info *fs_info,
-- 
2.19.2

