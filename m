Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:42778 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752857AbdLEIwf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Dec 2017 03:52:35 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vB58plwl008851
        for <linux-btrfs@vger.kernel.org>; Tue, 5 Dec 2017 08:52:34 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2enc2g1mum-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Dec 2017 08:52:34 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vB58qXU5031151
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 5 Dec 2017 08:52:33 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vB58qXwe020802
        for <linux-btrfs@vger.kernel.org>; Tue, 5 Dec 2017 08:52:33 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 1/2] btrfs: add function to device list delete
Date: Tue,  5 Dec 2017 16:52:56 +0800
Message-Id: <20171205085258.4038-2-anand.jain@oracle.com>
In-Reply-To: <20171205085258.4038-1-anand.jain@oracle.com>
References: <20171205085258.4038-1-anand.jain@oracle.com>
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
v4: no change

 fs/btrfs/volumes.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 04164337ac69..5deda80316f0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -531,6 +531,28 @@ static void pending_bios_fn(struct btrfs_work *work)
 	run_scheduled_bios(device);
 }
 
+static void delete_device_from_list(struct btrfs_device *device)
+{
+	struct btrfs_fs_devices *fs_devices;
+
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
 
 static void btrfs_free_stale_device(struct btrfs_device *cur_dev)
 {
-- 
2.7.0

