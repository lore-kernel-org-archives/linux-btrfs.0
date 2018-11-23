Return-Path: <SRS0=1Z4l=OC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A22A9C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 16:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 689CB20659
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 16:05:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pr+9+N1V"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 689CB20659
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632801AbeKXCuY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 23 Nov 2018 21:50:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:42646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2632797AbeKXCuY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Nov 2018 21:50:24 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BA3120659
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Nov 2018 16:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1542989136;
        bh=ZCnaqaquUB0xxk75tKPFuBN+fbu61uX8yo+vFQZnpcY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Pr+9+N1V/GIVXV597KDjUUfaN8St5kBy1CJZ0R3qrpfkJGiOvO4iRtPOYQ0fLg2hM
         Xvg/8y69qnDz5o3K8zocs5//XfQTumStTLwgcsOsJiNLbpjhiZZyrV3XnP7KPNrnrx
         mdgTKE1Z0TH1yIGa7rl5A3+wF13x93+9tCn59GEk=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2] Btrfs: fix deadlock with memory reclaim during scrub
Date:   Fri, 23 Nov 2018 16:05:33 +0000
Message-Id: <20181123160533.21204-1-fdmanana@kernel.org>
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

 fs/btrfs/scrub.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 3be1456b5116..0630ea0881bc 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2205,7 +2205,13 @@ static int scrub_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
 	struct scrub_block *sblock;
 	int index;
 
-	sblock = kzalloc(sizeof(*sblock), GFP_KERNEL);
+	/*
+	 * In order to avoid deadlock with reclaim when there is a transaction
+	 * trying to pause scrub, use GFP_NOFS. The pausing request is done when
+	 * the transaction commit starts, and it blocks the transaction until
+	 * scrub is paused (done at specific points at scrub_stripe()).
+	 */
+	sblock = kzalloc(sizeof(*sblock), GFP_NOFS);
 	if (!sblock) {
 		spin_lock(&sctx->stat_lock);
 		sctx->stat.malloc_errors++;
@@ -2223,7 +2229,7 @@ static int scrub_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
 		struct scrub_page *spage;
 		u64 l = min_t(u64, len, PAGE_SIZE);
 
-		spage = kzalloc(sizeof(*spage), GFP_KERNEL);
+		spage = kzalloc(sizeof(*spage), GFP_NOFS);
 		if (!spage) {
 leave_nomem:
 			spin_lock(&sctx->stat_lock);
@@ -2250,7 +2256,7 @@ static int scrub_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
 			spage->have_csum = 0;
 		}
 		sblock->page_count++;
-		spage->page = alloc_page(GFP_KERNEL);
+		spage->page = alloc_page(GFP_NOFS);
 		if (!spage->page)
 			goto leave_nomem;
 		len -= l;
-- 
2.11.0

