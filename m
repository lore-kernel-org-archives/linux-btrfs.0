Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:61618 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbcCVHVq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Mar 2016 03:21:46 -0400
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 5A13B4056404
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Mar 2016 15:21:24 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v6 1/8] btrfs-progs: Basic framework for dedupe command group
Date: Tue, 22 Mar 2016 15:19:14 +0800
Message-Id: <1458631161-19036-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add basic ioctl header and command group framework for later use.
Alone with basic man page doc.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/Makefile.in           |  1 +
 Documentation/btrfs-dedupe.asciidoc | 39 ++++++++++++++++++++++++++++++
 Documentation/btrfs.asciidoc        |  4 ++++
 Makefile.in                         |  3 ++-
 btrfs.c                             |  1 +
 cmds-dedupe.c                       | 48 +++++++++++++++++++++++++++++++++++++
 commands.h                          |  2 ++
 ctree.h                             | 40 ++++++++++++++++++++++++++++++-
 dedupe.h                            | 42 ++++++++++++++++++++++++++++++++
 ioctl.h                             | 21 ++++++++++++++++
 10 files changed, 199 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/btrfs-dedupe.asciidoc
 create mode 100644 cmds-dedupe.c
 create mode 100644 dedupe.h

diff --git a/Documentation/Makefile.in b/Documentation/Makefile.in
index aea2cb4..24fd35e 100644
--- a/Documentation/Makefile.in
+++ b/Documentation/Makefile.in
@@ -28,6 +28,7 @@ MAN8_TXT += btrfs-qgroup.asciidoc
 MAN8_TXT += btrfs-replace.asciidoc
 MAN8_TXT += btrfs-restore.asciidoc
 MAN8_TXT += btrfs-property.asciidoc
+MAN8_TXT += btrfs-dedupe.asciidoc
 
 # Category 5 manual page
 MAN5_TXT += btrfs-man5.asciidoc
diff --git a/Documentation/btrfs-dedupe.asciidoc b/Documentation/btrfs-dedupe.asciidoc
new file mode 100644
index 0000000..5d63c32
--- /dev/null
+++ b/Documentation/btrfs-dedupe.asciidoc
@@ -0,0 +1,39 @@
+btrfs-dedupe(8)
+==============
+
+NAME
+----
+btrfs-dedupe - manage in-band (write time) de-duplication of a btrfs filesystem
+
+SYNOPSIS
+--------
+*btrfs dedupe* <subcommand> <args>
+
+DESCRIPTION
+-----------
+*btrfs dedupe* is used to enable/disable or show current in-band de-duplication
+status of a btrfs filesystem.
+
+Kernel support for in-band de-duplication starts from 4.6.
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
+*btrfs dedupe* returns a zero exit status if it succeeds. Non zero is
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
index 71ef76d..0b6d7de 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -76,7 +76,8 @@ cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
 	       cmds-restore.o cmds-rescue.o chunk-recover.o super-recover.o \
 	       cmds-property.o cmds-fi-usage.o cmds-inspect-dump-tree.o \
-	       cmds-inspect-dump-super.o cmds-inspect-tree-stats.o cmds-fi-du.o
+	       cmds-inspect-dump-super.o cmds-inspect-tree-stats.o cmds-fi-du.o \
+	       cmds-dedupe.o
 libbtrfs_objects = send-stream.o send-utils.o rbtree.o btrfs-list.o crc32c.o \
 		   uuid-tree.o utils-lib.o rbtree-utils.o
 libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
diff --git a/btrfs.c b/btrfs.c
index cc70515..c0c8f27 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -199,6 +199,7 @@ static const struct cmd_group btrfs_cmd_group = {
 		{ "receive", cmd_receive, cmd_receive_usage, NULL, 0 },
 		{ "quota", cmd_quota, NULL, &quota_cmd_group, 0 },
 		{ "qgroup", cmd_qgroup, NULL, &qgroup_cmd_group, 0 },
+		{ "dedupe", cmd_dedupe, NULL, &dedupe_cmd_group, 0 },
 		{ "replace", cmd_replace, NULL, &replace_cmd_group, 0 },
 		{ "help", cmd_help, cmd_help_usage, NULL, 0 },
 		{ "version", cmd_version, cmd_version_usage, NULL, 0 },
diff --git a/cmds-dedupe.c b/cmds-dedupe.c
new file mode 100644
index 0000000..b25b8db
--- /dev/null
+++ b/cmds-dedupe.c
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
+#include "dedupe.h"
+
+static const char * const dedupe_cmd_group_usage[] = {
+	"btrfs dedupe <command> [options] <path>",
+	NULL
+};
+
+static const char dedupe_cmd_group_info[] =
+"manage inband(write time) de-duplication";
+
+const struct cmd_group dedupe_cmd_group = {
+	dedupe_cmd_group_usage, dedupe_cmd_group_info, {
+		NULL_CMD_STRUCT
+	}
+};
+
+int cmd_dedupe(int argc, char **argv)
+{
+	return handle_command_group(&dedupe_cmd_group, argc, argv);
+}
diff --git a/commands.h b/commands.h
index 2da093b..1ae71a1 100644
--- a/commands.h
+++ b/commands.h
@@ -93,6 +93,7 @@ extern const struct cmd_group inspect_cmd_group;
 extern const struct cmd_group property_cmd_group;
 extern const struct cmd_group quota_cmd_group;
 extern const struct cmd_group qgroup_cmd_group;
+extern const struct cmd_group dedupe_cmd_group;
 extern const struct cmd_group replace_cmd_group;
 extern const struct cmd_group rescue_cmd_group;
 
@@ -118,6 +119,7 @@ int cmd_send(int argc, char **argv);
 int cmd_receive(int argc, char **argv);
 int cmd_quota(int argc, char **argv);
 int cmd_qgroup(int argc, char **argv);
+int cmd_dedupe(int argc, char **argv);
 int cmd_replace(int argc, char **argv);
 int cmd_restore(int argc, char **argv);
 int cmd_select_super(int argc, char **argv);
diff --git a/ctree.h b/ctree.h
index 5ab0f4a..d251f65 100644
--- a/ctree.h
+++ b/ctree.h
@@ -457,6 +457,7 @@ struct btrfs_super_block {
  * ones specified below then we will fail to mount
  */
 #define BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE	(1ULL << 0)
+#define BTRFS_FEATURE_COMPAT_RO_DEDUPE		(1ULL << 1)
 
 #define BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF	(1ULL << 0)
 #define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(1ULL << 1)
@@ -484,7 +485,8 @@ struct btrfs_super_block {
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
 
 #define BTRFS_FEATURE_COMPAT_RO_SUPP			\
-	(BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE)
+	(BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE |	\
+	 BTRFS_FEATURE_COMPAT_RO_DEDUPE)
 
 #define BTRFS_FEATURE_INCOMPAT_SUPP			\
 	(BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF |		\
@@ -835,6 +837,25 @@ struct btrfs_csum_item {
 	u8 csum;
 } __attribute__ ((__packed__));
 
+struct btrfs_dedupe_status_item {
+	__le64 blocksize;
+	__le64 limit_nr;
+	__le16 hash_type;
+	__le16 backend;
+} __attribute__ ((__packed__));
+
+struct btrfs_dedupe_hash_item {
+	/* length of dedupe range in memory */
+	__le32 len;
+
+	/* length of dedupe range on disk */
+	__le32 disk_len;
+
+	u8 compression;
+
+	/* Hash follows */
+} __attribute__ ((__packed__));
+
 /*
  * We don't want to overwrite 1M at the beginning of device, even though
  * there is our 1st superblock at 64k. Some possible reasons:
@@ -2074,6 +2095,23 @@ static inline unsigned long btrfs_leaf_data(struct extent_buffer *l)
 	return offsetof(struct btrfs_leaf, items);
 }
 
+/* btrfs_dedupe_status */
+BTRFS_SETGET_FUNCS(dedupe_status_blocksize, struct btrfs_dedupe_status_item,
+		   blocksize, 64);
+BTRFS_SETGET_FUNCS(dedupe_status_limit, struct btrfs_dedupe_status_item,
+		   limit_nr, 64);
+BTRFS_SETGET_FUNCS(dedupe_status_hash_type, struct btrfs_dedupe_status_item,
+		   hash_type, 16);
+BTRFS_SETGET_FUNCS(dedupe_status_backend, struct btrfs_dedupe_status_item,
+		   backend, 16);
+
+/* btrfs_dedupe_hash_item */
+BTRFS_SETGET_FUNCS(dedupe_hash_len, struct btrfs_dedupe_hash_item, len, 32);
+BTRFS_SETGET_FUNCS(dedupe_hash_disk_len, struct btrfs_dedupe_hash_item,
+		   disk_len, 32);
+BTRFS_SETGET_FUNCS(dedupe_hash_compression, struct btrfs_dedupe_hash_item,
+		   compression, 8);
+
 /* struct btrfs_file_extent_item */
 BTRFS_SETGET_FUNCS(file_extent_type, struct btrfs_file_extent_item, type, 8);
 BTRFS_SETGET_STACK_FUNCS(stack_file_extent_type, struct btrfs_file_extent_item, type, 8);
diff --git a/dedupe.h b/dedupe.h
new file mode 100644
index 0000000..ad3dab0
--- /dev/null
+++ b/dedupe.h
@@ -0,0 +1,42 @@
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
+#define BTRFS_DEDUPE_BACKEND_ONDISK		1
+#define BTRFS_DEDUPE_BACKEND_LAST		2
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
index cab9ec2..8b1a512 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -503,6 +503,27 @@ struct btrfs_ioctl_get_dev_stats {
 	__u64 unused[128 - 2 - BTRFS_DEV_STAT_VALUES_MAX]; /* pad to 1k */
 };
 
+/*
+ * de-duplication control modes
+ * For re-config, enable will handle it
+ */
+#define BTRFS_DEDUPE_CTL_ENABLE	1
+#define BTRFS_DEDUPE_CTL_DISABLE 2
+#define BTRFS_DEDUPE_CTL_STATUS	3
+#define BTRFS_DEDUPE_CTL_LAST	4
+struct btrfs_ioctl_dedupe_args {
+	__u16 cmd;		/* In: command(see above macro) */
+	__u64 blocksize;	/* In/Out: For enable/status */
+	__u64 limit_nr;		/* In/Out: For enable/status */
+	__u64 limit_mem;	/* In/Out: For enable/status */
+	__u64 current_nr;	/* Out: For status output */
+	__u16 backend;		/* In/Out: For enable/status */
+	__u16 hash_type;	/* In/Out: For enable/status */
+	u8 status;		/* Out: For status output */
+	/* pad to 512 bytes */
+	u8 __unused[473];
+};
+
 /* BTRFS_IOC_SNAP_CREATE is no longer used by the btrfs command */
 #define BTRFS_QUOTA_CTL_ENABLE	1
 #define BTRFS_QUOTA_CTL_DISABLE	2
-- 
2.7.4



