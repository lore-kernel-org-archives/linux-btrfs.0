Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56509 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946124AbcBRNZk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Feb 2016 08:25:40 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id D4CD8AC01
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Feb 2016 13:25:38 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/2] btrfs: add GET_SUPPORTED_FEATURES to the control device ioctls
Date: Thu, 18 Feb 2016 14:25:33 +0100
Message-Id: <f85225cc3f232fda01c71c5c1afee0139a8ee5ef.1455801904.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The control device is accessible when no filesystem is mounted and we
may want to query features supported by the module. This is already
possible using the sysfs files, this ioctl is for parity and
convenience.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h | 1 +
 fs/btrfs/ioctl.c | 3 +--
 fs/btrfs/super.c | 4 ++++
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index bfe4a337fb4d..47bc50fd4f55 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -4089,6 +4089,7 @@ void btrfs_test_inode_set_ops(struct inode *inode);
 
 /* ioctl.c */
 long btrfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
+int btrfs_ioctl_get_supported_features(struct file *file, void __user *arg);
 void btrfs_update_iflags(struct inode *inode);
 void btrfs_inherit_iflags(struct inode *inode, struct inode *dir);
 int btrfs_is_empty_uuid(u8 *uuid);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 952172ca7e45..f4c6ed5c5300 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5187,8 +5187,7 @@ static int btrfs_ioctl_set_fslabel(struct file *file, void __user *arg)
 	  .compat_ro_flags = BTRFS_FEATURE_COMPAT_RO_##suffix, \
 	  .incompat_flags = BTRFS_FEATURE_INCOMPAT_##suffix }
 
-static int btrfs_ioctl_get_supported_features(struct file *file,
-					      void __user *arg)
+int btrfs_ioctl_get_supported_features(struct file *file, void __user *arg)
 {
 	static const struct btrfs_ioctl_feature_flags features[3] = {
 		INIT_FEATURE_FLAGS(SUPP),
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index d41e09fe8e38..dda6f64dfd73 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2163,6 +2163,10 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 			break;
 		ret = !(fs_devices->num_devices == fs_devices->total_devices);
 		break;
+	case BTRFS_IOC_GET_SUPPORTED_FEATURES:
+		ret = btrfs_ioctl_get_supported_features(NULL,
+				(void __user*)arg);
+		break;
 	}
 
 	kfree(vol);
-- 
2.7.1

