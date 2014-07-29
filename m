Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41740 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbaG2LJx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jul 2014 07:09:53 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s6TB9p2W004120
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jul 2014 11:09:52 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6TB9pAA019342
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jul 2014 11:09:51 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id s6TB9nZl006874
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jul 2014 11:09:50 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix regression of btrfs device replace
Date: Tue, 29 Jul 2014 19:09:39 +0800
Message-Id: <1406632179-17747-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 49c6f736f34f901117c20960ebd7d5e60f12fcac(
btrfs: dev replace should replace the sysfs entry) added the missing sysfs entry
in the process of device replace, but didn't take missing devices into account,
so now we have

BUG: unable to handle kernel NULL pointer dereference at 0000000000000088
IP: [<ffffffffa0268551>] btrfs_kobj_rm_device+0x21/0x40 [btrfs]
...

To reproduce it,
1. mkfs.btrfs -f disk1 disk2
2. mkfs.ext4 disk1
3. mount disk2 /mnt -odegraded
4. btrfs replace start -B 1 disk3 /mnt
--------------------------

This fixes the problem.

Reported-by: Chris Murphy <lists@colorremedies.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 7869936..12e5355 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -614,7 +614,7 @@ int btrfs_kobj_rm_device(struct btrfs_fs_info *fs_info,
 	if (!fs_info->device_dir_kobj)
 		return -EINVAL;
 
-	if (one_device) {
+	if (one_device && one_device->bdev) {
 		disk = one_device->bdev->bd_part;
 		disk_kobj = &part_to_dev(disk)->kobj;
 
-- 
1.8.1.4

