Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48511 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750742AbdCNJFr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Mar 2017 05:05:47 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v2E93xSc018438
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Mar 2017 05:05:46 -0400
Received: from e28smtp03.in.ibm.com (e28smtp03.in.ibm.com [125.16.236.3])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2960gyrv9d-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Mar 2017 05:05:45 -0400
Received: from localhost
        by e28smtp03.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandansbg@gmail.com>;
        Tue, 14 Mar 2017 14:35:42 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
        by d28relay09.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v2E95dvM17498290
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Mar 2017 14:35:39 +0530
Received: from d28av04.in.ibm.com (localhost [127.0.0.1])
        by d28av04.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v2E95djN005428
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Mar 2017 14:35:39 +0530
From: Chandan Jay Sharma <chandansbg@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, chandan.opensource@gmail.com
Subject: [PATCH] btrfs: add support for extended file attributes
Date: Tue, 14 Mar 2017 14:35:33 +0530
Message-Id: <1489482333-7409-1-git-send-email-chandansbg@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This commit impliments FS_IOC_FSGETXATTR and FS_IOC_FSSETXATTR ioctls for BTRFS.

Signed-off-by: Chandan Jay Sharma <chandansbg@gmail.com>
---
 fs/btrfs/ioctl.c | 146 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 146 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 33f967d..9d30afe 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -132,6 +132,25 @@ static unsigned int btrfs_flags_to_ioctl(unsigned int flags)
 	return iflags;
 }
 
+/* Transfer ioctl flags to btrfs internal flags */
+static unsigned int btrfs_ioctl_to_flags(unsigned int iflags)
+{
+	unsigned int flags = 0;
+
+	if (iflags & FS_SYNC_FL)
+		flags |= BTRFS_INODE_SYNC;
+	if (iflags & FS_IMMUTABLE_FL)
+		flags |= BTRFS_INODE_IMMUTABLE;
+	if (iflags & FS_APPEND_FL)
+		flags |= BTRFS_INODE_APPEND;
+	if (iflags & FS_NODUMP_FL)
+		flags |= BTRFS_INODE_NODUMP;
+	if (iflags & FS_NOATIME_FL)
+		flags |= BTRFS_INODE_NOATIME;
+
+	return flags;
+}
+
 /*
  * Update inode->i_flags based on the btrfs internal flags.
  */
@@ -157,6 +176,75 @@ void btrfs_update_iflags(struct inode *inode)
 }
 
 /*
+ * Propagate flags from i_flags to BTRFS_I(inode)->flags
+ */
+void btrfs_get_inode_flags(struct btrfs_inode *ip)
+{
+	unsigned int vfs_fl;
+	unsigned long old_fl, new_fl;
+
+	do {
+		vfs_fl = ip->vfs_inode.i_flags;
+		old_fl = ip->flags;
+		new_fl = old_fl & ~(BTRFS_INODE_SYNC | BTRFS_INODE_APPEND |
+				BTRFS_INODE_IMMUTABLE | BTRFS_INODE_NOATIME |
+				BTRFS_INODE_DIRSYNC);
+		if (vfs_fl & S_SYNC)
+			new_fl |= BTRFS_INODE_SYNC;
+		if (vfs_fl & S_APPEND)
+			new_fl |= BTRFS_INODE_APPEND;
+		if (vfs_fl & S_IMMUTABLE)
+			new_fl |= BTRFS_INODE_IMMUTABLE;
+		if (vfs_fl & S_NOATIME)
+			new_fl |= BTRFS_INODE_NOATIME;
+		if (vfs_fl & S_DIRSYNC)
+			new_fl |= BTRFS_INODE_DIRSYNC;
+	} while (cmpxchg(&ip->flags, old_fl, new_fl) != old_fl);
+}
+
+/*
+ * Translate btrfs internal flags BTRFS_I(inode)->flags to xflags.
+ */
+static inline unsigned int btrfs_flags_to_xflags(unsigned int flags)
+{
+	unsigned int xflags = 0;
+
+	if (flags & BTRFS_INODE_SYNC)
+		xflags |= FS_XFLAG_SYNC;
+	if (flags & BTRFS_INODE_IMMUTABLE)
+		xflags |= FS_XFLAG_IMMUTABLE;
+	if (flags & BTRFS_INODE_APPEND)
+		xflags |= FS_XFLAG_APPEND;
+	if (flags & BTRFS_INODE_NODUMP)
+		xflags |= FS_XFLAG_NODUMP;
+	if (flags & BTRFS_INODE_NOATIME)
+		xflags |= FS_XFLAG_NOATIME;
+
+	return xflags;
+}
+
+/*
+ * Transfer xflags flags to ioctl flags.
+ */
+static inline unsigned int btrfs_xflags_to_ioctl(unsigned int xflags)
+{
+	unsigned int flags = 0;
+
+	if (xflags & FS_XFLAG_SYNC)
+		flags |= FS_SYNC_FL;
+	if (xflags & FS_XFLAG_IMMUTABLE)
+		flags |= FS_IMMUTABLE_FL;
+	if (xflags & FS_XFLAG_APPEND)
+		flags |= FS_APPEND_FL;
+	if (xflags & FS_XFLAG_NODUMP)
+		flags |= FS_NODUMP_FL;
+	if (xflags & FS_XFLAG_NOATIME)
+		flags |= FS_NOATIME_FL;
+
+	return flags;
+}
+
+/*
  * Inherit flags from the parent inode.
  *
  * Currently only the compression flags and the cow flags are inherited.
@@ -5511,6 +5599,60 @@ static int btrfs_ioctl_set_features(struct file *file, void __user *arg)
 	return ret;
 }
 
+static int btrfs_ioctl_fsgetxattr(struct file *file, void __user *arg)
+{
+	struct fsxattr fa;
+	struct btrfs_inode *ip = BTRFS_I(file_inode(file));
+
+	memset(&fa, 0, sizeof(struct fsxattr));
+	btrfs_get_inode_flags(ip);
+	fa.fsx_xflags = btrfs_flags_to_xflags(ip->flags);
+
+	if (copy_to_user(arg, &fa, sizeof(fa)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int btrfs_ioctl_fssetxattr(struct file *file, void __user *arg)
+{
+	struct inode *inode = file_inode(file);
+	struct btrfs_inode *ip = BTRFS_I(inode);
+	struct btrfs_root *root = ip->root;
+	struct fsxattr fa;
+	unsigned int flags;
+	int err;
+
+	/* Make sure caller has proper permission */
+	if (!inode_owner_or_capable(inode))
+		return -EPERM;
+
+	if (btrfs_root_readonly(root))
+		return -EROFS;
+
+	memset(&fa, 0, sizeof(struct fsxattr));
+	if (copy_from_user(&fa, arg, sizeof(fa)))
+		return -EFAULT;
+
+	flags = btrfs_xflags_to_ioctl(fa.fsx_xflags);
+
+	if (btrfs_mask_flags(inode->i_mode, flags) != flags)
+		return -EOPNOTSUPP;
+
+	err = mnt_want_write_file(file);
+	if (err)
+		return err;
+
+	inode_lock(inode);
+	ip->flags = (ip->flags | btrfs_ioctl_to_flags(flags));
+	btrfs_update_iflags(inode);
+	inode_unlock(inode);
+
+	mnt_drop_write_file(file);
+
+	return 0;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -5645,6 +5787,10 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_get_features(file, argp);
 	case BTRFS_IOC_SET_FEATURES:
 		return btrfs_ioctl_set_features(file, argp);
+	case FS_IOC_FSGETXATTR:
+		return btrfs_ioctl_fsgetxattr(file, argp);
+	case FS_IOC_FSSETXATTR:
+		return btrfs_ioctl_fssetxattr(file, argp);
 	}
 
 	return -ENOTTY;
-- 
2.7.4

