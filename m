Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:6733 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751903Ab3IRIaX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Sep 2013 04:30:23 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r8I8UG7J030190
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Sep 2013 16:30:17 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/4] Btrfs-progs: add super-recover to recover bad supers
Date: Wed, 18 Sep 2013 16:27:36 +0800
Message-Id: <1379492856-30639-5-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1379492856-30639-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1379492856-30639-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Until now if one of device's first superblock is corrupt,btrfs
will fail to mount. Luckily, btrfs have at least two superblocks
for every disk.

In theory, if silent corrupting happens when we are writting
superblocks into disk, we must hold at least one good superblock.

One side effect is that user must gurantee that the disk must be
a btrfs disk. Otherwise, this tool may destroy other fs.(This is also
reason why btrfs only use first superblock in every disk to mount)

This little program will try to correct bad superblocks from
good superblocks with max generation.

However, users should gurantee the disk passed is a btrfs disk,
otherwise, the tool may destroy other fs.

There will be five kinds of return values:

0: all supers are valid, no need to recover
1: usage or syntax error
2: recover all bad superblocks successfully
3: fail to recover bad superblocks
4: abort to recover bad superblocks

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 Makefile        |   2 +-
 cmds-rescue.c   |  55 ++++++++++
 commands.h      |   2 +
 disk-io.c       |  33 +++++-
 disk-io.h       |   2 +
 super-recover.c | 323 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 411 insertions(+), 6 deletions(-)
 create mode 100644 super-recover.c

diff --git a/Makefile b/Makefile
index bd32121..3acb3b8 100644
--- a/Makefile
+++ b/Makefile
@@ -14,7 +14,7 @@ cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
 	       cmds-restore.o cmds-dedup.o cmds-rescue.o \
-	       chunk-recover.o
+	       chunk-recover.o super-recover.o
 libbtrfs_objects = send-stream.o send-utils.o rbtree.o btrfs-list.o crc32c.o \
 		   uuid-tree.o
 libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
diff --git a/cmds-rescue.c b/cmds-rescue.c
index cfbc198..e18eb98 100644
--- a/cmds-rescue.c
+++ b/cmds-rescue.c
@@ -28,6 +28,7 @@ static const char * const rescue_cmd_group_usage[] = {
 };
 
 int btrfs_recover_chunk_tree(char *path, int verbose, int yes);
+int btrfs_recover_superblocks(char *path, int verbose, int yes);
 
 const char * const cmd_chunk_recover_usage[] = {
 	"btrfs rescue chunk-recover [options] <device>",
@@ -39,6 +40,15 @@ const char * const cmd_chunk_recover_usage[] = {
 	NULL
 };
 
+const char * const cmd_super_recover_usage[] = {
+	"btrfs rescue super-recover [options] <device>",
+	"Recover bad superblocks from good copies",
+	"",
+	"-y	Assume an answer of `yes' to all questions",
+	"-v	Verbose mode",
+	NULL
+};
+
 int cmd_chunk_recover(int argc, char *argv[])
 {
 	int ret = 0;
@@ -87,9 +97,54 @@ int cmd_chunk_recover(int argc, char *argv[])
 	return ret;
 }
 
+/*
+ * return codes:
+ *   0 : All superblocks are valid, no need to recover
+ *   1 : Usage or syntax error
+ *   2 : Recover all bad superblocks successfully
+ *   3 : Fail to Recover bad supeblocks
+ *   4 : Abort to recover bad superblocks
+ */
+int cmd_super_recover(int argc, char **argv)
+{
+	int ret;
+	int verbose = 0;
+	int yes = 0;
+	char *dname;
+
+	while (1) {
+		int c = getopt(argc, argv, "vy");
+		if (c < 0)
+			break;
+		switch (c) {
+		case 'v':
+			verbose = 1;
+			break;
+		case 'y':
+			yes = 1;
+			break;
+		default:
+			usage(cmd_super_recover_usage);
+		}
+	}
+	argc = argc - optind;
+	if (argc != 1)
+		usage(cmd_super_recover_usage);
+
+	dname = argv[optind];
+	ret = check_mounted(dname);
+	if (ret) {
+		fprintf(stderr, "the device is busy\n");
+		return 1;
+	}
+	ret = btrfs_recover_superblocks(dname, verbose, yes);
+	return ret;
+}
+
 const struct cmd_group rescue_cmd_group = {
 	rescue_cmd_group_usage, NULL, {
 		{ "chunk-recover", cmd_chunk_recover, cmd_chunk_recover_usage, NULL, 0},
+		{ "super-recover", cmd_super_recover, cmd_super_recover_usage, NULL, 0},
 		{ 0, 0, 0, 0, 0 }
 	}
 };
diff --git a/commands.h b/commands.h
index d25b8c1..24a5bd8 100644
--- a/commands.h
+++ b/commands.h
@@ -97,6 +97,7 @@ extern const char * const cmd_send_usage[];
 extern const char * const cmd_receive_usage[];
 extern const char * const cmd_check_usage[];
 extern const char * const cmd_chunk_recover_usage[];
+extern const char * const cmd_super_recover_usage[];
 extern const char * const cmd_restore_usage[];
 extern const char * const cmd_rescue_usage[];
 
@@ -107,6 +108,7 @@ int cmd_device(int argc, char **argv);
 int cmd_scrub(int argc, char **argv);
 int cmd_check(int argc, char **argv);
 int cmd_chunk_recover(int argc, char **argv);
+int cmd_super_recover(int argc, char **argv);
 int cmd_inspect(int argc, char **argv);
 int cmd_send(int argc, char **argv);
 int cmd_receive(int argc, char **argv);
diff --git a/disk-io.c b/disk-io.c
index 6281569..de89fa3 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -982,7 +982,8 @@ int btrfs_setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info)
 static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 					     u64 sb_bytenr,
 					     u64 root_tree_bytenr, int writes,
-					     int partial, int restore)
+					     int partial, int restore,
+					     int run_ioctl)
 {
 	struct btrfs_fs_info *fs_info;
 	struct btrfs_super_block *disk_super;
@@ -1005,7 +1006,8 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	if (restore)
 		fs_info->on_restoring = 1;
 
-	ret = btrfs_scan_fs_devices(fp, path, &fs_devices, sb_bytenr, 1);
+	ret = btrfs_scan_fs_devices(fp, path, &fs_devices, sb_bytenr,
+				    run_ioctl);
 	if (ret)
 		goto out;
 
@@ -1078,7 +1080,7 @@ struct btrfs_fs_info *open_ctree_fs_info_restore(const char *filename,
 		return NULL;
 	}
 	info = __open_ctree_fd(fp, filename, sb_bytenr, root_tree_bytenr,
-			       writes, partial, restore);
+			       writes, partial, restore, 1);
 	close(fp);
 	return info;
 }
@@ -1100,11 +1102,32 @@ struct btrfs_fs_info *open_ctree_fs_info(const char *filename,
 		return NULL;
 	}
 	info = __open_ctree_fd(fp, filename, sb_bytenr, root_tree_bytenr,
-			       writes, partial, 0);
+			       writes, partial, 0, 1);
 	close(fp);
 	return info;
 }
 
+struct btrfs_root *open_ctree_with_broken_super(const char *filename,
+					u64 sb_bytenr, int writes)
+{
+	int fp;
+	struct btrfs_fs_info *info;
+	int flags = O_CREAT | O_RDWR;
+
+	if (!writes)
+		flags = O_RDONLY;
+
+	fp = open(filename, flags, 0600);
+	if (fp < 0) {
+		fprintf(stderr, "Could not open %s\n", filename);
+		return NULL;
+	}
+	info = __open_ctree_fd(fp, filename, sb_bytenr, 0,
+			       writes, 0, 0, 0);
+	close(fp);
+	return info->fs_root;
+}
+
 struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr, int writes)
 {
 	struct btrfs_fs_info *info;
@@ -1119,7 +1142,7 @@ struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
 				 int writes)
 {
 	struct btrfs_fs_info *info;
-	info = __open_ctree_fd(fp, path, sb_bytenr, 0, writes, 0, 0);
+	info = __open_ctree_fd(fp, path, sb_bytenr, 0, writes, 0, 0, 1);
 	if (!info)
 		return NULL;
 	return info->fs_root;
diff --git a/disk-io.h b/disk-io.h
index 7219c2e..681ff79 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -70,6 +70,8 @@ struct btrfs_fs_info *open_ctree_fs_info_restore(const char *filename,
 struct btrfs_fs_info *open_ctree_fs_info(const char *filename,
 					 u64 sb_bytenr, u64 root_tree_bytenr,
 					 int writes, int partial);
+struct btrfs_root *open_ctree_with_broken_super(const char *filename,
+					u64 sb_bytenr, int writes);
 int close_ctree(struct btrfs_root *root);
 int write_all_supers(struct btrfs_root *root);
 int write_ctree_super(struct btrfs_trans_handle *trans,
diff --git a/super-recover.c b/super-recover.c
new file mode 100644
index 0000000..8c9c5a2
--- /dev/null
+++ b/super-recover.c
@@ -0,0 +1,323 @@
+/*
+ * Copyright (C) 2013 Fujitsu.  All rights reserved.
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
+#define _XOPEN_SOURCE 500
+#define _GNU_SOURCE 1
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <fcntl.h>
+#include <sys/stat.h>
+#include <uuid/uuid.h>
+#include <errno.h>
+#include <unistd.h>
+#include <ctype.h>
+#include <getopt.h>
+
+#include "kerncompat.h"
+#include "ctree.h"
+#include "disk-io.h"
+#include "list.h"
+#include "utils.h"
+#include "crc32c.h"
+#include "volumes.h"
+#include "version.h"
+#include "transaction.h"
+
+#include "commands.h"
+
+struct btrfs_recover_superblock {
+	struct btrfs_fs_devices *fs_devices;
+
+	struct list_head good_supers;
+	struct list_head bad_supers;
+
+	u64 max_generation;
+	int recover_flag;
+};
+
+struct super_block_record {
+	struct list_head list;
+
+	char *device_name;
+	struct btrfs_super_block sb;
+
+	u64 bytenr;
+};
+
+static
+void init_recover_superblock(struct btrfs_recover_superblock *recover)
+{
+	INIT_LIST_HEAD(&recover->good_supers);
+	INIT_LIST_HEAD(&recover->bad_supers);
+
+	recover->fs_devices = NULL;
+	recover->max_generation = 0;
+	recover->recover_flag = 0;
+}
+
+static
+void free_recover_superblock(struct btrfs_recover_superblock *recover)
+{
+	struct btrfs_device *device;
+	struct super_block_record *record;
+
+	if (!recover->fs_devices)
+		return;
+
+	while (!list_empty(&recover->fs_devices->devices)) {
+		device = list_entry(recover->fs_devices->devices.next,
+				struct btrfs_device, dev_list);
+		list_del_init(&device->dev_list);
+		free(device->name);
+		free(device);
+	}
+	free(recover->fs_devices);
+
+	while (!list_empty(&recover->good_supers)) {
+		record = list_entry(recover->good_supers.next,
+				struct super_block_record, list);
+		list_del_init(&record->list);
+		free(record->device_name);
+		free(record);
+	}
+
+	while (!list_empty(&recover->bad_supers)) {
+		record = list_entry(recover->bad_supers.next,
+				struct super_block_record, list);
+		list_del_init(&record->list);
+		free(record->device_name);
+		free(record);
+	}
+}
+
+static int check_super(u64 bytenr, struct btrfs_super_block *sb)
+{
+	int csum_size = btrfs_super_csum_size(sb);
+	char result[csum_size];
+	u32 crc = ~(u32)0;
+
+	if (btrfs_super_bytenr(sb) != bytenr)
+		return 0;
+	if (sb->magic != cpu_to_le64(BTRFS_MAGIC))
+		return 0;
+
+	crc = btrfs_csum_data(NULL, (char *)sb + BTRFS_CSUM_SIZE,
+			crc, BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE);
+	btrfs_csum_final(crc, result);
+
+	return !memcmp(sb, &result, csum_size);
+}
+
+static int add_superblock_record(struct btrfs_super_block *sb, char *fname,
+			u64 bytenr, struct list_head *head)
+{
+	struct super_block_record *record;
+
+	record = malloc(sizeof(struct super_block_record));
+	if (!record)
+		return -ENOMEM;
+
+	record->device_name = strdup(fname);
+	if (!record->device_name) {
+		free(record);
+		return -ENOMEM;
+	}
+	memcpy(&record->sb, sb, sizeof(*sb));
+	record->bytenr = bytenr;
+	list_add_tail(&record->list, head);
+
+	return 0;
+}
+
+static int
+read_dev_supers(char *filename, struct btrfs_recover_superblock *recover)
+{
+	int i, ret, fd;
+	u8 buf[BTRFS_SUPER_INFO_SIZE];
+	u64 max_gen, bytenr;
+
+	struct btrfs_super_block *sb = (struct btrfs_super_block *)buf;
+
+	fd = open(filename, O_RDONLY, 0666);
+	if (fd < 0)
+		return -errno;
+
+	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
+		bytenr = btrfs_sb_offset(i);
+		ret = pread64(fd, buf, sizeof(buf), bytenr);
+		if (ret < sizeof(buf)) {
+			close(fd);
+			return -errno;
+		}
+		ret = check_super(bytenr, sb);
+		if (ret) {
+			ret = add_superblock_record(sb, filename, bytenr,
+							&recover->good_supers);
+			if (ret)
+				return ret;
+			max_gen = btrfs_super_generation(sb);
+			if (max_gen > recover->max_generation)
+				recover->max_generation = max_gen;
+		} else {
+			ret = add_superblock_record(sb, filename, bytenr,
+						&recover->bad_supers);
+			if (ret)
+				return ret;
+		}
+	}
+	close(fd);
+	return ret;
+}
+
+static int read_fs_supers(struct btrfs_recover_superblock *recover)
+{
+	struct super_block_record *record;
+	struct super_block_record *next_record;
+	struct btrfs_device *dev;
+	int ret;
+	u64 gen;
+
+	list_for_each_entry(dev, &recover->fs_devices->devices,
+				dev_list) {
+		ret = read_dev_supers(dev->name, recover);
+		if (ret)
+			return ret;
+	}
+	list_for_each_entry_safe(record, next_record,
+			&recover->good_supers, list) {
+		gen = btrfs_super_generation(&record->sb);
+		if (gen < recover->max_generation)
+			list_move_tail(&record->list, &recover->bad_supers);
+	}
+
+	return 0;
+}
+
+static struct super_block_record *recover_get_good_super(
+				struct btrfs_recover_superblock *recover)
+{
+	struct super_block_record *record;
+	record = list_entry(recover->good_supers.next,
+				struct super_block_record, list);
+	return record;
+}
+
+static void print_all_devices(struct list_head *devices)
+{
+	struct btrfs_device *dev;
+
+	printf("All Devices:\n");
+	list_for_each_entry(dev, devices, dev_list) {
+		printf("\t");
+		printf("Device: id = %llu, name = %s\n",
+			dev->devid, dev->name);
+	}
+	printf("\n");
+}
+
+static void print_super_info(struct super_block_record *record)
+{
+	printf("\t\tdevice name = %s\n", record->device_name);
+	printf("\t\tsuperblock bytenr = %llu\n", record->bytenr);
+}
+
+static void print_all_supers(struct btrfs_recover_superblock *recover)
+{
+	struct super_block_record *record;
+
+	printf("\t[All good supers]:\n");
+	list_for_each_entry(record, &recover->good_supers, list) {
+		print_super_info(record);
+		printf("\n");
+	}
+
+	printf("\t[All bad supers]:\n");
+	list_for_each_entry(record, &recover->bad_supers, list) {
+		print_super_info(record);
+		printf("\n");
+	}
+	printf("\n");
+}
+
+int btrfs_recover_superblocks(const char *dname,
+			int verbose, int yes)
+{
+	int fd, ret;
+	struct btrfs_recover_superblock recover;
+	struct super_block_record *record;
+	struct btrfs_root *root = NULL;
+
+	fd = open(dname, O_RDONLY);
+	if (fd < 0) {
+		fprintf(stderr, "open %s error\n", dname);
+		return 1;
+	}
+	init_recover_superblock(&recover);
+
+	ret = btrfs_scan_fs_devices(fd, dname, &recover.fs_devices, 0, 0);
+	if (ret) {
+		ret = 1;
+		goto no_recover;
+	}
+
+	if (verbose)
+		print_all_devices(&recover.fs_devices->devices);
+
+	ret = read_fs_supers(&recover);
+	if (ret) {
+		ret = 1;
+		goto out;
+	}
+	if (verbose) {
+		printf("Before Recovering:\n");
+		print_all_supers(&recover);
+	}
+
+	if (list_empty(&recover.bad_supers)) {
+		printf("All supers are valid, no need to recover\n");
+		goto no_recover;
+	}
+	if (!yes) {
+		ret = ask_user("Make sure this is a btrfs disk otherwise the tool will destroy other fs, Are you sure?");
+		if (!ret) {
+			ret = 4;
+			goto no_recover;
+		}
+	}
+	record = recover_get_good_super(&recover);
+	root = open_ctree_with_broken_super(record->device_name,
+					record->bytenr, O_RDWR);
+	BUG_ON(!root);
+
+	root->fs_info->super_bytenr = BTRFS_SUPER_INFO_OFFSET;
+	ret = write_all_supers(root);
+	if (!ret) {
+		ret = 2;
+		printf("Recovering bad superblocks successful\n");
+	} else {
+		ret = 3;
+		printf("Failed to recover bad superblocks\n");
+	}
+out:
+	close_ctree(root);
+no_recover:
+	free_recover_superblock(&recover);
+	return ret;
+}
+
-- 
1.8.3.1

