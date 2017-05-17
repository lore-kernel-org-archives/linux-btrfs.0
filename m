Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39941 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754313AbdEQXXd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 19:23:33 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v4HNNVqT013281
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 17 May 2017 23:23:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v4HNNVkn023493
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 17 May 2017 23:23:31 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v4HNNVpb023872
        for <linux-btrfs@vger.kernel.org>; Wed, 17 May 2017 23:23:31 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 7/8] Btrfs: unify naming of btrfs_io_bio
Date: Wed, 17 May 2017 16:22:51 -0600
Message-Id: <20170517222252.29242-8-bo.li.liu@oracle.com>
In-Reply-To: <20170517222252.29242-1-bo.li.liu@oracle.com>
References: <20170517222252.29242-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All dio endio functions are using io_bio for struct btrfs_io_bio, this
makes btrfs_submit_direct to follow this convention.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3060c66..042a13e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8431,16 +8431,16 @@ static void btrfs_submit_direct(struct bio *dio_bio, struct inode *inode,
 				loff_t file_offset)
 {
 	struct btrfs_dio_private *dip = NULL;
-	struct bio *io_bio = NULL;
-	struct btrfs_io_bio *btrfs_bio;
+	struct bio *bio = NULL;
+	struct btrfs_io_bio *io_bio;
 	int skip_sum;
 	bool write = (bio_op(dio_bio) == REQ_OP_WRITE);
 	int ret = 0;
 
 	skip_sum = BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM;
 
-	io_bio = btrfs_bio_clone(dio_bio, GFP_NOFS);
-	if (!io_bio) {
+	bio = btrfs_bio_clone(dio_bio, GFP_NOFS);
+	if (!bio) {
 		ret = -ENOMEM;
 		goto free_ordered;
 	}
@@ -8456,17 +8456,17 @@ static void btrfs_submit_direct(struct bio *dio_bio, struct inode *inode,
 	dip->logical_offset = file_offset;
 	dip->bytes = dio_bio->bi_iter.bi_size;
 	dip->disk_bytenr = (u64)dio_bio->bi_iter.bi_sector << 9;
-	io_bio->bi_private = dip;
-	dip->orig_bio = io_bio;
+	bio->bi_private = dip;
+	dip->orig_bio = bio;
 	dip->dio_bio = dio_bio;
 	atomic_set(&dip->pending_bios, 0);
-	btrfs_bio = btrfs_io_bio(io_bio);
-	btrfs_bio->logical = file_offset;
+	io_bio = btrfs_io_bio(bio);
+	io_bio->logical = file_offset;
 
 	if (write) {
-		io_bio->bi_end_io = btrfs_endio_direct_write;
+		bio->bi_end_io = btrfs_endio_direct_write;
 	} else {
-		io_bio->bi_end_io = btrfs_endio_direct_read;
+		bio->bi_end_io = btrfs_endio_direct_read;
 		dip->subio_endio = btrfs_subio_endio_read;
 	}
 
@@ -8489,8 +8489,8 @@ static void btrfs_submit_direct(struct bio *dio_bio, struct inode *inode,
 	if (!ret)
 		return;
 
-	if (btrfs_bio->end_io)
-		btrfs_bio->end_io(btrfs_bio, ret);
+	if (io_bio->end_io)
+		io_bio->end_io(io_bio, ret);
 
 free_ordered:
 	/*
@@ -8502,16 +8502,16 @@ static void btrfs_submit_direct(struct bio *dio_bio, struct inode *inode,
 	 * same as btrfs_endio_direct_[write|read] because we can't call these
 	 * callbacks - they require an allocated dip and a clone of dio_bio.
 	 */
-	if (io_bio && dip) {
-		io_bio->bi_error = -EIO;
-		bio_endio(io_bio);
+	if (bio && dip) {
+		bio->bi_error = -EIO;
+		bio_endio(bio);
 		/*
-		 * The end io callbacks free our dip, do the final put on io_bio
+		 * The end io callbacks free our dip, do the final put on bio
 		 * and all the cleanup and final put for dio_bio (through
 		 * dio_end_io()).
 		 */
 		dip = NULL;
-		io_bio = NULL;
+		bio = NULL;
 	} else {
 		if (write)
 			btrfs_endio_direct_write_update_ordered(inode,
@@ -8529,8 +8529,8 @@ static void btrfs_submit_direct(struct bio *dio_bio, struct inode *inode,
 		 */
 		dio_end_io(dio_bio, ret);
 	}
-	if (io_bio)
-		bio_put(io_bio);
+	if (bio)
+		bio_put(bio);
 	kfree(dip);
 }
 
-- 
2.9.4

