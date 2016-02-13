Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43082 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbcBMCCC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Feb 2016 21:02:02 -0500
From: Anand Jain <anand.jain@oracle.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 04/13] btrfs: device path change must be logged
Date: Sat, 13 Feb 2016 10:01:31 +0800
Message-Id: <1455328900-1476-5-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1455328900-1476-1-git-send-email-anand.jain@oracle.com>
References: <1455328900-1476-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>From the issue diagnosable point of view, log if the device path is changed.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 V2: Accepts David's review comment and adds a new ret value 2
     for device_list_add() and based on that the caller function
     would indicate if the path is overwritten (thanks David).

 fs/btrfs/volumes.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 36108e9..76133e0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -585,6 +585,7 @@ void btrfs_free_stale_device(struct btrfs_device *cur_dev)
  *
  * Returns:
  * 1   - first time device is seen
+ * 2   - device already known but now is overwritten with new path
  * 0   - device already known
  * < 0 - error
  */
@@ -684,6 +685,7 @@ static noinline int device_list_add(const char *path,
 			fs_devices->missing_devices--;
 			device->missing = 0;
 		}
+		ret = 2;
 	}
 
 	/*
@@ -1080,8 +1082,9 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 
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
2.7.0

