Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34453 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751700AbdHCUyq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Aug 2017 16:54:46 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v73KsigY003002
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 3 Aug 2017 20:54:45 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v73KsiW6015348
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 3 Aug 2017 20:54:44 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v73Ksitd003569
        for <linux-btrfs@vger.kernel.org>; Thu, 3 Aug 2017 20:54:44 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] Btrfs: search parity device wisely
Date: Thu,  3 Aug 2017 13:53:31 -0600
Message-Id: <20170803195331.20079-1-bo.li.liu@oracle.com>
In-Reply-To: <20170802203246.27121-1-bo.li.liu@oracle.com>
References: <20170802203246.27121-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After mapping block with BTRFS_MAP_WRITE, parities have been sorted to
the end position, so this search can start from the first parity
stripe.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2: fix typo (data_stripes -> nr_data).

 fs/btrfs/raid56.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 2086383..88a5b7b 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -2229,12 +2229,13 @@ raid56_parity_alloc_scrub_rbio(struct btrfs_fs_info *fs_info, struct bio *bio,
 	ASSERT(!bio->bi_iter.bi_size);
 	rbio->operation = BTRFS_RBIO_PARITY_SCRUB;
 
-	for (i = 0; i < rbio->real_stripes; i++) {
+	for (i = rbio->nr_data; i < rbio->real_stripes; i++) {
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

