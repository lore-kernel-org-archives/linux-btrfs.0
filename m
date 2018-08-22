Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60158 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726076AbeHVI3K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Aug 2018 04:29:10 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0DC63AF40
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Aug 2018 05:05:56 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs-progs: rescue: Add ability to disable quota offline
Date: Wed, 22 Aug 2018 13:05:50 +0800
Message-Id: <20180822050550.32429-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Provide an offline tool to disable quota.

For kernel which skip_balance doesn't work, there is no way to disable
quota on huge fs with balance, as quota will cause balance to hang for a
long long time for each tree block switch.

So add an offline rescue tool to disable quota.

Reported-by: Dan Merillat <dan.merillat@gmail.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
changelog
v2:
  Message update for no quota status item case.
---
 Documentation/btrfs-rescue.asciidoc |  6 +++
 cmds-rescue.c                       | 80 +++++++++++++++++++++++++++++
 2 files changed, 86 insertions(+)

diff --git a/Documentation/btrfs-rescue.asciidoc b/Documentation/btrfs-rescue.asciidoc
index f94a0ff2b45e..fb088c1a768a 100644
--- a/Documentation/btrfs-rescue.asciidoc
+++ b/Documentation/btrfs-rescue.asciidoc
@@ -31,6 +31,12 @@ help.
 NOTE: Since *chunk-recover* will scan the whole device, it will be *VERY* slow
 especially executed on a large device.
 
+*disable-quota* <device>::
+disable quota offline
++
+Acts as a fallback method to disable quota for case where mount hangs due to
+balance and quota.
+
 *fix-device-size* <device>::
 fix device size and super block total bytes values that are do not match
 +
diff --git a/cmds-rescue.c b/cmds-rescue.c
index 38c4ab9b2ef6..0b451fb2dea4 100644
--- a/cmds-rescue.c
+++ b/cmds-rescue.c
@@ -250,6 +250,84 @@ out:
 	return !!ret;
 }
 
+static const char * const cmd_rescue_disable_quota_usage[] = {
+	"btrfs rescue disable-quota <device>",
+	"Disable quota, especially useful for balance mount hang when quota enabled",
+	"",
+	NULL
+};
+
+static int cmd_rescue_disable_quota(int argc, char **argv)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_fs_info *fs_info;
+	struct btrfs_path path;
+	struct btrfs_root *root;
+	struct btrfs_qgroup_status_item *qi;
+	struct btrfs_key key;
+	char *devname;
+	int ret;
+
+	clean_args_no_options(argc, argv, cmd_rescue_disable_quota_usage);
+	if (check_argc_exact(argc, 2))
+		usage(cmd_rescue_disable_quota_usage);
+
+	devname = argv[optind];
+	ret = check_mounted(devname);
+	if (ret < 0) {
+		error("could not check mount status: %s", strerror(-ret));
+		return !!ret;
+	} else if (ret) {
+		error("%s is currently mounted", devname);
+		return !!ret;
+	}
+	fs_info = open_ctree_fs_info(devname, 0, 0, 0, OPEN_CTREE_WRITES);
+	if (!fs_info) {
+		error("could not open btrfs");
+		ret = -EIO;
+		return !!ret;
+	}
+	root = fs_info->quota_root;
+	if (!root) {
+		printf("Quota is not enabled, no need to modify the fs\n");
+		goto close;
+	}
+	btrfs_init_path(&path);
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		error("failed to start transaction: %s", strerror(-ret));
+		goto close;
+	}
+	key.objectid = 0;
+	key.type = BTRFS_QGROUP_STATUS_KEY;
+	key.offset = 0;
+	ret = btrfs_search_slot(trans, root, &key, &path, 0, 1);
+	if (ret < 0) {
+		error("failed to search tree: %s", strerror(-ret));
+		goto close;
+	}
+	if (ret > 0) {
+		printf(
+		"Qgroup status item not found, no need to modify the fs\n");
+		ret = 0;
+		goto release;
+	}
+	qi = btrfs_item_ptr(path.nodes[0], path.slots[0],
+			    struct btrfs_qgroup_status_item);
+	btrfs_set_qgroup_status_flags(path.nodes[0], qi,
+			BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT);
+	btrfs_mark_buffer_dirty(path.nodes[0]);
+	ret = btrfs_commit_transaction(trans, root);
+	if (ret < 0)
+		error("failed to commit transaction: %s", strerror(-ret));
+release:
+	btrfs_release_path(&path);
+close:
+	close_ctree(fs_info->tree_root);
+	return !!ret;
+}
+
 static const char rescue_cmd_group_info[] =
 "toolbox for specific rescue operations";
 
@@ -262,6 +340,8 @@ const struct cmd_group rescue_cmd_group = {
 		{ "zero-log", cmd_rescue_zero_log, cmd_rescue_zero_log_usage, NULL, 0},
 		{ "fix-device-size", cmd_rescue_fix_device_size,
 			cmd_rescue_fix_device_size_usage, NULL, 0},
+		{ "disable-quota", cmd_rescue_disable_quota,
+			cmd_rescue_disable_quota_usage, NULL, 0},
 		NULL_CMD_STRUCT
 	}
 };
-- 
2.18.0
