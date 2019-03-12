Return-Path: <SRS0=uY43=RP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E2DCC4360F
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 15:20:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3D032054F
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 15:20:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbfCLPUj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Mar 2019 11:20:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:41188 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726684AbfCLPUi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Mar 2019 11:20:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0CAE1B6A1
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2019 15:20:37 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 6/7] btrfs: Set iotree only once in submit_compressed_extents
Date:   Tue, 12 Mar 2019 17:20:29 +0200
Message-Id: <20190312152030.31987-7-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190312152030.31987-1-nborisov@suse.com>
References: <20190312152030.31987-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The inode never changes so it's sufficient to dereference it and get
the iotree only once, before the execution of the main loop. No
functional changes, only the size of the function is decreased:

add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-44 (-44)
Function                                     old     new   delta
submit_compressed_extents                   1240    1196     -44
Total: Before=88476, After=88432, chg -0.05%

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0123f7067c8a..f5bd6fb840a5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -727,7 +727,7 @@ static noinline void submit_compressed_extents(struct async_chunk *async_chunk)
 	struct btrfs_key ins;
 	struct extent_map *em;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct extent_io_tree *io_tree;
+	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	int ret = 0;
 
 again:
@@ -735,9 +735,6 @@ static noinline void submit_compressed_extents(struct async_chunk *async_chunk)
 		async_extent = list_entry(async_chunk->extents.next,
 					  struct async_extent, list);
 		list_del(&async_extent->list);
-
-		io_tree = &BTRFS_I(inode)->io_tree;
-
 retry:
 		/* did the compression code fall back to uncompressed IO? */
 		if (!async_extent->pages) {
-- 
2.17.1

