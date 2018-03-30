Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:51524 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751191AbeC3AHp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Mar 2018 20:07:45 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2U05W8c008166
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Mar 2018 00:07:44 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2h1abwr075-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Mar 2018 00:07:44 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w2U07h6x032028
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Mar 2018 00:07:43 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w2U07hO3005042
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Mar 2018 00:07:43 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 6/7] btrfs: verify checksum for all devices in mount context
Date: Fri, 30 Mar 2018 08:09:22 +0800
Message-Id: <20180330000924.11148-7-anand.jain@oracle.com>
In-Reply-To: <20180330000924.11148-1-anand.jain@oracle.com>
References: <20180330000924.11148-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

During mount context, we aren't verifying the superblock checksum
for all the devices, instead, we verify it only for the
struct btrfs_fs_device::latest_bdev. This patch fixes it by moving
the checksum verification code from the function open_ctree() into
the function btrfs_read_dev_one_super().

By doing this now we are verifying the superblock checksum in the
mount-context, device-replace and, device-delete context. The
device-replace and device-delete call-chain is as show below after
this patch.

delete-device/replace:
btrfs_rm_device() || btrfs_dev_replace_by_ioctl()
|_btrfs_find_device_by_devspec()
  |_btrfs_find_device_missing_or_by_path()
    |_btrfs_find_device_by_path()
      |_btrfs_get_bdev_and_sb()
        |_btrfs_read_dev_super()
          |_btrfs_read_dev_one_super()
	    |_btrfs_check_super_csum()

Test case:
 Before:
   mkfs.btrfs -fq -draid1 -mraid1 /dev/sdb /dev/sdc
   dd if=/dev/urandom of=/dev/sdc ibs=1 obs=1 count=1 seek=64K
   mount /dev/sdb /btrfs <-- success as kernel does not check csum
			     for non-btrfs_fs_devices::latest_bdev.
 After:
   mkfs.btrfs -fq -draid1 -mraid1 /dev/sdb /dev/sdc
   dd if=/dev/urandom of=/dev/sdc ibs=1 obs=1 count=1 seek=64K
   mount /dev/sdb /btrfs
     mount: mount /dev/sdc on /btrfs failed: Structure needs cleaning
   mount -o degraded /dev/sdc /btrfs
     mount: mount /dev/sdc on /btrfs failed: Structure needs cleaning

 So the current recovery step is to fix the primary superblock, by
 using the btrfs-progs cli.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
---
v1->v2:
 git commit log update. With the call-chain (which I believe will
  go away in the long term, we need the uuid from the userland not
  the disk-path). And add test case.
 Check err < 0 explicitly and drop check for "else if (err == -EUCLEAN)"
  v1:
	err = btrfs_check_super_csum(bh->b_data);
	if (err) {
		if (err == -EINVAL)
			pr_err("BTRFS error (device %pg): unsupported checksum algorithm",
				bdev);
		else if (err == -EUCLEAN)
			pr_err("BTRFS error (device %pg): superblock checksum mismatch",
				bdev);
		brelse(bh);
		return err;
	}

 fs/btrfs/disk-io.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 37b0cf489fdd..1eabcc4bf8d2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2565,22 +2565,6 @@ int open_ctree(struct super_block *sb,
 	}
 
 	/*
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
-	/*
 	 * super_copy is zeroed at allocation time and we never touch the
 	 * following bytes up to INFO_SIZE, the checksum is calculated from
 	 * the whole block of INFO_SIZE
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
+	if (err < 0) {
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

