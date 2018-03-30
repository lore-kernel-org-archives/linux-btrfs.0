Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:59880 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752177AbeC3AQw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Mar 2018 20:16:52 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2U04cgI007776
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Mar 2018 00:16:52 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2h1abwr1tn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Mar 2018 00:16:49 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w2U07fIM012677
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Mar 2018 00:07:41 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w2U07e17005039
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Mar 2018 00:07:41 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 4/7] btrfs: check if the fsid in the primary sb and copy sb are same
Date: Fri, 30 Mar 2018 08:09:20 +0800
Message-Id: <20180330000924.11148-5-anand.jain@oracle.com>
In-Reply-To: <20180330000924.11148-1-anand.jain@oracle.com>
References: <20180330000924.11148-1-anand.jain@oracle.com>
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
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
---
v1->v2:
  Do an explicit read for primary superblock. Drop kzalloc().
  Fix split pr_err().

 fs/btrfs/volumes.c | 48 ++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 38 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e63723f23227..035affa447fa 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1198,39 +1198,67 @@ static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
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
+			goto error_rel_primary;
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
+error_rel_primary:
+	btrfs_release_disk_super(page_primary);
 
 error_bdev_put:
 	blkdev_put(bdev, flags);
-- 
2.7.0

