Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27038 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020Ab2LMByh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Dec 2012 20:54:37 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Jim Schutt <jaschut@sandia.gov>
Subject: [PATCH] Btrfs: fix a deadlock on chunk mutex
Date: Thu, 13 Dec 2012 09:52:37 +0800
Message-Id: <1355363557-2962-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

An user reported that he has hit an annoying deadlock while playing with
ceph based on btrfs.

Current updating device tree requires space from METADATA chunk,
so we -may- need to do a recursive chunk allocation when adding/updating
dev extent, that is where the deadlock comes from.

If we use SYSTEM metadata to update device tree, we can avoid the recursive
stuff.

Reported-by: Jim Schutt <jaschut@sandia.gov>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent-tree.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3d3e2c1..561dad5 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3346,7 +3346,8 @@ u64 btrfs_get_alloc_profile(struct btrfs_root *root, int data)
 
 	if (data)
 		flags = BTRFS_BLOCK_GROUP_DATA;
-	else if (root == root->fs_info->chunk_root)
+	else if (root == root->fs_info->chunk_root ||
+		 root == root->fs_info->dev_root)
 		flags = BTRFS_BLOCK_GROUP_SYSTEM;
 	else
 		flags = BTRFS_BLOCK_GROUP_METADATA;
@@ -3534,7 +3535,8 @@ static u64 get_system_chunk_thresh(struct btrfs_root *root, u64 type)
 	else
 		num_dev = 1;	/* DUP or single */
 
-	/* metadata for updaing devices and chunk tree */
+	/* metadata for adding/updating devices and chunk tree */
+	num_dev = num_dev << 1
 	return btrfs_calc_trans_metadata_size(root, num_dev + 1);
 }
 
@@ -4351,7 +4353,7 @@ static void init_global_block_rsv(struct btrfs_fs_info *fs_info)
 
 	fs_info->extent_root->block_rsv = &fs_info->global_block_rsv;
 	fs_info->csum_root->block_rsv = &fs_info->global_block_rsv;
-	fs_info->dev_root->block_rsv = &fs_info->global_block_rsv;
+	fs_info->dev_root->block_rsv = &fs_info->chunk_block_rsv;
 	fs_info->tree_root->block_rsv = &fs_info->global_block_rsv;
 	fs_info->chunk_root->block_rsv = &fs_info->chunk_block_rsv;
 
-- 
1.7.7.6

