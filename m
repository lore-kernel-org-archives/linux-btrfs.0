Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20328 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757067AbaEPODZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 May 2014 10:03:25 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: wangsl.fnst@cn.fujitsu.com
Subject: [PATCH] btrfs: ioctl BTRFS_IOC_FS_INFO and BTRFS_IOC_DEV_INFO miss-matched with slots
Date: Fri, 16 May 2014 22:06:00 +0800
Message-Id: <1400249160-23186-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

BTRFS_IOC_FS_INFO return num_devices which does not include seed disks,
BTRFS_IOC_DEV_INFO fetches seed disk when probed. So in this case hits
the btrfs-progs bug:
            get_fs_info()
            ::
                    BUG_ON(ndevs >= fi_args->num_devices);
which is very easy to hit by using btrfs filesystem show.

This patch will make BTRFS_IOC_DEV_INFO ioctl to provide disks only
of the FSID being probed (seed disks are under different FSID).

which means when seed is still not deleted from the sprout the btrfs
filesystem show command will show disks them under their
respective FSIDs

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ioctl.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index ff27c08..902d279 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2584,7 +2584,8 @@ static long btrfs_ioctl_dev_info(struct btrfs_root *root, void __user *arg)
 		s_uuid = di_args->uuid;
 
 	mutex_lock(&fs_devices->device_list_mutex);
-	dev = btrfs_find_device(root->fs_info, di_args->devid, s_uuid, NULL);
+	dev = btrfs_find_device(root->fs_info, di_args->devid, s_uuid,
+				fs_devices->fsid);
 
 	if (!dev) {
 		ret = -ENODEV;
-- 
1.7.1

