Return-Path: <SRS0=uY43=RP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D713FC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 15:20:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACF762054F
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 15:20:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfCLPUt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Mar 2019 11:20:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:41162 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726452AbfCLPUh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Mar 2019 11:20:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BE958B69E
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2019 15:20:35 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/7] btrfs: Rename async_cow to async_chunk
Date:   Tue, 12 Mar 2019 17:20:25 +0200
Message-Id: <20190312152030.31987-3-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190312152030.31987-1-nborisov@suse.com>
References: <20190312152030.31987-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Now that we have an explicit async_chunk struct rename references to
variables of this type to async_chunk. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 60 ++++++++++++++++++++++++------------------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2c13915c6f71..be3777d03c80 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -453,7 +453,7 @@ static inline void inode_should_defrag(struct btrfs_inode *inode,
 static noinline void compress_file_range(struct inode *inode,
 					struct page *locked_page,
 					u64 start, u64 end,
-					struct async_chunk *async_cow,
+					struct async_chunk *async_chunk,
 					int *num_added)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
@@ -636,7 +636,7 @@ static noinline void compress_file_range(struct inode *inode,
 			 * allocation on disk for these compressed pages, and
 			 * will submit them to the elevator.
 			 */
-			add_async_extent(async_cow, start, total_in,
+			add_async_extent(async_chunk, start, total_in,
 					total_compressed, pages, nr_pages,
 					compress_type);
 
@@ -683,7 +683,7 @@ static noinline void compress_file_range(struct inode *inode,
 
 	if (redirty)
 		extent_range_redirty_for_io(inode, start, end);
-	add_async_extent(async_cow, start, end - start + 1, 0, NULL, 0,
+	add_async_extent(async_chunk, start, end - start + 1, 0, NULL, 0,
 			 BTRFS_COMPRESS_NONE);
 	*num_added += 1;
 
@@ -719,9 +719,9 @@ static void free_async_extent_pages(struct async_extent *async_extent)
  * queued.  We walk all the async extents created by compress_file_range
  * and send them down to the disk.
  */
-static noinline void submit_compressed_extents(struct async_chunk *async_cow)
+static noinline void submit_compressed_extents(struct async_chunk *async_chunk)
 {
-	struct inode *inode = async_cow->inode;
+	struct inode *inode = async_chunk->inode;
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct async_extent *async_extent;
 	u64 alloc_hint = 0;
@@ -732,8 +732,8 @@ static noinline void submit_compressed_extents(struct async_chunk *async_cow)
 	int ret = 0;
 
 again:
-	while (!list_empty(&async_cow->extents)) {
-		async_extent = list_entry(async_cow->extents.next,
+	while (!list_empty(&async_chunk->extents)) {
+		async_extent = list_entry(async_chunk->extents.next,
 					  struct async_extent, list);
 		list_del(&async_extent->list);
 
@@ -750,7 +750,7 @@ static noinline void submit_compressed_extents(struct async_chunk *async_cow)
 					 async_extent->ram_size - 1);
 
 			/* allocate blocks */
-			ret = cow_file_range(inode, async_cow->locked_page,
+			ret = cow_file_range(inode, async_chunk->locked_page,
 					     async_extent->start,
 					     async_extent->start +
 					     async_extent->ram_size - 1,
@@ -774,7 +774,7 @@ static noinline void submit_compressed_extents(struct async_chunk *async_cow)
 						  async_extent->ram_size - 1,
 						  WB_SYNC_ALL);
 			else if (ret)
-				unlock_page(async_cow->locked_page);
+				unlock_page(async_chunk->locked_page);
 			kfree(async_extent);
 			cond_resched();
 			continue;
@@ -861,7 +861,7 @@ static noinline void submit_compressed_extents(struct async_chunk *async_cow)
 				    ins.objectid,
 				    ins.offset, async_extent->pages,
 				    async_extent->nr_pages,
-				    async_cow->write_flags)) {
+				    async_chunk->write_flags)) {
 			struct page *p = async_extent->pages[0];
 			const u64 start = async_extent->start;
 			const u64 end = start + async_extent->ram_size - 1;
@@ -1138,16 +1138,16 @@ static noinline int cow_file_range(struct inode *inode,
  */
 static noinline void async_cow_start(struct btrfs_work *work)
 {
-	struct async_chunk *async_cow;
+	struct async_chunk *async_chunk;
 	int num_added = 0;
-	async_cow = container_of(work, struct async_chunk, work);
+	async_chunk = container_of(work, struct async_chunk, work);
 
-	compress_file_range(async_cow->inode, async_cow->locked_page,
-			    async_cow->start, async_cow->end, async_cow,
+	compress_file_range(async_chunk->inode, async_chunk->locked_page,
+			    async_chunk->start, async_chunk->end, async_chunk,
 			    &num_added);
 	if (num_added == 0) {
-		btrfs_add_delayed_iput(async_cow->inode);
-		async_cow->inode = NULL;
+		btrfs_add_delayed_iput(async_chunk->inode);
+		async_chunk->inode = NULL;
 	}
 }
 
@@ -1157,13 +1157,13 @@ static noinline void async_cow_start(struct btrfs_work *work)
 static noinline void async_cow_submit(struct btrfs_work *work)
 {
 	struct btrfs_fs_info *fs_info;
-	struct async_chunk *async_cow;
+	struct async_chunk *async_chunk;
 	unsigned long nr_pages;
 
-	async_cow = container_of(work, struct async_chunk, work);
+	async_chunk = container_of(work, struct async_chunk, work);
 
-	fs_info = async_cow->fs_info;
-	nr_pages = (async_cow->end - async_cow->start + PAGE_SIZE) >>
+	fs_info = async_chunk->fs_info;
+	nr_pages = (async_chunk->end - async_chunk->start + PAGE_SIZE) >>
 		PAGE_SHIFT;
 
 	/* atomic_sub_return implies a barrier */
@@ -1172,27 +1172,27 @@ static noinline void async_cow_submit(struct btrfs_work *work)
 		cond_wake_up_nomb(&fs_info->async_submit_wait);
 
 	/*
-	 * ->inode could be NULL if async_cow_start has failed to compress,
+	 * ->inode could be NULL if async_chunk_start has failed to compress,
 	 * in which case we don't have anything to submit, yet we need to
 	 * always adjust ->async_delalloc_pages as its paired with the init
 	 * happening in cow_file_range_async
 	 */
-	if (async_cow->inode)
-		submit_compressed_extents(async_cow);
+	if (async_chunk->inode)
+		submit_compressed_extents(async_chunk);
 }
 
 static noinline void async_cow_free(struct btrfs_work *work)
 {
-	struct async_chunk *async_cow;
-	async_cow = container_of(work, struct async_chunk, work);
-	if (async_cow->inode)
-		btrfs_add_delayed_iput(async_cow->inode);
+	struct async_chunk *async_chunk;
+	async_chunk = container_of(work, struct async_chunk, work);
+	if (async_chunk->inode)
+		btrfs_add_delayed_iput(async_chunk->inode);
 	/*
 	 * Since the pointer to 'pending' is at the beginning of the array of
-	 * async_cow's, freeing it ensures the whole array has been freed.
+	 * async_chunk's, freeing it ensures the whole array has been freed.
 	 */
-	if (atomic_dec_and_test(async_cow->pending))
-		kfree(async_cow->pending);
+	if (atomic_dec_and_test(async_chunk->pending))
+		kfree(async_chunk->pending);
 }
 
 static int cow_file_range_async(struct inode *inode, struct page *locked_page,
-- 
2.17.1

