Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52679 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751474AbeEPVjF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 17:39:05 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 13E7CAF5E
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 21:39:03 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 14/18] btrfs-progs: pass cmd_struct to clean_args_no_options{,_relaxed}
Date: Wed, 16 May 2018 17:38:47 -0400
Message-Id: <20180516213851.10196-15-jeffm@suse.com>
In-Reply-To: <20180516213851.10196-1-jeffm@suse.com>
References: <20180516213851.10196-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

Now that we have a cmd_struct everywhere, we can pass it to
clean_args_no_options and have it resolve the usage string from
it there.  This is necessary for it to pass the cmd_struct to
usage() in the next patch.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 cmds-balance.c    |  6 +++---
 cmds-device.c     |  9 +++++----
 cmds-filesystem.c |  8 ++++----
 cmds-inspect.c    |  4 ++--
 cmds-qgroup.c     | 16 ++++++++--------
 cmds-quota.c      |  4 ++--
 cmds-rescue.c     |  4 ++--
 cmds-scrub.c      | 15 ++++++++-------
 cmds-subvolume.c  |  6 +++---
 help.c            |  9 +++++----
 help.h            |  6 ++++--
 11 files changed, 46 insertions(+), 41 deletions(-)

diff --git a/cmds-balance.c b/cmds-balance.c
index 1bd7b3ce..488fffcc 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -689,7 +689,7 @@ static int cmd_balance_pause(const struct cmd_struct *cmd,
 	int ret;
 	DIR *dirstream = NULL;
 
-	clean_args_no_options(argc, argv, cmd_balance_pause_usage);
+	clean_args_no_options(cmd, argc, argv);
 
 	if (check_argc_exact(argc - optind, 1))
 		usage(cmd_balance_pause_usage);
@@ -729,7 +729,7 @@ static int cmd_balance_cancel(const struct cmd_struct *cmd,
 	int ret;
 	DIR *dirstream = NULL;
 
-	clean_args_no_options(argc, argv, cmd_balance_cancel_usage);
+	clean_args_no_options(cmd, argc, argv);
 
 	if (check_argc_exact(argc - optind, 1))
 		usage(cmd_balance_cancel_usage);
@@ -770,7 +770,7 @@ static int cmd_balance_resume(const struct cmd_struct *cmd,
 	int fd;
 	int ret;
 
-	clean_args_no_options(argc, argv, cmd_balance_resume_usage);
+	clean_args_no_options(cmd, argc, argv);
 
 	if (check_argc_exact(argc - optind, 1))
 		usage(cmd_balance_resume_usage);
diff --git a/cmds-device.c b/cmds-device.c
index feb53f68..5be748f7 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -149,11 +149,12 @@ static int _cmd_device_remove(const struct cmd_struct *cmd,
 	char	*mntpnt;
 	int i, fdmnt, ret = 0;
 	DIR	*dirstream = NULL;
+	const char * const *usagestr = cmd->usagestr;
 
-	clean_args_no_options(argc, argv, cmd->usagestr);
+	clean_args_no_options(cmd, argc, argv);
 
 	if (check_argc_min(argc - optind, 2))
-		usage(cmd->usagestr);
+		usage(usagestr);
 
 	mntpnt = argv[argc - 1];
 
@@ -347,7 +348,7 @@ static int cmd_device_ready(const struct cmd_struct *cmd, int argc, char **argv)
 	int	ret;
 	char	*path;
 
-	clean_args_no_options(argc, argv, cmd->usagestr);
+	clean_args_no_options(cmd, argc, argv);
 
 	if (check_argc_exact(argc - optind, 1))
 		usage(cmd_device_ready_usage);
@@ -573,7 +574,7 @@ static int cmd_device_usage(const struct cmd_struct *cmd, int argc, char **argv)
 
 	unit_mode = get_unit_mode_from_arg(&argc, argv, 1);
 
-	clean_args_no_options(argc, argv, cmd->usagestr);
+	clean_args_no_options(cmd, argc, argv);
 
 	if (check_argc_min(argc - optind, 1))
 		usage(cmd_device_usage_usage);
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 649d97a9..2a9f530d 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -129,7 +129,7 @@ static int cmd_filesystem_df(const struct cmd_struct *cmd,
 
 	unit_mode = get_unit_mode_from_arg(&argc, argv, 1);
 
-	clean_args_no_options(argc, argv, cmd_filesystem_df_usage);
+	clean_args_no_options(cmd, argc, argv);
 
 	if (check_argc_exact(argc - optind, 1))
 		usage(cmd_filesystem_df_usage);
@@ -822,7 +822,7 @@ static int cmd_filesystem_sync(const struct cmd_struct *cmd,
 {
 	enum btrfs_util_error err;
 
-	clean_args_no_options(argc, argv, cmd_filesystem_sync_usage);
+	clean_args_no_options(cmd, argc, argv);
 
 	if (check_argc_exact(argc - optind, 1))
 		usage(cmd_filesystem_sync_usage);
@@ -1095,7 +1095,7 @@ static int cmd_filesystem_resize(const struct cmd_struct *cmd,
 	DIR	*dirstream = NULL;
 	struct stat st;
 
-	clean_args_no_options_relaxed(argc, argv);
+	clean_args_no_options_relaxed(cmd, argc, argv);
 
 	if (check_argc_exact(argc - optind, 2))
 		usage(cmd_filesystem_resize_usage);
@@ -1168,7 +1168,7 @@ static const char * const cmd_filesystem_label_usage[] = {
 static int cmd_filesystem_label(const struct cmd_struct *cmd,
 				int argc, char **argv)
 {
-	clean_args_no_options(argc, argv, cmd_filesystem_label_usage);
+	clean_args_no_options(cmd, argc, argv);
 
 	if (check_argc_min(argc - optind, 1) ||
 			check_argc_max(argc - optind, 2))
diff --git a/cmds-inspect.c b/cmds-inspect.c
index 46ea5551..b6d045a3 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -277,7 +277,7 @@ static int cmd_inspect_subvolid_resolve(const struct cmd_struct *cmd,
 	char path[PATH_MAX];
 	DIR *dirstream = NULL;
 
-	clean_args_no_options(argc, argv, cmd_inspect_subvolid_resolve_usage);
+	clean_args_no_options(cmd, argc, argv);
 
 	if (check_argc_exact(argc - optind, 2))
 		usage(cmd_inspect_subvolid_resolve_usage);
@@ -320,7 +320,7 @@ static int cmd_inspect_rootid(const struct cmd_struct *cmd,
 	u64 rootid;
 	DIR *dirstream = NULL;
 
-	clean_args_no_options(argc, argv, cmd_inspect_rootid_usage);
+	clean_args_no_options(cmd, argc, argv);
 
 	if (check_argc_exact(argc - optind, 1))
 		usage(cmd_inspect_rootid_usage);
diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 5426c8fe..2b220224 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -35,8 +35,8 @@ static const char * const qgroup_cmd_group_usage[] = {
 	NULL
 };
 
-static int _cmd_qgroup_assign(int assign, int argc, char **argv,
-		const char * const *usage_str)
+static int _cmd_qgroup_assign(const struct cmd_struct *cmd, int assign,
+			      int argc, char **argv)
 {
 	int ret = 0;
 	int fd;
@@ -72,11 +72,11 @@ static int _cmd_qgroup_assign(int assign, int argc, char **argv,
 			}
 		}
 	} else {
-		clean_args_no_options(argc, argv, usage_str);
+		clean_args_no_options(cmd, argc, argv);
 	}
 
 	if (check_argc_exact(argc - optind, 3))
-		usage(usage_str);
+		usage(cmd->usagestr);
 
 	memset(&args, 0, sizeof(args));
 	args.assign = assign;
@@ -220,7 +220,7 @@ static const char * const cmd_qgroup_assign_usage[] = {
 static int cmd_qgroup_assign(const struct cmd_struct *cmd,
 			     int argc, char **argv)
 {
-	return _cmd_qgroup_assign(1, argc, argv, cmd_qgroup_assign_usage);
+	return _cmd_qgroup_assign(cmd, 1, argc, argv);
 }
 static DEFINE_SIMPLE_COMMAND(qgroup_assign, "assign");
 
@@ -233,7 +233,7 @@ static const char * const cmd_qgroup_remove_usage[] = {
 static int cmd_qgroup_remove(const struct cmd_struct *cmd,
 			     int argc, char **argv)
 {
-	return _cmd_qgroup_assign(0, argc, argv, cmd_qgroup_remove_usage);
+	return _cmd_qgroup_assign(cmd, 0, argc, argv);
 }
 static DEFINE_SIMPLE_COMMAND(qgroup_remove, "remove");
 
@@ -248,7 +248,7 @@ static int cmd_qgroup_create(const struct cmd_struct *cmd,
 {
 	int ret;
 
-	clean_args_no_options(argc, argv, cmd_qgroup_create_usage);
+	clean_args_no_options(cmd, argc, argv);
 
 	ret = _cmd_qgroup_create(1, argc, argv);
 
@@ -269,7 +269,7 @@ static int cmd_qgroup_destroy(const struct cmd_struct *cmd,
 {
 	int ret;
 
-	clean_args_no_options(argc, argv, cmd_qgroup_destroy_usage);
+	clean_args_no_options(cmd, argc, argv);
 
 	ret = _cmd_qgroup_create(0, argc, argv);
 
diff --git a/cmds-quota.c b/cmds-quota.c
index a6e7a6f6..23757f9a 100644
--- a/cmds-quota.c
+++ b/cmds-quota.c
@@ -71,7 +71,7 @@ static int cmd_quota_enable(const struct cmd_struct *cmd, int argc, char **argv)
 {
 	int ret;
 
-	clean_args_no_options(argc, argv, cmd_quota_enable_usage);
+	clean_args_no_options(cmd, argc, argv);
 
 	ret = quota_ctl(BTRFS_QUOTA_CTL_ENABLE, argc, argv);
 
@@ -92,7 +92,7 @@ static int cmd_quota_disable(const struct cmd_struct *cmd,
 {
 	int ret;
 
-	clean_args_no_options(argc, argv, cmd_quota_disable_usage);
+	clean_args_no_options(cmd, argc, argv);
 
 	ret = quota_ctl(BTRFS_QUOTA_CTL_DISABLE, argc, argv);
 
diff --git a/cmds-rescue.c b/cmds-rescue.c
index f5a618e1..975ff05a 100644
--- a/cmds-rescue.c
+++ b/cmds-rescue.c
@@ -170,7 +170,7 @@ static int cmd_rescue_zero_log(const struct cmd_struct *cmd,
 	char *devname;
 	int ret;
 
-	clean_args_no_options(argc, argv, cmd_rescue_zero_log_usage);
+	clean_args_no_options(cmd, argc, argv);
 
 	if (check_argc_exact(argc, 2))
 		usage(cmd_rescue_zero_log_usage);
@@ -223,7 +223,7 @@ static int cmd_rescue_fix_device_size(const struct cmd_struct *cmd,
 	char *devname;
 	int ret;
 
-	clean_args_no_options(argc, argv, cmd_rescue_fix_device_size_usage);
+	clean_args_no_options(cmd, argc, argv);
 
 	if (check_argc_exact(argc, 2))
 		usage(cmd_rescue_fix_device_size_usage);
diff --git a/cmds-scrub.c b/cmds-scrub.c
index a421047b..b07ff2e3 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -1095,8 +1095,7 @@ static int is_scrub_running_in_kernel(int fd,
 static const char * const cmd_scrub_start_usage[];
 static const char * const cmd_scrub_resume_usage[];
 
-static int scrub_start(const struct cmd_struct *cmd, int argc, char **argv,
-		       bool resume)
+static int scrub_start(int argc, char **argv, bool resume)
 {
 	int fdmnt;
 	int prg_fd = -1;
@@ -1175,14 +1174,16 @@ static int scrub_start(const struct cmd_struct *cmd, int argc, char **argv,
 			break;
 		case '?':
 		default:
-			usage(cmd->usagestr);
+			usage(resume ? cmd_scrub_resume_usage :
+						cmd_scrub_start_usage);
 		}
 	}
 
 	/* try to catch most error cases before forking */
 
 	if (check_argc_exact(argc - optind, 1)) {
-		usage(cmd->usagestr);
+		usage(resume ? cmd_scrub_resume_usage :
+					cmd_scrub_start_usage);
 	}
 
 	spc.progress = NULL;
@@ -1575,7 +1576,7 @@ static const char * const cmd_scrub_start_usage[] = {
 
 static int cmd_scrub_start(const struct cmd_struct *cmd, int argc, char **argv)
 {
-	return scrub_start(cmd, argc, argv, false);
+	return scrub_start(argc, argv, false);
 }
 static DEFINE_SIMPLE_COMMAND(scrub_start, "start");
 
@@ -1592,7 +1593,7 @@ static int cmd_scrub_cancel(const struct cmd_struct *cmd, int argc, char **argv)
 	int fdmnt = -1;
 	DIR *dirstream = NULL;
 
-	clean_args_no_options(argc, argv, cmd_scrub_cancel_usage);
+	clean_args_no_options(cmd, argc, argv);
 
 	if (check_argc_exact(argc - optind, 1))
 		usage(cmd_scrub_cancel_usage);
@@ -1642,7 +1643,7 @@ static const char * const cmd_scrub_resume_usage[] = {
 
 static int cmd_scrub_resume(const struct cmd_struct *cmd, int argc, char **argv)
 {
-	return scrub_start(cmd, argc, argv, true);
+	return scrub_start(argc, argv, true);
 }
 static DEFINE_SIMPLE_COMMAND(scrub_resume, "resume");
 
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index f00503b5..dc065ea7 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -784,7 +784,7 @@ static int cmd_subvol_get_default(const struct cmd_struct *cmd,
 	struct btrfs_util_subvolume_info subvol;
 	char *path;
 
-	clean_args_no_options(argc, argv, cmd_subvol_get_default_usage);
+	clean_args_no_options(cmd, argc, argv);
 
 	if (check_argc_exact(argc - optind, 1))
 		usage(cmd_subvol_get_default_usage);
@@ -846,7 +846,7 @@ static int cmd_subvol_set_default(const struct cmd_struct *cmd,
 	char *path;
 	enum btrfs_util_error err;
 
-	clean_args_no_options(argc, argv, cmd_subvol_set_default_usage);
+	clean_args_no_options(cmd, argc, argv);
 
 	if (check_argc_min(argc - optind, 1) ||
 			check_argc_max(argc - optind, 2))
@@ -887,7 +887,7 @@ static int cmd_subvol_find_new(const struct cmd_struct *cmd,
 	DIR *dirstream = NULL;
 	enum btrfs_util_error err;
 
-	clean_args_no_options(argc, argv, cmd_subvol_find_new_usage);
+	clean_args_no_options(cmd, argc, argv);
 
 	if (check_argc_exact(argc - optind, 2))
 		usage(cmd_subvol_find_new_usage);
diff --git a/help.c b/help.c
index 2c0d8d71..23d6ea8f 100644
--- a/help.c
+++ b/help.c
@@ -86,7 +86,7 @@ int check_argc_max(int nargs, int expected)
  * Unknown short and long options are reported, optionally the @usage is printed
  * before exit.
  */
-void clean_args_no_options(int argc, char *argv[], const char * const *usagestr)
+void clean_args_no_options(const struct cmd_struct *cmd, int argc, char *argv[])
 {
 	static const struct option long_options[] = {
 		{NULL, 0, NULL, 0}
@@ -100,8 +100,8 @@ void clean_args_no_options(int argc, char *argv[], const char * const *usagestr)
 
 		switch (c) {
 		default:
-			if (usagestr)
-				usage(usagestr);
+			if (cmd->usagestr)
+				usage(cmd->usagestr);
 		}
 	}
 }
@@ -115,7 +115,8 @@ void clean_args_no_options(int argc, char *argv[], const char * const *usagestr)
  * - "-- option1 option2 ..."
  * - "option1 option2 ..."
  */
-void clean_args_no_options_relaxed(int argc, char *argv[])
+void clean_args_no_options_relaxed(const struct cmd_struct *cmd,
+				   int argc, char *argv[])
 {
 	if (argc <= 1)
 		return;
diff --git a/help.h b/help.h
index 322b910a..e642f58d 100644
--- a/help.h
+++ b/help.h
@@ -71,8 +71,10 @@ void help_command_group(const struct cmd_group *grp, int argc, char **argv);
 int check_argc_exact(int nargs, int expected);
 int check_argc_min(int nargs, int expected);
 int check_argc_max(int nargs, int expected);
-void clean_args_no_options(int argc, char *argv[], const char * const *usage);
-void clean_args_no_options_relaxed(int argc, char *argv[]);
+void clean_args_no_options(const struct cmd_struct *cmd,
+			   int argc, char *argv[]);
+void clean_args_no_options_relaxed(const struct cmd_struct *cmd,
+				   int argc, char *argv[]);
 
 void fixup_argv0(char **argv, const char *token);
 void set_argv0(char **argv);
-- 
2.15.1

