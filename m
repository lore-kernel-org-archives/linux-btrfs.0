Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:27535 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752094Ab2HBKPb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Aug 2012 06:15:31 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q72AFTVj032455
	for <linux-btrfs@vger.kernel.org>; Thu, 2 Aug 2012 18:15:29 +0800
Message-ID: <501A530D.2020107@cn.fujitsu.com>
Date: Thu, 02 Aug 2012 18:14:37 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Chen Yang <chenyang.fnst@cn.fujitsu.com>
Subject: [RFC][PATCH] Btrfs-progs, btrfsck: add block group check function
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Chen Yang <chenyang.fnst@cn.fujitsu.com>

This patch adds the function to check correspondence between block group,
chunk and device extent.

Signed-off-by: Cheng Yang <chenyang.fnst@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 Makefile           |    2 +-
 btrfsck.c          |  569 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 dev-extent-cache.c |  188 +++++++++++++++++
 dev-extent-cache.h |   60 ++++++
 4 files changed, 812 insertions(+), 7 deletions(-)
 create mode 100644 dev-extent-cache.c
 create mode 100644 dev-extent-cache.h

diff --git a/Makefile b/Makefile
index 9694444..75eced8 100644
--- a/Makefile
+++ b/Makefile
@@ -4,7 +4,7 @@ CFLAGS = -g -O0
 objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o \
 	  inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o \
-	  volumes.o utils.o btrfs-list.o btrfslabel.o repair.o
+	  volumes.o utils.o btrfs-list.o btrfslabel.o repair.o dev-extent-cache.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o
 
diff --git a/btrfsck.c b/btrfsck.c
index 088b9f4..a25c948 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -34,6 +34,56 @@
 #include "list.h"
 #include "version.h"
 #include "utils.h"
+#include "dev-extent-cache.h"
+
+
+struct block_group_rec {
+	struct cache_extent cache;
+	u64 objectid;
+	u8  type;
+	u64 offset;
+
+	u64 flags;
+};
+
+struct dev_rec {
+	struct cache_extent cache;
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
+struct chunk_rec {
+	struct cache_extent cache;
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
+struct dev_extent_rec {
+	struct cache_dev_extent cache;
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
@@ -1852,7 +1902,7 @@ static int all_backpointers_checked(struct extent_record *rec, int print_errs)
 					(unsigned long long)rec->start,
 					back->full_backref ?
 					"parent" : "root",
-					back->full_backref ? 
+					back->full_backref ?
 					(unsigned long long)dback->parent:
 					(unsigned long long)dback->root,
 					(unsigned long long)dback->owner,
@@ -2440,6 +2490,149 @@ static int process_extent_ref_v0(struct cache_tree *extent_cache,
 }
 #endif
 
+static int process_chunk_item(struct cache_tree *chunk_cache,
+		struct btrfs_key *key, struct extent_buffer *eb, int slot)
+{
+	struct btrfs_chunk *ptr;
+	struct chunk_rec *rec;
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
+	struct dev_rec *rec;
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
+	struct block_group_rec *rec;
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
+	struct dev_extent_rec *rec;
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
 static int process_extent_item(struct cache_tree *extent_cache,
 			       struct extent_buffer *eb, int slot)
 {
@@ -2531,7 +2724,11 @@ static int run_next_block(struct btrfs_root *root,
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
@@ -2622,9 +2819,25 @@ static int run_next_block(struct btrfs_root *root,
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
@@ -2663,7 +2876,7 @@ static int run_next_block(struct btrfs_root *root,
 				ref = btrfs_item_ptr(buf, i,
 						struct btrfs_shared_data_ref);
 				add_data_backref(extent_cache,
-					key.objectid, key.offset, 0, 0, 0, 
+					key.objectid, key.offset, 0, 0, 0,
 					btrfs_shared_data_ref_count(buf, ref),
 					0, root->sectorsize);
 				continue;
@@ -3366,9 +3579,312 @@ repair_abort:
 	return err;
 }
 
+static void free_chunk_cache(struct cache_tree *chunk_cache)
+{
+	struct cache_extent *cache;
+	while (1) {
+		struct chunk_rec *rec;
+
+		cache = find_first_cache_extent(chunk_cache, 0);
+		if (!cache)
+			break;
+		rec = container_of(cache, struct chunk_rec, cache);
+		remove_cache_extent(chunk_cache, &rec->cache);
+		free(rec);
+	}
+}
+
+static void free_dev_cache(struct cache_tree *dev_cache)
+{
+	struct cache_extent *cache;
+	while (1) {
+		struct dev_rec *rec;
+
+		cache = find_first_cache_extent(dev_cache, 0);
+		if (!cache)
+			break;
+		rec = container_of(cache, struct dev_rec, cache);
+		remove_cache_extent(dev_cache, &rec->cache);
+		free(rec);
+	}
+}
+
+static void free_block_group_cache(struct cache_tree *block_group_cache)
+{
+	struct cache_extent *cache;
+	while (1) {
+		struct block_group_rec *rec;
+
+		cache = find_first_cache_extent(block_group_cache, 0);
+		if (!cache)
+			break;
+		rec = container_of(cache, struct block_group_rec, cache);
+		remove_cache_extent(block_group_cache, &rec->cache);
+		free(rec);
+	}
+}
+
+static void free_dev_extent_cache(struct dev_extent_tree *dev_extent_cache)
+{
+	struct cache_dev_extent *cache;
+	while (1) {
+		struct dev_extent_rec *rec;
+
+		cache = find_first_cache_dev_extent(dev_extent_cache, 0);
+		if (!cache)
+			break;
+		rec = container_of(cache, struct dev_extent_rec, cache);
+		remove_cache_dev_extent(dev_extent_cache, &rec->cache);
+		free(rec);
+	}
+}
+
+/* check btrfs_chunk -> btrfs_dev_extent */
+static int check_chunk_refs_dev_extent(struct cache_tree *chunk_cache,
+				struct dev_extent_tree *dev_extent_cache)
+{
+	struct cache_extent *cache;
+	struct chunk_rec *rec;
+	int err = 0;
+
+	cache = find_first_cache_extent(chunk_cache, 0);
+	while (cache) {
+		struct cache_dev_extent *cache2;
+		int i;
+
+		rec = container_of(cache, struct chunk_rec, cache);
+
+		for (i = 0; i < rec->num_stripes; ++i) {
+			cache2 = find_cache_dev_extent(dev_extent_cache,
+				rec->stripes[i].devid, rec->stripes[i].offset);
+			if (!cache2) {
+				fprintf(stderr,
+					"chunk stripe(%llu, %llu) refs to dev "
+					"extent error\n",
+					rec->stripes[i].devid,
+					rec->stripes[i].offset);
+				err = -1;
+			}
+		}
+
+		cache = next_cache_extent(cache);
+	}
+	return err;
+}
+
+/* check btrfs_dev_extent -> btrfs_chunk */
+static int check_dev_extent_refs_chunk(struct dev_extent_tree *dev_extent_cache,
+					struct cache_tree *chunk_cache)
+{
+	struct cache_dev_extent *cache;
+	struct dev_extent_rec *rec;
+	int err = 0;
+
+	cache = find_first_cache_dev_extent(dev_extent_cache, 0);
+	while (cache) {
+		struct cache_extent *cache2;
+
+		rec = container_of(cache, struct dev_extent_rec, cache);
+
+		cache2 = find_cache_extent(chunk_cache,
+			rec->chunk_offset, 1);
+		if (!cache2) {
+			fprintf(stderr,
+				"dev extent refs to chunk(%llu, %llu) error\n",
+				rec->chunk_objecteid,
+				rec->chunk_offset);
+			err = -1;
+		}
+
+		cache = next_cache_dev_extent(cache);
+	}
+	return err;
+}
+
+/* check btrfs_block_group_item -> btrfs_chunk */
+static int check_block_group_refs_chunk(struct cache_tree *block_group_cache,
+					struct cache_tree *chunk_cache)
+{
+	struct cache_extent *cache;
+	struct block_group_rec *rec;
+	int err = 0;
+
+	cache = find_first_cache_extent(block_group_cache, 0);
+	while (cache) {
+		struct cache_extent *cache2;
+		struct chunk_rec *rec2;
+
+		rec = container_of(cache, struct block_group_rec, cache);
+
+		cache2 = find_cache_extent(chunk_cache,
+			rec->objectid, 1);
+		if (cache2) {
+			rec2 = container_of(cache2, struct chunk_rec, cache);
+
+			/* Todo: check */
+			if (rec2->length != rec->offset) {
+				BUG_ON(1);
+				fprintf(stderr,
+					"block group(%llu, %llu) refs to "
+					"chunk with length(%llu) error\n",
+					rec->objectid,
+					rec->offset,
+					rec2->length);
+				err = -1;
+			}
+			if (rec2->offset != rec->objectid) {
+				BUG_ON(1);
+				fprintf(stderr,
+					"block group(%llu, %llu) refs to "
+					"chunk with offset(%llu) error\n",
+					rec->objectid,
+					rec->offset,
+					rec2->offset);
+				err = -1;
+			}
+			if (rec2->type != rec->flags) {
+				BUG_ON(1);
+				fprintf(stderr,
+					"block group(%llu, %llu) "
+					"with flags(%llu)refs to "
+					"chunk with type(%llu) error\n",
+					rec->objectid,
+					rec->offset,
+					rec->flags,
+					rec2->type_flags);
+				err = -1;
+			}
+		} else {
+			fprintf(stderr,
+				"block group refs to chunk(-, %llu) error\n",
+				rec->objectid);
+			err = -1;
+		}
+
+		cache = next_cache_extent(cache);
+	}
+	return err;
+}
+
+/* check btrfs_chunk -> btrfs_block_group_item */
+static int check_chunk_refs_block_group(struct cache_tree *chunk_cache,
+					struct cache_tree *block_group_cache)
+{
+	struct cache_extent *cache;
+	struct chunk_rec *rec;
+	int err = 0;
+
+	cache = find_first_cache_extent(chunk_cache, 0);
+	while (cache) {
+		struct cache_extent *cache2;
+		struct block_group_rec *rec2;
+
+		rec = container_of(cache, struct chunk_rec, cache);
+
+		cache2 = find_cache_extent(block_group_cache,
+			rec->offset, 1);
+		if (cache2) {
+			rec2 = container_of(cache2,
+				struct block_group_rec, cache);
+
+			/* Todo: check */
+			if (rec->length != rec2->offset) {
+				BUG_ON(1);
+				fprintf(stderr,
+					"chunk(-, %llu) with length(%llu) refs "
+					"to block group with length(%llu) "
+					"error\n",
+					rec->offset,
+					rec->length,
+					rec2->offset);
+				err = -1;
+			}
+			if (rec->offset != rec2->objectid) {
+				BUG_ON(1);
+				fprintf(stderr,
+					"chunk(-, %llu) with length(%llu) refs "
+					"to block group with offset(%llu) "
+					"error\n",
+					rec->offset,
+					rec->length,
+					rec2->objectid);
+				err = -1;
+			}
+			if (rec->type != rec2->flags) {
+				BUG_ON(1);
+				fprintf(stderr,
+					"chunk(-, %llu) with type(%llu) refs to"
+					" block group with flags(%llu) error\n",
+					rec->offset,
+					rec->type_flags,
+					rec2->flags);
+				err = -1;
+			}
+		} else {
+			fprintf(stderr,
+				"chunk refs to block group(%llu, %llu) error\n",
+				rec->offset,
+				rec->length);
+			err = -1;
+		}
+
+		cache = next_cache_extent(cache);
+	}
+	return err;
+}
+
+/* check btrfs_dev_item -> btrfs_dev_extent */
+static int check_dev_refs_dev_extent(struct cache_tree *dev_cache,
+				struct dev_extent_tree *dev_extent_cache)
+{
+	struct cache_extent *cache;
+	struct dev_rec *rec;
+	int err = 0;
+
+	cache = find_first_cache_extent(dev_cache, 0);
+	while (cache) {
+		struct cache_dev_extent *cache2;
+		struct dev_extent_rec *rec2;
+		u64 total_byte = 0;
+
+		rec = container_of(cache, struct dev_rec, cache);
+
+		cache2 = find_first_cache_dev_extent(dev_extent_cache, 0);
+		while (cache2) {
+			rec2 = container_of(cache2,
+				struct dev_extent_rec, cache);
+
+			if (rec2->objectid == rec->devid)
+				total_byte += rec2->length;
+
+			cache2 = next_cache_dev_extent(cache2);
+		}
+
+		/* Todo: check */
+		if (total_byte != rec->byte_used) {
+			BUG_ON(1);
+			fprintf(stderr,
+				"dev extent total-byte(%llu) not equals"
+				" byte-used(%llu) in dev(%llu)\n",
+				total_byte,
+				rec->byte_used,
+				rec->devid);
+			err = -1;
+		}
+
+		cache = next_cache_extent(cache);
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
@@ -3378,7 +3894,7 @@ static int check_extents(struct btrfs_trans_handle *trans,
 	struct btrfs_path path;
 	struct btrfs_key key;
 	struct btrfs_key found_key;
-	int ret;
+	int ret, err = 0;
 	u64 last = 0;
 	struct block_info *bits;
 	int bits_nr;
@@ -3386,6 +3902,11 @@ static int check_extents(struct btrfs_trans_handle *trans,
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
@@ -3452,11 +3973,42 @@ static int check_extents(struct btrfs_trans_handle *trans,
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
+	ret = check_chunk_refs_dev_extent(&chunk_cache, &dev_extent_cache);
+	if (ret) {
+		err = 1;
+		fprintf(stderr, "Errors found in chunk item and dev extent\n");
+	}
+	ret = check_dev_extent_refs_chunk(&dev_extent_cache, &chunk_cache);
+	if (ret) {
+		err = 1;
+		fprintf(stderr, "Errors found in dev extent and chunk item\n");
+	}
+	ret = check_block_group_refs_chunk(&block_group_cache, &chunk_cache);
+	if (ret) {
+		err = 1;
+		fprintf(stderr, "Errors found in block group and chunk item\n");
+	}
+	ret = check_chunk_refs_block_group(&chunk_cache, &block_group_cache);
+	if (ret) {
+		err = 1;
+		fprintf(stderr, "Errors found in chunk item and block group\n");
+	}
+	ret = check_dev_refs_dev_extent(&dev_cache, &dev_extent_cache);
+	if (ret) {
+		err = 1;
+		fprintf(stderr, "Errors found in dev item and dev extent\n");
+	}
 
 	if (repair) {
 		free_corrupt_blocks(root->fs_info);
@@ -3465,7 +4017,12 @@ static int check_extents(struct btrfs_trans_handle *trans,
 		root->fs_info->corrupt_blocks = NULL;
 	}
 
-	return ret;
+	free_chunk_cache(&chunk_cache);
+	free_dev_cache(&dev_cache);
+	free_block_group_cache(&block_group_cache);
+	free_dev_extent_cache(&dev_extent_cache);
+
+	return err;
 }
 
 static void print_usage(void)
diff --git a/dev-extent-cache.c b/dev-extent-cache.c
new file mode 100644
index 0000000..1f0d047
--- /dev/null
+++ b/dev-extent-cache.c
@@ -0,0 +1,188 @@
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
+
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
-- 
1.7.6.5
