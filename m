Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46196 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449Ab3D2Njm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Apr 2013 09:39:42 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id B756BA5623
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Apr 2013 15:39:41 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: fix misleading variable name for flags
Date: Mon, 29 Apr 2013 15:39:40 +0200
Message-Id: <1367242780-8946-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The variable was named 'data' in btrfs_reserve_extent and that's the
only function that actually uses it to let btrfs_get_alloc_profile know
what profile we want. Then it's passed down as u64 flags.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ctree.h       |    2 +-
 fs/btrfs/extent-tree.c |   37 +++++++++++++++++++------------------
 2 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 66d9f4d..dd202d3 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3068,7 +3068,7 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 				  struct btrfs_root *root,
 				  u64 num_bytes, u64 min_alloc_size,
 				  u64 empty_size, u64 hint_byte,
-				  struct btrfs_key *ins, u64 data);
+				  struct btrfs_key *ins, int is_data);
 int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		  struct extent_buffer *buf, int full_backref, int for_cow);
 int btrfs_dec_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8464d36..5141ec1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5888,7 +5888,7 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 				     struct btrfs_root *orig_root,
 				     u64 num_bytes, u64 empty_size,
 				     u64 hint_byte, struct btrfs_key *ins,
-				     u64 data)
+				     u64 flags)
 {
 	int ret = 0;
 	struct btrfs_root *root = orig_root->fs_info->extent_root;
@@ -5899,8 +5899,8 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 	int empty_cluster = 2 * 1024 * 1024;
 	struct btrfs_space_info *space_info;
 	int loop = 0;
-	int index = __get_raid_index(data);
-	int alloc_type = (data & BTRFS_BLOCK_GROUP_DATA) ?
+	int index = __get_raid_index(flags);
+	int alloc_type = (flags & BTRFS_BLOCK_GROUP_DATA) ?
 		RESERVE_ALLOC_NO_ACCOUNT : RESERVE_ALLOC;
 	bool found_uncached_bg = false;
 	bool failed_cluster_refill = false;
@@ -5913,11 +5913,11 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 	ins->objectid = 0;
 	ins->offset = 0;
 
-	trace_find_free_extent(orig_root, num_bytes, empty_size, data);
+	trace_find_free_extent(orig_root, num_bytes, empty_size, flags);
 
-	space_info = __find_space_info(root->fs_info, data);
+	space_info = __find_space_info(root->fs_info, flags);
 	if (!space_info) {
-		btrfs_err(root->fs_info, "No space info for %llu", data);
+		btrfs_err(root->fs_info, "No space info for %llu", flags);
 		return -ENOSPC;
 	}
 
@@ -5928,13 +5928,13 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 	if (btrfs_mixed_space_info(space_info))
 		use_cluster = false;
 
-	if (data & BTRFS_BLOCK_GROUP_METADATA && use_cluster) {
+	if (flags & BTRFS_BLOCK_GROUP_METADATA && use_cluster) {
 		last_ptr = &root->fs_info->meta_alloc_cluster;
 		if (!btrfs_test_opt(root, SSD))
 			empty_cluster = 64 * 1024;
 	}
 
-	if ((data & BTRFS_BLOCK_GROUP_DATA) && use_cluster &&
+	if ((flags & BTRFS_BLOCK_GROUP_DATA) && use_cluster &&
 	    btrfs_test_opt(root, SSD)) {
 		last_ptr = &root->fs_info->data_alloc_cluster;
 	}
@@ -5963,7 +5963,7 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 		 * However if we are re-searching with an ideal block group
 		 * picked out then we don't care that the block group is cached.
 		 */
-		if (block_group && block_group_bits(block_group, data) &&
+		if (block_group && block_group_bits(block_group, flags) &&
 		    block_group->cached != BTRFS_CACHE_NO) {
 			down_read(&space_info->groups_sem);
 			if (list_empty(&block_group->list) ||
@@ -6001,7 +6001,7 @@ search:
 		 * raid types, but we want to make sure we only allocate
 		 * for the proper type.
 		 */
-		if (!block_group_bits(block_group, data)) {
+		if (!block_group_bits(block_group, flags)) {
 		    u64 extra = BTRFS_BLOCK_GROUP_DUP |
 				BTRFS_BLOCK_GROUP_RAID1 |
 				BTRFS_BLOCK_GROUP_RAID5 |
@@ -6013,7 +6013,7 @@ search:
 			 * doesn't provide them, bail.  This does allow us to
 			 * fill raid0 from raid1.
 			 */
-			if ((data & extra) && !(block_group->flags & extra))
+			if ((flags & extra) && !(block_group->flags & extra))
 				goto loop;
 		}
 
@@ -6044,7 +6044,7 @@ have_block_group:
 			if (used_block_group != block_group &&
 			    (!used_block_group ||
 			     used_block_group->ro ||
-			     !block_group_bits(used_block_group, data))) {
+			     !block_group_bits(used_block_group, flags))) {
 				used_block_group = block_group;
 				goto refill_cluster;
 			}
@@ -6240,7 +6240,7 @@ loop:
 		index = 0;
 		loop++;
 		if (loop == LOOP_ALLOC_CHUNK) {
-			ret = do_chunk_alloc(trans, root, data,
+			ret = do_chunk_alloc(trans, root, flags,
 					     CHUNK_ALLOC_FORCE);
 			/*
 			 * Do not bail out on ENOSPC since we
@@ -6318,16 +6318,17 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root,
 			 u64 num_bytes, u64 min_alloc_size,
 			 u64 empty_size, u64 hint_byte,
-			 struct btrfs_key *ins, u64 data)
+			 struct btrfs_key *ins, int is_data)
 {
 	bool final_tried = false;
+	u64 flags;
 	int ret;
 
-	data = btrfs_get_alloc_profile(root, data);
+	flags = btrfs_get_alloc_profile(root, is_data);
 again:
 	WARN_ON(num_bytes < root->sectorsize);
 	ret = find_free_extent(trans, root, num_bytes, empty_size,
-			       hint_byte, ins, data);
+			       hint_byte, ins, flags);
 
 	if (ret == -ENOSPC) {
 		if (!final_tried) {
@@ -6340,9 +6341,9 @@ again:
 		} else if (btrfs_test_opt(root, ENOSPC_DEBUG)) {
 			struct btrfs_space_info *sinfo;
 
-			sinfo = __find_space_info(root->fs_info, data);
+			sinfo = __find_space_info(root->fs_info, flags);
 			btrfs_err(root->fs_info, "allocation failed flags %llu, wanted %llu",
-				(unsigned long long)data,
+				(unsigned long long)flags,
 				(unsigned long long)num_bytes);
 			if (sinfo)
 				dump_space_info(sinfo, num_bytes, 1);
-- 
1.7.9

