Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19254 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760302Ab3GaPiN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Jul 2013 11:38:13 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r6VFcCKm006078
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 31 Jul 2013 15:38:13 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6VFcCjp006202
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 31 Jul 2013 15:38:12 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6VFcCk9006197
	for <linux-btrfs@vger.kernel.org>; Wed, 31 Jul 2013 15:38:12 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: add dedup subcommand
Date: Wed, 31 Jul 2013 23:37:46 +0800
Message-Id: <1375285066-14173-7-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1375285066-14173-1-git-send-email-bo.li.liu@oracle.com>
References: <1375285066-14173-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This aims to add deduplication subcommand, 'btrfs dedup command <path>',
ie. register/unregister'.

It can be used to enable or disable dedup support for a filesystem.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 Makefile     |    2 +-
 btrfs.c      |    1 +
 cmds-dedup.c |  101 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 commands.h   |    2 +
 ctree.h      |    2 +
 ioctl.h      |    5 +++
 6 files changed, 112 insertions(+), 1 deletions(-)
 create mode 100644 cmds-dedup.c

diff --git a/Makefile b/Makefile
index da7438e..5b4a07d 100644
--- a/Makefile
+++ b/Makefile
@@ -10,7 +10,7 @@ objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
-	       cmds-restore.o
+	       cmds-restore.o cmds-dedup.o
 libbtrfs_objects = send-stream.o send-utils.o rbtree.o btrfs-list.o crc32c.o
 libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
 	       crc32c.h list.h kerncompat.h radix-tree.h extent-cache.h \
diff --git a/btrfs.c b/btrfs.c
index 691adef..956905c 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -254,6 +254,7 @@ const struct cmd_group btrfs_cmd_group = {
 		{ "quota", cmd_quota, NULL, &quota_cmd_group, 0 },
 		{ "qgroup", cmd_qgroup, NULL, &qgroup_cmd_group, 0 },
 		{ "replace", cmd_replace, NULL, &replace_cmd_group, 0 },
+		{ "dedup", cmd_dedup, NULL, &dedup_cmd_group, 0 },
 		{ "help", cmd_help, cmd_help_usage, NULL, 0 },
 		{ "version", cmd_version, cmd_version_usage, NULL, 0 },
 		{ 0, 0, 0, 0, 0 }
diff --git a/cmds-dedup.c b/cmds-dedup.c
new file mode 100644
index 0000000..a977585
--- /dev/null
+++ b/cmds-dedup.c
@@ -0,0 +1,101 @@
+/*
+ * Copyright (C) 2013 Oracle.  All rights reserved.
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
+#include <sys/ioctl.h>
+#include <unistd.h>
+
+#include "ctree.h"
+#include "ioctl.h"
+
+#include "commands.h"
+#include "utils.h"
+
+static const char * const dedup_cmd_group_usage[] = {
+	"btrfs dedup <command> [options] <path>",
+	NULL
+};
+
+int dedup_ctl(int cmd, int argc, char **argv)
+{
+	int ret = 0;
+	int fd;
+	int e;
+	char *path = argv[1];
+
+	if (check_argc_exact(argc, 2))
+		return -1;
+
+	fd = open_file_or_dir(path);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access '%s'\n", path);
+		return -EACCES;
+	}
+
+	ret = ioctl(fd, BTRFS_IOC_DEDUP_CTL, cmd);
+	e = errno;
+	close(fd);
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: dedup command failed: %s\n",
+			strerror(e));
+		if (cmd == BTRFS_DEDUP_CTL_UNREG)
+			fprintf(stderr, "please refer to 'dmesg | tail' for more info\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static const char * const cmd_dedup_reg_usage[] = {
+	"btrfs dedup register <path>",
+	"Enable data deduplication support for a filesystem.",
+	NULL
+};
+
+static int cmd_dedup_reg(int argc, char **argv)
+{
+	int ret = dedup_ctl(BTRFS_DEDUP_CTL_REG, argc, argv);
+	if (ret < 0)
+		usage(cmd_dedup_reg_usage);
+	return ret;
+}
+
+static const char * const cmd_dedup_unreg_usage[] = {
+	"btrfs dedup unregister <path>",
+	"Disable data deduplication support for a filesystem.",
+	NULL
+};
+
+static int cmd_dedup_unreg(int argc, char **argv)
+{
+	int ret = dedup_ctl(BTRFS_DEDUP_CTL_UNREG, argc, argv);
+	if (ret < 0)
+		usage(cmd_dedup_unreg_usage);
+	return ret;
+}
+
+const struct cmd_group dedup_cmd_group = {
+	dedup_cmd_group_usage, NULL, {
+		{ "register", cmd_dedup_reg, cmd_dedup_reg_usage, NULL, 0 },
+		{ "unregister", cmd_dedup_unreg, cmd_dedup_unreg_usage, 0, 0 },
+		{ 0, 0, 0, 0, 0 }
+	}
+};
+
+int cmd_dedup(int argc, char **argv)
+{
+	return handle_command_group(&dedup_cmd_group, argc, argv);
+}
diff --git a/commands.h b/commands.h
index 15c616d..d31afa4 100644
--- a/commands.h
+++ b/commands.h
@@ -90,6 +90,7 @@ extern const struct cmd_group receive_cmd_group;
 extern const struct cmd_group quota_cmd_group;
 extern const struct cmd_group qgroup_cmd_group;
 extern const struct cmd_group replace_cmd_group;
+extern const struct cmd_group dedup_cmd_group;
 
 extern const char * const cmd_send_usage[];
 extern const char * const cmd_receive_usage[];
@@ -112,6 +113,7 @@ int cmd_restore(int argc, char **argv);
 int cmd_select_super(int argc, char **argv);
 int cmd_dump_super(int argc, char **argv);
 int cmd_debug_tree(int argc, char **argv);
+int cmd_dedup(int argc, char **argv);
 
 /* subvolume exported functions */
 int test_issubvolume(char *path);
diff --git a/ctree.h b/ctree.h
index 6f086bf..e86ff96 100644
--- a/ctree.h
+++ b/ctree.h
@@ -467,6 +467,7 @@ struct btrfs_super_block {
 #define BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF	(1ULL << 6)
 #define BTRFS_FEATURE_INCOMPAT_RAID56		(1ULL << 7)
 #define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
+#define BTRFS_FEATURE_INCOMPAT_DEDUP		(1ULL << 9)
 
 
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
@@ -479,6 +480,7 @@ struct btrfs_super_block {
 	 BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF |		\
 	 BTRFS_FEATURE_INCOMPAT_RAID56 |		\
 	 BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS |		\
+	 BTRFS_FEATURE_INCOMPAT_DEDUP |			\
 	 BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA)
 
 /*
diff --git a/ioctl.h b/ioctl.h
index abe6dd4..fba1898 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -417,6 +417,10 @@ struct btrfs_ioctl_get_dev_stats {
 	__u64 unused[128 - 2 - BTRFS_DEV_STAT_VALUES_MAX]; /* pad to 1k */
 };
 
+/* deduplication control ioctl modes */
+#define BTRFS_DEDUP_CTL_REG 1
+#define BTRFS_DEDUP_CTL_UNREG 2
+
 /* BTRFS_IOC_SNAP_CREATE is no longer used by the btrfs command */
 #define BTRFS_QUOTA_CTL_ENABLE	1
 #define BTRFS_QUOTA_CTL_DISABLE	2
@@ -537,6 +541,7 @@ struct btrfs_ioctl_clone_range_args {
 				      struct btrfs_ioctl_get_dev_stats)
 #define BTRFS_IOC_DEV_REPLACE _IOWR(BTRFS_IOCTL_MAGIC, 53, \
 				    struct btrfs_ioctl_dev_replace_args)
+#define BTRFS_IOC_DEDUP_CTL _IOW(BTRFS_IOCTL_MAGIC, 55, int)
 
 #ifdef __cplusplus
 }
-- 
1.7.7

