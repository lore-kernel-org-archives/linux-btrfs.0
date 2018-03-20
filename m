Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:35518 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752223AbeCTJv3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Mar 2018 05:51:29 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2K9kAEL004089
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Mar 2018 09:51:27 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2gtyxer109-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Mar 2018 09:51:27 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w2K9pQJv018613
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Mar 2018 09:51:27 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w2K9pQr3004903
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Mar 2018 09:51:26 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs: refactor btrfs_check_super_csum() for scan
Date: Tue, 20 Mar 2018 17:53:10 +0800
Message-Id: <20180320095310.6355-4-anand.jain@oracle.com>
In-Reply-To: <20180320095310.6355-1-anand.jain@oracle.com>
References: <20180320095310.6355-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In preparation to use the function btrfs_check_super_csum() for
the device scan context, make it nonstatic and pass the
struct block_device instead of the struct fs_info.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 12 ++++++------
 fs/btrfs/disk-io.h |  1 +
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index aafd836af61d..d2ace2dca9de 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -393,8 +393,7 @@ static int verify_parent_transid(struct extent_io_tree *io_tree,
  * Return 0 if the superblock checksum type matches the checksum value of that
  * algorithm. Pass the raw disk superblock data.
  */
-static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
-				  char *raw_disk_sb)
+int btrfs_check_super_csum(struct block_device *bdev, char *raw_disk_sb)
 {
 	struct btrfs_super_block *disk_sb =
 		(struct btrfs_super_block *)raw_disk_sb;
@@ -404,8 +403,8 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
 
 	/* We support csum type crc32 only as of now */
 	if (csum_type != BTRFS_CSUM_TYPE_CRC32) {
-		btrfs_err(fs_info, "unsupported checksum algorithm %u",
-			  csum_type);
+		pr_err("BTRFS error (device %pg): unsupported checksum algorithm %u",
+			bdev, csum_type);
 		return -EINVAL;
 	}
 
@@ -419,7 +418,8 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
 	btrfs_csum_final(crc, result);
 
 	if (memcmp(raw_disk_sb, result, sizeof(result))) {
-		btrfs_err(fs_info, "superblock checksum mismatch");
+		pr_err("BTRFS error (device %pg): superblock checksum mismatch",
+			bdev);
 		return -EINVAL;
 	}
 
@@ -2573,7 +2573,7 @@ int open_ctree(struct super_block *sb,
 	 * We want to check superblock checksum, the type is stored inside.
 	 * Pass the whole disk block of size BTRFS_SUPER_INFO_SIZE (4k).
 	 */
-	err = btrfs_check_super_csum(fs_info, bh->b_data);
+	err = btrfs_check_super_csum(fs_devices->latest_bdev, bh->b_data);
 	if (err) {
 		brelse(bh);
 		goto fail_alloc;
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 70a88d61b547..1427fa1181d4 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -69,6 +69,7 @@ int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors);
 struct buffer_head *btrfs_read_dev_super(struct block_device *bdev);
 int btrfs_read_dev_one_super(struct block_device *bdev, int copy_num,
 			struct buffer_head **bh_ret);
+int btrfs_check_super_csum(struct block_device *bdev, char *raw_disk_sb);
 int btrfs_commit_super(struct btrfs_fs_info *fs_info);
 struct btrfs_root *btrfs_read_fs_root(struct btrfs_root *tree_root,
 				      struct btrfs_key *location);
-- 
2.15.0

