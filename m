From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] remove btrfs_xattrs_delete
Date: Wed, 9 Jul 2008 15:38:28 -0400
Message-ID: <20080709193828.GQ2088@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This stuff is no longer needed since btrfs_truncate_in_trans does the work for
us.  It's not used anywhere so its just dead code.  Thanks,

Signed-off-by: Josef Bacik <jbacik@redhat.com>


diff -r 870370c6975e ctree.h
--- a/ctree.h	Wed Jul 09 22:38:43 2008 -0400
+++ b/ctree.h	Wed Jul 09 22:43:50 2008 -0400
@@ -1663,8 +1663,7 @@ void btrfs_sysfs_del_super(struct btrfs_
 
 /* xattr.c */
 ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
-int btrfs_delete_xattrs(struct btrfs_trans_handle *trans,
-			struct btrfs_root *root, struct inode *inode);
+
 /* super.c */
 u64 btrfs_parse_size(char *str);
 int btrfs_parse_options(struct btrfs_root *root, char *options);
diff -r 870370c6975e xattr.c
--- a/xattr.c	Wed Jul 09 22:38:43 2008 -0400
+++ b/xattr.c	Wed Jul 09 22:43:50 2008 -0400
@@ -385,57 +385,6 @@ err:
 }
 
 /*
- * delete all the xattrs associated with the inode.
- */
-int btrfs_delete_xattrs(struct btrfs_trans_handle *trans,
-			struct btrfs_root *root, struct inode *inode)
-{
-	struct btrfs_path *path;
-	struct btrfs_key key, found_key;
-	struct btrfs_item *item;
-	struct extent_buffer *leaf;
-	int ret;
-
-	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
-	path->reada = -1;
-	key.objectid = inode->i_ino;
-	btrfs_set_key_type(&key, BTRFS_XATTR_ITEM_KEY);
-	key.offset = (u64)-1;
-
-	while(1) {
-		/* look for our next xattr */
-		ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
-		if (ret < 0)
-			goto out;
-		BUG_ON(ret == 0);
-
-		if (path->slots[0] == 0)
-			break;
-
-		path->slots[0]--;
-		leaf = path->nodes[0];
-		item = btrfs_item_nr(leaf, path->slots[0]);
-		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
-
-		if (found_key.objectid != key.objectid)
-			break;
-		if (btrfs_key_type(&found_key) != BTRFS_XATTR_ITEM_KEY)
-			break;
-
-		ret = btrfs_del_item(trans, root, path);
-		BUG_ON(ret);
-		btrfs_release_path(root, path);
-	}
-	ret = 0;
-out:
-	btrfs_free_path(path);
-
-	return ret;
-}
-
-/*
  * Handler functions
  */
 #define BTRFS_XATTR_SETGET_FUNCS(name, index)				\
