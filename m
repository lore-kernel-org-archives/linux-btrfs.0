Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:34396 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752964AbcLOG5h (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Dec 2016 01:57:37 -0500
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
        by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id uBF6vTPq028702
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Dec 2016 06:57:29 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] Btrfs: fix another race between truncate and lockless dio write
Date: Wed, 14 Dec 2016 23:04:05 -0800
Message-Id: <1481785445-13329-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dio writes can update i_size in btrfs_get_blocks_direct when it
writes to offset beyond EOF so that endio can update disk_i_size
correctly (because we don't udpate disk_i_size beyond i_size).

However, when truncating down a file, we firstly update i_size
and then wait for in-flight lockless dio reads/writes, according
to the above, i_size may have been changed in dio writes, and
file extents don't get truncated.

For lockless dio writes are always overwrites, i_size is not
supposed to be changed, so this adds a check to filter out this
case.

The race could be reproduced by fstests/generic/299 with patch
"Btrfs: fix btrfs_ordered_update_i_size to update disk_i_size properly"
 applied.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c9973e5..171d8e8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -72,6 +72,7 @@ struct btrfs_dio_data {
 	u64 reserve;
 	u64 unsubmitted_oe_range_start;
 	u64 unsubmitted_oe_range_end;
+	int overwrite;
 };
 
 static const struct inode_operations btrfs_dir_inode_operations;
@@ -7833,7 +7834,7 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
 		 * Need to update the i_size under the extent lock so buffered
 		 * readers will get the updated i_size when we unlock.
 		 */
-		if (start + len > i_size_read(inode))
+		if (!dio_data->overwrite && start + len > i_size_read(inode))
 			i_size_write(inode, start + len);
 
 		adjust_dio_outstanding_extents(inode, dio_data, len);
@@ -8715,6 +8716,7 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 		 * not unlock the i_mutex at this case.
 		 */
 		if (offset + count <= inode->i_size) {
+			dio_data.overwrite = 1;
 			inode_unlock(inode);
 			relock = true;
 		}
-- 
2.5.5

