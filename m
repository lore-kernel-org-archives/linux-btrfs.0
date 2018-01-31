Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:58672 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752994AbeAaC2Z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 21:28:25 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0V2Ra4i026710
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Jan 2018 02:28:24 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2fu16f0pbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Jan 2018 02:28:24 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0V2SNMU030857
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Jan 2018 02:28:23 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0V2SNSX021958
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Jan 2018 02:28:23 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 1/2] btrfs: fix device order consistency
Date: Wed, 31 Jan 2018 10:28:55 +0800
Message-Id: <20180131022856.16791-2-anand.jain@oracle.com>
In-Reply-To: <20180131022856.16791-1-anand.jain@oracle.com>
References: <20180131022856.16791-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

By maintaining the device order consistency it makes reproducing
the problems related to missing chunk in the degraded mode much more
consistent. So fix this by sorting the devices by devid within the
kernel. So that we know which device is assigned to the struct
fs_info::latest_bdev when all the devices are having and same
SB generation.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b5036bd69e6a..0109f370ad5b 100644
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
@@ -1102,6 +1103,20 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 	return ret;
 }
 
+static int device_cmp(void *priv, struct list_head *a, struct list_head *b)
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
@@ -1112,6 +1127,7 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 		fs_devices->opened++;
 		ret = 0;
 	} else {
+		list_sort(NULL, &fs_devices->devices, device_cmp);
 		ret = __btrfs_open_devices(fs_devices, flags, holder);
 	}
 	mutex_unlock(&uuid_mutex);
-- 
2.7.0

