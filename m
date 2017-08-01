Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33476 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751929AbdHARPz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 13:15:55 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v71HFskh002153
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:55 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v71HFsTA021082
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:54 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v71HFsUl022948
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:54 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 07/14] Btrfs: raid56: load r5log
Date: Tue,  1 Aug 2017 10:14:30 -0600
Message-Id: <20170801161439.13426-8-bo.li.liu@oracle.com>
In-Reply-To: <20170801161439.13426-1-bo.li.liu@oracle.com>
References: <20170801161439.13426-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A raid5/6 log can be loaded while mounting a btrfs (which already has
a disk set up as raid5/6 log) or setting up a disk as raid5/6 log for
the first time.

It gets %journal_tail from super_block where it can read the first 4K
block and goes through the sanity checks, if it's valid, then go check
if anything needs to be replayed, otherwise it creates a new empty
block at the beginning of the disk and new writes will append to it.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/disk-io.c |  16 +++++++
 fs/btrfs/raid56.c  | 128 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/raid56.h  |   1 +
 3 files changed, 145 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8685d67..c2d8697 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2987,6 +2987,22 @@ int open_ctree(struct super_block *sb,
 	fs_info->generation = generation;
 	fs_info->last_trans_committed = generation;
 
+	if (fs_info->r5log) {
+		u64 cp = btrfs_super_journal_tail(fs_info->super_copy);
+#ifdef BTRFS_DEBUG_R5LOG
+		trace_printk("%s: get journal_tail %llu\n", __func__, cp);
+#endif
+		/* if the data is not replayed, data and parity on
+		 * disk are still consistent.  So we can move on.
+		 *
+		 * About fsync, since fsync can make sure data is
+		 * flushed onto disk and only metadata is kept into
+		 * write-ahead log, the fsync'd data will never ends
+		 * up with being replayed by raid56 log.
+		 */
+		btrfs_r5l_load_log(fs_info, cp);
+	}
+
 	ret = btrfs_recover_balance(fs_info);
 	if (ret) {
 		btrfs_err(fs_info, "failed to recover balance: %d", ret);
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 60010a6..5d7ea235 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1477,6 +1477,134 @@ static bool btrfs_r5l_has_free_space(struct btrfs_r5l_log *log, u64 size)
 	return log->device_size > (used_size + size);
 }
 
+static int btrfs_r5l_sync_page_io(struct btrfs_r5l_log *log,
+				  struct btrfs_device *dev, sector_t sector,
+				  int size, struct page *page, int op)
+{
+	struct bio *bio = btrfs_io_bio_alloc(GFP_NOFS, 1);
+	int ret;
+
+	bio->bi_bdev = dev->bdev;
+	bio->bi_opf = op;
+	if (dev == log->dev)
+		bio->bi_iter.bi_sector = (log->data_offset >> 9) + sector;
+	else
+		bio->bi_iter.bi_sector = sector;
+
+#ifdef BTRFS_DEBUG_R5LOG
+	trace_printk("%s: op %d bi_sector 0x%llx\n", __func__, op, (bio->bi_iter.bi_sector << 9));
+#endif
+
+	bio_add_page(bio, page, size, 0);
+	submit_bio_wait(bio);
+	ret = !bio->bi_error;
+	bio_put(bio);
+	return ret;
+}
+
+static int btrfs_r5l_write_empty_meta_block(struct btrfs_r5l_log *log, u64 pos, u64 seq)
+{
+	struct page *page;
+	struct btrfs_r5l_meta_block *mb;
+	int ret = 0;
+
+#ifdef BTRFS_DEBUG_R5LOG
+	trace_printk("%s: pos %llu seq %llu\n", __func__, pos, seq);
+#endif
+
+	page = alloc_page(GFP_NOFS | __GFP_HIGHMEM | __GFP_ZERO);
+	ASSERT(page);
+
+	mb = kmap(page);
+	mb->magic = cpu_to_le32(BTRFS_R5LOG_MAGIC);
+	mb->meta_size = cpu_to_le32(sizeof(struct btrfs_r5l_meta_block));
+	mb->seq = cpu_to_le64(seq);
+	mb->position = cpu_to_le64(pos);
+	kunmap(page);
+
+	if (!btrfs_r5l_sync_page_io(log, log->dev, (pos >> 9), PAGE_SIZE, page, REQ_OP_WRITE | REQ_FUA)) {
+		ret = -EIO;
+	}
+
+	__free_page(page);
+	return ret;
+}
+
+static void btrfs_r5l_write_super(struct btrfs_fs_info *fs_info, u64 cp);
+
+static int btrfs_r5l_recover_log(struct btrfs_r5l_log *log)
+{
+	return 0;
+}
+
+/* return 0 if success, otherwise return errors */
+int btrfs_r5l_load_log(struct btrfs_fs_info *fs_info, u64 cp)
+{
+	struct btrfs_r5l_log *log = fs_info->r5log;
+	struct page *page;
+	struct btrfs_r5l_meta_block *mb;
+	bool create_new = false;
+
+	ASSERT(log);
+
+	page = alloc_page(GFP_NOFS | __GFP_HIGHMEM);
+	ASSERT(page);
+
+	if (!btrfs_r5l_sync_page_io(log, log->dev, (cp >> 9), PAGE_SIZE, page,
+				    REQ_OP_READ)) {
+		__free_page(page);
+		return -EIO;
+	}
+
+	mb = kmap(page);
+#ifdef BTRFS_DEBUG_R5LOG
+	trace_printk("r5l: mb->pos %llu cp %llu mb->seq %llu\n", le64_to_cpu(mb->position), cp, le64_to_cpu(mb->seq));
+#endif
+
+	if (le32_to_cpu(mb->magic) != BTRFS_R5LOG_MAGIC) {
+#ifdef BTRFS_DEBUG_R5LOG
+		trace_printk("magic not match: create new r5l\n");
+#endif
+		create_new = true;
+		goto create;
+	}
+
+	ASSERT(le64_to_cpu(mb->position) == cp);
+	if (le64_to_cpu(mb->position) != cp) {
+#ifdef BTRFS_DEBUG_R5LOG
+		trace_printk("mb->position not match: create new r5l\n");
+#endif
+		create_new = true;
+		goto create;
+	}
+create:
+	if (create_new) {
+		/* initial new r5log */
+		log->last_cp_seq = prandom_u32();
+		cp = 0;
+
+		btrfs_r5l_write_empty_meta_block(log, cp, log->last_cp_seq);
+		btrfs_r5l_write_super(fs_info, cp);
+	} else {
+		log->last_cp_seq = le64_to_cpu(mb->seq);
+	}
+
+	log->last_checkpoint = cp;
+
+	kunmap(page);
+	__free_page(page);
+
+	if (create_new) {
+		log->log_start = btrfs_r5l_ring_add(log, cp, PAGE_SIZE);
+		log->seq = log->last_cp_seq + 1;
+		log->next_checkpoint = cp;
+	} else {
+		btrfs_r5l_recover_log(log);
+	}
+
+	return 0;
+}
+
 /*
  * writing super with log->next_checkpoint
  *
diff --git a/fs/btrfs/raid56.h b/fs/btrfs/raid56.h
index 76a20fa..314d299 100644
--- a/fs/btrfs/raid56.h
+++ b/fs/btrfs/raid56.h
@@ -131,4 +131,5 @@ void raid56_submit_missing_rbio(struct btrfs_raid_bio *rbio);
 int btrfs_alloc_stripe_hash_table(struct btrfs_fs_info *info);
 void btrfs_free_stripe_hash_table(struct btrfs_fs_info *info);
 int btrfs_set_r5log(struct btrfs_fs_info *fs_info, struct btrfs_device *device);
+int btrfs_r5l_load_log(struct btrfs_fs_info *fs_info, u64 cp);
 #endif
-- 
2.9.4

