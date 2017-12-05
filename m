Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:51934 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750995AbdLECME (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Dec 2017 21:12:04 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vB52BZOX106899
        for <linux-btrfs@vger.kernel.org>; Tue, 5 Dec 2017 02:12:03 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2enc4r8xe1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Dec 2017 02:12:03 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vB52C2Rl030202
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 5 Dec 2017 02:12:02 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vB52C2q7007753
        for <linux-btrfs@vger.kernel.org>; Tue, 5 Dec 2017 02:12:02 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: remove useless wait in lock_stripe_add
Date: Mon,  4 Dec 2017 18:09:42 -0700
Message-Id: <20171205010942.17420-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The defined wait is not used anywhere.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/raid56.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 24a6222..62bcda2 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -670,7 +670,6 @@ static noinline int lock_stripe_add(struct btrfs_raid_bio *rbio)
 	struct btrfs_raid_bio *cur;
 	struct btrfs_raid_bio *pending;
 	unsigned long flags;
-	DEFINE_WAIT(wait);
 	struct btrfs_raid_bio *freeit = NULL;
 	struct btrfs_raid_bio *cache_drop = NULL;
 	int ret = 0;
-- 
2.9.4

