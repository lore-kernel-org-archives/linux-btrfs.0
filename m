Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34363 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934820AbeEIN5V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 May 2018 09:57:21 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: misono.tomohiro@jp.fujitsu.com, David Sterba <dsterba@suse.com>
Subject: [PATCH v2 7/8] btrfs: add FS_IOC_FSSETXATTR ioctl
Date: Wed,  9 May 2018 15:54:42 +0200
Message-Id: <3094cba18b66bd4b5c8085ff02555dbf1be6c6c3.1525873677.git.dsterba@suse.com>
In-Reply-To: <cover.1525873677.git.dsterba@suse.com>
References: <cover.1525873677.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The new ioctl is an extension to the FS_IOC_SETFLAGS and adds new
flags and is extensible. Don't get fooled by the XATTR in the name, it
does not have anything in common with the extended attributes,
incidentally also abbreviated as XATTRs.

This patch allows to set the xflags portion of the fsxattr structure,
other items have no meaning and non-zero values will result in
EOPNOTSUPP.

Currently supported xflags:

- APPEND
- IMMUTABLE
- NOATIME
- NODUMP
- SYNC

The structure of btrfs_ioctl_fssetxattr copies btrfs_ioctl_setflags but
is simpler on the flag setting side.

The original patch was written by Chandan Jay Sharma but was incomplete
and no further revision has been sent.

Based-on-patches-by: Chandan Jay Sharma <chandansbg@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ioctl.c | 94 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 94 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a3bb59ac5666..838a7a80e6b0 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -388,6 +388,98 @@ static int btrfs_ioctl_fsgetxattr(struct file *file, void __user *arg)
 	return 0;
 }
 
+static int btrfs_ioctl_fssetxattr(struct file *file, void __user *arg)
+{
+	struct inode *inode = file_inode(file);
+	struct btrfs_inode *binode = BTRFS_I(inode);
+	struct btrfs_root *root = binode->root;
+	struct btrfs_trans_handle *trans;
+	struct fsxattr fa;
+	unsigned old_flags;
+	unsigned old_i_flags;
+	int ret = 0;
+
+	if (!inode_owner_or_capable(inode))
+		return -EPERM;
+
+	if (btrfs_root_readonly(root))
+		return -EROFS;
+
+	memset(&fa, 0, sizeof(fa));
+	if (copy_from_user(&fa, arg, sizeof(fa)))
+		return -EFAULT;
+
+	ret = check_xflags(fa.fsx_xflags);
+	if (ret)
+		return ret;
+
+	if (fa.fsx_extsize != 0 || fa.fsx_projid != 0 || fa.fsx_cowextsize != 0)
+		return -EOPNOTSUPP;
+
+	ret = mnt_want_write_file(file);
+	if (ret)
+		return ret;
+
+	inode_lock(inode);
+
+	old_flags = binode->flags;
+	old_i_flags = inode->i_flags;
+
+	/* We need the capabilities to change append-only or immutable inode */
+	if (((old_flags & (BTRFS_INODE_APPEND | BTRFS_INODE_IMMUTABLE)) ||
+	     (fa.fsx_xflags & (FS_XFLAG_APPEND | FS_XFLAG_IMMUTABLE))) &&
+	    !capable(CAP_LINUX_IMMUTABLE)) {
+		ret = -EPERM;
+		goto out_unlock;
+	}
+
+	if (fa.fsx_xflags & FS_XFLAG_SYNC)
+		binode->flags |= BTRFS_INODE_SYNC;
+	else
+		binode->flags &= ~BTRFS_INODE_SYNC;
+	if (fa.fsx_xflags & FS_XFLAG_IMMUTABLE)
+		binode->flags |= BTRFS_INODE_IMMUTABLE;
+	else
+		binode->flags &= ~BTRFS_INODE_IMMUTABLE;
+	if (fa.fsx_xflags & FS_XFLAG_APPEND)
+		binode->flags |= BTRFS_INODE_APPEND;
+	else
+		binode->flags &= ~BTRFS_INODE_APPEND;
+	if (fa.fsx_xflags & FS_XFLAG_NODUMP)
+		binode->flags |= BTRFS_INODE_NODUMP;
+	else
+		binode->flags &= ~BTRFS_INODE_NODUMP;
+	if (fa.fsx_xflags & FS_XFLAG_NOATIME)
+		binode->flags |= BTRFS_INODE_NOATIME;
+	else
+		binode->flags &= ~BTRFS_INODE_NOATIME;
+
+	/* 1 item for the inode */
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out_unlock;
+	}
+
+	btrfs_sync_inode_flags_to_i_flags(inode);
+	inode_inc_iversion(inode);
+	inode->i_ctime = current_time(inode);
+	ret = btrfs_update_inode(trans, root, inode);
+
+	btrfs_end_transaction(trans);
+
+out_unlock:
+	if (ret) {
+		binode->flags = old_flags;
+		inode->i_flags = old_i_flags;
+	}
+
+	inode_unlock(inode);
+	mnt_drop_write_file(file);
+
+	return ret;
+}
+
 static int btrfs_ioctl_getversion(struct file *file, int __user *arg)
 {
 	struct inode *inode = file_inode(file);
@@ -5620,6 +5712,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_set_features(file, argp);
 	case FS_IOC_FSGETXATTR:
 		return btrfs_ioctl_fsgetxattr(file, argp);
+	case FS_IOC_FSSETXATTR:
+		return btrfs_ioctl_fssetxattr(file, argp);
 	}
 
 	return -ENOTTY;
-- 
2.16.2

