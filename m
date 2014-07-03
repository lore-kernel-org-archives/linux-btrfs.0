Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43967 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759233AbaGCKUu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jul 2014 06:20:50 -0400
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Anand Jain <Anand.Jain@oracle.com>
Subject: [PATCH V2 7/9] btrfs: fix null pointer dereference in clone_fs_devices when name is null
Date: Thu, 3 Jul 2014 18:22:11 +0800
Message-ID: <1404382933-26672-7-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1404382933-26672-1-git-send-email-miaox@cn.fujitsu.com>
References: <1404382933-26672-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

when one of the device path is missing btrfs_device name is null. So this
patch will check for that.

stack:
BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
IP: [<ffffffff812e18c0>] strlen+0x0/0x30
[<ffffffffa01cd92a>] ? clone_fs_devices+0xaa/0x160 [btrfs]
[<ffffffffa01cdcf7>] btrfs_init_new_device+0x317/0xca0 [btrfs]
[<ffffffff81155bca>] ? __kmalloc_track_caller+0x15a/0x1a0
[<ffffffffa01d6473>] btrfs_ioctl+0xaa3/0x2860 [btrfs]
[<ffffffff81132a6c>] ? handle_mm_fault+0x48c/0x9c0
[<ffffffff81192a61>] ? __blkdev_put+0x171/0x180
[<ffffffff817a784c>] ? __do_page_fault+0x4ac/0x590
[<ffffffff81193426>] ? blkdev_put+0x106/0x110
[<ffffffff81179175>] ? mntput+0x35/0x40
[<ffffffff8116d4b0>] do_vfs_ioctl+0x460/0x4a0
[<ffffffff8115c72e>] ? ____fput+0xe/0x10
[<ffffffff81068033>] ? task_work_run+0xb3/0xd0
[<ffffffff8116d547>] SyS_ioctl+0x57/0x90
[<ffffffff817a793e>] ? do_page_fault+0xe/0x10
[<ffffffff817abe52>] system_call_fastpath+0x16/0x1b

reproducer:
mkfs.btrfs -draid1 -mraid1 /dev/sdg1 /dev/sdg2
btrfstune -S 1 /dev/sdg1
modprobe -r btrfs && modprobe btrfs
mount -o degraded /dev/sdg1 /btrfs
btrfs dev add /dev/sdg3 /btrfs

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1->v2:
- Fix the problem that we forgot to set the missing flag for the cloned device
---
 fs/btrfs/volumes.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1891541..4731bd6 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -598,16 +598,23 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
 		if (IS_ERR(device))
 			goto error;
 
-		/*
-		 * This is ok to do without rcu read locked because we hold the
-		 * uuid mutex so nothing we touch in here is going to disappear.
-		 */
-		name = rcu_string_strdup(orig_dev->name->str, GFP_NOFS);
-		if (!name) {
-			kfree(device);
-			goto error;
+		if (orig_dev->missing) {
+			device->missing = 1;
+			fs_devices->missing_devices++;
+		} else {
+			ASSERT(orig_dev->name);
+			/*
+			 * This is ok to do without rcu read locked because
+			 * we hold the uuid mutex so nothing we touch in here
+			 * is going to disappear.
+			 */
+			name = rcu_string_strdup(orig_dev->name->str, GFP_NOFS);
+			if (!name) {
+				kfree(device);
+				goto error;
+			}
+			rcu_assign_pointer(device->name, name);
 		}
-		rcu_assign_pointer(device->name, name);
 
 		list_add(&device->dev_list, &fs_devices->devices);
 		device->fs_devices = fs_devices;
-- 
1.9.3

