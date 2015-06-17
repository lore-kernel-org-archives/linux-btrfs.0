Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35648 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbbFQJAS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 05:00:18 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t5H90G6b024134
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 09:00:17 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by aserv0022.oracle.com (8.13.8/8.13.8) with ESMTP id t5H90Ghm003344
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 09:00:16 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
	by userv0121.oracle.com (8.13.8/8.13.8) with ESMTP id t5H90GpV027522
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 09:00:16 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] Btrfs: fix hang when failing to submit bio of directIO
Date: Wed, 17 Jun 2015 16:59:57 +0800
Message-Id: <1434531598-8607-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The hang is uncoverd by generic/019.

btrfs_endio_direct_write() skips the "finish_ordered_fn" part when it hits
an error, thus those added ordered extents will never get processed, which
block processes that waiting for them via btrfs_start_ordered_extent().

This fixes the above, and meanwhile finish_ordered_fn will do the space
accounting work.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8bb0136..7bf150a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7855,8 +7855,6 @@ static void btrfs_endio_direct_write(struct bio *bio, int err)
 	struct bio *dio_bio;
 	int ret;
 
-	if (err)
-		goto out_done;
 again:
 	ret = btrfs_dec_test_first_ordered_pending(inode, &ordered,
 						   &ordered_offset,
@@ -7879,7 +7877,6 @@ out_test:
 		ordered = NULL;
 		goto again;
 	}
-out_done:
 	dio_bio = dip->dio_bio;
 
 	kfree(dip);
-- 
2.1.0

