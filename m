Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28889 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750951AbdAXX7k (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jan 2017 18:59:40 -0500
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v0ONxcU2012654
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jan 2017 23:59:38 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v0ONxcMs014487
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jan 2017 23:59:38 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id v0ONxauc031515
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jan 2017 23:59:37 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix wrong argument for btrfs_lookup_ordered_range
Date: Tue, 24 Jan 2017 15:58:51 -0800
Message-Id: <1485302331-20167-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit "d0b7da88 Btrfs: btrfs_page_mkwrite: Reserve space in sectorsized units"
did this, but btrfs_lookup_ordered_range expects a 'length' rather than a
'page_end'.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
Is this a candidate for stable?

 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4e02426..366cf0b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9023,7 +9023,7 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	 * we can't set the delalloc bits if there are pending ordered
 	 * extents.  Drop our locks and wait for them to finish
 	 */
-	ordered = btrfs_lookup_ordered_range(inode, page_start, page_end);
+	ordered = btrfs_lookup_ordered_range(inode, page_start, PAGE_SIZE);
 	if (ordered) {
 		unlock_extent_cached(io_tree, page_start, page_end,
 				     &cached_state, GFP_NOFS);
-- 
2.5.5

