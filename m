Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49936 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751520AbdKVBiW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 20:38:22 -0500
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAM1cLaR023659
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Nov 2017 01:38:21 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vAM1cKgu024941
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Nov 2017 01:38:20 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vAM1cK4F031310
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Nov 2017 01:38:20 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/7] Btrfs: add helper __raid_write_end_io
Date: Tue, 21 Nov 2017 17:35:56 -0700
Message-Id: <20171122003558.28722-6-bo.li.liu@oracle.com>
In-Reply-To: <20171122003558.28722-1-bo.li.liu@oracle.com>
References: <20171122003558.28722-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We'd like to retry write on errors, so this splits raid_write_end_io()
to two parts, a) checking errors and b) the rest in a helper
__raid_write_end_io().

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/raid56.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index aa04e5b..aebc849 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -887,19 +887,12 @@ static void rbio_orig_end_io(struct btrfs_raid_bio *rbio, blk_status_t err)
 	}
 }
 
-/*
- * end io function used by finish_rmw.  When we finally
- * get here, we've written a full stripe
- */
-static void raid_write_end_io(struct bio *bio)
+static void __raid_write_end_io(struct bio *bio)
 {
 	struct btrfs_raid_bio *rbio = bio->bi_private;
-	blk_status_t err = bio->bi_status;
+	blk_status_t err;
 	int max_errors;
 
-	if (err)
-		fail_bio_stripe(bio);
-
 	bio_put(bio);
 
 	if (!atomic_dec_and_test(&rbio->stripes_pending))
@@ -917,6 +910,18 @@ static void raid_write_end_io(struct bio *bio)
 }
 
 /*
+ * end io function used by finish_rmw.  When we finally
+ * get here, we've written a full stripe
+ */
+static void raid_write_end_io(struct bio *bio)
+{
+	if (bio->bi_status)
+		fail_bio_stripe(bio);
+
+	__raid_write_end_io(bio);
+}
+
+/*
  * the read/modify/write code wants to use the original bio for
  * any pages it included, and then use the rbio for everything
  * else.  This function decides if a given index (stripe number)
-- 
2.9.4

