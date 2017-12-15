Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:32988 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753942AbdLOHoN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Dec 2017 02:44:13 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBF7gEAZ073855
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 07:44:11 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2ev9yug2n6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 07:44:11 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vBF7dh3J000715
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 07:39:43 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vBF7dhP9029044
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 07:39:43 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs: make code easy to read in btrfs_open_one_device()
Date: Fri, 15 Dec 2017 15:40:14 +0800
Message-Id: <20171215074016.26461-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No functional change. First set the usual case, writeable then check
for any special config.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5a4c30451c7f..a81574dba124 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -676,14 +676,12 @@ static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
 
 	device->generation = btrfs_super_generation(disk_super);
 
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

