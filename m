Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60586 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935183AbeCHClG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 21:41:06 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C68FCAF79
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 02:41:03 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 14/20] btrfs-progs: pass cmd_struct to command callback function
Date: Wed,  7 Mar 2018 21:40:41 -0500
Message-Id: <20180308024047.10104-15-jeffm@suse.com>
In-Reply-To: <20180308024047.10104-1-jeffm@suse.com>
References: <20180308024047.10104-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

This patch passes the cmd_struct to the command callback function.  This
has several purposes: It allows the command callback to identify which
command was used to call it.  It also gives us direct access to the
usage associated with that command.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 btrfs.c                   |  8 ++++----
 check/main.c              |  2 +-
 cmds-balance.c            | 19 ++++++++++++-------
 cmds-device.c             | 35 +++++++++++++++++++----------------
 cmds-fi-du.c              |  3 ++-
 cmds-fi-usage.c           |  3 ++-
 cmds-filesystem.c         | 24 ++++++++++++++++--------
 cmds-inspect-dump-super.c |  3 ++-
 cmds-inspect-dump-tree.c  |  3 ++-
 cmds-inspect-tree-stats.c |  3 ++-
 cmds-inspect.c            | 17 +++++++++++------
 cmds-property.c           | 12 ++++++++----
 cmds-qgroup.c             | 18 +++++++++++-------
 cmds-quota.c              |  9 +++++----
 cmds-receive.c            |  2 +-
 cmds-replace.c            | 11 +++++++----
 cmds-rescue.c             | 14 +++++++++-----
 cmds-restore.c            |  2 +-
 cmds-scrub.c              | 23 +++++++++++------------
 cmds-send.c               |  2 +-
 cmds-subvolume.c          | 27 +++++++++++++++++----------
 commands.h                |  4 ++--
 22 files changed, 146 insertions(+), 98 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 1e68b0c0..49128182 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -148,7 +148,7 @@ static const char * const cmd_help_usage[] = {
 	NULL
 };
 
-static int cmd_help(int argc, char **argv)
+static int cmd_help(const struct cmd_struct *unused, int argc, char **argv)
 {
 	help_command_group(&btrfs_cmd_group, argc, argv);
 	return 0;
@@ -162,7 +162,7 @@ static const char * const cmd_version_usage[] = {
 	NULL
 };
 
-static int cmd_version(int argc, char **argv)
+static int cmd_version(const struct cmd_struct *unused, int argc, char **argv)
 {
 	printf("%s\n", PACKAGE_STRING);
 	return 0;
@@ -231,13 +231,13 @@ void handle_special_globals(int shift, int argc, char **argv)
 		if (has_full)
 			usage_command_group(&btrfs_cmd_group, true, false);
 		else
-			cmd_help(argc, argv);
+			cmd_execute(&cmd_struct_help, argc, argv);
 		exit(0);
 	}
 
 	for (i = 0; i < shift; i++)
 		if (strcmp(argv[i], "--version") == 0) {
-			cmd_version(argc, argv);
+			cmd_execute(&cmd_struct_version, argc, argv);
 			exit(0);
 		}
 }
diff --git a/check/main.c b/check/main.c
index 4b8f7678..bd31fb9f 100644
--- a/check/main.c
+++ b/check/main.c
@@ -9440,7 +9440,7 @@ static const char * const cmd_check_usage[] = {
 	NULL
 };
 
-static int cmd_check(int argc, char **argv)
+static int cmd_check(const struct cmd_struct *cmd, int argc, char **argv)
 {
 	struct cache_tree root_cache;
 	struct btrfs_root *root;
diff --git a/cmds-balance.c b/cmds-balance.c
index 7a60be61..1bd7b3ce 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -515,7 +515,8 @@ static const char * const cmd_balance_start_usage[] = {
 	NULL
 };
 
-static int cmd_balance_start(int argc, char **argv)
+static int cmd_balance_start(const struct cmd_struct *cmd,
+			     int argc, char **argv)
 {
 	struct btrfs_ioctl_balance_args args;
 	struct btrfs_balance_args *ptrs[] = { &args.data, &args.sys,
@@ -680,7 +681,8 @@ static const char * const cmd_balance_pause_usage[] = {
 	NULL
 };
 
-static int cmd_balance_pause(int argc, char **argv)
+static int cmd_balance_pause(const struct cmd_struct *cmd,
+			     int argc, char **argv)
 {
 	const char *path;
 	int fd;
@@ -719,7 +721,8 @@ static const char * const cmd_balance_cancel_usage[] = {
 	NULL
 };
 
-static int cmd_balance_cancel(int argc, char **argv)
+static int cmd_balance_cancel(const struct cmd_struct *cmd,
+			      int argc, char **argv)
 {
 	const char *path;
 	int fd;
@@ -758,7 +761,8 @@ static const char * const cmd_balance_resume_usage[] = {
 	NULL
 };
 
-static int cmd_balance_resume(int argc, char **argv)
+static int cmd_balance_resume(const struct cmd_struct *cmd,
+			      int argc, char **argv)
 {
 	struct btrfs_ioctl_balance_args args;
 	const char *path;
@@ -826,7 +830,8 @@ static const char * const cmd_balance_status_usage[] = {
  *   1 : Successful to know status of a pending balance
  *   0 : When there is no pending balance or completed
  */
-static int cmd_balance_status(int argc, char **argv)
+static int cmd_balance_status(const struct cmd_struct *cmd,
+			      int argc, char **argv)
 {
 	struct btrfs_ioctl_balance_args args;
 	const char *path;
@@ -904,7 +909,7 @@ out:
 }
 static DEFINE_SIMPLE_COMMAND(balance_status, "status");
 
-static int cmd_balance_full(int argc, char **argv)
+static int cmd_balance_full(const struct cmd_struct *cmd, int argc, char **argv)
 {
 	struct btrfs_ioctl_balance_args args;
 
@@ -931,7 +936,7 @@ static const struct cmd_group balance_cmd_group = {
 	}
 };
 
-static int cmd_balance(int argc, char **argv)
+static int cmd_balance(const struct cmd_struct *unused, int argc, char **argv)
 {
 	if (argc == 2 && strcmp("start", argv[1]) != 0) {
 		/* old 'btrfs filesystem balance <path>' syntax */
diff --git a/cmds-device.c b/cmds-device.c
index 96764d6c..feb53f68 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -48,7 +48,8 @@ static const char * const cmd_device_add_usage[] = {
 	NULL
 };
 
-static int cmd_device_add(int argc, char **argv)
+static int cmd_device_add(const struct cmd_struct *cmd,
+			  int argc, char **argv)
 {
 	char	*mntpnt;
 	int i, fdmnt, ret = 0;
@@ -142,17 +143,17 @@ error_out:
 }
 static DEFINE_SIMPLE_COMMAND(device_add, "add");
 
-static int _cmd_device_remove(int argc, char **argv,
-		const char * const *usagestr)
+static int _cmd_device_remove(const struct cmd_struct *cmd,
+			      int argc, char **argv)
 {
 	char	*mntpnt;
 	int i, fdmnt, ret = 0;
 	DIR	*dirstream = NULL;
 
-	clean_args_no_options(argc, argv, usagestr);
+	clean_args_no_options(argc, argv, cmd->usagestr);
 
 	if (check_argc_min(argc - optind, 2))
-		usage(usagestr);
+		usage(cmd->usagestr);
 
 	mntpnt = argv[argc - 1];
 
@@ -236,9 +237,10 @@ static const char * const cmd_device_remove_usage[] = {
 	NULL
 };
 
-static int cmd_device_remove(int argc, char **argv)
+static int cmd_device_remove(const struct cmd_struct *cmd,
+			     int argc, char **argv)
 {
-	return _cmd_device_remove(argc, argv, cmd_device_remove_usage);
+	return _cmd_device_remove(cmd, argc, argv);
 }
 static DEFINE_SIMPLE_COMMAND(device_remove, "remove");
 
@@ -250,9 +252,10 @@ static const char * const cmd_device_delete_usage[] = {
 	NULL
 };
 
-static int cmd_device_delete(int argc, char **argv)
+static int cmd_device_delete(const struct cmd_struct *cmd,
+			     int argc, char **argv)
 {
-	return _cmd_device_remove(argc, argv, cmd_device_delete_usage);
+	return _cmd_device_remove(cmd, argc, argv);
 }
 static DEFINE_COMMAND(device_delete, "delete", cmd_device_delete,
 		      cmd_device_delete_usage, NULL, CMD_ALIAS);
@@ -264,7 +267,7 @@ static const char * const cmd_device_scan_usage[] = {
 	NULL
 };
 
-static int cmd_device_scan(int argc, char **argv)
+static int cmd_device_scan(const struct cmd_struct *cmd, int argc, char **argv)
 {
 	int i;
 	int devstart;
@@ -337,14 +340,14 @@ static const char * const cmd_device_ready_usage[] = {
 	NULL
 };
 
-static int cmd_device_ready(int argc, char **argv)
+static int cmd_device_ready(const struct cmd_struct *cmd, int argc, char **argv)
 {
 	struct	btrfs_ioctl_vol_args args;
 	int	fd;
 	int	ret;
 	char	*path;
 
-	clean_args_no_options(argc, argv, cmd_device_ready_usage);
+	clean_args_no_options(argc, argv, cmd->usagestr);
 
 	if (check_argc_exact(argc - optind, 1))
 		usage(cmd_device_ready_usage);
@@ -396,7 +399,7 @@ static const char * const cmd_device_stats_usage[] = {
 	NULL
 };
 
-static int cmd_device_stats(int argc, char **argv)
+static int cmd_device_stats(const struct cmd_struct *cmd, int argc, char **argv)
 {
 	char *dev_path;
 	struct btrfs_ioctl_fs_info_args fi_args;
@@ -562,7 +565,7 @@ out:
 	return ret;
 }
 
-static int cmd_device_usage(int argc, char **argv)
+static int cmd_device_usage(const struct cmd_struct *cmd, int argc, char **argv)
 {
 	unsigned unit_mode;
 	int ret = 0;
@@ -570,7 +573,7 @@ static int cmd_device_usage(int argc, char **argv)
 
 	unit_mode = get_unit_mode_from_arg(&argc, argv, 1);
 
-	clean_args_no_options(argc, argv, cmd_device_usage_usage);
+	clean_args_no_options(argc, argv, cmd->usagestr);
 
 	if (check_argc_min(argc - optind, 1))
 		usage(cmd_device_usage_usage);
@@ -615,7 +618,7 @@ static const struct cmd_group device_cmd_group = {
 	}
 };
 
-static int cmd_device(int argc, char **argv)
+static int cmd_device(const struct cmd_struct *unused, int argc, char **argv)
 {
 	return handle_command_group(&device_cmd_group, argc, argv);
 }
diff --git a/cmds-fi-du.c b/cmds-fi-du.c
index cb2f09c7..a86f4ad6 100644
--- a/cmds-fi-du.c
+++ b/cmds-fi-du.c
@@ -557,7 +557,8 @@ static const char * const cmd_filesystem_du_usage[] = {
 	NULL
 };
 
-static int cmd_filesystem_du(int argc, char **argv)
+static int cmd_filesystem_du(const struct cmd_struct *cmd,
+			     int argc, char **argv)
 {
 	int ret = 0, err = 0;
 	int i;
diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
index af882400..36684762 100644
--- a/cmds-fi-usage.c
+++ b/cmds-fi-usage.c
@@ -965,7 +965,8 @@ static const char * const cmd_filesystem_usage_usage[] = {
 	NULL
 };
 
-static int cmd_filesystem_usage(int argc, char **argv)
+static int cmd_filesystem_usage(const struct cmd_struct *cmd,
+				int argc, char **argv)
 {
 	int ret = 0;
 	unsigned unit_mode;
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index ec038f2f..c2ee8595 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -115,7 +115,8 @@ static void print_df(struct btrfs_ioctl_space_args *sargs, unsigned unit_mode)
 	}
 }
 
-static int cmd_filesystem_df(int argc, char **argv)
+static int cmd_filesystem_df(const struct cmd_struct *cmd,
+			     int argc, char **argv)
 {
 	struct btrfs_ioctl_space_args *sargs = NULL;
 	int ret;
@@ -666,7 +667,8 @@ static const char * const cmd_filesystem_show_usage[] = {
 	NULL
 };
 
-static int cmd_filesystem_show(int argc, char **argv)
+static int cmd_filesystem_show(const struct cmd_struct *cmd,
+			       int argc, char **argv)
 {
 	LIST_HEAD(all_uuids);
 	struct btrfs_fs_devices *fs_devices;
@@ -813,7 +815,8 @@ static const char * const cmd_filesystem_sync_usage[] = {
 	NULL
 };
 
-static int cmd_filesystem_sync(int argc, char **argv)
+static int cmd_filesystem_sync(const struct cmd_struct *cmd,
+			       int argc, char **argv)
 {
 	int 	fd, res;
 	char	*path;
@@ -910,7 +913,8 @@ error:
 	return 0;
 }
 
-static int cmd_filesystem_defrag(int argc, char **argv)
+static int cmd_filesystem_defrag(const struct cmd_struct *cmd,
+				 int argc, char **argv)
 {
 	int fd;
 	int flush = 0;
@@ -1089,7 +1093,8 @@ static const char * const cmd_filesystem_resize_usage[] = {
 	NULL
 };
 
-static int cmd_filesystem_resize(int argc, char **argv)
+static int cmd_filesystem_resize(const struct cmd_struct *cmd,
+				 int argc, char **argv)
 {
 	struct btrfs_ioctl_vol_args	args;
 	int	fd, res, len, e;
@@ -1167,7 +1172,8 @@ static const char * const cmd_filesystem_label_usage[] = {
 	NULL
 };
 
-static int cmd_filesystem_label(int argc, char **argv)
+static int cmd_filesystem_label(const struct cmd_struct *cmd,
+				int argc, char **argv)
 {
 	clean_args_no_options(argc, argv, cmd_filesystem_label_usage);
 
@@ -1196,7 +1202,8 @@ static const char * const cmd_filesystem_balance_usage[] = {
 	NULL
 };
 
-static int cmd_filesystem_balance(int argc, char **argv)
+static int cmd_filesystem_balance(const struct cmd_struct *unused,
+				  int argc, char **argv)
 {
 	return cmd_execute(&cmd_struct_balance, argc, argv);
 }
@@ -1228,7 +1235,8 @@ static const struct cmd_group filesystem_cmd_group = {
 	}
 };
 
-static int cmd_filesystem(int argc, char **argv)
+static int cmd_filesystem(const struct cmd_struct *unused,
+			  int argc, char **argv)
 {
 	return handle_command_group(&filesystem_cmd_group, argc, argv);
 }
diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index 34542d71..ca503a2e 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -504,7 +504,8 @@ static const char * const cmd_inspect_dump_super_usage[] = {
 	NULL
 };
 
-static int cmd_inspect_dump_super(int argc, char **argv)
+static int cmd_inspect_dump_super(const struct cmd_struct *cmd,
+				  int argc, char **argv)
 {
 	int all = 0;
 	int full = 0;
diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
index 6417eab3..5cc39a88 100644
--- a/cmds-inspect-dump-tree.c
+++ b/cmds-inspect-dump-tree.c
@@ -201,7 +201,8 @@ static const char * const cmd_inspect_dump_tree_usage[] = {
 	NULL
 };
 
-static int cmd_inspect_dump_tree(int argc, char **argv)
+static int cmd_inspect_dump_tree(const struct cmd_struct *cmd,
+				 int argc, char **argv)
 {
 	struct btrfs_root *root;
 	struct btrfs_fs_info *info;
diff --git a/cmds-inspect-tree-stats.c b/cmds-inspect-tree-stats.c
index 14d79ccc..64ca3d0b 100644
--- a/cmds-inspect-tree-stats.c
+++ b/cmds-inspect-tree-stats.c
@@ -427,7 +427,8 @@ static const char * const cmd_inspect_tree_stats_usage[] = {
 	NULL
 };
 
-static int cmd_inspect_tree_stats(int argc, char **argv)
+static int cmd_inspect_tree_stats(const struct cmd_struct *cmd,
+				  int argc, char **argv)
 {
 	struct btrfs_key key;
 	struct btrfs_root *root;
diff --git a/cmds-inspect.c b/cmds-inspect.c
index 12f200b3..1bdc8bd9 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -87,7 +87,8 @@ static const char * const cmd_inspect_inode_resolve_usage[] = {
 	NULL
 };
 
-static int cmd_inspect_inode_resolve(int argc, char **argv)
+static int cmd_inspect_inode_resolve(const struct cmd_struct *cmd,
+				     int argc, char **argv)
 {
 	int fd;
 	int verbose = 0;
@@ -134,7 +135,8 @@ static const char * const cmd_inspect_logical_resolve_usage[] = {
 	NULL
 };
 
-static int cmd_inspect_logical_resolve(int argc, char **argv)
+static int cmd_inspect_logical_resolve(const struct cmd_struct *cmd,
+				       int argc, char **argv)
 {
 	int ret;
 	int fd;
@@ -266,7 +268,8 @@ static const char * const cmd_inspect_subvolid_resolve_usage[] = {
 	NULL
 };
 
-static int cmd_inspect_subvolid_resolve(int argc, char **argv)
+static int cmd_inspect_subvolid_resolve(const struct cmd_struct *cmd,
+					int argc, char **argv)
 {
 	int ret;
 	int fd = -1;
@@ -309,7 +312,8 @@ static const char* const cmd_inspect_rootid_usage[] = {
 	NULL
 };
 
-static int cmd_inspect_rootid(int argc, char **argv)
+static int cmd_inspect_rootid(const struct cmd_struct *cmd,
+			      int argc, char **argv)
 {
 	int ret;
 	int fd = -1;
@@ -588,7 +592,8 @@ out:
 	return ret;
 }
 
-static int cmd_inspect_min_dev_size(int argc, char **argv)
+static int cmd_inspect_min_dev_size(const struct cmd_struct *cmd,
+				    int argc, char **argv)
 {
 	int ret;
 	int fd = -1;
@@ -648,7 +653,7 @@ static const struct cmd_group inspect_cmd_group = {
 	}
 };
 
-static int cmd_inspect(int argc, char **argv)
+static int cmd_inspect(const struct cmd_struct *unused, int argc, char **argv)
 {
 	return handle_command_group(&inspect_cmd_group, argc, argv);
 }
diff --git a/cmds-property.c b/cmds-property.c
index dce1f2a9..5684443c 100644
--- a/cmds-property.c
+++ b/cmds-property.c
@@ -341,7 +341,8 @@ static const char * const cmd_property_get_usage[] = {
 	NULL
 };
 
-static int cmd_property_get(int argc, char **argv)
+static int cmd_property_get(const struct cmd_struct *cmd,
+			    int argc, char **argv)
 {
 	int ret;
 	char *object = NULL;
@@ -368,7 +369,8 @@ static const char * const cmd_property_set_usage[] = {
 	NULL
 };
 
-static int cmd_property_set(int argc, char **argv)
+static int cmd_property_set(const struct cmd_struct *cmd,
+			    int argc, char **argv)
 {
 	int ret;
 	char *object = NULL;
@@ -393,7 +395,8 @@ static const char * const cmd_property_list_usage[] = {
 	NULL
 };
 
-static int cmd_property_list(int argc, char **argv)
+static int cmd_property_list(const struct cmd_struct *cmd,
+			     int argc, char **argv)
 {
 	int ret;
 	char *object = NULL;
@@ -420,7 +423,8 @@ static const struct cmd_group property_cmd_group = {
 	}
 };
 
-static int cmd_property(int argc, char **argv)
+static int cmd_property(const struct cmd_struct *unused,
+			int argc, char **argv)
 {
 	return handle_command_group(&property_cmd_group, argc, argv);
 }
diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 6945d160..2972baee 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -215,7 +215,8 @@ static const char * const cmd_qgroup_assign_usage[] = {
 	NULL
 };
 
-static int cmd_qgroup_assign(int argc, char **argv)
+static int cmd_qgroup_assign(const struct cmd_struct *cmd,
+			     int argc, char **argv)
 {
 	return _cmd_qgroup_assign(1, argc, argv, cmd_qgroup_assign_usage);
 }
@@ -227,7 +228,8 @@ static const char * const cmd_qgroup_remove_usage[] = {
 	NULL
 };
 
-static int cmd_qgroup_remove(int argc, char **argv)
+static int cmd_qgroup_remove(const struct cmd_struct *cmd,
+			     int argc, char **argv)
 {
 	return _cmd_qgroup_assign(0, argc, argv, cmd_qgroup_remove_usage);
 }
@@ -239,7 +241,8 @@ static const char * const cmd_qgroup_create_usage[] = {
 	NULL
 };
 
-static int cmd_qgroup_create(int argc, char **argv)
+static int cmd_qgroup_create(const struct cmd_struct *cmd,
+			     int argc, char **argv)
 {
 	int ret;
 
@@ -259,7 +262,8 @@ static const char * const cmd_qgroup_destroy_usage[] = {
 	NULL
 };
 
-static int cmd_qgroup_destroy(int argc, char **argv)
+static int cmd_qgroup_destroy(const struct cmd_struct *cmd,
+			      int argc, char **argv)
 {
 	int ret;
 
@@ -296,7 +300,7 @@ static const char * const cmd_qgroup_show_usage[] = {
 	NULL
 };
 
-static int cmd_qgroup_show(int argc, char **argv)
+static int cmd_qgroup_show(const struct cmd_struct *cmd, int argc, char **argv)
 {
 	char *path;
 	int ret = 0;
@@ -430,7 +434,7 @@ static const char * const cmd_qgroup_limit_usage[] = {
 	NULL
 };
 
-static int cmd_qgroup_limit(int argc, char **argv)
+static int cmd_qgroup_limit(const struct cmd_struct *cmd, int argc, char **argv)
 {
 	int ret = 0;
 	int fd;
@@ -528,7 +532,7 @@ static const struct cmd_group qgroup_cmd_group = {
 	}
 };
 
-static int cmd_qgroup(int argc, char **argv)
+static int cmd_qgroup(const struct cmd_struct *unused, int argc, char **argv)
 {
 	return handle_command_group(&qgroup_cmd_group, argc, argv);
 }
diff --git a/cmds-quota.c b/cmds-quota.c
index 5cd5607f..a6e7a6f6 100644
--- a/cmds-quota.c
+++ b/cmds-quota.c
@@ -67,7 +67,7 @@ static const char * const cmd_quota_enable_usage[] = {
 	NULL
 };
 
-static int cmd_quota_enable(int argc, char **argv)
+static int cmd_quota_enable(const struct cmd_struct *cmd, int argc, char **argv)
 {
 	int ret;
 
@@ -87,7 +87,8 @@ static const char * const cmd_quota_disable_usage[] = {
 	NULL
 };
 
-static int cmd_quota_disable(int argc, char **argv)
+static int cmd_quota_disable(const struct cmd_struct *cmd,
+			     int argc, char **argv)
 {
 	int ret;
 
@@ -110,7 +111,7 @@ static const char * const cmd_quota_rescan_usage[] = {
 	NULL
 };
 
-static int cmd_quota_rescan(int argc, char **argv)
+static int cmd_quota_rescan(const struct cmd_struct *cmd, int argc, char **argv)
 {
 	int ret = 0;
 	int fd;
@@ -213,7 +214,7 @@ static const struct cmd_group quota_cmd_group = {
 	}
 };
 
-static int cmd_quota(int argc, char **argv)
+static int cmd_quota(const struct cmd_struct *unused, int argc, char **argv)
 {
 	return handle_command_group(&quota_cmd_group, argc, argv);
 }
diff --git a/cmds-receive.c b/cmds-receive.c
index d88b8793..93c1838d 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -1279,7 +1279,7 @@ static const char * const cmd_receive_usage[] = {
 	NULL
 };
 
-static int cmd_receive(int argc, char **argv)
+static int cmd_receive(const struct cmd_struct *cmd, int argc, char **argv)
 {
 	char *tomnt = NULL;
 	char fromfile[PATH_MAX];
diff --git a/cmds-replace.c b/cmds-replace.c
index a7379c71..f1e76bdf 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -114,7 +114,8 @@ static const char *const cmd_replace_start_usage[] = {
 	NULL
 };
 
-static int cmd_replace_start(int argc, char **argv)
+static int cmd_replace_start(const struct cmd_struct *cmd,
+			     int argc, char **argv)
 {
 	struct btrfs_ioctl_dev_replace_args start_args = {0};
 	struct btrfs_ioctl_dev_replace_args status_args = {0};
@@ -325,7 +326,8 @@ static const char *const cmd_replace_status_usage[] = {
 	NULL
 };
 
-static int cmd_replace_status(int argc, char **argv)
+static int cmd_replace_status(const struct cmd_struct *cmd,
+			      int argc, char **argv)
 {
 	int fd;
 	int c;
@@ -494,7 +496,8 @@ static const char *const cmd_replace_cancel_usage[] = {
 	NULL
 };
 
-static int cmd_replace_cancel(int argc, char **argv)
+static int cmd_replace_cancel(const struct cmd_struct *cmd,
+			      int argc, char **argv)
 {
 	struct btrfs_ioctl_dev_replace_args args = {0};
 	int ret;
@@ -554,7 +557,7 @@ static const struct cmd_group replace_cmd_group = {
 	}
 };
 
-static int cmd_replace(int argc, char **argv)
+static int cmd_replace(const struct cmd_struct *unused, int argc, char **argv)
 {
 	return handle_command_group(&replace_cmd_group, argc, argv);
 }
diff --git a/cmds-rescue.c b/cmds-rescue.c
index e3611f2f..f5a618e1 100644
--- a/cmds-rescue.c
+++ b/cmds-rescue.c
@@ -45,7 +45,8 @@ static const char * const cmd_rescue_chunk_recover_usage[] = {
 	NULL
 };
 
-static int cmd_rescue_chunk_recover(int argc, char *argv[])
+static int cmd_rescue_chunk_recover(const struct cmd_struct *cmd,
+				    int argc, char *argv[])
 {
 	int ret = 0;
 	char *file;
@@ -113,7 +114,8 @@ static const char * const cmd_rescue_super_recover_usage[] = {
  *   3 : Fail to Recover bad supeblocks
  *   4 : Abort to recover bad superblocks
  */
-static int cmd_rescue_super_recover(int argc, char **argv)
+static int cmd_rescue_super_recover(const struct cmd_struct *cmd,
+				    int argc, char **argv)
 {
 	int ret;
 	int verbose = 0;
@@ -159,7 +161,8 @@ static const char * const cmd_rescue_zero_log_usage[] = {
 	NULL
 };
 
-static int cmd_rescue_zero_log(int argc, char **argv)
+static int cmd_rescue_zero_log(const struct cmd_struct *cmd,
+			       int argc, char **argv)
 {
 	struct btrfs_root *root;
 	struct btrfs_trans_handle *trans;
@@ -213,7 +216,8 @@ static const char * const cmd_rescue_fix_device_size_usage[] = {
 	NULL
 };
 
-static int cmd_rescue_fix_device_size(int argc, char **argv)
+static int cmd_rescue_fix_device_size(const struct cmd_struct *cmd,
+				      int argc, char **argv)
 {
 	struct btrfs_fs_info *fs_info;
 	char *devname;
@@ -265,7 +269,7 @@ static const struct cmd_group rescue_cmd_group = {
 	}
 };
 
-static int cmd_rescue(int argc, char **argv)
+static int cmd_rescue(const struct cmd_struct *unused, int argc, char **argv)
 {
 	return handle_command_group(&rescue_cmd_group, argc, argv);
 }
diff --git a/cmds-restore.c b/cmds-restore.c
index 05fd1c80..e850ec97 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -1415,7 +1415,7 @@ static const char * const cmd_restore_usage[] = {
 	NULL
 };
 
-static int cmd_restore(int argc, char **argv)
+static int cmd_restore(const struct cmd_struct *unused, int argc, char **argv)
 {
 	struct btrfs_root *root;
 	struct btrfs_key key;
diff --git a/cmds-scrub.c b/cmds-scrub.c
index b0f447c7..a762f035 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -1097,7 +1097,8 @@ static int is_scrub_running_in_kernel(int fd,
 static const char * const cmd_scrub_start_usage[];
 static const char * const cmd_scrub_resume_usage[];
 
-static int scrub_start(int argc, char **argv, int resume)
+static int scrub_start(const struct cmd_struct *cmd, int argc, char **argv,
+		       bool resume)
 {
 	int fdmnt;
 	int prg_fd = -1;
@@ -1176,16 +1177,14 @@ static int scrub_start(int argc, char **argv, int resume)
 			break;
 		case '?':
 		default:
-			usage(resume ? cmd_scrub_resume_usage :
-						cmd_scrub_start_usage);
+			usage(cmd->usagestr);
 		}
 	}
 
 	/* try to catch most error cases before forking */
 
 	if (check_argc_exact(argc - optind, 1)) {
-		usage(resume ? cmd_scrub_resume_usage :
-					cmd_scrub_start_usage);
+		usage(cmd->usagestr);
 	}
 
 	spc.progress = NULL;
@@ -1576,9 +1575,9 @@ static const char * const cmd_scrub_start_usage[] = {
 	NULL
 };
 
-static int cmd_scrub_start(int argc, char **argv)
+static int cmd_scrub_start(const struct cmd_struct *cmd, int argc, char **argv)
 {
-	return scrub_start(argc, argv, 0);
+	return scrub_start(cmd, argc, argv, false);
 }
 static DEFINE_SIMPLE_COMMAND(scrub_start, "start");
 
@@ -1588,7 +1587,7 @@ static const char * const cmd_scrub_cancel_usage[] = {
 	NULL
 };
 
-static int cmd_scrub_cancel(int argc, char **argv)
+static int cmd_scrub_cancel(const struct cmd_struct *cmd, int argc, char **argv)
 {
 	char *path;
 	int ret;
@@ -1643,9 +1642,9 @@ static const char * const cmd_scrub_resume_usage[] = {
 	NULL
 };
 
-static int cmd_scrub_resume(int argc, char **argv)
+static int cmd_scrub_resume(const struct cmd_struct *cmd, int argc, char **argv)
 {
-	return scrub_start(argc, argv, 1);
+	return scrub_start(cmd, argc, argv, true);
 }
 static DEFINE_SIMPLE_COMMAND(scrub_resume, "resume");
 
@@ -1658,7 +1657,7 @@ static const char * const cmd_scrub_status_usage[] = {
 	NULL
 };
 
-static int cmd_scrub_status(int argc, char **argv)
+static int cmd_scrub_status(const struct cmd_struct *cmd, int argc, char **argv)
 {
 	char *path;
 	struct btrfs_ioctl_fs_info_args fi_args;
@@ -1804,7 +1803,7 @@ static const struct cmd_group scrub_cmd_group = {
 	}
 };
 
-static int cmd_scrub(int argc, char **argv)
+static int cmd_scrub(const struct cmd_struct *unused, int argc, char **argv)
 {
 	return handle_command_group(&scrub_cmd_group, argc, argv);
 }
diff --git a/cmds-send.c b/cmds-send.c
index f1e5124d..bd501576 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -523,7 +523,7 @@ static const char * const cmd_send_usage[] = {
 	NULL
 };
 
-static int cmd_send(int argc, char **argv)
+static int cmd_send(const struct cmd_struct *cmd, int argc, char **argv)
 {
 	char *subvol = NULL;
 	int ret;
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 6fc4b2e7..13303db8 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -116,7 +116,8 @@ static const char * const cmd_subvol_create_usage[] = {
 	NULL
 };
 
-static int cmd_subvol_create(int argc, char **argv)
+static int cmd_subvol_create(const struct cmd_struct *cmd,
+			     int argc, char **argv)
 {
 	int	retval, res, len;
 	int	fddst = -1;
@@ -251,7 +252,8 @@ static const char * const cmd_subvol_delete_usage[] = {
 	NULL
 };
 
-static int cmd_subvol_delete(int argc, char **argv)
+static int cmd_subvol_delete(const struct cmd_struct *cmd,
+			     int argc, char **argv)
 {
 	int res, ret = 0;
 	int cnt;
@@ -477,7 +479,7 @@ static const char * const cmd_subvol_list_usage[] = {
 	NULL,
 };
 
-static int cmd_subvol_list(int argc, char **argv)
+static int cmd_subvol_list(const struct cmd_struct *cmd, int argc, char **argv)
 {
 	struct btrfs_list_filter_set *filter_set;
 	struct btrfs_list_comparer_set *comparer_set;
@@ -649,7 +651,8 @@ static const char * const cmd_subvol_snapshot_usage[] = {
 	NULL
 };
 
-static int cmd_subvol_snapshot(int argc, char **argv)
+static int cmd_subvol_snapshot(const struct cmd_struct *cmd,
+			       int argc, char **argv)
 {
 	char	*subvol, *dst;
 	int	res, retval;
@@ -799,7 +802,8 @@ static const char * const cmd_subvol_get_default_usage[] = {
 	NULL
 };
 
-static int cmd_subvol_get_default(int argc, char **argv)
+static int cmd_subvol_get_default(const struct cmd_struct *cmd,
+				  int argc, char **argv)
 {
 	int fd = -1;
 	int ret;
@@ -867,7 +871,8 @@ static const char * const cmd_subvol_set_default_usage[] = {
 	NULL
 };
 
-static int cmd_subvol_set_default(int argc, char **argv)
+static int cmd_subvol_set_default(const struct cmd_struct *cmd,
+				  int argc, char **argv)
 {
 	int	ret=0, fd;
 	u64	objectid;
@@ -931,7 +936,8 @@ static const char * const cmd_subvol_find_new_usage[] = {
 	NULL
 };
 
-static int cmd_subvol_find_new(int argc, char **argv)
+static int cmd_subvol_find_new(const struct cmd_struct *cmd,
+			       int argc, char **argv)
 {
 	int fd;
 	int ret;
@@ -986,7 +992,7 @@ static const char * const cmd_subvol_show_usage[] = {
 	NULL
 };
 
-static int cmd_subvol_show(int argc, char **argv)
+static int cmd_subvol_show(const struct cmd_struct *cmd, int argc, char **argv)
 {
 	struct root_info get_ri;
 	struct btrfs_list_filter_set *filter_set = NULL;
@@ -1337,7 +1343,7 @@ static int enumerate_dead_subvols(int fd, u64 **ids)
 	return idx;
 }
 
-static int cmd_subvol_sync(int argc, char **argv)
+static int cmd_subvol_sync(const struct cmd_struct *cmd, int argc, char **argv)
 {
 	int fd = -1;
 	int i;
@@ -1448,7 +1454,8 @@ static const struct cmd_group subvolume_cmd_group = {
 	}
 };
 
-static int cmd_subvolume(int argc, char **argv)
+static int cmd_subvolume(const struct cmd_struct *unused,
+			 int argc, char **argv)
 {
 	return handle_command_group(&subvolume_cmd_group, argc, argv);
 }
diff --git a/commands.h b/commands.h
index 9a65204b..4c5469ac 100644
--- a/commands.h
+++ b/commands.h
@@ -24,7 +24,7 @@ enum {
 
 struct cmd_struct {
 	const char *token;
-	int (*fn)(int, char **);
+	int (*fn)(const struct cmd_struct *cmd, int argc, char **argv);
 
 	/*
 	 * Usage strings
@@ -110,7 +110,7 @@ struct cmd_group {
 static inline int cmd_execute(const struct cmd_struct *cmd,
 			      int argc, char **argv)
 {
-	return cmd->fn(argc, argv);
+	return cmd->fn(cmd, argc, argv);
 }
 
 int handle_command_group(const struct cmd_group *grp, int argc,
-- 
2.12.3

