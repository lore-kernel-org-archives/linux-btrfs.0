Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37189 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754585AbdDRBRz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Apr 2017 21:17:55 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v3I1HrVY027549
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Apr 2017 01:17:54 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v3I1HrR8023303
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Apr 2017 01:17:53 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v3I1HrBl009877
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Apr 2017 01:17:53 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/6] Btrfs: record error if one block has failed to retry
Date: Mon, 17 Apr 2017 18:16:25 -0700
Message-Id: <1492478187-24875-5-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1492478187-24875-1-git-send-email-bo.li.liu@oracle.com>
References: <1492478187-24875-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In the nocsum case of dio read endio, it will return immediately if an
error got returned when repairing, which left the rest blocks unrepaired.
The behavior is different from how buffered read endio works in the same
case.  This changes it to record error only and go on repairing the rest
blocks.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index fca2f1f..cc46d21 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7942,6 +7942,7 @@ static int __btrfs_correct_data_nocsum(struct inode *inode,
 	u32 sectorsize;
 	int nr_sectors;
 	int ret;
+	int err;
 
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
 
 		if (nr_sectors--) {
@@ -7980,7 +7984,7 @@ static int __btrfs_correct_data_nocsum(struct inode *inode,
 		}
 	}
 
-	return 0;
+	return err;
 }
 
 static void btrfs_retry_endio(struct bio *bio)
-- 
2.5.5

