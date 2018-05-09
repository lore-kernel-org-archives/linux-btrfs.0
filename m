Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34321 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934870AbeEIN5G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 May 2018 09:57:06 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: misono.tomohiro@jp.fujitsu.com, David Sterba <dsterba@suse.com>
Subject: [PATCH v2 1/8] btrfs: rename btrfs_update_iflags to reflect which flags it touches
Date: Wed,  9 May 2018 15:54:28 +0200
Message-Id: <56697064041956d0bc084593a287136b799b97b7.1525873677.git.dsterba@suse.com>
In-Reply-To: <cover.1525873677.git.dsterba@suse.com>
References: <cover.1525873677.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The btrfs inode flag flavour is now simply called 'inode flags' and the
vfs inode are i_flags. Also rename the internal variable to something
less confusing than 'ip'.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h | 2 +-
 fs/btrfs/inode.c | 4 ++--
 fs/btrfs/ioctl.c | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2771cc56a622..d738eaa1d6e1 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3260,7 +3260,7 @@ void btrfs_test_inode_set_ops(struct inode *inode);
 long btrfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 long btrfs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 int btrfs_ioctl_get_supported_features(void __user *arg);
-void btrfs_update_iflags(struct inode *inode);
+void btrfs_sync_inode_flags_to_i_flags(struct inode *inode);
 int btrfs_is_empty_uuid(u8 *uuid);
 int btrfs_defrag_file(struct inode *inode, struct file *file,
 		      struct btrfs_ioctl_defrag_range_args *range,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d241285a0d2a..c30afabcb6b0 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3924,7 +3924,7 @@ static int btrfs_read_locked_inode(struct inode *inode)
 		break;
 	}
 
-	btrfs_update_iflags(inode);
+	btrfs_sync_inode_flags_to_i_flags(inode);
 	return 0;
 
 make_bad:
@@ -6263,7 +6263,7 @@ static void btrfs_inherit_iflags(struct inode *inode, struct inode *dir)
 			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATASUM;
 	}
 
-	btrfs_update_iflags(inode);
+	btrfs_sync_inode_flags_to_i_flags(inode);
 }
 
 static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 632e26d6f7ce..11edbdf3df7d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -136,7 +136,7 @@ static unsigned int btrfs_flags_to_ioctl(unsigned int flags)
 /*
  * Update inode->i_flags based on the btrfs internal flags.
  */
-void btrfs_update_iflags(struct inode *inode)
+void btrfs_sync_inode_flags_to_i_flags(struct inode *inode)
 {
 	struct btrfs_inode *ip = BTRFS_I(inode);
 	unsigned int new_fl = 0;
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

