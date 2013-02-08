Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.vapor.com ([83.220.149.2]:39469 "EHLO nitrogen.vapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772Ab3BHAk7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Feb 2013 19:40:59 -0500
Received: from twilight.demius.net (c-297271d5.013-195-6c756e10.cust.bredbandsbolaget.se [213.113.114.41])
	by nitrogen.vapor.com (Postfix) with ESMTPSA id 81FBC40C6A5
	for <linux-btrfs@vger.kernel.org>; Fri,  8 Feb 2013 01:40:51 +0100 (CET)
From: Ian Kumlien <pomac@demius.net>
To: linux-btrfs@vger.kernel.org
Cc: Ian Kumlien <pomac@demius.net>
Subject: [PATCH 2/6] Btrfs-progs: add btrfsck functionality to btrfs
Date: Fri,  8 Feb 2013 01:36:58 +0100
Message-Id: <1360283822-23452-3-git-send-email-pomac@demius.net>
In-Reply-To: <1360283822-23452-1-git-send-email-pomac@demius.net>
References: <1360283822-23452-1-git-send-email-pomac@demius.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch includes the functionality of btrfs, it's
found as "btrfs check" however it makes the binary
behave differently depending on what it's run as.

	btrfsck -> will act like normal btrfsck
	fsck.btrfs -> noop

Signed-off-by: Ian Kumlien <pomac@demius.net>
---
 Makefile     |  8 ++-----
 btrfs.c      | 68 ++++++++++++++++++++++++++++++++++++++++++++----------------
 cmds-check.c | 40 ++++++++++++++++++++---------------
 commands.h   |  3 +++
 4 files changed, 78 insertions(+), 41 deletions(-)

diff --git a/Makefile b/Makefile
index 2c2a500..94541b2 100644
--- a/Makefile
+++ b/Makefile
@@ -8,7 +8,7 @@ objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  send-stream.o send-utils.o qgroup.o raid6.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
-	       cmds-quota.o cmds-qgroup.o cmds-replace.o
+	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o
 
 CHECKFLAGS= -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise \
 	    -Wuninitialized -Wshadow -Wundef
@@ -35,7 +35,7 @@ endif
 
 MAKEOPTS = --no-print-directory Q=$(Q)
 
-progs = btrfsctl mkfs.btrfs btrfs-debug-tree btrfs-show btrfs-vol btrfsck \
+progs = btrfsctl mkfs.btrfs btrfs-debug-tree btrfs-show btrfs-vol \
 	btrfs btrfs-map-logical btrfs-image btrfs-zero-log btrfs-convert \
 	btrfs-find-root btrfs-restore btrfstune btrfs-show-super \
 	btrfs-dump-super
@@ -111,10 +111,6 @@ btrfs-show: $(objects) btrfs-show.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o btrfs-show btrfs-show.o $(objects) $(LDFLAGS) $(LIBS)
 
-btrfsck: $(objects) btrfsck.o
-	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) -o btrfsck btrfsck.o $(objects) $(LDFLAGS) $(LIBS)
-
 mkfs.btrfs: $(objects) mkfs.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o mkfs.btrfs $(objects) mkfs.o $(LDFLAGS) $(LIBS) -lblkid
diff --git a/btrfs.c b/btrfs.c
index 7b0e50f..cf2f320 100644
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
+		{ "check", cmd_check, cmd_check_usage, NULL, 0 },
 		{ "inspect-internal", cmd_inspect, NULL, &inspect_cmd_group, 0 },
 		{ "send", cmd_send, cmd_send_usage, NULL, 0 },
 		{ "receive", cmd_receive, cmd_receive_usage, NULL, 0 },
@@ -258,24 +267,47 @@ const struct cmd_group btrfs_cmd_group = {
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
+		{ "btrfsck", cmd_check, NULL, NULL, 0 },
+		{ "fsck.btrfs", cmd_dummy, NULL, NULL, 0 },
+		{ 0, 0, 0, 0, 0 }
+	},
+};
+
 int main(int argc, char **argv)
 {
 	const struct cmd_struct *cmd;
+	char *called_as = strrchr(argv[0], '/');
+	if (called_as)
+		argv[0] = ++called_as;
 
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
 
diff --git a/cmds-check.c b/cmds-check.c
index 71e98de..8e4cce0 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -37,6 +37,7 @@
 #include "list.h"
 #include "version.h"
 #include "utils.h"
+#include "commands.h"
 
 static u64 bytes_used = 0;
 static u64 total_csum_bytes = 0;
@@ -3529,13 +3530,6 @@ static int check_extents(struct btrfs_trans_handle *trans,
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
@@ -3544,7 +3538,18 @@ static struct option long_options[] = {
 	{ 0, 0, 0, 0}
 };
 
-int main(int ac, char **av)
+const char * const cmd_check_usage[] = {
+	"btrfs check [options] <device>",
+	"check a btrfs filesystem",
+	"",
+	"-s|--super <superblock>     use this superblock copy",
+	"--repair                    try to repair the filesystem",
+	"--init-csum-tree            create a new CRC tree",
+	"--init-extent-tree          create a new extent tree",
+	NULL
+};
+
+int cmd_check(int argc, char **argv)
 {
 	struct cache_tree root_cache;
 	struct btrfs_root *root;
@@ -3561,7 +3566,7 @@ int main(int ac, char **av)
 
 	while(1) {
 		int c;
-		c = getopt_long(ac, av, "as:", long_options,
+		c = getopt_long(argc, argv, "as:", long_options,
 				&option_index);
 		if (c < 0)
 			break;
@@ -3574,7 +3579,8 @@ int main(int ac, char **av)
 				       (unsigned long long)bytenr);
 				break;
 			case '?':
-				print_usage();
+			case 'h':
+				usage(cmd_check_usage);
 		}
 		if (option_index == 1) {
 			printf("enabling repair mode\n");
@@ -3587,25 +3593,25 @@ int main(int ac, char **av)
 		}
 
 	}
-	ac = ac - optind;
+	argc = argc - optind;
 
-	if (ac != 1)
-		print_usage();
+	if (argc != 1)
+		usage(cmd_check_usage);
 
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
 	uuid_unparse(info->super_copy.fsid, uuidbuf);
-	printf("Checking filesystem on %s\nUUID: %s\n", av[optind], uuidbuf);
+	printf("Checking filesystem on %s\nUUID: %s\n", argv[optind], uuidbuf);
 
 	if (info == NULL)
 		return 1;
diff --git a/commands.h b/commands.h
index 33eb99a..ddb636f 100644
--- a/commands.h
+++ b/commands.h
@@ -94,11 +94,14 @@ extern const struct cmd_group replace_cmd_group;
 extern const char * const cmd_send_usage[];
 extern const char * const cmd_receive_usage[];
 
+extern const char * const cmd_check_usage[];
+
 int cmd_subvolume(int argc, char **argv);
 int cmd_filesystem(int argc, char **argv);
 int cmd_balance(int argc, char **argv);
 int cmd_device(int argc, char **argv);
 int cmd_scrub(int argc, char **argv);
+int cmd_check(int argc, char **argv);
 int cmd_inspect(int argc, char **argv);
 int cmd_send(int argc, char **argv);
 int cmd_receive(int argc, char **argv);
-- 
1.8.1.2

