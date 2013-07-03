Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:36202 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751612Ab3GCOAg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Jul 2013 10:00:36 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r63DODNu003961
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Jul 2013 21:24:14 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 08/12] Btrfs-progs: Add block group check funtion
Date: Wed, 3 Jul 2013 21:25:16 +0800
Message-Id: <1372857920-4678-9-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1372857920-4678-1-git-send-email-miaox@cn.fujitsu.com>
References: <1372857920-4678-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds the function to check correspondence between block group,
chunk and device extent.

Original-signed-off-by: Cheng Yang <chenyang.fnst@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 Makefile     |   2 +-
 btrfsck.h    | 118 +++++++++++++
 cmds-check.c | 555 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 665 insertions(+), 10 deletions(-)
 create mode 100644 btrfsck.h

diff --git a/Makefile b/Makefile
index da7438e..b45235e 100644
--- a/Makefile
+++ b/Makefile
@@ -14,7 +14,7 @@ cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 libbtrfs_objects = send-stream.o send-utils.o rbtree.o btrfs-list.o crc32c.o
 libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
 	       crc32c.h list.h kerncompat.h radix-tree.h extent-cache.h \
-	       extent_io.h ioctl.h ctree.h
+	       extent_io.h ioctl.h ctree.h btrfsck.h
 
 CHECKFLAGS= -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise \
 	    -Wuninitialized -Wshadow -Wundef
diff --git a/btrfsck.h b/btrfsck.h
new file mode 100644
index 0000000..37ac130
--- /dev/null
+++ b/btrfsck.h
@@ -0,0 +1,118 @@
+/*
+ * Copyright (C) 2013 Fujitsu.  All rights reserved.
+ * Written by Miao Xie <miaox@cn.fujitsu.com>
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
+#ifndef __CHUNK_CHECK_H__
+#define __CHUNK_CHECK_H__
+
+#if BTRFS_FLAT_INCLUDES
+#include "kerncompat.h"
+#include "extent-cache.h"
+#include "list.h"
+#else
+#include <btrfs/kerncompat.h>
+#include <btrfs/extent-cache.h>
+#include <btrfs/list.h>
+#endif /* BTRFS_FLAT_INCLUDES */
+
+struct block_group_record {
+	struct cache_extent cache;
+	/* Used to identify the orphan block groups */
+	struct list_head list;
+
+	u64 objectid;
+	u8  type;
+	u64 offset;
+
+	u64 flags;
+};
+
+struct block_group_tree {
+	struct cache_tree tree;
+	struct list_head block_groups;
+};
+
+struct device_record {
+	struct rb_node node;
+	u64 devid;
+
+	u64 objectid;
+	u8  type;
+	u64 offset;
+
+	u64 total_byte;
+	u64 byte_used;
+
+	u64 real_used;
+};
+
+struct stripe {
+	u64 devid;
+	u64 offset;
+};
+
+struct chunk_record {
+	struct cache_extent cache;
+
+	u64 objectid;
+	u8  type;
+	u64 offset;
+
+	u64 length;
+	u64 type_flags;
+	u16 num_stripes;
+	u16 sub_stripes;
+	struct stripe stripes[0];
+};
+
+struct device_extent_record {
+	struct cache_extent cache;
+	/*
+	 * Used to identify the orphan device extents (the device extents
+	 * don't belong to a chunk or a device)
+	 */
+	struct list_head chunk_list;
+	struct list_head device_list;
+
+	u64 objectid;
+	u8  type;
+	u64 offset;
+
+	u64 chunk_objecteid;
+	u64 chunk_offset;
+	u64 length;
+};
+
+struct device_extent_tree {
+	struct cache_tree tree;
+	/*
+	 * The idea is:
+	 * When checking the chunk information, we move the device extents
+	 * that has its chunk to the chunk's device extents list. After the
+	 * check, if there are still some device extents in no_chunk_orphans,
+	 * it means there are some device extents which don't belong to any
+	 * chunk.
+	 *
+	 * The usage of no_device_orphans is the same as the first one, but it
+	 * is for the device information check.
+	 */
+	struct list_head no_chunk_orphans;
+	struct list_head no_device_orphans;
+};
+
+#endif
diff --git a/cmds-check.c b/cmds-check.c
index 2a34839..c65ae68 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -27,18 +27,17 @@
 #include <unistd.h>
 #include <getopt.h>
 #include <uuid/uuid.h>
-#include "kerncompat.h"
 #include "ctree.h"
 #include "volumes.h"
 #include "repair.h"
 #include "disk-io.h"
 #include "print-tree.h"
 #include "transaction.h"
-#include "list.h"
 #include "version.h"
 #include "utils.h"
 #include "commands.h"
 #include "free-space-cache.h"
+#include "btrfsck.h"
 
 static u64 bytes_used = 0;
 static u64 total_csum_bytes = 0;
@@ -239,6 +238,21 @@ static u8 imode_to_type(u32 imode)
 #undef S_SHIFT
 }
 
+static int device_record_compare(struct rb_node *node1, struct rb_node *node2)
+{
+	struct device_record *rec1;
+	struct device_record *rec2;
+
+	rec1 = rb_entry(node1, struct device_record, node);
+	rec2 = rb_entry(node2, struct device_record, node);
+	if (rec1->devid > rec2->devid)
+		return -1;
+	else if (rec1->devid < rec2->devid)
+		return 1;
+	else
+		return 0;
+}
+
 static struct inode_record *clone_inode_rec(struct inode_record *orig_rec)
 {
 	struct inode_record *rec;
@@ -2603,6 +2617,98 @@ static int pick_next_pending(struct cache_tree *pending,
 	return ret;
 }
 
+static void free_chunk_record(struct cache_extent *cache)
+{
+	struct chunk_record *rec;
+
+	rec = container_of(cache, struct chunk_record, cache);
+	free(rec);
+}
+
+FREE_EXTENT_CACHE_BASED_TREE(chunk_cache, free_chunk_record);
+
+static void free_device_record(struct rb_node *node)
+{
+	struct device_record *rec;
+
+	rec = container_of(node, struct device_record, node);
+	free(rec);
+}
+
+FREE_RB_BASED_TREE(device_cache, free_device_record);
+
+static void block_group_tree_init(struct block_group_tree *tree)
+{
+	cache_tree_init(&tree->tree);
+	INIT_LIST_HEAD(&tree->block_groups);
+}
+
+static int insert_block_group_record(struct block_group_tree *tree,
+				     struct block_group_record *bg_rec)
+{
+	int ret;
+
+	ret = insert_cache_extent(&tree->tree, &bg_rec->cache);
+	if (ret)
+		return ret;
+
+	list_add_tail(&bg_rec->list, &tree->block_groups);
+	return 0;
+}
+
+static void free_block_group_record(struct cache_extent *cache)
+{
+	struct block_group_record *rec;
+
+	rec = container_of(cache, struct block_group_record, cache);
+	free(rec);
+}
+
+static void free_block_group_tree(struct block_group_tree *tree)
+{
+	cache_tree_free_extents(&tree->tree, free_block_group_record);
+}
+
+static void device_extent_tree_init(struct device_extent_tree *tree)
+{
+	cache_tree_init(&tree->tree);
+	INIT_LIST_HEAD(&tree->no_chunk_orphans);
+	INIT_LIST_HEAD(&tree->no_device_orphans);
+}
+
+static int insert_device_extent_record(struct device_extent_tree *tree,
+				       struct device_extent_record *de_rec)
+{
+	int ret;
+
+	/*
+	 * Device extent is a bit different from the other extents, because
+	 * the extents which belong to the different devices may have the
+	 * same start and size, so we need use the special extent cache
+	 * search/insert functions.
+	 */
+	ret = insert_cache_extent2(&tree->tree, &de_rec->cache);
+	if (ret)
+		return ret;
+
+	list_add_tail(&de_rec->chunk_list, &tree->no_chunk_orphans);
+	list_add_tail(&de_rec->device_list, &tree->no_device_orphans);
+	return 0;
+}
+
+static void free_device_extent_record(struct cache_extent *cache)
+{
+	struct device_extent_record *rec;
+
+	rec = container_of(cache, struct device_extent_record, cache);
+	free(rec);
+}
+
+static void free_device_extent_tree(struct device_extent_tree *tree)
+{
+	cache_tree_free_extents(&tree->tree, free_device_extent_record);
+}
+
 #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
 static int process_extent_ref_v0(struct cache_tree *extent_cache,
 				 struct extent_buffer *leaf, int slot)
@@ -2622,6 +2728,172 @@ static int process_extent_ref_v0(struct cache_tree *extent_cache,
 }
 #endif
 
+static inline unsigned long chunk_record_size(int num_stripes)
+{
+	return sizeof(struct chunk_record) +
+	       sizeof(struct stripe) * num_stripes;
+}
+
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
+	rec = malloc(chunk_record_size(num_stripes));
+	if (!rec) {
+		fprintf(stderr, "memory allocation failed\n");
+		return -ENOMEM;
+	}
+
+	rec->cache.start = key->offset;
+	rec->cache.size = btrfs_chunk_length(eb, ptr);
+
+	rec->objectid = key->objectid;
+	rec->type = key->type;
+	rec->offset = key->offset;
+
+	rec->length = rec->cache.size;
+	rec->type_flags = btrfs_chunk_type(eb, ptr);
+	rec->num_stripes = num_stripes;
+	rec->sub_stripes = btrfs_chunk_sub_stripes(eb, ptr);
+
+	for (i = 0; i < rec->num_stripes; ++i) {
+		rec->stripes[i].devid =
+			btrfs_stripe_devid_nr(eb, ptr, i);
+		rec->stripes[i].offset =
+			btrfs_stripe_offset_nr(eb, ptr, i);
+	}
+
+	ret = insert_cache_extent(chunk_cache, &rec->cache);
+	if (ret) {
+		fprintf(stderr, "Chunk[%llu, %llu] existed.\n",
+			rec->offset, rec->length);
+		free(rec);
+	}
+
+	return ret;
+}
+
+static int process_device_item(struct rb_root *dev_cache,
+		struct btrfs_key *key, struct extent_buffer *eb, int slot)
+{
+	struct btrfs_dev_item *ptr;
+	struct device_record *rec;
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
+	rec->devid = key->offset;
+
+	rec->objectid = key->objectid;
+	rec->type = key->type;
+	rec->offset = key->offset;
+
+	rec->devid = btrfs_device_id(eb, ptr);
+	rec->total_byte = btrfs_device_total_bytes(eb, ptr);
+	rec->byte_used = btrfs_device_bytes_used(eb, ptr);
+
+	ret = rb_insert(dev_cache, &rec->node, device_record_compare);
+	if (ret) {
+		fprintf(stderr, "Device[%llu] existed.\n", rec->devid);
+		free(rec);
+	}
+
+	return ret;
+}
+
+static int process_block_group_item(struct block_group_tree *block_group_cache,
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
+	rec->cache.size = key->offset;
+
+	rec->objectid = key->objectid;
+	rec->type = key->type;
+	rec->offset = key->offset;
+	rec->flags = btrfs_disk_block_group_flags(eb, ptr);
+
+	ret = insert_block_group_record(block_group_cache, rec);
+	if (ret) {
+		fprintf(stderr, "Block Group[%llu, %llu] existed.\n",
+			rec->objectid, rec->offset);
+		free(rec);
+	}
+
+	return ret;
+}
+
+static int
+process_device_extent_item(struct device_extent_tree *dev_extent_cache,
+			   struct btrfs_key *key, struct extent_buffer *eb,
+			   int slot)
+{
+	int ret = 0;
+
+	struct btrfs_dev_extent *ptr;
+	struct device_extent_record *rec;
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
+	rec->cache.objectid = key->objectid;
+	rec->cache.start = key->offset;
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
+	rec->cache.size = rec->length;
+
+	ret = insert_device_extent_record(dev_extent_cache, rec);
+	if (ret) {
+		fprintf(stderr, "Device extent[%llu, %llu, %llu] existed.\n",
+			rec->objectid, rec->offset, rec->length);
+		free(rec);
+	}
+
+	return ret;
+}
+
 static int process_extent_item(struct btrfs_root *root,
 			       struct cache_tree *extent_cache,
 			       struct extent_buffer *eb, int slot)
@@ -3146,7 +3418,11 @@ static int run_next_block(struct btrfs_root *root,
 			  struct cache_tree *seen,
 			  struct cache_tree *reada,
 			  struct cache_tree *nodes,
-			  struct cache_tree *extent_cache)
+			  struct cache_tree *extent_cache,
+			  struct cache_tree *chunk_cache,
+			  struct rb_root *dev_cache,
+			  struct block_group_tree *block_group_cache,
+			  struct device_extent_tree *dev_extent_cache)
 {
 	struct extent_buffer *buf;
 	u64 bytenr;
@@ -3246,8 +3522,24 @@ static int run_next_block(struct btrfs_root *root,
 					btrfs_item_size_nr(buf, i);
 				continue;
 			}
+			if (key.type == BTRFS_CHUNK_ITEM_KEY) {
+				process_chunk_item(chunk_cache, &key, buf, i);
+				continue;
+			}
+			if (key.type == BTRFS_DEV_ITEM_KEY) {
+				process_device_item(dev_cache, &key, buf, i);
+				continue;
+			}
 			if (key.type == BTRFS_BLOCK_GROUP_ITEM_KEY) {
+				process_block_group_item(block_group_cache,
+					&key, buf, i);
+				continue;
+			}
+			if (key.type == BTRFS_DEV_EXTENT_KEY) {
+				process_device_extent_item(dev_extent_cache,
+					&key, buf, i);
 				continue;
+
 			}
 			if (key.type == BTRFS_EXTENT_REF_V0_KEY) {
 #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
@@ -4595,8 +4887,233 @@ repair_abort:
 	return err;
 }
 
-static int check_extents(struct btrfs_root *root, int repair)
+static u64 calc_stripe_length(struct chunk_record *chunk_rec)
+{
+	u64 stripe_size;
+
+	if (chunk_rec->type_flags & BTRFS_BLOCK_GROUP_RAID0) {
+		stripe_size = chunk_rec->length;
+		stripe_size /= chunk_rec->num_stripes;
+	} else if (chunk_rec->type_flags & BTRFS_BLOCK_GROUP_RAID10) {
+		stripe_size = chunk_rec->length * 2;
+		stripe_size /= chunk_rec->num_stripes;
+	} else if (chunk_rec->type_flags & BTRFS_BLOCK_GROUP_RAID5) {
+		stripe_size = chunk_rec->length;
+		stripe_size /= (chunk_rec->num_stripes - 1);
+	} else if (chunk_rec->type_flags & BTRFS_BLOCK_GROUP_RAID6) {
+		stripe_size = chunk_rec->length;
+		stripe_size /= (chunk_rec->num_stripes - 2);
+	} else {
+		stripe_size = chunk_rec->length;
+	}
+	return stripe_size;
+}
+
+static int check_chunk_refs(struct chunk_record *chunk_rec,
+			    struct block_group_tree *block_group_cache,
+			    struct device_extent_tree *dev_extent_cache)
+{
+	struct cache_extent *block_group_item;
+	struct block_group_record *block_group_rec;
+	struct cache_extent *dev_extent_item;
+	struct device_extent_record *dev_extent_rec;
+	u64 devid;
+	u64 offset;
+	u64 length;
+	int i;
+	int ret = 0;
+
+	block_group_item = lookup_cache_extent(&block_group_cache->tree,
+					       chunk_rec->offset,
+					       chunk_rec->length);
+	if (block_group_item) {
+		block_group_rec = container_of(block_group_item,
+					       struct block_group_record,
+					       cache);
+		if (chunk_rec->length != block_group_rec->offset ||
+		    chunk_rec->offset != block_group_rec->objectid ||
+		    chunk_rec->type_flags != block_group_rec->flags) {
+			fprintf(stderr,
+				"Chunk[%llu, %u, %llu]: length(%llu), offset(%llu), type(%llu) mismatch with block group[%llu, %u, %llu]: offset(%llu), objectid(%llu), flags(%llu)\n",
+				chunk_rec->objectid,
+				chunk_rec->type,
+				chunk_rec->offset,
+				chunk_rec->length,
+				chunk_rec->offset,
+				chunk_rec->type_flags,
+				block_group_rec->objectid,
+				block_group_rec->type,
+				block_group_rec->offset,
+				block_group_rec->offset,
+				block_group_rec->objectid,
+				block_group_rec->flags);
+			ret = -1;
+		}
+		list_del(&block_group_rec->list);
+	} else {
+		fprintf(stderr,
+			"Chunk[%llu, %u, %llu]: length(%llu), offset(%llu), type(%llu) is not found in block group\n",
+			chunk_rec->objectid,
+			chunk_rec->type,
+			chunk_rec->offset,
+			chunk_rec->length,
+			chunk_rec->offset,
+			chunk_rec->type_flags);
+		ret = -1;
+	}
+
+	length = calc_stripe_length(chunk_rec);
+	for (i = 0; i < chunk_rec->num_stripes; ++i) {
+		devid = chunk_rec->stripes[i].devid;
+		offset = chunk_rec->stripes[i].offset;
+		dev_extent_item = lookup_cache_extent2(&dev_extent_cache->tree,
+						       devid, offset, length);
+		if (dev_extent_item) {
+			dev_extent_rec = container_of(dev_extent_item,
+						struct device_extent_record,
+						cache);
+			if (dev_extent_rec->objectid != devid ||
+			    dev_extent_rec->offset != offset ||
+			    dev_extent_rec->chunk_offset != chunk_rec->offset ||
+			    dev_extent_rec->length != length) {
+				fprintf(stderr,
+					"Chunk[%llu, %u, %llu] stripe[%llu, %llu] dismatch dev extent[%llu, %llu, %llu]\n",
+					chunk_rec->objectid,
+					chunk_rec->type,
+					chunk_rec->offset,
+					chunk_rec->stripes[i].devid,
+					chunk_rec->stripes[i].offset,
+					dev_extent_rec->objectid,
+					dev_extent_rec->offset,
+					dev_extent_rec->length);
+				ret = -1;
+			}
+			list_del(&dev_extent_rec->chunk_list);
+		} else {
+			fprintf(stderr,
+				"Chunk[%llu, %u, %llu] stripe[%llu, %llu] is not found in dev extent\n",
+				chunk_rec->objectid,
+				chunk_rec->type,
+				chunk_rec->offset,
+				chunk_rec->stripes[i].devid,
+				chunk_rec->stripes[i].offset);
+			ret = -1;
+		}
+	}
+	return ret;
+}
+
+/* check btrfs_chunk -> btrfs_dev_extent / btrfs_block_group_item */
+static int check_chunks(struct cache_tree *chunk_cache,
+			struct block_group_tree *block_group_cache,
+			struct device_extent_tree *dev_extent_cache)
 {
+	struct cache_extent *chunk_item;
+	struct chunk_record *chunk_rec;
+	struct block_group_record *bg_rec;
+	struct device_extent_record *dext_rec;
+	int err;
+	int ret = 0;
+
+	chunk_item = first_cache_extent(chunk_cache);
+	while (chunk_item) {
+		chunk_rec = container_of(chunk_item, struct chunk_record,
+					 cache);
+		err = check_chunk_refs(chunk_rec, block_group_cache,
+				       dev_extent_cache);
+		if (err)
+			ret = err;
+
+		chunk_item = next_cache_extent(chunk_item);
+	}
+
+	list_for_each_entry(bg_rec, &block_group_cache->block_groups, list) {
+		fprintf(stderr,
+			"Block group[%llu, %llu] (flags = %llu) didn't find the relative chunk.\n",
+			bg_rec->objectid, bg_rec->offset, bg_rec->flags);
+		if (!ret)
+			ret = 1;
+	}
+
+	list_for_each_entry(dext_rec, &dev_extent_cache->no_chunk_orphans,
+			    chunk_list) {
+		fprintf(stderr,
+			"Device extent[%llu, %llu, %llu] didn't find the relative chunk.\n",
+			dext_rec->objectid, dext_rec->offset, dext_rec->length);
+		if (!ret)
+			ret = 1;
+	}
+	return ret;
+}
+
+
+static int check_device_used(struct device_record *dev_rec,
+			     struct device_extent_tree *dext_cache)
+{
+	struct cache_extent *cache;
+	struct device_extent_record *dev_extent_rec;
+	u64 total_byte = 0;
+
+	cache = search_cache_extent2(&dext_cache->tree, dev_rec->devid, 0);
+	while (cache) {
+		dev_extent_rec = container_of(cache,
+					      struct device_extent_record,
+					      cache);
+		if (dev_extent_rec->objectid != dev_rec->devid)
+			break;
+
+		list_del(&dev_extent_rec->device_list);
+		total_byte += dev_extent_rec->length;
+		cache = next_cache_extent(cache);
+	}
+
+	if (total_byte != dev_rec->byte_used) {
+		fprintf(stderr,
+			"Dev extent's total-byte(%llu) is not equal to byte-used(%llu) in dev[%llu, %u, %llu]\n",
+			total_byte, dev_rec->byte_used,	dev_rec->objectid,
+			dev_rec->type, dev_rec->offset);
+		return -1;
+	} else {
+		return 0;
+	}
+}
+
+/* check btrfs_dev_item -> btrfs_dev_extent */
+static int check_devices(struct rb_root *dev_cache,
+			 struct device_extent_tree *dev_extent_cache)
+{
+	struct rb_node *dev_node;
+	struct device_record *dev_rec;
+	struct device_extent_record *dext_rec;
+	int err;
+	int ret = 0;
+
+	dev_node = rb_first(dev_cache);
+	while (dev_node) {
+		dev_rec = container_of(dev_node, struct device_record, node);
+		err = check_device_used(dev_rec, dev_extent_cache);
+		if (err)
+			ret = err;
+
+		dev_node = rb_next(dev_node);
+	}
+	list_for_each_entry(dext_rec, &dev_extent_cache->no_device_orphans,
+			    device_list) {
+		fprintf(stderr,
+			"Device extent[%llu, %llu, %llu] didn't find its device.\n",
+			dext_rec->objectid, dext_rec->offset, dext_rec->length);
+		if (!ret)
+			ret = 1;
+	}
+	return ret;
+}
+
+static int check_chunks_and_extents(struct btrfs_root *root, int repair)
+{
+	struct rb_root dev_cache;
+	struct cache_tree chunk_cache;
+	struct block_group_tree block_group_cache;
+	struct device_extent_tree dev_extent_cache;
 	struct cache_tree extent_cache;
 	struct cache_tree seen;
 	struct cache_tree pending;
@@ -4606,7 +5123,7 @@ static int check_extents(struct btrfs_root *root, int repair)
 	struct btrfs_path path;
 	struct btrfs_key key;
 	struct btrfs_key found_key;
-	int ret;
+	int ret, err = 0;
 	u64 last = 0;
 	struct block_info *bits;
 	int bits_nr;
@@ -4615,6 +5132,11 @@ static int check_extents(struct btrfs_root *root, int repair)
 	int slot;
 	struct btrfs_root_item ri;
 
+	dev_cache = RB_ROOT;
+	cache_tree_init(&chunk_cache);
+	block_group_tree_init(&block_group_cache);
+	device_extent_tree_init(&dev_extent_cache);
+
 	cache_tree_init(&extent_cache);
 	cache_tree_init(&seen);
 	cache_tree_init(&pending);
@@ -4686,12 +5208,14 @@ again:
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
-	ret = check_extent_refs(trans, root, &extent_cache, repair);
 
+	ret = check_extent_refs(trans, root, &extent_cache, repair);
 	if (ret == -EAGAIN) {
 		ret = btrfs_commit_transaction(trans, root);
 		if (ret)
@@ -4712,6 +5236,15 @@ again:
 		goto again;
 	}
 
+	err = check_chunks(&chunk_cache, &block_group_cache,
+			   &dev_extent_cache);
+	if (err && !ret)
+		ret = err;
+
+	err = check_devices(&dev_cache, &dev_extent_cache);
+	if (err && !ret)
+		ret = err;
+
 	if (trans) {
 		int err;
 
@@ -4727,6 +5260,10 @@ out:
 		root->fs_info->corrupt_blocks = NULL;
 	}
 	free(bits);
+	free_chunk_cache_tree(&chunk_cache);
+	free_device_cache_tree(&dev_cache);
+	free_block_group_tree(&block_group_cache);
+	free_device_extent_tree(&dev_extent_cache);
 	return ret;
 }
 
@@ -5207,9 +5744,9 @@ int cmd_check(int argc, char **argv)
 			exit(1);
 		goto out;
 	}
-	ret = check_extents(root, repair);
+	ret = check_chunks_and_extents(root, repair);
 	if (ret)
-		fprintf(stderr, "Errors found in extent allocation tree\n");
+		fprintf(stderr, "Errors found in extent allocation tree or chunk allocation\n");
 
 	fprintf(stderr, "checking free space cache\n");
 	ret = check_space_cache(root);
-- 
1.8.1.4

