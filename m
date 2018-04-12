Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:37456 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752802AbeDLC1t (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 22:27:49 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3C2Q0OK098941
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:49 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2h6ny3hwhg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:48 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w3C2Rl2k027063
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:48 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3C2Rl6e006960
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:47 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 11/15] btrfs: drop uuid_mutex in btrfs_open_devices()
Date: Thu, 12 Apr 2018 10:29:34 +0800
Message-Id: <20180412022938.8257-12-anand.jain@oracle.com>
In-Reply-To: <20180412022938.8257-1-anand.jain@oracle.com>
References: <20180412022938.8257-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_open_devices() is using uuid_mutex, but as the btrfs_open_devices()
is just limited to open all the devices under a given fsid, so we don't
need uuid_mutex.

Instead it should hold the device_list_mutex as it updated the status
of the btrfs_fs_devices and btrfs_device of a fsid.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 85948ef12ecf..dfebf8f29916 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1115,7 +1115,7 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 {
 	int ret;
 
-	mutex_lock(&uuid_mutex);
+	mutex_lock(&fs_devices->device_list_mutex);
 	if (fs_devices->opened) {
 		fs_devices->opened++;
 		ret = 0;
@@ -1123,7 +1123,7 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 		list_sort(NULL, &fs_devices->devices, devid_cmp);
 		ret = open_fs_devices(fs_devices, flags, holder);
 	}
-	mutex_unlock(&uuid_mutex);
+	mutex_unlock(&fs_devices->device_list_mutex);
 	return ret;
 }
 
-- 
2.7.0

