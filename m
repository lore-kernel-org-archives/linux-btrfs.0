Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:36748 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbcBVOuW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Feb 2016 09:50:22 -0500
Received: by mail-wm0-f44.google.com with SMTP id g62so176552434wme.1
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Feb 2016 06:50:21 -0800 (PST)
From: Alexander Fougner <fougner89@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Alexander Fougner <fougner89@gmail.com>
Subject: [PATCH v2 1/2] btrfs-progs: copy functionality of btrfs-debug-tree to inspect-internal subcommand
Date: Mon, 22 Feb 2016 15:49:49 +0100
Message-Id: <1456152590-24601-1-git-send-email-fougner89@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The long-term plan is to merge the features of standalone tools
into the btrfs binary, reducing the number of shipped binaries.

Signed-off-by: Alexander Fougner <fougner89@gmail.com>
---
 Makefile.in              |   2 +-
 btrfs-debug-tree.c       | 435 +-------------------------------------------
 cmds-inspect-dump-tree.c | 462 +++++++++++++++++++++++++++++++++++++++++++++++
 cmds-inspect-dump-tree.h |  26 +++
 cmds-inspect.c           |   8 +
 5 files changed, 504 insertions(+), 429 deletions(-)
 create mode 100644 cmds-inspect-dump-tree.c
 create mode 100644 cmds-inspect-dump-tree.h

diff --git a/Makefile.in b/Makefile.in
index 19697ff..14dab76 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -70,7 +70,7 @@ objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  extent-cache.o extent_io.o volumes.o utils.o repair.o \
 	  qgroup.o raid6.o free-space-cache.o list_sort.o props.o \
 	  ulist.o qgroup-verify.o backref.o string-table.o task-utils.o \
-	  inode.o file.o find-root.o free-space-tree.o help.o
+	  inode.o file.o find-root.o free-space-tree.o help.o cmds-inspect-dump-tree.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
index 266176f..d6e5a69 100644
--- a/btrfs-debug-tree.c
+++ b/btrfs-debug-tree.c
@@ -16,447 +16,26 @@
  * Boston, MA 021110-1307, USA.
  */
 
-#include <stdio.h>
-#include <stdlib.h>
-#include <unistd.h>
-#include <uuid/uuid.h>
-#include <getopt.h>
-
-#include "kerncompat.h"
-#include "radix-tree.h"
-#include "ctree.h"
 #include "disk-io.h"
-#include "print-tree.h"
-#include "transaction.h"
 #include "volumes.h"
 #include "utils.h"
-
-static int print_usage(int ret)
-{
-	fprintf(stderr, "usage: btrfs-debug-tree [-e] [-d] [-r] [-R] [-u]\n");
-	fprintf(stderr, "                        [-b block_num ] device\n");
-	fprintf(stderr, "\t-e : print detailed extents info\n");
-	fprintf(stderr, "\t-d : print info of btrfs device and root tree dirs"
-                    " only\n");
-	fprintf(stderr, "\t-r : print info of roots only\n");
-	fprintf(stderr, "\t-R : print info of roots and root backups\n");
-	fprintf(stderr, "\t-u : print info of uuid tree only\n");
-	fprintf(stderr, "\t-b block_num : print info of the specified block"
-                    " only\n");
-	fprintf(stderr,
-		"\t-t tree_id : print only the tree with the given id\n");
-	fprintf(stderr, "%s\n", PACKAGE_STRING);
-	exit(ret);
-}
-
-static void print_extents(struct btrfs_root *root, struct extent_buffer *eb)
-{
-	int i;
-	u32 nr;
-	u32 size;
-
-	if (!eb)
-		return;
-
-	if (btrfs_is_leaf(eb)) {
-		btrfs_print_leaf(root, eb);
-		return;
-	}
-
-	size = btrfs_level_size(root, btrfs_header_level(eb) - 1);
-	nr = btrfs_header_nritems(eb);
-	for (i = 0; i < nr; i++) {
-		struct extent_buffer *next = read_tree_block(root,
-					     btrfs_node_blockptr(eb, i),
-					     size,
-					     btrfs_node_ptr_generation(eb, i));
-		if (!extent_buffer_uptodate(next))
-			continue;
-		if (btrfs_is_leaf(next) &&
-		    btrfs_header_level(eb) != 1)
-			BUG();
-		if (btrfs_header_level(next) !=
-			btrfs_header_level(eb) - 1)
-			BUG();
-		print_extents(root, next);
-		free_extent_buffer(next);
-	}
-}
-
-static void print_old_roots(struct btrfs_super_block *super)
-{
-	struct btrfs_root_backup *backup;
-	int i;
-
-	for (i = 0; i < BTRFS_NUM_BACKUP_ROOTS; i++) {
-		backup = super->super_roots + i;
-		printf("btrfs root backup slot %d\n", i);
-		printf("\ttree root gen %llu block %llu\n",
-		       (unsigned long long)btrfs_backup_tree_root_gen(backup),
-		       (unsigned long long)btrfs_backup_tree_root(backup));
-
-		printf("\t\textent root gen %llu block %llu\n",
-		       (unsigned long long)btrfs_backup_extent_root_gen(backup),
-		       (unsigned long long)btrfs_backup_extent_root(backup));
-
-		printf("\t\tchunk root gen %llu block %llu\n",
-		       (unsigned long long)btrfs_backup_chunk_root_gen(backup),
-		       (unsigned long long)btrfs_backup_chunk_root(backup));
-
-		printf("\t\tdevice root gen %llu block %llu\n",
-		       (unsigned long long)btrfs_backup_dev_root_gen(backup),
-		       (unsigned long long)btrfs_backup_dev_root(backup));
-
-		printf("\t\tcsum root gen %llu block %llu\n",
-		       (unsigned long long)btrfs_backup_csum_root_gen(backup),
-		       (unsigned long long)btrfs_backup_csum_root(backup));
-
-		printf("\t\tfs root gen %llu block %llu\n",
-		       (unsigned long long)btrfs_backup_fs_root_gen(backup),
-		       (unsigned long long)btrfs_backup_fs_root(backup));
-
-		printf("\t\t%llu used %llu total %llu devices\n",
-		       (unsigned long long)btrfs_backup_bytes_used(backup),
-		       (unsigned long long)btrfs_backup_total_bytes(backup),
-		       (unsigned long long)btrfs_backup_num_devices(backup));
-	}
-}
+#include "commands.h"
+#include "cmds-inspect-dump-tree.h"
 
 int main(int ac, char **av)
 {
-	struct btrfs_root *root;
-	struct btrfs_fs_info *info;
-	struct btrfs_path path;
-	struct btrfs_key key;
-	struct btrfs_root_item ri;
-	struct extent_buffer *leaf;
-	struct btrfs_disk_key disk_key;
-	struct btrfs_key found_key;
-	char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
 	int ret;
-	int slot;
-	int extent_only = 0;
-	int device_only = 0;
-	int uuid_tree_only = 0;
-	int roots_only = 0;
-	int root_backups = 0;
-	u64 block_only = 0;
-	struct btrfs_root *tree_root_scan;
-	u64 tree_id = 0;
 
-	radix_tree_init();
-
-	while(1) {
-		int c;
-		static const struct option long_options[] = {
-			{ "help", no_argument, NULL, GETOPT_VAL_HELP},
-			{ NULL, 0, NULL, 0 }
-		};
-
-		c = getopt_long(ac, av, "deb:rRut:", long_options, NULL);
-		if (c < 0)
-			break;
-		switch(c) {
-			case 'e':
-				extent_only = 1;
-				break;
-			case 'd':
-				device_only = 1;
-				break;
-			case 'r':
-				roots_only = 1;
-				break;
-			case 'u':
-				uuid_tree_only = 1;
-				break;
-			case 'R':
-				roots_only = 1;
-				root_backups = 1;
-				break;
-			case 'b':
-				block_only = arg_strtou64(optarg);
-				break;
-			case 't':
-				tree_id = arg_strtou64(optarg);
-				break;
-			case GETOPT_VAL_HELP:
-			default:
-				print_usage(c != GETOPT_VAL_HELP);
-		}
-	}
 	set_argv0(av);
-	ac = ac - optind;
-	if (check_argc_exact(ac, 1))
-		print_usage(1);
-
-	ret = check_arg_type(av[optind]);
-	if (ret != BTRFS_ARG_BLKDEV && ret != BTRFS_ARG_REG) {
-		fprintf(stderr, "'%s' is not a block device or regular file\n",
-			av[optind]);
-		exit(1);
-	}
-
-	info = open_ctree_fs_info(av[optind], 0, 0, OPEN_CTREE_PARTIAL);
-	if (!info) {
-		fprintf(stderr, "unable to open %s\n", av[optind]);
-		exit(1);
-	}
-
-	root = info->fs_root;
-	if (!root) {
-		fprintf(stderr, "unable to open %s\n", av[optind]);
-		exit(1);
-	}
-
-	if (block_only) {
-		leaf = read_tree_block(root,
-				      block_only,
-				      root->leafsize, 0);
-
-		if (extent_buffer_uptodate(leaf) &&
-		    btrfs_header_level(leaf) != 0) {
-			free_extent_buffer(leaf);
-			leaf = NULL;
-		}
-
-		if (!leaf) {
-			leaf = read_tree_block(root,
-					      block_only,
-					      root->nodesize, 0);
-		}
-		if (!extent_buffer_uptodate(leaf)) {
-			fprintf(stderr, "failed to read %llu\n",
-				(unsigned long long)block_only);
-			goto close_root;
-		}
-		btrfs_print_tree(root, leaf, 0);
-		free_extent_buffer(leaf);
-		goto close_root;
-	}
-
-	if (!(extent_only || uuid_tree_only || tree_id)) {
-		if (roots_only) {
-			printf("root tree: %llu level %d\n",
-			     (unsigned long long)info->tree_root->node->start,
-			     btrfs_header_level(info->tree_root->node));
-			printf("chunk tree: %llu level %d\n",
-			     (unsigned long long)info->chunk_root->node->start,
-			     btrfs_header_level(info->chunk_root->node));
-		} else {
-			if (info->tree_root->node) {
-				printf("root tree\n");
-				btrfs_print_tree(info->tree_root,
-						 info->tree_root->node, 1);
-			}
 
-			if (info->chunk_root->node) {
-				printf("chunk tree\n");
-				btrfs_print_tree(info->chunk_root,
-						 info->chunk_root->node, 1);
-			}
-		}
-	}
-	tree_root_scan = info->tree_root;
+	if (ac > 1 && !strcmp(av[1], "--help"))
+		usage(cmd_inspect_dump_tree_usage);
 
-	btrfs_init_path(&path);
-again:
-	if (!extent_buffer_uptodate(tree_root_scan->node))
-		goto no_node;
-
-	/*
-	 * Tree's that are not pointed by the tree of tree roots
-	 */
-	if (tree_id && tree_id == BTRFS_ROOT_TREE_OBJECTID) {
-		if (!info->tree_root->node) {
-			error("cannot print root tree, invalid pointer");
-			goto no_node;
-		}
-		printf("root tree\n");
-		btrfs_print_tree(info->tree_root, info->tree_root->node, 1);
-		goto no_node;
-	}
-
-	if (tree_id && tree_id == BTRFS_CHUNK_TREE_OBJECTID) {
-		if (!info->chunk_root->node) {
-			error("cannot print chunk tree, invalid pointer");
-			goto no_node;
-		}
-		printf("chunk tree\n");
-		btrfs_print_tree(info->chunk_root, info->chunk_root->node, 1);
-		goto no_node;
-	}
-
-	key.offset = 0;
-	key.objectid = 0;
-	btrfs_set_key_type(&key, BTRFS_ROOT_ITEM_KEY);
-	ret = btrfs_search_slot(NULL, tree_root_scan, &key, &path, 0, 0);
-	BUG_ON(ret < 0);
-	while(1) {
-		leaf = path.nodes[0];
-		slot = path.slots[0];
-		if (slot >= btrfs_header_nritems(leaf)) {
-			ret = btrfs_next_leaf(tree_root_scan, &path);
-			if (ret != 0)
-				break;
-			leaf = path.nodes[0];
-			slot = path.slots[0];
-		}
-		btrfs_item_key(leaf, &disk_key, path.slots[0]);
-		btrfs_disk_key_to_cpu(&found_key, &disk_key);
-		if (btrfs_key_type(&found_key) == BTRFS_ROOT_ITEM_KEY) {
-			unsigned long offset;
-			struct extent_buffer *buf;
-			int skip = extent_only | device_only | uuid_tree_only;
-
-			offset = btrfs_item_ptr_offset(leaf, slot);
-			read_extent_buffer(leaf, &ri, offset, sizeof(ri));
-			buf = read_tree_block(tree_root_scan,
-					      btrfs_root_bytenr(&ri),
-					      btrfs_level_size(tree_root_scan,
-							btrfs_root_level(&ri)),
-					      0);
-			if (!extent_buffer_uptodate(buf))
-				goto next;
-			if (tree_id && found_key.objectid != tree_id) {
-				free_extent_buffer(buf);
-				goto next;
-			}
-
-			switch(found_key.objectid) {
-			case BTRFS_ROOT_TREE_OBJECTID:
-				if (!skip)
-					printf("root");
-				break;
-			case BTRFS_EXTENT_TREE_OBJECTID:
-				if (!device_only && !uuid_tree_only)
-					skip = 0;
-				if (!skip)
-					printf("extent");
-				break;
-			case BTRFS_CHUNK_TREE_OBJECTID:
-				if (!skip) {
-					printf("chunk");
-				}
-				break;
-			case BTRFS_DEV_TREE_OBJECTID:
-				if (!uuid_tree_only)
-					skip = 0;
-				if (!skip)
-					printf("device");
-				break;
-			case BTRFS_FS_TREE_OBJECTID:
-				if (!skip) {
-					printf("fs");
-				}
-				break;
-			case BTRFS_ROOT_TREE_DIR_OBJECTID:
-				skip = 0;
-				printf("directory");
-				break;
-			case BTRFS_CSUM_TREE_OBJECTID:
-				if (!skip) {
-					printf("checksum");
-				}
-				break;
-			case BTRFS_ORPHAN_OBJECTID:
-				if (!skip) {
-					printf("orphan");
-				}
-				break;
-			case BTRFS_TREE_LOG_OBJECTID:
-				if (!skip) {
-					printf("log");
-				}
-				break;
-			case BTRFS_TREE_LOG_FIXUP_OBJECTID:
-				if (!skip) {
-					printf("log fixup");
-				}
-				break;
-			case BTRFS_TREE_RELOC_OBJECTID:
-				if (!skip) {
-					printf("reloc");
-				}
-				break;
-			case BTRFS_DATA_RELOC_TREE_OBJECTID:
-				if (!skip) {
-					printf("data reloc");
-				}
-				break;
-			case BTRFS_EXTENT_CSUM_OBJECTID:
-				if (!skip) {
-					printf("extent checksum");
-				}
-				break;
-			case BTRFS_QUOTA_TREE_OBJECTID:
-				if (!skip) {
-					printf("quota");
-				}
-				break;
-			case BTRFS_UUID_TREE_OBJECTID:
-				if (!extent_only && !device_only)
-					skip = 0;
-				if (!skip)
-					printf("uuid");
-				break;
-			case BTRFS_FREE_SPACE_TREE_OBJECTID:
-				if (!skip)
-					printf("free space");
-				break;
-			case BTRFS_MULTIPLE_OBJECTIDS:
-				if (!skip) {
-					printf("multiple");
-				}
-				break;
-			default:
-				if (!skip) {
-					printf("file");
-				}
-			}
-			if (extent_only && !skip) {
-				print_extents(tree_root_scan, buf);
-			} else if (!skip) {
-				printf(" tree ");
-				btrfs_print_key(&disk_key);
-				if (roots_only) {
-					printf(" %llu level %d\n",
-					       (unsigned long long)buf->start,
-					       btrfs_header_level(buf));
-				} else {
-					printf(" \n");
-					btrfs_print_tree(tree_root_scan, buf, 1);
-				}
-			}
-			free_extent_buffer(buf);
-		}
-next:
-		path.slots[0]++;
-	}
-no_node:
-	btrfs_release_path(&path);
-
-	if (tree_root_scan == info->tree_root &&
-	    info->log_root_tree) {
-		tree_root_scan = info->log_root_tree;
-		goto again;
-	}
-
-	if (extent_only || device_only || uuid_tree_only)
-		goto close_root;
+	radix_tree_init();
 
-	if (root_backups)
-		print_old_roots(info->super_copy);
+	ret = cmd_inspect_dump_tree(ac, av);
 
-	printf("total bytes %llu\n",
-	       (unsigned long long)btrfs_super_total_bytes(info->super_copy));
-	printf("bytes used %llu\n",
-	       (unsigned long long)btrfs_super_bytes_used(info->super_copy));
-	uuidbuf[BTRFS_UUID_UNPARSED_SIZE - 1] = '\0';
-	uuid_unparse(info->super_copy->fsid, uuidbuf);
-	printf("uuid %s\n", uuidbuf);
-	printf("%s\n", PACKAGE_STRING);
-close_root:
-	ret = close_ctree(root);
 	btrfs_close_all_devices();
+
 	return ret;
 }
diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
new file mode 100644
index 0000000..8f36144
--- /dev/null
+++ b/cmds-inspect-dump-tree.c
@@ -0,0 +1,462 @@
+/*
+ * Copyright (C) 2007 Oracle.  All rights reserved.
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
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <uuid/uuid.h>
+#include <getopt.h>
+
+#include "kerncompat.h"
+#include "radix-tree.h"
+#include "ctree.h"
+#include "disk-io.h"
+#include "print-tree.h"
+#include "transaction.h"
+#include "volumes.h"
+#include "commands.h"
+#include "utils.h"
+#include "cmds-inspect-dump-tree.h"
+
+static void print_extents(struct btrfs_root *root, struct extent_buffer *eb)
+{
+	int i;
+	u32 nr;
+	u32 size;
+
+	if (!eb)
+		return;
+
+	if (btrfs_is_leaf(eb)) {
+		btrfs_print_leaf(root, eb);
+		return;
+	}
+
+	size = btrfs_level_size(root, btrfs_header_level(eb) - 1);
+	nr = btrfs_header_nritems(eb);
+	for (i = 0; i < nr; i++) {
+		struct extent_buffer *next = read_tree_block(root,
+					     btrfs_node_blockptr(eb, i),
+					     size,
+					     btrfs_node_ptr_generation(eb, i));
+		if (!extent_buffer_uptodate(next))
+			continue;
+		if (btrfs_is_leaf(next) &&
+		    btrfs_header_level(eb) != 1)
+			BUG();
+		if (btrfs_header_level(next) !=
+			btrfs_header_level(eb) - 1)
+			BUG();
+		print_extents(root, next);
+		free_extent_buffer(next);
+	}
+}
+
+static void print_old_roots(struct btrfs_super_block *super)
+{
+	struct btrfs_root_backup *backup;
+	int i;
+
+	for (i = 0; i < BTRFS_NUM_BACKUP_ROOTS; i++) {
+		backup = super->super_roots + i;
+		printf("btrfs root backup slot %d\n", i);
+		printf("\ttree root gen %llu block %llu\n",
+		       (unsigned long long)btrfs_backup_tree_root_gen(backup),
+		       (unsigned long long)btrfs_backup_tree_root(backup));
+
+		printf("\t\textent root gen %llu block %llu\n",
+		       (unsigned long long)btrfs_backup_extent_root_gen(backup),
+		       (unsigned long long)btrfs_backup_extent_root(backup));
+
+		printf("\t\tchunk root gen %llu block %llu\n",
+		       (unsigned long long)btrfs_backup_chunk_root_gen(backup),
+		       (unsigned long long)btrfs_backup_chunk_root(backup));
+
+		printf("\t\tdevice root gen %llu block %llu\n",
+		       (unsigned long long)btrfs_backup_dev_root_gen(backup),
+		       (unsigned long long)btrfs_backup_dev_root(backup));
+
+		printf("\t\tcsum root gen %llu block %llu\n",
+		       (unsigned long long)btrfs_backup_csum_root_gen(backup),
+		       (unsigned long long)btrfs_backup_csum_root(backup));
+
+		printf("\t\tfs root gen %llu block %llu\n",
+		       (unsigned long long)btrfs_backup_fs_root_gen(backup),
+		       (unsigned long long)btrfs_backup_fs_root(backup));
+
+		printf("\t\t%llu used %llu total %llu devices\n",
+		       (unsigned long long)btrfs_backup_bytes_used(backup),
+		       (unsigned long long)btrfs_backup_total_bytes(backup),
+		       (unsigned long long)btrfs_backup_num_devices(backup));
+	}
+}
+
+const char * const cmd_inspect_dump_tree_usage[] = {
+	"btrfs inspect-internal dump-tree [options] device",
+	"Dump structures from a device",
+	"-e|--extents           print detailed extents info",
+	"-d|--device            print info of btrfs device and root tree dir only",
+	"-r|--roots             print info of roots only",
+	"-R|--backups           print info of roots and root backups",
+	"-u|--uuid              print info of uuid tree only",
+	"-b|--block <block_num> print info of the specified block only",
+	"-t|--tree  <tree_id>   print only the tree with the given id",
+	NULL
+};
+
+int cmd_inspect_dump_tree(int ac, char **av)
+{
+	struct btrfs_root *root;
+	struct btrfs_fs_info *info;
+	struct btrfs_path path;
+	struct btrfs_key key;
+	struct btrfs_root_item ri;
+	struct extent_buffer *leaf;
+	struct btrfs_disk_key disk_key;
+	struct btrfs_key found_key;
+	char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
+	int ret;
+	int slot;
+	int extent_only = 0;
+	int device_only = 0;
+	int uuid_tree_only = 0;
+	int roots_only = 0;
+	int root_backups = 0;
+	u64 block_only = 0;
+	struct btrfs_root *tree_root_scan;
+	u64 tree_id = 0;
+
+	while (1) {
+		int c;
+		static const struct option long_options[] = {
+			{ "extents", no_argument, NULL, 'e'},
+			{ "device", no_argument, NULL, 'd'},
+			{ "roots", no_argument, NULL, 'r'},
+			{ "backups", no_argument, NULL, 'R'},
+			{ "uuid", no_argument, NULL, 'u'},
+			{ "block", required_argument, NULL, 'b'},
+			{ "tree", required_argument, NULL, 't'},
+			{ NULL, 0, NULL, 0 }
+		};
+
+		c = getopt_long(ac, av, "deb:rRut:", long_options, NULL);
+		if (c < 0)
+			break;
+		switch (c) {
+		case 'e':
+			extent_only = 1;
+			break;
+		case 'd':
+			device_only = 1;
+			break;
+		case 'r':
+			roots_only = 1;
+			break;
+		case 'u':
+			uuid_tree_only = 1;
+			break;
+		case 'R':
+			roots_only = 1;
+			root_backups = 1;
+			break;
+		case 'b':
+			block_only = arg_strtou64(optarg);
+			break;
+		case 't':
+			tree_id = arg_strtou64(optarg);
+			break;
+		default:
+			usage(cmd_inspect_dump_tree_usage);
+		}
+	}
+
+	ac = ac - optind;
+	if (check_argc_exact(ac, 1))
+		usage(cmd_inspect_dump_tree_usage);
+
+	ret = check_arg_type(av[optind]);
+	if (ret != BTRFS_ARG_BLKDEV && ret != BTRFS_ARG_REG) {
+		fprintf(stderr, "'%s' is not a block device or regular file\n",
+			av[optind]);
+		goto out;
+	}
+
+	info = open_ctree_fs_info(av[optind], 0, 0, OPEN_CTREE_PARTIAL);
+	if (!info) {
+		fprintf(stderr, "unable to open %s\n", av[optind]);
+		goto out;
+	}
+
+	root = info->fs_root;
+	if (!root) {
+		fprintf(stderr, "unable to open %s\n", av[optind]);
+		goto out;
+	}
+
+	if (block_only) {
+		leaf = read_tree_block(root,
+				      block_only,
+				      root->leafsize, 0);
+
+		if (extent_buffer_uptodate(leaf) &&
+		    btrfs_header_level(leaf) != 0) {
+			free_extent_buffer(leaf);
+			leaf = NULL;
+		}
+
+		if (!leaf) {
+			leaf = read_tree_block(root,
+					      block_only,
+					      root->nodesize, 0);
+		}
+		if (!extent_buffer_uptodate(leaf)) {
+			fprintf(stderr, "failed to read %llu\n",
+				(unsigned long long)block_only);
+			goto close_root;
+		}
+		btrfs_print_tree(root, leaf, 0);
+		free_extent_buffer(leaf);
+		goto close_root;
+	}
+
+	if (!(extent_only || uuid_tree_only || tree_id)) {
+		if (roots_only) {
+			printf("root tree: %llu level %d\n",
+			     (unsigned long long)info->tree_root->node->start,
+			     btrfs_header_level(info->tree_root->node));
+			printf("chunk tree: %llu level %d\n",
+			     (unsigned long long)info->chunk_root->node->start,
+			     btrfs_header_level(info->chunk_root->node));
+		} else {
+			if (info->tree_root->node) {
+				printf("root tree\n");
+				btrfs_print_tree(info->tree_root,
+						 info->tree_root->node, 1);
+			}
+
+			if (info->chunk_root->node) {
+				printf("chunk tree\n");
+				btrfs_print_tree(info->chunk_root,
+						 info->chunk_root->node, 1);
+			}
+		}
+	}
+	tree_root_scan = info->tree_root;
+
+	btrfs_init_path(&path);
+again:
+	if (!extent_buffer_uptodate(tree_root_scan->node))
+		goto no_node;
+
+	/*
+	 * Tree's that are not pointed by the tree of tree roots
+	 */
+	if (tree_id && tree_id == BTRFS_ROOT_TREE_OBJECTID) {
+		if (!info->tree_root->node) {
+			error("cannot print root tree, invalid pointer");
+			goto no_node;
+		}
+		printf("root tree\n");
+		btrfs_print_tree(info->tree_root, info->tree_root->node, 1);
+		goto no_node;
+	}
+
+	if (tree_id && tree_id == BTRFS_CHUNK_TREE_OBJECTID) {
+		if (!info->chunk_root->node) {
+			error("cannot print chunk tree, invalid pointer");
+			goto no_node;
+		}
+		printf("chunk tree\n");
+		btrfs_print_tree(info->chunk_root, info->chunk_root->node, 1);
+		goto no_node;
+	}
+
+	key.offset = 0;
+	key.objectid = 0;
+	btrfs_set_key_type(&key, BTRFS_ROOT_ITEM_KEY);
+	ret = btrfs_search_slot(NULL, tree_root_scan, &key, &path, 0, 0);
+	BUG_ON(ret < 0);
+	while (1) {
+		leaf = path.nodes[0];
+		slot = path.slots[0];
+		if (slot >= btrfs_header_nritems(leaf)) {
+			ret = btrfs_next_leaf(tree_root_scan, &path);
+			if (ret != 0)
+				break;
+			leaf = path.nodes[0];
+			slot = path.slots[0];
+		}
+		btrfs_item_key(leaf, &disk_key, path.slots[0]);
+		btrfs_disk_key_to_cpu(&found_key, &disk_key);
+		if (btrfs_key_type(&found_key) == BTRFS_ROOT_ITEM_KEY) {
+			unsigned long offset;
+			struct extent_buffer *buf;
+			int skip = extent_only | device_only | uuid_tree_only;
+
+			offset = btrfs_item_ptr_offset(leaf, slot);
+			read_extent_buffer(leaf, &ri, offset, sizeof(ri));
+			buf = read_tree_block(tree_root_scan,
+					      btrfs_root_bytenr(&ri),
+					      btrfs_level_size(tree_root_scan,
+							btrfs_root_level(&ri)),
+					      0);
+			if (!extent_buffer_uptodate(buf))
+				goto next;
+			if (tree_id && found_key.objectid != tree_id) {
+				free_extent_buffer(buf);
+				goto next;
+			}
+
+			switch (found_key.objectid) {
+			case BTRFS_ROOT_TREE_OBJECTID:
+				if (!skip)
+					printf("root");
+				break;
+			case BTRFS_EXTENT_TREE_OBJECTID:
+				if (!device_only && !uuid_tree_only)
+					skip = 0;
+				if (!skip)
+					printf("extent");
+				break;
+			case BTRFS_CHUNK_TREE_OBJECTID:
+				if (!skip) {
+					printf("chunk");
+				}
+				break;
+			case BTRFS_DEV_TREE_OBJECTID:
+				if (!uuid_tree_only)
+					skip = 0;
+				if (!skip)
+					printf("device");
+				break;
+			case BTRFS_FS_TREE_OBJECTID:
+				if (!skip) {
+					printf("fs");
+				}
+				break;
+			case BTRFS_ROOT_TREE_DIR_OBJECTID:
+				skip = 0;
+				printf("directory");
+				break;
+			case BTRFS_CSUM_TREE_OBJECTID:
+				if (!skip) {
+					printf("checksum");
+				}
+				break;
+			case BTRFS_ORPHAN_OBJECTID:
+				if (!skip) {
+					printf("orphan");
+				}
+				break;
+			case BTRFS_TREE_LOG_OBJECTID:
+				if (!skip) {
+					printf("log");
+				}
+				break;
+			case BTRFS_TREE_LOG_FIXUP_OBJECTID:
+				if (!skip) {
+					printf("log fixup");
+				}
+				break;
+			case BTRFS_TREE_RELOC_OBJECTID:
+				if (!skip) {
+					printf("reloc");
+				}
+				break;
+			case BTRFS_DATA_RELOC_TREE_OBJECTID:
+				if (!skip) {
+					printf("data reloc");
+				}
+				break;
+			case BTRFS_EXTENT_CSUM_OBJECTID:
+				if (!skip) {
+					printf("extent checksum");
+				}
+				break;
+			case BTRFS_QUOTA_TREE_OBJECTID:
+				if (!skip) {
+					printf("quota");
+				}
+				break;
+			case BTRFS_UUID_TREE_OBJECTID:
+				if (!extent_only && !device_only)
+					skip = 0;
+				if (!skip)
+					printf("uuid");
+				break;
+			case BTRFS_FREE_SPACE_TREE_OBJECTID:
+				if (!skip)
+					printf("free space");
+				break;
+			case BTRFS_MULTIPLE_OBJECTIDS:
+				if (!skip) {
+					printf("multiple");
+				}
+				break;
+			default:
+				if (!skip) {
+					printf("file");
+				}
+			}
+			if (extent_only && !skip) {
+				print_extents(tree_root_scan, buf);
+			} else if (!skip) {
+				printf(" tree ");
+				btrfs_print_key(&disk_key);
+				if (roots_only) {
+					printf(" %llu level %d\n",
+					       (unsigned long long)buf->start,
+					       btrfs_header_level(buf));
+				} else {
+					printf(" \n");
+					btrfs_print_tree(tree_root_scan, buf, 1);
+				}
+			}
+			free_extent_buffer(buf);
+		}
+next:
+		path.slots[0]++;
+	}
+no_node:
+	btrfs_release_path(&path);
+
+	if (tree_root_scan == info->tree_root &&
+	    info->log_root_tree) {
+		tree_root_scan = info->log_root_tree;
+		goto again;
+	}
+
+	if (extent_only || device_only || uuid_tree_only)
+		goto close_root;
+
+	if (root_backups)
+		print_old_roots(info->super_copy);
+
+	printf("total bytes %llu\n",
+	       (unsigned long long)btrfs_super_total_bytes(info->super_copy));
+	printf("bytes used %llu\n",
+	       (unsigned long long)btrfs_super_bytes_used(info->super_copy));
+	uuidbuf[BTRFS_UUID_UNPARSED_SIZE - 1] = '\0';
+	uuid_unparse(info->super_copy->fsid, uuidbuf);
+	printf("uuid %s\n", uuidbuf);
+	printf("%s\n", PACKAGE_STRING);
+close_root:
+	ret = close_ctree(root);
+out:
+	return !!ret;
+}
diff --git a/cmds-inspect-dump-tree.h b/cmds-inspect-dump-tree.h
new file mode 100644
index 0000000..0341e20
--- /dev/null
+++ b/cmds-inspect-dump-tree.h
@@ -0,0 +1,26 @@
+/*
+ * Copyright (C) 2007 Oracle.  All rights reserved.
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
+ #ifndef __CMDS_INSPECT_DUMP_TREE_H__
+ #define __CMDS_INSPECT_DUMP_TREE_H__
+
+int cmd_inspect_dump_tree(int ac, char **av);
+
+extern const char * const cmd_inspect_dump_tree_usage[];
+
+#endif
diff --git a/cmds-inspect.c b/cmds-inspect.c
index 7fa4881..25ddd4c 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -31,6 +31,7 @@
 #include "disk-io.h"
 #include "commands.h"
 #include "btrfs-list.h"
+#include "cmds-inspect-dump-tree.h"
 
 static const char * const inspect_cmd_group_usage[] = {
 	"btrfs inspect-internal <command> <args>",
@@ -619,6 +620,11 @@ out:
 	return !!ret;
 }
 
+static int cmd_inspect_dump_tree_hook(int ac, char **av)
+{
+	return cmd_inspect_dump_tree(ac, av);
+}
+
 static const char inspect_cmd_group_info[] =
 "query various internal information";
 
@@ -634,6 +640,8 @@ const struct cmd_group inspect_cmd_group = {
 			0 },
 		{ "min-dev-size", cmd_inspect_min_dev_size,
 			cmd_inspect_min_dev_size_usage, NULL, 0 },
+		{ "dump-tree", cmd_inspect_dump_tree_hook,
+				cmd_inspect_dump_tree_usage, NULL, 0 },
 		NULL_CMD_STRUCT
 	}
 };
-- 
2.7.1

