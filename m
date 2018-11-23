Return-Path: <SRS0=1Z4l=OC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8AF7C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 16:41:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8179220659
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 16:41:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="D0mcxhox"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8179220659
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440667AbeKXD0q (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 23 Nov 2018 22:26:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:51570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730360AbeKXD0q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Nov 2018 22:26:46 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5251E20659
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Nov 2018 16:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1542991308;
        bh=R6rNRI+MhP8Igdos5ocsD8ataZGcB1Xegqp8fQg1jK0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=D0mcxhox6wxtMl14DUPoHPNHEf+lxvvta03W4VaKxm6R6pR0157GeTnK2LxIVNdbl
         T7ZHXMAtzOqDapul9TIfeV2Odlvb0iBCZl3g+1ixzhTxIoXPI3nvGx+9kdOcS6Ez/W
         cF7p+MOhmzxottb4HShDbexNA76b2aSWhWCiInto=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v3] Btrfs: fix deadlock with memory reclaim during scrub
Date:   Fri, 23 Nov 2018 16:41:45 +0000
Message-Id: <20181123164145.32027-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20181123134543.20199-1-fdmanana@kernel.org>
References: <20181123134543.20199-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

When a transaction commit starts, it attempts to pause scrub and it blocks
until the scrub is paused. So while the transaction is blocked waiting for
scrub to pause, we can not do memory allocation with GFP_KERNEL while scrub
is running, we must use GFP_NOS to avoid deadlock with reclaim. Checking
for pause requests is done early in the while loop of scrub_stripe(), and
later in the loop, scrub_extent() is called, which in turns calls
scrub_pages(), which does memory allocations using GFP_KERNEL. So use
GFP_NOFS for the memory allocations because at any time a scrub pause
request can happen from another task that started to commit a transaction.

Fixes: 58c4e173847a ("btrfs: scrub: use GFP_KERNEL on the submission path")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Make using GFP_NOFS unconditionial. Previous version was racy, as pausing
requests migth happen just after we checked for them.

V3: Use memalloc_nofs_save() just like V1 did.

 fs/btrfs/scrub.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 3be1456b5116..8e9ead5073ec 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2204,13 +2204,24 @@ static int scrub_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
 {
 	struct scrub_block *sblock;
 	int index;
+	unsigned int nofs_flag;
+	int ret = 0;
+
+	/*
+	 * In order to avoid deadlock with reclaim when there is a transaction
+	 * trying to pause scrub, use GFP_NOFS. The pausing request is done when
+	 * the transaction commit starts, and it blocks the transaction until
+	 * scrub is paused (done at specific points at scrub_stripe()).
+	 */
+	nofs_flag = memalloc_nofs_save();
 
 	sblock = kzalloc(sizeof(*sblock), GFP_KERNEL);
 	if (!sblock) {
 		spin_lock(&sctx->stat_lock);
 		sctx->stat.malloc_errors++;
 		spin_unlock(&sctx->stat_lock);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out;
 	}
 
 	/* one ref inside this function, plus one for each page added to
@@ -2230,7 +2241,8 @@ static int scrub_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
 			sctx->stat.malloc_errors++;
 			spin_unlock(&sctx->stat_lock);
 			scrub_block_put(sblock);
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto out;
 		}
 		BUG_ON(index >= SCRUB_MAX_PAGES_PER_BLOCK);
 		scrub_page_get(spage);
@@ -2269,12 +2281,11 @@ static int scrub_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
 	} else {
 		for (index = 0; index < sblock->page_count; index++) {
 			struct scrub_page *spage = sblock->pagev[index];
-			int ret;
 
 			ret = scrub_add_page_to_rd_bio(sctx, spage);
 			if (ret) {
 				scrub_block_put(sblock);
-				return ret;
+				goto out;
 			}
 		}
 
@@ -2284,7 +2295,9 @@ static int scrub_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
 
 	/* last one frees, either here or in bio completion for last page */
 	scrub_block_put(sblock);
-	return 0;
+out:
+	memalloc_nofs_restore(nofs_flag);
+	return ret;
 }
 
 static void scrub_bio_end_io(struct bio *bio)
-- 
2.11.0

