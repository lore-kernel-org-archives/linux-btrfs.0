Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60608 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935177AbeCHClF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 21:41:05 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 85321AF61
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 02:41:03 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 10/20] btrfs-progs: help: convert ints used as bools to bool
Date: Wed,  7 Mar 2018 21:40:37 -0500
Message-Id: <20180308024047.10104-11-jeffm@suse.com>
In-Reply-To: <20180308024047.10104-1-jeffm@suse.com>
References: <20180308024047.10104-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

We use an int for 'full', 'all', and 'err' when we really mean a boolean.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 btrfs.c | 14 +++++++-------
 help.c  | 25 +++++++++++++------------
 help.h  |  4 ++--
 3 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 2d39f2ce..fec1a135 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -109,7 +109,7 @@ static void handle_help_options_next_level(const struct cmd_struct *cmd,
 			argv++;
 			help_command_group(cmd->next, argc, argv);
 		} else {
-			usage_command(cmd, 1, 0);
+			usage_command(cmd, true, false);
 		}
 
 		exit(0);
@@ -125,7 +125,7 @@ int handle_command_group(const struct cmd_group *grp, int argc,
 	argc--;
 	argv++;
 	if (argc < 1) {
-		usage_command_group(grp, 0, 0);
+		usage_command_group(grp, false, false);
 		exit(1);
 	}
 
@@ -212,20 +212,20 @@ static int handle_global_options(int argc, char **argv)
 
 void handle_special_globals(int shift, int argc, char **argv)
 {
-	int has_help = 0;
-	int has_full = 0;
+	bool has_help = false;
+	bool has_full = false;
 	int i;
 
 	for (i = 0; i < shift; i++) {
 		if (strcmp(argv[i], "--help") == 0)
-			has_help = 1;
+			has_help = true;
 		else if (strcmp(argv[i], "--full") == 0)
-			has_full = 1;
+			has_full = true;
 	}
 
 	if (has_help) {
 		if (has_full)
-			usage_command_group(&btrfs_cmd_group, 1, 0);
+			usage_command_group(&btrfs_cmd_group, true, false);
 		else
 			cmd_help(argc, argv);
 		exit(0);
diff --git a/help.c b/help.c
index 311a4320..ef7986b4 100644
--- a/help.c
+++ b/help.c
@@ -196,8 +196,8 @@ static int do_usage_one_command(const char * const *usagestr,
 }
 
 static int usage_command_internal(const char * const *usagestr,
-				  const char *token, int full, int lst,
-				  int alias, FILE *outf)
+				  const char *token, bool full, bool lst,
+				  bool alias, FILE *outf)
 {
 	unsigned int flags = 0;
 	int ret;
@@ -223,17 +223,17 @@ static int usage_command_internal(const char * const *usagestr,
 }
 
 static void usage_command_usagestr(const char * const *usagestr,
-				   const char *token, int full, int err)
+				   const char *token, bool full, bool err)
 {
 	FILE *outf = err ? stderr : stdout;
 	int ret;
 
-	ret = usage_command_internal(usagestr, token, full, 0, 0, outf);
+	ret = usage_command_internal(usagestr, token, full, false, false, outf);
 	if (!ret)
 		fputc('\n', outf);
 }
 
-void usage_command(const struct cmd_struct *cmd, int full, int err)
+void usage_command(const struct cmd_struct *cmd, bool full, bool err)
 {
 	usage_command_usagestr(cmd->usagestr, cmd->token, full, err);
 }
@@ -241,11 +241,11 @@ void usage_command(const struct cmd_struct *cmd, int full, int err)
 __attribute__((noreturn))
 void usage(const char * const *usagestr)
 {
-	usage_command_usagestr(usagestr, NULL, 1, 1);
+	usage_command_usagestr(usagestr, NULL, true, true);
 	exit(1);
 }
 
-static void usage_command_group_internal(const struct cmd_group *grp, int full,
+static void usage_command_group_internal(const struct cmd_group *grp, bool full,
 					 FILE *outf)
 {
 	const struct cmd_struct *cmd = grp->commands;
@@ -265,7 +265,8 @@ static void usage_command_group_internal(const struct cmd_group *grp, int full,
 			}
 
 			usage_command_internal(cmd->usagestr, cmd->token, full,
-					       1, cmd->flags & CMD_ALIAS, outf);
+					       true, cmd->flags & CMD_ALIAS,
+					       outf);
 			if (cmd->flags & CMD_ALIAS)
 				putchar('\n');
 			continue;
@@ -327,7 +328,7 @@ void usage_command_group_short(const struct cmd_group *grp)
 	fprintf(stderr, "All command groups have their manual page named 'btrfs-<group>'.\n");
 }
 
-void usage_command_group(const struct cmd_group *grp, int full, int err)
+void usage_command_group(const struct cmd_group *grp, bool full, bool err)
 {
 	const char * const *usagestr = grp->usagestr;
 	FILE *outf = err ? stderr : stdout;
@@ -350,7 +351,7 @@ __attribute__((noreturn))
 void help_unknown_token(const char *arg, const struct cmd_group *grp)
 {
 	fprintf(stderr, "%s: unknown token '%s'\n", get_argv0_buf(), arg);
-	usage_command_group(grp, 0, 1);
+	usage_command_group(grp, false, true);
 	exit(1);
 }
 
@@ -372,13 +373,13 @@ void help_ambiguous_token(const char *arg, const struct cmd_group *grp)
 
 void help_command_group(const struct cmd_group *grp, int argc, char **argv)
 {
-	int full = 0;
+	bool full = false;
 
 	if (argc > 1) {
 		if (!strcmp(argv[1], "--full"))
 			full = 1;
 	}
 
-	usage_command_group(grp, full, 0);
+	usage_command_group(grp, full, false);
 }
 
diff --git a/help.h b/help.h
index efeded30..a69ea6b2 100644
--- a/help.h
+++ b/help.h
@@ -57,8 +57,8 @@ struct cmd_group;
 
 __attribute__((noreturn))
 void usage(const char * const *usagestr);
-void usage_command(const struct cmd_struct *cmd, int full, int err);
-void usage_command_group(const struct cmd_group *grp, int all, int err);
+void usage_command(const struct cmd_struct *cmd, bool full, bool err);
+void usage_command_group(const struct cmd_group *grp, bool all, bool err);
 void usage_command_group_short(const struct cmd_group *grp);
 
 __attribute__((noreturn))
-- 
2.12.3

