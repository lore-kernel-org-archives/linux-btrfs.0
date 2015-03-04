Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:40183 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932666AbbCDSm0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Mar 2015 13:42:26 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t24IfWNf016421
	for <linux-btrfs@vger.kernel.org>; Thu, 5 Mar 2015 02:41:32 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 5/6] btrfs: Use raid_write_end_io for scrub
Date: Thu, 5 Mar 2015 02:41:11 +0800
Message-ID: <43e89ebcab7349a011fa24474695ee6720813410.1425494151.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <86557aad51883ada25ace853f10d1474e8db048e.1425494151.git.zhaolei@cn.fujitsu.com>
References: <86557aad51883ada25ace853f10d1474e8db048e.1425494151.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

No need to create additional end_io function for scrub, it can use
existing raid_write_end_io() instead.

This patch also fixed some wrong comments.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/raid56.c | 36 ++++++++----------------------------
 1 file changed, 8 insertions(+), 28 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 0a40d07..2285e78 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -897,6 +897,7 @@ static void rbio_orig_end_io(struct btrfs_raid_bio *rbio, int err, int uptodate)
 static void raid_write_end_io(struct bio *bio, int err)
 {
 	struct btrfs_raid_bio *rbio = bio->bi_private;
+	int max_errors;
 
 	if (err)
 		fail_bio_stripe(rbio, bio);
@@ -906,10 +907,13 @@ static void raid_write_end_io(struct bio *bio, int err)
 	if (!atomic_dec_and_test(&rbio->stripes_pending))
 		return;
 
-	err = 0;
+	/* OK, we have wrote all the stripes we need to. */
+	if (rbio->operation == BTRFS_RBIO_PARITY_SCRUB)
+		max_errors = 0;
+	else
+		max_errors = rbio->bbio->max_errors;
 
-	/* OK, we have read all the stripes we need to. */
-	if (atomic_read(&rbio->error) > rbio->bbio->max_errors)
+	if (atomic_read(&rbio->error) > max_errors)
 		err = -EIO;
 
 	rbio_orig_end_io(rbio, err, 0);
@@ -2276,30 +2280,6 @@ static int alloc_rbio_essential_pages(struct btrfs_raid_bio *rbio)
 	return 0;
 }
 
-/*
- * end io function used by finish_rmw.  When we finally
- * get here, we've written a full stripe
- */
-static void raid_write_parity_end_io(struct bio *bio, int err)
-{
-	struct btrfs_raid_bio *rbio = bio->bi_private;
-
-	if (err)
-		fail_bio_stripe(rbio, bio);
-
-	bio_put(bio);
-
-	if (!atomic_dec_and_test(&rbio->stripes_pending))
-		return;
-
-	err = 0;
-
-	if (atomic_read(&rbio->error))
-		err = -EIO;
-
-	rbio_orig_end_io(rbio, err, 0);
-}
-
 static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
 					 int need_check)
 {
@@ -2452,7 +2432,7 @@ submit_write:
 			break;
 
 		bio->bi_private = rbio;
-		bio->bi_end_io = raid_write_parity_end_io;
+		bio->bi_end_io = raid_write_end_io;
 		BUG_ON(!test_bit(BIO_UPTODATE, &bio->bi_flags));
 		submit_bio(WRITE, bio);
 	}
-- 
1.8.5.1

