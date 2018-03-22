Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:49072 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754967AbeCVM75 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Mar 2018 08:59:57 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2MCh4Gg026127
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Mar 2018 12:59:56 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2gvcr0g2gn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Mar 2018 12:59:56 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w2MCxt1t021892
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Mar 2018 12:59:55 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w2MCxsw4010297
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Mar 2018 12:59:54 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: check if the fsid in the primary sb and copy sb are same
Date: Thu, 22 Mar 2018 21:01:40 +0800
Message-Id: <20180322130141.19894-2-anand.jain@oracle.com>
In-Reply-To: <20180322130141.19894-1-anand.jain@oracle.com>
References: <20180322130141.19894-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

During the btrfs dev scan make sure that other copies of superblock
contain the same fsid as the primary SB. So that we bring to the
users notice if the superblock has been overwritten.

 mkfs.btrfs -fq /dev/sdc
 mkfs.btrfs -fq /dev/sdb
 dd if=/dev/sdb of=/dev/sdc count=4K skip=64K seek=64K obs=1 ibs=1
 mount /dev/sdc /btrfs

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 43 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 87d183accdb2..b79e3ffd2047 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1203,24 +1203,45 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	struct block_device *bdev;
 	struct page *page;
 	int ret = 0;
-	u64 bytenr;
+	int i;
+	u8 fsid_tmp[BTRFS_FSID_SIZE];
 
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
-		goto error_bdev_put;
+	/*
+	 * We would like to check all the supers and use one good copy,
+	 * but that would make a btrfs mount succeed after a mkfs from
+	 * a different FS.
+	 * So, we need to add a special mount option to scan for
+	 * later supers, using BTRFS_SUPER_MIRROR_MAX instead.
+	 * So, just validate if all copies of the superblocks are ok
+	 * and have the same fsid.
+	 */
+	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
+		u64 bytenr = btrfs_sb_offset(i);
+
+		if (btrfs_read_disk_super(bdev, bytenr, &page, &disk_super)) {
+			if (i != 0)
+				continue;
+			ret = -EINVAL;
+			goto error_bdev_put;
+		}
+		if (i == 0) {
+			memcpy(fsid_tmp, disk_super->fsid, BTRFS_FSID_SIZE);
+			continue;
+		}
+
+		if (memcmp(fsid_tmp, disk_super->fsid, BTRFS_FSID_SIZE)) {
+			pr_err("BTRFS: (device %pg) SB copy#%d fsid %pU "\
+				"doesn't match with the primary SB fsid %pU\n",
+				bdev, i, disk_super->fsid, fsid_tmp);
+			ret = -EINVAL;
+			goto error_bdev_put;
+		}
 	}
 
 	mutex_lock(&uuid_mutex);
-- 
2.7.0

