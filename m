Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44797 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbaAPOua (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jan 2014 09:50:30 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 728F7AC3E
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Jan 2014 14:50:29 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH v2] btrfs: call permission checks earlier in ioctls and return EPERM
Date: Thu, 16 Jan 2014 15:50:22 +0100
Message-Id: <1389883822-30463-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <1389806820-15250-1-git-send-email-dsterba@suse.cz>
References: <1389806820-15250-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The owner and capability checks in IOC_SUBVOL_SETFLAGS and
SET_RECEIVED_SUBVOL should be called before any other checks are done.

Also unify the error code to EPERM.

Signed-off-by: David Sterba <dsterba@suse.cz>
---

v2: Fix typo, refresh patch for btrfs-next

 fs/btrfs/ioctl.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 3970f32b2b80..62e169e8f19c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -192,6 +192,9 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	unsigned int i_oldflags;
 	umode_t mode;
 
+	if (!inode_owner_or_capable(inode))
+		return -EPERM;
+
 	if (btrfs_root_readonly(root))
 		return -EROFS;
 
@@ -202,9 +205,6 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	if (ret)
 		return ret;
 
-	if (!inode_owner_or_capable(inode))
-		return -EACCES;
-
 	ret = mnt_want_write_file(file);
 	if (ret)
 		return ret;
@@ -1691,6 +1691,9 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
 	u64 flags;
 	int ret = 0;
 
+	if (!inode_owner_or_capable(inode))
+		return -EPERM;
+
 	ret = mnt_want_write_file(file);
 	if (ret)
 		goto out;
@@ -1715,11 +1718,6 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
 		goto out_drop_write;
 	}
 
-	if (!inode_owner_or_capable(inode)) {
-		ret = -EACCES;
-		goto out_drop_write;
-	}
-
 	down_write(&root->fs_info->subvol_sem);
 
 	/* nothing to do */
@@ -4384,6 +4382,9 @@ static long btrfs_ioctl_set_received_subvol(struct file *file,
 	int ret = 0;
 	int received_uuid_changed;
 
+	if (!inode_owner_or_capable(inode))
+		return -EPERM;
+
 	ret = mnt_want_write_file(file);
 	if (ret < 0)
 		return ret;
@@ -4400,11 +4401,6 @@ static long btrfs_ioctl_set_received_subvol(struct file *file,
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
1.7.9

