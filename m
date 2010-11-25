From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [RFC PATCH 4/4] Btrfs: deal with filesystem state at mount, umount
 and remount
Date: Thu, 25 Nov 2010 17:56:41 +0800
Message-ID: <4CEE32D9.8060207@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Liu Bo <liubo2009@cn.fujitsu.com>
To: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Liu Bo <liubo2009@cn.fujitsu.com>

Since there is a filesystem state, we should deal with it carefully at mount,
 umount and remount.

- At mount, the FS state should be checked if there is error on these FS.
  If it does have, btrfsck is recommended.
- At umount, the FS state should be saved into disk for consistency.
- At remount, the FS state in super block may be updated.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c |   23 +++++++++++++++++++++++
 fs/btrfs/super.c   |   12 +++++++++---
 2 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index fb827d0..15ff468 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -43,6 +43,8 @@
 static struct extent_io_ops btree_extent_io_ops;
 static void end_workqueue_fn(struct btrfs_work *work);
 static void free_fs_root(struct btrfs_root *root);
+static void btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
+				     int read_only);
 
 /*
  * end_io_wq structs are used to do processing in task context when an IO is
@@ -1700,6 +1702,11 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	if (!btrfs_super_root(disk_super))
 		goto fail_iput;
 
+	/* check filesystem state */
+	fs_info->fs_state |= btrfs_super_flags(disk_super);
+
+	btrfs_check_super_valid(fs_info, sb->s_flags & MS_RDONLY);
+
 	ret = btrfs_parse_options(tree_root, options);
 	if (ret) {
 		err = ret;
@@ -2409,6 +2416,7 @@ int btrfs_commit_super(struct btrfs_root *root)
 int close_ctree(struct btrfs_root *root)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_super_block *sb = &fs_info->super_for_commit;
 	int ret;
 
 	fs_info->closing = 1;
@@ -2416,6 +2424,7 @@ int close_ctree(struct btrfs_root *root)
 
 	btrfs_put_block_group_cache(fs_info);
 	if (!(fs_info->sb->s_flags & MS_RDONLY)) {
+		sb->flags |= cpu_to_le64(fs_info->fs_state);
 		ret =  btrfs_commit_super(root);
 		if (ret)
 			printk(KERN_ERR "btrfs: commit super ret %d\n", ret);
@@ -2592,6 +2601,20 @@ out:
 	return 0;
 }
 
+static void btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
+				     int read_only)
+{
+	if (read_only)
+		return;
+
+	if (!(fs_info->fs_state & BTRFS_SUPER_FLAG_VALID))
+		printk(KERN_WARNING "warning: mount unchecked fs, "
+		       "running btfsck is recommended\n");
+	else if (fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR)
+		printk(KERN_WARNING "warning: mount fs with errors, "
+		       "running btfsck is recommended\n");
+}
+
 static struct extent_io_ops btree_extent_io_ops = {
 	.write_cache_pages_lock_hook = btree_lock_page_hook,
 	.readpage_end_io_hook = btree_readpage_end_io_hook,
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 48fac6e..40130e8 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -771,6 +771,8 @@ error_free_subvol_name:
 static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 {
 	struct btrfs_root *root = btrfs_sb(sb);
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_super_block *disk_super = &fs_info->super_copy;
 	int ret;
 
 	ret = btrfs_parse_options(root, data);
@@ -782,17 +784,21 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 
 	if (*flags & MS_RDONLY) {
 		sb->s_flags |= MS_RDONLY;
+		if (!(disk_super->flags &
+		    cpu_to_le64(BTRFS_SUPER_FLAG_VALID)) &&
+		    (fs_info->fs_state & BTRFS_SUPER_FLAG_VALID))
+			disk_super->flags |= cpu_to_le64(fs_info->fs_state);
 
 		ret =  btrfs_commit_super(root);
 		WARN_ON(ret);
 	} else {
-		if (root->fs_info->fs_devices->rw_devices == 0)
+		if (fs_info->fs_devices->rw_devices == 0)
 			return -EACCES;
 
-		if (btrfs_super_log_root(&root->fs_info->super_copy) != 0)
+		if (btrfs_super_log_root(disk_super) != 0)
 			return -EINVAL;
 
-		ret = btrfs_cleanup_fs_roots(root->fs_info);
+		ret = btrfs_cleanup_fs_roots(fs_info);
 		WARN_ON(ret);
 
 		/* recover relocation */
-- 
1.7.0.1
