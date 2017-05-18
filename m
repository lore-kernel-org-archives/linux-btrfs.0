Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46077 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932138AbdERDjS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 23:39:18 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 12/32] btrfs-progs: Refactor block sizes users in cmds-check.c
Date: Thu, 18 May 2017 11:38:37 +0800
Message-ID: <20170518033857.15002-13-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
References: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 110 +++++++++++++++++++++++++++++++----------------------------
 1 file changed, 58 insertions(+), 52 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index ad7c81b2..ce479855 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -829,7 +829,8 @@ static void print_inode_error(struct btrfs_root *root, struct inode_record *rec)
 		}
 		if (!found)
 			fprintf(stderr, "\tstart: 0, len: %llu\n",
-				round_up(rec->isize, root->sectorsize));
+				round_up(rec->isize,
+					 root->fs_info->sectorsize));
 	}
 }
 
@@ -1699,7 +1700,8 @@ static int count_csum_range(struct btrfs_root *root, u64 start,
 			start = key.offset;
 
 		size = btrfs_item_size_nr(leaf, path.slots[0]);
-		csum_end = key.offset + (size / csum_size) * root->sectorsize;
+		csum_end = key.offset + (size / csum_size) *
+			   root->fs_info->sectorsize;
 		if (csum_end > start) {
 			size = min(csum_end - start, len);
 			len -= size;
@@ -1726,7 +1728,7 @@ static int process_file_extent(struct btrfs_root *root,
 	u64 num_bytes = 0;
 	u64 disk_bytenr = 0;
 	u64 extent_offset = 0;
-	u64 mask = root->sectorsize - 1;
+	u64 mask = root->fs_info->sectorsize - 1;
 	int extent_type;
 	int ret;
 
@@ -1977,7 +1979,7 @@ static void reada_walk_down(struct btrfs_root *root,
 		return;
 
 	nritems = btrfs_header_nritems(node);
-	blocksize = root->nodesize;
+	blocksize = root->fs_info->nodesize;
 	for (i = slot; i < nritems; i++) {
 		bytenr = btrfs_node_blockptr(node, i);
 		ptr_gen = btrfs_node_ptr_generation(node, i);
@@ -2153,7 +2155,7 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
 		}
 		bytenr = btrfs_node_blockptr(cur, path->slots[*level]);
 		ptr_gen = btrfs_node_ptr_generation(cur, path->slots[*level]);
-		blocksize = root->nodesize;
+		blocksize = root->fs_info->nodesize;
 
 		if (bytenr == nrefs->bytenr[*level - 1]) {
 			refs = nrefs->refs[*level - 1];
@@ -2192,7 +2194,8 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
 				btrfs_add_corrupt_extent_record(root->fs_info,
 						&node_key,
 						path->nodes[*level]->start,
-						root->nodesize, *level);
+						root->fs_info->nodesize,
+						*level);
 				err = -EIO;
 				goto out;
 			}
@@ -2281,7 +2284,7 @@ static int walk_down_tree_v2(struct btrfs_root *root, struct btrfs_path *path,
 		}
 		bytenr = btrfs_node_blockptr(cur, path->slots[*level]);
 		ptr_gen = btrfs_node_ptr_generation(cur, path->slots[*level]);
-		blocksize = root->nodesize;
+		blocksize = root->fs_info->nodesize;
 
 		ret = update_nodes_refs(root, bytenr, nrefs, *level - 1);
 		if (ret)
@@ -2306,7 +2309,8 @@ static int walk_down_tree_v2(struct btrfs_root *root, struct btrfs_path *path,
 				btrfs_add_corrupt_extent_record(root->fs_info,
 						&node_key,
 						path->nodes[*level]->start,
-						root->nodesize, *level);
+						root->fs_info->nodesize,
+						*level);
 				ret = -EIO;
 				break;
 			}
@@ -3232,7 +3236,8 @@ static int repair_inode_discount_extent(struct btrfs_trans_handle *trans,
 	/* special case for a file losing all its file extent */
 	if (!found) {
 		ret = btrfs_punch_hole(trans, root, rec->ino, 0,
-				       round_up(rec->isize, root->sectorsize));
+				       round_up(rec->isize,
+					        root->fs_info->sectorsize));
 		if (ret < 0)
 			goto out;
 	}
@@ -3852,9 +3857,9 @@ static int repair_btree(struct btrfs_root *root,
 		 * return value is not concerned.
 		 */
 		btrfs_release_path(&path);
-		ret = btrfs_free_extent(trans, root, offset, root->nodesize,
-					0, root->root_key.objectid,
-					level - 1, 0);
+		ret = btrfs_free_extent(trans, root, offset,
+				root->fs_info->nodesize, 0,
+				root->root_key.objectid, level - 1, 0);
 		cache = next_cache_extent(cache);
 	}
 
@@ -4981,9 +4986,10 @@ out:
 		 * Just a warning, as dir inode nbytes is just an
 		 * instructive value.
 		 */
-		if (!IS_ALIGNED(nbytes, root->nodesize)) {
+		if (!IS_ALIGNED(nbytes, root->fs_info->nodesize)) {
 			warning("root %llu DIR INODE[%llu] nbytes should be aligned to %u",
-				root->objectid, inode_id, root->nodesize);
+				root->objectid, inode_id,
+				root->fs_info->nodesize);
 		}
 
 		if (isize != size) {
@@ -6103,7 +6109,7 @@ static int add_extent_rec_nolookup(struct cache_tree *extent_cache,
 
 	if (tmpl->metadata)
 		rec->crossing_stripes = check_crossing_stripes(global_info,
-				rec->start, global_info->tree_root->nodesize);
+				rec->start, global_info->nodesize);
 	check_extent_type(rec);
 	return ret;
 }
@@ -6205,7 +6211,7 @@ static int add_extent_rec(struct cache_tree *extent_cache,
 		if (tmpl->metadata)
 			rec->crossing_stripes = check_crossing_stripes(
 					global_info, rec->start,
-					global_info->tree_root->nodesize);
+					global_info->nodesize);
 		check_extent_type(rec);
 		maybe_free_extent_rec(extent_cache, rec);
 		return ret;
@@ -6802,14 +6808,14 @@ static int process_extent_item(struct btrfs_root *root,
 
 	if (key.type == BTRFS_METADATA_ITEM_KEY) {
 		metadata = 1;
-		num_bytes = root->nodesize;
+		num_bytes = root->fs_info->nodesize;
 	} else {
 		num_bytes = key.offset;
 	}
 
-	if (!IS_ALIGNED(key.objectid, root->sectorsize)) {
+	if (!IS_ALIGNED(key.objectid, root->fs_info->sectorsize)) {
 		error("ignoring invalid extent, bytenr %llu is not aligned to %u",
-		      key.objectid, root->sectorsize);
+		      key.objectid, root->fs_info->sectorsize);
 		return -EIO;
 	}
 	if (item_size < sizeof(*ei)) {
@@ -6838,14 +6844,14 @@ static int process_extent_item(struct btrfs_root *root,
 		metadata = 1;
 	else
 		metadata = 0;
-	if (metadata && num_bytes != root->nodesize) {
+	if (metadata && num_bytes != root->fs_info->nodesize) {
 		error("ignore invalid metadata extent, length %llu does not equal to %u",
-		      num_bytes, root->nodesize);
+		      num_bytes, root->fs_info->nodesize);
 		return -EIO;
 	}
-	if (!metadata && !IS_ALIGNED(num_bytes, root->sectorsize)) {
+	if (!metadata && !IS_ALIGNED(num_bytes, root->fs_info->sectorsize)) {
 		error("ignore invalid data extent, length %llu is not aligned to %u",
-		      num_bytes, root->sectorsize);
+		      num_bytes, root->fs_info->sectorsize);
 		return -EIO;
 	}
 
@@ -7053,7 +7059,7 @@ static int verify_space_cache(struct btrfs_root *root,
 			if (key.type == BTRFS_EXTENT_ITEM_KEY)
 				last = key.objectid + key.offset;
 			else
-				last = key.objectid + root->nodesize;
+				last = key.objectid + root->fs_info->nodesize;
 			path.slots[0]++;
 			continue;
 		}
@@ -7065,7 +7071,7 @@ static int verify_space_cache(struct btrfs_root *root,
 		if (key.type == BTRFS_EXTENT_ITEM_KEY)
 			last = key.objectid + key.offset;
 		else
-			last = key.objectid + root->nodesize;
+			last = key.objectid + root->fs_info->nodesize;
 		path.slots[0]++;
 	}
 
@@ -7115,7 +7121,7 @@ static int check_space_cache(struct btrfs_root *root)
 		start = cache->key.objectid + cache->key.offset;
 		if (!cache->free_space_ctl) {
 			if (btrfs_init_free_space_ctl(cache,
-						      root->sectorsize)) {
+						root->fs_info->sectorsize)) {
 				ret = -ENOMEM;
 				break;
 			}
@@ -7176,7 +7182,7 @@ static int check_extent_csums(struct btrfs_root *root, u64 bytenr,
 	int mirror;
 	int num_copies;
 
-	if (num_bytes % root->sectorsize)
+	if (num_bytes % root->fs_info->sectorsize)
 		return -EINVAL;
 
 	data = malloc(num_bytes);
@@ -7199,11 +7205,11 @@ again:
 			tmp = offset + data_checked;
 
 			csum = btrfs_csum_data((char *)data + tmp,
-					       csum, root->sectorsize);
+					       csum, root->fs_info->sectorsize);
 			btrfs_csum_final(csum, (u8 *)&csum);
 
 			csum_offset = leaf_offset +
-				 tmp / root->sectorsize * csum_size;
+				 tmp / root->fs_info->sectorsize * csum_size;
 			read_extent_buffer(eb, (char *)&csum_expected,
 					   csum_offset, csum_size);
 			/* try another mirror */
@@ -7219,7 +7225,7 @@ again:
 					goto again;
 				}
 			}
-			data_checked += root->sectorsize;
+			data_checked += root->fs_info->sectorsize;
 		}
 		offset += read_len;
 	}
@@ -7420,7 +7426,7 @@ static int check_csums(struct btrfs_root *root)
 		}
 
 		data_len = (btrfs_item_size_nr(leaf, path.slots[0]) /
-			      csum_size) * root->sectorsize;
+			      csum_size) * root->fs_info->sectorsize;
 		if (!check_data_csum)
 			goto skip_csum_check;
 		leaf_offset = btrfs_item_ptr_offset(leaf, path.slots[0]);
@@ -7821,7 +7827,7 @@ static int run_next_block(struct btrfs_root *root,
 								       ref),
 					btrfs_extent_data_ref_offset(buf, ref),
 					btrfs_extent_data_ref_count(buf, ref),
-					0, root->sectorsize);
+					0, root->fs_info->sectorsize);
 				continue;
 			}
 			if (key.type == BTRFS_SHARED_DATA_REF_KEY) {
@@ -7831,7 +7837,7 @@ static int run_next_block(struct btrfs_root *root,
 				add_data_backref(extent_cache,
 					key.objectid, key.offset, 0, 0, 0,
 					btrfs_shared_data_ref_count(buf, ref),
-					0, root->sectorsize);
+					0, root->fs_info->sectorsize);
 				continue;
 			}
 			if (key.type == BTRFS_ORPHAN_ITEM_KEY) {
@@ -7863,7 +7869,7 @@ static int run_next_block(struct btrfs_root *root,
 
 			data_bytes_allocated +=
 				btrfs_file_extent_disk_num_bytes(buf, fi);
-			if (data_bytes_allocated < root->sectorsize) {
+			if (data_bytes_allocated < root->fs_info->sectorsize) {
 				abort();
 			}
 			data_bytes_referenced +=
@@ -7887,7 +7893,7 @@ static int run_next_block(struct btrfs_root *root,
 			struct extent_record tmpl;
 
 			ptr = btrfs_node_blockptr(buf, i);
-			size = root->nodesize;
+			size = root->fs_info->nodesize;
 			btrfs_node_key_to_cpu(buf, &key, i);
 			if (ri != NULL) {
 				if ((level == ri->drop_level)
@@ -8113,7 +8119,7 @@ static int delete_extent_records(struct btrfs_trans_handle *trans,
 		if (found_key.type == BTRFS_EXTENT_ITEM_KEY ||
 		    found_key.type == BTRFS_METADATA_ITEM_KEY) {
 			u64 bytes = (found_key.type == BTRFS_EXTENT_ITEM_KEY) ?
-				found_key.offset : root->nodesize;
+				found_key.offset : root->fs_info->nodesize;
 
 			ret = btrfs_update_block_group(trans, root, bytenr,
 						       bytes, 0, 0);
@@ -8147,7 +8153,7 @@ static int record_extent(struct btrfs_trans_handle *trans,
 
 	if (!back->is_data)
 		rec->max_size = max_t(u64, rec->max_size,
-				    info->extent_root->nodesize);
+				    info->nodesize);
 
 	if (!allocated) {
 		u32 item_size = sizeof(*ei);
@@ -9890,14 +9896,14 @@ again:
 	level = btrfs_header_level(root1->node);
 	ret = add_root_item_to_list(&normal_trees, root1->root_key.objectid,
 				    root1->node->start, 0, level, 0,
-				    root1->nodesize, NULL);
+				    root1->fs_info->nodesize, NULL);
 	if (ret < 0)
 		goto out;
 	root1 = root->fs_info->chunk_root;
 	level = btrfs_header_level(root1->node);
 	ret = add_root_item_to_list(&normal_trees, root1->root_key.objectid,
 				    root1->node->start, 0, level, 0,
-				    root1->nodesize, NULL);
+				    root1->fs_info->nodesize, NULL);
 	if (ret < 0)
 		goto out;
 	btrfs_init_path(&path);
@@ -9928,7 +9934,7 @@ again:
 			last_snapshot = btrfs_root_last_snapshot(&ri);
 			if (btrfs_disk_key_objectid(&ri.drop_progress) == 0) {
 				level = btrfs_root_level(&ri);
-				level_size = root->nodesize;
+				level_size = root->fs_info->nodesize;
 				ret = add_root_item_to_list(&normal_trees,
 						found_key.objectid,
 						btrfs_root_bytenr(&ri),
@@ -9938,7 +9944,7 @@ again:
 					goto out;
 			} else {
 				level = btrfs_root_level(&ri);
-				level_size = root->nodesize;
+				level_size = root->fs_info->nodesize;
 				objectid = found_key.objectid;
 				btrfs_disk_key_to_cpu(&found_key,
 						      &ri.drop_progress);
@@ -10065,7 +10071,7 @@ static int check_tree_block_ref(struct btrfs_root *root,
 	int slot;
 	int skinny_level;
 	int type;
-	u32 nodesize = root->nodesize;
+	u32 nodesize = root->fs_info->nodesize;
 	u32 item_size;
 	u64 offset;
 	int tree_reloc_root = 0;
@@ -10250,20 +10256,20 @@ static int check_extent_data_item(struct btrfs_root *root,
 	extent_num_bytes = btrfs_file_extent_num_bytes(eb, fi);
 
 	/* Check unaligned disk_num_bytes and num_bytes */
-	if (!IS_ALIGNED(disk_num_bytes, root->sectorsize)) {
+	if (!IS_ALIGNED(disk_num_bytes, root->fs_info->sectorsize)) {
 		error(
 "file extent [%llu, %llu] has unaligned disk num bytes: %llu, should be aligned to %u",
 			fi_key.objectid, fi_key.offset, disk_num_bytes,
-			root->sectorsize);
+			root->fs_info->sectorsize);
 		err |= BYTES_UNALIGNED;
 	} else {
 		data_bytes_allocated += disk_num_bytes;
 	}
-	if (!IS_ALIGNED(extent_num_bytes, root->sectorsize)) {
+	if (!IS_ALIGNED(extent_num_bytes, root->fs_info->sectorsize)) {
 		error(
 "file extent [%llu, %llu] has unaligned num bytes: %llu, should be aligned to %u",
 			fi_key.objectid, fi_key.offset, extent_num_bytes,
-			root->sectorsize);
+			root->fs_info->sectorsize);
 		err |= BYTES_UNALIGNED;
 	} else {
 		data_bytes_referenced += extent_num_bytes;
@@ -10476,7 +10482,7 @@ static int check_tree_block_backref(struct btrfs_fs_info *fs_info, u64 root_id,
 	}
 
 	/* Read out the tree block to get item/node key */
-	eb = read_tree_block(root, bytenr, root->nodesize, 0);
+	eb = read_tree_block(root, bytenr, root->fs_info->nodesize, 0);
 	if (!extent_buffer_uptodate(eb)) {
 		err |= REFERENCER_MISSING;
 		free_extent_buffer(eb);
@@ -11499,7 +11505,7 @@ static int traverse_tree_block(struct btrfs_root *root,
 		 * As a btrfs tree has most 8 levels (0..7), so it's quite safe
 		 * to call the function itself.
 		 */
-		eb = read_tree_block(root, blocknr, root->nodesize, 0);
+		eb = read_tree_block(root, blocknr, root->fs_info->nodesize, 0);
 		if (extent_buffer_uptodate(eb)) {
 			ret = traverse_tree_block(root, eb);
 			err |= ret;
@@ -11590,7 +11596,7 @@ static int btrfs_fsck_reinit_root(struct btrfs_trans_handle *trans,
 		goto init;
 	}
 	c = btrfs_alloc_free_block(trans, root,
-				   root->nodesize,
+				   root->fs_info->nodesize,
 				   root->root_key.objectid,
 				   &disk_key, level, 0, 0);
 	if (IS_ERR(c)) {
@@ -12088,7 +12094,7 @@ static int populate_csum(struct btrfs_trans_handle *trans,
 	int ret = 0;
 
 	while (offset < len) {
-		sectorsize = csum_root->sectorsize;
+		sectorsize = csum_root->fs_info->sectorsize;
 		ret = read_extent_data(csum_root, buf, start + offset,
 				       &sectorsize, 0);
 		if (ret)
@@ -12116,7 +12122,7 @@ static int fill_csum_tree_from_one_fs_root(struct btrfs_trans_handle *trans,
 	int slot = 0;
 	int ret = 0;
 
-	buf = malloc(cur_root->fs_info->csum_root->sectorsize);
+	buf = malloc(cur_root->fs_info->sectorsize);
 	if (!buf)
 		return -ENOMEM;
 
@@ -12248,7 +12254,7 @@ static int fill_csum_tree_from_extent(struct btrfs_trans_handle *trans,
 		return ret;
 	}
 
-	buf = malloc(csum_root->sectorsize);
+	buf = malloc(csum_root->fs_info->sectorsize);
 	if (!buf) {
 		btrfs_release_path(&path);
 		return -ENOMEM;
-- 
2.13.0



