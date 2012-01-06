From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 17/21] Btrfs: add skip_balance mount option
Date: Fri,  6 Jan 2012 16:31:05 +0200
Message-ID: <1325860269-15013-18-git-send-email-idryomov@gmail.com>
References: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Since restriper kthread starts involuntarily on mount and can suck cpu
and memory bandwidth add a mount option to forcefully skip it.  The
restriper in that case hangs around in paused state and can be resumed
from userspace when it's convenient.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/ctree.h   |    1 +
 fs/btrfs/super.c   |   11 +++++++++--
 fs/btrfs/volumes.c |   10 +++++++---
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 9997a59..99eb2bc 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1492,6 +1492,7 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_MOUNT_AUTO_DEFRAG		(1 << 16)
 #define BTRFS_MOUNT_INODE_MAP_CACHE	(1 << 17)
 #define BTRFS_MOUNT_RECOVERY		(1 << 18)
+#define BTRFS_MOUNT_SKIP_BALANCE	(1 << 19)
 
 #define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
 #define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 34a8b61..063b521 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -164,8 +164,9 @@ enum {
 	Opt_compress_type, Opt_compress_force, Opt_compress_force_type,
 	Opt_notreelog, Opt_ratio, Opt_flushoncommit, Opt_discard,
 	Opt_space_cache, Opt_clear_cache, Opt_user_subvol_rm_allowed,
-	Opt_enospc_debug, Opt_subvolrootid, Opt_defrag,
-	Opt_inode_cache, Opt_no_space_cache, Opt_recovery, Opt_err,
+	Opt_enospc_debug, Opt_subvolrootid, Opt_defrag, Opt_inode_cache,
+	Opt_no_space_cache, Opt_recovery, Opt_skip_balance,
+	Opt_err,
 };
 
 static match_table_t tokens = {
@@ -200,6 +201,7 @@ static match_table_t tokens = {
 	{Opt_inode_cache, "inode_cache"},
 	{Opt_no_space_cache, "nospace_cache"},
 	{Opt_recovery, "recovery"},
+	{Opt_skip_balance, "skip_balance"},
 	{Opt_err, NULL},
 };
 
@@ -398,6 +400,9 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			printk(KERN_INFO "btrfs: enabling auto recovery");
 			btrfs_set_opt(info->mount_opt, RECOVERY);
 			break;
+		case Opt_skip_balance:
+			btrfs_set_opt(info->mount_opt, SKIP_BALANCE);
+			break;
 		case Opt_err:
 			printk(KERN_INFO "btrfs: unrecognized mount option "
 			       "'%s'\n", p);
@@ -723,6 +728,8 @@ static int btrfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
 		seq_puts(seq, ",autodefrag");
 	if (btrfs_test_opt(root, INODE_MAP_CACHE))
 		seq_puts(seq, ",inode_cache");
+	if (btrfs_test_opt(root, SKIP_BALANCE))
+		seq_puts(seq, ",skip_balance");
 	return 0;
 }
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c03df10..c50a0af 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2692,15 +2692,19 @@ static int restriper_kthread(void *data)
 	struct btrfs_balance_control *bctl =
 			(struct btrfs_balance_control *)data;
 	struct btrfs_fs_info *fs_info = bctl->fs_info;
-	int ret;
+	int ret = 0;
 
 	mutex_lock(&fs_info->volume_mutex);
 	mutex_lock(&fs_info->balance_mutex);
 
 	set_balance_control(bctl);
 
-	printk(KERN_INFO "btrfs: continuing balance\n");
-	ret = btrfs_balance(bctl, 1);
+	if (btrfs_test_opt(fs_info->tree_root, SKIP_BALANCE)) {
+		printk(KERN_INFO "btrfs: force skipping balance\n");
+	} else {
+		printk(KERN_INFO "btrfs: continuing balance\n");
+		ret = btrfs_balance(bctl, 1);
+	}
 
 	mutex_unlock(&fs_info->balance_mutex);
 	mutex_unlock(&fs_info->volume_mutex);
-- 
1.7.6.3

