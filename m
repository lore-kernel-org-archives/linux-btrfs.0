From: Jan Engelhardt <jengelh@medozas.de>
Subject: [patch] resolve compile error on -rt
Date: Sun, 1 Jun 2008 21:05:50 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0806012105130.4055@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Required to make it compiled with -rt patchset.

---
 btrfs/inode.c |    1 -
 1 file changed, 1 deletion(-)

Index: btrfs-0.14/inode.c
===================================================================
--- btrfs-0.14.orig/btrfs/inode.c
+++ btrfs-0.14/btrfs/inode.c
@@ -3139,7 +3139,6 @@ struct inode *btrfs_alloc_inode(struct s
 void btrfs_destroy_inode(struct inode *inode)
 {
 	WARN_ON(!list_empty(&inode->i_dentry));
-	WARN_ON(inode->i_data.nrpages);
 
 	btrfs_drop_extent_cache(inode, 0, (u64)-1);
 	kmem_cache_free(btrfs_inode_cachep, BTRFS_I(inode));
