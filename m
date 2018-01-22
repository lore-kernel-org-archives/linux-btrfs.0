Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:41716 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751126AbeAVWtj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Jan 2018 17:49:39 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0MMl2E8090973
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jan 2018 22:49:38 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2fnrnt034e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jan 2018 22:49:38 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0MMnbBK029280
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jan 2018 22:49:37 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0MMnbbQ025040
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jan 2018 22:49:37 GMT
MIME-Version: 1.0
Message-ID: <20180122224937.3458-2-anand.jain@oracle.com>
Date: Mon, 22 Jan 2018 14:49:36 -0800 (PST)
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/2] btrfs: fix device order consistency
References: <20180122224937.3458-1-anand.jain@oracle.com>
In-Reply-To: <20180122224937.3458-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=ascii
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
index 03f2685a5018..98e41d286283 100644
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
@@ -1107,6 +1108,20 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
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
@@ -1117,6 +1132,7 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 		fs_devices->opened++;
 		ret = 0;
 	} else {
+		list_sort(NULL, &fs_devices->devices, device_sort);
 		ret = __btrfs_open_devices(fs_devices, flags, holder);
 	}
 	mutex_unlock(&uuid_mutex);
-- 
2.7.0

