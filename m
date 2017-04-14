Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34311 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751083AbdDNBNH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Apr 2017 21:13:07 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v3E1D6wF013038
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Apr 2017 01:13:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v3E1D6RQ013045
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Apr 2017 01:13:06 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id v3E1D37a002650
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Apr 2017 01:13:05 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: skip checksum verification if IO error occurs
Date: Thu, 13 Apr 2017 18:11:48 -0700
Message-Id: <1492132308-2959-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently dio read also goes to verify checksum if -EIO has been returned,
although it usually fails on checksum, it's not necessary at all, we could
directly check if there is another copy to read.

And with this, the behavior of dio read is now consistent with that of
buffered read.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5e71f1e..632b616 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8030,6 +8030,7 @@ static int __btrfs_subio_endio_read(struct inode *inode,
 	unsigned int pgoff;
 	int csum_pos;
 	int i;
+	int uptodate = !!(err == 0);
 	int ret;
 
 	fs_info = BTRFS_I(inode)->root->fs_info;
@@ -8044,12 +8045,14 @@ static int __btrfs_subio_endio_read(struct inode *inode,
 
 		pgoff = bvec->bv_offset;
 next_block:
-		csum_pos = BTRFS_BYTES_TO_BLKS(fs_info, offset);
-		ret = __readpage_endio_check(inode, io_bio, csum_pos,
-					bvec->bv_page, pgoff, start,
-					sectorsize);
-		if (likely(!ret))
-			goto next;
+		if (uptodate) {
+			csum_pos = BTRFS_BYTES_TO_BLKS(fs_info, offset);
+			ret = __readpage_endio_check(inode, io_bio, csum_pos,
+						     bvec->bv_page, pgoff,
+						     start, sectorsize);
+			if (likely(!ret))
+				goto next;
+		}
 try_again:
 		done.uptodate = 0;
 		done.start = start;
-- 
2.5.5

