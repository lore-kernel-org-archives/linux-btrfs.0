Return-Path: <SRS0=UqpE=RD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D968C4360F
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 14:45:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B2AF2133D
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 14:45:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732675AbfB1OpB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Feb 2019 09:45:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:53350 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727757AbfB1Oo6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Feb 2019 09:44:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A416EAD05
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Feb 2019 14:44:55 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Cc:     Johannes Thumshirn <jthumshirn@suse.de>
Subject: [RFC PATCH 1/2] btrfs-progs: add 'btrfs inspect-internal csum-dump' command
Date:   Thu, 28 Feb 2019 15:44:31 +0100
Message-Id: <20190228144432.17038-2-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190228144432.17038-1-jthumshirn@suse.de>
References: <20190228144432.17038-1-jthumshirn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Add a 'btrfs inspect-internal csum-dump' command to dump the on-disk
checksums of a file.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 Makefile                 |   3 +-
 cmds-inspect-dump-csum.c | 266 +++++++++++++++++++++++++++++++++++++++++++++++
 cmds-inspect.c           |   2 +
 commands.h               |   2 +
 4 files changed, 272 insertions(+), 1 deletion(-)
 create mode 100644 cmds-inspect-dump-csum.c

diff --git a/Makefile b/Makefile
index e25e256f96af..f5d0c0532faf 100644
--- a/Makefile
+++ b/Makefile
@@ -130,7 +130,8 @@ cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-restore.o cmds-rescue.o chunk-recover.o super-recover.o \
 	       cmds-property.o cmds-fi-usage.o cmds-inspect-dump-tree.o \
 	       cmds-inspect-dump-super.o cmds-inspect-tree-stats.o cmds-fi-du.o \
-	       mkfs/common.o check/mode-common.o check/mode-lowmem.o
+	       cmds-inspect-dump-csum.o mkfs/common.o check/mode-common.o \
+	       check/mode-lowmem.o
 libbtrfs_objects = send-stream.o send-utils.o kernel-lib/rbtree.o btrfs-list.o \
 		   kernel-lib/crc32c.o messages.o \
 		   uuid-tree.o utils-lib.o rbtree-utils.o
diff --git a/cmds-inspect-dump-csum.c b/cmds-inspect-dump-csum.c
new file mode 100644
index 000000000000..beb98abcf08b
--- /dev/null
+++ b/cmds-inspect-dump-csum.c
@@ -0,0 +1,266 @@
+/*
+ * Copyright (C) 2019 SUSE. All rights reserved.
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
+#include <sys/types.h>
+#include <sys/stat.h>
+
+#include <stdlib.h>
+#include <stdio.h>
+#include <errno.h>
+#include <unistd.h>
+#include <string.h>
+#include <fcntl.h>
+
+#include "ctree.h"
+#include "disk-io.h"
+#include "volumes.h"
+#include "help.h"
+#include "utils.h"
+
+#ifdef DEBUG
+#define pr_debug(fmt, ...) printf(fmt, __VA_ARGS__)
+#else
+#define pr_debug(fmt, ...) do {} while (0)
+#endif
+
+static int btrfs_lookup_csum(struct btrfs_root *root, struct btrfs_path *path,
+			     u64 bytenr, u64 extent_len)
+{
+	struct btrfs_key key;
+	int pending_csums;
+	int total_csums;
+	u16 csum_size;
+	int ret;
+
+	key.objectid = BTRFS_EXTENT_CSUM_OBJECTID;
+	key.offset = bytenr;
+	key.type = BTRFS_EXTENT_CSUM_KEY;
+
+	csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
+
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0) {
+		goto out;
+	} else if (ret > 0) {
+		if (path->slots[0] == 0) {
+			ret = -ENOENT;
+			goto out;
+		} else {
+			path->slots[0]--;
+		}
+	}
+
+	pending_csums = total_csums = extent_len / 4096;
+
+	ret = -EINVAL;
+	while (pending_csums) {
+		struct extent_buffer *leaf;
+		struct btrfs_key found_key;
+		struct btrfs_csum_item *ci;
+		u32 item_size;
+		int nr_csums;
+		int slot;
+		int i;
+
+		leaf = path->nodes[0];
+		slot = path->slots[0];
+
+		btrfs_item_key_to_cpu(leaf, &found_key, slot);
+		if (found_key.type != BTRFS_EXTENT_CSUM_KEY)
+			goto out;
+
+		ci = btrfs_item_ptr(leaf, slot, struct btrfs_csum_item);
+		item_size = btrfs_item_size_nr(leaf, slot);
+
+		if (pending_csums < (item_size / 4))
+			nr_csums = pending_csums;
+		else
+			nr_csums = item_size / 4;
+
+		for (i = 0; i < nr_csums; i++) {
+			u32 csum;
+
+			read_extent_buffer(leaf, &csum,
+					   (unsigned long) ci + i * 4,
+					   csum_size);
+			printf("Disk Byte: %llu, Checksum: 0x%08x\n",
+			       bytenr + i * 4096, csum);
+		}
+		pending_csums -= nr_csums;
+
+
+		ret = btrfs_next_item(root, path);
+		if (ret > 0) {
+			ret = 0;
+			break;
+		}
+	}
+
+out:
+	if (ret)
+		error("failed to lookup checksums for extent at %llu", bytenr);
+
+	return ret;
+}
+
+static int btrfs_get_extent_csum(struct btrfs_root *root,
+				 struct btrfs_path *path, unsigned long ino)
+{
+	struct btrfs_fs_info *info = root->fs_info;
+	struct btrfs_key key;
+	int ret;
+
+	key.objectid = ino;
+	key.type = BTRFS_EXTENT_DATA_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0) {
+		goto out;
+	} else if (ret > 0) {
+		if (path->slots[0] == 0) {
+			ret = -ENOENT;
+			goto out;
+		} else {
+			path->slots[0]--;
+		}
+	}
+
+	ret = -EINVAL;
+	while (1) {
+		struct btrfs_file_extent_item *fi;
+		struct btrfs_path *csum_path;
+		struct extent_buffer *leaf;
+		struct btrfs_key found_key;
+		u64 extent_len;
+		u64 bytenr;
+		int slot;
+
+		leaf = path->nodes[0];
+		slot = path->slots[0];
+
+		btrfs_item_key_to_cpu(leaf, &found_key, slot);
+		if (found_key.type != BTRFS_EXTENT_DATA_KEY)
+			goto out;
+
+		fi = btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
+		extent_len = btrfs_file_extent_num_bytes(leaf, fi);
+		bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
+
+		pr_debug("extent start: %llu, len: %llu\n", bytenr, extent_len);
+
+		csum_path = btrfs_alloc_path();
+		ret = btrfs_lookup_csum(info->csum_root, csum_path, bytenr,
+					extent_len);
+		btrfs_release_path(csum_path);
+		if (ret) {
+			error("Error looking up checsum\n");
+			break;
+		}
+
+		ret = btrfs_next_item(root, path);
+		if (ret > 0) {
+			ret = 0;
+			break;
+		}
+	}
+
+out:
+	return ret;
+}
+
+const char * const cmd_inspect_dump_csum_usage[] = {
+	"btrfs inspect-internal dump-csum <path> <device>",
+	"Get Checksums for a given file",
+	NULL
+};
+
+int cmd_inspect_dump_csum(int argc, char **argv)
+{
+	struct btrfs_fs_info *info;
+	struct btrfs_root *root;
+	struct btrfs_path path;
+	struct stat sb;
+	char *filename;
+	u64 rootid;
+	int fd;
+	int ret;
+
+	ret = check_argc_exact(argc, 3);
+	if (ret)
+		usage(cmd_inspect_dump_csum_usage);
+
+	filename = argv[1];
+
+	info = open_ctree_fs_info(argv[2], 0, 0, 0, OPEN_CTREE_PARTIAL);
+	if (!info) {
+		error("unable to open device %s\n", argv[2]);
+		exit(1);
+	}
+
+	ret = stat(filename, &sb);
+	if (ret) {
+		error("cannot stat %s: %s\n", filename, strerror(errno));
+		exit(1);
+	}
+
+	if (sb.st_size < 1024) {
+		error("file smaller than 1KB, aborting\n");
+		exit(1);
+	}
+
+	fd = open(filename, O_RDONLY);
+	ret = lookup_path_rootid(fd, &rootid);
+	if (ret) {
+		error("error looking up subvolume for '%s'\n",
+				filename);
+		goto out_close;
+	}
+
+	pr_debug("%s: '%s' is on subvolume %llu\n", __func__, filename, rootid);
+
+	root = info->fs_root;
+
+	if (rootid != BTRFS_FS_TREE_OBJECTID) {
+		struct btrfs_key key;
+
+		key.objectid = rootid;
+		key.type = BTRFS_ROOT_ITEM_KEY;
+		key.offset = (u64)-1;
+
+		root = btrfs_read_fs_root(info, &key);
+		if (IS_ERR(root)) {
+			error("unable to read root of subvolume '%llu'\n",
+			      rootid);
+			goto out_close;
+		}
+	}
+
+	btrfs_init_path(&path);
+	ret = btrfs_get_extent_csum(root, &path, sb.st_ino);
+	btrfs_release_path(&path);
+	close_ctree(info->fs_root);
+	btrfs_close_all_devices();
+
+	if (ret)
+		error("checsum lookup for file %s (%lu) failed\n",
+			filename, sb.st_ino);
+out_close:
+	close(fd);
+	return ret;
+}
diff --git a/cmds-inspect.c b/cmds-inspect.c
index efea0331b7aa..c533e9f6dc0b 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -654,6 +654,8 @@ const struct cmd_group inspect_cmd_group = {
 				cmd_inspect_dump_super_usage, NULL, 0 },
 		{ "tree-stats", cmd_inspect_tree_stats,
 				cmd_inspect_tree_stats_usage, NULL, 0 },
+		{ "dump-csum", cmd_inspect_dump_csum,
+			cmd_inspect_dump_csum_usage, NULL, 0 },
 		NULL_CMD_STRUCT
 	}
 };
diff --git a/commands.h b/commands.h
index 76991f2b28d5..698ae532b2b8 100644
--- a/commands.h
+++ b/commands.h
@@ -92,6 +92,7 @@ extern const char * const cmd_rescue_usage[];
 extern const char * const cmd_inspect_dump_super_usage[];
 extern const char * const cmd_inspect_dump_tree_usage[];
 extern const char * const cmd_inspect_tree_stats_usage[];
+extern const char * const cmd_inspect_dump_csum_usage[];
 extern const char * const cmd_filesystem_du_usage[];
 extern const char * const cmd_filesystem_usage_usage[];
 
@@ -108,6 +109,7 @@ int cmd_super_recover(int argc, char **argv);
 int cmd_inspect(int argc, char **argv);
 int cmd_inspect_dump_super(int argc, char **argv);
 int cmd_inspect_dump_tree(int argc, char **argv);
+int cmd_inspect_dump_csum(int argc, char **argv);
 int cmd_inspect_tree_stats(int argc, char **argv);
 int cmd_property(int argc, char **argv);
 int cmd_send(int argc, char **argv);
-- 
2.16.4

