Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:59576 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726601AbeIKQd1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 12:33:27 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id C313F4B6ADFF
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 19:34:25 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [RFC PATCH v2 2/2] btrfs-progs: subvolume: undelete: add btrfs subvolume undelete subcommand
Date: Tue, 11 Sep 2018 19:34:17 +0800
Message-ID: <20180911113417.26466-2-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180911113417.26466-1-lufq.fnst@cn.fujitsu.com>
References: <20180911112903.25985-1-lufq.fnst@cn.fujitsu.com>
 <20180911113417.26466-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add the undelete subcommand, this is depend on the
BTRFS_IOC_SUBVOL_UNDELETE ioctl.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 btrfs-completion |  2 +-
 cmds-subvolume.c | 70 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+), 1 deletion(-)

diff --git a/btrfs-completion b/btrfs-completion
index ae683f4ecf61..2b43fbd63023 100644
--- a/btrfs-completion
+++ b/btrfs-completion
@@ -30,7 +30,7 @@ _btrfs()
 	local cmd=${words[1]}
 
 	commands='subvolume filesystem balance device scrub check rescue restore inspect-internal property send receive quota qgroup replace help version'
-	commands_subvolume='create delete list snapshot find-new get-default set-default show sync'
+	commands_subvolume='create delete list snapshot find-new get-default set-default show sync undelete'
 	commands_filesystem='defragment sync resize show df du label usage'
 	commands_balance='start pause cancel resume status'
 	commands_device='scan add delete remove ready stats usage'
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index e7a884af1f5d..228d0b9e9b34 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -1219,6 +1219,74 @@ out:
 	return !!ret;
 }
 
+static const char * const cmd_subvol_undelete_usage[] = {
+	"btrfs subvolume undelete [-n <name>] <subvol_id> <dest>",
+	"Undelete the subvolume of the given <subvol_id> to <dest>.",
+	"",
+	"-n <name>  recover the subvolume with <name>.",
+	NULL
+};
+
+static int cmd_subvol_undelete(int argc, char **argv)
+{
+	struct btrfs_ioctl_subvol_undelete_args args;
+	bool need_assign_name = true;
+	DIR *dirstream = NULL;
+	char *dest;
+	int fd = -1;
+	int ret;
+
+	memset(&args, 0, sizeof(args));
+
+	while (1) {
+		int c = getopt(argc, argv, "n:");
+
+		if (c < 0)
+			break;
+
+		switch (c) {
+		case 'n':
+			strncpy_null(args.name, optarg);
+			need_assign_name = false;
+			break;
+		default:
+			usage(cmd_subvol_undelete_usage);
+		}
+	}
+	if (!need_assign_name) {
+		if (!test_issubvolname(args.name)) {
+			error("invalid subvolume name: %s", args.name);
+			return -EINVAL;
+		} else if (strlen(args.name) > BTRFS_VOL_NAME_MAX) {
+			error("subvolume name too long: %s", args.name);
+			return -EINVAL;
+		}
+	}
+
+	if (check_argc_exact(argc - optind, 2))
+		usage(cmd_subvol_undelete_usage);
+
+	args.subvol_id = arg_strtou64(argv[optind]);
+	if (need_assign_name)
+		snprintf(args.name, BTRFS_VOL_NAME_MAX, "sub_%llu",
+				args.subvol_id);
+
+	dest = argv[optind + 1];
+	fd = btrfs_open_dir(dest, &dirstream, 1);
+	if (fd < 0) {
+		error("can't access '%s'", dest);
+		return -1;
+	}
+
+	ret = ioctl(fd, BTRFS_IOC_SUBVOL_UNDELETE, &args);
+	if (ret)
+		perror("BTRFS_IOC_SUBVOL_UNDELETE");
+
+	close_file_or_dir(fd, dirstream);
+
+	return ret;
+}
+
 static const char subvolume_cmd_group_info[] =
 "manage subvolumes: create, delete, list, etc";
 
@@ -1237,6 +1305,8 @@ const struct cmd_group subvolume_cmd_group = {
 			NULL, 0 },
 		{ "show", cmd_subvol_show, cmd_subvol_show_usage, NULL, 0 },
 		{ "sync", cmd_subvol_sync, cmd_subvol_sync_usage, NULL, 0 },
+		{ "undelete", cmd_subvol_undelete, cmd_subvol_undelete_usage,
+			NULL, 0 },
 		NULL_CMD_STRUCT
 	}
 };
-- 
2.18.0
