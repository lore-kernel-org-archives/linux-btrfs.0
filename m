Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58861 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755246AbeDTOYZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Apr 2018 10:24:25 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 70615AEBF
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Apr 2018 14:24:24 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 4/6] btrfs: add new ioctl BTRFS_IOC_CLEAR_FREE
Date: Fri, 20 Apr 2018 16:21:52 +0200
Message-Id: <37957ea7612cf6bb838bac99684fa144e2cf5c36.1524233244.git.dsterba@suse.com>
In-Reply-To: <cover.1524233244.git.dsterba@suse.com>
References: <cover.1524233244.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A new ioctl that will clear the free space (by writing zeros) given by
the user range. Similar to the TRIM ioctl.

We need a new ioctl for that because struct fstrim_range does not
provide any existing or reserved member for extensions. The new ioctl
also supports TRIM as the operation type.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h           | 11 ++---------
 fs/btrfs/extent-tree.c     | 48 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ioctl.c           | 42 ++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/btrfs.h | 20 +++++++++++++++++++
 4 files changed, 112 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 772cb4ccc5f7..d8cc70a6bef7 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -674,15 +674,6 @@ struct btrfs_stripe_hash {
 	spinlock_t lock;
 };
 
-/*
- * Type of operation that will be used to clear unused blocks.
- */
-enum btrfs_clear_op_type {
-	BTRFS_CLEAR_OP_DISCARD = 0,
-	BTRFS_CLEAR_OP_ZERO,
-	BTRFS_NR_CLEAR_OP_TYPES,
-};
-
 /* used by the raid56 code to lock stripes for read/modify/write */
 struct btrfs_stripe_hash_table {
 	struct list_head stripe_cache;
@@ -2800,6 +2791,8 @@ int btrfs_error_unpin_extent_range(struct btrfs_fs_info *fs_info,
 int btrfs_discard_extent(struct btrfs_fs_info *fs_info, u64 bytenr,
 			 u64 num_bytes, u64 *actual_bytes,
 			 enum btrfs_clear_op_type clear);
+int btrfs_clear_free_space(struct btrfs_root *root,
+		struct btrfs_ioctl_clear_free_args *args);
 int btrfs_force_chunk_alloc(struct btrfs_trans_handle *trans,
 			    struct btrfs_fs_info *fs_info, u64 type);
 int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 800aaf45e6bd..21a24fff32dd 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -11061,6 +11061,54 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
 	return ret;
 }
 
+int btrfs_clear_free_space(struct btrfs_root *root,
+		struct btrfs_ioctl_clear_free_args *args)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_block_group_cache *cache = NULL;
+	u64 group_cleared;
+	u64 start;
+	u64 cleared = 0;
+	u64 end;
+	int ret = 0;
+
+	cache = btrfs_lookup_first_block_group(fs_info, args->start);
+
+	while (cache) {
+		if (cache->key.objectid >= (args->start + args->length)) {
+			btrfs_put_block_group(cache);
+			break;
+		}
+
+		start = max(args->start, cache->key.objectid);
+		end = min(args->start + args->length,
+				cache->key.objectid + cache->key.offset);
+
+		if (end - start >= args->minlen) {
+			if (!block_group_cache_done(cache)) {
+				ret = cache_block_group(cache, 0);
+				if (!ret)
+					wait_block_group_cache_done(cache);
+			}
+			ret = btrfs_trim_block_group(cache, &group_cleared,
+					start, end, args->minlen,
+					args->type);
+
+			if (ret) {
+				btrfs_put_block_group(cache);
+				break;
+			}
+			cleared += group_cleared;
+		}
+
+		cache = next_block_group(fs_info, cache);
+	}
+
+	args->length = cleared;
+
+	return ret;
+}
+
 /*
  * btrfs_{start,end}_write_no_snapshotting() are similar to
  * mnt_{want,drop}_write(), they are used to prevent some tasks from writing
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9cc4fd25f83d..a56d4fb3ae82 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5429,6 +5429,46 @@ static int _btrfs_ioctl_send(struct file *file, void __user *argp, bool compat)
 	return ret;
 }
 
+static int btrfs_ioctl_clear_free(struct file *file, void __user *arg)
+{
+	struct btrfs_fs_info *fs_info;
+	struct btrfs_ioctl_clear_free_args args;
+	u64 total_bytes;
+	int ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (copy_from_user(&args, arg, sizeof(args)))
+		return -EFAULT;
+
+	if (args.type >= BTRFS_NR_CLEAR_OP_TYPES)
+		return -EOPNOTSUPP;
+
+	ret = mnt_want_write_file(file);
+	if (ret)
+		return ret;
+
+	fs_info = btrfs_sb(file_inode(file)->i_sb);
+	total_bytes = btrfs_super_total_bytes(fs_info->super_copy);
+	if (args.start > total_bytes) {
+		ret = -EINVAL;
+		goto out_drop_write;
+	}
+
+	ret = btrfs_clear_free_space(fs_info->tree_root, &args);
+	if (ret < 0)
+		goto out_drop_write;
+
+	if (copy_to_user(arg, &args, sizeof(args)))
+		ret = -EFAULT;
+
+out_drop_write:
+	mnt_drop_write_file(file);
+
+	return 0;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -5565,6 +5605,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_get_features(file, argp);
 	case BTRFS_IOC_SET_FEATURES:
 		return btrfs_ioctl_set_features(file, argp);
+	case BTRFS_IOC_CLEAR_FREE:
+		return btrfs_ioctl_clear_free(file, argp);
 	}
 
 	return -ENOTTY;
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index c8d99b9ca550..860f9df01614 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -737,6 +737,24 @@ enum btrfs_err_code {
 	BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS
 };
 
+/*
+ * Type of operation that will be used to clear unused blocks.
+ */
+enum btrfs_clear_op_type {
+	BTRFS_CLEAR_OP_DISCARD = 0,
+	BTRFS_CLEAR_OP_ZERO,
+	BTRFS_NR_CLEAR_OP_TYPES,
+};
+
+struct btrfs_ioctl_clear_free_args {
+	__u32 type;			/* in, btrfs_clear_free_op_type */
+	__u32 reserved1;		/* padding, must be zero */
+	__u64 start;			/* in */
+	__u64 length;			/* in, out */
+	__u64 minlen;			/* in */
+	__u64 reserved2[4];
+};
+
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
@@ -843,5 +861,7 @@ enum btrfs_err_code {
 				   struct btrfs_ioctl_vol_args_v2)
 #define BTRFS_IOC_LOGICAL_INO_V2 _IOWR(BTRFS_IOCTL_MAGIC, 59, \
 					struct btrfs_ioctl_logical_ino_args)
+#define BTRFS_IOC_CLEAR_FREE _IOW(BTRFS_IOCTL_MAGIC, 90, \
+				struct btrfs_ioctl_clear_free_args)
 
 #endif /* _UAPI_LINUX_BTRFS_H */
-- 
2.16.2

