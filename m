Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35992 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751526AbbFRWHS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Jun 2015 18:07:18 -0400
Received: from pps.filterd (m0004003 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id t5IM4XG1023397
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Jun 2015 15:07:17 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0b-00082601.pphosted.com with ESMTP id 1v43sa0ptr-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Jun 2015 15:07:17 -0700
From: Omar Sandoval <osandov@fb.com>
To: <linux-btrfs@vger.kernel.org>
CC: Omar Sandoval <osandov@fb.com>
Subject: [PATCH] btrfs-progs: alias btrfs device delete to btrfs device remove
Date: Thu, 18 Jun 2015 15:07:09 -0700
Message-ID: <83c7d294299d9b66238f7369b1171c24d35b9294.1434508872.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There's an awkward asymmetry between btrfs device add and btrfs device
delete. Resolve this by aliasing delete to remove.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 Documentation/btrfs-device.asciidoc |  5 ++++-
 cmds-device.c                       | 33 +++++++++++++++++++++++++++------
 2 files changed, 31 insertions(+), 7 deletions(-)

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
index 1022656988c2..0e1ea94a0e41 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -145,20 +145,17 @@ error_out:
 }
 
 static const char * const cmd_rm_dev_usage[] = {
-	"btrfs device delete <device> [<device>...] <path>",
+	"btrfs device remove <device> [<device>...] <path>",
 	"Remove a device from a filesystem",
 	NULL
 };
 
-static int cmd_rm_dev(int argc, char **argv)
+static int _cmd_rm_dev(int argc, char **argv)
 {
 	char	*mntpnt;
 	int	i, fdmnt, ret=0, e;
 	DIR	*dirstream = NULL;
 
-	if (check_argc_min(argc, 3))
-		usage(cmd_rm_dev_usage);
-
 	mntpnt = argv[argc - 1];
 
 	fdmnt = open_file_or_dir(mntpnt, &dirstream);
@@ -198,6 +195,29 @@ static int cmd_rm_dev(int argc, char **argv)
 	return !!ret;
 }
 
+static int cmd_rm_dev(int argc, char **argv)
+{
+	if (check_argc_min(argc, 3))
+		usage(cmd_rm_dev_usage);
+
+	return _cmd_rm_dev(argc, argv);
+}
+
+
+static const char * const cmd_del_dev_usage[] = {
+	"btrfs device delete <device> [<device>...] <path>",
+	"Remove a device from a filesystem (alias of remove)",
+	NULL
+};
+
+static int cmd_del_dev(int argc, char **argv)
+{
+	if (check_argc_min(argc, 3))
+		usage(cmd_del_dev_usage);
+
+	return _cmd_rm_dev(argc, argv);
+}
+
 static const char * const cmd_scan_dev_usage[] = {
 	"btrfs device scan [(-d|--all-devices)|<device> [<device>...]]",
 	"Scan devices for a btrfs filesystem",
@@ -586,12 +606,13 @@ out:
 const struct cmd_group device_cmd_group = {
 	device_cmd_group_usage, NULL, {
 		{ "add", cmd_add_dev, cmd_add_dev_usage, NULL, 0 },
-		{ "delete", cmd_rm_dev, cmd_rm_dev_usage, NULL, 0 },
+		{ "remove", cmd_rm_dev, cmd_rm_dev_usage, NULL, 0 },
 		{ "scan", cmd_scan_dev, cmd_scan_dev_usage, NULL, 0 },
 		{ "ready", cmd_ready_dev, cmd_ready_dev_usage, NULL, 0 },
 		{ "stats", cmd_dev_stats, cmd_dev_stats_usage, NULL, 0 },
 		{ "usage", cmd_device_usage,
 			cmd_device_usage_usage, NULL, 0 },
+		{ "delete", cmd_del_dev, cmd_del_dev_usage, NULL, 0 },
 		NULL_CMD_STRUCT
 	}
 };
-- 
2.4.3

