Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44527 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751930AbdHARPz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 13:15:55 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v71HFs8Q012788
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v71HFsEQ024876
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:54 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v71HFsBL022520
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:54 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 08/14] Btrfs: raid56: log recovery
Date: Tue,  1 Aug 2017 10:14:31 -0600
Message-Id: <20170801161439.13426-9-bo.li.liu@oracle.com>
In-Reply-To: <20170801161439.13426-1-bo.li.liu@oracle.com>
References: <20170801161439.13426-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is adding recovery on raid5/6 log.

We've set a %journal_tail in super_block, which indicates the position
from where we need to replay data.  So we scan the log and replay
valid meta/data/parity pairs until finding an invalid one.  By
replaying, it simply reads data/parity from the raid5/6 log and issues
writes to the raid disks where it should be.  Please note that the
whole meta/data/parity pair can be discarded if it fails the sanity
check in the meta block.

After recovery, we also append an empty meta block and update the
%journal_tail in super_block in order to avoid a situation, where the
layout on the raid5/6 log is

[valid A][invalid B][valid C],

so block A is the only one we should replay.

Then the recovery ends up pointing to block A as block B is invalid,
and some new writes come in and append to block A so that block B is
now overwritten to be a valid meta/data/parity.  If a power loss
happens, the new recovery starts again from block A, and since block B
is now valid, it may replay block C as well which has become stale.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/raid56.c | 151 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 151 insertions(+)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 5d7ea235..dea33c4 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1530,10 +1530,161 @@ static int btrfs_r5l_write_empty_meta_block(struct btrfs_r5l_log *log, u64 pos,
 	return ret;
 }
 
+struct btrfs_r5l_recover_ctx {
+	u64 pos;
+	u64 seq;
+	u64 total_size;
+	struct page *meta_page;
+	struct page *io_page;
+};
+
+static int btrfs_r5l_recover_load_meta(struct btrfs_r5l_log *log, struct btrfs_r5l_recover_ctx *ctx)
+{
+	struct btrfs_r5l_meta_block *mb;
+
+	btrfs_r5l_sync_page_io(log, log->dev, (ctx->pos >> 9), PAGE_SIZE, ctx->meta_page, REQ_OP_READ);
+
+	mb = kmap(ctx->meta_page);
+#ifdef BTRFS_DEBUG_R5LOG
+	trace_printk("ctx->pos %llu ctx->seq %llu pos %llu seq %llu\n", ctx->pos, ctx->seq, le64_to_cpu(mb->position), le64_to_cpu(mb->seq));
+#endif
+
+	if (le32_to_cpu(mb->magic) != BTRFS_R5LOG_MAGIC ||
+	    le64_to_cpu(mb->position) != ctx->pos ||
+	    le64_to_cpu(mb->seq) != ctx->seq) {
+#ifdef BTRFS_DEBUG_R5LOG
+		trace_printk("%s: mismatch magic %llu default %llu\n", __func__, le32_to_cpu(mb->magic), BTRFS_R5LOG_MAGIC);
+#endif
+		return -EINVAL;
+	}
+
+	ASSERT(le32_to_cpu(mb->meta_size) <= PAGE_SIZE);
+	kunmap(ctx->meta_page);
+
+	/* meta_block */
+	ctx->total_size = PAGE_SIZE;
+
+	return 0;
+}
+
+static int btrfs_r5l_recover_load_data(struct btrfs_r5l_log *log, struct btrfs_r5l_recover_ctx *ctx)
+{
+	u64 offset;
+	struct btrfs_r5l_meta_block *mb;
+	u64 meta_size;
+	u64 io_offset;
+	struct btrfs_device *dev;
+
+	mb = kmap(ctx->meta_page);
+
+	io_offset = PAGE_SIZE;
+	offset = sizeof(struct btrfs_r5l_meta_block);
+	meta_size = le32_to_cpu(mb->meta_size);
+
+	while (offset < meta_size) {
+		struct btrfs_r5l_payload *payload = (void *)mb + offset;
+
+		/* read data from log disk and write to payload->location */
+#ifdef BTRFS_DEBUG_R5LOG
+		trace_printk("payload type %d flags %d size %d location 0x%llx devid %llu\n", le16_to_cpu(payload->type), le16_to_cpu(payload->flags), le32_to_cpu(payload->size), le64_to_cpu(payload->location), le64_to_cpu(payload->devid));
+#endif
+
+		dev = btrfs_find_device(log->fs_info, le64_to_cpu(payload->devid), NULL, NULL);
+		if (!dev || dev->missing) {
+			ASSERT(0);
+		}
+
+		if (le16_to_cpu(payload->type) == R5LOG_PAYLOAD_DATA) {
+			ASSERT(le32_to_cpu(payload->size) == 1);
+			btrfs_r5l_sync_page_io(log, log->dev, (ctx->pos + io_offset) >> 9, PAGE_SIZE, ctx->io_page, REQ_OP_READ);
+			btrfs_r5l_sync_page_io(log, dev, le64_to_cpu(payload->location) >> 9, PAGE_SIZE, ctx->io_page, REQ_OP_WRITE);
+			io_offset += PAGE_SIZE;
+		} else if (le16_to_cpu(payload->type) == R5LOG_PAYLOAD_PARITY) {
+			int i;
+			ASSERT(le32_to_cpu(payload->size) == 16);
+			for (i = 0; i < le32_to_cpu(payload->size); i++) {
+				/* liubo: parity are guaranteed to be
+				 * contiguous, use just one bio to
+				 * hold all pages and flush them. */
+				u64 parity_off = le64_to_cpu(payload->location) + i * PAGE_SIZE;
+				btrfs_r5l_sync_page_io(log, log->dev, (ctx->pos + io_offset) >> 9, PAGE_SIZE, ctx->io_page, REQ_OP_READ);
+				btrfs_r5l_sync_page_io(log, dev, parity_off >> 9, PAGE_SIZE, ctx->io_page, REQ_OP_WRITE);
+				io_offset += PAGE_SIZE;
+			}
+		} else {
+			ASSERT(0);
+		}
+
+		offset += sizeof(struct btrfs_r5l_payload);
+	}
+	kunmap(ctx->meta_page);
+
+	ctx->total_size += (io_offset - PAGE_SIZE);
+	return 0;
+}
+
+static int btrfs_r5l_recover_flush_log(struct btrfs_r5l_log *log, struct btrfs_r5l_recover_ctx *ctx)
+{
+	int ret;
+
+	while (1) {
+		ret = btrfs_r5l_recover_load_meta(log, ctx);
+		if (ret)
+			break;
+
+		ret = btrfs_r5l_recover_load_data(log, ctx);
+		ASSERT(!ret || ret > 0);
+		if (ret)
+			break;
+
+		ctx->seq++;
+		ctx->pos = btrfs_r5l_ring_add(log, ctx->pos, ctx->total_size);
+	}
+
+	return ret;
+}
+
 static void btrfs_r5l_write_super(struct btrfs_fs_info *fs_info, u64 cp);
 
 static int btrfs_r5l_recover_log(struct btrfs_r5l_log *log)
 {
+	struct btrfs_r5l_recover_ctx *ctx;
+	u64 pos;
+	int ret;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_NOFS);
+	ASSERT(ctx);
+
+	ctx->pos = log->last_checkpoint;
+	ctx->seq = log->last_cp_seq;
+	ctx->meta_page = alloc_page(GFP_NOFS | __GFP_HIGHMEM);
+	ASSERT(ctx->meta_page);
+	ctx->io_page = alloc_page(GFP_NOFS | __GFP_HIGHMEM);
+	ASSERT(ctx->io_page);
+
+	ret = btrfs_r5l_recover_flush_log(log, ctx);
+	if (ret) {
+		;
+	}
+
+	pos = ctx->pos;
+	log->next_checkpoint = ctx->pos;
+	ctx->seq += 10000;
+	btrfs_r5l_write_empty_meta_block(log, ctx->pos, ctx->seq++);
+	ctx->pos = btrfs_r5l_ring_add(log, ctx->pos, PAGE_SIZE);
+
+	log->log_start = ctx->pos;
+	log->seq = ctx->seq;
+	/* last_checkpoint point to the empty block. */
+	log->last_checkpoint = pos;
+	btrfs_r5l_write_super(log->fs_info, pos);
+
+#ifdef BTRFS_DEBUG_R5LOG
+	trace_printk("%s: log_start %llu seq %llu\n", __func__, log->log_start, log->seq);
+#endif
+	__free_page(ctx->meta_page);
+	__free_page(ctx->io_page);
+	kfree(ctx);
 	return 0;
 }
 
-- 
2.9.4

