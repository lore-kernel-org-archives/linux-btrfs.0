Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5902 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755796AbbBIUDz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Feb 2015 15:03:55 -0500
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 11/16] Btrfs-progs: remove global transaction from fsck
Date: Mon, 9 Feb 2015 15:03:14 -0500
Message-ID: <1423512199-16552-12-git-send-email-jbacik@fb.com>
In-Reply-To: <1423512199-16552-1-git-send-email-jbacik@fb.com>
References: <1423512199-16552-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We hold a transaction open for the entirety of fixing extent refs.  This works
out ok most of the time but we can be tight on space and run out of space when
fixing things.  To get around this just push down the transaction starting dance
into the functions that actually fix things.  This keeps us from ending up with
ENOSPC because we pinned everything and allows the code to be a bit simpler.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 cmds-check.c  | 230 +++++++++++++++++++++++++++++++++-------------------------
 ctree.h       |   1 +
 disk-io.c     |   2 +
 extent-tree.c |   7 ++
 4 files changed, 140 insertions(+), 100 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index ffdfbf2..5458c28 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -3668,7 +3668,6 @@ static void free_extent_record_cache(struct btrfs_fs_info *fs_info,
 		if (!cache)
 			break;
 		rec = container_of(cache, struct extent_record, cache);
-		btrfs_unpin_extent(fs_info, rec->start, rec->max_size);
 		remove_cache_extent(extent_cache, cache);
 		free_all_extent_backrefs(rec);
 		free(rec);
@@ -3995,11 +3994,11 @@ again:
  * Attempt to fix basic block failures.  If we can't fix it for whatever reason
  * then just return -EIO.
  */
-static int try_to_fix_bad_block(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root,
+static int try_to_fix_bad_block(struct btrfs_root *root,
 				struct extent_buffer *buf,
 				enum btrfs_tree_block_status status)
 {
+	struct btrfs_trans_handle *trans;
 	struct ulist *roots;
 	struct ulist_node *node;
 	struct btrfs_root *search_root;
@@ -4016,7 +4015,7 @@ static int try_to_fix_bad_block(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -EIO;
 
-	ret = btrfs_find_all_roots(trans, root->fs_info, buf->start,
+	ret = btrfs_find_all_roots(NULL, root->fs_info, buf->start,
 				   0, &roots);
 	if (ret) {
 		btrfs_free_path(path);
@@ -4035,7 +4034,12 @@ static int try_to_fix_bad_block(struct btrfs_trans_handle *trans,
 			break;
 		}
 
-		record_root_in_trans(trans, search_root);
+
+		trans = btrfs_start_transaction(search_root, 0);
+		if (IS_ERR(trans)) {
+			ret = PTR_ERR(trans);
+			break;
+		}
 
 		path->lowest_level = btrfs_header_level(buf);
 		path->skip_check_block = 1;
@@ -4046,23 +4050,26 @@ static int try_to_fix_bad_block(struct btrfs_trans_handle *trans,
 		ret = btrfs_search_slot(trans, search_root, &key, path, 0, 1);
 		if (ret) {
 			ret = -EIO;
+			btrfs_commit_transaction(trans, search_root);
 			break;
 		}
 		if (status == BTRFS_TREE_BLOCK_BAD_KEY_ORDER)
 			ret = fix_key_order(trans, search_root, path);
 		else if (status == BTRFS_TREE_BLOCK_INVALID_OFFSETS)
 			ret = fix_item_offset(trans, search_root, path);
-		if (ret)
+		if (ret) {
+			btrfs_commit_transaction(trans, search_root);
 			break;
+		}
 		btrfs_release_path(path);
+		btrfs_commit_transaction(trans, search_root);
 	}
 	ulist_free(roots);
 	btrfs_free_path(path);
 	return ret;
 }
 
-static int check_block(struct btrfs_trans_handle *trans,
-		       struct btrfs_root *root,
+static int check_block(struct btrfs_root *root,
 		       struct cache_tree *extent_cache,
 		       struct extent_buffer *buf, u64 flags)
 {
@@ -4098,8 +4105,7 @@ static int check_block(struct btrfs_trans_handle *trans,
 
 	if (status != BTRFS_TREE_BLOCK_CLEAN) {
 		if (repair)
-			status = try_to_fix_bad_block(trans, root, buf,
-						      status);
+			status = try_to_fix_bad_block(root, buf, status);
 		if (status != BTRFS_TREE_BLOCK_CLEAN) {
 			ret = -EIO;
 			fprintf(stderr, "bad block %llu\n",
@@ -5678,8 +5684,7 @@ full_backref:
 	return 0;
 }
 
-static int run_next_block(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *root,
+static int run_next_block(struct btrfs_root *root,
 			  struct block_info *bits,
 			  int bits_nr,
 			  u64 *last,
@@ -5797,7 +5802,7 @@ static int run_next_block(struct btrfs_trans_handle *trans,
 		owner = btrfs_header_owner(buf);
 	}
 
-	ret = check_block(trans, root, extent_cache, buf, flags);
+	ret = check_block(root, extent_cache, buf, flags);
 	if (ret)
 		goto out;
 
@@ -6349,16 +6354,16 @@ static struct extent_entry *find_most_right_entry(struct list_head *entries)
 	return best;
 }
 
-static int repair_ref(struct btrfs_trans_handle *trans,
-		      struct btrfs_fs_info *info, struct btrfs_path *path,
+static int repair_ref(struct btrfs_fs_info *info, struct btrfs_path *path,
 		      struct data_backref *dback, struct extent_entry *entry)
 {
+	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root;
 	struct btrfs_file_extent_item *fi;
 	struct extent_buffer *leaf;
 	struct btrfs_key key;
 	u64 bytenr, bytes;
-	int ret;
+	int ret, err;
 
 	key.objectid = dback->root;
 	key.type = BTRFS_ROOT_ITEM_KEY;
@@ -6410,11 +6415,9 @@ static int repair_ref(struct btrfs_trans_handle *trans,
 
 	btrfs_release_path(path);
 
-	/*
-	 * Have to make sure that this root gets updated when we commit the
-	 * transaction
-	 */
-	record_root_in_trans(trans, root);
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 
 	/*
 	 * Ok we have the key of the file extent we want to fix, now we can cow
@@ -6424,13 +6427,14 @@ static int repair_ref(struct btrfs_trans_handle *trans,
 	if (ret < 0) {
 		fprintf(stderr, "Error cowing down to ref [%Lu, %u, %Lu]: %d\n",
 			key.objectid, key.type, key.offset, ret);
-		return ret;
+		goto out;
 	}
 	if (ret > 0) {
 		fprintf(stderr, "Well that's odd, we just found this key "
 			"[%Lu, %u, %Lu]\n", key.objectid, key.type,
 			key.offset);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 	leaf = path->nodes[0];
 	fi = btrfs_item_ptr(leaf, path->slots[0],
@@ -6443,7 +6447,8 @@ static int repair_ref(struct btrfs_trans_handle *trans,
 			"system and send it to a btrfs developer so they can "
 			"complete this functionality for bytenr %Lu\n",
 			dback->disk_bytenr);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	if (dback->node.broken && dback->disk_bytenr != entry->bytenr) {
@@ -6460,7 +6465,8 @@ static int repair_ref(struct btrfs_trans_handle *trans,
 				"take a btrfs-image of this file system and "
 				"send it to a btrfs developer, ref %Lu\n",
 				dback->disk_bytenr);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out;
 		}
 		offset += off_diff;
 		btrfs_set_file_extent_disk_bytenr(leaf, fi, entry->bytenr);
@@ -6474,7 +6480,8 @@ static int repair_ref(struct btrfs_trans_handle *trans,
 				" take a btrfs-image of this file system and "
 				"send it to a btrfs developer, ref %Lu\n",
 				dback->disk_bytenr);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out;
 		}
 
 		offset += dback->disk_bytenr;
@@ -6495,12 +6502,13 @@ static int repair_ref(struct btrfs_trans_handle *trans,
 	else
 		printf("ram bytes may be wrong?\n");
 	btrfs_mark_buffer_dirty(leaf);
+out:
+	err = btrfs_commit_transaction(trans, root);
 	btrfs_release_path(path);
-	return 0;
+	return ret ? ret : err;
 }
 
-static int verify_backrefs(struct btrfs_trans_handle *trans,
-			   struct btrfs_fs_info *info, struct btrfs_path *path,
+static int verify_backrefs(struct btrfs_fs_info *info, struct btrfs_path *path,
 			   struct extent_record *rec)
 {
 	struct extent_backref *back;
@@ -6662,7 +6670,7 @@ static int verify_backrefs(struct btrfs_trans_handle *trans,
 		    dback->disk_bytenr == best->bytenr)
 			continue;
 
-		ret = repair_ref(trans, info, path, dback, best);
+		ret = repair_ref(info, path, dback, best);
 		if (ret)
 			goto out;
 	}
@@ -6763,15 +6771,15 @@ static int process_duplicates(struct btrfs_root *root,
 	return good->num_duplicates ? 0 : 1;
 }
 
-static int delete_duplicate_records(struct btrfs_trans_handle *trans,
-				    struct btrfs_root *root,
+static int delete_duplicate_records(struct btrfs_root *root,
 				    struct extent_record *rec)
 {
+	struct btrfs_trans_handle *trans;
 	LIST_HEAD(delete_list);
 	struct btrfs_path *path;
 	struct extent_record *tmp, *good, *n;
 	int nr_del = 0;
-	int ret = 0;
+	int ret = 0, err;
 	struct btrfs_key key;
 
 	path = btrfs_alloc_path();
@@ -6809,6 +6817,12 @@ static int delete_duplicate_records(struct btrfs_trans_handle *trans,
 	}
 
 	root = root->fs_info->extent_root;
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out;
+	}
+
 	list_for_each_entry(tmp, &delete_list, list) {
 		if (tmp->found_rec == 0)
 			continue;
@@ -6828,15 +6842,17 @@ static int delete_duplicate_records(struct btrfs_trans_handle *trans,
 		if (ret) {
 			if (ret > 0)
 				ret = -EINVAL;
-			goto out;
+			break;
 		}
 		ret = btrfs_del_item(trans, root, path);
 		if (ret)
-			goto out;
+			break;
 		btrfs_release_path(path);
 		nr_del++;
 	}
-
+	err = btrfs_commit_transaction(trans, root);
+	if (err && !ret)
+		ret = err;
 out:
 	while (!list_empty(&delete_list)) {
 		tmp = list_entry(delete_list.next, struct extent_record, list);
@@ -6860,8 +6876,7 @@ out:
 	return ret ? ret : nr_del;
 }
 
-static int find_possible_backrefs(struct btrfs_trans_handle *trans,
-				  struct btrfs_fs_info *info,
+static int find_possible_backrefs(struct btrfs_fs_info *info,
 				  struct btrfs_path *path,
 				  struct cache_tree *extent_cache,
 				  struct extent_record *rec)
@@ -7035,11 +7050,11 @@ out:
  * all of the existing entries for it and recreate them
  * based on what the tree scan found.
  */
-static int fixup_extent_refs(struct btrfs_trans_handle *trans,
-			     struct btrfs_fs_info *info,
+static int fixup_extent_refs(struct btrfs_fs_info *info,
 			     struct cache_tree *extent_cache,
 			     struct extent_record *rec)
 {
+	struct btrfs_trans_handle *trans = NULL;
 	int ret;
 	struct btrfs_path *path;
 	struct list_head *cur = rec->backrefs.next;
@@ -7063,17 +7078,22 @@ static int fixup_extent_refs(struct btrfs_trans_handle *trans,
 		 * them into the list if we find the backref so that
 		 * verify_backrefs can figure out what to do.
 		 */
-		ret = find_possible_backrefs(trans, info, path, extent_cache,
-					     rec);
+		ret = find_possible_backrefs(info, path, extent_cache, rec);
 		if (ret < 0)
 			goto out;
 	}
 
 	/* step one, make sure all of the backrefs agree */
-	ret = verify_backrefs(trans, info, path, rec);
+	ret = verify_backrefs(info, path, rec);
 	if (ret < 0)
 		goto out;
 
+	trans = btrfs_start_transaction(info->extent_root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out;
+	}
+
 	/* step two, delete all the existing records */
 	ret = delete_extent_records(trans, info->extent_root, path,
 				    rec->start, rec->max_size);
@@ -7108,6 +7128,12 @@ static int fixup_extent_refs(struct btrfs_trans_handle *trans,
 			goto out;
 	}
 out:
+	if (trans) {
+		int err = btrfs_commit_transaction(trans, info->extent_root);
+		if (!ret)
+			ret = err;
+	}
+
 	btrfs_free_path(path);
 	return ret;
 }
@@ -7181,20 +7207,27 @@ out:
 	return ret;
 }
 
-static int prune_corrupt_blocks(struct btrfs_trans_handle *trans,
-				struct btrfs_fs_info *info)
+static int prune_corrupt_blocks(struct btrfs_fs_info *info)
 {
+	struct btrfs_trans_handle *trans = NULL;
 	struct cache_extent *cache;
 	struct btrfs_corrupt_block *corrupt;
 
-	cache = search_cache_extent(info->corrupt_blocks, 0);
 	while (1) {
+		cache = search_cache_extent(info->corrupt_blocks, 0);
 		if (!cache)
 			break;
+		if (!trans) {
+			trans = btrfs_start_transaction(info->extent_root, 1);
+			if (IS_ERR(trans))
+				return PTR_ERR(trans);
+		}
 		corrupt = container_of(cache, struct btrfs_corrupt_block, cache);
 		prune_one_block(trans, info, corrupt);
-		cache = next_cache_extent(cache);
+		remove_cache_extent(info->corrupt_blocks, cache);
 	}
+	if (trans)
+		return btrfs_commit_transaction(trans, info->extent_root);
 	return 0;
 }
 
@@ -7224,8 +7257,7 @@ static void reset_cached_block_groups(struct btrfs_fs_info *fs_info)
 	}
 }
 
-static int check_extent_refs(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *root,
+static int check_extent_refs(struct btrfs_root *root,
 			     struct cache_tree *extent_cache)
 {
 	struct extent_record *rec;
@@ -7246,22 +7278,28 @@ static int check_extent_refs(struct btrfs_trans_handle *trans,
 		cache = search_cache_extent(extent_cache, 0);
 		while(cache) {
 			rec = container_of(cache, struct extent_record, cache);
-			btrfs_pin_extent(root->fs_info,
-					 rec->start, rec->max_size);
+			set_extent_dirty(root->fs_info->excluded_extents,
+					 rec->start,
+					 rec->start + rec->max_size - 1,
+					 GFP_NOFS);
 			cache = next_cache_extent(cache);
 		}
 
 		/* pin down all the corrupted blocks too */
 		cache = search_cache_extent(root->fs_info->corrupt_blocks, 0);
 		while(cache) {
-			btrfs_pin_extent(root->fs_info,
-					 cache->start, cache->size);
+			set_extent_dirty(root->fs_info->excluded_extents,
+					 cache->start,
+					 cache->start + cache->size - 1,
+					 GFP_NOFS);
 			cache = next_cache_extent(cache);
 		}
-		prune_corrupt_blocks(trans, root->fs_info);
+		prune_corrupt_blocks(root->fs_info);
 		reset_cached_block_groups(root->fs_info);
 	}
 
+	reset_cached_block_groups(root->fs_info);
+
 	/*
 	 * We need to delete any duplicate entries we find first otherwise we
 	 * could mess up the extent tree when we have backrefs that actually
@@ -7281,7 +7319,7 @@ static int check_extent_refs(struct btrfs_trans_handle *trans,
 		 */
 		if (process_duplicates(root, extent_cache, rec))
 			continue;
-		ret = delete_duplicate_records(trans, root, rec);
+		ret = delete_duplicate_records(root, rec);
 		if (ret < 0)
 			return ret;
 		/*
@@ -7327,7 +7365,7 @@ static int check_extent_refs(struct btrfs_trans_handle *trans,
 				 * extent, let the fallback method handle it.
 				 */
 				if (!fixed && repair) {
-					ret = fixup_extent_refs(trans,
+					ret = fixup_extent_refs(
 							root->fs_info,
 							extent_cache, rec);
 					if (ret)
@@ -7344,7 +7382,7 @@ static int check_extent_refs(struct btrfs_trans_handle *trans,
 				(unsigned long long)rec->nr);
 
 			if (!fixed && !recorded && repair) {
-				ret = fixup_extent_refs(trans, root->fs_info,
+				ret = fixup_extent_refs(root->fs_info,
 							extent_cache, rec);
 				if (ret)
 					goto repair_abort;
@@ -7357,7 +7395,7 @@ static int check_extent_refs(struct btrfs_trans_handle *trans,
 				(unsigned long long)rec->start,
 				(unsigned long long)rec->nr);
 			if (!fixed && !recorded && repair) {
-				ret = fixup_extent_refs(trans, root->fs_info,
+				ret = fixup_extent_refs(root->fs_info,
 							extent_cache, rec);
 				if (ret)
 					goto repair_abort;
@@ -7376,7 +7414,19 @@ repair_abort:
 			fprintf(stderr, "failed to repair damaged filesystem, aborting\n");
 			exit(1);
 		} else if (!ret) {
+			struct btrfs_trans_handle *trans;
+
+			root = root->fs_info->extent_root;
+			trans = btrfs_start_transaction(root, 1);
+			if (IS_ERR(trans)) {
+				ret = PTR_ERR(trans);
+				goto repair_abort;
+			}
+
 			btrfs_fix_block_accounting(trans, root);
+			ret = btrfs_commit_transaction(trans, root);
+			if (ret)
+				goto repair_abort;
 		}
 		if (err)
 			fprintf(stderr, "repaired damaged extent references\n");
@@ -7676,7 +7726,6 @@ static void free_root_item_list(struct list_head *list)
 }
 
 static int deal_root_from_list(struct list_head *list,
-			       struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root,
 			       struct block_info *bits,
 			       int bits_nr,
@@ -7714,11 +7763,10 @@ static int deal_root_from_list(struct list_head *list,
 		 * can maximize readahead.
 		 */
 		while (1) {
-			ret = run_next_block(trans, root, bits, bits_nr, &last,
-					     pending, seen, reada,
-					     nodes, extent_cache,
-					     chunk_cache, dev_cache,
-					     block_group_cache,
+			ret = run_next_block(root, bits, bits_nr, &last,
+					     pending, seen, reada, nodes,
+					     extent_cache, chunk_cache,
+					     dev_cache, block_group_cache,
 					     dev_extent_cache, rec);
 			if (ret != 0)
 				break;
@@ -7730,11 +7778,9 @@ static int deal_root_from_list(struct list_head *list,
 			break;
 	}
 	while (ret >= 0) {
-		ret = run_next_block(trans, root, bits, bits_nr, &last,
-				     pending, seen, reada,
-				     nodes, extent_cache,
-				     chunk_cache, dev_cache,
-				     block_group_cache,
+		ret = run_next_block(root, bits, bits_nr, &last, pending, seen,
+				     reada, nodes, extent_cache, chunk_cache,
+				     dev_cache, block_group_cache,
 				     dev_extent_cache, NULL);
 		if (ret != 0) {
 			if (ret > 0)
@@ -7756,6 +7802,7 @@ static int check_chunks_and_extents(struct btrfs_root *root)
 	struct cache_tree pending;
 	struct cache_tree reada;
 	struct cache_tree nodes;
+	struct extent_io_tree excluded_extents;
 	struct cache_tree corrupt_blocks;
 	struct btrfs_path path;
 	struct btrfs_key key;
@@ -7764,7 +7811,6 @@ static int check_chunks_and_extents(struct btrfs_root *root)
 	struct block_info *bits;
 	int bits_nr;
 	struct extent_buffer *leaf;
-	struct btrfs_trans_handle *trans = NULL;
 	int slot;
 	struct btrfs_root_item ri;
 	struct list_head dropping_trees;
@@ -7785,15 +7831,12 @@ static int check_chunks_and_extents(struct btrfs_root *root)
 	cache_tree_init(&nodes);
 	cache_tree_init(&reada);
 	cache_tree_init(&corrupt_blocks);
+	extent_io_tree_init(&excluded_extents);
 	INIT_LIST_HEAD(&dropping_trees);
 	INIT_LIST_HEAD(&normal_trees);
 
 	if (repair) {
-		trans = btrfs_start_transaction(root, 1);
-		if (IS_ERR(trans)) {
-			fprintf(stderr, "Error starting transaction\n");
-			return PTR_ERR(trans);
-		}
+		root->fs_info->excluded_extents = &excluded_extents;
 		root->fs_info->fsck_extent_cache = &extent_cache;
 		root->fs_info->free_extent_hook = free_extent_hook;
 		root->fs_info->corrupt_blocks = &corrupt_blocks;
@@ -7878,9 +7921,8 @@ again:
 	 * this in mind when dealing with return values from these functions, if
 	 * we get -EAGAIN we want to fall through and restart the loop.
 	 */
-	ret = deal_root_from_list(&normal_trees, trans, root,
-				  bits, bits_nr, &pending, &seen,
-				  &reada, &nodes, &extent_cache,
+	ret = deal_root_from_list(&normal_trees, root, bits, bits_nr, &pending,
+				  &seen, &reada, &nodes, &extent_cache,
 				  &chunk_cache, &dev_cache, &block_group_cache,
 				  &dev_extent_cache);
 	if (ret < 0) {
@@ -7888,12 +7930,10 @@ again:
 			goto loop;
 		goto out;
 	}
-	ret = deal_root_from_list(&dropping_trees, trans, root,
-				  bits, bits_nr, &pending, &seen,
-				  &reada, &nodes, &extent_cache,
-				  &chunk_cache, &dev_cache,
-				  &block_group_cache,
-				  &dev_extent_cache);
+	ret = deal_root_from_list(&dropping_trees, root, bits, bits_nr,
+				  &pending, &seen, &reada, &nodes,
+				  &extent_cache, &chunk_cache, &dev_cache,
+				  &block_group_cache, &dev_extent_cache);
 	if (ret < 0) {
 		if (ret == -EAGAIN)
 			goto loop;
@@ -7909,7 +7949,7 @@ again:
 			ret = err;
 	}
 
-	ret = check_extent_refs(trans, root, &extent_cache);
+	ret = check_extent_refs(root, &extent_cache);
 	if (ret < 0) {
 		if (ret == -EAGAIN)
 			goto loop;
@@ -7921,16 +7961,13 @@ again:
 		ret = err;
 
 out:
-	if (trans) {
-		err = btrfs_commit_transaction(trans, root);
-		if (!ret)
-			ret = err;
-	}
 	if (repair) {
 		free_corrupt_blocks_tree(root->fs_info->corrupt_blocks);
+		extent_io_tree_cleanup(&excluded_extents);
 		root->fs_info->fsck_extent_cache = NULL;
 		root->fs_info->free_extent_hook = NULL;
 		root->fs_info->corrupt_blocks = NULL;
+		root->fs_info->excluded_extents = NULL;
 	}
 	free(bits);
 	free_chunk_cache_tree(&chunk_cache);
@@ -7943,16 +7980,6 @@ out:
 	free_extent_cache_tree(&nodes);
 	return ret;
 loop:
-	ret = btrfs_commit_transaction(trans, root);
-	if (ret)
-		goto out;
-
-	trans = btrfs_start_transaction(root, 1);
-	if (IS_ERR(trans)) {
-		ret = PTR_ERR(trans);
-		goto out;
-	}
-
 	free_corrupt_blocks_tree(root->fs_info->corrupt_blocks);
 	free_extent_cache_tree(&seen);
 	free_extent_cache_tree(&pending);
@@ -7965,6 +7992,7 @@ loop:
 	free_extent_record_cache(root->fs_info, &extent_cache);
 	free_root_item_list(&normal_trees);
 	free_root_item_list(&dropping_trees);
+	extent_io_tree_cleanup(&excluded_extents);
 	goto again;
 }
 
@@ -8924,6 +8952,8 @@ out:
 	free_roots_info_cache();
 	if (path)
 		btrfs_free_path(path);
+	if (trans)
+		btrfs_commit_transaction(trans, info->tree_root);
 	if (ret < 0)
 		return ret;
 
diff --git a/ctree.h b/ctree.h
index be30cb6..f4275d9 100644
--- a/ctree.h
+++ b/ctree.h
@@ -963,6 +963,7 @@ struct btrfs_fs_info {
 	struct extent_io_tree pinned_extents;
 	struct extent_io_tree pending_del;
 	struct extent_io_tree extent_ins;
+	struct extent_io_tree *excluded_extents;
 
 	/* logical->physical extent mapping */
 	struct btrfs_mapping_tree mapping_tree;
diff --git a/disk-io.c b/disk-io.c
index 0d33258..ca39f17 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -763,6 +763,8 @@ struct btrfs_fs_info *btrfs_new_fs_info(int writable, u64 sb_bytenr)
 	extent_io_tree_init(&fs_info->pinned_extents);
 	extent_io_tree_init(&fs_info->pending_del);
 	extent_io_tree_init(&fs_info->extent_ins);
+	fs_info->excluded_extents = NULL;
+
 	fs_info->fs_root_tree = RB_ROOT;
 	cache_tree_init(&fs_info->mapping_tree.cache_tree);
 
diff --git a/extent-tree.c b/extent-tree.c
index d42c572..e8545ef 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -2566,6 +2566,13 @@ check_failed:
 		goto new_group;
 	}
 
+	if (info->excluded_extents &&
+	    test_range_bit(info->excluded_extents, ins->objectid,
+			   ins->objectid + num_bytes -1, EXTENT_DIRTY, 0)) {
+		search_start = ins->objectid + num_bytes;
+		goto new_group;
+	}
+
 	if (exclude_nr > 0 && (ins->objectid + num_bytes > exclude_start &&
 	    ins->objectid < exclude_start + exclude_nr)) {
 		search_start = exclude_start + exclude_nr;
-- 
1.8.3.1

