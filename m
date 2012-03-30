From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH] Btrfs: change integrity checker to support big blocks
Date: Fri, 30 Mar 2012 13:58:33 +0200
Message-ID: <afd0b8834ec58724f13127400cc2ede1ac6728f4.1333107802.git.sbehrens@giantdisaster.de>
References: <a1550959ef3f5776fcd0b0bf97487f1ef0863ef0.1333107802.git.sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <a1550959ef3f5776fcd0b0bf97487f1ef0863ef0.1333107802.git.sbehrens@giantdisaster.de>
List-ID: <linux-btrfs.vger.kernel.org>

The integrity checker used to be coded for nodesize == leafsize ==
sectorsize == PAGE_CACHE_SIZE.
This is now changed to support sizes for nodesize and leafsize which are
N * PAGE_CACHE_SIZE.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
The patch is based on cmason/integration as of 3/30/2012.

 fs/btrfs/check-integrity.c |  561 ++++++++++++++++++++++++++++++++------------
 1 files changed, 415 insertions(+), 146 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index d986824..013fb04 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -104,8 +104,6 @@
 #define BTRFSIC_BLOCK_STACK_FRAME_MAGIC_NUMBER 20111300
 #define BTRFSIC_TREE_DUMP_MAX_INDENT_LEVEL (200 - 6)	/* in characters,
 							 * excluding " [...]" */
-#define BTRFSIC_BLOCK_SIZE PAGE_SIZE
-
 #define BTRFSIC_GENERATION_UNKNOWN ((u64)-1)
 
 /*
@@ -211,8 +209,9 @@ struct btrfsic_block_data_ctx {
 	u64 dev_bytenr;		/* physical bytenr on device */
 	u32 len;
 	struct btrfsic_dev_state *dev;
-	char *data;
-	struct buffer_head *bh;	/* do not use if set to NULL */
+	char **datav;
+	struct page **pagev;
+	void *mem_to_free;
 };
 
 /* This structure is used to implement recursion without occupying
@@ -244,6 +243,8 @@ struct btrfsic_state {
 	struct btrfs_root *root;
 	u64 max_superblock_generation;
 	struct btrfsic_block *latest_superblock;
+	u32 metablock_size;
+	u32 datablock_size;
 };
 
 static void btrfsic_block_init(struct btrfsic_block *b);
@@ -291,8 +292,10 @@ static int btrfsic_process_superblock(struct btrfsic_state *state,
 static int btrfsic_process_metablock(struct btrfsic_state *state,
 				     struct btrfsic_block *block,
 				     struct btrfsic_block_data_ctx *block_ctx,
-				     struct btrfs_header *hdr,
 				     int limit_nesting, int force_iodone_flag);
+static void btrfsic_read_from_block_data(
+	struct btrfsic_block_data_ctx *block_ctx,
+	void *dst, u32 offset, size_t len);
 static int btrfsic_create_link_to_next_block(
 		struct btrfsic_state *state,
 		struct btrfsic_block *block,
@@ -319,12 +322,13 @@ static void btrfsic_release_block_ctx(struct btrfsic_block_data_ctx *block_ctx);
 static int btrfsic_read_block(struct btrfsic_state *state,
 			      struct btrfsic_block_data_ctx *block_ctx);
 static void btrfsic_dump_database(struct btrfsic_state *state);
+static void btrfsic_complete_bio_end_io(struct bio *bio, int err);
 static int btrfsic_test_for_metadata(struct btrfsic_state *state,
-				     const u8 *data, unsigned int size);
+				     char **datav, unsigned int num_pages);
 static void btrfsic_process_written_block(struct btrfsic_dev_state *dev_state,
-					  u64 dev_bytenr, u8 *mapped_data,
-					  unsigned int len, struct bio *bio,
-					  int *bio_is_patched,
+					  u64 dev_bytenr, char **mapped_datav,
+					  unsigned int num_pages,
+					  struct bio *bio, int *bio_is_patched,
 					  struct buffer_head *bh,
 					  int submit_bio_bh_rw);
 static int btrfsic_process_written_superblock(
@@ -376,7 +380,7 @@ static struct btrfsic_dev_state *btrfsic_dev_state_lookup(
 static void btrfsic_cmp_log_and_dev_bytenr(struct btrfsic_state *state,
 					   u64 bytenr,
 					   struct btrfsic_dev_state *dev_state,
-					   u64 dev_bytenr, char *data);
+					   u64 dev_bytenr);
 
 static struct mutex btrfsic_mutex;
 static int btrfsic_is_initialized;
@@ -652,7 +656,7 @@ static int btrfsic_process_superblock(struct btrfsic_state *state,
 	int pass;
 
 	BUG_ON(NULL == state);
-	selected_super = kmalloc(sizeof(*selected_super), GFP_NOFS);
+	selected_super = kzalloc(sizeof(*selected_super), GFP_NOFS);
 	if (NULL == selected_super) {
 		printk(KERN_INFO "btrfsic: error, kmalloc failed!\n");
 		return -1;
@@ -719,7 +723,7 @@ static int btrfsic_process_superblock(struct btrfsic_state *state,
 
 		num_copies =
 		    btrfs_num_copies(&state->root->fs_info->mapping_tree,
-				     next_bytenr, PAGE_SIZE);
+				     next_bytenr, state->metablock_size);
 		if (state->print_mask & BTRFSIC_PRINT_MASK_NUM_COPIES)
 			printk(KERN_INFO "num_copies(log_bytenr=%llu) = %d\n",
 			       (unsigned long long)next_bytenr, num_copies);
@@ -728,9 +732,9 @@ static int btrfsic_process_superblock(struct btrfsic_state *state,
 			struct btrfsic_block *next_block;
 			struct btrfsic_block_data_ctx tmp_next_block_ctx;
 			struct btrfsic_block_link *l;
-			struct btrfs_header *hdr;
 
-			ret = btrfsic_map_block(state, next_bytenr, PAGE_SIZE,
+			ret = btrfsic_map_block(state, next_bytenr,
+						state->metablock_size,
 						&tmp_next_block_ctx,
 						mirror_num);
 			if (ret) {
@@ -759,7 +763,7 @@ static int btrfsic_process_superblock(struct btrfsic_state *state,
 			BUG_ON(NULL == l);
 
 			ret = btrfsic_read_block(state, &tmp_next_block_ctx);
-			if (ret < (int)BTRFSIC_BLOCK_SIZE) {
+			if (ret < (int)PAGE_CACHE_SIZE) {
 				printk(KERN_INFO
 				       "btrfsic: read @logical %llu failed!\n",
 				       (unsigned long long)
@@ -769,11 +773,9 @@ static int btrfsic_process_superblock(struct btrfsic_state *state,
 				return -1;
 			}
 
-			hdr = (struct btrfs_header *)tmp_next_block_ctx.data;
 			ret = btrfsic_process_metablock(state,
 							next_block,
 							&tmp_next_block_ctx,
-							hdr,
 							BTRFS_MAX_LEVEL + 3, 1);
 			btrfsic_release_block_ctx(&tmp_next_block_ctx);
 		}
@@ -800,7 +802,10 @@ static int btrfsic_process_superblock_dev_mirror(
 
 	/* super block bytenr is always the unmapped device bytenr */
 	dev_bytenr = btrfs_sb_offset(superblock_mirror_num);
-	bh = __bread(superblock_bdev, dev_bytenr / 4096, 4096);
+	if (dev_bytenr + BTRFS_SUPER_INFO_SIZE > device->total_bytes)
+		return -1;
+	bh = __bread(superblock_bdev, dev_bytenr / 4096,
+		     BTRFS_SUPER_INFO_SIZE);
 	if (NULL == bh)
 		return -1;
 	super_tmp = (struct btrfs_super_block *)
@@ -809,7 +814,10 @@ static int btrfsic_process_superblock_dev_mirror(
 	if (btrfs_super_bytenr(super_tmp) != dev_bytenr ||
 	    strncmp((char *)(&(super_tmp->magic)), BTRFS_MAGIC,
 		    sizeof(super_tmp->magic)) ||
-	    memcmp(device->uuid, super_tmp->dev_item.uuid, BTRFS_UUID_SIZE)) {
+	    memcmp(device->uuid, super_tmp->dev_item.uuid, BTRFS_UUID_SIZE) ||
+	    btrfs_super_nodesize(super_tmp) != state->metablock_size ||
+	    btrfs_super_leafsize(super_tmp) != state->metablock_size ||
+	    btrfs_super_sectorsize(super_tmp) != state->datablock_size) {
 		brelse(bh);
 		return 0;
 	}
@@ -894,7 +902,7 @@ static int btrfsic_process_superblock_dev_mirror(
 
 		num_copies =
 		    btrfs_num_copies(&state->root->fs_info->mapping_tree,
-				     next_bytenr, PAGE_SIZE);
+				     next_bytenr, state->metablock_size);
 		if (state->print_mask & BTRFSIC_PRINT_MASK_NUM_COPIES)
 			printk(KERN_INFO "num_copies(log_bytenr=%llu) = %d\n",
 			       (unsigned long long)next_bytenr, num_copies);
@@ -903,7 +911,8 @@ static int btrfsic_process_superblock_dev_mirror(
 			struct btrfsic_block_data_ctx tmp_next_block_ctx;
 			struct btrfsic_block_link *l;
 
-			if (btrfsic_map_block(state, next_bytenr, PAGE_SIZE,
+			if (btrfsic_map_block(state, next_bytenr,
+					      state->metablock_size,
 					      &tmp_next_block_ctx,
 					      mirror_num)) {
 				printk(KERN_INFO "btrfsic: btrfsic_map_block("
@@ -967,13 +976,15 @@ static int btrfsic_process_metablock(
 		struct btrfsic_state *state,
 		struct btrfsic_block *const first_block,
 		struct btrfsic_block_data_ctx *const first_block_ctx,
-		struct btrfs_header *const first_hdr,
 		int first_limit_nesting, int force_iodone_flag)
 {
 	struct btrfsic_stack_frame initial_stack_frame = { 0 };
 	struct btrfsic_stack_frame *sf;
 	struct btrfsic_stack_frame *next_stack;
+	struct btrfs_header *const first_hdr =
+		(struct btrfs_header *)first_block_ctx->datav[0];
 
+	BUG_ON(!first_hdr);
 	sf = &initial_stack_frame;
 	sf->error = 0;
 	sf->i = -1;
@@ -1013,21 +1024,47 @@ continue_with_current_leaf_stack_frame:
 		}
 
 		if (sf->i < sf->nr) {
-			struct btrfs_item *disk_item = leafhdr->items + sf->i;
-			struct btrfs_disk_key *disk_key = &disk_item->key;
+			struct btrfs_item disk_item;
+			u32 disk_item_offset =
+				(uintptr_t)(leafhdr->items + sf->i) -
+				(uintptr_t)leafhdr;
+			struct btrfs_disk_key *disk_key;
 			u8 type;
-			const u32 item_offset = le32_to_cpu(disk_item->offset);
+			u32 item_offset;
 
+			if (disk_item_offset + sizeof(struct btrfs_item) >
+			    sf->block_ctx->len) {
+leaf_item_out_of_bounce_error:
+				printk(KERN_INFO
+				       "btrfsic: leaf item out of bounce at logical %llu, dev %s\n",
+				       sf->block_ctx->start,
+				       sf->block_ctx->dev->name);
+				goto one_stack_frame_backwards;
+			}
+			btrfsic_read_from_block_data(sf->block_ctx,
+						     &disk_item,
+						     disk_item_offset,
+						     sizeof(struct btrfs_item));
+			item_offset = le32_to_cpu(disk_item.offset);
+			disk_key = &disk_item.key;
 			type = disk_key->type;
 
 			if (BTRFS_ROOT_ITEM_KEY == type) {
-				const struct btrfs_root_item *const root_item =
-				    (struct btrfs_root_item *)
-				    (sf->block_ctx->data +
-				     offsetof(struct btrfs_leaf, items) +
-				     item_offset);
-				const u64 next_bytenr =
-				    le64_to_cpu(root_item->bytenr);
+				struct btrfs_root_item root_item;
+				u32 root_item_offset;
+				u64 next_bytenr;
+
+				root_item_offset = item_offset +
+					offsetof(struct btrfs_leaf, items);
+				if (root_item_offset +
+				    sizeof(struct btrfs_root_item) >
+				    sf->block_ctx->len)
+					goto leaf_item_out_of_bounce_error;
+				btrfsic_read_from_block_data(
+					sf->block_ctx, &root_item,
+					root_item_offset,
+					sizeof(struct btrfs_root_item));
+				next_bytenr = le64_to_cpu(root_item.bytenr);
 
 				sf->error =
 				    btrfsic_create_link_to_next_block(
@@ -1042,7 +1079,7 @@ continue_with_current_leaf_stack_frame:
 						&sf->num_copies,
 						&sf->mirror_num,
 						disk_key,
-						le64_to_cpu(root_item->
+						le64_to_cpu(root_item.
 						generation));
 				if (sf->error)
 					goto one_stack_frame_backwards;
@@ -1050,7 +1087,7 @@ continue_with_current_leaf_stack_frame:
 				if (NULL != sf->next_block) {
 					struct btrfs_header *const next_hdr =
 					    (struct btrfs_header *)
-					    sf->next_block_ctx.data;
+					    sf->next_block_ctx.datav[0];
 
 					next_stack =
 					    btrfsic_stack_frame_alloc();
@@ -1112,10 +1149,24 @@ continue_with_current_node_stack_frame:
 		}
 
 		if (sf->i < sf->nr) {
-			struct btrfs_key_ptr *disk_key_ptr =
-			    nodehdr->ptrs + sf->i;
-			const u64 next_bytenr =
-			    le64_to_cpu(disk_key_ptr->blockptr);
+			struct btrfs_key_ptr key_ptr;
+			u32 key_ptr_offset;
+			u64 next_bytenr;
+
+			key_ptr_offset = (uintptr_t)(nodehdr->ptrs + sf->i) -
+					  (uintptr_t)nodehdr;
+			if (key_ptr_offset + sizeof(struct btrfs_key_ptr) >
+			    sf->block_ctx->len) {
+				printk(KERN_INFO
+				       "btrfsic: node item out of bounce at logical %llu, dev %s\n",
+				       sf->block_ctx->start,
+				       sf->block_ctx->dev->name);
+				goto one_stack_frame_backwards;
+			}
+			btrfsic_read_from_block_data(
+				sf->block_ctx, &key_ptr, key_ptr_offset,
+				sizeof(struct btrfs_key_ptr));
+			next_bytenr = le64_to_cpu(key_ptr.blockptr);
 
 			sf->error = btrfsic_create_link_to_next_block(
 					state,
@@ -1128,15 +1179,15 @@ continue_with_current_node_stack_frame:
 					force_iodone_flag,
 					&sf->num_copies,
 					&sf->mirror_num,
-					&disk_key_ptr->key,
-					le64_to_cpu(disk_key_ptr->generation));
+					&key_ptr.key,
+					le64_to_cpu(key_ptr.generation));
 			if (sf->error)
 				goto one_stack_frame_backwards;
 
 			if (NULL != sf->next_block) {
 				struct btrfs_header *const next_hdr =
 				    (struct btrfs_header *)
-				    sf->next_block_ctx.data;
+				    sf->next_block_ctx.datav[0];
 
 				next_stack = btrfsic_stack_frame_alloc();
 				if (NULL == next_stack)
@@ -1182,6 +1233,35 @@ one_stack_frame_backwards:
 	return sf->error;
 }
 
+static void btrfsic_read_from_block_data(
+	struct btrfsic_block_data_ctx *block_ctx,
+	void *dstv, u32 offset, size_t len)
+{
+	size_t cur;
+	size_t offset_in_page;
+	char *kaddr;
+	char *dst = (char *)dstv;
+	size_t start_offset = block_ctx->start & ((u64)PAGE_CACHE_SIZE - 1);
+	unsigned long i = (start_offset + offset) >> PAGE_CACHE_SHIFT;
+
+	WARN_ON(offset + len > block_ctx->len);
+	offset_in_page = (start_offset + offset) &
+			 ((unsigned long)PAGE_CACHE_SIZE - 1);
+
+	while (len > 0) {
+		cur = min(len, (PAGE_CACHE_SIZE - offset_in_page));
+		BUG_ON(i >= (block_ctx->len + PAGE_CACHE_SIZE - 1) >>
+			    PAGE_CACHE_SHIFT);
+		kaddr = block_ctx->datav[i];
+		memcpy(dst, kaddr + offset_in_page, cur);
+
+		dst += cur;
+		len -= cur;
+		offset_in_page = 0;
+		i++;
+	}
+}
+
 static int btrfsic_create_link_to_next_block(
 		struct btrfsic_state *state,
 		struct btrfsic_block *block,
@@ -1205,7 +1285,7 @@ static int btrfsic_create_link_to_next_block(
 	if (0 == *num_copiesp) {
 		*num_copiesp =
 		    btrfs_num_copies(&state->root->fs_info->mapping_tree,
-				     next_bytenr, PAGE_SIZE);
+				     next_bytenr, state->metablock_size);
 		if (state->print_mask & BTRFSIC_PRINT_MASK_NUM_COPIES)
 			printk(KERN_INFO "num_copies(log_bytenr=%llu) = %d\n",
 			       (unsigned long long)next_bytenr, *num_copiesp);
@@ -1220,7 +1300,7 @@ static int btrfsic_create_link_to_next_block(
 		       "btrfsic_create_link_to_next_block(mirror_num=%d)\n",
 		       *mirror_nump);
 	ret = btrfsic_map_block(state, next_bytenr,
-				BTRFSIC_BLOCK_SIZE,
+				state->metablock_size,
 				next_block_ctx, *mirror_nump);
 	if (ret) {
 		printk(KERN_INFO
@@ -1315,7 +1395,7 @@ static int btrfsic_create_link_to_next_block(
 
 	if (limit_nesting > 0 && did_alloc_block_link) {
 		ret = btrfsic_read_block(state, next_block_ctx);
-		if (ret < (int)BTRFSIC_BLOCK_SIZE) {
+		if (ret < (int)next_block_ctx->len) {
 			printk(KERN_INFO
 			       "btrfsic: read block @logical %llu failed!\n",
 			       (unsigned long long)next_bytenr);
@@ -1340,43 +1420,55 @@ static int btrfsic_handle_extent_data(
 		u32 item_offset, int force_iodone_flag)
 {
 	int ret;
-	struct btrfs_file_extent_item *file_extent_item =
-	    (struct btrfs_file_extent_item *)(block_ctx->data +
-					      offsetof(struct btrfs_leaf,
-						       items) + item_offset);
-	u64 next_bytenr =
-	    le64_to_cpu(file_extent_item->disk_bytenr) +
-	    le64_to_cpu(file_extent_item->offset);
-	u64 num_bytes = le64_to_cpu(file_extent_item->num_bytes);
-	u64 generation = le64_to_cpu(file_extent_item->generation);
+	struct btrfs_file_extent_item file_extent_item;
+	u64 file_extent_item_offset;
+	u64 next_bytenr;
+	u64 num_bytes;
+	u64 generation;
 	struct btrfsic_block_link *l;
 
+	file_extent_item_offset = offsetof(struct btrfs_leaf, items) +
+				  item_offset;
+	if (file_extent_item_offset + sizeof(struct btrfs_file_extent_item) >
+	    block_ctx->len) {
+		printk(KERN_INFO
+		       "btrfsic: file item out of bounce at logical %llu, dev %s\n",
+		       block_ctx->start, block_ctx->dev->name);
+		return -1;
+	}
+	btrfsic_read_from_block_data(block_ctx, &file_extent_item,
+				     file_extent_item_offset,
+				     sizeof(struct btrfs_file_extent_item));
+	next_bytenr = le64_to_cpu(file_extent_item.disk_bytenr) +
+		      le64_to_cpu(file_extent_item.offset);
+	generation = le64_to_cpu(file_extent_item.generation);
+	num_bytes = le64_to_cpu(file_extent_item.num_bytes);
+	generation = le64_to_cpu(file_extent_item.generation);
+
 	if (state->print_mask & BTRFSIC_PRINT_MASK_VERY_VERBOSE)
 		printk(KERN_INFO "extent_data: type %u, disk_bytenr = %llu,"
 		       " offset = %llu, num_bytes = %llu\n",
-		       file_extent_item->type,
-		       (unsigned long long)
-		       le64_to_cpu(file_extent_item->disk_bytenr),
-		       (unsigned long long)
-		       le64_to_cpu(file_extent_item->offset),
+		       file_extent_item.type,
 		       (unsigned long long)
-		       le64_to_cpu(file_extent_item->num_bytes));
-	if (BTRFS_FILE_EXTENT_REG != file_extent_item->type ||
-	    ((u64)0) == le64_to_cpu(file_extent_item->disk_bytenr))
+		       le64_to_cpu(file_extent_item.disk_bytenr),
+		       (unsigned long long)le64_to_cpu(file_extent_item.offset),
+		       (unsigned long long)num_bytes);
+	if (BTRFS_FILE_EXTENT_REG != file_extent_item.type ||
+	    ((u64)0) == le64_to_cpu(file_extent_item.disk_bytenr))
 		return 0;
 	while (num_bytes > 0) {
 		u32 chunk_len;
 		int num_copies;
 		int mirror_num;
 
-		if (num_bytes > BTRFSIC_BLOCK_SIZE)
-			chunk_len = BTRFSIC_BLOCK_SIZE;
+		if (num_bytes > state->datablock_size)
+			chunk_len = state->datablock_size;
 		else
 			chunk_len = num_bytes;
 
 		num_copies =
 		    btrfs_num_copies(&state->root->fs_info->mapping_tree,
-				     next_bytenr, PAGE_SIZE);
+				     next_bytenr, state->datablock_size);
 		if (state->print_mask & BTRFSIC_PRINT_MASK_NUM_COPIES)
 			printk(KERN_INFO "num_copies(log_bytenr=%llu) = %d\n",
 			       (unsigned long long)next_bytenr, num_copies);
@@ -1476,8 +1568,9 @@ static int btrfsic_map_block(struct btrfsic_state *state, u64 bytenr, u32 len,
 	block_ctx_out->dev_bytenr = multi->stripes[0].physical;
 	block_ctx_out->start = bytenr;
 	block_ctx_out->len = len;
-	block_ctx_out->data = NULL;
-	block_ctx_out->bh = NULL;
+	block_ctx_out->datav = NULL;
+	block_ctx_out->pagev = NULL;
+	block_ctx_out->mem_to_free = NULL;
 
 	if (0 == ret)
 		kfree(multi);
@@ -1497,8 +1590,9 @@ static int btrfsic_map_superblock(struct btrfsic_state *state, u64 bytenr,
 	block_ctx_out->dev_bytenr = bytenr;
 	block_ctx_out->start = bytenr;
 	block_ctx_out->len = len;
-	block_ctx_out->data = NULL;
-	block_ctx_out->bh = NULL;
+	block_ctx_out->datav = NULL;
+	block_ctx_out->pagev = NULL;
+	block_ctx_out->mem_to_free = NULL;
 	if (NULL != block_ctx_out->dev) {
 		return 0;
 	} else {
@@ -1509,38 +1603,127 @@ static int btrfsic_map_superblock(struct btrfsic_state *state, u64 bytenr,
 
 static void btrfsic_release_block_ctx(struct btrfsic_block_data_ctx *block_ctx)
 {
-	if (NULL != block_ctx->bh) {
-		brelse(block_ctx->bh);
-		block_ctx->bh = NULL;
+	if (block_ctx->mem_to_free) {
+		unsigned int num_pages;
+
+		BUG_ON(!block_ctx->datav);
+		BUG_ON(!block_ctx->pagev);
+		num_pages = (block_ctx->len + (u64)PAGE_CACHE_SIZE - 1) >>
+			    PAGE_CACHE_SHIFT;
+		while (num_pages > 0) {
+			num_pages--;
+			if (block_ctx->datav[num_pages]) {
+				kunmap(block_ctx->pagev[num_pages]);
+				block_ctx->datav[num_pages] = NULL;
+			}
+			if (block_ctx->pagev[num_pages]) {
+				__free_page(block_ctx->pagev[num_pages]);
+				block_ctx->pagev[num_pages] = NULL;
+			}
+		}
+
+		kfree(block_ctx->mem_to_free);
+		block_ctx->mem_to_free = NULL;
+		block_ctx->pagev = NULL;
+		block_ctx->datav = NULL;
 	}
 }
 
 static int btrfsic_read_block(struct btrfsic_state *state,
 			      struct btrfsic_block_data_ctx *block_ctx)
 {
-	block_ctx->bh = NULL;
-	if (block_ctx->dev_bytenr & 4095) {
+	unsigned int num_pages;
+	unsigned int i;
+	u64 dev_bytenr;
+	int ret;
+
+	BUG_ON(block_ctx->datav);
+	BUG_ON(block_ctx->pagev);
+	BUG_ON(block_ctx->mem_to_free);
+	if (block_ctx->dev_bytenr & ((u64)PAGE_CACHE_SIZE - 1)) {
 		printk(KERN_INFO
 		       "btrfsic: read_block() with unaligned bytenr %llu\n",
 		       (unsigned long long)block_ctx->dev_bytenr);
 		return -1;
 	}
-	if (block_ctx->len > 4096) {
-		printk(KERN_INFO
-		       "btrfsic: read_block() with too huge size %d\n",
-		       block_ctx->len);
+
+	num_pages = (block_ctx->len + (u64)PAGE_CACHE_SIZE - 1) >>
+		    PAGE_CACHE_SHIFT;
+	block_ctx->mem_to_free = kzalloc((sizeof(*block_ctx->datav) +
+					  sizeof(*block_ctx->pagev)) *
+					 num_pages, GFP_NOFS);
+	if (!block_ctx->mem_to_free)
 		return -1;
+	block_ctx->datav = block_ctx->mem_to_free;
+	block_ctx->pagev = (struct page **)(block_ctx->datav + num_pages);
+	for (i = 0; i < num_pages; i++) {
+		block_ctx->pagev[i] = alloc_page(GFP_NOFS);
+		if (!block_ctx->pagev[i])
+			return -1;
 	}
 
-	block_ctx->bh = __bread(block_ctx->dev->bdev,
-				block_ctx->dev_bytenr >> 12, 4096);
-	if (NULL == block_ctx->bh)
-		return -1;
-	block_ctx->data = block_ctx->bh->b_data;
+	dev_bytenr = block_ctx->dev_bytenr;
+	for (i = 0; i < num_pages;) {
+		struct bio *bio;
+		unsigned int j;
+		DECLARE_COMPLETION_ONSTACK(complete);
+
+		bio = bio_alloc(GFP_NOFS, num_pages - i);
+		if (!bio) {
+			printk(KERN_INFO
+			       "btrfsic: bio_alloc() for %u pages failed!\n",
+			       num_pages - i);
+			return -1;
+		}
+		bio->bi_bdev = block_ctx->dev->bdev;
+		bio->bi_sector = dev_bytenr >> 9;
+		bio->bi_end_io = btrfsic_complete_bio_end_io;
+		bio->bi_private = &complete;
+
+		for (j = i; j < num_pages; j++) {
+			ret = bio_add_page(bio, block_ctx->pagev[j],
+					   PAGE_CACHE_SIZE, 0);
+			if (PAGE_CACHE_SIZE != ret)
+				break;
+		}
+		if (j == i) {
+			printk(KERN_INFO
+			       "btrfsic: error, failed to add a single page!\n");
+			return -1;
+		}
+		submit_bio(READ, bio);
+
+		/* this will also unplug the queue */
+		wait_for_completion(&complete);
+
+		if (!test_bit(BIO_UPTODATE, &bio->bi_flags)) {
+			printk(KERN_INFO
+			       "btrfsic: read error at logical %llu dev %s!\n",
+			       block_ctx->start, block_ctx->dev->name);
+			bio_put(bio);
+			return -1;
+		}
+		bio_put(bio);
+		dev_bytenr += (j - i) * PAGE_CACHE_SIZE;
+		i = j;
+	}
+	for (i = 0; i < num_pages; i++) {
+		block_ctx->datav[i] = kmap(block_ctx->pagev[i]);
+		if (!block_ctx->datav[i]) {
+			printk(KERN_INFO "btrfsic: kmap() failed (dev %s)!\n",
+			       block_ctx->dev->name);
+			return -1;
+		}
+	}
 
 	return block_ctx->len;
 }
 
+static void btrfsic_complete_bio_end_io(struct bio *bio, int err)
+{
+	complete((struct completion *)bio->bi_private);
+}
+
 static void btrfsic_dump_database(struct btrfsic_state *state)
 {
 	struct list_head *elem_all;
@@ -1618,32 +1801,39 @@ static void btrfsic_dump_database(struct btrfsic_state *state)
  * (note that this test fails for the super block)
  */
 static int btrfsic_test_for_metadata(struct btrfsic_state *state,
-				     const u8 *data, unsigned int size)
+				     char **datav, unsigned int num_pages)
 {
 	struct btrfs_header *h;
 	u8 csum[BTRFS_CSUM_SIZE];
 	u32 crc = ~(u32)0;
-	int fail = 0;
-	int crc_fail = 0;
+	unsigned int i;
 
-	h = (struct btrfs_header *)data;
+	if (num_pages * PAGE_CACHE_SIZE < state->metablock_size)
+		return 1; /* not metadata */
+	num_pages = state->metablock_size >> PAGE_CACHE_SHIFT;
+	h = (struct btrfs_header *)datav[0];
 
 	if (memcmp(h->fsid, state->root->fs_info->fsid, BTRFS_UUID_SIZE))
-		fail++;
+		return 1;
 
-	crc = crc32c(crc, data + BTRFS_CSUM_SIZE, PAGE_SIZE - BTRFS_CSUM_SIZE);
+	for (i = 0; i < num_pages; i++) {
+		u8 *data = i ? datav[i] : (datav[i] + BTRFS_CSUM_SIZE);
+		size_t sublen = i ? PAGE_CACHE_SIZE :
+				    (PAGE_CACHE_SIZE - BTRFS_CSUM_SIZE);
+
+		crc = crc32c(crc, data, sublen);
+	}
 	btrfs_csum_final(crc, csum);
 	if (memcmp(csum, h->csum, state->csum_size))
-		crc_fail++;
+		return 1;
 
-	return fail || crc_fail;
+	return 0; /* is metadata */
 }
 
 static void btrfsic_process_written_block(struct btrfsic_dev_state *dev_state,
-					  u64 dev_bytenr,
-					  u8 *mapped_data, unsigned int len,
-					  struct bio *bio,
-					  int *bio_is_patched,
+					  u64 dev_bytenr, char **mapped_datav,
+					  unsigned int num_pages,
+					  struct bio *bio, int *bio_is_patched,
 					  struct buffer_head *bh,
 					  int submit_bio_bh_rw)
 {
@@ -1653,12 +1843,19 @@ static void btrfsic_process_written_block(struct btrfsic_dev_state *dev_state,
 	int ret;
 	struct btrfsic_state *state = dev_state->state;
 	struct block_device *bdev = dev_state->bdev;
+	unsigned int processed_len;
 
-	WARN_ON(len > PAGE_SIZE);
-	is_metadata = (0 == btrfsic_test_for_metadata(state, mapped_data, len));
 	if (NULL != bio_is_patched)
 		*bio_is_patched = 0;
 
+again:
+	if (num_pages == 0)
+		return;
+
+	processed_len = 0;
+	is_metadata = (0 == btrfsic_test_for_metadata(state, mapped_datav,
+						      num_pages));
+
 	block = btrfsic_block_hashtable_lookup(bdev, dev_bytenr,
 					       &state->block_hashtable);
 	if (NULL != block) {
@@ -1668,8 +1865,16 @@ static void btrfsic_process_written_block(struct btrfsic_dev_state *dev_state,
 
 		if (block->is_superblock) {
 			bytenr = le64_to_cpu(((struct btrfs_super_block *)
-					      mapped_data)->bytenr);
+					      mapped_datav[0])->bytenr);
+			if (num_pages * PAGE_CACHE_SIZE <
+			    BTRFS_SUPER_INFO_SIZE) {
+				printk(KERN_INFO
+				       "btrfsic: cannot work with too short bios!\n");
+				return;
+			}
 			is_metadata = 1;
+			BUG_ON(BTRFS_SUPER_INFO_SIZE & (PAGE_CACHE_SIZE - 1));
+			processed_len = BTRFS_SUPER_INFO_SIZE;
 			if (state->print_mask &
 			    BTRFSIC_PRINT_MASK_TREE_BEFORE_SB_WRITE) {
 				printk(KERN_INFO
@@ -1679,12 +1884,18 @@ static void btrfsic_process_written_block(struct btrfsic_dev_state *dev_state,
 		}
 		if (is_metadata) {
 			if (!block->is_superblock) {
+				if (num_pages * PAGE_CACHE_SIZE <
+				    state->metablock_size) {
+					printk(KERN_INFO
+					       "btrfsic: cannot work with too short bios!\n");
+					return;
+				}
+				processed_len = state->metablock_size;
 				bytenr = le64_to_cpu(((struct btrfs_header *)
-						      mapped_data)->bytenr);
+						      mapped_datav[0])->bytenr);
 				btrfsic_cmp_log_and_dev_bytenr(state, bytenr,
 							       dev_state,
-							       dev_bytenr,
-							       mapped_data);
+							       dev_bytenr);
 			}
 			if (block->logical_bytenr != bytenr) {
 				printk(KERN_INFO
@@ -1711,6 +1922,13 @@ static void btrfsic_process_written_block(struct btrfsic_dev_state *dev_state,
 				       block->mirror_num,
 				       btrfsic_get_block_type(state, block));
 		} else {
+			if (num_pages * PAGE_CACHE_SIZE <
+			    state->datablock_size) {
+				printk(KERN_INFO
+				       "btrfsic: cannot work with too short bios!\n");
+				return;
+			}
+			processed_len = state->datablock_size;
 			bytenr = block->logical_bytenr;
 			if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
 				printk(KERN_INFO
@@ -1748,7 +1966,7 @@ static void btrfsic_process_written_block(struct btrfsic_dev_state *dev_state,
 			       le64_to_cpu(block->disk_key.offset),
 			       (unsigned long long)
 			       le64_to_cpu(((struct btrfs_header *)
-					    mapped_data)->generation),
+					    mapped_datav[0])->generation),
 			       (unsigned long long)
 			       state->max_superblock_generation);
 			btrfsic_dump_tree(state);
@@ -1766,10 +1984,10 @@ static void btrfsic_process_written_block(struct btrfsic_dev_state *dev_state,
 			       (unsigned long long)block->generation,
 			       (unsigned long long)
 			       le64_to_cpu(((struct btrfs_header *)
-					    mapped_data)->generation));
+					    mapped_datav[0])->generation));
 			/* it would not be safe to go on */
 			btrfsic_dump_tree(state);
-			return;
+			goto continue_loop;
 		}
 
 		/*
@@ -1797,18 +2015,19 @@ static void btrfsic_process_written_block(struct btrfsic_dev_state *dev_state,
 		}
 
 		if (block->is_superblock)
-			ret = btrfsic_map_superblock(state, bytenr, len,
+			ret = btrfsic_map_superblock(state, bytenr,
+						     processed_len,
 						     bdev, &block_ctx);
 		else
-			ret = btrfsic_map_block(state, bytenr, len,
+			ret = btrfsic_map_block(state, bytenr, processed_len,
 						&block_ctx, 0);
 		if (ret) {
 			printk(KERN_INFO
 			       "btrfsic: btrfsic_map_block(root @%llu)"
 			       " failed!\n", (unsigned long long)bytenr);
-			return;
+			goto continue_loop;
 		}
-		block_ctx.data = mapped_data;
+		block_ctx.datav = mapped_datav;
 		/* the following is required in case of writes to mirrors,
 		 * use the same that was used for the lookup */
 		block_ctx.dev = dev_state;
@@ -1864,11 +2083,13 @@ static void btrfsic_process_written_block(struct btrfsic_dev_state *dev_state,
 			block->logical_bytenr = bytenr;
 			block->is_metadata = 1;
 			if (block->is_superblock) {
+				BUG_ON(PAGE_CACHE_SIZE !=
+				       BTRFS_SUPER_INFO_SIZE);
 				ret = btrfsic_process_written_superblock(
 						state,
 						block,
 						(struct btrfs_super_block *)
-						mapped_data);
+						mapped_datav[0]);
 				if (state->print_mask &
 				    BTRFSIC_PRINT_MASK_TREE_AFTER_SB_WRITE) {
 					printk(KERN_INFO
@@ -1881,8 +2102,6 @@ static void btrfsic_process_written_block(struct btrfsic_dev_state *dev_state,
 						state,
 						block,
 						&block_ctx,
-						(struct btrfs_header *)
-						block_ctx.data,
 						0, 0);
 			}
 			if (ret)
@@ -1913,26 +2132,30 @@ static void btrfsic_process_written_block(struct btrfsic_dev_state *dev_state,
 		u64 bytenr;
 
 		if (!is_metadata) {
+			processed_len = state->datablock_size;
 			if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
 				printk(KERN_INFO "Written block (%s/%llu/?)"
 				       " !found in hash table, D.\n",
 				       dev_state->name,
 				       (unsigned long long)dev_bytenr);
-			if (!state->include_extent_data)
-				return;	/* ignore that written D block */
+			if (!state->include_extent_data) {
+				/* ignore that written D block */
+				goto continue_loop;
+			}
 
 			/* this is getting ugly for the
 			 * include_extent_data case... */
 			bytenr = 0;	/* unknown */
 			block_ctx.start = bytenr;
-			block_ctx.len = len;
-			block_ctx.bh = NULL;
+			block_ctx.len = processed_len;
+			block_ctx.mem_to_free = NULL;
+			block_ctx.pagev = NULL;
 		} else {
+			processed_len = state->metablock_size;
 			bytenr = le64_to_cpu(((struct btrfs_header *)
-					      mapped_data)->bytenr);
+					      mapped_datav[0])->bytenr);
 			btrfsic_cmp_log_and_dev_bytenr(state, bytenr, dev_state,
-						       dev_bytenr,
-						       mapped_data);
+						       dev_bytenr);
 			if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
 				printk(KERN_INFO
 				       "Written block @%llu (%s/%llu/?)"
@@ -1941,17 +2164,17 @@ static void btrfsic_process_written_block(struct btrfsic_dev_state *dev_state,
 				       dev_state->name,
 				       (unsigned long long)dev_bytenr);
 
-			ret = btrfsic_map_block(state, bytenr, len, &block_ctx,
-						0);
+			ret = btrfsic_map_block(state, bytenr, processed_len,
+						&block_ctx, 0);
 			if (ret) {
 				printk(KERN_INFO
 				       "btrfsic: btrfsic_map_block(root @%llu)"
 				       " failed!\n",
 				       (unsigned long long)dev_bytenr);
-				return;
+				goto continue_loop;
 			}
 		}
-		block_ctx.data = mapped_data;
+		block_ctx.datav = mapped_datav;
 		/* the following is required in case of writes to mirrors,
 		 * use the same that was used for the lookup */
 		block_ctx.dev = dev_state;
@@ -1961,7 +2184,7 @@ static void btrfsic_process_written_block(struct btrfsic_dev_state *dev_state,
 		if (NULL == block) {
 			printk(KERN_INFO "btrfsic: error, kmalloc failed!\n");
 			btrfsic_release_block_ctx(&block_ctx);
-			return;
+			goto continue_loop;
 		}
 		block->dev_state = dev_state;
 		block->dev_bytenr = dev_bytenr;
@@ -2021,9 +2244,7 @@ static void btrfsic_process_written_block(struct btrfsic_dev_state *dev_state,
 
 		if (is_metadata) {
 			ret = btrfsic_process_metablock(state, block,
-							&block_ctx,
-							(struct btrfs_header *)
-							block_ctx.data, 0, 0);
+							&block_ctx, 0, 0);
 			if (ret)
 				printk(KERN_INFO
 				       "btrfsic: process_metablock(root @%llu)"
@@ -2032,6 +2253,13 @@ static void btrfsic_process_written_block(struct btrfsic_dev_state *dev_state,
 		}
 		btrfsic_release_block_ctx(&block_ctx);
 	}
+
+continue_loop:
+	BUG_ON(!processed_len);
+	dev_bytenr += processed_len;
+	mapped_datav += processed_len >> PAGE_CACHE_SHIFT;
+	num_pages -= processed_len >> PAGE_CACHE_SHIFT;
+	goto again;
 }
 
 static void btrfsic_bio_end_io(struct bio *bp, int bio_error_status)
@@ -2214,7 +2442,7 @@ static int btrfsic_process_written_superblock(
 
 		num_copies =
 		    btrfs_num_copies(&state->root->fs_info->mapping_tree,
-				     next_bytenr, PAGE_SIZE);
+				     next_bytenr, BTRFS_SUPER_INFO_SIZE);
 		if (state->print_mask & BTRFSIC_PRINT_MASK_NUM_COPIES)
 			printk(KERN_INFO "num_copies(log_bytenr=%llu) = %d\n",
 			       (unsigned long long)next_bytenr, num_copies);
@@ -2225,7 +2453,8 @@ static int btrfsic_process_written_superblock(
 				printk(KERN_INFO
 				       "btrfsic_process_written_superblock("
 				       "mirror_num=%d)\n", mirror_num);
-			ret = btrfsic_map_block(state, next_bytenr, PAGE_SIZE,
+			ret = btrfsic_map_block(state, next_bytenr,
+						BTRFS_SUPER_INFO_SIZE,
 						&tmp_next_block_ctx,
 						mirror_num);
 			if (ret) {
@@ -2690,7 +2919,7 @@ static struct btrfsic_block *btrfsic_block_lookup_or_add(
 static void btrfsic_cmp_log_and_dev_bytenr(struct btrfsic_state *state,
 					   u64 bytenr,
 					   struct btrfsic_dev_state *dev_state,
-					   u64 dev_bytenr, char *data)
+					   u64 dev_bytenr)
 {
 	int num_copies;
 	int mirror_num;
@@ -2699,10 +2928,10 @@ static void btrfsic_cmp_log_and_dev_bytenr(struct btrfsic_state *state,
 	int match = 0;
 
 	num_copies = btrfs_num_copies(&state->root->fs_info->mapping_tree,
-				      bytenr, PAGE_SIZE);
+				      bytenr, state->metablock_size);
 
 	for (mirror_num = 1; mirror_num <= num_copies; mirror_num++) {
-		ret = btrfsic_map_block(state, bytenr, PAGE_SIZE,
+		ret = btrfsic_map_block(state, bytenr, state->metablock_size,
 					&block_ctx, mirror_num);
 		if (ret) {
 			printk(KERN_INFO "btrfsic:"
@@ -2728,7 +2957,8 @@ static void btrfsic_cmp_log_and_dev_bytenr(struct btrfsic_state *state,
 		       (unsigned long long)bytenr, dev_state->name,
 		       (unsigned long long)dev_bytenr);
 		for (mirror_num = 1; mirror_num <= num_copies; mirror_num++) {
-			ret = btrfsic_map_block(state, bytenr, PAGE_SIZE,
+			ret = btrfsic_map_block(state, bytenr,
+						state->metablock_size,
 						&block_ctx, mirror_num);
 			if (ret)
 				continue;
@@ -2782,13 +3012,13 @@ int btrfsic_submit_bh(int rw, struct buffer_head *bh)
 			       (unsigned long)bh->b_size, bh->b_data,
 			       bh->b_bdev);
 		btrfsic_process_written_block(dev_state, dev_bytenr,
-					      bh->b_data, bh->b_size, NULL,
+					      &bh->b_data, 1, NULL,
 					      NULL, bh, rw);
 	} else if (NULL != dev_state && (rw & REQ_FLUSH)) {
 		if (dev_state->state->print_mask &
 		    BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH)
 			printk(KERN_INFO
-			       "submit_bh(rw=0x%x) FLUSH, bdev=%p)\n",
+			       "submit_bh(rw=0x%x FLUSH, bdev=%p)\n",
 			       rw, bh->b_bdev);
 		if (!dev_state->dummy_block_for_bio_bh_flush.is_iodone) {
 			if ((dev_state->state->print_mask &
@@ -2837,6 +3067,7 @@ void btrfsic_submit_bio(int rw, struct bio *bio)
 		unsigned int i;
 		u64 dev_bytenr;
 		int bio_is_patched;
+		char **mapped_datav;
 
 		dev_bytenr = 512 * bio->bi_sector;
 		bio_is_patched = 0;
@@ -2849,35 +3080,46 @@ void btrfsic_submit_bio(int rw, struct bio *bio)
 			       (unsigned long long)dev_bytenr,
 			       bio->bi_bdev);
 
+		mapped_datav = kmalloc(sizeof(*mapped_datav) * bio->bi_vcnt,
+				       GFP_NOFS);
+		if (!mapped_datav)
+			goto leave;
 		for (i = 0; i < bio->bi_vcnt; i++) {
-			u8 *mapped_data;
-
-			mapped_data = kmap(bio->bi_io_vec[i].bv_page);
+			BUG_ON(bio->bi_io_vec[i].bv_len != PAGE_CACHE_SIZE);
+			mapped_datav[i] = kmap(bio->bi_io_vec[i].bv_page);
+			if (!mapped_datav[i]) {
+				while (i > 0) {
+					i--;
+					kunmap(bio->bi_io_vec[i].bv_page);
+				}
+				kfree(mapped_datav);
+				goto leave;
+			}
 			if ((BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH |
 			     BTRFSIC_PRINT_MASK_VERBOSE) ==
 			    (dev_state->state->print_mask &
 			     (BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH |
 			      BTRFSIC_PRINT_MASK_VERBOSE)))
 				printk(KERN_INFO
-				       "#%u: page=%p, mapped=%p, len=%u,"
-				       " offset=%u\n",
+				       "#%u: page=%p, len=%u, offset=%u\n",
 				       i, bio->bi_io_vec[i].bv_page,
-				       mapped_data,
 				       bio->bi_io_vec[i].bv_len,
 				       bio->bi_io_vec[i].bv_offset);
-			btrfsic_process_written_block(dev_state, dev_bytenr,
-						      mapped_data,
-						      bio->bi_io_vec[i].bv_len,
-						      bio, &bio_is_patched,
-						      NULL, rw);
+		}
+		btrfsic_process_written_block(dev_state, dev_bytenr,
+					      mapped_datav, bio->bi_vcnt,
+					      bio, &bio_is_patched,
+					      NULL, rw);
+		while (i > 0) {
+			i--;
 			kunmap(bio->bi_io_vec[i].bv_page);
-			dev_bytenr += bio->bi_io_vec[i].bv_len;
 		}
+		kfree(mapped_datav);
 	} else if (NULL != dev_state && (rw & REQ_FLUSH)) {
 		if (dev_state->state->print_mask &
 		    BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH)
 			printk(KERN_INFO
-			       "submit_bio(rw=0x%x) FLUSH, bdev=%p)\n",
+			       "submit_bio(rw=0x%x FLUSH, bdev=%p)\n",
 			       rw, bio->bi_bdev);
 		if (!dev_state->dummy_block_for_bio_bh_flush.is_iodone) {
 			if ((dev_state->state->print_mask &
@@ -2904,6 +3146,7 @@ void btrfsic_submit_bio(int rw, struct bio *bio)
 			bio->bi_end_io = btrfsic_bio_end_io;
 		}
 	}
+leave:
 	mutex_unlock(&btrfsic_mutex);
 
 	submit_bio(rw, bio);
@@ -2918,6 +3161,30 @@ int btrfsic_mount(struct btrfs_root *root,
 	struct list_head *dev_head = &fs_devices->devices;
 	struct btrfs_device *device;
 
+	if (root->nodesize != root->leafsize) {
+		printk(KERN_INFO
+		       "btrfsic: cannot handle nodesize %d != leafsize %d!\n",
+		       root->nodesize, root->leafsize);
+		return -1;
+	}
+	if (root->nodesize & ((u64)PAGE_CACHE_SIZE - 1)) {
+		printk(KERN_INFO
+		       "btrfsic: cannot handle nodesize %d not being a multiple of PAGE_CACHE_SIZE %ld!\n",
+		       root->nodesize, (unsigned long)PAGE_CACHE_SIZE);
+		return -1;
+	}
+	if (root->leafsize & ((u64)PAGE_CACHE_SIZE - 1)) {
+		printk(KERN_INFO
+		       "btrfsic: cannot handle leafsize %d not being a multiple of PAGE_CACHE_SIZE %ld!\n",
+		       root->leafsize, (unsigned long)PAGE_CACHE_SIZE);
+		return -1;
+	}
+	if (root->sectorsize & ((u64)PAGE_CACHE_SIZE - 1)) {
+		printk(KERN_INFO
+		       "btrfsic: cannot handle sectorsize %d not being a multiple of PAGE_CACHE_SIZE %ld!\n",
+		       root->sectorsize, (unsigned long)PAGE_CACHE_SIZE);
+		return -1;
+	}
 	state = kzalloc(sizeof(*state), GFP_NOFS);
 	if (NULL == state) {
 		printk(KERN_INFO "btrfs check-integrity: kmalloc() failed!\n");
@@ -2934,6 +3201,8 @@ int btrfsic_mount(struct btrfs_root *root,
 	state->print_mask = print_mask;
 	state->include_extent_data = including_extent_data;
 	state->csum_size = 0;
+	state->metablock_size = root->nodesize;
+	state->datablock_size = root->sectorsize;
 	INIT_LIST_HEAD(&state->all_blocks_list);
 	btrfsic_block_hashtable_init(&state->block_hashtable);
 	btrfsic_block_link_hashtable_init(&state->block_link_hashtable);
-- 
1.7.3.4

