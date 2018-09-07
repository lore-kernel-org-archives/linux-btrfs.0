Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:34576 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726151AbeIGWmP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Sep 2018 18:42:15 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: use correct args for kcalloc in btrfsic_read_block
Date: Sat,  8 Sep 2018 01:59:50 +0800
Message-Id: <1536343190-400-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

kcalloc is defined as
kcalloc(size_t n, size_t size, gfp_t flags)

Although this won't cause problems in practice, btrfsic_read_block()
has switched n with size.

This updates btrfsic_read_block() to be correct in using kcalloc.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 fs/btrfs/check-integrity.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 833cf3c35b4d..651b75939ce9 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -1594,6 +1594,7 @@ static int btrfsic_read_block(struct btrfsic_state *state,
 {
 	unsigned int num_pages;
 	unsigned int i;
+	u64 size;
 	u64 dev_bytenr;
 	int ret;
 
@@ -1608,9 +1609,8 @@ static int btrfsic_read_block(struct btrfsic_state *state,
 
 	num_pages = (block_ctx->len + (u64)PAGE_SIZE - 1) >>
 		    PAGE_SHIFT;
-	block_ctx->mem_to_free = kcalloc(sizeof(*block_ctx->datav) +
-						sizeof(*block_ctx->pagev),
-					 num_pages, GFP_NOFS);
+	size = sizeof(*block_ctx->datav) + sizeof(*block_ctx->pagev);
+	block_ctx->mem_to_free = kcalloc(num_pages, size, GFP_NOFS);
 	if (!block_ctx->mem_to_free)
 		return -ENOMEM;
 	block_ctx->datav = block_ctx->mem_to_free;
-- 
1.8.3.1
