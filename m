Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26350 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdHRS7K (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 14:59:10 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7IIx958027391
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Aug 2017 18:59:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v7IIx9vG024211
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Aug 2017 18:59:09 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v7IIx9XV010826
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Aug 2017 18:59:09 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: do not async submit for nodatacsum inodes
Date: Fri, 18 Aug 2017 11:54:02 -0600
Message-Id: <20170818175402.27633-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While we submit direct writes, if the inode is flagged with nodatasum,
there's no benefit to submit asynchronously, because

a) we don't have to calculate checksum across processors,

b) and direct IO has started a plug, but async submit makes us queue
IO on each device's scheduled IO list instead of DIO's plug list, so
that IOs get much less merges in general.

Lets use sync submit for nodatasum inodes.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 95c2120..f4a48d8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8467,7 +8467,7 @@ static inline int __btrfs_submit_dio_bio(struct bio *bio, struct inode *inode,
 			goto err;
 	}
 map:
-	ret = btrfs_map_bio(fs_info, bio, 0, async_submit);
+	ret = btrfs_map_bio(fs_info, bio, 0, 0);
 err:
 	bio_put(bio);
 	return ret;
-- 
2.9.4

