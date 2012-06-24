Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41559 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842Ab2FXVUl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Jun 2012 17:20:41 -0400
Received: by mail-bk0-f46.google.com with SMTP id ji2so2680230bkc.19
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Jun 2012 14:20:41 -0700 (PDT)
From: Alexander Block <ablock84@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: Alexander Block <ablock84@googlemail.com>
Subject: [PATCH 5/5] Btrfs-progs: introduce btrfs filesystem property command
Date: Sun, 24 Jun 2012 23:20:08 +0200
Message-Id: <1340572808-30281-6-git-send-email-ablock84@googlemail.com>
In-Reply-To: <1340572808-30281-1-git-send-email-ablock84@googlemail.com>
References: <1340572808-30281-1-git-send-email-ablock84@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

"btrfs filesystem property" is a generic interface to set/get
properties on filesystem objects (inodes/subvolumes/roots/devs).

This patch adds the generic framework for properties and also
implements two properties. The first is the read-only property
for subvolumes and the second is the label property for devices.

Signed-off-by: Alexander Block <ablock84@googlemail.com>
---
 Makefile          |    3 +-
 btrfs.c           |    2 +
 cmds-filesystem.c |   98 ++++++++++++
 commands.h        |    3 +
 props.c           |  460 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 props.h           |   45 ++++++
 6 files changed, 610 insertions(+), 1 deletion(-)
 create mode 100644 props.c
 create mode 100644 props.h

diff --git a/Makefile b/Makefile
index 9694444..3e685d9 100644
--- a/Makefile
+++ b/Makefile
@@ -4,7 +4,8 @@ CFLAGS = -g -O0
 objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o \
 	  inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o \
-	  volumes.o utils.o btrfs-list.o btrfslabel.o repair.o
+	  volumes.o utils.o btrfs-list.o btrfslabel.o repair.o \
+	  props.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o
 
diff --git a/btrfs.c b/btrfs.c
index f48e483..20f0845 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -243,6 +243,8 @@ int main(int argc, char **argv)
 {
 	const struct cmd_struct *cmd;
 
+	init_cmd_prop_usage();
+
 	argc--;
 	argv++;
 	handle_options(&argc, &argv);
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 4c61233..5b8863f 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -33,6 +33,7 @@
 
 #include "commands.h"
 #include "btrfslabel.h"
+#include "props.h"
 
 static const char * const filesystem_cmd_group_usage[] = {
 	"btrfs filesystem [<group>] <command> [<args>]",
@@ -534,6 +535,102 @@ static int cmd_label(int argc, char **argv)
 		return ret;
 	}
 }
+
+static const char *cmd_prop_usage_base[] = {
+	"btrfs filesystem property [type:]<object> [<name>[=<value>]]",
+	"Get or set a property of a filesystem object.",
+	"A filesystem object can be a the root of a filesystem, a subvolume,",
+	"an inode or a device. The 'type:' can be used to explicitly specify",
+	"what type of object you meant. This is only needed when a property",
+	"could be set for more then one object type. Possible types are",
+	"s[ubvol], r[oot], i[node], d[evice]. If you need to specify an",
+	"object that itself contains a colon, use '\\:' to escape it.",
+	"Depending on your shell, you may need to use two back slashes.",
+	"If only the object and no name is specified, all properties for",
+	"this object are dumped. If you specify a name but no value, this",
+	"property is dumped.",
+	"",
+	"Currently supported properties:",
+	NULL
+};
+
+static const char **gen_cmd_prop_usage()
+{
+	const char **result;
+	int cnt = 0;
+	int i;
+	int len;
+
+	for (i = 0; cmd_prop_usage_base[i]; i++)
+		cnt++;
+	for (i = 0; prop_handlers[i].desc; i++)
+		cnt++;
+
+	result = malloc(sizeof(char*) * (cnt + 1));
+
+	cnt = 0;
+	for (i = 0; cmd_prop_usage_base[i]; i++)
+		result[cnt++] = cmd_prop_usage_base[i];
+	for (i = 0; prop_handlers[i].desc; i++) {
+		len = snprintf(NULL, 0, "%-16s%s",
+				prop_handlers[i].name, prop_handlers[i].desc);
+		result[cnt] = malloc(len + 2);
+		snprintf((char*)result[cnt], len + 1, "%-16s%s",
+				prop_handlers[i].name, prop_handlers[i].desc);
+		cnt++;
+	}
+	result[cnt] = NULL;
+	return result;
+}
+
+static const char **cmd_prop_usage;
+
+void init_cmd_prop_usage()
+{
+	int i;
+
+	cmd_prop_usage = gen_cmd_prop_usage();
+	for (i = 0; filesystem_cmd_group.commands[i].fn; i++) {
+		if (!strcmp(filesystem_cmd_group.commands[i].token,
+				"property")) {
+			filesystem_cmd_group.commands[i].usagestr =
+					cmd_prop_usage;
+			break;
+		}
+	}
+}
+
+static int cmd_prop(int argc, char **argv)
+{
+	int ret;
+	char *object;
+	char *name_value;
+	char *name;
+	char *value;
+
+	if (argc != 2 && argc != 3)
+		usage(cmd_prop_usage);
+
+	object = argv[1];
+	name_value = argv[2];
+
+	if (name_value) {
+		value = strchr(name_value, '=');
+		if (value) {
+			name = strndup(name_value, value - name_value);
+			value++;
+		} else {
+			name = strdup(name_value);
+		}
+	} else {
+		name = NULL;
+		value = NULL;
+	}
+
+	ret = handle_prop(object, name, value);
+	free(name);
+
+	return ret;
 }
 
 struct cmd_group filesystem_cmd_group = {
@@ -545,6 +642,7 @@ struct cmd_group filesystem_cmd_group = {
 		{ "balance", cmd_balance, NULL, &balance_cmd_group, 1 },
 		{ "resize", cmd_resize, cmd_resize_usage, NULL, 0 },
 		{ "label", cmd_label, cmd_label_usage, NULL, 0 },
+		{ "property", cmd_prop, NULL, NULL, 0 },
 		{ 0, 0, 0, 0, 0 },
 	}
 };
diff --git a/commands.h b/commands.h
index 9405806..07a9f9f 100644
--- a/commands.h
+++ b/commands.h
@@ -87,6 +87,9 @@ extern const struct cmd_group device_cmd_group;
 extern const struct cmd_group scrub_cmd_group;
 extern const struct cmd_group inspect_cmd_group;
 
+/* cmds-filesystem.c */
+void init_cmd_prop_usage();
+
 int cmd_subvolume(int argc, char **argv);
 int cmd_filesystem(int argc, char **argv);
 int cmd_balance(int argc, char **argv);
diff --git a/props.c b/props.c
new file mode 100644
index 0000000..a428c83
--- /dev/null
+++ b/props.c
@@ -0,0 +1,460 @@
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
+			fprintf(stdout, "read-only=true\n");
+		else
+			fprintf(stdout, "read-only=false\n");
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
+		{"read-only", "Set/get read only flag of subvolume",
+				0, prop_object_subvol, prop_read_only},
+		{"label", "Set/get label of filesystem",
+				0, prop_object_dev, prop_label},
+		{0, 0, 0, 0, 0}
+};
+
+static int parse_prop(const char *arg, const struct prop_handler *props,
+		      const struct prop_handler **prop_ret)
+{
+	const struct prop_handler *prop = props;
+	const struct prop_handler *abbrev_prop = NULL;
+	const struct prop_handler *ambiguous_prop = NULL;
+
+	for (; prop->name; prop++) {
+		const char *rest;
+
+		rest = skip_prefix(arg, prop->name);
+		if (!rest) {
+			if (!prefixcmp(prop->name, arg)) {
+				if (abbrev_prop) {
+					/*
+					 * If this is abbreviated, it is
+					 * ambiguous. So when there is no
+					 * exact match later, we need to
+					 * error out.
+					 */
+					ambiguous_prop = abbrev_prop;
+				}
+				abbrev_prop = prop;
+			}
+			continue;
+		}
+		if (*rest)
+			continue;
+
+		*prop_ret = prop;
+		return 0;
+	}
+
+	if (ambiguous_prop)
+		return -2;
+
+	if (abbrev_prop) {
+		*prop_ret = abbrev_prop;
+		return 0;
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
+static int detect_object_types(const char *object, int *types_out)
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
+static int dump_prop(const struct prop_handler *prop,
+		     const char *object,
+		     int types,
+		     int type)
+{
+	int ret = 0;
+
+	if ((types & type) && (prop->types & type))
+		ret = prop->handler(type, object, prop->name, NULL);
+	return ret;
+}
+
+int handle_prop(const char *object_in, const char *name, const char *value)
+{
+	int ret;
+	const struct prop_handler *prop = NULL;
+	char *buf = NULL;
+	char *object = NULL;
+	char *type = NULL;
+	char *tmp;
+	struct stat st;
+	int i;
+	int j;
+	int types = 0;
+
+	if (!name) {
+		object = strdup(object_in);
+		ret = detect_object_types(object, &types);
+		if (ret < 0) {
+			fprintf(stderr, "ERROR: failed to detect object "
+					"type. %s\n", strerror(-ret));
+			ret = 46;
+			goto out;
+		}
+		if (!types) {
+			fprintf(stderr, "ERROR: object is no device and not "
+					"from a btrfs filesystem.\n");
+			ret = 46;
+			goto out;
+		}
+		for (i = 0; prop_handlers[i].name; i++) {
+			prop = &prop_handlers[i];
+			for (j = 1; j < __prop_object_max; j <<= 1) {
+				ret = dump_prop(&prop_handlers[i], object,
+						types, j);
+				if (ret < 0) {
+					fprintf(stderr, "ERROR: failed to set/"
+							"get property for "
+							"object.\n");
+					ret = 50;
+					goto out;
+				}
+			}
+		}
+		ret = 0;
+		goto out;
+	}
+
+	ret = parse_prop(name, prop_handlers, &prop);
+	if (ret == -1) {
+		fprintf(stderr, "ERROR: property is unknown\n");
+		ret = 40;
+		goto out;
+	} else if (ret == -2) {
+		fprintf(stderr, "ERROR: property is ambigious\n");
+		ret = 41;
+		goto out;
+	} else if (ret) {
+		fprintf(stderr, "ERROR: parse_prop reported unknown error\n");
+		ret = 42;
+		goto out;
+	}
+
+	buf = strdup(object_in);
+	tmp = buf;
+
+	for (i = 0; buf[i]; i++) {
+		if (buf[i] != ':')
+			continue;
+		if (i == 0 || (i == 1 && buf[0] == '\\')) {
+			ret = 43;
+			fprintf(stderr, "ERROR: invalid object\n");
+			goto out;
+		}
+
+		/* escape? */
+		if (tmp[i - 1] == '\\') {
+			memmove(buf + i - 1, buf + i, strlen(buf + i) + 1);
+			i--;
+			continue;
+		}
+
+		if (!type) {
+			type = buf;
+			object = buf + i + 1;
+			buf[i] = 0;
+		}
+	}
+
+	if (!type)
+		object = buf;
+
+	if (type) {
+		if (!strcmp(type, "s") || !strcmp(type, "subvol"))
+			types = prop_object_subvol;
+		else if (!strcmp(type, "r") || !strcmp(type, "root"))
+			types = prop_object_root;
+		else if (!strcmp(type, "i") || !strcmp(type, "inode"))
+			types = prop_object_inode;
+		else if (!strcmp(type, "d") || !strcmp(type, "device"))
+			types = prop_object_dev;
+		else {
+			fprintf(stderr, "ERROR: invalid object type.\n");
+			ret = 45;
+			goto out;
+		}
+	} else {
+		/* try auto detection */
+		ret = detect_object_types(object, &types);
+		if (ret < 0) {
+			fprintf(stderr, "ERROR: failed to detect object type. "
+					"%s\n", strerror(-ret));
+			ret = 46;
+			goto out;
+		}
+
+		if (!(types & prop->types)) {
+			fprintf(stderr, "ERROR: object is not compatible "
+					"with property\n");
+			ret = 47;
+			goto out;
+		}
+	}
+
+	types &= prop->types;
+
+	if (count_bits(types) > 1) {
+		fprintf(stderr, "ERROR: type of object is ambiguous. "
+				"Please specify a type by hand.\n");
+		ret = 48;
+		goto out;
+	}
+
+	if (!types) {
+		fprintf(stderr, "ERROR: invalid object type.\n");
+		ret = 49;
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
+	free(buf);
+	return ret;
+
+}
+
diff --git a/props.h b/props.h
new file mode 100644
index 0000000..bd497b7
--- /dev/null
+++ b/props.h
@@ -0,0 +1,45 @@
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
+int handle_prop(const char *object, const char *name, const char *value);
+
+#endif /* PROPS_H_ */
-- 
1.7.10

