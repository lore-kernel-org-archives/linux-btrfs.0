Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45144 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752135AbeCZI0B (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Mar 2018 04:26:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2Q8HH2s057085
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 08:26:01 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2gxw7j810s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 08:26:01 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w2Q8Q0jC020729
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 08:26:00 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w2Q8PxUa016418
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 08:26:00 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 7/8] btrfs: verify checksum for all devices in mount context
Date: Mon, 26 Mar 2018 16:27:40 +0800
Message-Id: <20180326082742.9235-8-anand.jain@oracle.com>
In-Reply-To: <20180326082742.9235-1-anand.jain@oracle.com>
References: <20180326082742.9235-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

During mount context, we aren't verifying the superblock checksum
for all the devices, instead, we verify it only for the
struct btrfs_fs_device::latest_bdev. This patch fixes it
by moving the checksum verification code from the function open_ctree()
into the function btrfs_read_dev_one_super().

By doing this now we are verifying the superblock checksum
in the mount-context, device-replace and, device-delete context.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6299ab18da5f..3cc50041c0b9 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2565,24 +2565,6 @@ int open_ctree(struct super_block *sb,
 	}
 
 	/*
-	 * We want to check superblock checksum, the type is stored inside.
-	 * Pass the whole disk block of size BTRFS_SUPER_INFO_SIZE (4k).
-	 */
-	err = btrfs_check_super_csum(bh->b_data);
-	if (err) {
-		if (err == -EINVAL)
-			pr_err("BTRFS error (device %pg): "\
-				"unsupported checksum algorithm",
-				fs_devices->latest_bdev);
-		else
-			pr_err("BTRFS error (device %pg): "\
-				"superblock checksum mismatch",
-				fs_devices->latest_bdev);
-		brelse(bh);
-		goto fail_alloc;
-	}
-
-	/*
 	 * super_copy is zeroed at allocation time and we never touch the
 	 * following bytes up to INFO_SIZE, the checksum is calculated from
 	 * the whole block of INFO_SIZE
@@ -3128,6 +3110,7 @@ int btrfs_read_dev_one_super(struct block_device *bdev, int copy_num,
 	struct buffer_head *bh;
 	struct btrfs_super_block *super;
 	u64 bytenr;
+	int err;
 
 	bytenr = btrfs_sb_offset(copy_num);
 	if (bytenr + BTRFS_SUPER_INFO_SIZE >= i_size_read(bdev->bd_inode))
@@ -3148,6 +3131,22 @@ int btrfs_read_dev_one_super(struct block_device *bdev, int copy_num,
 		return -EINVAL;
 	}
 
+	/*
+	 * Check the superblock checksum, the type is stored inside.
+	 * Pass the whole disk block of size BTRFS_SUPER_INFO_SIZE (4k).
+	 */
+	err = btrfs_check_super_csum(bh->b_data);
+	if (err) {
+		if (err == -EINVAL)
+			pr_err("BTRFS error (device %pg): unsupported checksum algorithm",
+				bdev);
+		else if (err == -EUCLEAN)
+			pr_err("BTRFS error (device %pg): superblock checksum mismatch",
+				bdev);
+		brelse(bh);
+		return err;
+	}
+
 	*bh_ret = bh;
 	return 0;
 }
-- 
2.7.0

