Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44528 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751931AbdHARPz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 13:15:55 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v71HFsTM012787
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:55 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v71HFsIf024870
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:54 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v71HFrrY032271
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:53 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 05/14] Btrfs: raid56: add stripe log for raid5/6
Date: Tue,  1 Aug 2017 10:14:28 -0600
Message-Id: <20170801161439.13426-6-bo.li.liu@oracle.com>
In-Reply-To: <20170801161439.13426-1-bo.li.liu@oracle.com>
References: <20170801161439.13426-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is adding the ability to use a disk as raid5/6's stripe log (aka
journal), the primary goal is to fix write hole issue that is inherent
in raid56 setup.

In a typical raid5/6 setup, both full stripe write and a partial
stripe write will generate parity at the very end of writing, so after
parity is generated, it's the right time to issue writes.

Now with raid5/6's stripe log, every write will be put into the stripe
log prior to being written to raid5/6 array, so that we have
everything to rewrite all 'not-yet-on-disk' data/parity if a power
loss happens while writing data/parity to different disks in raid5/6
array.

A metadata block is used here to manage the information of data and
parity and it's placed ahead of data and parity on stripe log.  Right
now such metadata block is limited to one page size and the structure
is defined as

{metadata block} + {a few payloads}

- 'metadata block' contains a magic code, a sequence number and the
  start position on the stripe log.

- 'payload' contains the information about data and parity, e.g. the
 physical offset and device id where data/parity is supposed to be.

Each data block has a payload while each set of parity has a payload
(e.g. for raid6, parity p and q has their own payload respectively).

And we treat data and parity differently because btrfs always prepares
the whole stripe length(64k) of parity, but data may only come from a
partial stripe write.

This metadata block is written to the raid5/6 stripe log with data/parity
in a single bio(could be two bios, doesn't support more than two
bios).

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/raid56.c | 512 +++++++++++++++++++++++++++++++++++++++++++++++-------
 fs/btrfs/raid56.h |  65 +++++++
 2 files changed, 513 insertions(+), 64 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index c75766f..007ba63 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -185,6 +185,8 @@ struct btrfs_r5l_log {
 	/* r5log device */
 	struct btrfs_device *dev;
 
+	struct btrfs_fs_info *fs_info;
+
 	/* allocation range for log entries */
 	u64 data_offset;
 	u64 device_size;
@@ -1179,6 +1181,445 @@ static void index_rbio_pages(struct btrfs_raid_bio *rbio)
 	spin_unlock_irq(&rbio->bio_list_lock);
 }
 
+/* r5log */
+/* XXX: this allocation may be done earlier, eg. when allocating rbio */
+static struct btrfs_r5l_io_unit *btrfs_r5l_alloc_io_unit(struct btrfs_r5l_log *log)
+{
+	struct btrfs_r5l_io_unit *io;
+	gfp_t gfp = GFP_NOFS;
+
+	io = kzalloc(sizeof(*io), gfp);
+	ASSERT(io);
+	io->log = log;
+	/* need to use kmap. */
+	io->meta_page = alloc_page(gfp | __GFP_HIGHMEM | __GFP_ZERO);
+	ASSERT(io->meta_page);
+
+	return io;
+}
+
+static void btrfs_r5l_free_io_unit(struct btrfs_r5l_log *log, struct btrfs_r5l_io_unit *io)
+{
+	__free_page(io->meta_page);
+	kfree(io);
+}
+
+static u64 btrfs_r5l_ring_add(struct btrfs_r5l_log *log, u64 start, u64 inc)
+{
+	start += inc;
+	if (start >= log->device_size)
+		start = start - log->device_size;
+	return start;
+}
+
+static void btrfs_r5l_reserve_log_entry(struct btrfs_r5l_log *log, struct btrfs_r5l_io_unit *io)
+{
+	log->log_start = btrfs_r5l_ring_add(log, log->log_start, PAGE_SIZE);
+	io->log_end = log->log_start;
+
+	if (log->log_start == 0)
+		io->need_split_bio = true;
+}
+
+static void btrfs_write_rbio(struct btrfs_raid_bio *rbio);
+
+static void btrfs_r5l_log_endio(struct bio *bio)
+{
+	struct btrfs_r5l_io_unit *io = bio->bi_private;
+	struct btrfs_r5l_log *log = io->log;
+
+	bio_put(bio);
+
+#ifdef BTRFS_DEBUG_R5LOG
+	trace_printk("move data to disk\n");
+#endif
+	/* move data to RAID. */
+	btrfs_write_rbio(io->rbio);
+
+	if (log->current_io == io)
+		log->current_io = NULL;
+	btrfs_r5l_free_io_unit(log, io);
+}
+
+static struct bio *btrfs_r5l_bio_alloc(struct btrfs_r5l_log *log)
+{
+	/* this allocation will not fail. */
+	struct bio *bio = btrfs_io_bio_alloc(GFP_NOFS, BIO_MAX_PAGES);
+
+	/* We need to make sure data/parity are settled down on the log disk. */
+	bio->bi_opf = REQ_OP_WRITE | REQ_PREFLUSH | REQ_FUA;
+	bio->bi_bdev = log->dev->bdev;
+
+#ifdef BTRFS_DEBUG_R5LOG
+	trace_printk("log->data_offset 0x%llx log->log_start 0x%llx\n", log->data_offset, log->log_start);
+#endif
+	bio->bi_iter.bi_sector = (log->data_offset + log->log_start) >> 9;
+
+	return bio;
+}
+
+static struct btrfs_r5l_io_unit *btrfs_r5l_new_meta(struct btrfs_r5l_log *log)
+{
+	struct btrfs_r5l_io_unit *io;
+	struct btrfs_r5l_meta_block *block;
+
+	io = btrfs_r5l_alloc_io_unit(log);
+	ASSERT(io);
+
+	block = kmap(io->meta_page);
+	clear_page(block);
+
+#ifdef BTRFS_DEBUG_R5LOG
+	trace_printk("%s pos %llu seq %llu\n", __func__, log->log_start, log->seq);
+#endif
+
+	block->magic = cpu_to_le32(BTRFS_R5LOG_MAGIC);
+	block->seq = cpu_to_le64(log->seq);
+	block->position = cpu_to_le64(log->log_start);
+
+	kunmap(io->meta_page);
+
+	io->log_start = log->log_start;
+	io->meta_offset = sizeof(struct btrfs_r5l_meta_block);
+	io->seq = log->seq++;
+
+	io->need_split_bio = false;
+	io->split_bio = NULL;
+	io->current_bio = btrfs_r5l_bio_alloc(log);
+	io->current_bio->bi_end_io = btrfs_r5l_log_endio;
+	io->current_bio->bi_private = io;
+
+	bio_add_page(io->current_bio, io->meta_page, PAGE_SIZE, 0);
+
+	btrfs_r5l_reserve_log_entry(log, io);
+	return io;
+}
+
+static int btrfs_r5l_get_meta(struct btrfs_r5l_log *log, struct btrfs_raid_bio *rbio, int payload_size)
+{
+	/* always allocate new meta block. */
+	log->current_io = btrfs_r5l_new_meta(log);
+	ASSERT(log->current_io);
+	log->current_io->rbio = rbio;
+	return 0;
+}
+
+static void btrfs_r5l_append_payload_meta(struct btrfs_r5l_log *log, u16 type, u64 location, u64 devid)
+{
+	struct btrfs_r5l_io_unit *io = log->current_io;
+	struct btrfs_r5l_payload *payload;
+	void *ptr;
+
+	ptr = kmap(io->meta_page);
+	payload = ptr + io->meta_offset;
+	payload->type = cpu_to_le16(type);
+	payload->flags = cpu_to_le16(0);
+
+	if (type == R5LOG_PAYLOAD_DATA)
+		payload->size = cpu_to_le32(1);
+	else if (type == R5LOG_PAYLOAD_PARITY)
+		payload->size = cpu_to_le32(16); /* stripe_len / PAGE_SIZE */
+	payload->devid = cpu_to_le64(devid);
+	payload->location = cpu_to_le64(location);
+	kunmap(io->meta_page);
+
+	/* XXX: add checksum later */
+	io->meta_offset += sizeof(*payload);
+	//io->meta_offset += sizeof(__le32);
+#ifdef BTRFS_DEBUG_R5LOG
+	trace_printk("io->meta_offset %d\n", io->meta_offset);
+#endif
+}
+
+static void btrfs_r5l_append_payload_page(struct btrfs_r5l_log *log, struct page *page)
+{
+	struct btrfs_r5l_io_unit *io = log->current_io;
+
+	if (io->need_split_bio) {
+		/* We're submitting too much data at a time!! */
+		BUG_ON(io->split_bio);
+		io->split_bio = io->current_bio;
+		io->current_bio = btrfs_r5l_bio_alloc(log);
+		bio_chain(io->current_bio, io->split_bio);
+		io->need_split_bio = false;
+	}
+
+	ASSERT(bio_add_page(io->current_bio, page, PAGE_SIZE, 0));
+
+	btrfs_r5l_reserve_log_entry(log, io);
+#ifdef BTRFS_DEBUG_R5LOG
+	trace_printk("log->log_start %llu io->current_bio bi_iter (bi_sector 0x%llx bi_size %d\n", log->log_start, io->current_bio->bi_iter.bi_sector << 9, io->current_bio->bi_iter.bi_size);
+#endif
+
+}
+
+static u64 btrfs_compute_location(struct btrfs_raid_bio *rbio, int stripe_nr, unsigned long page_index)
+{
+	struct btrfs_bio_stripe *stripe;
+
+	stripe = &rbio->bbio->stripes[stripe_nr];
+	return stripe->physical + (page_index << PAGE_SHIFT);
+}
+
+static u64 btrfs_compute_devid(struct btrfs_raid_bio *rbio, int stripe_nr)
+{
+	struct btrfs_bio_stripe *stripe;
+
+	stripe = &rbio->bbio->stripes[stripe_nr];
+	ASSERT(stripe->dev);
+	return stripe->dev->devid;
+}
+
+static void btrfs_r5l_log_stripe(struct btrfs_r5l_log *log, int data_pages, int parity_pages, struct btrfs_raid_bio *rbio)
+{
+	int meta_size;
+	int stripe, pagenr;
+	struct page *page;
+
+	/*
+	 * parity pages are contiguous on disk, thus only one
+	 * payload is required.
+	 */
+	meta_size = sizeof(struct btrfs_r5l_payload) * data_pages +
+		    sizeof(struct btrfs_r5l_payload) * (rbio->real_stripes - rbio->nr_data);
+
+	/* add meta block */
+	btrfs_r5l_get_meta(log, rbio, meta_size);
+
+	/* add data blocks which need to be written */
+	for (stripe = 0; stripe < rbio->nr_data; stripe++) {
+		for (pagenr = 0; pagenr < rbio->stripe_npages; pagenr++) {
+			u64 location;
+			u64 devid;
+			if (stripe < rbio->nr_data) {
+				page = page_in_rbio(rbio, stripe, pagenr, 1);
+				if (!page)
+					continue;
+				/* the page is from bio, queued for log bio */
+				location = btrfs_compute_location(rbio, stripe, pagenr);
+				devid = btrfs_compute_devid(rbio, stripe);
+#ifdef BTRFS_DEBUG_R5LOG
+				trace_printk("data: stripe %d pagenr %d location 0x%llx devid %llu\n", stripe, pagenr, location, devid);
+#endif
+				btrfs_r5l_append_payload_meta(log, R5LOG_PAYLOAD_DATA, location, devid);
+				btrfs_r5l_append_payload_page(log, page);
+			}
+		}
+	}
+
+	/* add the whole parity blocks */
+	for (; stripe < rbio->real_stripes; stripe++) {
+		u64 location = btrfs_compute_location(rbio, stripe, 0);
+		u64 devid = btrfs_compute_devid(rbio, stripe);
+
+#ifdef BTRFS_DEBUG_R5LOG
+		trace_printk("parity: stripe %d location 0x%llx devid %llu\n", stripe, location, devid);
+#endif
+		btrfs_r5l_append_payload_meta(log, R5LOG_PAYLOAD_PARITY, location, devid);
+		for (pagenr = 0; pagenr < rbio->stripe_npages; pagenr++) {
+			page = rbio_stripe_page(rbio, stripe, pagenr);
+			btrfs_r5l_append_payload_page(log, page);
+		}
+	}
+}
+
+static void btrfs_r5l_submit_current_io(struct btrfs_r5l_log *log)
+{
+	struct btrfs_r5l_io_unit *io = log->current_io;
+	struct btrfs_r5l_meta_block *mb;
+
+	if (!io)
+		return;
+
+	mb = kmap(io->meta_page);
+	mb->meta_size = cpu_to_le32(io->meta_offset);
+	kunmap(io->meta_page);
+
+	log->current_io = NULL;
+#ifdef BTRFS_DEBUG_R5LOG
+	trace_printk("io->current bio bi_sector 0x%llx devid %llu\n", io->current_bio->bi_iter.bi_sector << 9, log->dev->devid);
+#endif
+	/*
+	 * make sure that r5l_log_endio does not run in interrupt
+	 * context.
+	 *
+	 * if io->split_bio is available, then current_bio is just a
+	 * chained bio.
+	 */
+	if (io->split_bio)
+		btrfs_bio_wq_end_io(log->fs_info, io->split_bio, BTRFS_WQ_ENDIO_RAID56);
+	else
+		btrfs_bio_wq_end_io(log->fs_info, io->current_bio, BTRFS_WQ_ENDIO_RAID56);
+
+	submit_bio(io->current_bio);
+	if (io->split_bio)
+		submit_bio(io->split_bio);
+}
+
+static u64 btrfs_r5l_ring_distance(struct btrfs_r5l_log *log, u64 start, u64 end)
+{
+	if (end >= start)
+		return end - start;
+	else
+		return end + (log->device_size) - start;
+}
+
+static bool btrfs_r5l_has_free_space(struct btrfs_r5l_log *log, u64 size)
+{
+	u64 used_size;
+	used_size = btrfs_r5l_ring_distance(log, log->last_checkpoint,
+					    log->log_start);
+	return log->device_size > (used_size + size);
+}
+
+/*
+ * return 0 if data/parity are written into log and it will move data
+ * to RAID in endio.
+ *
+ * return 1 if log is not available or there is no space in log.
+ */
+static int btrfs_r5l_write_stripe(struct btrfs_raid_bio *rbio)
+{
+	int stripe, pagenr;
+	int data_pages = 0, parity_pages = 0;
+	u64 reserve;
+	int meta_size;
+	bool do_submit = false;
+	struct btrfs_r5l_log *log = rbio->fs_info->r5log;
+
+	if (!log) {
+#ifdef BTRFS_DEBUG_R5LOG
+		btrfs_info(rbio->fs_info, "r5log is not available\n");
+#endif
+		return 1;
+	}
+
+	/* get data_pages and parity_pages */
+	for (stripe = 0; stripe < rbio->real_stripes; stripe++) {
+		for (pagenr = 0; pagenr < rbio->stripe_npages; pagenr++) {
+			struct page *page;
+			if (stripe < rbio->nr_data) {
+				page = page_in_rbio(rbio, stripe, pagenr, 1);
+				if (!page)
+					continue;
+				data_pages++;
+			} else {
+				parity_pages++;
+			}
+		}
+	}
+#ifdef BTRFS_DEBUG_R5LOG
+	trace_printk("data_pages %d parity_pages %d\n", data_pages, parity_pages);
+	ASSERT(parity_pages == 16 * (rbio->real_stripes - rbio->nr_data));
+#endif
+
+	/*
+	 * parity pages are contiguous on disk, thus only one
+	 * payload is required.
+	 */
+	meta_size = sizeof(struct btrfs_r5l_payload) * data_pages +
+		sizeof(struct btrfs_r5l_payload) * (rbio->real_stripes - rbio->nr_data);
+
+	/* doesn't support large raid array */
+	if (meta_size + sizeof(struct btrfs_r5l_meta_block) > PAGE_SIZE) {
+#ifdef BTRFS_DEBUG_R5LOG
+		btrfs_info(rbio->fs_info, "meta_size (%d) is too big\n", meta_size);
+#endif
+		return 1;
+	}
+
+	mutex_lock(&log->io_mutex);
+	/* meta + data/parity */
+	reserve = (1 + data_pages + parity_pages) << PAGE_SHIFT;
+	if (btrfs_r5l_has_free_space(log, reserve)) {
+		btrfs_r5l_log_stripe(log, data_pages, parity_pages, rbio);
+		do_submit = true;
+	} else {
+		; /* XXX: reclaim */
+	}
+
+	if (do_submit) {
+		btrfs_r5l_submit_current_io(log);
+	}
+	mutex_unlock(&log->io_mutex);
+
+	return (do_submit ? 0 : 1);
+}
+
+static void btrfs_write_rbio(struct btrfs_raid_bio *rbio)
+{
+	struct btrfs_bio *bbio = rbio->bbio;
+	int stripe, pagenr;
+	struct bio_list bio_list;
+	struct bio *bio;
+	int ret = 0;
+
+	bio_list_init(&bio_list);
+
+	for (stripe = 0; stripe < rbio->real_stripes; stripe++) {
+		for (pagenr = 0; pagenr < rbio->stripe_npages; pagenr++) {
+			struct page *page;
+			if (stripe < rbio->nr_data) {
+				page = page_in_rbio(rbio, stripe, pagenr, 1);
+				if (!page)
+					continue;
+			} else {
+			       page = rbio_stripe_page(rbio, stripe, pagenr);
+			}
+
+			ret = rbio_add_io_page(rbio, &bio_list,
+				       page, stripe, pagenr, rbio->stripe_len);
+			if (ret)
+				goto out;
+		}
+	}
+
+	if (likely(!bbio->num_tgtdevs))
+		goto write_data;
+
+	for (stripe = 0; stripe < rbio->real_stripes; stripe++) {
+		if (!bbio->tgtdev_map[stripe])
+			continue;
+
+		for (pagenr = 0; pagenr < rbio->stripe_npages; pagenr++) {
+			struct page *page;
+			if (stripe < rbio->nr_data) {
+				page = page_in_rbio(rbio, stripe, pagenr, 1);
+				if (!page)
+					continue;
+			} else {
+			       page = rbio_stripe_page(rbio, stripe, pagenr);
+			}
+
+			ret = rbio_add_io_page(rbio, &bio_list, page,
+					       rbio->bbio->tgtdev_map[stripe],
+					       pagenr, rbio->stripe_len);
+			if (ret)
+				goto out;
+		}
+	}
+
+write_data:
+	atomic_set(&rbio->stripes_pending, bio_list_size(&bio_list));
+	BUG_ON(atomic_read(&rbio->stripes_pending) == 0);
+
+	while (1) {
+		bio = bio_list_pop(&bio_list);
+		if (!bio)
+			break;
+
+		bio->bi_private = rbio;
+		bio->bi_end_io = raid_write_end_io;
+		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
+
+		submit_bio(bio);
+	}
+out:
+	ASSERT(ret == 0 || ret == -EIO);
+	if (ret == -EIO)
+		rbio_orig_end_io(rbio, -EIO);
+}
+
 /*
  * this is called from one of two situations.  We either
  * have a full stripe from the higher layers, or we've read all
@@ -1189,19 +1630,14 @@ static void index_rbio_pages(struct btrfs_raid_bio *rbio)
  */
 static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
 {
-	struct btrfs_bio *bbio = rbio->bbio;
 	void *pointers[rbio->real_stripes];
 	int nr_data = rbio->nr_data;
 	int stripe;
 	int pagenr;
 	int p_stripe = -1;
 	int q_stripe = -1;
-	struct bio_list bio_list;
-	struct bio *bio;
 	int ret;
 
-	bio_list_init(&bio_list);
-
 	if (rbio->real_stripes - rbio->nr_data == 1) {
 		p_stripe = rbio->real_stripes - 1;
 	} else if (rbio->real_stripes - rbio->nr_data == 2) {
@@ -1281,68 +1717,15 @@ static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
 	 * higher layers (the bio_list in our rbio) and our p/q.  Ignore
 	 * everything else.
 	 */
-	for (stripe = 0; stripe < rbio->real_stripes; stripe++) {
-		for (pagenr = 0; pagenr < rbio->stripe_npages; pagenr++) {
-			struct page *page;
-			if (stripe < rbio->nr_data) {
-				page = page_in_rbio(rbio, stripe, pagenr, 1);
-				if (!page)
-					continue;
-			} else {
-			       page = rbio_stripe_page(rbio, stripe, pagenr);
-			}
-
-			ret = rbio_add_io_page(rbio, &bio_list,
-				       page, stripe, pagenr, rbio->stripe_len);
-			if (ret)
-				goto cleanup;
-		}
-	}
-
-	if (likely(!bbio->num_tgtdevs))
-		goto write_data;
-
-	for (stripe = 0; stripe < rbio->real_stripes; stripe++) {
-		if (!bbio->tgtdev_map[stripe])
-			continue;
-
-		for (pagenr = 0; pagenr < rbio->stripe_npages; pagenr++) {
-			struct page *page;
-			if (stripe < rbio->nr_data) {
-				page = page_in_rbio(rbio, stripe, pagenr, 1);
-				if (!page)
-					continue;
-			} else {
-			       page = rbio_stripe_page(rbio, stripe, pagenr);
-			}
-
-			ret = rbio_add_io_page(rbio, &bio_list, page,
-					       rbio->bbio->tgtdev_map[stripe],
-					       pagenr, rbio->stripe_len);
-			if (ret)
-				goto cleanup;
-		}
-	}
 
-write_data:
-	atomic_set(&rbio->stripes_pending, bio_list_size(&bio_list));
-	BUG_ON(atomic_read(&rbio->stripes_pending) == 0);
-
-	while (1) {
-		bio = bio_list_pop(&bio_list);
-		if (!bio)
-			break;
-
-		bio->bi_private = rbio;
-		bio->bi_end_io = raid_write_end_io;
-		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
+	/* write to log device firstly */
+	ret = btrfs_r5l_write_stripe(rbio);
+	if (ret == 0)
+		return;
 
-		submit_bio(bio);
-	}
+	/* if no log, lets write data to RAID. */
+	btrfs_write_rbio(rbio);
 	return;
-
-cleanup:
-	rbio_orig_end_io(rbio, -EIO);
 }
 
 /*
@@ -2748,6 +3131,7 @@ int btrfs_set_r5log(struct btrfs_fs_info *fs_info, struct btrfs_device *device)
 	log->device_size = btrfs_device_get_total_bytes(device) - log->data_offset;
 	log->device_size = round_down(log->device_size, PAGE_SIZE);
 	log->dev = device;
+	log->fs_info = fs_info;
 	mutex_init(&log->io_mutex);
 
 	cmpxchg(&fs_info->r5log, NULL, log);
diff --git a/fs/btrfs/raid56.h b/fs/btrfs/raid56.h
index 0c8bf6a..76a20fa 100644
--- a/fs/btrfs/raid56.h
+++ b/fs/btrfs/raid56.h
@@ -39,6 +39,71 @@ static inline int nr_data_stripes(struct map_lookup *map)
 #define is_parity_stripe(x) (((x) == RAID5_P_STRIPE) ||		\
 			     ((x) == RAID6_Q_STRIPE))
 
+/* r5log */
+struct btrfs_r5l_log;
+#define BTRFS_R5LOG_MAGIC 0x6433c509
+
+/* one meta block + several data + parity blocks */
+struct btrfs_r5l_io_unit {
+	struct btrfs_r5l_log *log;
+	struct btrfs_raid_bio *rbio;
+
+	/* store meta block */
+	struct page *meta_page;
+
+	/* current offset in meta page */
+	int meta_offset;
+
+	/* current bio for accepting new data/parity block */
+	struct bio *current_bio;
+
+	/* sequence number in meta block */
+	u64 seq;
+
+	/* where io_unit starts and ends */
+	u64 log_start;
+	u64 log_end;
+
+	/* split bio to hold more data */
+	bool need_split_bio;
+	struct bio *split_bio;
+};
+
+enum r5l_payload_type {
+	R5LOG_PAYLOAD_DATA = 0,
+	R5LOG_PAYLOAD_PARITY = 1,
+};
+
+/*
+ * payload is appending to the meta block and it describes the
+ * location and the size of data or parity.
+ */
+struct btrfs_r5l_payload {
+	__le16 type;
+	__le16 flags;
+
+	__le32 size;
+
+	/* data or parity */
+	__le64 location;
+	__le64 devid;
+};
+
+/* io unit starts from a meta block. */
+struct btrfs_r5l_meta_block {
+	__le32 magic;
+
+	/* the whole size of the block */
+	__le32 meta_size;
+
+	__le64 seq;
+	__le64 position;
+
+	struct btrfs_r5l_payload payload[];
+};
+
+/* r5log end */
+
 struct btrfs_raid_bio;
 struct btrfs_device;
 
-- 
2.9.4

