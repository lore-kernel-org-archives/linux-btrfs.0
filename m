Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34128 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbaCaOON (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Mar 2014 10:14:13 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s2VEECxR008264
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Mar 2014 14:14:12 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s2VEEBKg015030
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Mar 2014 14:14:12 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id s2VEEBYG001963
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Mar 2014 14:14:11 GMT
From: Anand Jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2 v2] btrfs: btrfs_rm_device() should zero mirror SB as well
Date: Mon, 31 Mar 2014 22:13:56 +0800
Message-Id: <1396275237-8306-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

This fix will ensure all SB copies on the disk is zeroed
when the disk is intentionally removed. This helps to
better manage disks in the user land.

Signed-off-by: Anand Jain <anand.jain@oracle.com>

btrfs: don't double brelse on device rm

Device removal currently causes bdev removal to try to double free a bh
in the bdev:

[   55.714833] WARNING: at fs/buffer.c:1160 __brelse+0x36/0x40()
[   55.714833] VFS: brelse: Trying to free free buffer

Commit 7e3d9ebb1 added a double release of the bh for a device being
removed when all the supers don't fit in the device.  In that case it
releases the bh assuming that it's going to read a new one, finds that
it won't read, and goes to a label that releases the bh again.

All it needed to do was only brelse() right before overwriting the
current bh with __bread().

Signed-off-by: Zach Brown <zab@redhat.com>
---
v1->v2: merge with Zach fix, commit update

 fs/btrfs/volumes.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b4660c4..7243196 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1681,12 +1681,43 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
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
+			bytenr = btrfs_sb_offset(i);
+			if (bytenr + BTRFS_SUPER_INFO_SIZE >=
+					i_size_read(bdev->bd_inode))
+				break;
+
+			brelse(bh);
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
1.8.5.3

