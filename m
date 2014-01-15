Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50329 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbaAOJWp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jan 2014 04:22:45 -0500
From: Anand Jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, Anand Jain <Anand.Jain@oracle.com>
Subject: [RFC PATCH] btrfs: fix null pointer deference at btrfs_sysfs_add_one+0x105
Date: Wed, 15 Jan 2014 17:22:28 +0800
Message-Id: <1389777748-4341-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

bdev is null when disk has disappeared and mounted with
the degrade option

stack trace
---------
btrfs_sysfs_add_one+0x105/0x1c0 [btrfs]
open_ctree+0x15f3/0x1fe0 [btrfs]
btrfs_mount+0x5db/0x790 [btrfs]
? alloc_pages_current+0xa4/0x160
mount_fs+0x34/0x1b0
vfs_kern_mount+0x62/0xf0
do_mount+0x22e/0xa80
? __get_free_pages+0x9/0x40
? copy_mount_options+0x31/0x170
SyS_mount+0x7e/0xc0
system_call_fastpath+0x16/0x1b
---------

reproducer:
-------
mkfs.btrfs -draid1 -mraid1 /dev/sdc /dev/sdd
(detach a disk)
devmgt detach /dev/sdc [1]
mount -o degrade /dev/sdd /btrfs
-------

[1] github.com/anajain/devmgt.git

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
 fs/btrfs/sysfs.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index ba94b27..f20bc1f 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -578,8 +578,14 @@ static int add_device_membership(struct btrfs_fs_info *fs_info)
 		return -ENOMEM;
 
 	list_for_each_entry(dev, &fs_devices->devices, dev_list) {
-		struct hd_struct *disk = dev->bdev->bd_part;
-		struct kobject *disk_kobj = &part_to_dev(disk)->kobj;
+		struct hd_struct *disk;
+		struct kobject *disk_kobj;
+
+		if (!dev->bdev)
+			continue;
+
+		disk = dev->bdev->bd_part;
+		disk_kobj = &part_to_dev(disk)->kobj;
 
 		error = sysfs_create_link(fs_info->device_dir_kobj,
 					  disk_kobj, disk_kobj->name);
-- 
1.8.4.2

