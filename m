Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42897 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752627AbdEPRLj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2017 13:11:39 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6306AAD23
        for <linux-btrfs@vger.kernel.org>; Tue, 16 May 2017 17:11:38 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 07/10] btrfs: scrub: use fs_info::sectorsize and drop it from scrub context
Date: Tue, 16 May 2017 19:10:41 +0200
Message-Id: <4a48588c77c94dd0ce696732cf7e5476217f0204.1494954480.git.dsterba@suse.com>
In-Reply-To: <cover.1494954480.git.dsterba@suse.com>
References: <cover.1494954480.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As we now have the node/block sizes in fs_info, we can use them and can
drop the local copies.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/scrub.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 8caf775fee0a..5b135df691fa 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -175,8 +175,6 @@ struct scrub_ctx {
 	atomic_t		cancel_req;
 	int			readonly;
 	int			pages_per_rd_bio;
-	u32			sectorsize;
-	u32			nodesize;
 
 	int			is_dev_replace;
 
@@ -700,8 +698,6 @@ struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *dev, int is_dev_replace)
 			sctx->bios[i]->next_free = -1;
 	}
 	sctx->first_free = 0;
-	sctx->nodesize = fs_info->nodesize;
-	sctx->sectorsize = fs_info->sectorsize;
 	atomic_set(&sctx->bios_in_flight, 0);
 	atomic_set(&sctx->workers_pending, 0);
 	atomic_set(&sctx->cancel_req, 0);
@@ -2072,7 +2068,7 @@ static int scrub_checksum_data(struct scrub_block *sblock)
 	page = sblock->pagev[0]->page;
 	buffer = kmap_atomic(page);
 
-	len = sctx->sectorsize;
+	len = sctx->fs_info->sectorsize;
 	index = 0;
 	for (;;) {
 		u64 l = min_t(u64, len, PAGE_SIZE);
@@ -2137,7 +2133,7 @@ static int scrub_checksum_tree_block(struct scrub_block *sblock)
 		   BTRFS_UUID_SIZE))
 		sblock->header_error = 1;
 
-	len = sctx->nodesize - BTRFS_CSUM_SIZE;
+	len = sctx->fs_info->nodesize - BTRFS_CSUM_SIZE;
 	mapped_size = PAGE_SIZE - BTRFS_CSUM_SIZE;
 	p = ((u8 *)mapped_buffer) + BTRFS_CSUM_SIZE;
 	index = 0;
@@ -2715,8 +2711,8 @@ static int scrub_find_csum(struct scrub_ctx *sctx, u64 logical, u8 *csum)
 	if (!sum)
 		return 0;
 
-	index = ((u32)(logical - sum->bytenr)) / sctx->sectorsize;
-	num_sectors = sum->len / sctx->sectorsize;
+	index = ((u32)(logical - sum->bytenr)) / sctx->fs_info->sectorsize;
+	num_sectors = sum->len / sctx->fs_info->sectorsize;
 	memcpy(csum, sum->sums + index, sctx->csum_size);
 	if (index == num_sectors - 1) {
 		list_del(&sum->list);
@@ -2735,19 +2731,19 @@ static int scrub_extent(struct scrub_ctx *sctx, u64 logical, u64 len,
 	u32 blocksize;
 
 	if (flags & BTRFS_EXTENT_FLAG_DATA) {
-		blocksize = sctx->sectorsize;
+		blocksize = sctx->fs_info->sectorsize;
 		spin_lock(&sctx->stat_lock);
 		sctx->stat.data_extents_scrubbed++;
 		sctx->stat.data_bytes_scrubbed += len;
 		spin_unlock(&sctx->stat_lock);
 	} else if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
-		blocksize = sctx->nodesize;
+		blocksize = sctx->fs_info->nodesize;
 		spin_lock(&sctx->stat_lock);
 		sctx->stat.tree_extents_scrubbed++;
 		sctx->stat.tree_bytes_scrubbed += len;
 		spin_unlock(&sctx->stat_lock);
 	} else {
-		blocksize = sctx->sectorsize;
+		blocksize = sctx->fs_info->sectorsize;
 		WARN_ON(1);
 	}
 
@@ -2881,11 +2877,11 @@ static int scrub_extent_for_parity(struct scrub_parity *sparity,
 	}
 
 	if (flags & BTRFS_EXTENT_FLAG_DATA) {
-		blocksize = sctx->sectorsize;
+		blocksize = sctx->fs_info->sectorsize;
 	} else if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
-		blocksize = sctx->nodesize;
+		blocksize = sctx->fs_info->nodesize;
 	} else {
-		blocksize = sctx->sectorsize;
+		blocksize = sctx->fs_info->sectorsize;
 		WARN_ON(1);
 	}
 
-- 
2.12.0

