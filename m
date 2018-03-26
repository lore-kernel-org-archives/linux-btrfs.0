Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:53172 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752021AbeCZI0A (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Mar 2018 04:26:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2Q8HPPv018187
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 08:26:00 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2gxw7j8142-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 08:25:59 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w2Q8PxWd020689
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 08:25:59 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w2Q8PwU7024008
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 08:25:59 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 6/8] btrfs: verify checksum when superblock is read for scan
Date: Mon, 26 Mar 2018 16:27:39 +0800
Message-Id: <20180326082742.9235-7-anand.jain@oracle.com>
In-Reply-To: <20180326082742.9235-1-anand.jain@oracle.com>
References: <20180326082742.9235-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

During the scan context, we aren't verifying the superblock-
checksum when read.
This patch fixes it by adding the checksum verification function
btrfs_check_super_csum() in the function btrfs_read_disk_super().
And makes device scan to error fail if the primary superblock csum
is wrong, whereas if the copy-superblock csum is wrong it will just
just report missmatch and continue mount/scan as usual. When the
mount is successful We anyway overwrite all superblocks upon unmount.

The context in which this will be called is - device scan, device ready,
and mount -o device option.

Test script:

 Corrupt primary superblock and check if device scan and mount
 fails:
 mkfs.btrfs -fq /dev/sdc
 dd if=/dev/urandom of=/dev/sdc ibs=1 obs=1 count=1 seek=64K
 btrfs dev scan
 mount /dev/sdb /btrfs

 Corrupt secondary superblock and check if device scan and mount
 is succcessful, check for the dmesg for errors.
 mkfs.btrfs -fq /dev/sdc
 dd if=/dev/urandom of=/dev/sdc ibs=1 obs=1 count=1 seek=64K
 btrfs dev scan
 mount /dev/sdb /btrfs

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 45dd0674571b..384e503c83ff 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1149,6 +1149,7 @@ static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
 				 struct page **page,
 				 struct btrfs_super_block **disk_super)
 {
+	int err;
 	void *p;
 	pgoff_t index;
 
@@ -1177,6 +1178,20 @@ static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
 	/* align our pointer to the offset of the super block */
 	*disk_super = p + (bytenr & ~PAGE_MASK);
 
+	err = btrfs_check_super_csum((char *) *disk_super);
+	if (err) {
+		if (err == -EINVAL)
+			pr_err("BTRFS error (device %pg): "\
+				"unsupported checksum type, bytenr=%llu",
+				bdev, bytenr);
+		else
+			pr_err("BTRFS error (device %pg): "\
+				"superblock checksum failed, bytenr=%llu",
+				bdev, bytenr);
+		btrfs_release_disk_super(*page);
+		return err;
+	}
+
 	if (btrfs_super_bytenr(*disk_super) != bytenr ||
 	    btrfs_super_magic(*disk_super) != BTRFS_MAGIC) {
 		btrfs_release_disk_super(*page);
-- 
2.7.0

