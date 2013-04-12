Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22593 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527Ab3DLHxc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Apr 2013 03:53:32 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r3C7rVUh011653
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2013 07:53:32 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r3C7rUTV027687
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2013 07:53:31 GMT
Received: from abhmt106.oracle.com (abhmt106.oracle.com [141.146.116.58])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r3C7rUCg022147
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2013 07:53:30 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: a copy of superblock is zero may not mean btrfs is not there
Date: Fri, 12 Apr 2013 15:55:06 +0800
Message-Id: <1365753306-19412-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If one of the copy of the superblock is zero it does not
confirm to us that btrfs isn't there on that disk. When
we are having more than one copy of superblock we should
rather let the for loop to continue to check other copies.

the following test case and results would justify the
fix

mkfs.btrfs /dev/sdb /dev/sdc -f
mount /dev/sdb /btrfs
dd if=/dev/zero bs=1 count=8 of=/dev/sdc seek=$((64*1024+64))
~/before/btrfs-select-super -s 1 /dev/sdc
using SB copy 1, bytenr 67108864

here btrfs-select-super just wrote superblock to a mounted btrfs

with the fix:
./btrfs-select-super -s 1 /dev/sdc
/dev/sdc is currently mounted. Aborting.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 disk-io.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 589b37a..3f85c21 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1138,9 +1138,12 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
 
 		if (btrfs_super_bytenr(&buf) != bytenr )
 			continue;
-		/* if magic is NULL, the device was removed */
-		if (buf.magic == 0 && i == 0) 
-			return -1;
+		/* if magic is NULL, either the device was removed
+		*  OR user / application inflected the disk albeit
+		*  with the most common zeros.
+		*  so only this doesn't confirm that this disk
+		*  isn't part of btrfs
+		*/
 		if (buf.magic != cpu_to_le64(BTRFS_MAGIC))
 			continue;
 
-- 
1.8.1.227.g44fe835

