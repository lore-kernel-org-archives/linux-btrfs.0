Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:9101 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753218Ab3EVASM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 May 2013 20:18:12 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r4M0I5Um032605
	for <linux-btrfs@vger.kernel.org>; Wed, 22 May 2013 08:18:05 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com, Cheng Yang <chenyang.fnst@cn.fujitsu.com>
Subject: [PATCH 1/2] btrfs-progs: Add block group check funtion.
Date: Wed, 22 May 2013 08:18:44 +0800
Message-Id: <1369181925-6016-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Cheng Yang <chenyang.fnst@cn.fujitsu.com>

This patch adds the function to check correspondence
between block group, chunk and device extent.

Signed-off-by: Cheng Yang <chenyang.fnst@cn.fujitsu.com>
Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Makefile           |   4 +-
 cmds-check.c       | 517 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 dev-extent-cache.c | 187 +++++++++++++++++++
 dev-extent-cache.h |  60 +++++++
 extent-cache.h     |   4 +-
 5 files changed, 762 insertions(+), 10 deletions(-)
 create mode 100644 dev-extent-cache.c
 create mode 100644 dev-extent-cache.h

diff --git a/Makefile b/Makefile
index da7438e..92c5850 100644
--- a/Makefile
+++ b/Makefile
@@ -6,7 +6,7 @@ CFLAGS = -g -O1
 objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o inode-map.o \
 	  extent-cache.o extent_io.o volumes.o utils.o repair.o \
-	  qgroup.o raid6.o free-space-cache.o
+	  qgroup.o raid6.o free-space-cache.o dev-extent-cache.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
@@ -14,7 +14,7 @@ cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 libbtrfs_objects = send-stream.o send-utils.o rbtree.o btrfs-list.o crc32c.o
 libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
 	       crc32c.h list.h kerncompat.h radix-tree.h extent-cache.h \
-	       extent_io.h ioctl.h ctree.h
+	       extent_io.h ioctl.h ctree.h dev-extent-cache.h
 
 CHECKFLAGS= -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise \
 	    -Wuninitialized -Wshadow -Wundef
diff --git a/cmds-check.c b/cmds-check.c
index 1e5e005..fda2cf2 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -39,6 +39,66 @@
 #include "utils.h"
 #include "commands.h"
 #include "free-space-cache.h"
+#include "dev-extent-cache.h"
+
+#define REC_UNCHECKED	0
+#define REC_CHECKED	1
+
+struct block_group_record {
+	struct cache_extent cache;
+	int state;
+
+	u64 objectid;
+	u8  type;
+	u64 offset;
+
+	u64 flags;
+};
+
+struct dev_record {
+	struct cache_extent cache;
+	int state;
+
+	u64 objectid;
+	u8  type;
+	u64 offset;
+
+	u64 devid;
+	u64 total_byte;
+	u64 byte_used;
+};
+
+struct stripe {
+	u64 devid;
+	u64 offset;
+};
+
+struct chunk_record {
+	struct cache_extent cache;
+	int state;
+
+	u64 objectid;
+	u8  type;
+	u64 offset;
+
+	u64 length;
+	u64 type_flags;
+	u16 num_stripes;
+	struct stripe stripes[0];
+};
+
+struct dev_extent_record {
+	struct cache_dev_extent cache;
+	int state;
+
+	u64 objectid;
+	u8  type;
+	u64 offset;
+
+	u64 chunk_objecteid;
+	u64 chunk_offset;
+	u64 length;
+};
 
 static u64 bytes_used = 0;
 static u64 total_csum_bytes = 0;
@@ -1916,7 +1976,7 @@ static int all_backpointers_checked(struct extent_record *rec, int print_errs)
 					(unsigned long long)rec->start,
 					back->full_backref ?
 					"parent" : "root",
-					back->full_backref ? 
+					back->full_backref ?
 					(unsigned long long)dback->parent:
 					(unsigned long long)dback->root,
 					(unsigned long long)dback->owner,
@@ -2551,6 +2611,153 @@ static int process_extent_ref_v0(struct cache_tree *extent_cache,
 }
 #endif
 
+static int process_chunk_item(struct cache_tree *chunk_cache,
+		struct btrfs_key *key, struct extent_buffer *eb, int slot)
+{
+	struct btrfs_chunk *ptr;
+	struct chunk_record *rec;
+	int num_stripes, i;
+	int ret = 0;
+
+	ptr = btrfs_item_ptr(eb,
+		slot, struct btrfs_chunk);
+
+	num_stripes = btrfs_chunk_num_stripes(eb, ptr);
+
+	rec = malloc(sizeof(*rec) +
+		num_stripes * sizeof(*rec->stripes));
+	if (!rec) {
+		fprintf(stderr, "memory allocation failed\n");
+		return -ENOMEM;
+	}
+
+	rec->cache.start = key->offset;
+	rec->cache.size = 1;
+	rec->state = REC_UNCHECKED;
+
+	rec->objectid = key->objectid;
+	rec->type = key->type;
+	rec->offset = key->offset;
+
+	rec->length = btrfs_chunk_length(eb, ptr);
+	rec->type = btrfs_chunk_type(eb, ptr);
+	rec->num_stripes = num_stripes;
+
+	for (i = 0; i < rec->num_stripes; ++i) {
+		rec->stripes[i].devid =
+			btrfs_stripe_devid_nr(eb, ptr, i);
+		rec->stripes[i].offset =
+			btrfs_stripe_offset_nr(eb, ptr, i);
+	}
+
+	ret = insert_existing_cache_extent(
+		chunk_cache, &rec->cache);
+
+	return ret;
+}
+
+static int process_dev_item(struct cache_tree *dev_cache,
+		struct btrfs_key *key, struct extent_buffer *eb, int slot)
+{
+	struct btrfs_dev_item *ptr;
+	struct dev_record *rec;
+	int ret = 0;
+
+	ptr = btrfs_item_ptr(eb,
+		slot, struct btrfs_dev_item);
+
+	rec = malloc(sizeof(*rec));
+	if (!rec) {
+		fprintf(stderr, "memory allocation failed\n");
+		return -ENOMEM;
+	}
+
+	rec->cache.start = key->offset;
+	rec->cache.size = 1;
+	rec->state = REC_UNCHECKED;
+
+	rec->objectid = key->objectid;
+	rec->type = key->type;
+	rec->offset = key->offset;
+
+	rec->devid = btrfs_device_id(eb, ptr);
+	rec->total_byte = btrfs_device_total_bytes(eb, ptr);
+	rec->byte_used = btrfs_device_bytes_used(eb, ptr);
+
+	ret = insert_existing_cache_extent(
+		dev_cache, &rec->cache);
+
+	return ret;
+}
+
+static int process_block_group_item(struct cache_tree *block_group_cache,
+		struct btrfs_key *key, struct extent_buffer *eb, int slot)
+{
+	struct btrfs_block_group_item *ptr;
+	struct block_group_record *rec;
+	int ret = 0;
+
+	ptr = btrfs_item_ptr(eb, slot,
+		struct btrfs_block_group_item);
+
+	rec = malloc(sizeof(*rec));
+	if (!rec) {
+		fprintf(stderr, "memory allocation failed\n");
+		return -ENOMEM;
+	}
+
+	rec->cache.start = key->objectid;
+	rec->cache.size = 1;
+	rec->state = REC_UNCHECKED;
+
+	rec->objectid = key->objectid;
+	rec->type = key->type;
+	rec->offset = key->offset;
+	rec->flags = btrfs_disk_block_group_flags(eb, ptr);
+
+	ret = insert_existing_cache_extent(
+		block_group_cache, &rec->cache);
+
+	return ret;
+}
+
+static int process_dev_extent_item(struct dev_extent_tree *dev_extent_cache,
+		struct btrfs_key *key, struct extent_buffer *eb, int slot)
+{
+	int ret = 0;
+
+	struct btrfs_dev_extent *ptr;
+	struct dev_extent_record *rec;
+
+	ptr = btrfs_item_ptr(eb,
+		slot, struct btrfs_dev_extent);
+
+	rec = malloc(sizeof(*rec));
+	if (!rec) {
+		fprintf(stderr, "memory allocation failed\n");
+		return -ENOMEM;
+	}
+
+	rec->cache.devno = key->objectid;
+	rec->cache.offset = key->offset;
+	rec->state = REC_UNCHECKED;
+
+	rec->objectid = key->objectid;
+	rec->type = key->type;
+	rec->offset = key->offset;
+
+	rec->chunk_objecteid =
+		btrfs_dev_extent_chunk_objectid(eb, ptr);
+	rec->chunk_offset =
+		btrfs_dev_extent_chunk_offset(eb, ptr);
+	rec->length = btrfs_dev_extent_length(eb, ptr);
+
+	ret = insert_existing_cache_dev_extent(
+		dev_extent_cache, &rec->cache);
+
+	return ret;
+}
+
 static int process_extent_item(struct btrfs_root *root,
 			       struct cache_tree *extent_cache,
 			       struct extent_buffer *eb, int slot)
@@ -3079,7 +3286,11 @@ static int run_next_block(struct btrfs_root *root,
 			  struct cache_tree *seen,
 			  struct cache_tree *reada,
 			  struct cache_tree *nodes,
-			  struct cache_tree *extent_cache)
+			  struct cache_tree *extent_cache,
+			  struct cache_tree *chunk_cache,
+			  struct cache_tree *dev_cache,
+			  struct cache_tree *block_group_cache,
+			  struct dev_extent_tree *dev_extent_cache)
 {
 	struct extent_buffer *buf;
 	u64 bytenr;
@@ -3177,9 +3388,25 @@ static int run_next_block(struct btrfs_root *root,
 					btrfs_item_size_nr(buf, i);
 				continue;
 			}
+			if (key.type == BTRFS_CHUNK_ITEM_KEY) {
+				process_chunk_item(chunk_cache, &key, buf, i);
+				continue;
+			}
+			if (key.type == BTRFS_DEV_ITEM_KEY) {
+				process_dev_item(dev_cache, &key, buf, i);
+				continue;
+			}
 			if (key.type == BTRFS_BLOCK_GROUP_ITEM_KEY) {
+				process_block_group_item(block_group_cache,
+					&key, buf, i);
 				continue;
 			}
+			if (key.type == BTRFS_DEV_EXTENT_KEY) {
+				process_dev_extent_item(dev_extent_cache,
+					&key, buf, i);
+				continue;
+
+			}
 			if (key.type == BTRFS_EXTENT_REF_V0_KEY) {
 #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
 				process_extent_ref_v0(extent_cache, buf, i);
@@ -3218,7 +3445,7 @@ static int run_next_block(struct btrfs_root *root,
 				ref = btrfs_item_ptr(buf, i,
 						struct btrfs_shared_data_ref);
 				add_data_backref(extent_cache,
-					key.objectid, key.offset, 0, 0, 0, 
+					key.objectid, key.offset, 0, 0, 0,
 					btrfs_shared_data_ref_count(buf, ref),
 					0, root->sectorsize);
 				continue;
@@ -3927,9 +4154,260 @@ repair_abort:
 	return err;
 }
 
+static void free_chunk_cache(struct cache_tree *chunk_cache)
+{
+	struct cache_extent *cache;
+	while (1) {
+		struct chunk_record *rec;
+
+		cache = find_first_cache_extent(chunk_cache, 0);
+		if (!cache)
+			break;
+		rec = container_of(cache, struct chunk_record, cache);
+		if (rec->state == REC_UNCHECKED) {
+			fprintf(stderr,
+				"Chunk[%llu, %u, %llu] "
+				"is not referred by any others\n",
+				rec->objectid,
+				rec->type,
+				rec->offset);
+		}
+
+		remove_cache_extent(chunk_cache, &rec->cache);
+		free(rec);
+	}
+}
+
+static void free_dev_cache(struct cache_tree *dev_cache)
+{
+	struct cache_extent *cache;
+	while (1) {
+		struct dev_record *rec;
+
+		cache = find_first_cache_extent(dev_cache, 0);
+		if (!cache)
+			break;
+		rec = container_of(cache, struct dev_record, cache);
+		if (rec->state == REC_UNCHECKED) {
+			fprintf(stderr,
+				"Dev[%llu, %u, %llu] "
+				"is not referred by any others\n",
+				rec->objectid,
+				rec->type,
+				rec->offset);
+		}
+
+		remove_cache_extent(dev_cache, &rec->cache);
+		free(rec);
+	}
+}
+
+static void free_block_group_cache(struct cache_tree *block_group_cache)
+{
+	struct cache_extent *cache;
+	while (1) {
+		struct block_group_record *rec;
+
+		cache = find_first_cache_extent(block_group_cache, 0);
+		if (!cache)
+			break;
+		rec = container_of(cache, struct block_group_record, cache);
+		if (rec->state == REC_UNCHECKED) {
+			fprintf(stderr,
+				"Block group[%llu, %u, %llu] "
+				"is not referred by any others\n",
+				rec->objectid,
+				rec->type,
+				rec->offset);
+		}
+
+		remove_cache_extent(block_group_cache, &rec->cache);
+		free(rec);
+	}
+}
+
+static void free_dev_extent_cache(struct dev_extent_tree *dev_extent_cache)
+{
+	struct cache_dev_extent *cache;
+	while (1) {
+		struct dev_extent_record *rec;
+
+		cache = find_first_cache_dev_extent(dev_extent_cache, 0);
+		if (!cache)
+			break;
+		rec = container_of(cache, struct dev_extent_record, cache);
+		if (rec->state == REC_UNCHECKED) {
+			fprintf(stderr,
+				"Dev extent[%llu, %u, %llu] "
+				"is not referred by any others\n",
+				rec->objectid,
+				rec->type,
+				rec->offset);
+		}
+
+		remove_cache_dev_extent(dev_extent_cache, &rec->cache);
+		free(rec);
+	}
+}
+
+/* check btrfs_chunk -> btrfs_dev_extent / btrfs_block_group_item */
+static int check_chunk_refs(struct cache_tree *chunk_cache,
+				struct cache_tree *block_group_cache,
+				struct dev_extent_tree *dev_extent_cache)
+{
+	struct cache_extent *chunk_item;
+	struct chunk_record *chunk_rec;
+	int err = 0;
+
+	chunk_item = find_first_cache_extent(chunk_cache, 0);
+	while (chunk_item) {
+		struct cache_extent *block_group_item;
+		struct block_group_record *block_group_rec;
+
+		struct cache_dev_extent *dev_extent_item;
+		struct dev_extent_record *dev_extent_rec;
+		int i;
+
+		chunk_rec = container_of(
+			chunk_item, struct chunk_record, cache);
+
+		block_group_item = find_cache_extent(block_group_cache,
+			chunk_rec->offset, 1);
+		if (block_group_item) {
+			block_group_rec = container_of(block_group_item,
+				struct block_group_record, cache);
+
+			if (chunk_rec->length != block_group_rec->offset)
+				err = -2;
+			if (chunk_rec->offset != block_group_rec->objectid)
+				err = -2;
+			if (chunk_rec->type != block_group_rec->flags)
+				err = -2;
+
+			if (err != 0) {
+				BUG_ON(1);
+				fprintf(stderr,
+					"Chunk[%llu, %u, %llu]: "
+					"length(%llu), offset(%llu), type(%llu) "
+					"mismatch with block group[%llu, %u, %llu]: "
+					"offset(%llu), objectid(%llu), flags(%llu)\n",
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
+			}
+
+			block_group_rec->state = REC_CHECKED;
+			chunk_rec->state = REC_CHECKED;
+		} else {
+			fprintf(stderr,
+				"Chunk[%llu, %u, %llu]: "
+				"length(%llu), offset(%llu), type(%llu) "
+				"is not found in block group\n",
+				chunk_rec->objectid,
+				chunk_rec->type,
+				chunk_rec->offset,
+				chunk_rec->length,
+				chunk_rec->offset,
+				chunk_rec->type_flags);
+			err = -1;
+		}
+
+		for (i = 0; i < chunk_rec->num_stripes; ++i) {
+			dev_extent_item = find_cache_dev_extent(
+				dev_extent_cache,
+				chunk_rec->stripes[i].devid,
+				chunk_rec->stripes[i].offset);
+			if (dev_extent_item) {
+				dev_extent_rec = container_of(dev_extent_item,
+					struct dev_extent_record, cache);
+				dev_extent_rec->state = REC_CHECKED;
+				chunk_rec->state = REC_CHECKED;
+			} else {
+				fprintf(stderr,
+					"Chunk[%llu, %u, %llu] stripe[%llu, %llu]"
+					"is not found in dev extent\n",
+					chunk_rec->objectid,
+					chunk_rec->type,
+					chunk_rec->offset,
+					chunk_rec->stripes[i].devid,
+					chunk_rec->stripes[i].offset);
+				err = -1;
+			}
+		}
+
+		chunk_item = next_cache_extent(chunk_item);
+	}
+	return err;
+}
+
+/* check btrfs_dev_item -> btrfs_dev_extent */
+static int check_dev_refs(struct cache_tree *dev_cache,
+			struct dev_extent_tree *dev_extent_cache)
+{
+	struct cache_extent *dev_item;
+	struct dev_record *dev_rec;
+	int err = 0;
+
+	dev_item = find_first_cache_extent(dev_cache, 0);
+	while (dev_item) {
+		struct cache_dev_extent *dev_extent_item;
+		struct dev_extent_record *dev_extent_rec;
+		u64 total_byte = 0;
+
+		dev_rec = container_of(dev_item, struct dev_record, cache);
+
+		dev_extent_item = find_first_cache_dev_extent(
+			dev_extent_cache, 0);
+		while (dev_extent_item) {
+			dev_extent_rec = container_of(dev_extent_item,
+				struct dev_extent_record, cache);
+
+			if (dev_extent_rec->objectid == dev_rec->devid)
+				total_byte += dev_extent_rec->length;
+
+			dev_extent_item = next_cache_dev_extent(
+				dev_extent_item);
+		}
+
+		if (total_byte != dev_rec->byte_used) {
+			err = -2;
+
+			BUG_ON(1);
+			fprintf(stderr,
+				"Dev extent's total-byte(%llu)"
+				"is not equal to byte-used(%llu) in"
+				"dev[%llu, %u, %llu]\n",
+				total_byte,
+				dev_rec->byte_used,
+				dev_rec->objectid,
+				dev_rec->type,
+				dev_rec->offset);
+		}
+
+		dev_rec->state = REC_CHECKED;
+
+		dev_item = next_cache_extent(dev_item);
+	}
+	return err;
+}
+
 static int check_extents(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root, int repair)
 {
+	struct cache_tree dev_cache;
+	struct cache_tree chunk_cache;
+	struct cache_tree block_group_cache;
+	struct dev_extent_tree dev_extent_cache;
+
 	struct cache_tree extent_cache;
 	struct cache_tree seen;
 	struct cache_tree pending;
@@ -3939,7 +4417,7 @@ static int check_extents(struct btrfs_trans_handle *trans,
 	struct btrfs_path path;
 	struct btrfs_key key;
 	struct btrfs_key found_key;
-	int ret;
+	int ret, err = 0;
 	u64 last = 0;
 	struct block_info *bits;
 	int bits_nr;
@@ -3947,6 +4425,11 @@ static int check_extents(struct btrfs_trans_handle *trans,
 	int slot;
 	struct btrfs_root_item ri;
 
+	cache_tree_init(&dev_cache);
+	cache_tree_init(&chunk_cache);
+	cache_tree_init(&block_group_cache);
+	dev_extent_tree_init(&dev_extent_cache);
+
 	cache_tree_init(&extent_cache);
 	cache_tree_init(&seen);
 	cache_tree_init(&pending);
@@ -4012,11 +4495,28 @@ static int check_extents(struct btrfs_trans_handle *trans,
 	btrfs_release_path(root, &path);
 	while(1) {
 		ret = run_next_block(root, bits, bits_nr, &last, &pending,
-				     &seen, &reada, &nodes, &extent_cache);
+				     &seen, &reada, &nodes, &extent_cache,
+				     &chunk_cache, &dev_cache,
+				     &block_group_cache, &dev_extent_cache);
 		if (ret != 0)
 			break;
 	}
 	ret = check_extent_refs(trans, root, &extent_cache, repair);
+	if (ret) {
+		err = 1;
+		fprintf(stderr, "Errors found in extent checking\n");
+	}
+	ret = check_chunk_refs(&chunk_cache,
+		&block_group_cache, &dev_extent_cache);
+	if (ret) {
+		err = 1;
+		fprintf(stderr, "Errors found in chunk refs checking\n");
+	}
+	ret = check_dev_refs(&dev_cache, &dev_extent_cache);
+	if (ret) {
+		err = 1;
+		fprintf(stderr, "Errors found in dev refs checking\n");
+	}
 
 	if (repair) {
 		free_corrupt_blocks(root->fs_info);
@@ -4026,7 +4526,12 @@ static int check_extents(struct btrfs_trans_handle *trans,
 	}
 
 	free(bits);
-	return ret;
+	free_chunk_cache(&chunk_cache);
+	free_dev_cache(&dev_cache);
+	free_block_group_cache(&block_group_cache);
+	free_dev_extent_cache(&dev_extent_cache);
+
+	return err;
 }
 
 static struct option long_options[] = {
diff --git a/dev-extent-cache.c b/dev-extent-cache.c
new file mode 100644
index 0000000..0a53639
--- /dev/null
+++ b/dev-extent-cache.c
@@ -0,0 +1,187 @@
+/*
+ * Copyright (C) 2012 Fujitsu.  All rights reserved.
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
+#include <stdio.h>
+#include <stdlib.h>
+#include "kerncompat.h"
+#include "dev-extent-cache.h"
+
+void dev_extent_tree_init(struct dev_extent_tree *tree)
+{
+	tree->root.rb_node = NULL;
+}
+
+static struct rb_node *tree_insert(struct rb_root *root, u64 devno,
+				   u64 offset, struct rb_node *node)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct cache_dev_extent *entry;
+
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct cache_dev_extent, rb_node);
+
+		if (devno == entry->devno) {
+			if (offset < entry->offset)
+				p = &(*p)->rb_left;
+			else if (offset > entry->offset)
+				p = &(*p)->rb_right;
+			else
+				return parent;
+		} else {
+			if (devno < entry->devno)
+				p = &(*p)->rb_left;
+			else if (devno > entry->devno)
+				p = &(*p)->rb_right;
+			else
+				return parent;
+		}
+	}
+
+	entry = rb_entry(parent, struct cache_dev_extent, rb_node);
+	rb_link_node(node, parent, p);
+	rb_insert_color(node, root);
+	return NULL;
+}
+
+static struct rb_node *__tree_search(struct rb_root *root, u64 devno,
+				     u64 offset, struct rb_node **prev_ret)
+{
+	struct rb_node *n = root->rb_node;
+	struct rb_node *prev = NULL;
+	struct cache_dev_extent *entry;
+	struct cache_dev_extent *prev_entry = NULL;
+
+	while (n) {
+		entry = rb_entry(n, struct cache_dev_extent, rb_node);
+		prev = n;
+		prev_entry = entry;
+
+		if (devno == entry->devno) {
+			if (offset < entry->offset)
+				n = n->rb_left;
+			else if (offset > entry->offset)
+				n = n->rb_right;
+			else
+				return n;
+		} else {
+			if (devno < entry->devno)
+				n = n->rb_left;
+			else if (devno > entry->devno)
+				n = n->rb_right;
+			else
+				return n;
+		}
+	}
+	if (!prev_ret)
+		return NULL;
+
+	while (prev && devno >= prev_entry->devno + prev_entry->offset) {
+		prev = rb_next(prev);
+		prev_entry = rb_entry(prev, struct cache_dev_extent, rb_node);
+	}
+	*prev_ret = prev;
+	return NULL;
+}
+
+struct cache_dev_extent *alloc_cache_dev_extent(u64 devno, u64 offset)
+{
+	struct cache_dev_extent *pe = malloc(sizeof(*pe));
+
+	if (!pe)
+		return pe;
+	pe->devno = devno;
+	pe->offset = offset;
+	return pe;
+}
+
+int insert_existing_cache_dev_extent(struct dev_extent_tree *tree,
+				 struct cache_dev_extent *pe)
+{
+	struct rb_node *found;
+
+	found = tree_insert(&tree->root, pe->devno, pe->offset, &pe->rb_node);
+	if (found)
+		return -EEXIST;
+
+	return 0;
+}
+
+int insert_cache_dev_extent(struct dev_extent_tree *tree, u64 devno, u64 offset)
+{
+	struct cache_dev_extent *pe = alloc_cache_dev_extent(devno, offset);
+	int ret;
+	ret = insert_existing_cache_dev_extent(tree, pe);
+	if (ret)
+		free(pe);
+	return ret;
+}
+
+struct cache_dev_extent *find_cache_dev_extent(struct dev_extent_tree *tree,
+					   u64 devno, u64 offset)
+{
+	struct rb_node *prev;
+	struct rb_node *ret;
+	struct cache_dev_extent *entry;
+	ret = __tree_search(&tree->root, devno, offset, &prev);
+	if (!ret)
+		return NULL;
+
+	entry = rb_entry(ret, struct cache_dev_extent, rb_node);
+	return entry;
+}
+
+struct cache_dev_extent *find_first_cache_dev_extent(
+				struct dev_extent_tree *tree, u64 devno)
+{
+	struct rb_node *prev;
+	struct rb_node *ret;
+	struct cache_dev_extent *entry;
+
+	ret = __tree_search(&tree->root, devno, 1, &prev);
+	if (!ret)
+		ret = prev;
+	if (!ret)
+		return NULL;
+	entry = rb_entry(ret, struct cache_dev_extent, rb_node);
+	return entry;
+}
+
+struct cache_dev_extent *prev_cache_dev_extent(struct cache_dev_extent *pe)
+{
+	struct rb_node *node = rb_prev(&pe->rb_node);
+
+	if (!node)
+		return NULL;
+	return rb_entry(node, struct cache_dev_extent, rb_node);
+}
+
+struct cache_dev_extent *next_cache_dev_extent(struct cache_dev_extent *pe)
+{
+	struct rb_node *node = rb_next(&pe->rb_node);
+
+	if (!node)
+		return NULL;
+	return rb_entry(node, struct cache_dev_extent, rb_node);
+}
+
+void remove_cache_dev_extent(struct dev_extent_tree *tree,
+				 struct cache_dev_extent *pe)
+{
+	rb_erase(&pe->rb_node, &tree->root);
+}
diff --git a/dev-extent-cache.h b/dev-extent-cache.h
new file mode 100644
index 0000000..9be2e2f
--- /dev/null
+++ b/dev-extent-cache.h
@@ -0,0 +1,60 @@
+/*
+ * Copyright (C) 2012 Fujitsu.  All rights reserved.
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
+
+#ifndef __PENDING_DEV_EXTENT__
+#define __PENDING_DEV_EXTENT__
+#include "kerncompat.h"
+#include "rbtree.h"
+
+struct dev_extent_tree {
+	struct rb_root root;
+};
+
+struct cache_dev_extent {
+	struct rb_node rb_node;
+	u64 devno;
+	u64 offset;
+};
+
+void dev_extent_tree_init(struct dev_extent_tree *tree);
+void remove_cache_dev_extent(struct dev_extent_tree *tree,
+			  struct cache_dev_extent *pe);
+struct cache_dev_extent *find_first_cache_dev_extent(
+				struct dev_extent_tree *tree, u64 devno);
+struct cache_dev_extent *prev_cache_dev_extent(struct cache_dev_extent *pe);
+struct cache_dev_extent *next_cache_dev_extent(struct cache_dev_extent *pe);
+struct cache_dev_extent *find_cache_dev_extent(struct dev_extent_tree *tree,
+					   u64 devno, u64 offset);
+int insert_cache_dev_extent(struct dev_extent_tree *tree,
+				u64 devno, u64 offset);
+int insert_existing_cache_dev_extent(struct dev_extent_tree *tree,
+				struct cache_dev_extent *pe);
+
+static inline int dev_extent_tree_empty(struct dev_extent_tree *tree)
+{
+	return RB_EMPTY_ROOT(&tree->root);
+}
+
+static inline void free_cache_dev_extent(struct cache_dev_extent *pe)
+{
+	free(pe);
+}
+
+struct cache_dev_extent *alloc_pending_dev_extent(u64 devno, u64 offset);
+
+#endif
diff --git a/extent-cache.h b/extent-cache.h
index 4cd0f79..486766c 100644
--- a/extent-cache.h
+++ b/extent-cache.h
@@ -16,8 +16,8 @@
  * Boston, MA 021110-1307, USA.
  */
 
-#ifndef __PENDING_EXTENT__
-#define __PENDING_EXTENT__
+#ifndef __EXTENT_CACHE_H__
+#define __EXTENT_CACHE_H__
 
 #if BTRFS_FLAT_INCLUDES
 #include "kerncompat.h"
-- 
1.8.2.3

