Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57380 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab2JLDYp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Oct 2012 23:24:45 -0400
Received: from m2.gw.fujitsu.co.jp (unknown [10.0.50.72])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 58BB83EE0B5
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 12:24:44 +0900 (JST)
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 3A83045DD78
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 12:24:44 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 1F73745DE4D
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 12:24:44 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 0B9BC1DB803F
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 12:24:44 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.240.81.134])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 5ED3E1DB802C
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 12:24:43 +0900 (JST)
Received: from ml14.css.fujitsu.com (ml14 [127.0.0.1])
	by ml14.s.css.fujitsu.com (Postfix) with ESMTP id 3389E9F7991
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 12:24:43 +0900 (JST)
Received: from [127.0.0.1] (unknown [10.124.101.110])
	by ml14.s.css.fujitsu.com (Postfix) with ESMTP id CB3099F6C65
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 12:24:42 +0900 (JST)
Message-ID: <50778D72.10807@jp.fujitsu.com>
Date: Fri, 12 Oct 2012 12:24:34 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/4] Btrfs-progs: add mount-option command
References: <50778C1D.4060807@jp.fujitsu.com>
In-Reply-To: <50778C1D.4060807@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds mount-option command that can set/get/clear default
mount options.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 Makefile             |    4 +-
 btrfs-parse-mntopt.c |  109 +++++++++++++++++++++++++++++
 btrfs-parse-mntopt.h |   66 ++++++++++++++++++
 btrfs.c              |    1 +
 cmds-mount.c         |  185 ++++++++++++++++++++++++++++++++++++++++++++++++++
 commands.h           |    2 +
 ctree.h              |    7 ++-
 7 files changed, 371 insertions(+), 3 deletions(-)
 create mode 100644 btrfs-parse-mntopt.c
 create mode 100644 btrfs-parse-mntopt.h
 create mode 100644 cmds-mount.c

diff --git a/Makefile b/Makefile
index 4894903..c25d982 100644
--- a/Makefile
+++ b/Makefile
@@ -5,10 +5,10 @@ objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o \
 	  inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o \
 	  volumes.o utils.o btrfs-list.o btrfslabel.o repair.o \
-	  send-stream.o send-utils.o qgroup.o
+	  send-stream.o send-utils.o qgroup.o btrfs-parse-mntopt.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
-	       cmds-quota.o cmds-qgroup.o
+	       cmds-quota.o cmds-qgroup.o cmds-mount.o
 
 CHECKFLAGS= -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise \
 	    -Wuninitialized -Wshadow -Wundef
diff --git a/btrfs-parse-mntopt.c b/btrfs-parse-mntopt.c
new file mode 100644
index 0000000..66a924d
--- /dev/null
+++ b/btrfs-parse-mntopt.c
@@ -0,0 +1,109 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include "ctree.h"
+#include "btrfs-parse-mntopt.h"
+
+void btrfs_parse_string2mntopt(u64 *optval, int optnum, char **options)
+{
+	char *p, *opts;
+	int i, j;
+	u64 newval = *optval;
+	char overwrite = 0;
+
+	for (i = 0; i < optnum; i++) {
+		char *token, *save_ptr;
+		char revert = 0;
+		u64 orders = 0;
+
+		opts = options[i];
+
+		switch (*opts) {
+		case '=':
+			if (overwrite) {
+				fprintf(stderr, "'=' operator may only be specified once.\n");
+				return;
+			}
+			if (i) {
+				fprintf(stderr, "cannot use operator '=' with '+/-'.\n");
+				return;
+			}
+			if (!*(opts + 1)) {
+				fprintf(stderr, "no options after '='.\n");
+				return;
+			}
+			overwrite = 1;
+			opts++;
+			break;
+		case '-':
+			revert = 1;
+		case '+':
+			if (overwrite) {
+				fprintf(stderr, "cannot use operator '=' with '+/-'.\n");
+				return;
+			}
+			if (!*(opts + 1)) {
+				fprintf(stderr, "no options after '%c'.\n", *opts);
+				return;
+			}
+			opts++;
+			break;
+		default:
+			fprintf(stderr, "options must be specified with '+/-/='.\n");
+			return;
+		}
+
+		for (token = strtok_r(opts, ",", &save_ptr); token != NULL;
+		     token = strtok_r(NULL, ",", &save_ptr)) {
+			char *arg;
+
+			arg = strchr(token, '=');
+			if (arg) {
+				/* TBD: compress=<type> */
+				fprintf(stderr, "format 'option=arg' is not supported.\n");
+				return;
+			}
+
+			for (j = 0; tokens[j].pattern != NULL; j++) {
+				if (!strcmp(token, tokens[j].pattern)) {
+					orders |= (1 << tokens[j].token);
+					break;
+				}
+			}
+			if (!tokens[j].pattern) {
+				fprintf(stderr, "unknown option '%s'.\n", token);
+				printf("supported options : ");
+				btrfs_parse_mntopt2string(-1);
+				return;
+			}
+		}
+
+		if (overwrite)
+			newval = orders;
+		else if (revert)
+			newval &= ~orders;
+		else
+			newval |= orders;
+	}
+
+	*optval = newval;
+}
+
+void btrfs_parse_mntopt2string(u64 optval)
+{
+	if (!optval)
+		printf("no default options\n");
+	else {
+		int i, cont = 0;
+
+		for (i = 0; tokens[i].pattern != NULL; i++) {
+			if (optval & (1 << tokens[i].token)) {
+				if (cont)
+					printf(",");
+				printf("%s", tokens[i].pattern);
+				cont = 1;
+			}
+		}
+		printf("\n");
+	}
+}
diff --git a/btrfs-parse-mntopt.h b/btrfs-parse-mntopt.h
new file mode 100644
index 0000000..784a942
--- /dev/null
+++ b/btrfs-parse-mntopt.h
@@ -0,0 +1,66 @@
+/* btrfs-parse-mntopt.h */
+
+struct match_token {
+	int token;
+	const char *pattern;
+};
+
+typedef struct match_token match_table_t[];
+
+/* copy & pasted from super.c */
+enum {
+	Opt_degraded, Opt_subvol, Opt_subvolid, Opt_device, Opt_nodatasum,
+	Opt_nodatacow, Opt_max_inline, Opt_alloc_start, Opt_nobarrier, Opt_ssd,
+	Opt_nossd, Opt_ssd_spread, Opt_thread_pool, Opt_noacl, Opt_compress,
+	Opt_compress_type, Opt_compress_force, Opt_compress_force_type,
+	Opt_notreelog, Opt_ratio, Opt_flushoncommit, Opt_discard,
+	Opt_space_cache, Opt_clear_cache, Opt_user_subvol_rm_allowed,
+	Opt_enospc_debug, Opt_subvolrootid, Opt_defrag, Opt_inode_cache,
+	Opt_no_space_cache, Opt_recovery, Opt_skip_balance,
+	Opt_check_integrity, Opt_check_integrity_including_extent_data,
+	Opt_check_integrity_print_mask, Opt_fatal_errors,
+	Opt_err,
+};
+
+static match_table_t tokens = {
+/*	{Opt_degraded, "degraded"},		... never be default */
+/*	{Opt_subvol, "subvol=%s"},		... not supported */
+/*	{Opt_subvolid, "subvolid=%d"},		... not supported */
+/*	{Opt_device, "device=%s"},		... not supported */
+	{Opt_nodatasum, "nodatasum"},
+	{Opt_nodatacow, "nodatacow"},
+	{Opt_nobarrier, "nobarrier"},
+/*	{Opt_max_inline, "max_inline=%s"},	... not supported */
+/*	{Opt_alloc_start, "alloc_start=%s"},	... not supported */
+/*	{Opt_thread_pool, "thread_pool=%d"},	... not supported */
+	{Opt_compress, "compress"},
+/*	{Opt_compress_type, "compress=%s"},		... TBD? */
+	{Opt_compress_force, "compress-force"},
+/*	{Opt_compress_force_type, "compress-force=%s"},	... TBD? */
+	{Opt_ssd, "ssd"},
+	{Opt_ssd_spread, "ssd_spread"},
+	{Opt_nossd, "nossd"},
+	{Opt_noacl, "noacl"},
+	{Opt_notreelog, "notreelog"},
+	{Opt_flushoncommit, "flushoncommit"},
+/*	{Opt_ratio, "metadata_ratio=%d"},	... not supported */
+	{Opt_discard, "discard"},
+	{Opt_space_cache, "space_cache"},
+	{Opt_clear_cache, "clear_cache"},
+	{Opt_user_subvol_rm_allowed, "user_subvol_rm_allowed"},
+/*	{Opt_enospc_debug, "enospc_debug"},	... never be default */
+/*	{Opt_subvolrootid, "subvolrootid=%d"},	... not supported */
+	{Opt_defrag, "autodefrag"},
+	{Opt_inode_cache, "inode_cache"},
+	{Opt_no_space_cache, "nospace_cache"},
+	{Opt_recovery, "recovery"},
+	{Opt_skip_balance, "skip_balance"},
+	{Opt_check_integrity, "check_int"},
+	{Opt_check_integrity_including_extent_data, "check_int_data"},
+/*	{Opt_check_integrity_print_mask, "check_int_print_mask=%d"},
+	{Opt_fatal_errors, "fatal_errors=%s"},	... not supported */
+	{Opt_err, NULL},	/* must be end */
+};
+
+void btrfs_parse_string2mntopt(u64 *optval, int optnum, char **options);
+void btrfs_parse_mntopt2string(u64 optval);
diff --git a/btrfs.c b/btrfs.c
index a229cee..608869d 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -250,6 +250,7 @@ const struct cmd_group btrfs_cmd_group = {
 		{ "receive", cmd_receive, NULL, &receive_cmd_group, 0 },
 		{ "quota", cmd_quota, NULL, &quota_cmd_group, 0 },
 		{ "qgroup", cmd_qgroup, NULL, &qgroup_cmd_group, 0 },
+		{ "mount-option", cmd_mount, NULL, &mount_cmd_group, 0 },
 		{ "help", cmd_help, cmd_help_usage, NULL, 0 },
 		{ "version", cmd_version, cmd_version_usage, NULL, 0 },
 		{ 0, 0, 0, 0, 0 }
diff --git a/cmds-mount.c b/cmds-mount.c
new file mode 100644
index 0000000..1752019
--- /dev/null
+++ b/cmds-mount.c
@@ -0,0 +1,185 @@
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
+#include <sys/ioctl.h>
+#include "ioctl.h"
+#include "ctree.h"
+#include "transaction.h"
+#include "commands.h"
+#include "disk-io.h"
+#include "utils.h"
+#include "btrfs-parse-mntopt.h"
+
+static int mount_check_device(char *device)
+{
+	int ret;
+
+	ret = check_mounted(device);
+	if (ret == 1) {
+		fprintf(stderr, "%s is mounted\n", device);
+		return 1;
+	}
+	if (ret < 0) {
+		fprintf(stderr, "error checking %s mount status with %d(%s)\n",
+			device, ret, strerror(-1*ret));
+		return 1;
+	}
+	return 0;
+}
+
+static int mount_set_common(char *device, int numopts, char **options)
+{
+	struct btrfs_root *root;
+	struct btrfs_trans_handle *trans;
+	u64 optval = 0;
+	int ret;
+
+	root = open_ctree(device, 0, 1);
+	if (!root) {
+		fprintf(stderr, "error opening ctree of %s\n", device);
+		return 1;
+	}
+
+	if (numopts) {
+		optval = btrfs_super_default_mount_opt(&root->fs_info->super_copy);
+		btrfs_parse_string2mntopt(&optval, numopts, options);
+	}
+
+	trans = btrfs_start_transaction(root, 1);
+	btrfs_set_super_default_mount_opt(&root->fs_info->super_copy, optval);
+	ret = btrfs_commit_transaction(trans, root);
+
+	close_ctree(root);
+
+	return ret;
+}
+
+static int mount_show_common(char *device)
+{
+	struct btrfs_root *root;
+	u64 def_opt;
+
+	root = open_ctree(device, 0, 0);
+	if (!root) {
+		fprintf(stderr, "error opening ctree of %s\n", device);
+		return 1;
+	}
+
+	def_opt = btrfs_super_default_mount_opt(&root->fs_info->super_copy);
+	btrfs_parse_mntopt2string(def_opt);
+
+	close_ctree(root);
+
+	return 0;
+}
+
+static const char * const cmd_set_mntopt_usage[] = {
+	"btrfs mount-option set [[+-=]<mount-option>,...] <device>",
+	"Set default mount options",
+	NULL
+};
+
+static int cmd_set_mntopt(int argc, char **argv)
+{
+	char *device;
+
+	if (check_argc_min(argc, 2)) {
+		usage(cmd_set_mntopt_usage);
+		return 1;
+	}
+
+	device = argv[argc - 1];
+	if (mount_check_device(device))
+		return 1;
+
+	if (argc == 2) {
+		/* get mount option */
+		return mount_show_common(device);
+	}
+	/* set mount option */
+	/*
+	 * Note:
+	 *	argv[0] = "btrfs mount-option set"
+	 *	argv[*] = <options>
+	 *	argv[n] = <device>
+	 */
+	return mount_set_common(device, argc - 2, &argv[1]);
+}
+
+static const char * const cmd_get_mntopt_usage[] = {
+	"btrfs mount-option get <device>",
+	"Get default mount options",
+	NULL
+};
+
+static int cmd_get_mntopt(int argc, char **argv)
+{
+	char *device;
+
+	if (check_argc_exact(argc, 2)) {
+		usage(cmd_get_mntopt_usage);
+		return 1;
+	}
+
+	device = argv[argc - 1];
+	if (mount_check_device(device))
+		return 1;
+
+	return mount_show_common(device);
+};
+
+static const char * const cmd_clear_mntopt_usage[] = {
+	"btrfs mount-option clear <device>",
+	"Clear default mount options",
+	NULL
+};
+
+static int cmd_clear_mntopt(int argc, char **argv)
+{
+	char *device;
+
+	if (check_argc_exact(argc, 2)) {
+		usage(cmd_clear_mntopt_usage);
+		return 1;
+	}
+
+	device = argv[argc - 1];
+	if (mount_check_device(device))
+		return 1;
+
+	return mount_set_common(device, 0, NULL);
+};
+
+static const char * const mount_cmd_group_usage[] = {
+	"btrfs mount-option <command> [<args>]",
+	NULL
+};
+
+const struct cmd_group mount_cmd_group = {
+	mount_cmd_group_usage, NULL, {
+		{ "set", cmd_set_mntopt, cmd_set_mntopt_usage, NULL, 0 },
+		{ "get", cmd_get_mntopt, cmd_get_mntopt_usage, NULL, 0 },
+		{ "clear", cmd_clear_mntopt, cmd_clear_mntopt_usage, NULL, 0},
+		{0, 0, 0, 0, 0 }
+	}
+};
+
+int cmd_mount(int argc, char **argv)
+{
+	return handle_command_group(&mount_cmd_group, argc, argv);
+}
diff --git a/commands.h b/commands.h
index bb6d2dd..fea30fd 100644
--- a/commands.h
+++ b/commands.h
@@ -92,6 +92,7 @@ extern const struct cmd_group send_cmd_group;
 extern const struct cmd_group receive_cmd_group;
 extern const struct cmd_group quota_cmd_group;
 extern const struct cmd_group qgroup_cmd_group;
+extern const struct cmd_group mount_cmd_group;
 
 int cmd_subvolume(int argc, char **argv);
 int cmd_filesystem(int argc, char **argv);
@@ -103,6 +104,7 @@ int cmd_send(int argc, char **argv);
 int cmd_receive(int argc, char **argv);
 int cmd_quota(int argc, char **argv);
 int cmd_qgroup(int argc, char **argv);
+int cmd_mount(int argc, char **argv);
 
 /* subvolume exported functions */
 int test_issubvolume(char *path);
diff --git a/ctree.h b/ctree.h
index 7f55229..363a118 100644
--- a/ctree.h
+++ b/ctree.h
@@ -402,8 +402,11 @@ struct btrfs_super_block {
 
 	__le64 cache_generation;
 
+	/* default mount options */
+	__le64 default_mount_opt;
+
 	/* future expansion */
-	__le64 reserved[31];
+	__le64 reserved[30];
 	u8 sys_chunk_array[BTRFS_SYSTEM_CHUNK_ARRAY_SIZE];
 	struct btrfs_root_backup super_roots[BTRFS_NUM_BACKUP_ROOTS];
 } __attribute__ ((__packed__));
@@ -1820,6 +1823,8 @@ BTRFS_SETGET_STACK_FUNCS(super_csum_type, struct btrfs_super_block,
 			 csum_type, 16);
 BTRFS_SETGET_STACK_FUNCS(super_cache_generation, struct btrfs_super_block,
 			 cache_generation, 64);
+BTRFS_SETGET_STACK_FUNCS(super_default_mount_opt, struct btrfs_super_block,
+			 default_mount_opt, 64);
 
 static inline int btrfs_super_csum_size(struct btrfs_super_block *s)
 {
-- 
1.7.7.6


