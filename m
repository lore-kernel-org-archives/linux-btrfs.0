Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23504 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759665AbaGYMaP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jul 2014 08:30:15 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: miaox@cn.fujitsu.com
Subject: [PATCH] btrfs: replace seed device followed by unmount causes kernel WARNING
Date: Fri, 25 Jul 2014 20:33:34 +0800
Message-Id: <1406291614-29544-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After the seed device has been replaced the new target device
is no more a seed device. So we need to bring that state in
the fs_devices.

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
        WARN_ON(fs_devices->rw_devices);

per the btrfs-devlist tool (to dump fs_devices and
btrfs_device from the kernel) the num_device, open_devices,
rw_devices are still at 1 but the total_device is at 2,
even after the seed device has been replaced in the above example.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index eea26e1..a144bb1 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -569,6 +569,19 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 
 	btrfs_rm_dev_replace_blocked(fs_info);
 
+	/*
+	 * if we are replacing a seed device with a writable device
+	 * then FS won't be a seeding FS any more.
+	 */
+	if (src_device->fs_devices->seeding && !src_device->writeable) {
+		fs_info->fs_devices->rw_devices++;
+		fs_info->fs_devices->num_devices++;
+		fs_info->fs_devices->open_devices++;
+
+		fs_info->fs_devices->seeding = 0;
+		fs_info->fs_devices->seed = NULL;
+	}
+
 	btrfs_rm_dev_replace_srcdev(fs_info, src_device);
 
 	btrfs_rm_dev_replace_unblocked(fs_info);
-- 
2.0.0.153.g79dcccc

