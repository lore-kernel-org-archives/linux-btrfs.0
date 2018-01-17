Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:23330 "EHLO
        mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751019AbeAQIhw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Jan 2018 03:37:52 -0500
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
        by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id C2D83AC0135
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jan 2018 17:37:45 +0900 (JST)
Subject: [PATCH 1/2] btrfs: fix the bug of device scan/ready for mounted,
 filesystem
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>, Anand Jain <anand.jain@oracle.com>
References: <7fba2dc9-44a9-4317-b9fd-263b2a687e9a@jp.fujitsu.com>
Message-ID: <923e5500-d6d8-b4b5-eb0b-30b80760a3f1@jp.fujitsu.com>
Date: Wed, 17 Jan 2018 17:37:39 +0900
MIME-Version: 1.0
In-Reply-To: <7fba2dc9-44a9-4317-b9fd-263b2a687e9a@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

commit ae3acc5fc0bf ("btrfs: cleanup btrfs_mount() using
btrfs_mount_root()") introduces a bug that "btrfs device scan/ready" for
mounted filesystem fails.

This is because fs_info->bdev_holder has been changed to hold
btrfs_root_fs_type instead of btrfs_fs_type by this commit, but ioctl
for device scan/ready still uses btrfs_fs_type to call
btrfs_scan_one_device(). This leads to failiure of blkdev_get_by_path()
for mounted filesystem because of different holder type.

Fix this by specifying btrfs_root_fs_type for btrfs_scan_one_device() in
the path of device ready/scan ioctl.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 fs/btrfs/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 9438d32c4267..6ff13948b655 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2231,11 +2231,11 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 	switch (cmd) {
 	case BTRFS_IOC_SCAN_DEV:
 		ret = btrfs_scan_one_device(vol->name, FMODE_READ,
-					    &btrfs_fs_type, &fs_devices);
+					    &btrfs_root_fs_type, &fs_devices);
 		break;
 	case BTRFS_IOC_DEVICES_READY:
 		ret = btrfs_scan_one_device(vol->name, FMODE_READ,
-					    &btrfs_fs_type, &fs_devices);
+					    &btrfs_root_fs_type, &fs_devices);
 		if (ret)
 			break;
 		ret = !(fs_devices->num_devices == fs_devices->total_devices);
-- 
2.14.3

