From: Milko Krachounov <sombre@gmail.com>
Subject: [PATCH] make btrfs_orphan_cleanup process bad inodes
Date: Tue, 6 Sep 2011 21:22:28 +0300
Message-ID: <201109062122.28357.sombre@gmail.com>
References: <CAJ-vRAKSGSXa5kjJ6zwk8qos2LgoJq8m4CYFPz+zHmkaoiGGDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAJ-vRAKSGSXa5kjJ6zwk8qos2LgoJq8m4CYFPz+zHmkaoiGGDw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

When btrfs_orphan_cleanup encounters an inode marked as bad, instead of going
down the code path that handles such inodes, it fails with the following error
message:

     btrfs: could not do orphan cleanup -116

This happens as the called btrfs_iget returns an error when encountering such
inode.

This patch attempts to correct this issue by calling btrfs_iget_locked
instead, and handling inodes in I_NEW state manually, while leaving bad inodes
to the handling that's already present in the function.

Signed-off-by: Milko Krachounov <milko@3mhz.net>
---
diff -pru linux-2.6-3.1.0~rc4.original/fs/btrfs/inode.c linux-2.6-3.1.0~rc4.fixed/fs/btrfs/inode.c
--- linux-2.6-3.1.0~rc4.original/fs/btrfs/inode.c	2011-08-29 07:16:01.000000000 +0300
+++ linux-2.6-3.1.0~rc4.fixed/fs/btrfs/inode.c	2011-09-06 19:26:58.490416217 +0300
@@ -94,6 +94,12 @@ static noinline int cow_file_range(struc
 				   u64 start, u64 end, int *page_started,
 				   unsigned long *nr_written, int unlock);
 
+static struct inode *btrfs_iget_locked(struct super_block *s,
+                                       u64 objectid, 
+                                       struct btrfs_root *root);
+static void btrfs_read_locked_inode(struct inode *inode);
+static void inode_tree_add(struct inode *inode);
+
 static int btrfs_init_inode_security(struct btrfs_trans_handle *trans,
 				     struct inode *inode,  struct inode *dir,
 				     const struct qstr *qstr)
@@ -2367,15 +2373,27 @@ int btrfs_orphan_cleanup(struct btrfs_ro
 		 * crossing root thing.  we store the inode number in the
 		 * offset of the orphan item.
 		 */
-		found_key.objectid = found_key.offset;
-		found_key.type = BTRFS_INODE_ITEM_KEY;
-		found_key.offset = 0;
-		inode = btrfs_iget(root->fs_info->sb, &found_key, root, NULL);
-		if (IS_ERR(inode)) {
-			ret = PTR_ERR(inode);
+		inode = btrfs_iget_locked(root->fs_info->sb,
+		                          found_key.offset, root);
+		if (!inode) {
+			ret = -ENOMEM;
 			goto out;
 		}
 
+		if (inode->i_state & I_NEW) {
+			BTRFS_I(inode)->root = root;
+			BTRFS_I(inode)->location.objectid = found_key.offset;
+			BTRFS_I(inode)->location.type = BTRFS_INODE_ITEM_KEY;
+			BTRFS_I(inode)->location.offset = 0;
+
+			btrfs_read_locked_inode(inode);
+
+			if (!is_bad_inode(inode))
+				inode_tree_add(inode);
+
+			unlock_new_inode(inode);
+		}
+
 		/*
 		 * add this inode to the orphan list so btrfs_orphan_del does
 		 * the proper thing when we hit it
