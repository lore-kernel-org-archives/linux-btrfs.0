Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44282 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751538AbdKVBiW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 20:38:22 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAM1cLZY022111
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Nov 2017 01:38:21 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vAM1cK4h022999
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Nov 2017 01:38:21 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vAM1cK1I014777
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Nov 2017 01:38:20 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 7/7] Btrfs: retry the whole bio on write error
Date: Tue, 21 Nov 2017 17:35:58 -0700
Message-Id: <20171122003558.28722-8-bo.li.liu@oracle.com>
In-Reply-To: <20171122003558.28722-1-bo.li.liu@oracle.com>
References: <20171122003558.28722-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since we haven't included badblocks support in our retry path, instead
of retry sector by sector only retry the whole bio to give it an extra
chance.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/volumes.c | 72 ++++++++++--------------------------------------------
 1 file changed, 13 insertions(+), 59 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c11db0b..395b03c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6033,74 +6033,28 @@ static inline struct btrfs_device *get_device_from_bio(struct bio *bio)
 }
 
 /*
- * return 1 if every sector retry returns successful.
- * return 0 if one or more sector retries fails.
+ * Return 1 if retry returns successful.
+ * Return 0 otherwise.
  */
 int btrfs_narrow_write_error(struct bio *bio, struct btrfs_device *dev)
 {
 	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
-	u64 sectors_to_write;
-	u64 offset;
-	u64 orig;
-	u64 unit;
-	u64 block_sectors;
-	int ok = 1;
+	int ret = 1;
 	struct bio *wbio;
 
-	/* offset and unit are bytes aligned, not 512-bytes aligned. */
-	sectors_to_write = io_bio->iter.bi_size >> 9;
-	orig = io_bio->iter.bi_sector;
-	offset = 0;
-	block_sectors = bdev_logical_block_size(dev->bdev) >> 9;
-	unit = block_sectors;
-	ASSERT(unit == 1);
-
-	while (1) {
-		if (!sectors_to_write)
-			break;
-		/*
-		 * LIUBO: I don't think unit > sectors_to_write could
-		 * happen, sectors_to_write should be aligned to PAGE_SIZE
-		 * which is > unit.  Just in case.
-		 */
-		if (unit > sectors_to_write) {
-			WARN_ONCE(1, "unit %llu > sectors_to_write (%llu)\n", unit, sectors_to_write);
-			unit = sectors_to_write;
-		}
-
-		/* write @unit bytes at @offset */
-		/* this would never fail, check btrfs_bio_clone(). */
-		wbio = btrfs_bio_clone(bio);
-		wbio->bi_opf = REQ_OP_WRITE;
-		wbio->bi_iter = io_bio->iter;
+	/* this would never fail, check btrfs_bio_clone(). */
+	wbio = btrfs_bio_clone(bio);
+	wbio->bi_opf = REQ_OP_WRITE;
+	wbio->bi_iter = io_bio->iter;
 
-		bio_trim(wbio, offset, unit);
-		bio_copy_dev(wbio, bio);
+	bio_copy_dev(wbio, bio);
 
-		/* submit in sync way */
-		/*
-		 * LIUBO: There is an issue, if this bio is quite
-		 * large, say 1M or 2M, and sector size is just 512,
-		 * then this may take a while.
-		 *
-		 * May need to schedule the job to workqueue.
-		 */
-		if (submit_bio_wait(wbio) < 0) {
-			ok = 0 && ok;
-			/*
-			 * This is not correct if badblocks is enabled
-			 * as we need to record every bad sector by
-			 * trying sectors one by one.
-			 */
-			break;
-		}
+	/* submit in sync way */
+	if (submit_bio_wait(wbio) < 0)
+		ret = 0;
 
-		bio_put(wbio);
-		offset += unit;
-		sectors_to_write -= unit;
-		unit = block_sectors;
-	}
-	return ok;
+	bio_put(wbio);
+	return ret;
 }
 
 void btrfs_record_bio_error(struct bio *bio, struct btrfs_device *dev)
-- 
2.9.4

