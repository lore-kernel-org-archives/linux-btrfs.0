Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33886 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751795AbdIVTNK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Sep 2017 15:13:10 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v8MJD9Qc000652
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Sep 2017 19:13:09 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v8MJD9RR008963
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Sep 2017 19:13:09 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v8MJD8Mk028556
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Sep 2017 19:13:08 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix memory leak in raid56
Date: Fri, 22 Sep 2017 12:11:18 -0600
Message-Id: <20170922181118.16878-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The local bio_list may have pending bios when doing cleanup, it can
end up with memory leak if they don't get free'd.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/raid56.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 2cf6ba4..063a2a0 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1325,6 +1325,9 @@ static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
 
 cleanup:
 	rbio_orig_end_io(rbio, BLK_STS_IOERR);
+
+	while ((bio = bio_list_pop(&bio_list)))
+		bio_put(bio);
 }
 
 /*
@@ -1580,6 +1583,10 @@ static int raid56_rmw_stripe(struct btrfs_raid_bio *rbio)
 
 cleanup:
 	rbio_orig_end_io(rbio, BLK_STS_IOERR);
+
+	while ((bio = bio_list_pop(&bio_list)))
+		bio_put(bio);
+
 	return -EIO;
 
 finish:
@@ -2105,6 +2112,10 @@ static int __raid56_parity_recover(struct btrfs_raid_bio *rbio)
 	if (rbio->operation == BTRFS_RBIO_READ_REBUILD ||
 	    rbio->operation == BTRFS_RBIO_REBUILD_MISSING)
 		rbio_orig_end_io(rbio, BLK_STS_IOERR);
+
+	while ((bio = bio_list_pop(&bio_list)))
+		bio_put(bio);
+
 	return -EIO;
 }
 
@@ -2452,6 +2463,9 @@ static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
 
 cleanup:
 	rbio_orig_end_io(rbio, BLK_STS_IOERR);
+
+	while ((bio = bio_list_pop(&bio_list)))
+		bio_put(bio);
 }
 
 static inline int is_data_stripe(struct btrfs_raid_bio *rbio, int stripe)
@@ -2561,12 +2575,12 @@ static void raid56_parity_scrub_stripe(struct btrfs_raid_bio *rbio)
 	int stripe;
 	struct bio *bio;
 
+	bio_list_init(&bio_list);
+
 	ret = alloc_rbio_essential_pages(rbio);
 	if (ret)
 		goto cleanup;
 
-	bio_list_init(&bio_list);
-
 	atomic_set(&rbio->error, 0);
 	/*
 	 * build a list of bios to read all the missing parts of this
@@ -2634,6 +2648,10 @@ static void raid56_parity_scrub_stripe(struct btrfs_raid_bio *rbio)
 
 cleanup:
 	rbio_orig_end_io(rbio, BLK_STS_IOERR);
+
+	while ((bio = bio_list_pop(&bio_list)))
+		bio_put(bio);
+
 	return;
 
 finish:
-- 
2.9.4

