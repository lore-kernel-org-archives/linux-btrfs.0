Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56563 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858Ab3H0TR7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Aug 2013 15:17:59 -0400
Message-ID: <521CFB62.7010600@suse.com>
Date: Tue, 27 Aug 2013 15:17:54 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: Chris Mason <clmason@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: add ability to query/change feature bits online
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are some feature bits that require no offline setup and can
be enabled online. I've only reviewed extended irefs, but there will
probably be more.

We introduce three new ioctls:
- BTRFS_IOC_GET_SUPPORTED_FEATURES: query the kernel for supported features
- BTRFS_IOC_GET_FEATURES: query the kernel for enabled features on a per-fs
  basis.
- BTRFS_IOC_ADD_FEATURES: enable new features on a per-fs basis.

We introduce a new mask _SAFE_ONLINE that allows us to define which
features are safe to enable at runtime.

The failure modes for BTRFS_IOC_ADD_FEATURES are as follows:
- Enabling a completely unsupported feature: warns and returns -ENOTSUPP
- Enabling a feature that can only be done offline: warns and returns -EPERM

The structure passed in is not modified on return since it is possible
to isolate which features would bounce a -EPERM by subtracting the features
provided by a GET_SUPPORTED_FEATURES call.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h           |    6 ++
 fs/btrfs/ioctl.c           |  127 +++++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/btrfs.h |   12 ++++
 3 files changed, 145 insertions(+)

--- a/fs/btrfs/ctree.h	2013-08-27 11:02:35.062626912 -0400
+++ b/fs/btrfs/ctree.h	2013-08-27 11:03:32.002352821 -0400
@@ -512,7 +512,10 @@ struct btrfs_super_block {
 #define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
 
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
+#define BTRFS_FEATURE_COMPAT_ONLINE_SAFE	0ULL
 #define BTRFS_FEATURE_COMPAT_RO_SUPP		0ULL
+#define BTRFS_FEATURE_COMPAT_RO_ONLINE_SAFE	0ULL
+
 #define BTRFS_FEATURE_INCOMPAT_SUPP			\
 	(BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF |		\
 	 BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL |	\
@@ -523,6 +526,9 @@ struct btrfs_super_block {
 	 BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF |		\
 	 BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA)
 
+#define BTRFS_FEATURE_INCOMPAT_ONLINE_SAFE	\
+	(BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF)
+
 /*
  * A leaf is full of items. offset and size tell us where to find
  * the item in the leaf (relative to the start of the data area)
--- a/fs/btrfs/ioctl.c	2013-08-27 11:02:35.062626912 -0400
+++ b/fs/btrfs/ioctl.c	2013-08-27 15:08:06.900740843 -0400
@@ -4098,6 +4098,127 @@ out_unlock:
 	return ret;
 }
 
+static int btrfs_ioctl_get_supported_features(struct file *file,
+					      void __user *arg)
+{
+	struct btrfs_ioctl_feature_flags features[2];
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	features[0].compat_flags = BTRFS_FEATURE_COMPAT_SUPP;
+	features[0].compat_ro_flags = BTRFS_FEATURE_COMPAT_RO_SUPP;
+	features[0].incompat_flags = BTRFS_FEATURE_INCOMPAT_SUPP;
+
+	features[1].compat_flags = BTRFS_FEATURE_COMPAT_ONLINE_SAFE;
+	features[1].compat_ro_flags = BTRFS_FEATURE_COMPAT_RO_ONLINE_SAFE;
+	features[1].incompat_flags = BTRFS_FEATURE_INCOMPAT_ONLINE_SAFE;
+
+	if (copy_to_user(arg, &features, sizeof(features)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int btrfs_ioctl_get_features(struct file *file, void __user *arg)
+{
+	struct btrfs_root *root = BTRFS_I(file_inode(file))->root;
+	struct btrfs_super_block *super_block = root->fs_info->super_copy;
+	struct btrfs_ioctl_feature_flags features;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	features.compat_flags = btrfs_super_compat_flags(super_block);
+	features.compat_ro_flags = btrfs_super_compat_ro_flags(super_block);
+	features.incompat_flags = btrfs_super_incompat_flags(super_block);
+
+	if (copy_to_user(arg, &features, sizeof(features)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int check_feature_bits(struct btrfs_root *root, const char *type,
+			      u64 flags, u64 supported_flags,
+			      u64 allowed_flags)
+{
+	u64 disallowed, unsupported;
+
+	unsupported = flags & ~supported_flags;
+	if (unsupported) {
+		btrfs_warn(root->fs_info,
+			   "this kernel does not support %s bits %llx", type,
+			   unsupported);
+		return -EOPNOTSUPP;
+	}
+
+	disallowed = flags & ~allowed_flags;
+	if (disallowed) {
+		btrfs_warn(root->fs_info,
+			   "can't enable %s bits %llx while mounted", type,
+			   disallowed);
+		return -EPERM;
+	}
+
+	return 0;
+}
+
+#define check_feature(root, flags, mask_base)			\
+check_feature_bits(root, # mask_base, flags,			\
+		BTRFS_FEATURE_ ## mask_base ## _SUPP,		\
+		BTRFS_FEATURE_ ## mask_base ## _ONLINE_SAFE)
+
+static int btrfs_ioctl_add_features(struct file *file, void __user *arg)
+{
+	struct btrfs_root *root = BTRFS_I(file_inode(file))->root;
+	struct btrfs_super_block *super_block = root->fs_info->super_copy;
+	struct btrfs_ioctl_feature_flags features;
+	int ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (copy_from_user(&features, arg, sizeof(features)))
+		return -EFAULT;
+
+	ret = check_feature(root, features.compat_flags, COMPAT);
+	if (ret)
+		return ret;
+
+	ret = check_feature(root, features.compat_ro_flags, COMPAT_RO);
+	if (ret)
+		return ret;
+
+	ret = check_feature(root, features.incompat_flags, INCOMPAT);
+	if (ret)
+		return ret;
+
+	if (features.compat_flags || features.compat_ro_flags ||
+	    features.incompat_flags) {
+		u64 flags;
+		struct btrfs_trans_handle *trans;
+		trans = btrfs_start_transaction(root, 1);
+		if (IS_ERR(trans))
+			return PTR_ERR(trans);
+
+		flags = btrfs_super_compat_flags(super_block);
+		flags |= features.compat_flags;
+		btrfs_set_super_compat_flags(super_block, flags);
+
+		flags = btrfs_super_compat_ro_flags(super_block);
+		flags |= features.compat_ro_flags;
+		btrfs_set_super_compat_ro_flags(super_block, flags);
+
+		flags = btrfs_super_incompat_flags(super_block);
+		flags |= features.incompat_flags;
+		btrfs_set_super_incompat_flags(super_block, flags);
+		return btrfs_end_transaction(trans, root);
+	}
+
+	return 0;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -4208,6 +4329,12 @@ long btrfs_ioctl(struct file *file, unsi
 		return btrfs_ioctl_get_fslabel(file, argp);
 	case BTRFS_IOC_SET_FSLABEL:
 		return btrfs_ioctl_set_fslabel(file, argp);
+	case BTRFS_IOC_GET_SUPPORTED_FEATURES:
+		return btrfs_ioctl_get_supported_features(file, argp);
+	case BTRFS_IOC_GET_FEATURES:
+		return btrfs_ioctl_get_features(file, argp);
+	case BTRFS_IOC_ADD_FEATURES:
+		return btrfs_ioctl_add_features(file, argp);
 	}
 
 	return -ENOTTY;
--- a/include/uapi/linux/btrfs.h	2013-08-27 11:02:35.062626912 -0400
+++ b/include/uapi/linux/btrfs.h	2013-08-27 11:03:32.006352802 -0400
@@ -184,6 +184,12 @@ struct btrfs_ioctl_fs_info_args {
 	__u64 reserved[124];			/* pad to 1k */
 };
 
+struct btrfs_ioctl_feature_flags {
+	__u64 compat_flags;
+	__u64 compat_ro_flags;
+	__u64 incompat_flags;
+};
+
 /* balance control ioctl modes */
 #define BTRFS_BALANCE_CTL_PAUSE		1
 #define BTRFS_BALANCE_CTL_CANCEL	2
@@ -579,4 +585,10 @@ static inline char *btrfs_err_str(enum b
 				      struct btrfs_ioctl_get_dev_stats)
 #define BTRFS_IOC_DEV_REPLACE _IOWR(BTRFS_IOCTL_MAGIC, 53, \
 				    struct btrfs_ioctl_dev_replace_args)
+#define BTRFS_IOC_GET_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 54, \
+				   struct btrfs_ioctl_feature_flags)
+#define BTRFS_IOC_ADD_FEATURES _IOW(BTRFS_IOCTL_MAGIC, 55, \
+				   struct btrfs_ioctl_feature_flags)
+#define BTRFS_IOC_GET_SUPPORTED_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 56, \
+				   struct btrfs_ioctl_feature_flags[2])
 #endif /* _UAPI_LINUX_BTRFS_H */

-- 
Jeff Mahoney
SUSE Labs
