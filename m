Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:57770 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751256AbeAYTIq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Jan 2018 14:08:46 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0PJ7Qah021833
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jan 2018 19:08:46 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2fqkb38hwu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jan 2018 19:08:46 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0PJ8ji7001130
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jan 2018 19:08:46 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0PJ8j1v007087
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jan 2018 19:08:45 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: do not check inode's runtime flags under root->orphan_lock
Date: Thu, 25 Jan 2018 11:02:55 -0700
Message-Id: <20180125180256.10844-8-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's not necessary to hold ->orphan_lock when checking inode's runtime
flags.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b3fe0a8..1511db2 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3354,14 +3354,6 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans,
 			return -ENOMEM;
 	}
 
-	spin_lock(&root->orphan_lock);
-	if (!root->orphan_block_rsv) {
-		root->orphan_block_rsv = block_rsv;
-	} else if (block_rsv) {
-		btrfs_free_block_rsv(fs_info, block_rsv);
-		block_rsv = NULL;
-	}
-
 	if (!test_and_set_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
 			      &inode->runtime_flags)) {
 #if 0
@@ -3376,12 +3368,23 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans,
 			insert = 1;
 #endif
 		insert = 1;
-		atomic_inc(&root->orphan_inodes);
 	}
 
 	if (!test_and_set_bit(BTRFS_INODE_ORPHAN_META_RESERVED,
 			      &inode->runtime_flags))
 		reserve = 1;
+
+	spin_lock(&root->orphan_lock);
+	/* If someone has created ->orphan_block_rsv, be happy to use it. */
+	if (!root->orphan_block_rsv) {
+		root->orphan_block_rsv = block_rsv;
+	} else if (block_rsv) {
+		btrfs_free_block_rsv(fs_info, block_rsv);
+		block_rsv = NULL;
+	}
+
+	if (insert)
+		atomic_inc(&root->orphan_inodes);
 	spin_unlock(&root->orphan_lock);
 
 	/* grab metadata reservation from transaction handle */
-- 
2.9.4

