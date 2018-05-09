Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34325 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751052AbeEIN5J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 May 2018 09:57:09 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: misono.tomohiro@jp.fujitsu.com, David Sterba <dsterba@suse.com>
Subject: [PATCH v2 2/8] btrfs: rename btrfs_mask_flags to reflect which flags it touches
Date: Wed,  9 May 2018 15:54:30 +0200
Message-Id: <e25035869a53c49266de464621a92184546750d5.1525873677.git.dsterba@suse.com>
In-Reply-To: <cover.1525873677.git.dsterba@suse.com>
References: <cover.1525873677.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The FS_*_FL flags cannot be easily identified by a variable name prefix
but we still need to recognize them so the 'fsflags' should be closer to
the naming scheme but again the 'fs' part sounds like it's a filesystem
flag. I don't have a better idea for now.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ioctl.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 11edbdf3df7d..e93dc3a6f554 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -93,11 +93,12 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 		       int no_time_update);
 
 /* Mask out flags that are inappropriate for the given type of inode. */
-static unsigned int btrfs_mask_flags(umode_t mode, unsigned int flags)
+static unsigned int btrfs_mask_fsflags_for_type(struct inode *inode,
+		unsigned int flags)
 {
-	if (S_ISDIR(mode))
+	if (S_ISDIR(inode->i_mode))
 		return flags;
-	else if (S_ISREG(mode))
+	else if (S_ISREG(inode->i_mode))
 		return flags & ~FS_DIRSYNC_FL;
 	else
 		return flags & (FS_NODUMP_FL | FS_NOATIME_FL);
@@ -218,7 +219,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	i_oldflags = inode->i_flags;
 	mode = inode->i_mode;
 
-	flags = btrfs_mask_flags(inode->i_mode, flags);
+	flags = btrfs_mask_fsflags_for_type(inode, flags);
 	oldflags = btrfs_flags_to_ioctl(ip->flags);
 	if ((flags ^ oldflags) & (FS_APPEND_FL | FS_IMMUTABLE_FL)) {
 		if (!capable(CAP_LINUX_IMMUTABLE)) {
-- 
2.16.2

