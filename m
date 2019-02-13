Return-Path: <SRS0=8r0n=QU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F6ECC282CA
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 15:55:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4ACBD222E3
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 15:55:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392024AbfBMPze (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Feb 2019 10:55:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:44680 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730831AbfBMPzd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Feb 2019 10:55:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B7177AE1B
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Feb 2019 15:55:31 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/4] btrfs: Refactor cow_file_range_async
Date:   Wed, 13 Feb 2019 17:55:26 +0200
Message-Id: <20190213155529.31500-2-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190213155529.31500-1-nborisov@suse.com>
References: <20190213155529.31500-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This commit changes the implementation of cow_file_range_async in order
to get rid of the BUG_ON in the middle of the loop. Additionally it
reworks the inner loop in the hopes of making it more understandable.

Main change is that the number of chunks required to handle the given
range is calculated before going into the loop and the logic of the loop
just iterates the chunk count. Furthermore, the way memory is allocated
is reworked and now the code does a single kmalloc with enough space to
handle all chunks. Depending on whether compression is enabled or not
chunks are either 1 (in non-compress case) or the range divided by 512k.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 75 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 49 insertions(+), 26 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 05bbfd02ea49..c2180f0a5f42 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -375,6 +375,7 @@ struct async_cow {
 	unsigned int write_flags;
 	struct list_head extents;
 	struct btrfs_work work;
+	atomic_t *pending;
 };
 
 static noinline int add_async_extent(struct async_cow *cow,
@@ -1181,7 +1182,12 @@ static noinline void async_cow_free(struct btrfs_work *work)
 	async_cow = container_of(work, struct async_cow, work);
 	if (async_cow->inode)
 		btrfs_add_delayed_iput(async_cow->inode);
-	kfree(async_cow);
+	/*
+	 * Since the pointer to 'pending' is at the beginning of the array of
+	 * async_cow's, freeing it ensures the whole array has been freed.
+	 */
+	if (atomic_dec_and_test(async_cow->pending))
+		kfree(async_cow->pending);
 }
 
 static int cow_file_range_async(struct inode *inode, struct page *locked_page,
@@ -1193,42 +1199,59 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 	struct async_cow *async_cow;
 	unsigned long nr_pages;
 	u64 cur_end;
+	u64 num_chunks = DIV_ROUND_UP(end - start, SZ_512K);
+	int i;
+	bool should_compress;
+	atomic_t *p;
+
 
 	clear_extent_bit(&BTRFS_I(inode)->io_tree, start, end, EXTENT_LOCKED,
 			 1, 0, NULL);
-	while (start < end) {
-		async_cow = kmalloc(sizeof(*async_cow), GFP_NOFS);
-		BUG_ON(!async_cow); /* -ENOMEM */
-		/*
-		 * igrab is called higher up in the call chain, take only the
-		 * lightweight reference for the callback lifetime
-		 */
-		ihold(inode);
-		async_cow->inode = inode;
-		async_cow->fs_info = fs_info;
-		async_cow->locked_page = locked_page;
-		async_cow->start = start;
-		async_cow->write_flags = write_flags;
-
-		if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS &&
-		    !btrfs_test_opt(fs_info, FORCE_COMPRESS))
-			cur_end = end;
-		else
-			cur_end = min(end, start + SZ_512K - 1);
 
-		async_cow->end = cur_end;
-		INIT_LIST_HEAD(&async_cow->extents);
+	if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS &&
+	    !btrfs_test_opt(fs_info, FORCE_COMPRESS)) {
+		num_chunks = 1;
+		should_compress = false;
+	} else {
+		should_compress = true;
+	}
+
+	/* Layout is [atomic_t][async_cow1][async_cowN].... */
+	async_cow = kmalloc(sizeof(atomic_t) + num_chunks*sizeof(*async_cow),
+			    GFP_NOFS);
+	if (!async_cow)
+		return -ENOMEM;
+
+	p = (atomic_t *)async_cow;
+	async_cow = (struct async_cow *)((char *)async_cow + sizeof(atomic_t));
+	atomic_set(p, num_chunks);
+
+	for (i = 0; i < num_chunks; i++) {
 
-		btrfs_init_work(&async_cow->work,
+		if (should_compress)
+			cur_end = min(end, start + SZ_512K - 1);
+		else
+			cur_end = end;
+
+		ihold(inode);
+		async_cow[i].pending= p;
+		async_cow[i].inode = inode;
+		async_cow[i].start = start;
+		async_cow[i].end = cur_end;
+		async_cow[i].fs_info = fs_info;
+		async_cow[i].locked_page = locked_page;
+		async_cow[i].write_flags = write_flags;
+		INIT_LIST_HEAD(&async_cow[i].extents);
+
+		btrfs_init_work(&async_cow[i].work,
 				btrfs_delalloc_helper,
 				async_cow_start, async_cow_submit,
 				async_cow_free);
 
-		nr_pages = (cur_end - start + PAGE_SIZE) >>
-			PAGE_SHIFT;
+		nr_pages = DIV_ROUND_UP(cur_end - start, PAGE_SIZE);
 		atomic_add(nr_pages, &fs_info->async_delalloc_pages);
 
-		btrfs_queue_work(fs_info->delalloc_workers, &async_cow->work);
+		btrfs_queue_work(fs_info->delalloc_workers, &async_cow[i].work);
 
 		*nr_written += nr_pages;
 		start = cur_end + 1;
-- 
2.17.1

