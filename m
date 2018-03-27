Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:32429 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752055AbeC0HHV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 03:07:21 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id B3BC848AE76D
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 15:07:10 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 08/10] btrfs-progs: undelete-subvol: add undelete-subvol subcommand
Date: Tue, 27 Mar 2018 15:06:56 +0800
Message-ID: <20180327070658.13064-9-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180327070658.13064-1-lufq.fnst@cn.fujitsu.com>
References: <20180327070658.13064-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add the undelete-subvol subcommand for btrfs rescue. This subcommand is
used to recover deleted subvolume left intact on the device.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
v2: add -s option to specify subvol_id.

 cmds-rescue.c | 70 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/cmds-rescue.c b/cmds-rescue.c
index c40088ad374e..c5132126e922 100644
--- a/cmds-rescue.c
+++ b/cmds-rescue.c
@@ -25,6 +25,7 @@
 #include "disk-io.h"
 #include "commands.h"
 #include "utils.h"
+#include "undelete-subvol.h"
 #include "help.h"
 
 static const char * const rescue_cmd_group_usage[] = {
@@ -248,6 +249,73 @@ out:
 	return !!ret;
 }
 
+static const char * const cmd_rescue_undelete_subvol_usage[] = {
+	"btrfs rescue undelete-subvol [-s <subvolid>] <device>",
+	"Undelete deleted subvolume",
+	"All deleted subvolume that still left intact on the device will be",
+	"recovered. If -s <subvolid> option is given, then just recover the",
+	"subvolume which specified by <subvolid>.",
+	"",
+	"-s <subvolid>	specify the subvolume which will be recovered.",
+	NULL
+};
+
+static int cmd_rescue_undelete_subvol(int argc, char **argv)
+{
+	struct btrfs_fs_info *fs_info;
+	char *devname;
+	u64 subvol_id = 0;
+	int ret;
+
+	while (1) {
+		int c = getopt(argc, argv, "s:");
+
+		if (c < 0)
+			break;
+		switch (c) {
+		case 's':
+			subvol_id = arg_strtou64(optarg);
+			if (!is_fstree(subvol_id)) {
+				error("%llu is not a valid subvolume id",
+						subvol_id);
+				ret = -EINVAL;
+				goto out;
+			}
+			break;
+		default:
+			usage(cmd_rescue_undelete_subvol_usage);
+		}
+	}
+
+	if (check_argc_exact(argc - optind, 1))
+		usage(cmd_rescue_undelete_subvol_usage);
+
+	devname = argv[optind];
+	ret = check_mounted(devname);
+	if (ret < 0) {
+		error("could not check mount status: %s", strerror(-ret));
+		goto out;
+	} else if (ret) {
+		error("%s is currently mounted", devname);
+		ret = -EBUSY;
+		goto out;
+	}
+
+	fs_info = open_ctree_fs_info(devname, 0, 0, 0, OPEN_CTREE_WRITES |
+				     OPEN_CTREE_PARTIAL);
+	if (!fs_info) {
+		error("could not open btrfs");
+		ret = -EIO;
+		goto out;
+	}
+
+	ret = btrfs_undelete_intact_subvols(fs_info->tree_root, subvol_id);
+
+	close_ctree(fs_info->tree_root);
+out:
+	return ret;
+}
+
 static const char rescue_cmd_group_info[] =
 "toolbox for specific rescue operations";
 
@@ -260,6 +328,8 @@ const struct cmd_group rescue_cmd_group = {
 		{ "zero-log", cmd_rescue_zero_log, cmd_rescue_zero_log_usage, NULL, 0},
 		{ "fix-device-size", cmd_rescue_fix_device_size,
 			cmd_rescue_fix_device_size_usage, NULL, 0},
+		{ "undelete-subvol", cmd_rescue_undelete_subvol,
+			cmd_rescue_undelete_subvol_usage, NULL, 0},
 		NULL_CMD_STRUCT
 	}
 };
-- 
2.16.2



