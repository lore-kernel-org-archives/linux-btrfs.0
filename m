Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40866 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753230AbdJNAgO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Oct 2017 20:36:14 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9E0aD68030965
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Oct 2017 00:36:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v9E0aCQO022645
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Oct 2017 00:36:13 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v9E0aCoW022707
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Oct 2017 00:36:12 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: use BLK_STS defines where needed
Date: Sat, 14 Oct 2017 08:35:56 +0800
Message-Id: <20171014003556.8038-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

At few places we could use BLK_STS_OK and BLK_STS_NOSUPP.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/compression.c | 3 ++-
 fs/btrfs/inode.c       | 4 ++--
 fs/btrfs/volumes.c     | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index b51d23f5cafa..43d4b51556ec 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -239,7 +239,8 @@ static void end_compressed_bio_write(struct bio *bio)
 					 cb->start,
 					 cb->start + cb->len - 1,
 					 NULL,
-					 bio->bi_status ? 0 : 1);
+					 bio->bi_status ?
+					 BLK_STS_OK : BLK_STS_NOTSUPP);
 	cb->compressed_pages[0]->mapping = NULL;
 
 	end_compressed_writeback(inode, cb);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 128f3e58634f..9aa03c89ad86 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8360,7 +8360,7 @@ static void btrfs_endio_direct_read(struct bio *bio)
 	if (dip->flags & BTRFS_DIO_ORIG_BIO_SUBMITTED) {
 		err = btrfs_subio_endio_read(inode, io_bio, err);
 		if (!err)
-			bio->bi_status = 0;
+			bio->bi_status = BLK_STS_OK;
 	}
 
 	unlock_extent(&BTRFS_I(inode)->io_tree, dip->logical_offset,
@@ -8478,7 +8478,7 @@ static void btrfs_end_dio_bio(struct bio *bio)
 	if (dip->errors) {
 		bio_io_error(dip->orig_bio);
 	} else {
-		dip->dio_bio->bi_status = 0;
+		dip->dio_bio->bi_status = BLK_STS_OK;
 		bio_endio(dip->orig_bio);
 	}
 out:
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a61405c2cd31..15e017af756c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6020,7 +6020,7 @@ static void btrfs_end_bio(struct bio *bio)
 			 * this bio is actually up to date, we didn't
 			 * go over the max number of errors
 			 */
-			bio->bi_status = 0;
+			bio->bi_status = BLK_STS_OK;
 		}
 
 		btrfs_end_bbio(bbio, bio);
-- 
2.13.1

