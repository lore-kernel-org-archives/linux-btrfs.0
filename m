Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44272 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751515AbdKVBiV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 20:38:21 -0500
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAM1cKCp022098
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Nov 2017 01:38:20 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vAM1cKk0014926
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Nov 2017 01:38:20 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vAM1cJVp029440
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Nov 2017 01:38:19 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/7] Btrfs: retry write for non-raid56
Date: Tue, 21 Nov 2017 17:35:54 -0700
Message-Id: <20171122003558.28722-4-bo.li.liu@oracle.com>
In-Reply-To: <20171122003558.28722-1-bo.li.liu@oracle.com>
References: <20171122003558.28722-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the underlying protocal doesn't support retry and there are some
transient errors happening somewhere in our IO stack, we'd like to
give an extra chance for IO.

In btrfs, read retry is handled in bio_readpage_error() with the retry
unit being page size , for write retry however, we're going to do it
in a different way, as a write may consist of several writes onto
different stripes, retry write needs to be done right after the IO on
each stripe completes and reaches to endio.

As write errors are really corner cases, performance impact is not
considered.

This adds code to retry write on errors _sector by sector_ in order to
find out which sector is really bad so that we can mark it somewhere.
And since endio is running in interrupt context, the real retry work
is scheduled in system_unbound_wq in order to get a normal context.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/volumes.c | 162 +++++++++++++++++++++++++++++++++++++++++++++--------
 fs/btrfs/volumes.h |   3 +
 2 files changed, 142 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 853f9ce..c11db0b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6023,34 +6023,150 @@ static void __btrfs_end_bio(struct bio *bio)
 	}
 }
 
-static void btrfs_end_bio(struct bio *bio)
+static inline struct btrfs_device *get_device_from_bio(struct bio *bio)
 {
 	struct btrfs_bio *bbio = bio->bi_private;
-	int is_orig_bio = 0;
+	unsigned int stripe_index = btrfs_io_bio(bio)->stripe_index;
+
+	BUG_ON(stripe_index >= bbio->num_stripes);
+	return bbio->stripes[stripe_index].dev;
+}
+
+/*
+ * return 1 if every sector retry returns successful.
+ * return 0 if one or more sector retries fails.
+ */
+int btrfs_narrow_write_error(struct bio *bio, struct btrfs_device *dev)
+{
+	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
+	u64 sectors_to_write;
+	u64 offset;
+	u64 orig;
+	u64 unit;
+	u64 block_sectors;
+	int ok = 1;
+	struct bio *wbio;
+
+	/* offset and unit are bytes aligned, not 512-bytes aligned. */
+	sectors_to_write = io_bio->iter.bi_size >> 9;
+	orig = io_bio->iter.bi_sector;
+	offset = 0;
+	block_sectors = bdev_logical_block_size(dev->bdev) >> 9;
+	unit = block_sectors;
+	ASSERT(unit == 1);
+
+	while (1) {
+		if (!sectors_to_write)
+			break;
+		/*
+		 * LIUBO: I don't think unit > sectors_to_write could
+		 * happen, sectors_to_write should be aligned to PAGE_SIZE
+		 * which is > unit.  Just in case.
+		 */
+		if (unit > sectors_to_write) {
+			WARN_ONCE(1, "unit %llu > sectors_to_write (%llu)\n", unit, sectors_to_write);
+			unit = sectors_to_write;
+		}
+
+		/* write @unit bytes at @offset */
+		/* this would never fail, check btrfs_bio_clone(). */
+		wbio = btrfs_bio_clone(bio);
+		wbio->bi_opf = REQ_OP_WRITE;
+		wbio->bi_iter = io_bio->iter;
+
+		bio_trim(wbio, offset, unit);
+		bio_copy_dev(wbio, bio);
+
+		/* submit in sync way */
+		/*
+		 * LIUBO: There is an issue, if this bio is quite
+		 * large, say 1M or 2M, and sector size is just 512,
+		 * then this may take a while.
+		 *
+		 * May need to schedule the job to workqueue.
+		 */
+		if (submit_bio_wait(wbio) < 0) {
+			ok = 0 && ok;
+			/*
+			 * This is not correct if badblocks is enabled
+			 * as we need to record every bad sector by
+			 * trying sectors one by one.
+			 */
+			break;
+		}
+
+		bio_put(wbio);
+		offset += unit;
+		sectors_to_write -= unit;
+		unit = block_sectors;
+	}
+	return ok;
+}
+
+void btrfs_record_bio_error(struct bio *bio, struct btrfs_device *dev)
+{
+	if (bio->bi_status == BLK_STS_IOERR ||
+	    bio->bi_status == BLK_STS_TARGET) {
+		if (dev->bdev) {
+			if (bio_data_dir(bio) == WRITE)
+				btrfs_dev_stat_inc(dev,
+						   BTRFS_DEV_STAT_WRITE_ERRS);
+			else
+				btrfs_dev_stat_inc(dev,
+						   BTRFS_DEV_STAT_READ_ERRS);
+			if (bio->bi_opf & REQ_PREFLUSH)
+				btrfs_dev_stat_inc(dev,
+						   BTRFS_DEV_STAT_FLUSH_ERRS);
+			btrfs_dev_stat_print_on_error(dev);
+		}
+	}
+}
+
+static void btrfs_handle_bio_error(struct work_struct *work)
+{
+	struct btrfs_io_bio *io_bio = container_of(work, struct btrfs_io_bio,
+						   work);
+	struct bio *bio = &io_bio->bio;
+	struct btrfs_device *dev = get_device_from_bio(bio);
+
+	ASSERT(bio_data_dir(bio) == WRITE);
+
+	if (!btrfs_narrow_write_error(bio, dev)) {
+		/* inc error counter if narrow (retry) fails */
+		struct btrfs_bio *bbio = bio->bi_private;
 
-	if (bio->bi_status) {
 		atomic_inc(&bbio->error);
-		if (bio->bi_status == BLK_STS_IOERR ||
-		    bio->bi_status == BLK_STS_TARGET) {
-			unsigned int stripe_index =
-				btrfs_io_bio(bio)->stripe_index;
-			struct btrfs_device *dev;
-
-			BUG_ON(stripe_index >= bbio->num_stripes);
-			dev = bbio->stripes[stripe_index].dev;
-			if (dev->bdev) {
-				if (bio_op(bio) == REQ_OP_WRITE)
-					btrfs_dev_stat_inc(dev,
-						BTRFS_DEV_STAT_WRITE_ERRS);
-				else
-					btrfs_dev_stat_inc(dev,
-						BTRFS_DEV_STAT_READ_ERRS);
-				if (bio->bi_opf & REQ_PREFLUSH)
-					btrfs_dev_stat_inc(dev,
-						BTRFS_DEV_STAT_FLUSH_ERRS);
-				btrfs_dev_stat_print_on_error(dev);
-			}
+		btrfs_record_bio_error(bio, dev);
+	}
+
+	__btrfs_end_bio(bio);
+}
+
+/* running in irq context */
+static void btrfs_reschedule_retry(struct bio *bio)
+{
+	INIT_WORK(&btrfs_io_bio(bio)->work, btrfs_handle_bio_error);
+	/* _temporarily_ use system_unbound_wq */
+	queue_work(system_unbound_wq, &btrfs_io_bio(bio)->work);
+}
+
+static void btrfs_end_bio(struct bio *bio)
+{
+	if (bio->bi_status) {
+		struct btrfs_bio *bbio = bio->bi_private;
+
+		if (bio_data_dir(bio) == WRITE) {
+			btrfs_reschedule_retry(bio);
+			return;
 		}
+
+		atomic_inc(&bbio->error);
+
+		/* I don't think we can have REQ_PREFLUSH, but just in case. */
+		WARN_ON_ONCE(bio->bi_opf & REQ_PREFLUSH);
+
+		/* REQ_PREFLUSH */
+		btrfs_record_bio_error(bio, get_device_from_bio(bio));
 	}
 
 	__btrfs_end_bio(bio);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 6108fdf..c1da27f 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -281,6 +281,7 @@ struct btrfs_io_bio {
 	u8 csum_inline[BTRFS_BIO_INLINE_CSUM_SIZE];
 	u8 *csum_allocated;
 	btrfs_io_bio_end_io_t *end_io;
+	struct work_struct work;
 	struct bvec_iter iter;
 	/*
 	 * This member must come last, bio_alloc_bioset will allocate enough
@@ -544,5 +545,7 @@ void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info);
 bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info);
 void btrfs_report_missing_device(struct btrfs_fs_info *fs_info, u64 devid,
 				 u8 *uuid);
+int btrfs_narrow_write_error(struct bio *bio, struct btrfs_device *dev);
+void btrfs_record_bio_error(struct bio *bio, struct btrfs_device *dev);
 
 #endif
-- 
2.9.4

