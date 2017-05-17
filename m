Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18976 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754363AbdEQXXd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 19:23:33 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v4HNNVGu014229
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 17 May 2017 23:23:31 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v4HNNVjv023487
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 17 May 2017 23:23:31 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v4HNNUwr023864
        for <linux-btrfs@vger.kernel.org>; Wed, 17 May 2017 23:23:31 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/8] Btrfs: record error if one block has failed to retry
Date: Wed, 17 May 2017 16:22:49 -0600
Message-Id: <20170517222252.29242-6-bo.li.liu@oracle.com>
In-Reply-To: <20170517222252.29242-1-bo.li.liu@oracle.com>
References: <20170517222252.29242-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In the nocsum case of dio read endio, it returns immediately if an error
gets returned when repairing, which leaves the rest blocks unrepaired.  The
behavior is different from how buffered read endio works in the same case.
This changes it to record error only and go on repairing the rest blocks.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 997ee7d..3060c66 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7941,6 +7941,7 @@ static int __btrfs_correct_data_nocsum(struct inode *inode,
 	u32 sectorsize;
 	int nr_sectors;
 	int ret;
+	int err = 0;
 
 	fs_info = BTRFS_I(inode)->root->fs_info;
 	sectorsize = fs_info->sectorsize;
@@ -7962,8 +7963,10 @@ static int __btrfs_correct_data_nocsum(struct inode *inode,
 				pgoff, start, start + sectorsize - 1,
 				io_bio->mirror_num,
 				btrfs_retry_endio_nocsum, &done);
-		if (ret)
-			return ret;
+		if (ret) {
+			err = ret;
+			goto next;
+		}
 
 		wait_for_completion(&done.done);
 
@@ -7972,6 +7975,7 @@ static int __btrfs_correct_data_nocsum(struct inode *inode,
 			goto next_block_or_try_again;
 		}
 
+next:
 		start += sectorsize;
 
 		nr_sectors--;
@@ -7982,7 +7986,7 @@ static int __btrfs_correct_data_nocsum(struct inode *inode,
 		}
 	}
 
-	return 0;
+	return err;
 }
 
 static void btrfs_retry_endio(struct bio *bio)
-- 
2.9.4

