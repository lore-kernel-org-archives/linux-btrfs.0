Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:36202 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754184Ab3GCOAl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Jul 2013 10:00:41 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r63DODx5003962
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Jul 2013 21:24:14 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH 09/12] Btrfs-progs: Add chunk recover function - using old chunk items
Date: Wed, 3 Jul 2013 21:25:17 +0800
Message-Id: <1372857920-4678-10-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1372857920-4678-1-git-send-email-miaox@cn.fujitsu.com>
References: <1372857920-4678-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add chunk-recover program to check or rebuild chunk tree when the system
chunk array or chunk tree is broken.

Due to the importance of the system chunk array and chunk tree, if one of
them is broken, the whole btrfs will be broken even other data are OK.

But we have some hint(fsid, checksum...) to salvage the old metadata.
So this function will first scan the whole file system and collect the
needed data(chunk/block group/dev extent), and check for the references
between them. If the references are OK, the chunk tree can be rebuilt and
luckily the file system will be mountable.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 Makefile      |    2 +-
 btrfs.c       |    1 +
 btrfsck.h     |   64 +++
 cmds-check.c  |  285 +++++++-----
 cmds-chunk.c  | 1399 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 commands.h    |    2 +
 disk-io.c     |   22 +-
 disk-io.h     |    1 +
 extent-tree.c |    6 -
 extent_io.h   |    6 +
 volumes.c     |   11 +-
 volumes.h     |    4 +
 12 files changed, 1672 insertions(+), 131 deletions(-)
 create mode 100644 cmds-chunk.c

diff --git a/Makefile b/Makefile
index b45235e..c43cb68 100644
--- a/Makefile
+++ b/Makefile
@@ -10,7 +10,7 @@ objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
-	       cmds-restore.o
+	       cmds-restore.o cmds-chunk.o
 libbtrfs_objects = send-stream.o send-utils.o rbtree.o btrfs-list.o crc32c.o
 libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
 	       crc32c.h list.h kerncompat.h radix-tree.h extent-cache.h \
diff --git a/btrfs.c b/btrfs.c
index 691adef..4e93e13 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -247,6 +247,7 @@ const struct cmd_group btrfs_cmd_group = {
 		{ "device", cmd_device, NULL, &device_cmd_group, 0 },
 		{ "scrub", cmd_scrub, NULL, &scrub_cmd_group, 0 },
 		{ "check", cmd_check, cmd_check_usage, NULL, 0 },
+		{ "chunk-recover", cmd_chunk_recover, cmd_chunk_recover_usage, NULL, 0},
 		{ "restore", cmd_restore, cmd_restore_usage, NULL, 0 },
 		{ "inspect-internal", cmd_inspect, NULL, &inspect_cmd_group, 0 },
 		{ "send", cmd_send, cmd_send_usage, NULL, 0 },
diff --git a/btrfsck.h b/btrfsck.h
index 37ac130..a6151d5 100644
--- a/btrfsck.h
+++ b/btrfsck.h
@@ -35,6 +35,8 @@ struct block_group_record {
 	/* Used to identify the orphan block groups */
 	struct list_head list;
 
+	u64 generation;
+
 	u64 objectid;
 	u8  type;
 	u64 offset;
@@ -51,6 +53,8 @@ struct device_record {
 	struct rb_node node;
 	u64 devid;
 
+	u64 generation;
+
 	u64 objectid;
 	u8  type;
 	u64 offset;
@@ -64,19 +68,31 @@ struct device_record {
 struct stripe {
 	u64 devid;
 	u64 offset;
+	u8 dev_uuid[BTRFS_UUID_SIZE];
 };
 
 struct chunk_record {
 	struct cache_extent cache;
 
+	struct list_head list;
+	struct list_head dextents;
+	struct block_group_record *bg_rec;
+
+	u64 generation;
+
 	u64 objectid;
 	u8  type;
 	u64 offset;
 
+	u64 owner;
 	u64 length;
 	u64 type_flags;
+	u64 stripe_len;
 	u16 num_stripes;
 	u16 sub_stripes;
+	u32 io_align;
+	u32 io_width;
+	u32 sector_size;
 	struct stripe stripes[0];
 };
 
@@ -89,6 +105,8 @@ struct device_extent_record {
 	struct list_head chunk_list;
 	struct list_head device_list;
 
+	u64 generation;
+
 	u64 objectid;
 	u8  type;
 	u64 offset;
@@ -115,4 +133,50 @@ struct device_extent_tree {
 	struct list_head no_device_orphans;
 };
 
+static inline unsigned long btrfs_chunk_record_size(int num_stripes)
+{
+	return sizeof(struct chunk_record) +
+	       sizeof(struct stripe) * num_stripes;
+}
+void free_chunk_cache_tree(struct cache_tree *chunk_cache);
+
+/* For block group tree */
+static inline void block_group_tree_init(struct block_group_tree *tree)
+{
+	cache_tree_init(&tree->tree);
+	INIT_LIST_HEAD(&tree->block_groups);
+}
+
+int insert_block_group_record(struct block_group_tree *tree,
+			      struct block_group_record *bg_rec);
+void free_block_group_tree(struct block_group_tree *tree);
+
+/* For device extent tree */
+static inline void device_extent_tree_init(struct device_extent_tree *tree)
+{
+	cache_tree_init(&tree->tree);
+	INIT_LIST_HEAD(&tree->no_chunk_orphans);
+	INIT_LIST_HEAD(&tree->no_device_orphans);
+}
+
+int insert_device_extent_record(struct device_extent_tree *tree,
+				struct device_extent_record *de_rec);
+void free_device_extent_tree(struct device_extent_tree *tree);
+
+
+/* Create various in-memory record by on-disk data */
+struct chunk_record *btrfs_new_chunk_record(struct extent_buffer *leaf,
+					    struct btrfs_key *key,
+					    int slot);
+struct block_group_record *
+btrfs_new_block_group_record(struct extent_buffer *leaf, struct btrfs_key *key,
+			     int slot);
+struct device_extent_record *
+btrfs_new_device_extent_record(struct extent_buffer *leaf,
+			       struct btrfs_key *key, int slot);
+
+int check_chunks(struct cache_tree *chunk_cache,
+		 struct block_group_tree *block_group_cache,
+		 struct device_extent_tree *dev_extent_cache,
+		 struct list_head *good, struct list_head *bad, int silent);
 #endif
diff --git a/cmds-check.c b/cmds-check.c
index c65ae68..c3c7575 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2625,7 +2625,10 @@ static void free_chunk_record(struct cache_extent *cache)
 	free(rec);
 }
 
-FREE_EXTENT_CACHE_BASED_TREE(chunk_cache, free_chunk_record);
+void free_chunk_cache_tree(struct cache_tree *chunk_cache)
+{
+	cache_tree_free_extents(chunk_cache, free_chunk_record);
+}
 
 static void free_device_record(struct rb_node *node)
 {
@@ -2637,14 +2640,8 @@ static void free_device_record(struct rb_node *node)
 
 FREE_RB_BASED_TREE(device_cache, free_device_record);
 
-static void block_group_tree_init(struct block_group_tree *tree)
-{
-	cache_tree_init(&tree->tree);
-	INIT_LIST_HEAD(&tree->block_groups);
-}
-
-static int insert_block_group_record(struct block_group_tree *tree,
-				     struct block_group_record *bg_rec)
+int insert_block_group_record(struct block_group_tree *tree,
+			      struct block_group_record *bg_rec)
 {
 	int ret;
 
@@ -2664,20 +2661,13 @@ static void free_block_group_record(struct cache_extent *cache)
 	free(rec);
 }
 
-static void free_block_group_tree(struct block_group_tree *tree)
+void free_block_group_tree(struct block_group_tree *tree)
 {
 	cache_tree_free_extents(&tree->tree, free_block_group_record);
 }
 
-static void device_extent_tree_init(struct device_extent_tree *tree)
-{
-	cache_tree_init(&tree->tree);
-	INIT_LIST_HEAD(&tree->no_chunk_orphans);
-	INIT_LIST_HEAD(&tree->no_device_orphans);
-}
-
-static int insert_device_extent_record(struct device_extent_tree *tree,
-				       struct device_extent_record *de_rec)
+int insert_device_extent_record(struct device_extent_tree *tree,
+				struct device_extent_record *de_rec)
 {
 	int ret;
 
@@ -2704,7 +2694,7 @@ static void free_device_extent_record(struct cache_extent *cache)
 	free(rec);
 }
 
-static void free_device_extent_tree(struct device_extent_tree *tree)
+void free_device_extent_tree(struct device_extent_tree *tree)
 {
 	cache_tree_free_extents(&tree->tree, free_device_extent_record);
 }
@@ -2728,50 +2718,69 @@ static int process_extent_ref_v0(struct cache_tree *extent_cache,
 }
 #endif
 
-static inline unsigned long chunk_record_size(int num_stripes)
-{
-	return sizeof(struct chunk_record) +
-	       sizeof(struct stripe) * num_stripes;
-}
-
-static int process_chunk_item(struct cache_tree *chunk_cache,
-		struct btrfs_key *key, struct extent_buffer *eb, int slot)
+struct chunk_record *btrfs_new_chunk_record(struct extent_buffer *leaf,
+					    struct btrfs_key *key,
+					    int slot)
 {
 	struct btrfs_chunk *ptr;
 	struct chunk_record *rec;
 	int num_stripes, i;
-	int ret = 0;
-
-	ptr = btrfs_item_ptr(eb,
-		slot, struct btrfs_chunk);
 
-	num_stripes = btrfs_chunk_num_stripes(eb, ptr);
+	ptr = btrfs_item_ptr(leaf, slot, struct btrfs_chunk);
+	num_stripes = btrfs_chunk_num_stripes(leaf, ptr);
 
-	rec = malloc(chunk_record_size(num_stripes));
+	rec = malloc(btrfs_chunk_record_size(num_stripes));
 	if (!rec) {
 		fprintf(stderr, "memory allocation failed\n");
-		return -ENOMEM;
+		exit(-1);
 	}
 
+	memset(rec, 0, btrfs_chunk_record_size(num_stripes));
+
+	INIT_LIST_HEAD(&rec->list);
+	INIT_LIST_HEAD(&rec->dextents);
+	rec->bg_rec = NULL;
+
 	rec->cache.start = key->offset;
-	rec->cache.size = btrfs_chunk_length(eb, ptr);
+	rec->cache.size = btrfs_chunk_length(leaf, ptr);
+
+	rec->generation = btrfs_header_generation(leaf);
 
 	rec->objectid = key->objectid;
 	rec->type = key->type;
 	rec->offset = key->offset;
 
 	rec->length = rec->cache.size;
-	rec->type_flags = btrfs_chunk_type(eb, ptr);
+	rec->owner = btrfs_chunk_owner(leaf, ptr);
+	rec->stripe_len = btrfs_chunk_stripe_len(leaf, ptr);
+	rec->type_flags = btrfs_chunk_type(leaf, ptr);
+	rec->io_width = btrfs_chunk_io_width(leaf, ptr);
+	rec->io_align = btrfs_chunk_io_align(leaf, ptr);
+	rec->sector_size = btrfs_chunk_sector_size(leaf, ptr);
 	rec->num_stripes = num_stripes;
-	rec->sub_stripes = btrfs_chunk_sub_stripes(eb, ptr);
+	rec->sub_stripes = btrfs_chunk_sub_stripes(leaf, ptr);
 
 	for (i = 0; i < rec->num_stripes; ++i) {
 		rec->stripes[i].devid =
-			btrfs_stripe_devid_nr(eb, ptr, i);
+			btrfs_stripe_devid_nr(leaf, ptr, i);
 		rec->stripes[i].offset =
-			btrfs_stripe_offset_nr(eb, ptr, i);
+			btrfs_stripe_offset_nr(leaf, ptr, i);
+		read_extent_buffer(leaf, rec->stripes[i].dev_uuid,
+				(unsigned long)btrfs_stripe_dev_uuid_nr(ptr, i),
+				BTRFS_UUID_SIZE);
 	}
 
+	return rec;
+}
+
+static int process_chunk_item(struct cache_tree *chunk_cache,
+			      struct btrfs_key *key, struct extent_buffer *eb,
+			      int slot)
+{
+	struct chunk_record *rec;
+	int ret = 0;
+
+	rec = btrfs_new_chunk_record(eb, key, slot);
 	ret = insert_cache_extent(chunk_cache, &rec->cache);
 	if (ret) {
 		fprintf(stderr, "Chunk[%llu, %llu] existed.\n",
@@ -2799,6 +2808,7 @@ static int process_device_item(struct rb_root *dev_cache,
 	}
 
 	rec->devid = key->offset;
+	rec->generation = btrfs_header_generation(eb);
 
 	rec->objectid = key->objectid;
 	rec->type = key->type;
@@ -2817,30 +2827,45 @@ static int process_device_item(struct rb_root *dev_cache,
 	return ret;
 }
 
-static int process_block_group_item(struct block_group_tree *block_group_cache,
-		struct btrfs_key *key, struct extent_buffer *eb, int slot)
+struct block_group_record *
+btrfs_new_block_group_record(struct extent_buffer *leaf, struct btrfs_key *key,
+			     int slot)
 {
 	struct btrfs_block_group_item *ptr;
 	struct block_group_record *rec;
-	int ret = 0;
-
-	ptr = btrfs_item_ptr(eb, slot,
-		struct btrfs_block_group_item);
 
 	rec = malloc(sizeof(*rec));
 	if (!rec) {
 		fprintf(stderr, "memory allocation failed\n");
-		return -ENOMEM;
+		exit(-1);
 	}
+	memset(rec, 0, sizeof(*rec));
 
 	rec->cache.start = key->objectid;
 	rec->cache.size = key->offset;
 
+	rec->generation = btrfs_header_generation(leaf);
+
 	rec->objectid = key->objectid;
 	rec->type = key->type;
 	rec->offset = key->offset;
-	rec->flags = btrfs_disk_block_group_flags(eb, ptr);
 
+	ptr = btrfs_item_ptr(leaf, slot, struct btrfs_block_group_item);
+	rec->flags = btrfs_disk_block_group_flags(leaf, ptr);
+
+	INIT_LIST_HEAD(&rec->list);
+
+	return rec;
+}
+
+static int process_block_group_item(struct block_group_tree *block_group_cache,
+				    struct btrfs_key *key,
+				    struct extent_buffer *eb, int slot)
+{
+	struct block_group_record *rec;
+	int ret = 0;
+
+	rec = btrfs_new_block_group_record(eb, key, slot);
 	ret = insert_block_group_record(block_group_cache, rec);
 	if (ret) {
 		fprintf(stderr, "Block Group[%llu, %llu] existed.\n",
@@ -2851,42 +2876,56 @@ static int process_block_group_item(struct block_group_tree *block_group_cache,
 	return ret;
 }
 
-static int
-process_device_extent_item(struct device_extent_tree *dev_extent_cache,
-			   struct btrfs_key *key, struct extent_buffer *eb,
-			   int slot)
+struct device_extent_record *
+btrfs_new_device_extent_record(struct extent_buffer *leaf,
+			       struct btrfs_key *key, int slot)
 {
-	int ret = 0;
-
-	struct btrfs_dev_extent *ptr;
 	struct device_extent_record *rec;
-
-	ptr = btrfs_item_ptr(eb,
-		slot, struct btrfs_dev_extent);
+	struct btrfs_dev_extent *ptr;
 
 	rec = malloc(sizeof(*rec));
 	if (!rec) {
 		fprintf(stderr, "memory allocation failed\n");
-		return -ENOMEM;
+		exit(-1);
 	}
+	memset(rec, 0, sizeof(*rec));
 
 	rec->cache.objectid = key->objectid;
 	rec->cache.start = key->offset;
 
+	rec->generation = btrfs_header_generation(leaf);
+
 	rec->objectid = key->objectid;
 	rec->type = key->type;
 	rec->offset = key->offset;
 
+	ptr = btrfs_item_ptr(leaf, slot, struct btrfs_dev_extent);
 	rec->chunk_objecteid =
-		btrfs_dev_extent_chunk_objectid(eb, ptr);
+		btrfs_dev_extent_chunk_objectid(leaf, ptr);
 	rec->chunk_offset =
-		btrfs_dev_extent_chunk_offset(eb, ptr);
-	rec->length = btrfs_dev_extent_length(eb, ptr);
+		btrfs_dev_extent_chunk_offset(leaf, ptr);
+	rec->length = btrfs_dev_extent_length(leaf, ptr);
 	rec->cache.size = rec->length;
 
+	INIT_LIST_HEAD(&rec->chunk_list);
+	INIT_LIST_HEAD(&rec->device_list);
+
+	return rec;
+}
+
+static int
+process_device_extent_item(struct device_extent_tree *dev_extent_cache,
+			   struct btrfs_key *key, struct extent_buffer *eb,
+			   int slot)
+{
+	struct device_extent_record *rec;
+	int ret;
+
+	rec = btrfs_new_device_extent_record(eb, key, slot);
 	ret = insert_device_extent_record(dev_extent_cache, rec);
 	if (ret) {
-		fprintf(stderr, "Device extent[%llu, %llu, %llu] existed.\n",
+		fprintf(stderr,
+			"Device extent[%llu, %llu, %llu] existed.\n",
 			rec->objectid, rec->offset, rec->length);
 		free(rec);
 	}
@@ -4911,7 +4950,8 @@ static u64 calc_stripe_length(struct chunk_record *chunk_rec)
 
 static int check_chunk_refs(struct chunk_record *chunk_rec,
 			    struct block_group_tree *block_group_cache,
-			    struct device_extent_tree *dev_extent_cache)
+			    struct device_extent_tree *dev_extent_cache,
+			    int silent)
 {
 	struct cache_extent *block_group_item;
 	struct block_group_record *block_group_rec;
@@ -4933,32 +4973,36 @@ static int check_chunk_refs(struct chunk_record *chunk_rec,
 		if (chunk_rec->length != block_group_rec->offset ||
 		    chunk_rec->offset != block_group_rec->objectid ||
 		    chunk_rec->type_flags != block_group_rec->flags) {
+			if (!silent)
+				fprintf(stderr,
+					"Chunk[%llu, %u, %llu]: length(%llu), offset(%llu), type(%llu) mismatch with block group[%llu, %u, %llu]: offset(%llu), objectid(%llu), flags(%llu)\n",
+					chunk_rec->objectid,
+					chunk_rec->type,
+					chunk_rec->offset,
+					chunk_rec->length,
+					chunk_rec->offset,
+					chunk_rec->type_flags,
+					block_group_rec->objectid,
+					block_group_rec->type,
+					block_group_rec->offset,
+					block_group_rec->offset,
+					block_group_rec->objectid,
+					block_group_rec->flags);
+			ret = -1;
+		} else {
+			list_del_init(&block_group_rec->list);
+			chunk_rec->bg_rec = block_group_rec;
+		}
+	} else {
+		if (!silent)
 			fprintf(stderr,
-				"Chunk[%llu, %u, %llu]: length(%llu), offset(%llu), type(%llu) mismatch with block group[%llu, %u, %llu]: offset(%llu), objectid(%llu), flags(%llu)\n",
+				"Chunk[%llu, %u, %llu]: length(%llu), offset(%llu), type(%llu) is not found in block group\n",
 				chunk_rec->objectid,
 				chunk_rec->type,
 				chunk_rec->offset,
 				chunk_rec->length,
 				chunk_rec->offset,
-				chunk_rec->type_flags,
-				block_group_rec->objectid,
-				block_group_rec->type,
-				block_group_rec->offset,
-				block_group_rec->offset,
-				block_group_rec->objectid,
-				block_group_rec->flags);
-			ret = -1;
-		}
-		list_del(&block_group_rec->list);
-	} else {
-		fprintf(stderr,
-			"Chunk[%llu, %u, %llu]: length(%llu), offset(%llu), type(%llu) is not found in block group\n",
-			chunk_rec->objectid,
-			chunk_rec->type,
-			chunk_rec->offset,
-			chunk_rec->length,
-			chunk_rec->offset,
-			chunk_rec->type_flags);
+				chunk_rec->type_flags);
 		ret = -1;
 	}
 
@@ -4976,27 +5020,31 @@ static int check_chunk_refs(struct chunk_record *chunk_rec,
 			    dev_extent_rec->offset != offset ||
 			    dev_extent_rec->chunk_offset != chunk_rec->offset ||
 			    dev_extent_rec->length != length) {
+				if (!silent)
+					fprintf(stderr,
+						"Chunk[%llu, %u, %llu] stripe[%llu, %llu] dismatch dev extent[%llu, %llu, %llu]\n",
+						chunk_rec->objectid,
+						chunk_rec->type,
+						chunk_rec->offset,
+						chunk_rec->stripes[i].devid,
+						chunk_rec->stripes[i].offset,
+						dev_extent_rec->objectid,
+						dev_extent_rec->offset,
+						dev_extent_rec->length);
+				ret = -1;
+			} else {
+				list_move(&dev_extent_rec->chunk_list,
+					  &chunk_rec->dextents);
+			}
+		} else {
+			if (!silent)
 				fprintf(stderr,
-					"Chunk[%llu, %u, %llu] stripe[%llu, %llu] dismatch dev extent[%llu, %llu, %llu]\n",
+					"Chunk[%llu, %u, %llu] stripe[%llu, %llu] is not found in dev extent\n",
 					chunk_rec->objectid,
 					chunk_rec->type,
 					chunk_rec->offset,
 					chunk_rec->stripes[i].devid,
-					chunk_rec->stripes[i].offset,
-					dev_extent_rec->objectid,
-					dev_extent_rec->offset,
-					dev_extent_rec->length);
-				ret = -1;
-			}
-			list_del(&dev_extent_rec->chunk_list);
-		} else {
-			fprintf(stderr,
-				"Chunk[%llu, %u, %llu] stripe[%llu, %llu] is not found in dev extent\n",
-				chunk_rec->objectid,
-				chunk_rec->type,
-				chunk_rec->offset,
-				chunk_rec->stripes[i].devid,
-				chunk_rec->stripes[i].offset);
+					chunk_rec->stripes[i].offset);
 			ret = -1;
 		}
 	}
@@ -5004,9 +5052,10 @@ static int check_chunk_refs(struct chunk_record *chunk_rec,
 }
 
 /* check btrfs_chunk -> btrfs_dev_extent / btrfs_block_group_item */
-static int check_chunks(struct cache_tree *chunk_cache,
-			struct block_group_tree *block_group_cache,
-			struct device_extent_tree *dev_extent_cache)
+int check_chunks(struct cache_tree *chunk_cache,
+		 struct block_group_tree *block_group_cache,
+		 struct device_extent_tree *dev_extent_cache,
+		 struct list_head *good, struct list_head *bad, int silent)
 {
 	struct cache_extent *chunk_item;
 	struct chunk_record *chunk_rec;
@@ -5020,26 +5069,38 @@ static int check_chunks(struct cache_tree *chunk_cache,
 		chunk_rec = container_of(chunk_item, struct chunk_record,
 					 cache);
 		err = check_chunk_refs(chunk_rec, block_group_cache,
-				       dev_extent_cache);
-		if (err)
+				       dev_extent_cache, silent);
+		if (err) {
 			ret = err;
+			if (bad)
+				list_add_tail(&chunk_rec->list, bad);
+		} else {
+			if (good)
+				list_add_tail(&chunk_rec->list, good);
+		}
 
 		chunk_item = next_cache_extent(chunk_item);
 	}
 
 	list_for_each_entry(bg_rec, &block_group_cache->block_groups, list) {
-		fprintf(stderr,
-			"Block group[%llu, %llu] (flags = %llu) didn't find the relative chunk.\n",
-			bg_rec->objectid, bg_rec->offset, bg_rec->flags);
+		if (!silent)
+			fprintf(stderr,
+				"Block group[%llu, %llu] (flags = %llu) didn't find the relative chunk.\n",
+				bg_rec->objectid,
+				bg_rec->offset,
+				bg_rec->flags);
 		if (!ret)
 			ret = 1;
 	}
 
 	list_for_each_entry(dext_rec, &dev_extent_cache->no_chunk_orphans,
 			    chunk_list) {
-		fprintf(stderr,
-			"Device extent[%llu, %llu, %llu] didn't find the relative chunk.\n",
-			dext_rec->objectid, dext_rec->offset, dext_rec->length);
+		if (!silent)
+			fprintf(stderr,
+				"Device extent[%llu, %llu, %llu] didn't find the relative chunk.\n",
+				dext_rec->objectid,
+				dext_rec->offset,
+				dext_rec->length);
 		if (!ret)
 			ret = 1;
 	}
@@ -5237,7 +5298,7 @@ again:
 	}
 
 	err = check_chunks(&chunk_cache, &block_group_cache,
-			   &dev_extent_cache);
+			   &dev_extent_cache, NULL, NULL, 0);
 	if (err && !ret)
 		ret = err;
 
diff --git a/cmds-chunk.c b/cmds-chunk.c
new file mode 100644
index 0000000..35577ed
--- /dev/null
+++ b/cmds-chunk.c
@@ -0,0 +1,1399 @@
+/*
+ * Copyright (C) 2013 Fujitsu.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+#define _XOPEN_SOURCE 500
+#define _GNU_SOURCE
+
+#include <stdio.h>
+#include <stdio_ext.h>
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <uuid/uuid.h>
+
+#include "kerncompat.h"
+#include "list.h"
+#include "radix-tree.h"
+#include "ctree.h"
+#include "extent-cache.h"
+#include "disk-io.h"
+#include "volumes.h"
+#include "transaction.h"
+#include "crc32c.h"
+#include "utils.h"
+#include "version.h"
+#include "btrfsck.h"
+#include "commands.h"
+
+#define BTRFS_CHUNK_TREE_REBUILD_ABORTED	-7500
+
+struct recover_control {
+	int verbose;
+	int yes;
+
+	u16 csum_size;
+	u32 sectorsize;
+	u32 leafsize;
+	u64 generation;
+	u64 chunk_root_generation;
+
+	struct btrfs_fs_devices *fs_devices;
+
+	struct cache_tree chunk;
+	struct block_group_tree bg;
+	struct device_extent_tree devext;
+
+	struct list_head good_chunks;
+	struct list_head bad_chunks;
+};
+
+static struct btrfs_chunk *create_chunk_item(struct chunk_record *record)
+{
+	struct btrfs_chunk *ret;
+	struct btrfs_stripe *chunk_stripe;
+	int i;
+
+	if (!record || record->num_stripes == 0)
+		return NULL;
+	ret = malloc(btrfs_chunk_item_size(record->num_stripes));
+	if (!ret)
+		return NULL;
+	btrfs_set_stack_chunk_length(ret, record->length);
+	btrfs_set_stack_chunk_owner(ret, record->owner);
+	btrfs_set_stack_chunk_stripe_len(ret, record->stripe_len);
+	btrfs_set_stack_chunk_type(ret, record->type_flags);
+	btrfs_set_stack_chunk_io_align(ret, record->io_align);
+	btrfs_set_stack_chunk_io_width(ret, record->io_width);
+	btrfs_set_stack_chunk_sector_size(ret, record->sector_size);
+	btrfs_set_stack_chunk_num_stripes(ret, record->num_stripes);
+	btrfs_set_stack_chunk_sub_stripes(ret, record->sub_stripes);
+	for (i = 0, chunk_stripe = &ret->stripe; i < record->num_stripes;
+	     i++, chunk_stripe++) {
+		btrfs_set_stack_stripe_devid(chunk_stripe,
+				record->stripes[i].devid);
+		btrfs_set_stack_stripe_offset(chunk_stripe,
+				record->stripes[i].offset);
+		memcpy(chunk_stripe->dev_uuid, record->stripes[i].dev_uuid,
+		       BTRFS_UUID_SIZE);
+	}
+	return ret;
+}
+
+void init_recover_control(struct recover_control *rc, int verbose, int yes)
+{
+	memset(rc, 0, sizeof(struct recover_control));
+	cache_tree_init(&rc->chunk);
+	block_group_tree_init(&rc->bg);
+	device_extent_tree_init(&rc->devext);
+
+	INIT_LIST_HEAD(&rc->good_chunks);
+	INIT_LIST_HEAD(&rc->bad_chunks);
+
+	rc->verbose = verbose;
+	rc->yes = yes;
+}
+
+void free_recover_control(struct recover_control *rc)
+{
+	free_block_group_tree(&rc->bg);
+	free_chunk_cache_tree(&rc->chunk);
+	free_device_extent_tree(&rc->devext);
+}
+
+static int process_block_group_item(struct block_group_tree *bg_cache,
+				    struct extent_buffer *leaf,
+				    struct btrfs_key *key, int slot)
+{
+	struct block_group_record *rec;
+	struct block_group_record *exist;
+	struct cache_extent *cache;
+	int ret = 0;
+
+	rec = btrfs_new_block_group_record(leaf, key, slot);
+	if (!rec->cache.size)
+		goto free_out;
+again:
+	cache = lookup_cache_extent(&bg_cache->tree,
+				    rec->cache.start,
+				    rec->cache.size);
+	if (cache) {
+		exist = container_of(cache, struct block_group_record, cache);
+
+		/*check the generation and replace if needed*/
+		if (exist->generation > rec->generation)
+			goto free_out;
+		if (exist->generation == rec->generation) {
+			int offset = offsetof(struct block_group_record,
+					      generation);
+			/*
+			 * According to the current kernel code, the following
+			 * case is impossble, or there is something wrong in
+			 * the kernel code.
+			 */
+			if (memcmp(((void *)exist) + offset,
+				   ((void *)rec) + offset,
+				   sizeof(*rec) - offset))
+				ret = -EEXIST;
+			goto free_out;
+		}
+		remove_cache_extent(&bg_cache->tree, cache);
+		list_del_init(&exist->list);
+		free(exist);
+		/*
+		 * We must do seach again to avoid the following cache.
+		 * /--old bg 1--//--old bg 2--/
+		 *        /--new bg--/
+		 */
+		goto again;
+	}
+
+	ret = insert_block_group_record(bg_cache, rec);
+	BUG_ON(ret);
+out:
+	return ret;
+free_out:
+	free(rec);
+	goto out;
+}
+
+static int process_chunk_item(struct cache_tree *chunk_cache,
+			      struct extent_buffer *leaf, struct btrfs_key *key,
+			      int slot)
+{
+	struct chunk_record *rec;
+	struct chunk_record *exist;
+	struct cache_extent *cache;
+	int ret = 0;
+
+	rec = btrfs_new_chunk_record(leaf, key, slot);
+	if (!rec->cache.size)
+		goto free_out;
+again:
+	cache = lookup_cache_extent(chunk_cache, rec->offset, rec->length);
+	if (cache) {
+		exist = container_of(cache, struct chunk_record, cache);
+
+		if (exist->generation > rec->generation)
+			goto free_out;
+		if (exist->generation == rec->generation) {
+			int num_stripes = rec->num_stripes;
+			int rec_size = btrfs_chunk_record_size(num_stripes);
+			int offset = offsetof(struct chunk_record, generation);
+
+			if (exist->num_stripes != rec->num_stripes ||
+			    memcmp(((void *)exist) + offset,
+				   ((void *)rec) + offset,
+				   rec_size - offset))
+				ret = -EEXIST;
+			goto free_out;
+		}
+		remove_cache_extent(chunk_cache, cache);
+		free(exist);
+		goto again;
+	}
+	ret = insert_cache_extent(chunk_cache, &rec->cache);
+	BUG_ON(ret);
+out:
+	return ret;
+free_out:
+	free(rec);
+	goto out;
+}
+
+static int process_device_extent_item(struct device_extent_tree *devext_cache,
+				      struct extent_buffer *leaf,
+				      struct btrfs_key *key, int slot)
+{
+	struct device_extent_record *rec;
+	struct device_extent_record *exist;
+	struct cache_extent *cache;
+	int ret = 0;
+
+	rec = btrfs_new_device_extent_record(leaf, key, slot);
+	if (!rec->cache.size)
+		goto free_out;
+again:
+	cache = lookup_cache_extent2(&devext_cache->tree,
+				     rec->cache.objectid,
+				     rec->cache.start,
+				     rec->cache.size);
+	if (cache) {
+		exist = container_of(cache, struct device_extent_record, cache);
+		if (exist->generation > rec->generation)
+			goto free_out;
+		if (exist->generation == rec->generation) {
+			int offset = offsetof(struct device_extent_record,
+					      generation);
+			if (memcmp(((void *)exist) + offset,
+				   ((void *)rec) + offset,
+				   sizeof(*rec) - offset))
+				ret = -EEXIST;
+			goto free_out;
+		}
+		remove_cache_extent(&devext_cache->tree, cache);
+		list_del_init(&exist->chunk_list);
+		list_del_init(&exist->device_list);
+		free(exist);
+		goto again;
+	}
+
+	ret = insert_device_extent_record(devext_cache, rec);
+	BUG_ON(ret);
+out:
+	return ret;
+free_out:
+	free(rec);
+	goto out;
+}
+
+static void print_block_group_info(struct block_group_record *rec, char *prefix)
+{
+	if (prefix)
+		printf("%s", prefix);
+	printf("Block Group: start = %llu, len = %llu, flag = %llx\n",
+	       rec->objectid, rec->offset, rec->flags);
+}
+
+static void print_block_group_tree(struct block_group_tree *tree)
+{
+	struct cache_extent *cache;
+	struct block_group_record *rec;
+
+	printf("All Block Groups:\n");
+	for (cache = first_cache_extent(&tree->tree); cache;
+	     cache = next_cache_extent(cache)) {
+		rec = container_of(cache, struct block_group_record, cache);
+		print_block_group_info(rec, "\t");
+	}
+	printf("\n");
+}
+
+static void print_stripe_info(struct stripe *data, char *prefix1, char *prefix2,
+			      int index)
+{
+	if (prefix1)
+		printf("%s", prefix1);
+	if (prefix2)
+		printf("%s", prefix2);
+	printf("[%2d] Stripe: devid = %llu, offset = %llu\n",
+	       index, data->devid, data->offset);
+}
+
+static void print_chunk_self_info(struct chunk_record *rec, char *prefix)
+{
+	int i;
+
+	if (prefix)
+		printf("%s", prefix);
+	printf("Chunk: start = %llu, len = %llu, type = %llx, num_stripes = %u\n",
+	       rec->offset, rec->length, rec->type_flags, rec->num_stripes);
+	if (prefix)
+		printf("%s", prefix);
+	printf("    Stripes list:\n");
+	for (i = 0; i < rec->num_stripes; i++)
+		print_stripe_info(&rec->stripes[i], prefix, "    ", i);
+}
+
+static void print_chunk_tree(struct cache_tree *tree)
+{
+	struct cache_extent *n;
+	struct chunk_record *entry;
+
+	printf("All Chunks:\n");
+	for (n = first_cache_extent(tree); n;
+	     n = next_cache_extent(n)) {
+		entry = container_of(n, struct chunk_record, cache);
+		print_chunk_self_info(entry, "\t");
+	}
+	printf("\n");
+}
+
+static void print_device_extent_info(struct device_extent_record *rec,
+				     char *prefix)
+{
+	if (prefix)
+		printf("%s", prefix);
+	printf("Device extent: devid = %llu, start = %llu, len = %llu, chunk offset = %llu\n",
+	       rec->objectid, rec->offset, rec->length, rec->chunk_offset);
+}
+
+static void print_device_extent_tree(struct device_extent_tree *tree)
+{
+	struct cache_extent *n;
+	struct device_extent_record *entry;
+
+	printf("All Device Extents:\n");
+	for (n = first_cache_extent(&tree->tree); n;
+	     n = next_cache_extent(n)) {
+		entry = container_of(n, struct device_extent_record, cache);
+		print_device_extent_info(entry, "\t");
+	}
+	printf("\n");
+}
+
+static void print_device_info(struct btrfs_device *device, char *prefix)
+{
+	if (prefix)
+		printf("%s", prefix);
+	printf("Device: id = %llu, name = %s\n",
+	       device->devid, device->name);
+}
+
+static void print_all_devices(struct list_head *devices)
+{
+	struct btrfs_device *dev;
+
+	printf("All Devices:\n");
+	list_for_each_entry(dev, devices, dev_list)
+		print_device_info(dev, "\t");
+	printf("\n");
+}
+
+static void print_scan_result(struct recover_control *rc)
+{
+	if (!rc->verbose)
+		return;
+
+	printf("DEVICE SCAN RESULT:\n");
+	printf("Filesystem Information:\n");
+	printf("\tsectorsize: %d\n", rc->sectorsize);
+	printf("\tleafsize: %d\n", rc->leafsize);
+	printf("\ttree root generation: %llu\n", rc->generation);
+	printf("\tchunk root generation: %llu\n", rc->chunk_root_generation);
+	printf("\n");
+
+	print_all_devices(&rc->fs_devices->devices);
+	print_block_group_tree(&rc->bg);
+	print_chunk_tree(&rc->chunk);
+	print_device_extent_tree(&rc->devext);
+}
+
+static void print_chunk_info(struct chunk_record *chunk, char *prefix)
+{
+	struct device_extent_record *devext;
+	int i;
+
+	print_chunk_self_info(chunk, prefix);
+	if (prefix)
+		printf("%s", prefix);
+	if (chunk->bg_rec)
+		print_block_group_info(chunk->bg_rec, "    ");
+	else
+		printf("    No block group.\n");
+	if (prefix)
+		printf("%s", prefix);
+	if (list_empty(&chunk->dextents)) {
+		printf("    No device extent.\n");
+	} else {
+		printf("    Device extent list:\n");
+		i = 0;
+		list_for_each_entry(devext, &chunk->dextents, chunk_list) {
+			if (prefix)
+				printf("%s", prefix);
+			printf("%s[%2d]", "        ", i);
+			print_device_extent_info(devext, NULL);
+			i++;
+		}
+	}
+}
+
+static void print_check_result(struct recover_control *rc)
+{
+	struct chunk_record *chunk;
+	struct block_group_record *bg;
+	struct device_extent_record *devext;
+	int total = 0;
+	int good = 0;
+	int bad = 0;
+
+	if (!rc->verbose)
+		return;
+
+	printf("CHECK RESULT:\n");
+	printf("Healthy Chunks:\n");
+	list_for_each_entry(chunk, &rc->good_chunks, list) {
+		print_chunk_info(chunk, "  ");
+		good++;
+		total++;
+	}
+	printf("Bad Chunks:\n");
+	list_for_each_entry(chunk, &rc->bad_chunks, list) {
+		print_chunk_info(chunk, "  ");
+		bad++;
+		total++;
+	}
+	printf("\n");
+	printf("Total Chunks:\t%d\n", total);
+	printf("  Heathy:\t%d\n", good);
+	printf("  Bad:\t%d\n", bad);
+
+	printf("\n");
+	printf("Orphan Block Groups:\n");
+	list_for_each_entry(bg, &rc->bg.block_groups, list)
+		print_block_group_info(bg, "  ");
+
+	printf("\n");
+	printf("Orphan Device Extents:\n");
+	list_for_each_entry(devext, &rc->devext.no_chunk_orphans, chunk_list)
+		print_device_extent_info(devext, "  ");
+}
+
+static int check_chunk_by_metadata(struct recover_control *rc,
+				   struct btrfs_root *root,
+				   struct chunk_record *chunk, int bg_only)
+{
+	int ret;
+	int i;
+	int slot;
+	struct btrfs_path path;
+	struct btrfs_key key;
+	struct btrfs_root *dev_root;
+	struct stripe *stripe;
+	struct btrfs_dev_extent *dev_extent;
+	struct btrfs_block_group_item *bg_ptr;
+	struct extent_buffer *l;
+
+	btrfs_init_path(&path);
+
+	if (bg_only)
+		goto bg_check;
+
+	dev_root = root->fs_info->dev_root;
+	for (i = 0; i < chunk->num_stripes; i++) {
+		stripe = &chunk->stripes[i];
+
+		key.objectid = stripe->devid;
+		key.offset = stripe->offset;
+		key.type = BTRFS_DEV_EXTENT_KEY;
+
+		ret = btrfs_search_slot(NULL, dev_root, &key, &path, 0, 0);
+		if (ret < 0) {
+			fprintf(stderr, "Search device extent failed(%d)\n",
+				ret);
+			btrfs_release_path(root, &path);
+			return ret;
+		} else if (ret > 0) {
+			if (rc->verbose)
+				fprintf(stderr,
+					"No device extent[%llu, %llu]\n",
+					stripe->devid, stripe->offset);
+			btrfs_release_path(root, &path);
+			return -ENOENT;
+		}
+		l = path.nodes[0];
+		slot = path.slots[0];
+		dev_extent = btrfs_item_ptr(l, slot, struct btrfs_dev_extent);
+		if (chunk->offset !=
+		    btrfs_dev_extent_chunk_offset(l, dev_extent)) {
+			if (rc->verbose)
+				fprintf(stderr,
+					"Device tree unmatch with chunks dev_extent[%llu, %llu], chunk[%llu, %llu]\n",
+					btrfs_dev_extent_chunk_offset(l,
+								dev_extent),
+					btrfs_dev_extent_length(l, dev_extent),
+					chunk->offset, chunk->length);
+			btrfs_release_path(root, &path);
+			return -ENOENT;
+		}
+		btrfs_release_path(root, &path);
+	}
+
+bg_check:
+	key.objectid = chunk->offset;
+	key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
+	key.offset = chunk->length;
+
+	ret = btrfs_search_slot(NULL, root->fs_info->extent_root, &key, &path,
+				0, 0);
+	if (ret < 0) {
+		fprintf(stderr, "Search block group failed(%d)\n", ret);
+		btrfs_release_path(root, &path);
+		return ret;
+	} else if (ret > 0) {
+		if (rc->verbose)
+			fprintf(stderr, "No block group[%llu, %llu]\n",
+				key.objectid, key.offset);
+		btrfs_release_path(root, &path);
+		return -ENOENT;
+	}
+
+	l = path.nodes[0];
+	slot = path.slots[0];
+	bg_ptr = btrfs_item_ptr(l, slot, struct btrfs_block_group_item);
+	if (chunk->type_flags != btrfs_disk_block_group_flags(l, bg_ptr)) {
+		if (rc->verbose)
+			fprintf(stderr,
+				"Chunk[%llu, %llu]'s type(%llu) is differemt with Block Group's type(%llu)\n",
+				chunk->offset, chunk->length, chunk->type_flags,
+				btrfs_disk_block_group_flags(l, bg_ptr));
+		btrfs_release_path(root, &path);
+		return -ENOENT;
+	}
+	btrfs_release_path(root, &path);
+	return 0;
+}
+
+static int check_all_chunks_by_metadata(struct recover_control *rc,
+					struct btrfs_root *root)
+{
+	struct chunk_record *chunk;
+	LIST_HEAD(orphan_chunks);
+	int ret = 0;
+	int err;
+
+	list_for_each_entry(chunk, &rc->good_chunks, list) {
+		err = check_chunk_by_metadata(rc, root, chunk, 0);
+		if (err) {
+			if (err == -ENOENT)
+				list_move_tail(&chunk->list, &orphan_chunks);
+			else if (err && !ret)
+				ret = err;
+		}
+	}
+
+	list_for_each_entry(chunk, &rc->bad_chunks, list) {
+		err = check_chunk_by_metadata(rc, root, chunk, 1);
+		if (err != -ENOENT && !ret)
+			ret = err ? err : -EINVAL;
+	}
+	list_splice(&orphan_chunks, &rc->bad_chunks);
+	return ret;
+}
+
+static int extract_metadata_record(struct recover_control *rc,
+				   struct extent_buffer *leaf)
+{
+	struct btrfs_key key;
+	int ret = 0;
+	int i;
+	u32 nritems;
+
+	nritems = btrfs_header_nritems(leaf);
+	for (i = 0; i < nritems; i++) {
+		btrfs_item_key_to_cpu(leaf, &key, i);
+		switch (key.type) {
+		case BTRFS_BLOCK_GROUP_ITEM_KEY:
+			ret = process_block_group_item(&rc->bg, leaf, &key, i);
+			break;
+		case BTRFS_CHUNK_ITEM_KEY:
+			ret = process_chunk_item(&rc->chunk, leaf, &key, i);
+			break;
+		case BTRFS_DEV_EXTENT_KEY:
+			ret = process_device_extent_item(&rc->devext, leaf,
+							 &key, i);
+			break;
+		}
+		if (ret)
+			break;
+	}
+	return ret;
+}
+
+static inline int is_super_block_address(u64 offset)
+{
+	int i;
+
+	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
+		if (offset == btrfs_sb_offset(i))
+			return 1;
+	}
+	return 0;
+}
+
+static int scan_one_device(struct recover_control *rc, int fd)
+{
+	struct extent_buffer *buf;
+	u64 bytenr;
+	int ret = 0;
+
+	buf = malloc(sizeof(*buf) + rc->leafsize);
+	if (!buf)
+		return -ENOMEM;
+	buf->len = rc->leafsize;
+
+	bytenr = 0;
+	while (1) {
+		if (is_super_block_address(bytenr))
+			bytenr += rc->sectorsize;
+
+		if (pread64(fd, buf->data, rc->leafsize, bytenr) <
+		    rc->leafsize)
+			break;
+
+		if (memcmp_extent_buffer(buf, rc->fs_devices->fsid,
+					 (unsigned long)btrfs_header_fsid(buf),
+					 BTRFS_FSID_SIZE)) {
+			bytenr += rc->sectorsize;
+			continue;
+		}
+
+		if (verify_tree_block_csum_silent(buf, rc->csum_size)) {
+			bytenr += rc->sectorsize;
+			continue;
+		}
+
+		if (btrfs_header_level(buf) != 0)
+			goto next_node;
+
+		switch (btrfs_header_owner(buf)) {
+		case BTRFS_EXTENT_TREE_OBJECTID:
+		case BTRFS_DEV_TREE_OBJECTID:
+			/* different tree use different generation */
+			if (btrfs_header_generation(buf) > rc->generation)
+				break;
+			ret = extract_metadata_record(rc, buf);
+			if (ret)
+				goto out;
+			break;
+		case BTRFS_CHUNK_TREE_OBJECTID:
+			if (btrfs_header_generation(buf) >
+			    rc->chunk_root_generation)
+				break;
+			ret = extract_metadata_record(rc, buf);
+			if (ret)
+				goto out;
+			break;
+		}
+next_node:
+		bytenr += rc->leafsize;
+	}
+out:
+	free(buf);
+	return ret;
+}
+
+static int scan_devices(struct recover_control *rc)
+{
+	int ret = 0;
+	int fd;
+	struct btrfs_device *dev;
+
+	list_for_each_entry(dev, &rc->fs_devices->devices, dev_list) {
+		fd = open(dev->name, O_RDONLY);
+		if (fd < 0) {
+			fprintf(stderr, "Failed to open device %s\n",
+				dev->name);
+			return -1;
+		}
+		ret = scan_one_device(rc, fd);
+		close(fd);
+		if (ret)
+			return ret;
+	}
+	return ret;
+}
+
+static int build_device_map_by_chunk_record(struct btrfs_root *root,
+					    struct chunk_record *chunk)
+{
+	int ret = 0;
+	int i;
+	u64 devid;
+	u8 uuid[BTRFS_UUID_SIZE];
+	u16 num_stripes;
+	struct btrfs_mapping_tree *map_tree;
+	struct map_lookup *map;
+	struct stripe *stripe;
+
+	map_tree = &root->fs_info->mapping_tree;
+	num_stripes = chunk->num_stripes;
+	map = malloc(btrfs_map_lookup_size(num_stripes));
+	if (!map)
+		return -ENOMEM;
+	map->ce.start = chunk->offset;
+	map->ce.size = chunk->length;
+	map->num_stripes = num_stripes;
+	map->io_width = chunk->io_width;
+	map->io_align = chunk->io_align;
+	map->sector_size = chunk->sector_size;
+	map->stripe_len = chunk->stripe_len;
+	map->type = chunk->type_flags;
+	map->sub_stripes = chunk->sub_stripes;
+
+	for (i = 0, stripe = chunk->stripes; i < num_stripes; i++, stripe++) {
+		devid = stripe->devid;
+		memcpy(uuid, stripe->dev_uuid, BTRFS_UUID_SIZE);
+		map->stripes[i].physical = stripe->offset;
+		map->stripes[i].dev = btrfs_find_device(root, devid,
+							uuid, NULL);
+		if (!map->stripes[i].dev) {
+			kfree(map);
+			return -EIO;
+		}
+	}
+
+	ret = insert_cache_extent(&map_tree->cache_tree, &map->ce);
+	return ret;
+}
+
+static int build_device_maps_by_chunk_records(struct recover_control *rc,
+					      struct btrfs_root *root)
+{
+	int ret = 0;
+	struct chunk_record *chunk;
+
+	list_for_each_entry(chunk, &rc->good_chunks, list) {
+		ret = build_device_map_by_chunk_record(root, chunk);
+		if (ret)
+			return ret;
+	}
+	return ret;
+}
+
+static int block_group_remove_all_extent_items(struct btrfs_trans_handle *trans,
+					       struct btrfs_root *root,
+					       struct block_group_record *bg)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_key key;
+	struct btrfs_path path;
+	struct extent_buffer *leaf;
+	u64 start = bg->objectid;
+	u64 end = bg->objectid + bg->offset;
+	u64 old_val;
+	int nitems;
+	int ret;
+	int i;
+	int del_s, del_nr;
+
+	btrfs_init_path(&path);
+	root = root->fs_info->extent_root;
+
+	key.objectid = start;
+	key.offset = 0;
+	key.type = BTRFS_EXTENT_ITEM_KEY;
+again:
+	ret = btrfs_search_slot(trans, root, &key, &path, -1, 1);
+	if (ret < 0)
+		goto err;
+	else if (ret > 0)
+		ret = 0;
+
+	leaf = path.nodes[0];
+	nitems = btrfs_header_nritems(leaf);
+	if (!nitems) {
+		/* The tree is empty. */
+		ret = 0;
+		goto err;
+	}
+
+	if (path.slots[0] >= nitems) {
+		ret = btrfs_next_leaf(root, &path);
+		if (ret < 0)
+			goto err;
+		if (ret > 0) {
+			ret = 0;
+			goto err;
+		}
+		leaf = path.nodes[0];
+		btrfs_item_key_to_cpu(leaf, &key, 0);
+		if (key.objectid >= end)
+			goto err;
+		btrfs_release_path(root, &path);
+		goto again;
+	}
+
+	del_nr = 0;
+	del_s = -1;
+	for (i = path.slots[0]; i < nitems; i++) {
+		btrfs_item_key_to_cpu(leaf, &key, i);
+		if (key.objectid >= end)
+			break;
+
+		if (key.type == BTRFS_BLOCK_GROUP_ITEM_KEY) {
+			if (del_nr == 0)
+				continue;
+			else
+				break;
+		}
+
+		if (del_s == -1)
+			del_s = i;
+		del_nr++;
+		if (key.type == BTRFS_EXTENT_ITEM_KEY ||
+		    key.type == BTRFS_METADATA_ITEM_KEY) {
+			old_val = btrfs_super_bytes_used(fs_info->super_copy);
+			if (key.type == BTRFS_METADATA_ITEM_KEY)
+				old_val += root->leafsize;
+			else
+				old_val += key.offset;
+			btrfs_set_super_bytes_used(fs_info->super_copy,
+						   old_val);
+		}
+	}
+
+	if (del_nr) {
+		ret = btrfs_del_items(trans, root, &path, del_s, del_nr);
+		if (ret)
+			goto err;
+	}
+
+	if (key.objectid < end) {
+		if (key.type == BTRFS_BLOCK_GROUP_ITEM_KEY) {
+			key.objectid += root->sectorsize;
+			key.type = BTRFS_EXTENT_ITEM_KEY;
+			key.offset = 0;
+		}
+		btrfs_release_path(root, &path);
+		goto again;
+	}
+err:
+	btrfs_release_path(root, &path);
+	return ret;
+}
+
+static int block_group_free_all_extent(struct btrfs_trans_handle *trans,
+				       struct btrfs_root *root,
+				       struct block_group_record *bg)
+{
+	struct btrfs_block_group_cache *cache;
+	struct btrfs_fs_info *info;
+	u64 start;
+	u64 end;
+
+	info = root->fs_info;
+	cache = btrfs_lookup_block_group(info, bg->objectid);
+	if (!cache)
+		return -ENOENT;
+
+	start = cache->key.objectid;
+	end = start + cache->key.offset - 1;
+
+	set_extent_bits(&info->block_group_cache, start, end,
+			BLOCK_GROUP_DIRTY, GFP_NOFS);
+	set_extent_dirty(&info->free_space_cache, start, end, GFP_NOFS);
+
+	btrfs_set_block_group_used(&cache->item, 0);
+
+	return 0;
+}
+
+static int remove_chunk_extent_item(struct btrfs_trans_handle *trans,
+				    struct recover_control *rc,
+				    struct btrfs_root *root)
+{
+	struct chunk_record *chunk;
+	int ret = 0;
+
+	list_for_each_entry(chunk, &rc->good_chunks, list) {
+		if (!(chunk->type_flags & BTRFS_BLOCK_GROUP_SYSTEM))
+			continue;
+		ret = block_group_remove_all_extent_items(trans, root,
+							  chunk->bg_rec);
+		if (ret)
+			return ret;
+
+		ret = block_group_free_all_extent(trans, root, chunk->bg_rec);
+		if (ret)
+			return ret;
+	}
+	return ret;
+}
+
+static int __rebuild_chunk_root(struct btrfs_trans_handle *trans,
+				struct recover_control *rc,
+				struct btrfs_root *root)
+{
+	u64 min_devid = -1;
+	struct btrfs_device *dev;
+	struct extent_buffer *cow;
+	struct btrfs_disk_key disk_key;
+	int ret = 0;
+
+	list_for_each_entry(dev, &rc->fs_devices->devices, dev_list) {
+		if (min_devid > dev->devid)
+			min_devid = dev->devid;
+	}
+	disk_key.objectid = BTRFS_DEV_ITEMS_OBJECTID;
+	disk_key.type = BTRFS_DEV_ITEM_KEY;
+	disk_key.offset = min_devid;
+
+	cow = btrfs_alloc_free_block(trans, root, root->sectorsize,
+				     BTRFS_CHUNK_TREE_OBJECTID,
+				     &disk_key, 0, 0, 0);
+	btrfs_set_header_bytenr(cow, cow->start);
+	btrfs_set_header_generation(cow, trans->transid);
+	btrfs_set_header_nritems(cow, 0);
+	btrfs_set_header_level(cow, 0);
+	btrfs_set_header_backref_rev(cow, BTRFS_MIXED_BACKREF_REV);
+	btrfs_set_header_owner(cow, BTRFS_CHUNK_TREE_OBJECTID);
+	write_extent_buffer(cow, root->fs_info->fsid,
+			(unsigned long)btrfs_header_fsid(cow),
+			BTRFS_FSID_SIZE);
+
+	write_extent_buffer(cow, root->fs_info->chunk_tree_uuid,
+			(unsigned long)btrfs_header_chunk_tree_uuid(cow),
+			BTRFS_UUID_SIZE);
+
+	root->node = cow;
+	btrfs_mark_buffer_dirty(cow);
+
+	return ret;
+}
+
+static int __rebuild_device_items(struct btrfs_trans_handle *trans,
+				  struct recover_control *rc,
+				  struct btrfs_root *root)
+{
+	struct btrfs_device *dev;
+	struct btrfs_key key;
+	struct btrfs_dev_item *dev_item;
+	int ret = 0;
+
+	dev_item = malloc(sizeof(struct btrfs_dev_item));
+	if (!dev_item)
+		return -ENOMEM;
+
+	list_for_each_entry(dev, &rc->fs_devices->devices, dev_list) {
+		key.objectid = BTRFS_DEV_ITEMS_OBJECTID;
+		key.type = BTRFS_DEV_ITEM_KEY;
+		key.offset = dev->devid;
+
+		btrfs_set_stack_device_generation(dev_item, 0);
+		btrfs_set_stack_device_type(dev_item, dev->type);
+		btrfs_set_stack_device_id(dev_item, dev->devid);
+		btrfs_set_stack_device_total_bytes(dev_item, dev->total_bytes);
+		btrfs_set_stack_device_bytes_used(dev_item, dev->bytes_used);
+		btrfs_set_stack_device_io_align(dev_item, dev->io_align);
+		btrfs_set_stack_device_io_width(dev_item, dev->io_width);
+		btrfs_set_stack_device_sector_size(dev_item, dev->sector_size);
+		memcpy(dev_item->uuid, dev->uuid, BTRFS_UUID_SIZE);
+		memcpy(dev_item->fsid, dev->fs_devices->fsid, BTRFS_UUID_SIZE);
+
+		ret = btrfs_insert_item(trans, root, &key,
+					dev_item, sizeof(*dev_item));
+	}
+
+	free(dev_item);
+	return ret;
+}
+
+static int __rebuild_chunk_items(struct btrfs_trans_handle *trans,
+				 struct recover_control *rc,
+				 struct btrfs_root *root)
+{
+	struct btrfs_key key;
+	struct btrfs_chunk *chunk = NULL;
+	struct btrfs_root *chunk_root;
+	struct chunk_record *chunk_rec;
+	int ret;
+
+	chunk_root = root->fs_info->chunk_root;
+
+	list_for_each_entry(chunk_rec, &rc->good_chunks, list) {
+		chunk = create_chunk_item(chunk_rec);
+		if (!chunk)
+			return -ENOMEM;
+
+		key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
+		key.type = BTRFS_CHUNK_ITEM_KEY;
+		key.offset = chunk_rec->offset;
+
+		ret = btrfs_insert_item(trans, chunk_root, &key, chunk,
+				btrfs_chunk_item_size(chunk->num_stripes));
+		free(chunk);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+static int rebuild_chunk_tree(struct btrfs_trans_handle *trans,
+			      struct recover_control *rc,
+			      struct btrfs_root *root)
+{
+	int ret = 0;
+
+	root = root->fs_info->chunk_root;
+
+	ret = __rebuild_chunk_root(trans, rc, root);
+	if (ret)
+		return ret;
+
+	ret = __rebuild_device_items(trans, rc, root);
+	if (ret)
+		return ret;
+
+	ret = __rebuild_chunk_items(trans, rc, root);
+
+	return ret;
+}
+
+static int rebuild_sys_array(struct recover_control *rc,
+			     struct btrfs_root *root)
+{
+	struct btrfs_chunk *chunk;
+	struct btrfs_key key;
+	struct chunk_record *chunk_rec;
+	int ret = 0;
+	u16 num_stripes;
+
+	btrfs_set_super_sys_array_size(root->fs_info->super_copy, 0);
+
+	list_for_each_entry(chunk_rec, &rc->good_chunks, list) {
+		if (!(chunk_rec->type_flags & BTRFS_BLOCK_GROUP_SYSTEM))
+			continue;
+
+		num_stripes = chunk_rec->num_stripes;
+		chunk = create_chunk_item(chunk_rec);
+		if (!chunk) {
+			ret = -ENOMEM;
+			break;
+		}
+
+		key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
+		key.type = BTRFS_CHUNK_ITEM_KEY;
+		key.offset = chunk_rec->offset;
+
+		ret = btrfs_add_system_chunk(NULL, root, &key, chunk,
+				btrfs_chunk_item_size(num_stripes));
+		free(chunk);
+		if (ret)
+			break;
+	}
+	return ret;
+
+}
+
+static struct btrfs_root *
+open_ctree_with_broken_chunk(struct recover_control *rc)
+{
+	struct btrfs_fs_info *fs_info;
+	struct btrfs_super_block *disk_super;
+	struct extent_buffer *eb;
+	u32 sectorsize;
+	u32 nodesize;
+	u32 leafsize;
+	u32 stripesize;
+	int ret;
+
+	fs_info = btrfs_new_fs_info(1, BTRFS_SUPER_INFO_OFFSET);
+	if (!fs_info) {
+		fprintf(stderr, "Failed to allocate memory for fs_info\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	fs_info->fs_devices = rc->fs_devices;
+	ret = btrfs_open_devices(fs_info->fs_devices, O_RDWR);
+	if (ret)
+		goto out;
+
+	disk_super = fs_info->super_copy;
+	ret = btrfs_read_dev_super(fs_info->fs_devices->latest_bdev,
+				   disk_super, fs_info->super_bytenr);
+	if (ret) {
+		fprintf(stderr, "No valid btrfs found\n");
+		goto out_devices;
+	}
+
+	memcpy(fs_info->fsid, &disk_super->fsid, BTRFS_FSID_SIZE);
+
+	ret = btrfs_check_fs_compatibility(disk_super, 1);
+	if (ret)
+		goto out_devices;
+
+	nodesize = btrfs_super_nodesize(disk_super);
+	leafsize = btrfs_super_leafsize(disk_super);
+	sectorsize = btrfs_super_sectorsize(disk_super);
+	stripesize = btrfs_super_stripesize(disk_super);
+
+	__setup_root(nodesize, leafsize, sectorsize, stripesize,
+		     fs_info->chunk_root, fs_info, BTRFS_CHUNK_TREE_OBJECTID);
+
+	ret = build_device_maps_by_chunk_records(rc, fs_info->chunk_root);
+	if (ret)
+		goto out_cleanup;
+
+	ret = btrfs_setup_all_roots(fs_info, 0, 0);
+	if (ret)
+		goto out_failed;
+
+	eb = fs_info->tree_root->node;
+	read_extent_buffer(eb, fs_info->chunk_tree_uuid,
+			   (unsigned long)btrfs_header_chunk_tree_uuid(eb),
+			   BTRFS_UUID_SIZE);
+
+	return fs_info->fs_root;
+out_failed:
+	btrfs_release_all_roots(fs_info);
+out_cleanup:
+	btrfs_cleanup_all_caches(fs_info);
+out_devices:
+	btrfs_close_devices(fs_info->fs_devices);
+out:
+	btrfs_free_fs_info(fs_info);
+	return ERR_PTR(ret);
+}
+
+static int recover_prepare(struct recover_control *rc, char *path)
+{
+	int ret;
+	int fd;
+	struct btrfs_super_block *sb;
+	struct btrfs_fs_devices *fs_devices;
+
+	ret = 0;
+	fd = open(path, O_RDONLY);
+	if (fd < 0) {
+		fprintf(stderr, "open %s\n error.\n", path);
+		return -1;
+	}
+
+	sb = malloc(sizeof(struct btrfs_super_block));
+	if (!sb) {
+		fprintf(stderr, "allocating memory for sb failed.\n");
+		ret = -ENOMEM;
+		goto fail_close_fd;
+	}
+
+	ret = btrfs_read_dev_super(fd, sb, BTRFS_SUPER_INFO_OFFSET);
+	if (ret) {
+		fprintf(stderr, "read super block error\n");
+		goto fail_free_sb;
+	}
+
+	rc->sectorsize = btrfs_super_sectorsize(sb);
+	rc->leafsize = btrfs_super_leafsize(sb);
+	rc->generation = btrfs_super_generation(sb);
+	rc->chunk_root_generation = btrfs_super_chunk_root_generation(sb);
+	rc->csum_size = btrfs_super_csum_size(sb);
+
+	/* if seed, the result of scanning below will be partial */
+	if (btrfs_super_flags(sb) & BTRFS_SUPER_FLAG_SEEDING) {
+		fprintf(stderr, "this device is seed device\n");
+		ret = -1;
+		goto fail_free_sb;
+	}
+
+	ret = btrfs_scan_fs_devices(fd, path, &fs_devices);
+	if (ret)
+		goto fail_free_sb;
+
+	rc->fs_devices = fs_devices;
+
+	if (rc->verbose)
+		print_all_devices(&rc->fs_devices->devices);
+
+fail_free_sb:
+	free(sb);
+fail_close_fd:
+	close(fd);
+	return ret;
+}
+
+static int ask_user(char *question, int defval)
+{
+	char answer[5];
+	char *defstr;
+	int i;
+
+	if (defval == 1)
+		defstr = "[Y/n]";
+	else if (defval == 0)
+		defstr = "[y/N]";
+	else if (defval == -1)
+		defstr = "[y/n]";
+	else
+		BUG_ON(1);
+again:
+	printf("%s%s? ", question, defstr);
+
+	i = 0;
+	while (i < 4 && scanf("%c", &answer[i])) {
+		if (answer[i] == '\n') {
+			answer[i] = '\0';
+			break;
+		} else if (answer[i] == ' '){
+			answer[i] = '\0';
+			if (i == 0)
+				continue;
+			else
+				break;
+		} else if (answer[i] >= 'A' && answer[i] <= 'Z') {
+			answer[i] += 'a' - 'A';
+		}
+		i++;
+	}
+	answer[5] = '\0';
+	__fpurge(stdin);
+
+	if (strlen(answer) == 0) {
+		if (defval != -1)
+			return defval;
+		else
+			goto again;
+	}
+
+	if (!strcmp(answer, "yes") ||
+	    !strcmp(answer, "y"))
+		return 1;
+
+	if (!strcmp(answer, "no") ||
+	    !strcmp(answer, "n"))
+		return 0;
+
+	goto again;
+}
+
+static int btrfs_recover_chunk_tree(char *path, int verbose, int yes)
+{
+	int ret = 0;
+	struct btrfs_root *root = NULL;
+	struct btrfs_trans_handle *trans;
+	struct recover_control rc;
+
+	init_recover_control(&rc, verbose, yes);
+
+	ret = recover_prepare(&rc, path);
+	if (ret) {
+		fprintf(stderr, "recover prepare error\n");
+		return ret;
+	}
+
+	ret = scan_devices(&rc);
+	if (ret) {
+		fprintf(stderr, "scan chunk headers error\n");
+		goto fail_rc;
+	}
+
+	if (cache_tree_empty(&rc.chunk) &&
+	    cache_tree_empty(&rc.bg.tree) &&
+	    cache_tree_empty(&rc.devext.tree)) {
+		fprintf(stderr, "no recoverable chunk\n");
+		goto fail_rc;
+	}
+
+	print_scan_result(&rc);
+
+	ret = check_chunks(&rc.chunk, &rc.bg, &rc.devext, &rc.good_chunks,
+			   &rc.bad_chunks, 1);
+	print_check_result(&rc);
+	if (ret) {
+		if (!list_empty(&rc.bg.block_groups) ||
+		    !list_empty(&rc.devext.no_chunk_orphans)) {
+			fprintf(stderr,
+				"There are some orphan block groups and device extents, we can't repair them now.\n");
+			goto fail_rc;
+		}
+		/*
+		 * If the chunk is healthy, its block group item and device
+		 * extent item should be written on the disks. So, it is very
+		 * likely that the bad chunk is a old one that has been
+		 * droppped from the fs. Don't deal with them now, we will
+		 * check it after the fs is opened.
+		 */
+	}
+
+	root = open_ctree_with_broken_chunk(&rc);
+	if (IS_ERR(root)) {
+		fprintf(stderr, "open with broken chunk error\n");
+		ret = PTR_ERR(root);
+		goto fail_rc;
+	}
+
+	ret = check_all_chunks_by_metadata(&rc, root);
+	if (ret) {
+		fprintf(stderr, "The chunks in memory can not match the metadata of the fs. Repair failed.\n");
+		goto fail_close_ctree;
+	}
+
+	if (!rc.yes) {
+		ret = ask_user("We are going to rebuild the chunk tree on disk, it might destroy the old metadata on the disk, Are you sure",
+			       0);
+		if (!ret) {
+			ret = BTRFS_CHUNK_TREE_REBUILD_ABORTED;
+			goto fail_close_ctree;
+		}
+	}
+
+	trans = btrfs_start_transaction(root, 1);
+	ret = remove_chunk_extent_item(trans, &rc, root);
+	BUG_ON(ret);
+
+	ret = rebuild_chunk_tree(trans, &rc, root);
+	BUG_ON(ret);
+
+	ret = rebuild_sys_array(&rc, root);
+	BUG_ON(ret);
+
+	btrfs_commit_transaction(trans, root);
+fail_close_ctree:
+	close_ctree(root);
+fail_rc:
+	free_recover_control(&rc);
+	return ret;
+}
+
+const char * const cmd_chunk_recover_usage[] = {
+	"btrfs chunk-recover [options] <device>",
+	"Recover the chunk tree by scaning the devices one by one.",
+	"",
+	"-y	Assume an answer of `yes' to all questions",
+	"-v	Verbose mode",
+	"-h	Help",
+	NULL
+};
+
+int cmd_chunk_recover(int argc, char *argv[])
+{
+	int ret = 0;
+	char *file;
+	int yes = 0;
+	int verbose = 0;
+
+	while (1) {
+		int c = getopt(argc, argv, "yvh");
+		if (c < 0)
+			break;
+		switch (c) {
+		case 'y':
+			yes = 1;
+			break;
+		case 'v':
+			verbose = 1;
+			break;
+		case 'h':
+		default:
+			usage(cmd_chunk_recover_usage);
+		}
+	}
+
+	argc = argc - optind;
+	if (argc == 0)
+		usage(cmd_chunk_recover_usage);
+
+	file = argv[optind];
+
+	ret = check_mounted(file);
+	if (ret) {
+		fprintf(stderr, "the device is busy\n");
+		return ret;
+	}
+
+	ret = btrfs_recover_chunk_tree(file, verbose, yes);
+	if (!ret) {
+		fprintf(stdout, "Recover the chunk tree successfully.\n");
+	} else if (ret == BTRFS_CHUNK_TREE_REBUILD_ABORTED) {
+		ret = 0;
+		fprintf(stdout, "Abort to rebuild the on-disk chunk tree.\n");
+	} else {
+		fprintf(stdout, "Fail to recover the chunk tree.\n");
+	}
+	return ret;
+}
diff --git a/commands.h b/commands.h
index 15c616d..65829f4 100644
--- a/commands.h
+++ b/commands.h
@@ -94,6 +94,7 @@ extern const struct cmd_group replace_cmd_group;
 extern const char * const cmd_send_usage[];
 extern const char * const cmd_receive_usage[];
 extern const char * const cmd_check_usage[];
+extern const char * const cmd_chunk_recover_usage[];
 extern const char * const cmd_restore_usage[];
 
 int cmd_subvolume(int argc, char **argv);
@@ -102,6 +103,7 @@ int cmd_balance(int argc, char **argv);
 int cmd_device(int argc, char **argv);
 int cmd_scrub(int argc, char **argv);
 int cmd_check(int argc, char **argv);
+int cmd_chunk_recover(int argc, char **argv);
 int cmd_inspect(int argc, char **argv);
 int cmd_send(int argc, char **argv);
 int cmd_receive(int argc, char **argv);
diff --git a/disk-io.c b/disk-io.c
index 7140367..a41d166 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -70,8 +70,8 @@ void btrfs_csum_final(u32 crc, char *result)
 	*(__le32 *)result = ~cpu_to_le32(crc);
 }
 
-int csum_tree_block_size(struct extent_buffer *buf, u16 csum_size,
-			 int verify)
+static int __csum_tree_block_size(struct extent_buffer *buf, u16 csum_size,
+				  int verify, int silent)
 {
 	char *result;
 	u32 len;
@@ -87,9 +87,11 @@ int csum_tree_block_size(struct extent_buffer *buf, u16 csum_size,
 
 	if (verify) {
 		if (memcmp_extent_buffer(buf, result, 0, csum_size)) {
-			printk("checksum verify failed on %llu found %08X "
-			       "wanted %08X\n", (unsigned long long)buf->start,
-			       *((u32 *)result), *((u32*)(char *)buf->data));
+			if (!silent)
+				printk("checksum verify failed on %llu found %08X wanted %08X\n",
+				       (unsigned long long)buf->start,
+				       *((u32 *)result),
+				       *((u32*)(char *)buf->data));
 			free(result);
 			return 1;
 		}
@@ -100,6 +102,16 @@ int csum_tree_block_size(struct extent_buffer *buf, u16 csum_size,
 	return 0;
 }
 
+int csum_tree_block_size(struct extent_buffer *buf, u16 csum_size, int verify)
+{
+	return __csum_tree_block_size(buf, csum_size, verify, 0);
+}
+
+int verify_tree_block_csum_silent(struct extent_buffer *buf, u16 csum_size)
+{
+	return __csum_tree_block_size(buf, csum_size, 1, 1);
+}
+
 int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 		    int verify)
 {
diff --git a/disk-io.h b/disk-io.h
index e845459..5fed663 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -92,6 +92,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 int btrfs_open_device(struct btrfs_device *dev);
 int csum_tree_block_size(struct extent_buffer *buf, u16 csum_sectorsize,
 			 int verify);
+int verify_tree_block_csum_silent(struct extent_buffer *buf, u16 csum_size);
 int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 		    int verify);
 int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid);
diff --git a/extent-tree.c b/extent-tree.c
index b0cfe0a..f597e16 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -28,12 +28,6 @@
 #include "volumes.h"
 #include "free-space-cache.h"
 
-#define BLOCK_GROUP_DATA     EXTENT_WRITEBACK
-#define BLOCK_GROUP_METADATA EXTENT_UPTODATE
-#define BLOCK_GROUP_SYSTEM   EXTENT_NEW
-
-#define BLOCK_GROUP_DIRTY EXTENT_DIRTY
-
 #define PENDING_EXTENT_INSERT 0
 #define PENDING_EXTENT_DELETE 1
 #define PENDING_BACKREF_UPDATE 2
diff --git a/extent_io.h b/extent_io.h
index a0308a9..2f5ff02 100644
--- a/extent_io.h
+++ b/extent_io.h
@@ -41,6 +41,12 @@
 #define EXTENT_CSUM (1 << 9)
 #define EXTENT_IOBITS (EXTENT_LOCKED | EXTENT_WRITEBACK)
 
+#define BLOCK_GROUP_DATA     EXTENT_WRITEBACK
+#define BLOCK_GROUP_METADATA EXTENT_UPTODATE
+#define BLOCK_GROUP_SYSTEM   EXTENT_NEW
+
+#define BLOCK_GROUP_DIRTY EXTENT_DIRTY
+
 struct btrfs_fs_info;
 
 struct extent_io_tree {
diff --git a/volumes.c b/volumes.c
index a3acee8..42cd943 100644
--- a/volumes.c
+++ b/volumes.c
@@ -52,9 +52,6 @@ static inline int nr_data_stripes(struct map_lookup *map)
 
 #define is_parity_stripe(x) ( ((x) == BTRFS_RAID5_P_STRIPE) || ((x) == BTRFS_RAID6_Q_STRIPE) )
 
-#define map_lookup_size(n) (sizeof(struct map_lookup) + \
-			    (sizeof(struct btrfs_bio_stripe) * (n)))
-
 static LIST_HEAD(fs_uuids);
 
 static struct btrfs_device *__find_device(struct list_head *head, u64 devid,
@@ -823,7 +820,7 @@ again:
 	if (!chunk)
 		return -ENOMEM;
 
-	map = kmalloc(map_lookup_size(num_stripes), GFP_NOFS);
+	map = kmalloc(btrfs_map_lookup_size(num_stripes), GFP_NOFS);
 	if (!map) {
 		kfree(chunk);
 		return -ENOMEM;
@@ -935,7 +932,7 @@ int btrfs_alloc_data_chunk(struct btrfs_trans_handle *trans,
 	if (!chunk)
 		return -ENOMEM;
 
-	map = kmalloc(map_lookup_size(num_stripes), GFP_NOFS);
+	map = kmalloc(btrfs_map_lookup_size(num_stripes), GFP_NOFS);
 	if (!map) {
 		kfree(chunk);
 		return -ENOMEM;
@@ -1420,7 +1417,7 @@ int btrfs_bootstrap_super_map(struct btrfs_mapping_tree *map_tree,
 	list_for_each(cur, &fs_devices->devices) {
 		num_stripes++;
 	}
-	map = kmalloc(map_lookup_size(num_stripes), GFP_NOFS);
+	map = kmalloc(btrfs_map_lookup_size(num_stripes), GFP_NOFS);
 	if (!map)
 		return -ENOMEM;
 
@@ -1517,7 +1514,7 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 	}
 
 	num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
-	map = kmalloc(map_lookup_size(num_stripes), GFP_NOFS);
+	map = kmalloc(btrfs_map_lookup_size(num_stripes), GFP_NOFS);
 	if (!map)
 		return -ENOMEM;
 
diff --git a/volumes.h b/volumes.h
index 911f788..91277a7 100644
--- a/volumes.h
+++ b/volumes.h
@@ -103,6 +103,8 @@ struct map_lookup {
 
 #define btrfs_multi_bio_size(n) (sizeof(struct btrfs_multi_bio) + \
 			    (sizeof(struct btrfs_bio_stripe) * (n)))
+#define btrfs_map_lookup_size(n) (sizeof(struct map_lookup) + \
+				 (sizeof(struct btrfs_bio_stripe) * (n)))
 
 /*
  * Restriper's general type filter
@@ -190,4 +192,6 @@ int btrfs_add_system_chunk(struct btrfs_trans_handle *trans,
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
 struct btrfs_device *btrfs_find_device_by_devid(struct btrfs_root *root,
                                                 u64 devid, int instance);
+struct btrfs_device *btrfs_find_device(struct btrfs_root *root, u64 devid,
+				       u8 *uuid, u8 *fsid);
 #endif
-- 
1.8.1.4

