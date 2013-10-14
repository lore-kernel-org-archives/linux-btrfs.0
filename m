Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31085 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab3JNFBZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Oct 2013 01:01:25 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r9E51OaL000746
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Oct 2013 05:01:24 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r9E51NvG000693
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Oct 2013 05:01:23 GMT
Received: from abhmt102.oracle.com (abhmt102.oracle.com [141.146.116.54])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r9E51MB0007440
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Oct 2013 05:01:22 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3] Btrfs-progs: add dedup subcommand
Date: Mon, 14 Oct 2013 12:59:56 +0800
Message-Id: <1381726796-27191-15-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1381726796-27191-1-git-send-email-bo.li.liu@oracle.com>
References: <1381726796-27191-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This adds deduplication subcommands, 'btrfs dedup command <path>',
including enable/disable/on/off.

- btrfs dedup enable
Create the dedup tree, and it's the very first step when you're going to use
the dedup feature.

- btrfs dedup disable
Delete the dedup tree, after this we're not able to use dedup any more unless
you enable it again.

- btrfs dedup on [-b]
Switch on the dedup feature temporarily, and it's the second step of applying
dedup with writes.  Option '-b' is used to set dedup blocksize.
The default blocksize is 8192(no special reason, you may argue), and the current
limit is [4096, 128 * 1024], because 4K is the generic page size and 128K is the
upper limit of btrfs's compression.

- btrfs dedup off
Switch off the dedup feature temporarily, but the dedup tree remains.

---------------------------------------------------------
Usage:
Step 1: btrfs dedup enable /btrfs
Step 2: btrfs dedup on /btrfs or btrfs dedup on -b 4K /btrfs
Step 3: now we have dedup, run your test.
Step 4: btrfs dedup off /btrfs
Step 5: btrfs dedup disable /btrfs
---------------------------------------------------------

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v3: add commands 'btrfs dedup on/off'
v2: add manpage

 Makefile       |    2 +-
 btrfs.c        |    1 +
 cmds-dedup.c   |  177 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 commands.h     |    2 +
 ctree.h        |    2 +
 ioctl.h        |   11 ++++
 man/btrfs.8.in |   24 ++++++++
 7 files changed, 218 insertions(+), 1 deletions(-)
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
index 0000000..38b6841
--- /dev/null
+++ b/cmds-dedup.c
@@ -0,0 +1,177 @@
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
+#include <getopt.h>
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
+int dedup_ctl(char *path, struct btrfs_ioctl_dedup_args *args)
+{
+	int ret = 0;
+	int fd;
+	int e;
+
+	fd = open_file_or_dir(path);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access '%s'\n", path);
+		return -EACCES;
+	}
+
+	ret = ioctl(fd, BTRFS_IOC_DEDUP_CTL, args);
+	e = errno;
+	close(fd);
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: dedup command failed: %s\n",
+			strerror(e));
+		if (args->cmd == BTRFS_DEDUP_CTL_DISABLE ||
+		    args->cmd == BTRFS_DEDUP_CTL_SET_BS)
+			fprintf(stderr, "please refer to 'dmesg | tail' for more info\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static const char * const cmd_dedup_enable_usage[] = {
+	"btrfs dedup enable <path>",
+	"Enable data deduplication support for a filesystem.",
+	NULL
+};
+
+static int cmd_dedup_enable(int argc, char **argv)
+{
+	struct btrfs_ioctl_dedup_args dargs;
+
+	if (check_argc_exact(argc, 2))
+		usage(cmd_dedup_enable_usage);
+
+	dargs.cmd = BTRFS_DEDUP_CTL_ENABLE;
+
+	return dedup_ctl(argv[1], &dargs);
+}
+
+static const char * const cmd_dedup_disable_usage[] = {
+	"btrfs dedup disable <path>",
+	"Disable data deduplication support for a filesystem.",
+	NULL
+};
+
+static int cmd_dedup_disable(int argc, char **argv)
+{
+	struct btrfs_ioctl_dedup_args dargs;
+
+	if (check_argc_exact(argc, 2))
+		usage(cmd_dedup_disable_usage);
+
+	dargs.cmd = BTRFS_DEDUP_CTL_DISABLE;
+
+	return dedup_ctl(argv[1], &dargs);
+}
+
+static int dedup_set_bs(char *path, struct btrfs_ioctl_dedup_args *dargs)
+{
+	return dedup_ctl(path, dargs);
+}
+
+static const char * const cmd_dedup_on_usage[] = {
+	"btrfs dedup on [-b|--bs size] <path>",
+	"Switch on data deduplication or change the dedup blocksize.",
+	"",
+	"-b|--bs <size>  set dedup blocksize",
+	NULL
+};
+
+static struct option longopts[] = {
+	{"bs", required_argument, NULL, 'b'},
+	{0, 0, 0, 0}
+};
+
+static int cmd_dedup_on(int argc, char **argv)
+{
+	struct btrfs_ioctl_dedup_args dargs;
+	u64 bs = 8192;
+
+	optind = 1;
+	while (1) {
+		int longindex;
+
+		int c = getopt_long(argc, argv, "b:", longopts, &longindex);
+		if (c < 0)
+			break;
+
+		switch (c) {
+		case 'b':
+			bs = parse_size(optarg);
+			break;
+		default:
+			usage(cmd_dedup_on_usage);
+		}
+	}
+
+	if (check_argc_exact(argc - optind, 1))
+		usage(cmd_dedup_on_usage);
+
+	dargs.cmd = BTRFS_DEDUP_CTL_SET_BS;
+	dargs.bs = bs;
+
+	return dedup_set_bs(argv[optind], &dargs);
+}
+
+static const char * const cmd_dedup_off_usage[] = {
+	"btrfs dedup off <path>",
+	"Switch off data deduplication.",
+	NULL
+};
+
+static int cmd_dedup_off(int argc, char **argv)
+{
+	struct btrfs_ioctl_dedup_args dargs;
+
+	if (check_argc_exact(argc, 2))
+		usage(cmd_dedup_off_usage);
+
+	dargs.cmd = BTRFS_DEDUP_CTL_SET_BS;
+	dargs.bs = 0;
+
+	return dedup_set_bs(argv[1], &dargs);
+}
+
+const struct cmd_group dedup_cmd_group = {
+	dedup_cmd_group_usage, NULL, {
+		{ "enable", cmd_dedup_enable, cmd_dedup_enable_usage, NULL, 0 },
+		{ "disable", cmd_dedup_disable, cmd_dedup_disable_usage, 0, 0 },
+		{ "on", cmd_dedup_on, cmd_dedup_on_usage, NULL, 0},
+		{ "off", cmd_dedup_off, cmd_dedup_off_usage, NULL, 0},
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
index abe6dd4..dc7b6a2 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -417,6 +417,15 @@ struct btrfs_ioctl_get_dev_stats {
 	__u64 unused[128 - 2 - BTRFS_DEV_STAT_VALUES_MAX]; /* pad to 1k */
 };
 
+/* deduplication control ioctl modes */
+#define BTRFS_DEDUP_CTL_ENABLE 1
+#define BTRFS_DEDUP_CTL_DISABLE 2
+#define BTRFS_DEDUP_CTL_SET_BS 3
+struct btrfs_ioctl_dedup_args {
+	__u64 cmd;
+	__u64 bs;
+};
+
 /* BTRFS_IOC_SNAP_CREATE is no longer used by the btrfs command */
 #define BTRFS_QUOTA_CTL_ENABLE	1
 #define BTRFS_QUOTA_CTL_DISABLE	2
@@ -537,6 +546,8 @@ struct btrfs_ioctl_clone_range_args {
 				      struct btrfs_ioctl_get_dev_stats)
 #define BTRFS_IOC_DEV_REPLACE _IOWR(BTRFS_IOCTL_MAGIC, 53, \
 				    struct btrfs_ioctl_dev_replace_args)
+#define BTRFS_IOC_DEDUP_CTL _IOWR(BTRFS_IOCTL_MAGIC, 55, \
+				  struct btrfs_ioctl_dedup_args)
 
 #ifdef __cplusplus
 }
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index af7df4d..887a81e 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -74,6 +74,14 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBqgroup limit\fP [options] \fI<size>\fP|\fBnone\fP [\fI<qgroupid>\fP] \fI<path>\fP
 .PP
+\fBbtrfs\fP \fBdedup enable <path> \fP\fI\fP
+.PP
+\fBbtrfs\fP \fBdedup disable <path> \fP\fI\fP
+.PP
+\fBbtrfs\fP \fBdedup on [-b|--bs size] <path> \fP\fI\fP
+.PP
+\fBbtrfs\fP \fBdedup off <path> \fP\fI\fP
+.PP
 \fBbtrfs\fP \fBhelp|\-\-help \fP\fI\fP
 .PP
 \fBbtrfs\fP \fB<command> \-\-help \fP\fI\fP
@@ -489,6 +497,22 @@ Show all subvolume quota groups.
 
 \fBbtrfs\fP \fBqgroup limit\fP [options] \fI<size>\fP|\fBnone\fP [\fI<qgroupid>\fP] \fI<path>\fP
 Limit the size of a subvolume quota group.
+.TP
+
+\fBbtrfs dedup enable\fP \fI<path>\fP
+Enable data deduplication support for a filesystem.
+.TP
+
+\fBbtrfs dedup disable\fP \fI<path>\fP
+Disable data deduplication support for a filesystem.
+.TP
+
+\fBbtrfs dedup on [-b|--bs size]\fP \fI<path>\fP
+Switch on data deduplication or change the dedup blocksize.
+.TP
+
+\fBbtrfs dedup off\fP \fI<path>\fP
+Switch off data deduplication.
 .RE
 
 .SH EXIT STATUS
-- 
1.7.7

