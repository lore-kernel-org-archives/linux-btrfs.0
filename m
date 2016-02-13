Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43080 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbcBMCCC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Feb 2016 21:02:02 -0500
From: Anand Jain <anand.jain@oracle.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 03/13] btrfs: maintain consistency in logging to help debugging
Date: Sat, 13 Feb 2016 10:01:30 +0800
Message-Id: <1455328900-1476-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1455328900-1476-1-git-send-email-anand.jain@oracle.com>
References: <1455328900-1476-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Optional Label may or may not be set, or it might be set at some time
later. However while debugging to search through the kernel logs the
scripts would need the logs to be consistent, so logs search key words
shouldn't depend on the optional variables, instead fsid is better.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2: fix commit log

 fs/btrfs/volumes.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9860b10..36108e9 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1080,13 +1080,8 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 
 	ret = device_list_add(path, disk_super, devid, fs_devices_ret);
 	if (ret > 0) {
-		if (disk_super->label[0]) {
-			printk(KERN_INFO "BTRFS: device label %s ", disk_super->label);
-		} else {
-			printk(KERN_INFO "BTRFS: device fsid %pU ", disk_super->fsid);
-		}
-
-		printk(KERN_CONT "devid %llu transid %llu %s\n", devid, transid, path);
+		printk(KERN_INFO "BTRFS: device fsid %pU devid %llu transid %llu %s\n",
+						disk_super->fsid, devid, transid, path);
 		ret = 0;
 	}
 	if (!ret && fs_devices_ret)
-- 
2.7.0

