Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:57006 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932890AbeCCAVG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Mar 2018 19:21:06 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w230HUx7021619
        for <linux-btrfs@vger.kernel.org>; Sat, 3 Mar 2018 00:21:06 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2gf4g1ub08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Mar 2018 00:21:06 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w230G5Ft031506
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Sat, 3 Mar 2018 00:16:05 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w230G4fL006153
        for <linux-btrfs@vger.kernel.org>; Sat, 3 Mar 2018 00:16:04 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: replace: cache rbio when rebuild data on missing device
Date: Fri,  2 Mar 2018 16:10:38 -0700
Message-Id: <20180302231041.10442-2-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rebuild on missing device is as same as recover, after it's done, rbio
has data which is consistent with on-disk data, so it can be cached to
avoid further reads.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/raid56.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index dec0907..bb8a3c5 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1986,7 +1986,8 @@ static void __raid_recover_end_io(struct btrfs_raid_bio *rbio)
 	kfree(pointers);
 
 cleanup_io:
-	if (rbio->operation == BTRFS_RBIO_READ_REBUILD) {
+	if (rbio->operation == BTRFS_RBIO_READ_REBUILD ||
+	    rbio->operation == BTRFS_RBIO_REBUILD_MISSING) {
 		/*
 		 * - In case of two failures, where rbio->failb != -1:
 		 *
@@ -2008,8 +2009,6 @@ static void __raid_recover_end_io(struct btrfs_raid_bio *rbio)
 			clear_bit(RBIO_CACHE_READY_BIT, &rbio->flags);
 
 		rbio_orig_end_io(rbio, err);
-	} else if (rbio->operation == BTRFS_RBIO_REBUILD_MISSING) {
-		rbio_orig_end_io(rbio, err);
 	} else if (err == BLK_STS_OK) {
 		rbio->faila = -1;
 		rbio->failb = -1;
-- 
2.9.4

