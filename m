From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 19/21] Btrfs: add skip_restripe mount option
Date: Tue, 23 Aug 2011 23:02:00 +0300
Message-ID: <1314129722-31601-20-git-send-email-idryomov@gmail.com>
References: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>,
	Hugo Mills <hugo@carfax.org.uk>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1314129722-31601-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Since restriper kthread starts involuntarily on mount and can suck cpu
and memory bandwidth add a mount option to forcefully skip it.  The
restriper in that case hangs around in paused state and can be resumed
from userspace when it's convenient.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/ctree.h   |    1 +
 fs/btrfs/super.c   |    8 +++++++-
 fs/btrfs/volumes.c |   15 +++++++++++++--
 3 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8e764d9..0eaa08d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1432,6 +1432,7 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_MOUNT_ENOSPC_DEBUG	 (1 << 15)
 #define BTRFS_MOUNT_AUTO_DEFRAG		(1 << 16)
 #define BTRFS_MOUNT_INODE_MAP_CACHE	(1 << 17)
+#define BTRFS_MOUNT_SKIP_RESTRIPE	(1 << 18)
 
 #define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
 #define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 15634d4..1ef8c33 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -162,7 +162,7 @@ enum {
 	Opt_notreelog, Opt_ratio, Opt_flushoncommit, Opt_discard,
 	Opt_space_cache, Opt_clear_cache, Opt_user_subvol_rm_allowed,
 	Opt_enospc_debug, Opt_subvolrootid, Opt_defrag,
-	Opt_inode_cache, Opt_err,
+	Opt_inode_cache, Opt_skip_restripe, Opt_err,
 };
 
 static match_table_t tokens = {
@@ -195,6 +195,7 @@ static match_table_t tokens = {
 	{Opt_subvolrootid, "subvolrootid=%d"},
 	{Opt_defrag, "autodefrag"},
 	{Opt_inode_cache, "inode_cache"},
+	{Opt_skip_restripe, "skip_restripe"},
 	{Opt_err, NULL},
 };
 
@@ -381,6 +382,9 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			printk(KERN_INFO "btrfs: enabling auto defrag");
 			btrfs_set_opt(info->mount_opt, AUTO_DEFRAG);
 			break;
+		case Opt_skip_restripe:
+			btrfs_set_opt(info->mount_opt, SKIP_RESTRIPE);
+			break;
 		case Opt_err:
 			printk(KERN_INFO "btrfs: unrecognized mount option "
 			       "'%s'\n", p);
@@ -729,6 +733,8 @@ static int btrfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
 		seq_puts(seq, ",autodefrag");
 	if (btrfs_test_opt(root, INODE_MAP_CACHE))
 		seq_puts(seq, ",inode_cache");
+	if (btrfs_test_opt(root, SKIP_RESTRIPE))
+		seq_puts(seq, ",skip_restripe");
 	return 0;
 }
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index bfe2b03..d8958e2 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2756,13 +2756,24 @@ static int restriper_kthread(void *data)
 {
 	struct restripe_control *rctl = (struct restripe_control *)data;
 	struct btrfs_fs_info *fs_info = rctl->fs_info;
-	int ret;
+	int ret = 0;
 
 	mutex_lock(&fs_info->restripe_mutex);
 
-	printk(KERN_INFO "btrfs: continuing restripe\n");
+	if (btrfs_test_opt(fs_info->tree_root, SKIP_RESTRIPE)) {
+		mutex_lock(&fs_info->volume_mutex);
+		set_restripe_control(rctl, 0);
+		mutex_unlock(&fs_info->volume_mutex);
+
+		printk(KERN_INFO "btrfs: force skipping restripe\n");
+		goto out;
+	} else {
+		printk(KERN_INFO "btrfs: continuing restripe\n");
+	}
+
 	ret = btrfs_restripe(rctl, 1);
 
+out:
 	mutex_unlock(&fs_info->restripe_mutex);
 	return ret;
 }
-- 
1.7.5.4

