Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42127 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab3DVKxf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Apr 2013 06:53:35 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r3MArX3j002418
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Apr 2013 10:53:34 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r3MArXMd014959
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Apr 2013 10:53:33 GMT
Received: from abhmt118.oracle.com (abhmt118.oracle.com [141.146.116.70])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r3MArWPJ005383
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Apr 2013 10:53:32 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: return free space in cow error path
Date: Mon, 22 Apr 2013 18:53:47 +0800
Message-Id: <1366628027-12682-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Replace some BUG_ONs with proper handling and take allocated space back to
free space cache for later use.

We don't have to worry about extent maps since they'd be freed in releasepage
path.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b883815..f8b4efa 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -921,7 +921,8 @@ static noinline int __cow_file_range(struct btrfs_trans_handle *trans,
 		}
 
 		em = alloc_extent_map();
-		BUG_ON(!em); /* -ENOMEM */
+		if (!em)
+			goto out_reserve;
 		em->start = start;
 		em->orig_start = em->start;
 		ram_size = ins.offset;
@@ -950,11 +951,14 @@ static noinline int __cow_file_range(struct btrfs_trans_handle *trans,
 			btrfs_drop_extent_cache(inode, start,
 						start + ram_size - 1, 0);
 		}
+		if (ret)
+			goto out_reserve;
 
 		cur_alloc_size = ins.offset;
 		ret = btrfs_add_ordered_extent(inode, start, ins.objectid,
 					       ram_size, cur_alloc_size, 0);
-		BUG_ON(ret); /* -ENOMEM */
+		if (ret)
+			goto out_reserve;
 
 		if (root->root_key.objectid ==
 		    BTRFS_DATA_RELOC_TREE_OBJECTID) {
@@ -962,7 +966,7 @@ static noinline int __cow_file_range(struct btrfs_trans_handle *trans,
 						      cur_alloc_size);
 			if (ret) {
 				btrfs_abort_transaction(trans, root, ret);
-				goto out_unlock;
+				goto out_reserve;
 			}
 		}
 
@@ -991,6 +995,8 @@ static noinline int __cow_file_range(struct btrfs_trans_handle *trans,
 out:
 	return ret;
 
+out_reserve:
+	btrfs_free_reserved_extent(root, ins.objectid, ins.offset);
 out_unlock:
 	extent_clear_unlock_delalloc(inode,
 		     &BTRFS_I(inode)->io_tree,
-- 
1.7.7.6

