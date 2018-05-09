Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34339 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756254AbeEIN5N (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 May 2018 09:57:13 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: misono.tomohiro@jp.fujitsu.com, David Sterba <dsterba@suse.com>
Subject: [PATCH v2 4/8] btrfs: rename btrfs_flags_to_ioctl to reflect which flags it touches
Date: Wed,  9 May 2018 15:54:35 +0200
Message-Id: <b17d538148dac18c90094a542444aefb2ade12ae.1525873677.git.dsterba@suse.com>
In-Reply-To: <cover.1525873677.git.dsterba@suse.com>
References: <cover.1525873677.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Converts btrfs_inode::flags to the FS_*_FL flags.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ioctl.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0b84f9e68f86..40eeb99310d5 100644
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

