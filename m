Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55606 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753240AbbFXQJw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Jun 2015 12:09:52 -0400
Received: from pps.filterd (m0004348 [127.0.0.1])
	by m0004348.ppops.net (8.14.5/8.14.5) with SMTP id t5OG8lqA010497
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2015 09:09:52 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by m0004348.ppops.net with ESMTP id 1v7vwk0b4h-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2015 09:09:52 -0700
From: Omar Sandoval <osandov@fb.com>
To: <linux-btrfs@vger.kernel.org>
CC: Omar Sandoval <osandov@fb.com>
Subject: [PATCH 2/2] btrfs-progs: alias btrfs device delete to btrfs device remove
Date: Wed, 24 Jun 2015 09:09:17 -0700
Message-ID: <4987361b608f2ff84d7c525afe859e5675fdfe85.1435161735.git.osandov@fb.com>
In-Reply-To: <cover.1435161735.git.osandov@fb.com>
References: <cover.1435161735.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There's an awkward asymmetry between btrfs device add and btrfs device
delete. Resolve this by aliasing delete to remove.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 Documentation/btrfs-device.asciidoc |  5 ++++-
 cmds-device.c                       | 35 ++++++++++++++++++++++++++---------
 commands.h                          |  1 +
 help.c                              | 10 ++++++----
 4 files changed, 37 insertions(+), 14 deletions(-)

diff --git a/Documentation/btrfs-device.asciidoc b/Documentation/btrfs-device.asciidoc
index c56cf5ef48fb..2827598a37f5 100644
--- a/Documentation/btrfs-device.asciidoc
+++ b/Documentation/btrfs-device.asciidoc
@@ -74,9 +74,12 @@ do not perform discard by default
 -f|--force::::
 force overwrite of existing filesystem on the given disk(s)
 
-*delete* <dev> [<dev>...] <path>::
+*remove* <dev> [<dev>...] <path>::
 Remove device(s) from a filesystem identified by <path>.
 
+*delete* <dev> [<dev>...] <path>::
+Alias of remove kept for backwards compatability
+
 *ready* <device>::
 Check device to see if it has all of it's devices in cache for mounting.
 
diff --git a/cmds-device.c b/cmds-device.c
index 1022656988c2..6972156fdf70 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -144,20 +144,14 @@ error_out:
 	return !!ret;
 }
 
-static const char * const cmd_rm_dev_usage[] = {
-	"btrfs device delete <device> [<device>...] <path>",
-	"Remove a device from a filesystem",
-	NULL
-};
-
-static int cmd_rm_dev(int argc, char **argv)
+static int _cmd_rm_dev(int argc, char **argv, const char * const *usagestr)
 {
 	char	*mntpnt;
 	int	i, fdmnt, ret=0, e;
 	DIR	*dirstream = NULL;
 
 	if (check_argc_min(argc, 3))
-		usage(cmd_rm_dev_usage);
+		usage(usagestr);
 
 	mntpnt = argv[argc - 1];
 
@@ -198,6 +192,28 @@ static int cmd_rm_dev(int argc, char **argv)
 	return !!ret;
 }
 
+static const char * const cmd_rm_dev_usage[] = {
+	"btrfs device remove <device> [<device>...] <path>",
+	"Remove a device from a filesystem",
+	NULL
+};
+
+static int cmd_rm_dev(int argc, char **argv)
+{
+	return _cmd_rm_dev(argc, argv, cmd_rm_dev_usage);
+}
+
+static const char * const cmd_del_dev_usage[] = {
+	"btrfs device delete <device> [<device>...] <path>",
+	"Remove a device from a filesystem",
+	NULL
+};
+
+static int cmd_del_dev(int argc, char **argv)
+{
+	return _cmd_rm_dev(argc, argv, cmd_del_dev_usage);
+}
+
 static const char * const cmd_scan_dev_usage[] = {
 	"btrfs device scan [(-d|--all-devices)|<device> [<device>...]]",
 	"Scan devices for a btrfs filesystem",
@@ -586,7 +602,8 @@ out:
 const struct cmd_group device_cmd_group = {
 	device_cmd_group_usage, NULL, {
 		{ "add", cmd_add_dev, cmd_add_dev_usage, NULL, 0 },
-		{ "delete", cmd_rm_dev, cmd_rm_dev_usage, NULL, 0 },
+		{ "delete", cmd_del_dev, cmd_del_dev_usage, NULL, CMD_ALIAS },
+		{ "remove", cmd_rm_dev, cmd_rm_dev_usage, NULL, 0 },
 		{ "scan", cmd_scan_dev, cmd_scan_dev_usage, NULL, 0 },
 		{ "ready", cmd_ready_dev, cmd_ready_dev_usage, NULL, 0 },
 		{ "stats", cmd_dev_stats, cmd_dev_stats_usage, NULL, 0 },
diff --git a/commands.h b/commands.h
index 42d31781f1a3..90bbd05a3542 100644
--- a/commands.h
+++ b/commands.h
@@ -19,6 +19,7 @@
 
 enum {
 	CMD_HIDDEN = (1 << 0),	/* should not be in help listings */
+	CMD_ALIAS = (1 << 1),	/* alias of next command in cmd_group */
 };
 
 struct cmd_struct {
diff --git a/help.c b/help.c
index 34754c16e6fe..6ecf01d57b83 100644
--- a/help.c
+++ b/help.c
@@ -81,11 +81,13 @@ static int do_usage_one_command(const char * const *usagestr,
 
 static int usage_command_internal(const char * const *usagestr,
 				  const char *token, int full, int lst,
-				  FILE *outf)
+				  int alias, FILE *outf)
 {
-	unsigned int flags = USAGE_SHORT;
+	unsigned int flags = 0;
 	int ret;
 
+	if (!alias)
+		flags |= USAGE_SHORT;
 	if (full)
 		flags |= USAGE_LONG | USAGE_OPTIONS;
 	if (lst)
@@ -110,7 +112,7 @@ static void usage_command_usagestr(const char * const *usagestr,
 	FILE *outf = err ? stderr : stdout;
 	int ret;
 
-	ret = usage_command_internal(usagestr, token, full, 0, outf);
+	ret = usage_command_internal(usagestr, token, full, 0, 0, outf);
 	if (!ret)
 		fputc('\n', outf);
 }
@@ -146,7 +148,7 @@ static void usage_command_group_internal(const struct cmd_group *grp, int full,
 			}
 
 			usage_command_internal(cmd->usagestr, cmd->token, full,
-					       1, outf);
+					       1, cmd->flags & CMD_ALIAS, outf);
 			continue;
 		}
 
-- 
2.4.4

