Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.vapor.com ([83.220.149.2]:39473 "EHLO nitrogen.vapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756024Ab3BHAlB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Feb 2013 19:41:01 -0500
Received: from twilight.demius.net (c-297271d5.013-195-6c756e10.cust.bredbandsbolaget.se [213.113.114.41])
	by nitrogen.vapor.com (Postfix) with ESMTPSA id 1699940C778
	for <linux-btrfs@vger.kernel.org>; Fri,  8 Feb 2013 01:40:55 +0100 (CET)
From: Ian Kumlien <pomac@demius.net>
To: linux-btrfs@vger.kernel.org
Cc: Ian Kumlien <pomac@demius.net>
Subject: [PATCH 6/6] Btrfs-progs: add the rescue section to btrfs
Date: Fri,  8 Feb 2013 01:37:02 +0100
Message-Id: <1360283822-23452-7-git-send-email-pomac@demius.net>
In-Reply-To: <1360283822-23452-1-git-send-email-pomac@demius.net>
References: <1360283822-23452-1-git-send-email-pomac@demius.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

the btrfs command now lists:
    btrfs rescue select-super -s <number> <device>
        Select a superblock
    btrfs rescue dump-super <device>
        Dump a superblock to disk
    btrfs rescue debug-tree [options] <device>
        Debug the filesystem

btrfs-dump-super.c was imported in to cmds-rescue-super-ops.c

This patch integrates all the functionality...

cmds-rescue.c is used to glue cmds-rescue-debug-tree.c,
cmds-rescue-restore.c and cmds-rescue-super-ops.c together to
make the source files more managable.

Signed-off-by: Ian Kumlien <pomac@demius.net>
---
 Makefile                 |  34 +++++-----------
 btrfs-dump-super.c       |  87 ---------------------------------------
 btrfs.c                  |   2 +
 cmds-rescue-debug-tree.c |  44 ++++++++++----------
 cmds-rescue-super-ops.c  | 103 +++++++++++++++++++++++++++++++++++++----------
 cmds-rescue.c            |  48 ++++++++++++++++++++++
 cmds-restore.c           |  42 +++++++++++--------
 commands.h               |   8 +++-
 8 files changed, 195 insertions(+), 173 deletions(-)
 delete mode 100644 btrfs-dump-super.c
 create mode 100644 cmds-rescue.c

diff --git a/Makefile b/Makefile
index 94541b2..7e2db76 100644
--- a/Makefile
+++ b/Makefile
@@ -8,7 +8,9 @@ objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  send-stream.o send-utils.o qgroup.o raid6.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
-	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o
+	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
+	       cmds-rescue.o cmds-rescue-super-ops.o \
+	       cmds-rescue-debug-tree.o cmds-restore.o
 
 CHECKFLAGS= -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise \
 	    -Wuninitialized -Wshadow -Wundef
@@ -17,8 +19,7 @@ DEPFLAGS = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
 INSTALL = install
 prefix ?= /usr/local
 bindir = $(prefix)/bin
-LIBS=-luuid -lm
-RESTORE_LIBS=-lz -llzo2
+LIBS=-luuid -lm -lz -llzo2
 
 ifeq ("$(origin V)", "command line")
   BUILD_VERBOSE = $(V)
@@ -35,10 +36,9 @@ endif
 
 MAKEOPTS = --no-print-directory Q=$(Q)
 
-progs = btrfsctl mkfs.btrfs btrfs-debug-tree btrfs-show btrfs-vol \
-	btrfs btrfs-map-logical btrfs-image btrfs-zero-log btrfs-convert \
-	btrfs-find-root btrfs-restore btrfstune btrfs-show-super \
-	btrfs-dump-super
+progs = btrfsctl mkfs.btrfs btrfs-show btrfs-vol btrfs \
+	btrfs-map-logical btrfs-image btrfs-zero-log btrfs-convert \
+	btrfs-find-root btrfstune \
 
 # Create all the static targets
 static_objects = $(patsubst %.o, %.static.o, $(objects))
@@ -95,10 +95,6 @@ btrfs-find-root: $(objects) find-root.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o btrfs-find-root find-root.o $(objects) $(LDFLAGS) $(LIBS)
 
-btrfs-restore: $(objects) restore.o
-	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) -o btrfs-restore restore.o $(objects) $(LDFLAGS) $(LIBS) $(RESTORE_LIBS)
-
 btrfsctl: $(objects) btrfsctl.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o btrfsctl btrfsctl.o $(objects) $(LDFLAGS) $(LIBS)
@@ -115,10 +111,6 @@ mkfs.btrfs: $(objects) mkfs.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o mkfs.btrfs $(objects) mkfs.o $(LDFLAGS) $(LIBS) -lblkid
 
-btrfs-debug-tree: $(objects) debug-tree.o
-	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) -o btrfs-debug-tree $(objects) debug-tree.o $(LDFLAGS) $(LIBS)
-
 btrfs-zero-log: $(objects) btrfs-zero-log.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o btrfs-zero-log $(objects) btrfs-zero-log.o $(LDFLAGS) $(LIBS)
@@ -127,14 +119,6 @@ btrfs-show-super: $(objects) btrfs-show-super.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o btrfs-show-super $(objects) btrfs-show-super.o $(LDFLAGS) $(LIBS)
 
-btrfs-select-super: $(objects) btrfs-select-super.o
-	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) -o btrfs-select-super $(objects) btrfs-select-super.o $(LDFLAGS) $(LIBS)
-
-btrfs-dump-super: $(objects) btrfs-dump-super.o
-	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) -o btrfs-dump-super $(objects) btrfs-dump-super.o $(LDFLAGS) $(LIBS)
-
 btrfstune: $(objects) btrfstune.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o btrfstune $(objects) btrfstune.o $(LDFLAGS) $(LIBS)
@@ -175,8 +159,8 @@ install-man:
 
 clean :
 	@echo "Cleaning"
-	$(Q)rm -f $(progs) cscope.out *.o .*.d btrfs-convert btrfs-image btrfs-select-super \
-	      btrfs-zero-log btrfstune btrfs-dump-super dir-test ioctl-test quick-test \
+	$(Q)rm -f $(progs) cscope.out *.o .*.d btrfs-convert btrfs-image \
+	      btrfs-zero-log btrfstune dir-test ioctl-test quick-test \
 	      version.h
 	$(Q)$(MAKE) $(MAKEOPTS) -C man $@
 
diff --git a/btrfs-dump-super.c b/btrfs-dump-super.c
deleted file mode 100644
index 033140c..0000000
--- a/btrfs-dump-super.c
+++ /dev/null
@@ -1,87 +0,0 @@
-/*
- * Copyright (C) 2011 Google.  All rights reserved.
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
-#include <unistd.h>
-#include <fcntl.h>
-#include <sys/stat.h>
-#include "kerncompat.h"
-#include "ctree.h"
-#include "disk-io.h"
-#include "version.h"
-
-static void print_usage(void)
-{
-	fprintf(stderr, "usage: btrfs-dump-super dev\n");
-	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
-	exit(1);
-}
-
-static int read_block(const char* filename,  u64 bytenr, struct btrfs_super_block* sb) {
-	int fd = open(filename, O_RDONLY, 0600);
-	int block_size = sizeof(struct btrfs_super_block);
-	int bytes_read = 0;
-
-	if (fd < 0) {
-		fprintf(stderr, "Could not open %s\n", filename);
-		return -1;
-	}
-
-	bytes_read = pread(fd, sb, block_size, bytenr);
-	if (bytes_read < block_size) {
-		fprintf(stderr, "Only read %d bytes of %d.\n", bytes_read, block_size);
-	}
-
-	close(fd);
-	return bytes_read;
-}
-
-int main(int ac, char **av)
-{
-	int i;
-
-	if (ac != 2)
-		print_usage();
-
-	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
-		u64 bytenr = btrfs_sb_offset(i);
-		int fd;
-		struct btrfs_super_block sb;
-		int block_size = sizeof(struct btrfs_super_block);
-		char filename[1024];
-		int bytes_read = read_block(av[optind], bytenr, &sb);
-		if (bytes_read < block_size)
-			continue;
-
-		sprintf(filename, "/tmp/block.%s.%llu",
-			strrchr(av[optind], '/') + 1, bytenr);
-		fd = open(filename, O_CREAT|O_WRONLY, 0644);
-		if (block_size != pwrite(fd, &sb, block_size, 0)) {
-			fprintf(stderr, "Failed to dump superblock %d", i);
-			continue;
-		}
-		fprintf(stderr, "Dumped superblock %s:%d, gen %llu to %s.\n",
-			av[optind], i, sb.generation, filename);
-		close(fd);
-	}
-
-	return 0;
-}
diff --git a/btrfs.c b/btrfs.c
index cf2f320..459108d 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -261,6 +261,8 @@ const struct cmd_group btrfs_cmd_group = {
 		{ "quota", cmd_quota, NULL, &quota_cmd_group, 0 },
 		{ "qgroup", cmd_qgroup, NULL, &qgroup_cmd_group, 0 },
 		{ "replace", cmd_replace, NULL, &replace_cmd_group, 0 },
+		{ "rescue", cmd_rescue, NULL, &rescue_cmd_group, 0 },
+		{ "restore", cmd_restore, cmd_restore_usage, NULL, 0 },
 		{ "help", cmd_help, cmd_help_usage, NULL, 0 },
 		{ "version", cmd_version, cmd_version_usage, NULL, 0 },
 		{ 0, 0, 0, 0, 0 }
diff --git a/cmds-rescue-debug-tree.c b/cmds-rescue-debug-tree.c
index f6bd5d8..24703cb 100644
--- a/cmds-rescue-debug-tree.c
+++ b/cmds-rescue-debug-tree.c
@@ -27,21 +27,19 @@
 #include "print-tree.h"
 #include "transaction.h"
 #include "version.h"
+#include "commands.h"
 
-static int print_usage(void)
-{
-	fprintf(stderr, "usage: btrfs-debug-tree [ -e ] [ -d ] [ -r ] [ -R ]\n");
-	fprintf(stderr, "                        [-b block_num ] device\n");
-	fprintf(stderr, "\t-e : print detailed extents info\n");
-	fprintf(stderr, "\t-d : print info of btrfs device and root tree dirs"
-                    " only\n");
-	fprintf(stderr, "\t-r : print info of roots only\n");
-	fprintf(stderr, "\t-R : print info of roots and root backups\n");
-	fprintf(stderr, "\t-b block_num : print info of the specified block"
-                    " only\n");
-	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
-	exit(1);
-}
+const char * const cmd_debug_tree_usage[] = {
+	"btrfs rescue debug-tree [options] <device>",
+	"Debug the filesystem",
+	"",
+	"-e                print detailed extents info",
+	"-d                print info about btrfs device and root tree dirs",
+	"-r                print info about roots only",
+	"-R                print info about roots and root backups",
+	"-b <block_num>    print info about the specified block only",
+	NULL
+};
 
 static void print_extents(struct btrfs_root *root, struct extent_buffer *eb)
 {
@@ -109,7 +107,7 @@ static void print_old_roots(struct btrfs_super_block *super)
 	}
 }
 
-int main(int ac, char **av)
+int cmd_debug_tree(int argc, char **argv)
 {
 	struct btrfs_root *root;
 	struct btrfs_fs_info *info;
@@ -133,7 +131,7 @@ int main(int ac, char **av)
 
 	while(1) {
 		int c;
-		c = getopt(ac, av, "deb:rR");
+		c = getopt(argc, argv, "deb:rR");
 		if (c < 0)
 			break;
 		switch(c) {
@@ -154,23 +152,23 @@ int main(int ac, char **av)
 				block_only = atoll(optarg);
 				break;
 			default:
-				print_usage();
+				usage(cmd_debug_tree_usage);
 		}
 	}
-	ac = ac - optind;
-	if (ac != 1)
-		print_usage();
+	argc = argc - optind;
+	if (argc != 1)
+		usage(cmd_debug_tree_usage);
 
-	info = open_ctree_fs_info(av[optind], 0, 0, 1);
+	info = open_ctree_fs_info(argv[optind], 0, 0, 1);
 	if (!info) {
-		fprintf(stderr, "unable to open %s\n", av[optind]);
+		fprintf(stderr, "unable to open %s\n", argv[optind]);
 		exit(1);
 	}
 	root = info->fs_root;
 
 	if (block_only) {
 		if (!root) {
-			fprintf(stderr, "unable to open %s\n", av[optind]);
+			fprintf(stderr, "unable to open %s\n", argv[optind]);
 			exit(1);
 		}
 		leaf = read_tree_block(root,
diff --git a/cmds-rescue-super-ops.c b/cmds-rescue-super-ops.c
index 5eb4e6e..a5e25f6 100644
--- a/cmds-rescue-super-ops.c
+++ b/cmds-rescue-super-ops.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (C) 2007 Oracle.  All rights reserved.
+ * Copyright (C) 2011 Google.  All rights reserved.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public
@@ -31,17 +32,25 @@
 #include "list.h"
 #include "version.h"
 #include "utils.h"
+#include "commands.h"
 
-static void print_usage(void)
-{
-	fprintf(stderr, "usage: btrfs-select-super [-c] [-e] -s number dev\n");
-	fprintf(stderr, "       -c Commit changes to disk [IRREVERSIBLE]\n");
-	fprintf(stderr, "       -e Use the earliest super found, may help recover transid verify problems\n");
-	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
-	exit(1);
-}
+const char * const cmd_select_super_usage[] = {
+	"btrfs rescue select-super [options] -s <number> <device>",
+	"Select a superblock",
+	"",
+	"-s <offset>     specify superblock",
+	"-c              commit changes to disk [IRREVERSIBLE]",
+	"-e              Use the earliest super found, may help recover transid verify problems",
+	NULL
+};
 
-int main(int ac, char **av)
+const char * const cmd_dump_super_usage[] = {
+	"btrfs rescue dump-super <device>",
+	"Dump a superblock to disk",
+	NULL
+};
+
+int cmd_select_super(int argc, char **argv)
 {
 	struct btrfs_root *root;
 	int ret;
@@ -53,7 +62,7 @@ int main(int ac, char **av)
 
 	while(1) {
 		int c;
-		c = getopt(ac, av, "s:ce");
+		c = getopt(argc, argv, "s:ce");
 		if (c < 0)
 			break;
 		switch(c) {
@@ -70,35 +79,35 @@ int main(int ac, char **av)
 				use_earliest_bdev = 1;
 				break;
 			default:
-				print_usage();
+				usage(cmd_select_super_usage);
 		}
 	}
-	ac = ac - optind;
+	argc = argc - optind;
 
-	if (ac != 1)
-		print_usage();
+	if (argc != 1)
+		usage(cmd_select_super_usage);
 
 	if (bytenr == 0) {
-		fprintf(stderr, "Please select the super copy with -s\n");
-		print_usage();
+		fprintf(stderr, "Please select the superblock copy with -s\n");
+		usage(cmd_select_super_usage);
 	}
 
 	radix_tree_init();
 
-	if ((ret = check_mounted(av[optind])) < 0) {
+	if ((ret = check_mounted(argv[optind])) < 0) {
 		fprintf(stderr, "Could not check mount status: %s\n", strerror(-ret));
 		return ret;
 	} else if (ret) {
-		fprintf(stderr, "%s is currently mounted. Aborting.\n", av[optind]);
+		fprintf(stderr, "%s is currently mounted. Aborting.\n", argv[optind]);
 		return -EBUSY;
 	}
 
-	fp = open(av[optind], O_CREAT|O_RDWR, 0600);
+	fp = open(argv[optind], O_CREAT|O_RDWR, 0600);
 	if (fp < 0) {
-		fprintf(stderr, "Could not open %s\n", av[optind]);
+		fprintf(stderr, "Could not open %s\n", argv[optind]);
 		return 1;
 	}
-	root = open_ctree_fd(fp, av[optind], bytenr, 1, 0);
+	root = open_ctree_fd(fp, argv[optind], bytenr, 1, 0);
 
 	if (!root) {
 		fprintf(stderr, "Open ctree failed\n");
@@ -121,3 +130,55 @@ int main(int ac, char **av)
 	 */ 
 	return ret;
 }
+
+static int read_block(const char* filename,  u64 bytenr, struct btrfs_super_block* sb) {
+        int fd = open(filename, O_RDONLY, 0600);
+        int block_size = sizeof(struct btrfs_super_block);
+        int bytes_read = 0;
+
+        if (fd < 0) {
+                fprintf(stderr, "Could not open %s\n", filename);
+                return -1;
+        }
+
+        bytes_read = pread(fd, sb, block_size, bytenr);
+        if (bytes_read < block_size) {
+                fprintf(stderr, "Only read %d bytes of %d.\n", bytes_read, block_size);
+        }
+
+        close(fd);
+        return bytes_read;
+}
+
+int cmd_dump_super(int argc, char **argv)
+{
+        int i;
+
+        if (argc != 2)
+                usage(cmd_dump_super_usage);
+
+        for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
+                u64 bytenr = btrfs_sb_offset(i);
+                int fd;
+                struct btrfs_super_block sb;
+                int block_size = sizeof(struct btrfs_super_block);
+                char filename[1024];
+                int bytes_read = read_block(argv[optind], bytenr, &sb);
+                if (bytes_read < block_size)
+                        continue;
+
+                sprintf(filename, "/tmp/block.%s.%llu",
+                        strrchr(argv[optind], '/') + 1, bytenr);
+                fd = open(filename, O_CREAT|O_WRONLY, 0644);
+                if (block_size != pwrite(fd, &sb, block_size, 0)) {
+                        fprintf(stderr, "Failed to dump superblock %d", i);
+                        continue;
+                }
+                fprintf(stderr, "Dumped superblock %s:%d, gen %llu to %s.\n",
+                        argv[optind], i, sb.generation, filename);
+                close(fd);
+        }
+
+        return 0;
+}
+
diff --git a/cmds-rescue.c b/cmds-rescue.c
new file mode 100644
index 0000000..d3e0bd4
--- /dev/null
+++ b/cmds-rescue.c
@@ -0,0 +1,48 @@
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
+#include "commands.h"
+
+static const char * const rescue_cmd_group_usage[] = {
+	"btrfs rescue <command> [<args>]",
+	NULL
+};
+
+extern const char * const cmd_restore_usage[];
+extern const char * const cmd_select_super_usage[];
+extern const char * const cmd_dump_super_usage[];
+extern const char * const cmd_debug_tree_usage[];
+
+int cmd_restore(int argc, char **argv);
+int cmd_select_super(int argc, char **argv);
+int cmd_dump_super(int argc, char **argv);
+int cmd_debug_tree(int argc, char **argv);
+
+const struct cmd_group rescue_cmd_group = {
+        rescue_cmd_group_usage, NULL, {
+		{ "select-super", cmd_select_super, cmd_select_super_usage, NULL, 0 },
+		{ "dump-super", cmd_dump_super, cmd_dump_super_usage, NULL, 0 },
+		{ "debug-tree", cmd_debug_tree, cmd_debug_tree_usage, NULL, 0 },
+		{ 0, 0, 0, 0, 0 },
+	}
+};
+
+int cmd_rescue(int argc, char **argv)
+{
+	return handle_command_group(&rescue_cmd_group, argc, argv);
+}
+
diff --git a/cmds-restore.c b/cmds-restore.c
index 0fe81b3..103a352 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -41,6 +41,7 @@
 #include "version.h"
 #include "volumes.h"
 #include "utils.h"
+#include "commands.h"
 
 static char fs_name[4096];
 static char path_name[4096];
@@ -775,12 +776,6 @@ next:
 	return 0;
 }
 
-static void usage()
-{
-	fprintf(stderr, "Usage: restore [-sviocl] [-t disk offset] "
-		"[-m regex] <device> <directory>\n");
-}
-
 static int do_list_roots(struct btrfs_root *root)
 {
 	struct btrfs_key key;
@@ -1004,7 +999,26 @@ out:
 	return ret;
 }
 
-int main(int argc, char **argv)
+const char * const cmd_restore_usage[] = {
+	"btrfs rescue restore [options] <device>",
+	"Restore filesystem",
+	"",
+	"-s              get snapshots",
+	"-v              verbose",
+	"-i              ignore errors",
+	"-o              overwrite",
+	"-t              tree location",
+	"-f <offset>     filesystem location",
+	"-u <block>      super mirror",
+	"-d              find dir",
+	"-r <num>        root objectid",
+	"-c              ignore case in regular expression",
+	"-m <regexp>     regular expression to match",
+	"-l              list roots",
+	NULL
+};
+
+int cmd_restore(int argc, char **argv)
 {
 	struct btrfs_root *root;
 	struct btrfs_key key;
@@ -1084,18 +1098,14 @@ int main(int argc, char **argv)
 				list_roots = 1;
 				break;
 			default:
-				usage();
-				exit(1);
+				usage(cmd_restore_usage);
 		}
 	}
 
-	if (!list_roots && optind + 1 >= argc) {
-		usage();
-		exit(1);
-	} else if (list_roots && optind >= argc) {
-		usage();
-		exit(1);
-	}
+	if (!list_roots && optind + 1 >= argc)
+		usage(cmd_restore_usage);
+	else if (list_roots && optind >= argc)
+		usage(cmd_restore_usage);
 
 	if ((ret = check_mounted(argv[optind])) < 0) {
 		fprintf(stderr, "Could not check mount status: %s\n",
diff --git a/commands.h b/commands.h
index ddb636f..06b78d1 100644
--- a/commands.h
+++ b/commands.h
@@ -90,11 +90,12 @@ extern const struct cmd_group receive_cmd_group;
 extern const struct cmd_group quota_cmd_group;
 extern const struct cmd_group qgroup_cmd_group;
 extern const struct cmd_group replace_cmd_group;
+extern const struct cmd_group rescue_cmd_group;
 
 extern const char * const cmd_send_usage[];
 extern const char * const cmd_receive_usage[];
-
 extern const char * const cmd_check_usage[];
+extern const char * const cmd_restore_usage[];
 
 int cmd_subvolume(int argc, char **argv);
 int cmd_filesystem(int argc, char **argv);
@@ -108,6 +109,11 @@ int cmd_receive(int argc, char **argv);
 int cmd_quota(int argc, char **argv);
 int cmd_qgroup(int argc, char **argv);
 int cmd_replace(int argc, char **argv);
+int cmd_restore(int argc, char **argv);
+int cmd_select_super(int argc, char **argv);
+int cmd_dump_super(int argc, char **argv);
+int cmd_debug_tree(int argc, char **argv);
+int cmd_rescue(int argc, char **argv);
 
 /* subvolume exported functions */
 int test_issubvolume(char *path);
-- 
1.8.1.2

