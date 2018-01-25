Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47090 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751258AbeAYTIr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Jan 2018 14:08:47 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0PJ7gdJ061119
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jan 2018 19:08:46 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2fqkb3ghf1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jan 2018 19:08:46 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0PJ8iwj001062
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jan 2018 19:08:45 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0PJ8ijl007079
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jan 2018 19:08:44 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix btrfs_evict_inode to handle abnormal inodes correctly
Date: Thu, 25 Jan 2018 11:02:53 -0700
Message-Id: <20180125180256.10844-6-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This regression is introduced in
commit 3d48d9810de4 ("btrfs: Handle uninitialised inode eviction").

There are two problems,

a) it is ->destroy_inode() that does the final free on inode, not
   ->evict_inode(),
b) clear_inode() must be called before ->evict_inode() returns.

This could end up hitting BUG_ON(inode->i_state != (I_FREEING | I_CLEAR));
in evict() because I_CLEAR is set in clear_inode().

Fixes: commit 3d48d9810de4 ("btrfs: Handle uninitialised inode eviction")
Cc: <stable@vger.kernel.org> # v4.7-rc6+
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 281a250..bc6ef73 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5286,7 +5286,7 @@ void btrfs_evict_inode(struct inode *inode)
 	trace_btrfs_inode_evict(inode);
 
 	if (!root) {
-		kmem_cache_free(btrfs_inode_cachep, BTRFS_I(inode));
+		clear_inode(inode);
 		return;
 	}
 
-- 
2.9.4

