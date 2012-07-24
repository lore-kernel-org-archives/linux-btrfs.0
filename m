Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58871 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125Ab2GXR6w (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jul 2012 13:58:52 -0400
Received: by yhmm54 with SMTP id m54so6958290yhm.19
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jul 2012 10:58:51 -0700 (PDT)
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: linux-btrfs@vger.kernel.org
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: [PATCH v4] Btrfs: Check INCOMPAT flags on remount and add helper function
Date: Tue, 24 Jul 2012 12:58:43 -0500
Message-Id: <1343152723-8856-1-git-send-email-mitch.harder@sabayonlinux.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In support of the recently added capability to remount with lzo
compression, provide a helper function to check the compression
INCOMPAT flags when remounting with lzo compression, and set
the flags if necessary.

Also, implement the new helper function when defragmenting with
explicit lzo compression and when setting the default subvolume.

Signed-off-by: Mitch Harder <mitch.harder@sabayonlinux.org>
---
v1->v2
- Remove extraneous formatting change.
v2->v3
- Consolidate into a single patch
- Convert helper function to a static inline function.
v3->v4
- Per feedback from Li Zefan, change function name from _chk_ to _set_
- Per feedback from David Sterba, make the helper function more generic.
- The more generic function can also be implemented in the INCOMPAT
  check made for setting the default subvolume.

 fs/btrfs/ctree.h |   17 +++++++++++++++++
 fs/btrfs/ioctl.c |   16 ++--------------
 fs/btrfs/super.c |    1 +
 3 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index a0ee2f8..5422e54 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3103,6 +3103,23 @@ void __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root, const char *function,
 			       unsigned int line, int errno);
 
+#define btrfs_set_fs_incompat(__fs_info, opt) \
+	__btrfs_set_fs_incompat((__fs_info), BTRFS_FEATURE_INCOMPAT_##opt)
+
+static inline void __btrfs_set_fs_incompat(struct btrfs_fs_info *fs_info,
+					   u64 flag)
+{
+	struct btrfs_super_block *disk_super;
+	u64 features;
+
+	disk_super = fs_info->super_copy;
+	features = btrfs_super_incompat_flags(disk_super);
+	if (!(features & flag)) {
+		features |= flag;
+		btrfs_set_super_incompat_flags(disk_super, features);
+	}
+}
+
 #define btrfs_abort_transaction(trans, root, errno)		\
 do {								\
 	__btrfs_abort_transaction(trans, root, __func__,	\
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 17facea..0d5d079 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1042,11 +1042,9 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 		      u64 newer_than, unsigned long max_to_defrag)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct btrfs_super_block *disk_super;
 	struct file_ra_state *ra = NULL;
 	unsigned long last_index;
 	u64 isize = i_size_read(inode);
-	u64 features;
 	u64 last_len = 0;
 	u64 skip = 0;
 	u64 defrag_end = 0;
@@ -1233,11 +1231,8 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 		mutex_unlock(&inode->i_mutex);
 	}
 
-	disk_super = root->fs_info->super_copy;
-	features = btrfs_super_incompat_flags(disk_super);
 	if (range->compress_type == BTRFS_COMPRESS_LZO) {
-		features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO;
-		btrfs_set_super_incompat_flags(disk_super, features);
+		btrfs_set_fs_incompat(root->fs_info, COMPRESS_LZO);
 	}
 
 	ret = defrag_count;
@@ -2761,8 +2756,6 @@ static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
 	struct btrfs_path *path;
 	struct btrfs_key location;
 	struct btrfs_disk_key disk_key;
-	struct btrfs_super_block *disk_super;
-	u64 features;
 	u64 objectid = 0;
 	u64 dir_id;
 
@@ -2813,12 +2806,7 @@ static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
 	btrfs_mark_buffer_dirty(path->nodes[0]);
 	btrfs_free_path(path);
 
-	disk_super = root->fs_info->super_copy;
-	features = btrfs_super_incompat_flags(disk_super);
-	if (!(features & BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL)) {
-		features |= BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL;
-		btrfs_set_super_incompat_flags(disk_super, features);
-	}
+	btrfs_set_fs_incompat(root->fs_info, DEFAULT_SUBVOL);
 	btrfs_end_transaction(trans, root);
 
 	return 0;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 26da344..75ee2c7 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -401,6 +401,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 				compress_type = "lzo";
 				info->compress_type = BTRFS_COMPRESS_LZO;
 				btrfs_set_opt(info->mount_opt, COMPRESS);
+				btrfs_set_fs_incompat(info, COMPRESS_LZO);
 			} else if (strncmp(args[0].from, "no", 2) == 0) {
 				compress_type = "no";
 				info->compress_type = BTRFS_COMPRESS_NONE;
-- 
1.7.8.6

