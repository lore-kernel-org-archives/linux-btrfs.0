From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] btrfs: remove unused function btrfs_ilookup
Date: Sat, 30 Aug 2008 16:12:12 +0200
Message-ID: <20080830141212.GA24645@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_ilookup is unused, which is good because a normal filesystem
should never have to use ilookup anyway.  Remove it.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: btrfs-unstable/ctree.h
===================================================================
--- btrfs-unstable.orig/ctree.h	2008-08-30 11:08:58.000000000 -0300
+++ btrfs-unstable/ctree.h	2008-08-30 11:09:10.000000000 -0300
@@ -1698,8 +1698,6 @@ void btrfs_destroy_cachep(void);
 long btrfs_ioctl_trans_end(struct file *file);
 struct inode *btrfs_iget_locked(struct super_block *s, u64 objectid,
 				struct btrfs_root *root);
-struct inode *btrfs_ilookup(struct super_block *s, u64 objectid,
-			    u64 root_objectid);
 struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
 			 struct btrfs_root *root, int *is_new);
 int btrfs_commit_write(struct file *file, struct page *page,
Index: btrfs-unstable/inode.c
===================================================================
--- btrfs-unstable.orig/inode.c	2008-08-30 11:08:58.000000000 -0300
+++ btrfs-unstable/inode.c	2008-08-30 11:09:03.000000000 -0300
@@ -1781,19 +1781,6 @@ static int btrfs_find_actor(struct inode
 		args->root == BTRFS_I(inode)->root);
 }
 
-struct inode *btrfs_ilookup(struct super_block *s, u64 objectid,
-			    u64 root_objectid)
-{
-	struct btrfs_iget_args args;
-	args.ino = objectid;
-	args.root = btrfs_lookup_fs_root(btrfs_sb(s)->fs_info, root_objectid);
-
-	if (!args.root)
-		return NULL;
-
-	return ilookup5(s, objectid, btrfs_find_actor, (void *)&args);
-}
-
 struct inode *btrfs_iget_locked(struct super_block *s, u64 objectid,
 				struct btrfs_root *root)
 {
