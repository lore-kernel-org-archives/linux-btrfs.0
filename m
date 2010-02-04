From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V2 4/6] debug-btrfs: Add command to dump each of the btrfs trees
Date: Thu,  4 Feb 2010 23:14:05 +0530
Message-ID: <1265305447-30780-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1265305447-30780-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1265305447-30780-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 debugbtrfs/Makefile            |    2 +-
 debugbtrfs/debug_btrfs_cmds.ct |   24 ++++
 debugbtrfs/debug_tree.c        |  238 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 263 insertions(+), 1 deletions(-)
 create mode 100644 debugbtrfs/debug_tree.c

diff --git a/debugbtrfs/Makefile b/debugbtrfs/Makefile
index 348160b..970990e 100644
--- a/debugbtrfs/Makefile
+++ b/debugbtrfs/Makefile
@@ -33,7 +33,7 @@ all: $(progs)
 debug_btrfs_cmds.c: debug_btrfs_cmds.ct
 	$(MK_CMDS) debug_btrfs_cmds.ct
 
-debug-btrfs: $(TOPDIR)/lib/libbtrfs.a  debug_btrfs.o cmds.o debug_btrfs_cmds.o
+debug-btrfs: $(TOPDIR)/lib/libbtrfs.a  debug_btrfs.o cmds.o debug_btrfs_cmds.o debug_tree.o
 	$(CC) $(CFLAGS) -o debug-btrfs $^ $(TOPDIR)/lib/libbtrfs.a $(LDFLAGS) $(LIBS)
 
 clean:
diff --git a/debugbtrfs/debug_btrfs_cmds.ct b/debugbtrfs/debug_btrfs_cmds.ct
index e9890ee..cd40cf4 100644
--- a/debugbtrfs/debug_btrfs_cmds.ct
+++ b/debugbtrfs/debug_btrfs_cmds.ct
@@ -23,5 +23,29 @@ request do_show_debugfs_params, "Show btrfs_debug parameters",
 request do_open_filesys, "Open the file system",
 	open_filesys, open;
 
+request do_dump_tree, "Show full btrfs tree",
+	dump_tree;
+
+request do_dump_extent_tree, "Show Extent tree",
+	dump_extent_tree;
+
+request do_dump_root_tree, "Show root tree",
+	dump_root_tree;
+
+request do_dump_chunk_tree, "Show btrfs chunk tree",
+	dump_chunk_tree;
+
+request do_dump_dev_tree, "Show btrfs dev tree",
+	dump_dev_tree;
+
+request do_dump_fs_tree, "Show btrfs fs tree",
+	dump_fs_tree;
+
+request do_dump_csum_tree, "Show btrfs checksum tree",
+	dump_csum_tree;
+
+request do_dump_log_tree, "Show btrfs log tree",
+	dump_log_tree;
+
 end;
 
diff --git a/debugbtrfs/debug_tree.c b/debugbtrfs/debug_tree.c
new file mode 100644
index 0000000..e92d6d0
--- /dev/null
+++ b/debugbtrfs/debug_tree.c
@@ -0,0 +1,238 @@
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
+#include "kerncompat.h"
+#include "radix-tree.h"
+#include "ctree.h"
+#include "disk-io.h"
+#include "print-tree.h"
+#include "transaction.h"
+#include "debug_btrfs.h"
+
+void do_dump_extent_tree(int argc, char *argv[])
+{
+	if (!current_fs_root) {
+		fprintf(stderr, "File system not yet opened: %s\n", current_device);
+		return;
+	}
+	printf("Extent tree\n");
+	btrfs_print_tree(current_fs_root->fs_info->extent_root,
+				 current_fs_root->fs_info->extent_root->node);
+}
+
+void do_dump_root_tree(int argc, char *argv[])
+{
+	if (!current_fs_root) {
+		fprintf(stderr, "File system not yet opened: %s\n", current_device);
+		return;
+	}
+	printf("root tree\n");
+	btrfs_print_tree(current_fs_root->fs_info->tree_root,
+			 current_fs_root->fs_info->tree_root->node);
+}
+
+void do_dump_chunk_tree(int argc, char *argv[])
+{
+	if (!current_fs_root) {
+		fprintf(stderr, "File system not yet opened: %s\n", current_device);
+		return;
+	}
+	printf("chunk tree\n");
+	btrfs_print_tree(current_fs_root->fs_info->chunk_root,
+				 current_fs_root->fs_info->chunk_root->node);
+}
+
+void do_dump_dev_tree(int argc, char *argv[])
+{
+	if (!current_fs_root) {
+		fprintf(stderr, "File system not yet opened: %s\n", current_device);
+		return;
+	}
+	printf("Device tree\n");
+	btrfs_print_tree(current_fs_root->fs_info->dev_root,
+				 current_fs_root->fs_info->dev_root->node);
+}
+
+void do_dump_fs_tree(int argc, char *argv[])
+{
+	if (!current_fs_root) {
+		fprintf(stderr, "File system not yet opened: %s\n", current_device);
+		return;
+	}
+	printf("FS tree\n");
+	btrfs_print_tree(current_fs_root->fs_info->fs_root,
+				 current_fs_root->fs_info->fs_root->node);
+}
+
+void do_dump_csum_tree(int argc, char *argv[])
+{
+	if (!current_fs_root) {
+		fprintf(stderr, "File system not yet opened: %s\n", current_device);
+		return;
+	}
+	printf("Checksum tree\n");
+	btrfs_print_tree(current_fs_root->fs_info->csum_root,
+				 current_fs_root->fs_info->csum_root->node);
+}
+
+void do_dump_log_tree(int argc, char *argv[])
+{
+	if (!current_fs_root) {
+		fprintf(stderr, "File system not yet opened: %s\n", current_device);
+		return;
+	}
+	printf("Log tree\n");
+	if (!current_fs_root->fs_info->log_root_tree) {
+		printf("Nothing to replay \n");
+		return;
+	}
+	btrfs_print_tree(current_fs_root->fs_info->log_root_tree,
+				 current_fs_root->fs_info->log_root_tree->node);
+}
+
+void do_dump_tree(int argc, char *argv[])
+{
+	struct btrfs_path path;
+	struct btrfs_key key;
+	struct btrfs_root_item ri;
+	struct extent_buffer *leaf;
+	struct btrfs_disk_key disk_key;
+	struct btrfs_key found_key;
+	char uuidbuf[37];
+	int ret;
+	int slot;
+	struct btrfs_root *tree_root_scan;
+
+	if (!current_fs_root) {
+		fprintf(stderr, "File system not yet opened: %s\n", current_device);
+		return;
+	}
+	printf("root tree\n");
+	btrfs_print_tree(current_fs_root->fs_info->tree_root,
+				 current_fs_root->fs_info->tree_root->node);
+
+	printf("chunk tree\n");
+	btrfs_print_tree(current_fs_root->fs_info->chunk_root,
+				 current_fs_root->fs_info->chunk_root->node);
+
+	tree_root_scan = current_fs_root->fs_info->tree_root;
+
+	btrfs_init_path(&path);
+again:
+	key.offset = 0;
+	key.objectid = 0;
+	btrfs_set_key_type(&key, BTRFS_ROOT_ITEM_KEY);
+	ret = btrfs_search_slot(NULL, tree_root_scan, &key, &path, 0, 0);
+	BUG_ON(ret < 0);
+	while(1) {
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
+
+			offset = btrfs_item_ptr_offset(leaf, slot);
+			read_extent_buffer(leaf, &ri, offset, sizeof(ri));
+			buf = read_tree_block(tree_root_scan,
+					      btrfs_root_bytenr(&ri),
+					      tree_root_scan->leafsize, 0);
+			switch(found_key.objectid) {
+			case BTRFS_ROOT_TREE_OBJECTID:
+				printf("root");
+				break;
+			case BTRFS_EXTENT_TREE_OBJECTID:
+				printf("extent");
+				break;
+			case BTRFS_CHUNK_TREE_OBJECTID:
+				printf("chunk");
+				break;
+			case BTRFS_DEV_TREE_OBJECTID:
+				printf("device");
+				break;
+			case BTRFS_FS_TREE_OBJECTID:
+				printf("fs");
+				break;
+			case BTRFS_ROOT_TREE_DIR_OBJECTID:
+				printf("directory");
+				break;
+			case BTRFS_CSUM_TREE_OBJECTID:
+				printf("checksum");
+				break;
+			case BTRFS_ORPHAN_OBJECTID:
+				printf("orphan");
+				break;
+			case BTRFS_TREE_LOG_OBJECTID:
+				printf("log");
+				break;
+			case BTRFS_TREE_LOG_FIXUP_OBJECTID:
+				printf("log fixup");
+				break;
+			case BTRFS_TREE_RELOC_OBJECTID:
+				printf("reloc");
+				break;
+			case BTRFS_DATA_RELOC_TREE_OBJECTID:
+				printf("data reloc");
+				break;
+			case BTRFS_EXTENT_CSUM_OBJECTID:
+				printf("extent checksum");
+				break;
+			case BTRFS_MULTIPLE_OBJECTIDS:
+				printf("multiple");
+				break;
+			default:
+				printf("file");
+			}
+
+			printf(" tree ");
+			btrfs_print_key(&disk_key);
+			printf(" \n");
+			btrfs_print_tree(tree_root_scan, buf);
+
+		}
+		path.slots[0]++;
+	}
+	btrfs_release_path(current_fs_root, &path);
+
+	if (tree_root_scan == current_fs_root->fs_info->tree_root &&
+	    current_fs_root->fs_info->log_root_tree) {
+		tree_root_scan = current_fs_root->fs_info->log_root_tree;
+		goto again;
+	}
+
+	printf("total bytes %llu\n",
+	       (unsigned long long)btrfs_super_total_bytes(&current_fs_root->fs_info->super_copy));
+	printf("bytes used %llu\n",
+	       (unsigned long long)btrfs_super_bytes_used(&current_fs_root->fs_info->super_copy));
+	uuidbuf[36] = '\0';
+	uuid_unparse(current_fs_root->fs_info->super_copy.fsid, uuidbuf);
+	printf("uuid %s\n", uuidbuf);
+	return;
+}
-- 
1.7.0.rc0.48.gdace5

