Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:25269 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756232Ab2HJNvJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Aug 2012 09:51:09 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs progs: quota groups support
Date: Fri, 10 Aug 2012 15:51:07 +0200
Message-Id: <1344606667-11727-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Arne Jansen <sensille@gmx.net>

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
Signed-off-by: Arne Jansen <sensille@gmx.net>
---
This is the rebased version of Arne's qgroup patch set. He's the
original author, which is why I'm sending with his author tag.
---
 Makefile         |    4 +-
 btrfs.c          |    2 +
 cmds-qgroup.c    |  454 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 cmds-quota.c     |  117 ++++++++++++++
 cmds-subvolume.c |   83 +++++++++--
 commands.h       |    7 +
 ctree.h          |   91 +++++++++++
 debug-tree.c     |    6 +
 ioctl.h          |   66 ++++++++-
 print-tree.c     |   90 +++++++++++-
 qgroup.c         |  140 +++++++++++++++++
 qgroup.h         |   31 ++++
 12 files changed, 1075 insertions(+), 16 deletions(-)
 create mode 100644 cmds-qgroup.c
 create mode 100644 cmds-quota.c
 create mode 100644 qgroup.c
 create mode 100644 qgroup.h

diff --git a/Makefile b/Makefile
index 9694444..905d578 100644
--- a/Makefile
+++ b/Makefile
@@ -4,9 +4,9 @@ CFLAGS = -g -O0
 objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o \
 	  inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o \
-	  volumes.o utils.o btrfs-list.o btrfslabel.o repair.o
+	  volumes.o utils.o btrfs-list.o btrfslabel.o repair.o qgroup.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
-	       cmds-inspect.o cmds-balance.o
+	       cmds-inspect.o cmds-balance.o cmds-quota.o cmds-qgroup.o
 
 CHECKFLAGS= -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise \
 	    -Wuninitialized -Wshadow -Wundef
diff --git a/btrfs.c b/btrfs.c
index 88238d6..59c70f2 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -246,6 +246,8 @@ const struct cmd_group btrfs_cmd_group = {
 		{ "device", cmd_device, NULL, &device_cmd_group, 0 },
 		{ "scrub", cmd_scrub, NULL, &scrub_cmd_group, 0 },
 		{ "inspect-internal", cmd_inspect, NULL, &inspect_cmd_group, 0 },
+		{ "quota", cmd_quota, NULL, &quota_cmd_group, 0 },
+		{ "qgroup", cmd_qgroup, NULL, &qgroup_cmd_group, 0 },
 		{ "help", cmd_help, cmd_help_usage, NULL, 0 },
 		{ "version", cmd_version, cmd_version_usage, NULL, 0 },
 		{ 0, 0, 0, 0, 0 }
diff --git a/cmds-qgroup.c b/cmds-qgroup.c
new file mode 100644
index 0000000..15534ea
--- /dev/null
+++ b/cmds-qgroup.c
@@ -0,0 +1,454 @@
+/*
+ * Copyright (C) 2012 STRATO.  All rights reserved.
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
+
+static const char * const qgroup_cmd_group_usage[] = {
+	"btrfs qgroup <command> [options] <path>",
+	NULL
+};
+
+static u64 parse_qgroupid(char *p)
+{
+	char *s = strchr(p, '/');
+	u64 level;
+	u64 id;
+
+	if (!s)
+		return atoll(p);
+	level = atoll(p);
+	id = atoll(s + 1);
+
+	return (level << 48) | id;
+}
+
+static int qgroup_assign(int assign, int argc, char **argv)
+{
+	int ret = 0;
+	int fd;
+	int e;
+	char *path = argv[3];
+	struct btrfs_ioctl_qgroup_assign_args args;
+
+	if (check_argc_exact(argc, 4))
+		return -1;
+
+	memset(&args, 0, sizeof(args));
+	args.assign = assign;
+	args.src = parse_qgroupid(argv[1]);
+	args.dst = parse_qgroupid(argv[2]);
+
+	/*
+	 * FIXME src should accept subvol path
+	 */
+	if (args.src >= args.dst) {
+		fprintf(stderr, "ERROR: bad relation requested '%s'\n", path);
+		return 12;
+	}
+	fd = open_file_or_dir(path);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access '%s'\n", path);
+		return 12;
+	}
+
+	ret = ioctl(fd, BTRFS_IOC_QGROUP_ASSIGN, &args);
+	e = errno;
+	close(fd);
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: unable to assign quota group: %s\n",
+			strerror(e));
+		return 30;
+	}
+	return 0;
+}
+
+static int qgroup_create(int create, int argc, char **argv)
+{
+	int ret = 0;
+	int fd;
+	int e;
+	char *path = argv[2];
+	struct btrfs_ioctl_qgroup_create_args args;
+
+	if (check_argc_exact(argc, 3))
+		return -1;
+
+	memset(&args, 0, sizeof(args));
+	args.create = create;
+	args.qgroupid = parse_qgroupid(argv[1]);
+
+	fd = open_file_or_dir(path);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access '%s'\n", path);
+		return 12;
+	}
+
+	ret = ioctl(fd, BTRFS_IOC_QGROUP_CREATE, &args);
+	e = errno;
+	close(fd);
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: unable to create quota group: %s\n",
+			strerror(e));
+		return 30;
+	}
+	return 0;
+}
+
+void print_qgroup_info(u64 objectid, struct btrfs_qgroup_info_item *info)
+{
+	printf("%llu/%llu %lld %lld\n", objectid >> 48,
+		objectid & ((1ll << 48) - 1),
+		btrfs_stack_qgroup_info_referenced(info),
+		btrfs_stack_qgroup_info_exclusive(info));
+}
+
+int list_qgroups(int fd)
+{
+	int ret;
+	struct btrfs_ioctl_search_args args;
+	struct btrfs_ioctl_search_key *sk = &args.key;
+	struct btrfs_ioctl_search_header *sh;
+	unsigned long off = 0;
+	unsigned int i;
+	int e;
+	struct btrfs_qgroup_info_item *info;
+
+	memset(&args, 0, sizeof(args));
+
+	/* search in the quota tree */
+	sk->tree_id = BTRFS_QUOTA_TREE_OBJECTID;
+
+	/*
+	 * set the min and max to backref keys.  The search will
+	 * only send back this type of key now.
+	 */
+	sk->max_type = BTRFS_QGROUP_INFO_KEY;
+	sk->min_type = BTRFS_QGROUP_INFO_KEY;
+	sk->max_objectid = 0;
+	sk->max_offset = (u64)-1;
+	sk->max_transid = (u64)-1;
+
+	/* just a big number, doesn't matter much */
+	sk->nr_items = 4096;
+
+	while (1) {
+		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
+		e = errno;
+		if (ret < 0) {
+			fprintf(stderr,
+				"ERROR: can't perform the search - %s\n",
+				strerror(e));
+			return ret;
+		}
+		/* the ioctl returns the number of item it found in nr_items */
+		if (sk->nr_items == 0)
+			break;
+
+		off = 0;
+
+		/*
+		 * for each item, pull the key out of the header and then
+		 * read the root_ref item it contains
+		 */
+		for (i = 0; i < sk->nr_items; i++) {
+			sh = (struct btrfs_ioctl_search_header *)(args.buf +
+								  off);
+			off += sizeof(*sh);
+
+			if (sh->objectid != 0)
+				goto done;
+
+			if (sh->type != BTRFS_QGROUP_INFO_KEY)
+				goto done;
+
+			info = (struct btrfs_qgroup_info_item *)
+					(args.buf + off);
+			print_qgroup_info(sh->offset, info);
+
+			off += sh->len;
+
+			/*
+			 * record the mins in sk so we can make sure the
+			 * next search doesn't repeat this root
+			 */
+			sk->min_offset = sh->offset;
+		}
+		sk->nr_items = 4096;
+		/*
+		 * this iteration is done, step forward one qgroup for the next
+		 * ioctl
+		 */
+		if (sk->min_offset < (u64)-1)
+			sk->min_offset++;
+		else
+			break;
+	}
+
+done:
+	return ret;
+}
+
+static int parse_limit(const char *p, unsigned long long *s)
+{
+	char *endptr;
+	unsigned long long size;
+
+	if (strcasecmp(p, "none") == 0) {
+		*s = 0;
+		return 1;
+	}
+	size = strtoull(p, &endptr, 10);
+	switch (*endptr) {
+	case 'T':
+	case 't':
+		size *= 1024;
+	case 'G':
+	case 'g':
+		size *= 1024;
+	case 'M':
+	case 'm':
+		size *= 1024;
+	case 'K':
+	case 'k':
+		size *= 1024;
+		++endptr;
+		break;
+	case 0:
+		break;
+	default:
+		return 0;
+	}
+
+	if (*endptr)
+		return 0;
+
+	*s = size;
+
+	return 1;
+}
+
+static const char * const cmd_qgroup_assign_usage[] = {
+	"btrfs qgroup assign <src> <dst> <path>",
+	"Enable subvolume qgroup support for a filesystem.",
+	NULL
+};
+
+static int cmd_qgroup_assign(int argc, char **argv)
+{
+	int ret = qgroup_assign(1, argc, argv);
+	if (ret < 0)
+		usage(cmd_qgroup_assign_usage);
+	return ret;
+}
+
+static const char * const cmd_qgroup_remove_usage[] = {
+	"btrfs qgroup remove <src> <dst> <path>",
+	"Remove a subvol from a quota group.",
+	NULL
+};
+
+static int cmd_qgroup_remove(int argc, char **argv)
+{
+	int ret = qgroup_assign(0, argc, argv);
+	if (ret < 0)
+		usage(cmd_qgroup_remove_usage);
+	return ret;
+}
+
+static const char * const cmd_qgroup_create_usage[] = {
+	"btrfs qgroup create <qgroupid> <path>",
+	"Create a subvolume quota group.",
+	NULL
+};
+
+static int cmd_qgroup_create(int argc, char **argv)
+{
+	int ret = qgroup_create(1, argc, argv);
+	if (ret < 0)
+		usage(cmd_qgroup_create_usage);
+	return ret;
+}
+
+static const char * const cmd_qgroup_destroy_usage[] = {
+	"btrfs qgroup destroy <qgroupid> <path>",
+	"Destroy a subvolume quota group.",
+	NULL
+};
+
+static int cmd_qgroup_destroy(int argc, char **argv)
+{
+	int ret = qgroup_create(0, argc, argv);
+	if (ret < 0)
+		usage(cmd_qgroup_destroy_usage);
+	return ret;
+}
+
+static const char * const cmd_qgroup_show_usage[] = {
+	"btrfs qgroup show <path>",
+	"Show all subvolume quota groups.",
+	NULL
+};
+
+static int cmd_qgroup_show(int argc, char **argv)
+{
+	int ret = 0;
+	int fd;
+	char *path = argv[1];
+
+	if (check_argc_exact(argc, 2))
+		usage(cmd_qgroup_show_usage);
+
+	fd = open_file_or_dir(path);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access '%s'\n", path);
+		return 12;
+	}
+
+	ret = list_qgroups(fd);
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: can't list qgroups\n");
+		return 30;
+	}
+
+	close(fd);
+
+	return ret;
+}
+
+static const char * const cmd_qgroup_limit_usage[] = {
+	"btrfs qgroup limit [options] <size>|none [<qgroupid>] <path>",
+	"Limit the size of a subvolume quota group.",
+	"",
+	"-c   limit amount of data after compression",
+	"-e   limit space exclusively assigned to this qgroup",
+	NULL
+};
+
+static int cmd_qgroup_limit(int argc, char **argv)
+{
+	int ret = 0;
+	int fd;
+	int e;
+	char *path;
+	struct btrfs_ioctl_qgroup_limit_args args;
+	unsigned long long size;
+	int compressed = 0;
+	int exclusive = 0;
+
+	optind = 1;
+	while (1) {
+		int c = getopt(argc, argv, "ce");
+		if (c < 0)
+			break;
+		switch (c) {
+		case 'c':
+			compressed = 1;
+			break;
+		case 'e':
+			exclusive = 1;
+			break;
+		default:
+			usage(cmd_qgroup_limit_usage);
+		}
+	}
+
+	if (!parse_limit(argv[optind], &size)) {
+		fprintf(stderr, "Invalid size argument given\n");
+		return 1;
+	}
+
+	memset(&args, 0, sizeof(args));
+	args.qgroupid = parse_qgroupid(argv[optind + 1]);
+	if (size) {
+		if (compressed)
+			args.lim.flags |= BTRFS_QGROUP_LIMIT_RFER_CMPR |
+					  BTRFS_QGROUP_LIMIT_EXCL_CMPR;
+		if (exclusive) {
+			args.lim.flags |= BTRFS_QGROUP_LIMIT_MAX_EXCL;
+			args.lim.max_exclusive = size;
+		} else {
+			args.lim.flags |= BTRFS_QGROUP_LIMIT_MAX_RFER;
+			args.lim.max_referenced = size;
+		}
+	}
+
+	if (args.qgroupid == 0) {
+		if (check_argc_exact(argc - optind, 2))
+			usage(cmd_qgroup_limit_usage);
+		path = argv[optind + 1];
+		ret = test_issubvolume(path);
+		if (ret < 0) {
+			fprintf(stderr, "ERROR: error accessing '%s'\n", path);
+			return 12;
+		}
+		if (!ret) {
+			fprintf(stderr, "ERROR: '%s' is not a subvolume\n",
+				path);
+			return 13;
+		}
+		/*
+		 * keep qgroupid at 0, this indicates that the subvolume the
+		 * fd refers to is to be limited
+		 */
+	} else {
+		if (check_argc_exact(argc - optind, 3))
+			usage(cmd_qgroup_limit_usage);
+		path = argv[optind + 2];
+	}
+
+	fd = open_file_or_dir(path);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access '%s'\n", path);
+		return 12;
+	}
+
+	ret = ioctl(fd, BTRFS_IOC_QGROUP_LIMIT, &args);
+	e = errno;
+	close(fd);
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: unable to limit requested quota group: "
+			"%s\n", strerror(e));
+		return 30;
+	}
+	return 0;
+}
+
+const struct cmd_group qgroup_cmd_group = {
+	qgroup_cmd_group_usage, NULL, {
+		{ "assign", cmd_qgroup_assign, cmd_qgroup_assign_usage, 0, 0 },
+		{ "remove", cmd_qgroup_remove, cmd_qgroup_remove_usage, 0, 0 },
+		{ "create", cmd_qgroup_create, cmd_qgroup_create_usage, 0, 0 },
+		{ "destroy", cmd_qgroup_destroy,
+		  cmd_qgroup_destroy_usage, 0, 0 },
+		{ "show", cmd_qgroup_show, cmd_qgroup_show_usage, 0, 0 },
+		{ "limit", cmd_qgroup_limit, cmd_qgroup_limit_usage, 0, 0 },
+		{ 0, 0, 0, 0, 0 }
+	}
+};
+
+int cmd_qgroup(int argc, char **argv)
+{
+	return handle_command_group(&qgroup_cmd_group, argc, argv);
+}
diff --git a/cmds-quota.c b/cmds-quota.c
new file mode 100644
index 0000000..cf9ad97
--- /dev/null
+++ b/cmds-quota.c
@@ -0,0 +1,117 @@
+/*
+ * Copyright (C) 2012 STRATO.  All rights reserved.
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
+
+static const char * const quota_cmd_group_usage[] = {
+	"btrfs quota <command> [options] <path>",
+	NULL
+};
+
+int quota_ctl(int cmd, int argc, char **argv)
+{
+	int ret = 0;
+	int fd;
+	int e;
+	char *path = argv[1];
+	struct btrfs_ioctl_quota_ctl_args args;
+
+	if (check_argc_exact(argc, 2))
+		return -1;
+
+	memset(&args, 0, sizeof(args));
+	args.cmd = cmd;
+
+	fd = open_file_or_dir(path);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access '%s'\n", path);
+		return 12;
+	}
+
+	ret = ioctl(fd, BTRFS_IOC_QUOTA_CTL, &args);
+	e = errno;
+	close(fd);
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: quota command failed: %s\n",
+			strerror(e));
+		return 30;
+	}
+	return 0;
+}
+
+static const char * const cmd_quota_enable_usage[] = {
+	"btrfs quota enable <path>",
+	"Enable subvolume quota support for a filesystem.",
+	NULL
+};
+
+static int cmd_quota_enable(int argc, char **argv)
+{
+	int ret = quota_ctl(BTRFS_QUOTA_CTL_ENABLE, argc, argv);
+	if (ret < 0)
+		usage(cmd_quota_enable_usage);
+	return ret;
+}
+
+static const char * const cmd_quota_disable_usage[] = {
+	"btrfs quota disable <path>",
+	"Disable subvolume quota support for a filesystem.",
+	NULL
+};
+
+static int cmd_quota_disable(int argc, char **argv)
+{
+	int ret = quota_ctl(BTRFS_QUOTA_CTL_DISABLE, argc, argv);
+	if (ret < 0)
+		usage(cmd_quota_disable_usage);
+	return ret;
+}
+
+static const char * const cmd_quota_rescan_usage[] = {
+	"btrfs quota rescan <path>",
+	"Rescan the subvolume for a changed quota setting.",
+	NULL
+};
+
+static int cmd_quota_rescan(int argc, char **argv)
+{
+	int ret = quota_ctl(BTRFS_QUOTA_CTL_RESCAN, argc, argv);
+	if (ret < 0)
+		usage(cmd_quota_rescan_usage);
+	return ret;
+}
+
+const struct cmd_group quota_cmd_group = {
+	quota_cmd_group_usage, NULL, {
+		{ "enable", cmd_quota_enable, cmd_quota_enable_usage, NULL, 0 },
+		{ "disable", cmd_quota_disable, cmd_quota_disable_usage, 0, 0 },
+		{ "rescan", cmd_quota_rescan, cmd_quota_rescan_usage, NULL, 0 },
+		{ 0, 0, 0, 0, 0 }
+	}
+};
+
+int cmd_quota(int argc, char **argv)
+{
+	return handle_command_group(&quota_cmd_group, argc, argv);
+}
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 3508ce6..f4aa80f 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -26,6 +26,7 @@
 
 #include "kerncompat.h"
 #include "ioctl.h"
+#include "qgroup.h"
 
 #include "commands.h"
 
@@ -70,13 +71,35 @@ static int cmd_subvol_create(int argc, char **argv)
 	int	res, fddst, len, e;
 	char	*newname;
 	char	*dstdir;
-	struct btrfs_ioctl_vol_args	args;
 	char	*dst;
+	struct btrfs_qgroup_inherit *inherit = NULL;
 
-	if (check_argc_exact(argc, 2))
+	optind = 1;
+	while (1) {
+		int c = getopt(argc, argv, "c:i:r");
+		if (c < 0)
+			break;
+
+		switch (c) {
+		case 'c':
+			res = qgroup_inherit_add_copy(&inherit, optarg, 0);
+			if (res)
+				return res;
+			break;
+		case 'i':
+			res = qgroup_inherit_add_group(&inherit, optarg);
+			if (res)
+				return res;
+			break;
+		default:
+			usage(cmd_subvol_create_usage);
+		}
+	}
+
+	if (check_argc_exact(argc - optind, 1))
 		usage(cmd_subvol_create_usage);
 
-	dst = argv[1];
+	dst = argv[optind];
 
 	res = test_isdir(dst);
 	if(res >= 0 ){
@@ -110,9 +133,27 @@ static int cmd_subvol_create(int argc, char **argv)
 	}
 
 	printf("Create subvolume '%s/%s'\n", dstdir, newname);
-	strncpy(args.name, newname, BTRFS_PATH_NAME_MAX);
-	args.name[BTRFS_PATH_NAME_MAX-1] = 0;
-	res = ioctl(fddst, BTRFS_IOC_SUBVOL_CREATE, &args);
+	if (inherit) {
+		struct btrfs_ioctl_vol_args_v2	args;
+
+		memset(&args, 0, sizeof(args));
+		strncpy(args.name, newname, BTRFS_SUBVOL_NAME_MAX);
+		args.name[BTRFS_SUBVOL_NAME_MAX-1] = 0;
+		args.flags |= BTRFS_SUBVOL_QGROUP_INHERIT;
+		args.size = qgroup_inherit_size(inherit);
+		args.qgroup_inherit = inherit;
+
+		res = ioctl(fddst, BTRFS_IOC_SUBVOL_CREATE_V2, &args);
+	} else {
+		struct btrfs_ioctl_vol_args	args;
+
+		memset(&args, 0, sizeof(args));
+		strncpy(args.name, newname, BTRFS_SUBVOL_NAME_MAX);
+		args.name[BTRFS_SUBVOL_NAME_MAX-1] = 0;
+
+		res = ioctl(fddst, BTRFS_IOC_SUBVOL_CREATE, &args);
+	}
+
 	e = errno;
 
 	close(fddst);
@@ -122,6 +163,7 @@ static int cmd_subvol_create(int argc, char **argv)
 			strerror(e));
 		return 11;
 	}
+	free(inherit);
 
 	return 0;
 }
@@ -133,7 +175,7 @@ static int cmd_subvol_create(int argc, char **argv)
  * 1-> path exists and it is  a subvolume
  * -1 -> path is unaccessible
  */
-static int test_issubvolume(char *path)
+int test_issubvolume(char *path)
 {
 	struct stat	st;
 	int		res;
@@ -291,19 +333,34 @@ static int cmd_snapshot(int argc, char **argv)
 	char	*newname;
 	char	*dstdir;
 	struct btrfs_ioctl_vol_args_v2	args;
-
-	memset(&args, 0, sizeof(args));
+	struct btrfs_qgroup_inherit *inherit = NULL;
 
 	optind = 1;
+	memset(&args, 0, sizeof(args));
 	while (1) {
-		int c = getopt(argc, argv, "r");
+		int c = getopt(argc, argv, "c:i:r");
 		if (c < 0)
 			break;
 
 		switch (c) {
+		case 'c':
+			res = qgroup_inherit_add_copy(&inherit, optarg, 0);
+			if (res)
+				return res;
+			break;
+		case 'i':
+			res = qgroup_inherit_add_group(&inherit, optarg);
+			if (res)
+				return res;
+			break;
 		case 'r':
 			readonly = 1;
 			break;
+		case 'x':
+			res = qgroup_inherit_add_copy(&inherit, optarg, 1);
+			if (res)
+				return res;
+			break;
 		default:
 			usage(cmd_snapshot_usage);
 		}
@@ -379,6 +436,11 @@ static int cmd_snapshot(int argc, char **argv)
 	}
 
 	args.fd = fd;
+	if (inherit) {
+		args.flags |= BTRFS_SUBVOL_QGROUP_INHERIT;
+		args.size = qgroup_inherit_size(inherit);
+		args.qgroup_inherit = inherit;
+	}
 	strncpy(args.name, newname, BTRFS_SUBVOL_NAME_MAX);
 	args.name[BTRFS_SUBVOL_NAME_MAX-1] = 0;
 	res = ioctl(fddst, BTRFS_IOC_SNAP_CREATE_V2, &args);
@@ -392,6 +454,7 @@ static int cmd_snapshot(int argc, char **argv)
 			subvol, strerror(e));
 		return 11;
 	}
+	free(inherit);
 
 	return 0;
 }
diff --git a/commands.h b/commands.h
index a303a50..7798a41 100644
--- a/commands.h
+++ b/commands.h
@@ -88,6 +88,8 @@ extern const struct cmd_group balance_cmd_group;
 extern const struct cmd_group device_cmd_group;
 extern const struct cmd_group scrub_cmd_group;
 extern const struct cmd_group inspect_cmd_group;
+extern const struct cmd_group quota_cmd_group;
+extern const struct cmd_group qgroup_cmd_group;
 
 int cmd_subvolume(int argc, char **argv);
 int cmd_filesystem(int argc, char **argv);
@@ -95,3 +97,8 @@ int cmd_balance(int argc, char **argv);
 int cmd_device(int argc, char **argv);
 int cmd_scrub(int argc, char **argv);
 int cmd_inspect(int argc, char **argv);
+int cmd_quota(int argc, char **argv);
+int cmd_qgroup(int argc, char **argv);
+
+/* subvolume exported functions */
+int test_issubvolume(char *path);
diff --git a/ctree.h b/ctree.h
index 71e387b..3eb0225 100644
--- a/ctree.h
+++ b/ctree.h
@@ -59,6 +59,7 @@ struct btrfs_trans_handle;
 #define BTRFS_ROOT_TREE_DIR_OBJECTID 6ULL
 /* holds checksums of all the data extents */
 #define BTRFS_CSUM_TREE_OBJECTID 7ULL
+#define BTRFS_QUOTA_TREE_OBJECTID 8ULL
 
 
 /* for storing balance parameters in the root tree */
@@ -730,12 +731,49 @@ struct btrfs_csum_item {
 /* used in struct btrfs_balance_args fields */
 #define BTRFS_AVAIL_ALLOC_BIT_SINGLE	(1ULL << 48)
 
+#define BTRFS_QGROUP_STATUS_OFF			0
+#define BTRFS_QGROUP_STATUS_ON			1
+#define BTRFS_QGROUP_STATUS_SCANNING		2
+
+#define BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT	(1 << 0)
+
+struct btrfs_qgroup_status_item {
+	__le64 version;
+	__le64 generation;
+	__le64 flags;
+	__le64 scan;		/* progress during scanning */
+} __attribute__ ((__packed__));
+
 struct btrfs_block_group_item {
 	__le64 used;
 	__le64 chunk_objectid;
 	__le64 flags;
 } __attribute__ ((__packed__));
 
+struct btrfs_qgroup_info_item {
+	__le64 generation;
+	__le64 referenced;
+	__le64 referenced_compressed;
+	__le64 exclusive;
+	__le64 exclusive_compressed;
+} __attribute__ ((__packed__));
+
+/* flags definition for qgroup limits */
+#define BTRFS_QGROUP_LIMIT_MAX_RFER	(1ULL << 0)
+#define BTRFS_QGROUP_LIMIT_MAX_EXCL	(1ULL << 1)
+#define BTRFS_QGROUP_LIMIT_RSV_RFER	(1ULL << 2)
+#define BTRFS_QGROUP_LIMIT_RSV_EXCL	(1ULL << 3)
+#define BTRFS_QGROUP_LIMIT_RFER_CMPR	(1ULL << 4)
+#define BTRFS_QGROUP_LIMIT_EXCL_CMPR	(1ULL << 5)
+
+struct btrfs_qgroup_limit_item {
+	__le64 flags;
+	__le64 max_referenced;
+	__le64 max_exclusive;
+	__le64 rsv_referenced;
+	__le64 rsv_exclusive;
+} __attribute__ ((__packed__));
+
 struct btrfs_space_info {
 	u64 flags;
 	u64 total_bytes;
@@ -946,6 +984,14 @@ struct btrfs_root {
 #define BTRFS_BALANCE_ITEM_KEY	248
 
 /*
+ * quota groups
+ */
+#define BTRFS_QGROUP_STATUS_KEY		240
+#define BTRFS_QGROUP_INFO_KEY		242
+#define BTRFS_QGROUP_LIMIT_KEY		244
+#define BTRFS_QGROUP_RELATION_KEY	246
+
+/*
  * string items are for debugging.  They just store a short string of
  * data in the FS
  */
@@ -1796,6 +1842,51 @@ BTRFS_SETGET_FUNCS(file_extent_encryption, struct btrfs_file_extent_item,
 BTRFS_SETGET_FUNCS(file_extent_other_encoding, struct btrfs_file_extent_item,
 		   other_encoding, 16);
 
+/* btrfs_qgroup_status_item */
+BTRFS_SETGET_FUNCS(qgroup_status_version, struct btrfs_qgroup_status_item,
+		   version, 64);
+BTRFS_SETGET_FUNCS(qgroup_status_generation, struct btrfs_qgroup_status_item,
+		   generation, 64);
+BTRFS_SETGET_FUNCS(qgroup_status_flags, struct btrfs_qgroup_status_item,
+		   flags, 64);
+BTRFS_SETGET_FUNCS(qgroup_status_scan, struct btrfs_qgroup_status_item,
+		   scan, 64);
+
+/* btrfs_qgroup_info_item */
+BTRFS_SETGET_FUNCS(qgroup_info_generation, struct btrfs_qgroup_info_item,
+		   generation, 64);
+BTRFS_SETGET_FUNCS(qgroup_info_referenced, struct btrfs_qgroup_info_item,
+		   referenced, 64);
+BTRFS_SETGET_FUNCS(qgroup_info_referenced_compressed,
+		   struct btrfs_qgroup_info_item, referenced_compressed, 64);
+BTRFS_SETGET_FUNCS(qgroup_info_exclusive, struct btrfs_qgroup_info_item,
+		   exclusive, 64);
+BTRFS_SETGET_FUNCS(qgroup_info_exclusive_compressed,
+		   struct btrfs_qgroup_info_item, exclusive_compressed, 64);
+
+BTRFS_SETGET_STACK_FUNCS(stack_qgroup_info_generation,
+			 struct btrfs_qgroup_info_item, generation, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_qgroup_info_referenced,
+			 struct btrfs_qgroup_info_item, referenced, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_qgroup_info_referenced_compressed,
+		   struct btrfs_qgroup_info_item, referenced_compressed, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_qgroup_info_exclusive,
+			 struct btrfs_qgroup_info_item, exclusive, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_qgroup_info_exclusive_compressed,
+		   struct btrfs_qgroup_info_item, exclusive_compressed, 64);
+
+/* btrfs_qgroup_limit_item */
+BTRFS_SETGET_FUNCS(qgroup_limit_flags, struct btrfs_qgroup_limit_item,
+		   flags, 64);
+BTRFS_SETGET_FUNCS(qgroup_limit_max_referenced, struct btrfs_qgroup_limit_item,
+		   max_referenced, 64);
+BTRFS_SETGET_FUNCS(qgroup_limit_max_exclusive, struct btrfs_qgroup_limit_item,
+		   max_exclusive, 64);
+BTRFS_SETGET_FUNCS(qgroup_limit_rsv_referenced, struct btrfs_qgroup_limit_item,
+		   rsv_referenced, 64);
+BTRFS_SETGET_FUNCS(qgroup_limit_rsv_exclusive, struct btrfs_qgroup_limit_item,
+		   rsv_exclusive, 64);
+
 /* this returns the number of file bytes represented by the inline item.
  * If an item is compressed, this is the uncompressed size
  */
diff --git a/debug-tree.c b/debug-tree.c
index c497892..94ffd8e 100644
--- a/debug-tree.c
+++ b/debug-tree.c
@@ -312,6 +312,12 @@ again:
 				if (!skip) {
 					printf("extent checksum");
 				}
+				break;
+			case BTRFS_QUOTA_TREE_OBJECTID:
+				if (!skip) {
+					printf("quota");
+				}
+				break;
 			case BTRFS_MULTIPLE_OBJECTIDS:
 				if (!skip) {
 					printf("multiple");
diff --git a/ioctl.h b/ioctl.h
index f2e5d8d..8865dc7 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -31,14 +31,47 @@ struct btrfs_ioctl_vol_args {
 	char name[BTRFS_PATH_NAME_MAX + 1];
 };
 
+#define BTRFS_SUBVOL_CREATE_ASYNC	(1ULL << 0)
 #define BTRFS_SUBVOL_RDONLY		(1ULL << 1)
+#define BTRFS_SUBVOL_QGROUP_INHERIT	(1ULL << 2)
+
+#define BTRFS_QGROUP_INHERIT_SET_LIMITS	(1ULL << 0)
+
+struct btrfs_qgroup_limit {
+	__u64	flags;
+	__u64	max_referenced;
+	__u64	max_exclusive;
+	__u64	rsv_referenced;
+	__u64	rsv_exclusive;
+};
+
+struct btrfs_qgroup_inherit {
+	__u64	flags;
+	__u64	num_qgroups;
+	__u64	num_ref_copies;
+	__u64	num_excl_copies;
+	struct btrfs_qgroup_limit lim;
+	__u64	qgroups[0];
+};
+
+struct btrfs_ioctl_qgroup_limit_args {
+	__u64	qgroupid;
+	struct btrfs_qgroup_limit lim;
+};
+
 #define BTRFS_SUBVOL_NAME_MAX 4039
 
 struct btrfs_ioctl_vol_args_v2 {
 	__s64 fd;
 	__u64 transid;
 	__u64 flags;
-	__u64 unused[4];
+	union {
+		struct {
+			__u64 size;
+			struct btrfs_qgroup_inherit *qgroup_inherit;
+		};
+		__u64 unused[4];
+	};
 	char name[BTRFS_SUBVOL_NAME_MAX + 1];
 };
 
@@ -272,6 +305,26 @@ struct btrfs_ioctl_logical_ino_args {
 	__u64				inodes;
 };
 
+
+#define BTRFS_QUOTA_CTL_ENABLE	1
+#define BTRFS_QUOTA_CTL_DISABLE	2
+#define BTRFS_QUOTA_CTL_RESCAN	3
+struct btrfs_ioctl_quota_ctl_args {
+	__u64 cmd;
+	__u64 status;
+};
+
+struct btrfs_ioctl_qgroup_assign_args {
+	__u64 assign;
+	__u64 src;
+	__u64 dst;
+};
+
+struct btrfs_ioctl_qgroup_create_args {
+	__u64 create;
+	__u64 qgroupid;
+};
+
 /* BTRFS_IOC_SNAP_CREATE is no longer used by the btrfs command */
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
@@ -312,6 +365,8 @@ struct btrfs_ioctl_logical_ino_args {
 				    struct btrfs_ioctl_space_args)
 #define BTRFS_IOC_SNAP_CREATE_V2 _IOW(BTRFS_IOCTL_MAGIC, 23, \
 				   struct btrfs_ioctl_vol_args_v2)
+#define BTRFS_IOC_SUBVOL_CREATE_V2 _IOW(BTRFS_IOCTL_MAGIC, 24, \
+				   struct btrfs_ioctl_vol_args_v2)
 #define BTRFS_IOC_SCRUB _IOWR(BTRFS_IOCTL_MAGIC, 27, \
 				struct btrfs_ioctl_scrub_args)
 #define BTRFS_IOC_SCRUB_CANCEL _IO(BTRFS_IOCTL_MAGIC, 28)
@@ -330,5 +385,12 @@ struct btrfs_ioctl_logical_ino_args {
 					struct btrfs_ioctl_ino_path_args)
 #define BTRFS_IOC_LOGICAL_INO _IOWR(BTRFS_IOCTL_MAGIC, 36, \
 					struct btrfs_ioctl_ino_path_args)
-
+#define BTRFS_IOC_QUOTA_CTL _IOWR(BTRFS_IOCTL_MAGIC, 40, \
+					struct btrfs_ioctl_quota_ctl_args)
+#define BTRFS_IOC_QGROUP_ASSIGN _IOW(BTRFS_IOCTL_MAGIC, 41, \
+					struct btrfs_ioctl_qgroup_assign_args)
+#define BTRFS_IOC_QGROUP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 42, \
+					struct btrfs_ioctl_qgroup_create_args)
+#define BTRFS_IOC_QGROUP_LIMIT _IOR(BTRFS_IOCTL_MAGIC, 43, \
+					struct btrfs_ioctl_qgroup_limit_args)
 #endif
diff --git a/print-tree.c b/print-tree.c
index face47a..a2cb943 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -379,8 +379,20 @@ static void print_key_type(u64 objectid, u8 type)
 	case BTRFS_STRING_ITEM_KEY:
 		printf("STRING_ITEM");
 		break;
+	case BTRFS_QGROUP_STATUS_KEY:
+		printf("BTRFS_STATUS_KEY");
+		break;
+	case BTRFS_QGROUP_RELATION_KEY:
+		printf("BTRFS_QGROUP_RELATION_KEY");
+		break;
+	case BTRFS_QGROUP_INFO_KEY:
+		printf("BTRFS_QGROUP_INFO_KEY");
+		break;
+	case BTRFS_QGROUP_LIMIT_KEY:
+		printf("BTRFS_QGROUP_LIMIT_KEY");
+		break;
 	default:
-		printf("UNKNOWN");
+		printf("UNKNOWN.%d", type);
 	};
 }
 
@@ -390,6 +402,12 @@ static void print_objectid(u64 objectid, u8 type)
 		printf("%llu", (unsigned long long)objectid); /* device id */
 		return;
 	}
+	switch (type) {
+	case BTRFS_QGROUP_RELATION_KEY:
+		printf("%llu/%llu", objectid >> 48,
+			objectid & ((1ll << 48) - 1));
+		return;
+	}
 
 	switch (objectid) {
 	case BTRFS_ROOT_TREE_OBJECTID:
@@ -442,6 +460,8 @@ static void print_objectid(u64 objectid, u8 type)
 		break;
 	case BTRFS_FREE_INO_OBJECTID:
 		printf("FREE_INO");
+	case BTRFS_QUOTA_TREE_OBJECTID:
+		printf("QUOTA_TREE");
 		break;
 	case BTRFS_MULTIPLE_OBJECTIDS:
 		printf("MULTIPLE");
@@ -461,12 +481,23 @@ void btrfs_print_key(struct btrfs_disk_key *disk_key)
 {
 	u64 objectid = btrfs_disk_key_objectid(disk_key);
 	u8 type = btrfs_disk_key_type(disk_key);
+	u64 offset = btrfs_disk_key_offset(disk_key);
 
 	printf("key (");
 	print_objectid(objectid, type);
 	printf(" ");
 	print_key_type(objectid, type);
-	printf(" %llu)", (unsigned long long)btrfs_disk_key_offset(disk_key));
+	switch (type) {
+	case BTRFS_QGROUP_RELATION_KEY:
+	case BTRFS_QGROUP_INFO_KEY:
+	case BTRFS_QGROUP_LIMIT_KEY:
+		printf(" %llu/%llu)", (unsigned long long)(offset >> 48),
+			(unsigned long long)(offset & ((1ll << 48) - 1)));
+		break;
+	default:
+		printf(" %llu)", (unsigned long long)offset);
+		break;
+	}
 }
 
 void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
@@ -487,6 +518,9 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 	struct btrfs_root_item root_item;
 	struct btrfs_block_group_item bg_item;
 	struct btrfs_dir_log_item *dlog;
+	struct btrfs_qgroup_info_item *qg_info;
+	struct btrfs_qgroup_limit_item *qg_limit;
+	struct btrfs_qgroup_status_item *qg_status;
 	u32 nr = btrfs_header_nritems(l);
 	u64 objectid;
 	u32 type;
@@ -638,6 +672,58 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 			       (unsigned long long)
 			       btrfs_dev_extent_length(l, dev_extent));
 			break;
+		case BTRFS_QGROUP_STATUS_KEY:
+			qg_status = btrfs_item_ptr(l, i,
+					struct btrfs_qgroup_status_item);
+			printf("\t\tversion %llu generation %llu flags %#llx "
+				"scan %lld\n",
+				(unsigned long long)
+				btrfs_qgroup_status_version(l, qg_status),
+				(unsigned long long)
+				btrfs_qgroup_status_generation(l, qg_status),
+				(unsigned long long)
+				btrfs_qgroup_status_flags(l, qg_status),
+				(unsigned long long)
+				btrfs_qgroup_status_scan(l, qg_status));
+			break;
+		case BTRFS_QGROUP_RELATION_KEY:
+			break;
+		case BTRFS_QGROUP_INFO_KEY:
+			qg_info = btrfs_item_ptr(l, i,
+						 struct btrfs_qgroup_info_item);
+			printf("\t\tgeneration %llu\n"
+			     "\t\treferenced %lld referenced compressed %lld\n"
+			     "\t\texclusive %lld exclusive compressed %lld\n",
+			       (unsigned long long)
+			       btrfs_qgroup_info_generation(l, qg_info),
+			       (long long)
+			       btrfs_qgroup_info_referenced(l, qg_info),
+			       (long long)
+			       btrfs_qgroup_info_referenced_compressed(l,
+								       qg_info),
+			       (long long)
+			       btrfs_qgroup_info_exclusive(l, qg_info),
+			       (long long)
+			       btrfs_qgroup_info_exclusive_compressed(l,
+								      qg_info));
+			break;
+		case BTRFS_QGROUP_LIMIT_KEY:
+			qg_limit = btrfs_item_ptr(l, i,
+					 struct btrfs_qgroup_limit_item);
+			printf("\t\tflags %llx\n"
+			     "\t\tmax referenced %lld max exclusive %lld\n"
+			     "\t\trsv referenced %lld rsv exclusive %lld\n",
+			       (unsigned long long)
+			       btrfs_qgroup_limit_flags(l, qg_limit),
+			       (long long)
+			       btrfs_qgroup_limit_max_referenced(l, qg_limit),
+			       (long long)
+			       btrfs_qgroup_limit_max_exclusive(l, qg_limit),
+			       (long long)
+			       btrfs_qgroup_limit_rsv_referenced(l, qg_limit),
+			       (long long)
+			       btrfs_qgroup_limit_rsv_exclusive(l, qg_limit));
+			break;
 		case BTRFS_STRING_ITEM_KEY:
 			/* dirty, but it's simple */
 			str = l->data + btrfs_item_ptr_offset(l, i);
diff --git a/qgroup.c b/qgroup.c
new file mode 100644
index 0000000..4083b57
--- /dev/null
+++ b/qgroup.c
@@ -0,0 +1,140 @@
+/*
+ * Copyright (C) 2012 STRATO.  All rights reserved.
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
+#include "qgroup.h"
+#include "ctree.h"
+
+u64 parse_qgroupid(char *p)
+{
+	char *s = strchr(p, '/');
+	u64 level;
+	u64 id;
+
+	if (!s)
+		return atoll(p);
+	level = atoll(p);
+	id = atoll(s + 1);
+
+	return (level << 48) | id;
+}
+
+int qgroup_inherit_size(struct btrfs_qgroup_inherit *p)
+{
+	return sizeof(*p) + sizeof(p->qgroups[0]) *
+			    (p->num_qgroups + 2 * p->num_ref_copies +
+			     2 * p->num_excl_copies);
+}
+
+int qgroup_inherit_realloc(struct btrfs_qgroup_inherit **inherit, int n,
+			   int pos)
+{
+	struct btrfs_qgroup_inherit *out;
+	int nitems = 0;
+
+	if (*inherit) {
+		nitems = (*inherit)->num_qgroups +
+			 (*inherit)->num_ref_copies +
+			 (*inherit)->num_excl_copies;
+	}
+
+	out = calloc(sizeof(*out) + sizeof(out->qgroups[0]) * (nitems + n), 1);
+	if (out == NULL) {
+		fprintf(stderr, "ERROR: Not enough memory\n");
+		return 13;
+	}
+
+	if (*inherit) {
+		struct btrfs_qgroup_inherit *i = *inherit;
+		int s = sizeof(out->qgroups);
+
+		out->num_qgroups = i->num_qgroups;
+		out->num_ref_copies = i->num_ref_copies;
+		out->num_excl_copies = i->num_excl_copies;
+		memcpy(out->qgroups, i->qgroups, pos * s);
+		memcpy(out->qgroups + pos + n, i->qgroups + pos,
+		       (nitems - pos) * s);
+	}
+	free(*inherit);
+	*inherit = out;
+
+	return 0;
+}
+
+int qgroup_inherit_add_group(struct btrfs_qgroup_inherit **inherit, char *arg)
+{
+	int ret;
+	u64 qgroupid = parse_qgroupid(arg);
+	int pos = 0;
+
+	if (qgroupid == 0) {
+		fprintf(stderr, "ERROR: bad qgroup specification\n");
+		return 12;
+	}
+
+	if (*inherit)
+		pos = (*inherit)->num_qgroups;
+	ret = qgroup_inherit_realloc(inherit, 1, pos);
+	if (ret)
+		return ret;
+
+	(*inherit)->qgroups[(*inherit)->num_qgroups++] = qgroupid;
+
+	return 0;
+}
+
+int qgroup_inherit_add_copy(struct btrfs_qgroup_inherit **inherit, char *arg,
+			    int type)
+{
+	int ret;
+	u64 qgroup_src;
+	u64 qgroup_dst;
+	char *p;
+	int pos = 0;
+
+	p = strchr(arg, ':');
+	if (!p) {
+bad:
+		fprintf(stderr, "ERROR: bad copy specification\n");
+		return 12;
+	}
+	*p = 0;
+	qgroup_src = parse_qgroupid(arg);
+	qgroup_dst = parse_qgroupid(p + 1);
+	*p = ':';
+
+	if (!qgroup_src || !qgroup_dst)
+		goto bad;
+
+	if (*inherit)
+		pos = (*inherit)->num_qgroups +
+		      (*inherit)->num_ref_copies * 2 * type;
+
+	ret = qgroup_inherit_realloc(inherit, 2, pos);
+	if (ret)
+		return ret;
+
+	(*inherit)->qgroups[pos++] = qgroup_src;
+	(*inherit)->qgroups[pos++] = qgroup_dst;
+
+	if (!type)
+		++(*inherit)->num_ref_copies;
+	else
+		++(*inherit)->num_excl_copies;
+
+	return 0;
+}
diff --git a/qgroup.h b/qgroup.h
new file mode 100644
index 0000000..f7af8c5
--- /dev/null
+++ b/qgroup.h
@@ -0,0 +1,31 @@
+/*
+ * Copyright (C) 2012 STRATO.  All rights reserved.
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
+#ifndef _BTRFS_QGROUP_H
+#define _BTRFS_QGROUP_H
+
+#include "ioctl.h"
+
+int qgroup_inherit_size(struct btrfs_qgroup_inherit *p);
+int qgroup_inherit_realloc(struct btrfs_qgroup_inherit **inherit,
+			   int incgroups, int inccopies);
+int qgroup_inherit_add_group(struct btrfs_qgroup_inherit **inherit, char *arg);
+int qgroup_inherit_add_copy(struct btrfs_qgroup_inherit **inherit, char *arg,
+			    int type);
+
+#endif
-- 
1.7.1

