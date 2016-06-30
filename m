Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:20606 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbcF3J16 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jun 2016 05:27:58 -0400
Received: from adam-work.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 43E434056403
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Jun 2016 17:24:32 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v9 1/5] btrfs-progs: Basic framework for dedupe-inband command group
Date: Thu, 30 Jun 2016 17:24:27 +0800
Message-Id: <20160630092431.27636-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160630092431.27636-1-quwenruo@cn.fujitsu.com>
References: <20160630092431.27636-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add basic ioctl header and command group framework for later use.
Alone with basic man page doc.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/Makefile.in                  |  1 +
 Documentation/btrfs-dedupe-inband.asciidoc | 40 +++++++++++++++++++++++++
 Documentation/btrfs.asciidoc               |  4 +++
 Makefile.in                                |  3 +-
 btrfs.c                                    |  2 ++
 cmds-dedupe-ib.c                           | 48 ++++++++++++++++++++++++++++++
 commands.h                                 |  2 ++
 dedupe-ib.h                                | 41 +++++++++++++++++++++++++
 ioctl.h                                    | 35 ++++++++++++++++++++++
 9 files changed, 175 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/btrfs-dedupe-inband.asciidoc
 create mode 100644 cmds-dedupe-ib.c
 create mode 100644 dedupe-ib.h

diff --git a/Documentation/Makefile.in b/Documentation/Makefile.in
index aea2cb4..7db4164 100644
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
index 0000000..9ee2bc7
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
index 6a77a85..8ded842 100644
--- a/Documentation/btrfs.asciidoc
+++ b/Documentation/btrfs.asciidoc
@@ -43,6 +43,10 @@ COMMANDS
 	Do off-line check on a btrfs filesystem. +
 	See `btrfs-check`(8) for details.
 
+*dedupe*::
+	Control btrfs in-band(write time) de-duplication. +
+	See `btrfs-dedupe`(8) for details.
+
 *device*::
 	Manage devices managed by btrfs, including add/delete/scan and so
 	on. +
diff --git a/Makefile.in b/Makefile.in
index ac6b353..5cf0fc2 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -86,7 +86,8 @@ cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
 	       cmds-restore.o cmds-rescue.o chunk-recover.o super-recover.o \
 	       cmds-property.o cmds-fi-usage.o cmds-inspect-dump-tree.o \
-	       cmds-inspect-dump-super.o cmds-inspect-tree-stats.o cmds-fi-du.o
+	       cmds-inspect-dump-super.o cmds-inspect-tree-stats.o cmds-fi-du.o \
+	       cmds-dedupe-ib.o
 libbtrfs_objects = send-stream.o send-utils.o rbtree.o btrfs-list.o crc32c.o \
 		   uuid-tree.o utils-lib.o rbtree-utils.o
 libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
diff --git a/btrfs.c b/btrfs.c
index cc70515..06c211b 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -199,6 +199,8 @@ static const struct cmd_group btrfs_cmd_group = {
 		{ "receive", cmd_receive, cmd_receive_usage, NULL, 0 },
 		{ "quota", cmd_quota, NULL, &quota_cmd_group, 0 },
 		{ "qgroup", cmd_qgroup, NULL, &qgroup_cmd_group, 0 },
+		{ "dedupe-inband", cmd_dedupe_ib, NULL, &dedupe_ib_cmd_group,
+			0 },
 		{ "replace", cmd_replace, NULL, &replace_cmd_group, 0 },
 		{ "help", cmd_help, cmd_help_usage, NULL, 0 },
 		{ "version", cmd_version, cmd_version_usage, NULL, 0 },
diff --git a/cmds-dedupe-ib.c b/cmds-dedupe-ib.c
new file mode 100644
index 0000000..160c8ec
--- /dev/null
+++ b/cmds-dedupe-ib.c
@@ -0,0 +1,48 @@
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
index 94229c1..2002c45 100644
--- a/commands.h
+++ b/commands.h
@@ -93,6 +93,7 @@ extern const struct cmd_group inspect_cmd_group;
 extern const struct cmd_group property_cmd_group;
 extern const struct cmd_group quota_cmd_group;
 extern const struct cmd_group qgroup_cmd_group;
+extern const struct cmd_group dedupe_ib_cmd_group;
 extern const struct cmd_group replace_cmd_group;
 extern const struct cmd_group rescue_cmd_group;
 
@@ -118,6 +119,7 @@ int cmd_send(int argc, char **argv);
 int cmd_receive(int argc, char **argv);
 int cmd_quota(int argc, char **argv);
 int cmd_qgroup(int argc, char **argv);
+int cmd_dedupe_ib(int argc, char **argv);
 int cmd_replace(int argc, char **argv);
 int cmd_restore(int argc, char **argv);
 int cmd_select_super(int argc, char **argv);
diff --git a/dedupe-ib.h b/dedupe-ib.h
new file mode 100644
index 0000000..02c5f8f
--- /dev/null
+++ b/dedupe-ib.h
@@ -0,0 +1,41 @@
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
index 5f18bcb..e698ef7 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -503,6 +503,41 @@ struct btrfs_ioctl_get_dev_stats {
 	__u64 unused[128 - 2 - BTRFS_DEV_STAT_VALUES_MAX]; /* pad to 1k */
 };
 
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
+
 /* BTRFS_IOC_SNAP_CREATE is no longer used by the btrfs command */
 #define BTRFS_QUOTA_CTL_ENABLE	1
 #define BTRFS_QUOTA_CTL_DISABLE	2
-- 
2.9.0



