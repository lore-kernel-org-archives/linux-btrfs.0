Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62053 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932539AbdDQD0v (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Apr 2017 23:26:51 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 3/9] btrfs-progs: Export commands processing code to commands.c from btrfs.c
Date: Mon, 17 Apr 2017 11:26:36 +0800
Message-ID: <20170417032642.30770-4-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170417032642.30770-1-quwenruo@cn.fujitsu.com>
References: <20170417032642.30770-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This allow us to the command group facility for other progs other than
btrfs command.
And since it's not bond to 'btrfs' command, move it to commands.c.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Makefile   |   2 +-
 btrfs.c    | 104 --------------------------------------------------
 commands.c | 127 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 commands.h |   4 ++
 4 files changed, 132 insertions(+), 105 deletions(-)
 create mode 100644 commands.c

diff --git a/Makefile b/Makefile
index 81598df1..f405c1ec 100644
--- a/Makefile
+++ b/Makefile
@@ -95,7 +95,7 @@ objects = ctree.o disk-io.o kernel-lib/radix-tree.o extent-tree.o print-tree.o \
 	  qgroup.o raid56.o free-space-cache.o kernel-lib/list_sort.o props.o \
 	  kernel-shared/ulist.o qgroup-verify.o backref.o string-table.o task-utils.o \
 	  inode.o file.o find-root.o free-space-tree.o help.o send-dump.o \
-	  fsfeatures.o
+	  fsfeatures.o commands.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
diff --git a/btrfs.c b/btrfs.c
index 9214ae6e..f096e780 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -32,110 +32,6 @@ static const char * const btrfs_cmd_group_usage[] = {
 static const char btrfs_cmd_group_info[] =
 	"Use --help as an argument for information on a specific group or command.";
 
-static inline const char *skip_prefix(const char *str, const char *prefix)
-{
-	size_t len = strlen(prefix);
-	return strncmp(str, prefix, len) ? NULL : str + len;
-}
-
-static int parse_one_token(const char *arg, const struct cmd_group *grp,
-			   const struct cmd_struct **cmd_ret)
-{
-	const struct cmd_struct *cmd = grp->commands;
-	const struct cmd_struct *abbrev_cmd = NULL, *ambiguous_cmd = NULL;
-
-	for (; cmd->token; cmd++) {
-		const char *rest;
-
-		rest = skip_prefix(arg, cmd->token);
-		if (!rest) {
-			if (!prefixcmp(cmd->token, arg)) {
-				if (abbrev_cmd) {
-					/*
-					 * If this is abbreviated, it is
-					 * ambiguous. So when there is no
-					 * exact match later, we need to
-					 * error out.
-					 */
-					ambiguous_cmd = abbrev_cmd;
-				}
-				abbrev_cmd = cmd;
-			}
-			continue;
-		}
-		if (*rest)
-			continue;
-
-		*cmd_ret = cmd;
-		return 0;
-	}
-
-	if (ambiguous_cmd)
-		return -2;
-
-	if (abbrev_cmd) {
-		*cmd_ret = abbrev_cmd;
-		return 0;
-	}
-
-	return -1;
-}
-
-static const struct cmd_struct *
-parse_command_token(const char *arg, const struct cmd_group *grp)
-{
-	const struct cmd_struct *cmd = NULL;
-
-	switch(parse_one_token(arg, grp, &cmd)) {
-	case -1:
-		help_unknown_token(arg, grp);
-	case -2:
-		help_ambiguous_token(arg, grp);
-	}
-
-	return cmd;
-}
-
-static void handle_help_options_next_level(const struct cmd_struct *cmd,
-		int argc, char **argv)
-{
-	if (argc < 2)
-		return;
-
-	if (!strcmp(argv[1], "--help")) {
-		if (cmd->next) {
-			argc--;
-			argv++;
-			help_command_group(cmd->next, argc, argv);
-		} else {
-			usage_command(cmd, 1, 0);
-		}
-
-		exit(0);
-	}
-}
-
-int handle_command_group(const struct cmd_group *grp, int argc,
-			 char **argv)
-
-{
-	const struct cmd_struct *cmd;
-
-	argc--;
-	argv++;
-	if (argc < 1) {
-		usage_command_group(grp, 0, 0);
-		exit(1);
-	}
-
-	cmd = parse_command_token(argv[0], grp);
-
-	handle_help_options_next_level(cmd, argc, argv);
-
-	fixup_argv0(argv, cmd->token);
-	return cmd->fn(argc, argv);
-}
-
 static const struct cmd_group btrfs_cmd_group;
 
 static const char * const cmd_help_usage[] = {
diff --git a/commands.c b/commands.c
new file mode 100644
index 00000000..dc016e97
--- /dev/null
+++ b/commands.c
@@ -0,0 +1,127 @@
+/*
+ * Copyright (C) 2017 Fujitsu.  All rights reserved.
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
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include "commands.h"
+#include "utils.h"
+#include "help.h"
+
+static inline const char *skip_prefix(const char *str, const char *prefix)
+{
+	size_t len = strlen(prefix);
+	return strncmp(str, prefix, len) ? NULL : str + len;
+}
+
+static int parse_one_token(const char *arg, const struct cmd_group *grp,
+			   const struct cmd_struct **cmd_ret)
+{
+	const struct cmd_struct *cmd = grp->commands;
+	const struct cmd_struct *abbrev_cmd = NULL, *ambiguous_cmd = NULL;
+
+	for (; cmd->token; cmd++) {
+		const char *rest;
+
+		rest = skip_prefix(arg, cmd->token);
+		if (!rest) {
+			if (!prefixcmp(cmd->token, arg)) {
+				if (abbrev_cmd) {
+					/*
+					 * If this is abbreviated, it is
+					 * ambiguous. So when there is no
+					 * exact match later, we need to
+					 * error out.
+					 */
+					ambiguous_cmd = abbrev_cmd;
+				}
+				abbrev_cmd = cmd;
+			}
+			continue;
+		}
+		if (*rest)
+			continue;
+
+		*cmd_ret = cmd;
+		return 0;
+	}
+
+	if (ambiguous_cmd)
+		return -2;
+
+	if (abbrev_cmd) {
+		*cmd_ret = abbrev_cmd;
+		return 0;
+	}
+
+	return -1;
+}
+
+const struct cmd_struct *
+parse_command_token(const char *arg, const struct cmd_group *grp)
+{
+	const struct cmd_struct *cmd = NULL;
+
+	switch(parse_one_token(arg, grp, &cmd)) {
+	case -1:
+		help_unknown_token(arg, grp);
+	case -2:
+		help_ambiguous_token(arg, grp);
+	}
+
+	return cmd;
+}
+
+void handle_help_options_next_level(const struct cmd_struct *cmd,
+				    int argc, char **argv)
+{
+	if (argc < 2)
+		return;
+
+	if (!strcmp(argv[1], "--help")) {
+		if (cmd->next) {
+			argc--;
+			argv++;
+			help_command_group(cmd->next, argc, argv);
+		} else {
+			usage_command(cmd, 1, 0);
+		}
+
+		exit(0);
+	}
+}
+
+int handle_command_group(const struct cmd_group *grp, int argc,
+			 char **argv)
+{
+	const struct cmd_struct *cmd;
+
+	argc--;
+	argv++;
+	if (argc < 1) {
+		usage_command_group(grp, 0, 0);
+		exit(1);
+	}
+
+	cmd = parse_command_token(argv[0], grp);
+
+	handle_help_options_next_level(cmd, argc, argv);
+
+	fixup_argv0(argv, cmd->token);
+	return cmd->fn(argc, argv);
+}
diff --git a/commands.h b/commands.h
index 01bf387e..5e109537 100644
--- a/commands.h
+++ b/commands.h
@@ -111,4 +111,8 @@ int cmd_dump_super(int argc, char **argv);
 int cmd_debug_tree(int argc, char **argv);
 int cmd_rescue(int argc, char **argv);
 
+const struct cmd_struct *
+parse_command_token(const char *arg, const struct cmd_group *grp);
+void handle_help_options_next_level(const struct cmd_struct *cmd,
+				    int argc, char **argv);
 #endif
-- 
2.12.2



