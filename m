Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:1693 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752074AbbL2IB6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Dec 2015 03:01:58 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id 7780C4092578
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Dec 2015 16:01:11 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/7] btrfs-progs: Basic framework for dedup command group
Date: Tue, 29 Dec 2015 16:01:03 +0800
Message-ID: <1451376069-30414-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1451376069-30414-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1451376069-30414-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add basic ioctl header and command group framework for later use.
Alone with basic man page doc.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/btrfs-dedup.asciidoc | 37 +++++++++++++++++++++++++++++
 Makefile.in                        |  2 +-
 btrfs.c                            |  1 +
 cmds-dedup.c                       | 48 ++++++++++++++++++++++++++++++++++++++
 commands.h                         |  2 ++
 ctree.h                            | 34 ++++++++++++++++++++++++++-
 dedup.h                            | 39 +++++++++++++++++++++++++++++++
 ioctl.h                            | 21 +++++++++++++++++
 8 files changed, 182 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/btrfs-dedup.asciidoc
 create mode 100644 cmds-dedup.c
 create mode 100644 dedup.h

diff --git a/Documentation/btrfs-dedup.asciidoc b/Documentation/btrfs-dedup.asciidoc
new file mode 100644
index 0000000..354313f
--- /dev/null
+++ b/Documentation/btrfs-dedup.asciidoc
@@ -0,0 +1,37 @@
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
+WARNING: In-band de-duplication is still a experimental feautre of btrfs,
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
diff --git a/Makefile.in b/Makefile.in
index 8e24808..f1fb54c 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -74,7 +74,7 @@ cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
 	       cmds-restore.o cmds-rescue.o chunk-recover.o super-recover.o \
-	       cmds-property.o cmds-fi-usage.o
+	       cmds-property.o cmds-fi-usage.o cmds-dedup.o
 libbtrfs_objects = send-stream.o send-utils.o rbtree.o btrfs-list.o crc32c.o \
 		   uuid-tree.o utils-lib.o rbtree-utils.o
 libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
diff --git a/btrfs.c b/btrfs.c
index 14b556b..0774ebb 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -208,6 +208,7 @@ static const struct cmd_group btrfs_cmd_group = {
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
index d2bb093..26d1af3 100644
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
index c57f9ca..20305de 100644
--- a/ctree.h
+++ b/ctree.h
@@ -476,9 +476,11 @@ struct btrfs_super_block {
 #define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
 #define BTRFS_FEATURE_INCOMPAT_NO_HOLES		(1ULL << 9)
 
+#define BTRFS_FEATURE_COMPAT_RO_DEDUP		(1ULL << 0)
 
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
-#define BTRFS_FEATURE_COMPAT_RO_SUPP		0ULL
+#define BTRFS_FEATURE_COMPAT_RO_SUPP			\
+	(BTRFS_FEATURE_COMPAT_RO_DEDUP)
 #define BTRFS_FEATURE_INCOMPAT_SUPP			\
 	(BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF |		\
 	 BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL |	\
@@ -828,6 +830,23 @@ struct btrfs_csum_item {
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
@@ -2032,6 +2051,19 @@ static inline unsigned long btrfs_leaf_data(struct extent_buffer *l)
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
index 0000000..d9efc9c
--- /dev/null
+++ b/dedup.h
@@ -0,0 +1,39 @@
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
+#define BTRFS_DEDUP_BLOCKSIZE_MAX	(128 * 1024)
+#define BTRFS_DEDUP_BLOCKSIZE_MIN	(16 * 1024)
+#define BTRFS_DEDUP_BLOCKSIZE_DEFAULT	(32 * 1024)
+
+/* Hash algorithm, only support SHA256 yet */
+#define BTRFS_DEDUP_HASH_SHA256		0
+
+#endif
diff --git a/ioctl.h b/ioctl.h
index dff015a..7c9221d 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -466,6 +466,27 @@ struct btrfs_ioctl_get_dev_stats {
 	__u64 unused[128 - 2 - BTRFS_DEV_STAT_VALUES_MAX]; /* pad to 1k */
 };
 
+/*
+ * de-duplication control modes
+ * For re-config, re-enable will handle it
+ * TODO: Add support to disable per-file/dir dedup operation
+ */
+#define BTRFS_DEDUP_CTL_ENABLE	1
+#define BTRFS_DEDUP_CTL_DISABLE 2
+#define BTRFS_DEDUP_CTL_STATUS	3
+#define BTRFS_DEDUP_CTL_LAST	4
+struct btrfs_ioctl_dedup_args {
+	__u16 cmd;		/* In: command(see above macro) */
+	__u64 blocksize;	/* In/Out: For enable/status */
+	__u64 limit_nr;		/* In/Out: For enable/status */
+	__u64 current_nr;	/* Out: For status output */
+	__u16 backend;		/* In/Out: For enable/status */
+	__u16 hash_type;	/* In/Out: For enable/status */
+	u8 status;		/* Out: For status output */
+	/* pad to 512 bytes */
+	u8 __unused[489];
+};
+
 /* BTRFS_IOC_SNAP_CREATE is no longer used by the btrfs command */
 #define BTRFS_QUOTA_CTL_ENABLE	1
 #define BTRFS_QUOTA_CTL_DISABLE	2
-- 
2.6.4



