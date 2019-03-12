Return-Path: <SRS0=uY43=RP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C217C10F00
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 15:20:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BD442054F
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 15:20:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbfCLPUi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Mar 2019 11:20:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:41138 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726427AbfCLPUh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Mar 2019 11:20:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6D437B69C
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2019 15:20:35 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/7] btrfs: Preallocate chunks in cow_file_range_async
Date:   Tue, 12 Mar 2019 17:20:24 +0200
Message-Id: <20190312152030.31987-2-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190312152030.31987-1-nborisov@suse.com>
References: <20190312152030.31987-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This commit changes the implementation of cow_file_range_async in order
to get rid of the BUG_ON in the middle of the loop. Additionally it
reworks the inner loop in the hopes of making it more understandable.

The idea is to make async_cow be a top-level structured, shared
amongst all chunks being sent for compression. This allows to perform
one memory allocation at the beginning and gracefully fail the IO if
there isn't enough memory. Now, each chunk is going to be described
by an async_chunk struct. It's the responsibility of the final chunk
to actually free the memory.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 105 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 71 insertions(+), 34 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 05bbfd02ea49..2c13915c6f71 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -366,7 +366,7 @@ struct async_extent {
 	struct list_head list;
 };
 
-struct async_cow {
+struct async_chunk {
 	struct inode *inode;
 	struct btrfs_fs_info *fs_info;
 	struct page *locked_page;
@@ -375,9 +375,15 @@ struct async_cow {
 	unsigned int write_flags;
 	struct list_head extents;
 	struct btrfs_work work;
+	atomic_t *pending;
+};
+
+struct async_cow {
+	atomic_t num_chunks; /* Number of chunks in flight */
+	struct async_chunk chunks[];
 };
 
-static noinline int add_async_extent(struct async_cow *cow,
+static noinline int add_async_extent(struct async_chunk *cow,
 				     u64 start, u64 ram_size,
 				     u64 compressed_size,
 				     struct page **pages,
@@ -447,7 +453,7 @@ static inline void inode_should_defrag(struct btrfs_inode *inode,
 static noinline void compress_file_range(struct inode *inode,
 					struct page *locked_page,
 					u64 start, u64 end,
-					struct async_cow *async_cow,
+					struct async_chunk *async_cow,
 					int *num_added)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
@@ -713,7 +719,7 @@ static void free_async_extent_pages(struct async_extent *async_extent)
  * queued.  We walk all the async extents created by compress_file_range
  * and send them down to the disk.
  */
-static noinline void submit_compressed_extents(struct async_cow *async_cow)
+static noinline void submit_compressed_extents(struct async_chunk *async_cow)
 {
 	struct inode *inode = async_cow->inode;
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
@@ -1132,9 +1138,9 @@ static noinline int cow_file_range(struct inode *inode,
  */
 static noinline void async_cow_start(struct btrfs_work *work)
 {
-	struct async_cow *async_cow;
+	struct async_chunk *async_cow;
 	int num_added = 0;
-	async_cow = container_of(work, struct async_cow, work);
+	async_cow = container_of(work, struct async_chunk, work);
 
 	compress_file_range(async_cow->inode, async_cow->locked_page,
 			    async_cow->start, async_cow->end, async_cow,
@@ -1151,10 +1157,10 @@ static noinline void async_cow_start(struct btrfs_work *work)
 static noinline void async_cow_submit(struct btrfs_work *work)
 {
 	struct btrfs_fs_info *fs_info;
-	struct async_cow *async_cow;
+	struct async_chunk *async_cow;
 	unsigned long nr_pages;
 
-	async_cow = container_of(work, struct async_cow, work);
+	async_cow = container_of(work, struct async_chunk, work);
 
 	fs_info = async_cow->fs_info;
 	nr_pages = (async_cow->end - async_cow->start + PAGE_SIZE) >>
@@ -1177,11 +1183,16 @@ static noinline void async_cow_submit(struct btrfs_work *work)
 
 static noinline void async_cow_free(struct btrfs_work *work)
 {
-	struct async_cow *async_cow;
-	async_cow = container_of(work, struct async_cow, work);
+	struct async_chunk *async_cow;
+	async_cow = container_of(work, struct async_chunk, work);
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
@@ -1190,45 +1201,71 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 				unsigned int write_flags)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
-	struct async_cow *async_cow;
+	struct async_cow *ctx;
+	struct async_chunk *async_chunk;
 	unsigned long nr_pages;
 	u64 cur_end;
+	u64 num_chunks = DIV_ROUND_UP(end - start, SZ_512K);
+	int i;
+	bool should_compress;
 
 	clear_extent_bit(&BTRFS_I(inode)->io_tree, start, end, EXTENT_LOCKED,
 			 1, 0, NULL);
-	while (start < end) {
-		async_cow = kmalloc(sizeof(*async_cow), GFP_NOFS);
-		BUG_ON(!async_cow); /* -ENOMEM */
+
+	if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS &&
+	    !btrfs_test_opt(fs_info, FORCE_COMPRESS)) {
+		num_chunks = 1;
+		should_compress = false;
+	} else {
+		should_compress = true;
+	}
+
+	ctx = kmalloc(struct_size(ctx, chunks, num_chunks), GFP_NOFS);
+	if (!ctx) {
+		unsigned clear_bits = EXTENT_LOCKED | EXTENT_DELALLOC |
+			EXTENT_DELALLOC_NEW | EXTENT_DEFRAG |
+			EXTENT_DO_ACCOUNTING;
+		unsigned long page_ops = PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
+			PAGE_SET_WRITEBACK | PAGE_END_WRITEBACK |
+			PAGE_SET_ERROR;
+		extent_clear_unlock_delalloc(inode, start, end, 0, locked_page,
+					     clear_bits, page_ops);
+		return -ENOMEM;
+	}
+
+	async_chunk = ctx->chunks;
+	atomic_set(&ctx->num_chunks, num_chunks);
+
+	for (i = 0; i < num_chunks; i++) {
+
+		if (should_compress)
+			cur_end = min(end, start + SZ_512K - 1);
+		else
+			cur_end = end;
+
 		/*
 		 * igrab is called higher up in the call chain, take only the
 		 * lightweight reference for the callback lifetime
 		 */
 		ihold(inode);
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
-
-		async_cow->end = cur_end;
-		INIT_LIST_HEAD(&async_cow->extents);
-
-		btrfs_init_work(&async_cow->work,
+		async_chunk[i].pending= &ctx->num_chunks;
+		async_chunk[i].inode = inode;
+		async_chunk[i].start = start;
+		async_chunk[i].end = cur_end;
+		async_chunk[i].fs_info = fs_info;
+		async_chunk[i].locked_page = locked_page;
+		async_chunk[i].write_flags = write_flags;
+		INIT_LIST_HEAD(&async_chunk[i].extents);
+
+		btrfs_init_work(&async_chunk[i].work,
 				btrfs_delalloc_helper,
 				async_cow_start, async_cow_submit,
 				async_cow_free);
 
-		nr_pages = (cur_end - start + PAGE_SIZE) >>
-			PAGE_SHIFT;
+		nr_pages = DIV_ROUND_UP(cur_end - start, PAGE_SIZE);
 		atomic_add(nr_pages, &fs_info->async_delalloc_pages);
 
-		btrfs_queue_work(fs_info->delalloc_workers, &async_cow->work);
+		btrfs_queue_work(fs_info->delalloc_workers, &async_chunk[i].work);
 
 		*nr_written += nr_pages;
 		start = cur_end + 1;
-- 
2.17.1

