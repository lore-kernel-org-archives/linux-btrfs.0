Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25106 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753455AbdJTRpo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Oct 2017 13:45:44 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9KHjhpi007675
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Oct 2017 17:45:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v9KHjgbA027333
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Oct 2017 17:45:43 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v9KHjgMS017945
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Oct 2017 17:45:42 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: clean up btrfs_dev_stat_inc() usage
Date: Sat, 21 Oct 2017 01:45:33 +0800
Message-Id: <20171020174533.7766-1-anand.jain@oracle.com>
In-Reply-To: <20171020095059.3730-1-anand.jain@oracle.com>
References: <20171020095059.3730-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_end_bio() is using btrfs_dev_stat_inc() and then
btrfs_dev_stat_print_on_error() separately instead use
btrfs_dev_stat_inc_and_print() directly.

As of now there isn't any bio in btrfs which is - a non-empty write and
also the REQ_PREFLUSH flag is set. So in actual the condition
   if (bio->bi_opf & REQ_PREFLUSH)
is never true in btrfs_end_bio(), and so there won't be any redundant error
log by using btrfs_dev_stat_inc_and_print() separately one for write and
another for flush.

This consolidation will help to add the device critical error handles in the
function btrfs_dev_stat_inc_and_print() and which can be renamed as needed.

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

