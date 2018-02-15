Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:35148 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966421AbeBOE3W (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Feb 2018 23:29:22 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1F4RR1R131239
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 04:29:21 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2g533980xn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 04:29:21 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w1F4TKKC019069
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 04:29:20 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w1F4TKFZ013027
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 04:29:20 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: use ASSERT to report logical error in cow_file_range()
Date: Thu, 15 Feb 2018 12:30:44 +0800
Message-Id: <20180215043044.19248-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use ASSERT to report logical error in cow_file_range(), also move
it a bit closer to when the num_bytes is derived.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/inode.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4b156e191592..5648c4425f1e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -976,6 +976,8 @@ static noinline int cow_file_range(struct inode *inode,
 
 	num_bytes = ALIGN(end - start + 1, blocksize);
 	num_bytes = max(blocksize,  num_bytes);
+	ASSERT(!(num_bytes >
+		 btrfs_super_total_bytes(fs_info->super_copy)));
 
 	inode_should_defrag(BTRFS_I(inode), start, end, num_bytes, SZ_64K);
 
@@ -1006,9 +1008,6 @@ static noinline int cow_file_range(struct inode *inode,
 		}
 	}
 
-	BUG_ON(num_bytes >
-	       btrfs_super_total_bytes(fs_info->super_copy));
-
 	alloc_hint = get_extent_allocation_hint(inode, start, num_bytes);
 	btrfs_drop_extent_cache(BTRFS_I(inode), start,
 			start + num_bytes - 1, 0);
-- 
2.15.0

