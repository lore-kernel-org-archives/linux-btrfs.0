Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31686 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaFME0j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Jun 2014 00:26:39 -0400
From: Anand Jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com, wangsl.fnst@cn.fujitsu.com
Subject: [PATCH 2/2] btrfs: check generation as replace duplicates devid+uuid
Date: Fri, 13 Jun 2014 12:26:21 +0800
Message-Id: <1402633581-19265-2-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1402633581-19265-1-git-send-email-Anand.Jain@oracle.com>
References: <1402633581-19265-1-git-send-email-Anand.Jain@oracle.com>
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
---
 fs/btrfs/volumes.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 56822f0..bb1b4bd 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -523,6 +523,16 @@ static noinline int device_list_add(const char *path,
 
 		if (fs_devices->opened)
 			return -EBUSY;
+		else {
+			/*
+			 * That is if the FS is _not_ mounted and if you are here, that
+			 * means there is more than one disk with same uuid and devid.
+			 * We keep the one with larger generation number or the last-in
+			 * if generation are equal.
+			 */
+			if (found_transid < device->generation)
+				return -EINVAL;
+		}
 
 		name = rcu_string_strdup(path, GFP_NOFS);
 		if (!name)
@@ -535,6 +545,15 @@ static noinline int device_list_add(const char *path,
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
1.8.5.3

