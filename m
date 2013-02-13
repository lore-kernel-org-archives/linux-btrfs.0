Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from peace.netnation.com ([204.174.223.2]:40946 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760868Ab3BMVws (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Feb 2013 16:52:48 -0500
Received: from sim by peace.netnation.com with local (Exim 4.80)
	(envelope-from <becf70cc92b0b83660e97e19215de424a36ebdb3@peace.netnation.com>)
	id 1U5jyl-00045e-Hm
	for linux-btrfs@vger.kernel.org; Wed, 13 Feb 2013 13:34:59 -0800
From: Simon Kirby <sim@hostway.ca>
Date: Wed, 13 Feb 2013 15:25:31 -0600
Subject: [PATCH] Btrfs: Include the device in most error printk()s
To: linux-btrfs@vger.kernel.org
Message-Id: <E1U5jyl-00045e-Hm@peace.netnation.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With more than one btrfs volume mounted, it can be very difficult to find
out which volume is hitting an error. btrfs_error() will print this, but
it is currently rigged as more of a fatal error handler, while many of
the printk()s are currently for debugging and yet-unhandled cases.

This may introduce some confusion with volumes backed by multiple devices
emitting errors referring to the primary device in the set instead of the
one on which the error occurred.

This patch just changes the functions where the device information is
already available. Some cases remain where the root or fs_info is not
passed to the function emitting the error.

Signed-off-by: Simon Kirby <sim@hostway.ca>
---
 fs/btrfs/extent-tree.c      |   49 +++++++++++++++++++++++++++----------------
 fs/btrfs/free-space-cache.c |   28 +++++++++++++++----------
 fs/btrfs/inode.c            |   49 ++++++++++++++++++++++++++-----------------
 fs/btrfs/print-tree.c       |    8 ++++---
 fs/btrfs/volumes.c          |    8 ++++---
 5 files changed, 88 insertions(+), 54 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5a3327b..6e9ebbe 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2300,7 +2300,10 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
 					list_del_init(&locked_ref->cluster);
 					mutex_unlock(&locked_ref->mutex);
 
-					printk(KERN_DEBUG "btrfs: run_delayed_extent_op returned %d\n", ret);
+					printk(KERN_DEBUG "btrfs %s: "
+					       "run_delayed_extent_op "
+					       "returned %d\n",
+					       fs_info->sb->s_id, ret);
 					spin_lock(&delayed_refs->lock);
 					return ret;
 				}
@@ -2346,7 +2349,8 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
 				list_del_init(&locked_ref->cluster);
 				mutex_unlock(&locked_ref->mutex);
 			}
-			printk(KERN_DEBUG "btrfs: run_one_delayed_ref returned %d\n", ret);
+			printk(KERN_DEBUG "btrfs %s: run_one_delayed_ref "
+			       "returned %d\n", fs_info->sb->s_id, ret);
 			spin_lock(&delayed_refs->lock);
 			return ret;
 		}
@@ -2410,7 +2414,8 @@ int btrfs_delayed_refs_qgroup_accounting(struct btrfs_trans_handle *trans,
 	if (list_empty(&trans->qgroup_ref_list) !=
 	    !trans->delayed_ref_elem.seq) {
 		/* list without seq or seq without list */
-		printk(KERN_ERR "btrfs: qgroup accounting update error, list is%s empty, seq is %llu\n",
+		printk(KERN_ERR "btrfs %s: qgroup accounting update error, "
+			"list is%s empty, seq is %llu\n", fs_info->sb->s_id,
 			list_empty(&trans->qgroup_ref_list) ? "" : " not",
 			trans->delayed_ref_elem.seq);
 		BUG();
@@ -3543,8 +3548,8 @@ static void check_system_chunk(struct btrfs_trans_handle *trans,
 
 	thresh = get_system_chunk_thresh(root, type);
 	if (left < thresh && btrfs_test_opt(root, ENOSPC_DEBUG)) {
-		printk(KERN_INFO "left=%llu, need=%llu, flags=%llu\n",
-		       left, thresh, type);
+		printk(KERN_INFO "btrfs %s: left=%llu, need=%llu, flags=%llu\n",
+		       root->fs_info->sb->s_id, left, thresh, type);
 		dump_space_info(info, 0, 0);
 	}
 
@@ -5155,8 +5160,9 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 			ret = btrfs_search_slot(trans, extent_root,
 						&key, path, -1, 1);
 			if (ret) {
-				printk(KERN_ERR "umm, got %d back from search"
-				       ", was looking for %llu\n", ret,
+				printk(KERN_ERR "btrfs %s: umm, got %d back "
+				       "from search, was looking for %llu\n",
+				       info->sb->s_id, ret,
 				       (unsigned long long)bytenr);
 				if (ret > 0)
 					btrfs_print_leaf(extent_root,
@@ -5171,8 +5177,9 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 	} else if (ret == -ENOENT) {
 		btrfs_print_leaf(extent_root, path->nodes[0]);
 		WARN_ON(1);
-		printk(KERN_ERR "btrfs unable to find ref byte nr %llu "
+		printk(KERN_ERR "btrfs %s: unable to find ref byte nr %llu "
 		       "parent %llu root %llu  owner %llu offset %llu\n",
+		       info->sb->s_id,
 		       (unsigned long long)bytenr,
 		       (unsigned long long)parent,
 		       (unsigned long long)root_objectid,
@@ -5205,8 +5212,8 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 		ret = btrfs_search_slot(trans, extent_root, &key, path,
 					-1, 1);
 		if (ret) {
-			printk(KERN_ERR "umm, got %d back from search"
-			       ", was looking for %llu\n", ret,
+			printk(KERN_ERR "btrfs %s: umm, got %d back from search"
+			       ", was looking for %llu\n", info->sb->s_id, ret,
 			       (unsigned long long)bytenr);
 			btrfs_print_leaf(extent_root, path->nodes[0]);
 		}
@@ -5576,7 +5583,8 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 
 	space_info = __find_space_info(root->fs_info, data);
 	if (!space_info) {
-		printk(KERN_ERR "No space info for %llu\n", data);
+		printk(KERN_ERR "btrfs %s: No space info for %llu\n",
+			root->fs_info->sb->s_id, data);
 		return -ENOSPC;
 	}
 
@@ -5993,8 +6001,10 @@ again:
 			struct btrfs_space_info *sinfo;
 
 			sinfo = __find_space_info(root->fs_info, data);
-			printk(KERN_ERR "btrfs allocation failed flags %llu, "
-			       "wanted %llu\n", (unsigned long long)data,
+			printk(KERN_ERR "btrfs %s: allocation failed "
+			       "flags %llu, wanted %llu\n",
+			       root->fs_info->sb->s_id,
+			       (unsigned long long)data,
 			       (unsigned long long)num_bytes);
 			if (sinfo)
 				dump_space_info(sinfo, num_bytes, 1);
@@ -6014,7 +6024,8 @@ static int __btrfs_free_reserved_extent(struct btrfs_root *root,
 
 	cache = btrfs_lookup_block_group(root->fs_info, start);
 	if (!cache) {
-		printk(KERN_ERR "Unable to find block group for %llu\n",
+		printk(KERN_ERR "btrfs %s: Unable to find block group "
+		       "for %llu\n", root->fs_info->sb->s_id,
 		       (unsigned long long)start);
 		return -ENOSPC;
 	}
@@ -6110,8 +6121,9 @@ static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 
 	ret = update_block_group(trans, root, ins->objectid, ins->offset, 1);
 	if (ret) { /* -ENOENT, logic error */
-		printk(KERN_ERR "btrfs update block group failed for %llu "
-		       "%llu\n", (unsigned long long)ins->objectid,
+		printk(KERN_ERR "btrfs %s: update block group failed for "
+		       "%llu %llu\n", fs_info->sb->s_id,
+		       (unsigned long long)ins->objectid,
 		       (unsigned long long)ins->offset);
 		BUG();
 	}
@@ -6174,8 +6186,9 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 
 	ret = update_block_group(trans, root, ins->objectid, ins->offset, 1);
 	if (ret) { /* -ENOENT, logic error */
-		printk(KERN_ERR "btrfs update block group failed for %llu "
-		       "%llu\n", (unsigned long long)ins->objectid,
+		printk(KERN_ERR "btrfs %s: update block group failed for "
+		       "%llu %llu\n", fs_info->sb->s_id,
+		       (unsigned long long)ins->objectid,
 		       (unsigned long long)ins->offset);
 		BUG();
 	}
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 0be7a87..ce7c502 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -104,7 +104,8 @@ struct inode *lookup_free_space_inode(struct btrfs_root *root,
 
 	spin_lock(&block_group->lock);
 	if (!((BTRFS_I(inode)->flags & flags) == flags)) {
-		printk(KERN_INFO "Old style space inode found, converting.\n");
+		printk(KERN_INFO "btrfs %s: Old style space inode found, "
+		       "converting.\n", root->fs_info->sb->s_id);
 		BTRFS_I(inode)->flags |= BTRFS_INODE_NODATASUM |
 			BTRFS_INODE_NODATACOW;
 		block_group->disk_cache_state = BTRFS_DC_CLEAR;
@@ -833,8 +834,9 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 
 	if (!matched) {
 		__btrfs_remove_free_space_cache(ctl);
-		printk(KERN_ERR "block group %llu has an wrong amount of free "
-		       "space\n", block_group->key.objectid);
+		printk(KERN_ERR "btrfs %s: block group %llu has wrong amount "
+		       "of free space\n", fs_info->sb->s_id,
+		       block_group->key.objectid);
 		ret = -1;
 	}
 out:
@@ -845,8 +847,9 @@ out:
 		spin_unlock(&block_group->lock);
 		ret = 0;
 
-		printk(KERN_ERR "btrfs: failed to load free space cache "
-		       "for block group %llu\n", block_group->key.objectid);
+		printk(KERN_ERR "btrfs %s: failed to load free space cache "
+		       "for block group %llu\n", fs_info->sb->s_id,
+		       block_group->key.objectid);
 	}
 
 	iput(inode);
@@ -1104,8 +1107,9 @@ int btrfs_write_out_cache(struct btrfs_root *root,
 		spin_unlock(&block_group->lock);
 		ret = 0;
 #ifdef DEBUG
-		printk(KERN_ERR "btrfs: failed to write free space cache "
-		       "for block group %llu\n", block_group->key.objectid);
+		printk(KERN_ERR "btrfs %s: failed to write free space cache "
+		       "for block group %llu\n", root->fs_info->sb->s_id,
+		       block_group->key.objectid);
 #endif
 	}
 
@@ -2891,8 +2895,9 @@ int load_free_ino_cache(struct btrfs_fs_info *fs_info, struct btrfs_root *root)
 	ret = __load_free_space_cache(root, inode, ctl, path, 0);
 
 	if (ret < 0)
-		printk(KERN_ERR "btrfs: failed to load free ino cache for "
-		       "root %llu\n", root->root_key.objectid);
+		printk(KERN_ERR "btrfs %s: failed to load free ino cache for "
+		       "root %llu\n", fs_info->sb->s_id,
+		       root->root_key.objectid);
 out_put:
 	iput(inode);
 out:
@@ -2919,8 +2924,9 @@ int btrfs_write_out_ino_cache(struct btrfs_root *root,
 	if (ret) {
 		btrfs_delalloc_release_metadata(inode, inode->i_size);
 #ifdef DEBUG
-		printk(KERN_ERR "btrfs: failed to write free ino cache "
-		       "for root %llu\n", root->root_key.objectid);
+		printk(KERN_ERR "btrfs %s: failed to write free ino cache "
+		       "for root %llu\n", root->fs_info->sb->s_id,
+		       root->root_key.objectid);
 #endif
 	}
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index cc93b23..88d7c07 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2106,8 +2106,9 @@ good:
 	return 0;
 
 zeroit:
-	printk_ratelimited(KERN_INFO "btrfs csum failed ino %llu off %llu csum %u "
-		       "private %llu\n",
+	printk_ratelimited(KERN_INFO "btrfs %s: csum failed ino %llu "
+		       "off %llu csum %u private %llu\n",
+		       root->fs_info->sb->s_id,
 		       (unsigned long long)btrfs_ino(page->mapping->host),
 		       (unsigned long long)start, csum,
 		       (unsigned long long)private);
@@ -2396,8 +2397,9 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 		 */
 
 		if (found_key.offset == last_objectid) {
-			printk(KERN_ERR "btrfs: Error removing orphan entry, "
-			       "stopping orphan cleanup\n");
+			printk(KERN_ERR "btrfs %s: Error removing orphan "
+			       " entry, stopping orphan cleanup\n",
+			       root->fs_info->sb->s_id);
 			ret = -EINVAL;
 			goto out;
 		}
@@ -2454,8 +2456,8 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 				ret = PTR_ERR(trans);
 				goto out;
 			}
-			printk(KERN_ERR "auto deleting %Lu\n",
-			       found_key.objectid);
+			printk(KERN_ERR "btrfs %s: auto deleting %Lu\n",
+			       root->fs_info->sb->s_id, found_key.objectid);
 			ret = btrfs_del_orphan_item(trans, root,
 						    found_key.objectid);
 			BUG_ON(ret); /* -ENOMEM or corruption (JDM: Recheck) */
@@ -2516,13 +2518,16 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 	}
 
 	if (nr_unlink)
-		printk(KERN_INFO "btrfs: unlinked %d orphans\n", nr_unlink);
+		printk(KERN_INFO "btrfs %s: unlinked %d orphans\n",
+		       root->fs_info->sb->s_id, nr_unlink);
 	if (nr_truncate)
-		printk(KERN_INFO "btrfs: truncated %d orphans\n", nr_truncate);
+		printk(KERN_INFO "btrfs %s: truncated %d orphans\n",
+		       root->fs_info->sb->s_id, nr_truncate);
 
 out:
 	if (ret)
-		printk(KERN_CRIT "btrfs: could not do orphan cleanup %d\n", ret);
+		printk(KERN_CRIT "btrfs %s: could not do orphan cleanup %d\n",
+		       root->fs_info->sb->s_id, ret);
 	btrfs_free_path(path);
 	return ret;
 }
@@ -2863,8 +2868,9 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 	ret = btrfs_del_inode_ref(trans, root, name, name_len, ino,
 				  dir_ino, &index);
 	if (ret) {
-		printk(KERN_INFO "btrfs failed to delete reference to %.*s, "
-		       "inode %llu parent %llu\n", name_len, name,
+		printk(KERN_INFO "btrfs %s: failed to delete reference to "
+		       "%.*s, inode %llu parent %llu\n",
+		       root->fs_info->sb->s_id, name_len, name,
 		       (unsigned long long)ino, (unsigned long long)dir_ino);
 		btrfs_abort_transaction(trans, root, ret);
 		goto err;
@@ -3934,8 +3940,9 @@ void btrfs_evict_inode(struct inode *inode)
 			ret = btrfs_block_rsv_migrate(global_rsv, rsv, min_size);
 
 		if (ret) {
-			printk(KERN_WARNING "Could not get space for a "
-			       "delete, will truncate on mount %d\n", ret);
+			printk(KERN_WARNING "btrfs %s: Could not get space "
+			       "for a delete, will truncate on mount %d\n",
+			       root->fs_info->sb->s_id, ret);
 			btrfs_orphan_del(NULL, inode);
 			btrfs_free_block_rsv(root, rsv);
 			goto no_delete;
@@ -5533,8 +5540,9 @@ not_found_em:
 insert:
 	btrfs_release_path(path);
 	if (em->start > start || extent_map_end(em) <= start) {
-		printk(KERN_ERR "Btrfs: bad extent! em: [%llu %llu] passed "
-		       "[%llu %llu]\n", (unsigned long long)em->start,
+		printk(KERN_ERR "btrfs %s: bad extent! em: [%llu %llu] passed "
+		       "[%llu %llu]\n", root->fs_info->sb->s_id,
+		       (unsigned long long)em->start,
 		       (unsigned long long)em->len,
 		       (unsigned long long)start,
 		       (unsigned long long)len);
@@ -6239,8 +6247,9 @@ static void btrfs_endio_direct_read(struct bio *bio, int err)
 			flush_dcache_page(bvec->bv_page);
 			if (csum != private) {
 failed:
-				printk(KERN_ERR "btrfs csum failed ino %llu off"
-				      " %llu csum %u private %u\n",
+				printk(KERN_ERR "btrfs %s: csum failed ino "
+				      " %llu off  %llu csum %u private %u\n",
+				      root->fs_info->sb->s_id,
 				      (unsigned long long)btrfs_ino(inode),
 				      (unsigned long long)start,
 				      csum, (unsigned)private);
@@ -7186,7 +7195,8 @@ void btrfs_destroy_inode(struct inode *inode)
 
 	if (test_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
 		     &BTRFS_I(inode)->runtime_flags)) {
-		printk(KERN_INFO "BTRFS: inode %llu still on the orphan list\n",
+		printk(KERN_INFO "btrfs %s: inode %llu still on the "
+		       "orphan list\n", root->fs_info->sb->s_id,
 		       (unsigned long long)btrfs_ino(inode));
 		atomic_dec(&root->orphan_inodes);
 	}
@@ -7196,8 +7206,9 @@ void btrfs_destroy_inode(struct inode *inode)
 		if (!ordered)
 			break;
 		else {
-			printk(KERN_ERR "btrfs found ordered "
+			printk(KERN_ERR "btrfs %s: found ordered "
 			       "extent %llu %llu on inode cleanup\n",
+			       root->fs_info->sb->s_id,
 			       (unsigned long long)ordered->file_offset,
 			       (unsigned long long)ordered->len);
 			btrfs_remove_ordered_extent(inode, ordered);
diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index 50d95fd..9d70a0b 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -176,7 +176,8 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 
 	nr = btrfs_header_nritems(l);
 
-	printk(KERN_INFO "leaf %llu total ptrs %d free space %d\n",
+	printk(KERN_INFO "btrfs %s: leaf %llu total ptrs %d free space %d\n",
+		root->fs_info->sb->s_id,
 		(unsigned long long)btrfs_header_bytenr(l), nr,
 		btrfs_leaf_free_space(root, l));
 	for (i = 0 ; i < nr ; i++) {
@@ -318,9 +319,10 @@ void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *c)
 		btrfs_print_leaf(root, c);
 		return;
 	}
-	printk(KERN_INFO "node %llu level %d total ptrs %d free spc %u\n",
+	printk(KERN_INFO "btrfs %s: node %llu level %d total ptrs %d free spc %u\n",
+	       root->fs_info->sb->s_id,
 	       (unsigned long long)btrfs_header_bytenr(c),
-	      level, nr,
+	       level, nr,
 	       (u32)BTRFS_NODEPTRS_PER_BLOCK(root) - nr);
 	for (i = 0; i < nr; i++) {
 		btrfs_node_key_to_cpu(c, &key, i);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5cbb7f4..1b4ef28 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4095,7 +4095,8 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 	read_unlock(&em_tree->lock);
 
 	if (!em) {
-		printk(KERN_CRIT "btrfs: unable to find logical %llu len %llu\n",
+		printk(KERN_CRIT "btrfs %s: unable to find logical %llu "
+		       "len %llu\n", fs_info->sb->s_id,
 		       (unsigned long long)logical,
 		       (unsigned long long)*length);
 		BUG();
@@ -4846,8 +4847,9 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 
 	total_devs = bbio->num_stripes;
 	if (map_length < length) {
-		printk(KERN_CRIT "btrfs: mapping failed logical %llu bio len %llu "
-		       "len %llu\n", (unsigned long long)logical,
+		printk(KERN_CRIT "btrfs %s: mapping failed logical %llu "
+		       "bio len %llu len %llu\n", root->fs_info->sb->s_id,
+		       (unsigned long long)logical,
 		       (unsigned long long)length,
 		       (unsigned long long)map_length);
 		BUG();
-- 
1.7.10.4

