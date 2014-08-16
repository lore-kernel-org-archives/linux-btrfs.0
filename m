Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49774 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbaHRIQe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Aug 2014 04:16:34 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: wangsl.fnst@cn.fujitsu.com, lists@colorremedies.com
Subject: [PATCH] btrfs: ioctl BTRFS_IOC_FS_INFO and BTRFS_IOC_DEV_INFO miss-matched with slots
Date: Sat, 16 Aug 2014 11:08:07 +0800
Message-Id: <1408158488-4316-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1408158488-4316-1-git-send-email-anand.jain@oracle.com>
References: <1408158488-4316-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

ioctl BTRFS_IOC_FS_INFO return num_devices which does _not_ include seed
device, But the following ioctl BTRFS_IOC_DEV_INFO counts and gets seed
disk when probed. So in the userland we hit a count-slot missmatch
bug..
            get_fs_info()
            ::
                    BUG_ON(ndevs >= fi_args->num_devices);
which hits this bug when we have mounted a seed device.

So to fix this problem here in this patch ioctl BTRFS_IOC_FS_INFO
will provide total_devices instead of num_devices.

This would fix the problem partly. Partly because ealier num_devices
included the replacing device but now total_device does not include
the replacing device. Getting a count which includes a transient device
is rather too in efficient/wrong indeed, because there can be a race
condition where in the time between ioctl BTRFS_IOC_FS_INFO to
BTRFS_IOC_DEV_INFO the replace device operation might have been
completed. So to fix this problem its better that user land btrfs-progs
probes replacing device (at devid 0) separately.

v2:
Agree with Wang's comment. Its better to show seed disks under the
sprout fs, so that user can establish mapping of seed to sprout devices.

So here I am making BTRFS_IOC_FS_INFO to return the total_devices
which would count the seed devices (but not the replacing device).
A btrfs-progs patch will separately probe for devid 0 (which is
a replacing transient device when present).

v1:
This patch will make BTRFS_IOC_DEV_INFO ioctl to provide disks only
of the FSID being probed (seed disks are under different FSID).

which means when seed is still not deleted from the sprout the btrfs
filesystem show command will show disks them under their
respective FSIDs

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index da73ab3..05dd88b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2725,7 +2725,7 @@ static long btrfs_ioctl_fs_info(struct btrfs_root *root, void __user *arg)
 		return -ENOMEM;
 
 	mutex_lock(&fs_devices->device_list_mutex);
-	fi_args->num_devices = fs_devices->num_devices;
+	fi_args->num_devices = fs_devices->total_devices;
 	memcpy(&fi_args->fsid, root->fs_info->fsid, sizeof(fi_args->fsid));
 
 	list_for_each_entry_safe(device, next, &fs_devices->devices, dev_list) {
-- 
2.0.0.153.g79dcccc

