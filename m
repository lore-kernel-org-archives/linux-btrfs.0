Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53819 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928AbaAOR1D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jan 2014 12:27:03 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id D6127AAD1
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Jan 2014 17:27:01 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: call permission checks earlier in ioctls and return EPERM
Date: Wed, 15 Jan 2014 18:27:00 +0100
Message-Id: <1389806820-15250-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The owner and capability checks in IOC_SUBVOL_SETFLAGS and
SET_RECEIVED_SUBVOL should be called before any other checks are done.

Also unify the error code to EPERM.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ioctl.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 21da5762b0b1..f21facd84947 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -190,6 +190,9 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	unsigned int i_oldflags;
 	umode_t mode;
 
+	if (!inode_owner_or_capable(inode))
+		return -PERM;
+
 	if (btrfs_root_readonly(root))
 		return -EROFS;
 
@@ -200,9 +203,6 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	if (ret)
 		return ret;
 
-	if (!inode_owner_or_capable(inode))
-		return -EACCES;
-
 	ret = mnt_want_write_file(file);
 	if (ret)
 		return ret;
@@ -1662,6 +1662,9 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
 	u64 flags;
 	int ret = 0;
 
+	if (!inode_owner_or_capable(inode))
+		return -EPERM;
+
 	ret = mnt_want_write_file(file);
 	if (ret)
 		goto out;
@@ -1686,11 +1689,6 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
 		goto out_drop_write;
 	}
 
-	if (!inode_owner_or_capable(inode)) {
-		ret = -EACCES;
-		goto out_drop_write;
-	}
-
 	down_write(&root->fs_info->subvol_sem);
 
 	/* nothing to do */
@@ -4325,6 +4323,9 @@ static long btrfs_ioctl_set_received_subvol(struct file *file,
 	int ret = 0;
 	int received_uuid_changed;
 
+	if (!inode_owner_or_capable(inode))
+		return -EPERM;
+
 	ret = mnt_want_write_file(file);
 	if (ret < 0)
 		return ret;
@@ -4341,11 +4342,6 @@ static long btrfs_ioctl_set_received_subvol(struct file *file,
 		goto out;
 	}
 
-	if (!inode_owner_or_capable(inode)) {
-		ret = -EACCES;
-		goto out;
-	}
-
 	sa = memdup_user(arg, sizeof(*sa));
 	if (IS_ERR(sa)) {
 		ret = PTR_ERR(sa);
-- 
1.8.5

