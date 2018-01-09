Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:60878 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753048AbeAIORg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 09:17:36 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w09EGa33148675
        for <linux-btrfs@vger.kernel.org>; Tue, 9 Jan 2018 14:17:36 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2fcpfyt3xg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jan 2018 14:17:36 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w09ECYlm013530
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Tue, 9 Jan 2018 14:12:35 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w09ECY8J023049
        for <linux-btrfs@vger.kernel.org>; Tue, 9 Jan 2018 14:12:34 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/6] btrfs: make btrfs_free_stale_device() to match the path
Date: Tue,  9 Jan 2018 22:13:13 +0800
Message-Id: <20180109141314.23795-6-anand.jain@oracle.com>
In-Reply-To: <20180109141314.23795-1-anand.jain@oracle.com>
References: <20180109141314.23795-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

The btrfs_free_stale_device() is updated to match for the given
device path and delete it. (It searchs for only unmounted list of
devices.)

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 7646f8860096..f87d30aa0e18 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -606,7 +606,7 @@ static void pending_bios_fn(struct btrfs_work *work)
 }
 
 
-static void btrfs_free_stale_device(struct btrfs_device *cur_dev)
+static void btrfs_free_stale_device(struct btrfs_device *cur_dev, char *path)
 {
 	struct btrfs_fs_devices *fs_devs, *tmp_fs_devs;
 	struct btrfs_device *dev, *tmp_dev;
@@ -633,6 +633,8 @@ static void btrfs_free_stale_device(struct btrfs_device *cur_dev)
 			if (cur_dev)
 				not_found = strcmp(rcu_str_deref(dev->name),
 						   rcu_str_deref(cur_dev->name));
+			else if (path)
+				not_found = strcmp(rcu_str_deref(dev->name), path);
 			else
 				not_found = 0;
 			rcu_read_unlock();
@@ -776,7 +778,7 @@ static noinline int device_list_add(const char *path,
 
 		ret = 1;
 		device->fs_devices = fs_devices;
-		btrfs_free_stale_device(device);
+		btrfs_free_stale_device(device, NULL);
 	} else if (!device->name || strcmp(device->name->str, path)) {
 		/*
 		 * When FS is already mounted.
-- 
2.7.0

