Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45098 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750716AbdJLJA5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Oct 2017 05:00:57 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9C90uuU004274
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Oct 2017 09:00:57 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v9C90ubh031236
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Oct 2017 09:00:56 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9C90ts5006435
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Oct 2017 09:00:56 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: remove BUG_ON in btrfs_rm_dev_replace_free_srcdev()
Date: Thu, 12 Oct 2017 17:00:41 +0800
Message-Id: <20171012090041.7438-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

That was only an extra check to tackle few bugs around this
area, now its save to remove it.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 332e00e72b86..0a5251a34d58 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2015,16 +2015,12 @@ void btrfs_rm_dev_replace_free_srcdev(struct btrfs_fs_info *fs_info,
 	}
 
 	btrfs_close_bdev(srcdev);
-
 	call_rcu(&srcdev->rcu, free_device);
 
 	/*
-	 * unless fs_devices is seed fs, num_devices shouldn't go
-	 * zero
+	 * If this is no devs we rather delete the fs_devices
+	 * which is true in case of single device seeding fs.
 	 */
-	BUG_ON(!fs_devices->num_devices && !fs_devices->seeding);
-
-	/* if this is no devs we rather delete the fs_devices */
 	if (!fs_devices->num_devices) {
 		struct btrfs_fs_devices *tmp_fs_devices;
 
-- 
2.13.1

