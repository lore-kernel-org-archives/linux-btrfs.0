Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27455 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750725AbdHBVeD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Aug 2017 17:34:03 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v72LY2dE016228
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 2 Aug 2017 21:34:03 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v72LY2JY003077
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 2 Aug 2017 21:34:02 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v72LY2SC023875
        for <linux-btrfs@vger.kernel.org>; Wed, 2 Aug 2017 21:34:02 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: search parity device wisely
Date: Wed,  2 Aug 2017 14:32:46 -0600
Message-Id: <20170802203246.27121-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After mapping block with BTRFS_MAP_WRITE, parities have been sorted to
the end position, so this search can start from the first parity
stripe.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/raid56.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index d8ea0eb..0c5ed68 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -2225,12 +2225,13 @@ raid56_parity_alloc_scrub_rbio(struct btrfs_fs_info *fs_info, struct bio *bio,
 	ASSERT(!bio->bi_iter.bi_size);
 	rbio->operation = BTRFS_RBIO_PARITY_SCRUB;
 
-	for (i = 0; i < rbio->real_stripes; i++) {
+	for (i = rbio->data_stripes; i < rbio->real_stripes; i++) {
 		if (bbio->stripes[i].dev == scrub_dev) {
 			rbio->scrubp = i;
 			break;
 		}
 	}
+	ASSERT(i < rbio->real_stripes);
 
 	/* Now we just support the sectorsize equals to page size */
 	ASSERT(fs_info->sectorsize == PAGE_SIZE);
-- 
2.9.4

