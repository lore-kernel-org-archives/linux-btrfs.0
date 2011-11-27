Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:45743 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754401Ab1K1Tdb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Nov 2011 14:33:31 -0500
Received: from freie.oliva.athome.lsd.ic.unicamp.br (gw-to-emilia.oliva.athome.lsd.ic.unicamp.br [172.31.160.17] (may be forged))
	by boneca.lsd.ic.unicamp.br (8.14.5/8.14.5) with ESMTP id pASJWiHU020829
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:44 -0200
Received: from livre.localdomain (livre-to-gw.oliva.athome.lsd.ic.unicamp.br [172.31.160.19])
	by freie.oliva.athome.lsd.ic.unicamp.br (8.14.4/8.14.4) with ESMTP id pASJWhqN012450
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:44 -0200
Received: from livre.localdomain (aoliva@localhost.localdomain [127.0.0.1])
	by livre.localdomain (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id pASJWh9H020467
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:43 -0200
Received: (from aoliva@localhost)
	by livre.localdomain (8.14.3/8.14.3/Submit) id pASJWgk0020464
	for linux-btrfs@vger.kernel.org; Mon, 28 Nov 2011 17:32:42 -0200
Message-Id: <cd3320a13052c6cd81186e902707cd93f17b954e.1322507825.git.oliva@lsd.ic.unicamp.br>
In-Reply-To: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
References: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Date: Sun, 27 Nov 2011 20:49:27 -0200
Subject: [PATCH 16/20] Btrfs: try cluster but don't advance in search list
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we find an existing cluster, we switch to its block group as the
current block group, possibly skipping multiple blocks in the process.
Furthermore, under heavy contention, multiple threads may fail to
allocate from a cluster and then release just-created clusters just to
proceed to create new ones in a different block group.

This patch tries to allocate from an existing cluster regardless of its
block group, and doesn't switch to that group, instead proceeding to
try to allocate a cluster from the group it was iterating before the
attempt.

Signed-off-by: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
---
 fs/btrfs/extent-tree.c |   76 +++++++++++++++++++++---------------------------
 1 files changed, 33 insertions(+), 43 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 66edda2..7064979 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5174,11 +5174,11 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 	struct btrfs_root *root = orig_root->fs_info->extent_root;
 	struct btrfs_free_cluster *last_ptr = NULL;
 	struct btrfs_block_group_cache *block_group = NULL;
+	struct btrfs_block_group_cache *used_block_group;
 	int empty_cluster = 2 * 1024 * 1024;
 	int allowed_chunk_alloc = 0;
 	int done_chunk_alloc = 0;
 	struct btrfs_space_info *space_info;
-	int last_ptr_loop = 0;
 	int loop = 0;
 	int index = 0;
 	int alloc_type = (data & BTRFS_BLOCK_GROUP_DATA) ?
@@ -5245,6 +5245,7 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 ideal_cache:
 		block_group = btrfs_lookup_block_group(root->fs_info,
 						       search_start);
+		used_block_group = block_group;
 		if (debug > 1)
 			printk(KERN_DEBUG "btrfs %x.%i: ideal cache block %llx\n",
 			       debugid, loop,
@@ -5286,6 +5287,7 @@ search:
 		u64 offset;
 		int cached;
 
+		used_block_group = block_group;
 		btrfs_get_block_group(block_group);
 		search_start = block_group->key.objectid;
 
@@ -5380,13 +5382,20 @@ alloc:
 			 * people trying to start a new cluster
 			 */
 			spin_lock(&last_ptr->refill_lock);
-			if (!last_ptr->block_group ||
-			    last_ptr->block_group->ro ||
-			    !block_group_bits(last_ptr->block_group, data))
+			used_block_group = last_ptr->block_group;
+			if (used_block_group != block_group &&
+			    (!used_block_group ||
+			     used_block_group->ro ||
+			     !block_group_bits(used_block_group, data))) {
+				used_block_group = block_group;
 				goto refill_cluster;
+			}
+
+			if (used_block_group != block_group)
+				btrfs_get_block_group(used_block_group);
 
-			offset = btrfs_alloc_from_cluster(block_group, last_ptr,
-						 num_bytes, search_start);
+			offset = btrfs_alloc_from_cluster(used_block_group,
+			  last_ptr, num_bytes, used_block_group->key.objectid);
 			if (offset) {
 				/* we have a block, we're done */
 				spin_unlock(&last_ptr->refill_lock);
@@ -5398,36 +5407,15 @@ alloc:
 				printk(KERN_DEBUG "btrfs %x.%i: failed cluster alloc\n",
 				       debugid, loop);
 
-			spin_lock(&last_ptr->lock);
-			/*
-			 * whoops, this cluster doesn't actually point to
-			 * this block group.  Get a ref on the block
-			 * group it does point to and try again
-			 */
-			if (!last_ptr_loop && last_ptr->block_group &&
-			    last_ptr->block_group != block_group &&
-			    index <=
-				 get_block_group_index(last_ptr->block_group)) {
-
-				btrfs_put_block_group(block_group);
-				block_group = last_ptr->block_group;
-				btrfs_get_block_group(block_group);
-				spin_unlock(&last_ptr->lock);
-				spin_unlock(&last_ptr->refill_lock);
-
-				last_ptr_loop = 1;
-				search_start = block_group->key.objectid;
-				/*
-				 * we know this block group is properly
-				 * in the list because
-				 * btrfs_remove_block_group, drops the
-				 * cluster before it removes the block
-				 * group from the list
-				 */
-				goto have_block_group;
+			WARN_ON(last_ptr->block_group != used_block_group);
+			if (used_block_group != block_group) {
+				btrfs_put_block_group(used_block_group);
+				used_block_group = block_group;
 			}
-			spin_unlock(&last_ptr->lock);
+
 refill_cluster:
+			BUG_ON(used_block_group != block_group);
+
 			/* If we are on LOOP_NO_EMPTY_SIZE, we can't
 			 * set up a new clusters, so lets just skip it
 			 * and let the allocator find whatever block
@@ -5451,8 +5439,6 @@ refill_cluster:
 				btrfs_dump_cluster(KERN_DEBUG, debugid, loop, 0, "drop", last_ptr);
 			btrfs_return_cluster_to_free_space(NULL, last_ptr);
 
-			last_ptr_loop = 0;
-
 			/* allocate a cluster in this block group */
 			ret = btrfs_find_space_cluster(trans, root,
 					       block_group, last_ptr,
@@ -5539,26 +5525,26 @@ checks:
 		search_start = stripe_align(root, offset);
 		/* move on to the next group */
 		if (search_start + num_bytes >= search_end) {
-			btrfs_add_free_space(block_group, offset, num_bytes);
+			btrfs_add_free_space(used_block_group, offset, num_bytes);
 			goto loop;
 		}
 
 		/* move on to the next group */
 		if (search_start + num_bytes >
-		    block_group->key.objectid + block_group->key.offset) {
-			btrfs_add_free_space(block_group, offset, num_bytes);
+		    used_block_group->key.objectid + used_block_group->key.offset) {
+			btrfs_add_free_space(used_block_group, offset, num_bytes);
 			goto loop;
 		}
 
 		if (offset < search_start)
-			btrfs_add_free_space(block_group, offset,
+			btrfs_add_free_space(used_block_group, offset,
 					     search_start - offset);
 		BUG_ON(offset > search_start);
 
-		ret = btrfs_update_reserved_bytes(block_group, num_bytes,
+		ret = btrfs_update_reserved_bytes(used_block_group, num_bytes,
 						  alloc_type);
 		if (ret == -EAGAIN) {
-			btrfs_add_free_space(block_group, offset, num_bytes);
+			btrfs_add_free_space(used_block_group, offset, num_bytes);
 			goto loop;
 		}
 
@@ -5567,15 +5553,19 @@ checks:
 		ins->offset = num_bytes;
 
 		if (offset < search_start)
-			btrfs_add_free_space(block_group, offset,
+			btrfs_add_free_space(used_block_group, offset,
 					     search_start - offset);
 		BUG_ON(offset > search_start);
+		if (used_block_group != block_group)
+			btrfs_put_block_group(used_block_group);
 		btrfs_put_block_group(block_group);
 		break;
 loop:
 		failed_cluster_refill = false;
 		failed_alloc = false;
 		BUG_ON(index != get_block_group_index(block_group));
+		if (used_block_group != block_group)
+			btrfs_put_block_group(used_block_group);
 		btrfs_put_block_group(block_group);
 	}
 	up_read(&space_info->groups_sem);
-- 
1.7.4.4

