Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44273 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751510AbdKVBiV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 20:38:21 -0500
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAM1cKnp022099
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Nov 2017 01:38:20 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vAM1cJvc014923
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Nov 2017 01:38:20 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vAM1cJ3o019802
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Nov 2017 01:38:19 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/7] Btrfs: add helper __btrfs_end_bio
Date: Tue, 21 Nov 2017 17:35:53 -0700
Message-Id: <20171122003558.28722-3-bo.li.liu@oracle.com>
In-Reply-To: <20171122003558.28722-1-bo.li.liu@oracle.com>
References: <20171122003558.28722-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_end_bio() does two things, firstly it'd check and print errors
from the underlying layers, secondly it'd check whether it's the last
stripe for this IO (e.g. raid1 consists of two stripes for a single IO).

Since I'd like to do retry on write errors before failing write IO,
the above two parts need to be split.

This add a helper __btrfs_end_bio() to do the second part.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/volumes.c | 60 +++++++++++++++++++++++++++++++-----------------------
 1 file changed, 34 insertions(+), 26 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4835136..853f9ce 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5987,36 +5987,11 @@ static inline void btrfs_end_bbio(struct btrfs_bio *bbio, struct bio *bio)
 	btrfs_put_bbio(bbio);
 }
 
-static void btrfs_end_bio(struct bio *bio)
+static void __btrfs_end_bio(struct bio *bio)
 {
 	struct btrfs_bio *bbio = bio->bi_private;
 	int is_orig_bio = 0;
 
-	if (bio->bi_status) {
-		atomic_inc(&bbio->error);
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
-		}
-	}
-
 	if (bio == bbio->orig_bio)
 		is_orig_bio = 1;
 
@@ -6048,6 +6023,39 @@ static void btrfs_end_bio(struct bio *bio)
 	}
 }
 
+static void btrfs_end_bio(struct bio *bio)
+{
+	struct btrfs_bio *bbio = bio->bi_private;
+	int is_orig_bio = 0;
+
+	if (bio->bi_status) {
+		atomic_inc(&bbio->error);
+		if (bio->bi_status == BLK_STS_IOERR ||
+		    bio->bi_status == BLK_STS_TARGET) {
+			unsigned int stripe_index =
+				btrfs_io_bio(bio)->stripe_index;
+			struct btrfs_device *dev;
+
+			BUG_ON(stripe_index >= bbio->num_stripes);
+			dev = bbio->stripes[stripe_index].dev;
+			if (dev->bdev) {
+				if (bio_op(bio) == REQ_OP_WRITE)
+					btrfs_dev_stat_inc(dev,
+						BTRFS_DEV_STAT_WRITE_ERRS);
+				else
+					btrfs_dev_stat_inc(dev,
+						BTRFS_DEV_STAT_READ_ERRS);
+				if (bio->bi_opf & REQ_PREFLUSH)
+					btrfs_dev_stat_inc(dev,
+						BTRFS_DEV_STAT_FLUSH_ERRS);
+				btrfs_dev_stat_print_on_error(dev);
+			}
+		}
+	}
+
+	__btrfs_end_bio(bio);
+}
+
 /*
  * see run_scheduled_bios for a description of why bios are collected for
  * async submit.
-- 
2.9.4

