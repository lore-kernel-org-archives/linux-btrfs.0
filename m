Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51649 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751878AbdJTJvK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Oct 2017 05:51:10 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9K9p9BK020922
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Oct 2017 09:51:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v9K9p9Bb001423
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Oct 2017 09:51:09 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v9K9p9qo014170
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Oct 2017 09:51:09 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: clean up btrfs_dev_stat_inc() usage
Date: Fri, 20 Oct 2017 17:50:59 +0800
Message-Id: <20171020095059.3730-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_end_bio() is using btrfs_dev_stat_inc() and then
btrfs_dev_stat_print_on_error() separately instead
use btrfs_dev_stat_inc_and_print() directly.

No need to worry about print lines one for read/write
and another if the source of IO request is flush, since
as mentioned in this patch
 [patch] btrfs: REQ_PREFLUSH does not use btrfs_end_bio() completion callback
there isn't any IO which is doing that.

This consolidation is a preparatory patch to add device
critical error handling in btrfs_dev_stat_inc_and_print()
and can be renamed as needed.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index efaf85dd91b0..d1d8aa226bff 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6004,15 +6004,14 @@ static void btrfs_end_bio(struct bio *bio)
 			dev = bbio->stripes[stripe_index].dev;
 			if (dev->bdev) {
 				if (bio_op(bio) == REQ_OP_WRITE)
-					btrfs_dev_stat_inc(dev,
+					btrfs_dev_stat_inc_and_print(dev,
 						BTRFS_DEV_STAT_WRITE_ERRS);
 				else
-					btrfs_dev_stat_inc(dev,
+					btrfs_dev_stat_inc_and_print(dev,
 						BTRFS_DEV_STAT_READ_ERRS);
 				if (bio->bi_opf & REQ_PREFLUSH)
-					btrfs_dev_stat_inc(dev,
+					btrfs_dev_stat_inc_and_print(dev,
 						BTRFS_DEV_STAT_FLUSH_ERRS);
-				btrfs_dev_stat_print_on_error(dev);
 			}
 		}
 	}
-- 
2.13.1

