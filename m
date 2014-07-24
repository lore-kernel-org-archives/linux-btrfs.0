Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23303 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758482AbaGXD1p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jul 2014 23:27:45 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6O3Rf1O016902
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Jul 2014 11:27:41 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 1/3] btrfs-progs: fix wrong data ratio for raid56 in btrfs-file-usage
Date: Thu, 24 Jul 2014 11:21:52 +0800
Message-ID: <1406172114-10793-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When run btrfs-file-usage on a btrfs with data profile raid5/6,
the output message for "Free" & "Data to device ratio" seems wrong
as follows:
    ...
    Device size:		 100.00GiB
    Device allocated:		   2.04GiB
    Device unallocated:		  97.96GiB
    Used:			   1.12MiB
    Free (Estimated):		 197.89GiB <== Free > Device size
    Data to device ratio:	     198 % <== > 100%
    Global reserve:		     0.00B
    ...

It is because the function get_raid56_used() is not iterating the
chunk_info array correctly, it is just repeating adding the first
chunk_info statistics.
Just add a ptr to iterate over the array.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 cmds-fi-disk_usage.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/cmds-fi-disk_usage.c b/cmds-fi-disk_usage.c
index 453410f..78dc414 100644
--- a/cmds-fi-disk_usage.c
+++ b/cmds-fi-disk_usage.c
@@ -293,14 +293,16 @@ static struct btrfs_ioctl_space_args *load_space_info(int fd, char *path)
 static void get_raid56_used(int fd, struct chunk_info *chunks, int chunkcount,
 		u64 *raid5_used, u64 *raid6_used)
 {
+	struct chunk_info *info_ptr = chunks;
 	*raid5_used = 0;
 	*raid6_used = 0;
 
 	while (chunkcount-- > 0) {
-		if (chunks->type & BTRFS_BLOCK_GROUP_RAID5)
-			(*raid5_used) += chunks->size / (chunks->num_stripes - 1);
-		if (chunks->type & BTRFS_BLOCK_GROUP_RAID6)
-			(*raid6_used) += chunks->size / (chunks->num_stripes - 2);
+		if (info_ptr->type & BTRFS_BLOCK_GROUP_RAID5)
+			(*raid5_used) += info_ptr->size / (info_ptr->num_stripes - 1);
+		if (info_ptr->type & BTRFS_BLOCK_GROUP_RAID6)
+			(*raid6_used) += info_ptr->size / (info_ptr->num_stripes - 2);
+		info_ptr++;
 	}
 }
 
-- 
1.8.1.4

