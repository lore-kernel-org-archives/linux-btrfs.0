Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33482 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751936AbdHARP4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 13:15:56 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v71HFsZg002160
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:55 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v71HFsgS021635
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:54 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v71HFsTe032281
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:54 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 09/14] Btrfs: raid56: add readahead for recovery
Date: Tue,  1 Aug 2017 10:14:32 -0600
Message-Id: <20170801161439.13426-10-bo.li.liu@oracle.com>
In-Reply-To: <20170801161439.13426-1-bo.li.liu@oracle.com>
References: <20170801161439.13426-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While doing recovery, blocks are read from the raid5/6 disk one by
one, so this is adding readahead so that we can read at most 256
contiguous blocks in one read IO.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/raid56.c | 114 +++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 109 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index dea33c4..24f7cbb 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1530,15 +1530,81 @@ static int btrfs_r5l_write_empty_meta_block(struct btrfs_r5l_log *log, u64 pos,
 	return ret;
 }
 
+#define BTRFS_R5L_RECOVER_IO_POOL_SIZE BIO_MAX_PAGES
 struct btrfs_r5l_recover_ctx {
 	u64 pos;
 	u64 seq;
 	u64 total_size;
 	struct page *meta_page;
 	struct page *io_page;
+
+	struct page *ra_pages[BTRFS_R5L_RECOVER_IO_POOL_SIZE];
+	struct bio *ra_bio;
+	int total;
+	int valid;
+	u64 start_offset;
+
+	struct btrfs_r5l_log *log;
 };
 
-static int btrfs_r5l_recover_load_meta(struct btrfs_r5l_log *log, struct btrfs_r5l_recover_ctx *ctx)
+static int btrfs_r5l_recover_read_ra(struct btrfs_r5l_recover_ctx *ctx, u64 offset)
+{
+	bio_reset(ctx->ra_bio);
+	ctx->ra_bio->bi_bdev = ctx->log->dev->bdev;
+	ctx->ra_bio->bi_opf = REQ_OP_READ;
+	ctx->ra_bio->bi_iter.bi_sector = (ctx->log->data_offset + offset) >> 9;
+
+	ctx->valid = 0;
+	ctx->start_offset = offset;
+
+	while (ctx->valid < ctx->total) {
+		bio_add_page(ctx->ra_bio, ctx->ra_pages[ctx->valid++], PAGE_SIZE, 0);
+
+		offset = btrfs_r5l_ring_add(ctx->log, offset, PAGE_SIZE);
+		if (offset == 0)
+			break;
+	}
+
+#ifdef BTRFS_DEBUG_R5LOG
+	trace_printk("to read %d pages starting from 0x%llx\n", ctx->valid, ctx->log->data_offset + ctx->start_offset);
+#endif
+	return submit_bio_wait(ctx->ra_bio);
+}
+
+static int btrfs_r5l_recover_read_page(struct btrfs_r5l_recover_ctx *ctx, struct page *page, u64 offset)
+{
+	struct page *tmp;
+	int index;
+	char *src;
+	char *dst;
+	int ret;
+
+	if (offset < ctx->start_offset || offset >= (ctx->start_offset + ctx->valid * PAGE_SIZE)) {
+		ret = btrfs_r5l_recover_read_ra(ctx, offset);
+		if (ret)
+			return ret;
+	}
+
+#ifdef BTRFS_DEBUG_R5LOG
+	trace_printk("offset 0x%llx start->offset 0x%llx ctx->valid %d\n", offset, ctx->start_offset, ctx->valid);
+#endif
+
+	ASSERT(IS_ALIGNED(ctx->start_offset, PAGE_SIZE));
+	ASSERT(IS_ALIGNED(offset, PAGE_SIZE));
+
+	index = (offset - ctx->start_offset) >> PAGE_SHIFT;
+	ASSERT(index < ctx->valid);
+
+	tmp = ctx->ra_pages[index];
+	src = kmap(tmp);
+	dst = kmap(page);
+	memcpy(dst, src, PAGE_SIZE);
+	kunmap(page);
+	kunmap(tmp);
+	return 0;
+}
+
+static int btrfs_r5l_recover_load_meta(struct btrfs_r5l_recover_ctx *ctx)
 {
 	struct btrfs_r5l_meta_block *mb;
 
@@ -1642,6 +1708,42 @@ static int btrfs_r5l_recover_flush_log(struct btrfs_r5l_log *log, struct btrfs_r
 	}
 
 	return ret;
+
+static int btrfs_r5l_recover_allocate_ra(struct btrfs_r5l_recover_ctx *ctx)
+{
+	struct page *page;
+	ctx->ra_bio = btrfs_io_bio_alloc(GFP_NOFS, BIO_MAX_PAGES);
+
+	ctx->total = 0;
+	ctx->valid = 0;
+	while (ctx->total < BTRFS_R5L_RECOVER_IO_POOL_SIZE) {
+		page = alloc_page(GFP_NOFS | __GFP_HIGHMEM);
+		if (!page)
+			break;
+
+		ctx->ra_pages[ctx->total++] = page;
+	}
+
+	if (ctx->total == 0) {
+		bio_put(ctx->ra_bio);
+		return -ENOMEM;
+	}
+
+#ifdef BTRFS_DEBUG_R5LOG
+	trace_printk("readahead: %d allocated pages\n", ctx->total);
+#endif
+	return 0;
+}
+
+static void btrfs_r5l_recover_free_ra(struct btrfs_r5l_recover_ctx *ctx)
+{
+	int i;
+#ifdef BTRFS_DEBUG_R5LOG
+	trace_printk("readahead: %d to free pages\n", ctx->total);
+#endif
+	for (i = 0; i < ctx->total; i++)
+		__free_page(ctx->ra_pages[i]);
+	bio_put(ctx->ra_bio);
 }
 
 static void btrfs_r5l_write_super(struct btrfs_fs_info *fs_info, u64 cp);
@@ -1655,6 +1757,7 @@ static int btrfs_r5l_recover_log(struct btrfs_r5l_log *log)
 	ctx = kzalloc(sizeof(*ctx), GFP_NOFS);
 	ASSERT(ctx);
 
+	ctx->log = log;
 	ctx->pos = log->last_checkpoint;
 	ctx->seq = log->last_cp_seq;
 	ctx->meta_page = alloc_page(GFP_NOFS | __GFP_HIGHMEM);
@@ -1662,10 +1765,10 @@ static int btrfs_r5l_recover_log(struct btrfs_r5l_log *log)
 	ctx->io_page = alloc_page(GFP_NOFS | __GFP_HIGHMEM);
 	ASSERT(ctx->io_page);
 
-	ret = btrfs_r5l_recover_flush_log(log, ctx);
-	if (ret) {
-		;
-	}
+	ret = btrfs_r5l_recover_allocate_ra(ctx);
+	ASSERT(ret == 0);
+
+	btrfs_r5l_recover_flush_log(ctx);
 
 	pos = ctx->pos;
 	log->next_checkpoint = ctx->pos;
@@ -1684,6 +1787,7 @@ static int btrfs_r5l_recover_log(struct btrfs_r5l_log *log)
 #endif
 	__free_page(ctx->meta_page);
 	__free_page(ctx->io_page);
+	btrfs_r5l_recover_free_ra(ctx);
 	kfree(ctx);
 	return 0;
 }
-- 
2.9.4

