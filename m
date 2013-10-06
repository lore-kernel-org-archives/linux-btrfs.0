Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:52376 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab3JFUzA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Oct 2013 16:55:00 -0400
Received: by mail-we0-f176.google.com with SMTP id w62so4225337wes.7
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Oct 2013 13:54:59 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: improve inode hash function/inode lookup
Date: Sun,  6 Oct 2013 21:53:27 +0100
Message-Id: <1381092807-21422-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently the hash value used for adding an inode to the VFS's inode
hash table consists of the plain inode number, which is a 64 bits
integer. This results in hash table buckets (hlist_head lists) with
too many elements for at least 2 important scenarios:

1) When we have many subvolumes. Each subvolume has its own btree
   where its files and directories are added to, and each has its
   own objectid (inode number) namespace. This means that if we have
   N subvolumes, and all have inode number X associated to a file or
   directory, the corresponding inodes all map to the same hash table
   entry, resulting in a bucket (hlist_head list) with N elements;

2) On 32 bits machines. Th VFS hash values are unsigned longs, which
   are 32 bits wide on 32 bits machines, and the inode (objectid)
   numbers are 64 bits unsigned integers. We simply cast the inode
   numbers to hash values, which means that for all inodes with the
   same 32 bits lower half, the same hash bucket is used for all of
   them. For example, all inodes with a number (objectid) between
   0x0000_0000_ffff_ffff and 0xffff_ffff_ffff_ffff will end up in
   the same hash table bucket.

This change ensures the inode's hash value depends both on the
objectid (inode number) and its subvolume's (btree root) objectid.
For 32 bits machines, this change gives better entropy by making
the hash value depend on both the upper and lower 32 bits of the
64 bits hash previously computed.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/btrfs_inode.h |   20 ++++++++++++++++++++
 fs/btrfs/disk-io.c     |    2 +-
 fs/btrfs/inode.c       |    6 ++++--
 3 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 71f074e..fbe745e 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -19,6 +19,7 @@
 #ifndef __BTRFS_I__
 #define __BTRFS_I__
 
+#include <linux/hash.h>
 #include "extent_map.h"
 #include "extent_io.h"
 #include "ordered-data.h"
@@ -179,6 +180,25 @@ static inline struct btrfs_inode *BTRFS_I(struct inode *inode)
 	return container_of(inode, struct btrfs_inode, vfs_inode);
 }
 
+static inline unsigned long inode_hash(u64 objectid,
+				       const struct btrfs_root *root)
+{
+	u64 h = objectid ^ (root->objectid * GOLDEN_RATIO_PRIME);
+
+#if BITS_PER_LONG == 32
+	h = (h >> 32) ^ (h & 0xffffffff);
+#endif
+
+	return (unsigned long)h;
+}
+
+static inline void btrfs_insert_inode_hash(struct inode *inode)
+{
+	unsigned long h = inode_hash(inode->i_ino, BTRFS_I(inode)->root);
+
+	__insert_inode_hash(inode, h);
+}
+
 static inline u64 btrfs_ino(struct inode *inode)
 {
 	u64 ino = BTRFS_I(inode)->location.objectid;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index ade6c0e..d205bdd 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2294,7 +2294,7 @@ int open_ctree(struct super_block *sb,
 	       sizeof(struct btrfs_key));
 	set_bit(BTRFS_INODE_DUMMY,
 		&BTRFS_I(fs_info->btree_inode)->runtime_flags);
-	insert_inode_hash(fs_info->btree_inode);
+	btrfs_insert_inode_hash(fs_info->btree_inode);
 
 	spin_lock_init(&fs_info->block_group_cache_lock);
 	fs_info->block_group_cache_tree = RB_ROOT;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 13b470c..3c76bf4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4837,10 +4837,12 @@ static struct inode *btrfs_iget_locked(struct super_block *s,
 {
 	struct inode *inode;
 	struct btrfs_iget_args args;
+	unsigned long hashval = inode_hash(objectid, root);
+
 	args.ino = objectid;
 	args.root = root;
 
-	inode = iget5_locked(s, objectid, btrfs_find_actor,
+	inode = iget5_locked(s, hashval, btrfs_find_actor,
 			     btrfs_init_locked_inode,
 			     (void *)&args);
 	return inode;
@@ -5460,7 +5462,7 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 				BTRFS_INODE_NODATASUM;
 	}
 
-	insert_inode_hash(inode);
+	btrfs_insert_inode_hash(inode);
 	inode_tree_add(inode);
 
 	trace_btrfs_inode_new(inode);
-- 
1.7.9.5

