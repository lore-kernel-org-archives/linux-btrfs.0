Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:46100 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752658AbeEWCvx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 22:51:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4N2pqdG165331
        for <linux-btrfs@vger.kernel.org>; Wed, 23 May 2018 02:51:52 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2j4nh7j2wn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 23 May 2018 02:51:52 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w4N2ppNk010196
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 23 May 2018 02:51:51 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w4N2pp5T026746
        for <linux-btrfs@vger.kernel.org>; Wed, 23 May 2018 02:51:51 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3] btrfs: drop uuid_mutex in btrfs_free_extra_devids()
Date: Wed, 23 May 2018 10:54:22 +0800
Message-Id: <20180523025422.32572-1-anand.jain@oracle.com>
In-Reply-To: <20180412022938.8257-11-anand.jain@oracle.com>
References: <20180412022938.8257-11-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_free_extra_devids() is called only in the mount context which
traverses through the fs_devices::devices and frees the orphan devices
devices in the given %fs_devices if any. As the search for the orphan
device is limited to fs_devices::devices so we don't need the global
uuid_mutex.

There can't be any mount-point based ioctl threads in this context as
the mount thread is not yet returned. But there can be the btrfs-control
based scan ioctls thread which calls device_list_add().

Here in the mount thread the fs_devices::opened is incremented way before
btrfs_free_extra_devids() is called and in the scan context the fs_devices
which are already opened neither be freed or alloc-able at
device_list_add().

But lets say you change the device-path and call the scan again, then scan
would update the new device path and this operation could race against the
btrfs_free_extra_devids() thread, which might be in the process of
free-ing the same device. So synchronize it by using the
device_list_mutex.

This scenario is a very corner case, and practically the scan and mount
are anyway serialized by the usage so unless the race is instrumented its
very difficult to achieve.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
Currently device_list_add() is very lean on its device_list_mutex usage,
a cleanup and fix is wip. Given the practicality of the above race
condition this patch is good to merge.

 fs/btrfs/volumes.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b6757b53c297..a9c1f4f7ebd0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -925,7 +925,7 @@ void btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices, int step)
 	struct btrfs_device *device, *next;
 	struct btrfs_device *latest_dev = NULL;
 
-	mutex_lock(&uuid_mutex);
+	mutex_lock(&fs_devices->device_list_mutex);
 again:
 	/* This is the initialized path, it is safe to release the devices. */
 	list_for_each_entry_safe(device, next, &fs_devices->devices, dev_list) {
@@ -979,8 +979,7 @@ void btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices, int step)
 	}
 
 	fs_devices->latest_bdev = latest_dev->bdev;
-
-	mutex_unlock(&uuid_mutex);
+	mutex_unlock(&fs_devices->device_list_mutex);
 }
 
 static void free_device_rcu(struct rcu_head *head)
-- 
2.7.0

