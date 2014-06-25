Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:34468 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbaFYUgR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jun 2014 16:36:17 -0400
Received: by mail-wg0-f47.google.com with SMTP id k14so2642695wgh.18
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jun 2014 13:36:16 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: atomically set inode->i_flags in btrfs_update_iflags
Date: Wed, 25 Jun 2014 22:36:02 +0100
Message-Id: <1403732162-22405-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This change is based on the corresponding recent change for ext4:

  ext4: atomically set inode->i_flags in ext4_set_inode_flags()

That has the following commit message that applies to btrfs as well:

  "Use cmpxchg() to atomically set i_flags instead of clearing out the
   S_IMMUTABLE, S_APPEND, etc. flags and then setting them from the
   EXT4_IMMUTABLE_FL, EXT4_APPEND_FL flags, since this opens up a race
   where an immutable file has the immutable flag cleared for a brief
   window of time."

Replacing EXT4_IMMUTABLE_FL and EXT4_APPEND_FL with BTRFS_INODE_IMMUTABLE
and BTRFS_INODE_APPEND, respectively.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/ioctl.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 6ea1546..02dc64b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -136,19 +136,22 @@ static unsigned int btrfs_flags_to_ioctl(unsigned int flags)
 void btrfs_update_iflags(struct inode *inode)
 {
 	struct btrfs_inode *ip = BTRFS_I(inode);
-
-	inode->i_flags &= ~(S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC);
+	unsigned int new_fl = 0;
 
 	if (ip->flags & BTRFS_INODE_SYNC)
-		inode->i_flags |= S_SYNC;
+		new_fl |= S_SYNC;
 	if (ip->flags & BTRFS_INODE_IMMUTABLE)
-		inode->i_flags |= S_IMMUTABLE;
+		new_fl |= S_IMMUTABLE;
 	if (ip->flags & BTRFS_INODE_APPEND)
-		inode->i_flags |= S_APPEND;
+		new_fl |= S_APPEND;
 	if (ip->flags & BTRFS_INODE_NOATIME)
-		inode->i_flags |= S_NOATIME;
+		new_fl |= S_NOATIME;
 	if (ip->flags & BTRFS_INODE_DIRSYNC)
-		inode->i_flags |= S_DIRSYNC;
+		new_fl |= S_DIRSYNC;
+
+	set_mask_bits(&inode->i_flags,
+		      S_SYNC | S_APPEND | S_IMMUTABLE | S_NOATIME | S_DIRSYNC,
+		      new_fl);
 }
 
 /*
-- 
1.9.1

