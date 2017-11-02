Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37957 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752380AbdKBB4k (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Nov 2017 21:56:40 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vA21ud68013776
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 2 Nov 2017 01:56:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vA21udjH023363
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 2 Nov 2017 01:56:39 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vA21udw6016826
        for <linux-btrfs@vger.kernel.org>; Thu, 2 Nov 2017 01:56:39 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/4] Btrfs: make raid1 and raid10 be aware of device flag In_sync
Date: Wed,  1 Nov 2017 18:54:04 -0600
Message-Id: <20171102005405.20420-4-bo.li.liu@oracle.com>
In-Reply-To: <20171102005405.20420-1-bo.li.liu@oracle.com>
References: <20171102005405.20420-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If a device is not in_sync, avoid reading data from it as data on it
might be stale.

Although checksum can detect stale data so we won't return stale data
to users , this helps us read the good copy directly.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/volumes.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 7b29b1a..b83b7c8 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5175,6 +5175,7 @@ static int find_live_mirror(struct btrfs_fs_info *fs_info,
 	int i;
 	int tolerance;
 	struct btrfs_device *srcdev;
+	struct btrfs_device *curr;
 
 	if (dev_replace_is_ongoing &&
 	    fs_info->dev_replace.cont_reading_from_srcdev_mode ==
@@ -5184,17 +5185,25 @@ static int find_live_mirror(struct btrfs_fs_info *fs_info,
 		srcdev = NULL;
 
 	/*
-	 * try to avoid the drive that is the source drive for a
-	 * dev-replace procedure, only choose it if no other non-missing
-	 * mirror is available
+	 * try to avoid the drive that is
+	 *
+	 * a) the source drive for a dev-replace procedure,
+	 * b) not in_sync
+	 *
+	 * only choose it if no other non-missing mirror is available.
 	 */
 	for (tolerance = 0; tolerance < 2; tolerance++) {
-		if (map->stripes[optimal].dev->bdev &&
-		    (tolerance || map->stripes[optimal].dev != srcdev))
+		curr = map->stripes[optimal].dev;
+		if (curr->bdev &&
+		    test_bit(In_sync, &curr->flags) &&
+		    (tolerance || curr != srcdev))
 			return optimal;
+
 		for (i = first; i < first + num; i++) {
-			if (map->stripes[i].dev->bdev &&
-			    (tolerance || map->stripes[i].dev != srcdev))
+			curr = map->stripes[i].dev;
+			if (curr->bdev &&
+			    test_bit(In_sync, &curr->flags) &&
+			    (tolerance || curr != srcdev))
 				return i;
 		}
 	}
-- 
2.9.4

