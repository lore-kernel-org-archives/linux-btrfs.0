Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:55648 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754839AbdLODwP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Dec 2017 22:52:15 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBF3q1Qj185603
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 03:52:14 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2ev6fp01xa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 03:52:14 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBF3lDOD001546
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 03:47:14 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vBF3lDKM013590
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 03:47:13 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/6] btrfs: make btrfs_free_stale_device() to match the path
Date: Fri, 15 Dec 2017 11:47:38 +0800
Message-Id: <20171215034739.26090-6-anand.jain@oracle.com>
In-Reply-To: <20171215034739.26090-1-anand.jain@oracle.com>
References: <20171215034739.26090-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The btrfs_free_stale_device() is updated to match for the given
device path and delete it. (It searchs for only unmounted list of
devices.)

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9aee4f987221..0bf3233859b6 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -608,7 +608,7 @@ static void pending_bios_fn(struct btrfs_work *work)
 }
 
 
-static void btrfs_free_stale_device(struct btrfs_device *cur_dev)
+static void btrfs_free_stale_device(struct btrfs_device *cur_dev, char *path)
 {
 	struct btrfs_fs_devices *fs_devs, *tmp_fs_devs;
 	struct btrfs_device *dev, *tmp_dev;
@@ -635,6 +635,8 @@ static void btrfs_free_stale_device(struct btrfs_device *cur_dev)
 			if (cur_dev)
 				not_found = strcmp(rcu_str_deref(dev->name),
 						   rcu_str_deref(cur_dev->name));
+			else if (path)
+				not_found = strcmp(rcu_str_deref(dev->name), path);
 			else
 				not_found = 0;
 			rcu_read_unlock();
@@ -782,7 +784,7 @@ static noinline int device_list_add(const char *path,
 
 		ret = 1;
 		device->fs_devices = fs_devices;
-		btrfs_free_stale_device(device);
+		btrfs_free_stale_device(device, NULL);
 	} else if (!device->name || strcmp(device->name->str, path)) {
 		/*
 		 * When FS is already mounted.
-- 
2.7.0

