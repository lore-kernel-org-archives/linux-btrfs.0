Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:53862 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752220AbeCCAQG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Mar 2018 19:16:06 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w230BZmr135497
        for <linux-btrfs@vger.kernel.org>; Sat, 3 Mar 2018 00:16:05 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2gfbnhs6rc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Mar 2018 00:16:05 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w230G5Vd021988
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Sat, 3 Mar 2018 00:16:05 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w230G4tr013057
        for <linux-btrfs@vger.kernel.org>; Sat, 3 Mar 2018 00:16:05 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: raid56: remove redundant async_missing_raid56
Date: Fri,  2 Mar 2018 16:10:39 -0700
Message-Id: <20180302231041.10442-3-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

async_missing_raid56() is identical to async_read_rebuild().

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/raid56.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index bb8a3c5..efb42dc 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -2766,24 +2766,8 @@ raid56_alloc_missing_rbio(struct btrfs_fs_info *fs_info, struct bio *bio,
 	return rbio;
 }
 
-static void missing_raid56_work(struct btrfs_work *work)
-{
-	struct btrfs_raid_bio *rbio;
-
-	rbio = container_of(work, struct btrfs_raid_bio, work);
-	__raid56_parity_recover(rbio);
-}
-
-static void async_missing_raid56(struct btrfs_raid_bio *rbio)
-{
-	btrfs_init_work(&rbio->work, btrfs_rmw_helper,
-			missing_raid56_work, NULL, NULL);
-
-	btrfs_queue_work(rbio->fs_info->rmw_workers, &rbio->work);
-}
-
 void raid56_submit_missing_rbio(struct btrfs_raid_bio *rbio)
 {
 	if (!lock_stripe_add(rbio))
-		async_missing_raid56(rbio);
+		async_read_rebuild(rbio);
 }
-- 
2.9.4

