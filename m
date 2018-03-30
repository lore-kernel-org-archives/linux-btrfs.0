Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57804 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751182AbeC3AQi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Mar 2018 20:16:38 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2U04fWq007781
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Mar 2018 00:16:37 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2h1abwr1wt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Mar 2018 00:16:36 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w2U07c1U001720
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Mar 2018 00:07:38 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w2U07cnu008759
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Mar 2018 00:07:38 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 2/7] btrfs: return required error from btrfs_check_super_csum
Date: Fri, 30 Mar 2018 08:09:18 +0800
Message-Id: <20180330000924.11148-3-anand.jain@oracle.com>
In-Reply-To: <20180330000924.11148-1-anand.jain@oracle.com>
References: <20180330000924.11148-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Return the required -EINVAL and -EUCLEAN from the function
btrfs_check_super_csum(). And more the error log into the
parent function.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
---
v2->v4:
 Check for -EUCLEAN in else if
v1->v2:
 Fix commit indent reported by checkpatch.pl
 Fix pr_err split string

 fs/btrfs/disk-io.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b9b435579527..c3a9407fc3a5 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -392,9 +392,10 @@ static int verify_parent_transid(struct extent_io_tree *io_tree,
 /*
  * Return 0 if the superblock checksum type matches the checksum value of that
  * algorithm. Pass the raw disk superblock data.
+ * Otherwise:	-EINVAL  if csum type is not found
+ *		-EUCLEAN if csum does not match
  */
-static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
-				  char *raw_disk_sb)
+static int btrfs_check_super_csum(char *raw_disk_sb)
 {
 	struct btrfs_super_block *disk_sb =
 		(struct btrfs_super_block *)raw_disk_sb;
@@ -402,11 +403,8 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
 	u32 crc = ~(u32)0;
 	char result[sizeof(crc)];
 
-	if (csum_type >= ARRAY_SIZE(btrfs_csum_sizes)) {
-		btrfs_err(fs_info, "unsupported checksum algorithm %u",
-			  csum_type);
-		return 1;
-	}
+	if (csum_type >= ARRAY_SIZE(btrfs_csum_sizes))
+		return -EINVAL;
 
 	/*
 	 * The super_block structure does not span the whole
@@ -418,7 +416,7 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
 	btrfs_csum_final(crc, result);
 
 	if (memcmp(raw_disk_sb, result, sizeof(result)))
-		return 1;
+		return -EUCLEAN;
 
 	return 0;
 }
@@ -2570,9 +2568,14 @@ int open_ctree(struct super_block *sb,
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
 		brelse(bh);
 		goto fail_alloc;
 	}
-- 
2.7.0

