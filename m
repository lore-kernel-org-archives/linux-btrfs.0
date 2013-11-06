Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:44951 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711Ab3KFUz5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Nov 2013 15:55:57 -0500
Received: by mail-pa0-f43.google.com with SMTP id hz1so222968pad.2
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Nov 2013 12:55:56 -0800 (PST)
Date: Thu, 7 Nov 2013 02:25:50 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: opw-kernel@googlegroups.com, linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs:check-integrity.c: replace kmalloc with
 kmalloc_array and kzalloc with kzalloc_array.
Message-ID: <20131106205550.GA11060@himangi-Inspiron-N5110gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch replaces kmalloc(size * nr, ) with kmalloc_array(nr, size)
as kmalloc_array() is preferred because it can check that the
calculation doesn't wrap and won't return a smaller allocation.
Also kzalloc(size * nr) was replaced with kzalloc_array().

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
---
 fs/btrfs/check-integrity.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 1c47be1..925a52b 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -1660,9 +1660,10 @@ static int btrfsic_read_block(struct btrfsic_state *state,
 
 	num_pages = (block_ctx->len + (u64)PAGE_CACHE_SIZE - 1) >>
 		    PAGE_CACHE_SHIFT;
-	block_ctx->mem_to_free = kzalloc((sizeof(*block_ctx->datav) +
-					  sizeof(*block_ctx->pagev)) *
-					 num_pages, GFP_NOFS);
+	block_ctx->mem_to_free = kzalloc_array(num_pages,
+						(sizeof(*block_ctx->datav) +
+						 sizeof(*block_ctx->pagev)),
+						GFP_NOFS);
 	if (!block_ctx->mem_to_free)
 		return -1;
 	block_ctx->datav = block_ctx->mem_to_free;
@@ -3031,8 +3032,9 @@ void btrfsic_submit_bio(int rw, struct bio *bio)
 			       (unsigned long long)bio->bi_sector, dev_bytenr,
 			       bio->bi_bdev);
 
-		mapped_datav = kmalloc(sizeof(*mapped_datav) * bio->bi_vcnt,
-				       GFP_NOFS);
+		mapped_datav = kmalloc_array(bio->bi_vcnt,
+					     sizeof(*mapped_datav),
+					     GFP_NOFS);
 		if (!mapped_datav)
 			goto leave;
 		for (i = 0; i < bio->bi_vcnt; i++) {
-- 
1.7.9.5

