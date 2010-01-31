From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 2/4] btrfs-progs: Add debug-btrfs command
Date: Sun, 31 Jan 2010 19:51:36 +0530
Message-ID: <1264947698-32371-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1264947698-32371-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1264947698-32371-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 Makefile                       |    3 +
 debugbtrfs/Makefile            |   44 +++++++
 debugbtrfs/cmds.c              |   27 +++++
 debugbtrfs/debug_btrfs.c       |   59 ++++++++++
 debugbtrfs/debug_btrfs.h       |   29 +++++
 debugbtrfs/debug_btrfs_cmds.ct |   33 ++++++
 debugbtrfs/debug_tree.c        |  243 ++++++++++++++++++++++++++++++++++++++++
 7 files changed, 438 insertions(+), 0 deletions(-)
 create mode 100644 debugbtrfs/Makefile
 create mode 100644 debugbtrfs/cmds.c
 create mode 100644 debugbtrfs/debug_btrfs.c
 create mode 100644 debugbtrfs/debug_btrfs.h
 create mode 100644 debugbtrfs/debug_btrfs_cmds.ct
 create mode 100644 debugbtrfs/debug_tree.c

diff --git a/Makefile b/Makefile
index a30c212..3efd405 100644
--- a/Makefile
+++ b/Makefile
@@ -12,6 +12,9 @@ bindir = $(prefix)/bin
 LIBS=-luuid
 
 SUBDIRS=lib misc man
+ifneq ($(E2FSPRGS_BUILD_DIR),)
+	SUBDIRS += debugbtrfs
+endif
 
 # make C=1 to enable sparse
 ifdef C
diff --git a/debugbtrfs/Makefile b/debugbtrfs/Makefile
new file mode 100644
index 0000000..d9d3720
--- /dev/null
+++ b/debugbtrfs/Makefile
@@ -0,0 +1,44 @@
+CC=gcc
+AM_CFLAGS = -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2
+CFLAGS = -g -Werror -Os -I$(E2FSPRGS_BUILD_DIR)/lib/ -I../lib/
+
+#
+CHECKFLAGS=-D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise \
+		-Wuninitialized -Wshadow -Wundef
+DEPFLAGS = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
+
+INSTALL= install
+prefix ?= /usr/local
+bindir = $(prefix)/bin
+LIBS=-L$(E2FSPRGS_BUILD_DIR)/lib/ss -lss -ldl -lcom_err -luuid
+TOPDIR=../
+
+MK_CMDS= _SS_DIR_OVERRIDE=$(E2FSPRGS_BUILD_DIR)/lib/ss $(E2FSPRGS_BUILD_DIR)/lib/ss/mk_cmds
+
+progs = debug-btrfs
+
+# make C=1 to enable sparse
+ifdef C
+	check=sparse $(CHECKFLAGS)
+else
+	check=ls
+endif
+
+.c.o:
+	$(check) $<
+	$(CC) $(DEPFLAGS) $(AM_CFLAGS) $(CFLAGS) -c $<
+
+all: $(progs)
+
+debug_btrfs_cmds.c: debug_btrfs_cmds.ct
+	$(MK_CMDS) debug_btrfs_cmds.ct
+
+debug-btrfs: $(TOPDIR)/lib/libbtrfs.a  debug_btrfs.o cmds.o debug_btrfs_cmds.o debug_tree.o
+	$(CC) $(CFLAGS) -o debug-btrfs debug_btrfs.o cmds.o debug_btrfs_cmds.o debug_tree.o $(TOPDIR)/lib/libbtrfs.a $(LDFLAGS) $(LIBS)
+
+clean:
+	rm -f *.o debug_btrfs_cmds.c
+	rm -f .*.d
+	rm -f debug-btrfs
+
+-include .*.d
diff --git a/debugbtrfs/cmds.c b/debugbtrfs/cmds.c
new file mode 100644
index 0000000..f5ed877
--- /dev/null
+++ b/debugbtrfs/cmds.c
@@ -0,0 +1,27 @@
+/*
+ * Copyright IBM Corporation, 2010
+ * Author Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
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
+#include "debug_btrfs.h"
+
+void do_show_debugfs_params(int argc, char *argv[])
+{
+        FILE *out = stdout;
+        fprintf(out, "Filesystem in use: %s\n", current_device);
+}
diff --git a/debugbtrfs/debug_btrfs.c b/debugbtrfs/debug_btrfs.c
new file mode 100644
index 0000000..44d6f64
--- /dev/null
+++ b/debugbtrfs/debug_btrfs.c
@@ -0,0 +1,59 @@
+/*
+ * Copyright IBM Corporation, 2010
+ * Author Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
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
+#include <ss/ss.h>
+#include "debug_btrfs.h"
+
+extern ss_request_table btrfs_debug_cmds;
+const char *current_device;
+
+void usage(char *prg)
+{
+	fprintf(stderr, "Usage: %s device\n", prg);
+	exit(1);
+}
+
+int main(int argc, char *argv[])
+{
+	int sci_idx;
+	int retval;
+
+	if (argc < 2)
+		usage(argv[0]);
+
+	current_device = argv[1];
+	sci_idx = ss_create_invocation("debug-btrfs", "0.0", NULL,
+				&btrfs_debug_cmds, &retval);
+	if (retval) {
+		ss_perror(sci_idx, retval, "create invocation");
+		exit(1);
+	}
+	ss_get_readline(sci_idx);
+	(void) ss_add_request_table (sci_idx, &ss_std_requests, 1, &retval);
+        if (retval) {
+                ss_perror(sci_idx, retval, "adding standard requests");
+                exit (1);
+        }
+	ss_listen(sci_idx);
+	ss_delete_invocation(sci_idx);
+
+	return 0;
+}
diff --git a/debugbtrfs/debug_btrfs.h b/debugbtrfs/debug_btrfs.h
new file mode 100644
index 0000000..55d7b17
--- /dev/null
+++ b/debugbtrfs/debug_btrfs.h
@@ -0,0 +1,29 @@
+/*
+ * Copyright IBM Corporation, 2010
+ * Author Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
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
+#ifndef DEBUG_BTRFS_H
+#define DEBUG_BTRFS_H
+#include <getopt.h>
+
+extern const char *current_device;
+static inline void reset_getopt(void)
+{
+	optind = 0;
+}
+#endif
diff --git a/debugbtrfs/debug_btrfs_cmds.ct b/debugbtrfs/debug_btrfs_cmds.ct
new file mode 100644
index 0000000..bd2e479
--- /dev/null
+++ b/debugbtrfs/debug_btrfs_cmds.ct
@@ -0,0 +1,33 @@
+# Copyright IBM Corporation, 2010
+# Author Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public
+# License v2 as published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+# General Public License for more details.
+#
+# You should have received a copy of the GNU General Public
+# License along with this program; if not, write to the
+# Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+# Boston, MA 021110-1307, USA.
+
+command_table btrfs_debug_cmds;
+
+request do_show_debugfs_params, "Show btrfs_debug parameters",
+	show_debugfs_params, params;
+
+request do_dump_tree, "Show full btrfs tree",
+	dump_tree;
+
+request do_dump_root_tree, "Show root tree",
+	dump_root_tree;
+
+request do_dump_chunk_tree, "Show btrfs chunk tree",
+	dump_chunk_tree;
+
+end;
+
diff --git a/debugbtrfs/debug_tree.c b/debugbtrfs/debug_tree.c
new file mode 100644
index 0000000..1a1e5e2
--- /dev/null
+++ b/debugbtrfs/debug_tree.c
@@ -0,0 +1,243 @@
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
+static void print_dump_tree_usage(void)
+{
+	fprintf(stderr, "usage: dump-tree [ -e ] \n");
+}
+
+void do_dump_root_tree(int argc, char *argv[])
+{
+	struct btrfs_root *root;
+
+	radix_tree_init();
+	root = open_ctree(current_device, 0, 0);
+	if (!root) {
+		fprintf(stderr, "unable to open %s\n", current_device);
+		return;
+	}
+	printf("root tree\n");
+	btrfs_print_tree(root->fs_info->tree_root,
+			 root->fs_info->tree_root->node);
+}
+
+void do_dump_chunk_tree(int argc, char *argv[])
+{
+	struct btrfs_root *root;
+	radix_tree_init();
+	root = open_ctree(current_device, 0, 0);
+	if (!root) {
+		fprintf(stderr, "unable to open %s\n", current_device);
+		return;
+	}
+	printf("chunk tree\n");
+	btrfs_print_tree(root->fs_info->chunk_root,
+				 root->fs_info->chunk_root->node);
+}
+
+void do_dump_tree(int argc, char *argv[])
+{
+	struct btrfs_root *root;
+	struct btrfs_path path;
+	struct btrfs_key key;
+	struct btrfs_root_item ri;
+	struct extent_buffer *leaf;
+	struct btrfs_disk_key disk_key;
+	struct btrfs_key found_key;
+	char uuidbuf[37];
+	int ret;
+	int slot;
+	int extent_only = 0;
+	struct btrfs_root *tree_root_scan;
+
+	radix_tree_init();
+	reset_getopt();
+	while(1) {
+		int c;
+		c = getopt(argc, argv, "e");
+		if (c < 0)
+			break;
+		switch(c) {
+			case 'e':
+				extent_only = 1;
+				break;
+			default:
+				print_dump_tree_usage();
+				return;
+		}
+	}
+
+	root = open_ctree(current_device, 0, 0);
+	if (!root) {
+		fprintf(stderr, "unable to open %s\n", current_device);
+		return;
+	}
+	if (!extent_only) {
+		printf("root tree\n");
+		btrfs_print_tree(root->fs_info->tree_root,
+				 root->fs_info->tree_root->node);
+
+		printf("chunk tree\n");
+		btrfs_print_tree(root->fs_info->chunk_root,
+				 root->fs_info->chunk_root->node);
+	}
+	tree_root_scan = root->fs_info->tree_root;
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
+			int skip = extent_only;
+
+			offset = btrfs_item_ptr_offset(leaf, slot);
+			read_extent_buffer(leaf, &ri, offset, sizeof(ri));
+			buf = read_tree_block(tree_root_scan,
+					      btrfs_root_bytenr(&ri),
+					      tree_root_scan->leafsize, 0);
+			switch(found_key.objectid) {
+			case BTRFS_ROOT_TREE_OBJECTID:
+				if (!skip)
+					printf("root");
+				break;
+			case BTRFS_EXTENT_TREE_OBJECTID:
+				skip = 0;
+				printf("extent");
+				break;
+			case BTRFS_CHUNK_TREE_OBJECTID:
+				if (!skip) {
+					printf("chunk");
+				}
+				break;
+			case BTRFS_DEV_TREE_OBJECTID:
+				if (!skip) {
+					printf("device");
+				}
+				break;
+			case BTRFS_FS_TREE_OBJECTID:
+				if (!skip) {
+					printf("fs");
+				}
+				break;
+			case BTRFS_ROOT_TREE_DIR_OBJECTID:
+				if (!skip) {
+					printf("directory");
+				}
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
+			if (!skip) {
+				printf(" tree ");
+				btrfs_print_key(&disk_key);
+				printf(" \n");
+				btrfs_print_tree(tree_root_scan, buf);
+			}
+		}
+		path.slots[0]++;
+	}
+	btrfs_release_path(root, &path);
+
+	if (tree_root_scan == root->fs_info->tree_root &&
+	    root->fs_info->log_root_tree) {
+		tree_root_scan = root->fs_info->log_root_tree;
+		goto again;
+	}
+
+	if (extent_only)
+		return;
+
+	printf("total bytes %llu\n",
+	       (unsigned long long)btrfs_super_total_bytes(&root->fs_info->super_copy));
+	printf("bytes used %llu\n",
+	       (unsigned long long)btrfs_super_bytes_used(&root->fs_info->super_copy));
+	uuidbuf[36] = '\0';
+	uuid_unparse(root->fs_info->super_copy.fsid, uuidbuf);
+	printf("uuid %s\n", uuidbuf);
+	return;
+}
-- 
1.7.0.rc0.48.gdace5

