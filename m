Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44414 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab3DOGhl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Apr 2013 02:37:41 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 11/11, RESEND] btrfs-progs: a copy of superblock is zero may not mean btrfs is not there
Date: Mon, 15 Apr 2013 14:38:17 +0800
Message-Id: <1366007897-26567-12-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1366007897-26567-1-git-send-email-anand.jain@oracle.com>
References: <1365141303-10571-1-git-send-email-anand.jain@oracle.com>
 <1366007897-26567-1-git-send-email-anand.jain@oracle.com>
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

