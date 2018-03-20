Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33050 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751697AbeCTXbd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Mar 2018 19:31:33 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2KNNik5026235
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Mar 2018 23:31:32 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2gubxfg0py-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Mar 2018 23:31:32 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w2KNVV2P027310
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Mar 2018 23:31:32 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w2KNVVSG000343
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Mar 2018 23:31:31 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/2] btrfs: return required error from btrfs_check_super_csum
Date: Wed, 21 Mar 2018 07:33:16 +0800
Message-Id: <20180320233316.20653-3-anand.jain@oracle.com>
In-Reply-To: <20180320233316.20653-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20180320233316.20653-1-anand.jain@oracle.com>

Return the required -EINVAL and -EUCLEAN from the function
btrfs_check_super_csum(). And more the error log into the
parent function.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 582ed6af3c50..4c6de2743250 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -392,9 +392,10 @@ static int verify_parent_transid(struct extent_io_tree *io_tree,
 /*
  * Return 0 if the superblock checksum type matches the checksum value of that
  * algorithm. Pass the raw disk superblock data.
+ * Otherwise: -EINVAL  if csum type is not found
+ * 	      -EUCLEAN if csum does not match
  */
-static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
-				  char *raw_disk_sb)
+static int btrfs_check_super_csum(char *raw_disk_sb)
 {
 	struct btrfs_super_block *disk_sb =
 		(struct btrfs_super_block *)raw_disk_sb;
@@ -403,11 +404,8 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
 	char result[sizeof(crc)];
 
 	/* We support csum type crc32 only as of now */
-	if (csum_type != BTRFS_CSUM_TYPE_CRC32) {
-		btrfs_err(fs_info, "unsupported checksum algorithm %u",
-			  csum_type);
-		return 1;
-	}
+	if (csum_type != BTRFS_CSUM_TYPE_CRC32)
+		return -EINVAL;
 
 	/*
 	 * The super_block structure does not span the whole
@@ -419,7 +417,7 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
 	btrfs_csum_final(crc, result);
 
 	if (memcmp(raw_disk_sb, result, sizeof(result)))
-		return 1;
+		return -EUCLEAN;
 
 	return 0;
 }
@@ -2571,9 +2569,17 @@ int open_ctree(struct super_block *sb,
 	 * We want to check superblock checksum, the type is stored inside.
 	 * Pass the whole disk block of size BTRFS_SUPER_INFO_SIZE (4k).
 	 */
-	if (btrfs_check_super_csum(fs_info, bh->b_data)) {
-		btrfs_err(fs_info, "superblock checksum mismatch");
-		err = -EINVAL;
+	err = btrfs_check_super_csum(bh->b_data);
+	if (err) {
+		if (err == -EINVAL)
+			pr_err("BTRFS error (device %pg): unsupported checksum algorithm",
+				fs_devices->latest_bdev);
+		else if (err == -EUCLEAN)
+			pr_err("BTRFS error (device %pg): superblock checksum mismatch",
+				fs_devices->latest_bdev);
+		else
+			pr_err("BTRFS error (device %pg): checksum check failed %d",
+				fs_devices->latest_bdev, err);
 		brelse(bh);
 		goto fail_alloc;
 	}
-- 
2.15.0

