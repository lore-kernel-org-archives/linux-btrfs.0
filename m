Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:49084 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753764Ab3GPDSh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jul 2013 23:18:37 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r6G3IXZp019457
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Jul 2013 11:18:34 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH v3] btrfs: Cleanup for using BTRFS_SETGET_STACK instead of raw convert
Date: Tue, 16 Jul 2013 11:19:18 +0800
Message-Id: <1373944758-32369-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some codes still use the cpu_to_lexx instead of the
BTRFS_SETGET_STACK_FUNCS declared in ctree.h.

Also added some BTRFS_SETGET_STACK_FUNCS for btrfs_header btrfs_timespec
and other structures.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaoxie@cn.fujitsu.com>
Reviewed-by: David Sterba <dsterba@suse.cz>
---
Changelog v1->v2:
- use the struct member name in the macro of btrfs_file_extent_item.
v2->v3:
- fix the check-integrity compile error
---
 fs/btrfs/check-integrity.c | 110 ++++++++++++++++++++++++---------------------
 fs/btrfs/ctree.h           |  47 +++++++++++++++++++
 fs/btrfs/delayed-inode.c   |  32 +++----------
 fs/btrfs/disk-io.c         |  14 +++---
 fs/btrfs/ioctl.c           |  28 ++++++------
 fs/btrfs/root-tree.c       |  14 +++---
 fs/btrfs/scrub.c           |  12 ++---
 fs/btrfs/transaction.c     |   4 +-
 fs/btrfs/volumes.c         |   2 +-
 9 files changed, 150 insertions(+), 113 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 1431a69..1f706e9 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -813,7 +813,7 @@ static int btrfsic_process_superblock_dev_mirror(
 	    (bh->b_data + (dev_bytenr & 4095));
 
 	if (btrfs_super_bytenr(super_tmp) != dev_bytenr ||
-	    super_tmp->magic != cpu_to_le64(BTRFS_MAGIC) ||
+	    btrfs_super_magic(super_tmp) != BTRFS_MAGIC ||
 	    memcmp(device->uuid, super_tmp->dev_item.uuid, BTRFS_UUID_SIZE) ||
 	    btrfs_super_nodesize(super_tmp) != state->metablock_size ||
 	    btrfs_super_leafsize(super_tmp) != state->metablock_size ||
@@ -880,20 +880,20 @@ static int btrfsic_process_superblock_dev_mirror(
 		tmp_disk_key.offset = 0;
 		switch (pass) {
 		case 0:
-			tmp_disk_key.objectid =
-			    cpu_to_le64(BTRFS_ROOT_TREE_OBJECTID);
+			btrfs_set_disk_key_objectid(&tmp_disk_key,
+						    BTRFS_ROOT_TREE_OBJECTID);
 			additional_string = "initial root ";
 			next_bytenr = btrfs_super_root(super_tmp);
 			break;
 		case 1:
-			tmp_disk_key.objectid =
-			    cpu_to_le64(BTRFS_CHUNK_TREE_OBJECTID);
+			btrfs_set_disk_key_objectid(&tmp_disk_key,
+						    BTRFS_CHUNK_TREE_OBJECTID);
 			additional_string = "initial chunk ";
 			next_bytenr = btrfs_super_chunk_root(super_tmp);
 			break;
 		case 2:
-			tmp_disk_key.objectid =
-			    cpu_to_le64(BTRFS_TREE_LOG_OBJECTID);
+			btrfs_set_disk_key_objectid(&tmp_disk_key,
+						    BTRFS_TREE_LOG_OBJECTID);
 			additional_string = "initial log ";
 			next_bytenr = btrfs_super_log_root(super_tmp);
 			if (0 == next_bytenr)
@@ -1003,7 +1003,7 @@ continue_with_new_stack_frame:
 		    (struct btrfs_leaf *)sf->hdr;
 
 		if (-1 == sf->i) {
-			sf->nr = le32_to_cpu(leafhdr->header.nritems);
+			sf->nr = btrfs_stack_header_nritems(&leafhdr->header);
 
 			if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
 				printk(KERN_INFO
@@ -1013,9 +1013,11 @@ continue_with_new_stack_frame:
 				       sf->block_ctx->start,
 				       sf->nr,
 				       (unsigned long long)
-				       le64_to_cpu(leafhdr->header.generation),
+				       btrfs_stack_header_generation(
+					       &leafhdr->header),
 				       (unsigned long long)
-				       le64_to_cpu(leafhdr->header.owner));
+				       btrfs_stack_header_owner(
+					       &leafhdr->header));
 		}
 
 continue_with_current_leaf_stack_frame:
@@ -1047,10 +1049,10 @@ leaf_item_out_of_bounce_error:
 						     &disk_item,
 						     disk_item_offset,
 						     sizeof(struct btrfs_item));
-			item_offset = le32_to_cpu(disk_item.offset);
-			item_size = le32_to_cpu(disk_item.size);
+			item_offset = btrfs_stack_item_offset(&disk_item);
+			item_size = btrfs_stack_item_offset(&disk_item);
 			disk_key = &disk_item.key;
-			type = disk_key->type;
+			type = btrfs_disk_key_type(disk_key);
 
 			if (BTRFS_ROOT_ITEM_KEY == type) {
 				struct btrfs_root_item root_item;
@@ -1066,7 +1068,7 @@ leaf_item_out_of_bounce_error:
 					sf->block_ctx, &root_item,
 					root_item_offset,
 					item_size);
-				next_bytenr = le64_to_cpu(root_item.bytenr);
+				next_bytenr = btrfs_root_bytenr(&root_item);
 
 				sf->error =
 				    btrfsic_create_link_to_next_block(
@@ -1081,8 +1083,8 @@ leaf_item_out_of_bounce_error:
 						&sf->num_copies,
 						&sf->mirror_num,
 						disk_key,
-						le64_to_cpu(root_item.
-						generation));
+						btrfs_root_generation(
+						&root_item));
 				if (sf->error)
 					goto one_stack_frame_backwards;
 
@@ -1130,7 +1132,7 @@ leaf_item_out_of_bounce_error:
 		struct btrfs_node *const nodehdr = (struct btrfs_node *)sf->hdr;
 
 		if (-1 == sf->i) {
-			sf->nr = le32_to_cpu(nodehdr->header.nritems);
+			sf->nr = btrfs_stack_header_nritems(&nodehdr->header);
 
 			if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
 				printk(KERN_INFO "node %llu level %d items %d"
@@ -1139,9 +1141,11 @@ leaf_item_out_of_bounce_error:
 				       sf->block_ctx->start,
 				       nodehdr->header.level, sf->nr,
 				       (unsigned long long)
-				       le64_to_cpu(nodehdr->header.generation),
+				       btrfs_stack_header_generation(
+				       &nodehdr->header),
 				       (unsigned long long)
-				       le64_to_cpu(nodehdr->header.owner));
+				       btrfs_stack_header_owner(
+				       &nodehdr->header));
 		}
 
 continue_with_current_node_stack_frame:
@@ -1168,7 +1172,7 @@ continue_with_current_node_stack_frame:
 			btrfsic_read_from_block_data(
 				sf->block_ctx, &key_ptr, key_ptr_offset,
 				sizeof(struct btrfs_key_ptr));
-			next_bytenr = le64_to_cpu(key_ptr.blockptr);
+			next_bytenr = btrfs_stack_key_blockptr(&key_ptr);
 
 			sf->error = btrfsic_create_link_to_next_block(
 					state,
@@ -1182,7 +1186,7 @@ continue_with_current_node_stack_frame:
 					&sf->num_copies,
 					&sf->mirror_num,
 					&key_ptr.key,
-					le64_to_cpu(key_ptr.generation));
+					btrfs_stack_key_generation(&key_ptr));
 			if (sf->error)
 				goto one_stack_frame_backwards;
 
@@ -1444,12 +1448,13 @@ static int btrfsic_handle_extent_data(
 		file_extent_item_offset,
 		offsetof(struct btrfs_file_extent_item, disk_num_bytes));
 	if (BTRFS_FILE_EXTENT_REG != file_extent_item.type ||
-	    ((u64)0) == le64_to_cpu(file_extent_item.disk_bytenr)) {
+	    btrfs_stack_file_extent_disk_bytenr(&file_extent_item) == 0) {
 		if (state->print_mask & BTRFSIC_PRINT_MASK_VERY_VERBOSE)
 			printk(KERN_INFO "extent_data: type %u, disk_bytenr = %llu\n",
 			       file_extent_item.type,
 			       (unsigned long long)
-			       le64_to_cpu(file_extent_item.disk_bytenr));
+			       btrfs_stack_file_extent_disk_bytenr(
+			       &file_extent_item));
 		return 0;
 	}
 
@@ -1463,19 +1468,20 @@ static int btrfsic_handle_extent_data(
 	btrfsic_read_from_block_data(block_ctx, &file_extent_item,
 				     file_extent_item_offset,
 				     sizeof(struct btrfs_file_extent_item));
-	next_bytenr = le64_to_cpu(file_extent_item.disk_bytenr) +
-		      le64_to_cpu(file_extent_item.offset);
-	generation = le64_to_cpu(file_extent_item.generation);
-	num_bytes = le64_to_cpu(file_extent_item.num_bytes);
-	generation = le64_to_cpu(file_extent_item.generation);
+	next_bytenr = btrfs_stack_file_extent_disk_bytenr(&file_extent_item) +
+		      btrfs_stack_file_extent_offset(&file_extent_item);
+	generation = btrfs_stack_file_extent_generation(&file_extent_item);
+	num_bytes = btrfs_stack_file_extent_num_bytes(&file_extent_item);
+	generation = btrfs_stack_file_extent_generation(&file_extent_item);
 
 	if (state->print_mask & BTRFSIC_PRINT_MASK_VERY_VERBOSE)
 		printk(KERN_INFO "extent_data: type %u, disk_bytenr = %llu,"
 		       " offset = %llu, num_bytes = %llu\n",
 		       file_extent_item.type,
 		       (unsigned long long)
-		       le64_to_cpu(file_extent_item.disk_bytenr),
-		       (unsigned long long)le64_to_cpu(file_extent_item.offset),
+		       btrfs_stack_file_extent_disk_bytenr(&file_extent_item),
+		       (unsigned long long)
+		       btrfs_stack_file_extent_offset(&file_extent_item),
 		       (unsigned long long)num_bytes);
 	while (num_bytes > 0) {
 		u32 chunk_len;
@@ -1896,8 +1902,8 @@ again:
 		struct list_head *tmp_ref_to;
 
 		if (block->is_superblock) {
-			bytenr = le64_to_cpu(((struct btrfs_super_block *)
-					      mapped_datav[0])->bytenr);
+			bytenr = btrfs_super_bytenr((struct btrfs_super_block *)
+						    mapped_datav[0]);
 			if (num_pages * PAGE_CACHE_SIZE <
 			    BTRFS_SUPER_INFO_SIZE) {
 				printk(KERN_INFO
@@ -1923,8 +1929,9 @@ again:
 					return;
 				}
 				processed_len = state->metablock_size;
-				bytenr = le64_to_cpu(((struct btrfs_header *)
-						      mapped_datav[0])->bytenr);
+				bytenr = btrfs_stack_header_bytenr(
+						(struct btrfs_header *)
+						mapped_datav[0]);
 				btrfsic_cmp_log_and_dev_bytenr(state, bytenr,
 							       dev_state,
 							       dev_bytenr);
@@ -1992,13 +1999,13 @@ again:
 			       block->mirror_num,
 			       (unsigned long long)block->generation,
 			       (unsigned long long)
-			       le64_to_cpu(block->disk_key.objectid),
+			       btrfs_disk_key_objectid(&block->disk_key),
 			       block->disk_key.type,
 			       (unsigned long long)
-			       le64_to_cpu(block->disk_key.offset),
+			       btrfs_disk_key_offset(&block->disk_key),
 			       (unsigned long long)
-			       le64_to_cpu(((struct btrfs_header *)
-					    mapped_datav[0])->generation),
+			       btrfs_stack_header_generation(
+				       (struct btrfs_header *) mapped_datav[0]),
 			       (unsigned long long)
 			       state->max_superblock_generation);
 			btrfsic_dump_tree(state);
@@ -2015,8 +2022,9 @@ again:
 			       block->mirror_num,
 			       (unsigned long long)block->generation,
 			       (unsigned long long)
-			       le64_to_cpu(((struct btrfs_header *)
-					    mapped_datav[0])->generation));
+			       btrfs_stack_header_generation(
+				       (struct btrfs_header *)
+				       mapped_datav[0]));
 			/* it would not be safe to go on */
 			btrfsic_dump_tree(state);
 			goto continue_loop;
@@ -2184,8 +2192,9 @@ again:
 			block_ctx.pagev = NULL;
 		} else {
 			processed_len = state->metablock_size;
-			bytenr = le64_to_cpu(((struct btrfs_header *)
-					      mapped_datav[0])->bytenr);
+			bytenr = btrfs_stack_header_bytenr(
+					(struct btrfs_header *)
+					mapped_datav[0]);
 			btrfsic_cmp_log_and_dev_bytenr(state, bytenr, dev_state,
 						       dev_bytenr);
 			if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
@@ -2434,13 +2443,14 @@ static int btrfsic_process_written_superblock(
 		const char *additional_string = NULL;
 		struct btrfs_disk_key tmp_disk_key;
 
-		tmp_disk_key.type = BTRFS_ROOT_ITEM_KEY;
-		tmp_disk_key.offset = 0;
+		btrfs_set_disk_key_objectid(&tmp_disk_key,
+					    BTRFS_ROOT_ITEM_KEY);
+		btrfs_set_disk_key_objectid(&tmp_disk_key, 0);
 
 		switch (pass) {
 		case 0:
-			tmp_disk_key.objectid =
-			    cpu_to_le64(BTRFS_ROOT_TREE_OBJECTID);
+			btrfs_set_disk_key_objectid(&tmp_disk_key,
+						    BTRFS_ROOT_TREE_OBJECTID);
 			additional_string = "root ";
 			next_bytenr = btrfs_super_root(super_hdr);
 			if (state->print_mask &
@@ -2449,8 +2459,8 @@ static int btrfsic_process_written_superblock(
 				       (unsigned long long)next_bytenr);
 			break;
 		case 1:
-			tmp_disk_key.objectid =
-			    cpu_to_le64(BTRFS_CHUNK_TREE_OBJECTID);
+			btrfs_set_disk_key_objectid(&tmp_disk_key,
+						    BTRFS_CHUNK_TREE_OBJECTID);
 			additional_string = "chunk ";
 			next_bytenr = btrfs_super_chunk_root(super_hdr);
 			if (state->print_mask &
@@ -2459,8 +2469,8 @@ static int btrfsic_process_written_superblock(
 				       (unsigned long long)next_bytenr);
 			break;
 		case 2:
-			tmp_disk_key.objectid =
-			    cpu_to_le64(BTRFS_TREE_LOG_OBJECTID);
+			btrfs_set_disk_key_objectid(&tmp_disk_key,
+						    BTRFS_TREE_LOG_OBJECTID);
 			additional_string = "log ";
 			next_bytenr = btrfs_super_log_root(super_hdr);
 			if (0 == next_bytenr)
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e795bf1..650dc57 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2240,6 +2240,23 @@ BTRFS_SETGET_FUNCS(inode_gid, struct btrfs_inode_item, gid, 32);
 BTRFS_SETGET_FUNCS(inode_mode, struct btrfs_inode_item, mode, 32);
 BTRFS_SETGET_FUNCS(inode_rdev, struct btrfs_inode_item, rdev, 64);
 BTRFS_SETGET_FUNCS(inode_flags, struct btrfs_inode_item, flags, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_inode_generation, struct btrfs_inode_item,
+			 generation, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_inode_sequence, struct btrfs_inode_item,
+			 sequence, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_inode_transid, struct btrfs_inode_item,
+			 transid, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_inode_size, struct btrfs_inode_item, size, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_inode_nbytes, struct btrfs_inode_item,
+			 nbytes, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_inode_block_group, struct btrfs_inode_item,
+			 block_group, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_inode_nlink, struct btrfs_inode_item, nlink, 32);
+BTRFS_SETGET_STACK_FUNCS(stack_inode_uid, struct btrfs_inode_item, uid, 32);
+BTRFS_SETGET_STACK_FUNCS(stack_inode_gid, struct btrfs_inode_item, gid, 32);
+BTRFS_SETGET_STACK_FUNCS(stack_inode_mode, struct btrfs_inode_item, mode, 32);
+BTRFS_SETGET_STACK_FUNCS(stack_inode_rdev, struct btrfs_inode_item, rdev, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_inode_flags, struct btrfs_inode_item, flags, 64);
 
 static inline struct btrfs_timespec *
 btrfs_inode_atime(struct btrfs_inode_item *inode_item)
@@ -2267,6 +2284,8 @@ btrfs_inode_ctime(struct btrfs_inode_item *inode_item)
 
 BTRFS_SETGET_FUNCS(timespec_sec, struct btrfs_timespec, sec, 64);
 BTRFS_SETGET_FUNCS(timespec_nsec, struct btrfs_timespec, nsec, 32);
+BTRFS_SETGET_STACK_FUNCS(stack_timespec_sec, struct btrfs_timespec, sec, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_timespec_nsec, struct btrfs_timespec, nsec, 32);
 
 /* struct btrfs_dev_extent */
 BTRFS_SETGET_FUNCS(dev_extent_chunk_tree, struct btrfs_dev_extent,
@@ -2348,6 +2367,10 @@ BTRFS_SETGET_FUNCS(ref_count_v0, struct btrfs_extent_ref_v0, count, 32);
 /* struct btrfs_node */
 BTRFS_SETGET_FUNCS(key_blockptr, struct btrfs_key_ptr, blockptr, 64);
 BTRFS_SETGET_FUNCS(key_generation, struct btrfs_key_ptr, generation, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_key_blockptr, struct btrfs_key_ptr,
+			 blockptr, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_key_generation, struct btrfs_key_ptr,
+			 generation, 64);
 
 static inline u64 btrfs_node_blockptr(struct extent_buffer *eb, int nr)
 {
@@ -2404,6 +2427,8 @@ static inline void btrfs_set_node_key(struct extent_buffer *eb,
 /* struct btrfs_item */
 BTRFS_SETGET_FUNCS(item_offset, struct btrfs_item, offset, 32);
 BTRFS_SETGET_FUNCS(item_size, struct btrfs_item, size, 32);
+BTRFS_SETGET_STACK_FUNCS(stack_item_offset, struct btrfs_item, offset, 32);
+BTRFS_SETGET_STACK_FUNCS(stack_item_size, struct btrfs_item, size, 32);
 
 static inline unsigned long btrfs_item_nr_offset(int nr)
 {
@@ -2466,6 +2491,13 @@ BTRFS_SETGET_FUNCS(dir_data_len, struct btrfs_dir_item, data_len, 16);
 BTRFS_SETGET_FUNCS(dir_type, struct btrfs_dir_item, type, 8);
 BTRFS_SETGET_FUNCS(dir_name_len, struct btrfs_dir_item, name_len, 16);
 BTRFS_SETGET_FUNCS(dir_transid, struct btrfs_dir_item, transid, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_dir_type, struct btrfs_dir_item, type, 8);
+BTRFS_SETGET_STACK_FUNCS(stack_dir_data_len, struct btrfs_dir_item,
+			 data_len, 16);
+BTRFS_SETGET_STACK_FUNCS(stack_dir_name_len, struct btrfs_dir_item,
+			 name_len, 16);
+BTRFS_SETGET_STACK_FUNCS(stack_dir_transid, struct btrfs_dir_item,
+			 transid, 64);
 
 static inline void btrfs_dir_item_key(struct extent_buffer *eb,
 				      struct btrfs_dir_item *item,
@@ -2568,6 +2600,12 @@ BTRFS_SETGET_HEADER_FUNCS(header_owner, struct btrfs_header, owner, 64);
 BTRFS_SETGET_HEADER_FUNCS(header_nritems, struct btrfs_header, nritems, 32);
 BTRFS_SETGET_HEADER_FUNCS(header_flags, struct btrfs_header, flags, 64);
 BTRFS_SETGET_HEADER_FUNCS(header_level, struct btrfs_header, level, 8);
+BTRFS_SETGET_STACK_FUNCS(stack_header_generation, struct btrfs_header,
+			 generation, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_header_owner, struct btrfs_header, owner, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_header_nritems, struct btrfs_header,
+			 nritems, 32);
+BTRFS_SETGET_STACK_FUNCS(stack_header_bytenr, struct btrfs_header, bytenr, 64);
 
 static inline int btrfs_header_flag(struct extent_buffer *eb, u64 flag)
 {
@@ -2830,6 +2868,7 @@ BTRFS_SETGET_STACK_FUNCS(super_csum_type, struct btrfs_super_block,
 			 csum_type, 16);
 BTRFS_SETGET_STACK_FUNCS(super_cache_generation, struct btrfs_super_block,
 			 cache_generation, 64);
+BTRFS_SETGET_STACK_FUNCS(super_magic, struct btrfs_super_block, magic, 64);
 
 static inline int btrfs_super_csum_size(struct btrfs_super_block *s)
 {
@@ -2847,6 +2886,14 @@ static inline unsigned long btrfs_leaf_data(struct extent_buffer *l)
 
 /* struct btrfs_file_extent_item */
 BTRFS_SETGET_FUNCS(file_extent_type, struct btrfs_file_extent_item, type, 8);
+BTRFS_SETGET_STACK_FUNCS(stack_file_extent_disk_bytenr,
+			 struct btrfs_file_extent_item, disk_bytenr, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_file_extent_offset,
+			 struct btrfs_file_extent_item, offset, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_file_extent_generation,
+			 struct btrfs_file_extent_item, generation, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_file_extent_num_bytes,
+			 struct btrfs_file_extent_item, num_bytes, 64);
 
 static inline unsigned long
 btrfs_file_extent_inline_start(struct btrfs_file_extent_item *e)
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 5615eac..fa88297 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -21,6 +21,7 @@
 #include "delayed-inode.h"
 #include "disk-io.h"
 #include "transaction.h"
+#include "ctree.h"
 
 #define BTRFS_DELAYED_WRITEBACK		512
 #define BTRFS_DELAYED_BACKGROUND	128
@@ -1453,10 +1454,10 @@ int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
 
 	dir_item = (struct btrfs_dir_item *)delayed_item->data;
 	dir_item->location = *disk_key;
-	dir_item->transid = cpu_to_le64(trans->transid);
-	dir_item->data_len = 0;
-	dir_item->name_len = cpu_to_le16(name_len);
-	dir_item->type = type;
+	btrfs_set_stack_dir_transid(dir_item, trans->transid);
+	btrfs_set_stack_dir_data_len(dir_item, 0);
+	btrfs_set_stack_dir_name_len(dir_item, name_len);
+	btrfs_set_stack_dir_type(dir_item, type);
 	memcpy((char *)(dir_item + 1), name, name_len);
 
 	ret = btrfs_delayed_item_reserve_metadata(trans, root, delayed_item);
@@ -1700,7 +1701,7 @@ int btrfs_readdir_delayed_dir_index(struct file *filp, void *dirent,
 
 		di = (struct btrfs_dir_item *)curr->data;
 		name = (char *)(di + 1);
-		name_len = le16_to_cpu(di->name_len);
+		name_len = btrfs_stack_dir_name_len(di);
 
 		d_type = btrfs_filetype_table[di->type];
 		btrfs_disk_key_to_cpu(&location, &di->location);
@@ -1717,27 +1718,6 @@ int btrfs_readdir_delayed_dir_index(struct file *filp, void *dirent,
 	return 0;
 }
 
-BTRFS_SETGET_STACK_FUNCS(stack_inode_generation, struct btrfs_inode_item,
-			 generation, 64);
-BTRFS_SETGET_STACK_FUNCS(stack_inode_sequence, struct btrfs_inode_item,
-			 sequence, 64);
-BTRFS_SETGET_STACK_FUNCS(stack_inode_transid, struct btrfs_inode_item,
-			 transid, 64);
-BTRFS_SETGET_STACK_FUNCS(stack_inode_size, struct btrfs_inode_item, size, 64);
-BTRFS_SETGET_STACK_FUNCS(stack_inode_nbytes, struct btrfs_inode_item,
-			 nbytes, 64);
-BTRFS_SETGET_STACK_FUNCS(stack_inode_block_group, struct btrfs_inode_item,
-			 block_group, 64);
-BTRFS_SETGET_STACK_FUNCS(stack_inode_nlink, struct btrfs_inode_item, nlink, 32);
-BTRFS_SETGET_STACK_FUNCS(stack_inode_uid, struct btrfs_inode_item, uid, 32);
-BTRFS_SETGET_STACK_FUNCS(stack_inode_gid, struct btrfs_inode_item, gid, 32);
-BTRFS_SETGET_STACK_FUNCS(stack_inode_mode, struct btrfs_inode_item, mode, 32);
-BTRFS_SETGET_STACK_FUNCS(stack_inode_rdev, struct btrfs_inode_item, rdev, 64);
-BTRFS_SETGET_STACK_FUNCS(stack_inode_flags, struct btrfs_inode_item, flags, 64);
-
-BTRFS_SETGET_STACK_FUNCS(stack_timespec_sec, struct btrfs_timespec, sec, 64);
-BTRFS_SETGET_STACK_FUNCS(stack_timespec_nsec, struct btrfs_timespec, nsec, 32);
-
 static void fill_stack_inode_item(struct btrfs_trans_handle *trans,
 				  struct btrfs_inode_item *inode_item,
 				  struct inode *inode)
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3c2886c..dfe6864 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1412,11 +1412,11 @@ int btrfs_add_log_tree(struct btrfs_trans_handle *trans,
 	log_root->root_key.offset = root->root_key.objectid;
 
 	inode_item = &log_root->root_item.inode;
-	inode_item->generation = cpu_to_le64(1);
-	inode_item->size = cpu_to_le64(3);
-	inode_item->nlink = cpu_to_le32(1);
-	inode_item->nbytes = cpu_to_le64(root->leafsize);
-	inode_item->mode = cpu_to_le32(S_IFDIR | 0755);
+	btrfs_set_stack_inode_generation(inode_item, 1);
+	btrfs_set_stack_inode_size(inode_item, 3);
+	btrfs_set_stack_inode_nlink(inode_item, 1);
+	btrfs_set_stack_inode_nbytes(inode_item, root->leafsize);
+	btrfs_set_stack_inode_mode(inode_item, S_IFDIR | 0755);
 
 	btrfs_set_root_node(&log_root->root_item, log_root->node);
 
@@ -2574,7 +2574,7 @@ int open_ctree(struct super_block *sb,
 	sb->s_blocksize = sectorsize;
 	sb->s_blocksize_bits = blksize_bits(sectorsize);
 
-	if (disk_super->magic != cpu_to_le64(BTRFS_MAGIC)) {
+	if (btrfs_super_magic(disk_super) != BTRFS_MAGIC) {
 		printk(KERN_INFO "btrfs: valid FS not found on %s\n", sb->s_id);
 		goto fail_sb_buffer;
 	}
@@ -2990,7 +2990,7 @@ struct buffer_head *btrfs_read_dev_super(struct block_device *bdev)
 
 		super = (struct btrfs_super_block *)bh->b_data;
 		if (btrfs_super_bytenr(super) != bytenr ||
-		    super->magic != cpu_to_le64(BTRFS_MAGIC)) {
+		    btrfs_super_magic(super) != BTRFS_MAGIC) {
 			brelse(bh);
 			continue;
 		}
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0e17a30..52c73f2 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -436,15 +436,15 @@ static noinline int create_subvol(struct inode *dir,
 	memset(&root_item, 0, sizeof(root_item));
 
 	inode_item = &root_item.inode;
-	inode_item->generation = cpu_to_le64(1);
-	inode_item->size = cpu_to_le64(3);
-	inode_item->nlink = cpu_to_le32(1);
-	inode_item->nbytes = cpu_to_le64(root->leafsize);
-	inode_item->mode = cpu_to_le32(S_IFDIR | 0755);
+	btrfs_set_stack_inode_generation(inode_item, 1);
+	btrfs_set_stack_inode_size(inode_item, 3);
+	btrfs_set_stack_inode_nlink(inode_item, 1);
+	btrfs_set_stack_inode_nbytes(inode_item, root->leafsize);
+	btrfs_set_stack_inode_mode(inode_item, S_IFDIR | 0755);
 
-	root_item.flags = 0;
-	root_item.byte_limit = 0;
-	inode_item->flags = cpu_to_le64(BTRFS_INODE_ROOT_ITEM_INIT);
+	btrfs_set_root_flags(&root_item, 0);
+	btrfs_set_root_limit(&root_item, 0);
+	btrfs_set_stack_inode_flags(inode_item, BTRFS_INODE_ROOT_ITEM_INIT);
 
 	btrfs_set_root_bytenr(&root_item, leaf->start);
 	btrfs_set_root_generation(&root_item, trans->transid);
@@ -457,8 +457,8 @@ static noinline int create_subvol(struct inode *dir,
 			btrfs_root_generation(&root_item));
 	uuid_le_gen(&new_uuid);
 	memcpy(root_item.uuid, new_uuid.b, BTRFS_UUID_SIZE);
-	root_item.otime.sec = cpu_to_le64(cur_time.tv_sec);
-	root_item.otime.nsec = cpu_to_le32(cur_time.tv_nsec);
+	btrfs_set_stack_timespec_sec(&root_item.otime, cur_time.tv_sec);
+	btrfs_set_stack_timespec_nsec(&root_item.otime, cur_time.tv_nsec);
 	root_item.ctime = root_item.otime;
 	btrfs_set_root_ctransid(&root_item, trans->transid);
 	btrfs_set_root_otransid(&root_item, trans->transid);
@@ -4010,10 +4010,10 @@ static long btrfs_ioctl_set_received_subvol(struct file *file,
 	memcpy(root_item->received_uuid, sa->uuid, BTRFS_UUID_SIZE);
 	btrfs_set_root_stransid(root_item, sa->stransid);
 	btrfs_set_root_rtransid(root_item, sa->rtransid);
-	root_item->stime.sec = cpu_to_le64(sa->stime.sec);
-	root_item->stime.nsec = cpu_to_le32(sa->stime.nsec);
-	root_item->rtime.sec = cpu_to_le64(sa->rtime.sec);
-	root_item->rtime.nsec = cpu_to_le32(sa->rtime.nsec);
+	btrfs_set_stack_timespec_sec(&root_item->stime, sa->stime.sec);
+	btrfs_set_stack_timespec_nsec(&root_item->stime, sa->stime.nsec);
+	btrfs_set_stack_timespec_sec(&root_item->rtime, sa->rtime.sec);
+	btrfs_set_stack_timespec_nsec(&root_item->rtime, sa->rtime.nsec);
 
 	ret = btrfs_update_root(trans, root->fs_info->tree_root,
 				&root->root_key, &root->root_item);
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index ffb1036..70193d0 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -490,13 +490,13 @@ again:
  */
 void btrfs_check_and_init_root_item(struct btrfs_root_item *root_item)
 {
-	u64 inode_flags = le64_to_cpu(root_item->inode.flags);
+	u64 inode_flags = btrfs_stack_inode_flags(&root_item->inode);
 
 	if (!(inode_flags & BTRFS_INODE_ROOT_ITEM_INIT)) {
 		inode_flags |= BTRFS_INODE_ROOT_ITEM_INIT;
-		root_item->inode.flags = cpu_to_le64(inode_flags);
-		root_item->flags = 0;
-		root_item->byte_limit = 0;
+		btrfs_set_stack_inode_flags(&root_item->inode, inode_flags);
+		btrfs_set_root_flags(root_item, 0);
+		btrfs_set_root_limit(root_item, 0);
 	}
 }
 
@@ -507,8 +507,8 @@ void btrfs_update_root_times(struct btrfs_trans_handle *trans,
 	struct timespec ct = CURRENT_TIME;
 
 	spin_lock(&root->root_item_lock);
-	item->ctransid = cpu_to_le64(trans->transid);
-	item->ctime.sec = cpu_to_le64(ct.tv_sec);
-	item->ctime.nsec = cpu_to_le32(ct.tv_nsec);
+	btrfs_set_root_ctransid(item, trans->transid);
+	btrfs_set_stack_timespec_sec(&item->ctime, ct.tv_sec);
+	btrfs_set_stack_timespec_nsec(&item->ctime, ct.tv_nsec);
 	spin_unlock(&root->root_item_lock);
 }
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 4ba2a69..929093d 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1345,12 +1345,12 @@ static void scrub_recheck_block_checksum(struct btrfs_fs_info *fs_info,
 		mapped_buffer = kmap_atomic(sblock->pagev[0]->page);
 		h = (struct btrfs_header *)mapped_buffer;
 
-		if (sblock->pagev[0]->logical != le64_to_cpu(h->bytenr) ||
+		if (sblock->pagev[0]->logical != btrfs_stack_header_bytenr(h) ||
 		    memcmp(h->fsid, fs_info->fsid, BTRFS_UUID_SIZE) ||
 		    memcmp(h->chunk_tree_uuid, fs_info->chunk_tree_uuid,
 			   BTRFS_UUID_SIZE)) {
 			sblock->header_error = 1;
-		} else if (generation != le64_to_cpu(h->generation)) {
+		} else if (generation != btrfs_stack_header_generation(h)) {
 			sblock->header_error = 1;
 			sblock->generation_error = 1;
 		}
@@ -1720,10 +1720,10 @@ static int scrub_checksum_tree_block(struct scrub_block *sblock)
 	 * b) the page is already kmapped
 	 */
 
-	if (sblock->pagev[0]->logical != le64_to_cpu(h->bytenr))
+	if (sblock->pagev[0]->logical != btrfs_stack_header_bytenr(h))
 		++fail;
 
-	if (sblock->pagev[0]->generation != le64_to_cpu(h->generation))
+	if (sblock->pagev[0]->generation != btrfs_stack_header_generation(h))
 		++fail;
 
 	if (memcmp(h->fsid, fs_info->fsid, BTRFS_UUID_SIZE))
@@ -1786,10 +1786,10 @@ static int scrub_checksum_super(struct scrub_block *sblock)
 	s = (struct btrfs_super_block *)mapped_buffer;
 	memcpy(on_disk_csum, s->csum, sctx->csum_size);
 
-	if (sblock->pagev[0]->logical != le64_to_cpu(s->bytenr))
+	if (sblock->pagev[0]->logical != btrfs_super_bytenr(s))
 		++fail_cor;
 
-	if (sblock->pagev[0]->generation != le64_to_cpu(s->generation))
+	if (sblock->pagev[0]->generation != btrfs_super_generation(s))
 		++fail_gen;
 
 	if (memcmp(s->fsid, fs_info->fsid, BTRFS_UUID_SIZE))
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index d58cce7..61a5c2c 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1225,8 +1225,8 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 		btrfs_set_root_stransid(new_root_item, 0);
 		btrfs_set_root_rtransid(new_root_item, 0);
 	}
-	new_root_item->otime.sec = cpu_to_le64(cur_time.tv_sec);
-	new_root_item->otime.nsec = cpu_to_le32(cur_time.tv_nsec);
+	btrfs_set_stack_timespec_sec(&new_root_item->otime, cur_time.tv_sec);
+	btrfs_set_stack_timespec_nsec(&new_root_item->otime, cur_time.tv_nsec);
 	btrfs_set_root_otransid(new_root_item, trans->transid);
 
 	old = btrfs_lock_root_node(root);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 78b8717..cfe435c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -865,7 +865,7 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	disk_super = p + (bytenr & ~PAGE_CACHE_MASK);
 
 	if (btrfs_super_bytenr(disk_super) != bytenr ||
-	    disk_super->magic != cpu_to_le64(BTRFS_MAGIC))
+	    btrfs_super_magic(disk_super) != BTRFS_MAGIC)
 		goto error_unmap;
 
 	devid = btrfs_stack_device_id(&disk_super->dev_item);
-- 
1.8.3.2

