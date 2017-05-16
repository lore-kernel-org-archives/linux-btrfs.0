Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16402 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751726AbdEPIgK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2017 04:36:10 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] btrfs: add mount umount logs
Date: Tue, 16 May 2017 16:41:49 +0800
Message-Id: <20170516084149.10147-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

By looking at the logs we should be able to know when the FS was
mounted and unmounted and the options used, so to help forensic
investigations.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/super.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 827a8305da50..a123bc46b521 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1408,6 +1408,17 @@ static char *setup_root_args(char *args)
 	return buf;
 }
 
+static void print_mount_info(struct btrfs_fs_info *info, int flag, char *opt,
+		char *prefix)
+{
+	char f[10] = {0};
+
+	if (flag & MS_RDONLY)
+		strcpy(f, "rdonly");
+
+	btrfs_notice(info, "%s: flags:%s opt:%s\n", prefix, f, opt);
+}
+
 static struct dentry *mount_subvol(const char *subvol_name, u64 subvol_objectid,
 				   int flags, const char *device_name,
 				   char *data)
@@ -1502,6 +1513,8 @@ static struct dentry *mount_subvol(const char *subvol_name, u64 subvol_objectid,
 			dput(root);
 			root = ERR_PTR(ret);
 			deactivate_locked_super(s);
+		} else {
+			print_mount_info(fs_info, flags, data, "mount");
 		}
 	}
 
@@ -1882,6 +1895,9 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 out:
 	wake_up_process(fs_info->transaction_kthread);
 	btrfs_remount_cleanup(fs_info, old_opts);
+
+	print_mount_info(fs_info, *flags, data, "remount");
+
 	return 0;
 
 restore:
@@ -2212,6 +2228,7 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 static void btrfs_kill_super(struct super_block *sb)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
+	btrfs_notice(fs_info, "%s\n", "unmount");
 	kill_anon_super(sb);
 	free_fs_info(fs_info);
 }
-- 
2.10.0

