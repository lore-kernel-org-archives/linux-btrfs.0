Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:33780 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508Ab2ILSEZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Sep 2012 14:04:25 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id h5aFcaHIwsuFGual (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2012 12:04:23 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: remove bytes argument from do_chunk_alloc
Date: Wed, 12 Sep 2012 14:09:49 -0400
Message-ID: <1347473389-3709-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Everybody is just making stuff up, and it's just used to see if we really do
need to alloc a chunk, and since we do this when we already know we really
do it's just a waste of space.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent-tree.c |   25 ++++++++++---------------
 1 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9dc77b2..9c70f63 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -94,8 +94,8 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 				     u64 flags, struct btrfs_disk_key *key,
 				     int level, struct btrfs_key *ins);
 static int do_chunk_alloc(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *extent_root, u64 alloc_bytes,
-			  u64 flags, int force);
+			  struct btrfs_root *extent_root, u64 flags,
+			  int force);
 static int find_next_key(struct btrfs_path *path, int level,
 			 struct btrfs_key *key);
 static void dump_space_info(struct btrfs_space_info *info, u64 bytes,
@@ -3400,7 +3400,6 @@ alloc:
 				return PTR_ERR(trans);
 
 			ret = do_chunk_alloc(trans, root->fs_info->extent_root,
-					     bytes + 2 * 1024 * 1024,
 					     alloc_target,
 					     CHUNK_ALLOC_NO_FORCE);
 			btrfs_end_transaction(trans, root);
@@ -3482,8 +3481,7 @@ static void force_metadata_allocation(struct btrfs_fs_info *info)
 }
 
 static int should_alloc_chunk(struct btrfs_root *root,
-			      struct btrfs_space_info *sinfo, u64 alloc_bytes,
-			      int force)
+			      struct btrfs_space_info *sinfo, int force)
 {
 	struct btrfs_block_rsv *global_rsv = &root->fs_info->global_block_rsv;
 	u64 num_bytes = sinfo->total_bytes - sinfo->bytes_readonly;
@@ -3514,7 +3512,7 @@ static int should_alloc_chunk(struct btrfs_root *root,
 			return 1;
 	}
 
-	if (num_allocated + alloc_bytes < div_factor(num_bytes, 8))
+	if (num_allocated + 2 * 1024 * 1024 < div_factor(num_bytes, 8))
 		return 0;
 	return 1;
 }
@@ -3564,8 +3562,7 @@ static void check_system_chunk(struct btrfs_trans_handle *trans,
 }
 
 static int do_chunk_alloc(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *extent_root, u64 alloc_bytes,
-			  u64 flags, int force)
+			  struct btrfs_root *extent_root, u64 flags, int force)
 {
 	struct btrfs_space_info *space_info;
 	struct btrfs_fs_info *fs_info = extent_root->fs_info;
@@ -3589,7 +3586,7 @@ again:
 		return 0;
 	}
 
-	if (!should_alloc_chunk(extent_root, space_info, alloc_bytes, force)) {
+	if (!should_alloc_chunk(extent_root, space_info, force)) {
 		spin_unlock(&space_info->lock);
 		return 0;
 	} else if (space_info->chunk_alloc) {
@@ -3865,7 +3862,6 @@ static int flush_space(struct btrfs_root *root,
 			break;
 		}
 		ret = do_chunk_alloc(trans, root->fs_info->extent_root,
-				     num_bytes,
 				     btrfs_get_alloc_profile(root, 0),
 				     CHUNK_ALLOC_NO_FORCE);
 		btrfs_end_transaction(trans, root);
@@ -5864,8 +5860,7 @@ loop:
 		index = 0;
 		loop++;
 		if (loop == LOOP_ALLOC_CHUNK) {
-			ret = do_chunk_alloc(trans, root, num_bytes +
-					     2 * 1024 * 1024, data,
+			ret = do_chunk_alloc(trans, root, data,
 					     CHUNK_ALLOC_FORCE);
 			/*
 			 * Do not bail out on ENOSPC since we
@@ -7265,7 +7260,7 @@ int btrfs_set_block_group_ro(struct btrfs_root *root,
 
 	alloc_flags = update_block_group_flags(root, cache->flags);
 	if (alloc_flags != cache->flags) {
-		ret = do_chunk_alloc(trans, root, 2 * 1024 * 1024, alloc_flags,
+		ret = do_chunk_alloc(trans, root, alloc_flags,
 				     CHUNK_ALLOC_FORCE);
 		if (ret < 0)
 			goto out;
@@ -7275,7 +7270,7 @@ int btrfs_set_block_group_ro(struct btrfs_root *root,
 	if (!ret)
 		goto out;
 	alloc_flags = get_alloc_profile(root, cache->space_info->flags);
-	ret = do_chunk_alloc(trans, root, 2 * 1024 * 1024, alloc_flags,
+	ret = do_chunk_alloc(trans, root, alloc_flags,
 			     CHUNK_ALLOC_FORCE);
 	if (ret < 0)
 		goto out;
@@ -7289,7 +7284,7 @@ int btrfs_force_chunk_alloc(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root, u64 type)
 {
 	u64 alloc_flags = get_alloc_profile(root, type);
-	return do_chunk_alloc(trans, root, 2 * 1024 * 1024, alloc_flags,
+	return do_chunk_alloc(trans, root, alloc_flags,
 			      CHUNK_ALLOC_FORCE);
 }
 
-- 
1.7.7.6

