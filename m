Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41448 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756704Ab3GYRYS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jul 2013 13:24:18 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r6PHOHIP024231
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jul 2013 17:24:18 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6PHOHOM022131
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jul 2013 17:24:17 GMT
Received: from abhmt109.oracle.com (abhmt109.oracle.com [141.146.116.61])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6PHOGgH002939
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jul 2013 17:24:16 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: use BTRFS_SUPER_INFO_SIZE macro at btrfs_read_dev_super()
Date: Fri, 26 Jul 2013 01:29:35 +0800
Message-Id: <1374773376-29853-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index dfe6864..de5884f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2982,9 +2982,11 @@ struct buffer_head *btrfs_read_dev_super(struct block_device *bdev)
 	 */
 	for (i = 0; i < 1; i++) {
 		bytenr = btrfs_sb_offset(i);
-		if (bytenr + 4096 >= i_size_read(bdev->bd_inode))
+		if (bytenr + BTRFS_SUPER_INFO_SIZE >=
+					i_size_read(bdev->bd_inode))
 			break;
-		bh = __bread(bdev, bytenr / 4096, 4096);
+		bh = __bread(bdev, bytenr / 4096,
+					BTRFS_SUPER_INFO_SIZE);
 		if (!bh)
 			continue;
 
-- 
1.7.1

