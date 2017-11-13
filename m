Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31839 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751236AbdKMFoB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Nov 2017 00:44:01 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAD5hxRP001481
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Nov 2017 05:44:00 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vAD5hx83008306
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Nov 2017 05:43:59 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vAD5hxR7006614
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Nov 2017 05:43:59 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: refactor btrfs_free_stale_device() to get device list delete
Date: Mon, 13 Nov 2017 13:44:09 +0800
Message-Id: <20171113054410.24872-2-anand.jain@oracle.com>
In-Reply-To: <20171113054410.24872-1-anand.jain@oracle.com>
References: <20171113054410.24872-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We need to delete a device from the dev_list, so refactor
btrfs_free_stale_device() for delete_device_from_list().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8bac1cf17048..8ead85dba6f5 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -546,6 +546,22 @@ static void pending_bios_fn(struct btrfs_work *work)
 	run_scheduled_bios(device);
 }
 
+void delete_device_from_list(struct btrfs_device *dev)
+{
+	struct btrfs_fs_devices *fs_devs;
+	fs_devs = dev->fs_devices;
+
+	if (fs_devs->num_devices == 1) {
+		btrfs_sysfs_remove_fsid(fs_devs);
+		list_del(&fs_devs->list);
+		free_fs_devices(fs_devs);
+	} else {
+		fs_devs->num_devices--;
+		list_del(&dev->dev_list);
+		rcu_string_free(dev->name);
+		kfree(dev);
+	}
+}
 
 void btrfs_free_stale_device(struct btrfs_device *cur_dev)
 {
@@ -586,16 +602,7 @@ void btrfs_free_stale_device(struct btrfs_device *cur_dev)
 
 		if (!del) {
 			/* delete the stale device */
-			if (fs_devs->num_devices == 1) {
-				btrfs_sysfs_remove_fsid(fs_devs);
-				list_del(&fs_devs->list);
-				free_fs_devices(fs_devs);
-			} else {
-				fs_devs->num_devices--;
-				list_del(&dev->dev_list);
-				rcu_string_free(dev->name);
-				kfree(dev);
-			}
+			delete_device_from_list(dev);
 			break;
 		}
 	}
-- 
2.13.1

