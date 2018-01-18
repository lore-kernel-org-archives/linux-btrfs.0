Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:55262 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756387AbeARN7k (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Jan 2018 08:59:40 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0IDufSS001499
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jan 2018 13:59:40 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2fjvcx05cx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jan 2018 13:59:39 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0IDxchp017705
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jan 2018 13:59:39 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0IDxctW021398
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jan 2018 13:59:38 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/6] btrfs: cleanup btrfs_free_stale_device() usage
Date: Thu, 18 Jan 2018 22:00:32 +0800
Message-Id: <20180118140037.25158-2-anand.jain@oracle.com>
In-Reply-To: <20180118140037.25158-1-anand.jain@oracle.com>
References: <20180118140037.25158-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We call btrfs_free_stale_device() only when we alloc a new
struct btrfs_device (ret=1), so move it closer to where we
alloc the new device. Also drop the comments.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/volumes.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d393808071d5..25b91776d036 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -782,6 +782,7 @@ static noinline int device_list_add(const char *path,
 
 		ret = 1;
 		device->fs_devices = fs_devices;
+		btrfs_free_stale_device(device);
 	} else if (!device->name || strcmp(device->name->str, path)) {
 		/*
 		 * When FS is already mounted.
@@ -840,13 +841,6 @@ static noinline int device_list_add(const char *path,
 	if (!fs_devices->opened)
 		device->generation = found_transid;
 
-	/*
-	 * if there is new btrfs on an already registered device,
-	 * then remove the stale device entry.
-	 */
-	if (ret > 0)
-		btrfs_free_stale_device(device);
-
 	*fs_devices_ret = fs_devices;
 
 	return ret;
-- 
2.7.0

