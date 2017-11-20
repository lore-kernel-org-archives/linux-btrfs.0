Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38075 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750932AbdKTIiP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Nov 2017 03:38:15 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAK8cEZd014873
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Nov 2017 08:38:14 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vAK8cECV013322
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Nov 2017 08:38:14 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vAK8cEod027428
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Nov 2017 08:38:14 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 1/2] btrfs: add function to device list delete
Date: Mon, 20 Nov 2017 16:38:28 +0800
Message-Id: <20171120083829.1132-1-anand.jain@oracle.com>
In-Reply-To: <20171113054410.24872-1-anand.jain@oracle.com>
References: <20171113054410.24872-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We need device delete from the dev_list so create a new function.
New instead of refactor of btrfs_free_stale_device() because,
btrfs_free_stale_device() doesn't hold device_list_mutex which
is actually needed here.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v1: title of this patch
  btrfs: refactor btrfs_free_stale_device() to get device list delete
v2:
 delete_device_from_list() is not pealed from btrfs_free_stale_device()
 as this needs device_list_mutex. And its static now.
v3: Send to correct ML

 fs/btrfs/volumes.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index bddf75d5e6a0..68f1dd44385b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -546,6 +546,27 @@ static void pending_bios_fn(struct btrfs_work *work)
 	run_scheduled_bios(device);
 }
 
+static void delete_device_from_list(struct btrfs_device *device)
+{
+	struct btrfs_fs_devices *fs_devices;
+	fs_devices = device->fs_devices;
+
+	lockdep_assert_held(&uuid_mutex);
+
+	mutex_lock(&fs_devices->device_list_mutex);
+	fs_devices->num_devices--;
+	list_del(&device->dev_list);
+	mutex_unlock(&fs_devices->device_list_mutex);
+
+	rcu_string_free(device->name);
+	kfree(device);
+
+	if (fs_devices->num_devices == 0) {
+		btrfs_sysfs_remove_fsid(fs_devices);
+		list_del(&fs_devices->list);
+		free_fs_devices(fs_devices);
+	}
+}
 
 void btrfs_free_stale_device(struct btrfs_device *cur_dev)
 {
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
