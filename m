Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:55151 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbaHNTzs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Aug 2014 15:55:48 -0400
Received: by mail-lb0-f177.google.com with SMTP id s7so1244579lbd.22
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Aug 2014 12:55:47 -0700 (PDT)
Received: from beplan.lan (nat3-minsk-pool-46-53-181-8.telecom.by. [46.53.181.8])
        by mx.google.com with ESMTPSA id zm10sm9241061lbb.17.2014.08.14.12.55.46
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Aug 2014 12:55:46 -0700 (PDT)
Message-ID: <53ED1441.2080005@gmail.com>
Date: Thu, 14 Aug 2014 22:55:45 +0300
From: Timofey Titovets <nefelim4ag@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Resend: [RFC PATCH] btrfs-progs: Move btrfstune to btrfs device tune
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Good time of day,
According to https://btrfs.wiki.kernel.org/index.php/Project_ideas#btrfs
Quote:
merge functionality of btrfstune, eg. under btrfs dev set-seed /dev/ 
(discuss the command name though)

This patch is just code move
After, user can tune btrfs parameters through:
btrfs dev tune -xr /dev/sda2

Also i merge two functions in one:
static int enable_extrefs_flag(struct btrfs_root *root)
and
static int enable_skinny_metadata(struct btrfs_root *root)
to
static void enable_flag(struct btrfs_root *root, u64 flag)
Where flag is:
BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA
BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF

Because function is identical.

P.S.
I write this patch on branch:
git://repo.or.cz/btrfs-progs-unstable/devel.git
But i think, what it can be safety applied on stable branch.
If it needed, i can redo and resend patch.

P.S.S
If it needed, i can move seed function in separated command, like in 
project ideas (btrfs dev set-seed /dev/ or something else).
And if seed is same as readonly, may be command must named like 
"readonly" 1/0 <dev>?

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
  Documentation/Makefile         |   3 +-
  Documentation/btrfs-device.txt |  19 +++-
  Makefile                       |  10 +--
  btrfstune.c                    | 197 
-----------------------------------------
  cmds-device.c                  | 156 ++++++++++++++++++++++++++++++++
  5 files changed, 177 insertions(+), 208 deletions(-)

diff --git a/Documentation/Makefile b/Documentation/Makefile
index 45299bb..75f50a2 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -9,7 +9,6 @@ MAN8_TXT += btrfs-find-root.txt
  MAN8_TXT += btrfs-image.txt
  MAN8_TXT += btrfs-map-logical.txt
  MAN8_TXT += btrfs-show-super.txt
-MAN8_TXT += btrfstune.txt
  MAN8_TXT += btrfs-zero-log.txt
  MAN8_TXT += fsck.btrfs.txt
  MAN8_TXT += mkfs.btrfs.txt
@@ -82,7 +81,7 @@ clean:
  %.8.gz : %.8
  	$(QUIET_GZIP)$(GZIP) -n -c $< > $@

-%.8 : %.xml
+%.8 : %.xml
  	$(QUIET_XMLTO)$(RM) $@ && \
  	$(XMLTO) -m $(MANPAGE_XSL) $(XMLTO_EXTRA) man $<
  %.xml : %.txt asciidoc.conf
diff --git a/Documentation/btrfs-device.txt b/Documentation/btrfs-device.txt
index 0f7917d..8f21672 100644
--- a/Documentation/btrfs-device.txt
+++ b/Documentation/btrfs-device.txt
@@ -80,10 +80,10 @@ Remove device(s) from a filesystem identified by <path>.
  *scan* [(--all-devices|-d)|<device> [<device>...]]::
  Scan devices for a btrfs filesystem.
  +
-If one or more devices are passed, these are scanned for a btrfs 
filesystem.
+If one or more devices are passed, these are scanned for a btrfs 
filesystem.
  If no devices are passed, btrfs uses block devices containing btrfs
  filesystem as listed by blkid.
-Finally, if '--all-devices' or '-d' is passed, all the devices under 
/dev are
+Finally, if '--all-devices' or '-d' is passed, all the devices under 
/dev are
  scanned.

  *ready* <device>::
@@ -98,6 +98,21 @@ identified by <path> or for a single <device>.
  -z::::
  Reset stats to zero after reading them.

+*tune* [options] <dev>::
+Used to tune various btrfs filesystem parameters, you can enable
+some extended features for btrfs and set seeding flag.
++
+`Options`
++
+-S <value>::
+Updates the seeding value, it forces a fs readonly so that you can use 
it to
+build other filesystems.
+-r::
+Enable extended inode refs.
+-x::
+Enable skinny metadata extent refs.
+
+
  EXIT STATUS
  -----------
  *btrfs device* returns a zero exist status if it succeeds. Non zero is
diff --git a/Makefile b/Makefile
index 76565e8..28e190f 100644
--- a/Makefile
+++ b/Makefile
@@ -48,7 +48,7 @@ MAKEOPTS = --no-print-directory Q=$(Q)

  progs = mkfs.btrfs btrfs-debug-tree btrfsck \
  	btrfs btrfs-map-logical btrfs-image btrfs-zero-log btrfs-convert \
-	btrfs-find-root btrfstune btrfs-show-super
+	btrfs-find-root btrfs-show-super

  # external libs required by various binaries; for btrfs-foo,
  # specify btrfs_foo_libs = <list of libs>; see $($(subst...)) rules below
@@ -85,7 +85,7 @@ lib_links = libbtrfs.so.0 libbtrfs.so
  headers = $(libbtrfs_headers)

  # make C=1 to enable sparse
-check_defs := .cc-defines.h
+check_defs := .cc-defines.h
  ifdef C
  	#
  	# We're trying to use sparse against glibc headers which go wild
@@ -200,10 +200,6 @@ mkfs.btrfs.static: $(static_objects) mkfs.static.o 
$(static_libbtrfs_objects)
  	$(Q)$(CC) $(STATIC_CFLAGS) -o mkfs.btrfs.static mkfs.static.o 
$(static_objects) \
  		$(static_libbtrfs_objects) $(STATIC_LDFLAGS) $(STATIC_LIBS)

-btrfstune: $(objects) $(libs) btrfstune.o
-	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) -o btrfstune $(objects) btrfstune.o $(LDFLAGS) $(LIBS)
-
  dir-test: $(objects) $(libs) dir-test.o
  	@echo "    [LD]     $@"
  	$(Q)$(CC) $(CFLAGS) -o dir-test $(objects) dir-test.o $(LDFLAGS) $(LIBS)
@@ -228,7 +224,7 @@ clean-all: clean-doc clean
  clean: $(CLEANDIRS)
  	@echo "Cleaning"
  	$(Q)rm -f $(progs) cscope.out *.o *.o.d btrfs-convert btrfs-image 
btrfs-select-super \
-	      btrfs-zero-log btrfstune dir-test ioctl-test quick-test 
send-test btrfsck \
+	      btrfs-zero-log dir-test ioctl-test quick-test send-test btrfsck \
  	      btrfs.static mkfs.btrfs.static btrfs-calc-size \
  	      version.h $(check_defs) \
  	      $(libs) $(lib_links)
diff --git a/btrfstune.c b/btrfstune.c
deleted file mode 100644
index 2c26fe9..0000000
--- a/btrfstune.c
+++ /dev/null
@@ -1,197 +0,0 @@
-/*
- * Copyright (C) 2008 Oracle.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License v2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
- */
-
-#define _XOPEN_SOURCE 500
-#define _GNU_SOURCE 1
-#include <stdio.h>
-#include <stdlib.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <fcntl.h>
-#include <unistd.h>
-#include <dirent.h>
-#include "kerncompat.h"
-#include "ctree.h"
-#include "disk-io.h"
-#include "transaction.h"
-#include "utils.h"
-#include "version.h"
-
-static char *device;
-
-static int update_seeding_flag(struct btrfs_root *root, int set_flag)
-{
-	struct btrfs_trans_handle *trans;
-	struct btrfs_super_block *disk_super;
-	u64 super_flags;
-
-	disk_super = root->fs_info->super_copy;
-	super_flags = btrfs_super_flags(disk_super);
-	if (set_flag) {
-		if (super_flags & BTRFS_SUPER_FLAG_SEEDING) {
-			fprintf(stderr, "seeding flag is already set on %s\n",
-				device);
-			return 1;
-		}
-		super_flags |= BTRFS_SUPER_FLAG_SEEDING;
-	} else {
-		if (!(super_flags & BTRFS_SUPER_FLAG_SEEDING)) {
-			fprintf(stderr, "seeding flag is not set on %s\n",
-				device);
-			return 1;
-		}
-		super_flags &= ~BTRFS_SUPER_FLAG_SEEDING;
-	}
-
-	trans = btrfs_start_transaction(root, 1);
-	btrfs_set_super_flags(disk_super, super_flags);
-	btrfs_commit_transaction(trans, root);
-
-	return 0;
-}
-
-static int enable_extrefs_flag(struct btrfs_root *root)
-{
-	struct btrfs_trans_handle *trans;
-	struct btrfs_super_block *disk_super;
-	u64 super_flags;
-
-	disk_super = root->fs_info->super_copy;
-	super_flags = btrfs_super_incompat_flags(disk_super);
-	super_flags |= BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF;
-	trans = btrfs_start_transaction(root, 1);
-	btrfs_set_super_incompat_flags(disk_super, super_flags);
-	btrfs_commit_transaction(trans, root);
-
-	return 0;
-}
-
-static int enable_skinny_metadata(struct btrfs_root *root)
-{
-	struct btrfs_trans_handle *trans;
-	struct btrfs_super_block *disk_super;
-	u64 super_flags;
-
-	disk_super = root->fs_info->super_copy;
-	super_flags = btrfs_super_incompat_flags(disk_super);
-	super_flags |= BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA;
-	trans = btrfs_start_transaction(root, 1);
-	btrfs_set_super_incompat_flags(disk_super, super_flags);
-	btrfs_commit_transaction(trans, root);
-
-	return 0;
-}
-
-static void print_usage(void)
-{
-	fprintf(stderr, "usage: btrfstune [options] device\n");
-	fprintf(stderr, "\t-S value\tenable/disable seeding\n");
-	fprintf(stderr, "\t-r \t\tenable extended inode refs\n");
-	fprintf(stderr, "\t-x enable skinny metadata extent refs\n");
-}
-
-int main(int argc, char *argv[])
-{
-	struct btrfs_root *root;
-	int success = 0;
-	int extrefs_flag = 0;
-	int seeding_flag = 0;
-	u64 seeding_value = 0;
-	int skinny_flag = 0;
-	int ret;
-
-	optind = 1;
-	while(1) {
-		int c = getopt(argc, argv, "S:rx");
-		if (c < 0)
-			break;
-		switch(c) {
-		case 'S':
-			seeding_flag = 1;
-			seeding_value = arg_strtou64(optarg);
-			break;
-		case 'r':
-			extrefs_flag = 1;
-			break;
-		case 'x':
-			skinny_flag = 1;
-			break;
-		default:
-			print_usage();
-			return 1;
-		}
-	}
-
-	argc = argc - optind;
-	device = argv[optind];
-	if (argc != 1) {
-		print_usage();
-		return 1;
-	}
-
-	if (!(seeding_flag + extrefs_flag + skinny_flag)) {
-		fprintf(stderr,
-			"ERROR: At least one option should be assigned.\n");
-		print_usage();
-		return 1;
-	}
-
-	ret = check_mounted(device);
-	if (ret < 0) {
-		fprintf(stderr, "Could not check mount status: %s\n",
-			strerror(-ret));
-		return 1;
-	} else if (ret) {
-		fprintf(stderr, "%s is mounted\n", device);
-		return 1;
-	}
-
-	root = open_ctree(device, 0, OPEN_CTREE_WRITES);
-
-	if (!root) {
-		fprintf(stderr, "Open ctree failed\n");
-		return 1;
-	}
-
-	if (seeding_flag) {
-		ret = update_seeding_flag(root, seeding_value);
-		if (!ret)
-			success++;
-	}
-
-	if (extrefs_flag) {
-		enable_extrefs_flag(root);
-		success++;
-	}
-
-	if (skinny_flag) {
-		enable_skinny_metadata(root);
-		success++;
-	}
-
-	if (success > 0) {
-		ret = 0;
-	} else {
-		root->fs_info->readonly = 1;
-		ret = 1;
-		fprintf(stderr, "btrfstune failed\n");
-	}
-	close_ctree(root);
-
-	return ret;
-}
diff --git a/cmds-device.c b/cmds-device.c
index c8586a0..eea02a5 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -14,6 +14,9 @@
   * Boston, MA 021110-1307, USA.
   */

+
+
+
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
@@ -24,10 +27,18 @@
  #include <sys/stat.h>
  #include <getopt.h>

+#define _XOPEN_SOURCE 500
+#define _GNU_SOURCE 1
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <dirent.h>
+
  #include "kerncompat.h"
  #include "ctree.h"
  #include "ioctl.h"
  #include "utils.h"
+#include "disk-io.h"
+#include "transaction.h"

  #include "commands.h"

@@ -422,6 +433,150 @@ out:
  	return err;
  }

+static const char * const cmd_dev_tune_usage[] = {
+	"btrfs device tune [options] device",
+	"-S value enable/disable seeding",
+	"-r       enable extended inode refs",
+	"-x       enable skinny metadata extent refs",
+	NULL
+};
+
+static int update_seeding_flag(struct btrfs_root *root, int set_flag, 
char *device)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_super_block *disk_super;
+	u64 super_flags;
+
+	disk_super = root->fs_info->super_copy;
+	super_flags = btrfs_super_flags(disk_super);
+	if (set_flag) {
+		if (super_flags & BTRFS_SUPER_FLAG_SEEDING) {
+			fprintf(stderr, "seeding flag is already set on %s\n",
+				device);
+			return 1;
+		}
+		super_flags |= BTRFS_SUPER_FLAG_SEEDING;
+	} else {
+		if (!(super_flags & BTRFS_SUPER_FLAG_SEEDING)) {
+			fprintf(stderr, "seeding flag is not set on %s\n",
+				device);
+			return 1;
+		}
+		super_flags &= ~BTRFS_SUPER_FLAG_SEEDING;
+	}
+
+	trans = btrfs_start_transaction(root, 1);
+	btrfs_set_super_flags(disk_super, super_flags);
+	btrfs_commit_transaction(trans, root);
+
+	return 0;
+}
+
+static void enable_flag(struct btrfs_root *root, u64 flag)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_super_block *disk_super;
+	u64 super_flags;
+
+	disk_super = root->fs_info->super_copy;
+	super_flags = btrfs_super_incompat_flags(disk_super);
+	super_flags |= flag;
+	trans = btrfs_start_transaction(root, 1);
+	btrfs_set_super_incompat_flags(disk_super, super_flags);
+	btrfs_commit_transaction(trans, root);
+}
+
+static int cmd_dev_tune(int argc, char **argv)
+{
+	struct btrfs_root *root;
+	char *device;
+	int success = 0;
+	int extrefs_flag = 0;
+	int seeding_flag = 0;
+	u64 seeding_value = 0;
+	int skinny_flag = 0;
+	int ret;
+
+	optind = 1;
+	while(1) {
+		int c = getopt(argc, argv, "S:rx");
+		if (c < 0 && argc)
+			break;
+		switch(c) {
+		case 'S':
+			seeding_flag = 1;
+			seeding_value = arg_strtou64(optarg);
+			break;
+		case 'r':
+			extrefs_flag = 1;
+			break;
+		case 'x':
+			skinny_flag = 1;
+			break;
+		default:
+			usage(cmd_dev_tune_usage);
+			return 1;
+		}
+	}
+
+	argc = argc - optind;
+	device = argv[optind];
+	if (argc != 1) {
+		usage(cmd_dev_tune_usage);
+		return 1;
+	}
+
+	if (!(seeding_flag + extrefs_flag + skinny_flag)) {
+		fprintf(stderr,
+			"ERROR: At least one option should be assigned.\n");
+		return 1;
+	}
+
+	ret = check_mounted(device);
+	if (ret < 0) {
+		fprintf(stderr, "Could not check mount status: %s\n",
+			strerror(-ret));
+		return 1;
+	} else if (ret) {
+		fprintf(stderr, "%s is mounted\n", device);
+		return 1;
+	}
+
+	root = open_ctree(device, 0, OPEN_CTREE_WRITES);
+
+	if (!root) {
+		fprintf(stderr, "Open ctree failed\n");
+		return 1;
+	}
+
+	if (seeding_flag) {
+		ret = update_seeding_flag(root, seeding_value, device);
+		if (!ret)
+			success++;
+	}
+
+	if (extrefs_flag) {
+		enable_flag(root, BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF);
+		success++;
+	}
+
+	if (skinny_flag) {
+		enable_flag(root, BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA);
+		success++;
+	}
+
+	if (success > 0) {
+		ret = 0;
+	} else {
+		root->fs_info->readonly = 1;
+		ret = 1;
+		fprintf(stderr, "btrfs device tune failed\n");
+	}
+	close_ctree(root);
+
+	return ret;
+}
+
  const struct cmd_group device_cmd_group = {
  	device_cmd_group_usage, NULL, {
  		{ "add", cmd_add_dev, cmd_add_dev_usage, NULL, 0 },
@@ -429,6 +584,7 @@ const struct cmd_group device_cmd_group = {
  		{ "scan", cmd_scan_dev, cmd_scan_dev_usage, NULL, 0 },
  		{ "ready", cmd_ready_dev, cmd_ready_dev_usage, NULL, 0 },
  		{ "stats", cmd_dev_stats, cmd_dev_stats_usage, NULL, 0 },
+		{ "tune", cmd_dev_tune, cmd_dev_tune_usage, NULL, 0 },
  		NULL_CMD_STRUCT
  	}
  };


-- 
Best regards,
Timofey.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo
