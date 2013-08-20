Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:38155 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab3HTLUl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Aug 2013 07:20:41 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chris Mason <chris.mason@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 01/12] Btrfs: Remove superfluous casts from u64 to unsigned long long
Date: Tue, 20 Aug 2013 13:20:07 +0200
Message-Id: <1376997618-13573-2-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1376997618-13573-1-git-send-email-geert@linux-m68k.org>
References: <1376997618-13573-1-git-send-email-geert@linux-m68k.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

u64 is "unsigned long long" on all architectures now, so there's no need to
cast it when formatting it using the "ll" length modifier.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 fs/btrfs/backref.c          |   24 ++--
 fs/btrfs/check-integrity.c  |  294 ++++++++++++++-----------------------------
 fs/btrfs/compression.c      |    5 +-
 fs/btrfs/ctree.c            |    6 +-
 fs/btrfs/delayed-inode.c    |   10 +-
 fs/btrfs/dev-replace.c      |    2 +-
 fs/btrfs/disk-io.c          |   25 ++--
 fs/btrfs/extent-tree.c      |   47 +++----
 fs/btrfs/extent_io.c        |   30 ++---
 fs/btrfs/file-item.c        |    4 +-
 fs/btrfs/free-space-cache.c |    6 +-
 fs/btrfs/inode.c            |   24 ++--
 fs/btrfs/ioctl.c            |   10 +-
 fs/btrfs/ordered-data.c     |   11 +-
 fs/btrfs/print-tree.c       |   80 +++++-------
 fs/btrfs/qgroup.c           |   10 +-
 fs/btrfs/relocation.c       |    7 +-
 fs/btrfs/root-tree.c        |    3 +-
 fs/btrfs/scrub.c            |   16 +--
 fs/btrfs/super.c            |   10 +-
 fs/btrfs/transaction.c      |    3 +-
 fs/btrfs/volumes.c          |   19 ++-
 22 files changed, 222 insertions(+), 424 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 8bc5e8c..c1a518e 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -295,10 +295,9 @@ static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
 	ret = btrfs_search_old_slot(root, &ref->key_for_search, path, time_seq);
 	pr_debug("search slot in root %llu (level %d, ref count %d) returned "
 		 "%d for key (%llu %u %llu)\n",
-		 (unsigned long long)ref->root_id, level, ref->count, ret,
-		 (unsigned long long)ref->key_for_search.objectid,
-		 ref->key_for_search.type,
-		 (unsigned long long)ref->key_for_search.offset);
+		 ref->root_id, level, ref->count, ret,
+		 ref->key_for_search.objectid, ref->key_for_search.type,
+		 ref->key_for_search.offset);
 	if (ret < 0)
 		goto out;
 
@@ -1326,8 +1325,7 @@ int extent_from_logical(struct btrfs_fs_info *fs_info, u64 logical,
 	     found_key->type != BTRFS_METADATA_ITEM_KEY) ||
 	    found_key->objectid > logical ||
 	    found_key->objectid + size <= logical) {
-		pr_debug("logical %llu is not within any extent\n",
-			 (unsigned long long)logical);
+		pr_debug("logical %llu is not within any extent\n", logical);
 		return -ENOENT;
 	}
 
@@ -1340,11 +1338,8 @@ int extent_from_logical(struct btrfs_fs_info *fs_info, u64 logical,
 
 	pr_debug("logical %llu is at position %llu within the extent (%llu "
 		 "EXTENT_ITEM %llu) flags %#llx size %u\n",
-		 (unsigned long long)logical,
-		 (unsigned long long)(logical - found_key->objectid),
-		 (unsigned long long)found_key->objectid,
-		 (unsigned long long)found_key->offset,
-		 (unsigned long long)flags, item_size);
+		 logical, logical - found_key->objectid, found_key->objectid,
+		 found_key->offset, flags, item_size);
 
 	WARN_ON(!flags_ret);
 	if (flags_ret) {
@@ -1516,7 +1511,7 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 		while (!ret && (root_node = ulist_next(roots, &root_uiter))) {
 			pr_debug("root %llu references leaf %llu, data list "
 				 "%#llx\n", root_node->val, ref_node->val,
-				 (long long)ref_node->aux);
+				 ref_node->aux);
 			ret = iterate_leaf_refs((struct extent_inode_elem *)
 						(uintptr_t)ref_node->aux,
 						root_node->val,
@@ -1608,9 +1603,8 @@ static int iterate_inode_refs(u64 inum, struct btrfs_root *fs_root,
 			name_len = btrfs_inode_ref_name_len(eb, iref);
 			/* path must be released before calling iterate()! */
 			pr_debug("following ref at offset %u for inode %llu in "
-				 "tree %llu\n", cur,
-				 (unsigned long long)found_key.objectid,
-				 (unsigned long long)fs_root->objectid);
+				 "tree %llu\n", cur, found_key.objectid,
+				 fs_root->objectid);
 			ret = iterate(parent, name_len,
 				      (unsigned long)(iref + 1), eb, ctx);
 			if (ret)
diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 1431a69..4bf75bb 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -701,15 +701,13 @@ static int btrfsic_process_superblock(struct btrfsic_state *state,
 			next_bytenr = btrfs_super_root(selected_super);
 			if (state->print_mask &
 			    BTRFSIC_PRINT_MASK_ROOT_CHUNK_LOG_TREE_LOCATION)
-				printk(KERN_INFO "root@%llu\n",
-				       (unsigned long long)next_bytenr);
+				printk(KERN_INFO "root@%llu\n", next_bytenr);
 			break;
 		case 1:
 			next_bytenr = btrfs_super_chunk_root(selected_super);
 			if (state->print_mask &
 			    BTRFSIC_PRINT_MASK_ROOT_CHUNK_LOG_TREE_LOCATION)
-				printk(KERN_INFO "chunk@%llu\n",
-				       (unsigned long long)next_bytenr);
+				printk(KERN_INFO "chunk@%llu\n", next_bytenr);
 			break;
 		case 2:
 			next_bytenr = btrfs_super_log_root(selected_super);
@@ -717,8 +715,7 @@ static int btrfsic_process_superblock(struct btrfsic_state *state,
 				continue;
 			if (state->print_mask &
 			    BTRFSIC_PRINT_MASK_ROOT_CHUNK_LOG_TREE_LOCATION)
-				printk(KERN_INFO "log@%llu\n",
-				       (unsigned long long)next_bytenr);
+				printk(KERN_INFO "log@%llu\n", next_bytenr);
 			break;
 		}
 
@@ -727,7 +724,7 @@ static int btrfsic_process_superblock(struct btrfsic_state *state,
 				     next_bytenr, state->metablock_size);
 		if (state->print_mask & BTRFSIC_PRINT_MASK_NUM_COPIES)
 			printk(KERN_INFO "num_copies(log_bytenr=%llu) = %d\n",
-			       (unsigned long long)next_bytenr, num_copies);
+			       next_bytenr, num_copies);
 
 		for (mirror_num = 1; mirror_num <= num_copies; mirror_num++) {
 			struct btrfsic_block *next_block;
@@ -742,8 +739,7 @@ static int btrfsic_process_superblock(struct btrfsic_state *state,
 				printk(KERN_INFO "btrfsic:"
 				       " btrfsic_map_block(root @%llu,"
 				       " mirror %d) failed!\n",
-				       (unsigned long long)next_bytenr,
-				       mirror_num);
+				       next_bytenr, mirror_num);
 				kfree(selected_super);
 				return -1;
 			}
@@ -767,7 +763,6 @@ static int btrfsic_process_superblock(struct btrfsic_state *state,
 			if (ret < (int)PAGE_CACHE_SIZE) {
 				printk(KERN_INFO
 				       "btrfsic: read @logical %llu failed!\n",
-				       (unsigned long long)
 				       tmp_next_block_ctx.start);
 				btrfsic_release_block_ctx(&tmp_next_block_ctx);
 				kfree(selected_super);
@@ -847,10 +842,8 @@ static int btrfsic_process_superblock_dev_mirror(
 			printk_in_rcu(KERN_INFO "New initial S-block (bdev %p, %s)"
 				     " @%llu (%s/%llu/%d)\n",
 				     superblock_bdev,
-				     rcu_str_deref(device->name),
-				     (unsigned long long)dev_bytenr,
-				     dev_state->name,
-				     (unsigned long long)dev_bytenr,
+				     rcu_str_deref(device->name), dev_bytenr,
+				     dev_state->name, dev_bytenr,
 				     superblock_mirror_num);
 		list_add(&superblock_tmp->all_blocks_node,
 			 &state->all_blocks_list);
@@ -906,7 +899,7 @@ static int btrfsic_process_superblock_dev_mirror(
 				     next_bytenr, state->metablock_size);
 		if (state->print_mask & BTRFSIC_PRINT_MASK_NUM_COPIES)
 			printk(KERN_INFO "num_copies(log_bytenr=%llu) = %d\n",
-			       (unsigned long long)next_bytenr, num_copies);
+			       next_bytenr, num_copies);
 		for (mirror_num = 1; mirror_num <= num_copies; mirror_num++) {
 			struct btrfsic_block *next_block;
 			struct btrfsic_block_data_ctx tmp_next_block_ctx;
@@ -918,8 +911,7 @@ static int btrfsic_process_superblock_dev_mirror(
 					      mirror_num)) {
 				printk(KERN_INFO "btrfsic: btrfsic_map_block("
 				       "bytenr @%llu, mirror %d) failed!\n",
-				       (unsigned long long)next_bytenr,
-				       mirror_num);
+				       next_bytenr, mirror_num);
 				brelse(bh);
 				return -1;
 			}
@@ -1009,12 +1001,8 @@ continue_with_new_stack_frame:
 				printk(KERN_INFO
 				       "leaf %llu items %d generation %llu"
 				       " owner %llu\n",
-				       (unsigned long long)
-				       sf->block_ctx->start,
-				       sf->nr,
-				       (unsigned long long)
+				       sf->block_ctx->start, sf->nr,
 				       le64_to_cpu(leafhdr->header.generation),
-				       (unsigned long long)
 				       le64_to_cpu(leafhdr->header.owner));
 		}
 
@@ -1135,12 +1123,9 @@ leaf_item_out_of_bounce_error:
 			if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
 				printk(KERN_INFO "node %llu level %d items %d"
 				       " generation %llu owner %llu\n",
-				       (unsigned long long)
 				       sf->block_ctx->start,
 				       nodehdr->header.level, sf->nr,
-				       (unsigned long long)
 				       le64_to_cpu(nodehdr->header.generation),
-				       (unsigned long long)
 				       le64_to_cpu(nodehdr->header.owner));
 		}
 
@@ -1290,7 +1275,7 @@ static int btrfsic_create_link_to_next_block(
 				     next_bytenr, state->metablock_size);
 		if (state->print_mask & BTRFSIC_PRINT_MASK_NUM_COPIES)
 			printk(KERN_INFO "num_copies(log_bytenr=%llu) = %d\n",
-			       (unsigned long long)next_bytenr, *num_copiesp);
+			       next_bytenr, *num_copiesp);
 		*mirror_nump = 1;
 	}
 
@@ -1307,7 +1292,7 @@ static int btrfsic_create_link_to_next_block(
 	if (ret) {
 		printk(KERN_INFO
 		       "btrfsic: btrfsic_map_block(@%llu, mirror=%d) failed!\n",
-		       (unsigned long long)next_bytenr, *mirror_nump);
+		       next_bytenr, *mirror_nump);
 		btrfsic_release_block_ctx(next_block_ctx);
 		*next_blockp = NULL;
 		return -1;
@@ -1335,20 +1320,16 @@ static int btrfsic_create_link_to_next_block(
 			       "Referenced block @%llu (%s/%llu/%d)"
 			       " found in hash table, %c,"
 			       " bytenr mismatch (!= stored %llu).\n",
-			       (unsigned long long)next_bytenr,
-			       next_block_ctx->dev->name,
-			       (unsigned long long)next_block_ctx->dev_bytenr,
-			       *mirror_nump,
+			       next_bytenr, next_block_ctx->dev->name,
+			       next_block_ctx->dev_bytenr, *mirror_nump,
 			       btrfsic_get_block_type(state, next_block),
-			       (unsigned long long)next_block->logical_bytenr);
+			       next_block->logical_bytenr);
 		} else if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
 			printk(KERN_INFO
 			       "Referenced block @%llu (%s/%llu/%d)"
 			       " found in hash table, %c.\n",
-			       (unsigned long long)next_bytenr,
-			       next_block_ctx->dev->name,
-			       (unsigned long long)next_block_ctx->dev_bytenr,
-			       *mirror_nump,
+			       next_bytenr, next_block_ctx->dev->name,
+			       next_block_ctx->dev_bytenr, *mirror_nump,
 			       btrfsic_get_block_type(state, next_block));
 		next_block->logical_bytenr = next_bytenr;
 
@@ -1400,7 +1381,7 @@ static int btrfsic_create_link_to_next_block(
 		if (ret < (int)next_block_ctx->len) {
 			printk(KERN_INFO
 			       "btrfsic: read block @logical %llu failed!\n",
-			       (unsigned long long)next_bytenr);
+			       next_bytenr);
 			btrfsic_release_block_ctx(next_block_ctx);
 			*next_blockp = NULL;
 			return -1;
@@ -1448,7 +1429,6 @@ static int btrfsic_handle_extent_data(
 		if (state->print_mask & BTRFSIC_PRINT_MASK_VERY_VERBOSE)
 			printk(KERN_INFO "extent_data: type %u, disk_bytenr = %llu\n",
 			       file_extent_item.type,
-			       (unsigned long long)
 			       le64_to_cpu(file_extent_item.disk_bytenr));
 		return 0;
 	}
@@ -1473,10 +1453,9 @@ static int btrfsic_handle_extent_data(
 		printk(KERN_INFO "extent_data: type %u, disk_bytenr = %llu,"
 		       " offset = %llu, num_bytes = %llu\n",
 		       file_extent_item.type,
-		       (unsigned long long)
 		       le64_to_cpu(file_extent_item.disk_bytenr),
-		       (unsigned long long)le64_to_cpu(file_extent_item.offset),
-		       (unsigned long long)num_bytes);
+		       le64_to_cpu(file_extent_item.offset),
+		       num_bytes);
 	while (num_bytes > 0) {
 		u32 chunk_len;
 		int num_copies;
@@ -1492,7 +1471,7 @@ static int btrfsic_handle_extent_data(
 				     next_bytenr, state->datablock_size);
 		if (state->print_mask & BTRFSIC_PRINT_MASK_NUM_COPIES)
 			printk(KERN_INFO "num_copies(log_bytenr=%llu) = %d\n",
-			       (unsigned long long)next_bytenr, num_copies);
+			       next_bytenr, num_copies);
 		for (mirror_num = 1; mirror_num <= num_copies; mirror_num++) {
 			struct btrfsic_block_data_ctx next_block_ctx;
 			struct btrfsic_block *next_block;
@@ -1504,8 +1483,7 @@ static int btrfsic_handle_extent_data(
 			if (state->print_mask & BTRFSIC_PRINT_MASK_VERY_VERBOSE)
 				printk(KERN_INFO
 				       "\tdisk_bytenr = %llu, num_bytes %u\n",
-				       (unsigned long long)next_bytenr,
-				       chunk_len);
+				       next_bytenr, chunk_len);
 			ret = btrfsic_map_block(state, next_bytenr,
 						chunk_len, &next_block_ctx,
 						mirror_num);
@@ -1513,8 +1491,7 @@ static int btrfsic_handle_extent_data(
 				printk(KERN_INFO
 				       "btrfsic: btrfsic_map_block(@%llu,"
 				       " mirror=%d) failed!\n",
-				       (unsigned long long)next_bytenr,
-				       mirror_num);
+				       next_bytenr, mirror_num);
 				return -1;
 			}
 
@@ -1543,12 +1520,10 @@ static int btrfsic_handle_extent_data(
 					       " found in hash table, D,"
 					       " bytenr mismatch"
 					       " (!= stored %llu).\n",
-					       (unsigned long long)next_bytenr,
+					       next_bytenr,
 					       next_block_ctx.dev->name,
-					       (unsigned long long)
 					       next_block_ctx.dev_bytenr,
 					       mirror_num,
-					       (unsigned long long)
 					       next_block->logical_bytenr);
 				}
 				next_block->logical_bytenr = next_bytenr;
@@ -1675,7 +1650,7 @@ static int btrfsic_read_block(struct btrfsic_state *state,
 	if (block_ctx->dev_bytenr & ((u64)PAGE_CACHE_SIZE - 1)) {
 		printk(KERN_INFO
 		       "btrfsic: read_block() with unaligned bytenr %llu\n",
-		       (unsigned long long)block_ctx->dev_bytenr);
+		       block_ctx->dev_bytenr);
 		return -1;
 	}
 
@@ -1772,10 +1747,8 @@ static void btrfsic_dump_database(struct btrfsic_state *state)
 
 		printk(KERN_INFO "%c-block @%llu (%s/%llu/%d)\n",
 		       btrfsic_get_block_type(state, b_all),
-		       (unsigned long long)b_all->logical_bytenr,
-		       b_all->dev_state->name,
-		       (unsigned long long)b_all->dev_bytenr,
-		       b_all->mirror_num);
+		       b_all->logical_bytenr, b_all->dev_state->name,
+		       b_all->dev_bytenr, b_all->mirror_num);
 
 		list_for_each(elem_ref_to, &b_all->ref_to_list) {
 			const struct btrfsic_block_link *const l =
@@ -1787,16 +1760,13 @@ static void btrfsic_dump_database(struct btrfsic_state *state)
 			       " refers %u* to"
 			       " %c @%llu (%s/%llu/%d)\n",
 			       btrfsic_get_block_type(state, b_all),
-			       (unsigned long long)b_all->logical_bytenr,
-			       b_all->dev_state->name,
-			       (unsigned long long)b_all->dev_bytenr,
-			       b_all->mirror_num,
+			       b_all->logical_bytenr, b_all->dev_state->name,
+			       b_all->dev_bytenr, b_all->mirror_num,
 			       l->ref_cnt,
 			       btrfsic_get_block_type(state, l->block_ref_to),
-			       (unsigned long long)
 			       l->block_ref_to->logical_bytenr,
 			       l->block_ref_to->dev_state->name,
-			       (unsigned long long)l->block_ref_to->dev_bytenr,
+			       l->block_ref_to->dev_bytenr,
 			       l->block_ref_to->mirror_num);
 		}
 
@@ -1810,16 +1780,12 @@ static void btrfsic_dump_database(struct btrfsic_state *state)
 			       " is ref %u* from"
 			       " %c @%llu (%s/%llu/%d)\n",
 			       btrfsic_get_block_type(state, b_all),
-			       (unsigned long long)b_all->logical_bytenr,
-			       b_all->dev_state->name,
-			       (unsigned long long)b_all->dev_bytenr,
-			       b_all->mirror_num,
+			       b_all->logical_bytenr, b_all->dev_state->name,
+			       b_all->dev_bytenr, b_all->mirror_num,
 			       l->ref_cnt,
 			       btrfsic_get_block_type(state, l->block_ref_from),
-			       (unsigned long long)
 			       l->block_ref_from->logical_bytenr,
 			       l->block_ref_from->dev_state->name,
-			       (unsigned long long)
 			       l->block_ref_from->dev_bytenr,
 			       l->block_ref_from->mirror_num);
 		}
@@ -1935,12 +1901,9 @@ again:
 				       " found in hash table, %c,"
 				       " bytenr mismatch"
 				       " (!= stored %llu).\n",
-				       (unsigned long long)bytenr,
-				       dev_state->name,
-				       (unsigned long long)dev_bytenr,
+				       bytenr, dev_state->name, dev_bytenr,
 				       block->mirror_num,
 				       btrfsic_get_block_type(state, block),
-				       (unsigned long long)
 				       block->logical_bytenr);
 				block->logical_bytenr = bytenr;
 			} else if (state->print_mask &
@@ -1948,9 +1911,7 @@ again:
 				printk(KERN_INFO
 				       "Written block @%llu (%s/%llu/%d)"
 				       " found in hash table, %c.\n",
-				       (unsigned long long)bytenr,
-				       dev_state->name,
-				       (unsigned long long)dev_bytenr,
+				       bytenr, dev_state->name, dev_bytenr,
 				       block->mirror_num,
 				       btrfsic_get_block_type(state, block));
 		} else {
@@ -1966,9 +1927,7 @@ again:
 				printk(KERN_INFO
 				       "Written block @%llu (%s/%llu/%d)"
 				       " found in hash table, %c.\n",
-				       (unsigned long long)bytenr,
-				       dev_state->name,
-				       (unsigned long long)dev_bytenr,
+				       bytenr, dev_state->name, dev_bytenr,
 				       block->mirror_num,
 				       btrfsic_get_block_type(state, block));
 		}
@@ -1985,21 +1944,14 @@ again:
 			       " new(gen=%llu),"
 			       " which is referenced by most recent superblock"
 			       " (superblockgen=%llu)!\n",
-			       btrfsic_get_block_type(state, block),
-			       (unsigned long long)bytenr,
-			       dev_state->name,
-			       (unsigned long long)dev_bytenr,
-			       block->mirror_num,
-			       (unsigned long long)block->generation,
-			       (unsigned long long)
+			       btrfsic_get_block_type(state, block), bytenr,
+			       dev_state->name, dev_bytenr, block->mirror_num,
+			       block->generation,
 			       le64_to_cpu(block->disk_key.objectid),
 			       block->disk_key.type,
-			       (unsigned long long)
 			       le64_to_cpu(block->disk_key.offset),
-			       (unsigned long long)
 			       le64_to_cpu(((struct btrfs_header *)
 					    mapped_datav[0])->generation),
-			       (unsigned long long)
 			       state->max_superblock_generation);
 			btrfsic_dump_tree(state);
 		}
@@ -2008,13 +1960,9 @@ again:
 			printk(KERN_INFO "btrfs: attempt to overwrite %c-block"
 			       " @%llu (%s/%llu/%d), oldgen=%llu, newgen=%llu,"
 			       " which is not yet iodone!\n",
-			       btrfsic_get_block_type(state, block),
-			       (unsigned long long)bytenr,
-			       dev_state->name,
-			       (unsigned long long)dev_bytenr,
-			       block->mirror_num,
-			       (unsigned long long)block->generation,
-			       (unsigned long long)
+			       btrfsic_get_block_type(state, block), bytenr,
+			       dev_state->name, dev_bytenr, block->mirror_num,
+			       block->generation,
 			       le64_to_cpu(((struct btrfs_header *)
 					    mapped_datav[0])->generation));
 			/* it would not be safe to go on */
@@ -2056,7 +2004,7 @@ again:
 		if (ret) {
 			printk(KERN_INFO
 			       "btrfsic: btrfsic_map_block(root @%llu)"
-			       " failed!\n", (unsigned long long)bytenr);
+			       " failed!\n", bytenr);
 			goto continue_loop;
 		}
 		block_ctx.datav = mapped_datav;
@@ -2140,7 +2088,7 @@ again:
 				printk(KERN_INFO
 				       "btrfsic: btrfsic_process_metablock"
 				       "(root @%llu) failed!\n",
-				       (unsigned long long)dev_bytenr);
+				       dev_bytenr);
 		} else {
 			block->is_metadata = 0;
 			block->mirror_num = 0;	/* unknown */
@@ -2168,8 +2116,7 @@ again:
 			if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
 				printk(KERN_INFO "Written block (%s/%llu/?)"
 				       " !found in hash table, D.\n",
-				       dev_state->name,
-				       (unsigned long long)dev_bytenr);
+				       dev_state->name, dev_bytenr);
 			if (!state->include_extent_data) {
 				/* ignore that written D block */
 				goto continue_loop;
@@ -2192,9 +2139,7 @@ again:
 				printk(KERN_INFO
 				       "Written block @%llu (%s/%llu/?)"
 				       " !found in hash table, M.\n",
-				       (unsigned long long)bytenr,
-				       dev_state->name,
-				       (unsigned long long)dev_bytenr);
+				       bytenr, dev_state->name, dev_bytenr);
 
 			ret = btrfsic_map_block(state, bytenr, processed_len,
 						&block_ctx, 0);
@@ -2202,7 +2147,7 @@ again:
 				printk(KERN_INFO
 				       "btrfsic: btrfsic_map_block(root @%llu)"
 				       " failed!\n",
-				       (unsigned long long)dev_bytenr);
+				       dev_bytenr);
 				goto continue_loop;
 			}
 		}
@@ -2267,10 +2212,8 @@ again:
 			printk(KERN_INFO
 			       "New written %c-block @%llu (%s/%llu/%d)\n",
 			       is_metadata ? 'M' : 'D',
-			       (unsigned long long)block->logical_bytenr,
-			       block->dev_state->name,
-			       (unsigned long long)block->dev_bytenr,
-			       block->mirror_num);
+			       block->logical_bytenr, block->dev_state->name,
+			       block->dev_bytenr, block->mirror_num);
 		list_add(&block->all_blocks_node, &state->all_blocks_list);
 		btrfsic_block_hashtable_add(block, &state->block_hashtable);
 
@@ -2281,7 +2224,7 @@ again:
 				printk(KERN_INFO
 				       "btrfsic: process_metablock(root @%llu)"
 				       " failed!\n",
-				       (unsigned long long)dev_bytenr);
+				       dev_bytenr);
 		}
 		btrfsic_release_block_ctx(&block_ctx);
 	}
@@ -2319,10 +2262,8 @@ static void btrfsic_bio_end_io(struct bio *bp, int bio_error_status)
 			       "bio_end_io(err=%d) for %c @%llu (%s/%llu/%d)\n",
 			       bio_error_status,
 			       btrfsic_get_block_type(dev_state->state, block),
-			       (unsigned long long)block->logical_bytenr,
-			       dev_state->name,
-			       (unsigned long long)block->dev_bytenr,
-			       block->mirror_num);
+			       block->logical_bytenr, dev_state->name,
+			       block->dev_bytenr, block->mirror_num);
 		next_block = block->next_in_same_bio;
 		block->iodone_w_error = iodone_w_error;
 		if (block->submit_bio_bh_rw & REQ_FLUSH) {
@@ -2332,7 +2273,6 @@ static void btrfsic_bio_end_io(struct bio *bp, int bio_error_status)
 				printk(KERN_INFO
 				       "bio_end_io() new %s flush_gen=%llu\n",
 				       dev_state->name,
-				       (unsigned long long)
 				       dev_state->last_flush_gen);
 		}
 		if (block->submit_bio_bh_rw & REQ_FUA)
@@ -2358,10 +2298,8 @@ static void btrfsic_bh_end_io(struct buffer_head *bh, int uptodate)
 		       "bh_end_io(error=%d) for %c @%llu (%s/%llu/%d)\n",
 		       iodone_w_error,
 		       btrfsic_get_block_type(dev_state->state, block),
-		       (unsigned long long)block->logical_bytenr,
-		       block->dev_state->name,
-		       (unsigned long long)block->dev_bytenr,
-		       block->mirror_num);
+		       block->logical_bytenr, block->dev_state->name,
+		       block->dev_bytenr, block->mirror_num);
 
 	block->iodone_w_error = iodone_w_error;
 	if (block->submit_bio_bh_rw & REQ_FLUSH) {
@@ -2370,8 +2308,7 @@ static void btrfsic_bh_end_io(struct buffer_head *bh, int uptodate)
 		     BTRFSIC_PRINT_MASK_END_IO_BIO_BH))
 			printk(KERN_INFO
 			       "bh_end_io() new %s flush_gen=%llu\n",
-			       dev_state->name,
-			       (unsigned long long)dev_state->last_flush_gen);
+			       dev_state->name, dev_state->last_flush_gen);
 	}
 	if (block->submit_bio_bh_rw & REQ_FUA)
 		block->flush_gen = 0; /* FUA completed means block is on disk */
@@ -2396,26 +2333,20 @@ static int btrfsic_process_written_superblock(
 			printk(KERN_INFO
 			       "btrfsic: superblock @%llu (%s/%llu/%d)"
 			       " with old gen %llu <= %llu\n",
-			       (unsigned long long)superblock->logical_bytenr,
+			       superblock->logical_bytenr,
 			       superblock->dev_state->name,
-			       (unsigned long long)superblock->dev_bytenr,
-			       superblock->mirror_num,
-			       (unsigned long long)
+			       superblock->dev_bytenr, superblock->mirror_num,
 			       btrfs_super_generation(super_hdr),
-			       (unsigned long long)
 			       state->max_superblock_generation);
 	} else {
 		if (state->print_mask & BTRFSIC_PRINT_MASK_SUPERBLOCK_WRITE)
 			printk(KERN_INFO
 			       "btrfsic: got new superblock @%llu (%s/%llu/%d)"
 			       " with new gen %llu > %llu\n",
-			       (unsigned long long)superblock->logical_bytenr,
+			       superblock->logical_bytenr,
 			       superblock->dev_state->name,
-			       (unsigned long long)superblock->dev_bytenr,
-			       superblock->mirror_num,
-			       (unsigned long long)
+			       superblock->dev_bytenr, superblock->mirror_num,
 			       btrfs_super_generation(super_hdr),
-			       (unsigned long long)
 			       state->max_superblock_generation);
 
 		state->max_superblock_generation =
@@ -2445,8 +2376,7 @@ static int btrfsic_process_written_superblock(
 			next_bytenr = btrfs_super_root(super_hdr);
 			if (state->print_mask &
 			    BTRFSIC_PRINT_MASK_ROOT_CHUNK_LOG_TREE_LOCATION)
-				printk(KERN_INFO "root@%llu\n",
-				       (unsigned long long)next_bytenr);
+				printk(KERN_INFO "root@%llu\n", next_bytenr);
 			break;
 		case 1:
 			tmp_disk_key.objectid =
@@ -2455,8 +2385,7 @@ static int btrfsic_process_written_superblock(
 			next_bytenr = btrfs_super_chunk_root(super_hdr);
 			if (state->print_mask &
 			    BTRFSIC_PRINT_MASK_ROOT_CHUNK_LOG_TREE_LOCATION)
-				printk(KERN_INFO "chunk@%llu\n",
-				       (unsigned long long)next_bytenr);
+				printk(KERN_INFO "chunk@%llu\n", next_bytenr);
 			break;
 		case 2:
 			tmp_disk_key.objectid =
@@ -2467,8 +2396,7 @@ static int btrfsic_process_written_superblock(
 				continue;
 			if (state->print_mask &
 			    BTRFSIC_PRINT_MASK_ROOT_CHUNK_LOG_TREE_LOCATION)
-				printk(KERN_INFO "log@%llu\n",
-				       (unsigned long long)next_bytenr);
+				printk(KERN_INFO "log@%llu\n", next_bytenr);
 			break;
 		}
 
@@ -2477,7 +2405,7 @@ static int btrfsic_process_written_superblock(
 				     next_bytenr, BTRFS_SUPER_INFO_SIZE);
 		if (state->print_mask & BTRFSIC_PRINT_MASK_NUM_COPIES)
 			printk(KERN_INFO "num_copies(log_bytenr=%llu) = %d\n",
-			       (unsigned long long)next_bytenr, num_copies);
+			       next_bytenr, num_copies);
 		for (mirror_num = 1; mirror_num <= num_copies; mirror_num++) {
 			int was_created;
 
@@ -2493,8 +2421,7 @@ static int btrfsic_process_written_superblock(
 				printk(KERN_INFO
 				       "btrfsic: btrfsic_map_block(@%llu,"
 				       " mirror=%d) failed!\n",
-				       (unsigned long long)next_bytenr,
-				       mirror_num);
+				       next_bytenr, mirror_num);
 				return -1;
 			}
 
@@ -2579,26 +2506,22 @@ static int btrfsic_check_all_ref_blocks(struct btrfsic_state *state,
 			       " %u* refers to %c @%llu (%s/%llu/%d)\n",
 			       recursion_level,
 			       btrfsic_get_block_type(state, block),
-			       (unsigned long long)block->logical_bytenr,
-			       block->dev_state->name,
-			       (unsigned long long)block->dev_bytenr,
-			       block->mirror_num,
+			       block->logical_bytenr, block->dev_state->name,
+			       block->dev_bytenr, block->mirror_num,
 			       l->ref_cnt,
 			       btrfsic_get_block_type(state, l->block_ref_to),
-			       (unsigned long long)
 			       l->block_ref_to->logical_bytenr,
 			       l->block_ref_to->dev_state->name,
-			       (unsigned long long)l->block_ref_to->dev_bytenr,
+			       l->block_ref_to->dev_bytenr,
 			       l->block_ref_to->mirror_num);
 		if (l->block_ref_to->never_written) {
 			printk(KERN_INFO "btrfs: attempt to write superblock"
 			       " which references block %c @%llu (%s/%llu/%d)"
 			       " which is never written!\n",
 			       btrfsic_get_block_type(state, l->block_ref_to),
-			       (unsigned long long)
 			       l->block_ref_to->logical_bytenr,
 			       l->block_ref_to->dev_state->name,
-			       (unsigned long long)l->block_ref_to->dev_bytenr,
+			       l->block_ref_to->dev_bytenr,
 			       l->block_ref_to->mirror_num);
 			ret = -1;
 		} else if (!l->block_ref_to->is_iodone) {
@@ -2606,10 +2529,9 @@ static int btrfsic_check_all_ref_blocks(struct btrfsic_state *state,
 			       " which references block %c @%llu (%s/%llu/%d)"
 			       " which is not yet iodone!\n",
 			       btrfsic_get_block_type(state, l->block_ref_to),
-			       (unsigned long long)
 			       l->block_ref_to->logical_bytenr,
 			       l->block_ref_to->dev_state->name,
-			       (unsigned long long)l->block_ref_to->dev_bytenr,
+			       l->block_ref_to->dev_bytenr,
 			       l->block_ref_to->mirror_num);
 			ret = -1;
 		} else if (l->block_ref_to->iodone_w_error) {
@@ -2617,10 +2539,9 @@ static int btrfsic_check_all_ref_blocks(struct btrfsic_state *state,
 			       " which references block %c @%llu (%s/%llu/%d)"
 			       " which has write error!\n",
 			       btrfsic_get_block_type(state, l->block_ref_to),
-			       (unsigned long long)
 			       l->block_ref_to->logical_bytenr,
 			       l->block_ref_to->dev_state->name,
-			       (unsigned long long)l->block_ref_to->dev_bytenr,
+			       l->block_ref_to->dev_bytenr,
 			       l->block_ref_to->mirror_num);
 			ret = -1;
 		} else if (l->parent_generation !=
@@ -2634,13 +2555,12 @@ static int btrfsic_check_all_ref_blocks(struct btrfsic_state *state,
 			       " with generation %llu !="
 			       " parent generation %llu!\n",
 			       btrfsic_get_block_type(state, l->block_ref_to),
-			       (unsigned long long)
 			       l->block_ref_to->logical_bytenr,
 			       l->block_ref_to->dev_state->name,
-			       (unsigned long long)l->block_ref_to->dev_bytenr,
+			       l->block_ref_to->dev_bytenr,
 			       l->block_ref_to->mirror_num,
-			       (unsigned long long)l->block_ref_to->generation,
-			       (unsigned long long)l->parent_generation);
+			       l->block_ref_to->generation,
+			       l->parent_generation);
 			ret = -1;
 		} else if (l->block_ref_to->flush_gen >
 			   l->block_ref_to->dev_state->last_flush_gen) {
@@ -2650,13 +2570,10 @@ static int btrfsic_check_all_ref_blocks(struct btrfsic_state *state,
 			       " (block flush_gen=%llu,"
 			       " dev->flush_gen=%llu)!\n",
 			       btrfsic_get_block_type(state, l->block_ref_to),
-			       (unsigned long long)
 			       l->block_ref_to->logical_bytenr,
 			       l->block_ref_to->dev_state->name,
-			       (unsigned long long)l->block_ref_to->dev_bytenr,
-			       l->block_ref_to->mirror_num,
-			       (unsigned long long)block->flush_gen,
-			       (unsigned long long)
+			       l->block_ref_to->dev_bytenr,
+			       l->block_ref_to->mirror_num, block->flush_gen,
 			       l->block_ref_to->dev_state->last_flush_gen);
 			ret = -1;
 		} else if (-1 == btrfsic_check_all_ref_blocks(state,
@@ -2701,16 +2618,12 @@ static int btrfsic_is_block_ref_by_superblock(
 			       " is ref %u* from %c @%llu (%s/%llu/%d)\n",
 			       recursion_level,
 			       btrfsic_get_block_type(state, block),
-			       (unsigned long long)block->logical_bytenr,
-			       block->dev_state->name,
-			       (unsigned long long)block->dev_bytenr,
-			       block->mirror_num,
+			       block->logical_bytenr, block->dev_state->name,
+			       block->dev_bytenr, block->mirror_num,
 			       l->ref_cnt,
 			       btrfsic_get_block_type(state, l->block_ref_from),
-			       (unsigned long long)
 			       l->block_ref_from->logical_bytenr,
 			       l->block_ref_from->dev_state->name,
-			       (unsigned long long)
 			       l->block_ref_from->dev_bytenr,
 			       l->block_ref_from->mirror_num);
 		if (l->block_ref_from->is_superblock &&
@@ -2737,14 +2650,12 @@ static void btrfsic_print_add_link(const struct btrfsic_state *state,
 	       " to %c @%llu (%s/%llu/%d).\n",
 	       l->ref_cnt,
 	       btrfsic_get_block_type(state, l->block_ref_from),
-	       (unsigned long long)l->block_ref_from->logical_bytenr,
+	       l->block_ref_from->logical_bytenr,
 	       l->block_ref_from->dev_state->name,
-	       (unsigned long long)l->block_ref_from->dev_bytenr,
-	       l->block_ref_from->mirror_num,
+	       l->block_ref_from->dev_bytenr, l->block_ref_from->mirror_num,
 	       btrfsic_get_block_type(state, l->block_ref_to),
-	       (unsigned long long)l->block_ref_to->logical_bytenr,
-	       l->block_ref_to->dev_state->name,
-	       (unsigned long long)l->block_ref_to->dev_bytenr,
+	       l->block_ref_to->logical_bytenr,
+	       l->block_ref_to->dev_state->name, l->block_ref_to->dev_bytenr,
 	       l->block_ref_to->mirror_num);
 }
 
@@ -2756,14 +2667,12 @@ static void btrfsic_print_rem_link(const struct btrfsic_state *state,
 	       " to %c @%llu (%s/%llu/%d).\n",
 	       l->ref_cnt,
 	       btrfsic_get_block_type(state, l->block_ref_from),
-	       (unsigned long long)l->block_ref_from->logical_bytenr,
+	       l->block_ref_from->logical_bytenr,
 	       l->block_ref_from->dev_state->name,
-	       (unsigned long long)l->block_ref_from->dev_bytenr,
-	       l->block_ref_from->mirror_num,
+	       l->block_ref_from->dev_bytenr, l->block_ref_from->mirror_num,
 	       btrfsic_get_block_type(state, l->block_ref_to),
-	       (unsigned long long)l->block_ref_to->logical_bytenr,
-	       l->block_ref_to->dev_state->name,
-	       (unsigned long long)l->block_ref_to->dev_bytenr,
+	       l->block_ref_to->logical_bytenr,
+	       l->block_ref_to->dev_state->name, l->block_ref_to->dev_bytenr,
 	       l->block_ref_to->mirror_num);
 }
 
@@ -2807,10 +2716,8 @@ static void btrfsic_dump_tree_sub(const struct btrfsic_state *state,
 	 */
 	indent_add = sprintf(buf, "%c-%llu(%s/%llu/%d)",
 			     btrfsic_get_block_type(state, block),
-			     (unsigned long long)block->logical_bytenr,
-			     block->dev_state->name,
-			     (unsigned long long)block->dev_bytenr,
-			     block->mirror_num);
+			     block->logical_bytenr, block->dev_state->name,
+			     block->dev_bytenr, block->mirror_num);
 	if (indent_level + indent_add > BTRFSIC_TREE_DUMP_MAX_INDENT_LEVEL) {
 		printk("[...]\n");
 		return;
@@ -2943,10 +2850,8 @@ static struct btrfsic_block *btrfsic_block_lookup_or_add(
 			       "New %s%c-block @%llu (%s/%llu/%d)\n",
 			       additional_string,
 			       btrfsic_get_block_type(state, block),
-			       (unsigned long long)block->logical_bytenr,
-			       dev_state->name,
-			       (unsigned long long)block->dev_bytenr,
-			       mirror_num);
+			       block->logical_bytenr, dev_state->name,
+			       block->dev_bytenr, mirror_num);
 		list_add(&block->all_blocks_node, &state->all_blocks_list);
 		btrfsic_block_hashtable_add(block, &state->block_hashtable);
 		if (NULL != was_created)
@@ -2980,7 +2885,7 @@ static void btrfsic_cmp_log_and_dev_bytenr(struct btrfsic_state *state,
 			printk(KERN_INFO "btrfsic:"
 			       " btrfsic_map_block(logical @%llu,"
 			       " mirror %d) failed!\n",
-			       (unsigned long long)bytenr, mirror_num);
+			       bytenr, mirror_num);
 			continue;
 		}
 
@@ -2997,8 +2902,7 @@ static void btrfsic_cmp_log_and_dev_bytenr(struct btrfsic_state *state,
 		printk(KERN_INFO "btrfs: attempt to write M-block which contains logical bytenr that doesn't map to dev+physical bytenr of submit_bio,"
 		       " buffer->log_bytenr=%llu, submit_bio(bdev=%s,"
 		       " phys_bytenr=%llu)!\n",
-		       (unsigned long long)bytenr, dev_state->name,
-		       (unsigned long long)dev_bytenr);
+		       bytenr, dev_state->name, dev_bytenr);
 		for (mirror_num = 1; mirror_num <= num_copies; mirror_num++) {
 			ret = btrfsic_map_block(state, bytenr,
 						state->metablock_size,
@@ -3008,10 +2912,8 @@ static void btrfsic_cmp_log_and_dev_bytenr(struct btrfsic_state *state,
 
 			printk(KERN_INFO "Read logical bytenr @%llu maps to"
 			       " (%s/%llu/%d)\n",
-			       (unsigned long long)bytenr,
-			       block_ctx.dev->name,
-			       (unsigned long long)block_ctx.dev_bytenr,
-			       mirror_num);
+			       bytenr, block_ctx.dev->name,
+			       block_ctx.dev_bytenr, mirror_num);
 		}
 		WARN_ON(1);
 	}
@@ -3050,8 +2952,7 @@ int btrfsic_submit_bh(int rw, struct buffer_head *bh)
 			printk(KERN_INFO
 			       "submit_bh(rw=0x%x, blocknr=%lu (bytenr %llu),"
 			       " size=%lu, data=%p, bdev=%p)\n",
-			       rw, (unsigned long)bh->b_blocknr,
-			       (unsigned long long)dev_bytenr,
+			       rw, (unsigned long)bh->b_blocknr, dev_bytenr,
 			       (unsigned long)bh->b_size, bh->b_data,
 			       bh->b_bdev);
 		btrfsic_process_written_block(dev_state, dev_bytenr,
@@ -3120,8 +3021,7 @@ void btrfsic_submit_bio(int rw, struct bio *bio)
 			       "submit_bio(rw=0x%x, bi_vcnt=%u,"
 			       " bi_sector=%lu (bytenr %llu), bi_bdev=%p)\n",
 			       rw, bio->bi_vcnt, (unsigned long)bio->bi_sector,
-			       (unsigned long long)dev_bytenr,
-			       bio->bi_bdev);
+			       dev_bytenr, bio->bi_bdev);
 
 		mapped_datav = kmalloc(sizeof(*mapped_datav) * bio->bi_vcnt,
 				       GFP_NOFS);
@@ -3369,10 +3269,8 @@ void btrfsic_unmount(struct btrfs_root *root,
 			       " @%llu (%s/%llu/%d) on umount which is"
 			       " not yet iodone!\n",
 			       btrfsic_get_block_type(state, b_all),
-			       (unsigned long long)b_all->logical_bytenr,
-			       b_all->dev_state->name,
-			       (unsigned long long)b_all->dev_bytenr,
-			       b_all->mirror_num);
+			       b_all->logical_bytenr, b_all->dev_state->name,
+			       b_all->dev_bytenr, b_all->mirror_num);
 	}
 
 	mutex_unlock(&btrfsic_mutex);
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index b189bd1..94b88cd 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -132,9 +132,8 @@ static int check_compressed_csum(struct inode *inode,
 			printk(KERN_INFO "btrfs csum failed ino %llu "
 			       "extent %llu csum %u "
 			       "wanted %u mirror %d\n",
-			       (unsigned long long)btrfs_ino(inode),
-			       (unsigned long long)disk_start,
-			       csum, *cb_sum, cb->mirror_num);
+			       btrfs_ino(inode), disk_start, csum, *cb_sum,
+			       cb->mirror_num);
 			ret = -EIO;
 			goto fail;
 		}
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index ed50460..b208df3 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1419,14 +1419,12 @@ noinline int btrfs_cow_block(struct btrfs_trans_handle *trans,
 
 	if (trans->transaction != root->fs_info->running_transaction)
 		WARN(1, KERN_CRIT "trans %llu running %llu\n",
-		       (unsigned long long)trans->transid,
-		       (unsigned long long)
+		       trans->transid,
 		       root->fs_info->running_transaction->transid);
 
 	if (trans->transid != root->fs_info->generation)
 		WARN(1, KERN_CRIT "trans %llu running %llu\n",
-		       (unsigned long long)trans->transid,
-		       (unsigned long long)root->fs_info->generation);
+		       trans->transid, root->fs_info->generation);
 
 	if (!should_cow_block(trans, root, buf)) {
 		*cow_ret = buf;
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 3755109..02cf3b0 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1473,10 +1473,8 @@ int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
 		printk(KERN_ERR "err add delayed dir index item(name: %s) into "
 				"the insertion tree of the delayed node"
 				"(root id: %llu, inode id: %llu, errno: %d)\n",
-				name,
-				(unsigned long long)delayed_node->root->objectid,
-				(unsigned long long)delayed_node->inode_id,
-				ret);
+				name, delayed_node->root->objectid,
+				delayed_node->inode_id, ret);
 		BUG();
 	}
 	mutex_unlock(&delayed_node->mutex);
@@ -1547,9 +1545,7 @@ int btrfs_delete_delayed_dir_index(struct btrfs_trans_handle *trans,
 		printk(KERN_ERR "err add delayed dir index item(index: %llu) "
 				"into the deletion tree of the delayed node"
 				"(root id: %llu, inode id: %llu, errno: %d)\n",
-				(unsigned long long)index,
-				(unsigned long long)node->root->objectid,
-				(unsigned long long)node->inode_id,
+				index, node->root->objectid, node->inode_id,
 				ret);
 		BUG();
 	}
diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 4253ad5..e34e72f 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -148,7 +148,7 @@ no_valid_dev_replace_entry_found:
 		    !btrfs_test_opt(dev_root, DEGRADED)) {
 			ret = -EIO;
 			pr_warn("btrfs: cannot mount because device replace operation is ongoing and\n" "srcdev (devid %llu) is missing, need to run 'btrfs dev scan'?\n",
-				(unsigned long long)src_devid);
+				src_devid);
 		}
 		if (!dev_replace->tgtdev &&
 		    !btrfs_test_opt(dev_root, DEGRADED)) {
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6b092a1..e5a68d2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -302,9 +302,8 @@ static int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 			printk_ratelimited(KERN_INFO "btrfs: %s checksum verify "
 				       "failed on %llu wanted %X found %X "
 				       "level %d\n",
-				       root->fs_info->sb->s_id,
-				       (unsigned long long)buf->start, val, found,
-				       btrfs_header_level(buf));
+				       root->fs_info->sb->s_id, buf->start,
+				       val, found, btrfs_header_level(buf));
 			if (result != (char *)&inline_result)
 				kfree(result);
 			return 1;
@@ -345,9 +344,7 @@ static int verify_parent_transid(struct extent_io_tree *io_tree,
 	}
 	printk_ratelimited("parent transid verify failed on %llu wanted %llu "
 		       "found %llu\n",
-		       (unsigned long long)eb->start,
-		       (unsigned long long)parent_transid,
-		       (unsigned long long)btrfs_header_generation(eb));
+		       eb->start, parent_transid, btrfs_header_generation(eb));
 	ret = 1;
 	clear_extent_buffer_uptodate(eb);
 out:
@@ -512,8 +509,7 @@ static int check_tree_block_fsid(struct btrfs_root *root,
 #define CORRUPT(reason, eb, root, slot)				\
 	printk(KERN_CRIT "btrfs: corrupt leaf, %s: block=%llu,"	\
 	       "root=%llu, slot=%d\n", reason,			\
-	       (unsigned long long)btrfs_header_bytenr(eb),	\
-	       (unsigned long long)root->objectid, slot)
+	       btrfs_header_bytenr(eb),	root->objectid, slot)
 
 static noinline int check_leaf(struct btrfs_root *root,
 			       struct extent_buffer *leaf)
@@ -612,14 +608,13 @@ static int btree_readpage_end_io_hook(struct page *page, u64 start, u64 end,
 	if (found_start != eb->start) {
 		printk_ratelimited(KERN_INFO "btrfs bad tree block start "
 			       "%llu %llu\n",
-			       (unsigned long long)found_start,
-			       (unsigned long long)eb->start);
+			       found_start, eb->start);
 		ret = -EIO;
 		goto err;
 	}
 	if (check_tree_block_fsid(root, eb)) {
 		printk_ratelimited(KERN_INFO "btrfs bad fsid on block %llu\n",
-			       (unsigned long long)eb->start);
+			       eb->start);
 		ret = -EIO;
 		goto err;
 	}
@@ -2383,7 +2378,7 @@ int open_ctree(struct super_block *sb,
 	if (features) {
 		printk(KERN_ERR "BTRFS: couldn't mount because of "
 		       "unsupported optional features (%Lx).\n",
-		       (unsigned long long)features);
+		       features);
 		err = -EINVAL;
 		goto fail_alloc;
 	}
@@ -2453,7 +2448,7 @@ int open_ctree(struct super_block *sb,
 	if (!(sb->s_flags & MS_RDONLY) && features) {
 		printk(KERN_ERR "BTRFS: couldn't mount RDWR because of "
 		       "unsupported option features (%Lx).\n",
-		       (unsigned long long)features);
+		       features);
 		err = -EINVAL;
 		goto fail_alloc;
 	}
@@ -3608,9 +3603,7 @@ void btrfs_mark_buffer_dirty(struct extent_buffer *buf)
 	if (transid != root->fs_info->generation)
 		WARN(1, KERN_CRIT "btrfs transid mismatch buffer %llu, "
 		       "found %llu running %llu\n",
-			(unsigned long long)buf->start,
-			(unsigned long long)transid,
-			(unsigned long long)root->fs_info->generation);
+			buf->start, transid, root->fs_info->generation);
 	was_dirty = set_extent_buffer_dirty(buf);
 	if (!was_dirty)
 		__percpu_counter_add(&root->fs_info->dirty_metadata_bytes,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 1204c8e..cae69c7 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5668,7 +5668,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 
 			if (ret) {
 				btrfs_err(info, "umm, got %d back from search, was looking for %llu",
-					ret, (unsigned long long)bytenr);
+					ret, bytenr);
 				if (ret > 0)
 					btrfs_print_leaf(extent_root,
 							 path->nodes[0]);
@@ -5684,11 +5684,8 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 		WARN_ON(1);
 		btrfs_err(info,
 			"unable to find ref byte nr %llu parent %llu root %llu  owner %llu offset %llu",
-			(unsigned long long)bytenr,
-			(unsigned long long)parent,
-			(unsigned long long)root_objectid,
-			(unsigned long long)owner_objectid,
-			(unsigned long long)owner_offset);
+			bytenr, parent, root_objectid, owner_objectid,
+			owner_offset);
 	} else {
 		btrfs_abort_transaction(trans, extent_root, ret);
 		goto out;
@@ -5717,7 +5714,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 					-1, 1);
 		if (ret) {
 			btrfs_err(info, "umm, got %d back from search, was looking for %llu",
-				ret, (unsigned long long)bytenr);
+				ret, bytenr);
 			btrfs_print_leaf(extent_root, path->nodes[0]);
 		}
 		if (ret < 0) {
@@ -6463,19 +6460,15 @@ static void dump_space_info(struct btrfs_space_info *info, u64 bytes,
 
 	spin_lock(&info->lock);
 	printk(KERN_INFO "space_info %llu has %llu free, is %sfull\n",
-	       (unsigned long long)info->flags,
-	       (unsigned long long)(info->total_bytes - info->bytes_used -
-				    info->bytes_pinned - info->bytes_reserved -
-				    info->bytes_readonly),
+	       info->flags,
+	       info->total_bytes - info->bytes_used - info->bytes_pinned -
+	       info->bytes_reserved - info->bytes_readonly,
 	       (info->full) ? "" : "not ");
 	printk(KERN_INFO "space_info total=%llu, used=%llu, pinned=%llu, "
 	       "reserved=%llu, may_use=%llu, readonly=%llu\n",
-	       (unsigned long long)info->total_bytes,
-	       (unsigned long long)info->bytes_used,
-	       (unsigned long long)info->bytes_pinned,
-	       (unsigned long long)info->bytes_reserved,
-	       (unsigned long long)info->bytes_may_use,
-	       (unsigned long long)info->bytes_readonly);
+	       info->total_bytes, info->bytes_used, info->bytes_pinned,
+	       info->bytes_reserved, info->bytes_may_use,
+	       info->bytes_readonly);
 	spin_unlock(&info->lock);
 
 	if (!dump_block_groups)
@@ -6486,12 +6479,9 @@ again:
 	list_for_each_entry(cache, &info->block_groups[index], list) {
 		spin_lock(&cache->lock);
 		printk(KERN_INFO "block group %llu has %llu bytes, %llu used %llu pinned %llu reserved %s\n",
-		       (unsigned long long)cache->key.objectid,
-		       (unsigned long long)cache->key.offset,
-		       (unsigned long long)btrfs_block_group_used(&cache->item),
-		       (unsigned long long)cache->pinned,
-		       (unsigned long long)cache->reserved,
-		       cache->ro ? "[readonly]" : "");
+		       cache->key.objectid, cache->key.offset,
+		       btrfs_block_group_used(&cache->item), cache->pinned,
+		       cache->reserved, cache->ro ? "[readonly]" : "");
 		btrfs_dump_free_space(cache, bytes);
 		spin_unlock(&cache->lock);
 	}
@@ -6529,8 +6519,7 @@ again:
 
 			sinfo = __find_space_info(root->fs_info, flags);
 			btrfs_err(root->fs_info, "allocation failed flags %llu, wanted %llu",
-				(unsigned long long)flags,
-				(unsigned long long)num_bytes);
+				flags, num_bytes);
 			if (sinfo)
 				dump_space_info(sinfo, num_bytes, 1);
 		}
@@ -6550,7 +6539,7 @@ static int __btrfs_free_reserved_extent(struct btrfs_root *root,
 	cache = btrfs_lookup_block_group(root->fs_info, start);
 	if (!cache) {
 		btrfs_err(root->fs_info, "Unable to find block group for %llu",
-			(unsigned long long)start);
+			start);
 		return -ENOSPC;
 	}
 
@@ -6646,8 +6635,7 @@ static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 	ret = update_block_group(root, ins->objectid, ins->offset, 1);
 	if (ret) { /* -ENOENT, logic error */
 		btrfs_err(fs_info, "update block group failed for %llu %llu",
-			(unsigned long long)ins->objectid,
-			(unsigned long long)ins->offset);
+			ins->objectid, ins->offset);
 		BUG();
 	}
 	return ret;
@@ -6719,8 +6707,7 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 	ret = update_block_group(root, ins->objectid, root->leafsize, 1);
 	if (ret) { /* -ENOENT, logic error */
 		btrfs_err(fs_info, "update block group failed for %llu %llu",
-			(unsigned long long)ins->objectid,
-			(unsigned long long)ins->offset);
+			ins->objectid, ins->offset);
 		BUG();
 	}
 	return ret;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index fe443fe..454edd5 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -61,9 +61,8 @@ void btrfs_leak_debug_check(void)
 		state = list_entry(states.next, struct extent_state, leak_list);
 		printk(KERN_ERR "btrfs state leak: start %llu end %llu "
 		       "state %lu in tree %p refs %d\n",
-		       (unsigned long long)state->start,
-		       (unsigned long long)state->end,
-		       state->state, state->tree, atomic_read(&state->refs));
+		       state->start, state->end, state->state, state->tree,
+		       atomic_read(&state->refs));
 		list_del(&state->leak_list);
 		kmem_cache_free(extent_state_cache, state);
 	}
@@ -71,8 +70,8 @@ void btrfs_leak_debug_check(void)
 	while (!list_empty(&buffers)) {
 		eb = list_entry(buffers.next, struct extent_buffer, leak_list);
 		printk(KERN_ERR "btrfs buffer leak start %llu len %lu "
-		       "refs %d\n", (unsigned long long)eb->start,
-		       eb->len, atomic_read(&eb->refs));
+		       "refs %d\n",
+		       eb->start, eb->len, atomic_read(&eb->refs));
 		list_del(&eb->leak_list);
 		kmem_cache_free(extent_buffer_cache, eb);
 	}
@@ -88,11 +87,7 @@ static inline void __btrfs_debug_check_extent_io_range(const char *caller,
 	if (end >= PAGE_SIZE && (end % 2) == 0 && end != isize - 1) {
 		printk_ratelimited(KERN_DEBUG
 		    "btrfs: %s: ino %llu isize %llu odd range [%llu,%llu]\n",
-				caller,
-				(unsigned long long)btrfs_ino(inode),
-				(unsigned long long)isize,
-				(unsigned long long)start,
-				(unsigned long long)end);
+				caller, btrfs_ino(inode), isize, start, end);
 	}
 }
 #else
@@ -388,8 +383,7 @@ static int insert_state(struct extent_io_tree *tree,
 
 	if (end < start)
 		WARN(1, KERN_ERR "btrfs end < start %llu %llu\n",
-		       (unsigned long long)end,
-		       (unsigned long long)start);
+		       end, start);
 	state->start = start;
 	state->end = end;
 
@@ -400,9 +394,8 @@ static int insert_state(struct extent_io_tree *tree,
 		struct extent_state *found;
 		found = rb_entry(node, struct extent_state, rb_node);
 		printk(KERN_ERR "btrfs found node %llu %llu on insert of "
-		       "%llu %llu\n", (unsigned long long)found->start,
-		       (unsigned long long)found->end,
-		       (unsigned long long)start, (unsigned long long)end);
+		       "%llu %llu\n",
+		       found->start, found->end, start, end);
 		return -EEXIST;
 	}
 	state->tree = tree;
@@ -3189,8 +3182,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 			if (!PageWriteback(page)) {
 				printk(KERN_ERR "btrfs warning page %lu not "
 				       "writeback, cur %llu end %llu\n",
-				       page->index, (unsigned long long)cur,
-				       (unsigned long long)end);
+				       page->index, cur, end);
 			}
 
 			ret = submit_extent_page(write_flags, tree, page,
@@ -4813,8 +4805,8 @@ int map_private_extent_buffer(struct extent_buffer *eb, unsigned long start,
 
 	if (start + min_len > eb->len) {
 		WARN(1, KERN_ERR "btrfs bad mapping eb start %llu len %lu, "
-		       "wanted %lu %lu\n", (unsigned long long)eb->start,
-		       eb->len, start, min_len);
+		       "wanted %lu %lu\n",
+		       eb->start, eb->len, start, min_len);
 		return -EINVAL;
 	}
 
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index a7bfc95..fff1a46 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -222,9 +222,7 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 				} else {
 					printk(KERN_INFO "btrfs no csum found "
 					       "for inode %llu start %llu\n",
-					       (unsigned long long)
-					       btrfs_ino(inode),
-					       (unsigned long long)offset);
+					       btrfs_ino(inode), offset);
 				}
 				item = NULL;
 				btrfs_release_path(path);
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index b21a3cd..1547ca3 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -673,8 +673,7 @@ static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 		btrfs_err(root->fs_info,
 			"free space inode generation (%llu) "
 			"did not match free space cache generation (%llu)",
-			(unsigned long long)BTRFS_I(inode)->generation,
-			(unsigned long long)generation);
+			BTRFS_I(inode)->generation, generation);
 		return 0;
 	}
 
@@ -1991,8 +1990,7 @@ void btrfs_dump_free_space(struct btrfs_block_group_cache *block_group,
 		if (info->bytes >= bytes && !block_group->ro)
 			count++;
 		printk(KERN_CRIT "entry offset %llu, bytes %llu, bitmap %s\n",
-		       (unsigned long long)info->offset,
-		       (unsigned long long)info->bytes,
+		       info->offset, info->bytes,
 		       (info->bitmap) ? "yes" : "no");
 	}
 	printk(KERN_INFO "block group has cluster?: %s\n",
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 021694c..57f07b1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2878,9 +2878,7 @@ good:
 zeroit:
 	if (__ratelimit(&_rs))
 		btrfs_info(root->fs_info, "csum failed ino %llu off %llu csum %u private %llu",
-			(unsigned long long)btrfs_ino(page->mapping->host),
-			(unsigned long long)start, csum,
-			(unsigned long long)private);
+			btrfs_ino(page->mapping->host), start, csum, private);
 	memset(kaddr + offset, 1, end - start + 1);
 	flush_dcache_page(page);
 	kunmap_atomic(kaddr);
@@ -3657,8 +3655,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 	if (ret) {
 		btrfs_info(root->fs_info,
 			"failed to delete reference to %.*s, inode %llu parent %llu",
-			name_len, name,
-			(unsigned long long)ino, (unsigned long long)dir_ino);
+			name_len, name, ino, dir_ino);
 		btrfs_abort_transaction(trans, root, ret);
 		goto err;
 	}
@@ -6161,10 +6158,7 @@ insert:
 	btrfs_release_path(path);
 	if (em->start > start || extent_map_end(em) <= start) {
 		btrfs_err(root->fs_info, "bad extent! em: [%llu %llu] passed [%llu %llu]",
-			(unsigned long long)em->start,
-			(unsigned long long)em->len,
-			(unsigned long long)start,
-			(unsigned long long)len);
+			em->start, em->len, start, len);
 		err = -EIO;
 		goto out;
 	}
@@ -6867,9 +6861,8 @@ static void btrfs_endio_direct_read(struct bio *bio, int err)
 			if (csum != private) {
 failed:
 				btrfs_err(root->fs_info, "csum failed ino %llu off %llu csum %u private %u",
-					(unsigned long long)btrfs_ino(inode),
-					(unsigned long long)start,
-					csum, (unsigned)private);
+					btrfs_ino(inode), start, csum,
+					(unsigned)private);
 				err = -EIO;
 			}
 		}
@@ -6956,7 +6949,7 @@ static void btrfs_end_dio_bio(struct bio *bio, int err)
 	if (err) {
 		printk(KERN_ERR "btrfs direct IO failed ino %llu rw %lu "
 		      "sector %#Lx len %u err no %d\n",
-		      (unsigned long long)btrfs_ino(dip->inode), bio->bi_rw,
+		      btrfs_ino(dip->inode), bio->bi_rw,
 		      (unsigned long long)bio->bi_sector, bio->bi_size, err);
 		dip->errors = 1;
 
@@ -7876,7 +7869,7 @@ void btrfs_destroy_inode(struct inode *inode)
 	if (test_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
 		     &BTRFS_I(inode)->runtime_flags)) {
 		btrfs_info(root->fs_info, "inode %llu still on the orphan list",
-			(unsigned long long)btrfs_ino(inode));
+			btrfs_ino(inode));
 		atomic_dec(&root->orphan_inodes);
 	}
 
@@ -7886,8 +7879,7 @@ void btrfs_destroy_inode(struct inode *inode)
 			break;
 		else {
 			btrfs_err(root->fs_info, "found ordered extent %llu %llu on inode cleanup",
-				(unsigned long long)ordered->file_offset,
-				(unsigned long long)ordered->len);
+				ordered->file_offset, ordered->len);
 			btrfs_remove_ordered_extent(inode, ordered);
 			btrfs_put_ordered_extent(ordered);
 			btrfs_put_ordered_extent(ordered);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 238a055..514b833 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1403,14 +1403,13 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 			ret = -EINVAL;
 			goto out_free;
 		}
-		printk(KERN_INFO "btrfs: resizing devid %llu\n",
-		       (unsigned long long)devid);
+		printk(KERN_INFO "btrfs: resizing devid %llu\n", devid);
 	}
 
 	device = btrfs_find_device(root->fs_info, devid, NULL, NULL);
 	if (!device) {
 		printk(KERN_INFO "btrfs: resizer unable to find device %llu\n",
-		       (unsigned long long)devid);
+		       devid);
 		ret = -ENODEV;
 		goto out_free;
 	}
@@ -1418,7 +1417,7 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 	if (!device->writeable) {
 		printk(KERN_INFO "btrfs: resizer unable to apply on "
 		       "readonly device %llu\n",
-		       (unsigned long long)devid);
+		       devid);
 		ret = -EPERM;
 		goto out_free;
 	}
@@ -1470,8 +1469,7 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 	new_size *= root->sectorsize;
 
 	printk_in_rcu(KERN_INFO "btrfs: new size for %s is %llu\n",
-		      rcu_str_deref(device->name),
-		      (unsigned long long)new_size);
+		      rcu_str_deref(device->name), new_size);
 
 	if (new_size > old_size) {
 		trans = btrfs_start_transaction(root, 0);
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 8136982..d92e34f 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -67,7 +67,7 @@ static void ordered_data_tree_panic(struct inode *inode, int errno,
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	btrfs_panic(fs_info, errno, "Inconsistency in ordered tree at offset "
-		    "%llu\n", (unsigned long long)offset);
+		    "%llu\n", offset);
 }
 
 /*
@@ -336,14 +336,12 @@ int btrfs_dec_test_first_ordered_pending(struct inode *inode,
 	*file_offset = dec_end;
 	if (dec_start > dec_end) {
 		printk(KERN_CRIT "bad ordering dec_start %llu end %llu\n",
-		       (unsigned long long)dec_start,
-		       (unsigned long long)dec_end);
+		       dec_start, dec_end);
 	}
 	to_dec = dec_end - dec_start;
 	if (to_dec > entry->bytes_left) {
 		printk(KERN_CRIT "bad ordered accounting left %llu size %llu\n",
-		       (unsigned long long)entry->bytes_left,
-		       (unsigned long long)to_dec);
+		       entry->bytes_left, to_dec);
 	}
 	entry->bytes_left -= to_dec;
 	if (!uptodate)
@@ -403,8 +401,7 @@ have_entry:
 
 	if (io_size > entry->bytes_left) {
 		printk(KERN_CRIT "bad ordered accounting left %llu size %llu\n",
-		       (unsigned long long)entry->bytes_left,
-		       (unsigned long long)io_size);
+		       entry->bytes_left, io_size);
 	}
 	entry->bytes_left -= io_size;
 	if (!uptodate)
diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index dc0024f..ac2b18c 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -26,14 +26,12 @@ static void print_chunk(struct extent_buffer *eb, struct btrfs_chunk *chunk)
 	int i;
 	printk(KERN_INFO "\t\tchunk length %llu owner %llu type %llu "
 	       "num_stripes %d\n",
-	       (unsigned long long)btrfs_chunk_length(eb, chunk),
-	       (unsigned long long)btrfs_chunk_owner(eb, chunk),
-	       (unsigned long long)btrfs_chunk_type(eb, chunk),
-	       num_stripes);
+	       btrfs_chunk_length(eb, chunk), btrfs_chunk_owner(eb, chunk),
+	       btrfs_chunk_type(eb, chunk), num_stripes);
 	for (i = 0 ; i < num_stripes ; i++) {
 		printk(KERN_INFO "\t\t\tstripe %d devid %llu offset %llu\n", i,
-		      (unsigned long long)btrfs_stripe_devid_nr(eb, chunk, i),
-		      (unsigned long long)btrfs_stripe_offset_nr(eb, chunk, i));
+		      btrfs_stripe_devid_nr(eb, chunk, i),
+		      btrfs_stripe_offset_nr(eb, chunk, i));
 	}
 }
 static void print_dev_item(struct extent_buffer *eb,
@@ -41,18 +39,18 @@ static void print_dev_item(struct extent_buffer *eb,
 {
 	printk(KERN_INFO "\t\tdev item devid %llu "
 	       "total_bytes %llu bytes used %llu\n",
-	       (unsigned long long)btrfs_device_id(eb, dev_item),
-	       (unsigned long long)btrfs_device_total_bytes(eb, dev_item),
-	       (unsigned long long)btrfs_device_bytes_used(eb, dev_item));
+	       btrfs_device_id(eb, dev_item),
+	       btrfs_device_total_bytes(eb, dev_item),
+	       btrfs_device_bytes_used(eb, dev_item));
 }
 static void print_extent_data_ref(struct extent_buffer *eb,
 				  struct btrfs_extent_data_ref *ref)
 {
 	printk(KERN_INFO "\t\textent data backref root %llu "
 	       "objectid %llu offset %llu count %u\n",
-	       (unsigned long long)btrfs_extent_data_ref_root(eb, ref),
-	       (unsigned long long)btrfs_extent_data_ref_objectid(eb, ref),
-	       (unsigned long long)btrfs_extent_data_ref_offset(eb, ref),
+	       btrfs_extent_data_ref_root(eb, ref),
+	       btrfs_extent_data_ref_objectid(eb, ref),
+	       btrfs_extent_data_ref_offset(eb, ref),
 	       btrfs_extent_data_ref_count(eb, ref));
 }
 
@@ -87,9 +85,8 @@ static void print_extent_item(struct extent_buffer *eb, int slot)
 	flags = btrfs_extent_flags(eb, ei);
 
 	printk(KERN_INFO "\t\textent refs %llu gen %llu flags %llu\n",
-	       (unsigned long long)btrfs_extent_refs(eb, ei),
-	       (unsigned long long)btrfs_extent_generation(eb, ei),
-	       (unsigned long long)flags);
+	       btrfs_extent_refs(eb, ei), btrfs_extent_generation(eb, ei),
+	       flags);
 
 	if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
 		struct btrfs_tree_block_info *info;
@@ -97,9 +94,8 @@ static void print_extent_item(struct extent_buffer *eb, int slot)
 		btrfs_tree_block_key(eb, info, &key);
 		printk(KERN_INFO "\t\ttree block key (%llu %x %llu) "
 		       "level %d\n",
-		       (unsigned long long)btrfs_disk_key_objectid(&key),
-		       key.type,
-		       (unsigned long long)btrfs_disk_key_offset(&key),
+		       btrfs_disk_key_objectid(&key), key.type,
+		       btrfs_disk_key_offset(&key),
 		       btrfs_tree_block_level(eb, info));
 		iref = (struct btrfs_extent_inline_ref *)(info + 1);
 	} else {
@@ -115,11 +111,11 @@ static void print_extent_item(struct extent_buffer *eb, int slot)
 		switch (type) {
 		case BTRFS_TREE_BLOCK_REF_KEY:
 			printk(KERN_INFO "\t\ttree block backref "
-				"root %llu\n", (unsigned long long)offset);
+				"root %llu\n", offset);
 			break;
 		case BTRFS_SHARED_BLOCK_REF_KEY:
 			printk(KERN_INFO "\t\tshared block backref "
-				"parent %llu\n", (unsigned long long)offset);
+				"parent %llu\n", offset);
 			break;
 		case BTRFS_EXTENT_DATA_REF_KEY:
 			dref = (struct btrfs_extent_data_ref *)(&iref->offset);
@@ -129,8 +125,7 @@ static void print_extent_item(struct extent_buffer *eb, int slot)
 			sref = (struct btrfs_shared_data_ref *)(iref + 1);
 			printk(KERN_INFO "\t\tshared data backref "
 			       "parent %llu count %u\n",
-			       (unsigned long long)offset,
-			       btrfs_shared_data_ref_count(eb, sref));
+			       offset, btrfs_shared_data_ref_count(eb, sref));
 			break;
 		default:
 			BUG();
@@ -148,9 +143,9 @@ static void print_extent_ref_v0(struct extent_buffer *eb, int slot)
 	ref0 = btrfs_item_ptr(eb, slot, struct btrfs_extent_ref_v0);
 	printk("\t\textent back ref root %llu gen %llu "
 		"owner %llu num_refs %lu\n",
-		(unsigned long long)btrfs_ref_root_v0(eb, ref0),
-		(unsigned long long)btrfs_ref_generation_v0(eb, ref0),
-		(unsigned long long)btrfs_ref_objectid_v0(eb, ref0),
+		btrfs_ref_root_v0(eb, ref0),
+		btrfs_ref_generation_v0(eb, ref0),
+		btrfs_ref_objectid_v0(eb, ref0),
 		(unsigned long)btrfs_ref_count_v0(eb, ref0));
 }
 #endif
@@ -177,39 +172,33 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 	nr = btrfs_header_nritems(l);
 
 	btrfs_info(root->fs_info, "leaf %llu total ptrs %d free space %d",
-		(unsigned long long)btrfs_header_bytenr(l), nr,
-		btrfs_leaf_free_space(root, l));
+		btrfs_header_bytenr(l), nr, btrfs_leaf_free_space(root, l));
 	for (i = 0 ; i < nr ; i++) {
 		item = btrfs_item_nr(l, i);
 		btrfs_item_key_to_cpu(l, &key, i);
 		type = btrfs_key_type(&key);
 		printk(KERN_INFO "\titem %d key (%llu %x %llu) itemoff %d "
 		       "itemsize %d\n",
-			i,
-			(unsigned long long)key.objectid, type,
-			(unsigned long long)key.offset,
+			i, key.objectid, type, key.offset,
 			btrfs_item_offset(l, item), btrfs_item_size(l, item));
 		switch (type) {
 		case BTRFS_INODE_ITEM_KEY:
 			ii = btrfs_item_ptr(l, i, struct btrfs_inode_item);
 			printk(KERN_INFO "\t\tinode generation %llu size %llu "
 			       "mode %o\n",
-			       (unsigned long long)
 			       btrfs_inode_generation(l, ii),
-			      (unsigned long long)btrfs_inode_size(l, ii),
+			       btrfs_inode_size(l, ii),
 			       btrfs_inode_mode(l, ii));
 			break;
 		case BTRFS_DIR_ITEM_KEY:
 			di = btrfs_item_ptr(l, i, struct btrfs_dir_item);
 			btrfs_dir_item_key_to_cpu(l, di, &found_key);
 			printk(KERN_INFO "\t\tdir oid %llu type %u\n",
-				(unsigned long long)found_key.objectid,
-				btrfs_dir_type(l, di));
+				found_key.objectid, btrfs_dir_type(l, di));
 			break;
 		case BTRFS_ROOT_ITEM_KEY:
 			ri = btrfs_item_ptr(l, i, struct btrfs_root_item);
 			printk(KERN_INFO "\t\troot data bytenr %llu refs %u\n",
-				(unsigned long long)
 				btrfs_disk_root_bytenr(l, ri),
 				btrfs_disk_root_refs(l, ri));
 			break;
@@ -245,17 +234,12 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 			}
 			printk(KERN_INFO "\t\textent data disk bytenr %llu "
 			       "nr %llu\n",
-			       (unsigned long long)
 			       btrfs_file_extent_disk_bytenr(l, fi),
-			       (unsigned long long)
 			       btrfs_file_extent_disk_num_bytes(l, fi));
 			printk(KERN_INFO "\t\textent data offset %llu "
 			       "nr %llu ram %llu\n",
-			       (unsigned long long)
 			       btrfs_file_extent_offset(l, fi),
-			       (unsigned long long)
 			       btrfs_file_extent_num_bytes(l, fi),
-			       (unsigned long long)
 			       btrfs_file_extent_ram_bytes(l, fi));
 			break;
 		case BTRFS_EXTENT_REF_V0_KEY:
@@ -269,7 +253,6 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 			bi = btrfs_item_ptr(l, i,
 					    struct btrfs_block_group_item);
 			printk(KERN_INFO "\t\tblock group used %llu\n",
-			       (unsigned long long)
 			       btrfs_disk_block_group_used(l, bi));
 			break;
 		case BTRFS_CHUNK_ITEM_KEY:
@@ -286,13 +269,9 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 			printk(KERN_INFO "\t\tdev extent chunk_tree %llu\n"
 			       "\t\tchunk objectid %llu chunk offset %llu "
 			       "length %llu\n",
-			       (unsigned long long)
 			       btrfs_dev_extent_chunk_tree(l, dev_extent),
-			       (unsigned long long)
 			       btrfs_dev_extent_chunk_objectid(l, dev_extent),
-			       (unsigned long long)
 			       btrfs_dev_extent_chunk_offset(l, dev_extent),
-			       (unsigned long long)
 			       btrfs_dev_extent_length(l, dev_extent));
 			break;
 		case BTRFS_DEV_STATS_KEY:
@@ -320,16 +299,13 @@ void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *c)
 		return;
 	}
 	btrfs_info(root->fs_info, "node %llu level %d total ptrs %d free spc %u",
-		(unsigned long long)btrfs_header_bytenr(c),
-		level, nr, (u32)BTRFS_NODEPTRS_PER_BLOCK(root) - nr);
+		btrfs_header_bytenr(c), level, nr,
+		(u32)BTRFS_NODEPTRS_PER_BLOCK(root) - nr);
 	for (i = 0; i < nr; i++) {
 		btrfs_node_key_to_cpu(c, &key, i);
 		printk(KERN_INFO "\tkey %d (%llu %u %llu) block %llu\n",
-		       i,
-		       (unsigned long long)key.objectid,
-		       key.type,
-		       (unsigned long long)key.offset,
-		       (unsigned long long)btrfs_node_blockptr(c, i));
+		       i, key.objectid, key.type, key.offset,
+		       btrfs_node_blockptr(c, i));
 	}
 	for (i = 0; i < nr; i++) {
 		struct extent_buffer *next = read_tree_block(root,
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 1280eff..96996bd 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -394,8 +394,7 @@ next1:
 		if (ret == -ENOENT) {
 			printk(KERN_WARNING
 				"btrfs: orphan qgroup relation 0x%llx->0x%llx\n",
-				(unsigned long long)found_key.objectid,
-				(unsigned long long)found_key.offset);
+				found_key.objectid, found_key.offset);
 			ret = 0;	/* ignore the error */
 		}
 		if (ret)
@@ -1174,7 +1173,7 @@ int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
 	if (ret) {
 		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
 		printk(KERN_INFO "unable to update quota limit for %llu\n",
-		       (unsigned long long)qgroupid);
+		       qgroupid);
 	}
 
 	spin_lock(&fs_info->qgroup_lock);
@@ -1884,10 +1883,9 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 					 path, 1, 0);
 
 	pr_debug("current progress key (%llu %u %llu), search_slot ret %d\n",
-		 (unsigned long long)fs_info->qgroup_rescan_progress.objectid,
+		 fs_info->qgroup_rescan_progress.objectid,
 		 fs_info->qgroup_rescan_progress.type,
-		 (unsigned long long)fs_info->qgroup_rescan_progress.offset,
-		 ret);
+		 fs_info->qgroup_rescan_progress.offset, ret);
 
 	if (ret) {
 		/*
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 1209649..7a21f70 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -335,7 +335,7 @@ static void backref_tree_panic(struct rb_node *rb_node, int errno, u64 bytenr)
 	if (bnode->root)
 		fs_info = bnode->root->fs_info;
 	btrfs_panic(fs_info, errno, "Inconsistency in backref cache "
-		    "found at offset %llu\n", (unsigned long long)bytenr);
+		    "found at offset %llu\n", bytenr);
 }
 
 /*
@@ -4219,8 +4219,7 @@ int btrfs_relocate_block_group(struct btrfs_root *extent_root, u64 group_start)
 	}
 
 	printk(KERN_INFO "btrfs: relocating block group %llu flags %llu\n",
-	       (unsigned long long)rc->block_group->key.objectid,
-	       (unsigned long long)rc->block_group->flags);
+	       rc->block_group->key.objectid, rc->block_group->flags);
 
 	ret = btrfs_start_all_delalloc_inodes(fs_info, 0);
 	if (ret < 0) {
@@ -4242,7 +4241,7 @@ int btrfs_relocate_block_group(struct btrfs_root *extent_root, u64 group_start)
 			break;
 
 		printk(KERN_INFO "btrfs: found %llu extents\n",
-			(unsigned long long)rc->extents_found);
+			rc->extents_found);
 
 		if (rc->stage == MOVE_DATA_EXTENTS && rc->found_file_extent) {
 			btrfs_wait_ordered_range(rc->data_inode, 0, (u64)-1);
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index ffb1036..c370933 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -155,8 +155,7 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
 	if (ret != 0) {
 		btrfs_print_leaf(root, path->nodes[0]);
 		printk(KERN_CRIT "unable to update root key %llu %u %llu\n",
-		       (unsigned long long)key->objectid, key->type,
-		       (unsigned long long)key->offset);
+		       key->objectid, key->type, key->offset);
 		BUG_ON(1);
 	}
 
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 64a157b..6ed2187 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -754,8 +754,7 @@ out:
 			num_uncorrectable_read_errors);
 		printk_ratelimited_in_rcu(KERN_ERR
 			"btrfs: unable to fixup (nodatasum) error at logical %llu on dev %s\n",
-			(unsigned long long)fixup->logical,
-			rcu_str_deref(fixup->dev->name));
+			fixup->logical, rcu_str_deref(fixup->dev->name));
 	}
 
 	btrfs_free_path(path);
@@ -1154,8 +1153,7 @@ corrected_error:
 			spin_unlock(&sctx->stat_lock);
 			printk_ratelimited_in_rcu(KERN_ERR
 				"btrfs: fixed up error at logical %llu on dev %s\n",
-				(unsigned long long)logical,
-				rcu_str_deref(dev->name));
+				logical, rcu_str_deref(dev->name));
 		}
 	} else {
 did_not_correct_error:
@@ -1164,8 +1162,7 @@ did_not_correct_error:
 		spin_unlock(&sctx->stat_lock);
 		printk_ratelimited_in_rcu(KERN_ERR
 			"btrfs: unable to fixup (regular) error at logical %llu on dev %s\n",
-			(unsigned long long)logical,
-			rcu_str_deref(dev->name));
+			logical, rcu_str_deref(dev->name));
 	}
 
 out:
@@ -2455,8 +2452,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 				printk(KERN_ERR
 				       "btrfs scrub: tree block %llu spanning "
 				       "stripes, ignored. logical=%llu\n",
-				       (unsigned long long)key.objectid,
-				       (unsigned long long)logical);
+				       key.objectid, logical);
 				goto next;
 			}
 
@@ -3176,9 +3172,7 @@ static void copy_nocow_pages_worker(struct btrfs_work *work)
 					  nocow_ctx);
 	if (ret != 0 && ret != -ENOENT) {
 		pr_warn("iterate_inodes_from_logical() failed: log %llu, phys %llu, len %llu, mir %llu, ret %d\n",
-			(unsigned long long)logical,
-			(unsigned long long)physical_for_dev_replace,
-			(unsigned long long)len,
+			logical, physical_for_dev_replace, len,
 			(unsigned long long)mirror_num, ret);
 		not_written = 1;
 		goto out;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 8eb6191..8c8c965 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -513,7 +513,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 						root->sectorsize);
 				}
 				printk(KERN_INFO "btrfs: max_inline at %llu\n",
-					(unsigned long long)info->max_inline);
+					info->max_inline);
 			}
 			break;
 		case Opt_alloc_start:
@@ -525,7 +525,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 				kfree(num);
 				printk(KERN_INFO
 					"btrfs: allocations start at %llu\n",
-					(unsigned long long)info->alloc_start);
+					info->alloc_start);
 			}
 			break;
 		case Opt_noacl:
@@ -892,11 +892,9 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 	if (btrfs_test_opt(root, NOBARRIER))
 		seq_puts(seq, ",nobarrier");
 	if (info->max_inline != 8192 * 1024)
-		seq_printf(seq, ",max_inline=%llu",
-			   (unsigned long long)info->max_inline);
+		seq_printf(seq, ",max_inline=%llu", info->max_inline);
 	if (info->alloc_start != 0)
-		seq_printf(seq, ",alloc_start=%llu",
-			   (unsigned long long)info->alloc_start);
+		seq_printf(seq, ",alloc_start=%llu", info->alloc_start);
 	if (info->thread_pool_size !=  min_t(unsigned long,
 					     num_online_cpus() + 2, 8))
 		seq_printf(seq, ",thread_pool=%d", info->thread_pool_size);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index af1931a..4fbd7a6 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1928,8 +1928,7 @@ int btrfs_clean_one_deleted_snapshot(struct btrfs_root *root)
 	list_del_init(&root->root_list);
 	spin_unlock(&fs_info->trans_lock);
 
-	pr_debug("btrfs: cleaner removing %llu\n",
-			(unsigned long long)root->objectid);
+	pr_debug("btrfs: cleaner removing %llu\n", root->objectid);
 
 	btrfs_kill_all_delayed_nodes(root);
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 78b8717..bdad547 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -880,8 +880,7 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 		printk(KERN_INFO "device fsid %pU ", disk_super->fsid);
 	}
 
-	printk(KERN_CONT "devid %llu transid %llu %s\n",
-	       (unsigned long long)devid, (unsigned long long)transid, path);
+	printk(KERN_CONT "devid %llu transid %llu %s\n", devid, transid, path);
 
 	ret = device_list_add(path, disk_super, devid, fs_devices_ret);
 	if (!ret && fs_devices_ret)
@@ -3139,7 +3138,7 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 	     (bctl->data.target & ~allowed))) {
 		printk(KERN_ERR "btrfs: unable to start balance with target "
 		       "data profile %llu\n",
-		       (unsigned long long)bctl->data.target);
+		       bctl->data.target);
 		ret = -EINVAL;
 		goto out;
 	}
@@ -3148,7 +3147,7 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 	     (bctl->meta.target & ~allowed))) {
 		printk(KERN_ERR "btrfs: unable to start balance with target "
 		       "metadata profile %llu\n",
-		       (unsigned long long)bctl->meta.target);
+		       bctl->meta.target);
 		ret = -EINVAL;
 		goto out;
 	}
@@ -3157,7 +3156,7 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 	     (bctl->sys.target & ~allowed))) {
 		printk(KERN_ERR "btrfs: unable to start balance with target "
 		       "system profile %llu\n",
-		       (unsigned long long)bctl->sys.target);
+		       bctl->sys.target);
 		ret = -EINVAL;
 		goto out;
 	}
@@ -4375,8 +4374,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 
 	if (!em) {
 		btrfs_crit(fs_info, "unable to find logical %llu len %llu",
-			(unsigned long long)logical,
-			(unsigned long long)*length);
+			logical, *length);
 		return -EINVAL;
 	}
 
@@ -5246,9 +5244,7 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 
 	if (map_length < length) {
 		btrfs_crit(root->fs_info, "mapping failed logical %llu bio len %llu len %llu",
-			(unsigned long long)logical,
-			(unsigned long long)length,
-			(unsigned long long)map_length);
+			logical, length, map_length);
 		BUG();
 	}
 
@@ -5519,8 +5515,7 @@ static int read_one_dev(struct btrfs_root *root,
 			return -EIO;
 
 		if (!device) {
-			btrfs_warn(root->fs_info, "devid %llu missing",
-				(unsigned long long)devid);
+			btrfs_warn(root->fs_info, "devid %llu missing", devid);
 			device = add_missing_dev(root, devid, dev_uuid);
 			if (!device)
 				return -ENOMEM;
-- 
1.7.9.5

