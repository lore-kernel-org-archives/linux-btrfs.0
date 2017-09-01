Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26800 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752563AbdIAXQT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Sep 2017 19:16:19 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v81NGFF0028352
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Sep 2017 23:16:16 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v81NGFJs026130
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Sep 2017 23:16:15 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v81NGEo2028558
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Sep 2017 23:16:15 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: remove batch plug in run_scheduled_IO
Date: Fri,  1 Sep 2017 16:14:26 -0600
Message-Id: <20170901221430.10131-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Block layer has a limit on plug, ie. BLK_MAX_REQUEST_COUNT == 16, so
we don't gain benefits by batching 64 bios here.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/volumes.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e8b9a26..de55024 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -524,12 +524,6 @@ static noinline void run_scheduled_bios(struct btrfs_device *device)
 					 &device->work);
 			goto done;
 		}
-		/* unplug every 64 requests just for good measure */
-		if (batch_run % 64 == 0) {
-			blk_finish_plug(&plug);
-			blk_start_plug(&plug);
-			sync_pending = 0;
-		}
 	}
 
 	cond_resched();
-- 
2.9.4

