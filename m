Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:39082 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750970AbeAVGaE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Jan 2018 01:30:04 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0M6RYjv047299
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jan 2018 06:30:04 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2fnaaeg3a2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jan 2018 06:30:04 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w0M6U3Xn005878
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jan 2018 06:30:03 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0M6U3FK029837
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jan 2018 06:30:03 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/2] btrfs: make code easy to read in btrfs_open_one_device()
Date: Mon, 22 Jan 2018 14:31:07 +0800
Message-Id: <20180122063108.12826-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

First set the usual case that is writeable, then check
for any special case like a seed device or a rdonly device
and set the state appropriately.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v1->v2:
 Add comments, and update change log.

 fs/btrfs/volumes.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5750cd9df417..001894782d84 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -689,14 +689,18 @@ static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
 
 	device->generation = btrfs_super_generation(disk_super);
 
+	/*
+	 * Set the device as writeable and then check if its
+	 * seed or readonly device. Both SUPER_FLAG_SEEDING and
+	 * bdev_read_only(bdev) can be set by the user when device
+	 * is unmounted. And this fn is called at the time of mount.
+	 */
+	set_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state);
 	if (btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_SEEDING) {
 		clear_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state);
 		fs_devices->seeding = 1;
-	} else {
-		if (bdev_read_only(bdev))
-			clear_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state);
-		else
-			set_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state);
+	} else if (bdev_read_only(bdev)) {
+		clear_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state);
 	}
 
 	q = bdev_get_queue(bdev);
-- 
2.7.0

