Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:58658 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752551AbeDLC1m (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 22:27:42 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3C2QaJU171049
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:42 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2h6kgtj0us-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:42 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w3C2RfJe001298
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:41 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3C2RfkI021316
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:41 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 05/15] btrfs: rename __btrfs_open_devices to open_fs_devices
Date: Thu, 12 Apr 2018 10:29:28 +0800
Message-Id: <20180412022938.8257-6-anand.jain@oracle.com>
In-Reply-To: <20180412022938.8257-1-anand.jain@oracle.com>
References: <20180412022938.8257-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

__btrfs_open_devices() is un-exported drop __ prefix and rename it to
open_fs_devices().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ef8578bf6b99..9ed670ffa6a5 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1071,7 +1071,7 @@ int btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 	return ret;
 }
 
-static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
+static int open_fs_devices(struct btrfs_fs_devices *fs_devices,
 				fmode_t flags, void *holder)
 {
 	struct btrfs_device *device;
@@ -1125,7 +1125,7 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 		ret = 0;
 	} else {
 		list_sort(NULL, &fs_devices->devices, devid_cmp);
-		ret = __btrfs_open_devices(fs_devices, flags, holder);
+		ret = open_fs_devices(fs_devices, flags, holder);
 	}
 	mutex_unlock(&uuid_mutex);
 	return ret;
@@ -6569,8 +6569,7 @@ static struct btrfs_fs_devices *open_seed_devices(struct btrfs_fs_info *fs_info,
 	if (IS_ERR(fs_devices))
 		return fs_devices;
 
-	ret = __btrfs_open_devices(fs_devices, FMODE_READ,
-				   fs_info->bdev_holder);
+	ret = open_fs_devices(fs_devices, FMODE_READ, fs_info->bdev_holder);
 	if (ret) {
 		free_fs_devices(fs_devices);
 		fs_devices = ERR_PTR(ret);
-- 
2.7.0

