Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:34444 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750931AbeARCbL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Jan 2018 21:31:11 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0I2RWT1056514
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jan 2018 02:31:10 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2fjhrd0648-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jan 2018 02:31:10 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0I2VA2X019756
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jan 2018 02:31:10 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0I2VA7a007919
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jan 2018 02:31:10 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: fix device order consistency
Date: Thu, 18 Jan 2018 10:32:11 +0800
Message-Id: <20180118023212.14256-2-anand.jain@oracle.com>
In-Reply-To: <20180118023212.14256-1-anand.jain@oracle.com>
References: <20180118023212.14256-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

By maintaining the device order consistency it makes reproducing
the problem more consistent. So fix this by having the devices
sorted by some order within the kernel, lets say by devid.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d393808071d5..68be58a5b03f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -27,6 +27,7 @@
 #include <linux/raid/pq.h>
 #include <linux/semaphore.h>
 #include <linux/uuid.h>
+#include <linux/list_sort.h>
 #include <asm/div64.h>
 #include "ctree.h"
 #include "extent_map.h"
@@ -1108,6 +1109,20 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 	return ret;
 }
 
+static int device_sort(void *priv, struct list_head *a, struct list_head *b)
+{
+	struct btrfs_device *dev1, *dev2;
+
+	dev1 = list_entry(a, struct btrfs_device, dev_list);
+	dev2 = list_entry(b, struct btrfs_device, dev_list);
+
+	if (dev1->devid < dev2->devid)
+		return -1;
+	else if (dev1->devid > dev2->devid)
+		return 1;
+	return 0;
+}
+
 int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 		       fmode_t flags, void *holder)
 {
@@ -1118,6 +1133,7 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 		fs_devices->opened++;
 		ret = 0;
 	} else {
+		list_sort(NULL, &fs_devices->devices, device_sort);
 		ret = __btrfs_open_devices(fs_devices, flags, holder);
 	}
 	mutex_unlock(&uuid_mutex);
-- 
2.15.0

