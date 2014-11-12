Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31080 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753076AbaKLFvt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Nov 2014 00:51:49 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sAC5pYYc008668
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Nov 2014 13:51:34 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/4] btrfs-progs: Export btrfs-find-root related structures to allow the usage in other tools.
Date: Wed, 12 Nov 2014 13:52:13 +0800
Message-ID: <1415771534-7979-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1415771534-7979-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1415771534-7979-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Export structs in btrfs-find-root to allow other btrfs-progs to
integrate find-root function.

This will mainly help btrfsck to search tree root if all tree root and
backup are not available.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Makefile          |   2 +-
 btrfs-find-root.c | 197 +++---------------------------------------------------
 find-root.c       | 183 ++++++++++++++++++++++++++++++++++++++++++++++++++
 find-root.h       |  66 ++++++++++++++++++
 4 files changed, 258 insertions(+), 190 deletions(-)
 create mode 100644 find-root.c
 create mode 100644 find-root.h

diff --git a/Makefile b/Makefile
index 9c69ada..67e00fa 100644
--- a/Makefile
+++ b/Makefile
@@ -10,7 +10,7 @@ objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o inode-map.o \
 	  extent-cache.o extent_io.o volumes.o utils.o repair.o \
 	  qgroup.o raid6.o free-space-cache.o list_sort.o props.o \
-	  ulist.o qgroup-verify.o backref.o rbtree-utils.o
+	  ulist.o qgroup-verify.o backref.o rbtree-utils.o find-root.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index d658989..59802a4 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -34,42 +34,7 @@
 #include "volumes.h"
 #include "utils.h"
 #include "crc32c.h"
-
-/*
- * find root result is a list like the following:
- *
- * result_list
- *    |
- *    gen_list	<->	gen_list	<->	gen_list ...
- *    gen:4		gen:5			gen:6
- *    level:0		level:1			level:2
- *    level_list	level_list		level_list
- *    |-l 0's eb	|-l 1'eb(possible root)	|-l 2'eb(possible root)
- *    |-l 0's eb
- *    ...
- *    level_list only contains the highest level's eb.
- *    if level_list only contains 1 eb, that may be root.
- *    if multiple, the root is already overwritten.
- */
-struct eb_entry{
-	struct list_head list;
-	struct extent_buffer *eb;
-};
-
-struct generation_entry{
-	struct list_head gen_list;
-	struct list_head eb_list;
-	u64 generation;
-	u8 level;
-};
-
-struct search_filter {
-	u64 objectid;
-	u64 generation;
-	u64 level;
-	u64 super_gen;
-	int search_all;
-};
+#include "find-root.h"
 
 static void usage(void)
 {
@@ -78,7 +43,7 @@ static void usage(void)
 		"[ -s [+-]{objectid|generation} ] <device>\n");
 }
 
-static inline void print_message(struct eb_entry *ebe,
+static inline void print_message(struct find_root_eb_entry *ebe,
 				 struct btrfs_super_block *super)
 {
 	u64 generation = btrfs_header_generation(ebe->eb);
@@ -100,8 +65,8 @@ static void print_result(struct btrfs_root *chunk_root,
 			 struct list_head *result_list)
 {
 	struct btrfs_super_block *super = chunk_root->fs_info->super_copy;
-	struct eb_entry *ebe;
-	struct generation_entry *gene;
+	struct find_root_eb_entry *ebe;
+	struct find_root_gen_entry *gene;
 
 	printf("Super think's the tree root is at %llu, chunk root %llu\n",
 	       btrfs_super_root(super), btrfs_super_chunk_root(super));
@@ -110,159 +75,13 @@ static void print_result(struct btrfs_root *chunk_root,
 			print_message(ebe, super);
 }
 
-static int add_eb_to_gen(struct extent_buffer *eb,
-			 struct generation_entry *gene)
-{
-	struct list_head *pos;
-	struct eb_entry *ebe;
-	struct eb_entry *n;
-	struct eb_entry *new;
-	u8 level = btrfs_header_level(eb);
-	u64 bytenr = btrfs_header_bytenr(eb);
-
-	if (level < gene->level)
-		goto free_out;
-
-	new = malloc(sizeof(*new));
-	if (!new)
-		return -ENOMEM;
-	new->eb = eb;
-
-	if (level > gene->level) {
-		gene->level = level;
-		list_for_each_entry_safe(ebe, n, &gene->eb_list, list) {
-			list_del(&ebe->list);
-			free_extent_buffer(ebe->eb);
-			free(ebe);
-		}
-		list_add(&new->list, &gene->eb_list);
-		return 0;
-	}
-	list_for_each(pos, &gene->eb_list) {
-		ebe = list_entry(pos, struct eb_entry, list);
-		if (btrfs_header_bytenr(ebe->eb) > bytenr) {
-			pos = pos->prev;
-			break;
-		}
-	}
-	list_add_tail(&new->list, pos);
-	return 0;
-free_out:
-	free_extent_buffer(eb);
-	return 0;
-}
-
-static int add_eb_to_result(struct extent_buffer *eb,
-			    struct list_head *result_list,
-			    struct search_filter *search)
-{
-	struct list_head *pos;
-	struct generation_entry *gene;
-	struct generation_entry *new;
-	u64 generation = btrfs_header_generation(eb);
-	u64 level = btrfs_header_level(eb);
-	u64 owner = btrfs_header_owner(eb);
-	int found = 0;
-	int ret = 0;
-
-	if (owner != search->objectid || level < search->level ||
-	    generation < search->generation)
-		goto free_out;
-
-	list_for_each(pos, result_list) {
-		gene = list_entry(pos, struct generation_entry, gen_list);
-		if (gene->generation == generation) {
-			found = 1;
-			break;
-		}
-		if (gene->generation > generation) {
-			pos = pos->prev;
-			break;
-		}
-	}
-	if (found) {
-		ret = add_eb_to_gen(eb, gene);
-	} else {
-		new = malloc(sizeof(*new));
-		if (!new) {
-			ret = -ENOMEM;
-			goto free_out;
-		}
-		new->generation = generation;
-		new->level = 0;
-		INIT_LIST_HEAD(&new->gen_list);
-		INIT_LIST_HEAD(&new->eb_list);
-		list_add_tail(&new->gen_list, pos);
-		ret = add_eb_to_gen(eb, new);
-	}
-	if (ret)
-		goto free_out;
-	if (generation == search->super_gen && !search->search_all)
-		ret = 1;
-	return ret;
-free_out:
-	free_extent_buffer(eb);
-	return ret;
-}
-static int find_root(struct btrfs_root *chunk_root,
-		     struct list_head *result_list,
-		     struct search_filter *search)
-{
-	struct extent_buffer *eb;
-	struct btrfs_fs_info *fs_info = chunk_root->fs_info;
-	u64 metadata_offset = 0;
-	u64 metadata_size = 0;
-	u64 offset;
-	u64 leafsize = btrfs_super_leafsize(fs_info->super_copy);
-	int ret = 0;
-
-	while (1) {
-		ret = btrfs_next_metadata(&chunk_root->fs_info->mapping_tree,
-					  &metadata_offset, &metadata_size);
-		if (ret) {
-			if (ret == -ENOENT)
-				ret = 0;
-			break;
-		}
-		for (offset = metadata_offset;
-		     offset < metadata_offset + metadata_size;
-		     offset += leafsize) {
-			eb = read_tree_block(chunk_root, offset, leafsize, 0);
-			if (!eb || IS_ERR(eb))
-				continue;
-			ret = add_eb_to_result(eb, result_list, search);
-			if (ret) {
-				ret = ret > 0 ? 0 : ret;
-				return ret;
-			}
-		}
-	}
-	return ret;
-}
-
-static void free_result_list(struct list_head *result_list)
-{
-	struct eb_entry *ebe;
-	struct eb_entry *ebtmp;
-	struct generation_entry *gene;
-	struct generation_entry *gentmp;
-
-	list_for_each_entry_safe(gene, gentmp, result_list, gen_list) {
-		list_for_each_entry_safe(ebe, ebtmp,&gene->eb_list, list) {
-			list_del(&ebe->list);
-			free_extent_buffer(ebe->eb);
-			free(ebe);
-		}
-		list_del(&gene->gen_list);
-		free(gene);
-	}
-}
 
 int main(int argc, char **argv)
 {
 	struct btrfs_root *chunk_root;
 	struct list_head result_list;
-	struct search_filter search = {BTRFS_ROOT_TREE_OBJECTID, 0 ,0, 0};
+	struct find_root_search_filter search =
+				{BTRFS_ROOT_TREE_OBJECTID, 0 ,0, 0};
 	int opt;
 	int ret;
 
@@ -302,9 +121,9 @@ int main(int argc, char **argv)
 	search.super_gen =
 		btrfs_super_generation(chunk_root->fs_info->super_copy);
 	INIT_LIST_HEAD(&result_list);
-	ret = find_root(chunk_root, &result_list, &search);
+	ret = find_root_start(chunk_root, &result_list, &search);
 	print_result(chunk_root, &result_list);
-	free_result_list(&result_list);
+	find_root_free(&result_list);
 	close_ctree(chunk_root);
 	return ret;
 }
diff --git a/find-root.c b/find-root.c
new file mode 100644
index 0000000..d263c2d
--- /dev/null
+++ b/find-root.c
@@ -0,0 +1,183 @@
+/*
+ * Copyright (C) 2014 Fujitsu.  All rights reserved.
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
+#include "disk-io.h"
+#include "list.h"
+#include "volumes.h"
+#include "utils.h"
+#include "crc32c.h"
+#include "find-root.h"
+
+static int add_eb_to_gen(struct extent_buffer *eb,
+			 struct find_root_gen_entry *gene)
+{
+	struct list_head *pos;
+	struct find_root_eb_entry *ebe;
+	struct find_root_eb_entry *n;
+	struct find_root_eb_entry *new;
+	u8 level = btrfs_header_level(eb);
+	u64 bytenr = btrfs_header_bytenr(eb);
+
+	if (level < gene->level)
+		goto free_out;
+
+	new = malloc(sizeof(*new));
+	if (!new)
+		return -ENOMEM;
+	new->eb = eb;
+
+	if (level > gene->level) {
+		gene->level = level;
+		list_for_each_entry_safe(ebe, n, &gene->eb_list, list) {
+			list_del(&ebe->list);
+			free_extent_buffer(ebe->eb);
+			free(ebe);
+		}
+		list_add(&new->list, &gene->eb_list);
+		return 0;
+	}
+	list_for_each(pos, &gene->eb_list) {
+		ebe = list_entry(pos, struct find_root_eb_entry, list);
+		if (btrfs_header_bytenr(ebe->eb) > bytenr) {
+			pos = pos->prev;
+			break;
+		}
+	}
+	list_add_tail(&new->list, pos);
+	return 0;
+free_out:
+	free_extent_buffer(eb);
+	return 0;
+}
+
+static int add_eb_to_result(struct extent_buffer *eb,
+			    struct list_head *result_list,
+			    struct find_root_search_filter *search)
+{
+	struct list_head *pos;
+	struct find_root_gen_entry *gene;
+	struct find_root_gen_entry *new;
+	u64 generation = btrfs_header_generation(eb);
+	u64 level = btrfs_header_level(eb);
+	u64 owner = btrfs_header_owner(eb);
+	int found = 0;
+	int ret = 0;
+
+	if (owner != search->objectid || level < search->level ||
+	    generation < search->generation)
+		goto free_out;
+
+	list_for_each(pos, result_list) {
+		gene = list_entry(pos, struct find_root_gen_entry, gen_list);
+		if (gene->generation == generation) {
+			found = 1;
+			break;
+		}
+		if (gene->generation > generation) {
+			pos = pos->prev;
+			break;
+		}
+	}
+	if (found) {
+		ret = add_eb_to_gen(eb, gene);
+	} else {
+		new = malloc(sizeof(*new));
+		if (!new) {
+			ret = -ENOMEM;
+			goto free_out;
+		}
+		new->generation = generation;
+		new->level = 0;
+		INIT_LIST_HEAD(&new->gen_list);
+		INIT_LIST_HEAD(&new->eb_list);
+		list_add_tail(&new->gen_list, pos);
+		ret = add_eb_to_gen(eb, new);
+	}
+	if (ret)
+		goto free_out;
+	if (generation == search->super_gen && !search->search_all)
+		ret = 1;
+	return ret;
+free_out:
+	free_extent_buffer(eb);
+	return ret;
+}
+
+int find_root_start(struct btrfs_root *chunk_root,
+		    struct list_head *result_list,
+		    struct find_root_search_filter *search)
+{
+	struct extent_buffer *eb;
+	struct btrfs_fs_info *fs_info = chunk_root->fs_info;
+	u64 metadata_offset = 0;
+	u64 metadata_size = 0;
+	u64 offset;
+	u64 leafsize = btrfs_super_leafsize(fs_info->super_copy);
+	int ret = 0;
+	int suppress_error = fs_info->suppress_error;
+
+	fs_info->suppress_error = 1;
+	while (1) {
+		ret = btrfs_next_metadata(&chunk_root->fs_info->mapping_tree,
+					  &metadata_offset, &metadata_size);
+		if (ret) {
+			if (ret == -ENOENT)
+				ret = 0;
+			break;
+		}
+		for (offset = metadata_offset;
+		     offset < metadata_offset + metadata_size;
+		     offset += leafsize) {
+			eb = read_tree_block(chunk_root, offset, leafsize, 0);
+			if (!eb || IS_ERR(eb))
+				continue;
+			ret = add_eb_to_result(eb, result_list, search);
+			if (ret) {
+				ret = ret > 0 ? 0 : ret;
+				goto out;
+			}
+		}
+	}
+out:
+	fs_info->suppress_error = suppress_error;
+	return ret;
+}
+
+void find_root_free(struct list_head *result_list)
+{
+	struct find_root_eb_entry *ebe;
+	struct find_root_eb_entry *ebtmp;
+	struct find_root_gen_entry *gene;
+	struct find_root_gen_entry *gentmp;
+
+	list_for_each_entry_safe(gene, gentmp, result_list, gen_list) {
+		list_for_each_entry_safe(ebe, ebtmp,&gene->eb_list, list) {
+			list_del(&ebe->list);
+			free_extent_buffer(ebe->eb);
+			free(ebe);
+		}
+		list_del(&gene->gen_list);
+		free(gene);
+	}
+}
diff --git a/find-root.h b/find-root.h
new file mode 100644
index 0000000..7a75a0e
--- /dev/null
+++ b/find-root.h
@@ -0,0 +1,66 @@
+/*
+ * Copyright (C) 2014 Fujitsu.  All rights reserved.
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
+/*
+ * find root result is a list like the following:
+ *
+ * <list_head>
+ * result_list
+ *    |
+ *    <gen_entry>	<gen_entry>		<gen_entry>
+ *    gen_list	<->	gen_list	<->	gen_list ...
+ *    gen:4		gen:5			gen:6
+ *    level:0		level:1			level:2
+ *    level_list	level_list		level_list
+ *    |<eb_entry>	|<eb_entry>		|<eb_entry>
+ *    |-l 0's eb	|-l 1'eb(possible root)	|-l 2'eb(possible root)
+ *    |-l 0's eb
+ *    ...
+ *    level_list only contains the highest level's eb.
+ *    if level_list only contains 1 eb, that may be root.
+ *    if multiple, the root is already overwritten.
+ */
+struct find_root_eb_entry {
+	struct list_head list;
+	struct extent_buffer *eb;
+};
+
+struct find_root_gen_entry {
+	struct list_head gen_list;
+	struct list_head eb_list;
+	u64 generation;
+	u8 level;
+};
+
+struct find_root_search_filter {
+	u64 objectid;
+	u64 generation;
+	u64 level;
+	u64 super_gen;
+	int search_all;
+};
+int find_root_start(struct btrfs_root *chunk_root,
+		    struct list_head *result_list,
+		    struct find_root_search_filter *search);
+void find_root_free(struct list_head *result_list);
+#endif
-- 
2.1.3

