Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33368 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbbIATW4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Sep 2015 15:22:56 -0400
Received: by pary6 with SMTP id y6so129770par.0
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Sep 2015 12:22:55 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: Omar Sandoval <osandov@fb.com>
Subject: [PATCH 3/3] btrfs-progs: check the free space tree in btrfsck
Date: Tue,  1 Sep 2015 12:22:46 -0700
Message-Id: <dce5631bcb5fab7ce6af2bed6385ca395860b7cc.1441133868.git.osandov@osandov.com>
In-Reply-To: <e9100a40e112cfa0cd6228594893337a8c9444b9.1441133868.git.osandov@osandov.com>
References: <cover.1441131625.git.osandov@fb.com>
 <e9100a40e112cfa0cd6228594893337a8c9444b9.1441133868.git.osandov@osandov.com>
In-Reply-To: <e9100a40e112cfa0cd6228594893337a8c9444b9.1441133868.git.osandov@osandov.com>
References: <e9100a40e112cfa0cd6228594893337a8c9444b9.1441133868.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

This reuses the existing code for checking the free space cache, we just
need to load the free space tree. While we do that, we check a couple of
invariants on the free space tree itself.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 Makefile.in        |   2 +-
 cmds-check.c       |  24 ++++-
 extent_io.c        |   6 ++
 extent_io.h        |   2 +
 free-space-cache.c |   4 +-
 free-space-cache.h |   2 +
 free-space-tree.c  | 277 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 free-space-tree.h  |  25 +++++
 8 files changed, 335 insertions(+), 7 deletions(-)
 create mode 100644 free-space-tree.c
 create mode 100644 free-space-tree.h

diff --git a/Makefile.in b/Makefile.in
index 665f83c04d00..cac9a269ee8f 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -38,7 +38,7 @@ objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  extent-cache.o extent_io.o volumes.o utils.o repair.o \
 	  qgroup.o raid6.o free-space-cache.o list_sort.o props.o \
 	  ulist.o qgroup-verify.o backref.o string-table.o task-utils.o \
-	  inode.o file.o find-root.o
+	  inode.o file.o find-root.o free-space-tree.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
diff --git a/cmds-check.c b/cmds-check.c
index 0694a3bc5646..2a3910c254a4 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -34,6 +34,7 @@
 #include "utils.h"
 #include "commands.h"
 #include "free-space-cache.h"
+#include "free-space-tree.h"
 #include "btrfsck.h"
 #include "qgroup-verify.h"
 #include "rbtree-utils.h"
@@ -5285,9 +5286,21 @@ static int check_space_cache(struct btrfs_root *root)
 			btrfs_remove_free_space_cache(cache);
 		}
 
-		ret = load_free_space_cache(root->fs_info, cache);
-		if (!ret)
-			continue;
+		if (btrfs_fs_compat_ro(root->fs_info,
+				       BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE)) {
+			ret = load_free_space_tree(root->fs_info, cache);
+			if (ret < 0) {
+				fprintf(stderr, "could not load free space tree: %s\n",
+					strerror(-ret));
+				error++;
+				continue;
+			}
+			error += ret;
+		} else {
+			ret = load_free_space_cache(root->fs_info, cache);
+			if (!ret)
+				continue;
+		}
 
 		ret = verify_space_cache(root, cache);
 		if (ret) {
@@ -9495,7 +9508,10 @@ int cmd_check(int argc, char **argv)
 		goto close_out;
 	}
 
-	fprintf(stderr, "checking free space cache\n");
+	if (btrfs_fs_compat_ro(info, BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE))
+		fprintf(stderr, "checking free space tree\n");
+	else
+		fprintf(stderr, "checking free space cache\n");
 	ret = check_space_cache(root);
 	if (ret)
 		goto out;
diff --git a/extent_io.c b/extent_io.c
index 07695ef8a097..079ab7f2fb7d 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -885,3 +885,9 @@ void memset_extent_buffer(struct extent_buffer *eb, char c,
 {
 	memset(eb->data + start, c, len);
 }
+
+int extent_buffer_test_bit(struct extent_buffer *eb, unsigned long start,
+			   unsigned long nr)
+{
+	return test_bit(nr, (unsigned long *)(eb->data + start));
+}
diff --git a/extent_io.h b/extent_io.h
index 27c4b6931c97..a9a7353556a7 100644
--- a/extent_io.h
+++ b/extent_io.h
@@ -148,6 +148,8 @@ void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 			   unsigned long src_offset, unsigned long len);
 void memset_extent_buffer(struct extent_buffer *eb, char c,
 			  unsigned long start, unsigned long len);
+int extent_buffer_test_bit(struct extent_buffer *eb, unsigned long start,
+			   unsigned long nr);
 int set_extent_buffer_dirty(struct extent_buffer *eb);
 int clear_extent_buffer_dirty(struct extent_buffer *eb);
 int read_data_from_disk(struct btrfs_fs_info *info, void *buf, u64 offset,
diff --git a/free-space-cache.c b/free-space-cache.c
index 19ab0c904a71..d10a5f517b10 100644
--- a/free-space-cache.c
+++ b/free-space-cache.c
@@ -802,8 +802,8 @@ void btrfs_remove_free_space_cache(struct btrfs_block_group_cache *block_group)
 	__btrfs_remove_free_space_cache(block_group->free_space_ctl);
 }
 
-static int btrfs_add_free_space(struct btrfs_free_space_ctl *ctl, u64 offset,
-				u64 bytes)
+int btrfs_add_free_space(struct btrfs_free_space_ctl *ctl, u64 offset,
+			 u64 bytes)
 {
 	struct btrfs_free_space *info;
 	int ret = 0;
diff --git a/free-space-cache.h b/free-space-cache.h
index 85411a10e64b..9214077a1b27 100644
--- a/free-space-cache.h
+++ b/free-space-cache.h
@@ -57,4 +57,6 @@ int btrfs_init_free_space_ctl(struct btrfs_block_group_cache *block_group,
 			      int sectorsize);
 void unlink_free_space(struct btrfs_free_space_ctl *ctl,
 		       struct btrfs_free_space *info);
+int btrfs_add_free_space(struct btrfs_free_space_ctl *ctl, u64 offset,
+			 u64 bytes);
 #endif
diff --git a/free-space-tree.c b/free-space-tree.c
new file mode 100644
index 000000000000..527af6e5f2a0
--- /dev/null
+++ b/free-space-tree.c
@@ -0,0 +1,277 @@
+/*
+ * Copyright (C) 2015 Facebook.  All rights reserved.
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
+#include "ctree.h"
+#include "disk-io.h"
+#include "free-space-cache.h"
+#include "free-space-tree.h"
+
+static struct btrfs_free_space_info *
+search_free_space_info(struct btrfs_trans_handle *trans,
+		       struct btrfs_fs_info *fs_info,
+		       struct btrfs_block_group_cache *block_group,
+		       struct btrfs_path *path, int cow)
+{
+	struct btrfs_root *root = fs_info->free_space_root;
+	struct btrfs_key key;
+	int ret;
+
+	key.objectid = block_group->key.objectid;
+	key.type = BTRFS_FREE_SPACE_INFO_KEY;
+	key.offset = block_group->key.offset;
+
+	ret = btrfs_search_slot(trans, root, &key, path, 0, cow);
+	if (ret < 0)
+		return ERR_PTR(ret);
+	if (ret != 0)
+		return ERR_PTR(-ENOENT);
+
+	return btrfs_item_ptr(path->nodes[0], path->slots[0],
+			      struct btrfs_free_space_info);
+}
+
+static int free_space_test_bit(struct btrfs_block_group_cache *block_group,
+			       struct btrfs_path *path, u64 offset,
+			       u64 sectorsize)
+{
+	struct extent_buffer *leaf;
+	struct btrfs_key key;
+	u64 found_start, found_end;
+	unsigned long ptr, i;
+
+	leaf = path->nodes[0];
+	btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+	ASSERT(key.type == BTRFS_FREE_SPACE_BITMAP_KEY);
+
+	found_start = key.objectid;
+	found_end = key.objectid + key.offset;
+	ASSERT(offset >= found_start && offset < found_end);
+
+	ptr = btrfs_item_ptr_offset(leaf, path->slots[0]);
+	i = (offset - found_start) / sectorsize;
+	return !!extent_buffer_test_bit(leaf, ptr, i);
+}
+
+static int load_free_space_bitmaps(struct btrfs_fs_info *fs_info,
+				   struct btrfs_block_group_cache *block_group,
+				   struct btrfs_path *path,
+				   u32 expected_extent_count,
+				   int *errors)
+{
+	struct btrfs_root *root = fs_info->free_space_root;
+	struct btrfs_key key;
+	int prev_bit = 0, bit;
+	u64 extent_start = 0;
+	u64 start, end, offset;
+	u32 extent_count = 0;
+	int ret;
+
+	start = block_group->key.objectid;
+	end = block_group->key.objectid + block_group->key.offset;
+
+	while (1) {
+		ret = btrfs_next_item(root, path);
+		if (ret < 0)
+			goto out;
+		if (ret)
+			break;
+
+		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+
+		if (key.type == BTRFS_FREE_SPACE_INFO_KEY)
+			break;
+
+		if (key.type != BTRFS_FREE_SPACE_BITMAP_KEY) {
+			fprintf(stderr, "unexpected key of type %u\n", key.type);
+			(*errors)++;
+			break;
+		}
+		if (key.objectid >= end) {
+			fprintf(stderr, "free space bitmap starts at %Lu, beyond end of block group %Lu-%Lu\n",
+				key.objectid, start, end);
+			(*errors)++;
+			break;
+		}
+		if (key.objectid + key.offset > end) {
+			fprintf(stderr, "free space bitmap ends at %Lu, beyond end of block group %Lu-%Lu\n",
+				key.objectid, start, end);
+			(*errors)++;
+			break;
+		}
+
+		offset = key.objectid;
+		while (offset < key.objectid + key.offset) {
+			bit = free_space_test_bit(block_group, path, offset,
+						  root->sectorsize);
+			if (prev_bit == 0 && bit == 1) {
+				extent_start = offset;
+			} else if (prev_bit == 1 && bit == 0) {
+				ret = btrfs_add_free_space(block_group->free_space_ctl,
+							   extent_start,
+							   offset - extent_start);
+				if (ret)
+					goto out;
+				extent_count++;
+			}
+			prev_bit = bit;
+			offset += root->sectorsize;
+		}
+	}
+
+	if (prev_bit == 1) {
+		ret = btrfs_add_free_space(block_group->free_space_ctl,
+					   extent_start, end - extent_start);
+		if (ret)
+			goto out;
+		extent_count++;
+	}
+
+	if (extent_count != expected_extent_count) {
+		fprintf(stderr, "free space info recorded %u extents, counted %u\n",
+			expected_extent_count, extent_count);
+		(*errors)++;
+	}
+
+	ret = 0;
+out:
+	return ret;
+}
+
+static int load_free_space_extents(struct btrfs_fs_info *fs_info,
+				   struct btrfs_block_group_cache *block_group,
+				   struct btrfs_path *path,
+				   u32 expected_extent_count,
+				   int *errors)
+{
+	struct btrfs_root *root = fs_info->free_space_root;
+	struct btrfs_key key, prev_key;
+	int have_prev = 0;
+	u64 start, end;
+	u32 extent_count = 0;
+	int ret;
+
+	start = block_group->key.objectid;
+	end = block_group->key.objectid + block_group->key.offset;
+
+	while (1) {
+		ret = btrfs_next_item(root, path);
+		if (ret < 0)
+			goto out;
+		if (ret)
+			break;
+
+		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+
+		if (key.type == BTRFS_FREE_SPACE_INFO_KEY)
+			break;
+
+		if (key.type != BTRFS_FREE_SPACE_EXTENT_KEY) {
+			fprintf(stderr, "unexpected key of type %u\n", key.type);
+			(*errors)++;
+			break;
+		}
+		if (key.objectid >= end) {
+			fprintf(stderr, "free space extent starts at %Lu, beyond end of block group %Lu-%Lu\n",
+				key.objectid, start, end);
+			(*errors)++;
+			break;
+		}
+		if (key.objectid + key.offset > end) {
+			fprintf(stderr, "free space extent ends at %Lu, beyond end of block group %Lu-%Lu\n",
+				key.objectid, start, end);
+			(*errors)++;
+			break;
+		}
+
+		if (have_prev) {
+			u64 cur_start = key.objectid;
+			u64 cur_end = cur_start + key.offset;
+			u64 prev_start = prev_key.objectid;
+			u64 prev_end = prev_start + prev_key.offset;
+
+			if (cur_start < prev_end) {
+				fprintf(stderr, "free space extent %Lu-%Lu overlaps with previous %Lu-%Lu\n",
+					cur_start, cur_end,
+					prev_start, prev_end);
+				(*errors)++;
+			} else if (cur_start == prev_end) {
+				fprintf(stderr, "free space extent %Lu-%Lu is unmerged with previous %Lu-%Lu\n",
+					cur_start, cur_end,
+					prev_start, prev_end);
+				(*errors)++;
+			}
+		}
+
+		ret = btrfs_add_free_space(block_group->free_space_ctl,
+					   key.objectid, key.offset);
+		if (ret)
+			goto out;
+		extent_count++;
+
+		prev_key = key;
+		have_prev = 1;
+	}
+
+	if (extent_count != expected_extent_count) {
+		fprintf(stderr, "free space info recorded %u extents, counted %u\n",
+			expected_extent_count, extent_count);
+		(*errors)++;
+	}
+
+	ret = 0;
+out:
+	return ret;
+}
+
+int load_free_space_tree(struct btrfs_fs_info *fs_info,
+			 struct btrfs_block_group_cache *block_group)
+{
+	struct btrfs_free_space_info *info;
+	struct btrfs_path *path;
+	u32 extent_count, flags;
+	int errors = 0;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+	path->reada = 1;
+
+	info = search_free_space_info(NULL, fs_info, block_group, path, 0);
+	if (IS_ERR(info)) {
+		ret = PTR_ERR(info);
+		goto out;
+	}
+	extent_count = btrfs_free_space_extent_count(path->nodes[0], info);
+	flags = btrfs_free_space_flags(path->nodes[0], info);
+
+	if (flags & BTRFS_FREE_SPACE_USING_BITMAPS) {
+		ret = load_free_space_bitmaps(fs_info, block_group, path,
+					      extent_count, &errors);
+	} else {
+		ret = load_free_space_extents(fs_info, block_group, path,
+					      extent_count, &errors);
+	}
+	if (ret)
+		goto out;
+
+	ret = 0;
+out:
+	btrfs_free_path(path);
+	return ret ? ret : errors;
+}
diff --git a/free-space-tree.h b/free-space-tree.h
new file mode 100644
index 000000000000..7529a46890da
--- /dev/null
+++ b/free-space-tree.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright (C) 2015 Facebook.  All rights reserved.
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
+#ifndef __BTRFS_FREE_SPACE_TREE_H__
+#define __BTRFS_FREE_SPACE_TREE_H__
+
+int load_free_space_tree(struct btrfs_fs_info *fs_info,
+			 struct btrfs_block_group_cache *block_group);
+
+#endif
-- 
2.5.1

