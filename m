Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46275 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932767AbaCQL6W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Mar 2014 07:58:22 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s2HBwLGV007193
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Mar 2014 11:58:21 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id s2HBwK1U021897
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Mar 2014 11:58:20 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s2HBwKZu022695
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Mar 2014 11:58:20 GMT
From: Anand Jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: all super blocks of the replaced disk must be scratched
Date: Mon, 17 Mar 2014 19:58:06 +0800
Message-Id: <1395057486-4341-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In a normal scenario when sys-admin replaces a disk, the
expeted is btrfs will release the disk completely.

However the below test case gives a wrong impression that
replaced disk is still is in use.

$ btrfs rep start /dev/sde /dev/sdg4 /btrfs
$ mkfs.btrfs /dev/sde
/dev/sde appears to contain an existing filesystem (btrfs).
Error: Use the -f option to force overwrite.

---
 fs/btrfs/volumes.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3c44800..06717a5 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6286,16 +6286,33 @@ int btrfs_scratch_superblock(struct btrfs_device *device)
 {
 	struct buffer_head *bh;
 	struct btrfs_super_block *disk_super;
+	int i;
+	u64 bytenr;
 
-	bh = btrfs_read_dev_super(device->bdev);
-	if (!bh)
-		return -EINVAL;
-	disk_super = (struct btrfs_super_block *)bh->b_data;
+	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
+		bytenr = btrfs_sb_offset(i);
+		if (bytenr + BTRFS_SUPER_INFO_SIZE >=
+				i_size_read(device->bdev->bd_inode))
+			break;
 
-	memset(&disk_super->magic, 0, sizeof(disk_super->magic));
-	set_buffer_dirty(bh);
-	sync_dirty_buffer(bh);
-	brelse(bh);
+		bh = __bread(device->bdev, bytenr / 4096,
+					BTRFS_SUPER_INFO_SIZE);
+		if (!bh)
+			continue;
+
+		disk_super = (struct btrfs_super_block *)bh->b_data;
+		if (btrfs_super_bytenr(disk_super) != bytenr ||
+				btrfs_super_magic(disk_super) != BTRFS_MAGIC) {
+			brelse(bh);
+			continue;
+		}
+
+		memset(&disk_super->magic, 0, sizeof(disk_super->magic));
+
+		set_buffer_dirty(bh);
+		sync_dirty_buffer(bh);
+		brelse(bh);
+	}
 
 	return 0;
 }
-- 
1.8.5.3

