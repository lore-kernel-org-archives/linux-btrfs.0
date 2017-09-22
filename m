Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:40142 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752290AbdIVR6x (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Sep 2017 13:58:53 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs: add a flags argument to LOGICAL_INO and call it LOGICAL_INO_V2
Date: Fri, 22 Sep 2017 13:58:46 -0400
Message-Id: <20170922175847.6071-3-ce3g8jdj@umail.furryterror.org>
In-Reply-To: <20170922175847.6071-1-ce3g8jdj@umail.furryterror.org>
References: <20170922175847.6071-1-ce3g8jdj@umail.furryterror.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now that check_extent_in_eb()'s extent offset filter can be turned off,
we need a way to do it from userspace.

Add a 'flags' field to the btrfs_logical_ino_args structure to disable
extent offset filtering, taking the place of one of the existing
reserved[] fields.

Previous versions of LOGICAL_INO neglected to check whether any of the
reserved fields have non-zero values.  Assigning meaning to those fields
now may change the behavior of existing programs that left these fields
uninitialized.  The lack of a zero check also means that new programs
have no way to know whether the kernel is honoring the flags field.

To avoid these problems, define a new ioctl LOGICAL_INO_V2.  We can
use the same argument layout as LOGICAL_INO, but shorten the reserved[]
array by one element and turn it into the 'flags' field.  The V2 ioctl
explicitly checks that reserved fields and unsupported flag bits are zero
so that userspace can negotiate future feature bits as they are defined.

Since the memory layouts of the two ioctls' arguments are compatible,
there is no need for a separate function for logical_to_ino_v2 (contrast
with tree_search_v2 vs tree_search where the layout and code are quite
different).  A version parameter and an 'if' statement will suffice.

Now that we have a flags field in logical_ino_args, add a flag
BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET to get the behavior we want,
and pass it down the stack to iterate_inodes_from_logical.

Signed-off-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
---
 fs/btrfs/ioctl.c           | 26 +++++++++++++++++++++++---
 include/uapi/linux/btrfs.h |  8 +++++++-
 2 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b7de32568082..f4281ffd1833 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4536,13 +4536,14 @@ static int build_ino_list(u64 inum, u64 offset, u64 root, void *ctx)
 }
 
 static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
-					void __user *arg)
+					void __user *arg, int version)
 {
 	int ret = 0;
 	int size;
 	struct btrfs_ioctl_logical_ino_args *loi;
 	struct btrfs_data_container *inodes = NULL;
 	struct btrfs_path *path = NULL;
+	bool ignore_offset;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -4551,6 +4552,22 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
 	if (IS_ERR(loi))
 		return PTR_ERR(loi);
 
+	if (version == 1) {
+		ignore_offset = false;
+	} else {
+		/* All reserved bits must be 0 for now */
+		if (memchr_inv(loi->reserved, 0, sizeof(loi->reserved))) {
+			ret = -EINVAL;
+			goto out_loi;
+		}
+		/* Only accept flags we have defined so far */
+		if (loi->flags & ~(BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET)) {
+			ret = -EINVAL;
+			goto out_loi;
+		}
+		ignore_offset = loi->flags & BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET;
+	}
+
 	path = btrfs_alloc_path();
 	if (!path) {
 		ret = -ENOMEM;
@@ -4566,7 +4583,7 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
 	}
 
 	ret = iterate_inodes_from_logical(loi->logical, fs_info, path,
-					  build_ino_list, inodes, false);
+					  build_ino_list, inodes, ignore_offset);
 	if (ret == -EINVAL)
 		ret = -ENOENT;
 	if (ret < 0)
@@ -4580,6 +4597,7 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
 out:
 	btrfs_free_path(path);
 	kvfree(inodes);
+out_loi:
 	kfree(loi);
 
 	return ret;
@@ -5550,7 +5568,9 @@ long btrfs_ioctl(struct file *file, unsigned int
 	case BTRFS_IOC_INO_PATHS:
 		return btrfs_ioctl_ino_to_path(root, argp);
 	case BTRFS_IOC_LOGICAL_INO:
-		return btrfs_ioctl_logical_to_ino(fs_info, argp);
+		return btrfs_ioctl_logical_to_ino(fs_info, argp, 1);
+	case BTRFS_IOC_LOGICAL_INO_V2:
+		return btrfs_ioctl_logical_to_ino(fs_info, argp, 2);
 	case BTRFS_IOC_SPACE_INFO:
 		return btrfs_ioctl_space_info(fs_info, argp);
 	case BTRFS_IOC_SYNC: {
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 378230c163d5..99bb7988e6fe 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -608,10 +608,14 @@ struct btrfs_ioctl_ino_path_args {
 struct btrfs_ioctl_logical_ino_args {
 	__u64				logical;	/* in */
 	__u64				size;		/* in */
-	__u64				reserved[4];
+	__u64				reserved[3];	/* must be 0 for now */
+	__u64				flags;		/* in, v2 only */
 	/* struct btrfs_data_container	*inodes;	out   */
 	__u64				inodes;
 };
+/* Return every ref to the extent, not just those containing logical block.
+ * Requires logical == extent bytenr. */
+#define BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET	(1ULL << 0)
 
 enum btrfs_dev_stat_values {
 	/* disk I/O failure stats */
@@ -835,5 +839,7 @@ enum btrfs_err_code {
 				   struct btrfs_ioctl_feature_flags[3])
 #define BTRFS_IOC_RM_DEV_V2 _IOW(BTRFS_IOCTL_MAGIC, 58, \
 				   struct btrfs_ioctl_vol_args_v2)
+#define BTRFS_IOC_LOGICAL_INO_V2 _IOWR(BTRFS_IOCTL_MAGIC, 59, \
+					struct btrfs_ioctl_logical_ino_args)
 
 #endif /* _UAPI_LINUX_BTRFS_H */
-- 
2.11.0

