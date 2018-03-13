Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:57810 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751886AbeCMPFA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Mar 2018 11:05:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2DF4x0x193647
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Mar 2018 15:04:59 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2gpgym001k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Mar 2018 15:04:59 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w2DF4wVE008120
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Mar 2018 15:04:58 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w2DF4w31011929
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Mar 2018 15:04:58 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH] btrfs: check for SB checksum when scanned
Date: Tue, 13 Mar 2018 23:06:37 +0800
Message-Id: <20180313150637.3913-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We aren't checking the SB csum when the device scanned,
instead we do that when mounting the device, and if the
csum fails we fail the mount. How if we check the csum
when the device is scanned, I can't see any reason for
why not? any idea?

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 9 +++++----
 fs/btrfs/disk-io.h | 2 ++
 fs/btrfs/volumes.c | 4 ++++
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 156116655a32..28e71e2aaa92 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -393,8 +393,8 @@ static int verify_parent_transid(struct extent_io_tree *io_tree,
  * Return 0 if the superblock checksum type matches the checksum value of that
  * algorithm. Pass the raw disk superblock data.
  */
-static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
-				  char *raw_disk_sb)
+int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
+			   char *raw_disk_sb)
 {
 	struct btrfs_super_block *disk_sb =
 		(struct btrfs_super_block *)raw_disk_sb;
@@ -420,8 +420,9 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
 	}
 
 	if (csum_type >= ARRAY_SIZE(btrfs_csum_sizes)) {
-		btrfs_err(fs_info, "unsupported checksum algorithm %u",
-				csum_type);
+		if (fs_info)
+			btrfs_err(fs_info, "unsupported checksum algorithm %u",
+				  csum_type);
 		ret = 1;
 	}
 
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 70a88d61b547..683e4b0c4e24 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -70,6 +70,8 @@ struct buffer_head *btrfs_read_dev_super(struct block_device *bdev);
 int btrfs_read_dev_one_super(struct block_device *bdev, int copy_num,
 			struct buffer_head **bh_ret);
 int btrfs_commit_super(struct btrfs_fs_info *fs_info);
+int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
+			   char *raw_disk_sb);
 struct btrfs_root *btrfs_read_fs_root(struct btrfs_root *tree_root,
 				      struct btrfs_key *location);
 int btrfs_init_fs_root(struct btrfs_root *root);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1e72357bdfa8..af34b8a611a0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -677,6 +677,10 @@ static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
 	if (ret)
 		return ret;
 
+	if (btrfs_check_super_csum(NULL, bh->b_data)) {
+		pr_err("BTRFS: superblock checksum mismatch");
+		goto error_brelse;
+	}
 	disk_super = (struct btrfs_super_block *)bh->b_data;
 	devid = btrfs_stack_device_id(&disk_super->dev_item);
 	if (devid != device->devid)
-- 
2.15.0

