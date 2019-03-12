Return-Path: <SRS0=uY43=RP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1956EC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 15:20:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF7132054F
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 15:20:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbfCLPUk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Mar 2019 11:20:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:41194 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726689AbfCLPUi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Mar 2019 11:20:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 57F4EB69F
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2019 15:20:37 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 7/7] btrfs: Factor out common extent locking code in submit_compressed_extents
Date:   Tue, 12 Mar 2019 17:20:30 +0200
Message-Id: <20190312152030.31987-8-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190312152030.31987-1-nborisov@suse.com>
References: <20190312152030.31987-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Irrespective of whether the compress code fell back to uncompressed or
a compressed extent has to be submitted, the extent range is always
locked. So factor out the common lock_extent call at the beginning of
the loop. No functional changes just removes one duplicate lock_extent
call.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f5bd6fb840a5..9fd7cd453a54 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -736,15 +736,14 @@ static noinline void submit_compressed_extents(struct async_chunk *async_chunk)
 					  struct async_extent, list);
 		list_del(&async_extent->list);
 retry:
+
+		lock_extent(io_tree, async_extent->start,
+			    async_extent->start + async_extent->ram_size - 1);
 		/* did the compression code fall back to uncompressed IO? */
 		if (!async_extent->pages) {
 			int page_started = 0;
 			unsigned long nr_written = 0;
 
-			lock_extent(io_tree, async_extent->start,
-					 async_extent->start +
-					 async_extent->ram_size - 1);
-
 			/* allocate blocks */
 			ret = cow_file_range(inode, async_chunk->locked_page,
 					     async_extent->start,
@@ -776,9 +775,6 @@ static noinline void submit_compressed_extents(struct async_chunk *async_chunk)
 			continue;
 		}
 
-		lock_extent(io_tree, async_extent->start,
-			    async_extent->start + async_extent->ram_size - 1);
-
 		ret = btrfs_reserve_extent(root, async_extent->ram_size,
 					   async_extent->compressed_size,
 					   async_extent->compressed_size,
-- 
2.17.1

