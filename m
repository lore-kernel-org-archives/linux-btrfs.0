Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49935 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751401AbdKVBiV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 20:38:21 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAM1cKQe023622
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Nov 2017 01:38:21 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vAM1cK2g028091
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Nov 2017 01:38:20 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vAM1cKho029443
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Nov 2017 01:38:20 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/7] Btrfs: get rbio inside fail_bio_stripe
Date: Tue, 21 Nov 2017 17:35:55 -0700
Message-Id: <20171122003558.28722-5-bo.li.liu@oracle.com>
In-Reply-To: <20171122003558.28722-1-bo.li.liu@oracle.com>
References: <20171122003558.28722-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Because rbio will be bio->private in any case, we can remove @rbio in
arguments.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/raid56.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 24a6222..aa04e5b 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -183,7 +183,7 @@ static void rmw_work(struct btrfs_work *work);
 static void read_rebuild_work(struct btrfs_work *work);
 static void async_rmw_stripe(struct btrfs_raid_bio *rbio);
 static void async_read_rebuild(struct btrfs_raid_bio *rbio);
-static int fail_bio_stripe(struct btrfs_raid_bio *rbio, struct bio *bio);
+static int fail_bio_stripe(struct bio *bio);
 static int fail_rbio_index(struct btrfs_raid_bio *rbio, int failed);
 static void __free_raid_bio(struct btrfs_raid_bio *rbio);
 static void index_rbio_pages(struct btrfs_raid_bio *rbio);
@@ -898,7 +898,7 @@ static void raid_write_end_io(struct bio *bio)
 	int max_errors;
 
 	if (err)
-		fail_bio_stripe(rbio, bio);
+		fail_bio_stripe(bio);
 
 	bio_put(bio);
 
@@ -1415,9 +1415,9 @@ static int fail_rbio_index(struct btrfs_raid_bio *rbio, int failed)
  * helper to fail a stripe based on a physical disk
  * bio.
  */
-static int fail_bio_stripe(struct btrfs_raid_bio *rbio,
-			   struct bio *bio)
+static int fail_bio_stripe(struct bio *bio)
 {
+	struct btrfs_raid_bio *rbio = bio->bi_private;
 	int failed = find_bio_stripe(rbio, bio);
 
 	if (failed < 0)
@@ -1455,7 +1455,7 @@ static void raid_rmw_end_io(struct bio *bio)
 	struct btrfs_raid_bio *rbio = bio->bi_private;
 
 	if (bio->bi_status)
-		fail_bio_stripe(rbio, bio);
+		fail_bio_stripe(bio);
 	else
 		set_bio_pages_uptodate(bio);
 
@@ -1998,7 +1998,7 @@ static void raid_recover_end_io(struct bio *bio)
 	 * up to date if there were no errors
 	 */
 	if (bio->bi_status)
-		fail_bio_stripe(rbio, bio);
+		fail_bio_stripe(bio);
 	else
 		set_bio_pages_uptodate(bio);
 	bio_put(bio);
@@ -2537,7 +2537,7 @@ static void raid56_parity_scrub_end_io(struct bio *bio)
 	struct btrfs_raid_bio *rbio = bio->bi_private;
 
 	if (bio->bi_status)
-		fail_bio_stripe(rbio, bio);
+		fail_bio_stripe(bio);
 	else
 		set_bio_pages_uptodate(bio);
 
-- 
2.9.4

