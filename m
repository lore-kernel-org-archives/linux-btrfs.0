Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33477 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751866AbdHARPz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 13:15:55 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v71HFsd4002155
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v71HFsc1021074
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:54 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v71HFr7d022516
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:53 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 06/14] Btrfs: raid56: add reclaim support
Date: Tue,  1 Aug 2017 10:14:29 -0600
Message-Id: <20170801161439.13426-7-bo.li.liu@oracle.com>
In-Reply-To: <20170801161439.13426-1-bo.li.liu@oracle.com>
References: <20170801161439.13426-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The log space is limited, so reclaim is necessary when there is not enough space to use.

By recording the largest position we've written to the log disk and
flushing all disks' cache and the superblock, we can be sure that data
and parity before this position have the identical copy in the log and
raid5/6 array.

Also we need to take care of the case when IOs get reordered.  A list
is used to keep the order right.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.h       | 10 +++++++-
 fs/btrfs/raid56.c      | 63 ++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/transaction.c |  2 ++
 3 files changed, 72 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index d967627..9235643 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -244,8 +244,10 @@ struct btrfs_super_block {
 	__le64 cache_generation;
 	__le64 uuid_tree_generation;
 
+	/* r5log journal tail (where recovery starts) */
+	__le64 journal_tail;
 	/* future expansion */
-	__le64 reserved[30];
+	__le64 reserved[29];
 	u8 sys_chunk_array[BTRFS_SYSTEM_CHUNK_ARRAY_SIZE];
 	struct btrfs_root_backup super_roots[BTRFS_NUM_BACKUP_ROOTS];
 } __attribute__ ((__packed__));
@@ -2291,6 +2293,8 @@ BTRFS_SETGET_STACK_FUNCS(super_log_root_transid, struct btrfs_super_block,
 			 log_root_transid, 64);
 BTRFS_SETGET_STACK_FUNCS(super_log_root_level, struct btrfs_super_block,
 			 log_root_level, 8);
+BTRFS_SETGET_STACK_FUNCS(super_journal_tail, struct btrfs_super_block,
+			 journal_tail, 64);
 BTRFS_SETGET_STACK_FUNCS(super_total_bytes, struct btrfs_super_block,
 			 total_bytes, 64);
 BTRFS_SETGET_STACK_FUNCS(super_bytes_used, struct btrfs_super_block,
@@ -3284,6 +3288,10 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 			unsigned long new_flags);
 int btrfs_sync_fs(struct super_block *sb, int wait);
 
+/* raid56.c */
+void btrfs_r5l_write_journal_tail(struct btrfs_fs_info *fs_info);
+
+
 static inline __printf(2, 3)
 void btrfs_no_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
 {
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 007ba63..60010a6 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -191,6 +191,8 @@ struct btrfs_r5l_log {
 	u64 data_offset;
 	u64 device_size;
 
+	u64 next_checkpoint;
+
 	u64 last_checkpoint;
 	u64 last_cp_seq;
 	u64 seq;
@@ -1231,11 +1233,14 @@ static void btrfs_r5l_log_endio(struct bio *bio)
 	bio_put(bio);
 
 #ifdef BTRFS_DEBUG_R5LOG
-	trace_printk("move data to disk\n");
+	trace_printk("move data to disk(current log->next_checkpoint %llu (will be %llu after writing to RAID\n", log->next_checkpoint, io->log_start);
 #endif
 	/* move data to RAID. */
 	btrfs_write_rbio(io->rbio);
 
+	/* After stripe data has been flushed into raid, set ->next_checkpoint. */
+	log->next_checkpoint = io->log_start;
+
 	if (log->current_io == io)
 		log->current_io = NULL;
 	btrfs_r5l_free_io_unit(log, io);
@@ -1473,6 +1478,42 @@ static bool btrfs_r5l_has_free_space(struct btrfs_r5l_log *log, u64 size)
 }
 
 /*
+ * writing super with log->next_checkpoint
+ *
+ * This is protected by log->io_mutex.
+ */
+static void btrfs_r5l_write_super(struct btrfs_fs_info *fs_info, u64 cp)
+{
+	int ret;
+
+#ifdef BTRFS_DEBUG_R5LOG
+	trace_printk("r5l writing super to reclaim space, cp %llu\n", cp);
+#endif
+
+	btrfs_set_super_journal_tail(fs_info->super_for_commit, cp);
+
+	/*
+	 * flush all disk cache so that all data prior to
+	 * %next_checkpoint lands on raid disks(recovery will start
+	 * from %next_checkpoint).
+	 */
+	ret = write_all_supers(fs_info, 1);
+	ASSERT(ret == 0);
+}
+
+/* this is called by commit transaction and it's followed by writing super. */
+void btrfs_r5l_write_journal_tail(struct btrfs_fs_info *fs_info)
+{
+	if (fs_info->r5log) {
+		u64 cp = READ_ONCE(fs_info->r5log->next_checkpoint);
+
+		trace_printk("journal_tail %llu\n", cp);
+		btrfs_set_super_journal_tail(fs_info->super_copy, cp);
+		WRITE_ONCE(fs_info->r5log->last_checkpoint, cp);
+	}
+}
+
+/*
  * return 0 if data/parity are written into log and it will move data
  * to RAID in endio.
  *
@@ -1535,7 +1576,25 @@ static int btrfs_r5l_write_stripe(struct btrfs_raid_bio *rbio)
 		btrfs_r5l_log_stripe(log, data_pages, parity_pages, rbio);
 		do_submit = true;
 	} else {
-		; /* XXX: reclaim */
+#ifdef BTRFS_DEBUG_R5LOG
+		trace_printk("r5log: no space log->last_checkpoint %llu log->log_start %llu log->next_checkpoint %llu\n", log->last_checkpoint, log->log_start, log->next_checkpoint);
+#endif
+
+		/*
+		 * reclaim works via writing to log device with the
+		 * new next_checkpoint.
+		 */
+		btrfs_r5l_write_super(rbio->fs_info, log->next_checkpoint);
+
+		log->last_checkpoint = log->next_checkpoint;
+
+#ifdef BTRFS_DEBUG_R5LOG
+		trace_printk("r5log: after reclaim(write super) log->last_checkpoint %llu log->log_start %llu log->next_checkpoint %llu\n", log->last_checkpoint, log->log_start, log->next_checkpoint);
+#endif
+		/* now we should have enough space. */
+		ASSERT(btrfs_r5l_has_free_space(log, reserve));
+		btrfs_r5l_log_stripe(log, data_pages, parity_pages, rbio);
+		do_submit = true;
 	}
 
 	if (do_submit) {
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 2168654..e312e5a 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2238,6 +2238,8 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 
 	btrfs_set_super_log_root(fs_info->super_copy, 0);
 	btrfs_set_super_log_root_level(fs_info->super_copy, 0);
+	btrfs_r5l_write_journal_tail(fs_info);
+
 	memcpy(fs_info->super_for_commit, fs_info->super_copy,
 	       sizeof(*fs_info->super_copy));
 
-- 
2.9.4

