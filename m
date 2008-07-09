From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] fix some transaction issues
Date: Wed, 9 Jul 2008 10:08:07 -0400
Message-ID: <20080709140806.GM2088@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

There are a few places where we return without stopping the transaction we
started.  This patch fixes those places.  Thank you,

Signed-off-by: Josef Bacik <jbacik@redhat.com>


diff -r 7a66e4e56156 extent-tree.c
--- a/extent-tree.c	Tue Jul 08 21:08:39 2008 -0400
+++ b/extent-tree.c	Wed Jul 09 17:13:36 2008 -0400
@@ -3103,8 +3103,10 @@ next:
 	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
 	if (ret > 0)
 		ret = -EIO;
-	if (ret < 0)
+	if (ret < 0) {
+		btrfs_end_transaction(trans, root);
 		goto out;
+	}
 
 	clear_extent_bits(&info->block_group_cache, key.objectid,
 			  key.objectid + key.offset - 1,
diff -r 7a66e4e56156 inode.c
--- a/inode.c	Tue Jul 08 21:08:39 2008 -0400
+++ b/inode.c	Wed Jul 09 17:13:36 2008 -0400
@@ -2284,7 +2284,7 @@ static int btrfs_mkdir(struct inode *dir
 	err = btrfs_find_free_objectid(trans, root, dir->i_ino, &objectid);
 	if (err) {
 		err = -ENOSPC;
-		goto out_unlock;
+		goto out_fail;
 	}
 
 	inode = btrfs_new_inode(trans, root, dentry->d_name.name,
diff -r 7a66e4e56156 ioctl.c
--- a/ioctl.c	Tue Jul 08 21:08:39 2008 -0400
+++ b/ioctl.c	Wed Jul 09 17:13:36 2008 -0400
@@ -78,8 +78,10 @@ static noinline int create_subvol(struct
 	leaf = btrfs_alloc_free_block(trans, root, root->leafsize,
 				      objectid, trans->transid, 0, 0,
 				      0, 0);
-	if (IS_ERR(leaf))
-		return PTR_ERR(leaf);
+	if (IS_ERR(leaf)) {
+		ret = PTR_ERR(leaf);
+		goto fail;
+	}
 
 	btrfs_set_header_nritems(leaf, 0);
 	btrfs_set_header_level(leaf, 0);
