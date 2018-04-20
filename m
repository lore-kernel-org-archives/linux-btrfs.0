Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55031 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753074AbeDTRFL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Apr 2018 13:05:11 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 46E25AC4F
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Apr 2018 17:05:10 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 4/7] btrfs: rename btrfs_flags_to_ioctl to reflect which flags it touches
Date: Fri, 20 Apr 2018 19:02:38 +0200
Message-Id: <2f7110c081dcf9c2523de8ca5357ad7efeeba40d.1524242295.git.dsterba@suse.com>
In-Reply-To: <cover.1524242295.git.dsterba@suse.com>
References: <cover.1524242295.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Converts btrfs_inode::flags to the FS_*_FL flags.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ioctl.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 953473f2a136..f0e6074233fa 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -105,9 +105,10 @@ static unsigned int btrfs_mask_fsflags_for_type(struct inode *inode,
 }
 
 /*
- * Export inode flags to the format expected by the FS_IOC_GETFLAGS ioctl.
+ * Export internal inode flags to the format expected by the FS_IOC_GETFLAGS
+ * ioctl.
  */
-static unsigned int btrfs_flags_to_ioctl(unsigned int flags)
+static unsigned int btrfs_inode_flags_to_fsflags(unsigned int flags)
 {
 	unsigned int iflags = 0;
 
@@ -161,7 +162,7 @@ void btrfs_sync_inode_flags_to_i_flags(struct inode *inode)
 static int btrfs_ioctl_getflags(struct file *file, void __user *arg)
 {
 	struct btrfs_inode *ip = BTRFS_I(file_inode(file));
-	unsigned int flags = btrfs_flags_to_ioctl(ip->flags);
+	unsigned int flags = btrfs_inode_flags_to_fsflags(ip->flags);
 
 	if (copy_to_user(arg, &flags, sizeof(flags)))
 		return -EFAULT;
@@ -221,7 +222,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	mode = inode->i_mode;
 
 	flags = btrfs_mask_fsflags_for_type(inode, flags);
-	oldflags = btrfs_flags_to_ioctl(ip->flags);
+	oldflags = btrfs_inode_flags_to_fsflags(ip->flags);
 	if ((flags ^ oldflags) & (FS_APPEND_FL | FS_IMMUTABLE_FL)) {
 		if (!capable(CAP_LINUX_IMMUTABLE)) {
 			ret = -EPERM;
-- 
2.16.2

