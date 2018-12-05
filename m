Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2AC4C07E85
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 14:23:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84CA82083F
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 14:23:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 84CA82083F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbeLEOXO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 09:23:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:46006 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727337AbeLEOXO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 09:23:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DFAABAD4C
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Dec 2018 14:23:12 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 2/3] btrfs: use PAGE_ALIGNED instead of open-coding it
Date:   Wed,  5 Dec 2018 15:23:04 +0100
Message-Id: <20181205142305.15361-3-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20181205142305.15361-1-jthumshirn@suse.de>
References: <20181205142305.15361-1-jthumshirn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

When using a 'var & (PAGE_SIZE - 1)' construct one is checking for a page
alignment and thus should use the PAGE_ALIGNED() macro instead of
open-coding it.

Convert all open-coded occurrences of PAGE_ALIGNED().

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 fs/btrfs/check-integrity.c | 8 ++++----
 fs/btrfs/compression.c     | 2 +-
 fs/btrfs/inode.c           | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index d319c3020c09..84e9729badaa 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -1601,7 +1601,7 @@ static int btrfsic_read_block(struct btrfsic_state *state,
 	BUG_ON(block_ctx->datav);
 	BUG_ON(block_ctx->pagev);
 	BUG_ON(block_ctx->mem_to_free);
-	if (block_ctx->dev_bytenr & ((u64)PAGE_SIZE - 1)) {
+	if (!PAGE_ALIGNED(block_ctx->dev_bytenr)) {
 		pr_info("btrfsic: read_block() with unaligned bytenr %llu\n",
 		       block_ctx->dev_bytenr);
 		return -1;
@@ -1778,7 +1778,7 @@ static void btrfsic_process_written_block(struct btrfsic_dev_state *dev_state,
 				return;
 			}
 			is_metadata = 1;
-			BUG_ON(BTRFS_SUPER_INFO_SIZE & (PAGE_SIZE - 1));
+			BUG_ON(!PAGE_ALIGNED(BTRFS_SUPER_INFO_SIZE));
 			processed_len = BTRFS_SUPER_INFO_SIZE;
 			if (state->print_mask &
 			    BTRFSIC_PRINT_MASK_TREE_BEFORE_SB_WRITE) {
@@ -2892,12 +2892,12 @@ int btrfsic_mount(struct btrfs_fs_info *fs_info,
 	struct list_head *dev_head = &fs_devices->devices;
 	struct btrfs_device *device;
 
-	if (fs_info->nodesize & ((u64)PAGE_SIZE - 1)) {
+	if (!PAGE_ALIGNED(fs_info->nodesize)) {
 		pr_info("btrfsic: cannot handle nodesize %d not being a multiple of PAGE_SIZE %ld!\n",
 		       fs_info->nodesize, PAGE_SIZE);
 		return -1;
 	}
-	if (fs_info->sectorsize & ((u64)PAGE_SIZE - 1)) {
+	if (!PAGE_ALIGNED(fs_info->sectorsize)) {
 		pr_info("btrfsic: cannot handle sectorsize %d not being a multiple of PAGE_SIZE %ld!\n",
 		       fs_info->sectorsize, PAGE_SIZE);
 		return -1;
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 2ab5591449f2..d5381f39a9e8 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -301,7 +301,7 @@ blk_status_t btrfs_submit_compressed_write(struct inode *inode, u64 start,
 	blk_status_t ret;
 	int skip_sum = BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM;
 
-	WARN_ON(start & ((u64)PAGE_SIZE - 1));
+	WARN_ON(!PAGE_ALIGNED(start));
 	cb = kmalloc(compressed_bio_size(fs_info, compressed_len), GFP_NOFS);
 	if (!cb)
 		return BLK_STS_RESOURCE;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index bc0564c384de..5c52e91b01e8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2027,7 +2027,7 @@ int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
 			      unsigned int extra_bits,
 			      struct extent_state **cached_state, int dedupe)
 {
-	WARN_ON((end & (PAGE_SIZE - 1)) == 0);
+	WARN_ON(PAGE_ALIGNED(end));
 	return set_extent_delalloc(&BTRFS_I(inode)->io_tree, start, end,
 				   extra_bits, cached_state);
 }
-- 
2.16.4

