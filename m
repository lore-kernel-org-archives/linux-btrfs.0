Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44545 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751942AbdHARP4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 13:15:56 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v71HFuuv012819
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:56 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v71HFt4s021169
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:56 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v71HFt8C032297
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:55 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 14/14] Btrfs: raid56: maintain IO order on raid5/6 log
Date: Tue,  1 Aug 2017 10:14:37 -0600
Message-Id: <20170801161439.13426-15-bo.li.liu@oracle.com>
In-Reply-To: <20170801161439.13426-1-bo.li.liu@oracle.com>
References: <20170801161439.13426-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A typical write to the raid5/6 log needs three steps:

1) collect data/parity pages into the bio in io_unit;
2) submit the bio in io_unit;
3) writeback data/parity to raid array in end_io.

1) and 2) are protected within log->io_mutex, while 3) is not.

Since recovery needs to know the checkpoint offset where the highest
successful writeback is, we cannot allow IO to be reordered.  This is
adding a list in which IO order is maintained properly.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/raid56.c | 42 ++++++++++++++++++++++++++++++++++--------
 fs/btrfs/raid56.h |  5 +++++
 2 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index b771d7d..ceca415 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -183,6 +183,9 @@ struct btrfs_r5l_log {
 	/* protect this struct and log io */
 	struct mutex io_mutex;
 
+	spinlock_t io_list_lock;
+	struct list_head io_list;
+
 	/* r5log device */
 	struct btrfs_device *dev;
 
@@ -1205,6 +1208,7 @@ static struct btrfs_r5l_io_unit *btrfs_r5l_alloc_io_unit(struct btrfs_r5l_log *l
 static void btrfs_r5l_free_io_unit(struct btrfs_r5l_log *log, struct btrfs_r5l_io_unit *io)
 {
 	__free_page(io->meta_page);
+	ASSERT(list_empty(&io->list));
 	kfree(io);
 }
 
@@ -1225,6 +1229,27 @@ static void btrfs_r5l_reserve_log_entry(struct btrfs_r5l_log *log, struct btrfs_
 		io->need_split_bio = true;
 }
 
+/* the IO order is maintained in log->io_list. */
+static void btrfs_r5l_finish_io(struct btrfs_r5l_log *log)
+{
+	struct btrfs_r5l_io_unit *io, *next;
+
+	spin_lock(&log->io_list_lock);
+	list_for_each_entry_safe(io, next, &log->io_list, list) {
+		if (io->status != BTRFS_R5L_STRIPE_END)
+			break;
+
+#ifdef BTRFS_DEBUG_R5LOG
+	trace_printk("current log->next_checkpoint %llu (will be %llu after writing to RAID\n", log->next_checkpoint, io->log_start);
+#endif
+
+		list_del_init(&io->list);
+		log->next_checkpoint = io->log_start;
+		btrfs_r5l_free_io_unit(log, io);
+	}
+	spin_unlock(&log->io_list_lock);
+}
+
 static void btrfs_write_rbio(struct btrfs_raid_bio *rbio);
 
 static void btrfs_r5l_log_endio(struct bio *bio)
@@ -1234,18 +1259,12 @@ static void btrfs_r5l_log_endio(struct bio *bio)
 
 	bio_put(bio);
 
-#ifdef BTRFS_DEBUG_R5LOG
-	trace_printk("move data to disk(current log->next_checkpoint %llu (will be %llu after writing to RAID\n", log->next_checkpoint, io->log_start);
-#endif
 	/* move data to RAID. */
 	btrfs_write_rbio(io->rbio);
 
+	io->status = BTRFS_R5L_STRIPE_END;
 	/* After stripe data has been flushed into raid, set ->next_checkpoint. */
-	log->next_checkpoint = io->log_start;
-
-	if (log->current_io == io)
-		log->current_io = NULL;
-	btrfs_r5l_free_io_unit(log, io);
+	btrfs_r5l_finish_io(log);
 }
 
 static struct bio *btrfs_r5l_bio_alloc(struct btrfs_r5l_log *log)
@@ -1299,6 +1318,11 @@ static struct btrfs_r5l_io_unit *btrfs_r5l_new_meta(struct btrfs_r5l_log *log)
 	bio_add_page(io->current_bio, io->meta_page, PAGE_SIZE, 0);
 
 	btrfs_r5l_reserve_log_entry(log, io);
+
+	INIT_LIST_HEAD(&io->list);
+	spin_lock(&log->io_list_lock);
+	list_add_tail(&io->list, &log->io_list);
+	spin_unlock(&log->io_list_lock);
 	return io;
 }
 
@@ -3760,6 +3784,8 @@ struct btrfs_r5l_log * btrfs_r5l_init_log_prepare(struct btrfs_fs_info *fs_info,
 	ASSERT(sizeof(device->uuid) == BTRFS_UUID_SIZE);
 	log->uuid_csum = btrfs_crc32c(~0, device->uuid, sizeof(device->uuid));
 	mutex_init(&log->io_mutex);
+	spin_lock_init(&log->io_list_lock);
+	INIT_LIST_HEAD(&log->io_list);
 
 	return log;
 }
diff --git a/fs/btrfs/raid56.h b/fs/btrfs/raid56.h
index 2cc64a3..fc4ff20 100644
--- a/fs/btrfs/raid56.h
+++ b/fs/btrfs/raid56.h
@@ -43,11 +43,16 @@ static inline int nr_data_stripes(struct map_lookup *map)
 struct btrfs_r5l_log;
 #define BTRFS_R5LOG_MAGIC 0x6433c509
 
+#define BTRFS_R5L_STRIPE_END 1
+
 /* one meta block + several data + parity blocks */
 struct btrfs_r5l_io_unit {
 	struct btrfs_r5l_log *log;
 	struct btrfs_raid_bio *rbio;
 
+	struct list_head list;
+	int status;
+
 	/* store meta block */
 	struct page *meta_page;
 
-- 
2.9.4

