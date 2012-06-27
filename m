Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38676 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab2F0NRH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jun 2012 09:17:07 -0400
Received: by mail-bk0-f46.google.com with SMTP id ji2so935423bkc.19
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jun 2012 06:17:06 -0700 (PDT)
From: Alexander Block <ablock84@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: Alexander Block <ablock84@googlemail.com>
Subject: [RFC PATCHv2 3/3] Btrfs-progs: introduce btrfs property subgroup
Date: Wed, 27 Jun 2012 15:16:51 +0200
Message-Id: <1340803011-21882-4-git-send-email-ablock84@googlemail.com>
In-Reply-To: <1340803011-21882-1-git-send-email-ablock84@googlemail.com>
References: <1340803011-21882-1-git-send-email-ablock84@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

"btrfs filesystem property" is a generic interface to set/get
properties on filesystem objects (inodes/subvolumes/filesystems
/devs).

This patch adds the generic framework for properties and also
implements two properties. The first is the read-only property
for subvolumes and the second is the label property for devices.

Signed-off-by: Alexander Block <ablock84@googlemail.com>
---
 Makefile        |    5 +-
 btrfs.c         |    1 +
 cmds-property.c |  459 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 commands.h      |    2 +
 props.c         |  114 ++++++++++++++
 props.h         |   43 ++++++
 6 files changed, 622 insertions(+), 2 deletions(-)
 create mode 100644 cmds-property.c
 create mode 100644 props.c
 create mode 100644 props.h

diff --git a/Makefile b/Makefile
index 9694444..b67c368 100644
--- a/Makefile
+++ b/Makefile
@@ -4,9 +4,10 @@ CFLAGS = -g -O0
 objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o \
 	  inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o \
-	  volumes.o utils.o btrfs-list.o btrfslabel.o repair.o
+	  volumes.o utils.o btrfs-list.o btrfslabel.o repair.o \
+	  props.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
-	       cmds-inspect.o cmds-balance.o
+	       cmds-inspect.o cmds-balance.o cmds-property.o
 
 CHECKFLAGS= -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise \
 	    -Wuninitialized -Wshadow -Wundef
diff --git a/btrfs.c b/btrfs.c
index 88238d6..0c8dde3 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -246,6 +246,7 @@ const struct cmd_group btrfs_cmd_group = {
 		{ "device", cmd_device, NULL, &device_cmd_group, 0 },
 		{ "scrub", cmd_scrub, NULL, &scrub_cmd_group, 0 },
 		{ "inspect-internal", cmd_inspect, NULL, &inspect_cmd_group, 0 },
+		{ "property", cmd_property, NULL, &property_cmd_group, 0 },
 		{ "help", cmd_help, cmd_help_usage, NULL, 0 },
 		{ "version", cmd_version, cmd_version_usage, NULL, 0 },
 		{ 0, 0, 0, 0, 0 }
diff --git a/cmds-property.c b/cmds-property.c
new file mode 100644
index 0000000..04c7b1e
--- /dev/null
+++ b/cmds-property.c
@@ -0,0 +1,459 @@
+/*
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
+#include <stdlib.h>
+#include <string.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/ioctl.h>
+#include <sys/stat.h>
+
+#include "commands.h"
+#include "props.h"
+#include "ctree.h"
+
+static const char * const property_cmd_group_usage[] = {
+	"btrfs property get/set/list [-t <type>] <object> [<name>] [value]",
+	NULL
+};
+
+static const char * const cmd_get_usage[] = {
+	"btrfs property get [-t <type>] <object> [<name>]",
+	"Gets a property from a btrfs object.",
+	"If no name is specified, all properties for the given object are",
+	"printed.",
+	"A filesystem object can be a the filesystem itself, a subvolume,",
+	"an inode or a device. The '-t <type>' option can be used to explicitly",
+	"specify what type of object you meant. This is only needed when a",
+	"property could be set for more then one object type. Possible types",
+	"are s[ubvol], f[ilesystem], i[node] and d[evice].",
+	NULL
+};
+
+static const char * const cmd_set_usage[] = {
+	"btrfs property set [-t <type>] <object> <name> <value>",
+	"Sets a property on a btrfs object.",
+	"Please see the help of 'btrfs property get' for a description of",
+	"objects and object types.",
+	NULL
+};
+
+static const char * const cmd_list_usage[] = {
+	"btrfs property list [-t <type>] <object>",
+	"Lists available properties with their descriptions for the given object.",
+	"Please see the help of 'btrfs property get' for a description of",
+	"objects and object types.",
+	NULL
+};
+
+static int parse_prop(const char *arg, const struct prop_handler *props,
+		      const struct prop_handler **prop_ret)
+{
+	const struct prop_handler *prop = props;
+
+	for (; prop->name; prop++) {
+		if (!strcmp(prop->name, arg)) {
+			*prop_ret = prop;
+			return 0;
+		}
+	}
+
+	return -1;
+}
+
+static int get_fsid(const char *path, u8 *fsid)
+{
+	int ret;
+	int fd;
+	struct btrfs_ioctl_fs_info_args args;
+
+	fd = open(path, O_RDONLY);
+	if (fd < 0) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: open %s failed. %s\n", path,
+				strerror(-ret));
+		goto out;
+	}
+
+	ret = ioctl(fd, BTRFS_IOC_FS_INFO, &args);
+	if (ret < 0) {
+		ret = -errno;
+		goto out;
+	}
+
+	memcpy(fsid, args.fsid, BTRFS_FSID_SIZE);
+	ret = 0;
+
+out:
+	if (fd != -1)
+		close(fd);
+	return ret;
+}
+
+static int check_btrfs_object(const char *object)
+{
+	int ret;
+	u8 fsid[BTRFS_FSID_SIZE];
+
+	ret = get_fsid(object, fsid);
+	if (ret < 0)
+		ret = 0;
+	else
+		ret = 1;
+	return ret;
+}
+
+static int check_is_root(const char *object)
+{
+	int ret;
+	u8 fsid[BTRFS_FSID_SIZE];
+	u8 fsid2[BTRFS_FSID_SIZE];
+	char *tmp;
+
+	tmp = malloc(strlen(object) + 5);
+	strcpy(tmp, object);
+	if (tmp[strlen(tmp) - 1] != '/')
+		strcat(tmp, "/");
+	strcat(tmp, "..");
+
+	ret = get_fsid(object, fsid);
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: get_fsid for %s failed. %s\n", object,
+				strerror(-ret));
+		goto out;
+	}
+
+	ret = get_fsid(tmp, fsid2);
+	if (ret < 0) {
+		ret = 0;
+		goto out;
+	}
+
+	if (!memcmp(fsid, fsid2, BTRFS_FSID_SIZE)) {
+		ret = 0;
+		goto out;
+	}
+
+	ret = 1;
+
+out:
+	free(tmp);
+	return ret;
+}
+
+static int count_bits(int v)
+{
+	unsigned int tmp = (unsigned int)v;
+	int cnt = 0;
+
+	while (tmp) {
+		if (tmp & 1)
+			cnt++;
+		tmp >>= 1;
+	}
+	return cnt;
+}
+
+static int autodetect_object_types(const char *object, int *types_out)
+{
+	int ret;
+	int is_btrfs_object;
+	int types = 0;
+	struct stat st;
+
+	is_btrfs_object = check_btrfs_object(object);
+
+	ret = lstat(object, &st);
+	if (ret < 0) {
+		ret = -errno;
+		goto out;
+	}
+
+	if (is_btrfs_object) {
+		types |= prop_object_inode;
+		if (st.st_ino == BTRFS_FIRST_FREE_OBJECTID) {
+			types |= prop_object_subvol;
+		}
+
+		ret = check_is_root(object);
+		if (ret < 0)
+			goto out;
+		if (ret)
+			types |= prop_object_root;
+	}
+
+	if (S_ISBLK(st.st_mode))
+		types |= prop_object_dev;
+
+	ret = 0;
+	*types_out = types;
+
+out:
+	return ret;
+}
+
+static int print_prop_help(const struct prop_handler *prop)
+{
+	int ret = 0;
+	fprintf(stdout, "%-20s%s\n", prop->name, prop->desc);
+	return ret;
+}
+
+static int dump_prop(const struct prop_handler *prop,
+		     const char *object,
+		     int types,
+		     int type,
+		     int name_and_help)
+{
+	int ret = 0;
+
+	if ((types & type) && (prop->types & type)) {
+		if (!name_and_help)
+			ret = prop->handler(type, object, prop->name, NULL);
+		else
+			ret = print_prop_help(prop);
+	}
+	return ret;
+}
+
+static int dump_props(int types, const char *object, int name_and_help)
+{
+	int ret;
+	int i;
+	int j;
+	const struct prop_handler *prop;
+
+	for (i = 0; prop_handlers[i].name; i++) {
+		prop = &prop_handlers[i];
+		for (j = 1; j < __prop_object_max; j <<= 1) {
+			ret = dump_prop(prop, object, types, j, name_and_help);
+			if (ret < 0) {
+				fprintf(stderr, "ERROR: failed to get property "
+						"'%s' for object.\n",
+						prop->name);
+				ret = 50;
+				goto out;
+			}
+		}
+	}
+
+	ret = 0;
+
+out:
+	return ret;
+}
+
+static int setget_prop(int types, const char *object, const char *name, const char *value)
+{
+	int ret;
+	const struct prop_handler *prop = NULL;
+
+	ret = parse_prop(name, prop_handlers, &prop);
+	if (ret == -1) {
+		fprintf(stderr, "ERROR: property is unknown\n");
+		ret = 40;
+		goto out;
+	} else if (ret) {
+		fprintf(stderr, "ERROR: parse_prop reported unknown error\n");
+		ret = 42;
+		goto out;
+	}
+
+	types &= prop->types;
+	if (!types) {
+		fprintf(stderr, "ERROR: object is not compatible "
+				"with property\n");
+		ret = 47;
+		goto out;
+	}
+
+	if (count_bits(types) > 1) {
+		fprintf(stderr, "ERROR: type of object is ambiguous. "
+				"Please specify a type by hand.\n");
+		ret = 48;
+		goto out;
+	}
+
+	if (value && prop->read_only) {
+		fprintf(stderr, "ERROR: %s is a read-only property.\n",
+				prop->name);
+		ret = 51;
+		goto out;
+	}
+
+	ret = prop->handler(types, object, name, value);
+
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: failed to set/get property for "
+				"object.\n");
+		ret = 50;
+	} else {
+		ret = 0;
+	}
+
+out:
+	return ret;
+
+}
+
+static void parse_args(int argc, char **argv,
+		       const char * const *usage_str,
+		       int *types, char **object,
+		       char **name, char **value)
+{
+	int ret;
+	char *type_str = NULL;
+
+	optind = 1;
+	while (1) {
+		int c = getopt(argc, argv, "t:");
+		if (c < 0)
+			break;
+
+		switch (c) {
+		case 't':
+			type_str = optarg;
+			break;
+		default:
+			usage(usage_str);
+			break;
+		}
+	}
+
+	*types = 0;
+	if (type_str) {
+		if (!strcmp(type_str, "s") || !strcmp(type_str, "subvol"))
+			*types = prop_object_subvol;
+		else if (!strcmp(type_str, "f") ||
+			 !strcmp(type_str, "filesystem"))
+			*types = prop_object_root;
+		else if (!strcmp(type_str, "i") || !strcmp(type_str, "inode"))
+			*types = prop_object_inode;
+		else if (!strcmp(type_str, "d") || !strcmp(type_str, "device"))
+			*types = prop_object_dev;
+		else {
+			fprintf(stderr, "ERROR: invalid object type.\n");
+			usage(usage_str);
+		}
+	}
+
+	if (object && optind < argc)
+		*object = argv[optind++];
+	if (name && optind < argc)
+		*name = argv[optind++];
+	if (value && optind < argc)
+		*value = argv[optind++];
+
+	if (optind != argc) {
+		fprintf(stderr, "ERROR: invalid arguments.\n");
+		usage(usage_str);
+	}
+
+	if (!*types && object && *object) {
+		ret = autodetect_object_types(*object, types);
+		if (ret < 0) {
+			fprintf(stderr, "ERROR: failed to detect object type. "
+					"%s\n", strerror(-ret));
+			usage(usage_str);
+		}
+		if (!*types) {
+			fprintf(stderr, "ERROR: object is not a btrfs "
+					"object.\n");
+			usage(usage_str);
+		}
+	}
+}
+
+static int cmd_get(int argc, char **argv)
+{
+	int ret;
+	char *object;
+	char *name = NULL;
+	int types = 0;
+
+	if (check_argc_min(argc, 2) || check_argc_max(argc, 4))
+		usage(cmd_get_usage);
+
+	parse_args(argc, argv, cmd_get_usage, &types, &object, &name, NULL);
+	if (!object) {
+		fprintf(stderr, "ERROR: invalid arguments.\n");
+		usage(cmd_set_usage);
+	}
+
+	if (name)
+		ret = setget_prop(types, object, name, NULL);
+	else
+		ret = dump_props(types, object, 0);
+
+	return ret;
+}
+
+static int cmd_set(int argc, char **argv)
+{
+	int ret;
+	char *object;
+	char *name;
+	char *value;
+	int types = 0;
+
+	if (check_argc_min(argc, 4) || check_argc_max(argc, 5))
+		usage(cmd_set_usage);
+
+	parse_args(argc, argv, cmd_set_usage, &types, &object, &name, &value);
+	if (!object || !name || !value) {
+		fprintf(stderr, "ERROR: invalid arguments.\n");
+		usage(cmd_set_usage);
+	}
+
+	ret = setget_prop(types, object, name, value);
+
+	return ret;
+}
+
+static int cmd_list(int argc, char **argv)
+{
+	int ret;
+	char *object = NULL;
+	int types = 0;
+
+	if (check_argc_min(argc, 2) || check_argc_max(argc, 3))
+		usage(cmd_list_usage);
+
+	parse_args(argc, argv, cmd_list_usage, &types, &object, NULL, NULL);
+	if (!object) {
+		fprintf(stderr, "ERROR: invalid arguments.\n");
+		usage(cmd_set_usage);
+	}
+
+	ret = dump_props(types, object, 1);
+
+	return ret;
+}
+
+const struct cmd_group property_cmd_group = {
+	property_cmd_group_usage, NULL, {
+		{ "get", cmd_get, cmd_get_usage, NULL, 0 },
+		{ "set", cmd_set, cmd_set_usage, NULL, 0 },
+		{ "list", cmd_list, cmd_list_usage, NULL, 0 },
+		{ 0, 0, 0, 0, 0 },
+	}
+};
+
+int cmd_property(int argc, char **argv)
+{
+	return handle_command_group(&property_cmd_group, argc, argv);
+}
diff --git a/commands.h b/commands.h
index a303a50..a1cfa2d 100644
--- a/commands.h
+++ b/commands.h
@@ -88,6 +88,7 @@ extern const struct cmd_group balance_cmd_group;
 extern const struct cmd_group device_cmd_group;
 extern const struct cmd_group scrub_cmd_group;
 extern const struct cmd_group inspect_cmd_group;
+extern const struct cmd_group property_cmd_group;
 
 int cmd_subvolume(int argc, char **argv);
 int cmd_filesystem(int argc, char **argv);
@@ -95,3 +96,4 @@ int cmd_balance(int argc, char **argv);
 int cmd_device(int argc, char **argv);
 int cmd_scrub(int argc, char **argv);
 int cmd_inspect(int argc, char **argv);
+int cmd_property(int argc, char **argv);
diff --git a/props.c b/props.c
new file mode 100644
index 0000000..f3e7dd4
--- /dev/null
+++ b/props.c
@@ -0,0 +1,114 @@
+/*
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
+#include <sys/stat.h>
+#include <sys/ioctl.h>
+#include <fcntl.h>
+#include <unistd.h>
+
+#include "ctree.h"
+#include "commands.h"
+#include "utils.h"
+#include "btrfslabel.h"
+#include "props.h"
+
+int prop_read_only(enum prop_object_type type,
+		   const char *object,
+		   const char *name,
+		   const char *value)
+{
+	int ret = 0;
+	int fd = -1;
+	u64 flags = 0;
+
+	fd = open(object, O_RDONLY);
+	if (fd < 0) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: open %s failed. %s\n",
+				object, strerror(-ret));
+		goto out;
+	}
+
+	ret = ioctl(fd, BTRFS_IOC_SUBVOL_GETFLAGS, &flags);
+	if (ret < 0) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: failed to get flags for %s. %s\n",
+				object, strerror(-ret));
+		goto out;
+	}
+
+	if (!value) {
+		if (flags & BTRFS_SUBVOL_RDONLY)
+			fprintf(stdout, "ro=true\n");
+		else
+			fprintf(stdout, "ro=false\n");
+		ret = 0;
+		goto out;
+	}
+
+	if (!strcmp(value, "true"))
+		flags |= BTRFS_SUBVOL_RDONLY;
+	else if (!strcmp(value, "false"))
+		flags = flags & ~BTRFS_SUBVOL_RDONLY;
+	else {
+		ret = -EINVAL;
+		fprintf(stderr, "ERROR: invalid value for property.\n");
+		goto out;
+	}
+
+	ret = ioctl(fd, BTRFS_IOC_SUBVOL_SETFLAGS, &flags);
+	if (ret < 0) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: failed to set flags for %s. %s\n",
+				object, strerror(-ret));
+		goto out;
+	}
+
+out:
+	if (fd != -1)
+		close(fd);
+	return ret;
+}
+
+int prop_label(enum prop_object_type type,
+	       const char *object,
+	       const char *name,
+	       const char *value)
+{
+	int ret;
+	char *label = NULL;
+
+	if (value) {
+		ret = set_label((char*)object, (char*)value);
+	} else {
+		ret = get_label((char*)object, &label);
+		if (!ret)
+			fprintf(stdout, "label=%s\n", label);
+		free(label);
+	}
+
+	return ret;
+}
+
+const struct prop_handler prop_handlers[] = {
+		{"ro",        "Set/get read-only flag of subvolume.",
+				0, prop_object_subvol, prop_read_only},
+		{"label",     "Set/get label of device.",
+				0, prop_object_dev, prop_label},
+		{0, 0, 0, 0, 0}
+};
+
+
diff --git a/props.h b/props.h
new file mode 100644
index 0000000..faa4410
--- /dev/null
+++ b/props.h
@@ -0,0 +1,43 @@
+/*
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
+#ifndef PROPS_H_
+#define PROPS_H_
+
+enum prop_object_type {
+	prop_object_dev		= (1 << 0),
+	prop_object_root	= (1 << 1),
+	prop_object_subvol	= (1 << 2),
+	prop_object_inode	= (1 << 3),
+	__prop_object_max,
+};
+
+typedef int (*prop_handler_t)(enum prop_object_type type,
+			      const char *object,
+			      const char *name,
+			      const char *value);
+
+struct prop_handler {
+	const char *name;
+	const char *desc;
+	int read_only;
+	int types;
+	prop_handler_t handler;
+};
+
+extern const struct prop_handler prop_handlers[];
+
+#endif /* PROPS_H_ */
-- 
1.7.10

