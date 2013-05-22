Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:9101 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753341Ab3EVASP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 May 2013 20:18:15 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r4M0I5Un032605
	for <linux-btrfs@vger.kernel.org>; Wed, 22 May 2013 08:18:05 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH 2/2] btrfs-progs: Add chunk recover function.
Date: Wed, 22 May 2013 08:18:45 +0800
Message-Id: <1369181925-6016-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1369181925-6016-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1369181925-6016-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add chunk-recover program to check and rebuild chunk tree even the
sys_chunk_array is broken.
This function is using the references between
chunk/block_group/dev_extent to rebuild the chunk.

Now the infrastructure to scan the whole disk and rebuild is OK.
The function to rebuild missing btrfs_chunk_item will be implemented
soon.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Makefile        |   10 +-
 chunk-recover.c | 1264 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 cmds-check.c    |   60 +--
 disk-io.c       |    6 +-
 disk-io.h       |    9 +
 recover-chunk.c |  636 ++++++++++++++++++++++++++++
 recover-chunk.h |  145 +++++++
 volumes.h       |    2 +
 8 files changed, 2068 insertions(+), 64 deletions(-)
 create mode 100644 chunk-recover.c
 create mode 100644 recover-chunk.c
 create mode 100644 recover-chunk.h

diff --git a/Makefile b/Makefile
index 92c5850..d4e2f78 100644
--- a/Makefile
+++ b/Makefile
@@ -6,7 +6,8 @@ CFLAGS = -g -O1
 objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o inode-map.o \
 	  extent-cache.o extent_io.o volumes.o utils.o repair.o \
-	  qgroup.o raid6.o free-space-cache.o dev-extent-cache.o
+	  qgroup.o raid6.o free-space-cache.o dev-extent-cache.o \
+	  recover-chunk.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
@@ -45,7 +46,7 @@ MAKEOPTS = --no-print-directory Q=$(Q)
 
 progs = mkfs.btrfs btrfs-debug-tree btrfsck \
 	btrfs btrfs-map-logical btrfs-image btrfs-zero-log btrfs-convert \
-	btrfs-find-root btrfstune btrfs-show-super
+	btrfs-find-root btrfstune btrfs-show-super chunk-recover
 
 # external libs required by various binaries; for btrfs-foo,
 # specify btrfs_foo_libs = <list of libs>; see $($(subst...)) rules below
@@ -175,6 +176,11 @@ send-test: $(objects) $(libs) send-test.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o send-test $(objects) send-test.o $(LDFLAGS) $(LIBS) -lpthread
 
+chunk-recover: $(objects) chunk-recover.o
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o chunk-recover chunk-recover.o $(objects) $(LDFLAGS) $(LIBS)
+
+
 manpages:
 	$(Q)$(MAKE) $(MAKEOPTS) -C man
 
diff --git a/chunk-recover.c b/chunk-recover.c
new file mode 100644
index 0000000..5ca52c5
--- /dev/null
+++ b/chunk-recover.c
@@ -0,0 +1,1264 @@
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
+#include "recover-chunk.h"
+
+BTRFS_SETGET_STACK_FUNCS(stack_header_nritems,struct btrfs_header, nritems, 32);
+BTRFS_SETGET_STACK_FUNCS(stack_header_generation,struct btrfs_header,
+		generation, 64);
+
+static void print_device(struct recover_control *rc)
+{
+	struct list_head *cur;
+	struct list_head *head;
+	struct btrfs_device *dev;
+	char str[37];
+
+	printf("device list:\n");
+	head = &rc->fs_devices->devices;
+	list_for_each(cur, head) {
+		dev = list_entry(cur, struct btrfs_device, dev_list);
+		uuid_unparse(dev->uuid, str);
+		printf("devid:%llu, name:%s, uuid:%s\n",
+		       dev->devid, dev->name, str);
+	}
+	printf("\n");
+}
+
+static int result_is_empty(struct recover_control *rc)
+{
+	if (rc->result.root.rb_node)
+		return 0;
+	else
+		return 1;
+}
+
+static int match_one_result(struct btrfs_trans_handle *trans,
+		struct recover_control *rc, struct btrfs_root *root,
+		struct result_record *result)
+{
+	int ret = 0;
+	int i;
+	int slot;
+	u64 offset;
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	struct btrfs_root *dev_root;
+	/*struct btrfs_chunk *chunk;*/
+	struct stripe *stripe;
+	struct btrfs_dev_extent *dev_extent;
+	struct extent_buffer *l;
+	struct chunk_record *citem;
+
+	dev_root = root->fs_info->dev_root;
+	offset = result->start;
+	citem = result->chunk;
+	for (i = 0; i < citem->num_stripes; i++) {
+		stripe = &citem->stripes[i];
+		key.objectid = stripe->devid;
+		key.offset = stripe->offset;
+		key.type = BTRFS_DEV_EXTENT_KEY;
+
+		path = btrfs_alloc_path();
+		if (!path)
+			return -ENOMEM;
+		btrfs_init_path(path);
+		ret = btrfs_search_slot(trans, dev_root, &key, path, 0, 0);
+		if (ret) {
+			btrfs_release_path(root, path);
+			return ret;
+		}
+		l = path->nodes[0];
+		slot = path->slots[0];
+		dev_extent = btrfs_item_ptr(l, slot, struct btrfs_dev_extent);
+		if (offset != btrfs_dev_extent_chunk_offset(l, dev_extent)) {
+			printf("device tree unmatch with chunks\n"
+			       "dev_extent[%llu, %llu], chunk[%llu, %llu]\n",
+			       btrfs_dev_extent_chunk_offset(l, dev_extent),
+			       btrfs_dev_extent_length(l, dev_extent),
+			       offset, citem->length);
+			btrfs_release_path(root, path);
+			ret = -1;
+			return ret;
+		}
+		btrfs_release_path(root, path);
+	}
+	return ret;
+}
+
+static int match_results(struct btrfs_trans_handle *trans,
+		struct recover_control *rc,
+		struct btrfs_root *root)
+{
+	int ret = 0;
+	struct cache_extent *n;
+	struct result_record *entry;
+	for (n = find_first_cache_extent(&rc->result, 0); n;
+	     n = next_cache_extent(n)) {
+		entry = cache_result_entry(n);
+		ret = match_one_result(trans, rc, root, entry);
+		if (ret)
+			return ret;
+	}
+	return ret;
+}
+
+static int extract_extent_tree(struct recover_control *rc, int fd, u64 bytenr)
+{
+	struct btrfs_header *header;
+	struct btrfs_item *item;
+	struct btrfs_block_group_item *bg_item;
+	char *buf;
+	char *start;
+	int ret = 0;
+	int i;
+	u32 nritems;
+	u32 offset;
+	u64 generation;
+
+	buf = malloc(rc->leafsize);
+	if (!buf)
+		return -ENOMEM;
+
+	if (pread64(fd, buf, rc->leafsize, bytenr) != rc->leafsize) {
+		ret = -EIO;
+		goto out;
+	}
+
+	header = (struct btrfs_header *)buf;
+	nritems = btrfs_stack_header_nritems(header);
+	start = buf + sizeof(struct btrfs_header);
+	offset = 0;
+	generation = btrfs_stack_header_generation(header);
+	for (i = 0; i < nritems; i++) {
+		item = (struct btrfs_item *)(start + offset);
+		if (btrfs_disk_key_type(&item->key) ==
+				BTRFS_BLOCK_GROUP_ITEM_KEY) {
+			bg_item = (typeof(bg_item))start + item->offset;
+			ret = insert_bg_record(&rc->bg, item, bg_item,
+					       generation);
+			if (ret < 0)
+				goto out;
+		}
+		offset += sizeof(struct btrfs_item);
+	}
+out:
+	free(buf);
+	return ret;
+}
+
+static int extract_chunk_tree(struct recover_control *rc, int fd, u64 bytenr)
+{
+	struct btrfs_header *header;
+	struct btrfs_item *item;
+	struct btrfs_chunk *chunk;
+	char *buf;
+	char *start;
+	int ret = 0;
+	int i;
+	u32 nritems;
+	u32 offset = 0;
+	u64 generation;
+
+	buf = malloc(rc->leafsize);
+	if (!buf)
+		return -ENOMEM;
+	if (pread64(fd, buf, rc->leafsize, bytenr) != rc->leafsize) {
+		ret = -EIO;
+		goto out;
+	}
+	header = (struct btrfs_header *) buf;
+	nritems = btrfs_stack_header_nritems(header);
+	start = buf + sizeof(struct btrfs_header);
+	offset = 0;
+	generation = btrfs_stack_header_generation(header);
+
+	for (i = 0; i < nritems; i++) {
+		item = (struct btrfs_item *) (start + offset);
+		if (btrfs_disk_key_type(&item->key) == BTRFS_CHUNK_ITEM_KEY) {
+			chunk = (typeof(chunk))start + item->offset;
+			ret = insert_chunk_record(&rc->chunk, item, chunk,
+						  generation);
+			if (ret < 0)
+				goto out;
+		}
+		offset += sizeof(struct btrfs_item);
+	}
+out:
+	free(buf);
+	return ret;
+}
+
+static int extract_dev_tree(struct recover_control *rc, int fd, u64 bytenr)
+{
+	struct btrfs_header *header;
+	struct btrfs_item *item;
+	struct btrfs_dev_extent *dev_extent;
+	char *buf;
+	char *start;
+	int ret = 0;
+	int i;
+	u32 nritems;
+	u32 offset = 0;
+	u64 generation;
+
+	buf = malloc(rc->leafsize);
+	if (!buf)
+		return -ENOMEM;
+
+	ret = pread64(fd, buf, rc->leafsize, bytenr);
+	if (ret != rc->leafsize) {
+		ret = -EIO;
+		goto out;
+	}
+
+	header = (struct btrfs_header *) buf;
+	nritems = btrfs_stack_header_nritems(header);
+	start = buf + sizeof(struct btrfs_header);
+	offset = 0;
+	generation = btrfs_stack_header_generation(header);
+	for (i = 0; i < nritems; i++) {
+		item = (struct btrfs_item *) (start + offset);
+		if (btrfs_disk_key_type(&item->key) == BTRFS_DEV_EXTENT_KEY) {
+			dev_extent = (typeof(dev_extent))start + item->offset;
+			ret = insert_devext_record(&rc->devext, item,
+						   dev_extent, generation);
+			if (ret < 0)
+				goto out;
+		}
+		offset += sizeof(struct btrfs_item);
+	}
+	ret = 0;
+out:
+	free(buf);
+	return ret;
+}
+
+static int scan_one_device_needed_data(struct recover_control *rc,
+				       int fd)
+{
+	int ret = 0;
+	char *buf;
+	char csum_result[BTRFS_CSUM_SIZE];
+	u64 crc;
+	u64 bytenr;
+	u64 sectorsize;
+	struct btrfs_header *header;
+	struct btrfs_super_block *sb;
+
+	sectorsize = rc->sectorsize;
+	buf = malloc(sectorsize);
+	if (!buf)
+		return -ENOMEM;
+
+	sb = malloc(sizeof(struct btrfs_super_block));
+	if (!sb) {
+		free(buf);
+		return -ENOMEM;
+	}
+
+	ret = btrfs_read_dev_super(fd, sb, BTRFS_SUPER_INFO_OFFSET);
+	if (ret) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	bytenr = 0;
+	while (1) {
+		ret = 0;
+		memset(buf, 0, sectorsize);
+		if (pread64(fd, buf, sectorsize, bytenr) < sectorsize)
+			break;
+
+		header = (struct btrfs_header *)buf;
+		if (!memcpy(header->fsid, rc->fs_devices->fsid,
+			    BTRFS_FSID_SIZE)) {
+			bytenr += rc->sectorsize;
+			continue;
+		}
+		crc = ~(u32)0;
+		crc = btrfs_csum_data(NULL, (char *)(buf + BTRFS_CSUM_SIZE),
+				crc, rc->leafsize - BTRFS_CSUM_SIZE);
+		btrfs_csum_final(crc, csum_result);
+		if (!memcmp(header->csum, csum_result, BTRFS_CSUM_SIZE)) {
+			bytenr += rc->sectorsize;
+			continue;
+		}
+
+		if (header->level != 0)
+			goto next_node;
+
+		switch (header->owner) {
+		case BTRFS_EXTENT_TREE_OBJECTID:
+			/* different tree use different generation */
+			if (header->generation > rc->generation)
+				break;
+			ret = extract_extent_tree(rc, fd, bytenr);
+			if (ret < 0)
+				goto out;
+			break;
+		case BTRFS_CHUNK_TREE_OBJECTID:
+			if (header->generation > rc->chunk_root_generation)
+				break;
+			ret = extract_chunk_tree(rc, fd, bytenr);
+			if (ret < 0)
+				goto out;
+			break;
+		case BTRFS_DEV_TREE_OBJECTID:
+			if (header->generation > rc->generation)
+				break;
+			ret = extract_dev_tree(rc, fd, bytenr);
+			if (ret < 0)
+				goto out;
+			break;
+		}
+next_node:
+		bytenr += rc->leafsize;
+		continue;
+	}
+out:
+	free(sb);
+	free(buf);
+	return ret;
+}
+
+static int scan_devices(struct recover_control *rc)
+{
+	int ret = 0;
+	int fd;
+	struct list_head *cur;
+	struct btrfs_device *dev;
+	if (!rc)
+		return -EFAULT;
+	list_for_each(cur, &rc->fs_devices->devices) {
+		dev = list_entry(cur, struct btrfs_device, dev_list);
+		fd = open(dev->name, O_RDONLY, 0600);
+		if (!fd)
+			return -ENOENT;
+		ret = scan_one_device_needed_data(rc, fd);
+		close(fd);
+		if (ret)
+			return ret;
+	}
+	return ret;
+}
+
+static int map_one_chunk(struct btrfs_root *root, struct result_record *result)
+{
+	int ret = 0;
+	int i;
+	u64 devid;
+	u8 uuid[BTRFS_UUID_SIZE];
+	u16 num_stripes;
+	struct btrfs_mapping_tree *map_tree;
+	struct map_lookup *map;
+	struct stripe *stripe;
+	/*struct btrfs_chunk *chunk;*/
+	struct chunk_record *citem = result->chunk;
+
+	map_tree = &root->fs_info->mapping_tree;
+	num_stripes = result->chunk->num_stripes;
+#define map_lookup_size(n) (sizeof(struct map_lookup) + \
+			    (sizeof(struct btrfs_bio_stripe) * (n)))
+	map = malloc(map_lookup_size(num_stripes));
+	if (!map)
+		return -ENOMEM;
+	map->ce.start = result->start;
+	map->ce.size = result->size;
+	map->num_stripes = num_stripes;
+	map->io_width = citem->io_width;
+	map->io_align = citem->io_align;
+	map->sector_size = citem->sector_size;
+	map->stripe_len = citem->stripe_len;
+	map->type = citem->type_flags;
+	map->sub_stripes = citem->sub_stripes;
+
+	for (i = 0, stripe = citem->stripes; i < num_stripes; i++, stripe++) {
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
+	ret = insert_existing_cache_extent(&map_tree->cache_tree, &map->ce);
+	return ret;
+}
+
+static int map_chunks(struct recover_control *rc, struct btrfs_root *root)
+{
+	int ret = 0;
+	struct cache_extent *n;
+	struct result_record *entry;
+
+	for (n = find_first_cache_extent(&rc->result, 0); n;
+	     n = next_cache_extent(n)) {
+		entry = cache_result_entry(n);
+		ret = map_one_chunk(root, entry);
+		if (ret)
+			return ret;
+	}
+	return ret;
+}
+
+static int __remove_chunk_extent_item(struct btrfs_trans_handle *trans,
+				      struct btrfs_root *root,
+				      u64 start, u64 offset)
+{
+	int ret;
+	struct btrfs_key key;
+	struct btrfs_path *path;
+
+	root = root->fs_info->extent_root;
+	key.objectid = start;
+	key.offset = offset;
+	key.type = BTRFS_EXTENT_ITEM_KEY;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+	if (ret < 0)
+		goto err;
+	else if (ret > 0) {
+		ret = 0;
+		goto err;
+	} else
+		ret = btrfs_del_item(trans, root, path);
+
+err:
+	btrfs_free_path(path);
+	return ret;
+}
+
+static int remove_chunk_extent_item(struct btrfs_trans_handle *trans,
+				    struct recover_control *rc,
+				    struct btrfs_root *root)
+{
+	int ret = 0;
+	struct cache_extent *n;
+	struct result_record *entry;
+	u64 start;
+	u64 end;
+	u64 sectorsize;
+
+	sectorsize = rc->sectorsize;
+	for (n = find_first_cache_extent(&rc->result, 0); n;
+	     n = next_cache_extent(n)) {
+		entry = cache_result_entry(n);
+		if (!(entry->recover_flags & RECOVER_CHUNK))
+			continue;
+		if (!(entry->chunk->type_flags & BTRFS_BLOCK_GROUP_SYSTEM))
+			continue;
+		start = entry->start;
+		end = entry->start + entry->size;
+		while (start < end) {
+			ret = __remove_chunk_extent_item(trans, root, start,
+					sectorsize);
+			if (ret)
+				return ret;
+			start += sectorsize;
+		}
+	}
+	return ret;
+}
+
+static int reset_block_group(struct btrfs_trans_handle *trans,
+			     struct btrfs_root *root,
+			     u64 bytenr, u64 num_bytes)
+{
+	int ret = 0;
+	struct btrfs_block_group_cache *cache;
+	struct btrfs_fs_info *info;
+	u64 byte_in_group;
+	u64 total;
+	u64 start;
+	u64 end;
+
+	info = root->fs_info;
+	total = num_bytes;
+	while (total) {
+		cache = btrfs_lookup_block_group(info, bytenr);
+		if (!cache)
+			return -1;
+
+		start = cache->key.objectid;
+		end = start + cache->key.offset - 1;
+		set_extent_bits(&info->block_group_cache, start, end,
+				EXTENT_DIRTY, GFP_NOFS);
+
+		byte_in_group = bytenr - cache->key.objectid;
+		num_bytes =  min(total, cache->key.offset - byte_in_group);
+
+		set_extent_dirty(&info->free_space_cache, bytenr,
+				 bytenr + num_bytes - 1, GFP_NOFS);
+
+		btrfs_set_block_group_used(&cache->item, 0);
+		total -= num_bytes;
+		bytenr += num_bytes;
+	}
+
+	return ret;
+}
+
+static int clean_sys_block_group_info(struct btrfs_trans_handle *trans,
+				      struct recover_control *rc,
+				      struct btrfs_root *root)
+{
+	int ret = 0;
+	struct cache_extent *n;
+	struct result_record *entry;
+
+	for (n = find_first_cache_extent(&rc->result, 0); n;
+	     n = next_cache_extent(n)) {
+		entry = cache_result_entry(n);
+		if (!(entry->recover_flags & RECOVER_BG))
+			continue;
+		if (!(entry->chunk->type_flags & BTRFS_BLOCK_GROUP_SYSTEM))
+			continue;
+		ret = reset_block_group(trans, root, entry->start, entry->size);
+		if (ret)
+			return ret;
+	}
+	return ret;
+}
+
+
+static int __reset_chunk_root(struct btrfs_trans_handle *trans,
+			      struct recover_control *rc,
+			      struct btrfs_root *root)
+{
+	int ret;
+	u64 min_devid;
+	struct list_head *head;
+	struct list_head *cur;
+	struct btrfs_super_block *super_copy;
+	struct btrfs_device *dev;
+	struct extent_buffer *cow;
+	struct btrfs_disk_key disk_key;
+
+	ret = 0;
+	min_devid = 1;
+	head = &rc->fs_devices->devices;
+	list_for_each(cur, head) {
+		dev = list_entry(cur, struct btrfs_device, dev_list);
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
+	super_copy = root->fs_info->super_copy;
+	btrfs_set_super_chunk_root(super_copy, cow->start);
+	btrfs_set_super_chunk_root_generation(super_copy, trans->transid);
+	btrfs_set_super_chunk_root_level(super_copy, 0);
+
+	return ret;
+}
+
+static int __rebuild_device_items(struct btrfs_trans_handle *trans,
+				  struct recover_control *rc,
+				  struct btrfs_root *root)
+{
+	int ret = 0;
+	struct list_head *cur;
+	struct list_head *head;
+	struct btrfs_device *dev;
+	struct btrfs_key key;
+	struct btrfs_dev_item *dev_item;
+
+	head = &rc->fs_devices->devices;
+	list_for_each(cur, head) {
+		dev = list_entry(cur, struct btrfs_device, dev_list);
+
+		key.objectid = BTRFS_DEV_ITEMS_OBJECTID;
+		key.type = BTRFS_DEV_ITEM_KEY;
+		key.offset = dev->devid;
+
+		dev_item = malloc(sizeof(struct btrfs_dev_item));
+		if (!dev_item)
+			return -ENOMEM;
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
+	return ret;
+}
+
+static int __rebuild_chunk_items(struct btrfs_trans_handle *trans,
+				 struct recover_control *rc,
+				 struct btrfs_root *root)
+{
+	int ret = 0;
+	int i;
+	struct btrfs_key key;
+	struct btrfs_chunk *chunk = NULL;
+	struct btrfs_root *chunk_root;
+	struct btrfs_stripe *stripe;
+	struct cache_extent *n;
+	struct result_record *entry;
+	struct chunk_record *citem;
+	chunk_root = root->fs_info->chunk_root;
+
+	for (n = find_first_cache_extent(&rc->result, 0); n;
+	     n = next_cache_extent(n)) {
+		entry = cache_result_entry(n);
+		citem = entry->chunk;
+		chunk = malloc(btrfs_chunk_item_size(citem->num_stripes));
+		if (!chunk)
+			return -ENOMEM;
+		btrfs_set_stack_chunk_length(chunk, citem->length);
+		btrfs_set_stack_chunk_owner(chunk, citem->owner);
+		btrfs_set_stack_chunk_stripe_len(chunk, citem->stripe_len);
+		btrfs_set_stack_chunk_type(chunk, citem->type_flags);
+		btrfs_set_stack_chunk_io_align(chunk, citem->io_align);
+		btrfs_set_stack_chunk_io_width(chunk, citem->io_width);
+		btrfs_set_stack_chunk_sector_size(chunk, citem->sector_size);
+		btrfs_set_stack_chunk_num_stripes(chunk, citem->num_stripes);
+		btrfs_set_stack_chunk_sub_stripes(chunk, citem->sub_stripes);
+		for (i = 0, stripe = &chunk->stripe; i < citem->num_stripes;
+		     i++, stripe++) {
+			btrfs_set_stack_stripe_devid(stripe,
+					citem->stripes[i].devid);
+			btrfs_set_stack_stripe_offset(stripe,
+					citem->stripes[i].devid);
+			memcpy(stripe->dev_uuid, &citem->stripes[i].dev_uuid,
+					BTRFS_UUID_SIZE);
+		}
+		key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
+		key.type = BTRFS_CHUNK_ITEM_KEY;
+		key.offset = entry->start;
+
+		ret = btrfs_insert_item(trans, chunk_root, &key, chunk,
+				btrfs_chunk_item_size(chunk->num_stripes));
+		if (ret)
+			return ret;
+	}
+	return ret;
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
+	ret = __reset_chunk_root(trans, rc, root);
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
+	int ret = 0;
+	int i;
+	u16 num_stripes;
+	struct btrfs_chunk *chunk = NULL;
+	struct btrfs_key key;
+	struct btrfs_stripe *stripe;
+	struct result_record *entry;
+	struct chunk_record *citem;
+	struct cache_extent *n;
+
+	btrfs_set_super_sys_array_size(root->fs_info->super_copy, 0);
+
+	for (n = find_first_cache_extent(&rc->result, 0); n;
+	     n = next_cache_extent(n)) {
+		entry = cache_result_entry(n);
+		if (!(entry->bg->flags & BTRFS_BLOCK_GROUP_SYSTEM))
+			continue;
+		num_stripes = entry->chunk->num_stripes;
+		chunk = malloc(btrfs_chunk_item_size(num_stripes));
+		if (!chunk)
+			return -ENOMEM;
+		citem = entry->chunk;
+
+		btrfs_set_stack_chunk_length(chunk, citem->length);
+		btrfs_set_stack_chunk_owner(chunk, citem->owner);
+		btrfs_set_stack_chunk_stripe_len(chunk, citem->stripe_len);
+		btrfs_set_stack_chunk_type(chunk, citem->type_flags);
+		btrfs_set_stack_chunk_io_align(chunk, citem->io_align);
+		btrfs_set_stack_chunk_io_width(chunk, citem->io_width);
+		btrfs_set_stack_chunk_sector_size(chunk, citem->sector_size);
+		btrfs_set_stack_chunk_num_stripes(chunk, citem->num_stripes);
+		btrfs_set_stack_chunk_sub_stripes(chunk, citem->sub_stripes);
+		for (i = 0, stripe = &chunk->stripe; i < num_stripes;
+		     i++, stripe++) {
+			btrfs_set_stack_stripe_devid(stripe,
+					citem->stripes[i].devid);
+			btrfs_set_stack_stripe_offset(stripe,
+					citem->stripes[i].devid);
+			memcpy(&stripe->dev_uuid, &citem->stripes[i].dev_uuid,
+					BTRFS_UUID_SIZE);
+		}
+		key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
+		key.type = BTRFS_CHUNK_ITEM_KEY;
+		key.offset = entry->start;
+
+		ret = btrfs_add_system_chunk(NULL, root, &key, chunk,
+				btrfs_chunk_item_size(num_stripes));
+		if (ret)
+			goto free_out;
+		free(chunk);
+		chunk = NULL;
+	}
+free_out:
+	if (chunk)
+		free(chunk);
+	return ret;
+
+}
+
+static struct btrfs_root *open_ctree_with_broken_chunk(
+				struct recover_control *rc,
+				const char *path,
+				int writes)
+{
+	int ret;
+	u32 sectorsize;
+	u32 nodesize;
+	u32 leafsize;
+	u32 blocksize;
+	u32 stripesize;
+	u64 generation;
+	u64 sb_bytenr;
+	u64 features;
+	struct btrfs_key key;
+	struct btrfs_root *tree_root = malloc(sizeof(struct btrfs_root));
+	struct btrfs_root *extent_root = malloc(sizeof(struct btrfs_root));
+	struct btrfs_root *chunk_root = malloc(sizeof(struct btrfs_root));
+	struct btrfs_root *dev_root = malloc(sizeof(struct btrfs_root));
+	struct btrfs_root *csum_root = malloc(sizeof(struct btrfs_root));
+	struct btrfs_fs_info *fs_info = malloc(sizeof(struct btrfs_fs_info));
+	struct btrfs_fs_devices *fs_devices = NULL;
+	struct btrfs_super_block *disk_super = NULL;
+
+	fs_devices = rc->fs_devices;
+	sb_bytenr = BTRFS_SUPER_INFO_OFFSET;
+
+	memset(fs_info, 0, sizeof(struct btrfs_fs_info));
+	/*fs_info->rc = rc;*/
+	fs_info->tree_root = tree_root;
+	fs_info->extent_root = extent_root;
+	fs_info->chunk_root = chunk_root;
+	fs_info->dev_root = dev_root;
+	fs_info->csum_root = csum_root;
+
+	extent_io_tree_init(&fs_info->extent_cache);
+	extent_io_tree_init(&fs_info->free_space_cache);
+	extent_io_tree_init(&fs_info->block_group_cache);
+	extent_io_tree_init(&fs_info->pinned_extents);
+	extent_io_tree_init(&fs_info->pending_del);
+	extent_io_tree_init(&fs_info->extent_ins);
+
+	cache_tree_init(&fs_info->fs_root_cache);
+	cache_tree_init(&fs_info->mapping_tree.cache_tree);
+
+	mutex_init(&fs_info->fs_mutex);
+	fs_info->fs_devices = fs_devices;
+	INIT_LIST_HEAD(&fs_info->dirty_cowonly_roots);
+	INIT_LIST_HEAD(&fs_info->space_info);
+
+	__setup_root(4096, 4096, 4096, 4096, tree_root,
+		     fs_info, BTRFS_ROOT_TREE_OBJECTID);
+
+	ret = btrfs_open_devices(fs_devices, O_RDWR);
+
+	fs_info->super_bytenr = sb_bytenr;
+	fs_info->super_copy = malloc(sizeof(struct btrfs_super_block));
+	if (!fs_info->super_copy) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	disk_super = fs_info->super_copy;
+	ret = btrfs_read_dev_super(fs_devices->latest_bdev,
+				   disk_super, sb_bytenr);
+	if (ret) {
+		fprintf(stderr, "No valid btrfs found\n");
+		ret = -ENOENT;
+		goto out;
+	}
+
+	memcpy(fs_info->fsid, &disk_super->fsid, BTRFS_FSID_SIZE);
+
+	features = btrfs_super_incompat_flags(disk_super) &
+		   ~BTRFS_FEATURE_INCOMPAT_SUPP;
+	if (features) {
+		fprintf(stderr,
+			"couldn't open because of unsupported option features (%Lx).\n",
+			features);
+		ret = -ENOTSUP;
+		goto out;
+	}
+
+	features = btrfs_super_incompat_flags(disk_super);
+	if (!(features & BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF)) {
+		features |= BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF;
+		btrfs_set_super_incompat_flags(disk_super, features);
+	}
+
+	features = btrfs_super_compat_ro_flags(disk_super) &
+		~BTRFS_FEATURE_COMPAT_RO_SUPP;
+	if (writes && features) {
+		fprintf(stderr,
+			"couldn't open RDWR because of unsupported option features (%Lx).\n",
+			features);
+		ret = -ENOTSUP;
+		goto out;
+	}
+
+	nodesize = btrfs_super_nodesize(disk_super);
+	leafsize = btrfs_super_leafsize(disk_super);
+	sectorsize = btrfs_super_sectorsize(disk_super);
+	stripesize = btrfs_super_stripesize(disk_super);
+	tree_root->nodesize = nodesize;
+	tree_root->leafsize = leafsize;
+	tree_root->sectorsize = sectorsize;
+	tree_root->stripesize = stripesize;
+
+	ret = rebuild_sys_array(rc, tree_root);
+	if (ret)
+		goto out;
+
+	ret = map_chunks(rc, tree_root);
+	if (ret)
+		goto out;
+
+	blocksize = btrfs_level_size(tree_root,
+				     btrfs_super_chunk_root_level(disk_super));
+	generation = btrfs_super_chunk_root_generation(disk_super);
+	__setup_root(nodesize, leafsize, sectorsize, stripesize,
+		     chunk_root, fs_info, BTRFS_CHUNK_TREE_OBJECTID);
+
+	blocksize = btrfs_level_size(tree_root,
+				     btrfs_super_root_level(disk_super));
+	generation = btrfs_super_generation(disk_super);
+
+	tree_root->node = read_tree_block(tree_root,
+					  btrfs_super_root(disk_super),
+					  blocksize, generation);
+	if (!tree_root->node) {
+		ret = -EIO;
+		goto out;
+	}
+
+	read_extent_buffer(tree_root->node, fs_info->chunk_tree_uuid,
+		(unsigned long)btrfs_header_chunk_tree_uuid(tree_root->node),
+		BTRFS_UUID_SIZE);
+
+	ret = find_and_setup_root(tree_root, fs_info,
+				  BTRFS_EXTENT_TREE_OBJECTID, extent_root);
+	if (ret)
+		goto out;
+	extent_root->track_dirty = 1;
+
+	ret = find_and_setup_root(tree_root, fs_info,
+				  BTRFS_DEV_TREE_OBJECTID, dev_root);
+	if (ret)
+		goto out;
+	dev_root->track_dirty = 1;
+
+	ret = find_and_setup_root(tree_root, fs_info,
+				  BTRFS_CSUM_TREE_OBJECTID, csum_root);
+	if (ret)
+		goto out;
+	csum_root->track_dirty = 1;
+
+	ret = find_and_setup_log_root(tree_root, fs_info, disk_super);
+	if (ret)
+		goto out;
+
+	fs_info->generation = generation + 1;
+	btrfs_read_block_groups(fs_info->tree_root);
+
+	key.objectid = BTRFS_FS_TREE_OBJECTID;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = (u64)-1;
+	fs_info->fs_root = btrfs_read_fs_root(fs_info, &key);
+
+	fs_info->data_alloc_profile = (u64)-1;
+	fs_info->metadata_alloc_profile = (u64)-1;
+	fs_info->system_alloc_profile = fs_info->metadata_alloc_profile;
+
+	return fs_info->fs_root;
+out:
+	return ERR_PTR(ret);
+}
+
+static int close_ctree_with_broken_chunk(struct recover_control *rc,
+					 struct btrfs_root *root)
+{
+	struct btrfs_fs_info *fs_info;
+
+	if (!rc || !root)
+		return -1;
+
+	fs_info = root->fs_info;
+
+	btrfs_free_block_groups(fs_info);
+	free_fs_roots(fs_info);
+
+	if (fs_info->extent_root->node)
+		free_extent_buffer(fs_info->extent_root->node);
+	if (fs_info->tree_root->node)
+		free_extent_buffer(fs_info->tree_root->node);
+	if (fs_info->chunk_root->node)
+		free_extent_buffer(fs_info->chunk_root->node);
+	if (fs_info->dev_root->node)
+		free_extent_buffer(fs_info->dev_root->node);
+	if (fs_info->csum_root->node)
+		free_extent_buffer(fs_info->csum_root->node);
+
+	if (fs_info->log_root_tree) {
+		if (fs_info->log_root_tree->node)
+			free_extent_buffer(fs_info->log_root_tree->node);
+		free(fs_info->log_root_tree);
+	}
+
+	extent_io_tree_cleanup(&fs_info->extent_cache);
+	extent_io_tree_cleanup(&fs_info->free_space_cache);
+	extent_io_tree_cleanup(&fs_info->block_group_cache);
+	extent_io_tree_cleanup(&fs_info->pinned_extents);
+	extent_io_tree_cleanup(&fs_info->pending_del);
+	extent_io_tree_cleanup(&fs_info->extent_ins);
+
+	free(fs_info->tree_root);
+	free(fs_info->extent_root);
+	free(fs_info->chunk_root);
+	free(fs_info->dev_root);
+	free(fs_info->csum_root);
+	free(fs_info->super_copy);
+	free(fs_info);
+
+	return 0;
+}
+
+static int recover_prepare(struct recover_control *rc,
+			   char *path, int silent)
+{
+	int ret;
+	int fd;
+	u64 total_devs;
+	struct btrfs_super_block *sb;
+	struct btrfs_fs_devices *fs_devices;
+
+	ret = 0;
+	fd = open(path, O_CREAT | O_RDWR, 0600);
+	if (fd < 0) {
+		fprintf(stderr, "open %s\n error", path);
+		return -1;
+	}
+
+	rc->fd = fd;
+	rc->silent = silent;
+
+	sb = malloc(sizeof(struct btrfs_super_block));
+	if (!sb) {
+		return -ENOMEM;
+		goto fail_close_fd;
+	}
+
+	ret = btrfs_read_dev_super(fd, sb, BTRFS_SUPER_INFO_OFFSET);
+	if (ret) {
+		fprintf(stderr, "read super block error\n");
+		free(sb);
+		goto fail_free_sb;
+	}
+
+	rc->sectorsize = btrfs_super_sectorsize(sb);
+	rc->leafsize = btrfs_super_leafsize(sb);
+	rc->generation = btrfs_super_generation(sb);
+	rc->chunk_root_generation = btrfs_super_chunk_root_generation(sb);
+
+	/* if seed, the result of scanning below will be partial */
+	if (btrfs_super_flags(sb) & BTRFS_SUPER_FLAG_SEEDING) {
+		fprintf(stderr, "this device is seed device\n");
+		ret = -1;
+		goto fail_free_sb;
+	}
+
+	ret = btrfs_scan_one_device(fd, path, &fs_devices,
+				    &total_devs, BTRFS_SUPER_INFO_OFFSET);
+	if (ret)
+		goto fail_free_sb;
+
+	if (total_devs != 1) {
+		ret = btrfs_scan_for_fsid(fs_devices, total_devs, 1);
+		if (ret)
+			goto fail_free_sb;
+	}
+
+	rc->fs_devices = fs_devices;
+
+	if (!rc->silent)
+		print_device(rc);
+
+fail_free_sb:
+	free(sb);
+fail_close_fd:
+	close(fd);
+	return ret;
+}
+
+static int recover_finish(struct recover_control *rc)
+{
+	if (rc && rc->fd)
+		close(rc->fd);
+
+	free_recover_control(rc);
+	return 0;
+}
+
+static int btrfs_chunk_tree_check(char *path, int silent)
+{
+	int ret = 0;
+	struct recover_control *rc = NULL;
+
+	rc = init_recover_control();
+	if (!rc)
+		return -ENOMEM;
+
+	ret = recover_prepare(rc, path, silent);
+	if (ret) {
+		fprintf(stderr, "recover prepare error\n");
+		goto fail_free_rc;
+	}
+
+	ret = scan_devices(rc);
+	if (ret) {
+		fprintf(stderr, "scan devices error\n");
+		goto fail_free_rc;
+	}
+
+	ret = check_scan_result(rc);
+	if (ret) {
+		fprintf(stderr, "check results error\n");
+		goto fail_free_rc;
+	}
+
+	if (result_is_empty(rc)) {
+		ret = -1;
+		goto fail_free_rc;
+	} else
+		print_result(rc);
+
+fail_free_rc:
+	recover_finish(rc);
+	return ret;
+}
+
+static int btrfs_chunk_tree_recover(char *path, int silent)
+{
+	int ret = 0;
+	struct btrfs_root *root = NULL;
+	struct btrfs_trans_handle *trans;
+	struct recover_control *rc = NULL;
+
+	rc = init_recover_control();
+	if (!rc)
+		return -ENOMEM;
+
+	ret = recover_prepare(rc, path, silent);
+	if (ret) {
+		fprintf(stderr, "recover prepare error\n");
+		goto fail_free_rc;
+	}
+
+	ret = scan_devices(rc);
+	if (ret) {
+		fprintf(stderr, "scan chunk headers error\n");
+		goto fail_free_rc;
+	}
+
+	ret = check_scan_result(rc);
+	if (ret) {
+		fprintf(stderr, "check chunk error\n");
+		goto fail_free_rc;
+	}
+
+	if (result_is_empty(rc)) {
+		fprintf(stderr, "no chunk recoverable error\n");
+		goto fail_free_rc;
+	} else
+		print_result(rc);
+
+	root = open_ctree_with_broken_chunk(rc, path, O_RDWR);
+	if (IS_ERR(root)) {
+		fprintf(stderr, "open with broken chunk error\n");
+		ret = PTR_ERR(root);
+		goto fail_close_ctree;
+	}
+
+	ret = match_results(NULL, rc, root);
+	if (ret) {
+		fprintf(stderr, "match chunk error\n");
+		goto fail_close_ctree;
+	}
+
+	trans = btrfs_start_transaction(root, 1);
+	ret = remove_chunk_extent_item(trans, rc, root);
+	BUG_ON(ret);
+
+	ret = clean_sys_block_group_info(trans, rc, root);
+	BUG_ON(ret);
+
+	ret = rebuild_chunk_tree(trans, rc, root);
+	BUG_ON(ret);
+	btrfs_commit_transaction(trans, root);
+
+fail_close_ctree:
+	close_ctree_with_broken_chunk(rc, root);
+fail_free_rc:
+	recover_finish(rc);
+	return ret;
+}
+
+static void print_usage(void)
+{
+	fprintf(stderr, "usage:btrfs-recover-chunk [options] dev\n");
+	fprintf(stderr, "options:\n");
+	fprintf(stderr, "\t -c --check stripe header after scan dev\n");
+	fprintf(stderr, "\t -s --silent mode\n");
+	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
+	exit(1);
+}
+int main(int argc, char *argv[])
+{
+	int ret = 0;
+	int silent = 0;
+	/* int check = 0; */
+	char *file;
+	int check = 0;
+
+	while (1) {
+		int c = getopt(argc, argv, "sc");
+		if (c < 0)
+			break;
+		switch (c) {
+		case 's':
+			silent  = 1;
+			break;
+		case 'c':
+			check = 1;
+			break;
+		default:
+			print_usage();
+		}
+	}
+
+	argc = argc - optind;
+	if (argc == 0)
+		print_usage();
+
+	file = argv[optind];
+
+	ret = check_mounted(file);
+	if (ret) {
+		fprintf(stderr, "the device is busy\n");
+		return ret;
+	}
+
+	if (silent)
+		printf("slient mode enable\n");
+	if (check) {
+		ret = btrfs_chunk_tree_check(file, silent);
+		if (ret)
+			printf("some stripe header invalid\n");
+		else
+			printf("all stripe headers valid\n");
+	} else {
+		ret = btrfs_chunk_tree_recover(file, silent);
+		if (ret)
+			printf("rebuild chunk tree fail\n");
+		else
+			printf("rebuild chunk tree success\n");
+	}
+	return ret;
+
+}
diff --git a/cmds-check.c b/cmds-check.c
index fda2cf2..12f4f08 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -40,65 +40,7 @@
 #include "commands.h"
 #include "free-space-cache.h"
 #include "dev-extent-cache.h"
-
-#define REC_UNCHECKED	0
-#define REC_CHECKED	1
-
-struct block_group_record {
-	struct cache_extent cache;
-	int state;
-
-	u64 objectid;
-	u8  type;
-	u64 offset;
-
-	u64 flags;
-};
-
-struct dev_record {
-	struct cache_extent cache;
-	int state;
-
-	u64 objectid;
-	u8  type;
-	u64 offset;
-
-	u64 devid;
-	u64 total_byte;
-	u64 byte_used;
-};
-
-struct stripe {
-	u64 devid;
-	u64 offset;
-};
-
-struct chunk_record {
-	struct cache_extent cache;
-	int state;
-
-	u64 objectid;
-	u8  type;
-	u64 offset;
-
-	u64 length;
-	u64 type_flags;
-	u16 num_stripes;
-	struct stripe stripes[0];
-};
-
-struct dev_extent_record {
-	struct cache_dev_extent cache;
-	int state;
-
-	u64 objectid;
-	u8  type;
-	u64 offset;
-
-	u64 chunk_objecteid;
-	u64 chunk_offset;
-	u64 length;
-};
+#include "recover-chunk.h"
 
 static u64 bytes_used = 0;
 static u64 total_csum_bytes = 0;
diff --git a/disk-io.c b/disk-io.c
index 21b410d..16b7617 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -604,7 +604,7 @@ commit_tree:
 	return 0;
 }
 
-static int find_and_setup_root(struct btrfs_root *tree_root,
+int find_and_setup_root(struct btrfs_root *tree_root,
 			       struct btrfs_fs_info *fs_info,
 			       u64 objectid, struct btrfs_root *root)
 {
@@ -630,7 +630,7 @@ static int find_and_setup_root(struct btrfs_root *tree_root,
 	return 0;
 }
 
-static int find_and_setup_log_root(struct btrfs_root *tree_root,
+int find_and_setup_log_root(struct btrfs_root *tree_root,
 			       struct btrfs_fs_info *fs_info,
 			       struct btrfs_super_block *disk_super)
 {
@@ -681,7 +681,7 @@ int btrfs_free_fs_root(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
-static int free_fs_roots(struct btrfs_fs_info *fs_info)
+int free_fs_roots(struct btrfs_fs_info *fs_info)
 {
 	struct cache_extent *cache;
 	struct btrfs_root *root;
diff --git a/disk-io.h b/disk-io.h
index c29ee8e..eddca86 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -87,3 +87,12 @@ int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid);
 
 /* raid6.c */
 void raid6_gen_syndrome(int disks, size_t bytes, void **ptrs);
+
+int find_and_setup_log_root(struct btrfs_root *tree_root,
+			       struct btrfs_fs_info *fs_info,
+			       struct btrfs_super_block *disk_super);
+
+int find_and_setup_root(struct btrfs_root *tree_root,
+			       struct btrfs_fs_info *fs_info,
+			       u64 objectid, struct btrfs_root *root);
+int free_fs_roots(struct btrfs_fs_info *fs_info);
diff --git a/recover-chunk.c b/recover-chunk.c
new file mode 100644
index 0000000..d5a3374
--- /dev/null
+++ b/recover-chunk.c
@@ -0,0 +1,636 @@
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
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <uuid/uuid.h>
+#include <string.h>
+
+#include "kerncompat.h"
+#include "list.h"
+#include "ctree.h"
+#include "extent-cache.h"
+#include "disk-io.h"
+#include "volumes.h"
+#include "transaction.h"
+#include "crc32c.h"
+#include "utils.h"
+#include "version.h"
+#include "recover-chunk.h"
+#include "extent-cache.h"
+
+BTRFS_SETGET_STACK_FUNCS(stack_dev_extent_chunk_objectid,
+               struct btrfs_dev_extent, chunk_objectid, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_dev_extent_chunk_offset,
+               struct btrfs_dev_extent, chunk_offset, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_dev_extent_length, struct btrfs_dev_extent,
+               length, 64);
+
+static inline unsigned long chunk_record_size(int num_stripes)
+{
+	BUG_ON(num_stripes == 0);
+	return sizeof(struct chunk_record) +
+		sizeof(struct stripe) * num_stripes;
+}
+static inline struct block_group_record *cache_bg_entry(
+		struct cache_extent *cache)
+{
+	if (!cache)
+		return NULL;
+	return container_of(cache, struct block_group_record, cache);
+}
+static inline struct chunk_record *cache_chunk_entry(
+		struct cache_extent *cache)
+{
+	if (!cache)
+		return NULL;
+	return container_of(cache, struct chunk_record, cache);
+}
+static inline struct dev_extent_record *cache_devext_entry(
+		struct cache_dev_extent *cache)
+{
+	if (!cache)
+		return NULL;
+	return container_of(cache, struct dev_extent_record, cache);
+}
+inline struct result_record *cache_result_entry(
+		struct cache_extent *cache)
+{
+	if (!cache)
+		return NULL;
+	return container_of(cache, struct result_record, cache);
+}
+
+static inline struct cache_extent *rb_cache_entry(struct rb_node *node)
+{
+	return rb_entry(node, struct cache_extent, rb_node);
+}
+static inline struct cache_dev_extent *rb_devext_entry(struct rb_node *node)
+{
+	return container_of(node, struct cache_dev_extent, rb_node);
+}
+
+#define FREE_CACHE_BASED_TREE(name, record_type)			\
+static void free_##name##_tree(struct cache_tree *tree)			\
+{									\
+	struct cache_extent *n;						\
+	struct record_type *entry;					\
+	for (n = find_first_cache_extent(tree, 0); n;			\
+	     n = find_first_cache_extent(tree, 0)) {			\
+		entry = cache_##name##_entry(n);			\
+		remove_cache_extent(tree, n);				\
+		free(entry);						\
+	}								\
+}
+FREE_CACHE_BASED_TREE(bg, block_group_record);
+FREE_CACHE_BASED_TREE(chunk, chunk_record);
+
+static void free_devext_tree(struct dev_extent_tree *devext_tree)
+{
+	struct rb_node *n;
+	struct cache_dev_extent *cache_entry;
+	struct dev_extent_record *devext_entry;
+	for (n = rb_first(&devext_tree->root); n;
+	     n = rb_first(&devext_tree->root)) {
+		cache_entry = rb_devext_entry(n);
+		devext_entry = cache_devext_entry(cache_entry);
+		remove_cache_dev_extent(devext_tree, cache_entry);
+		free(devext_entry);
+	}
+
+}
+struct recover_control *init_recover_control()
+{
+	struct recover_control *rc;
+
+	rc = malloc(sizeof(struct recover_control));
+	if (!rc)
+		return NULL;
+
+	memset(rc, 0, sizeof(struct recover_control));
+	cache_tree_init(&rc->bg);
+	cache_tree_init(&rc->chunk);
+	dev_extent_tree_init(&rc->devext);
+
+	return rc;
+}
+
+int free_recover_control(struct recover_control *rc)
+{
+	if (!rc)
+		return -1;
+
+	free_bg_tree(&rc->bg);
+	free_chunk_tree(&rc->chunk);
+	free_devext_tree(&rc->devext);
+	free(rc);
+
+	return 0;
+}
+
+struct block_group_record *find_bg_record(struct cache_tree *tree, u64 start,
+					  u64 size)
+{
+	struct cache_extent *cache_entry;
+	cache_entry = find_cache_extent(tree, start, size);
+	return cache_bg_entry(cache_entry);
+}
+
+int insert_bg_record(struct cache_tree *tree, struct btrfs_item *item,
+		     struct btrfs_block_group_item *data, u64 gen)
+{
+	int ret = 0;
+	struct block_group_record *bg_entry;
+	struct block_group_record *bg_find_entry;
+
+	bg_entry = malloc(sizeof(struct block_group_record));
+	if (!bg_entry)
+		return -ENOMEM;
+	bg_entry->objectid = btrfs_disk_key_objectid(&item->key);
+	bg_entry->type = btrfs_disk_key_type(&item->key);
+	bg_entry->offset = btrfs_disk_key_offset(&item->key);
+	bg_entry->generation = gen;
+	bg_entry->flags = btrfs_block_group_flags(data);
+	bg_entry->cache.start = bg_entry->objectid;
+	bg_entry->cache.size = bg_entry->offset;
+
+	bg_find_entry = find_bg_record(tree, bg_entry->objectid,
+			bg_entry->offset);
+	if (bg_find_entry) {
+		/*check the generation and replace if needed*/
+		if (bg_find_entry->generation > bg_entry->generation)
+			goto free_out;
+		/*FIXME:need better method to deal with duplicant generation*/
+		if (bg_find_entry->generation == bg_entry->generation) {
+			ret = -EIO;
+			goto free_out;
+		}
+		/*newer generation found, replace*/
+		rb_replace_node(&bg_find_entry->cache.rb_node,
+				&bg_entry->cache.rb_node,
+				&tree->root);
+		free(bg_find_entry);
+		goto out;
+	}
+	/*new record, add*/
+	ret = insert_existing_cache_extent(tree, &bg_entry->cache);
+	if (ret < 0)
+		goto free_out;
+	goto out;
+free_out:
+	free(bg_entry);
+out:
+	return ret;
+}
+
+struct chunk_record *find_chunk_record(struct cache_tree *tree,
+		u64 start, u64 size)
+{
+	struct cache_extent *cache_entry;
+	cache_entry = find_cache_extent(tree, start, size);
+	return cache_chunk_entry(cache_entry);
+}
+
+int insert_chunk_record(struct cache_tree *tree, struct btrfs_item *item,
+		struct btrfs_chunk *data, u64 gen)
+{
+	int ret = 0;
+	int i;
+	struct chunk_record *chunk_entry;
+	struct chunk_record *chunk_find_entry;
+	struct btrfs_stripe *stripe;
+
+	chunk_entry = malloc(chunk_record_size(
+				btrfs_stack_chunk_num_stripes(data)));
+	if (!chunk_entry)
+		return -ENOMEM;
+	chunk_entry->objectid = btrfs_disk_key_objectid(&item->key);
+	chunk_entry->type = btrfs_disk_key_type(&item->key);
+	chunk_entry->offset = btrfs_disk_key_offset(&item->key);
+	chunk_entry->generation = gen;
+	chunk_entry->length = btrfs_stack_chunk_length(data);
+	chunk_entry->owner = btrfs_stack_chunk_owner(data);
+	chunk_entry->stripe_len = btrfs_stack_chunk_stripe_len(data);
+	chunk_entry->type_flags = btrfs_stack_chunk_type(data);
+	chunk_entry->io_width = btrfs_stack_chunk_io_width(data);
+	chunk_entry->io_align = btrfs_stack_chunk_io_align(data);
+	chunk_entry->sector_size = btrfs_stack_chunk_sector_size(data);
+	chunk_entry->num_stripes = btrfs_stack_chunk_num_stripes(data);
+	chunk_entry->sub_stripes = btrfs_stack_chunk_sub_stripes(data);
+	for (i = 0, stripe = &data->stripe; i < chunk_entry->num_stripes;
+	     i++, stripe++) {
+		chunk_entry->stripes[i].devid = btrfs_stack_stripe_devid(
+				stripe + i);
+		chunk_entry->stripes[i].offset = btrfs_stack_stripe_offset(
+				stripe + i);
+		memcpy(&chunk_entry->stripes[i].dev_uuid,
+				(stripe + i)->dev_uuid, BTRFS_UUID_SIZE);
+	}
+	chunk_entry->cache.start = chunk_entry->offset;
+	chunk_entry->cache.size = chunk_entry->length;
+
+	chunk_find_entry = find_chunk_record(tree, chunk_entry->offset,
+			chunk_entry->length);
+	if (chunk_find_entry) {
+		if (chunk_find_entry->generation > chunk_entry->generation)
+			goto free_out;
+		/*FIXME:need better method to deal with duplicant generation*/
+		if (chunk_find_entry->generation == chunk_entry->generation) {
+			ret = -EIO;
+			goto free_out;
+		}
+		rb_replace_node(&chunk_find_entry->cache.rb_node,
+				&chunk_entry->cache.rb_node,
+				&tree->root);
+		goto out;
+	}
+	ret = insert_existing_cache_extent(tree, &chunk_entry->cache);
+	if (ret < 0)
+		goto free_out;
+	goto out;
+free_out:
+	free(chunk_entry);
+out:
+	return ret;
+}
+
+struct dev_extent_record *find_devext_record(struct dev_extent_tree *tree,
+		u64 devno, u64 offset)
+{
+	struct cache_dev_extent *cache_entry;
+	cache_entry = find_cache_dev_extent(tree, devno, offset);
+	return cache_devext_entry(cache_entry);
+}
+
+int insert_devext_record(struct dev_extent_tree *tree, struct btrfs_item *item,
+		struct btrfs_dev_extent *data, u64 gen)
+{
+	int ret = 0;
+	struct dev_extent_record *devext_entry;
+	struct dev_extent_record *devext_find_entry;
+
+	devext_entry = malloc(sizeof(struct dev_extent_record));
+	if (!devext_entry)
+		return -ENOMEM;
+
+	devext_entry->objectid = btrfs_disk_key_objectid(&item->key);
+	devext_entry->type = btrfs_disk_key_type(&item->key);
+	devext_entry->offset = btrfs_disk_key_offset(&item->key);
+	devext_entry->generation = gen;
+	devext_entry->chunk_objecteid = btrfs_stack_dev_extent_chunk_objectid(
+			data);
+	devext_entry->chunk_offset = btrfs_stack_dev_extent_chunk_offset(
+			data);
+	devext_entry->length = btrfs_stack_dev_extent_length(data);
+	devext_entry->cache.devno = devext_entry->objectid;
+	devext_entry->cache.offset = devext_entry->offset;
+	devext_find_entry = find_devext_record(tree, devext_entry->objectid,
+			devext_entry->offset);
+	INIT_LIST_HEAD(&devext_entry->list);
+	if (devext_find_entry) {
+		if (devext_find_entry->generation > devext_entry->generation)
+			goto free_out;
+		/*FIXME:need better method ot deal with duplicant generation*/
+		if (devext_find_entry->generation == devext_entry->generation) {
+			ret = -EIO;
+			goto free_out;
+		}
+		rb_replace_node(&devext_find_entry->cache.rb_node,
+				&devext_entry->cache.rb_node,
+				&tree->root);
+		free(devext_find_entry);
+		goto out;
+	}
+	ret = insert_existing_cache_dev_extent(tree, &devext_entry->cache);
+	if (ret < 0)
+		goto free_out;
+	goto out;
+free_out:
+	free(devext_entry);
+out:
+	return ret;
+}
+
+struct result_record *find_result_item(struct cache_tree *tree,
+		u64 start, u64 size)
+{
+	struct cache_extent *cache_entry;
+	cache_entry = find_cache_extent(tree, start, size);
+	return cache_result_entry(cache_entry);
+}
+
+static void __update_devext_list(struct dev_extent_record *dest,
+		struct dev_extent_record *src)
+{
+	struct dev_extent_record *cur;
+	int found = 0;
+	list_for_each_entry(cur, &dest->list, list) {
+		if (cur->objectid == src->objectid &&
+		    cur->chunk_offset == src->chunk_offset) {
+			found = 1;
+			break;
+		}
+	}
+	if (!found)
+		list_add(&src->list, &dest->list);
+}
+
+static int __check_devext_full(struct result_record *rec)
+{
+	u16 n = 1;
+	struct list_head *cur;
+
+	if (!rec->devext)
+		return 0;
+
+	list_for_each(cur, &rec->devext->list)
+		n++;
+
+	if (n == rec->chunk->num_stripes)
+		return 1;
+
+	return 0;
+}
+
+int update_result_record(struct cache_tree *tree, struct result_record *data)
+{
+	int ret = 0;
+	struct result_record *result_entry;
+	struct result_record *dest;
+
+	result_entry = find_result_item(tree, data->start, data->size);
+	if (result_entry) {
+		/*update the existing one*/
+		if (!(result_entry->recover_flags & RECOVER_CHUNK) &&
+		    data->recover_flags & RECOVER_CHUNK)
+			result_entry->chunk = data->chunk;
+
+		if (data->recover_flags & RECOVER_DEVEXT) {
+			if (!result_entry->devext)
+				result_entry->devext = data->devext;
+			else
+				__update_devext_list(result_entry->devext,
+						     data->devext);
+		}
+
+		if (!(result_entry->recover_flags & RECOVER_BG) &&
+		    (data->recover_flags & RECOVER_BG))
+			result_entry->bg = data->bg;
+
+		result_entry->recover_flags |= data->recover_flags;
+		if (__check_devext_full(result_entry))
+			result_entry->recover_flags |= RECOVER_DEVEXT_FULL;
+
+		return 0;
+	}
+	dest = malloc(sizeof(struct result_record));
+	if (!dest)
+		return -ENOMEM;
+	memset(dest, 0, sizeof(struct result_record));
+
+	dest->start = data->start;
+	dest->size = data->size;
+
+	dest->cache.start = dest->start;
+	dest->cache.size = dest->size;
+	if (data->recover_flags & RECOVER_CHUNK && data->chunk)
+		dest->chunk = data->chunk;
+	if (data->recover_flags & RECOVER_DEVEXT && data->devext)
+		dest->devext = data->devext;
+	if (data->recover_flags & RECOVER_BG && data->bg)
+		dest->bg = data->bg;
+	dest->recover_flags = data->recover_flags;
+	if (__check_devext_full(dest))
+		dest->recover_flags |= RECOVER_DEVEXT_FULL;
+	ret = insert_existing_cache_extent(tree, &dest->cache);
+	if (ret < 0)
+		goto free_out;
+	return 0;
+free_out:
+	free(dest);
+	return ret;
+}
+
+void print_bg_tree(struct cache_tree *tree)
+{
+	struct cache_extent *n;
+	struct block_group_record *entry;
+	for (n = find_first_cache_extent(tree, 0); n;
+	     n = next_cache_extent(n)) {
+		entry = cache_bg_entry(n);
+		printf("start:\t%llu\n", entry->objectid);
+		printf("length:\t%llu\n", entry->offset);
+		printf("flags:\t%llu\n", entry->flags);
+		printf("\n");
+	}
+}
+
+void print_stripe(struct stripe *data)
+{
+	printf("stripe devid:\t%llu\n", data->devid);
+	printf("stripe offset:\t%llu\n", data->offset);
+	printf("\n");
+}
+
+void print_chunk_tree(struct cache_tree *tree)
+{
+	struct cache_extent *n;
+	struct chunk_record *entry;
+	int i;
+	for (n = find_first_cache_extent(tree, 0); n;
+	     n = next_cache_extent(n)) {
+		entry = cache_chunk_entry(n);
+		printf("start:\t%llu\n", entry->offset);
+		printf("length:\t%llu\n", entry->length);
+		printf("type:\t%llu\n", entry->type_flags);
+		printf("num_stripes:\t%u\n", entry->num_stripes);
+		printf("\n");
+		printf("stripe data:\n");
+		for (i = 0; i < entry->num_stripes; i++)
+			print_stripe(&entry->stripes[i]);
+	}
+}
+
+void print_devext_tree(struct dev_extent_tree *tree)
+{
+	struct cache_dev_extent *n;
+	struct dev_extent_record *entry;
+	for (n = find_first_cache_dev_extent(tree, 0); n;
+	     n = next_cache_dev_extent(n)) {
+		entry = cache_devext_entry(n);
+		printf("devid:\t%llu\n", entry->objectid);
+		printf("start:\t%llu\n", entry->offset);
+		printf("chunk_offset:\t%llu\n", entry->chunk_offset);
+		printf("length:\t%llu\n", entry->length);
+		printf("\n");
+	}
+}
+
+void print_rc(struct recover_control *rc)
+{
+	struct list_head *cur;
+	struct btrfs_device *dev;
+
+	printf("===================================\n");
+	printf("recover control data:\n");
+	printf("silent:\t%d\n", rc->silent);
+	printf("sectorsize:\t%d\n", rc->sectorsize);
+	printf("leafsize:\t%d\n", rc->leafsize);
+	printf("generation:\t%llu\n", rc->generation);
+	printf("chunk_root_generation:\t%llu\n", rc->chunk_root_generation);
+	printf("\n");
+	printf("===================================\n");
+
+	printf("devices list:\n");
+	list_for_each(cur, &rc->fs_devices->devices) {
+		dev = list_entry(cur, struct btrfs_device, dev_list);
+		printf("device path:\t%s\n", dev->name);
+	}
+
+	printf("\n");
+	printf("===================================\n");
+	printf("block group item data:\n");
+	print_bg_tree(&rc->bg);
+	printf("\n");
+	printf("===================================\n");
+	printf("chunk data:\n");
+	print_chunk_tree(&rc->chunk);
+	printf("\n");
+	printf("===================================\n");
+	printf("device extent data:\n");
+	print_devext_tree(&rc->devext);
+}
+
+/*The real chunk rebuild should go here */
+int __check_scan_result(struct recover_control *rc)
+{
+	struct cache_extent *n;
+	struct result_record *entry;
+
+	for (n = find_first_cache_extent(&rc->result, 0); n;
+	     n = next_cache_extent(n)) {
+		entry = cache_result_entry(n);
+		if (!((entry->recover_flags & RECOVER_CHUNK) &&
+		      (entry->recover_flags & RECOVER_BG) &&
+		      (entry->recover_flags & RECOVER_DEVEXT_FULL))) {
+			printf("Not enough data for recover chunk:\n");
+			printf("chunk start:\t%llu:\n", entry->start);
+			printf("chunk size:\t%llu:\n", entry->size);
+			return -1;
+		}
+	}
+	return 0;
+}
+int check_scan_result(struct recover_control *rc)
+{
+	int ret = 0;
+	struct cache_extent *ce;
+	struct cache_dev_extent *cde;
+	struct chunk_record *chunk;
+	struct block_group_record *bg;
+	struct dev_extent_record *devext;
+	struct result_record dest;
+
+	for (ce = find_first_cache_extent(&rc->chunk, 0); ce;
+	     ce = next_cache_extent(ce)) {
+		memset(&dest, 0, sizeof(struct result_record));
+		chunk = cache_chunk_entry(ce);
+		dest.start = chunk->offset;
+		dest.size = chunk->length;
+		dest.recover_flags |= RECOVER_CHUNK;
+		dest.chunk = chunk;
+		dest.cache.start = chunk->offset;
+		dest.cache.size = chunk->length;
+
+		ret = update_result_record(&rc->result, &dest);
+		if (ret < 0)
+			return ret;
+	}
+
+	for (cde = find_first_cache_dev_extent(&rc->devext, 0); cde;
+	     cde = next_cache_dev_extent(cde)) {
+		memset(&dest, 0, sizeof(struct result_record));
+		devext = cache_devext_entry(cde);
+		dest.start = devext->offset;
+		dest.size = devext->length;
+		dest.recover_flags |= RECOVER_DEVEXT;
+		dest.devext = devext;
+		dest.cache.start = devext->chunk_offset;
+		dest.cache.size = devext->length;
+
+		ret = update_result_record(&rc->result, &dest);
+		if (ret < 0)
+			return ret;
+	}
+
+	for (ce = find_first_cache_extent(&rc->bg, 0); ce;
+	     ce = next_cache_extent(ce)) {
+		memset(&dest, 0, sizeof(struct result_record));
+		bg = cache_bg_entry(ce);
+		dest.start = bg->objectid;
+		dest.size = bg->offset;
+		dest.recover_flags |= RECOVER_BG;
+		dest.bg = bg;
+		dest.cache.start = bg->objectid;
+		dest.cache.size = bg->offset;
+
+		ret = update_result_record(&rc->result, &dest);
+		if (ret < 0)
+			return ret;
+	}
+	return __check_scan_result(rc);
+}
+
+void print_result(struct recover_control *rc)
+{
+	u64 result_nr = 0;
+	u64 confirmed = 0;
+	u64 unsure = 0;
+	struct cache_extent *n;
+	struct result_record *entry;
+
+	for (n = find_first_cache_extent(&rc->result, 0); n;
+	     n = next_cache_extent(n))
+		result_nr++;
+
+	printf("Total number of chunks:\t%lld\n", result_nr);
+	printf("===========================\n");
+	printf("result data:\n");
+	for (n = find_first_cache_extent(&rc->result, 0); n;
+	     n = next_cache_extent(n)) {
+		entry = cache_result_entry(n);
+		printf("chunk start:\t%llu\n", entry->start);
+		printf("chunk len:\t%llu\n", entry->size);
+		printf("recover flags:\t%u\n", entry->recover_flags);
+		printf("\n");
+		if ((entry->recover_flags & RECOVER_CHUNK) &&
+		    (entry->recover_flags & RECOVER_DEVEXT_FULL) &&
+		    (entry->recover_flags & RECOVER_BG))
+			confirmed++;
+		else
+			unsure++;
+	}
+	printf("Confirmed chunks:\t%lld\n", confirmed);
+	printf("Unsure chunks:\t%lld\n", unsure);
+}
diff --git a/recover-chunk.h b/recover-chunk.h
new file mode 100644
index 0000000..2855f4f
--- /dev/null
+++ b/recover-chunk.h
@@ -0,0 +1,145 @@
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
+#ifndef __PENDING_CHUNK__
+#define __PENDING_CHUNK__
+#include "kerncompat.h"
+#include "volumes.h"
+#include "list.h"
+#include "ctree.h"
+#include "rbtree.h"
+#include "dev-extent-cache.h"
+#include "extent-cache.h"
+
+#define REC_UNCHECKED	0
+#define REC_CHECKED	1
+
+struct result_record *cache_result_entry(
+		struct cache_extent *cache);
+struct block_group_record {
+	struct cache_extent cache;
+	int state;
+
+	u64 objectid;
+	u8  type;
+	u64 offset;
+	u64 generation;
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
+	u64 generation;
+
+	u64 devid;
+	u64 total_byte;
+	u64 byte_used;
+};
+
+struct stripe {
+	u64 devid;
+	u64 offset;
+	u8 dev_uuid[BTRFS_UUID_SIZE];
+};
+
+struct chunk_record {
+	struct cache_extent cache;
+	int state;
+
+	u64 objectid;
+	u8  type;
+	u64 offset;
+	u64 generation;
+
+	u64 length;
+	u64 owner;
+	u64 stripe_len;
+	u64 type_flags;
+	u32 io_align;
+	u32 io_width;
+	u32 sector_size;
+	u16 num_stripes;
+	u16 sub_stripes;
+	struct stripe stripes[0];
+};
+
+struct dev_extent_record {
+	struct cache_dev_extent cache;
+	struct list_head list;
+	int state;
+
+	u64 objectid;
+	u8  type;
+	u64 offset;
+	u64 generation;
+
+	u64 chunk_objecteid;
+	u64 chunk_offset;
+	u64 length;
+};
+
+#define RECOVER_CHUNK		(1<<0)
+#define RECOVER_BG		(1<<1)
+#define RECOVER_DEVEXT		(1<<2)
+#define RECOVER_DEVEXT_FULL	(1<<3)
+struct result_record {
+	struct cache_extent cache;
+	int recover_flags;
+
+	u64 start;
+	u64 size;
+
+	struct chunk_record *chunk;
+	struct block_group_record *bg;
+	struct dev_extent_record *devext;
+};
+
+struct recover_control {
+	int fd;
+	int silent;
+	u32 sectorsize;
+	u32 leafsize;
+	u64 generation;
+	u64 chunk_root_generation;
+	struct btrfs_fs_devices *fs_devices;
+	struct cache_tree bg;
+	struct cache_tree chunk;
+	struct dev_extent_tree devext;
+	struct cache_tree result;
+};
+
+struct recover_control *init_recover_control();
+int free_recover_control(struct recover_control *rc);
+void print_rc(struct recover_control *rc);
+
+int check_scan_result(struct recover_control *rc);
+void print_result(struct recover_control *rc);
+
+int insert_bg_record(struct cache_tree *tree, struct btrfs_item *item,
+		struct btrfs_block_group_item *data, u64 gen);
+int insert_chunk_record(struct cache_tree *tree, struct btrfs_item *item,
+		struct btrfs_chunk *data, u64 gen);
+int insert_devext_record(struct dev_extent_tree *tree, struct btrfs_item *item,
+		struct btrfs_dev_extent *data, u64 gen);
+#endif
diff --git a/volumes.h b/volumes.h
index 911f788..722b39c 100644
--- a/volumes.h
+++ b/volumes.h
@@ -190,4 +190,6 @@ int btrfs_add_system_chunk(struct btrfs_trans_handle *trans,
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
 struct btrfs_device *btrfs_find_device_by_devid(struct btrfs_root *root,
                                                 u64 devid, int instance);
+struct btrfs_device *btrfs_find_device(struct btrfs_root *root, u64 devid,
+				       u8 *uuid, u8 *fsid);
 #endif
-- 
1.8.2.3

