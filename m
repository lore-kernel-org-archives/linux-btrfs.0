Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33500 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751944AbdHARP5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 13:15:57 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v71HFtnv002181
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:56 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v71HFtBD014040
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:55 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v71HFtRT032287
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:55 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 11/14] Btrfs: raid56: add csum support
Date: Tue,  1 Aug 2017 10:14:34 -0600
Message-Id: <20170801161439.13426-12-bo.li.liu@oracle.com>
In-Reply-To: <20170801161439.13426-1-bo.li.liu@oracle.com>
References: <20170801161439.13426-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is adding checksum to meta/data/parity resident on the raid5/6
log.  So recovery now can verify checksum to see if anything inside
meta/data/parity has been changed.

If anything is wrong in meta block, we stops replaying data/parity at
that position, while if anything is wrong in data/parity block, we
just skip this this meta/data/parity pair and move onto the next one.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/raid56.c | 235 ++++++++++++++++++++++++++++++++++++++++++++----------
 fs/btrfs/raid56.h |   4 +
 2 files changed, 197 insertions(+), 42 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 8f47e56..8bc7ba4 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -43,6 +43,7 @@
 #include "async-thread.h"
 #include "check-integrity.h"
 #include "rcu-string.h"
+#include "hash.h"
 
 /* set when additional merges to this rbio are not allowed */
 #define RBIO_RMW_LOCKED_BIT	1
@@ -197,6 +198,7 @@ struct btrfs_r5l_log {
 	u64 last_cp_seq;
 	u64 seq;
 	u64 log_start;
+	u32 uuid_csum;
 	struct btrfs_r5l_io_unit *current_io;
 };
 
@@ -1309,7 +1311,7 @@ static int btrfs_r5l_get_meta(struct btrfs_r5l_log *log, struct btrfs_raid_bio *
 	return 0;
 }
 
-static void btrfs_r5l_append_payload_meta(struct btrfs_r5l_log *log, u16 type, u64 location, u64 devid)
+static void btrfs_r5l_append_payload_meta(struct btrfs_r5l_log *log, u16 type, u64 location, u64 devid, u32 csum)
 {
 	struct btrfs_r5l_io_unit *io = log->current_io;
 	struct btrfs_r5l_payload *payload;
@@ -1326,11 +1328,11 @@ static void btrfs_r5l_append_payload_meta(struct btrfs_r5l_log *log, u16 type, u
 		payload->size = cpu_to_le32(16); /* stripe_len / PAGE_SIZE */
 	payload->devid = cpu_to_le64(devid);
 	payload->location = cpu_to_le64(location);
+	payload->csum = cpu_to_le32(csum);
 	kunmap(io->meta_page);
 
-	/* XXX: add checksum later */
 	io->meta_offset += sizeof(*payload);
-	//io->meta_offset += sizeof(__le32);
+
 #ifdef BTRFS_DEBUG_R5LOG
 	trace_printk("io->meta_offset %d\n", io->meta_offset);
 #endif
@@ -1380,6 +1382,10 @@ static void btrfs_r5l_log_stripe(struct btrfs_r5l_log *log, int data_pages, int
 	int meta_size;
 	int stripe, pagenr;
 	struct page *page;
+	char *kaddr;
+	u32 csum;
+	u64 location;
+	u64 devid;
 
 	/*
 	 * parity pages are contiguous on disk, thus only one
@@ -1394,8 +1400,6 @@ static void btrfs_r5l_log_stripe(struct btrfs_r5l_log *log, int data_pages, int
 	/* add data blocks which need to be written */
 	for (stripe = 0; stripe < rbio->nr_data; stripe++) {
 		for (pagenr = 0; pagenr < rbio->stripe_npages; pagenr++) {
-			u64 location;
-			u64 devid;
 			if (stripe < rbio->nr_data) {
 				page = page_in_rbio(rbio, stripe, pagenr, 1);
 				if (!page)
@@ -1406,7 +1410,11 @@ static void btrfs_r5l_log_stripe(struct btrfs_r5l_log *log, int data_pages, int
 #ifdef BTRFS_DEBUG_R5LOG
 				trace_printk("data: stripe %d pagenr %d location 0x%llx devid %llu\n", stripe, pagenr, location, devid);
 #endif
-				btrfs_r5l_append_payload_meta(log, R5LOG_PAYLOAD_DATA, location, devid);
+				kaddr = kmap(page);
+				csum = btrfs_crc32c(log->uuid_csum, kaddr, PAGE_SIZE);
+				kunmap(page);
+
+				btrfs_r5l_append_payload_meta(log, R5LOG_PAYLOAD_DATA, location, devid, csum);
 				btrfs_r5l_append_payload_page(log, page);
 			}
 		}
@@ -1414,17 +1422,26 @@ static void btrfs_r5l_log_stripe(struct btrfs_r5l_log *log, int data_pages, int
 
 	/* add the whole parity blocks */
 	for (; stripe < rbio->real_stripes; stripe++) {
-		u64 location = btrfs_compute_location(rbio, stripe, 0);
-		u64 devid = btrfs_compute_devid(rbio, stripe);
+		location = btrfs_compute_location(rbio, stripe, 0);
+		devid = btrfs_compute_devid(rbio, stripe);
 
 #ifdef BTRFS_DEBUG_R5LOG
 		trace_printk("parity: stripe %d location 0x%llx devid %llu\n", stripe, location, devid);
 #endif
-		btrfs_r5l_append_payload_meta(log, R5LOG_PAYLOAD_PARITY, location, devid);
 		for (pagenr = 0; pagenr < rbio->stripe_npages; pagenr++) {
 			page = rbio_stripe_page(rbio, stripe, pagenr);
+
+			kaddr = kmap(page);
+			if (pagenr == 0)
+				csum = btrfs_crc32c(log->uuid_csum, kaddr, PAGE_SIZE);
+			else
+				csum = btrfs_crc32c(csum, kaddr, PAGE_SIZE);
+			kunmap(page);
+
 			btrfs_r5l_append_payload_page(log, page);
 		}
+
+		btrfs_r5l_append_payload_meta(log, R5LOG_PAYLOAD_PARITY, location, devid, csum);
 	}
 }
 
@@ -1432,12 +1449,16 @@ static void btrfs_r5l_submit_current_io(struct btrfs_r5l_log *log)
 {
 	struct btrfs_r5l_io_unit *io = log->current_io;
 	struct btrfs_r5l_meta_block *mb;
+	u32 csum;
 
 	if (!io)
 		return;
 
 	mb = kmap(io->meta_page);
 	mb->meta_size = cpu_to_le32(io->meta_offset);
+	ASSERT(mb->csum == 0);
+	csum = btrfs_crc32c(log->uuid_csum, mb, PAGE_SIZE);
+	mb->csum = cpu_to_le32(csum);
 	kunmap(io->meta_page);
 
 	log->current_io = NULL;
@@ -1506,6 +1527,7 @@ static int btrfs_r5l_write_empty_meta_block(struct btrfs_r5l_log *log, u64 pos,
 {
 	struct page *page;
 	struct btrfs_r5l_meta_block *mb;
+	u32 csum;
 	int ret = 0;
 
 #ifdef BTRFS_DEBUG_R5LOG
@@ -1520,6 +1542,9 @@ static int btrfs_r5l_write_empty_meta_block(struct btrfs_r5l_log *log, u64 pos,
 	mb->meta_size = cpu_to_le32(sizeof(struct btrfs_r5l_meta_block));
 	mb->seq = cpu_to_le64(seq);
 	mb->position = cpu_to_le64(pos);
+
+	csum = btrfs_crc32c(log->uuid_csum, mb, PAGE_SIZE);
+	mb->csum = cpu_to_le32(csum);
 	kunmap(page);
 
 	if (!btrfs_r5l_sync_page_io(log, log->dev, (pos >> 9), PAGE_SIZE, page, REQ_OP_WRITE | REQ_FUA)) {
@@ -1607,6 +1632,9 @@ static int btrfs_r5l_recover_read_page(struct btrfs_r5l_recover_ctx *ctx, struct
 static int btrfs_r5l_recover_load_meta(struct btrfs_r5l_recover_ctx *ctx)
 {
 	struct btrfs_r5l_meta_block *mb;
+	u32 csum;
+	u32 expected;
+	int ret = 0;
 
 	ret = btrfs_r5l_recover_read_page(ctx, ctx->meta_page, ctx->pos);
 	if (ret)
@@ -1623,25 +1651,131 @@ static int btrfs_r5l_recover_load_meta(struct btrfs_r5l_recover_ctx *ctx)
 #ifdef BTRFS_DEBUG_R5LOG
 		trace_printk("%s: mismatch magic %llu default %llu\n", __func__, le32_to_cpu(mb->magic), BTRFS_R5LOG_MAGIC);
 #endif
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
-	ASSERT(le32_to_cpu(mb->meta_size) <= PAGE_SIZE);
-	kunmap(ctx->meta_page);
+	expected = le32_to_cpu(mb->csum);
+	/*
+	 * when we calculate mb->csum, it's zero, so we need to zero
+	 * it back.
+	 */
+	mb->csum = 0;
+	csum = btrfs_crc32c(ctx->log->uuid_csum, mb, PAGE_SIZE);
+	if (csum != expected) {
+#ifdef BTRFS_DEBUG_R5LOG
+		pr_info("%s: mismatch checksum for r5l meta block\n", __func__);
+#endif
+		ret = -EINVAL;
+		goto out;
+	}
 
+	ASSERT(le32_to_cpu(mb->meta_size) <= PAGE_SIZE);
 	/* meta_block */
 	ctx->total_size = PAGE_SIZE;
 
-	return 0;
+out:
+	kunmap(ctx->meta_page);
+
+	return ret;
+}
+
+static int btrfs_r5l_recover_verify_checksum(struct btrfs_r5l_recover_ctx *ctx)
+{
+	u64 offset;
+	u32 meta_size;
+	u64 csum_io_offset;
+	u64 read_pos;
+	char *kaddr;
+	u32 csum;
+	int type;
+	struct btrfs_r5l_meta_block *mb;
+	struct btrfs_r5l_payload *payload;
+	struct btrfs_r5l_log *log = ctx->log;
+	struct btrfs_device *dev;
+	int ret = 0;
+
+	mb = kmap(ctx->meta_page);
+	meta_size = le32_to_cpu(mb->meta_size);
+	csum_io_offset = PAGE_SIZE;
+
+	for (offset = sizeof(struct btrfs_r5l_meta_block);
+	     offset < meta_size;
+	     offset += sizeof(struct btrfs_r5l_payload)) {
+		payload = (void *)mb + offset;
+
+		/* check if there is any invalid device, if so, skip writing this mb. */
+		dev = btrfs_find_device(log->fs_info, le64_to_cpu(payload->devid), NULL, NULL);
+		if (!dev || dev->missing) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		type = le16_to_cpu(payload->type);
+		if (type == R5LOG_PAYLOAD_DATA) {
+			read_pos = btrfs_r5l_ring_add(log, ctx->pos, csum_io_offset);
+			csum_io_offset += PAGE_SIZE;
+
+			ASSERT(le32_to_cpu(payload->size) == 1);
+			ret = btrfs_r5l_recover_read_page(ctx, ctx->io_page, read_pos);
+			if (ret) {
+				ret = -EIO;
+				goto out;
+			}
+
+			kaddr = kmap(ctx->io_page);
+			csum = btrfs_crc32c(log->uuid_csum, kaddr, PAGE_SIZE);
+			kunmap(ctx->io_page);
+		} else if (type == R5LOG_PAYLOAD_PARITY) {
+			int i;
+			for (i = 0; i < le32_to_cpu(payload->size); i++) {
+				read_pos = btrfs_r5l_ring_add(log, ctx->pos, csum_io_offset);
+				csum_io_offset += PAGE_SIZE;
+
+				ret = btrfs_r5l_recover_read_page(ctx, ctx->io_page, read_pos);
+				if (ret) {
+					ret = -EIO;
+					goto out;
+				}
+
+				kaddr = kmap(ctx->io_page);
+				if (i == 0)
+					csum = btrfs_crc32c(log->uuid_csum, kaddr, PAGE_SIZE);
+				else
+					csum = btrfs_crc32c(csum, kaddr, PAGE_SIZE);
+				kunmap(ctx->io_page);
+			}
+		} else {
+			ASSERT(0);
+		}
+
+		if (csum != le32_to_cpu(payload->csum)) {
+			trace_printk("r5l data csum fails location 0x%llx devid %llu\n", le64_to_cpu(payload->location), le64_to_cpu(payload->devid));
+			ret = -EAGAIN;
+			goto out;
+		}
+	}
+out:
+	kunmap(ctx->meta_page);
+	return ret;
 }
 
-static int btrfs_r5l_recover_load_data(struct btrfs_r5l_log *log, struct btrfs_r5l_recover_ctx *ctx)
+static int btrfs_r5l_recover_load_data(struct btrfs_r5l_recover_ctx *ctx)
 {
 	u64 offset;
 	struct btrfs_r5l_meta_block *mb;
-	u64 meta_size;
+	u32 meta_size;
 	u64 io_offset;
+	u64 read_pos;
 	struct btrfs_device *dev;
+	struct btrfs_r5l_payload *payload;
+	struct btrfs_r5l_log *log = ctx->log;
+	int ret = 0;
+
+	/* if any checksum fails, skip writing this mb. */
+	ret = btrfs_r5l_recover_verify_checksum(ctx);
+	if (ret)
+		return ret;
 
 	mb = kmap(ctx->meta_page);
 
@@ -1649,67 +1783,81 @@ static int btrfs_r5l_recover_load_data(struct btrfs_r5l_log *log, struct btrfs_r
 	offset = sizeof(struct btrfs_r5l_meta_block);
 	meta_size = le32_to_cpu(mb->meta_size);
 
-	while (offset < meta_size) {
-		struct btrfs_r5l_payload *payload = (void *)mb + offset;
+	for (offset = sizeof(struct btrfs_r5l_meta_block);
+	     offset < meta_size;
+	     offset += sizeof(struct btrfs_r5l_payload)) {
+		payload = (void *)mb + offset;
 
 		/* read data from log disk and write to payload->location */
 #ifdef BTRFS_DEBUG_R5LOG
 		trace_printk("payload type %d flags %d size %d location 0x%llx devid %llu\n", le16_to_cpu(payload->type), le16_to_cpu(payload->flags), le32_to_cpu(payload->size), le64_to_cpu(payload->location), le64_to_cpu(payload->devid));
 #endif
 
+		/* liubo: how to handle the case where dev is suddenly off? */
 		dev = btrfs_find_device(log->fs_info, le64_to_cpu(payload->devid), NULL, NULL);
-		if (!dev || dev->missing) {
-			ASSERT(0);
-		}
+		ASSERT(dev && !dev->missing);
 
 		if (le16_to_cpu(payload->type) == R5LOG_PAYLOAD_DATA) {
-			ASSERT(le32_to_cpu(payload->size) == 1);
-			btrfs_r5l_sync_page_io(log, log->dev, (ctx->pos + io_offset) >> 9, PAGE_SIZE, ctx->io_page, REQ_OP_READ);
-			btrfs_r5l_sync_page_io(log, dev, le64_to_cpu(payload->location) >> 9, PAGE_SIZE, ctx->io_page, REQ_OP_WRITE);
+			read_pos = btrfs_r5l_ring_add(log, ctx->pos, io_offset);
 			io_offset += PAGE_SIZE;
+
+			ret = btrfs_r5l_recover_read_page(ctx, ctx->io_page, read_pos);
+			if (ret)
+				goto out;
+
+			if (!btrfs_r5l_sync_page_io(log, dev, le64_to_cpu(payload->location) >> 9, PAGE_SIZE, ctx->io_page, REQ_OP_WRITE)) {
+				ret = -EIO;
+				goto out;
+			}
 		} else if (le16_to_cpu(payload->type) == R5LOG_PAYLOAD_PARITY) {
 			int i;
-			ASSERT(le32_to_cpu(payload->size) == 16);
+
+			ASSERT(offset + sizeof(struct btrfs_r5l_payload) == meta_size);
+
 			for (i = 0; i < le32_to_cpu(payload->size); i++) {
-				/* liubo: parity are guaranteed to be
-				 * contiguous, use just one bio to
-				 * hold all pages and flush them. */
 				u64 parity_off = le64_to_cpu(payload->location) + i * PAGE_SIZE;
-				btrfs_r5l_sync_page_io(log, log->dev, (ctx->pos + io_offset) >> 9, PAGE_SIZE, ctx->io_page, REQ_OP_READ);
-				btrfs_r5l_sync_page_io(log, dev, parity_off >> 9, PAGE_SIZE, ctx->io_page, REQ_OP_WRITE);
+				read_pos = btrfs_r5l_ring_add(log, ctx->pos, io_offset);
 				io_offset += PAGE_SIZE;
+
+				ret = btrfs_r5l_recover_read_page(ctx, ctx->io_page, read_pos);
+				if (ret)
+					goto out;
+
+				if (!btrfs_r5l_sync_page_io(log, dev, parity_off >> 9, PAGE_SIZE, ctx->io_page, REQ_OP_WRITE)) {
+					ret = -EIO;
+					goto out;
+				}
 			}
 		} else {
 			ASSERT(0);
 		}
-
-		offset += sizeof(struct btrfs_r5l_payload);
 	}
-	kunmap(ctx->meta_page);
 
 	ctx->total_size += (io_offset - PAGE_SIZE);
-	return 0;
+out:
+	kunmap(ctx->meta_page);
+	return ret;
 }
 
-static int btrfs_r5l_recover_flush_log(struct btrfs_r5l_log *log, struct btrfs_r5l_recover_ctx *ctx)
+static int btrfs_r5l_recover_flush_log(struct btrfs_r5l_recover_ctx *ctx)
 {
 	int ret;
 
 	while (1) {
-		ret = btrfs_r5l_recover_load_meta(log, ctx);
+		ret = btrfs_r5l_recover_load_meta(ctx);
 		if (ret)
 			break;
 
-		ret = btrfs_r5l_recover_load_data(log, ctx);
-		ASSERT(!ret || ret > 0);
-		if (ret)
+		ret = btrfs_r5l_recover_load_data(ctx);
+		if (ret && ret != -EAGAIN)
 			break;
 
 		ctx->seq++;
-		ctx->pos = btrfs_r5l_ring_add(log, ctx->pos, ctx->total_size);
+		ctx->pos = btrfs_r5l_ring_add(ctx->log, ctx->pos, ctx->total_size);
 	}
 
-	return ret;
+	return 0;
+}
 
 static int btrfs_r5l_recover_allocate_ra(struct btrfs_r5l_recover_ctx *ctx)
 {
@@ -1801,6 +1949,7 @@ int btrfs_r5l_load_log(struct btrfs_fs_info *fs_info, u64 cp)
 	struct page *page;
 	struct btrfs_r5l_meta_block *mb;
 	bool create_new = false;
+	int ret;
 
 	ASSERT(log);
 
@@ -1856,10 +2005,10 @@ int btrfs_r5l_load_log(struct btrfs_fs_info *fs_info, u64 cp)
 		log->seq = log->last_cp_seq + 1;
 		log->next_checkpoint = cp;
 	} else {
-		btrfs_r5l_recover_log(log);
+		ret = btrfs_r5l_recover_log(log);
 	}
 
-	return 0;
+	return ret;
 }
 
 /*
@@ -3576,6 +3725,8 @@ int btrfs_set_r5log(struct btrfs_fs_info *fs_info, struct btrfs_device *device)
 	log->device_size = round_down(log->device_size, PAGE_SIZE);
 	log->dev = device;
 	log->fs_info = fs_info;
+	ASSERT(sizeof(device->uuid) == BTRFS_UUID_SIZE);
+	log->uuid_csum = btrfs_crc32c(~0, device->uuid, sizeof(device->uuid));
 	mutex_init(&log->io_mutex);
 
 	cmpxchg(&fs_info->r5log, NULL, log);
diff --git a/fs/btrfs/raid56.h b/fs/btrfs/raid56.h
index 314d299..569cec8 100644
--- a/fs/btrfs/raid56.h
+++ b/fs/btrfs/raid56.h
@@ -87,6 +87,8 @@ struct btrfs_r5l_payload {
 	/* data or parity */
 	__le64 location;
 	__le64 devid;
+
+	__le32 csum;
 };
 
 /* io unit starts from a meta block. */
@@ -96,6 +98,8 @@ struct btrfs_r5l_meta_block {
 	/* the whole size of the block */
 	__le32 meta_size;
 
+	__le32 csum;
+
 	__le64 seq;
 	__le64 position;
 
-- 
2.9.4

