Return-Path: <SRS0=1Z4l=OC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8F2DC43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 13:45:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78795206B2
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 13:45:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="iG92SqNO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 78795206B2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439825AbeKXAaE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 23 Nov 2018 19:30:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:53534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390880AbeKXAaD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Nov 2018 19:30:03 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE313206B2
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Nov 2018 13:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1542980747;
        bh=wU3QvcWw23lODwzHNOOGlPk0MUPWIP+WaVLlM6ifx/o=;
        h=From:To:Subject:Date:From;
        b=iG92SqNOCtvj7Cyj8ltrydZ79uVI0c5nkicvwb2rv9aDqcZFz0XVNpgI8n/6pggnw
         NGr0VEGRAnbWKUpHfIAJVbuFJW+GQI8VhA8qvsf3O93rej1y+8haBu5M4DDw8bB+ZC
         P1O7Fluo0cGA8GOQqLPVZGD6Rbcx3ge4MO1Iq05k=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix deadlock with memory reclaim during scrub
Date:   Fri, 23 Nov 2018 13:45:43 +0000
Message-Id: <20181123134543.20199-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
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
GFP_NOFS for the memory allocations if there are any scrub pause requests.

Fixes: 58c4e173847a ("btrfs: scrub: use GFP_KERNEL on the submission path")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/scrub.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 3be1456b5116..5fcb9d1eb983 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2204,13 +2204,26 @@ static int scrub_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
 {
 	struct scrub_block *sblock;
 	int index;
+	bool pause_req = (atomic_read(&sctx->fs_info->scrub_pause_req) != 0);
+	unsigned int nofs_flag;
+	int ret = 0;
+
+	/*
+	 * In order to avoid deadlock with reclaim when there is a transaction
+	 * trying to pause scrub, use GFP_NOFS. The pausing request is done when
+	 * the transaction commit starts, and it blocks the transaction until
+	 * scrub is paused (done at specific points at scrub_stripe()).
+	 */
+	if (pause_req)
+		nofs_flag = memalloc_nofs_save();
 
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
@@ -2230,7 +2243,8 @@ static int scrub_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
 			sctx->stat.malloc_errors++;
 			spin_unlock(&sctx->stat_lock);
 			scrub_block_put(sblock);
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto out;
 		}
 		BUG_ON(index >= SCRUB_MAX_PAGES_PER_BLOCK);
 		scrub_page_get(spage);
@@ -2269,12 +2283,11 @@ static int scrub_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
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
 
@@ -2284,7 +2297,10 @@ static int scrub_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
 
 	/* last one frees, either here or in bio completion for last page */
 	scrub_block_put(sblock);
-	return 0;
+ out:
+	if (pause_req)
+		memalloc_nofs_restore(nofs_flag);
+	return ret;
 }
 
 static void scrub_bio_end_io(struct bio *bio)
-- 
2.11.0

