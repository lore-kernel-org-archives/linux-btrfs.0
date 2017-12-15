Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:45275 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754679AbdLOEaL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Dec 2017 23:30:11 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBF4RPkT010470
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 04:30:10 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2ev74kg0yb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 04:30:10 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vBF3l9AV029220
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 03:47:09 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vBF3l9VZ005323
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 03:47:09 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/6] btrfs: cleanup btrfs_free_stale_device() usage
Date: Fri, 15 Dec 2017 11:47:34 +0800
Message-Id: <20171215034739.26090-2-anand.jain@oracle.com>
In-Reply-To: <20171215034739.26090-1-anand.jain@oracle.com>
References: <20171215034739.26090-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We call btrfs_free_stale_device() only when we alloc a new
struct btrfs_device (ret=1), so move it closer to where we
alloc the new device. Also drop the comments.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b8ba3de6e9e6..6317a3561ae1 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -788,6 +788,7 @@ static noinline int device_list_add(const char *path,
 
 		ret = 1;
 		device->fs_devices = fs_devices;
+		btrfs_free_stale_device(device);
 	} else if (!device->name || strcmp(device->name->str, path)) {
 		/*
 		 * When FS is already mounted.
@@ -846,13 +847,6 @@ static noinline int device_list_add(const char *path,
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

