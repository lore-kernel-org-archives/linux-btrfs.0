Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:28910 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbaAOL7i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jan 2014 06:59:38 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s0FBxSMP003391
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Jan 2014 19:59:29 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/5] Btrfs: cleanup the code of used_block_group in find_free_extent()
Date: Wed, 15 Jan 2014 20:00:56 +0800
Message-Id: <1389787258-10865-3-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1389787258-10865-1-git-send-email-miaox@cn.fujitsu.com>
References: <1389787258-10865-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

used_block_group is just used for the space cluster which doesn't
belong to the current block group, the other place needn't use it.
Or the logic of code seems unclear.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 69a79ed..a47efc1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6179,7 +6179,6 @@ static noinline int find_free_extent(struct btrfs_root *orig_root,
 	struct btrfs_root *root = orig_root->fs_info->extent_root;
 	struct btrfs_free_cluster *last_ptr = NULL;
 	struct btrfs_block_group_cache *block_group = NULL;
-	struct btrfs_block_group_cache *used_block_group;
 	u64 search_start = 0;
 	u64 max_extent_size = 0;
 	int empty_cluster = 2 * 1024 * 1024;
@@ -6241,7 +6240,6 @@ static noinline int find_free_extent(struct btrfs_root *orig_root,
 	if (search_start == hint_byte) {
 		block_group = btrfs_lookup_block_group(root->fs_info,
 						       search_start);
-		used_block_group = block_group;
 		/*
 		 * we don't want to use the block group if it doesn't match our
 		 * allocation bits, or if its not cached.
@@ -6278,7 +6276,6 @@ search:
 		u64 offset;
 		int cached;
 
-		used_block_group = block_group;
 		btrfs_get_block_group(block_group);
 		search_start = block_group->key.objectid;
 
@@ -6322,6 +6319,7 @@ have_block_group:
 		 * lets look there
 		 */
 		if (last_ptr) {
+			struct btrfs_block_group_cache *used_block_group;
 			unsigned long aligned_cluster;
 			/*
 			 * the refill lock keeps out other
@@ -6332,10 +6330,8 @@ have_block_group:
 			if (used_block_group != block_group &&
 			    (!used_block_group ||
 			     used_block_group->ro ||
-			     !block_group_bits(used_block_group, flags))) {
-				used_block_group = block_group;
+			     !block_group_bits(used_block_group, flags)))
 				goto refill_cluster;
-			}
 
 			if (used_block_group != block_group)
 				btrfs_get_block_group(used_block_group);
@@ -6350,16 +6346,17 @@ have_block_group:
 				spin_unlock(&last_ptr->refill_lock);
 				trace_btrfs_reserve_extent_cluster(root,
 					block_group, search_start, num_bytes);
+				if (used_block_group != block_group) {
+					btrfs_put_block_group(block_group);
+					block_group = used_block_group;
+				}
 				goto checks;
 			}
 
 			WARN_ON(last_ptr->block_group != used_block_group);
-			if (used_block_group != block_group) {
+			if (used_block_group != block_group)
 				btrfs_put_block_group(used_block_group);
-				used_block_group = block_group;
-			}
 refill_cluster:
-			BUG_ON(used_block_group != block_group);
 			/* If we are on LOOP_NO_EMPTY_SIZE, we can't
 			 * set up a new clusters, so lets just skip it
 			 * and let the allocator find whatever block
@@ -6478,25 +6475,25 @@ unclustered_alloc:
 			goto loop;
 		}
 checks:
-		search_start = stripe_align(root, used_block_group,
+		search_start = stripe_align(root, block_group,
 					    offset, num_bytes);
 
 		/* move on to the next group */
 		if (search_start + num_bytes >
-		    used_block_group->key.objectid + used_block_group->key.offset) {
-			btrfs_add_free_space(used_block_group, offset, num_bytes);
+		    block_group->key.objectid + block_group->key.offset) {
+			btrfs_add_free_space(block_group, offset, num_bytes);
 			goto loop;
 		}
 
 		if (offset < search_start)
-			btrfs_add_free_space(used_block_group, offset,
+			btrfs_add_free_space(block_group, offset,
 					     search_start - offset);
 		BUG_ON(offset > search_start);
 
-		ret = btrfs_update_reserved_bytes(used_block_group, num_bytes,
+		ret = btrfs_update_reserved_bytes(block_group, num_bytes,
 						  alloc_type);
 		if (ret == -EAGAIN) {
-			btrfs_add_free_space(used_block_group, offset, num_bytes);
+			btrfs_add_free_space(block_group, offset, num_bytes);
 			goto loop;
 		}
 
@@ -6506,16 +6503,12 @@ checks:
 
 		trace_btrfs_reserve_extent(orig_root, block_group,
 					   search_start, num_bytes);
-		if (used_block_group != block_group)
-			btrfs_put_block_group(used_block_group);
 		btrfs_put_block_group(block_group);
 		break;
 loop:
 		failed_cluster_refill = false;
 		failed_alloc = false;
 		BUG_ON(index != get_block_group_index(block_group));
-		if (used_block_group != block_group)
-			btrfs_put_block_group(used_block_group);
 		btrfs_put_block_group(block_group);
 	}
 	up_read(&space_info->groups_sem);
-- 
1.8.3.1

