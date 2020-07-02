Return-Path: <SRS0=RJN2=AN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B21AC433DF
	for <linux-btrfs@archiver.kernel.org>; Thu,  2 Jul 2020 13:47:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74DF72088E
	for <linux-btrfs@archiver.kernel.org>; Thu,  2 Jul 2020 13:47:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729457AbgGBNrB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 2 Jul 2020 09:47:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:45862 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729441AbgGBNq4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Jul 2020 09:46:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 39593B16F;
        Thu,  2 Jul 2020 13:46:54 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 08/10] btrfs: Remove fail1 label in btrfs_submit_compressed_read
Date:   Thu,  2 Jul 2020 16:46:48 +0300
Message-Id: <20200702134650.16550-9-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200702134650.16550-1-nborisov@suse.com>
References: <20200702134650.16550-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/compression.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 48ceab7be0fe..2033ce17e5c6 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -703,8 +703,10 @@ blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	nr_pages = DIV_ROUND_UP(compressed_len, PAGE_SIZE);
 	cb->compressed_pages = kcalloc(nr_pages, sizeof(struct page *),
 				       GFP_NOFS);
-	if (!cb->compressed_pages)
-		goto fail1;
+	if (!cb->compressed_pages) {
+		kfree(cb);
+		return BLK_STS_RESOURCE;
+	}
 
 	for (pg_index = 0; pg_index < nr_pages; pg_index++) {
 		cb->compressed_pages[pg_index] = alloc_page(GFP_NOFS |
@@ -806,7 +808,6 @@ blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	}
 
 	kfree(cb->compressed_pages);
-fail1:
 	kfree(cb);
 out:
 	free_extent_map(em);
-- 
2.17.1

