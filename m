Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:46436 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752357AbeCWMwG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Mar 2018 08:52:06 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2NCgd8a066920
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Mar 2018 12:52:06 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2gw1txg186-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Mar 2018 12:52:06 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w2NCq2x7029108
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Mar 2018 12:52:02 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w2NCq13C017711
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Mar 2018 12:52:01 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: verify checksum when superblock is read for mount
Date: Fri, 23 Mar 2018 20:53:48 +0800
Message-Id: <20180323125349.26893-2-anand.jain@oracle.com>
In-Reply-To: <20180323125349.26893-1-anand.jain@oracle.com>
References: <20180323125349.26893-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

During mount context, we aren't verifying the superblock checksum
for all the devices, instead, we verify it only for the
struct btrfs_fs_device::latest_bdev. This patch fixes it
by moving the checksum verification code from the function open_ctree()
into the function btrfs_read_dev_one_super().

By doing this now we are verifying the superblock checksum
in the mount-context, device-replace and device-delete context.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 062b3e0c7fd1..c4600d5eca9c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2564,22 +2564,6 @@ int open_ctree(struct super_block *sb,
 		goto fail_alloc;
 	}
 
-	/*
-	 * We want to check superblock checksum, the type is stored inside.
-	 * Pass the whole disk block of size BTRFS_SUPER_INFO_SIZE (4k).
-	 */
-	err = btrfs_check_super_csum(bh->b_data);
-	if (err) {
-		if (err == -EINVAL)
-			pr_err("BTRFS error (device %pg): unsupported checksum algorithm",
-				fs_devices->latest_bdev);
-		else if (err == -EUCLEAN)
-			pr_err("BTRFS error (device %pg): superblock checksum mismatch",
-				fs_devices->latest_bdev);
-		brelse(bh);
-		goto fail_alloc;
-	}
-
 	/*
 	 * super_copy is zeroed at allocation time and we never touch the
 	 * following bytes up to INFO_SIZE, the checksum is calculated from
@@ -3126,6 +3110,7 @@ int btrfs_read_dev_one_super(struct block_device *bdev, int copy_num,
 	struct buffer_head *bh;
 	struct btrfs_super_block *super;
 	u64 bytenr;
+	int err;
 
 	bytenr = btrfs_sb_offset(copy_num);
 	if (bytenr + BTRFS_SUPER_INFO_SIZE >= i_size_read(bdev->bd_inode))
@@ -3146,6 +3131,22 @@ int btrfs_read_dev_one_super(struct block_device *bdev, int copy_num,
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
2.15.0

