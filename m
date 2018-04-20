Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55048 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753606AbeDTRFQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Apr 2018 13:05:16 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D96B3AC4F
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Apr 2018 17:05:14 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 6/7] btrfs: add FS_IOC_FSGETXATTR ioctl
Date: Fri, 20 Apr 2018 19:02:43 +0200
Message-Id: <ecd125f68764400e5812653b9bc40f1a626a1314.1524242295.git.dsterba@suse.com>
In-Reply-To: <cover.1524242295.git.dsterba@suse.com>
References: <cover.1524242295.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The new ioctl is an extension to the FS_IOC_GETFLAGS and adds new
flags and is extensible. This patch allows to return the xflags portion
of the fsxattr structure, other items have no meaning for btrfs or can
be added later.

The original patch was written by Chandan Jay Sharma but was incomplete
and no further revision has been sent. Several cleanups were necessary
to avoid confusion with other ioctls, as we have another flavor of
flags.

Based-on-patches-by: Chandan Jay Sharma <chandansbg@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ioctl.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a25ad4e6a478..52b12ab9b82b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -370,6 +370,24 @@ static int check_xflags(unsigned int flags)
 	return 0;
 }
 
+/*
+ * Set the xflags from the internal inode flags. The remaining items of fsxattr
+ * are zeroed.
+ */
+static int btrfs_ioctl_fsgetxattr(struct file *file, void __user *arg)
+{
+	struct btrfs_inode *binode = BTRFS_I(file_inode(file));
+	struct fsxattr fa;
+
+	memset(&fa, 0, sizeof(fa));
+	fa.fsx_xflags = btrfs_inode_flags_to_xflags(binode->flags);
+
+	if (copy_to_user(arg, &fa, sizeof(fa)))
+		return -EFAULT;
+
+	return 0;
+}
+
 static int btrfs_ioctl_getversion(struct file *file, int __user *arg)
 {
 	struct inode *inode = file_inode(file);
@@ -5600,6 +5618,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_get_features(file, argp);
 	case BTRFS_IOC_SET_FEATURES:
 		return btrfs_ioctl_set_features(file, argp);
+	case FS_IOC_FSGETXATTR:
+		return btrfs_ioctl_fsgetxattr(file, argp);
 	}
 
 	return -ENOTTY;
-- 
2.16.2

