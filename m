From: Sage Weil <sage@newdream.net>
Subject: [PATCH] btrfs: 'usertrans' mount option to allow unprivileged
 userspace transactions
Date: Thu, 25 Jun 2009 14:45:39 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0906221434150.9993@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This lets an administrator give non-root users access to the btrfs 
transaction start/end ioctls via a mount option.

Currently any process using the ioctls must run as root.  That's 
appropriate in general, since the ioctls allow let any process to hang fs 
commits by holding an open transaction indefinitely.  But on locked down 
hosts (i.e. no users), that can be inconvenient because daemons using 
transactions have to run as root.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/ctree.h |    1 +
 fs/btrfs/ioctl.c |    3 ++-
 fs/btrfs/super.c |    9 ++++++++-
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 03441a9..eb1f3b7 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1102,6 +1102,7 @@ struct btrfs_root {
 #define BTRFS_MOUNT_FLUSHONCOMMIT       (1 << 7)
 #define BTRFS_MOUNT_SSD_SPREAD		(1 << 8)
 #define BTRFS_MOUNT_NOSSD		(1 << 9)
+#define BTRFS_MOUNT_USERTRANS           (1 << 10)
 
 #define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
 #define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index eff18f5..2aadc14 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1183,7 +1183,8 @@ static long btrfs_ioctl_trans_start(struct file *file)
 	struct btrfs_trans_handle *trans;
 	int ret = 0;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable(CAP_SYS_ADMIN) &&
+	    !btrfs_test_opt(root, USERTRANS))
 		return -EPERM;
 
 	if (file->private_data) {
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 708ac06..1be8567 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -67,7 +67,8 @@ enum {
 	Opt_degraded, Opt_subvol, Opt_device, Opt_nodatasum, Opt_nodatacow,
 	Opt_max_extent, Opt_max_inline, Opt_alloc_start, Opt_nobarrier,
 	Opt_ssd, Opt_nossd, Opt_ssd_spread, Opt_thread_pool, Opt_noacl,
-	Opt_compress, Opt_notreelog, Opt_ratio, Opt_flushoncommit, Opt_err,
+	Opt_compress, Opt_notreelog, Opt_ratio, Opt_flushoncommit,
+	Opt_usertrans, Opt_err,
 };
 
 static match_table_t tokens = {
@@ -89,6 +90,7 @@ static match_table_t tokens = {
 	{Opt_notreelog, "notreelog"},
 	{Opt_flushoncommit, "flushoncommit"},
 	{Opt_ratio, "metadata_ratio=%d"},
+	{Opt_usertrans, "usertrans"},
 	{Opt_err, NULL},
 };
 
@@ -257,6 +259,9 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 				printk(KERN_INFO "btrfs: metadata ratio %d\n",
 				       info->metadata_ratio);
 			}
+		case Opt_usertrans:
+			printk(KERN_INFO "btrfs: enabling unprivileged user transactions\n");
+			btrfs_set_opt(info->mount_opt, USERTRANS);
 			break;
 		default:
 			break;
@@ -449,6 +454,8 @@ static int btrfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
 		seq_puts(seq, ",notreelog");
 	if (btrfs_test_opt(root, FLUSHONCOMMIT))
 		seq_puts(seq, ",flushoncommit");
+	if (btrfs_test_opt(root, USERTRANS))
+		seq_puts(seq, ",usertrans");
 	if (!(root->fs_info->sb->s_flags & MS_POSIXACL))
 		seq_puts(seq, ",noacl");
 	return 0;
-- 
1.5.6.5

