Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:41174 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751109AbeCZIZz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Mar 2018 04:25:55 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2Q8JdJD039894
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 08:25:54 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2gxw8gg0r5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 08:25:54 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w2Q8Prc8025079
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 08:25:53 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w2Q8PrPH010916
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Mar 2018 08:25:53 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/8] btrfs: cleanup btrfs_check_super_csum() for better code flow
Date: Mon, 26 Mar 2018 16:27:34 +0800
Message-Id: <20180326082742.9235-2-anand.jain@oracle.com>
In-Reply-To: <20180326082742.9235-1-anand.jain@oracle.com>
References: <20180326082742.9235-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We check the %csum_type twice. Drop one. Check for the csum_type and
then for the csum. Which also matches with the progs which have better
logic. This is preparatory patch to get proper error code from
btrfs_check_super_csum().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 38 +++++++++++++++++---------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1657d6aa4fa6..b9b435579527 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -399,32 +399,28 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
 	struct btrfs_super_block *disk_sb =
 		(struct btrfs_super_block *)raw_disk_sb;
 	u16 csum_type = btrfs_super_csum_type(disk_sb);
-	int ret = 0;
-
-	if (csum_type == BTRFS_CSUM_TYPE_CRC32) {
-		u32 crc = ~(u32)0;
-		char result[sizeof(crc)];
-
-		/*
-		 * The super_block structure does not span the whole
-		 * BTRFS_SUPER_INFO_SIZE range, we expect that the unused space
-		 * is filled with zeros and is included in the checksum.
-		 */
-		crc = btrfs_csum_data(raw_disk_sb + BTRFS_CSUM_SIZE,
-				crc, BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE);
-		btrfs_csum_final(crc, result);
-
-		if (memcmp(raw_disk_sb, result, sizeof(result)))
-			ret = 1;
-	}
+	u32 crc = ~(u32)0;
+	char result[sizeof(crc)];
 
 	if (csum_type >= ARRAY_SIZE(btrfs_csum_sizes)) {
 		btrfs_err(fs_info, "unsupported checksum algorithm %u",
-				csum_type);
-		ret = 1;
+			  csum_type);
+		return 1;
 	}
 
-	return ret;
+	/*
+	 * The super_block structure does not span the whole
+	 * BTRFS_SUPER_INFO_SIZE range, we expect that the unused space
+	 * is filled with zeros and is included in the checksum.
+	 */
+	crc = btrfs_csum_data(raw_disk_sb + BTRFS_CSUM_SIZE,
+			      crc, BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE);
+	btrfs_csum_final(crc, result);
+
+	if (memcmp(raw_disk_sb, result, sizeof(result)))
+		return 1;
+
+	return 0;
 }
 
 /*
-- 
2.7.0

