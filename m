Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55014 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753575AbeDTRFG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Apr 2018 13:05:06 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9BE7BAC4F
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Apr 2018 17:05:05 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/7] btrfs: rename btrfs_mask_flags to reflect which flags it touches
Date: Fri, 20 Apr 2018 19:02:34 +0200
Message-Id: <45cf464fea354f4fbf23639104822817dc6f07d4.1524242295.git.dsterba@suse.com>
In-Reply-To: <cover.1524242295.git.dsterba@suse.com>
References: <cover.1524242295.git.dsterba@suse.com>
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
index c3189ebf7c88..b2c26beffd82 100644
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

