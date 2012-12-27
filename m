Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49637 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab2L0JDn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Dec 2012 04:03:43 -0500
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qBR93f2Z008371
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2012 09:03:42 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qBR93frP003541
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2012 09:03:41 GMT
Received: from abhmt114.oracle.com (abhmt114.oracle.com [141.146.116.66])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qBR93eL5007098
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2012 03:03:40 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/8] Btrfs: kill unused argument of update_block_group
Date: Thu, 27 Dec 2012 17:01:19 +0800
Message-Id: <1356598884-22952-3-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1356598884-22952-1-git-send-email-bo.li.liu@oracle.com>
References: <1356598884-22952-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Argument 'trans' is not used any more.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent-tree.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b57c233..6f71a7a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -72,8 +72,7 @@ enum {
 	RESERVE_ALLOC_NO_ACCOUNT = 2,
 };
 
-static int update_block_group(struct btrfs_trans_handle *trans,
-			      struct btrfs_root *root,
+static int update_block_group(struct btrfs_root *root,
 			      u64 bytenr, u64 num_bytes, int alloc);
 static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
@@ -4729,8 +4728,7 @@ void btrfs_delalloc_release_space(struct inode *inode, u64 num_bytes)
 	btrfs_free_reserved_data_space(inode, num_bytes);
 }
 
-static int update_block_group(struct btrfs_trans_handle *trans,
-			      struct btrfs_root *root,
+static int update_block_group(struct btrfs_root *root,
 			      u64 bytenr, u64 num_bytes, int alloc)
 {
 	struct btrfs_block_group_cache *cache = NULL;
@@ -5279,7 +5277,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 			}
 		}
 
-		ret = update_block_group(trans, root, bytenr, num_bytes, 0);
+		ret = update_block_group(root, bytenr, num_bytes, 0);
 		if (ret) {
 			btrfs_abort_transaction(trans, extent_root, ret);
 			goto out;
@@ -6101,7 +6099,7 @@ static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(path->nodes[0]);
 	btrfs_free_path(path);
 
-	ret = update_block_group(trans, root, ins->objectid, ins->offset, 1);
+	ret = update_block_group(root, ins->objectid, ins->offset, 1);
 	if (ret) { /* -ENOENT, logic error */
 		printk(KERN_ERR "btrfs update block group failed for %llu "
 		       "%llu\n", (unsigned long long)ins->objectid,
@@ -6165,7 +6163,7 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_free_path(path);
 
-	ret = update_block_group(trans, root, ins->objectid, ins->offset, 1);
+	ret = update_block_group(root, ins->objectid, ins->offset, 1);
 	if (ret) { /* -ENOENT, logic error */
 		printk(KERN_ERR "btrfs update block group failed for %llu "
 		       "%llu\n", (unsigned long long)ins->objectid,
-- 
1.7.7.6

