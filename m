From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] update btrfs-progs for seed device support
Date: Tue, 11 Nov 2008 21:26:48 +0800
Message-ID: <49198818.7080807@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

hello,

This patch has following 3 things.

1) Update device management code to match the kernel code.

2) Allocator fixes.

3) Add a program called btrfstune to set/clear the SEEDING
   super block flags.

Regards

Yan Zheng <zheng.yan@oracle.com>

---
diff -urpN btrfs-progs-orig/btrfstune.c btrfs-progs-2/btrfstune.c
--- btrfs-progs-orig/btrfstune.c	1970-01-01 07:00:00.000000000 +0700
+++ btrfs-progs-2/btrfstune.c	2008-11-07 14:29:01.000000000 +0800
@@ -0,0 +1,126 @@
+/*
+ * Copyright (C) 2008 Oracle.  All rights reserved.
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
+#define _XOPEN_SOURCE 500
+#define _GNU_SOURCE 1
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <dirent.h>
+#include "kerncompat.h"
+#include "ctree.h"
+#include "disk-io.h"
+#include "transaction.h"
+#include "utils.h"
+#include "version.h"
+
+static char *device;
+
+int update_seeding_flag(struct btrfs_root *root, int set_flag)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_super_block *disk_super;
+	u64 super_flags;
+
+	disk_super = &root->fs_info->super_copy;
+	super_flags = btrfs_super_flags(disk_super);
+	if (set_flag) {
+		if (super_flags & BTRFS_SUPER_FLAG_SEEDING) {
+			fprintf(stderr, "seeding flag is already set on %s\n",
+				device);
+			return 1;
+		}
+		super_flags |= BTRFS_SUPER_FLAG_SEEDING;
+	} else {
+		if (!(super_flags & BTRFS_SUPER_FLAG_SEEDING)) {
+			fprintf(stderr, "seeding flag is not set on %s\n",
+				device);
+			return 1;
+		}
+		super_flags &= ~BTRFS_SUPER_FLAG_SEEDING;
+	}
+
+	trans = btrfs_start_transaction(root, 1);
+	btrfs_set_super_flags(disk_super, super_flags);
+	btrfs_commit_transaction(trans, root);
+
+	return 0;
+}
+
+static void print_usage(void)
+{
+	fprintf(stderr, "usage: btrfstune [options] device\n");
+	fprintf(stderr, "\t-S value\tenable/disable seeding\n");
+}
+
+int main(int argc, char *argv[])
+{
+	struct btrfs_root *root;
+	int success = 0;
+	int seeding_flag = 0;
+	int seeding_value = 0;
+	int ret;
+
+	while(1) {
+		int c = getopt(argc, argv, "S:");
+		if (c < 0)
+			break;
+		switch(c) {
+		case 'S':
+			seeding_flag = 1;
+			seeding_value = atoi(optarg);
+			break;
+		default:
+			print_usage();
+			return 1;
+		}
+	}
+
+	argc = argc - optind;
+	device = argv[optind];
+	if (argc != 1) {
+		print_usage();
+		return 1;
+	}
+
+	if (check_mounted(device)) {
+		fprintf(stderr, "%s is mounted\n", device);
+		return 1;
+	}
+
+	root = open_ctree(device, 0, 1);
+
+	if (seeding_flag) {
+		ret = update_seeding_flag(root, seeding_value);
+		if (!ret)
+			success++;
+	}
+
+	if (success > 0) {
+		ret = 0;
+	} else {
+		root->fs_info->readonly = 1;
+		ret = 1;
+	}
+	close_ctree(root);
+
+	return ret;
+}
diff -urpN btrfs-progs-orig/ctree.c btrfs-progs-2/ctree.c
--- btrfs-progs-orig/ctree.c	2008-10-10 04:21:07.000000000 +0800
+++ btrfs-progs-2/ctree.c	2008-11-11 11:11:11.000000000 +0800
@@ -111,6 +111,10 @@ int btrfs_copy_root(struct btrfs_trans_h
 	btrfs_set_header_generation(cow, trans->transid);
 	btrfs_set_header_owner(cow, new_root_objectid);
 	btrfs_clear_header_flag(cow, BTRFS_HEADER_FLAG_WRITTEN);
+	
+	write_extent_buffer(cow, root->fs_info->fsid,
+			    (unsigned long)btrfs_header_fsid(cow),
+			    BTRFS_FSID_SIZE);
 
 	WARN_ON(btrfs_header_generation(buf) > trans->transid);
 	ret = btrfs_inc_ref(trans, new_root, buf, cow, NULL);
@@ -161,6 +165,10 @@ int __btrfs_cow_block(struct btrfs_trans
 	btrfs_set_header_owner(cow, root->root_key.objectid);
 	btrfs_clear_header_flag(cow, BTRFS_HEADER_FLAG_WRITTEN);
 
+	write_extent_buffer(cow, root->fs_info->fsid,
+			    (unsigned long)btrfs_header_fsid(cow),
+			    BTRFS_FSID_SIZE);
+
 	WARN_ON(btrfs_header_generation(buf) > trans->transid);
 	if (btrfs_header_generation(buf) != trans->transid) {
 		different_trans = 1;
diff -urpN btrfs-progs-orig/ctree.h btrfs-progs-2/ctree.h
--- btrfs-progs-orig/ctree.h	2008-11-01 01:04:01.000000000 +0800
+++ btrfs-progs-2/ctree.h	2008-11-09 21:41:42.000000000 +0800
@@ -160,6 +160,9 @@ struct btrfs_dev_item {
 	/* type and info about this device */
 	__le64 type;
 
+	/* expected generation for this device */
+	__le64 generation;
+
 	/* grouping information for allocation decisions */
 	__le32 dev_group;
 
@@ -171,6 +174,9 @@ struct btrfs_dev_item {
 
 	/* btrfs generated uuid for this device */
 	u8 uuid[BTRFS_UUID_SIZE];
+
+	/* uuid of FS who owns this device */
+	u8 fsid[BTRFS_UUID_SIZE];
 } __attribute__ ((__packed__));
 
 struct btrfs_stripe {
@@ -246,6 +252,8 @@ struct btrfs_header {
 					sizeof(struct btrfs_item) - \
 					sizeof(struct btrfs_file_extent_item))
 
+#define BTRFS_SUPER_FLAG_SEEDING (1ULL << 32)
+
 /*
  * this is a very generous portion of the super block, giving us
  * room to translate 14 chunks with 3 stripes each.
@@ -524,6 +532,7 @@ struct btrfs_block_group_cache {
 	u64 pinned;
 	u64 flags;
 	int cached;
+	int ro;
 };
 
 struct btrfs_extent_ops {
@@ -744,6 +753,7 @@ BTRFS_SETGET_FUNCS(device_id, struct btr
 BTRFS_SETGET_FUNCS(device_group, struct btrfs_dev_item, dev_group, 32);
 BTRFS_SETGET_FUNCS(device_seek_speed, struct btrfs_dev_item, seek_speed, 8);
 BTRFS_SETGET_FUNCS(device_bandwidth, struct btrfs_dev_item, bandwidth, 8);
+BTRFS_SETGET_FUNCS(device_generation, struct btrfs_dev_item, generation, 64);
 
 BTRFS_SETGET_STACK_FUNCS(stack_device_type, struct btrfs_dev_item, type, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_device_total_bytes, struct btrfs_dev_item,
@@ -763,12 +773,19 @@ BTRFS_SETGET_STACK_FUNCS(stack_device_se
 			 seek_speed, 8);
 BTRFS_SETGET_STACK_FUNCS(stack_device_bandwidth, struct btrfs_dev_item,
 			 bandwidth, 8);
+BTRFS_SETGET_STACK_FUNCS(stack_device_generation, struct btrfs_dev_item,
+			 generation, 64);
 
 static inline char *btrfs_device_uuid(struct btrfs_dev_item *d)
 {
 	return (char *)d + offsetof(struct btrfs_dev_item, uuid);
 }
 
+static inline char *btrfs_device_fsid(struct btrfs_dev_item *d)
+{
+	return (char *)d + offsetof(struct btrfs_dev_item, fsid);
+}
+
 BTRFS_SETGET_FUNCS(chunk_length, struct btrfs_chunk, length, 64);
 BTRFS_SETGET_FUNCS(chunk_owner, struct btrfs_chunk, owner, 64);
 BTRFS_SETGET_FUNCS(chunk_stripe_len, struct btrfs_chunk, stripe_len, 64);
@@ -1259,6 +1276,7 @@ BTRFS_SETGET_STACK_FUNCS(root_last_snaps
 
 /* struct btrfs_super_block */
 BTRFS_SETGET_STACK_FUNCS(super_bytenr, struct btrfs_super_block, bytenr, 64);
+BTRFS_SETGET_STACK_FUNCS(super_flags, struct btrfs_super_block, flags, 64);
 BTRFS_SETGET_STACK_FUNCS(super_generation, struct btrfs_super_block,
 			 generation, 64);
 BTRFS_SETGET_STACK_FUNCS(super_root, struct btrfs_super_block, root, 64);
diff -urpN btrfs-progs-orig/disk-io.c btrfs-progs-2/disk-io.c
--- btrfs-progs-orig/disk-io.c	2008-10-31 00:09:19.000000000 +0800
+++ btrfs-progs-2/disk-io.c	2008-11-07 17:23:00.000000000 +0800
@@ -37,14 +37,24 @@
 
 static int check_tree_block(struct btrfs_root *root, struct extent_buffer *buf)
 {
+
+	struct btrfs_fs_devices *fs_devices;
+	int ret = 1;
+
 	if (buf->start != btrfs_header_bytenr(buf))
-		return 1;
+		return ret;
 
-	if (memcmp_extent_buffer(buf, root->fs_info->fsid,
-				 (unsigned long)btrfs_header_fsid(buf),
-				 BTRFS_FSID_SIZE))
-		return 1;
-	return 0;
+	fs_devices = root->fs_info->fs_devices;
+	while (fs_devices) {
+		if (!memcmp_extent_buffer(buf, fs_devices->fsid,
+					  (unsigned long)btrfs_header_fsid(buf),
+					  BTRFS_FSID_SIZE)) {
+			ret = 0;
+			break;
+		}
+		fs_devices = fs_devices->seed;
+	}
+	return ret;
 }
 
 u32 btrfs_csum_data(struct btrfs_root *root, char *data, u32 seed, size_t len)
@@ -685,6 +695,10 @@ int write_all_supers(struct btrfs_root *
 						      dev_item);
 	list_for_each(cur, head) {
 		dev = list_entry(cur, struct btrfs_device, dev_list);
+		if (!dev->writeable)
+			continue;
+
+		btrfs_set_device_generation(sb, dev_item, 0);
 		btrfs_set_device_type(sb, dev_item, dev->type);
 		btrfs_set_device_id(sb, dev_item, dev->devid);
 		btrfs_set_device_total_bytes(sb, dev_item, dev->total_bytes);
@@ -695,6 +709,9 @@ int write_all_supers(struct btrfs_root *
 		write_extent_buffer(sb, dev->uuid,
 				    (unsigned long)btrfs_device_uuid(dev_item),
 				    BTRFS_UUID_SIZE);
+		write_extent_buffer(sb, dev->fs_devices->fsid,
+				    (unsigned long)btrfs_device_fsid(dev_item),
+				    BTRFS_UUID_SIZE);
 		sb->fd = dev->fd;
 		sb->dev_bytenr = sb->start;
 		btrfs_set_header_flag(sb, BTRFS_HEADER_FLAG_WRITTEN);
diff -urpN btrfs-progs-orig/extent-tree.c btrfs-progs-2/extent-tree.c
--- btrfs-progs-orig/extent-tree.c	2008-10-10 04:21:07.000000000 +0800
+++ btrfs-progs-2/extent-tree.c	2008-11-07 11:12:54.000000000 +0800
@@ -159,6 +159,35 @@ err:
 	return 0;
 }
 
+struct btrfs_block_group_cache *btrfs_lookup_first_block_group(struct
+						       btrfs_fs_info *info,
+						       u64 bytenr)
+{
+	struct extent_io_tree *block_group_cache;
+	struct btrfs_block_group_cache *block_group = NULL;
+	u64 ptr;
+	u64 start;
+	u64 end;
+	int ret;
+
+	bytenr = max_t(u64, bytenr,
+		       BTRFS_SUPER_INFO_OFFSET + BTRFS_SUPER_INFO_SIZE);
+	block_group_cache = &info->block_group_cache;
+	ret = find_first_extent_bit(block_group_cache,
+				    bytenr, &start, &end,
+				    BLOCK_GROUP_DATA | BLOCK_GROUP_METADATA |
+				    BLOCK_GROUP_SYSTEM);
+	if (ret) {
+		return NULL;
+	}
+	ret = get_state_private(block_group_cache, start, &ptr);
+	if (ret)
+		return NULL;
+
+	block_group = (struct btrfs_block_group_cache *)(unsigned long)ptr;
+	return block_group;
+}
+
 struct btrfs_block_group_cache *btrfs_lookup_block_group(struct
 							 btrfs_fs_info *info,
 							 u64 bytenr)
@@ -203,7 +232,6 @@ static int noinline find_search_start(st
 	u64 last;
 	u64 start = 0;
 	u64 end = 0;
-	u64 cache_miss = 0;
 	u64 search_start = *start_ret;
 	int wrapped = 0;
 
@@ -216,7 +244,7 @@ again:
 		goto out;
 
 	last = max(search_start, cache->key.objectid);
-	if (!block_group_bits(cache, data)) {
+	if (cache->ro || !block_group_bits(cache, data)) {
 		goto new_group;
 	}
 
@@ -224,20 +252,17 @@ again:
 		ret = find_first_extent_bit(&root->fs_info->free_space_cache,
 					    last, &start, &end, EXTENT_DIRTY);
 		if (ret) {
-			if (!cache_miss)
-				cache_miss = last;
 			goto new_group;
 		}
 
 		start = max(last, start);
 		last = end + 1;
 		if (last - start < num) {
-			if (last == cache->key.objectid + cache->key.offset)
-				cache_miss = start;
 			continue;
 		}
-		if (start + num > cache->key.objectid + cache->key.offset)
+		if (start + num > cache->key.objectid + cache->key.offset) {
 			goto new_group;
+		}
 		*start_ret = start;
 		return 0;
 	}
@@ -253,7 +278,7 @@ out:
 new_group:
 	last = cache->key.objectid + cache->key.offset;
 wrapped:
-	cache = btrfs_lookup_block_group(root->fs_info, last);
+	cache = btrfs_lookup_first_block_group(root->fs_info, last);
 	if (!cache) {
 no_cache:
 		if (!wrapped) {
@@ -263,16 +288,12 @@ no_cache:
 		}
 		goto out;
 	}
-	if (cache_miss && !cache->cached) {
-		cache_block_group(root, cache);
-		last = cache_miss;
-		cache = btrfs_lookup_block_group(root->fs_info, last);
-	}
+	cache = btrfs_find_block_group(root, cache, last, data, 0);
 	cache = btrfs_find_block_group(root, cache, last, data, 0);
 	if (!cache)
 		goto no_cache;
+
 	*cache_ret = cache;
-	cache_miss = 0;
 	goto again;
 }
 
@@ -328,7 +349,7 @@ struct btrfs_block_group_cache *btrfs_fi
 	if (search_start) {
 		struct btrfs_block_group_cache *shint;
 		shint = btrfs_lookup_block_group(info, search_start);
-		if (shint && block_group_bits(shint, data)) {
+		if (shint && !shint->ro && block_group_bits(shint, data)) {
 			used = btrfs_block_group_used(&shint->item);
 			if (used + shint->pinned <
 			    div_factor(shint->key.offset, factor)) {
@@ -336,7 +357,7 @@ struct btrfs_block_group_cache *btrfs_fi
 			}
 		}
 	}
-	if (hint && block_group_bits(hint, data)) {
+	if (hint && !hint->ro && block_group_bits(hint, data)) {
 		used = btrfs_block_group_used(&hint->item);
 		if (used + hint->pinned <
 		    div_factor(hint->key.offset, factor)) {
@@ -367,7 +388,7 @@ again:
 		last = cache->key.objectid + cache->key.offset;
 		used = btrfs_block_group_used(&cache->item);
 
-		if (block_group_bits(cache, data)) {
+		if (!cache->ro && block_group_bits(cache, data)) {
 			if (full_search)
 				free_check = cache->key.offset;
 			else
@@ -1705,11 +1726,8 @@ static int noinline find_free_extent(str
 	WARN_ON(num_bytes < root->sectorsize);
 	btrfs_set_key_type(ins, BTRFS_EXTENT_ITEM_KEY);
 
-	if (search_end == (u64)-1)
-		search_end = btrfs_super_total_bytes(&info->super_copy);
-
 	if (hint_byte) {
-		block_group = btrfs_lookup_block_group(info, hint_byte);
+		block_group = btrfs_lookup_first_block_group(info, hint_byte);
 		if (!block_group)
 			hint_byte = search_start;
 		block_group = btrfs_find_block_group(root, block_group,
@@ -1724,9 +1742,10 @@ static int noinline find_free_extent(str
 
 check_failed:
 	if (!block_group) {
-		block_group = btrfs_lookup_block_group(info, search_start);
+		block_group = btrfs_lookup_first_block_group(info,
+							     search_start);
 		if (!block_group)
-			block_group = btrfs_lookup_block_group(info,
+			block_group = btrfs_lookup_first_block_group(info,
 						       orig_search_start);
 	}
 	ret = find_search_start(root, &block_group, &search_start,
@@ -1738,9 +1757,6 @@ check_failed:
 	ins->objectid = search_start;
 	ins->offset = num_bytes;
 
-	if (ins->objectid + num_bytes >= search_end)
-		goto enospc;
-
 	if (ins->objectid + num_bytes >
 	    block_group->key.objectid + block_group->key.offset) {
 		search_start = block_group->key.objectid +
@@ -1775,8 +1791,8 @@ check_failed:
 	return 0;
 
 new_group:
-	if (search_start + num_bytes >= search_end) {
-enospc:
+	block_group = btrfs_lookup_first_block_group(info, search_start);
+	if (!block_group) {
 		search_start = orig_search_start;
 		if (full_scan) {
 			ret = -ENOSPC;
@@ -1789,7 +1805,6 @@ enospc:
 		} else
 			wrapped = 1;
 	}
-	block_group = btrfs_lookup_block_group(info, search_start);
 	cond_resched();
 	block_group = btrfs_find_block_group(root, block_group,
 					     search_start, data, 0);
@@ -2414,7 +2429,7 @@ int btrfs_read_block_groups(struct btrfs
 		}
 		leaf = path->nodes[0];
 		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
-		cache = kmalloc(sizeof(*cache), GFP_NOFS);
+		cache = kzalloc(sizeof(*cache), GFP_NOFS);
 		if (!cache) {
 			ret = -ENOMEM;
 			break;
@@ -2438,6 +2453,8 @@ int btrfs_read_block_groups(struct btrfs
 			bit = BLOCK_GROUP_METADATA;
 		}
 		set_avail_alloc_bits(info, cache->flags);
+		if (btrfs_chunk_readonly(root, cache->key.objectid))
+			cache->ro = 1;
 
 		ret = update_space_info(info, cache->flags, found_key.offset,
 					btrfs_block_group_used(&cache->item),
@@ -2451,10 +2468,6 @@ int btrfs_read_block_groups(struct btrfs
 				bit | EXTENT_LOCKED, GFP_NOFS);
 		set_state_private(block_group_cache, found_key.objectid,
 				  (unsigned long)cache);
-
-		if (key.objectid >=
-		    btrfs_super_total_bytes(&info->super_copy))
-			break;
 	}
 	ret = 0;
 error:
diff -urpN btrfs-progs-orig/Makefile btrfs-progs-2/Makefile
--- btrfs-progs-orig/Makefile	2008-09-30 16:50:58.000000000 +0800
+++ btrfs-progs-2/Makefile	2008-11-07 11:05:31.000000000 +0800
@@ -15,7 +15,7 @@ prefix ?= /usr/local
 bindir = $(prefix)/bin
 LIBS=-luuid
 
-progs = btrfsctl btrfsck mkfs.btrfs debug-tree btrfs-show btrfs-vol
+progs = btrfsctl btrfsck mkfs.btrfs debug-tree btrfs-show btrfs-vol btrfstune
 
 # make C=1 to enable sparse
 ifdef C
@@ -52,6 +52,9 @@ mkfs.btrfs: $(objects) mkfs.o
 debug-tree: $(objects) debug-tree.o
 	gcc $(CFLAGS) -o debug-tree $(objects) debug-tree.o $(LDFLAGS) $(LIBS)
 
+btrfstune: $(objects) btrfstune.o
+	gcc $(CFLAGS) -o btrfstune $(objects) btrfstune.o $(LDFLAGS) $(LIBS)
+
 dir-test: $(objects) dir-test.o
 	gcc $(CFLAGS) -o dir-test $(objects) dir-test.o $(LDFLAGS) $(LIBS)
 
diff -urpN btrfs-progs-orig/utils.c btrfs-progs-2/utils.c
--- btrfs-progs-orig/utils.c	2008-10-30 07:21:15.000000000 +0800
+++ btrfs-progs-2/utils.c	2008-11-08 10:58:43.000000000 +0800
@@ -96,7 +96,7 @@ int make_btrfs(int fd, const char *devic
 	btrfs_set_super_root(&super, blocks[1]);
 	btrfs_set_super_chunk_root(&super, blocks[3]);
 	btrfs_set_super_total_bytes(&super, num_bytes);
-	btrfs_set_super_bytes_used(&super, first_free + 5 * leafsize);
+	btrfs_set_super_bytes_used(&super, 5 * leafsize);
 	btrfs_set_super_sectorsize(&super, sectorsize);
 	btrfs_set_super_leafsize(&super, leafsize);
 	btrfs_set_super_nodesize(&super, nodesize);
@@ -252,6 +252,7 @@ int make_btrfs(int fd, const char *devic
 
 	dev_item = btrfs_item_ptr(buf, nritems, struct btrfs_dev_item);
 	btrfs_set_device_id(buf, dev_item, 1);
+	btrfs_set_device_generation(buf, dev_item, 0);
 	btrfs_set_device_total_bytes(buf, dev_item, num_bytes);
 	btrfs_set_device_bytes_used(buf, dev_item,
 				    BTRFS_MKFS_SYSTEM_GROUP_SIZE);
@@ -263,6 +264,9 @@ int make_btrfs(int fd, const char *devic
 	write_extent_buffer(buf, super.dev_item.uuid,
 			    (unsigned long)btrfs_device_uuid(dev_item),
 			    BTRFS_UUID_SIZE);
+	write_extent_buffer(buf, super.fsid,
+			    (unsigned long)btrfs_device_fsid(dev_item),
+			    BTRFS_UUID_SIZE);
 	read_extent_buffer(buf, &super.dev_item, (unsigned long)dev_item,
 			   sizeof(*dev_item));
 
@@ -456,6 +460,7 @@ int btrfs_add_to_fsid(struct btrfs_trans
 	device->io_align = io_align;
 	device->sector_size = sectorsize;
 	device->fd = fd;
+	device->writeable = 1;
 	device->total_bytes = block_count;
 	device->bytes_used = 0;
 	device->total_ios = 0;
@@ -489,6 +494,7 @@ int btrfs_add_to_fsid(struct btrfs_trans
 
 	kfree(buf);
 	list_add(&device->dev_list, &root->fs_info->fs_devices->devices);
+	device->fs_devices = root->fs_info->fs_devices;
 	ret = btrfs_bootstrap_super_map(&root->fs_info->mapping_tree,
 					root->fs_info->fs_devices);
 	BUG_ON(ret);
diff -urpN btrfs-progs-orig/volumes.c btrfs-progs-2/volumes.c
--- btrfs-progs-orig/volumes.c	2008-09-30 16:50:58.000000000 +0800
+++ btrfs-progs-2/volumes.c	2008-11-09 21:42:32.000000000 +0800
@@ -91,7 +91,7 @@ static int device_list_add(const char *p
 
 	fs_devices = find_fsid(disk_super->fsid);
 	if (!fs_devices) {
-		fs_devices = kmalloc(sizeof(*fs_devices), GFP_NOFS);
+		fs_devices = kzalloc(sizeof(*fs_devices), GFP_NOFS);
 		if (!fs_devices)
 			return -ENOMEM;
 		INIT_LIST_HEAD(&fs_devices->devices);
@@ -127,6 +127,7 @@ static int device_list_add(const char *p
 		device->bytes_used =
 			btrfs_stack_device_bytes_used(&disk_super->dev_item);
 		list_add(&device->dev_list, &fs_devices->devices);
+		device->fs_devices = fs_devices;
 	}
 
 	if (found_transid > fs_devices->latest_trans) {
@@ -142,15 +143,24 @@ static int device_list_add(const char *p
 
 int btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 {
-	struct list_head *head = &fs_devices->devices;
+	struct btrfs_fs_devices *seed_devices;
 	struct list_head *cur;
 	struct btrfs_device *device;
-
-	list_for_each(cur, head) {
+again:
+	list_for_each(cur, &fs_devices->devices) {
 		device = list_entry(cur, struct btrfs_device, dev_list);
 		close(device->fd);
 		device->fd = -1;
+		device->writeable = 0;
 	}
+
+	seed_devices = fs_devices->seed;
+	fs_devices->seed = NULL;
+	if (seed_devices) {
+		fs_devices = seed_devices;
+		goto again;
+	}
+
 	return 0;
 }
 
@@ -176,6 +186,8 @@ int btrfs_open_devices(struct btrfs_fs_d
 		if (device->devid == fs_devices->lowest_devid)
 			fs_devices->lowest_bdev = fd;
 		device->fd = fd;
+		if (flags == O_RDWR)
+			device->writeable = 1;
 	}
 	return 0;
 fail:
@@ -504,6 +516,7 @@ int btrfs_add_device(struct btrfs_trans_
 
 	device->devid = free_devid;
 	btrfs_set_device_id(leaf, dev_item, device->devid);
+	btrfs_set_device_generation(leaf, dev_item, 0);
 	btrfs_set_device_type(leaf, dev_item, device->type);
 	btrfs_set_device_io_align(leaf, dev_item, device->io_align);
 	btrfs_set_device_io_width(leaf, dev_item, device->io_width);
@@ -516,6 +529,8 @@ int btrfs_add_device(struct btrfs_trans_
 
 	ptr = (unsigned long)btrfs_device_uuid(dev_item);
 	write_extent_buffer(leaf, device->uuid, ptr, BTRFS_UUID_SIZE);
+	ptr = (unsigned long)btrfs_device_fsid(dev_item);
+	write_extent_buffer(leaf, root->fs_info->fsid, ptr, BTRFS_UUID_SIZE);
 	btrfs_mark_buffer_dirty(leaf);
 	ret = 0;
 
@@ -996,11 +1011,23 @@ out:
 }
 
 struct btrfs_device *btrfs_find_device(struct btrfs_root *root, u64 devid,
-				       u8 *uuid)
+				       u8 *uuid, u8 *fsid)
 {
-	struct list_head *head = &root->fs_info->fs_devices->devices;
-
-	return __find_device(head, devid, uuid);
+	struct btrfs_device *device;
+	struct btrfs_fs_devices *cur_devices;
+       
+	cur_devices = root->fs_info->fs_devices;
+	while (cur_devices) {
+		if (!fsid ||
+		    !memcmp(cur_devices->fsid, fsid, BTRFS_UUID_SIZE)) {
+			device = __find_device(&cur_devices->devices,
+					       devid, uuid);
+			if (device)
+				return device;
+		}
+		cur_devices = cur_devices->seed;
+	}
+	return NULL;
 }
 
 int btrfs_bootstrap_super_map(struct btrfs_mapping_tree *map_tree,
@@ -1056,6 +1083,28 @@ int btrfs_bootstrap_super_map(struct btr
 	return 0;
 }
 
+int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset)
+{
+	struct cache_extent *ce;
+	struct map_lookup *map;
+	struct btrfs_mapping_tree *map_tree = &root->fs_info->mapping_tree;
+	int readonly = 0;
+	int i;
+
+	ce = find_first_cache_extent(&map_tree->cache_tree, chunk_offset);
+	BUG_ON(!ce);
+
+	map = container_of(ce, struct map_lookup, ce);
+	for (i = 0; i < map->num_stripes; i++) {
+		if (!map->stripes[i].dev->writeable) {
+			readonly = 1;
+			break;
+		}
+	}
+
+	return readonly;
+}
+
 static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 			  struct extent_buffer *leaf,
 			  struct btrfs_chunk *chunk)
@@ -1111,7 +1160,8 @@ static int read_one_chunk(struct btrfs_r
 		read_extent_buffer(leaf, uuid, (unsigned long)
 				   btrfs_stripe_dev_uuid_nr(chunk, i),
 				   BTRFS_UUID_SIZE);
-		map->stripes[i].dev = btrfs_find_device(root, devid, uuid);
+		map->stripes[i].dev = btrfs_find_device(root, devid, uuid,
+							NULL);
 		if (!map->stripes[i].dev) {
 			kfree(map);
 			return -EIO;
@@ -1144,6 +1194,36 @@ static int fill_device_from_item(struct 
 	return 0;
 }
 
+static int open_seed_devices(struct btrfs_root *root, u8 *fsid)
+{
+	struct btrfs_fs_devices *fs_devices;
+	int ret;
+
+	fs_devices = root->fs_info->fs_devices->seed;
+	while (fs_devices) {
+		if (!memcmp(fs_devices->fsid, fsid, BTRFS_UUID_SIZE)) {
+			ret = 0;
+			goto out;
+		}
+		fs_devices = fs_devices->seed;
+	}
+
+	fs_devices = find_fsid(fsid);
+	if (!fs_devices) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	ret = btrfs_open_devices(fs_devices, O_RDONLY);
+	if (ret)
+		goto out;
+
+	fs_devices->seed = root->fs_info->fs_devices->seed;
+	root->fs_info->fs_devices->seed = fs_devices;
+out:
+	return ret;
+}
+
 static int read_one_dev(struct btrfs_root *root,
 			struct extent_buffer *leaf,
 			struct btrfs_dev_item *dev_item)
@@ -1151,13 +1231,24 @@ static int read_one_dev(struct btrfs_roo
 	struct btrfs_device *device;
 	u64 devid;
 	int ret = 0;
+	u8 fs_uuid[BTRFS_UUID_SIZE];
 	u8 dev_uuid[BTRFS_UUID_SIZE];
 
 	devid = btrfs_device_id(leaf, dev_item);
 	read_extent_buffer(leaf, dev_uuid,
 			   (unsigned long)btrfs_device_uuid(dev_item),
 			   BTRFS_UUID_SIZE);
-	device = btrfs_find_device(root, devid, dev_uuid);
+	read_extent_buffer(leaf, fs_uuid,
+			   (unsigned long)btrfs_device_fsid(dev_item),
+			   BTRFS_UUID_SIZE);
+
+	if (memcmp(fs_uuid, root->fs_info->fsid, BTRFS_UUID_SIZE)) {
+		ret = open_seed_devices(root, fs_uuid);
+		if (ret)
+			return ret;
+	}
+
+	device = btrfs_find_device(root, devid, dev_uuid, fs_uuid);
 	if (!device) {
 		printk("warning devid %llu not found already\n",
 			(unsigned long long)devid);
@@ -1284,6 +1375,7 @@ again:
 			struct btrfs_chunk *chunk;
 			chunk = btrfs_item_ptr(leaf, slot, struct btrfs_chunk);
 			ret = read_one_chunk(root, &found_key, leaf, chunk);
+			BUG_ON(ret);
 		}
 		path->slots[0]++;
 	}
diff -urpN btrfs-progs-orig/volumes.h btrfs-progs-2/volumes.h
--- btrfs-progs-orig/volumes.h	2008-09-30 16:50:58.000000000 +0800
+++ btrfs-progs-2/volumes.h	2008-11-07 11:05:33.000000000 +0800
@@ -21,11 +21,14 @@
 struct btrfs_device {
 	struct list_head dev_list;
 	struct btrfs_root *dev_root;
+	struct btrfs_fs_devices *fs_devices;
 
 	u64 total_ios;
 
 	int fd;
 
+	int writeable;
+
 	char *name;
 
 	/* these are read off the super block, only in the progs */
@@ -69,6 +72,9 @@ struct btrfs_fs_devices {
 	int lowest_bdev;
 	struct list_head devices;
 	struct list_head list;
+
+	int seeding;
+	struct btrfs_fs_devices *seed;
 };
 
 struct btrfs_bio_stripe {
@@ -120,4 +126,5 @@ struct list_head *btrfs_scanned_uuids(vo
 int btrfs_add_system_chunk(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, struct btrfs_key *key,
 			   struct btrfs_chunk *chunk, int item_size);
+int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
 #endif
