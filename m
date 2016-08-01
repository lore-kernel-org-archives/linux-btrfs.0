Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:5028 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751422AbcHAGbb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Aug 2016 02:31:31 -0400
Received: from adam-work.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 4B2664056404
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Aug 2016 14:29:45 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs-progs: inspect: Introduce dump-send-stream subcommand
Date: Mon,  1 Aug 2016 14:29:43 +0800
Message-Id: <20160801062944.25355-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160801062944.25355-1-quwenruo@cn.fujitsu.com>
References: <20160801062944.25355-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new subcommand "dump-send-stream" for "inspect-internal"
command group.

It will exam and output all operations inside a send stream.
It's quite a useful tool to learn and dig kernel send stream.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/btrfs-inspect-internal.asciidoc |  8 +++
 Makefile.in                                   |  3 +-
 cmds-inspect-dump-send.c                      | 84 +++++++++++++++++++++++++++
 cmds-inspect-dump-send.h                      | 24 ++++++++
 cmds-inspect.c                                |  3 +
 5 files changed, 121 insertions(+), 1 deletion(-)
 create mode 100644 cmds-inspect-dump-send.c
 create mode 100644 cmds-inspect-dump-send.h

diff --git a/Documentation/btrfs-inspect-internal.asciidoc b/Documentation/btrfs-inspect-internal.asciidoc
index 74f6dea..8ba768d 100644
--- a/Documentation/btrfs-inspect-internal.asciidoc
+++ b/Documentation/btrfs-inspect-internal.asciidoc
@@ -146,6 +146,14 @@ Print sizes and statistics of trees.
 -b::::
 Print raw numbers in bytes.
 
+*dump-send-stream [options]*::
+exam and output all operations inside a send stream. Read from 'stdin' by default.
++
+`Options`
++
+-f|--file <file>::::
+Read from file instead of 'stdin'.
+
 EXIT STATUS
 -----------
 *btrfs inspect-internal* returns a zero exit status if it succeeds. Non zero is
diff --git a/Makefile.in b/Makefile.in
index 97caf95..00bf639 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -86,7 +86,8 @@ cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
 	       cmds-restore.o cmds-rescue.o chunk-recover.o super-recover.o \
 	       cmds-property.o cmds-fi-usage.o cmds-inspect-dump-tree.o \
-	       cmds-inspect-dump-super.o cmds-inspect-tree-stats.o cmds-fi-du.o
+	       cmds-inspect-dump-super.o cmds-inspect-tree-stats.o \
+	       cmds-fi-du.o cmds-inspect-dump-send.o
 libbtrfs_objects = send-stream.o send-utils.o rbtree.o btrfs-list.o crc32c.o \
 		   uuid-tree.o utils-lib.o rbtree-utils.o
 libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
diff --git a/cmds-inspect-dump-send.c b/cmds-inspect-dump-send.c
new file mode 100644
index 0000000..46a3cd6
--- /dev/null
+++ b/cmds-inspect-dump-send.c
@@ -0,0 +1,84 @@
+/*
+ * Copyright (C) 2016 Fujitsu.  All rights reserved.
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
+ * License along with this program.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <errno.h>
+#include <getopt.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include "kerncompat.h"
+#include "ctree.h"
+#include "send-dump.h"
+#include "send-stream.h"
+#include "utils.h"
+#include "commands.h"
+
+const char * const cmd_inspect_dump_send_usage[] = {
+	"btrfs inspect-internal dump-send-stream [options]",
+	"Dump the operations of a send stream from stdin",
+	"-f|--file <file>    read send stream from file",
+	"-h|--help           print this message",
+	NULL
+};
+
+int cmd_inspect_dump_send(int argc, char **argv)
+{
+	struct btrfs_dump_send_args dump_args;
+	int fd = 0;
+	int ret;
+
+	while (1) {
+		int c;
+		static const struct option long_options[] = {
+			{ "file", required_argument, NULL, 'f' },
+			{ "help", no_argument, NULL, 'h' },
+			{ NULL, 0, NULL, 0 }
+		};
+
+		c = getopt_long(argc, argv, "f:h", long_options, NULL);
+		if (c < 0)
+			break;
+		switch(c) {
+		case 'f':
+			fd = open(optarg, O_RDONLY, 0666);
+			if (fd < 0) {
+				error("cannot open %s: %s", optarg,
+				      strerror(errno));
+				exit(1);
+			}
+			break;
+		case 'h':
+		default:
+			usage(cmd_inspect_dump_send_usage);
+			break;
+		}
+	}
+	dump_args.root_path = malloc(PATH_MAX);
+	dump_args.root_path[0] = '.';
+	dump_args.root_path[1] = '\0';
+	dump_args.full_subvol_path = malloc(PATH_MAX);
+	dump_args.full_subvol_path[0] = '.';
+	dump_args.full_subvol_path[1] = '\0';
+
+	ret = btrfs_read_and_process_send_stream(fd, &btrfs_print_send_ops,
+			&dump_args, 0, 0);
+	if (ret < 0)
+		error("failed to read the send stream: %s\n", strerror(-ret));
+	close(fd);
+	return ret;
+}
diff --git a/cmds-inspect-dump-send.h b/cmds-inspect-dump-send.h
new file mode 100644
index 0000000..49c8034
--- /dev/null
+++ b/cmds-inspect-dump-send.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright (C) 2016 Fujitsu.  All rights reserved.
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
+ * License along with this program.
+ */
+
+#ifndef __CMDS_INSPECT_DUMP_SEND_H__
+#define __CMDS_INSPECT_DUMP_SEND_H__
+
+int cmd_inspect_dump_send(int argc, char **argv);
+
+extern const char * const cmd_inspect_dump_send_usage[];
+
+#endif
diff --git a/cmds-inspect.c b/cmds-inspect.c
index 4b7cea0..98653d5 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -34,6 +34,7 @@
 #include "cmds-inspect-dump-tree.h"
 #include "cmds-inspect-dump-super.h"
 #include "cmds-inspect-tree-stats.h"
+#include "cmds-inspect-dump-send.h"
 
 static const char * const inspect_cmd_group_usage[] = {
 	"btrfs inspect-internal <command> <args>",
@@ -642,6 +643,8 @@ const struct cmd_group inspect_cmd_group = {
 				cmd_inspect_dump_super_usage, NULL, 0 },
 		{ "tree-stats", cmd_inspect_tree_stats,
 				cmd_inspect_tree_stats_usage, NULL, 0 },
+		{ "dump-send-stream", cmd_inspect_dump_send,
+				cmd_inspect_dump_send_usage, NULL, 0 },
 		NULL_CMD_STRUCT
 	}
 };
-- 
2.9.0



