Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:11650 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726308AbeIMN3C (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Sep 2018 09:29:02 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id F151C4B6EC75
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Sep 2018 16:20:33 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: lowmem: fix false alert about the existence of gaps in the check_file_extent
Date: Thu, 13 Sep 2018 16:20:26 +0800
Message-ID: <20180913082026.16996-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In the check_inode_item function, the extent_end variable used to store the
end of the last file extent that has checked. When it passes to
check_file_extent, if the offset of the next file extent is not equal to
it, there is a gap between the two file extents.

In the case of a gap existing, it is wrong that only add the
extent_num_bytes of this file extent to the invalid extent_end variable as
before. Therefore, lowmem check will false alert that there are gaps
between the subsequent file extents of this inode due to the wrong
extent_end variable.

Solution:
The extent_end variable should set to the sum of the offset and the
extent_num_bytes of the file extent.

Example:
Suppose that lowmem check the following file extent of inode 257.

        item 6 key (257 EXTENT_DATA 0) itemoff 15813 itemsize 53
                generation 6 type 1 (regular)
                extent data disk byte 13631488 nr 4096
                extent data offset 0 nr 4096 ram 4096
                extent compression 0 (none)
        item 7 key (257 EXTENT_DATA 8192) itemoff 15760 itemsize 53
                generation 6 type 1 (regular)
                extent data disk byte 13631488 nr 4096
                extent data offset 0 nr 4096 ram 4096
                extent compression 0 (none)
        item 8 key (257 EXTENT_DATA 12288) itemoff 15707 itemsize 53
                generation 6 type 1 (regular)
                extent data disk byte 13631488 nr 4096
                extent data offset 0 nr 4096 ram 4096
                extent compression 0 (none)

For inode 257, check_inode_item set extent_end to 0, then call
check_file_extent to check item {6,7,8}.
item 6)
	offset(0) == extent_end(0)
	extent_end = extent_end(0) + extent_num_bytes(4096)
item 7)
	offset(8192) != extent_end(4096)
	extent_end = extent_end(4096) + extent_num_bytes(4096)
			^^^
	The old extent_end should replace by offset(8192).
item 8)
	offset(12288) != extent_end(8192)
		^^^
	But there is no gap between item {7,8}.

Fixes: d88da10ddd42 ("btrfs-progs: check: introduce function to check file extent")
Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 check/mode-lowmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 1bce44f5658a..370318f0e631 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -1974,7 +1974,7 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_path *path,
 		}
 	}
 
-	*end += extent_num_bytes;
+	*end = fkey.offset + extent_num_bytes;
 	if (!is_hole)
 		*size += extent_num_bytes;
 
-- 
2.18.0
