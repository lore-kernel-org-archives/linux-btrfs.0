Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29464 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756704Ab3GYRYV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jul 2013 13:24:21 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r6PHOK4t011767
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jul 2013 17:24:21 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6PHOIpR015903
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jul 2013 17:24:20 GMT
Received: from abhmt109.oracle.com (abhmt109.oracle.com [141.146.116.61])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6PHOIwl002974
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jul 2013 17:24:18 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: btrfs_rm_device() should zero mirror SB as well
Date: Fri, 26 Jul 2013 01:29:36 +0800
Message-Id: <1374773376-29853-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1374773376-29853-1-git-send-email-anand.jain@oracle.com>
References: <1374773376-29853-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is a very less chance that all the copies of SB
on the disk is zeroed unintentionally. unless device
is removed, so this fix will ensure all copies on the
disk is zeroed when the disk is intentionally removed.

reproducer:
-------------------
btrfs dev del /dev/sdc /btrfs
echo $?
0
umount /btrfs
btrfs fi show
Label: none  uuid: e7aae9f0-1aa8-41f5-8fb6-d4d8f80cdb2c
        Total devices 1 FS bytes used 28.00KiB
        devid    1 size 2.00GiB used 20.00MiB path /dev/sdb

./btrfs-select-super -s 1 /dev/sdc
using SB copy 1, bytenr 67108864

btrfs fi show
Label: none  uuid: e7aae9f0-1aa8-41f5-8fb6-d4d8f80cdb2c
        Total devices 1 FS bytes used 28.00KiB
        devid    2 size 2.00GiB used 0.00 path /dev/sdc   <-- WRONG
        devid    1 size 2.00GiB used 20.00MiB path /dev/sdb

mount /dev/sdc /btrfs
btrfs fi show --kernel
Label: none  uuid: e7aae9f0-1aa8-41f5-8fb6-d4d8f80cdb2c mounted: /btrfs
        Group profile: metadata: single  data: single
        Total devices 1 FS bytes used 28.00KiB
        devid    1 size 2.00GiB used 20.00MiB path /dev/sdb
---------------------

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 557a743..090f57c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1641,12 +1641,42 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	 * remove it from the devices list and zero out the old super
 	 */
 	if (clear_super && disk_super) {
+		u64 bytenr;
+		int i;
+
 		/* make sure this device isn't detected as part of
 		 * the FS anymore
 		 */
 		memset(&disk_super->magic, 0, sizeof(disk_super->magic));
 		set_buffer_dirty(bh);
 		sync_dirty_buffer(bh);
+
+		/* clear the mirror copies of super block on the disk
+		 * being removed, 0th copy is been taken care above and
+		 * the below would take of the rest
+		 */
+		for (i = 1; i < BTRFS_SUPER_MIRROR_MAX; i++) {
+			brelse(bh);
+			bytenr = btrfs_sb_offset(i);
+			if (bytenr + BTRFS_SUPER_INFO_SIZE >=
+					i_size_read(bdev->bd_inode))
+				break;
+			bh = __bread(bdev, bytenr / 4096,
+					BTRFS_SUPER_INFO_SIZE);
+			if (!bh)
+				continue;
+
+			disk_super = (struct btrfs_super_block *)bh->b_data;
+
+			if (btrfs_super_bytenr(disk_super) != bytenr ||
+				btrfs_super_magic(disk_super) != BTRFS_MAGIC) {
+				continue;
+			}
+			memset(&disk_super->magic, 0,
+						sizeof(disk_super->magic));
+			set_buffer_dirty(bh);
+			sync_dirty_buffer(bh);
+		}
 	}
 
 	ret = 0;
-- 
1.7.1

