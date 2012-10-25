Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:1304 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S964801Ab2JYItc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 04:49:32 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q9P8nPIt026579
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2012 16:49:25 +0800
From: Chen Yang <chenyang.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Chen Yang <chenyang.fnst@cn.fujitsu.com>
Subject: [PATCH 1/2] Btrfs-progs: Improve the command help system of btrfs
Date: Thu, 25 Oct 2012 16:49:08 +0800
Message-Id: <1351154948-7237-1-git-send-email-chenyang.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs's command help system allow you to show only one line short usage.
But in some case we need to use two or more lines to show
the short usage of a complicated command.

This patch add a filed 'lines' in cmd_struct, which is the number of the
extra short usage lines you want to append.

For example you have N lines short usage; you should set the field 'lines'
to N-1.

Signed-off-by: Cheng Yang <chenyang.fnst@cn.fujitsu.com>
---
 commands.h |    4 ++++
 help.c     |   31 ++++++++++++++++++++++---------
 2 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/commands.h b/commands.h
index bb6d2dd..f535dc2 100644
--- a/commands.h
+++ b/commands.h
@@ -48,6 +48,9 @@ struct cmd_struct {
 
 	/* if true don't list this token in help listings */
 	int hidden;
+
+	/* number of the extra short usage lines  */
+	int lines;
 };
 
 struct cmd_group {
@@ -70,6 +73,7 @@ int handle_command_group(const struct cmd_group *grp, int argc,
 /* help.c */
 extern const char * const generic_cmd_help_usage[];
 
+void usage_lines(const char * const *usagestr, int lines);
 void usage(const char * const *usagestr);
 void usage_command(const struct cmd_struct *cmd, int full, int err);
 void usage_command_group(const struct cmd_group *grp, int all, int err);
diff --git a/help.c b/help.c
index 6d04293..5679933 100644
--- a/help.c
+++ b/help.c
@@ -28,15 +28,21 @@ extern char argv0_buf[ARGV0_BUF_SIZE];
 #define USAGE_LISTING		8U
 
 static int do_usage_one_command(const char * const *usagestr,
-				unsigned int flags, FILE *outf)
+				unsigned int flags, FILE *outf, int lines)
 {
-	int pad = 4;
+	int pad = 4, i = 0;
 
 	if (!usagestr || !*usagestr)
 		return -1;
 
 	fprintf(outf, "%s%s\n", (flags & USAGE_LISTING) ? "    " : "usage: ",
 		*usagestr++);
+	for (i = 0; i < lines; i++) {
+		fprintf(outf, "%s%s\n",
+			(flags & USAGE_LISTING) ? "    " : "       ",
+			usagestr[i]);
+	}
+	usagestr += lines;
 
 	/* a short one-line description (mandatory) */
 	if ((flags & USAGE_SHORT) == 0)
@@ -79,7 +85,7 @@ static int do_usage_one_command(const char * const *usagestr,
 
 static int usage_command_internal(const char * const *usagestr,
 				  const char *token, int full, int lst,
-				  FILE *outf)
+				  FILE *outf, int lines)
 {
 	unsigned int flags = USAGE_SHORT;
 	int ret;
@@ -89,7 +95,7 @@ static int usage_command_internal(const char * const *usagestr,
 	if (lst)
 		flags |= USAGE_LISTING;
 
-	ret = do_usage_one_command(usagestr, flags, outf);
+	ret = do_usage_one_command(usagestr, flags, outf, lines);
 	switch (ret) {
 	case -1:
 		fprintf(outf, "No usage for '%s'\n", token);
@@ -103,24 +109,31 @@ static int usage_command_internal(const char * const *usagestr,
 }
 
 static void usage_command_usagestr(const char * const *usagestr,
-				   const char *token, int full, int err)
+			   const char *token, int full, int err, int lines)
 {
 	FILE *outf = err ? stderr : stdout;
 	int ret;
 
-	ret = usage_command_internal(usagestr, token, full, 0, outf);
+	ret = usage_command_internal(usagestr, token, full, 0, outf, lines);
 	if (!ret)
 		fputc('\n', outf);
 }
 
 void usage_command(const struct cmd_struct *cmd, int full, int err)
 {
-	usage_command_usagestr(cmd->usagestr, cmd->token, full, err);
+	usage_command_usagestr(
+		cmd->usagestr, cmd->token, full, err, cmd->lines);
 }
 
 void usage(const char * const *usagestr)
 {
-	usage_command_usagestr(usagestr, NULL, 1, 1);
+	usage_lines(usagestr, 0);
+	exit(129);
+}
+
+void usage_lines(const char * const *usagestr, int lines)
+{
+	usage_command_usagestr(usagestr, NULL, 1, 1, lines);
 	exit(129);
 }
 
@@ -144,7 +157,7 @@ static void usage_command_group_internal(const struct cmd_group *grp, int full,
 			}
 
 			usage_command_internal(cmd->usagestr, cmd->token, full,
-					       1, outf);
+					       1, outf, cmd->lines);
 			continue;
 		}
 
-- 
1.7.7.6

