Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60619 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935190AbeCHClG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 21:41:06 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DFB3FAF7E
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 02:41:03 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 13/20] btrfs-progs: use cmd_struct as command entry point
Date: Wed,  7 Mar 2018 21:40:40 -0500
Message-Id: <20180308024047.10104-14-jeffm@suse.com>
In-Reply-To: <20180308024047.10104-1-jeffm@suse.com>
References: <20180308024047.10104-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

Rather than having global command usage and callbacks used to create
cmd_structs in the command array, establish the cmd_struct structures
separately and use those.  The next commit in the series passes the
cmd_struct to the command callbacks such that we can access flags
and determine which of several potential command we were called as.

This establishes several macros to more easily define the commands
within each command's source.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 btrfs-calc-size.c         |   5 +-
 btrfs-debug-tree.c        |   5 +-
 btrfs-show-super.c        |   6 +--
 btrfs.c                   |  48 ++++++++++--------
 check/main.c              |   5 +-
 cmds-balance.c            |  27 ++++++----
 cmds-device.c             |  31 ++++++-----
 cmds-fi-du.c              |   5 +-
 cmds-fi-usage.c           |   5 +-
 cmds-filesystem.c         |  52 ++++++++++---------
 cmds-inspect-dump-super.c |   5 +-
 cmds-inspect-dump-tree.c  |   5 +-
 cmds-inspect-tree-stats.c |   5 +-
 cmds-inspect.c            |  36 +++++++------
 cmds-property.c           |  19 +++----
 cmds-qgroup.c             |  31 +++++------
 cmds-quota.c              |  17 ++++---
 cmds-receive.c            |   5 +-
 cmds-replace.c            |  19 +++----
 cmds-rescue.c             |  22 ++++----
 cmds-restore.c            |   5 +-
 cmds-scrub.c              |  20 +++++---
 cmds-send.c               |   6 +--
 cmds-subvolume.c          |  38 ++++++++------
 commands.h                | 127 +++++++++++++++++++++++++++-------------------
 help.c                    |  21 +++++---
 26 files changed, 326 insertions(+), 244 deletions(-)

diff --git a/btrfs-calc-size.c b/btrfs-calc-size.c
index d2d68ab2..908e830f 100644
--- a/btrfs-calc-size.c
+++ b/btrfs-calc-size.c
@@ -23,15 +23,16 @@
 
 int main(int argc, char **argv)
 {
+	const struct cmd_struct *cmd = &cmd_struct_inspect_tree_stats;
 	int ret;
 
 	warning(
 "\nthe tool has been deprecated, please use 'btrfs inspect-internal tree-stats' instead\n");
 
 	if (argc > 1 && !strcmp(argv[1], "--help"))
-		usage(cmd_inspect_tree_stats_usage);
+		usage(cmd->usagestr);
 
-	ret = cmd_inspect_tree_stats(argc, argv);
+	ret = cmd_execute(cmd, argc, argv);
 
 	btrfs_close_all_devices();
 
diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
index 7bee018f..7f254519 100644
--- a/btrfs-debug-tree.c
+++ b/btrfs-debug-tree.c
@@ -24,16 +24,17 @@
 
 int main(int argc, char **argv)
 {
+	const struct cmd_struct *cmd = &cmd_struct_inspect_dump_tree;
 	int ret;
 
 	set_argv0(argv);
 
 	if (argc > 1 && !strcmp(argv[1], "--help"))
-		usage(cmd_inspect_dump_tree_usage);
+		usage(cmd->usagestr);
 
 	radix_tree_init();
 
-	ret = cmd_inspect_dump_tree(argc, argv);
+	ret = cmd_execute(cmd, argc, argv);
 
 	btrfs_close_all_devices();
 
diff --git a/btrfs-show-super.c b/btrfs-show-super.c
index 4273e42d..ee717c33 100644
--- a/btrfs-show-super.c
+++ b/btrfs-show-super.c
@@ -22,7 +22,7 @@
 
 int main(int argc, char **argv)
 {
-
+	const struct cmd_struct *cmd = &cmd_struct_inspect_dump_super;
 	int ret;
 
 	set_argv0(argv);
@@ -31,9 +31,9 @@ int main(int argc, char **argv)
 "\nthe tool has been deprecated, please use 'btrfs inspect-internal dump-super' instead\n");
 
 	if (argc > 1 && !strcmp(argv[1], "--help"))
-		usage(cmd_inspect_dump_super_usage);
+		usage(cmd->usagestr);
 
-	ret = cmd_inspect_dump_super(argc, argv);
+	ret = cmd_execute(cmd, argc, argv);
 
 	return ret;
 }
diff --git a/btrfs.c b/btrfs.c
index fec1a135..1e68b0c0 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -42,10 +42,11 @@ static inline const char *skip_prefix(const char *str, const char *prefix)
 static int parse_one_token(const char *arg, const struct cmd_group *grp,
 			   const struct cmd_struct **cmd_ret)
 {
-	const struct cmd_struct *cmd = grp->commands;
 	const struct cmd_struct *abbrev_cmd = NULL, *ambiguous_cmd = NULL;
+	int i = 0;
 
-	for (; cmd->token; cmd++) {
+	for (i = 0; grp->commands[i]; i++) {
+		const struct cmd_struct *cmd = grp->commands[i];
 		const char *rest;
 
 		rest = skip_prefix(arg, cmd->token);
@@ -134,7 +135,7 @@ int handle_command_group(const struct cmd_group *grp, int argc,
 	handle_help_options_next_level(cmd, argc, argv);
 
 	fixup_argv0(argv, cmd->token);
-	return cmd->fn(argc, argv);
+	return cmd_execute(cmd, argc, argv);
 }
 
 static const struct cmd_group btrfs_cmd_group;
@@ -153,6 +154,8 @@ static int cmd_help(int argc, char **argv)
 	return 0;
 }
 
+static DEFINE_SIMPLE_COMMAND(help, "help");
+
 static const char * const cmd_version_usage[] = {
 	"btrfs version",
 	"Display btrfs-progs version",
@@ -164,6 +167,7 @@ static int cmd_version(int argc, char **argv)
 	printf("%s\n", PACKAGE_STRING);
 	return 0;
 }
+static DEFINE_SIMPLE_COMMAND(version, "version");
 
 /*
  * Parse global options, between binary name and first non-option argument
@@ -240,24 +244,24 @@ void handle_special_globals(int shift, int argc, char **argv)
 
 static const struct cmd_group btrfs_cmd_group = {
 	btrfs_cmd_group_usage, btrfs_cmd_group_info, {
-		{ "subvolume", cmd_subvolume, NULL, &subvolume_cmd_group, 0 },
-		{ "filesystem", cmd_filesystem, NULL, &filesystem_cmd_group, 0 },
-		{ "balance", cmd_balance, NULL, &balance_cmd_group, 0 },
-		{ "device", cmd_device, NULL, &device_cmd_group, 0 },
-		{ "scrub", cmd_scrub, NULL, &scrub_cmd_group, 0 },
-		{ "check", cmd_check, cmd_check_usage, NULL, 0 },
-		{ "rescue", cmd_rescue, NULL, &rescue_cmd_group, 0 },
-		{ "restore", cmd_restore, cmd_restore_usage, NULL, 0 },
-		{ "inspect-internal", cmd_inspect, NULL, &inspect_cmd_group, 0 },
-		{ "property", cmd_property, NULL, &property_cmd_group, 0 },
-		{ "send", cmd_send, cmd_send_usage, NULL, 0 },
-		{ "receive", cmd_receive, cmd_receive_usage, NULL, 0 },
-		{ "quota", cmd_quota, NULL, &quota_cmd_group, 0 },
-		{ "qgroup", cmd_qgroup, NULL, &qgroup_cmd_group, 0 },
-		{ "replace", cmd_replace, NULL, &replace_cmd_group, 0 },
-		{ "help", cmd_help, cmd_help_usage, NULL, 0 },
-		{ "version", cmd_version, cmd_version_usage, NULL, 0 },
-		NULL_CMD_STRUCT
+		&cmd_struct_subvolume,
+		&cmd_struct_filesystem,
+		&cmd_struct_balance,
+		&cmd_struct_device,
+		&cmd_struct_scrub,
+		&cmd_struct_check,
+		&cmd_struct_rescue,
+		&cmd_struct_restore,
+		&cmd_struct_inspect,
+		&cmd_struct_property,
+		&cmd_struct_send,
+		&cmd_struct_receive,
+		&cmd_struct_quota,
+		&cmd_struct_qgroup,
+		&cmd_struct_replace,
+		&cmd_struct_help,
+		&cmd_struct_version,
+		NULL
 	},
 };
 
@@ -299,7 +303,7 @@ int main(int argc, char **argv)
 
 	fixup_argv0(argv, cmd->token);
 
-	ret = cmd->fn(argc, argv);
+	ret = cmd_execute(cmd, argc, argv);
 
 	btrfs_close_all_devices();
 
diff --git a/check/main.c b/check/main.c
index 97baae58..4b8f7678 100644
--- a/check/main.c
+++ b/check/main.c
@@ -9408,7 +9408,7 @@ close_out:
 	return ret;
 }
 
-const char * const cmd_check_usage[] = {
+static const char * const cmd_check_usage[] = {
 	"btrfs check [options] <device>",
 	"Check structural integrity of a filesystem (unmounted).",
 	"Check structural integrity of an unmounted filesystem. Verify internal",
@@ -9440,7 +9440,7 @@ const char * const cmd_check_usage[] = {
 	NULL
 };
 
-int cmd_check(int argc, char **argv)
+static int cmd_check(int argc, char **argv)
 {
 	struct cache_tree root_cache;
 	struct btrfs_root *root;
@@ -9930,3 +9930,4 @@ err_out:
 
 	return err;
 }
+DEFINE_SIMPLE_COMMAND(check, "check");
diff --git a/cmds-balance.c b/cmds-balance.c
index 0c91bdf1..7a60be61 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -672,6 +672,7 @@ static int cmd_balance_start(int argc, char **argv)
 
 	return do_balance(argv[optind], &args, start_flags);
 }
+static DEFINE_SIMPLE_COMMAND(balance_start, "start");
 
 static const char * const cmd_balance_pause_usage[] = {
 	"btrfs balance pause <path>",
@@ -710,6 +711,7 @@ static int cmd_balance_pause(int argc, char **argv)
 	close_file_or_dir(fd, dirstream);
 	return ret;
 }
+static DEFINE_SIMPLE_COMMAND(balance_pause, "pause");
 
 static const char * const cmd_balance_cancel_usage[] = {
 	"btrfs balance cancel <path>",
@@ -748,6 +750,7 @@ static int cmd_balance_cancel(int argc, char **argv)
 	close_file_or_dir(fd, dirstream);
 	return ret;
 }
+static DEFINE_SIMPLE_COMMAND(balance_cancel, "cancel");
 
 static const char * const cmd_balance_resume_usage[] = {
 	"btrfs balance resume <path>",
@@ -807,6 +810,7 @@ static int cmd_balance_resume(int argc, char **argv)
 	close_file_or_dir(fd, dirstream);
 	return ret;
 }
+static DEFINE_SIMPLE_COMMAND(balance_resume, "resume");
 
 static const char * const cmd_balance_status_usage[] = {
 	"btrfs balance status [-v] <path>",
@@ -898,6 +902,7 @@ out:
 	close_file_or_dir(fd, dirstream);
 	return ret;
 }
+static DEFINE_SIMPLE_COMMAND(balance_status, "status");
 
 static int cmd_balance_full(int argc, char **argv)
 {
@@ -908,23 +913,25 @@ static int cmd_balance_full(int argc, char **argv)
 
 	return do_balance(argv[1], &args, BALANCE_START_NOWARN);
 }
+static DEFINE_COMMAND(balance_full, "--full-balance", cmd_balance_full,
+		      NULL, NULL, CMD_HIDDEN);
 
 static const char balance_cmd_group_info[] =
 "balance data across devices, or change block groups using filters";
 
-const struct cmd_group balance_cmd_group = {
+static const struct cmd_group balance_cmd_group = {
 	balance_cmd_group_usage, balance_cmd_group_info, {
-		{ "start", cmd_balance_start, cmd_balance_start_usage, NULL, 0 },
-		{ "pause", cmd_balance_pause, cmd_balance_pause_usage, NULL, 0 },
-		{ "cancel", cmd_balance_cancel, cmd_balance_cancel_usage, NULL, 0 },
-		{ "resume", cmd_balance_resume, cmd_balance_resume_usage, NULL, 0 },
-		{ "status", cmd_balance_status, cmd_balance_status_usage, NULL, 0 },
-		{ "--full-balance", cmd_balance_full, NULL, NULL, 1 },
-		NULL_CMD_STRUCT
+		&cmd_struct_balance_start,
+		&cmd_struct_balance_pause,
+		&cmd_struct_balance_cancel,
+		&cmd_struct_balance_resume,
+		&cmd_struct_balance_status,
+		&cmd_struct_balance_full,
+		NULL
 	}
 };
 
-int cmd_balance(int argc, char **argv)
+static int cmd_balance(int argc, char **argv)
 {
 	if (argc == 2 && strcmp("start", argv[1]) != 0) {
 		/* old 'btrfs filesystem balance <path>' syntax */
@@ -938,3 +945,5 @@ int cmd_balance(int argc, char **argv)
 
 	return handle_command_group(&balance_cmd_group, argc, argv);
 }
+
+DEFINE_GROUP_COMMAND(balance, "balance");
diff --git a/cmds-device.c b/cmds-device.c
index a49c9d9d..96764d6c 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -140,6 +140,7 @@ error_out:
 	close_file_or_dir(fdmnt, dirstream);
 	return !!ret;
 }
+static DEFINE_SIMPLE_COMMAND(device_add, "add");
 
 static int _cmd_device_remove(int argc, char **argv,
 		const char * const *usagestr)
@@ -239,6 +240,7 @@ static int cmd_device_remove(int argc, char **argv)
 {
 	return _cmd_device_remove(argc, argv, cmd_device_remove_usage);
 }
+static DEFINE_SIMPLE_COMMAND(device_remove, "remove");
 
 static const char * const cmd_device_delete_usage[] = {
 	"btrfs device delete <device>|<devid> [<device>|<devid>...] <path>",
@@ -252,6 +254,8 @@ static int cmd_device_delete(int argc, char **argv)
 {
 	return _cmd_device_remove(argc, argv, cmd_device_delete_usage);
 }
+static DEFINE_COMMAND(device_delete, "delete", cmd_device_delete,
+		      cmd_device_delete_usage, NULL, CMD_ALIAS);
 
 static const char * const cmd_device_scan_usage[] = {
 	"btrfs device scan [(-d|--all-devices)|<device> [<device>...]]",
@@ -325,6 +329,7 @@ static int cmd_device_scan(int argc, char **argv)
 out:
 	return !!ret;
 }
+static DEFINE_SIMPLE_COMMAND(device_scan, "scan");
 
 static const char * const cmd_device_ready_usage[] = {
 	"btrfs device ready <device>",
@@ -378,6 +383,7 @@ out:
 	close(fd);
 	return ret;
 }
+static DEFINE_SIMPLE_COMMAND(device_ready, "ready");
 
 static const char * const cmd_device_stats_usage[] = {
 	"btrfs device stats [options] <path>|<device>",
@@ -518,6 +524,7 @@ out:
 
 	return err;
 }
+static DEFINE_SIMPLE_COMMAND(device_stats, "stats");
 
 static const char * const cmd_device_usage_usage[] = {
 	"btrfs device usage [options] <path> [<path>..]",
@@ -590,26 +597,26 @@ static int cmd_device_usage(int argc, char **argv)
 
 	return !!ret;
 }
+static DEFINE_SIMPLE_COMMAND(device_usage, "usage");
 
 static const char device_cmd_group_info[] =
 "manage and query devices in the filesystem";
 
-const struct cmd_group device_cmd_group = {
+static const struct cmd_group device_cmd_group = {
 	device_cmd_group_usage, device_cmd_group_info, {
-		{ "add", cmd_device_add, cmd_device_add_usage, NULL, 0 },
-		{ "delete", cmd_device_delete, cmd_device_delete_usage, NULL,
-			CMD_ALIAS },
-		{ "remove", cmd_device_remove, cmd_device_remove_usage, NULL, 0 },
-		{ "scan", cmd_device_scan, cmd_device_scan_usage, NULL, 0 },
-		{ "ready", cmd_device_ready, cmd_device_ready_usage, NULL, 0 },
-		{ "stats", cmd_device_stats, cmd_device_stats_usage, NULL, 0 },
-		{ "usage", cmd_device_usage,
-			cmd_device_usage_usage, NULL, 0 },
-		NULL_CMD_STRUCT
+		&cmd_struct_device_add,
+		&cmd_struct_device_delete,
+		&cmd_struct_device_remove,
+		&cmd_struct_device_scan,
+		&cmd_struct_device_ready,
+		&cmd_struct_device_stats,
+		&cmd_struct_device_usage,
+		NULL
 	}
 };
 
-int cmd_device(int argc, char **argv)
+static int cmd_device(int argc, char **argv)
 {
 	return handle_command_group(&device_cmd_group, argc, argv);
 }
+DEFINE_GROUP_COMMAND_TOKEN(device);
diff --git a/cmds-fi-du.c b/cmds-fi-du.c
index 8a44665c..cb2f09c7 100644
--- a/cmds-fi-du.c
+++ b/cmds-fi-du.c
@@ -549,7 +549,7 @@ out:
 	return ret;
 }
 
-const char * const cmd_filesystem_du_usage[] = {
+static const char * const cmd_filesystem_du_usage[] = {
 	"btrfs filesystem du [options] <path> [<path>..]",
 	"Summarize disk usage of each file.",
 	"-s|--summarize     display only a total for each argument",
@@ -557,7 +557,7 @@ const char * const cmd_filesystem_du_usage[] = {
 	NULL
 };
 
-int cmd_filesystem_du(int argc, char **argv)
+static int cmd_filesystem_du(int argc, char **argv)
 {
 	int ret = 0, err = 0;
 	int i;
@@ -611,3 +611,4 @@ int cmd_filesystem_du(int argc, char **argv)
 
 	return err;
 }
+DEFINE_SIMPLE_COMMAND(filesystem_du, "du");
diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
index 9a1c76ab..af882400 100644
--- a/cmds-fi-usage.c
+++ b/cmds-fi-usage.c
@@ -957,7 +957,7 @@ out:
 	return ret;
 }
 
-const char * const cmd_filesystem_usage_usage[] = {
+static const char * const cmd_filesystem_usage_usage[] = {
 	"btrfs filesystem usage [options] <path> [<path>..]",
 	"Show detailed information about internal filesystem usage .",
 	HELPINFO_UNITS_SHORT_LONG,
@@ -965,7 +965,7 @@ const char * const cmd_filesystem_usage_usage[] = {
 	NULL
 };
 
-int cmd_filesystem_usage(int argc, char **argv)
+static int cmd_filesystem_usage(int argc, char **argv)
 {
 	int ret = 0;
 	unsigned unit_mode;
@@ -1035,6 +1035,7 @@ cleanup:
 out:
 	return !!ret;
 }
+DEFINE_SIMPLE_COMMAND(filesystem_usage, "usage");
 
 void print_device_chunks(struct device_info *devinfo,
 		struct chunk_info *chunks_info_ptr,
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 62112705..ec038f2f 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -149,6 +149,7 @@ static int cmd_filesystem_df(int argc, char **argv)
 	close_file_or_dir(fd, dirstream);
 	return !!ret;
 }
+static DEFINE_SIMPLE_COMMAND(filesystem_df, "df");
 
 static int match_search_item_kernel(u8 *fsid, char *mnt, char *label,
 					char *search)
@@ -804,6 +805,7 @@ out:
 	free_seen_fsid(seen_fsid_hash);
 	return ret;
 }
+static DEFINE_SIMPLE_COMMAND(filesystem_show, "show");
 
 static const char * const cmd_filesystem_sync_usage[] = {
 	"btrfs filesystem sync <path>",
@@ -837,6 +839,7 @@ static int cmd_filesystem_sync(int argc, char **argv)
 
 	return 0;
 }
+static DEFINE_SIMPLE_COMMAND(filesystem_sync, "sync");
 
 static int parse_compress_type(char *s)
 {
@@ -1075,6 +1078,7 @@ next:
 
 	return !!defrag_global_errors;
 }
+static DEFINE_SIMPLE_COMMAND(filesystem_defrag, "defrag");
 
 static const char * const cmd_filesystem_resize_usage[] = {
 	"btrfs filesystem resize [devid:][+/-]<newsize>[kKmMgGtTpPeE]|[devid:]max <path>",
@@ -1153,6 +1157,7 @@ static int cmd_filesystem_resize(int argc, char **argv)
 	}
 	return 0;
 }
+static DEFINE_SIMPLE_COMMAND(filesystem_resize, "resize");
 
 static const char * const cmd_filesystem_label_usage[] = {
 	"btrfs filesystem label [<device>|<mount_point>] [<newlabel>]",
@@ -1183,6 +1188,7 @@ static int cmd_filesystem_label(int argc, char **argv)
 		return ret;
 	}
 }
+static DEFINE_SIMPLE_COMMAND(filesystem_label, "label");
 
 static const char * const cmd_filesystem_balance_usage[] = {
 	"btrfs filesystem balance [args...] (alias of \"btrfs balance\")",
@@ -1190,40 +1196,40 @@ static const char * const cmd_filesystem_balance_usage[] = {
 	NULL
 };
 
-/* Compatible old "btrfs filesystem balance" command */
 static int cmd_filesystem_balance(int argc, char **argv)
 {
-	return cmd_balance(argc, argv);
+	return cmd_execute(&cmd_struct_balance, argc, argv);
 }
 
+/*
+ * Compatible old "btrfs filesystem balance" command
+ *
+ * We can't use cmd_struct_balance directly here since this alias is
+ * for historical compatibility and is hidden.
+ */
+static DEFINE_COMMAND(filesystem_balance, "balance", cmd_filesystem_balance,
+		      cmd_filesystem_balance_usage, NULL, CMD_HIDDEN);
+
 static const char filesystem_cmd_group_info[] =
 "overall filesystem tasks and information";
 
-const struct cmd_group filesystem_cmd_group = {
+static const struct cmd_group filesystem_cmd_group = {
 	filesystem_cmd_group_usage, filesystem_cmd_group_info, {
-		{ "df", cmd_filesystem_df, cmd_filesystem_df_usage, NULL, 0 },
-		{ "du", cmd_filesystem_du, cmd_filesystem_du_usage, NULL, 0 },
-		{ "show", cmd_filesystem_show, cmd_filesystem_show_usage, NULL,
-			0 },
-		{ "sync", cmd_filesystem_sync, cmd_filesystem_sync_usage, NULL,
-			0 },
-		{ "defragment", cmd_filesystem_defrag,
-			cmd_filesystem_defrag_usage, NULL, 0 },
-		{ "balance", cmd_filesystem_balance,
-		   cmd_filesystem_balance_usage, &balance_cmd_group,
-		   CMD_HIDDEN },
-		{ "resize", cmd_filesystem_resize, cmd_filesystem_resize_usage,
-			NULL, 0 },
-		{ "label", cmd_filesystem_label, cmd_filesystem_label_usage,
-			NULL, 0 },
-		{ "usage", cmd_filesystem_usage,
-			cmd_filesystem_usage_usage, NULL, 0 },
-
-		NULL_CMD_STRUCT
+		&cmd_struct_filesystem_df,
+		&cmd_struct_filesystem_du,
+		&cmd_struct_filesystem_show,
+		&cmd_struct_filesystem_sync,
+		&cmd_struct_filesystem_defrag,
+		&cmd_struct_filesystem_balance,
+		&cmd_struct_filesystem_resize,
+		&cmd_struct_filesystem_label,
+		&cmd_struct_filesystem_usage,
+		NULL
 	}
 };
 
-int cmd_filesystem(int argc, char **argv)
+static int cmd_filesystem(int argc, char **argv)
 {
 	return handle_command_group(&filesystem_cmd_group, argc, argv);
 }
+DEFINE_GROUP_COMMAND_TOKEN(filesystem);
diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index 150c2e5a..34542d71 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -486,7 +486,7 @@ static int load_and_dump_sb(char *filename, int fd, u64 sb_bytenr, int full,
 	return 0;
 }
 
-const char * const cmd_inspect_dump_super_usage[] = {
+static const char * const cmd_inspect_dump_super_usage[] = {
 	"btrfs inspect-internal dump-super [options] device [device...]",
 	"Dump superblock from a device in a textual form",
 	"-f|--full             print full superblock information, backup roots etc.",
@@ -504,7 +504,7 @@ const char * const cmd_inspect_dump_super_usage[] = {
 	NULL
 };
 
-int cmd_inspect_dump_super(int argc, char **argv)
+static int cmd_inspect_dump_super(int argc, char **argv)
 {
 	int all = 0;
 	int full = 0;
@@ -612,3 +612,4 @@ int cmd_inspect_dump_super(int argc, char **argv)
 out:
 	return ret;
 }
+DEFINE_SIMPLE_COMMAND(inspect_dump_super, "dump-super");
diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
index df44bb63..6417eab3 100644
--- a/cmds-inspect-dump-tree.c
+++ b/cmds-inspect-dump-tree.c
@@ -183,7 +183,7 @@ static u64 treeid_from_string(const char *str, const char **end)
 	return id;
 }
 
-const char * const cmd_inspect_dump_tree_usage[] = {
+static const char * const cmd_inspect_dump_tree_usage[] = {
 	"btrfs inspect-internal dump-tree [options] device",
 	"Dump tree structures from a given device",
 	"Dump tree structures from a given device in textual form, expand keys to human",
@@ -201,7 +201,7 @@ const char * const cmd_inspect_dump_tree_usage[] = {
 	NULL
 };
 
-int cmd_inspect_dump_tree(int argc, char **argv)
+static int cmd_inspect_dump_tree(int argc, char **argv)
 {
 	struct btrfs_root *root;
 	struct btrfs_fs_info *info;
@@ -585,3 +585,4 @@ close_root:
 out:
 	return !!ret;
 }
+DEFINE_SIMPLE_COMMAND(inspect_dump_tree, "dump-tree");
diff --git a/cmds-inspect-tree-stats.c b/cmds-inspect-tree-stats.c
index eced0db9..14d79ccc 100644
--- a/cmds-inspect-tree-stats.c
+++ b/cmds-inspect-tree-stats.c
@@ -420,14 +420,14 @@ out:
 	return ret;
 }
 
-const char * const cmd_inspect_tree_stats_usage[] = {
+static const char * const cmd_inspect_tree_stats_usage[] = {
 	"btrfs inspect-internal tree-stats [options] <device>",
 	"Print various stats for trees",
 	"-b		raw numbers in bytes",
 	NULL
 };
 
-int cmd_inspect_tree_stats(int argc, char **argv)
+static int cmd_inspect_tree_stats(int argc, char **argv)
 {
 	struct btrfs_key key;
 	struct btrfs_root *root;
@@ -494,3 +494,4 @@ out:
 	close_ctree(root);
 	return ret;
 }
+DEFINE_SIMPLE_COMMAND(inspect_tree_stats, "tree-stats");
diff --git a/cmds-inspect.c b/cmds-inspect.c
index afd7fe48..12f200b3 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -121,6 +121,7 @@ static int cmd_inspect_inode_resolve(int argc, char **argv)
 	return !!ret;
 
 }
+static DEFINE_SIMPLE_COMMAND(inspect_inode_resolve, "inode-resolve");
 
 static const char * const cmd_inspect_logical_resolve_usage[] = {
 	"btrfs inspect-internal logical-resolve [-Pv] [-s bufsize] <logical> <path>",
@@ -257,6 +258,7 @@ out:
 	free(inodes);
 	return !!ret;
 }
+static DEFINE_SIMPLE_COMMAND(inspect_logical_resolve, "logical-resolve");
 
 static const char * const cmd_inspect_subvolid_resolve_usage[] = {
 	"btrfs inspect-internal subvolid-resolve <subvolid> <path>",
@@ -299,6 +301,7 @@ out:
 	close_file_or_dir(fd, dirstream);
 	return !!ret;
 }
+static DEFINE_SIMPLE_COMMAND(inspect_subvolid_resolve, "subvolid-resolve");
 
 static const char* const cmd_inspect_rootid_usage[] = {
 	"btrfs inspect-internal rootid <path>",
@@ -336,6 +339,7 @@ out:
 
 	return !!ret;
 }
+static DEFINE_SIMPLE_COMMAND(inspect_rootid, "rootid");
 
 static const char* const cmd_inspect_min_dev_size_usage[] = {
 	"btrfs inspect-internal min-dev-size [options] <path>",
@@ -625,33 +629,27 @@ static int cmd_inspect_min_dev_size(int argc, char **argv)
 out:
 	return !!ret;
 }
+static DEFINE_SIMPLE_COMMAND(inspect_min_dev_size, "min-dev-size");
 
 static const char inspect_cmd_group_info[] =
 "query various internal information";
 
-const struct cmd_group inspect_cmd_group = {
+static const struct cmd_group inspect_cmd_group = {
 	inspect_cmd_group_usage, inspect_cmd_group_info, {
-		{ "inode-resolve", cmd_inspect_inode_resolve,
-			cmd_inspect_inode_resolve_usage, NULL, 0 },
-		{ "logical-resolve", cmd_inspect_logical_resolve,
-			cmd_inspect_logical_resolve_usage, NULL, 0 },
-		{ "subvolid-resolve", cmd_inspect_subvolid_resolve,
-			cmd_inspect_subvolid_resolve_usage, NULL, 0 },
-		{ "rootid", cmd_inspect_rootid, cmd_inspect_rootid_usage, NULL,
-			0 },
-		{ "min-dev-size", cmd_inspect_min_dev_size,
-			cmd_inspect_min_dev_size_usage, NULL, 0 },
-		{ "dump-tree", cmd_inspect_dump_tree,
-				cmd_inspect_dump_tree_usage, NULL, 0 },
-		{ "dump-super", cmd_inspect_dump_super,
-				cmd_inspect_dump_super_usage, NULL, 0 },
-		{ "tree-stats", cmd_inspect_tree_stats,
-				cmd_inspect_tree_stats_usage, NULL, 0 },
-		NULL_CMD_STRUCT
+		&cmd_struct_inspect_inode_resolve,
+		&cmd_struct_inspect_logical_resolve,
+		&cmd_struct_inspect_subvolid_resolve,
+		&cmd_struct_inspect_rootid,
+		&cmd_struct_inspect_min_dev_size,
+		&cmd_struct_inspect_dump_tree,
+		&cmd_struct_inspect_dump_super,
+		&cmd_struct_inspect_tree_stats,
+		NULL
 	}
 };
 
-int cmd_inspect(int argc, char **argv)
+static int cmd_inspect(int argc, char **argv)
 {
 	return handle_command_group(&inspect_cmd_group, argc, argv);
 }
+DEFINE_GROUP_COMMAND(inspect, "inspect");
diff --git a/cmds-property.c b/cmds-property.c
index 03bafa05..dce1f2a9 100644
--- a/cmds-property.c
+++ b/cmds-property.c
@@ -358,6 +358,7 @@ static int cmd_property_get(int argc, char **argv)
 
 	return ret;
 }
+static DEFINE_SIMPLE_COMMAND(property_get, "get");
 
 static const char * const cmd_property_set_usage[] = {
 	"btrfs property set [-t <type>] <object> <name> <value>",
@@ -382,6 +383,7 @@ static int cmd_property_set(int argc, char **argv)
 
 	return ret;
 }
+static DEFINE_SIMPLE_COMMAND(property_set, "set");
 
 static const char * const cmd_property_list_usage[] = {
 	"btrfs property list [-t <type>] <object>",
@@ -404,23 +406,22 @@ static int cmd_property_list(int argc, char **argv)
 
 	return ret;
 }
+static DEFINE_SIMPLE_COMMAND(property_list, "list");
 
 static const char property_cmd_group_info[] =
 "modify properties of filesystem objects";
 
-const struct cmd_group property_cmd_group = {
+static const struct cmd_group property_cmd_group = {
 	property_cmd_group_usage, property_cmd_group_info, {
-		{ "get", cmd_property_get,
-			cmd_property_get_usage, NULL, 0 },
-		{ "set", cmd_property_set,
-			cmd_property_set_usage, NULL, 0 },
-		{ "list", cmd_property_list,
-			cmd_property_list_usage, NULL, 0 },
-		NULL_CMD_STRUCT
+		&cmd_struct_property_get,
+		&cmd_struct_property_set,
+		&cmd_struct_property_list,
+		NULL
 	}
 };
 
-int cmd_property(int argc, char **argv)
+static int cmd_property(int argc, char **argv)
 {
 	return handle_command_group(&property_cmd_group, argc, argv);
 }
+DEFINE_GROUP_COMMAND_TOKEN(property);
diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index d704aeaf..6945d160 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -219,6 +219,7 @@ static int cmd_qgroup_assign(int argc, char **argv)
 {
 	return _cmd_qgroup_assign(1, argc, argv, cmd_qgroup_assign_usage);
 }
+static DEFINE_SIMPLE_COMMAND(qgroup_assign, "assign");
 
 static const char * const cmd_qgroup_remove_usage[] = {
 	"btrfs qgroup remove <src> <dst> <path>",
@@ -230,6 +231,7 @@ static int cmd_qgroup_remove(int argc, char **argv)
 {
 	return _cmd_qgroup_assign(0, argc, argv, cmd_qgroup_remove_usage);
 }
+static DEFINE_SIMPLE_COMMAND(qgroup_remove, "remove");
 
 static const char * const cmd_qgroup_create_usage[] = {
 	"btrfs qgroup create <qgroupid> <path>",
@@ -249,6 +251,7 @@ static int cmd_qgroup_create(int argc, char **argv)
 		usage(cmd_qgroup_create_usage);
 	return ret;
 }
+static DEFINE_SIMPLE_COMMAND(qgroup_create, "create");
 
 static const char * const cmd_qgroup_destroy_usage[] = {
 	"btrfs qgroup destroy <qgroupid> <path>",
@@ -268,6 +271,7 @@ static int cmd_qgroup_destroy(int argc, char **argv)
 		usage(cmd_qgroup_destroy_usage);
 	return ret;
 }
+static DEFINE_SIMPLE_COMMAND(qgroup_destroy, "destroy");
 
 static const char * const cmd_qgroup_show_usage[] = {
 	"btrfs qgroup show [options] <path>",
@@ -414,6 +418,7 @@ static int cmd_qgroup_show(int argc, char **argv)
 out:
 	return !!ret;
 }
+static DEFINE_SIMPLE_COMMAND(qgroup_show, "show");
 
 static const char * const cmd_qgroup_limit_usage[] = {
 	"btrfs qgroup limit [options] <size>|none [<qgroupid>] <path>",
@@ -506,29 +511,25 @@ static int cmd_qgroup_limit(int argc, char **argv)
 	}
 	return 0;
 }
+static DEFINE_SIMPLE_COMMAND(qgroup_limit, "limit");
 
 static const char qgroup_cmd_group_info[] =
 "manage quota groups";
 
-const struct cmd_group qgroup_cmd_group = {
+static const struct cmd_group qgroup_cmd_group = {
 	qgroup_cmd_group_usage, qgroup_cmd_group_info, {
-		{ "assign", cmd_qgroup_assign, cmd_qgroup_assign_usage,
-		   NULL, 0 },
-		{ "remove", cmd_qgroup_remove, cmd_qgroup_remove_usage,
-		   NULL, 0 },
-		{ "create", cmd_qgroup_create, cmd_qgroup_create_usage,
-		   NULL, 0 },
-		{ "destroy", cmd_qgroup_destroy, cmd_qgroup_destroy_usage,
-		   NULL, 0 },
-		{ "show", cmd_qgroup_show, cmd_qgroup_show_usage,
-		   NULL, 0 },
-		{ "limit", cmd_qgroup_limit, cmd_qgroup_limit_usage,
-		   NULL, 0 },
-		NULL_CMD_STRUCT
+		&cmd_struct_qgroup_assign,
+		&cmd_struct_qgroup_remove,
+		&cmd_struct_qgroup_create,
+		&cmd_struct_qgroup_destroy,
+		&cmd_struct_qgroup_show,
+		&cmd_struct_qgroup_limit,
+		NULL
 	}
 };
 
-int cmd_qgroup(int argc, char **argv)
+static int cmd_qgroup(int argc, char **argv)
 {
 	return handle_command_group(&qgroup_cmd_group, argc, argv);
 }
+DEFINE_GROUP_COMMAND_TOKEN(qgroup);
diff --git a/cmds-quota.c b/cmds-quota.c
index 7f933495..5cd5607f 100644
--- a/cmds-quota.c
+++ b/cmds-quota.c
@@ -79,6 +79,7 @@ static int cmd_quota_enable(int argc, char **argv)
 		usage(cmd_quota_enable_usage);
 	return ret;
 }
+static DEFINE_SIMPLE_COMMAND(quota_enable, "enable");
 
 static const char * const cmd_quota_disable_usage[] = {
 	"btrfs quota disable <path>",
@@ -98,6 +99,7 @@ static int cmd_quota_disable(int argc, char **argv)
 		usage(cmd_quota_disable_usage);
 	return ret;
 }
+static DEFINE_SIMPLE_COMMAND(quota_disable, "disable");
 
 static const char * const cmd_quota_rescan_usage[] = {
 	"btrfs quota rescan [-sw] <path>",
@@ -197,21 +199,22 @@ static int cmd_quota_rescan(int argc, char **argv)
 	close_file_or_dir(fd, dirstream);
 	return 0;
 }
+static DEFINE_SIMPLE_COMMAND(quota_rescan, "rescan");
 
 static const char quota_cmd_group_info[] =
 "manage filesystem quota settings";
 
-const struct cmd_group quota_cmd_group = {
+static const struct cmd_group quota_cmd_group = {
 	quota_cmd_group_usage, quota_cmd_group_info, {
-		{ "enable", cmd_quota_enable, cmd_quota_enable_usage, NULL, 0 },
-		{ "disable", cmd_quota_disable, cmd_quota_disable_usage,
-		   NULL, 0 },
-		{ "rescan", cmd_quota_rescan, cmd_quota_rescan_usage, NULL, 0 },
-		NULL_CMD_STRUCT
+		&cmd_struct_quota_enable,
+		&cmd_struct_quota_disable,
+		&cmd_struct_quota_rescan,
+		NULL
 	}
 };
 
-int cmd_quota(int argc, char **argv)
+static int cmd_quota(int argc, char **argv)
 {
 	return handle_command_group(&quota_cmd_group, argc, argv);
 }
+DEFINE_GROUP_COMMAND_TOKEN(quota);
diff --git a/cmds-receive.c b/cmds-receive.c
index b3709f36..d88b8793 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -1248,7 +1248,7 @@ out:
 	return ret;
 }
 
-const char * const cmd_receive_usage[] = {
+static const char * const cmd_receive_usage[] = {
 	"btrfs receive [options] <mount>\n"
 	"btrfs receive --dump [options]",
 	"Receive subvolumes from a stream",
@@ -1279,7 +1279,7 @@ const char * const cmd_receive_usage[] = {
 	NULL
 };
 
-int cmd_receive(int argc, char **argv)
+static int cmd_receive(int argc, char **argv)
 {
 	char *tomnt = NULL;
 	char fromfile[PATH_MAX];
@@ -1388,3 +1388,4 @@ out:
 
 	return !!ret;
 }
+DEFINE_SIMPLE_COMMAND(receive, "receive");
diff --git a/cmds-replace.c b/cmds-replace.c
index 032a44fc..a7379c71 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -313,6 +313,7 @@ leave_with_error:
 		close(fddstdev);
 	return 1;
 }
+static DEFINE_SIMPLE_COMMAND(replace_start, "start");
 
 static const char *const cmd_replace_status_usage[] = {
 	"btrfs replace status [-1] <mount_point>",
@@ -356,6 +357,7 @@ static int cmd_replace_status(int argc, char **argv)
 	close_file_or_dir(fd, dirstream);
 	return !!ret;
 }
+static DEFINE_SIMPLE_COMMAND(replace_status, "status");
 
 static int print_replace_status(int fd, const char *path, int once)
 {
@@ -538,23 +540,22 @@ static int cmd_replace_cancel(int argc, char **argv)
 	}
 	return 0;
 }
+static DEFINE_SIMPLE_COMMAND(replace_cancel, "cancel");
 
 static const char replace_cmd_group_info[] =
 "replace a device in the filesystem";
 
-const struct cmd_group replace_cmd_group = {
+static const struct cmd_group replace_cmd_group = {
 	replace_cmd_group_usage, replace_cmd_group_info, {
-		{ "start", cmd_replace_start, cmd_replace_start_usage, NULL,
-		  0 },
-		{ "status", cmd_replace_status, cmd_replace_status_usage, NULL,
-		  0 },
-		{ "cancel", cmd_replace_cancel, cmd_replace_cancel_usage, NULL,
-		  0 },
-		NULL_CMD_STRUCT
+		&cmd_struct_replace_start,
+		&cmd_struct_replace_status,
+		&cmd_struct_replace_cancel,
+		NULL
 	}
 };
 
-int cmd_replace(int argc, char **argv)
+static int cmd_replace(int argc, char **argv)
 {
 	return handle_command_group(&replace_cmd_group, argc, argv);
 }
+DEFINE_GROUP_COMMAND_TOKEN(replace);
diff --git a/cmds-rescue.c b/cmds-rescue.c
index c61145bc..e3611f2f 100644
--- a/cmds-rescue.c
+++ b/cmds-rescue.c
@@ -94,6 +94,7 @@ static int cmd_rescue_chunk_recover(int argc, char *argv[])
 	}
 	return ret;
 }
+static DEFINE_SIMPLE_COMMAND(rescue_chunk_recover, "chunk-recover");
 
 static const char * const cmd_rescue_super_recover_usage[] = {
 	"btrfs rescue super-recover [options] <device>",
@@ -149,6 +150,7 @@ static int cmd_rescue_super_recover(int argc, char **argv)
 	ret = btrfs_recover_superblocks(dname, verbose, yes);
 	return ret;
 }
+static DEFINE_SIMPLE_COMMAND(rescue_super_recover, "super-recover");
 
 static const char * const cmd_rescue_zero_log_usage[] = {
 	"btrfs rescue zero-log <device>",
@@ -202,6 +204,7 @@ static int cmd_rescue_zero_log(int argc, char **argv)
 out:
 	return !!ret;
 }
+static DEFINE_SIMPLE_COMMAND(rescue_zero_log, "zero-log");
 
 static const char * const cmd_rescue_fix_device_size_usage[] = {
 	"btrfs rescue fix-device-size <device>",
@@ -247,24 +250,23 @@ static int cmd_rescue_fix_device_size(int argc, char **argv)
 out:
 	return !!ret;
 }
+static DEFINE_SIMPLE_COMMAND(rescue_fix_device_size, "fix-device-size");
 
 static const char rescue_cmd_group_info[] =
 "toolbox for specific rescue operations";
 
-const struct cmd_group rescue_cmd_group = {
+static const struct cmd_group rescue_cmd_group = {
 	rescue_cmd_group_usage, rescue_cmd_group_info, {
-		{ "chunk-recover", cmd_rescue_chunk_recover,
-			cmd_rescue_chunk_recover_usage, NULL, 0},
-		{ "super-recover", cmd_rescue_super_recover,
-			cmd_rescue_super_recover_usage, NULL, 0},
-		{ "zero-log", cmd_rescue_zero_log, cmd_rescue_zero_log_usage, NULL, 0},
-		{ "fix-device-size", cmd_rescue_fix_device_size,
-			cmd_rescue_fix_device_size_usage, NULL, 0},
-		NULL_CMD_STRUCT
+		&cmd_struct_rescue_chunk_recover,
+		&cmd_struct_rescue_super_recover,
+		&cmd_struct_rescue_zero_log,
+		&cmd_struct_rescue_fix_device_size,
+		NULL
 	}
 };
 
-int cmd_rescue(int argc, char **argv)
+static int cmd_rescue(int argc, char **argv)
 {
 	return handle_command_group(&rescue_cmd_group, argc, argv);
 }
+DEFINE_GROUP_COMMAND_TOKEN(rescue);
diff --git a/cmds-restore.c b/cmds-restore.c
index ade35f0f..05fd1c80 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -1389,7 +1389,7 @@ out:
 	return ret;
 }
 
-const char * const cmd_restore_usage[] = {
+static const char * const cmd_restore_usage[] = {
 	"btrfs restore [options] <device> <path> | -l <device>",
 	"Try to restore files from a damaged filesystem (unmounted)",
 	"",
@@ -1415,7 +1415,7 @@ const char * const cmd_restore_usage[] = {
 	NULL
 };
 
-int cmd_restore(int argc, char **argv)
+static int cmd_restore(int argc, char **argv)
 {
 	struct btrfs_root *root;
 	struct btrfs_key key;
@@ -1621,3 +1621,4 @@ out:
 	close_ctree(root);
 	return !!ret;
 }
+DEFINE_SIMPLE_COMMAND(restore, "restore");
diff --git a/cmds-scrub.c b/cmds-scrub.c
index dabe7d9a..b0f447c7 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -1580,6 +1580,7 @@ static int cmd_scrub_start(int argc, char **argv)
 {
 	return scrub_start(argc, argv, 0);
 }
+static DEFINE_SIMPLE_COMMAND(scrub_start, "start");
 
 static const char * const cmd_scrub_cancel_usage[] = {
 	"btrfs scrub cancel <path>|<device>",
@@ -1626,6 +1627,7 @@ out:
 	close_file_or_dir(fdmnt, dirstream);
 	return ret;
 }
+static DEFINE_SIMPLE_COMMAND(scrub_cancel, "cancel");
 
 static const char * const cmd_scrub_resume_usage[] = {
 	"btrfs scrub resume [-BdqrR] [-c ioprio_class -n ioprio_classdata] <path>|<device>",
@@ -1645,6 +1647,7 @@ static int cmd_scrub_resume(int argc, char **argv)
 {
 	return scrub_start(argc, argv, 1);
 }
+static DEFINE_SIMPLE_COMMAND(scrub_resume, "resume");
 
 static const char * const cmd_scrub_status_usage[] = {
 	"btrfs scrub status [-dR] <path>|<device>",
@@ -1786,21 +1789,24 @@ out:
 
 	return !!err;
 }
+static DEFINE_SIMPLE_COMMAND(scrub_status, "status");
 
 static const char scrub_cmd_group_info[] =
 "verify checksums of data and metadata";
 
-const struct cmd_group scrub_cmd_group = {
+static const struct cmd_group scrub_cmd_group = {
 	scrub_cmd_group_usage, scrub_cmd_group_info, {
-		{ "start", cmd_scrub_start, cmd_scrub_start_usage, NULL, 0 },
-		{ "cancel", cmd_scrub_cancel, cmd_scrub_cancel_usage, NULL, 0 },
-		{ "resume", cmd_scrub_resume, cmd_scrub_resume_usage, NULL, 0 },
-		{ "status", cmd_scrub_status, cmd_scrub_status_usage, NULL, 0 },
-		NULL_CMD_STRUCT
+		&cmd_struct_scrub_start,
+		&cmd_struct_scrub_cancel,
+		&cmd_struct_scrub_resume,
+		&cmd_struct_scrub_status,
+		NULL
 	}
 };
 
-int cmd_scrub(int argc, char **argv)
+static int cmd_scrub(int argc, char **argv)
 {
 	return handle_command_group(&scrub_cmd_group, argc, argv);
 }
+
+DEFINE_GROUP_COMMAND_TOKEN(scrub);
diff --git a/cmds-send.c b/cmds-send.c
index 8365e9c9..f1e5124d 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -489,8 +489,7 @@ static void free_send_info(struct btrfs_send *sctx)
 	subvol_uuid_search_finit(&sctx->sus);
 }
 
-
-const char * const cmd_send_usage[] = {
+static const char * const cmd_send_usage[] = {
 	"btrfs send [-ve] [-p <parent>] [-c <clone-src>] [-f <outfile>] <subvol> [<subvol>...]",
 	"Send the subvolume(s) to stdout.",
 	"Sends the subvolume(s) specified by <subvol> to stdout.",
@@ -524,7 +523,7 @@ const char * const cmd_send_usage[] = {
 	NULL
 };
 
-int cmd_send(int argc, char **argv)
+static int cmd_send(int argc, char **argv)
 {
 	char *subvol = NULL;
 	int ret;
@@ -809,3 +808,4 @@ out:
 	free_send_info(&send);
 	return !!ret;
 }
+DEFINE_SIMPLE_COMMAND(send, "send");
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 96fb7b06..6fc4b2e7 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -223,6 +223,7 @@ out:
 
 	return retval;
 }
+static DEFINE_SIMPLE_COMMAND(subvol_create, "create");
 
 static int wait_for_commit(int fd)
 {
@@ -429,6 +430,7 @@ keep_fd:
 
 	return ret;
 }
+static DEFINE_SIMPLE_COMMAND(subvol_delete, "delete");
 
 /*
  * Naming of options:
@@ -632,6 +634,7 @@ out:
 		usage(cmd_subvol_list_usage);
 	return !!ret;
 }
+static DEFINE_SIMPLE_COMMAND(subvol_list, "list");
 
 static const char * const cmd_subvol_snapshot_usage[] = {
 	"btrfs subvolume snapshot [-r] [-i <qgroupid>] <source> <dest>|[<dest>/]<name>",
@@ -788,6 +791,7 @@ out:
 
 	return retval;
 }
+static DEFINE_SIMPLE_COMMAND(subvol_snapshot, "snapshot");
 
 static const char * const cmd_subvol_get_default_usage[] = {
 	"btrfs subvolume get-default <path>",
@@ -852,6 +856,7 @@ out:
 	close_file_or_dir(fd, dirstream);
 	return !!ret;
 }
+static DEFINE_SIMPLE_COMMAND(subvol_get_default, "get-default");
 
 static const char * const cmd_subvol_set_default_usage[] = {
 	"btrfs subvolume set-default <subvolume>\n"
@@ -918,6 +923,7 @@ static int cmd_subvol_set_default(int argc, char **argv)
 	}
 	return 0;
 }
+static DEFINE_SIMPLE_COMMAND(subvol_set_default, "set-default");
 
 static const char * const cmd_subvol_find_new_usage[] = {
 	"btrfs subvolume find-new <path> <lastgen>",
@@ -966,6 +972,7 @@ static int cmd_subvol_find_new(int argc, char **argv)
 	close_file_or_dir(fd, dirstream);
 	return !!ret;
 }
+static DEFINE_SIMPLE_COMMAND(subvol_find_new, "find-new");
 
 static const char * const cmd_subvol_show_usage[] = {
 	"btrfs subvolume show [options] <subvol-path>|<mnt>",
@@ -1170,6 +1177,7 @@ out:
 	free(fullpath);
 	return !!ret;
 }
+static DEFINE_SIMPLE_COMMAND(subvol_show, "show");
 
 static const char * const cmd_subvol_sync_usage[] = {
 	"btrfs subvolume sync <path> [<subvol-id>...]",
@@ -1420,30 +1428,28 @@ out:
 
 	return !!ret;
 }
+static DEFINE_SIMPLE_COMMAND(subvol_sync, "sync");
 
 static const char subvolume_cmd_group_info[] =
 "manage subvolumes: create, delete, list, etc";
 
-const struct cmd_group subvolume_cmd_group = {
+static const struct cmd_group subvolume_cmd_group = {
 	subvolume_cmd_group_usage, subvolume_cmd_group_info, {
-		{ "create", cmd_subvol_create, cmd_subvol_create_usage, NULL, 0 },
-		{ "delete", cmd_subvol_delete, cmd_subvol_delete_usage, NULL, 0 },
-		{ "list", cmd_subvol_list, cmd_subvol_list_usage, NULL, 0 },
-		{ "snapshot", cmd_subvol_snapshot, cmd_subvol_snapshot_usage,
-			NULL, 0 },
-		{ "get-default", cmd_subvol_get_default,
-			cmd_subvol_get_default_usage, NULL, 0 },
-		{ "set-default", cmd_subvol_set_default,
-			cmd_subvol_set_default_usage, NULL, 0 },
-		{ "find-new", cmd_subvol_find_new, cmd_subvol_find_new_usage,
-			NULL, 0 },
-		{ "show", cmd_subvol_show, cmd_subvol_show_usage, NULL, 0 },
-		{ "sync", cmd_subvol_sync, cmd_subvol_sync_usage, NULL, 0 },
-		NULL_CMD_STRUCT
+		&cmd_struct_subvol_create,
+		&cmd_struct_subvol_delete,
+		&cmd_struct_subvol_list,
+		&cmd_struct_subvol_snapshot,
+		&cmd_struct_subvol_get_default,
+		&cmd_struct_subvol_set_default,
+		&cmd_struct_subvol_find_new,
+		&cmd_struct_subvol_show,
+		&cmd_struct_subvol_sync,
+		NULL
 	}
 };
 
-int cmd_subvolume(int argc, char **argv)
+static int cmd_subvolume(int argc, char **argv)
 {
 	return handle_command_group(&subvolume_cmd_group, argc, argv);
 }
+DEFINE_GROUP_COMMAND_TOKEN(subvolume);
diff --git a/commands.h b/commands.h
index 76991f2b..9a65204b 100644
--- a/commands.h
+++ b/commands.h
@@ -56,69 +56,92 @@ struct cmd_struct {
 	int flags;
 };
 
-#define NULL_CMD_STRUCT {NULL, NULL, NULL, NULL, 0}
+/*
+ * These macros will create cmd_struct structures with a standard name:
+ * cmd_struct_<name>.
+ */
+#define __CMD_NAME(name)	cmd_struct_ ##name
+#define DECLARE_COMMAND(name)						\
+	extern const struct cmd_struct __CMD_NAME(name)
+
+/* Define a command with all members specified */
+#define DEFINE_COMMAND(name, _token, _fn, _usagestr, _group, _flags)	\
+	const struct cmd_struct __CMD_NAME(name) =			\
+		{							\
+			.token = (_token),				\
+			.fn = (_fn),					\
+			.usagestr = (_usagestr),			\
+			.next = (_group),				\
+			.flags = (_flags),				\
+		}
+
+/*
+ * Define a command for the common case - just a name and string.
+ * It's assumed that the callback is called cmd_<name> and the usage
+ * array is named cmd_<name>_usage.
+ */
+#define DEFINE_SIMPLE_COMMAND(name, token)				\
+	DEFINE_COMMAND(name, token, cmd_ ##name,			\
+		       cmd_ ##name ##_usage, NULL, 0)
+
+/*
+ * Define a command group callback.
+ * It's assumed that the callback is called cmd_<name> and the
+ * struct cmd_group is called <name>_cmd_group.
+ */
+#define DEFINE_GROUP_COMMAND(name, token)				\
+	DEFINE_COMMAND(name, token, cmd_ ##name,			\
+		       NULL, &(name ## _cmd_group), 0)
+
+/*
+ * Define a command group callback when the name and the string are
+ * the same.
+ */
+#define DEFINE_GROUP_COMMAND_TOKEN(name)				\
+	DEFINE_GROUP_COMMAND(name, #name)
 
 struct cmd_group {
 	const char * const *usagestr;
 	const char *infostr;
 
-	const struct cmd_struct commands[];
+	const struct cmd_struct * const commands[];
 };
 
+static inline int cmd_execute(const struct cmd_struct *cmd,
+			      int argc, char **argv)
+{
+	return cmd->fn(argc, argv);
+}
+
 int handle_command_group(const struct cmd_group *grp, int argc,
 			 char **argv);
 
 extern const char * const generic_cmd_help_usage[];
 
-extern const struct cmd_group subvolume_cmd_group;
-extern const struct cmd_group filesystem_cmd_group;
-extern const struct cmd_group balance_cmd_group;
-extern const struct cmd_group device_cmd_group;
-extern const struct cmd_group scrub_cmd_group;
-extern const struct cmd_group inspect_cmd_group;
-extern const struct cmd_group property_cmd_group;
-extern const struct cmd_group quota_cmd_group;
-extern const struct cmd_group qgroup_cmd_group;
-extern const struct cmd_group replace_cmd_group;
-extern const struct cmd_group rescue_cmd_group;
-
-extern const char * const cmd_send_usage[];
-extern const char * const cmd_receive_usage[];
-extern const char * const cmd_check_usage[];
-extern const char * const cmd_chunk_recover_usage[];
-extern const char * const cmd_super_recover_usage[];
-extern const char * const cmd_restore_usage[];
-extern const char * const cmd_rescue_usage[];
-extern const char * const cmd_inspect_dump_super_usage[];
-extern const char * const cmd_inspect_dump_tree_usage[];
-extern const char * const cmd_inspect_tree_stats_usage[];
-extern const char * const cmd_filesystem_du_usage[];
-extern const char * const cmd_filesystem_usage_usage[];
-
-int cmd_subvolume(int argc, char **argv);
-int cmd_filesystem(int argc, char **argv);
-int cmd_filesystem_du(int argc, char **argv);
-int cmd_filesystem_usage(int argc, char **argv);
-int cmd_balance(int argc, char **argv);
-int cmd_device(int argc, char **argv);
-int cmd_scrub(int argc, char **argv);
-int cmd_check(int argc, char **argv);
-int cmd_chunk_recover(int argc, char **argv);
-int cmd_super_recover(int argc, char **argv);
-int cmd_inspect(int argc, char **argv);
-int cmd_inspect_dump_super(int argc, char **argv);
-int cmd_inspect_dump_tree(int argc, char **argv);
-int cmd_inspect_tree_stats(int argc, char **argv);
-int cmd_property(int argc, char **argv);
-int cmd_send(int argc, char **argv);
-int cmd_receive(int argc, char **argv);
-int cmd_quota(int argc, char **argv);
-int cmd_qgroup(int argc, char **argv);
-int cmd_replace(int argc, char **argv);
-int cmd_restore(int argc, char **argv);
-int cmd_select_super(int argc, char **argv);
-int cmd_dump_super(int argc, char **argv);
-int cmd_debug_tree(int argc, char **argv);
-int cmd_rescue(int argc, char **argv);
+DECLARE_COMMAND(subvolume);
+DECLARE_COMMAND(filesystem);
+DECLARE_COMMAND(filesystem_du);
+DECLARE_COMMAND(filesystem_usage);
+DECLARE_COMMAND(balance);
+DECLARE_COMMAND(device);
+DECLARE_COMMAND(scrub);
+DECLARE_COMMAND(check);
+DECLARE_COMMAND(chunk_recover);
+DECLARE_COMMAND(super_recover);
+DECLARE_COMMAND(inspect);
+DECLARE_COMMAND(inspect_dump_super);
+DECLARE_COMMAND(inspect_dump_tree);
+DECLARE_COMMAND(inspect_tree_stats);
+DECLARE_COMMAND(property);
+DECLARE_COMMAND(send);
+DECLARE_COMMAND(receive);
+DECLARE_COMMAND(quota);
+DECLARE_COMMAND(qgroup);
+DECLARE_COMMAND(replace);
+DECLARE_COMMAND(restore);
+DECLARE_COMMAND(select_super);
+DECLARE_COMMAND(dump_super);
+DECLARE_COMMAND(debug_tree);
+DECLARE_COMMAND(rescue);
 
 #endif
diff --git a/help.c b/help.c
index ef7986b4..b7f06aae 100644
--- a/help.c
+++ b/help.c
@@ -248,14 +248,15 @@ void usage(const char * const *usagestr)
 static void usage_command_group_internal(const struct cmd_group *grp, bool full,
 					 FILE *outf)
 {
-	const struct cmd_struct *cmd = grp->commands;
+	int i;
 	int do_sep = 0;
 
-	for (; cmd->token; cmd++) {
+	for (i = 0; grp->commands[i]; i++) {
+		const struct cmd_struct *cmd = grp->commands[i];
 		if (cmd->flags & CMD_HIDDEN)
 			continue;
 
-		if (full && cmd != grp->commands)
+		if (full && i)
 			fputc('\n', outf);
 
 		if (!cmd->next) {
@@ -274,7 +275,7 @@ static void usage_command_group_internal(const struct cmd_group *grp, bool full,
 
 		/* this is an entry point to a nested command group */
 
-		if (!full && cmd != grp->commands)
+		if (!full && i)
 			fputc('\n', outf);
 
 		usage_command_group_internal(cmd->next, full, outf);
@@ -289,6 +290,7 @@ void usage_command_group_short(const struct cmd_group *grp)
 	const char * const *usagestr = grp->usagestr;
 	FILE *outf = stdout;
 	const struct cmd_struct *cmd;
+	int i;
 
 	if (usagestr && *usagestr) {
 		fprintf(outf, "usage: %s\n", *usagestr++);
@@ -299,7 +301,8 @@ void usage_command_group_short(const struct cmd_group *grp)
 	fputc('\n', outf);
 
 	fprintf(outf, "Command groups:\n");
-	for (cmd = grp->commands; cmd->token; cmd++) {
+	for (i = 0; grp->commands[i]; i++) {
+		cmd = grp->commands[i];
 		if (cmd->flags & CMD_HIDDEN)
 			continue;
 
@@ -310,7 +313,8 @@ void usage_command_group_short(const struct cmd_group *grp)
 	}
 
 	fprintf(outf, "\nCommands:\n");
-	for (cmd = grp->commands; cmd->token; cmd++) {
+	for (i = 0; grp->commands[i]; i++) {
+		cmd = grp->commands[i];
 		if (cmd->flags & CMD_HIDDEN)
 			continue;
 
@@ -358,12 +362,13 @@ void help_unknown_token(const char *arg, const struct cmd_group *grp)
 __attribute__((noreturn))
 void help_ambiguous_token(const char *arg, const struct cmd_group *grp)
 {
-	const struct cmd_struct *cmd = grp->commands;
+	int i;
 
 	fprintf(stderr, "%s: ambiguous token '%s'\n", get_argv0_buf(), arg);
 	fprintf(stderr, "\nDid you mean one of these ?\n");
 
-	for (; cmd->token; cmd++) {
+	for (i = 0; grp->commands[i]; i++) {
+		const struct cmd_struct *cmd = grp->commands[i];
 		if (!prefixcmp(cmd->token, arg))
 			fprintf(stderr, "\t%s\n", cmd->token);
 	}
-- 
2.12.3

