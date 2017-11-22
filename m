Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44280 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751527AbdKVBiW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 20:38:22 -0500
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAM1cLEG022109
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Nov 2017 01:38:21 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vAM1cKLp014941
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Nov 2017 01:38:20 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vAM1cKmR019857
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Nov 2017 01:38:20 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 6/7] Btrfs: retry write for raid56
Date: Tue, 21 Nov 2017 17:35:57 -0700
Message-Id: <20171122003558.28722-7-bo.li.liu@oracle.com>
In-Reply-To: <20171122003558.28722-1-bo.li.liu@oracle.com>
References: <20171122003558.28722-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Retry writes on raid56's final full stripe writes in order to get over
some transient errors in our IO stack.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/raid56.c | 42 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index aebc849..2e182f8 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -909,14 +909,49 @@ static void __raid_write_end_io(struct bio *bio)
 	rbio_orig_end_io(rbio, err);
 }
 
+struct btrfs_device *get_raid_device_from_bio(struct bio *bio)
+{
+	struct btrfs_raid_bio *rbio = bio->bi_private;
+	unsigned int stripe_index = btrfs_io_bio(bio)->stripe_index;
+
+	BUG_ON(stripe_index >= rbio->bbio->num_stripes);
+	return rbio->bbio->stripes[stripe_index].dev;
+}
+
+static void raid_handle_write_error(struct work_struct *work)
+{
+	struct btrfs_io_bio *io_bio;
+	struct bio *bio;
+	struct btrfs_device *dev;
+
+	io_bio = container_of(work, struct btrfs_io_bio, work);
+	bio = &io_bio->bio;
+	dev = get_raid_device_from_bio(bio);
+
+	if (!btrfs_narrow_write_error(bio, dev)) {
+		fail_bio_stripe(bio);
+		btrfs_record_bio_error(bio, dev);
+	}
+
+	__raid_write_end_io(bio);
+}
+
+static void raid_reschedule_bio(struct bio *bio)
+{
+	INIT_WORK(&btrfs_io_bio(bio)->work, raid_handle_write_error);
+	queue_work(system_unbound_wq, &btrfs_io_bio(bio)->work);
+}
+
 /*
  * end io function used by finish_rmw.  When we finally
  * get here, we've written a full stripe
  */
 static void raid_write_end_io(struct bio *bio)
 {
-	if (bio->bi_status)
-		fail_bio_stripe(bio);
+	if (bio->bi_status) {
+		raid_reschedule_bio(bio);
+		return;
+	}
 
 	__raid_write_end_io(bio);
 }
@@ -1108,6 +1143,7 @@ static int rbio_add_io_page(struct btrfs_raid_bio *rbio,
 	bio->bi_iter.bi_size = 0;
 	bio_set_dev(bio, stripe->dev->bdev);
 	bio->bi_iter.bi_sector = disk_start >> 9;
+	btrfs_io_bio(bio)->stripe_index = stripe_nr;
 
 	bio_add_page(bio, page, PAGE_SIZE, 0);
 	bio_list_add(bio_list, bio);
@@ -1324,6 +1360,7 @@ static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
 		bio->bi_private = rbio;
 		bio->bi_end_io = raid_write_end_io;
 		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
+		btrfs_io_bio(bio)->iter = bio->bi_iter;
 
 		submit_bio(bio);
 	}
@@ -2452,6 +2489,7 @@ static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
 		bio->bi_private = rbio;
 		bio->bi_end_io = raid_write_end_io;
 		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
+		btrfs_io_bio(bio)->iter = bio->bi_iter;
 
 		submit_bio(bio);
 	}
-- 
2.9.4

