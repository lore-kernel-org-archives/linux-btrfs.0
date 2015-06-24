Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43151 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753198AbbFXQJv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Jun 2015 12:09:51 -0400
Received: from pps.filterd (m0044010 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id t5OG9nbt012962
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2015 09:09:51 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0a-00082601.pphosted.com with ESMTP id 1v7yn200v4-4
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2015 09:09:51 -0700
From: Omar Sandoval <osandov@fb.com>
To: <linux-btrfs@vger.kernel.org>
CC: Omar Sandoval <osandov@fb.com>
Subject: [PATCH 1/2] btrfs-progs: replace struct cmd_group->hidden with flags
Date: Wed, 24 Jun 2015 09:09:16 -0700
Message-ID: <2368516acde293032f9dae5117136fbf138e33c3.1435161735.git.osandov@fb.com>
In-Reply-To: <cover.1435161735.git.osandov@fb.com>
References: <cover.1435161735.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We're also going to want to support aliases, so rather than adding
another member, replace "hidden" with a "flags" member.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 cmds-filesystem.c | 2 +-
 commands.h        | 8 ++++++--
 help.c            | 2 +-
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index b93bb33028f2..284dc87bc464 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -1327,7 +1327,7 @@ const struct cmd_group filesystem_cmd_group = {
 		{ "show", cmd_show, cmd_show_usage, NULL, 0 },
 		{ "sync", cmd_sync, cmd_sync_usage, NULL, 0 },
 		{ "defragment", cmd_defrag, cmd_defrag_usage, NULL, 0 },
-		{ "balance", cmd_balance, NULL, &balance_cmd_group, 1 },
+		{ "balance", cmd_balance, NULL, &balance_cmd_group, CMD_HIDDEN },
 		{ "resize", cmd_resize, cmd_resize_usage, NULL, 0 },
 		{ "label", cmd_label, cmd_label_usage, NULL, 0 },
 		{ "usage", cmd_filesystem_usage,
diff --git a/commands.h b/commands.h
index bd23340d45ae..42d31781f1a3 100644
--- a/commands.h
+++ b/commands.h
@@ -17,6 +17,10 @@
 #ifndef __BTRFS_COMMANDS_H__
 #define __BTRFS_COMMANDS_H__
 
+enum {
+	CMD_HIDDEN = (1 << 0),	/* should not be in help listings */
+};
+
 struct cmd_struct {
 	const char *token;
 	int (*fn)(int, char **);
@@ -47,8 +51,8 @@ struct cmd_struct {
 	/* should be NULL if token is not a subgroup */
 	const struct cmd_group *next;
 
-	/* if true don't list this token in help listings */
-	int hidden;
+	/* CMD_* flags above */
+	int flags;
 };
 
 #define NULL_CMD_STRUCT {NULL, NULL, NULL, NULL, 0}
diff --git a/help.c b/help.c
index 56aaf9c3c64c..34754c16e6fe 100644
--- a/help.c
+++ b/help.c
@@ -133,7 +133,7 @@ static void usage_command_group_internal(const struct cmd_group *grp, int full,
 	int do_sep = 0;
 
 	for (; cmd->token; cmd++) {
-		if (cmd->hidden)
+		if (cmd->flags & CMD_HIDDEN)
 			continue;
 
 		if (full && cmd != grp->commands)
-- 
2.4.4

