Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:43864 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752655AbeCTJ6n (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Mar 2018 05:58:43 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2K9wCao039461
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Mar 2018 09:58:42 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2gu04tr0gq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Mar 2018 09:58:36 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w2K9pOFr018557
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Mar 2018 09:51:24 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w2K9pOMu006980
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Mar 2018 09:51:24 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs: cleanup btrfs_check_super_csum() to check the csum_type to the type
Date: Tue, 20 Mar 2018 17:53:08 +0800
Message-Id: <20180320095310.6355-2-anand.jain@oracle.com>
In-Reply-To: <20180320095310.6355-1-anand.jain@oracle.com>
References: <20180320095310.6355-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

%csum_type is being checked to check the number of csum types we support,
which is 1 as of now. Instead just check if the type matches with the
only type we support, that is BTRFS_CSUM_TYPE_CRC32. And further adds
cleanup.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 41 +++++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1657d6aa4fa6..582ed6af3c50 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -399,32 +399,29 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
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
 
-	if (csum_type >= ARRAY_SIZE(btrfs_csum_sizes)) {
+	/* We support csum type crc32 only as of now */
+	if (csum_type != BTRFS_CSUM_TYPE_CRC32) {
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
2.15.0

