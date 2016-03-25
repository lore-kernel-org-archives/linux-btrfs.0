Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64882 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754120AbcCYR0d (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 13:26:33 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.16.0.11/8.16.0.11) with SMTP id u2PHKjbp021158
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 10:26:32 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by m0089730.ppops.net with ESMTP id 21vva22wjj-1
	(version=TLSv1 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 10:26:32 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 14/14] Btrfs: don't do nocow check unless we have to
Date: Fri, 25 Mar 2016 13:26:00 -0400
Message-ID: <1458926760-17563-15-git-send-email-jbacik@fb.com>
In-Reply-To: <1458926760-17563-1-git-send-email-jbacik@fb.com>
References: <1458926760-17563-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before we write into prealloc/nocow space we have to make sure that there are no
references to the extents we are writing into, which means checking the extent
tree and csum tree in the case of nocow.  So we don't want to do the nocow dance
unless we can't reserve data space, since it's a serious drag on performance.
With the following sequence

fallocate -l10737418240 /mnt/btrfs-test/file
cp --reflink /mnt/btrfs-test/file /mnt/btrfs-test/link
fio --name=randwrite --rw=randwrite --bs=4k --filename=/mnt/btrfs-test/file \
	--end_fsync=1

we get the worst case scenario where we have to fall back on to doing the check
anyway.

Without this patch
lat (usec): min=5, max=111598, avg=27.65, stdev=124.51
write: io=10240MB, bw=126876KB/s, iops=31718, runt= 82646msec

With this patch
lat (usec): min=3, max=91210, avg=14.09, stdev=110.62
write: io=10240MB, bw=212753KB/s, iops=53188, runt= 49286msec

We get twice the throughput, half of the runtime, and half of the average
latency.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/file.c | 44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 0ce4bb3..7c80208 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1534,30 +1534,30 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 		reserve_bytes = round_up(write_bytes + sector_offset,
 				root->sectorsize);
 
-		if ((BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
-					      BTRFS_INODE_PREALLOC)) &&
-		    check_can_nocow(inode, pos, &write_bytes) > 0) {
-			/*
-			 * For nodata cow case, no need to reserve
-			 * data space.
-			 */
-			only_release_metadata = true;
-			/*
-			 * our prealloc extent may be smaller than
-			 * write_bytes, so scale down.
-			 */
-			num_pages = DIV_ROUND_UP(write_bytes + offset,
-						 PAGE_CACHE_SIZE);
-			reserve_bytes = round_up(write_bytes + sector_offset,
-					root->sectorsize);
-			goto reserve_metadata;
-		}
-
 		ret = btrfs_check_data_free_space(inode, pos, write_bytes);
-		if (ret < 0)
-			break;
+		if (ret < 0) {
+			if ((BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
+						      BTRFS_INODE_PREALLOC)) &&
+			    check_can_nocow(inode, pos, &write_bytes) > 0) {
+				/*
+				 * For nodata cow case, no need to reserve
+				 * data space.
+				 */
+				only_release_metadata = true;
+				/*
+				 * our prealloc extent may be smaller than
+				 * write_bytes, so scale down.
+				 */
+				num_pages = DIV_ROUND_UP(write_bytes + offset,
+							 PAGE_CACHE_SIZE);
+				reserve_bytes = round_up(write_bytes +
+							 sector_offset,
+							 root->sectorsize);
+			} else {
+				break;
+			}
+		}
 
-reserve_metadata:
 		ret = btrfs_delalloc_reserve_metadata(inode, reserve_bytes);
 		if (ret) {
 			if (!only_release_metadata)
-- 
2.5.0

