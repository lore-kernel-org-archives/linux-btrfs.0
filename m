Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46077 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932097AbdERDjO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 23:39:14 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 15/32] btrfs-progs: Refactor block sizes users in extent-tree.c
Date: Thu, 18 May 2017 11:38:40 +0800
Message-ID: <20170518033857.15002-16-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
References: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

And in the refactoring, also refactors a open-coded round_up().

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 extent-tree.c | 38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff --git a/extent-tree.c b/extent-tree.c
index b12ee290..43fa3b5f 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -152,7 +152,7 @@ static int cache_block_group(struct btrfs_root *root,
 						 last + hole_size - 1);
 			}
 			if (key.type == BTRFS_METADATA_ITEM_KEY)
-				last = key.objectid + root->nodesize;
+				last = key.objectid + root->fs_info->nodesize;
 			else
 				last = key.objectid + key.offset;
 		}
@@ -1452,7 +1452,7 @@ int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 
 	if (metadata &&
 	    !btrfs_fs_incompat(root->fs_info, SKINNY_METADATA)) {
-		offset = root->nodesize;
+		offset = root->fs_info->nodesize;
 		metadata = 0;
 	}
 
@@ -1487,14 +1487,14 @@ again:
 					      path->slots[0]);
 			if (key.objectid == bytenr &&
 			    key.type == BTRFS_EXTENT_ITEM_KEY &&
-			    key.offset == root->nodesize)
+			    key.offset == root->fs_info->nodesize)
 				ret = 0;
 		}
 
 		if (ret) {
 			btrfs_release_path(path);
 			key.type = BTRFS_EXTENT_ITEM_KEY;
-			key.offset = root->nodesize;
+			key.offset = root->fs_info->nodesize;
 			metadata = 0;
 			goto again;
 		}
@@ -1558,7 +1558,7 @@ int btrfs_set_block_flags(struct btrfs_trans_handle *trans,
 		key.offset = level;
 		key.type = BTRFS_METADATA_ITEM_KEY;
 	} else {
-		key.offset = root->nodesize;
+		key.offset = root->fs_info->nodesize;
 		key.type = BTRFS_EXTENT_ITEM_KEY;
 	}
 
@@ -1575,13 +1575,13 @@ again:
 			btrfs_item_key_to_cpu(path->nodes[0], &key,
 					      path->slots[0]);
 			if (key.objectid == bytenr &&
-			    key.offset == root->nodesize &&
+			    key.offset == root->fs_info->nodesize &&
 			    key.type == BTRFS_EXTENT_ITEM_KEY)
 				ret = 0;
 		}
 		if (ret) {
 			btrfs_release_path(path);
-			key.offset = root->nodesize;
+			key.offset = root->fs_info->nodesize;
 			key.type = BTRFS_EXTENT_ITEM_KEY;
 			goto again;
 		}
@@ -1679,7 +1679,7 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 			}
 		} else {
 			bytenr = btrfs_node_blockptr(buf, i);
-			num_bytes = root->nodesize;
+			num_bytes = root->fs_info->nodesize;
 			ret = process_func(trans, root, bytenr, num_bytes,
 					   parent, ref_root, level - 1, 0);
 			if (ret) {
@@ -2001,7 +2001,7 @@ static int update_pinned_extents(struct btrfs_root *root,
 	while (num > 0) {
 		cache = btrfs_lookup_block_group(fs_info, bytenr);
 		if (!cache) {
-			len = min((u64)root->sectorsize, num);
+			len = min((u64)fs_info->sectorsize, num);
 			goto next;
 		}
 		WARN_ON(!cache);
@@ -2479,7 +2479,7 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 	int pending_ret;
 	int ret;
 
-	WARN_ON(num_bytes < root->sectorsize);
+	WARN_ON(num_bytes < root->fs_info->sectorsize);
 	if (root == extent_root) {
 		struct pending_extent_op *extent_op;
 
@@ -2506,9 +2506,7 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 
 static u64 stripe_align(struct btrfs_root *root, u64 val)
 {
-	u64 mask = ((u64)root->stripesize - 1);
-	u64 ret = (val + mask) & ~mask;
-	return ret;
+	return round_up(val, (u64)root->fs_info->stripesize);
 }
 
 /*
@@ -2536,7 +2534,7 @@ static int noinline find_free_extent(struct btrfs_trans_handle *trans,
 	int full_scan = 0;
 	int wrapped = 0;
 
-	WARN_ON(num_bytes < root->sectorsize);
+	WARN_ON(num_bytes < info->sectorsize);
 	ins->type = BTRFS_EXTENT_ITEM_KEY;
 
 	search_start = stripe_align(root, search_start);
@@ -2688,7 +2686,7 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 		BUG_ON(ret);
 	}
 
-	WARN_ON(num_bytes < root->sectorsize);
+	WARN_ON(num_bytes < info->sectorsize);
 	ret = find_free_extent(trans, root, num_bytes, empty_size,
 			       search_start, search_end, hint_byte, ins,
 			       trans->alloc_exclude_start,
@@ -2749,7 +2747,7 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_free_path(path);
 
-	ret = update_block_group(trans, root, ins->objectid, root->nodesize,
+	ret = update_block_group(trans, root, ins->objectid, fs_info->nodesize,
 				 1, 0);
 	return ret;
 }
@@ -3405,7 +3403,7 @@ int btrfs_make_block_groups(struct btrfs_trans_handle *trans,
 	block_group_cache = &root->fs_info->block_group_cache;
 	chunk_objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
 	total_bytes = btrfs_super_total_bytes(root->fs_info->super_copy);
-	group_align = 64 * root->sectorsize;
+	group_align = 64 * root->fs_info->sectorsize;
 
 	cur_start = 0;
 	while (cur_start < total_bytes) {
@@ -3907,9 +3905,9 @@ int btrfs_fix_block_accounting(struct btrfs_trans_handle *trans,
 				  key.objectid, key.offset, 1, 0);
 			BUG_ON(ret);
 		} else if (key.type == BTRFS_METADATA_ITEM_KEY) {
-			bytes_used += root->nodesize;
+			bytes_used += fs_info->nodesize;
 			ret = btrfs_update_block_group(trans, root,
-				  key.objectid, root->nodesize, 1, 0);
+				  key.objectid, fs_info->nodesize, 1, 0);
 			BUG_ON(ret);
 		}
 		path.slots[0]++;
@@ -3931,7 +3929,7 @@ static void __get_extent_size(struct btrfs_root *root, struct btrfs_path *path,
 	if (key.type == BTRFS_EXTENT_ITEM_KEY)
 		*len = key.offset;
 	else
-		*len = root->nodesize;
+		*len = root->fs_info->nodesize;
 }
 
 /*
-- 
2.13.0



