Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:39297 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751644AbeBAGpx (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Thu, 1 Feb 2018 01:45:53 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH v2 3/3] btrfs-progs: check: Cleanup all checkpatch error and warning
Date: Thu,  1 Feb 2018 14:45:41 +0800
Message-Id: <20180201064541.14603-4-wqu@suse.com>
In-Reply-To: <20180201064541.14603-1-wqu@suse.com>
References: <20180201064541.14603-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since we're moving tons of codes, it's a good idea to fix all errors and
warnings from checkpatch.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/lowmem.c |  65 +++++++++------
 check/main.c   | 253 +++++++++++++++++++++++++++++----------------------------
 2 files changed, 165 insertions(+), 153 deletions(-)

diff --git a/check/lowmem.c b/check/lowmem.c
index a3bda97fdea8..3e7fe148bc56 100644
--- a/check/lowmem.c
+++ b/check/lowmem.c
@@ -322,7 +322,8 @@ static int repair_tree_block_ref(struct btrfs_trans_handle *trans,
 			goto out;
 
 		eb = path.nodes[0];
-		ei = btrfs_item_ptr(eb, path.slots[0], struct btrfs_extent_item);
+		ei = btrfs_item_ptr(eb, path.slots[0],
+				    struct btrfs_extent_item);
 
 		btrfs_set_extent_refs(eb, ei, 0);
 		btrfs_set_extent_generation(eb, ei, generation);
@@ -730,7 +731,9 @@ begin:
 		need_research = 0;
 		btrfs_release_path(path);
 		ret = btrfs_search_slot(NULL, root, ref_key, path, 0, 0);
-		/* the item was deleted, let path point to the last checked item */
+		/*
+		 * the item was deleted, let path point to the last checked item
+		 */
 		if (ret > 0) {
 			if (path->slots[0] == 0)
 				btrfs_prev_leaf(root, path);
@@ -1486,7 +1489,8 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
 		search_start = disk_bytenr;
 		search_len = disk_num_bytes;
 	}
-	ret = count_csum_range(root->fs_info, search_start, search_len, &csum_found);
+	ret = count_csum_range(root->fs_info, search_start, search_len,
+			       &csum_found);
 	if (csum_found > 0 && nodatasum) {
 		err |= ODD_CSUM_ITEM;
 		error("root %llu EXTENT_DATA[%llu %llu] nodatasum shouldn't have datasum",
@@ -1497,7 +1501,8 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
 		error("root %llu EXTENT_DATA[%llu %llu] csum missing, have: %llu, expected: %llu",
 		      root->objectid, fkey->objectid, fkey->offset,
 		      csum_found, search_len);
-	} else if (extent_type == BTRFS_FILE_EXTENT_PREALLOC && csum_found > 0) {
+	} else if (extent_type == BTRFS_FILE_EXTENT_PREALLOC &&
+		   csum_found > 0) {
 		err |= ODD_CSUM_ITEM;
 		error("root %llu EXTENT_DATA[%llu %llu] prealloc shouldn't have csum, but has: %llu",
 		      root->objectid, fkey->objectid, fkey->offset, csum_found);
@@ -1561,7 +1566,8 @@ loop:
 	}
 
 special_case:
-	di = btrfs_item_ptr(path.nodes[0], path.slots[0], struct btrfs_dir_item);
+	di = btrfs_item_ptr(path.nodes[0], path.slots[0],
+			    struct btrfs_dir_item);
 	cur = 0;
 	total = btrfs_item_size_nr(path.nodes[0], path.slots[0]);
 
@@ -1913,7 +1919,8 @@ static int check_inode_item(struct btrfs_root *root, struct btrfs_path *path,
 	nodatasum = btrfs_inode_flags(node, ii) & BTRFS_INODE_NODATASUM;
 
 	while (1) {
-		btrfs_item_key_to_cpu(path->nodes[0], &last_key, path->slots[0]);
+		btrfs_item_key_to_cpu(path->nodes[0], &last_key,
+				      path->slots[0]);
 		ret = btrfs_next_item(root, path);
 		if (ret < 0) {
 			/* out will fill 'err' rusing current statistics */
@@ -2360,7 +2367,7 @@ static int check_tree_block_ref(struct btrfs_root *root,
 				 * Check if the backref points to valid
 				 * referencer
 				 */
-				found_ref = !check_tree_block_ref( root, NULL,
+				found_ref = !check_tree_block_ref(root, NULL,
 						offset, level + 1, owner,
 						NULL);
 			}
@@ -2500,7 +2507,8 @@ static int repair_extent_data_item(struct btrfs_trans_handle *trans,
 		if (ret)
 			goto out;
 		eb = path.nodes[0];
-		ei = btrfs_item_ptr(eb, path.slots[0], struct btrfs_extent_item);
+		ei = btrfs_item_ptr(eb, path.slots[0],
+				    struct btrfs_extent_item);
 
 		btrfs_set_extent_refs(eb, ei, 0);
 		btrfs_set_extent_generation(eb, ei, generation);
@@ -2657,7 +2665,8 @@ static int check_extent_data_item(struct btrfs_root *root,
 		}
 		if (type == BTRFS_EXTENT_DATA_REF_KEY) {
 			ref_root = btrfs_extent_data_ref_root(leaf, dref);
-			ref_objectid = btrfs_extent_data_ref_objectid(leaf, dref);
+			ref_objectid = btrfs_extent_data_ref_objectid(leaf,
+								      dref);
 			ref_offset = btrfs_extent_data_ref_offset(leaf, dref);
 
 			if (ref_objectid == fi_key.objectid &&
@@ -2820,8 +2829,8 @@ static int check_block_group_item(struct btrfs_fs_info *fs_info,
 			if (!(bg_flags & BTRFS_BLOCK_GROUP_DATA)) {
 				error(
 			"bad extent[%llu, %llu) type mismatch with chunk",
-					extent_key.objectid,
-					extent_key.objectid + extent_key.offset);
+				      extent_key.objectid,
+				      extent_key.objectid + extent_key.offset);
 				err |= CHUNK_TYPE_MISMATCH;
 			}
 		} else if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
@@ -3175,7 +3184,8 @@ static int check_extent_data_backref(struct btrfs_fs_info *fs_info,
 		    btrfs_header_owner(leaf) != root_id)
 			goto next;
 		btrfs_item_key_to_cpu(leaf, &key, slot);
-		if (key.objectid != objectid || key.type != BTRFS_EXTENT_DATA_KEY)
+		if (key.objectid != objectid || key.type !=
+		    BTRFS_EXTENT_DATA_KEY)
 			break;
 		fi = btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
 		/*
@@ -3205,7 +3215,8 @@ out:
 	if (found_count != count) {
 		error(
 "extent[%llu, %llu] referencer count mismatch (root: %llu, owner: %llu, offset: %llu) wanted: %u, have: %u",
-			bytenr, len, root_id, objectid, offset, count, found_count);
+			bytenr, len, root_id, objectid, offset, count,
+			found_count);
 		return REFERENCER_MISSING;
 	}
 	return 0;
@@ -3975,13 +3986,12 @@ static int walk_down_tree(struct btrfs_trans_handle *trans,
 					       nrefs, account_file_data);
 			err |= ret;
 			break;
-		} else {
-			if (check || !check_all) {
-				ret = btrfs_check_node(root, NULL, cur);
-				if (ret != BTRFS_TREE_BLOCK_CLEAN) {
-					err |= -EIO;
-					break;
-				}
+		}
+		if (check || !check_all) {
+			ret = btrfs_check_node(root, NULL, cur);
+			if (ret != BTRFS_TREE_BLOCK_CLEAN) {
+				err |= -EIO;
+				break;
 			}
 		}
 
@@ -4001,7 +4011,8 @@ static int walk_down_tree(struct btrfs_trans_handle *trans,
 			continue;
 		}
 
-		next = btrfs_find_tree_block(fs_info, bytenr, fs_info->nodesize);
+		next = btrfs_find_tree_block(fs_info, bytenr,
+					     fs_info->nodesize);
 		if (!next || !btrfs_buffer_uptodate(next, ptr_gen)) {
 			free_extent_buffer(next);
 			reada_walk_down(root, cur, path->slots[*level]);
@@ -4022,7 +4033,7 @@ static int walk_down_tree(struct btrfs_trans_handle *trans,
 
 		ret = check_child_node(cur, path->slots[*level], next);
 		err |= ret;
-		if (ret < 0) 
+		if (ret < 0)
 			break;
 
 		if (btrfs_is_leaf(next))
@@ -4041,7 +4052,8 @@ static int walk_down_tree(struct btrfs_trans_handle *trans,
 		path->slots[*level] = 0;
 		account_file_data = 0;
 
-		update_nodes_refs(root, (u64)-1, next, nrefs, *level, check_all);
+		update_nodes_refs(root, (u64)-1, next, nrefs, *level,
+				  check_all);
 	}
 	return err;
 }
@@ -4058,11 +4070,10 @@ static int walk_up_tree(struct btrfs_root *root, struct btrfs_path *path,
 			path->slots[i]++;
 			*level = i;
 			return 0;
-		} else {
-			free_extent_buffer(path->nodes[*level]);
-			path->nodes[*level] = NULL;
-			*level = i + 1;
 		}
+		free_extent_buffer(path->nodes[*level]);
+		path->nodes[*level] = NULL;
+		*level = i + 1;
 	}
 	return 1;
 }
diff --git a/check/main.c b/check/main.c
index aec3881fc043..f6874cd86543 100644
--- a/check/main.c
+++ b/check/main.c
@@ -1720,14 +1720,13 @@ static int walk_up_tree(struct btrfs_root *root, struct btrfs_path *path,
 			path->slots[i]++;
 			*level = i;
 			return 0;
-		} else {
-			free_extent_buffer(path->nodes[*level]);
-			path->nodes[*level] = NULL;
-			BUG_ON(*level > wc->active_node);
-			if (*level == wc->active_node)
-				leave_shared_node(root, wc, *level);
-			*level = i + 1;
 		}
+		free_extent_buffer(path->nodes[*level]);
+		path->nodes[*level] = NULL;
+		BUG_ON(*level > wc->active_node);
+		if (*level == wc->active_node)
+			leave_shared_node(root, wc, *level);
+		*level = i + 1;
 	}
 	return 1;
 }
@@ -3488,22 +3487,21 @@ static int all_backpointers_checked(struct extent_record *rec, int print_errs)
 				goto out;
 			if (back->is_data) {
 				dback = to_data_backref(back);
-				fprintf(stderr, "Data backref %llu %s %llu"
-					" owner %llu offset %llu num_refs %lu"
-					" not found in extent tree\n",
+				fprintf(stderr,
+"Data backref %llu %s %llu owner %llu offset %llu num_refs %lu not found in extent tree\n",
 					(unsigned long long)rec->start,
 					back->full_backref ?
 					"parent" : "root",
 					back->full_backref ?
-					(unsigned long long)dback->parent:
+					(unsigned long long)dback->parent :
 					(unsigned long long)dback->root,
 					(unsigned long long)dback->owner,
 					(unsigned long long)dback->offset,
 					(unsigned long)dback->num_refs);
 			} else {
 				tback = to_tree_backref(back);
-				fprintf(stderr, "Tree backref %llu parent %llu"
-					" root %llu not found in extent tree\n",
+				fprintf(stderr,
+"Tree backref %llu parent %llu root %llu not found in extent tree\n",
 					(unsigned long long)rec->start,
 					(unsigned long long)tback->parent,
 					(unsigned long long)tback->root);
@@ -3514,7 +3512,8 @@ static int all_backpointers_checked(struct extent_record *rec, int print_errs)
 			if (!print_errs)
 				goto out;
 			tback = to_tree_backref(back);
-			fprintf(stderr, "Backref %llu %s %llu not referenced back %p\n",
+			fprintf(stderr,
+				"Backref %llu %s %llu not referenced back %p\n",
 				(unsigned long long)rec->start,
 				back->full_backref ? "parent" : "root",
 				back->full_backref ?
@@ -3527,26 +3526,25 @@ static int all_backpointers_checked(struct extent_record *rec, int print_errs)
 				err = 1;
 				if (!print_errs)
 					goto out;
-				fprintf(stderr, "Incorrect local backref count"
-					" on %llu %s %llu owner %llu"
-					" offset %llu found %u wanted %u back %p\n",
+				fprintf(stderr,
+"Incorrect local backref count on %llu %s %llu owner %llu offset %llu found %u wanted %u back %p\n",
 					(unsigned long long)rec->start,
 					back->full_backref ?
 					"parent" : "root",
 					back->full_backref ?
-					(unsigned long long)dback->parent:
+					(unsigned long long)dback->parent :
 					(unsigned long long)dback->root,
 					(unsigned long long)dback->owner,
 					(unsigned long long)dback->offset,
-					dback->found_ref, dback->num_refs, back);
+					dback->found_ref, dback->num_refs,
+					back);
 			}
 			if (dback->disk_bytenr != rec->start) {
 				err = 1;
 				if (!print_errs)
 					goto out;
-				fprintf(stderr, "Backref disk bytenr does not"
-					" match extent record, bytenr=%llu, "
-					"ref bytenr=%llu\n",
+				fprintf(stderr,
+"Backref disk bytenr does not match extent record, bytenr=%llu, ref bytenr=%llu\n",
 					(unsigned long long)rec->start,
 					(unsigned long long)dback->disk_bytenr);
 			}
@@ -3555,9 +3553,8 @@ static int all_backpointers_checked(struct extent_record *rec, int print_errs)
 				err = 1;
 				if (!print_errs)
 					goto out;
-				fprintf(stderr, "Backref bytes do not match "
-					"extent backref, bytenr=%llu, ref "
-					"bytes=%llu, backref bytes=%llu\n",
+				fprintf(stderr,
+"Backref bytes do not match extent backref, bytenr=%llu, ref bytes=%llu, backref bytes=%llu\n",
 					(unsigned long long)rec->start,
 					(unsigned long long)rec->nr,
 					(unsigned long long)dback->bytes);
@@ -3574,8 +3571,8 @@ static int all_backpointers_checked(struct extent_record *rec, int print_errs)
 		err = 1;
 		if (!print_errs)
 			goto out;
-		fprintf(stderr, "Incorrect global backref count "
-			"on %llu found %llu wanted %llu\n",
+		fprintf(stderr,
+"Incorrect global backref count on %llu found %llu wanted %llu\n",
 			(unsigned long long)rec->start,
 			(unsigned long long)found,
 			(unsigned long long)rec->refs);
@@ -3745,6 +3742,7 @@ static int swap_values(struct btrfs_root *root, struct btrfs_path *path,
 				    sizeof(struct btrfs_key_ptr));
 		if (slot == 0) {
 			struct btrfs_disk_key key;
+
 			btrfs_node_key(buf, &key, 0);
 			btrfs_fixup_low_keys(root, path, &key,
 					     btrfs_header_level(buf) + 1);
@@ -3877,8 +3875,8 @@ again:
 				ret = delete_bogus_item(root, path, buf, i);
 				if (!ret)
 					goto again;
-				fprintf(stderr, "item is off the end of the "
-					"leaf, can't fix\n");
+				fprintf(stderr,
+				"item is off the end of the leaf, can't fix\n");
 				ret = -EIO;
 				break;
 			}
@@ -4066,7 +4064,7 @@ static struct tree_backref *find_tree_backref(struct extent_record *rec,
 	struct extent_backref *node;
 	struct tree_backref *back;
 
-	while(cur != &rec->backrefs) {
+	while (cur != &rec->backrefs) {
 		node = to_extent_backref(cur);
 		cur = cur->next;
 		if (node->is_data)
@@ -4118,7 +4116,7 @@ static struct data_backref *find_data_backref(struct extent_record *rec,
 	struct extent_backref *node;
 	struct data_backref *back;
 
-	while(cur != &rec->backrefs) {
+	while (cur != &rec->backrefs) {
 		node = to_extent_backref(cur);
 		cur = cur->next;
 		if (!node->is_data)
@@ -4344,12 +4342,13 @@ static int add_extent_rec(struct cache_tree *extent_cache,
 
 		if (tmpl->extent_item_refs && !dup) {
 			if (rec->extent_item_refs) {
-				fprintf(stderr, "block %llu rec "
-					"extent_item_refs %llu, passed %llu\n",
+				fprintf(stderr,
+			"block %llu rec extent_item_refs %llu, passed %llu\n",
 					(unsigned long long)tmpl->start,
 					(unsigned long long)
 							rec->extent_item_refs,
-					(unsigned long long)tmpl->extent_item_refs);
+					(unsigned long long)
+							tmpl->extent_item_refs);
 			}
 			rec->extent_item_refs = tmpl->extent_item_refs;
 		}
@@ -4433,8 +4432,8 @@ static int add_tree_backref(struct cache_tree *extent_cache, u64 bytenr,
 
 	if (found_ref) {
 		if (back->node.found_ref) {
-			fprintf(stderr, "Extent back ref already exists "
-				"for %llu parent %llu root %llu \n",
+			fprintf(stderr,
+	"Extent back ref already exists for %llu parent %llu root %llu\n",
 				(unsigned long long)bytenr,
 				(unsigned long long)parent,
 				(unsigned long long)root);
@@ -4442,8 +4441,8 @@ static int add_tree_backref(struct cache_tree *extent_cache, u64 bytenr,
 		back->node.found_ref = 1;
 	} else {
 		if (back->node.found_extent_tree) {
-			fprintf(stderr, "Extent back ref already exists "
-				"for %llu parent %llu root %llu \n",
+			fprintf(stderr,
+	"Extent back ref already exists for %llu parent %llu root %llu\n",
 				(unsigned long long)bytenr,
 				(unsigned long long)parent,
 				(unsigned long long)root);
@@ -4530,9 +4529,8 @@ static int add_data_backref(struct cache_tree *extent_cache, u64 bytenr,
 		rec->owner_ref_checked = 1;
 	} else {
 		if (back->node.found_extent_tree) {
-			fprintf(stderr, "Extent back ref already exists "
-				"for %llu parent %llu root %llu "
-				"owner %llu offset %llu num_refs %lu\n",
+			fprintf(stderr,
+"Extent back ref already exists for %llu parent %llu root %llu owner %llu offset %llu num_refs %lu\n",
 				(unsigned long long)bytenr,
 				(unsigned long long)parent,
 				(unsigned long long)root,
@@ -4555,6 +4553,7 @@ static int add_pending(struct cache_tree *pending,
 		       struct cache_tree *seen, u64 bytenr, u32 size)
 {
 	int ret;
+
 	ret = add_cache_extent(seen, bytenr, size);
 	if (ret)
 		return ret;
@@ -4588,17 +4587,17 @@ static int pick_next_pending(struct cache_tree *pending,
 		cache = search_cache_extent(nodes, 0);
 
 	if (!cache) {
-		 cache = search_cache_extent(pending, 0);
-		 if (!cache)
-			 return 0;
-		 ret = 0;
-		 do {
-			 bits[ret].start = cache->start;
-			 bits[ret].size = cache->size;
-			 cache = next_cache_extent(cache);
-			 ret++;
-		 } while (cache && ret < bits_nr);
-		 return ret;
+		cache = search_cache_extent(pending, 0);
+		if (!cache)
+			return 0;
+		ret = 0;
+		do {
+			bits[ret].start = cache->start;
+			bits[ret].size = cache->size;
+			cache = next_cache_extent(cache);
+			ret++;
+		} while (cache && ret < bits_nr);
+		return ret;
 	}
 
 	ret = 0;
@@ -4612,8 +4611,9 @@ static int pick_next_pending(struct cache_tree *pending,
 	if (bits_nr - ret > 8) {
 		u64 lookup = bits[0].start + bits[0].size;
 		struct cache_extent *next;
+
 		next = search_cache_extent(pending, lookup);
-		while(next) {
+		while (next) {
 			if (next->start - lookup > 32768)
 				break;
 			bits[ret].start = next->start;
@@ -5004,6 +5004,7 @@ static int process_extent_item(struct btrfs_root *root,
 	if (item_size < sizeof(*ei)) {
 #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
 		struct btrfs_extent_item_v0 *ei0;
+
 		if (item_size != sizeof(*ei0)) {
 			error(
 	"invalid extent item format: ITEM[%llu %u %llu] leaf: %llu slot: %d",
@@ -5356,8 +5357,8 @@ static int check_space_cache(struct btrfs_root *root)
 
 static int check_extent_csums(struct btrfs_root *root, u64 bytenr,
 			u64 num_bytes, unsigned long leaf_offset,
-			struct extent_buffer *eb) {
-
+			struct extent_buffer *eb)
+{
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	u64 offset = 0;
 	u16 csum_size = btrfs_super_csum_size(fs_info->super_copy);
@@ -5646,7 +5647,8 @@ skip_csum_check:
 }
 
 static int is_dropped_key(struct btrfs_key *key,
-			  struct btrfs_key *drop_key) {
+			  struct btrfs_key *drop_key)
+{
 	if (key->objectid < drop_key->objectid)
 		return 1;
 	else if (key->objectid == drop_key->objectid) {
@@ -5823,7 +5825,7 @@ static int run_next_block(struct btrfs_root *root,
 		return 1;
 
 	if (!reada_bits) {
-		for(i = 0; i < nritems; i++) {
+		for (i = 0; i < nritems; i++) {
 			ret = add_cache_extent(reada, bits[i].start,
 					       bits[i].size);
 			if (ret == -EEXIST)
@@ -5933,6 +5935,7 @@ static int run_next_block(struct btrfs_root *root,
 		btree_space_waste += btrfs_leaf_free_space(root, buf);
 		for (i = 0; i < nritems; i++) {
 			struct btrfs_file_extent_item *fi;
+
 			btrfs_item_key_to_cpu(buf, &key, i);
 			/*
 			 * Check key type against the leaf owner.
@@ -6007,6 +6010,7 @@ static int run_next_block(struct btrfs_root *root,
 			}
 			if (key.type == BTRFS_EXTENT_DATA_REF_KEY) {
 				struct btrfs_extent_data_ref *ref;
+
 				ref = btrfs_item_ptr(buf, i,
 						struct btrfs_extent_data_ref);
 				add_data_backref(extent_cache,
@@ -6021,6 +6025,7 @@ static int run_next_block(struct btrfs_root *root,
 			}
 			if (key.type == BTRFS_SHARED_DATA_REF_KEY) {
 				struct btrfs_shared_data_ref *ref;
+
 				ref = btrfs_item_ptr(buf, i,
 						struct btrfs_shared_data_ref);
 				add_data_backref(extent_cache,
@@ -6058,9 +6063,9 @@ static int run_next_block(struct btrfs_root *root,
 
 			data_bytes_allocated +=
 				btrfs_file_extent_disk_num_bytes(buf, fi);
-			if (data_bytes_allocated < root->fs_info->sectorsize) {
+			if (data_bytes_allocated < root->fs_info->sectorsize)
 				abort();
-			}
+
 			data_bytes_referenced +=
 				btrfs_file_extent_num_bytes(buf, fi);
 			add_data_backref(extent_cache,
@@ -6093,7 +6098,8 @@ static int run_next_block(struct btrfs_root *root,
 
 			memset(&tmpl, 0, sizeof(tmpl));
 			btrfs_cpu_key_to_disk(&tmpl.parent_key, &key);
-			tmpl.parent_generation = btrfs_node_ptr_generation(buf, i);
+			tmpl.parent_generation =
+				btrfs_node_ptr_generation(buf, i);
 			tmpl.start = ptr;
 			tmpl.nr = size;
 			tmpl.refs = 1;
@@ -6112,11 +6118,10 @@ static int run_next_block(struct btrfs_root *root,
 				continue;
 			}
 
-			if (level > 1) {
+			if (level > 1)
 				add_pending(nodes, seen, ptr, size);
-			} else {
+			else
 				add_pending(pending, seen, ptr, size);
-			}
 		}
 		btree_space_waste += (BTRFS_NODEPTRS_PER_BLOCK(fs_info) -
 				      nritems) * sizeof(struct btrfs_key_ptr);
@@ -6188,6 +6193,7 @@ static int free_extent_hook(struct btrfs_trans_handle *trans,
 	rec = container_of(cache, struct extent_record, cache);
 	if (is_data) {
 		struct data_backref *back;
+
 		back = find_data_backref(rec, parent, root_objectid, owner,
 					 offset, 1, bytenr, num_bytes);
 		if (!back)
@@ -6213,6 +6219,7 @@ static int free_extent_hook(struct btrfs_trans_handle *trans,
 		}
 	} else {
 		struct tree_backref *back;
+
 		back = find_tree_backref(rec, parent, root_objectid);
 		if (!back)
 			goto out;
@@ -6252,7 +6259,7 @@ static int delete_extent_records(struct btrfs_trans_handle *trans,
 	key.type = (u8)-1;
 	key.offset = (u64)-1;
 
-	while(1) {
+	while (1) {
 		ret = btrfs_search_slot(trans, root->fs_info->extent_root,
 					&key, path, 0, 1);
 		if (ret < 0)
@@ -6365,7 +6372,7 @@ static int record_extent(struct btrfs_trans_handle *trans,
 			btrfs_set_extent_flags(leaf, ei,
 					       BTRFS_EXTENT_FLAG_DATA);
 		} else {
-			struct btrfs_disk_key copy_key;;
+			struct btrfs_disk_key copy_key;
 
 			bi = (struct btrfs_tree_block_info *)(ei + 1);
 			memset_extent_buffer(leaf, 0, (unsigned long)bi,
@@ -6379,8 +6386,8 @@ static int record_extent(struct btrfs_trans_handle *trans,
 			btrfs_set_tree_block_level(leaf, bi, rec->info_level);
 			btrfs_set_tree_block_key(leaf, bi, &copy_key);
 
-			btrfs_set_extent_flags(leaf, ei,
-					       BTRFS_EXTENT_FLAG_TREE_BLOCK | flags);
+			btrfs_set_extent_flags(leaf, ei, flags |
+					       BTRFS_EXTENT_FLAG_TREE_BLOCK);
 		}
 
 		btrfs_mark_buffer_dirty(leaf);
@@ -6418,18 +6425,14 @@ static int record_extent(struct btrfs_trans_handle *trans,
 			if (ret)
 				break;
 		}
-		fprintf(stderr, "adding new data backref"
-				" on %llu %s %llu owner %llu"
-				" offset %llu found %d\n",
-				(unsigned long long)rec->start,
-				back->full_backref ?
-				"parent" : "root",
-				back->full_backref ?
-				(unsigned long long)parent :
-				(unsigned long long)dback->root,
-				(unsigned long long)dback->owner,
-				(unsigned long long)dback->offset,
-				dback->found_ref);
+		fprintf(stderr,
+"adding new data backref on %llu %s %llu owner %llu offset %llu found %d\n",
+			(unsigned long long)rec->start,
+			back->full_backref ? "parent" : "root",
+			back->full_backref ? (unsigned long long)parent :
+					     (unsigned long long)dback->root,
+			(unsigned long long)dback->owner,
+			(unsigned long long)dback->offset, dback->found_ref);
 	} else {
 		u64 parent;
 		struct tree_backref *tback;
@@ -6443,8 +6446,8 @@ static int record_extent(struct btrfs_trans_handle *trans,
 		ret = btrfs_inc_extent_ref(trans, info->extent_root,
 					   rec->start, rec->max_size,
 					   parent, tback->root, 0, 0);
-		fprintf(stderr, "adding new tree backref on "
-			"start %llu len %llu parent %llu root %llu\n",
+		fprintf(stderr,
+"adding new tree backref on start %llu len %llu parent %llu root %llu\n",
 			rec->start, rec->max_size, parent, tback->root);
 	}
 fail:
@@ -6587,9 +6590,9 @@ static int repair_ref(struct btrfs_fs_info *info, struct btrfs_path *path,
 		goto out;
 	}
 	if (ret > 0) {
-		fprintf(stderr, "Well that's odd, we just found this key "
-			"[%Lu, %u, %Lu]\n", key.objectid, key.type,
-			key.offset);
+		fprintf(stderr,
+		"Well that's odd, we just found this key [%Lu, %u, %Lu]\n",
+			key.objectid, key.type, key.offset);
 		ret = -EINVAL;
 		goto out;
 	}
@@ -6599,10 +6602,8 @@ static int repair_ref(struct btrfs_fs_info *info, struct btrfs_path *path,
 
 	if (btrfs_file_extent_compression(leaf, fi) &&
 	    dback->disk_bytenr != entry->bytenr) {
-		fprintf(stderr, "Ref doesn't match the record start and is "
-			"compressed, please take a btrfs-image of this file "
-			"system and send it to a btrfs developer so they can "
-			"complete this functionality for bytenr %Lu\n",
+		fprintf(stderr,
+"Ref doesn't match the record start and is compressed, please take a btrfs-image of this file system and send it to a btrfs developer so they can complete this functionality for bytenr %Lu\n",
 			dback->disk_bytenr);
 		ret = -EINVAL;
 		goto out;
@@ -6618,9 +6619,8 @@ static int repair_ref(struct btrfs_fs_info *info, struct btrfs_path *path,
 		if (dback->disk_bytenr + offset +
 		    btrfs_file_extent_num_bytes(leaf, fi) >
 		    entry->bytenr + entry->bytes) {
-			fprintf(stderr, "Ref is past the entry end, please "
-				"take a btrfs-image of this file system and "
-				"send it to a btrfs developer, ref %Lu\n",
+			fprintf(stderr,
+"Ref is past the entry end, please take a btrfs-image of this file system and send it to a btrfs developer, ref %Lu\n",
 				dback->disk_bytenr);
 			ret = -EINVAL;
 			goto out;
@@ -6633,9 +6633,8 @@ static int repair_ref(struct btrfs_fs_info *info, struct btrfs_path *path,
 
 		offset = btrfs_file_extent_offset(leaf, fi);
 		if (dback->disk_bytenr + offset < entry->bytenr) {
-			fprintf(stderr, "Ref is before the entry start, please"
-				" take a btrfs-image of this file system and "
-				"send it to a btrfs developer, ref %Lu\n",
+			fprintf(stderr,
+"Ref is before the entry start, please take a btrfs-image of this file system and send it to a btrfs developer, ref %Lu\n",
 				dback->disk_bytenr);
 			ret = -EINVAL;
 			goto out;
@@ -6741,8 +6740,9 @@ static int verify_backrefs(struct btrfs_fs_info *info, struct btrfs_path *path,
 	if (nr_entries <= 1 && !mismatch)
 		goto out;
 
-	fprintf(stderr, "attempting to repair backref discrepency for bytenr "
-		"%Lu\n", rec->start);
+	fprintf(stderr,
+		"attempting to repair backref discrepency for bytenr %Lu\n",
+		rec->start);
 
 	/*
 	 * First we want to see if the backrefs can agree amongst themselves who
@@ -6758,9 +6758,8 @@ static int verify_backrefs(struct btrfs_fs_info *info, struct btrfs_path *path,
 	if (!best) {
 		entry = find_entry(&entries, rec->start, rec->nr);
 		if (!entry && (!broken_entries || !rec->found_rec)) {
-			fprintf(stderr, "Backrefs don't agree with each other "
-				"and extent record doesn't agree with anybody,"
-				" so we can't fix bytenr %Lu bytes %Lu\n",
+			fprintf(stderr,
+"Backrefs don't agree with each other and extent record doesn't agree with anybody, so we can't fix bytenr %Lu bytes %Lu\n",
 				rec->start, rec->nr);
 			ret = -EINVAL;
 			goto out;
@@ -6783,10 +6782,9 @@ static int verify_backrefs(struct btrfs_fs_info *info, struct btrfs_path *path,
 		entry->count++;
 		best = find_most_right_entry(&entries);
 		if (!best) {
-			fprintf(stderr, "Backrefs and extent record evenly "
-				"split on who is right, this is going to "
-				"require user input to fix bytenr %Lu bytes "
-				"%Lu\n", rec->start, rec->nr);
+			fprintf(stderr,
+"Backrefs and extent record evenly split on who is right, this is going to require user input to fix bytenr %Lu bytes %Lu\n",
+				rec->start, rec->nr);
 			ret = -EINVAL;
 			goto out;
 		}
@@ -6798,10 +6796,8 @@ static int verify_backrefs(struct btrfs_fs_info *info, struct btrfs_path *path,
 	 * deal with it properly here yet, so just bail out of that's the case.
 	 */
 	if (best->bytenr != rec->start) {
-		fprintf(stderr, "Extent start and backref starts don't match, "
-			"please use btrfs-image on this file system and send "
-			"it to a btrfs developer so they can make fsck fix "
-			"this particular case.  bytenr is %Lu, bytes is %Lu\n",
+		fprintf(stderr,
+"Extent start and backref starts don't match, please use btrfs-image on this file system and send it to a btrfs developer so they can make fsck fix this particular case.  bytenr is %Lu, bytes is %Lu\n",
 			rec->start, rec->nr);
 		ret = -EINVAL;
 		goto out;
@@ -6951,10 +6947,8 @@ static int delete_duplicate_records(struct btrfs_root *root,
 			continue;
 
 		if (tmp->start + tmp->nr < good->start + good->nr) {
-			fprintf(stderr, "Ok we have overlapping extents that "
-				"aren't completely covered by each other, this "
-				"is going to require more careful thought.  "
-				"The extents are [%Lu-%Lu] and [%Lu-%Lu]\n",
+			fprintf(stderr,
+"Ok we have overlapping extents that aren't completely covered by each other, this is going to require more careful thought. The extents are [%Lu-%Lu] and [%Lu-%Lu]\n",
 				tmp->start, tmp->nr, good->start, good->nr);
 			abort();
 		}
@@ -6986,9 +6980,9 @@ static int delete_duplicate_records(struct btrfs_root *root,
 
 		/* Shouldn't happen but just in case */
 		if (tmp->metadata) {
-			fprintf(stderr, "Well this shouldn't happen, extent "
-				"record overlaps but is metadata? "
-				"[%Lu, %Lu]\n", tmp->start, tmp->nr);
+			fprintf(stderr,
+"Well this shouldn't happen, extent record overlaps but is metadata? [%Lu, %Lu]\n",
+				tmp->start, tmp->nr);
 			abort();
 		}
 
@@ -7090,6 +7084,7 @@ static int find_possible_backrefs(struct btrfs_fs_info *info,
 		cache = lookup_cache_extent(extent_cache, bytenr, 1);
 		if (cache) {
 			struct extent_record *tmp;
+
 			tmp = container_of(cache, struct extent_record, cache);
 
 			/*
@@ -7271,7 +7266,8 @@ static int fixup_extent_refs(struct btrfs_fs_info *info,
 			continue;
 
 		rec->bad_full_backref = 0;
-		ret = record_extent(trans, info, &path, rec, back, allocated, flags);
+		ret = record_extent(trans, info, &path, rec, back, allocated,
+				    flags);
 		allocated = 1;
 
 		if (ret)
@@ -7280,6 +7276,7 @@ static int fixup_extent_refs(struct btrfs_fs_info *info,
 out:
 	if (trans) {
 		int err = btrfs_commit_transaction(trans, info->extent_root);
+
 		if (!ret)
 			ret = err;
 	}
@@ -7401,8 +7398,8 @@ again:
 			goto del_ptr;
 	}
 	/*
-	 * we couldn't find the bad block.  TODO, search all the nodes for pointers
-	 * to this block
+	 * we couldn't find the bad block.
+	 * TODO: search all the nodes for pointers to this block
 	 */
 	if (eb == info->extent_root->node) {
 		ret = -ENOENT;
@@ -7437,7 +7434,8 @@ static int prune_corrupt_blocks(struct btrfs_fs_info *info)
 			if (IS_ERR(trans))
 				return PTR_ERR(trans);
 		}
-		corrupt = container_of(cache, struct btrfs_corrupt_block, cache);
+		corrupt = container_of(cache, struct btrfs_corrupt_block,
+				       cache);
 		prune_one_block(trans, info, corrupt);
 		remove_cache_extent(info->corrupt_blocks, cache);
 	}
@@ -7463,7 +7461,7 @@ static int check_extent_refs(struct btrfs_root *root,
 		 * extents in the FS
 		 */
 		cache = search_cache_extent(extent_cache, 0);
-		while(cache) {
+		while (cache) {
 			rec = container_of(cache, struct extent_record, cache);
 			set_extent_dirty(root->fs_info->excluded_extents,
 					 rec->start,
@@ -7473,7 +7471,7 @@ static int check_extent_refs(struct btrfs_root *root,
 
 		/* pin down all the corrupted blocks too */
 		cache = search_cache_extent(root->fs_info->corrupt_blocks, 0);
-		while(cache) {
+		while (cache) {
 			set_extent_dirty(root->fs_info->excluded_extents,
 					 cache->start,
 					 cache->start + cache->size - 1);
@@ -7518,7 +7516,7 @@ static int check_extent_refs(struct btrfs_root *root,
 	if (had_dups)
 		return -EAGAIN;
 
-	while(1) {
+	while (1) {
 		int cur_err = 0;
 		int fix = 0;
 
@@ -7527,8 +7525,9 @@ static int check_extent_refs(struct btrfs_root *root,
 			break;
 		rec = container_of(cache, struct extent_record, cache);
 		if (rec->num_duplicates) {
-			fprintf(stderr, "extent item %llu has multiple extent "
-				"items\n", (unsigned long long)rec->start);
+			fprintf(stderr,
+				"extent item %llu has multiple extent items\n",
+				(unsigned long long)rec->start);
 			cur_err = 1;
 		}
 
@@ -7561,7 +7560,8 @@ static int check_extent_refs(struct btrfs_root *root,
 		}
 
 		if (repair && fix) {
-			ret = fixup_extent_refs(root->fs_info, extent_cache, rec);
+			ret = fixup_extent_refs(root->fs_info, extent_cache,
+						rec);
 			if (ret)
 				goto repair_abort;
 		}
@@ -7943,8 +7943,8 @@ static int add_root_item_to_list(struct list_head *head,
 				  u8 level, u8 drop_level,
 				  struct btrfs_key *drop_key)
 {
-
 	struct root_item_record *ri_rec;
+
 	ri_rec = malloc(sizeof(*ri_rec));
 	if (!ri_rec)
 		return -ENOMEM;
@@ -7992,6 +7992,7 @@ static int deal_root_from_list(struct list_head *list,
 	while (!list_empty(list)) {
 		struct root_item_record *rec;
 		struct extent_buffer *buf;
+
 		rec = list_entry(list->next,
 				 struct root_item_record, list);
 		last = 0;
@@ -8123,7 +8124,7 @@ again:
 	ret = btrfs_search_slot(NULL, fs_info->tree_root, &key, &path, 0, 0);
 	if (ret < 0)
 		goto out;
-	while(1) {
+	while (1) {
 		leaf = path.nodes[0];
 		slot = path.slots[0];
 		if (slot >= btrfs_header_nritems(path.nodes[0])) {
-- 
2.16.1

