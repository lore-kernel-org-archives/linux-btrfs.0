Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41939 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751461AbbASGrW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Jan 2015 01:47:22 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0J6kgxh022569
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Jan 2015 14:46:42 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 04/10] btrfs-progs: Add new find-root.[ch] infrastructure.
Date: Mon, 19 Jan 2015 14:45:06 +0800
Message-ID: <1421649912-14539-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1421649912-14539-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1421649912-14539-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce new find-root.[ch] infrastructure which has better tree root
judgment and uses much less codes to do it.

The new infrastructure will only record tree blocks with highest level
among its generation, and do better judgment whether the found tree block
is the desired one(level + generation check other than the original
generation only check).

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Makefile    |   2 +-
 find-root.c | 139 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 find-root.h |  84 ++++++++++++++++++++++++++++++++++++
 3 files changed, 224 insertions(+), 1 deletion(-)
 create mode 100644 find-root.c
 create mode 100644 find-root.h

diff --git a/Makefile b/Makefile
index 8b843bb..b0d0c3f 100644
--- a/Makefile
+++ b/Makefile
@@ -12,7 +12,7 @@ objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  extent-cache.o extent_io.o volumes.o utils.o repair.o \
 	  qgroup.o raid6.o free-space-cache.o list_sort.o props.o \
 	  ulist.o qgroup-verify.o backref.o string-table.o task-utils.o \
-	  inode.o
+	  inode.o find-root.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
diff --git a/find-root.c b/find-root.c
new file mode 100644
index 0000000..a5ad777
--- /dev/null
+++ b/find-root.c
@@ -0,0 +1,139 @@
+/*
+ * Copyright (C) 2015 Fujitsu.  All rights reserved.
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
+#include "kerncompat.h"
+#include "ctree.h"
+#include "utils.h"
+#include "find-root.h"
+#include "volumes.h"
+#include "disk-io.h"
+#include "extent-cache.h"
+
+/* Return value is the same as btrfs_find_root_search(). */
+static int add_eb_to_result(struct extent_buffer *eb,
+			    struct cache_tree *result,
+			    u32 leafsize,
+			    struct btrfs_find_root_filter *filter,
+			    struct cache_extent **match)
+{
+	u64 generation = btrfs_header_generation(eb);
+	u64 level = btrfs_header_level(eb);
+	u64 owner = btrfs_header_owner(eb);
+	u64 start = eb->start;
+	struct cache_extent *cache;
+	struct btrfs_find_root_gen_cache *gen_cache = NULL;
+	int ret = 0;
+
+	if (owner != filter->objectid || level < filter->level ||
+	    generation < filter->generation)
+		return ret;
+
+	/* Get the generation cache or create one */
+	cache = search_cache_extent(result, generation);
+	if (!cache) {
+		gen_cache = malloc(sizeof(*gen_cache));
+		cache = &gen_cache->cache;
+		cache->start = generation;
+		cache->size = 1;
+		cache->objectid = 0;
+		gen_cache->highest_level = 0;
+		cache_tree_init(&gen_cache->eb_tree);
+
+		ret = insert_cache_extent(result, cache);
+		if (ret < 0)
+			return ret;
+	}
+	gen_cache = container_of(cache, struct btrfs_find_root_gen_cache,
+				 cache);
+
+	/* Higher level, clean tree and insert the new one */
+	if (level > gen_cache->highest_level) {
+		free_extent_cache_tree(&gen_cache->eb_tree);
+		gen_cache->highest_level = level;
+		/* Fall into the insert routine */
+	}
+
+	/* Same level, insert it into the eb_tree */
+	if (level == gen_cache->highest_level) {
+		ret = add_cache_extent(&gen_cache->eb_tree,
+				       start, leafsize);
+		if (ret < 0 && ret != -EEXIST)
+			return ret;
+		ret = 0;
+	}
+	if (generation == filter->match_gen &&
+	    level == filter->match_level &&
+	    !filter->search_all) {
+		ret = 1;
+		if (match)
+			*match = search_cache_extent(&gen_cache->eb_tree,
+						     start);
+	}
+	return ret;
+}
+
+/*
+ * Return 0 if iterating all the metadata extents.
+ * Return 1 if found root with given gen/level and set *match to it.
+ * Return <0 if error happens
+ */
+int btrfs_find_root_search(struct btrfs_root *chunk_root,
+			   struct btrfs_find_root_filter *filter,
+			   struct cache_tree *result,
+			   struct cache_extent **match)
+{
+	struct btrfs_fs_info *fs_info = chunk_root->fs_info;
+	struct extent_buffer *eb;
+	u64 metadata_offset = 0;
+	u64 metadata_size = 0;
+	u64 offset = 0;
+	u32 leafsize = chunk_root->leafsize;
+	int suppress_error = 0;
+	int ret = 0;
+
+	suppress_error = fs_info->suppress_error;
+	fs_info->suppress_error = 1;
+	while (1) {
+		ret = btrfs_next_metadata(&fs_info->mapping_tree,
+					  &metadata_offset, &metadata_size);
+		if (ret) {
+			if (ret == -ENOENT)
+				ret = 0;
+			break;
+		}
+		for (offset = metadata_offset;
+		     offset < metadata_offset + metadata_size;
+		     offset += chunk_root->leafsize) {
+			eb = read_tree_block(chunk_root, offset, leafsize, 0);
+			if (!eb || IS_ERR(eb))
+				continue;
+			ret = add_eb_to_result(eb, result, leafsize, filter,
+					       match);
+			free_extent_buffer(eb);
+			if (ret)
+				goto out;
+		}
+	}
+out:
+	fs_info->suppress_error = suppress_error;
+	return ret;
+}
diff --git a/find-root.h b/find-root.h
new file mode 100644
index 0000000..81f3786
--- /dev/null
+++ b/find-root.h
@@ -0,0 +1,84 @@
+/*
+ * Copyright (C) 2015 Fujitsu.  All rights reserved.
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
+#ifndef __BTRFS_FIND_ROOT_H
+#define __BTRFS_FIND_ROOT_H
+#include "ctree.h"
+#include "list.h"
+#include "kerncompat.h"
+#include "extent-cache.h"
+/*
+ * Find-root will restore the search result in a 2-level trees.
+ * Search result is a cache_tree consisted of generation_cache.
+ * Each generation cache records the highest level of this generation
+ * and all the tree blocks with this generation.
+ *
+ * <result>
+ * cache_tree ----> generation_cache: gen:1 level: 2  eb_tree ----> eb1
+ *		|						|-> eb2
+ *		|						......
+ *		|-> generation_cache: gen:2 level: 3  eb_tree ---> eb3
+ *
+ * In the above example, generation 1's highest level is 2, but have multiple
+ * eb with same generation, so the root of generation 1 must be missing,
+ * possibly has already been overwritten.
+ * On the other hand, generation 2's highest level is 3 and we find only one
+ * eb for it, so it may be the root of generation 2.
+ */
+
+struct btrfs_find_root_gen_cache {
+	struct cache_extent cache;	/* cache->start is generation */
+	u64 highest_level;
+	struct cache_tree eb_tree;
+};
+
+struct btrfs_find_root_filter {
+	u64 objectid;	/* Only search tree with this objectid */
+	u64 generation; /* Only record tree block with higher or
+			   equal generation */
+	u8 level;	/* Only record tree block with higher or
+			   equal level */
+	u8 match_level;
+	u64 match_gen;
+	unsigned int search_all:1;
+	/*
+	 * If set search_all, even the tree block matches match_gen
+	 * and match_level and objectid, still continue searching
+	 * This *WILL* takes *TONS* of extra time.
+	 */
+};
+int btrfs_find_root_search(struct btrfs_root *chunk_root,
+			   struct btrfs_find_root_filter *filter,
+			   struct cache_tree *result,
+			   struct cache_extent **match);
+static inline void btrfs_find_root_free(struct cache_tree *result)
+{
+	struct btrfs_find_root_gen_cache *gen_cache;
+	struct cache_extent *cache;
+
+	cache = first_cache_extent(result);
+	while (cache) {
+		gen_cache = container_of(cache,
+				struct btrfs_find_root_gen_cache, cache);
+		free_extent_cache_tree(&gen_cache->eb_tree);
+		remove_cache_extent(result, cache);
+		free(gen_cache);
+		cache = first_cache_extent(result);
+	}
+}
+#endif
-- 
2.2.2

