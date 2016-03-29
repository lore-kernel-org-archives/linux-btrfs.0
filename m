Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50869 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbcC2O1i (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Mar 2016 10:27:38 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH v2 2/4] btrfs-progs: Introduce btrfs spare subcommand
Date: Tue, 29 Mar 2016 22:27:19 +0800
Message-Id: <1459261641-32254-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1459261641-32254-1-git-send-email-anand.jain@oracle.com>
References: <1459261349-32206-1-git-send-email-anand.jain@oracle.com>
 <1459261641-32254-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adds a new sub command so that a global spare device can be
added. A sub cli is better so that we can enhance to provide
per FSID spare in future.

btrfs spare add <dev> ..

This will create a btrfs on the dev with the newly introduced
flag, BTRFS_FEATURE_INCOMPAT_SPARE_DEV. And then calls
btrfs_register_one_device() to let kernel know about it.

Compatible with older kernel, that it would fail to mount
as there will be an incompatible flag.


Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2: 
  Commit log updated
  Changes as per mixed patch from Chandan
  Call btrfs_register_one_device() so that user no need to run
   btrfs dev scan again
  User error() instead of fprintf(stderr,
  
 Android.mk   |   2 +-
 Makefile.in  |   3 +-
 btrfs.c      |   1 +
 cmds-spare.c | 292 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 commands.h   |   2 +
 5 files changed, 298 insertions(+), 2 deletions(-)
 create mode 100644 cmds-spare.c

diff --git a/Android.mk b/Android.mk
index fe3209b63dfe..baaf17967864 100644
--- a/Android.mk
+++ b/Android.mk
@@ -27,7 +27,7 @@ cmds_objects := cmds-subvolume.c cmds-filesystem.c cmds-device.c cmds-scrub.c \
                cmds-inspect.c cmds-balance.c cmds-send.c cmds-receive.c \
                cmds-quota.c cmds-qgroup.c cmds-replace.c cmds-check.c \
                cmds-restore.c cmds-rescue.c chunk-recover.c super-recover.c \
-               cmds-property.c cmds-fi-usage.c
+               cmds-property.c cmds-fi-usage.c cmds-spare.c
 libbtrfs_objects := send-stream.c send-utils.c rbtree.c btrfs-list.c crc32c.c \
                    uuid-tree.c utils-lib.c rbtree-utils.c
 libbtrfs_headers := send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
diff --git a/Makefile.in b/Makefile.in
index 71ef76d4fd4e..f7a1e7dc11f8 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -76,7 +76,8 @@ cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
 	       cmds-restore.o cmds-rescue.o chunk-recover.o super-recover.o \
 	       cmds-property.o cmds-fi-usage.o cmds-inspect-dump-tree.o \
-	       cmds-inspect-dump-super.o cmds-inspect-tree-stats.o cmds-fi-du.o
+	       cmds-inspect-dump-super.o cmds-inspect-tree-stats.o cmds-fi-du.o \
+	       cmds-spare.o
 libbtrfs_objects = send-stream.o send-utils.o rbtree.o btrfs-list.o crc32c.o \
 		   uuid-tree.o utils-lib.o rbtree-utils.o
 libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
diff --git a/btrfs.c b/btrfs.c
index cc7051531824..455f78ec8012 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -200,6 +200,7 @@ static const struct cmd_group btrfs_cmd_group = {
 		{ "quota", cmd_quota, NULL, &quota_cmd_group, 0 },
 		{ "qgroup", cmd_qgroup, NULL, &qgroup_cmd_group, 0 },
 		{ "replace", cmd_replace, NULL, &replace_cmd_group, 0 },
+		{ "spare", cmd_spare, NULL, &spare_cmd_group, 0 },
 		{ "help", cmd_help, cmd_help_usage, NULL, 0 },
 		{ "version", cmd_version, cmd_version_usage, NULL, 0 },
 		NULL_CMD_STRUCT
diff --git a/cmds-spare.c b/cmds-spare.c
new file mode 100644
index 000000000000..2a5c4b4d7308
--- /dev/null
+++ b/cmds-spare.c
@@ -0,0 +1,292 @@
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
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/ioctl.h>
+#include <errno.h>
+#include <getopt.h>
+
+#include "ctree.h"
+#include "utils.h"
+#include "volumes.h"
+#include "disk-io.h"
+
+#include "commands.h"
+
+int print_spare_device(unsigned unit_mode)
+{
+	int ret;
+	struct btrfs_fs_devices *fs_devices;
+	struct btrfs_device *device;
+	struct list_head *fs_uuids;
+
+	printf("Global spare\n");
+
+	ret = btrfs_scan_lblkid();
+	if (ret) {
+		error("scan_lblkid failed ret %d\n", ret);
+		return ret;
+	}
+
+	fs_uuids = btrfs_scanned_uuids();
+
+	list_for_each_entry(fs_devices, fs_uuids, list) {
+		if (!fs_devices->spare)
+			continue;
+
+		device = list_entry(fs_devices->devices.next,
+					struct btrfs_device, dev_list);
+		if (device->name)
+			printf("\tdevice size %s path %s\n",
+				pretty_size_mode(device->total_bytes,
+					unit_mode), device->name);
+
+	}
+
+	return 0;
+
+}
+
+static void btrfs_delete_spare(char *path)
+{
+	printf("Unscan the device (or don't run device scan after reboot) and run wipefs to wipe SB\n");
+
+}
+
+static void btrfs_add_spare(char *dev)
+{
+	struct stat st;
+	int fd;
+	int i;
+	int ret;
+	u64 block_cnt;
+	u64 blocks[7];
+	u32 nodesz = max_t(u32, sysconf(_SC_PAGESIZE), BTRFS_MKFS_DEFAULT_NODE_SIZE);
+	struct btrfs_mkfs_config mkfs_cfg;
+
+	fd = open(dev, O_RDWR);
+	if (fd < 0) {
+		error("unable to open %s: %s\n", dev, strerror(errno));
+		return;
+	}
+
+	if (fstat(fd, &st)) {
+		error("unable to stat %s\n", dev);
+		goto out;
+	}
+	block_cnt = btrfs_device_size(fd, &st);
+	if (!block_cnt) {
+		error("unable to find %s size\n", dev);
+		goto out;
+	}
+
+	if (block_cnt < BTRFS_MKFS_SYSTEM_GROUP_SIZE) {
+		error("device is too small to make filesystem\n");
+		goto out;
+	}
+
+	blocks[0] = BTRFS_SUPER_INFO_OFFSET;
+	for (i = 1; i < 7; i++)
+		blocks[i] = BTRFS_SUPER_INFO_OFFSET + 1024 * 1024 + nodesz * i;
+
+	memset(&mkfs_cfg, 0, sizeof(mkfs_cfg));
+	memcpy(mkfs_cfg.blocks, blocks, sizeof(blocks));
+	mkfs_cfg.num_bytes = block_cnt;
+	mkfs_cfg.nodesize = nodesz;
+	mkfs_cfg.sectorsize = 4096;
+	mkfs_cfg.stripesize = 4096;
+	mkfs_cfg.features = BTRFS_FEATURE_INCOMPAT_SPARE_DEV;
+	ret = make_btrfs(fd, &mkfs_cfg);
+	if (!ret) {
+		close(fd);
+		btrfs_register_one_device(dev);
+		return;
+	}
+	error("during mkfs: %s\n", strerror(-ret));
+
+out:
+	close(fd);
+}
+
+static const char * const spare_cmd_group_usage[] = {
+	"btrfs spare <command> [<args>]",
+	NULL
+};
+
+static const char * const cmd_spare_add_usage[] = {
+	"btrfs spare add <device> [<device>...]",
+	"Add global spare device(s) to btrfs",
+	"-K|--nodiscard    do not perform whole device TRIM",
+	"-f|--force        force overwrite existing filesystem on the disk",
+	NULL
+};
+
+static const char * const cmd_spare_delete_usage[] = {
+	"btrfs spare delete <device> [<device>...]",
+	"Delete global spare device(s) from btrfs",
+	NULL
+};
+
+static const char * const cmd_spare_list_usage[] = {
+	"btrfs spare list",
+	"List spare device(s) both scanned and unscanned(*) for kernel",
+	NULL
+};
+
+static int cmd_spare_add(int argc, char **argv)
+{
+	int i;
+	int force = 0;
+	int discard = 1;
+	int ret = 0;
+
+	while (1) {
+		int c;
+		static const struct option long_options[] = {
+			{ "nodiscard", optional_argument, NULL, 'K'},
+			{ "force", no_argument, NULL, 'f'},
+			{ NULL, 0, NULL, 0}
+		};
+
+		c = getopt_long(argc, argv, "f", long_options, NULL);
+		if (c < 0)
+			break;
+
+		switch (c) {
+		case 'K':
+			discard = 0;
+			break;
+		case 'f':
+			force = 1;
+			break;
+		default:
+			usage(cmd_spare_add_usage);
+		}
+	}
+
+	if (check_argc_min(argc - optind, 1))
+		usage(cmd_spare_add_usage);
+
+	for (i = optind; i < argc; i++) {
+		u64 dev_block_count = 0;
+		int devfd;
+		char *path;
+		int res;
+
+		if (test_dev_for_mkfs(argv[i], force)) {
+			ret++;
+			continue;
+		}
+
+		devfd = open(argv[i], O_RDWR);
+		if (devfd < 0) {
+			error("Unable to open device '%s'\n", argv[i]);
+			ret++;
+			continue;
+		}
+
+		res = btrfs_prepare_device(devfd, argv[i], 1,
+					&dev_block_count, 0, discard);
+		close(devfd);
+		if (res) {
+			ret++;
+			goto error_out;
+		}
+
+		path = canonicalize_path(argv[i]);
+		if (!path) {
+			error("Could not canonicalize pathname '%s': %s\n",
+				argv[i], strerror(errno));
+			ret++;
+			goto error_out;
+		}
+
+		btrfs_add_spare(path);
+		free(path);
+	}
+error_out:
+	btrfs_close_all_devices();
+	return !!ret;
+}
+
+static int cmd_spare_delete(int argc, char **argv)
+{
+	int i;
+	char *path;
+	int ret = 0;
+
+	if (check_argc_min(argc - optind, 1))
+		usage(cmd_spare_add_usage);
+
+	for (i = optind; i < argc; i++) {
+		int devfd;
+
+		devfd = open(argv[i], O_RDWR);
+		if (devfd < 0) {
+			error("Unable to open device '%s'\n", argv[i]);
+			ret++;
+			continue;
+		}
+		close(devfd);
+
+		path = canonicalize_path(argv[i]);
+		if (!path) {
+			error("Could not canonicalize pathname '%s': %s\n",
+				argv[i], strerror(errno));
+			ret++;
+			goto error_out;
+		}
+
+		btrfs_delete_spare(path);
+		free(path);
+	}
+
+error_out:
+	btrfs_close_all_devices();
+	return !!ret;
+}
+
+int cmd_spare_list(int argc, char **argv)
+{
+	int ret;
+	unsigned unit_mode;
+
+	unit_mode = get_unit_mode_from_arg(&argc, argv, 0);
+
+	ret = print_spare_device(unit_mode);
+
+	return !!ret;
+}
+
+static const char spare_cmd_group_info[] =
+	"manage spare devices in the filesystem";
+
+const struct cmd_group spare_cmd_group = {
+	spare_cmd_group_usage, spare_cmd_group_info, {
+		{ "add", cmd_spare_add, cmd_spare_add_usage, NULL, 0 },
+		{ "delete", cmd_spare_delete, cmd_spare_delete_usage, NULL, 0},
+		{ "list", cmd_spare_list, cmd_spare_list_usage, NULL, 0},
+		NULL_CMD_STRUCT
+	}
+};
+
+int cmd_spare(int argc, char **argv)
+{
+	return handle_command_group(&spare_cmd_group, argc, argv);
+}
diff --git a/commands.h b/commands.h
index 2da093bf81a3..c9be13fb15ba 100644
--- a/commands.h
+++ b/commands.h
@@ -95,6 +95,7 @@ extern const struct cmd_group quota_cmd_group;
 extern const struct cmd_group qgroup_cmd_group;
 extern const struct cmd_group replace_cmd_group;
 extern const struct cmd_group rescue_cmd_group;
+extern const struct cmd_group spare_cmd_group;
 
 extern const char * const cmd_send_usage[];
 extern const char * const cmd_receive_usage[];
@@ -119,6 +120,7 @@ int cmd_receive(int argc, char **argv);
 int cmd_quota(int argc, char **argv);
 int cmd_qgroup(int argc, char **argv);
 int cmd_replace(int argc, char **argv);
+int cmd_spare(int argc, char **argv);
 int cmd_restore(int argc, char **argv);
 int cmd_select_super(int argc, char **argv);
 int cmd_dump_super(int argc, char **argv);
-- 
2.7.0

