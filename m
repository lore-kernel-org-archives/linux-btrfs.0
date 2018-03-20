Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:35498 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752136AbeCTJv0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Mar 2018 05:51:26 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2K9jvic003975
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Mar 2018 09:51:26 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2gtyxer105-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Mar 2018 09:51:26 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w2K9pPuL007936
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Mar 2018 09:51:25 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w2K9pP4G023303
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Mar 2018 09:51:25 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs: return required error from btrfs_check_super_csum
Date: Tue, 20 Mar 2018 17:53:09 +0800
Message-Id: <20180320095310.6355-3-anand.jain@oracle.com>
In-Reply-To: <20180320095310.6355-1-anand.jain@oracle.com>
References: <20180320095310.6355-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Return the required -EINVAL from the function btrfs_check_super_csum()
and move the error logging into the btrfs_check_super_csum() itself.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 582ed6af3c50..aafd836af61d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -406,7 +406,7 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
 	if (csum_type != BTRFS_CSUM_TYPE_CRC32) {
 		btrfs_err(fs_info, "unsupported checksum algorithm %u",
 			  csum_type);
-		return 1;
+		return -EINVAL;
 	}
 
 	/*
@@ -418,8 +418,10 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
 			      crc, BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE);
 	btrfs_csum_final(crc, result);
 
-	if (memcmp(raw_disk_sb, result, sizeof(result)))
-		return 1;
+	if (memcmp(raw_disk_sb, result, sizeof(result))) {
+		btrfs_err(fs_info, "superblock checksum mismatch");
+		return -EINVAL;
+	}
 
 	return 0;
 }
@@ -2571,9 +2573,8 @@ int open_ctree(struct super_block *sb,
 	 * We want to check superblock checksum, the type is stored inside.
 	 * Pass the whole disk block of size BTRFS_SUPER_INFO_SIZE (4k).
 	 */
-	if (btrfs_check_super_csum(fs_info, bh->b_data)) {
-		btrfs_err(fs_info, "superblock checksum mismatch");
-		err = -EINVAL;
+	err = btrfs_check_super_csum(fs_info, bh->b_data);
+	if (err) {
 		brelse(bh);
 		goto fail_alloc;
 	}
-- 
2.15.0

