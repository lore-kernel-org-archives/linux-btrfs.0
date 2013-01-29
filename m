Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.vapor.com ([83.220.149.2]:53002 "EHLO nitrogen.vapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009Ab3A2XHl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 18:07:41 -0500
Received: from twilight.demius.net (c-297271d5.013-195-6c756e10.cust.bredbandsbolaget.se [213.113.114.41])
	by nitrogen.vapor.com (Postfix) with ESMTPSA id 5636D40C18C
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2013 00:07:40 +0100 (CET)
From: Ian Kumlien <pomac@demius.net>
To: linux-btrfs@vger.kernel.org
Cc: Ian Kumlien <pomac@demius.net>
Subject: [PATCH] [RFC] include btrfsck in btrfs - including "name check"
Date: Wed, 30 Jan 2013 00:03:53 +0100
Message-Id: <1359500633-7219-2-git-send-email-pomac@demius.net>
In-Reply-To: <1359500633-7219-1-git-send-email-pomac@demius.net>
References: <1359500633-7219-1-git-send-email-pomac@demius.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch includes fsck as a subcommand of btrfs, but if you rename
the binary to btrfsck (or, preferably, use a symlink) it will act like
the old btrfs command.

It will also handle fsck.btrfs which currently is a noop.
---
 Makefile    |  4 ++--
 btrfs.c     | 68 +++++++++++++++++++++++++++++++++++++++++++++----------------
 cmds-fsck.c | 38 +++++++++++++++++++---------------
 commands.h  |  3 +++
 4 files changed, 77 insertions(+), 36 deletions(-)

diff --git a/Makefile b/Makefile
index 4894903..8467530 100644
--- a/Makefile
+++ b/Makefile
@@ -8,7 +8,7 @@ objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  send-stream.o send-utils.o qgroup.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
-	       cmds-quota.o cmds-qgroup.o
+	       cmds-quota.o cmds-qgroup.o cmds-fsck.o
 
 CHECKFLAGS= -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise \
 	    -Wuninitialized -Wshadow -Wundef
@@ -20,7 +20,7 @@ bindir = $(prefix)/bin
 LIBS=-luuid -lm
 RESTORE_LIBS=-lz
 
-progs = btrfsctl mkfs.btrfs btrfs-debug-tree btrfs-show btrfs-vol btrfsck \
+progs = btrfsctl mkfs.btrfs btrfs-debug-tree btrfs-show btrfs-vol \
 	btrfs btrfs-map-logical btrfs-image btrfs-zero-log btrfs-convert \
 	btrfs-find-root btrfs-restore btrfstune
 
diff --git a/btrfs.c b/btrfs.c
index 687acec..5c1220e 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -48,8 +48,13 @@ int prefixcmp(const char *str, const char *prefix)
 			return (unsigned char)*prefix - (unsigned char)*str;
 }
 
-static int parse_one_token(const char *arg, const struct cmd_group *grp,
-			   const struct cmd_struct **cmd_ret)
+#define parse_one_token(arg, grp, cmd_ret) \
+	_parse_one_token((arg), (grp), (cmd_ret), 0)
+#define parse_one_exact_token(arg, grp, cmd_ret) \
+	_parse_one_token((arg), (grp), (cmd_ret), 1)
+
+static int _parse_one_token(const char *arg, const struct cmd_group *grp,
+			   const struct cmd_struct **cmd_ret, int exact)
 {
 	const struct cmd_struct *cmd = grp->commands;
 	const struct cmd_struct *abbrev_cmd = NULL, *ambiguous_cmd = NULL;
@@ -80,12 +85,15 @@ static int parse_one_token(const char *arg, const struct cmd_group *grp,
 		return 0;
 	}
 
-	if (ambiguous_cmd)
-		return -2;
+	if (!exact)
+	{
+		if (ambiguous_cmd)
+			return -2;
 
-	if (abbrev_cmd) {
-		*cmd_ret = abbrev_cmd;
-		return 0;
+		if (abbrev_cmd) {
+			*cmd_ret = abbrev_cmd;
+			return 0;
+		}
 	}
 
 	return -1;
@@ -246,6 +254,7 @@ const struct cmd_group btrfs_cmd_group = {
 		{ "balance", cmd_balance, NULL, &balance_cmd_group, 0 },
 		{ "device", cmd_device, NULL, &device_cmd_group, 0 },
 		{ "scrub", cmd_scrub, NULL, &scrub_cmd_group, 0 },
+		{ "fsck", cmd_fsck, cmd_fsck_usage, NULL, 0 },
 		{ "inspect-internal", cmd_inspect, NULL, &inspect_cmd_group, 0 },
 		{ "send", cmd_send, NULL, &send_cmd_group, 0 },
 		{ "receive", cmd_receive, NULL, &receive_cmd_group, 0 },
@@ -257,24 +266,47 @@ const struct cmd_group btrfs_cmd_group = {
 	},
 };
 
+static int cmd_dummy(int argc, char **argv)
+{
+	return 0;
+}
+
+/* change behaviour depending on what we're called */
+const struct cmd_group function_cmd_group = {
+	NULL, NULL,
+	{
+		{ "btrfsck", cmd_fsck, NULL, NULL, 0 },
+		{ "fsck.btrfs", cmd_dummy, NULL, NULL, 0 },
+		{ 0, 0, 0, 0, 0 }
+	},
+};
+
 int main(int argc, char **argv)
 {
 	const struct cmd_struct *cmd;
+	char *func = strrchr(argv[0], '/');
+	if (func)
+		argv[0] = ++func;
 
 	crc32c_optimization_init();
 
-	argc--;
-	argv++;
-	handle_options(&argc, &argv);
-	if (argc > 0) {
-		if (!prefixcmp(argv[0], "--"))
-			argv[0] += 2;
-	} else {
-		usage_command_group(&btrfs_cmd_group, 0, 0);
-		exit(1);
-	}
+	/* if we have cmd, we're started as a sub command */
+	if (parse_one_exact_token(argv[0], &function_cmd_group, &cmd) < 0)
+	{
+		argc--;
+		argv++;
 
-	cmd = parse_command_token(argv[0], &btrfs_cmd_group);
+		handle_options(&argc, &argv);
+		if (argc > 0) {
+			if (!prefixcmp(argv[0], "--"))
+				argv[0] += 2;
+		} else {
+			usage_command_group(&btrfs_cmd_group, 0, 0);
+			exit(1);
+		}
+
+		cmd = parse_command_token(argv[0], &btrfs_cmd_group);
+	}
 
 	handle_help_options_next_level(cmd, argc, argv);
 
diff --git a/cmds-fsck.c b/cmds-fsck.c
index 67f4a9d..bb5d81f 100644
--- a/cmds-fsck.c
+++ b/cmds-fsck.c
@@ -34,6 +34,7 @@
 #include "list.h"
 #include "version.h"
 #include "utils.h"
+#include "commands.h"
 
 static u64 bytes_used = 0;
 static u64 total_csum_bytes = 0;
@@ -3470,13 +3471,6 @@ static int check_extents(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static void print_usage(void)
-{
-	fprintf(stderr, "usage: btrfsck dev\n");
-	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
-	exit(1);
-}
-
 static struct option long_options[] = {
 	{ "super", 1, NULL, 's' },
 	{ "repair", 0, NULL, 0 },
@@ -3485,7 +3479,18 @@ static struct option long_options[] = {
 	{ 0, 0, 0, 0}
 };
 
-int main(int ac, char **av)
+const char * const cmd_fsck_usage[] = {
+	"btrfs fsck [-s <superblock>] [--repair] [--init-csum-tree] [--init-extent-tree] <device>",
+	"check a btrfs filesystem",
+	"",
+	"-s|--super <superblock>     use this superblock copy",
+	"--repair                    try to repair the filesystem",
+	"--init-csum-tree            create a new CRC tree",
+	"--init-extent-tree          create a new extent tree",
+	NULL
+};
+
+int cmd_fsck(int argc, char **argv)
 {
 	struct cache_tree root_cache;
 	struct btrfs_root *root;
@@ -3501,7 +3506,7 @@ int main(int ac, char **av)
 
 	while(1) {
 		int c;
-		c = getopt_long(ac, av, "s:", long_options,
+		c = getopt_long(argc, argv, "s:", long_options,
 				&option_index);
 		if (c < 0)
 			break;
@@ -3513,7 +3518,8 @@ int main(int ac, char **av)
 				       (unsigned long long)bytenr);
 				break;
 			case '?':
-				print_usage();
+			case 'h':
+				usage(cmd_fsck_usage);
 		}
 		if (option_index == 1) {
 			printf("enabling repair mode\n");
@@ -3526,23 +3532,23 @@ int main(int ac, char **av)
 		}
 
 	}
-	ac = ac - optind;
+	argc = argc - optind;
 
-	if (ac != 1)
-		print_usage();
+	if (argc != 1)
+		usage(cmd_fsck_usage);
 
 	radix_tree_init();
 	cache_tree_init(&root_cache);
 
-	if((ret = check_mounted(av[optind])) < 0) {
+	if((ret = check_mounted(argv[optind])) < 0) {
 		fprintf(stderr, "Could not check mount status: %s\n", strerror(-ret));
 		return ret;
 	} else if(ret) {
-		fprintf(stderr, "%s is currently mounted. Aborting.\n", av[optind]);
+		fprintf(stderr, "%s is currently mounted. Aborting.\n", argv[optind]);
 		return -EBUSY;
 	}
 
-	info = open_ctree_fs_info(av[optind], bytenr, rw, 1);
+	info = open_ctree_fs_info(argv[optind], bytenr, rw, 1);
 
 	if (info == NULL)
 		return 1;
diff --git a/commands.h b/commands.h
index bb6d2dd..308eb61 100644
--- a/commands.h
+++ b/commands.h
@@ -93,11 +93,14 @@ extern const struct cmd_group receive_cmd_group;
 extern const struct cmd_group quota_cmd_group;
 extern const struct cmd_group qgroup_cmd_group;
 
+extern const char * const cmd_fsck_usage[];
+
 int cmd_subvolume(int argc, char **argv);
 int cmd_filesystem(int argc, char **argv);
 int cmd_balance(int argc, char **argv);
 int cmd_device(int argc, char **argv);
 int cmd_scrub(int argc, char **argv);
+int cmd_fsck(int argc, char **argv);
 int cmd_inspect(int argc, char **argv);
 int cmd_send(int argc, char **argv);
 int cmd_receive(int argc, char **argv);
-- 
1.8.1.2

