Return-Path: <SRS0=hUT/=SD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F351FC4360F
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 08:30:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD5FB20857
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 08:30:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732066AbfDAIaD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Apr 2019 04:30:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:51650 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726206AbfDAIaD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Apr 2019 04:30:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 409F2AF11
        for <linux-btrfs@vger.kernel.org>; Mon,  1 Apr 2019 08:30:02 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/2] btrfs: Switch memory allocations in async csum calculation path to kvmalloc
Date:   Mon,  1 Apr 2019 11:29:58 +0300
Message-Id: <20190401082958.26470-3-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190401082958.26470-1-nborisov@suse.com>
References: <20190401082958.26470-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

For performance reasons checksum calculation on pending writes is
performed in asynchronous context. This requires doing potentially
large order memory allocations (in my testing I've seen up to order 6 or
512k). This could put quite a strain on the slab allocator since it's
not guaranteed such a large, phisically contiguous memory allocation
can succeed - allocation could fail because of memory fragmentation in
addition to exhaustion. To add insult to injury, the code path in
question can't handle allocation failure gracefully, instead it just
BUGs.

This patch tries to alleviate the issue by switching the allocation
from using kmalloc to using kvmalloc. For small writes this is unlikely
to have any visible effect since kmalloc will still satisfy allocation
requests. For larger requests the code will just fallback to vmalloc.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/file-item.c    | 15 +++++++++++----
 fs/btrfs/ordered-data.c |  3 ++-
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 7e2cd9c81eb1..06757b67a7be 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -7,6 +7,7 @@
 #include <linux/slab.h>
 #include <linux/pagemap.h>
 #include <linux/highmem.h>
+#include <linux/sched/mm.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
@@ -427,9 +428,13 @@ blk_status_t btrfs_csum_one_bio(struct inode *inode, struct bio *bio,
 	unsigned long this_sum_bytes = 0;
 	int i;
 	u64 offset;
+	unsigned nofs_flag;
+
+	nofs_flag = memalloc_nofs_save();
+	sums = kvmalloc(btrfs_ordered_sum_size(fs_info, bio->bi_iter.bi_size),
+		       GFP_KERNEL);
+	memalloc_nofs_restore(nofs_flag);
 
-	sums = kzalloc(btrfs_ordered_sum_size(fs_info, bio->bi_iter.bi_size),
-		       GFP_NOFS);
 	if (!sums)
 		return BLK_STS_RESOURCE;
 
@@ -469,8 +474,10 @@ blk_status_t btrfs_csum_one_bio(struct inode *inode, struct bio *bio,
 
 				bytes_left = bio->bi_iter.bi_size - total_bytes;
 
-				sums = kzalloc(btrfs_ordered_sum_size(fs_info, bytes_left),
-					       GFP_NOFS);
+				nofs_flag = memalloc_nofs_save();
+				sums = kzalloc(btrfs_ordered_sum_size(fs_info,
+						      bytes_left), GFP_KERNEL);
+				memalloc_nofs_restore(nofs_flag);
 				BUG_ON(!sums); /* -ENOMEM */
 				sums->len = bytes_left;
 				ordered = btrfs_lookup_ordered_extent(inode,
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 4d9bb0dea9af..f6bb6039fa4c 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -6,6 +6,7 @@
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/writeback.h>
+#include <linux/sched/mm.h>
 #include "ctree.h"
 #include "transaction.h"
 #include "btrfs_inode.h"
@@ -441,7 +442,7 @@ void btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry)
 			cur = entry->list.next;
 			sum = list_entry(cur, struct btrfs_ordered_sum, list);
 			list_del(&sum->list);
-			kfree(sum);
+			kvfree(sum);
 		}
 		kmem_cache_free(btrfs_ordered_extent_cache, entry);
 	}
-- 
2.17.1

