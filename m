Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:53282 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752003AbeCWMgj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Mar 2018 08:36:39 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2NCYjeK018317
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Mar 2018 12:36:39 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2gw1q880bq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Mar 2018 12:36:39 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w2NCacnv017371
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Mar 2018 12:36:38 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w2NCac2P008797
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Mar 2018 12:36:38 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2.1] btrfs: check if the fsid in the primary sb and copy sb are same
Date: Fri, 23 Mar 2018 20:38:26 +0800
Message-Id: <20180323123826.26644-1-anand.jain@oracle.com>
In-Reply-To: <20180322130141.19894-2-anand.jain@oracle.com>
References: <20180322130141.19894-2-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

During the btrfs dev scan make sure that other copies of superblock
contain the same fsid as the primary SB. So that we bring to the
user notice if the superblock has been overwritten.

 mkfs.btrfs -fq /dev/sdc
 mkfs.btrfs -fq /dev/sdb
 dd if=/dev/sdb of=/dev/sdc count=4K skip=64K seek=64K obs=1 ibs=1
 mount /dev/sdc /btrfs

Also reading all copies of the SB is required to verify their csum
is correct, so this serves as a preparatory as well.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2->v2.1:
 Fix the page release part.
 pr_err string changes.
 add else part for if(btrfs_read_disk_super(..)).
v1:
 Not born yet.

 fs/btrfs/volumes.c | 57 +++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 44 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 87d183accdb2..3e2dae4e8ccb 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1198,41 +1198,72 @@ static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
 int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 			  struct btrfs_fs_devices **fs_devices_ret)
 {
+	struct btrfs_super_block *disk_super_primary;
 	struct btrfs_super_block *disk_super;
 	struct btrfs_device *device;
 	struct block_device *bdev;
 	struct page *page;
 	int ret = 0;
-	u64 bytenr;
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
 
-	if (btrfs_read_disk_super(bdev, bytenr, &page, &disk_super)) {
-		ret = -EINVAL;
+	/*
+	 * We would like to check all the supers and use one good copy,
+	 * but that would make a btrfs mount succeed after a mkfs from
+	 * a different FS.
+	 * So, we need to add a special mount option to scan for
+	 * later supers, using BTRFS_SUPER_MIRROR_MAX instead.
+	 * So, just validate if all copies of the superblocks are ok
+	 * and have the same fsid.
+	 */
+	disk_super_primary = kzalloc(sizeof(*disk_super_primary), GFP_KERNEL);
+	if (!disk_super_primary) {
+		ret = -ENOMEM;
 		goto error_bdev_put;
 	}
+	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
+		u64 bytenr = btrfs_sb_offset(i);
+
+		if (btrfs_read_disk_super(bdev, bytenr, &page, &disk_super)) {
+			if (i == 0) {
+				ret = -EINVAL;
+				goto error_kfree;
+			}
+			continue;
+		} else if (i == 0) {
+			memcpy(disk_super_primary, disk_super,
+			       sizeof(*disk_super_primary));
+			btrfs_release_disk_super(page);
+			continue;
+		}
+
+		if (memcmp(disk_super_primary->fsid, disk_super->fsid,
+			   BTRFS_FSID_SIZE)) {
+			pr_err("BTRFS (device %pg): superblock primary:copy#%d fsid missmatch %pU:%pU",
+				bdev, i, disk_super->fsid,
+				disk_super_primary->fsid);
+			ret = -EINVAL;
+			btrfs_release_disk_super(page);
+			goto error_kfree;
+		}
+		btrfs_release_disk_super(page);
+	}
 
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
+error_kfree:
+	kfree(disk_super_primary);
 error_bdev_put:
 	blkdev_put(bdev, flags);
 
-- 
2.15.0

