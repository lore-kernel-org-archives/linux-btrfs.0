Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39548 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750784AbdFOJOk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Jun 2017 05:14:40 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2] btrfs: add mount umount logs
Date: Thu, 15 Jun 2017 17:20:42 +0800
Message-Id: <1497518442-1078-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

By looking at the logs we should be able to know when FS was
mounted and unmounted and the options used, so to help forensic
investigations.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
Hi David,

 As you suggested VFS is definitly a better place to have this
 and its patch is in the ML. But I am not too sure what's their
 plan is.  So can we integrate this into BTRFS ? as we can always
 remove it once VFS provides that feature.

Thanks, Anand

v2: Use ro,rw instead of rdonly and directly print it.

 fs/btrfs/super.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 3371213924bd..2cb367a106e3 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1373,6 +1373,13 @@ static char *setup_root_args(char *args)
 	return buf;
 }
 
+static void print_mount_info(struct btrfs_fs_info *info, int flag, char *opt,
+		char *prefix)
+{
+	btrfs_notice(info, "%s: flags=%s opt=%s\n",
+			prefix, flag & MS_RDONLY ? "ro":"rw", opt);
+}
+
 static struct dentry *mount_subvol(const char *subvol_name, u64 subvol_objectid,
 				   int flags, const char *device_name,
 				   char *data)
@@ -1467,6 +1474,8 @@ static struct dentry *mount_subvol(const char *subvol_name, u64 subvol_objectid,
 			dput(root);
 			root = ERR_PTR(ret);
 			deactivate_locked_super(s);
+		} else {
+			print_mount_info(fs_info, flags, data, "mount");
 		}
 	}
 
@@ -1845,6 +1854,9 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 out:
 	wake_up_process(fs_info->transaction_kthread);
 	btrfs_remount_cleanup(fs_info, old_opts);
+
+	print_mount_info(fs_info, *flags, data, "remount");
+
 	return 0;
 
 restore:
@@ -2174,6 +2186,7 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 static void btrfs_kill_super(struct super_block *sb)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
+	btrfs_notice(fs_info, "%s\n", "unmount");
 	kill_anon_super(sb);
 	free_fs_info(fs_info);
 }
-- 
2.7.0

