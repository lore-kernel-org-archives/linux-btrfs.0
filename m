Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49995 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbaHKJkR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Aug 2014 05:40:17 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s7B9eF2i020561
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 09:40:16 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id s7B9eD0A007740
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 09:40:13 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s7B9eBTB017040
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 09:40:11 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/4] btrfs: replace seed device followed by unmount causes kernel WARNING
Date: Mon, 11 Aug 2014 17:42:54 +0800
Message-Id: <1407750176-15853-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1407750176-15853-1-git-send-email-anand.jain@oracle.com>
References: <1407750176-15853-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

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

