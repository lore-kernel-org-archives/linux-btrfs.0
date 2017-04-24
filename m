Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-04.prod.phx3.secureserver.net ([184.168.200.145]:37018
        "EHLO p3nlsmtpcp01-04.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1171054AbdDXNc7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Apr 2017 09:32:59 -0400
Received: from [117.202.244.131] (port=19206 helo=giis.co.in)
        by p3plcpnl0639.prod.phx3.secureserver.net with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.87)
        (envelope-from <Lakshmipathi.G@giis.co.in>)
        id 1d2e5h-0006at-Hu
        for linux-btrfs@vger.kernel.org; Mon, 24 Apr 2017 06:31:58 -0700
Date: Mon, 24 Apr 2017 19:01:18 +0530
From: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: Introduce 'btrfs inspect-internal dump-csum'
 option
Message-ID: <20170424133118.GA11898@giis.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Example usage:
btrfs inspect-internal dump-csum /btrfs/50gbfile /dev/sda4
csum for /btrfs/50gbfile dumped to /btrfs/50gbfile.csumdump

Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
---
 Makefile                 |   3 +-
 cmds-inspect-dump-csum.c | 256 +++++++++++++++++++++++++++++++++++++++++++++++
 cmds-inspect-dump-csum.h |  24 +++++
 cmds-inspect.c           |   3 +
 4 files changed, 285 insertions(+), 1 deletion(-)
 create mode 100644 cmds-inspect-dump-csum.c
 create mode 100644 cmds-inspect-dump-csum.h

diff --git a/Makefile b/Makefile
index 81598df..6e63e18 100644
--- a/Makefile
+++ b/Makefile
@@ -102,7 +102,7 @@ cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-restore.o cmds-rescue.o chunk-recover.o super-recover.o \
 	       cmds-property.o cmds-fi-usage.o cmds-inspect-dump-tree.o \
 	       cmds-inspect-dump-super.o cmds-inspect-tree-stats.o cmds-fi-du.o \
-	       mkfs/common.o
+	       cmds-inspect-dump-csum.o mkfs/common.o
 libbtrfs_objects = send-stream.o send-utils.o kernel-lib/rbtree.o btrfs-list.o \
 		   kernel-lib/crc32c.o messages.o \
 		   uuid-tree.o utils-lib.o rbtree-utils.o
@@ -191,6 +191,7 @@ btrfs_convert_cflags = -DBTRFSCONVERT_EXT2=$(BTRFSCONVERT_EXT2)
 btrfs_fragments_libs = -lgd -lpng -ljpeg -lfreetype
 btrfs_debug_tree_objects = cmds-inspect-dump-tree.o
 btrfs_show_super_objects = cmds-inspect-dump-super.o
+btrfs_dump_csum_objects = cmds-inspect-dump-csum.o
 btrfs_calc_size_objects = cmds-inspect-tree-stats.o
 
 # collect values of the variables above
diff --git a/cmds-inspect-dump-csum.c b/cmds-inspect-dump-csum.c
new file mode 100644
index 0000000..6065eb4
--- /dev/null
+++ b/cmds-inspect-dump-csum.c
@@ -0,0 +1,256 @@
+/*
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
+#include "kerncompat.h"
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/stat.h>
+#include <ctype.h>
+#include <uuid/uuid.h>
+#include <errno.h>
+#include <getopt.h>
+
+#include "ctree.h"
+#include "disk-io.h"
+#include "print-tree.h"
+#include "transaction.h"
+#include "list.h"
+#include "utils.h"
+#include "commands.h"
+#include "crc32c.h"
+#include "cmds-inspect-dump-csum.h"
+#include "help.h"
+#include "volumes.h"
+
+
+const char * const cmd_inspect_dump_csum_usage[] = {
+	"btrfs inspect-internal dump-csum <path/to/file> <device>",
+	"Get csums for the given file.",
+	NULL
+};
+
+int btrfs_lookup_csums(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+	struct btrfs_path *path, u64 bytenr, int cow, int total_csums, FILE *fp)
+{
+	int ret;
+	int i;
+	int start_pos = 0;
+	struct btrfs_key file_key;
+	struct btrfs_key found_key;
+	struct btrfs_csum_item *item;
+	struct extent_buffer *leaf;
+	u64 csum_offset = 0;
+	u16 csum_size =
+		btrfs_super_csum_size(root->fs_info->super_copy);
+	int csums_in_item = 0;
+	unsigned int tree_csum = 0;
+	int pending_csums = total_csums;
+	static int cnt=1;
+
+	file_key.objectid = BTRFS_EXTENT_CSUM_OBJECTID;
+	file_key.offset = bytenr;
+	file_key.type = BTRFS_EXTENT_CSUM_KEY;
+	ret = btrfs_search_slot(trans, root, &file_key, path, 0, cow);
+	if (ret < 0)
+		goto fail;
+	while(1){
+		leaf = path->nodes[0];
+		if (ret > 0) {
+			ret = 1;
+			if (path->slots[0] == 0)
+				goto fail; 
+			path->slots[0]--;
+			btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
+			if (found_key.type != BTRFS_EXTENT_CSUM_KEY){
+				fprintf(stderr, "\nInvalid key found.");
+				goto fail;
+			}
+
+			csum_offset = ((bytenr - found_key.offset) / root->sectorsize) * csum_size;
+			csums_in_item = btrfs_item_size_nr(leaf, path->slots[0]);
+			csums_in_item /= csum_size;
+			csums_in_item -= ( bytenr - found_key.offset ) / root->sectorsize;
+			start_pos=csum_offset;
+		}
+		if (path->slots[0] >= btrfs_header_nritems(leaf)) {
+			if (pending_csums > 0){
+				ret = btrfs_next_leaf(root, path);
+				if (ret == 0)
+				      continue;
+			}
+		}
+		item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_csum_item);
+		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
+		if (!ret){
+			start_pos=0;
+			csum_offset = ( bytenr - found_key.offset ) / root->sectorsize;
+			csums_in_item = btrfs_item_size_nr(leaf, path->slots[0]);
+			csums_in_item /= csum_size;
+		}
+		if (csums_in_item > pending_csums){
+			//possibly,some other csums on this item.
+			for(i = 0; i < pending_csums; i++, cnt++){
+			read_extent_buffer(leaf, &tree_csum, 
+					(unsigned long)item + ((i*4)+start_pos) , csum_size);
+			fprintf(fp, "%x ", tree_csum);
+			if (cnt % 8 == 0)
+				fprintf(fp, "\n");
+			}
+			pending_csums = 0;
+			return 0;
+		}else{
+			for(i = 0; i < csums_in_item; i++, cnt++){
+			read_extent_buffer(leaf, &tree_csum, 
+					(unsigned long)item+((i*4)+start_pos), csum_size);
+			fprintf(fp, "%x ", tree_csum);
+			if (cnt % 8 == 0)
+				fprintf(fp, "\n");
+			}
+		}
+		pending_csums -= csums_in_item;
+		ret = 0;
+		if (pending_csums > 0){
+			path->slots[0]++;
+
+		}else
+			return 0; 
+	
+	}
+fail:
+	fprintf(stderr, "btrfs_lookup_csums search failed.");
+	if (ret > 0)
+		ret = -ENOENT;
+	return ret;
+}
+
+int btrfs_lookup_extent(struct btrfs_fs_info *info, struct btrfs_path *path,
+		u64 ino, int cow, FILE *fp){
+	struct btrfs_key key;
+	struct btrfs_key found_key;
+	struct btrfs_file_extent_item *fi;
+	struct extent_buffer *leaf;
+	struct btrfs_root *fs_root;
+	int ret = -1;
+	int slot;
+	int total_csums = 0;
+	u64 bytenr;
+	u64 itemnum = 0;
+	struct btrfs_path *path1 = NULL;
+
+	fs_root = info->fs_root;
+	key.objectid = ino;
+	key.type = BTRFS_EXTENT_DATA_KEY;
+	key.offset = 0;
+	ret = btrfs_search_slot(NULL,fs_root,&key,path,0,0);
+
+	if(ret < 0)
+		goto error;
+
+	if (ret > 1){
+		fprintf(stderr, "Unable to find the entry");
+		return ret;
+	}
+
+	while(1){
+		leaf = path->nodes[0];
+		slot = path->slots[0];
+		if (slot >=  btrfs_header_nritems(leaf)){
+		       ret = btrfs_next_leaf(fs_root, path);
+			       if (ret == 0)
+				      continue;
+			       if (ret < 0)
+				      goto error;
+		}
+		btrfs_item_key_to_cpu(leaf, &found_key, slot);
+		if (found_key.type != BTRFS_EXTENT_DATA_KEY){
+			btrfs_release_path(path);
+			return -EINVAL;
+		}
+
+		fi = btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
+		bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
+		total_csums=(btrfs_file_extent_num_bytes(leaf, fi) / 1024) / 4;
+		path->slots[0]++;
+		itemnum++;
+		path1 = btrfs_alloc_path();
+	 	ret = btrfs_lookup_csums(NULL,info->csum_root, path1, bytenr, 0,
+			       	total_csums, fp);
+		btrfs_release_path(path1);
+		if (ret) {
+			fprintf(stderr, "\n Error: btrfs_lookup_csum");
+			return 1;
+		}
+	}
+
+error:
+	btrfs_release_path(path);
+	return ret;
+}
+
+int cmd_inspect_dump_csum(int argc, char **argv)
+{
+	struct btrfs_fs_info *info;
+	int ret;
+	struct btrfs_path path;
+	FILE *fp;
+	struct stat st;
+	char *filename;
+	char *outfile;
+
+	if (check_argc_exact(argc, 3))
+		usage(cmd_inspect_dump_csum_usage);
+
+	filename = argv[1];
+	info = open_ctree_fs_info(argv[2], 0, 0, 0, OPEN_CTREE_PARTIAL);
+	if (!info) {
+		fprintf(stderr, "unable to open %s\n", argv[2]);
+	        exit(1);
+	}
+
+	ret = stat(filename, &st);
+	if (ret < 0)	{
+		fprintf(stderr, "unable to open %s\n", filename);
+		exit(1);
+	}
+
+	if(st.st_size < 1024){
+		fprintf(stderr, "file less than 1KB.abort%lu", (st.st_size ));
+		exit(1);
+	}
+
+	btrfs_init_path(&path);
+	ret = asprintf(&outfile, "%s.csumdump", filename);
+	if (ret == -1){
+		fprintf(stderr, "memory allocation failed.");
+		return -1;
+	}
+	fp = fopen(outfile, "w+");
+	if (NULL == fp) {
+		fprintf(stderr, "Unable to open %s file", outfile);
+		free(outfile);
+		return -1;
+	}
+	ret = btrfs_lookup_extent(info, &path, st.st_ino, 0, fp);
+	fclose(fp);
+	ret = close_ctree(info->fs_root);
+	btrfs_close_all_devices();
+
+	fprintf(stdout, "csum for %s dumped to %s\n ", filename, outfile);
+	free(outfile);
+	return ret;
+}
diff --git a/cmds-inspect-dump-csum.h b/cmds-inspect-dump-csum.h
new file mode 100644
index 0000000..05d1a8f
--- /dev/null
+++ b/cmds-inspect-dump-csum.h
@@ -0,0 +1,24 @@
+/*
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
+ *
+ * Authors: Lakshmipathi.G <lakshmipathi.g@giis.co.in>
+ */
+
+#ifndef __CMDS_INSPECT_DUMP_CSUM_H__
+#define __CMDS_INSPECT_DUMP_CSUM_H__
+
+int cmd_inspect_dump_csum(int argc, char **argv);
+
+extern const char * const cmd_inspect_dump_csum_usage[];
+
+#endif
diff --git a/cmds-inspect.c b/cmds-inspect.c
index 58b5956..3d248d0 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -34,6 +34,7 @@
 #include "cmds-inspect-dump-tree.h"
 #include "cmds-inspect-dump-super.h"
 #include "cmds-inspect-tree-stats.h"
+#include "cmds-inspect-dump-csum.h"
 #include "help.h"
 
 static const char * const inspect_cmd_group_usage[] = {
@@ -650,6 +651,8 @@ const struct cmd_group inspect_cmd_group = {
 				cmd_inspect_dump_super_usage, NULL, 0 },
 		{ "tree-stats", cmd_inspect_tree_stats,
 				cmd_inspect_tree_stats_usage, NULL, 0 },
+		{ "dump-csum", cmd_inspect_dump_csum,
+				cmd_inspect_dump_csum_usage, NULL, 0 },
 		NULL_CMD_STRUCT
 	}
 };
-- 
2.7.4

