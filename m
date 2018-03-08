Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60637 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935194AbeCHClH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 21:41:07 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 202AFAF96
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 02:41:06 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 20/20] btrfs-progs: handle command groups directly for common case
Date: Wed,  7 Mar 2018 21:40:47 -0500
Message-Id: <20180308024047.10104-21-jeffm@suse.com>
In-Reply-To: <20180308024047.10104-1-jeffm@suse.com>
References: <20180308024047.10104-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

Most command groups just pass their own command group to
handle_command_group.  We can remove the explicit definitions
of command group callbacks by passing the cmd_struct to
handle_command_group and allowing it to resolve the group from it.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 btrfs.c           | 14 +++++++-------
 cmds-balance.c    |  6 +++---
 cmds-device.c     |  5 -----
 cmds-filesystem.c |  6 ------
 cmds-inspect.c    |  5 -----
 cmds-property.c   |  6 ------
 cmds-qgroup.c     |  5 -----
 cmds-quota.c      |  5 -----
 cmds-replace.c    |  5 -----
 cmds-rescue.c     |  5 -----
 cmds-scrub.c      |  6 ------
 cmds-subvolume.c  |  5 -----
 commands.h        |  7 ++++---
 13 files changed, 14 insertions(+), 66 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 32b8e090..427e14c8 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -140,26 +140,26 @@ static void handle_help_options_next_level(const struct cmd_struct *cmd,
 	}
 }
 
-int handle_command_group(const struct cmd_group *grp,
+int handle_command_group(const struct cmd_struct *cmd,
 			 const struct cmd_context *cmdcxt,
 			 int argc, char **argv)
 
 {
-	const struct cmd_struct *cmd;
+	const struct cmd_struct *subcmd;
 
 	argc--;
 	argv++;
 	if (argc < 1) {
-		usage_command_group(grp, false, false);
+		usage_command_group(cmd->next, false, false);
 		exit(1);
 	}
 
-	cmd = parse_command_token(argv[0], grp);
+	subcmd = parse_command_token(argv[0], cmd->next);
 
-	handle_help_options_next_level(cmd, cmdcxt, argc, argv);
+	handle_help_options_next_level(subcmd, cmdcxt, argc, argv);
 
-	fixup_argv0(argv, cmd->token);
-	return cmd_execute(cmd, cmdcxt, argc, argv);
+	fixup_argv0(argv, subcmd->token);
+	return cmd_execute(subcmd, cmdcxt, argc, argv);
 }
 
 static const struct cmd_group btrfs_cmd_group;
diff --git a/cmds-balance.c b/cmds-balance.c
index c17b9ee3..e414ca27 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -943,7 +943,7 @@ static const struct cmd_group balance_cmd_group = {
 	}
 };
 
-static int cmd_balance(const struct cmd_struct *unused,
+static int cmd_balance(const struct cmd_struct *cmd,
 		       const struct cmd_context *cmdcxt, int argc, char **argv)
 {
 	if (argc == 2 && strcmp("start", argv[1]) != 0) {
@@ -956,7 +956,7 @@ static int cmd_balance(const struct cmd_struct *unused,
 		return do_balance(argv[1], &args, 0);
 	}
 
-	return handle_command_group(&balance_cmd_group, cmdcxt, argc, argv);
+	return handle_command_group(cmd, cmdcxt, argc, argv);
 }
 
-DEFINE_GROUP_COMMAND(balance, "balance");
+DEFINE_COMMAND(balance, "balance", cmd_balance, NULL, &balance_cmd_group, 0, 0);
diff --git a/cmds-device.c b/cmds-device.c
index ac9e82b1..f8c0ff20 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -630,9 +630,4 @@ static const struct cmd_group device_cmd_group = {
 	}
 };
 
-static int cmd_device(const struct cmd_struct *unused,
-		      const struct cmd_context *cmdcxt, int argc, char **argv)
-{
-	return handle_command_group(&device_cmd_group, cmdcxt, argc, argv);
-}
 DEFINE_GROUP_COMMAND_TOKEN(device);
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 27e0865c..e3e54864 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -1242,10 +1242,4 @@ static const struct cmd_group filesystem_cmd_group = {
 	}
 };
 
-static int cmd_filesystem(const struct cmd_struct *unused,
-			  const struct cmd_context *cmdcxt,
-			  int argc, char **argv)
-{
-	return handle_command_group(&filesystem_cmd_group, cmdcxt, argc, argv);
-}
 DEFINE_GROUP_COMMAND_TOKEN(filesystem);
diff --git a/cmds-inspect.c b/cmds-inspect.c
index ade9db7e..561a0fbd 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -658,9 +658,4 @@ static const struct cmd_group inspect_cmd_group = {
 	}
 };
 
-static int cmd_inspect(const struct cmd_struct *unused,
-		       const struct cmd_context *cmdcxt, int argc, char **argv)
-{
-	return handle_command_group(&inspect_cmd_group, cmdcxt, argc, argv);
-}
 DEFINE_GROUP_COMMAND(inspect, "inspect");
diff --git a/cmds-property.c b/cmds-property.c
index 498fa456..58f6c48a 100644
--- a/cmds-property.c
+++ b/cmds-property.c
@@ -422,10 +422,4 @@ static const struct cmd_group property_cmd_group = {
 	}
 };
 
-static int cmd_property(const struct cmd_struct *unused,
-			const struct cmd_context *cmdcxt,
-			int argc, char **argv)
-{
-	return handle_command_group(&property_cmd_group, cmdcxt, argc, argv);
-}
 DEFINE_GROUP_COMMAND_TOKEN(property);
diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index fd637a45..e20c1159 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -558,9 +558,4 @@ static const struct cmd_group qgroup_cmd_group = {
 	}
 };
 
-static int cmd_qgroup(const struct cmd_struct *unused,
-		      const struct cmd_context *cmdcxt, int argc, char **argv)
-{
-	return handle_command_group(&qgroup_cmd_group, cmdcxt, argc, argv);
-}
 DEFINE_GROUP_COMMAND_TOKEN(qgroup);
diff --git a/cmds-quota.c b/cmds-quota.c
index 2a88d4c4..7b524123 100644
--- a/cmds-quota.c
+++ b/cmds-quota.c
@@ -219,9 +219,4 @@ static const struct cmd_group quota_cmd_group = {
 	}
 };
 
-static int cmd_quota(const struct cmd_struct *unused,
-		     const struct cmd_context *cmdcxt, int argc, char **argv)
-{
-	return handle_command_group(&quota_cmd_group, cmdcxt, argc, argv);
-}
 DEFINE_GROUP_COMMAND_TOKEN(quota);
diff --git a/cmds-replace.c b/cmds-replace.c
index 64c93537..8b2091c9 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -560,9 +560,4 @@ static const struct cmd_group replace_cmd_group = {
 	}
 };
 
-static int cmd_replace(const struct cmd_struct *unused,
-		       const struct cmd_context *cmdcxt, int argc, char **argv)
-{
-	return handle_command_group(&replace_cmd_group, cmdcxt, argc, argv);
-}
 DEFINE_GROUP_COMMAND_TOKEN(replace);
diff --git a/cmds-rescue.c b/cmds-rescue.c
index ec1ea222..364d6dd9 100644
--- a/cmds-rescue.c
+++ b/cmds-rescue.c
@@ -273,9 +273,4 @@ static const struct cmd_group rescue_cmd_group = {
 	}
 };
 
-static int cmd_rescue(const struct cmd_struct *unused,
-		      const struct cmd_context *cmdcxt, int argc, char **argv)
-{
-	return handle_command_group(&rescue_cmd_group, cmdcxt, argc, argv);
-}
 DEFINE_GROUP_COMMAND_TOKEN(rescue);
diff --git a/cmds-scrub.c b/cmds-scrub.c
index d4d5a10c..b0238032 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -1807,10 +1807,4 @@ static const struct cmd_group scrub_cmd_group = {
 	}
 };
 
-static int cmd_scrub(const struct cmd_struct *unused,
-		     const struct cmd_context *cmdcxt, int argc, char **argv)
-{
-	return handle_command_group(&scrub_cmd_group, cmdcxt, argc, argv);
-}
-
 DEFINE_GROUP_COMMAND_TOKEN(scrub);
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 3498ff21..7a420a64 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -1466,9 +1466,4 @@ static const struct cmd_group subvolume_cmd_group = {
 	}
 };
 
-int cmd_subvolume(const struct cmd_struct *unused,
-		  const struct cmd_context *cmdcxt, int argc, char **argv)
-{
-	return handle_command_group(&subvolume_cmd_group, cmdcxt, argc, argv);
-}
 DEFINE_GROUP_COMMAND_TOKEN(subvolume);
diff --git a/commands.h b/commands.h
index bf74eaf8..65be8742 100644
--- a/commands.h
+++ b/commands.h
@@ -107,7 +107,8 @@ struct cmd_struct {
 /*
  * Define a command for the common case - just a name and string.
  * It's assumed that the callback is called cmd_<name> and the usage
- * array is named cmd_<name>_usage.
+ * array is named cmd_<name>_usage.  Text is the only supported output
+ * format.
  */
 #define DEFINE_SIMPLE_COMMAND(name, token)				\
 	DEFINE_COMMAND(name, token, cmd_ ##name,			\
@@ -119,7 +120,7 @@ struct cmd_struct {
  * struct cmd_group is called <name>_cmd_group.
  */
 #define DEFINE_GROUP_COMMAND(name, token)				\
-	DEFINE_COMMAND(name, token, cmd_ ##name,			\
+	DEFINE_COMMAND(name, token, handle_command_group,		\
 		       NULL, &(name ## _cmd_group), 0, 0)
 
 /*
@@ -143,7 +144,7 @@ static inline int cmd_execute(const struct cmd_struct *cmd,
 	return cmd->fn(cmd, cmdcxt, argc, argv);
 }
 
-int handle_command_group(const struct cmd_group *grp,
+int handle_command_group(const struct cmd_struct *cmd,
 			 const struct cmd_context *cmdcxt,
 			 int argc, char **argv);
 
-- 
2.12.3

