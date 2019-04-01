Return-Path: <SRS0=hUT/=SD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8F54C10F05
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 08:30:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 890D820857
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 08:30:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732029AbfDAIaD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Apr 2019 04:30:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:51638 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732000AbfDAIaD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Apr 2019 04:30:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F09E9AED7
        for <linux-btrfs@vger.kernel.org>; Mon,  1 Apr 2019 08:30:01 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/2] btrfs: Use kvmalloc for allocating compressed path context
Date:   Mon,  1 Apr 2019 11:29:57 +0300
Message-Id: <20190401082958.26470-2-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190401082958.26470-1-nborisov@suse.com>
References: <20190401082958.26470-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Recent refactoring of cow_file_range_async means it's now possible to
request a rather large physically contiguous memory via kmalloc. The
size is dependent on the number of 512k chunks that the compressed range
consists of. David reported multiple OOM messages on such large
allocations. Fix it by switching to using kvmalloc.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 43ee890c715f..85f61913b92d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -28,6 +28,7 @@
 #include <linux/magic.h>
 #include <linux/iversion.h>
 #include <linux/swap.h>
+#include <linux/sched/mm.h>
 #include <asm/unaligned.h>
 #include "ctree.h"
 #include "disk-io.h"
@@ -1172,7 +1173,7 @@ static noinline void async_cow_free(struct btrfs_work *work)
 	 * async_chunk's, freeing it ensures the whole array has been freed.
 	 */
 	if (atomic_dec_and_test(async_chunk->pending))
-		kfree(async_chunk->pending);
+		kvfree(async_chunk->pending);
 }
 
 static int cow_file_range_async(struct inode *inode, struct page *locked_page,
@@ -1188,6 +1189,7 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 	u64 num_chunks = DIV_ROUND_UP(end - start, SZ_512K);
 	int i;
 	bool should_compress;
+	unsigned nofs_flag;
 
 	unlock_extent(&BTRFS_I(inode)->io_tree, start, end);
 
@@ -1199,7 +1201,10 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 		should_compress = true;
 	}
 
-	ctx = kmalloc(struct_size(ctx, chunks, num_chunks), GFP_NOFS);
+	nofs_flag = memalloc_nofs_save();
+	ctx = kvmalloc(struct_size(ctx, chunks, num_chunks), GFP_KERNEL);
+	memalloc_nofs_restore(nofs_flag);
+
 	if (!ctx) {
 		unsigned clear_bits = EXTENT_LOCKED | EXTENT_DELALLOC |
 			EXTENT_DELALLOC_NEW | EXTENT_DEFRAG |
-- 
2.17.1

