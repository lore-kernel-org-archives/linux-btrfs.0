Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41559 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab2FXVUj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Jun 2012 17:20:39 -0400
Received: by mail-bk0-f46.google.com with SMTP id ji2so2680230bkc.19
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Jun 2012 14:20:38 -0700 (PDT)
From: Alexander Block <ablock84@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: Alexander Block <ablock84@googlemail.com>
Subject: [PATCH 4/5] Btrfs-progs: make filesystem_cmd_group non const
Date: Sun, 24 Jun 2012 23:20:07 +0200
Message-Id: <1340572808-30281-5-git-send-email-ablock84@googlemail.com>
In-Reply-To: <1340572808-30281-1-git-send-email-ablock84@googlemail.com>
References: <1340572808-30281-1-git-send-email-ablock84@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Make filesystem_cmd_group non const so that btrfs fi prop can
generate the usage string at runtime. The commands member of
struct cmd_group is also non const now.

Signed-off-by: Alexander Block <ablock84@googlemail.com>
---
 cmds-filesystem.c |    2 +-
 commands.h        |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index a8f63b3..4c61233 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -536,7 +536,7 @@ static int cmd_label(int argc, char **argv)
 }
 }
 
-const struct cmd_group filesystem_cmd_group = {
+struct cmd_group filesystem_cmd_group = {
 	filesystem_cmd_group_usage, NULL, {
 		{ "df", cmd_df, cmd_df_usage, NULL, 0 },
 		{ "show", cmd_show, cmd_show_usage, NULL, 0 },
diff --git a/commands.h b/commands.h
index 64acf17..9405806 100644
--- a/commands.h
+++ b/commands.h
@@ -54,7 +54,7 @@ struct cmd_group {
 	const char * const *usagestr;
 	const char *infostr;
 
-	const struct cmd_struct commands[];
+	struct cmd_struct commands[];
 };
 
 /* btrfs.c */
@@ -81,7 +81,7 @@ void help_command_group(const struct cmd_group *grp, int argc, char **argv);
 int open_file_or_dir(const char *fname);
 
 extern const struct cmd_group subvolume_cmd_group;
-extern const struct cmd_group filesystem_cmd_group;
+extern struct cmd_group filesystem_cmd_group;
 extern const struct cmd_group balance_cmd_group;
 extern const struct cmd_group device_cmd_group;
 extern const struct cmd_group scrub_cmd_group;
-- 
1.7.10

