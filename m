Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:33452 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752549AbeC0XiV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 19:38:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2RNTrVE022377
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 23:38:21 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2gyyp7g0yg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 23:38:21 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w2RNcJdx028738
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 23:38:19 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w2RNcJE1022338
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 23:38:19 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 5/8] btrfs: check if the fsid in the primary sb and copy sb are same
Date: Wed, 28 Mar 2018 07:39:56 +0800
Message-Id: <20180327234000.23656-6-anand.jain@oracle.com>
In-Reply-To: <20180327234000.23656-1-anand.jain@oracle.com>
References: <20180327234000.23656-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

During the btrfs dev scan make sure that other copies of superblock
contain the same fsid as the primary SB. So that we bring to the
user notice if the superblock has been overwritten.

 mkfs.btrfs -fq /dev/sdc
 mkfs.btrfs -fq /dev/sdb
 dd if=/dev/sdb of=/dev/sdc count=4K skip=64K seek=64K obs=1 ibs=1
 mount /dev/sdc /btrfs

Caveat: Pls note that older btrfs-progs do not wipe the non-overwriting
stale superblock like copy2 if a smaller mkfs.btrfs -b  <size> is created.
Thus this patch in the kernel will report error. The workaround is to wipe
the superblock manually, like
  dd if=/dev/zero of=<dev> seek=274877906944 ibs=1 obs=1 count4K
OR apply the btrfs-progs patch
  btrfs-progs: wipe copies of the stale superblock beyond -b size
which shall find and wipe the non overwriting superblock during mkfs.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v1->v2:
  Do an explicit read for primary superblock. Drop kzalloc().
  Fix split pr_err().

 fs/btrfs/volumes.c | 47 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 36 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e63723f23227..b099823f60d1 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1198,40 +1198,65 @@ static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
 int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 			  struct btrfs_fs_devices **fs_devices_ret)
 {
+	struct btrfs_super_block *disk_super_primary;
 	struct btrfs_super_block *disk_super;
 	struct btrfs_device *device;
 	struct block_device *bdev;
+	struct page *page_primary;
 	struct page *page;
 	int ret = 0;
 	u64 bytenr;
+	int i;
 
-	/*
-	 * we would like to check all the supers, but that would make
-	 * a btrfs mount succeed after a mkfs from a different FS.
-	 * So, we need to add a special mount option to scan for
-	 * later supers, using BTRFS_SUPER_MIRROR_MAX instead
-	 */
-	bytenr = btrfs_sb_offset(0);
 	flags |= FMODE_EXCL;
 
 	bdev = blkdev_get_by_path(path, flags, holder);
 	if (IS_ERR(bdev))
 		return PTR_ERR(bdev);
 
-	ret = btrfs_read_disk_super(bdev, bytenr, &page, &disk_super);
+	/*
+	 * We would like to check all the supers and use one good copy,
+	 * but that would make a btrfs mount succeed after a mkfs from
+	 * a different FS.
+	 * So, we need to add a special mount option to scan for
+	 * later supers, using BTRFS_SUPER_MIRROR_MAX instead.
+	 * So, just validate if all copies of the superblocks are ok
+	 * and have the same fsid.
+	 */
+	bytenr = btrfs_sb_offset(0);
+	ret = btrfs_read_disk_super(bdev, bytenr, &page_primary,
+				    &disk_super_primary);
 	if (ret < 0)
 		goto error_bdev_put;
 
+	for (i = 1; i < BTRFS_SUPER_MIRROR_MAX; i++) {
+		bytenr = btrfs_sb_offset(i);
+		ret = btrfs_read_disk_super(bdev, bytenr, &page, &disk_super);
+		if (ret < 0) {
+			ret = 0;
+			continue;
+		}
+
+		if (memcmp(disk_super_primary->fsid, disk_super->fsid,
+			   BTRFS_FSID_SIZE)) {
+			pr_err("BTRFS (device %pg): superblock fsid mismatch, primary %pU copy%d %pU",
+				bdev, disk_super_primary->fsid, i,
+				disk_super->fsid);
+			ret = -EINVAL;
+			btrfs_release_disk_super(page);
+			goto error_bdev_put;
+		}
+		btrfs_release_disk_super(page);
+	}
+
 	mutex_lock(&uuid_mutex);
-	device = device_list_add(path, disk_super);
+	device = device_list_add(path, disk_super_primary);
 	if (IS_ERR(device))
 		ret = PTR_ERR(device);
 	else
 		*fs_devices_ret = device->fs_devices;
 	mutex_unlock(&uuid_mutex);
 
-	btrfs_release_disk_super(page);
-
 error_bdev_put:
 	blkdev_put(bdev, flags);
 
-- 
2.7.0

