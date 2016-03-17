Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36545 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbcCQWN7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Mar 2016 18:13:59 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u2HMDwnN025956
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Mar 2016 22:13:58 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
	by userv0021.oracle.com (8.13.8/8.13.8) with ESMTP id u2HMDwKL032623
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Mar 2016 22:13:58 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
	by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id u2HMDvRL009877
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Mar 2016 22:13:57 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix performance regression of writing to prealloc/nocow file
Date: Thu, 17 Mar 2016 15:16:15 -0700
Message-Id: <1458252975-1349-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For nocow/prealloc files, we try our best to not allocate space, however,
this ends up a huge performance regression since it's expensive to check
if data is shared.

Let's go back to only go check shared data once we're not able to allocate
space.

The test was made against a tmpfs backed loop device:

xfs_io -f -c "falloc 0 400M" foobar
xfs_io -c "pwrite -W -b 4096 0 400M" foobar

Vanilla:
wrote 419430400/419430400 bytes at offset 0
400 MiB, 102400 ops; 0:00:01.00 (200.015 MiB/sec and 51203.8403 ops/sec)

Patched kernel:
wrote 419430400/419430400 bytes at offset 0
400 MiB, 102400 ops; 0:00:01.00 (346.137 MiB/sec and 88610.9796 ops/sec)

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/file.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 098bb8f..f66c1bc 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1525,16 +1525,12 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 
 		reserve_bytes = num_pages << PAGE_CACHE_SHIFT;
 
-		if (BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
-					     BTRFS_INODE_PREALLOC)) {
+		ret = btrfs_check_data_free_space(inode, pos, write_bytes);
+		if (ret == -ENOSPC &&
+		    BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
+						     BTRFS_INODE_PREALLOC)) {
 			ret = check_can_nocow(inode, pos, &write_bytes);
-			if (ret < 0)
-				break;
 			if (ret > 0) {
-				/*
-				 * For nodata cow case, no need to reserve
-				 * data space.
-				 */
 				only_release_metadata = true;
 				/*
 				 * our prealloc extent may be smaller than
@@ -1543,10 +1539,13 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 				num_pages = DIV_ROUND_UP(write_bytes + offset,
 							 PAGE_CACHE_SIZE);
 				reserve_bytes = num_pages << PAGE_CACHE_SHIFT;
+
+				ret = 0;
 				goto reserve_metadata;
+			} else {
+				ret = -ENOSPC;
 			}
 		}
-		ret = btrfs_check_data_free_space(inode, pos, write_bytes);
 		if (ret < 0)
 			break;
 
-- 
2.5.0

