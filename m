Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59764 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755240AbeBOKGg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 05:06:36 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1F9vHd7193580
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 10:06:36 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2g57dcg8dq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 10:06:35 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w1FA6Ytt009117
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 10:06:35 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w1FA6YS9029311
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 10:06:34 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: use ASSERT to report logical error in cow_file_range()
Date: Thu, 15 Feb 2018 18:07:59 +0800
Message-Id: <20180215100759.11647-1-anand.jain@oracle.com>
In-Reply-To: <8fd2c67e-3808-f9a8-043c-54a296fc40c6@suse.com>
References: <8fd2c67e-3808-f9a8-043c-54a296fc40c6@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use ASSERT to report logical error in cow_file_range(), also move
it a bit closer to when the num_bytes is derived.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v1->v2:
   ASSERT logic changed. Thanks Nikolay.

 fs/btrfs/inode.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4b156e191592..260fd8139951 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -976,6 +976,7 @@ static noinline int cow_file_range(struct inode *inode,
 
 	num_bytes = ALIGN(end - start + 1, blocksize);
 	num_bytes = max(blocksize,  num_bytes);
+	ASSERT(num_bytes <= btrfs_super_total_bytes(fs_info->super_copy));
 
 	inode_should_defrag(BTRFS_I(inode), start, end, num_bytes, SZ_64K);
 
@@ -1006,9 +1007,6 @@ static noinline int cow_file_range(struct inode *inode,
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

