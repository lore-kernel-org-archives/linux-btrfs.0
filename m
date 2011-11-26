Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:45768 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755189Ab1K1Tdu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Nov 2011 14:33:50 -0500
Received: from freie.oliva.athome.lsd.ic.unicamp.br (gw-to-emilia.oliva.athome.lsd.ic.unicamp.br [172.31.160.17] (may be forged))
	by boneca.lsd.ic.unicamp.br (8.14.5/8.14.5) with ESMTP id pASJWbEV020814
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:38 -0200
Received: from livre.localdomain (livre-to-gw.oliva.athome.lsd.ic.unicamp.br [172.31.160.19])
	by freie.oliva.athome.lsd.ic.unicamp.br (8.14.4/8.14.4) with ESMTP id pASJWak3012425
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:37 -0200
Received: from livre.localdomain (aoliva@localhost.localdomain [127.0.0.1])
	by livre.localdomain (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id pASJWaJc020375
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:36 -0200
Received: (from aoliva@localhost)
	by livre.localdomain (8.14.3/8.14.3/Submit) id pASJWZT7020373
	for linux-btrfs@vger.kernel.org; Mon, 28 Nov 2011 17:32:35 -0200
Message-Id: <b66839ad3c4d2d1992e5107cd431b0fd902b35e4.1322507825.git.oliva@lsd.ic.unicamp.br>
In-Reply-To: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
References: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Date: Sat, 26 Nov 2011 19:19:09 -0200
Subject: [PATCH 12/20] Btrfs: introduce verbose debug mode for patched
 clustered allocation recovery
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds several debug messages that helped me track down
problems in the cluster allocation logic.  All the messages are
disabled by default, so that they're optimized away, but enabling the
commented-out settings of debug brings some helpful messages.

Signed-off-by: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
---
 fs/btrfs/extent-tree.c |  148 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 147 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 92e640b..823ab22 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5073,6 +5073,88 @@ enum btrfs_loop_type {
 	LOOP_NO_EMPTY_SIZE = 4,
 };
 
+/* ??? Move to free-space-cache.c? */
+static void
+btrfs_dump_free_space_tree (const char *kern, int debugid, int loop,
+			    int detailed, const char *what, const char *what2,
+			    unsigned long long prev, struct rb_node *node) {
+	struct btrfs_free_space *entry;
+	int entries = 0, frags = 0;
+	unsigned long long size = 0;
+	unsigned long bits = 0, i, p, q;
+
+	if (detailed)
+		printk("%sbtrfs %x.%i: %s %s %llx:\n",
+		       kern, debugid, loop, what, what2, prev);
+
+	while (node) {
+		entries++;
+		entry = rb_entry(node, struct btrfs_free_space, offset_index);
+		node = rb_next(&entry->offset_index);
+
+		size += entry->bytes;
+
+		if (detailed)
+			printk("%sbtrfs %x.%i:  +%llx,%llx%s\n",
+			       kern, debugid, loop,
+			       (long long)(entry->offset - prev),
+			       (unsigned long long)entry->bytes,
+			       entry->bitmap ? (detailed > 1 ? ":" : " bitmap") : "");
+
+		if (!entry->bitmap)
+			continue;
+
+		i = 0;
+#define BITS_PER_BITMAP (PAGE_CACHE_SIZE * 8)
+		do {
+			p = i;
+			i = find_next_bit (entry->bitmap, BITS_PER_BITMAP, i);
+			q = i;
+			i = find_next_zero_bit (entry->bitmap, BITS_PER_BITMAP, i);
+
+			if (i != q)
+				frags++;
+			bits += i - q;
+
+			if (detailed > 1)
+				printk("%sbtrfs %x.%i:   b+%lx,%lx\n",
+				       kern, debugid, loop, q - p, i - q);
+		} while (i < BITS_PER_BITMAP);
+#undef BITS_PER_BITMAP
+	}
+
+	if (detailed)
+		printk("%sbtrfs %x.%i:  entries %x size %llx bits %lx frags %x\n",
+		       kern, debugid, loop, entries, size, bits, frags);
+	else
+		printk("%sbtrfs %x.%i: %s %s %llx: e:%x s:%llx b:%lx f:%x\n",
+		       kern, debugid, loop, what, what2,
+		       prev, entries, size, bits, frags);
+}
+
+static void
+btrfs_dump_cluster (const char *kern, int debugid, int loop, int detailed,
+		    const char *what, struct btrfs_free_cluster *cluster) {
+	spin_lock (&cluster->lock);
+
+	btrfs_dump_free_space_tree (kern, debugid, loop,
+				    detailed, what, "cluster",
+				    cluster->window_start,
+				    rb_first(&cluster->root));
+
+	spin_unlock (&cluster->lock);
+}
+
+static void
+btrfs_dump_block_group_free_space (const char *kern, int debugid, int loop,
+				   int detailed, const char *what,
+				   struct btrfs_block_group_cache *block_group) {
+	btrfs_dump_free_space_tree (kern, debugid, loop,
+				    detailed, what, "block group",
+				    block_group->key.objectid,
+		rb_first(&block_group->free_space_ctl->free_space_offset));
+}
+
 /*
  * walks the btree of allocated extents and find a hole of a given size.
  * The key ins is changed to record the hole:
@@ -5108,6 +5190,9 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 	bool have_caching_bg = false;
 	u64 ideal_cache_percent = 0;
 	u64 ideal_cache_offset = 0;
+	int debug = 0;
+	int debugid = 0;
+	static atomic_t debugcnt;
 
 	WARN_ON(num_bytes < root->sectorsize);
 	btrfs_set_key_type(ins, BTRFS_EXTENT_ITEM_KEY);
@@ -5131,6 +5216,8 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 		allowed_chunk_alloc = 1;
 
 	if (data & BTRFS_BLOCK_GROUP_METADATA && use_cluster) {
+		/* debug = 1; */
+		debugid = atomic_inc_return(&debugcnt);
 		last_ptr = &root->fs_info->meta_alloc_cluster;
 		if (!btrfs_test_opt(root, SSD))
 			empty_cluster = 64 * 1024;
@@ -5158,6 +5245,10 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 ideal_cache:
 		block_group = btrfs_lookup_block_group(root->fs_info,
 						       search_start);
+		if (debug > 1)
+			printk(KERN_DEBUG "btrfs %x.%i: ideal cache block %llx\n",
+			       debugid, loop,
+			       (unsigned long long)block_group->key.objectid);
 		/*
 		 * we don't want to use the block group if it doesn't match our
 		 * allocation bits, or if its not cached.
@@ -5219,6 +5310,11 @@ search:
 
 have_block_group:
 		cached = block_group_cache_done(block_group);
+		if (debug > 1)
+			printk(KERN_DEBUG "btrfs %x.%i: block group %llx c:%i\n",
+			       debugid, loop,
+			       (unsigned long long)search_start,
+			       block_group->cached);
 		if (unlikely(!cached)) {
 			u64 free_percent;
 
@@ -5265,6 +5361,10 @@ alloc:
 		if (cached &&
 		    block_group->free_space_ctl->free_space <
 		    num_bytes + empty_cluster + empty_size) {
+			if (debug > 1 && cached)
+				printk(KERN_DEBUG "btrfs %x.%i: %llx is not enough space\n",
+				       debugid, loop,
+				       (unsigned long long)block_group->free_space_ctl->free_space);
 			spin_unlock(&block_group->free_space_ctl->tree_lock);
 			goto loop;
 		}
@@ -5293,6 +5393,11 @@ alloc:
 				goto checks;
 			}
 
+			/* debug = 2; */
+			if (debug > 1)
+				printk(KERN_DEBUG "btrfs %x.%i: failed cluster alloc\n",
+				       debugid, loop);
+
 			spin_lock(&last_ptr->lock);
 			/*
 			 * whoops, this cluster doesn't actually point to
@@ -5341,6 +5446,9 @@ refill_cluster:
 			 * this cluster didn't work out, free it and
 			 * start over
 			 */
+			/* debug = 2; */
+			if ((debug > 1 || (debug && last_ptr->block_group)) && last_ptr->window_start)
+				btrfs_dump_cluster(KERN_DEBUG, debugid, loop, 0, "drop", last_ptr);
 			btrfs_return_cluster_to_free_space(NULL, last_ptr);
 
 			last_ptr_loop = 0;
@@ -5351,6 +5459,8 @@ refill_cluster:
 					       search_start, num_bytes,
 					       empty_cluster + empty_size);
 			if (ret == 0) {
+				if (debug > 1 || (debug && last_ptr->block_group))
+					btrfs_dump_cluster(KERN_INFO, debugid, loop, 0, "new", last_ptr);
 				/*
 				 * now pull our allocation out of this
 				 * cluster
@@ -5363,15 +5473,23 @@ refill_cluster:
 					spin_unlock(&last_ptr->refill_lock);
 					goto checks;
 				}
+				if (debug)
+					printk(KERN_INFO "btrfs %x.%i: failed new cluster alloc\n",
+					       debugid, loop);
 			} else if (!cached && loop > LOOP_CACHING_NOWAIT
 				   && !failed_cluster_refill) {
 				spin_unlock(&last_ptr->refill_lock);
 
+				if (debug > 1)
+					printk(KERN_DEBUG "btrfs %x.%i: no new cluster, caching\n",
+					       debugid, loop);
+
 				failed_cluster_refill = true;
 				wait_block_group_cache_progress(block_group,
 				       num_bytes + empty_cluster + empty_size);
 				goto have_block_group;
-			}
+			} else if (cached && debug > 1)
+				btrfs_dump_block_group_free_space(KERN_DEBUG, debugid, loop, 1, "no cluster in", block_group);
 
 			/*
 			 * at this point we either didn't find a cluster
@@ -5379,12 +5497,19 @@ refill_cluster:
 			 * cluster.  Free the cluster we've been trying
 			 * to use, and go to the next block group
 			 */
+			if ((debug > 1 || (debug && last_ptr->block_group)) && last_ptr->window_start)
+				btrfs_dump_cluster(KERN_DEBUG, debugid, loop, 0, "xdrop", last_ptr);
 			btrfs_return_cluster_to_free_space(NULL, last_ptr);
 			spin_unlock(&last_ptr->refill_lock);
 			goto loop;
 		}
 
 unclustered_alloc:
+		if (debug > 1 || (debug && last_ptr))
+			printk(KERN_DEBUG "btrfs %x.%i: old alloc %llx+%llx\n",
+			       debugid, loop,
+			       (unsigned long long)num_bytes,
+			       (unsigned long long)empty_size);
 		offset = btrfs_find_space_for_alloc(block_group, search_start,
 						    num_bytes, empty_size);
 		/*
@@ -5398,6 +5523,9 @@ unclustered_alloc:
 		 */
 		if (!offset && !failed_alloc && !cached &&
 		    loop > LOOP_CACHING_NOWAIT) {
+			if (debug > 1)
+				printk(KERN_DEBUG "btrfs %x.%i: failed old alloc, caching\n",
+				       debugid, loop);
 			wait_block_group_cache_progress(block_group,
 						num_bytes + empty_size);
 			failed_alloc = true;
@@ -5517,10 +5645,21 @@ loop:
 				allowed_chunk_alloc = 0;
 				if (ret == 1)
 					done_chunk_alloc = 1;
+				if (debug > 1) {
+					if (done_chunk_alloc)
+						printk(KERN_INFO "btrfs %x.%i: new chunk\n",
+						       debugid, loop);
+					else
+						printk(KERN_INFO "btrfs %x.%i: no new chunk\n",
+						       debugid, loop);
+				}
 			} else if (!done_chunk_alloc &&
 				   space_info->force_alloc ==
 				   CHUNK_ALLOC_NO_FORCE) {
 				space_info->force_alloc = CHUNK_ALLOC_LIMITED;
+				if (debug > 1)
+					printk(KERN_INFO "btrfs %x.%i: get new chunk\n",
+					       debugid, loop);
 			}
 
 		       /*
@@ -5538,8 +5677,15 @@ loop:
 
 		goto search;
 	} else if (!ins->objectid) {
+		if (debug > 1)
+			printk(KERN_DEBUG "btrfs %x.%i: alloc failed\n",
+			       debugid, loop);
 		ret = -ENOSPC;
 	} else if (ins->objectid) {
+		if (debug > 1)
+			printk(KERN_DEBUG "btrfs %x.%i: alloced %llx\n",
+			       debugid, loop, ins->objectid);
+
 		ret = 0;
 	}
 
-- 
1.7.4.4

