Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:52096 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751499AbdLLGeN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 01:34:13 -0500
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH v10.1 1/5] btrfs-progs: Basic framework for dedupe-inband command group
Date: Tue, 12 Dec 2017 14:32:53 +0800
Message-ID: <20171212063257.31451-2-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20171212063257.31451-1-lufq.fnst@cn.fujitsu.com>
References: <20171212063257.31451-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

Add basic ioctl header and command group framework for later use.
Alone with basic man page doc.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/Makefile.in                  |  1 +
 Documentation/btrfs-dedupe-inband.asciidoc | 40 +++++++++++++++++++++++++++
 Documentation/btrfs.asciidoc               |  4 +++
 Makefile                                   |  2 +-
 btrfs.c                                    |  2 ++
 cmds-dedupe-ib.c                           | 43 ++++++++++++++++++++++++++++++
 commands.h                                 |  2 ++
 dedupe-ib.h                                | 36 +++++++++++++++++++++++++
 ioctl.h                                    | 36 +++++++++++++++++++++++++
 9 files changed, 165 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/btrfs-dedupe-inband.asciidoc
 create mode 100644 cmds-dedupe-ib.c
 create mode 100644 dedupe-ib.h

diff --git a/Documentation/Makefile.in b/Documentation/Makefile.in
index bdc3dc3f..980ee388 100644
--- a/Documentation/Makefile.in
+++ b/Documentation/Makefile.in
@@ -28,6 +28,7 @@ MAN8_TXT += btrfs-qgroup.asciidoc
 MAN8_TXT += btrfs-replace.asciidoc
 MAN8_TXT += btrfs-restore.asciidoc
 MAN8_TXT += btrfs-property.asciidoc
+MAN8_TXT += btrfs-dedupe-inband.asciidoc
 
 # Category 5 manual page
 MAN5_TXT += btrfs-man5.asciidoc
diff --git a/Documentation/btrfs-dedupe-inband.asciidoc b/Documentation/btrfs-dedupe-inband.asciidoc
new file mode 100644
index 00000000..9ee2bc75
--- /dev/null
+++ b/Documentation/btrfs-dedupe-inband.asciidoc
@@ -0,0 +1,40 @@
+btrfs-dedupe(8)
+==============
+
+NAME
+----
+btrfs-dedupe-inband - manage in-band (write time) de-duplication of a btrfs
+filesystem
+
+SYNOPSIS
+--------
+*btrfs dedupe-inband* <subcommand> <args>
+
+DESCRIPTION
+-----------
+*btrfs dedupe-inband* is used to enable/disable or show current in-band de-duplication
+status of a btrfs filesystem.
+
+Kernel support for in-band de-duplication starts from 4.8.
+
+WARNING: In-band de-duplication is still an experimental feautre of btrfs,
+use with caution.
+
+SUBCOMMAND
+----------
+Nothing yet
+
+EXIT STATUS
+-----------
+*btrfs dedupe-inband* returns a zero exit status if it succeeds. Non zero is
+returned in case of failure.
+
+AVAILABILITY
+------------
+*btrfs* is part of btrfs-progs.
+Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
+further details.
+
+SEE ALSO
+--------
+`mkfs.btrfs`(8),
diff --git a/Documentation/btrfs.asciidoc b/Documentation/btrfs.asciidoc
index 100a6adf..64fc0d2c 100644
--- a/Documentation/btrfs.asciidoc
+++ b/Documentation/btrfs.asciidoc
@@ -50,6 +50,10 @@ COMMANDS
 	Do off-line check on a btrfs filesystem. +
 	See `btrfs-check`(8) for details.
 
+*dedupe*::
+	Control btrfs in-band(write time) de-duplication. +
+	See `btrfs-dedupe`(8) for details.
+
 *device*::
 	Manage devices managed by btrfs, including add/delete/scan and so
 	on. +
diff --git a/Makefile b/Makefile
index 6369e8f4..188ee7be 100644
--- a/Makefile
+++ b/Makefile
@@ -113,7 +113,7 @@ cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-restore.o cmds-rescue.o chunk-recover.o super-recover.o \
 	       cmds-property.o cmds-fi-usage.o cmds-inspect-dump-tree.o \
 	       cmds-inspect-dump-super.o cmds-inspect-tree-stats.o cmds-fi-du.o \
-	       mkfs/common.o
+	       mkfs/common.o cmds-dedupe-ib.o
 libbtrfs_objects = send-stream.o send-utils.o kernel-lib/rbtree.o btrfs-list.o \
 		   kernel-lib/crc32c.o messages.o \
 		   uuid-tree.o utils-lib.o rbtree-utils.o
diff --git a/btrfs.c b/btrfs.c
index 2d39f2ce..2168f5a8 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -255,6 +255,8 @@ static const struct cmd_group btrfs_cmd_group = {
 		{ "quota", cmd_quota, NULL, &quota_cmd_group, 0 },
 		{ "qgroup", cmd_qgroup, NULL, &qgroup_cmd_group, 0 },
 		{ "replace", cmd_replace, NULL, &replace_cmd_group, 0 },
+		{ "dedupe-inband", cmd_dedupe_ib, NULL, &dedupe_ib_cmd_group,
+			0 },
 		{ "help", cmd_help, cmd_help_usage, NULL, 0 },
 		{ "version", cmd_version, cmd_version_usage, NULL, 0 },
 		NULL_CMD_STRUCT
diff --git a/cmds-dedupe-ib.c b/cmds-dedupe-ib.c
new file mode 100644
index 00000000..853ec2a7
--- /dev/null
+++ b/cmds-dedupe-ib.c
@@ -0,0 +1,43 @@
+/*
+ * Copyright (C) 2017 Fujitsu.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <getopt.h>
+#include <unistd.h>
+#include <sys/ioctl.h>
+
+#include "ctree.h"
+#include "ioctl.h"
+
+#include "commands.h"
+#include "utils.h"
+#include "kerncompat.h"
+#include "dedupe-ib.h"
+
+static const char * const dedupe_ib_cmd_group_usage[] = {
+	"btrfs dedupe-inband <command> [options] <path>",
+	NULL
+};
+
+static const char dedupe_ib_cmd_group_info[] =
+"manage inband(write time) de-duplication";
+
+const struct cmd_group dedupe_ib_cmd_group = {
+	dedupe_ib_cmd_group_usage, dedupe_ib_cmd_group_info, {
+		NULL_CMD_STRUCT
+	}
+};
+
+int cmd_dedupe_ib(int argc, char **argv)
+{
+	return handle_command_group(&dedupe_ib_cmd_group, argc, argv);
+}
diff --git a/commands.h b/commands.h
index 76991f2b..28b8eec7 100644
--- a/commands.h
+++ b/commands.h
@@ -81,6 +81,7 @@ extern const struct cmd_group quota_cmd_group;
 extern const struct cmd_group qgroup_cmd_group;
 extern const struct cmd_group replace_cmd_group;
 extern const struct cmd_group rescue_cmd_group;
+extern const struct cmd_group dedupe_ib_cmd_group;
 
 extern const char * const cmd_send_usage[];
 extern const char * const cmd_receive_usage[];
@@ -120,5 +121,6 @@ int cmd_select_super(int argc, char **argv);
 int cmd_dump_super(int argc, char **argv);
 int cmd_debug_tree(int argc, char **argv);
 int cmd_rescue(int argc, char **argv);
+int cmd_dedupe_ib(int argc, char **argv);
 
 #endif
diff --git a/dedupe-ib.h b/dedupe-ib.h
new file mode 100644
index 00000000..1ee91716
--- /dev/null
+++ b/dedupe-ib.h
@@ -0,0 +1,36 @@
+/*
+ * Copyright (C) 2017 Fujitsu.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __BTRFS_DEDUPE__
+#define __BTRFS_DEDUPE__
+
+/*
+ * Dedup storage backend
+ * On disk is persist storage but overhead is large
+ * In memory is fast but will lose all its hash on umount
+ */
+#define BTRFS_DEDUPE_BACKEND_INMEMORY		0
+#define BTRFS_DEDUPE_BACKEND_LAST		1
+
+/* Dedup block size limit and default value */
+#define BTRFS_DEDUPE_BLOCKSIZE_MAX	(8 * 1024 * 1024)
+#define BTRFS_DEDUPE_BLOCKSIZE_MIN	(16 * 1024)
+#define BTRFS_DEDUPE_BLOCKSIZE_DEFAULT	(128 * 1024)
+
+/* Default dedupe limit on number of hash */
+#define BTRFS_DEDUPE_LIMIT_NR_DEFAULT	(32 * 1024)
+
+/* Hash algorithm, only support SHA256 yet */
+#define BTRFS_DEDUPE_HASH_SHA256		0
+
+#endif
diff --git a/ioctl.h b/ioctl.h
index 709e996f..8268c035 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -559,6 +559,42 @@ struct btrfs_ioctl_qgroup_create_args {
 };
 BUILD_ASSERT(sizeof(struct btrfs_ioctl_qgroup_create_args) == 16);
 
+/*
+ * de-duplication control modes
+ * For re-config, enable will handle it
+ */
+#define BTRFS_DEDUPE_CTL_ENABLE	1
+#define BTRFS_DEDUPE_CTL_DISABLE 2
+#define BTRFS_DEDUPE_CTL_STATUS	3
+#define BTRFS_DEDUPE_CTL_RECONF	4
+#define BTRFS_DEDUPE_CTL_LAST	5
+
+/*
+ * Allow enable command to be executed on dedupe enabled fs.
+ * Make dedupe_enable ioctl to be stateless.
+ *
+ * Or only dedup_reconf ioctl can be executed on dedupe enabled fs
+ */
+#define BTRFS_DEDUPE_FLAG_FORCE		(1 << 0)
+/*
+ * This structure is used for dedupe enable/disable/configure
+ * and status ioctl.
+ * Reserved range should be set to 0xff.
+ */
+struct btrfs_ioctl_dedupe_args {
+	__u16 cmd;		/* In: command */
+	__u64 blocksize;	/* In/Out: blocksize */
+	__u64 limit_nr;		/* In/Out: limit nr for inmem backend */
+	__u64 limit_mem;	/* In/Out: limit mem for inmem backend */
+	__u64 current_nr;	/* Out: current hash nr */
+	__u16 backend;		/* In/Out: current backend */
+	__u16 hash_algo;	/* In/Out: hash algorithm */
+	u8 status;		/* Out: enabled or disabled */
+	u8 flags;		/* In: special flags for ioctl */
+	u8 __unused[472];	/* Pad to 512 bytes */
+};
+BUILD_ASSERT(sizeof(btrfs_ioctl_dedupe_args) == 512);
+
 struct btrfs_ioctl_timespec {
 	__u64 sec;
 	__u32 nsec;
-- 
2.15.1



