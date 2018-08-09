Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:41198 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727407AbeHIUcM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Aug 2018 16:32:12 -0400
From: Naohiro Aota <naota@elisp.net>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Matias Bjorling <mb@lightnvm.io>, Naohiro Aota <naota@elisp.net>
Subject: [RFC PATCH 10/17] btrfs: split btrfs_map_bio()
Date: Fri, 10 Aug 2018 03:04:43 +0900
Message-Id: <20180809180450.5091-11-naota@elisp.net>
In-Reply-To: <20180809180450.5091-1-naota@elisp.net>
References: <20180809180450.5091-1-naota@elisp.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch splits btrfs_map_bio() into two functions so that the following
patches can make use of the latter part of this function. The first part of
btrfs_map_bio() maps bios to a btrfs_bio and the second part submits the
mapped bios in btrfs_bio to the actual devices.

By splitting the function, we can now reuse the latter part to send
buffered btrfs_bio.

Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 fs/btrfs/volumes.c | 53 +++++++++++++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ada13120c2cd..08d13da2553f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6435,17 +6435,44 @@ static void bbio_error(struct btrfs_bio *bbio, struct bio *bio, u64 logical)
 	}
 }
 
+static void __btrfs_map_bio(struct btrfs_fs_info *fs_info, u64 logical,
+			    struct btrfs_bio *bbio, int async_submit)
+{
+	struct btrfs_device *dev;
+	int dev_nr;
+	int total_devs;
+	struct bio *first_bio = bbio->orig_bio;
+	struct bio *bio = first_bio;
+
+	total_devs = bbio->num_stripes;
+	for (dev_nr = 0; dev_nr < total_devs; dev_nr++) {
+		dev = bbio->stripes[dev_nr].dev;
+		if (!dev || !dev->bdev ||
+		    (bio_op(first_bio) == REQ_OP_WRITE &&
+		     !test_bit(BTRFS_DEV_STATE_WRITEABLE, &dev->dev_state))) {
+			bbio_error(bbio, first_bio, logical);
+			continue;
+		}
+
+		if (dev_nr < total_devs - 1)
+			bio = btrfs_bio_clone(first_bio);
+		else
+			bio = first_bio;
+
+		submit_stripe_bio(bbio, bio, bbio->stripes[dev_nr].physical,
+				  dev_nr, async_submit);
+	}
+	btrfs_bio_counter_dec(fs_info);
+}
+
 blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 			   int mirror_num, int async_submit)
 {
-	struct btrfs_device *dev;
 	struct bio *first_bio = bio;
 	u64 logical = (u64)bio->bi_iter.bi_sector << 9;
 	u64 length = 0;
 	u64 map_length;
 	int ret;
-	int dev_nr;
-	int total_devs;
 	struct btrfs_bio *bbio = NULL;
 
 	length = bio->bi_iter.bi_size;
@@ -6459,7 +6486,6 @@ blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 		return errno_to_blk_status(ret);
 	}
 
-	total_devs = bbio->num_stripes;
 	bbio->orig_bio = first_bio;
 	bbio->private = first_bio->bi_private;
 	bbio->end_io = first_bio->bi_end_io;
@@ -6489,24 +6515,7 @@ blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 		BUG();
 	}
 
-	for (dev_nr = 0; dev_nr < total_devs; dev_nr++) {
-		dev = bbio->stripes[dev_nr].dev;
-		if (!dev || !dev->bdev ||
-		    (bio_op(first_bio) == REQ_OP_WRITE &&
-		    !test_bit(BTRFS_DEV_STATE_WRITEABLE, &dev->dev_state))) {
-			bbio_error(bbio, first_bio, logical);
-			continue;
-		}
-
-		if (dev_nr < total_devs - 1)
-			bio = btrfs_bio_clone(first_bio);
-		else
-			bio = first_bio;
-
-		submit_stripe_bio(bbio, bio, bbio->stripes[dev_nr].physical,
-				  dev_nr, async_submit);
-	}
-	btrfs_bio_counter_dec(fs_info);
+	__btrfs_map_bio(fs_info, logical, bbio, async_submit);
 	return BLK_STS_OK;
 }
 
-- 
2.18.0

