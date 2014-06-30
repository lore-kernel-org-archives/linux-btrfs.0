Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34387 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbaF3JNE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Jun 2014 05:13:04 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s5U9D27l021077
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Jun 2014 09:13:02 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s5U9D1Cv008922
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Jun 2014 09:13:02 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s5U9D1m5017990
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Jun 2014 09:13:01 GMT
From: Anand Jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: fix null pointer dereference in clone_fs_devices when name is null
Date: Mon, 30 Jun 2014 17:12:47 +0800
Message-Id: <1404119568-4097-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

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
---
 fs/btrfs/volumes.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 24477a4..66991c6 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -739,12 +739,14 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
 		 * This is ok to do without rcu read locked because we hold the
 		 * uuid mutex so nothing we touch in here is going to disappear.
 		 */
-		name = rcu_string_strdup(orig_dev->name->str, GFP_NOFS);
-		if (!name) {
-			kfree(device);
-			goto error;
+		if (orig_dev->name) {
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
2.0.0.257.g75cc6c6

