Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21238 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932600AbdDQD0y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Apr 2017 23:26:54 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 7/9] btrfs-progs: modify: Add support to corrupt specified mirror
Date: Mon, 17 Apr 2017 11:26:40 +0800
Message-ID: <20170417032642.30770-8-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170417032642.30770-1-quwenruo@cn.fujitsu.com>
References: <20170417032642.30770-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add a subcommand, mirror, for btrfs-modify.

The mirror subcommand is used to modify specified mirror (P/Q included) of
a logical range.

Currently the mirror can be specified by --logical, --length and
--mirror.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/btrfs-modify.asciidoc |  28 +++-
 Makefile                            |   6 +-
 modify/main.c                       |   2 +
 modify/mirror.c                     | 282 ++++++++++++++++++++++++++++++++++++
 modify/modify_commands.h            |  25 ++++
 5 files changed, 339 insertions(+), 4 deletions(-)
 create mode 100644 modify/mirror.c
 create mode 100644 modify/modify_commands.h

diff --git a/Documentation/btrfs-modify.asciidoc b/Documentation/btrfs-modify.asciidoc
index 7d6e8e73..ae2ada65 100644
--- a/Documentation/btrfs-modify.asciidoc
+++ b/Documentation/btrfs-modify.asciidoc
@@ -16,11 +16,35 @@ experienced user to fix filesystem, or corrupt fs for test purpose.
 
 COMMANDS
 --------
-Nothing yet
+*mirror*::
+Modify specified mirror, including RAID56 P/Q stripe.
 
 OPTIONS
 -------
-Nothing yet
+*Mirror command options*::
+--logical <address>::::
+Specify the start logical address to modify. Must be aligned to sectorsize.
++
+Must be specified
+
+--length <length>::::
+Specify the length to modify. Must be aligned to sectorsize.
++
+Default value is the sectorsize of the filesystem, if not specified.
+
+--stripe <stripe number>::::
+Specify the stripe number to modify.
++
+0 for 1st data stripe. All profiles support stripe number 0. +
+1 for backup data stripe. Only mirror based profiles (DUP,RAID1,RAID10) support
+stripe number 1.
+P for RAID56 1st parity stripe. Only RAID5 and RAID6 support stripe number P.
+Q for RAID6 2nd parity stripe.
+
+EXIT STATUS
+-----------
+*btrfs-modify* returns a zero exit status if all its operations succeed.
+None zero is returned if any error happens.
 
 AVAILABILITY
 ------------
diff --git a/Makefile b/Makefile
index 633c4447..18ea6051 100644
--- a/Makefile
+++ b/Makefile
@@ -103,6 +103,7 @@ cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-property.o cmds-fi-usage.o cmds-inspect-dump-tree.o \
 	       cmds-inspect-dump-super.o cmds-inspect-tree-stats.o cmds-fi-du.o \
 	       mkfs/common.o
+modify_objects = modify/mirror.o
 libbtrfs_objects = send-stream.o send-utils.o kernel-lib/rbtree.o btrfs-list.o \
 		   kernel-lib/crc32c.o messages.o \
 		   uuid-tree.o utils-lib.o rbtree-utils.o
@@ -394,11 +395,11 @@ btrfs-image.static: image/main.static.o $(static_objects) $(static_libbtrfs_obje
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(STATIC_CFLAGS) -o $@ $^ $(STATIC_LDFLAGS) $(STATIC_LIBS) $(STATIC_LIBS_COMP)
 
-btrfs-modify: modify/main.o $(objects) $(libs_static)
+btrfs-modify: modify/main.o $(modify_objects) $(objects) $(libs_static)
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS) $(LIBS) $(LIBS_COMP)
 
-btrfs-modify.static: modify/main.static.o $(static_objects) $(static_libbtrfs_objects)
+btrfs-modify.static: modify/main.static.o $(static_objects) $(static_libbtrfs_objects) $(modify_objects)
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o $@ $^ $(STATIC_LDFLAGS) $(STATIC_LIBS) $(STATIC_LIBS_COMP)
 
@@ -514,6 +515,7 @@ clean: $(CLEANDIRS)
 		image/*.o image/*.o.d \
 		convert/*.o convert/*.o.d \
 		mkfs/*.o mkfs/*.o.d \
+		modify/*.o modify/*.o.d \
 	      dir-test ioctl-test quick-test library-test library-test-static \
 	      btrfs.static mkfs.btrfs.static fssum \
 	      $(check_defs) \
diff --git a/modify/main.c b/modify/main.c
index 107e2e7e..eca93fc2 100644
--- a/modify/main.c
+++ b/modify/main.c
@@ -33,6 +33,7 @@
 #include "help.h"
 #include "commands.h"
 #include "crc32c.h"
+#include "modify/modify_commands.h"
 
 const char * const modify_group_usage[] = {
 	"btrfs-modify <command> <dest_options> <device>",
@@ -53,6 +54,7 @@ static const char modify_group_info[] =
 
 static const struct cmd_group modify_cmd_group = {
 	modify_group_usage, modify_group_info, {
+		{ "mirror", modify_mirror, modify_mirror_usage, NULL, 0 },
 		NULL_CMD_STRUCT
 	},
 };
diff --git a/modify/mirror.c b/modify/mirror.c
new file mode 100644
index 00000000..f17dc9a7
--- /dev/null
+++ b/modify/mirror.c
@@ -0,0 +1,282 @@
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
+#include <strings.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <limits.h>
+#include <getopt.h>
+#include <unistd.h>
+#include "utils.h"
+#include "ctree.h"
+#include "kerncompat.h"
+#include "help.h"
+#include "disk-io.h"
+#include "volumes.h"
+#include "modify/modify_commands.h"
+
+const char * const modify_mirror_usage[] = {
+	"btrfs-modify mirror <options> <device>",
+	"Modify specified mirror/parity of a filesystem(unmounted).",
+	"<options> are used to specify the destination.",
+	"See 'btrfs-modify'(8) for supported options",
+	NULL
+};
+
+#define STRIPE_UNINITILIZED	(-1)
+#define STRIPE_P		(-2)
+#define STRIPE_Q		(-3)
+
+static char write_buf[BTRFS_STRIPE_LEN] = { 0 };
+
+static int strtostripe(const char *str)
+{
+	u32 tmp;
+
+	if (!strncasecmp(str, "p", strlen("p") + 1))
+		return STRIPE_P;
+	if (!strncasecmp(str, "q", strlen("q") + 1))
+		return STRIPE_Q;
+	tmp = arg_strtou32(str);
+	return (int)tmp;
+}
+
+static int write_range_fd(int fd, u64 offset, u64 len)
+{
+	u64 cur = offset;
+	int ret;
+
+	while (cur < offset + len) {
+		u64 write_len = min(offset + len - cur, (u64)BTRFS_STRIPE_LEN);
+		ret = pwrite(fd, write_buf, write_len, cur);
+		if (ret < 0)
+			return -errno;
+		cur += ret;
+	}
+	return 0;
+}
+
+static int corrupt_mapped_range(struct btrfs_fs_info *fs_info,
+				struct btrfs_map_block *map, u64 logical,
+				u64 len, int stripe_num)
+{
+	u64 mirror_profiles = BTRFS_BLOCK_GROUP_RAID1 |
+			      BTRFS_BLOCK_GROUP_RAID10 |
+			      BTRFS_BLOCK_GROUP_DUP;
+	u64 parity_profiles = BTRFS_BLOCK_GROUP_RAID5 |
+			      BTRFS_BLOCK_GROUP_RAID6;
+	int i;
+	int ret;
+
+	/* Check stripe_num with map->profiles */
+	if (!(map->type & mirror_profiles) && stripe_num > 0) {
+		error("logical range [%llu, %llu) doesn't have extra mirror",
+			map->start, map->length);
+		return -EINVAL;
+	}
+	if (stripe_num == STRIPE_P && !(map->type & parity_profiles)) {
+		error("logical range [%llu, %llu) doesn't have P stripe",
+			map->start, map->length);
+		return -EINVAL;
+	}
+	if (stripe_num == STRIPE_Q && !(map->type & BTRFS_BLOCK_GROUP_RAID6)) {
+		error("logical range [%llu, %llu) doesn't have Q stripe",
+			map->start, map->length);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < map->num_stripes; i++) {
+		struct btrfs_map_stripe *stripe = &map->stripes[i];
+
+		u64 corrupt_logical = 0;
+		u64 corrupt_phy;
+		u64 corrupt_len;
+
+		if (stripe_num == STRIPE_P || stripe_num == STRIPE_Q) {
+			u64 dest_logical;
+
+			if (stripe_num == STRIPE_P)
+				dest_logical = BTRFS_RAID5_P_STRIPE;
+			else
+				dest_logical = BTRFS_RAID6_Q_STRIPE;
+			if (stripe->logical != dest_logical)
+				continue;
+
+			/* For P/Q, corrupt the whole stripe */
+			corrupt_phy = stripe->physical;
+			corrupt_len = stripe->length;
+		} else  {
+			/* Skip unrelated mirror stripe */
+			if (map->type & mirror_profiles && i % 2 != stripe_num)
+				continue;
+
+			corrupt_logical = max(stripe->logical, logical);
+			corrupt_phy = corrupt_logical - stripe->logical +
+					stripe->physical;
+			corrupt_len = min(stripe->logical + stripe->length,
+					logical + len) - corrupt_logical;
+		}
+		ret = write_range_fd(stripe->dev->fd, corrupt_phy,
+				     corrupt_len);
+		if (ret < 0) {
+			if (stripe_num == STRIPE_P || stripe_num == STRIPE_Q)
+				error(
+			"failded to write %s stripe for full stripe [%llu, %llu): %s",
+					(stripe_num == STRIPE_P ? "P" : "Q"),
+					map->start, map->start + map->length,
+					strerror(-ret));
+			else
+				error(
+			"failed to write data for logical range [%llu, %llu): %s",
+					corrupt_logical,
+					corrupt_logical + corrupt_len,
+					strerror(-ret));
+			return ret;
+		}
+	}
+	return 0;
+}
+
+static int modify_logical(struct btrfs_fs_info *fs_info, u64 logical, u64 len,
+			  int stripe)
+{
+	u32 sectorsize = fs_info->tree_root->sectorsize;
+	u64 cur;
+	int ret;
+
+	if (!IS_ALIGNED(logical, sectorsize)) {
+		error("logical address %llu is not aligned to sectorsize %d",
+			logical, sectorsize);
+		return -EINVAL;
+	}
+	if (!IS_ALIGNED(len, sectorsize)) {
+		error("length %llu is not aligned to sectorsize %d",
+			len, sectorsize);
+		return -EINVAL;
+	}
+	/* Current btrfs only support 1 mirror */
+	if (stripe > 1) {
+		error("btrfs only supports 1 mirror, stripe number %d is invalid",
+			stripe);
+		return -EINVAL;
+	}
+
+	cur = logical;
+
+	while (cur < logical + len) {
+		struct btrfs_map_block *map;
+
+		ret = __btrfs_map_block_v2(fs_info, WRITE, cur,
+					   logical + len - cur, &map);
+		if (ret < 0) {
+			error("failed to map logical range [%llu, %llu): %s",
+				cur, logical + len, strerror(-ret));
+			return ret;
+		}
+		ret = corrupt_mapped_range(fs_info, map, cur,
+					   logical + len - cur, stripe);
+		if (ret < 0) {
+			error("failed to modify on-disk data for range [%llu, %llu): %s",
+				cur, logical + len, strerror(-ret));
+			free(map);
+			return ret;
+		}
+		cur = map->start + map->length;
+	}
+	return 0;
+}
+
+int modify_mirror(int argc, char **argv)
+{
+	struct btrfs_fs_info *fs_info;
+	char *device;
+	u64 length = (u64)-1;
+	u64 logical = (u64)-1;
+	int stripe = STRIPE_UNINITILIZED;
+	int ret;
+
+	while (1) {
+		int c;
+		enum { GETOPT_VAL_LOGICAL = 257, GETOPT_VAL_LENGTH,
+			GETOPT_VAL_STRIPE };
+		static const struct option long_options[] = {
+			{ "logical", required_argument, NULL,
+				GETOPT_VAL_LOGICAL },
+			{ "length", required_argument, NULL,
+				GETOPT_VAL_LENGTH },
+			{ "stripe", required_argument, NULL, GETOPT_VAL_STRIPE }
+		};
+
+		c = getopt_long(argc, argv, "", long_options, NULL);
+		if (c < 0)
+			break;
+		switch (c) {
+		case GETOPT_VAL_LOGICAL:
+			logical = arg_strtou64(optarg);
+			break;
+		case GETOPT_VAL_LENGTH:
+			length = arg_strtou64(optarg);
+			break;
+		case GETOPT_VAL_STRIPE:
+			stripe = strtostripe(optarg);
+			break;
+		case '?':
+		case 'h':
+			usage(modify_mirror_usage);
+		}
+	}
+	if (check_argc_exact(argc - optind, 1))
+		usage(modify_mirror_usage);
+	device = argv[optind];
+	
+	ret = check_mounted(device);
+	if (ret < 0) {
+		error("could not check mount status for device %s: %s",
+			device, strerror(-ret));
+		return ret;
+	}
+	if (ret > 0) {
+		error("%s is currently mounted, aborting", device);
+		return -EINVAL;
+	}
+	if (logical == (u64)-1) {
+		error("--logical must be specified");
+		return -EINVAL;
+	}
+	if (stripe == STRIPE_UNINITILIZED) {
+		printf("--stripe not specified, fallback to 0 (1st stripe)\n");
+		stripe = 0;
+	}
+
+	fs_info = open_ctree_fs_info(device, 0, 0, 0, OPEN_CTREE_WRITES);
+	if (!fs_info) {
+		error("failed to open btrfs on device %s\n", device);
+		return -EIO;
+	}
+	if (length == (u64)-1) {
+		printf("--length not specified, fallback to sectorsize (%d)\n",
+			fs_info->tree_root->sectorsize);
+		length = fs_info->tree_root->sectorsize;
+	}
+	ret = modify_logical(fs_info, logical, length, stripe);
+	if (ret < 0)
+		error("failed to modify btrfs: %s", strerror(-ret));
+	else
+		printf("Succeeded in modifying specified mirror\n");
+
+	close_ctree(fs_info->tree_root);
+	return ret;
+}
diff --git a/modify/modify_commands.h b/modify/modify_commands.h
new file mode 100644
index 00000000..0d3e188f
--- /dev/null
+++ b/modify/modify_commands.h
@@ -0,0 +1,25 @@
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
+#ifndef __BTRFS_MODIFY_COMMANDS_H__
+#define __BTRFS_MODIFY_COMMANDS_H__
+
+#include "commands.h"
+
+extern const char * const modify_mirror_usage[];
+int modify_mirror(int argc, char **argv);
+
+#endif
-- 
2.12.2



