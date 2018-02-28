Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:54274 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751831AbeB1COA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Feb 2018 21:14:00 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1S2CXkD094154
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Feb 2018 02:13:59 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2gdgpk8e46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Feb 2018 02:13:59 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w1S2Dw53014805
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Feb 2018 02:13:58 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w1S2DwFZ002715
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Feb 2018 02:13:58 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: dev-replace: skip prealloc extents when copy nocow pages
Date: Tue, 27 Feb 2018 18:10:58 -0700
Message-Id: <20180228011058.23906-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It doens't make sense to process prealloc extents as pages will be
filled with zero when reading prealloc extents.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/scrub.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index ec56f33..9882513 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -4480,7 +4480,8 @@ static int check_extent_to_block(struct btrfs_inode *inode, u64 start, u64 len,
 	 * move on to the next inode.
 	 */
 	if (em->block_start > logical ||
-	    em->block_start + em->block_len < logical + len) {
+	    em->block_start + em->block_len < logical + len ||
+	    test_bit(EXTENT_FLAG_PREALLOC, &em->flags)) {
 		free_extent_map(em);
 		ret = 1;
 		goto out_unlock;
-- 
2.9.4

