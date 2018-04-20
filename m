Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55007 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753569AbeDTRFE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Apr 2018 13:05:04 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5A746AE7A
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Apr 2018 17:05:03 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/7] btrfs: rename btrfs_update_iflags to reflect which flags it touches
Date: Fri, 20 Apr 2018 19:02:31 +0200
Message-Id: <01df791d51214e652117f084953e9d2cbe90f686.1524242295.git.dsterba@suse.com>
In-Reply-To: <cover.1524242295.git.dsterba@suse.com>
References: <cover.1524242295.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The btrfs inode flag flavour is now simply called 'inode flags' and the
vfs inode are i_flags. Also rename the internal variable to something
less confusing than 'ip'.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h |  2 +-
 fs/btrfs/inode.c |  4 ++--
 fs/btrfs/ioctl.c | 16 ++++++++--------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 5474ef14d6e6..08a96e594097 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3235,7 +3235,7 @@ void btrfs_test_inode_set_ops(struct inode *inode);
 long btrfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 long btrfs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 int btrfs_ioctl_get_supported_features(void __user *arg);
-void btrfs_update_iflags(struct inode *inode);
+void btrfs_sync_inode_flags_to_i_flags(struct inode *inode);
 int btrfs_is_empty_uuid(u8 *uuid);
 int btrfs_defrag_file(struct inode *inode, struct file *file,
 		      struct btrfs_ioctl_defrag_range_args *range,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e064c49c9a9a..6a24b159aeeb 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3923,7 +3923,7 @@ static int btrfs_read_locked_inode(struct inode *inode)
 		break;
 	}
 
-	btrfs_update_iflags(inode);
+	btrfs_sync_inode_flags_to_i_flags(inode);
 	return 0;
 
 make_bad:
@@ -6259,7 +6259,7 @@ static void btrfs_inherit_iflags(struct inode *inode, struct inode *dir)
 			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATASUM;
 	}
 
-	btrfs_update_iflags(inode);
+	btrfs_sync_inode_flags_to_i_flags(inode);
 }
 
 static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9cc4fd25f83d..c3189ebf7c88 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -136,20 +136,20 @@ static unsigned int btrfs_flags_to_ioctl(unsigned int flags)
 /*
  * Update inode->i_flags based on the btrfs internal flags.
  */
-void btrfs_update_iflags(struct inode *inode)
+void btrfs_sync_inode_flags_to_i_flags(struct inode *inode)
 {
-	struct btrfs_inode *ip = BTRFS_I(inode);
+	struct btrfs_inode *binode = BTRFS_I(inode);
 	unsigned int new_fl = 0;
 
-	if (ip->flags & BTRFS_INODE_SYNC)
+	if (binode->flags & BTRFS_INODE_SYNC)
 		new_fl |= S_SYNC;
-	if (ip->flags & BTRFS_INODE_IMMUTABLE)
+	if (binode->flags & BTRFS_INODE_IMMUTABLE)
 		new_fl |= S_IMMUTABLE;
-	if (ip->flags & BTRFS_INODE_APPEND)
+	if (binode->flags & BTRFS_INODE_APPEND)
 		new_fl |= S_APPEND;
-	if (ip->flags & BTRFS_INODE_NOATIME)
+	if (binode->flags & BTRFS_INODE_NOATIME)
 		new_fl |= S_NOATIME;
-	if (ip->flags & BTRFS_INODE_DIRSYNC)
+	if (binode->flags & BTRFS_INODE_DIRSYNC)
 		new_fl |= S_DIRSYNC;
 
 	set_mask_bits(&inode->i_flags,
@@ -317,7 +317,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 		goto out_drop;
 	}
 
-	btrfs_update_iflags(inode);
+	btrfs_sync_inode_flags_to_i_flags(inode);
 	inode_inc_iversion(inode);
 	inode->i_ctime = current_time(inode);
 	ret = btrfs_update_inode(trans, root, inode);
-- 
2.16.2

