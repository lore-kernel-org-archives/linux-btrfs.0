Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44900 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbbJEIt1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Oct 2015 04:49:27 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t958nQOv009174
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 5 Oct 2015 08:49:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by aserv0021.oracle.com (8.13.8/8.13.8) with ESMTP id t958nPLn009005
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 5 Oct 2015 08:49:26 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
	by userv0121.oracle.com (8.13.8/8.13.8) with ESMTP id t958nPro000724
	for <linux-btrfs@vger.kernel.org>; Mon, 5 Oct 2015 08:49:25 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH V2 3/3] Btrfs: device path change must be logged
Date: Mon,  5 Oct 2015 16:48:10 +0800
Message-Id: <1444034890-9353-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1444034890-9353-1-git-send-email-anand.jain@oracle.com>
References: <1444034890-9353-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>From the issue diagnosable point of view, log if the device path is
changed.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 V2: Accepts David's review comment and adds a new ret value 2
     for device_list_add() and based on that the caller function
     would indicate if the path is overwritten (thanks David).

 fs/btrfs/volumes.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e76cad3..b8b1171 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -504,6 +504,7 @@ void btrfs_free_stale_device(struct btrfs_device *cur_dev)
  *
  * Returns:
  * 1   - first time device is seen
+ * 2   - device already known but now is overwritten with new path
  * 0   - device already known
  * < 0 - error
  */
@@ -603,6 +604,7 @@ static noinline int device_list_add(const char *path,
 			fs_devices->missing_devices--;
 			device->missing = 0;
 		}
+		ret = 2;
 	}
 
 	/*
@@ -1033,8 +1035,9 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 
 	ret = device_list_add(path, disk_super, devid, fs_devices_ret);
 	if (ret > 0) {
-		printk(KERN_INFO "BTRFS: device fsid %pU devid %llu transid %llu %s\n",
-						disk_super->fsid, devid, transid, path);
+		printk(KERN_INFO "BTRFS: device fsid %pU devid %llu transid %llu %s %s\n",
+						disk_super->fsid, devid, transid, path,
+						ret == 2 ? "(overwritten)":"");
 		ret = 0;
 	}
 	if (!ret && fs_devices_ret)
-- 
2.4.1

