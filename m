Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49796 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbaKYJgC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 04:36:02 -0500
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id sAP9a0BZ019742
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Nov 2014 09:36:01 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id sAP9a0u5012217
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Nov 2014 09:36:00 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id sAP9a0TY009693
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Nov 2014 09:36:00 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: fix a bug of converting sparse ext2/3/4
Date: Tue, 25 Nov 2014 17:35:52 +0800
Message-Id: <1416908152-8367-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When converting a sparse ext* filesystem, btrfs-convert adds checksum extents
for empty extents, whose disk_bytenr = 0, and this can end up with some weird
problems, one of them is the failure of reading free space cache inode on
mounting converted btrfs.

The fix is simple, just to skip making checksum on empty extents.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 btrfs-convert.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index a544fc6..02c5e94 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -393,7 +393,7 @@ static int record_file_blocks(struct btrfs_trans_handle *trans,
 	ret = btrfs_record_file_extent(trans, root, objectid, inode, file_pos,
 					disk_bytenr, num_bytes);
 
-	if (ret || !checksum)
+	if (ret || !checksum || disk_bytenr == 0)
 		return ret;
 
 	return csum_disk_extent(trans, root, disk_bytenr, num_bytes);
-- 
1.8.1.4

