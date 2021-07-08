Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60FD3C07E96
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Jul 2021 11:47:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 402146143A
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Jul 2021 11:47:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbhGHLuh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 8 Jul 2021 07:50:37 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:56176 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231628AbhGHLug (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Jul 2021 07:50:36 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 471AA201B9;
        Thu,  8 Jul 2021 11:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625744874; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zcA1IBeFAvT4jDeBPE8P/tAogiUmECYu6EAvOsxtw0k=;
        b=VeaxIgqeSMawGbwfflslSoanxM2+7q6VFBPjcHUc11Mwdp4GEQWgGdl6/ba1vwqoZn4Oh7
        OOeKnoD6gbChVodcFGveufqFRoxhsBRyroRlFAfqwjSqi44Iro6fd3rFuGIl2CxKZ+nllN
        iPz8QXQXqD2C+WRKd1D0BGYHP4Sftkk=
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 3F509A3B89;
        Thu,  8 Jul 2021 11:47:54 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 2C1DEDAF79; Thu,  8 Jul 2021 13:45:20 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 6/6] btrfs: check-integrity: drop kmap/kunmap for block pages
Date:   Thu,  8 Jul 2021 13:45:20 +0200
Message-Id: <0208f5f269b262e6c328a3a8ca041b7986bfb3e7.1625043706.git.dsterba@suse.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1625043706.git.dsterba@suse.com>
References: <cover.1625043706.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pages in block_ctx have never been allocated from highmem (in
btrfsic_read_block) so the mapping is pointless and can be removed.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/check-integrity.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 169508609324..232dd3f85ac0 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -1558,10 +1558,8 @@ static void btrfsic_release_block_ctx(struct btrfsic_block_data_ctx *block_ctx)
 		/* Pages must be unmapped in reverse order */
 		while (num_pages > 0) {
 			num_pages--;
-			if (block_ctx->datav[num_pages]) {
-				kunmap_local(block_ctx->datav[num_pages]);
+			if (block_ctx->datav[num_pages])
 				block_ctx->datav[num_pages] = NULL;
-			}
 			if (block_ctx->pagev[num_pages]) {
 				__free_page(block_ctx->pagev[num_pages]);
 				block_ctx->pagev[num_pages] = NULL;
@@ -1638,7 +1636,7 @@ static int btrfsic_read_block(struct btrfsic_state *state,
 		i = j;
 	}
 	for (i = 0; i < num_pages; i++)
-		block_ctx->datav[i] = kmap_local_page(block_ctx->pagev[i]);
+		block_ctx->datav[i] = page_address(block_ctx->pagev[i]);
 
 	return block_ctx->len;
 }
@@ -2703,7 +2701,7 @@ static void __btrfsic_submit_bio(struct bio *bio)
 
 		bio_for_each_segment(bvec, bio, iter) {
 			BUG_ON(bvec.bv_len != PAGE_SIZE);
-			mapped_datav[i] = kmap_local_page(bvec.bv_page);
+			mapped_datav[i] = page_address(bvec.bv_page);
 			i++;
 
 			if (dev_state->state->print_mask &
@@ -2716,9 +2714,6 @@ static void __btrfsic_submit_bio(struct bio *bio)
 					      mapped_datav, segs,
 					      bio, &bio_is_patched,
 					      bio->bi_opf);
-		/* Unmap in reverse order */
-		for (--i; i >= 0; i--)
-			kunmap_local(mapped_datav[i]);
 		kfree(mapped_datav);
 	} else if (NULL != dev_state && (bio->bi_opf & REQ_PREFLUSH)) {
 		if (dev_state->state->print_mask &
-- 
2.31.1

