Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51927 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbcFWB26 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jun 2016 21:28:58 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u5N1Svit012765
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jun 2016 01:28:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by userv0021.oracle.com (8.13.8/8.13.8) with ESMTP id u5N1SvWn025162
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jun 2016 01:28:57 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
	by aserv0122.oracle.com (8.13.8/8.13.8) with ESMTP id u5N1StvF023358
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jun 2016 01:28:56 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix BUG_ON in btrfs_submit_compressed_write
Date: Wed, 22 Jun 2016 18:32:06 -0700
Message-Id: <1466645526-27128-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is similar to btrfs_submit_compressed_read(), if we fail after
bio is allocated, then we can use bio_endio() and errors are saved
 in bio->bi_error.  But please note that we don't return errors to
its caller because the caller assumes it won't call endio to cleanup
on error.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/compression.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 658c39b..7a4d9c8 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -402,7 +402,10 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 			}
 
 			ret = btrfs_map_bio(root, WRITE, bio, 0, 1);
-			BUG_ON(ret); /* -ENOMEM */
+			if (ret) {
+				bio->bi_error = ret;
+				bio_endio(bio);
+			}
 
 			bio_put(bio);
 
@@ -432,7 +435,10 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 	}
 
 	ret = btrfs_map_bio(root, WRITE, bio, 0, 1);
-	BUG_ON(ret); /* -ENOMEM */
+	if (ret) {
+		bio->bi_error = ret;
+		bio_endio(bio);
+	}
 
 	bio_put(bio);
 	return 0;
-- 
2.5.5

