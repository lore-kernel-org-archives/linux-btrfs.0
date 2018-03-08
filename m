Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60641 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935205AbeCHClI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 21:41:08 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 37D07AF98
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 02:41:06 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 17/20] btrfs-progs: add support for output formats
Date: Wed,  7 Mar 2018 21:40:44 -0500
Message-Id: <20180308024047.10104-18-jeffm@suse.com>
In-Reply-To: <20180308024047.10104-1-jeffm@suse.com>
References: <20180308024047.10104-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

This adds a global --format option to request extended output formats
from each command.  Most of it is plumbing a new cmd_context structure
that's established at the beginning of argument parsing into the command
callbacks.  That structure currently only contains the output mode enum.

We currently only support text mode.  Command help reports what
output formats are available for each command.  Global help reports
what valid formats are.

If an invalid format is requested, an error is reported and we global usage
is dumped that lists the valid formats.

Each command sets a bitmask that describes which formats it is capable
of outputting.  If a globally valid format is requested of a command
that doesn't support it, an error is reported and command usage dumped.

Commands don't need to specify that they support text output.  All
commands are required to output text.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 btrfs-debug-tree.c        |   3 +-
 btrfs.c                   | 110 ++++++++++++++++++++++++++++++++++++++--------
 check/main.c              |   3 +-
 cmds-balance.c            |  16 +++++--
 cmds-device.c             |  31 +++++++++----
 cmds-fi-du.c              |   1 +
 cmds-fi-usage.c           |   1 +
 cmds-filesystem.c         |  14 ++++--
 cmds-inspect-dump-super.c |   1 +
 cmds-inspect-dump-tree.c  |   1 +
 cmds-inspect-tree-stats.c |   1 +
 cmds-inspect.c            |  10 ++++-
 cmds-property.c           |   6 ++-
 cmds-qgroup.c             |  17 +++++--
 cmds-quota.c              |  14 ++++--
 cmds-receive.c            |   3 +-
 cmds-replace.c            |   8 +++-
 cmds-rescue.c             |   9 +++-
 cmds-restore.c            |   3 +-
 cmds-scrub.c              |  21 ++++++---
 cmds-send.c               |   3 +-
 cmds-subvolume.c          |  24 +++++++---
 commands.h                |  32 +++++++++++---
 help.c                    |  51 ++++++++++++++++-----
 help.h                    |   2 +
 25 files changed, 301 insertions(+), 84 deletions(-)

diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
index 49a2e949..8cd05d53 100644
--- a/btrfs-debug-tree.c
+++ b/btrfs-debug-tree.c
@@ -26,6 +26,7 @@ int main(int argc, char **argv)
 {
 	const struct cmd_struct *cmd = &cmd_struct_inspect_dump_tree;
 	int ret;
+	struct cmd_context cmdcxt = {};
 
 	set_argv0(argv);
 
@@ -34,7 +35,7 @@ int main(int argc, char **argv)
 
 	radix_tree_init();
 
-	ret = cmd_execute(cmd, argc, argv);
+	ret = cmd_execute(cmd, &cmdcxt, argc, argv);
 
 	btrfs_close_all_devices();
 
diff --git a/btrfs.c b/btrfs.c
index 49128182..32b8e090 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -26,7 +26,7 @@
 #include "help.h"
 
 static const char * const btrfs_cmd_group_usage[] = {
-	"btrfs [--help] [--version] <group> [<group>...] <command> [<args>]",
+	"btrfs [--help] [--version] [--format <format>] <group> [<group>...] <command> [<args>]",
 	NULL
 };
 
@@ -98,13 +98,36 @@ parse_command_token(const char *arg, const struct cmd_group *grp)
 	return cmd;
 }
 
+static bool cmd_provides_output_format(const struct cmd_struct *cmd,
+				       const struct cmd_context *cmdcxt)
+{
+	if (!cmdcxt->output_mode)
+		return true;
+
+	return (1 << cmdcxt->output_mode) & cmd->cmd_format_flags;
+}
+
 static void handle_help_options_next_level(const struct cmd_struct *cmd,
-		int argc, char **argv)
+					   const struct cmd_context *cmdcxt,
+					   int argc, char **argv)
 {
+	int err = 0;
+
 	if (argc < 2)
 		return;
 
-	if (!strcmp(argv[1], "--help")) {
+	/* Check if the command can provide the requested output format */
+	if (!cmd->next && !cmd_provides_output_format(cmd, cmdcxt)) {
+		ASSERT(cmdcxt->output_mode >= 0);
+		ASSERT(cmdcxt->output_mode < CMD_OUTPUT_MAX);
+		fprintf(stderr,
+			"error: %s output is unsupported for this command.\n\n",
+			cmd_outputs[cmdcxt->output_mode]);
+
+		err = 1;
+	}
+
+	if (!strcmp(argv[1], "--help") || err) {
 		if (cmd->next) {
 			argc--;
 			argv++;
@@ -113,12 +136,13 @@ static void handle_help_options_next_level(const struct cmd_struct *cmd,
 			usage_command(cmd, true, false);
 		}
 
-		exit(0);
+		exit(err);
 	}
 }
 
-int handle_command_group(const struct cmd_group *grp, int argc,
-			 char **argv)
+int handle_command_group(const struct cmd_group *grp,
+			 const struct cmd_context *cmdcxt,
+			 int argc, char **argv)
 
 {
 	const struct cmd_struct *cmd;
@@ -132,10 +156,10 @@ int handle_command_group(const struct cmd_group *grp, int argc,
 
 	cmd = parse_command_token(argv[0], grp);
 
-	handle_help_options_next_level(cmd, argc, argv);
+	handle_help_options_next_level(cmd, cmdcxt, argc, argv);
 
 	fixup_argv0(argv, cmd->token);
-	return cmd_execute(cmd, argc, argv);
+	return cmd_execute(cmd, cmdcxt, argc, argv);
 }
 
 static const struct cmd_group btrfs_cmd_group;
@@ -148,7 +172,8 @@ static const char * const cmd_help_usage[] = {
 	NULL
 };
 
-static int cmd_help(const struct cmd_struct *unused, int argc, char **argv)
+static int cmd_help(const struct cmd_struct *unused,
+		    const struct cmd_context *cmdcxt, int argc, char **argv)
 {
 	help_command_group(&btrfs_cmd_group, argc, argv);
 	return 0;
@@ -162,25 +187,66 @@ static const char * const cmd_version_usage[] = {
 	NULL
 };
 
-static int cmd_version(const struct cmd_struct *unused, int argc, char **argv)
+static int cmd_version(const struct cmd_struct *unused,
+		       const struct cmd_context *cmdcxt, int argc, char **argv)
 {
 	printf("%s\n", PACKAGE_STRING);
 	return 0;
 }
 static DEFINE_SIMPLE_COMMAND(version, "version");
 
+static void print_output_formats(FILE *outf)
+{
+	int i;
+
+	fputs("Options for --format are:", outf);
+	for (i = 0; i < CMD_OUTPUT_MAX; i++)
+		fprintf(outf, "%s\"%s\"", i ? ", " : " ", cmd_outputs[i]);
+	fputs("\n", outf);
+
+	/* No extended formats anywhere */
+	if (CMD_OUTPUT_TEXT + 1 != CMD_OUTPUT_MAX)
+		fputs("Extended output formats may not be available for all commands.\n",
+		      outf);
+}
+
+static void handle_output_format(struct cmd_context *cmdcxt,
+				 const char *format)
+{
+	int i;
+
+	for (i = 0; i < CMD_OUTPUT_MAX; i++) {
+		if (!strcasecmp(format, cmd_outputs[i])) {
+			cmdcxt->output_mode = i;
+			break;
+		}
+	}
+
+	/* Print error and usage for invalid format */
+	if (i == CMD_OUTPUT_MAX) {
+		cmdcxt->output_mode = CMD_OUTPUT_TEXT;
+		fprintf(stderr, "error: invalid output format \"%s\"\n\n",
+			format);
+		usage_command_group(&btrfs_cmd_group, false, true);
+		print_output_formats(stderr);
+		exit(1);
+	}
+}
+
 /*
  * Parse global options, between binary name and first non-option argument
  * after processing all valid options (including those with arguments).
  *
  * Returns index to argv where parsting stopped, optind is reset to 1
  */
-static int handle_global_options(int argc, char **argv)
+static int handle_global_options(struct cmd_context *cmdcxt,
+				 int argc, char **argv)
 {
-	enum { OPT_HELP = 256, OPT_VERSION, OPT_FULL };
+	enum { OPT_HELP = 256, OPT_VERSION, OPT_FULL, OPT_FORMAT };
 	static const struct option long_options[] = {
 		{ "help", no_argument, NULL, OPT_HELP },
 		{ "version", no_argument, NULL, OPT_VERSION },
+		{ "format", required_argument, NULL, OPT_FORMAT },
 		{ "full", no_argument, NULL, OPT_FULL },
 		{ NULL, 0, NULL, 0}
 	};
@@ -201,6 +267,9 @@ static int handle_global_options(int argc, char **argv)
 		case OPT_HELP: break;
 		case OPT_VERSION: break;
 		case OPT_FULL: break;
+		case OPT_FORMAT:
+			handle_output_format(cmdcxt, optarg);
+			break;
 		default:
 			fprintf(stderr, "Unknown global option: %s\n",
 					argv[optind - 1]);
@@ -214,7 +283,8 @@ static int handle_global_options(int argc, char **argv)
 	return shift;
 }
 
-void handle_special_globals(int shift, int argc, char **argv)
+void handle_special_globals(const struct cmd_context *cmdcxt, int shift,
+			    int argc, char **argv)
 {
 	bool has_help = false;
 	bool has_full = false;
@@ -231,13 +301,14 @@ void handle_special_globals(int shift, int argc, char **argv)
 		if (has_full)
 			usage_command_group(&btrfs_cmd_group, true, false);
 		else
-			cmd_execute(&cmd_struct_help, argc, argv);
+			cmd_execute(&cmd_struct_help, cmdcxt, argc, argv);
+		print_output_formats(stdout);
 		exit(0);
 	}
 
 	for (i = 0; i < shift; i++)
 		if (strcmp(argv[i], "--version") == 0) {
-			cmd_execute(&cmd_struct_version, argc, argv);
+			cmd_execute(&cmd_struct_version, cmdcxt, argc, argv);
 			exit(0);
 		}
 }
@@ -269,6 +340,7 @@ int main(int argc, char **argv)
 {
 	const struct cmd_struct *cmd;
 	const char *bname;
+	struct cmd_context cmdcxt = { .output_mode = CMD_OUTPUT_TEXT, };
 	int ret;
 
 	btrfs_config_init();
@@ -283,8 +355,8 @@ int main(int argc, char **argv)
 	} else {
 		int shift;
 
-		shift = handle_global_options(argc, argv);
-		handle_special_globals(shift, argc, argv);
+		shift = handle_global_options(&cmdcxt, argc, argv);
+		handle_special_globals(&cmdcxt, shift, argc, argv);
 		while (shift-- > 0) {
 			argc--;
 			argv++;
@@ -297,13 +369,13 @@ int main(int argc, char **argv)
 
 	cmd = parse_command_token(argv[0], &btrfs_cmd_group);
 
-	handle_help_options_next_level(cmd, argc, argv);
+	handle_help_options_next_level(cmd, &cmdcxt, argc, argv);
 
 	crc32c_optimization_init();
 
 	fixup_argv0(argv, cmd->token);
 
-	ret = cmd_execute(cmd, argc, argv);
+	ret = cmd_execute(cmd, &cmdcxt, argc, argv);
 
 	btrfs_close_all_devices();
 
diff --git a/check/main.c b/check/main.c
index 0bb8633a..6c74ca8f 100644
--- a/check/main.c
+++ b/check/main.c
@@ -9440,7 +9440,8 @@ static const char * const cmd_check_usage[] = {
 	NULL
 };
 
-static int cmd_check(const struct cmd_struct *cmd, int argc, char **argv)
+static int cmd_check(const struct cmd_struct *cmd,
+		     const struct cmd_context *cmdcxt, int argc, char **argv)
 {
 	struct cache_tree root_cache;
 	struct btrfs_root *root;
diff --git a/cmds-balance.c b/cmds-balance.c
index c639459f..c17b9ee3 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -516,6 +516,7 @@ static const char * const cmd_balance_start_usage[] = {
 };
 
 static int cmd_balance_start(const struct cmd_struct *cmd,
+			     const struct cmd_context *cmdcxt,
 			     int argc, char **argv)
 {
 	struct btrfs_ioctl_balance_args args;
@@ -682,6 +683,7 @@ static const char * const cmd_balance_pause_usage[] = {
 };
 
 static int cmd_balance_pause(const struct cmd_struct *cmd,
+			     const struct cmd_context *cmdcxt,
 			     int argc, char **argv)
 {
 	const char *path;
@@ -722,6 +724,7 @@ static const char * const cmd_balance_cancel_usage[] = {
 };
 
 static int cmd_balance_cancel(const struct cmd_struct *cmd,
+			      const struct cmd_context *cmdcxt,
 			      int argc, char **argv)
 {
 	const char *path;
@@ -762,6 +765,7 @@ static const char * const cmd_balance_resume_usage[] = {
 };
 
 static int cmd_balance_resume(const struct cmd_struct *cmd,
+			      const struct cmd_context *cmdcxt,
 			      int argc, char **argv)
 {
 	struct btrfs_ioctl_balance_args args;
@@ -831,6 +835,7 @@ static const char * const cmd_balance_status_usage[] = {
  *   0 : When there is no pending balance or completed
  */
 static int cmd_balance_status(const struct cmd_struct *cmd,
+			      const struct cmd_context *cmdcxt,
 			      int argc, char **argv)
 {
 	struct btrfs_ioctl_balance_args args;
@@ -909,7 +914,9 @@ out:
 }
 static DEFINE_SIMPLE_COMMAND(balance_status, "status");
 
-static int cmd_balance_full(const struct cmd_struct *cmd, int argc, char **argv)
+static int cmd_balance_full(const struct cmd_struct *cmd,
+			    const struct cmd_context *cmdcxt,
+			    int argc, char **argv)
 {
 	struct btrfs_ioctl_balance_args args;
 
@@ -919,7 +926,7 @@ static int cmd_balance_full(const struct cmd_struct *cmd, int argc, char **argv)
 	return do_balance(argv[1], &args, BALANCE_START_NOWARN);
 }
 static DEFINE_COMMAND(balance_full, "--full-balance", cmd_balance_full,
-		      NULL, NULL, CMD_HIDDEN);
+		      NULL, NULL, CMD_HIDDEN, 0);
 
 static const char balance_cmd_group_info[] =
 "balance data across devices, or change block groups using filters";
@@ -936,7 +943,8 @@ static const struct cmd_group balance_cmd_group = {
 	}
 };
 
-static int cmd_balance(const struct cmd_struct *unused, int argc, char **argv)
+static int cmd_balance(const struct cmd_struct *unused,
+		       const struct cmd_context *cmdcxt, int argc, char **argv)
 {
 	if (argc == 2 && strcmp("start", argv[1]) != 0) {
 		/* old 'btrfs filesystem balance <path>' syntax */
@@ -948,7 +956,7 @@ static int cmd_balance(const struct cmd_struct *unused, int argc, char **argv)
 		return do_balance(argv[1], &args, 0);
 	}
 
-	return handle_command_group(&balance_cmd_group, argc, argv);
+	return handle_command_group(&balance_cmd_group, cmdcxt, argc, argv);
 }
 
 DEFINE_GROUP_COMMAND(balance, "balance");
diff --git a/cmds-device.c b/cmds-device.c
index 6c74ca8e..ac9e82b1 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -49,6 +49,7 @@ static const char * const cmd_device_add_usage[] = {
 };
 
 static int cmd_device_add(const struct cmd_struct *cmd,
+			  const struct cmd_context *cmdcxt,
 			  int argc, char **argv)
 {
 	char	*mntpnt;
@@ -144,6 +145,7 @@ error_out:
 static DEFINE_SIMPLE_COMMAND(device_add, "add");
 
 static int _cmd_device_remove(const struct cmd_struct *cmd,
+			      const struct cmd_context *cmdcxt,
 			      int argc, char **argv)
 {
 	char	*mntpnt;
@@ -238,9 +240,10 @@ static const char * const cmd_device_remove_usage[] = {
 };
 
 static int cmd_device_remove(const struct cmd_struct *cmd,
+			     const struct cmd_context *cmdcxt,
 			     int argc, char **argv)
 {
-	return _cmd_device_remove(cmd, argc, argv);
+	return _cmd_device_remove(cmd, cmdcxt, argc, argv);
 }
 static DEFINE_SIMPLE_COMMAND(device_remove, "remove");
 
@@ -253,12 +256,13 @@ static const char * const cmd_device_delete_usage[] = {
 };
 
 static int cmd_device_delete(const struct cmd_struct *cmd,
+			     const struct cmd_context *cmdcxt,
 			     int argc, char **argv)
 {
-	return _cmd_device_remove(cmd, argc, argv);
+	return _cmd_device_remove(cmd, cmdcxt, argc, argv);
 }
 static DEFINE_COMMAND(device_delete, "delete", cmd_device_delete,
-		      cmd_device_delete_usage, NULL, CMD_ALIAS);
+		      cmd_device_delete_usage, NULL, CMD_ALIAS, 0);
 
 static const char * const cmd_device_scan_usage[] = {
 	"btrfs device scan [(-d|--all-devices)|<device> [<device>...]]",
@@ -267,7 +271,9 @@ static const char * const cmd_device_scan_usage[] = {
 	NULL
 };
 
-static int cmd_device_scan(const struct cmd_struct *cmd, int argc, char **argv)
+static int cmd_device_scan(const struct cmd_struct *cmd,
+			   const struct cmd_context *cmdcxt,
+			   int argc, char **argv)
 {
 	int i;
 	int devstart;
@@ -340,7 +346,9 @@ static const char * const cmd_device_ready_usage[] = {
 	NULL
 };
 
-static int cmd_device_ready(const struct cmd_struct *cmd, int argc, char **argv)
+static int cmd_device_ready(const struct cmd_struct *cmd,
+			    const struct cmd_context *cmdcxt,
+			    int argc, char **argv)
 {
 	struct	btrfs_ioctl_vol_args args;
 	int	fd;
@@ -399,7 +407,9 @@ static const char * const cmd_device_stats_usage[] = {
 	NULL
 };
 
-static int cmd_device_stats(const struct cmd_struct *cmd, int argc, char **argv)
+static int cmd_device_stats(const struct cmd_struct *cmd,
+			    const struct cmd_context *cmdcxt,
+			    int argc, char **argv)
 {
 	char *dev_path;
 	struct btrfs_ioctl_fs_info_args fi_args;
@@ -565,7 +575,9 @@ out:
 	return ret;
 }
 
-static int cmd_device_usage(const struct cmd_struct *cmd, int argc, char **argv)
+static int cmd_device_usage(const struct cmd_struct *cmd,
+			    const struct cmd_context *cmdcxt,
+			    int argc, char **argv)
 {
 	unsigned unit_mode;
 	int ret = 0;
@@ -618,8 +630,9 @@ static const struct cmd_group device_cmd_group = {
 	}
 };
 
-static int cmd_device(const struct cmd_struct *unused, int argc, char **argv)
+static int cmd_device(const struct cmd_struct *unused,
+		      const struct cmd_context *cmdcxt, int argc, char **argv)
 {
-	return handle_command_group(&device_cmd_group, argc, argv);
+	return handle_command_group(&device_cmd_group, cmdcxt, argc, argv);
 }
 DEFINE_GROUP_COMMAND_TOKEN(device);
diff --git a/cmds-fi-du.c b/cmds-fi-du.c
index ebcb0c15..c85c0063 100644
--- a/cmds-fi-du.c
+++ b/cmds-fi-du.c
@@ -558,6 +558,7 @@ static const char * const cmd_filesystem_du_usage[] = {
 };
 
 static int cmd_filesystem_du(const struct cmd_struct *cmd,
+			     const struct cmd_context *cmdcxt,
 			     int argc, char **argv)
 {
 	int ret = 0, err = 0;
diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
index 6da96411..5d220cc2 100644
--- a/cmds-fi-usage.c
+++ b/cmds-fi-usage.c
@@ -966,6 +966,7 @@ static const char * const cmd_filesystem_usage_usage[] = {
 };
 
 static int cmd_filesystem_usage(const struct cmd_struct *cmd,
+				const struct cmd_context *cmdcxt,
 				int argc, char **argv)
 {
 	int ret = 0;
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 8ddb7ea5..27e0865c 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -116,6 +116,7 @@ static void print_df(struct btrfs_ioctl_space_args *sargs, unsigned unit_mode)
 }
 
 static int cmd_filesystem_df(const struct cmd_struct *cmd,
+			     const struct cmd_context *cmdcxt,
 			     int argc, char **argv)
 {
 	struct btrfs_ioctl_space_args *sargs = NULL;
@@ -668,6 +669,7 @@ static const char * const cmd_filesystem_show_usage[] = {
 };
 
 static int cmd_filesystem_show(const struct cmd_struct *cmd,
+			       const struct cmd_context *cmdcxt,
 			       int argc, char **argv)
 {
 	LIST_HEAD(all_uuids);
@@ -816,6 +818,7 @@ static const char * const cmd_filesystem_sync_usage[] = {
 };
 
 static int cmd_filesystem_sync(const struct cmd_struct *cmd,
+			       const struct cmd_context *cmdcxt,
 			       int argc, char **argv)
 {
 	int 	fd, res;
@@ -914,6 +917,7 @@ error:
 }
 
 static int cmd_filesystem_defrag(const struct cmd_struct *cmd,
+				 const struct cmd_context *cmdcxt,
 				 int argc, char **argv)
 {
 	int fd;
@@ -1094,6 +1098,7 @@ static const char * const cmd_filesystem_resize_usage[] = {
 };
 
 static int cmd_filesystem_resize(const struct cmd_struct *cmd,
+				 const struct cmd_context *cmdcxt,
 				 int argc, char **argv)
 {
 	struct btrfs_ioctl_vol_args	args;
@@ -1173,6 +1178,7 @@ static const char * const cmd_filesystem_label_usage[] = {
 };
 
 static int cmd_filesystem_label(const struct cmd_struct *cmd,
+				const struct cmd_context *cmdcxt,
 				int argc, char **argv)
 {
 	clean_args_no_options(cmd, argc, argv);
@@ -1203,9 +1209,10 @@ static const char * const cmd_filesystem_balance_usage[] = {
 };
 
 static int cmd_filesystem_balance(const struct cmd_struct *unused,
+				  const struct cmd_context *cmdcxt,
 				  int argc, char **argv)
 {
-	return cmd_execute(&cmd_struct_balance, argc, argv);
+	return cmd_execute(&cmd_struct_balance, cmdcxt, argc, argv);
 }
 
 /*
@@ -1215,7 +1222,7 @@ static int cmd_filesystem_balance(const struct cmd_struct *unused,
  * for historical compatibility and is hidden.
  */
 static DEFINE_COMMAND(filesystem_balance, "balance", cmd_filesystem_balance,
-		      cmd_filesystem_balance_usage, NULL, CMD_HIDDEN);
+		      cmd_filesystem_balance_usage, NULL, CMD_HIDDEN, 0);
 
 static const char filesystem_cmd_group_info[] =
 "overall filesystem tasks and information";
@@ -1236,8 +1243,9 @@ static const struct cmd_group filesystem_cmd_group = {
 };
 
 static int cmd_filesystem(const struct cmd_struct *unused,
+			  const struct cmd_context *cmdcxt,
 			  int argc, char **argv)
 {
-	return handle_command_group(&filesystem_cmd_group, argc, argv);
+	return handle_command_group(&filesystem_cmd_group, cmdcxt, argc, argv);
 }
 DEFINE_GROUP_COMMAND_TOKEN(filesystem);
diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index 6341d2ac..da171779 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -505,6 +505,7 @@ static const char * const cmd_inspect_dump_super_usage[] = {
 };
 
 static int cmd_inspect_dump_super(const struct cmd_struct *cmd,
+				  const struct cmd_context *cmdcxt,
 				  int argc, char **argv)
 {
 	int all = 0;
diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
index 22bc9cb9..9e0b950b 100644
--- a/cmds-inspect-dump-tree.c
+++ b/cmds-inspect-dump-tree.c
@@ -202,6 +202,7 @@ static const char * const cmd_inspect_dump_tree_usage[] = {
 };
 
 static int cmd_inspect_dump_tree(const struct cmd_struct *cmd,
+				 const struct cmd_context *cmdcxt,
 				 int argc, char **argv)
 {
 	struct btrfs_root *root;
diff --git a/cmds-inspect-tree-stats.c b/cmds-inspect-tree-stats.c
index e5e68562..768af025 100644
--- a/cmds-inspect-tree-stats.c
+++ b/cmds-inspect-tree-stats.c
@@ -428,6 +428,7 @@ static const char * const cmd_inspect_tree_stats_usage[] = {
 };
 
 static int cmd_inspect_tree_stats(const struct cmd_struct *cmd,
+				  const struct cmd_context *cmdcxt,
 				  int argc, char **argv)
 {
 	struct btrfs_key key;
diff --git a/cmds-inspect.c b/cmds-inspect.c
index bc86e999..ade9db7e 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -88,6 +88,7 @@ static const char * const cmd_inspect_inode_resolve_usage[] = {
 };
 
 static int cmd_inspect_inode_resolve(const struct cmd_struct *cmd,
+				     const struct cmd_context *cmdcxt,
 				     int argc, char **argv)
 {
 	int fd;
@@ -136,6 +137,7 @@ static const char * const cmd_inspect_logical_resolve_usage[] = {
 };
 
 static int cmd_inspect_logical_resolve(const struct cmd_struct *cmd,
+				       const struct cmd_context *cmdcxt,
 				       int argc, char **argv)
 {
 	int ret;
@@ -269,6 +271,7 @@ static const char * const cmd_inspect_subvolid_resolve_usage[] = {
 };
 
 static int cmd_inspect_subvolid_resolve(const struct cmd_struct *cmd,
+					const struct cmd_context *cmdcxt,
 					int argc, char **argv)
 {
 	int ret;
@@ -313,6 +316,7 @@ static const char* const cmd_inspect_rootid_usage[] = {
 };
 
 static int cmd_inspect_rootid(const struct cmd_struct *cmd,
+			      const struct cmd_context *cmdcxt,
 			      int argc, char **argv)
 {
 	int ret;
@@ -593,6 +597,7 @@ out:
 }
 
 static int cmd_inspect_min_dev_size(const struct cmd_struct *cmd,
+				    const struct cmd_context *cmdcxt,
 				    int argc, char **argv)
 {
 	int ret;
@@ -653,8 +658,9 @@ static const struct cmd_group inspect_cmd_group = {
 	}
 };
 
-static int cmd_inspect(const struct cmd_struct *unused, int argc, char **argv)
+static int cmd_inspect(const struct cmd_struct *unused,
+		       const struct cmd_context *cmdcxt, int argc, char **argv)
 {
-	return handle_command_group(&inspect_cmd_group, argc, argv);
+	return handle_command_group(&inspect_cmd_group, cmdcxt, argc, argv);
 }
 DEFINE_GROUP_COMMAND(inspect, "inspect");
diff --git a/cmds-property.c b/cmds-property.c
index 4aa2f18f..498fa456 100644
--- a/cmds-property.c
+++ b/cmds-property.c
@@ -341,6 +341,7 @@ static const char * const cmd_property_get_usage[] = {
 };
 
 static int cmd_property_get(const struct cmd_struct *cmd,
+			    const struct cmd_context *cmdcxt,
 			    int argc, char **argv)
 {
 	int ret;
@@ -368,6 +369,7 @@ static const char * const cmd_property_set_usage[] = {
 };
 
 static int cmd_property_set(const struct cmd_struct *cmd,
+			    const struct cmd_context *cmdcxt,
 			    int argc, char **argv)
 {
 	int ret;
@@ -393,6 +395,7 @@ static const char * const cmd_property_list_usage[] = {
 };
 
 static int cmd_property_list(const struct cmd_struct *cmd,
+			     const struct cmd_context *cmdcxt,
 			     int argc, char **argv)
 {
 	int ret;
@@ -420,8 +423,9 @@ static const struct cmd_group property_cmd_group = {
 };
 
 static int cmd_property(const struct cmd_struct *unused,
+			const struct cmd_context *cmdcxt,
 			int argc, char **argv)
 {
-	return handle_command_group(&property_cmd_group, argc, argv);
+	return handle_command_group(&property_cmd_group, cmdcxt, argc, argv);
 }
 DEFINE_GROUP_COMMAND_TOKEN(property);
diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 986f272c..f9e81e30 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -216,6 +216,7 @@ static const char * const cmd_qgroup_assign_usage[] = {
 };
 
 static int cmd_qgroup_assign(const struct cmd_struct *cmd,
+			     const struct cmd_context *cmdcxt,
 			     int argc, char **argv)
 {
 	return _cmd_qgroup_assign(cmd, 1, argc, argv);
@@ -229,6 +230,7 @@ static const char * const cmd_qgroup_remove_usage[] = {
 };
 
 static int cmd_qgroup_remove(const struct cmd_struct *cmd,
+			     const struct cmd_context *cmdcxt,
 			     int argc, char **argv)
 {
 	return _cmd_qgroup_assign(cmd, 0, argc, argv);
@@ -242,6 +244,7 @@ static const char * const cmd_qgroup_create_usage[] = {
 };
 
 static int cmd_qgroup_create(const struct cmd_struct *cmd,
+			     const struct cmd_context *cmdcxt,
 			     int argc, char **argv)
 {
 	int ret;
@@ -263,6 +266,7 @@ static const char * const cmd_qgroup_destroy_usage[] = {
 };
 
 static int cmd_qgroup_destroy(const struct cmd_struct *cmd,
+			      const struct cmd_context *cmdcxt,
 			      int argc, char **argv)
 {
 	int ret;
@@ -300,7 +304,9 @@ static const char * const cmd_qgroup_show_usage[] = {
 	NULL
 };
 
-static int cmd_qgroup_show(const struct cmd_struct *cmd, int argc, char **argv)
+static int cmd_qgroup_show(const struct cmd_struct *cmd,
+			   const struct cmd_context *cmdcxt,
+			   int argc, char **argv)
 {
 	char *path;
 	int ret = 0;
@@ -434,7 +440,9 @@ static const char * const cmd_qgroup_limit_usage[] = {
 	NULL
 };
 
-static int cmd_qgroup_limit(const struct cmd_struct *cmd, int argc, char **argv)
+static int cmd_qgroup_limit(const struct cmd_struct *cmd,
+			    const struct cmd_context *cmdcxt,
+			    int argc, char **argv)
 {
 	int ret = 0;
 	int fd;
@@ -532,8 +540,9 @@ static const struct cmd_group qgroup_cmd_group = {
 	}
 };
 
-static int cmd_qgroup(const struct cmd_struct *unused, int argc, char **argv)
+static int cmd_qgroup(const struct cmd_struct *unused,
+		      const struct cmd_context *cmdcxt, int argc, char **argv)
 {
-	return handle_command_group(&qgroup_cmd_group, argc, argv);
+	return handle_command_group(&qgroup_cmd_group, cmdcxt, argc, argv);
 }
 DEFINE_GROUP_COMMAND_TOKEN(qgroup);
diff --git a/cmds-quota.c b/cmds-quota.c
index c634c4e9..2a88d4c4 100644
--- a/cmds-quota.c
+++ b/cmds-quota.c
@@ -67,7 +67,9 @@ static const char * const cmd_quota_enable_usage[] = {
 	NULL
 };
 
-static int cmd_quota_enable(const struct cmd_struct *cmd, int argc, char **argv)
+static int cmd_quota_enable(const struct cmd_struct *cmd,
+			    const struct cmd_context *cmdcxt,
+			    int argc, char **argv)
 {
 	int ret;
 
@@ -88,6 +90,7 @@ static const char * const cmd_quota_disable_usage[] = {
 };
 
 static int cmd_quota_disable(const struct cmd_struct *cmd,
+			     const struct cmd_context *cmdcxt,
 			     int argc, char **argv)
 {
 	int ret;
@@ -111,7 +114,9 @@ static const char * const cmd_quota_rescan_usage[] = {
 	NULL
 };
 
-static int cmd_quota_rescan(const struct cmd_struct *cmd, int argc, char **argv)
+static int cmd_quota_rescan(const struct cmd_struct *cmd,
+			    const struct cmd_context *cmdcxt,
+			    int argc, char **argv)
 {
 	int ret = 0;
 	int fd;
@@ -214,8 +219,9 @@ static const struct cmd_group quota_cmd_group = {
 	}
 };
 
-static int cmd_quota(const struct cmd_struct *unused, int argc, char **argv)
+static int cmd_quota(const struct cmd_struct *unused,
+		     const struct cmd_context *cmdcxt, int argc, char **argv)
 {
-	return handle_command_group(&quota_cmd_group, argc, argv);
+	return handle_command_group(&quota_cmd_group, cmdcxt, argc, argv);
 }
 DEFINE_GROUP_COMMAND_TOKEN(quota);
diff --git a/cmds-receive.c b/cmds-receive.c
index 5429c607..57ce2272 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -1279,7 +1279,8 @@ static const char * const cmd_receive_usage[] = {
 	NULL
 };
 
-static int cmd_receive(const struct cmd_struct *cmd, int argc, char **argv)
+static int cmd_receive(const struct cmd_struct *cmd,
+		       const struct cmd_context *cmdcxt, int argc, char **argv)
 {
 	char *tomnt = NULL;
 	char fromfile[PATH_MAX];
diff --git a/cmds-replace.c b/cmds-replace.c
index 2057d69e..64c93537 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -115,6 +115,7 @@ static const char *const cmd_replace_start_usage[] = {
 };
 
 static int cmd_replace_start(const struct cmd_struct *cmd,
+			     const struct cmd_context *cmdcxt,
 			     int argc, char **argv)
 {
 	struct btrfs_ioctl_dev_replace_args start_args = {0};
@@ -327,6 +328,7 @@ static const char *const cmd_replace_status_usage[] = {
 };
 
 static int cmd_replace_status(const struct cmd_struct *cmd,
+			      const struct cmd_context *cmdcxt,
 			      int argc, char **argv)
 {
 	int fd;
@@ -497,6 +499,7 @@ static const char *const cmd_replace_cancel_usage[] = {
 };
 
 static int cmd_replace_cancel(const struct cmd_struct *cmd,
+			      const struct cmd_context *cmdcxt,
 			      int argc, char **argv)
 {
 	struct btrfs_ioctl_dev_replace_args args = {0};
@@ -557,8 +560,9 @@ static const struct cmd_group replace_cmd_group = {
 	}
 };
 
-static int cmd_replace(const struct cmd_struct *unused, int argc, char **argv)
+static int cmd_replace(const struct cmd_struct *unused,
+		       const struct cmd_context *cmdcxt, int argc, char **argv)
 {
-	return handle_command_group(&replace_cmd_group, argc, argv);
+	return handle_command_group(&replace_cmd_group, cmdcxt, argc, argv);
 }
 DEFINE_GROUP_COMMAND_TOKEN(replace);
diff --git a/cmds-rescue.c b/cmds-rescue.c
index f96d8010..ec1ea222 100644
--- a/cmds-rescue.c
+++ b/cmds-rescue.c
@@ -46,6 +46,7 @@ static const char * const cmd_rescue_chunk_recover_usage[] = {
 };
 
 static int cmd_rescue_chunk_recover(const struct cmd_struct *cmd,
+				    const struct cmd_context *cmdcxt,
 				    int argc, char *argv[])
 {
 	int ret = 0;
@@ -115,6 +116,7 @@ static const char * const cmd_rescue_super_recover_usage[] = {
  *   4 : Abort to recover bad superblocks
  */
 static int cmd_rescue_super_recover(const struct cmd_struct *cmd,
+				    const struct cmd_context *cmdcxt,
 				    int argc, char **argv)
 {
 	int ret;
@@ -162,6 +164,7 @@ static const char * const cmd_rescue_zero_log_usage[] = {
 };
 
 static int cmd_rescue_zero_log(const struct cmd_struct *cmd,
+			       const struct cmd_context *cmdcxt,
 			       int argc, char **argv)
 {
 	struct btrfs_root *root;
@@ -217,6 +220,7 @@ static const char * const cmd_rescue_fix_device_size_usage[] = {
 };
 
 static int cmd_rescue_fix_device_size(const struct cmd_struct *cmd,
+				      const struct cmd_context *cmdcxt,
 				      int argc, char **argv)
 {
 	struct btrfs_fs_info *fs_info;
@@ -269,8 +273,9 @@ static const struct cmd_group rescue_cmd_group = {
 	}
 };
 
-static int cmd_rescue(const struct cmd_struct *unused, int argc, char **argv)
+static int cmd_rescue(const struct cmd_struct *unused,
+		      const struct cmd_context *cmdcxt, int argc, char **argv)
 {
-	return handle_command_group(&rescue_cmd_group, argc, argv);
+	return handle_command_group(&rescue_cmd_group, cmdcxt, argc, argv);
 }
 DEFINE_GROUP_COMMAND_TOKEN(rescue);
diff --git a/cmds-restore.c b/cmds-restore.c
index 87cfb582..03c90cb6 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -1415,7 +1415,8 @@ static const char * const cmd_restore_usage[] = {
 	NULL
 };
 
-static int cmd_restore(const struct cmd_struct *cmd, int argc, char **argv)
+static int cmd_restore(const struct cmd_struct *cmd,
+		       const struct cmd_context *cmdcxt, int argc, char **argv)
 {
 	struct btrfs_root *root;
 	struct btrfs_key key;
diff --git a/cmds-scrub.c b/cmds-scrub.c
index 872c996b..d4d5a10c 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -1571,7 +1571,9 @@ static const char * const cmd_scrub_start_usage[] = {
 	NULL
 };
 
-static int cmd_scrub_start(const struct cmd_struct *cmd, int argc, char **argv)
+static int cmd_scrub_start(const struct cmd_struct *cmd,
+			   const struct cmd_context *cmdcxt,
+			   int argc, char **argv)
 {
 	return scrub_start(cmd, argc, argv, false);
 }
@@ -1583,7 +1585,9 @@ static const char * const cmd_scrub_cancel_usage[] = {
 	NULL
 };
 
-static int cmd_scrub_cancel(const struct cmd_struct *cmd, int argc, char **argv)
+static int cmd_scrub_cancel(const struct cmd_struct *cmd,
+			    const struct cmd_context *cmdcxt,
+			    int argc, char **argv)
 {
 	char *path;
 	int ret;
@@ -1638,7 +1642,9 @@ static const char * const cmd_scrub_resume_usage[] = {
 	NULL
 };
 
-static int cmd_scrub_resume(const struct cmd_struct *cmd, int argc, char **argv)
+static int cmd_scrub_resume(const struct cmd_struct *cmd,
+			    const struct cmd_context *cmdcxt,
+			    int argc, char **argv)
 {
 	return scrub_start(cmd, argc, argv, true);
 }
@@ -1653,7 +1659,9 @@ static const char * const cmd_scrub_status_usage[] = {
 	NULL
 };
 
-static int cmd_scrub_status(const struct cmd_struct *cmd, int argc, char **argv)
+static int cmd_scrub_status(const struct cmd_struct *cmd,
+			    const struct cmd_context *cmdcxt,
+			    int argc, char **argv)
 {
 	char *path;
 	struct btrfs_ioctl_fs_info_args fi_args;
@@ -1799,9 +1807,10 @@ static const struct cmd_group scrub_cmd_group = {
 	}
 };
 
-static int cmd_scrub(const struct cmd_struct *unused, int argc, char **argv)
+static int cmd_scrub(const struct cmd_struct *unused,
+		     const struct cmd_context *cmdcxt, int argc, char **argv)
 {
-	return handle_command_group(&scrub_cmd_group, argc, argv);
+	return handle_command_group(&scrub_cmd_group, cmdcxt, argc, argv);
 }
 
 DEFINE_GROUP_COMMAND_TOKEN(scrub);
diff --git a/cmds-send.c b/cmds-send.c
index e2d87785..c810f842 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -523,7 +523,8 @@ static const char * const cmd_send_usage[] = {
 	NULL
 };
 
-static int cmd_send(const struct cmd_struct *cmd, int argc, char **argv)
+static int cmd_send(const struct cmd_struct *cmd,
+		    const struct cmd_context *cmdcxt, int argc, char **argv)
 {
 	char *subvol = NULL;
 	int ret;
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index dc529315..3498ff21 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -117,6 +117,7 @@ static const char * const cmd_subvol_create_usage[] = {
 };
 
 static int cmd_subvol_create(const struct cmd_struct *cmd,
+			     const struct cmd_context *cmdcxt,
 			     int argc, char **argv)
 {
 	int	retval, res, len;
@@ -253,6 +254,7 @@ static const char * const cmd_subvol_delete_usage[] = {
 };
 
 static int cmd_subvol_delete(const struct cmd_struct *cmd,
+			     const struct cmd_context *cmdcxt,
 			     int argc, char **argv)
 {
 	int res, ret = 0;
@@ -479,7 +481,9 @@ static const char * const cmd_subvol_list_usage[] = {
 	NULL,
 };
 
-static int cmd_subvol_list(const struct cmd_struct *cmd, int argc, char **argv)
+static int cmd_subvol_list(const struct cmd_struct *cmd,
+			   const struct cmd_context *cmdcxt,
+			   int argc, char **argv)
 {
 	struct btrfs_list_filter_set *filter_set;
 	struct btrfs_list_comparer_set *comparer_set;
@@ -652,6 +656,7 @@ static const char * const cmd_subvol_snapshot_usage[] = {
 };
 
 static int cmd_subvol_snapshot(const struct cmd_struct *cmd,
+			       const struct cmd_context *cmdcxt,
 			       int argc, char **argv)
 {
 	char	*subvol, *dst;
@@ -803,6 +808,7 @@ static const char * const cmd_subvol_get_default_usage[] = {
 };
 
 static int cmd_subvol_get_default(const struct cmd_struct *cmd,
+				  const struct cmd_context *cmdcxt,
 				  int argc, char **argv)
 {
 	int fd = -1;
@@ -872,6 +878,7 @@ static const char * const cmd_subvol_set_default_usage[] = {
 };
 
 static int cmd_subvol_set_default(const struct cmd_struct *cmd,
+				  const struct cmd_context *cmdcxt,
 				  int argc, char **argv)
 {
 	int	ret=0, fd;
@@ -937,6 +944,7 @@ static const char * const cmd_subvol_find_new_usage[] = {
 };
 
 static int cmd_subvol_find_new(const struct cmd_struct *cmd,
+			       const struct cmd_context *cmdcxt,
 			       int argc, char **argv)
 {
 	int fd;
@@ -992,7 +1000,9 @@ static const char * const cmd_subvol_show_usage[] = {
 	NULL
 };
 
-static int cmd_subvol_show(const struct cmd_struct *cmd, int argc, char **argv)
+static int cmd_subvol_show(const struct cmd_struct *cmd,
+			   const struct cmd_context *cmdcxt,
+			   int argc, char **argv)
 {
 	struct root_info get_ri;
 	struct btrfs_list_filter_set *filter_set = NULL;
@@ -1343,7 +1353,9 @@ static int enumerate_dead_subvols(int fd, u64 **ids)
 	return idx;
 }
 
-static int cmd_subvol_sync(const struct cmd_struct *cmd, int argc, char **argv)
+static int cmd_subvol_sync(const struct cmd_struct *cmd,
+			   const struct cmd_context *cmdcxt,
+			   int argc, char **argv)
 {
 	int fd = -1;
 	int i;
@@ -1454,9 +1466,9 @@ static const struct cmd_group subvolume_cmd_group = {
 	}
 };
 
-static int cmd_subvolume(const struct cmd_struct *unused,
-			 int argc, char **argv)
+int cmd_subvolume(const struct cmd_struct *unused,
+		  const struct cmd_context *cmdcxt, int argc, char **argv)
 {
-	return handle_command_group(&subvolume_cmd_group, argc, argv);
+	return handle_command_group(&subvolume_cmd_group, cmdcxt, argc, argv);
 }
 DEFINE_GROUP_COMMAND_TOKEN(subvolume);
diff --git a/commands.h b/commands.h
index 4c5469ac..83316c6d 100644
--- a/commands.h
+++ b/commands.h
@@ -17,6 +17,17 @@
 #ifndef __BTRFS_COMMANDS_H__
 #define __BTRFS_COMMANDS_H__
 
+enum cmd_output {
+	CMD_OUTPUT_TEXT = 0,
+	CMD_OUTPUT_MAX,
+};
+
+#define CMD_OUTPUT_FLAG(x)	(1 << (CMD_OUTPUT_##x))
+
+struct cmd_context {
+	enum cmd_output output_mode;
+};
+
 enum {
 	CMD_HIDDEN = (1 << 0),	/* should not be in help listings */
 	CMD_ALIAS = (1 << 1),	/* alias of next command in cmd_group */
@@ -24,7 +35,8 @@ enum {
 
 struct cmd_struct {
 	const char *token;
-	int (*fn)(const struct cmd_struct *cmd, int argc, char **argv);
+	int (*fn)(const struct cmd_struct *cmd,
+		  const struct cmd_context *cmdcxt, int argc, char **argv);
 
 	/*
 	 * Usage strings
@@ -54,6 +66,8 @@ struct cmd_struct {
 
 	/* CMD_* flags above */
 	int flags;
+
+	unsigned int cmd_format_flags;
 };
 
 /*
@@ -65,7 +79,8 @@ struct cmd_struct {
 	extern const struct cmd_struct __CMD_NAME(name)
 
 /* Define a command with all members specified */
-#define DEFINE_COMMAND(name, _token, _fn, _usagestr, _group, _flags)	\
+#define DEFINE_COMMAND(name, _token, _fn, _usagestr, _group, _flags,	\
+		       _cmd_format_flags)				\
 	const struct cmd_struct __CMD_NAME(name) =			\
 		{							\
 			.token = (_token),				\
@@ -73,6 +88,7 @@ struct cmd_struct {
 			.usagestr = (_usagestr),			\
 			.next = (_group),				\
 			.flags = (_flags),				\
+			.cmd_format_flags = (_cmd_format_flags),	\
 		}
 
 /*
@@ -82,7 +98,7 @@ struct cmd_struct {
  */
 #define DEFINE_SIMPLE_COMMAND(name, token)				\
 	DEFINE_COMMAND(name, token, cmd_ ##name,			\
-		       cmd_ ##name ##_usage, NULL, 0)
+		       cmd_ ##name ##_usage, NULL, 0, 0)
 
 /*
  * Define a command group callback.
@@ -91,7 +107,7 @@ struct cmd_struct {
  */
 #define DEFINE_GROUP_COMMAND(name, token)				\
 	DEFINE_COMMAND(name, token, cmd_ ##name,			\
-		       NULL, &(name ## _cmd_group), 0)
+		       NULL, &(name ## _cmd_group), 0, 0)
 
 /*
  * Define a command group callback when the name and the string are
@@ -108,13 +124,15 @@ struct cmd_group {
 };
 
 static inline int cmd_execute(const struct cmd_struct *cmd,
+			      const struct cmd_context *cmdcxt,
 			      int argc, char **argv)
 {
-	return cmd->fn(cmd, argc, argv);
+	return cmd->fn(cmd, cmdcxt, argc, argv);
 }
 
-int handle_command_group(const struct cmd_group *grp, int argc,
-			 char **argv);
+int handle_command_group(const struct cmd_group *grp,
+			 const struct cmd_context *cmdcxt,
+			 int argc, char **argv);
 
 extern const char * const generic_cmd_help_usage[];
 
diff --git a/help.c b/help.c
index 6ee93161..063e9740 100644
--- a/help.c
+++ b/help.c
@@ -28,6 +28,11 @@
 #define USAGE_LONG		2U
 #define USAGE_OPTIONS		4U
 #define USAGE_LISTING		8U
+#define USAGE_FORMAT		16U
+
+const char *cmd_outputs[CMD_OUTPUT_MAX] = {
+	"text",
+};
 
 static char argv0_buf[ARGV0_BUF_SIZE] = "btrfs";
 
@@ -126,6 +131,7 @@ void clean_args_no_options_relaxed(const struct cmd_struct *cmd,
 }
 
 static int do_usage_one_command(const char * const *usagestr,
+				unsigned int format_flags,
 				unsigned int flags, FILE *outf)
 {
 	int pad = 4;
@@ -193,12 +199,32 @@ static int do_usage_one_command(const char * const *usagestr,
 	while (*usagestr)
 		fprintf(outf, "%*s%s\n", pad, "", *usagestr++);
 
+	if (flags & USAGE_FORMAT) {
+		/* We always support text */
+		format_flags |= (1 << CMD_OUTPUT_TEXT);
+
+		fputs("\n\tThis command supports output in ", outf);
+		if (format_flags == (1 << CMD_OUTPUT_TEXT))
+			fputs("text mode only.\n", outf);
+		else {
+			int i;
+
+			fputs("the following formats:", outf);
+			for (i = 0; i < CMD_OUTPUT_MAX; i++) {
+				if (format_flags & (1 << i))
+					fprintf(outf, " %s", cmd_outputs[i]);
+			}
+			fputs("\n", outf);
+		}
+	}
+
 	return 0;
 }
 
 static int usage_command_internal(const char * const *usagestr,
-				  const char *token, bool full, bool lst,
-				  bool alias, FILE *outf)
+				  const char *token,
+				  unsigned int format_flags, bool full,
+				  bool lst, bool alias, FILE *outf)
 {
 	unsigned int flags = 0;
 	int ret;
@@ -206,11 +232,11 @@ static int usage_command_internal(const char * const *usagestr,
 	if (!alias)
 		flags |= USAGE_SHORT;
 	if (full)
-		flags |= USAGE_LONG | USAGE_OPTIONS;
+		flags |= USAGE_LONG | USAGE_OPTIONS | USAGE_FORMAT;
 	if (lst)
 		flags |= USAGE_LISTING;
 
-	ret = do_usage_one_command(usagestr, flags, outf);
+	ret = do_usage_one_command(usagestr, format_flags, flags, outf);
 	switch (ret) {
 	case -1:
 		fprintf(outf, "No usage for '%s'\n", token);
@@ -224,25 +250,28 @@ static int usage_command_internal(const char * const *usagestr,
 }
 
 static void usage_command_usagestr(const char * const *usagestr,
-				   const char *token, bool full, bool err)
+				   const char *token, unsigned int format_flags,
+				   bool full, bool err)
 {
 	FILE *outf = err ? stderr : stdout;
 	int ret;
 
-	ret = usage_command_internal(usagestr, token, full, false, false, outf);
+	ret = usage_command_internal(usagestr, token, format_flags,
+				     full, false, false, outf);
 	if (!ret)
 		fputc('\n', outf);
 }
 
 void usage_command(const struct cmd_struct *cmd, bool full, bool err)
 {
-	usage_command_usagestr(cmd->usagestr, cmd->token, full, err);
+	usage_command_usagestr(cmd->usagestr, cmd->token,
+			       cmd->cmd_format_flags, full, err);
 }
 
 __attribute__((noreturn))
 void usage(const struct cmd_struct *cmd)
 {
-	usage_command_usagestr(cmd->usagestr, NULL, true, true);
+	usage_command_usagestr(cmd->usagestr, NULL, 0, true, true);
 	exit(1);
 }
 
@@ -266,7 +295,8 @@ static void usage_command_group_internal(const struct cmd_group *grp, bool full,
 				do_sep = 0;
 			}
 
-			usage_command_internal(cmd->usagestr, cmd->token, full,
+			usage_command_internal(cmd->usagestr, cmd->token,
+					       cmd->cmd_format_flags, full,
 					       true, cmd->flags & CMD_ALIAS,
 					       outf);
 			if (cmd->flags & CMD_ALIAS)
@@ -377,7 +407,8 @@ void help_ambiguous_token(const char *arg, const struct cmd_group *grp)
 	exit(1);
 }
 
-void help_command_group(const struct cmd_group *grp, int argc, char **argv)
+void help_command_group(const struct cmd_group *grp, int argc,
+			char **argv)
 {
 	bool full = false;
 
diff --git a/help.h b/help.h
index 7468cf8b..5b338a49 100644
--- a/help.h
+++ b/help.h
@@ -55,6 +55,8 @@
 struct cmd_struct;
 struct cmd_group;
 
+extern const char *cmd_outputs[];
+
 __attribute__((noreturn))
 void usage(const struct cmd_struct *cmd);
 void usage_command(const struct cmd_struct *cmd, bool full, bool err);
-- 
2.12.3

