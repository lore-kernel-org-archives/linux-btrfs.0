Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:33627 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751795AbeBBI2K (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Feb 2018 03:28:10 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id CA98949F19B7
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Feb 2018 16:28:04 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 08/10] btrfs-progs: undelete-subvol: add undelete-subvol subcommand
Date: Fri, 2 Feb 2018 16:27:49 +0800
Message-ID: <20180202082751.26225-9-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180202082751.26225-1-lufq.fnst@cn.fujitsu.com>
References: <20180202082751.26225-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add the undelete-subvol subcommand for btrfs rescue. This subcommand is
used to recover all deleted subvolume left intact on the device.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 cmds-rescue.c | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/cmds-rescue.c b/cmds-rescue.c
index c40088ad374e..17bc1df33a23 100644
--- a/cmds-rescue.c
+++ b/cmds-rescue.c
@@ -25,6 +25,7 @@
 #include "disk-io.h"
 #include "commands.h"
 #include "utils.h"
+#include "undelete-subvol.h"
 #include "help.h"
 
 static const char * const rescue_cmd_group_usage[] = {
@@ -248,6 +249,50 @@ out:
 	return !!ret;
 }
 
+static const char * const cmd_rescue_undelete_subvol_usage[] = {
+	"btrfs rescue undelete-subvol <device>",
+	"Undelete all deleted subvolume that still left intact on the device",
+	"",
+	NULL
+};
+
+static int cmd_rescue_undelete_subvol(int argc, char **argv)
+{
+	struct btrfs_fs_info *fs_info;
+	char *devname;
+	int ret;
+
+	clean_args_no_options(argc, argv, cmd_rescue_undelete_subvol_usage);
+
+	if (check_argc_exact(argc, 2))
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
+	ret = btrfs_undelete_intact_subvols(fs_info->tree_root);
+
+	close_ctree(fs_info->tree_root);
+out:
+	return ret;
+}
+
 static const char rescue_cmd_group_info[] =
 "toolbox for specific rescue operations";
 
@@ -260,6 +305,8 @@ const struct cmd_group rescue_cmd_group = {
 		{ "zero-log", cmd_rescue_zero_log, cmd_rescue_zero_log_usage, NULL, 0},
 		{ "fix-device-size", cmd_rescue_fix_device_size,
 			cmd_rescue_fix_device_size_usage, NULL, 0},
+		{ "undelete-subvol", cmd_rescue_undelete_subvol,
+			cmd_rescue_undelete_subvol_usage, NULL, 0},
 		NULL_CMD_STRUCT
 	}
 };
-- 
2.16.1



