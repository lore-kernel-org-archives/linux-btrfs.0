Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:59567 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751896AbcBBDBa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Feb 2016 22:01:30 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id C79A2413CD7E
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Feb 2016 11:01:24 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 1/8] btrfs-progs: Basic framework for dedup command group
Date: Tue,  2 Feb 2016 10:59:06 +0800
Message-Id: <1454381953-29676-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1454381953-29676-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1454381953-29676-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add basic ioctl header and command group framework for later use.
Alone with basic man page doc.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/Makefile.in          |  1 +
 Documentation/btrfs-dedup.asciidoc | 39 +++++++++++++++++++++++++++++++
 Documentation/btrfs.asciidoc       |  4 ++++
 Makefile.in                        |  2 +-
 btrfs.c                            |  1 +
 cmds-dedup.c                       | 48 ++++++++++++++++++++++++++++++++++++++
 commands.h                         |  2 ++
 ctree.h                            | 35 ++++++++++++++++++++++++++-
 dedup.h                            | 42 +++++++++++++++++++++++++++++++++
 ioctl.h                            | 21 +++++++++++++++++
 10 files changed, 193 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/btrfs-dedup.asciidoc
 create mode 100644 cmds-dedup.c
 create mode 100644 dedup.h

diff --git a/Documentation/Makefile.in b/Documentation/Makefile.in
index f046abd..9756570 100644
--- a/Documentation/Makefile.in
+++ b/Documentation/Makefile.in
@@ -30,6 +30,7 @@ MAN8_TXT += btrfs-qgroup.asciidoc
 MAN8_TXT += btrfs-replace.asciidoc
 MAN8_TXT += btrfs-restore.asciidoc
 MAN8_TXT += btrfs-property.asciidoc
+MAN8_TXT += btrfs-dedup.asciidoc
 
 # Category 5 manual page
 MAN5_TXT += btrfs-man5.asciidoc
diff --git a/Documentation/btrfs-dedup.asciidoc b/Documentation/btrfs-dedup.asciidoc
new file mode 100644
index 0000000..917977b
--- /dev/null
+++ b/Documentation/btrfs-dedup.asciidoc
@@ -0,0 +1,39 @@
+btrfs-dedup(8)
+==============
+
+NAME
+----
+btrfs-dedup - manage in-band (write time) de-duplication of a btrfs filesystem
+
+SYNOPSIS
+--------
+*btrfs dedup* <subcommand> <args>
+
+DESCRIPTION
+-----------
+*btrfs dedup* is used to enable/disable or show current in-band de-duplication
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
+*btrfs dedup* returns a zero exit status if it succeeds. Non zero is
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
index abf1ff8..27c8883 100644
--- a/Documentation/btrfs.asciidoc
+++ b/Documentation/btrfs.asciidoc
@@ -43,6 +43,10 @@ COMMANDS
 	Do off-line check on a btrfs filesystem. +
 	See `btrfs-check`(8) for details.
 
+*dedup*::
+	Control btrfs in-band(write time) de-duplication. +
+	See `btrfs-dedup`(8) for details.
+
 *device*::
 	Manage devices managed by btrfs, including add/delete/scan and so
 	on. +
diff --git a/Makefile.in b/Makefile.in
index 19697ff..474a67a 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -75,7 +75,7 @@ cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
 	       cmds-restore.o cmds-rescue.o chunk-recover.o super-recover.o \
-	       cmds-property.o cmds-fi-usage.o
+	       cmds-property.o cmds-fi-usage.o cmds-dedup.o
 libbtrfs_objects = send-stream.o send-utils.o rbtree.o btrfs-list.o crc32c.o \
 		   uuid-tree.o utils-lib.o rbtree-utils.o
 libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
diff --git a/btrfs.c b/btrfs.c
index cc70515..3775dfa 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -199,6 +199,7 @@ static const struct cmd_group btrfs_cmd_group = {
 		{ "receive", cmd_receive, cmd_receive_usage, NULL, 0 },
 		{ "quota", cmd_quota, NULL, &quota_cmd_group, 0 },
 		{ "qgroup", cmd_qgroup, NULL, &qgroup_cmd_group, 0 },
+		{ "dedup", cmd_dedup, NULL, &dedup_cmd_group, 0 },
 		{ "replace", cmd_replace, NULL, &replace_cmd_group, 0 },
 		{ "help", cmd_help, cmd_help_usage, NULL, 0 },
 		{ "version", cmd_version, cmd_version_usage, NULL, 0 },
diff --git a/cmds-dedup.c b/cmds-dedup.c
new file mode 100644
index 0000000..800df34
--- /dev/null
+++ b/cmds-dedup.c
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
+#include "dedup.h"
+
+static const char * const dedup_cmd_group_usage[] = {
+	"btrfs dedup <command> [options] <path>",
+	NULL
+};
+
+static const char dedup_cmd_group_info[] =
+"manage inband(write time) de-duplication";
+
+const struct cmd_group dedup_cmd_group = {
+	dedup_cmd_group_usage, dedup_cmd_group_info, {
+		NULL_CMD_STRUCT
+	}
+};
+
+int cmd_dedup(int argc, char **argv)
+{
+	return handle_command_group(&dedup_cmd_group, argc, argv);
+}
diff --git a/commands.h b/commands.h
index 2da093b..cff8104 100644
--- a/commands.h
+++ b/commands.h
@@ -93,6 +93,7 @@ extern const struct cmd_group inspect_cmd_group;
 extern const struct cmd_group property_cmd_group;
 extern const struct cmd_group quota_cmd_group;
 extern const struct cmd_group qgroup_cmd_group;
+extern const struct cmd_group dedup_cmd_group;
 extern const struct cmd_group replace_cmd_group;
 extern const struct cmd_group rescue_cmd_group;
 
@@ -118,6 +119,7 @@ int cmd_send(int argc, char **argv);
 int cmd_receive(int argc, char **argv);
 int cmd_quota(int argc, char **argv);
 int cmd_qgroup(int argc, char **argv);
+int cmd_dedup(int argc, char **argv);
 int cmd_replace(int argc, char **argv);
 int cmd_restore(int argc, char **argv);
 int cmd_select_super(int argc, char **argv);
diff --git a/ctree.h b/ctree.h
index 2e1e631..bbffd1f 100644
--- a/ctree.h
+++ b/ctree.h
@@ -457,6 +457,7 @@ struct btrfs_super_block {
  * ones specified below then we will fail to mount
  */
 #define BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE	(1ULL << 0)
+#define BTRFS_FEATURE_COMPAT_RO_DEDUP		(1ULL << 1)
 
 #define BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF	(1ULL << 0)
 #define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(1ULL << 1)
@@ -483,7 +484,9 @@ struct btrfs_super_block {
 
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
 
-#define BTRFS_FEATURE_COMPAT_RO_SUPP		0ULL
+#define BTRFS_FEATURE_COMPAT_RO_SUPP			\
+	(BTRFS_FEATURE_COMPAT_RO_DEDUP |		\
+	 BTRFS_FEATURE_COMPAT_RO_DEDUP)
 
 #define BTRFS_FEATURE_INCOMPAT_SUPP			\
 	(BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF |		\
@@ -834,6 +837,23 @@ struct btrfs_csum_item {
 	u8 csum;
 } __attribute__ ((__packed__));
 
+struct btrfs_dedup_status_item {
+	__le64 blocksize;
+	__le64 limit_nr;
+	__le16 hash_type;
+	__le16 backend;
+} __attribute__ ((__packed__));
+
+struct btrfs_dedup_hash_item {
+	/* on disk length of dedup range */
+	__le64 len;
+
+	/* Spare space */
+	u8 __unused[16];
+
+	/* Hash follows */
+} __attribute__ ((__packed__));
+
 /*
  * We don't want to overwrite 1M at the beginning of device, even though
  * there is our 1st superblock at 64k. Some possible reasons:
@@ -2072,6 +2092,19 @@ static inline unsigned long btrfs_leaf_data(struct extent_buffer *l)
 	return offsetof(struct btrfs_leaf, items);
 }
 
+/* btrfs_dedup_status */
+BTRFS_SETGET_FUNCS(dedup_status_blocksize, struct btrfs_dedup_status_item,
+		   blocksize, 64);
+BTRFS_SETGET_FUNCS(dedup_status_limit, struct btrfs_dedup_status_item,
+		   limit_nr, 64);
+BTRFS_SETGET_FUNCS(dedup_status_hash_type, struct btrfs_dedup_status_item,
+		   hash_type, 16);
+BTRFS_SETGET_FUNCS(dedup_status_backend, struct btrfs_dedup_status_item,
+		   backend, 16);
+
+/* btrfs_dedup_hash_item */
+BTRFS_SETGET_FUNCS(dedup_hash_len, struct btrfs_dedup_hash_item, len, 64);
+
 /* struct btrfs_file_extent_item */
 BTRFS_SETGET_FUNCS(file_extent_type, struct btrfs_file_extent_item, type, 8);
 BTRFS_SETGET_STACK_FUNCS(stack_file_extent_type, struct btrfs_file_extent_item, type, 8);
diff --git a/dedup.h b/dedup.h
new file mode 100644
index 0000000..58f57f7
--- /dev/null
+++ b/dedup.h
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
+#ifndef __BTRFS_DEDUP__
+#define __BTRFS_DEDUP__
+
+/*
+ * Dedup storage backend
+ * On disk is persist storage but overhead is large
+ * In memory is fast but will lose all its hash on umount
+ */
+#define BTRFS_DEDUP_BACKEND_INMEMORY		0
+#define BTRFS_DEDUP_BACKEND_ONDISK		1
+#define BTRFS_DEDUP_BACKEND_LAST		2
+
+/* Dedup block size limit and default value */
+#define BTRFS_DEDUP_BLOCKSIZE_MAX	(8 * 1024 * 1024)
+#define BTRFS_DEDUP_BLOCKSIZE_MIN	(16 * 1024)
+#define BTRFS_DEDUP_BLOCKSIZE_DEFAULT	(128 * 1024)
+
+/* Default dedup limit on number of hash */
+#define BTRFS_DEDUP_LIMIT_NR_DEFAULT	(32 * 1024)
+
+/* Hash algorithm, only support SHA256 yet */
+#define BTRFS_DEDUP_HASH_SHA256		0
+
+#endif
diff --git a/ioctl.h b/ioctl.h
index 771da23..b19d4e6 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -492,6 +492,27 @@ struct btrfs_ioctl_get_dev_stats {
 	__u64 unused[128 - 2 - BTRFS_DEV_STAT_VALUES_MAX]; /* pad to 1k */
 };
 
+/*
+ * de-duplication control modes
+ * For re-config, enable will handle it
+ */
+#define BTRFS_DEDUP_CTL_ENABLE	1
+#define BTRFS_DEDUP_CTL_DISABLE 2
+#define BTRFS_DEDUP_CTL_STATUS	3
+#define BTRFS_DEDUP_CTL_LAST	4
+struct btrfs_ioctl_dedup_args {
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
2.7.0



