Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27650 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756042AbdDGUMZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Apr 2017 16:12:25 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v37KCMJv022368
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 7 Apr 2017 20:12:23 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v37KCMbn005718
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 7 Apr 2017 20:12:22 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v37KCMvo018842
        for <linux-btrfs@vger.kernel.org>; Fri, 7 Apr 2017 20:12:22 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix segment fault when doing dio read
Date: Fri,  7 Apr 2017 13:11:10 -0700
Message-Id: <1491595870-9633-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 2dabb3248453 ("Btrfs: Direct I/O read: Work on sectorsized blocks")
introduced this bug during iterating bio pages in dio read's endio hook,
and it could end up with segment fault of the dio reading task.

So the reason is 'if (nr_sectors--)', and it makes the code assume that
there is one more block in the same page, so page offset is increased and
the bio which is created to repair the bad block then has an incorrect
bvec.bv_offset, and a later access of the page content would throw a
segment fault.

This also adds ASSERT to check page offset against page size.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c875e68..5e71f1e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7972,8 +7972,10 @@ static int __btrfs_correct_data_nocsum(struct inode *inode,
 
 		start += sectorsize;
 
-		if (nr_sectors--) {
+		nr_sectors--;
+		if (nr_sectors) {
 			pgoff += sectorsize;
+			ASSERT(pgoff < PAGE_SIZE);
 			goto next_block_or_try_again;
 		}
 	}
@@ -8074,8 +8076,10 @@ static int __btrfs_subio_endio_read(struct inode *inode,
 
 		ASSERT(nr_sectors);
 
-		if (--nr_sectors) {
+		nr_sectors--;
+		if (nr_sectors) {
 			pgoff += sectorsize;
+			ASSERT(pgoff < PAGE_SIZE);
 			goto next_block;
 		}
 	}
-- 
2.5.5

