Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:56580 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755959AbaGCKUr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jul 2014 06:20:47 -0400
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Anand Jain <anand.jain@oracle.com>,
        Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: [PATCH V2 2/9] btrfs: check generation as replace duplicates devid+uuid
Date: Thu, 3 Jul 2014 18:22:06 +0800
Message-ID: <1404382933-26672-2-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1404382933-26672-1-git-send-email-miaox@cn.fujitsu.com>
References: <1404382933-26672-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

When FS in unmounted we need to check generation number as well
since devid+uuid combination could match with the missing replaced
disk when it reappears, and without this patch it might pair with
the replaced disk again.

 device_list_add() function is called in the following threads,
	mount device option
	mount argument
	ioctl BTRFS_IOC_SCAN_DEV (btrfs dev scan)
	ioctl BTRFS_IOC_DEVICES_READY (btrfs dev ready <dev>)
 they have been unit tested to work fine with this patch.

 If the user knows what he is doing and really want to pair with
 replaced disk (which is not a standard operation), then he should
 first clear the kernel btrfs device list in the memory by doing
 the module unload/load and followed with the mount -o device option.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1->v2:
- Fix the over-80-charactor problem and unreasonable error number
---
 fs/btrfs/volumes.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 16e71a1..1891541 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -532,8 +532,19 @@ static noinline int device_list_add(const char *path,
 		 * As of now don't allow update to btrfs_fs_device through
 		 * the btrfs dev scan cli, after FS has been mounted.
 		 */
-		if (fs_devices->opened)
+		if (fs_devices->opened) {
 			return -EBUSY;
+		} else {
+			/*
+			 * That is if the FS is _not_ mounted and if you
+			 * are here, that means there is more than one
+			 * disk with same uuid and devid.We keep the one
+			 * with larger generation number or the last-in if
+			 * generation are equal.
+			 */
+			if (found_transid < device->generation)
+				return -EEXIST;
+		}
 
 		name = rcu_string_strdup(path, GFP_NOFS);
 		if (!name)
@@ -546,6 +557,15 @@ static noinline int device_list_add(const char *path,
 		}
 	}
 
+	/*
+	 * Unmount does not free the btrfs_device struct but would zero
+	 * generation along with most of the other members. So just update
+	 * it back. We need it to pick the disk with largest generation
+	 * (as above).
+	 */
+	if (!fs_devices->opened)
+		device->generation = found_transid;
+
 	if (found_transid > fs_devices->latest_trans) {
 		fs_devices->latest_devid = devid;
 		fs_devices->latest_trans = found_transid;
-- 
1.9.3

