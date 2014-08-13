Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31379 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaHMGRN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Aug 2014 02:17:13 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s7D6HCbM025138
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Aug 2014 06:17:12 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s7D6HBrS011157
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Aug 2014 06:17:11 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s7D6HAGP016359
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Aug 2014 06:17:10 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/8] btrfs: replace seed device followed by unmount causes kernel WARNING
Date: Wed, 13 Aug 2014 14:24:20 +0800
Message-Id: <1407911066-5363-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1407911066-5363-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1407911066-5363-1-git-send-email-anand.jain@oracle.com>

reproducer:
mount /dev/sdb /btrfs
btrfs dev add /dev/sdc /btrfs
btrfs rep start -B /dev/sdb /dev/sdd /btrfs
umount /btrfs

WARNING: CPU: 0 PID: 12661 at fs/btrfs/volumes.c:891 __btrfs_close_devices+0x1b0/0x200 [btrfs]()
::

__btrfs_close_devices()
::
        WARN_ON(fs_devices->open_devices);

After the seed device has been replaced the new target device
is no more a seed device. So we need to update the device
numbers in the fs_devices as pointed by the fs_info.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5fd0132..f098ae7 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1964,7 +1964,13 @@ void btrfs_rm_dev_replace_srcdev(struct btrfs_fs_info *fs_info,
 
 	WARN_ON(!mutex_is_locked(&fs_info->fs_devices->device_list_mutex));
 
-	fs_devices = fs_info->fs_devices;
+	/*
+	 * in case of fs with no seed, srcdev->fs_devices will point
+	 * to fs_devices of fs_info. However when the dev being replaced is
+	 * a seed dev it will point to the seed's local fs_devices. In short
+	 * srcdev will have its correct fs_devices in both the cases.
+	 */
+	fs_devices = srcdev->fs_devices;
 
 	list_del_rcu(&srcdev->dev_list);
 	list_del_rcu(&srcdev->dev_alloc_list);
-- 
2.0.0.153.g79dcccc

