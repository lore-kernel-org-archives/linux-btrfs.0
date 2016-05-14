Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19190 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339AbcENAFZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 May 2016 20:05:25 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u4E05OxP028127
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sat, 14 May 2016 00:05:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
	by aserv0022.oracle.com (8.13.8/8.13.8) with ESMTP id u4E05N4t032742
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sat, 14 May 2016 00:05:24 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
	by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id u4E05Nbw008373
	for <linux-btrfs@vger.kernel.org>; Sat, 14 May 2016 00:05:23 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/7] Btrfs: replace BUG_ON with WARN_ONCE in cow_file_range
Date: Fri, 13 May 2016 17:06:57 -0700
Message-Id: <1463184422-13584-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1463184422-13584-1-git-send-email-bo.li.liu@oracle.com>
References: <1463184422-13584-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This BUG_ON is more like a warning since an invalid
btrfs_super_total_bytes() doesn't affect other stuff.

Thus, use WARN_ONCE for warning purpose and don't leave a possible
kernel panic here.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2aaba58..5874562 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -974,8 +974,11 @@ static noinline int cow_file_range(struct inode *inode,
 		}
 	}
 
-	BUG_ON(disk_num_bytes >
-	       btrfs_super_total_bytes(root->fs_info->super_copy));
+	WARN_ONCE(disk_num_bytes >
+		  btrfs_super_total_bytes(root->fs_info->super_copy),
+	  KERN_WARNING "disk_num_bytes(%llu) > btrfs_super_total_bytes(%llu)\n",
+		  disk_num_bytes,
+		  btrfs_super_total_bytes(root->fs_info->super_copy));
 
 	alloc_hint = get_extent_allocation_hint(inode, start, num_bytes);
 	btrfs_drop_extent_cache(inode, start, start + num_bytes - 1, 0);
-- 
2.5.5

