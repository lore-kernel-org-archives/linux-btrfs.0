From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH 2/5] updated orphan patch
Date: Fri, 18 Jul 2008 12:40:27 -0400
Message-ID: <20080718164027.GF15844@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Here is an updated orphan inode patch for the unstable tree.  Thanks,

Josef


diff -r 704bbd0d8f9b Makefile
--- a/Makefile	Fri Jul 18 19:34:01 2008 -0400
+++ b/Makefile	Fri Jul 18 19:42:53 2008 -0400
@@ -6,7 +6,7 @@ btrfs-y := super.o ctree.o extent-tree.o
 	   hash.o file-item.o inode-item.o inode-map.o disk-io.o \
 	   transaction.o bit-radix.o inode.o file.o tree-defrag.o \
 	   extent_map.o sysfs.o struct-funcs.o xattr.o ordered-data.o \
-	   extent_io.o volumes.o async-thread.o ioctl.o locking.o
+	   extent_io.o volumes.o async-thread.o ioctl.o locking.o orphan.o
 
 btrfs-$(CONFIG_FS_POSIX_ACL)	+= acl.o
 else
diff -r 704bbd0d8f9b btrfs_inode.h
--- a/btrfs_inode.h	Fri Jul 18 19:34:01 2008 -0400
+++ b/btrfs_inode.h	Fri Jul 18 19:42:53 2008 -0400
@@ -39,6 +39,9 @@ struct btrfs_inode {
 	struct posix_acl *i_acl;
 	struct posix_acl *i_default_acl;
 
+	/* for keeping track of orphaned inodes */
+	struct list_head i_orphan;
+
 	/*
 	 * transid of the trans_handle that last modified this inode
 	 */
diff -r 704bbd0d8f9b ctree.c
--- a/ctree.c	Fri Jul 18 19:34:01 2008 -0400
+++ b/ctree.c	Fri Jul 18 19:42:53 2008 -0400
@@ -2622,7 +2622,7 @@ int btrfs_insert_empty_items(struct btrf
 		total_data += data_size[i];
 	}
 
-	total_size = total_data + (nr - 1) * sizeof(struct btrfs_item);
+	total_size = total_data + (nr * sizeof(struct btrfs_item));
 	ret = btrfs_search_slot(trans, root, cpu_key, path, total_size, 1);
 	if (ret == 0) {
 		return -EEXIST;
diff -r 704bbd0d8f9b ctree.h
--- a/ctree.h	Fri Jul 18 19:34:01 2008 -0400
+++ b/ctree.h	Fri Jul 18 19:42:53 2008 -0400
@@ -69,6 +69,9 @@ struct btrfs_ordered_sum;
 
 /* directory objectid inside the root tree */
 #define BTRFS_ROOT_TREE_DIR_OBJECTID 6ULL
+
+/* orhpan objectid for tracking unlinked/truncated files */
+#define BTRFS_ORPHAN_OBJECTID -5ULL
 
 /*
  * All files have objectids higher than this.
@@ -633,6 +636,9 @@ struct btrfs_root {
 
 	/* the dirty list is only used by non-reference counted roots */
 	struct list_head dirty_list;
+
+	spinlock_t orphan_lock;
+	struct list_head orphan_list;
 };
 
 /*
@@ -644,6 +650,7 @@ struct btrfs_root {
 #define BTRFS_INODE_ITEM_KEY		1
 #define BTRFS_INODE_REF_KEY		2
 #define BTRFS_XATTR_ITEM_KEY		8
+#define BTRFS_ORPHAN_ITEM_KEY		9
 /* reserve 2-15 close to the inode for later flexibility */
 
 /*
@@ -1546,6 +1553,13 @@ struct btrfs_dir_item *btrfs_lookup_xatt
 					  struct btrfs_path *path, u64 dir,
 					  const char *name, u16 name_len,
 					  int mod);
+
+/* orphan.c */
+int btrfs_insert_orphan_item(struct btrfs_trans_handle *trans,
+			     struct btrfs_root *root, u64 offset);
+int btrfs_del_orphan_item(struct btrfs_trans_handle *trans,
+			  struct btrfs_root *root, u64 offset);
+
 /* inode-map.c */
 int btrfs_find_free_objectid(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *fs_root,
diff -r 704bbd0d8f9b disk-io.c
--- a/disk-io.c	Fri Jul 18 19:34:01 2008 -0400
+++ b/disk-io.c	Fri Jul 18 19:42:53 2008 -0400
@@ -732,7 +732,9 @@ static int __setup_root(u32 nodesize, u3
 	root->in_sysfs = 0;
 
 	INIT_LIST_HEAD(&root->dirty_list);
+	INIT_LIST_HEAD(&root->orphan_list);
 	spin_lock_init(&root->node_lock);
+	spin_lock_init(&root->orphan_lock);
 	mutex_init(&root->objectid_mutex);
 	memset(&root->root_key, 0, sizeof(root->root_key));
 	memset(&root->root_item, 0, sizeof(root->root_item));
diff -r 704bbd0d8f9b inode.c
--- a/inode.c	Fri Jul 18 19:34:01 2008 -0400
+++ b/inode.c	Fri Jul 18 19:42:53 2008 -0400
@@ -77,6 +77,8 @@ static unsigned char btrfs_type_by_mode[
 	[S_IFSOCK >> S_SHIFT]	= BTRFS_FT_SOCK,
 	[S_IFLNK >> S_SHIFT]	= BTRFS_FT_SYMLINK,
 };
+
+static void btrfs_truncate(struct inode *inode);
 
 int btrfs_check_free_space(struct btrfs_root *root, u64 num_required,
 			   int for_del)
@@ -794,6 +796,190 @@ zeroit:
 	return -EIO;
 }
 
+/*
+ * This creates an orphan entry for the given inode in case something goes
+ * wrong in the middle of an unlink/truncate.
+ */
+int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	int ret = 0;
+
+	spin_lock(&root->orphan_lock);
+
+	/* already on the orphan list, we're good */
+	if (!list_empty(&BTRFS_I(inode)->i_orphan)) {
+		spin_unlock(&root->orphan_lock);
+		return 0;
+	}
+
+	list_add(&BTRFS_I(inode)->i_orphan, &root->orphan_list);
+
+	spin_unlock(&root->orphan_lock);
+
+	/*
+	 * insert an orphan item to track this unlinked/truncated file
+	 */
+	ret = btrfs_insert_orphan_item(trans, root, inode->i_ino);
+
+	return ret;
+}
+
+/*
+ * We have done the truncate/delete so we can go ahead and remove the orphan
+ * item for this particular inode.
+ */
+int btrfs_orphan_del(struct btrfs_trans_handle *trans, struct inode *inode)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	int ret = 0;
+
+	spin_lock(&root->orphan_lock);
+
+	if (list_empty(&BTRFS_I(inode)->i_orphan)) {
+		spin_unlock(&root->orphan_lock);
+		return 0;
+	}
+
+	list_del_init(&BTRFS_I(inode)->i_orphan);
+	if (!trans) {
+		spin_unlock(&root->orphan_lock);
+		return 0;
+	}
+
+	spin_unlock(&root->orphan_lock);
+
+	ret = btrfs_del_orphan_item(trans, root, inode->i_ino);
+
+	return ret;
+}
+
+/*
+ * this cleans up any orphans that may be left on the list from the last use
+ * of this root.
+ */
+void btrfs_orphan_cleanup(struct btrfs_root *root)
+{
+	struct btrfs_path *path;
+	struct extent_buffer *leaf;
+	struct btrfs_item *item;
+	struct btrfs_key key, found_key;
+	struct btrfs_trans_handle *trans;
+	struct inode *inode;
+	int ret = 0, nr_unlink = 0, nr_truncate = 0;
+
+	/* don't do orphan cleanup if the fs is readonly. */
+	if (root->inode->i_sb->s_flags & MS_RDONLY)
+		return;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return;
+	path->reada = -1;
+
+	key.objectid = BTRFS_ORPHAN_OBJECTID;
+	btrfs_set_key_type(&key, BTRFS_ORPHAN_ITEM_KEY);
+	key.offset = (u64)-1;
+
+	trans = btrfs_start_transaction(root, 1);
+	btrfs_set_trans_block_group(trans, root->inode);
+
+	while (1) {
+		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+		if (ret < 0) {
+			printk(KERN_ERR "Error searching slot for orphan: %d"
+			       "\n", ret);
+			break;
+		}
+
+		/*
+		 * if ret == 0 means we found what we were searching for, which
+		 * is weird, but possible, so only screw with path if we didnt
+		 * find the key and see if we have stuff that matches
+		 */
+		if (ret > 0) {
+			if (path->slots[0] == 0)
+				break;
+			path->slots[0]--;
+		}
+
+		/* pull out the item */
+		leaf = path->nodes[0];
+		item = btrfs_item_nr(leaf, path->slots[0]);
+		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
+
+		/* make sure the item matches what we want */
+		if (found_key.objectid != BTRFS_ORPHAN_OBJECTID)
+			break;
+		if (btrfs_key_type(&found_key) != BTRFS_ORPHAN_ITEM_KEY)
+			break;
+
+		/* release the path since we're done with it */
+		btrfs_release_path(root, path);
+
+		/*
+		 * this is where we are basically btrfs_lookup, without the
+		 * crossing root thing.  we store the inode number in the
+		 * offset of the orphan item.
+		 */
+		inode = btrfs_iget_locked(root->inode->i_sb,
+					  found_key.offset, root);
+		if (!inode)
+			break;
+
+		if (inode->i_state & I_NEW) {
+			BTRFS_I(inode)->root = root;
+
+			/* have to set the location manually */
+			BTRFS_I(inode)->location.objectid = inode->i_ino;
+			BTRFS_I(inode)->location.type = BTRFS_INODE_ITEM_KEY;
+			BTRFS_I(inode)->location.offset = 0;
+
+			btrfs_read_locked_inode(inode);
+			unlock_new_inode(inode);
+		}
+
+		/*
+		 * add this inode to the orphan list so btrfs_orphan_del does
+		 * the proper thing when we hit it
+		 */
+		spin_lock(&root->orphan_lock);
+		list_add(&BTRFS_I(inode)->i_orphan, &root->orphan_list);
+		spin_unlock(&root->orphan_lock);
+
+		/*
+		 * if this is a bad inode, means we actually succeeded in
+		 * removing the inode, but not the orphan record, which means
+		 * we need to manually delete the orphan since iput will just
+		 * do a destroy_inode
+		 */
+		if (is_bad_inode(inode)) {
+			btrfs_orphan_del(trans, inode);
+			iput(inode);
+			continue;
+		}
+
+		/* if we have links, this was a truncate, lets do that */
+		if (inode->i_nlink) {
+			nr_truncate++;
+			btrfs_truncate(inode);
+		} else {
+			nr_unlink++;
+		}
+
+		/* this will do delete_inode and everything for us */
+		iput(inode);
+	}
+
+	if (nr_unlink)
+		printk(KERN_INFO "btrfs: unlinked %d orphans\n", nr_unlink);
+	if (nr_truncate)
+		printk(KERN_INFO "btrfs: truncated %d orphans\n", nr_truncate);
+
+	btrfs_free_path(path);
+	btrfs_end_transaction(trans, root);
+}
+
 void btrfs_read_locked_inode(struct inode *inode)
 {
 	struct btrfs_path *path;
@@ -1030,6 +1216,7 @@ static int btrfs_unlink(struct inode *di
 {
 	struct btrfs_root *root;
 	struct btrfs_trans_handle *trans;
+	struct inode *inode = dentry->d_inode;
 	int ret;
 	unsigned long nr = 0;
 
@@ -1043,6 +1230,10 @@ static int btrfs_unlink(struct inode *di
 
 	btrfs_set_trans_block_group(trans, dir);
 	ret = btrfs_unlink_trans(trans, root, dir, dentry);
+
+	if (inode->i_nlink == 0)
+		ret = btrfs_orphan_add(trans, inode);
+
 	nr = trans->blocks_used;
 
 	btrfs_end_transaction_throttle(trans, root);
@@ -1071,12 +1262,17 @@ static int btrfs_rmdir(struct inode *dir
 	trans = btrfs_start_transaction(root, 1);
 	btrfs_set_trans_block_group(trans, dir);
 
+	err = btrfs_orphan_add(trans, inode);
+	if (err)
+		goto fail_trans;
+
 	/* now the directory is empty */
 	err = btrfs_unlink_trans(trans, root, dir, dentry);
 	if (!err) {
 		btrfs_i_size_write(inode, 0);
 	}
 
+fail_trans:
 	nr = trans->blocks_used;
 	ret = btrfs_end_transaction_throttle(trans, root);
 fail:
@@ -1094,6 +1290,9 @@ fail:
  *
  * csum items that cross the new i_size are truncated to the new size
  * as well.
+ *
+ * min_type is the minimum key type to truncate down to.  If set to 0, this
+ * will kill all the items on this inode, including the INODE_ITEM_KEY.
  */
 static int btrfs_truncate_in_trans(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root,
@@ -1458,6 +1657,7 @@ void btrfs_delete_inode(struct inode *in
 	btrfs_wait_ordered_range(inode, 0, (u64)-1);
 	truncate_inode_pages(&inode->i_data, 0);
 	if (is_bad_inode(inode)) {
+		btrfs_orphan_del(NULL, inode);
 		goto no_delete;
 	}
 
@@ -1466,8 +1666,12 @@ void btrfs_delete_inode(struct inode *in
 
 	btrfs_set_trans_block_group(trans, inode);
 	ret = btrfs_truncate_in_trans(trans, root, inode, 0);
-	if (ret)
+	if (ret) {
+		btrfs_orphan_del(NULL, inode);
 		goto no_delete_lock;
+	}
+
+	btrfs_orphan_del(trans, inode);
 
 	nr = trans->blocks_used;
 	clear_inode(inode);
@@ -1649,7 +1853,7 @@ static struct dentry *btrfs_lookup(struc
 	struct btrfs_root *root = bi->root;
 	struct btrfs_root *sub_root = root;
 	struct btrfs_key location;
-	int ret;
+	int ret, do_orphan = 0;
 
 	if (dentry->d_name.len > BTRFS_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
@@ -1667,6 +1871,7 @@ static struct dentry *btrfs_lookup(struc
 			return ERR_PTR(ret);
 		if (ret > 0)
 			return ERR_PTR(-ENOENT);
+
 		inode = btrfs_iget_locked(dir->i_sb, location.objectid,
 					  sub_root);
 		if (!inode)
@@ -1676,6 +1881,7 @@ static struct dentry *btrfs_lookup(struc
 			if (sub_root != root) {
 				igrab(inode);
 				sub_root->inode = inode;
+				do_orphan = 1;
 			}
 			BTRFS_I(inode)->root = sub_root;
 			memcpy(&BTRFS_I(inode)->location, &location,
@@ -1684,6 +1890,10 @@ static struct dentry *btrfs_lookup(struc
 			unlock_new_inode(inode);
 		}
 	}
+
+	if (unlikely(do_orphan))
+		btrfs_orphan_cleanup(sub_root);
+
 	return d_splice_alias(inode, dentry);
 }
 
@@ -2831,12 +3041,19 @@ static void btrfs_truncate(struct inode 
 	btrfs_wait_ordered_range(inode, inode->i_size & (~mask), (u64)-1);
 	btrfs_i_size_write(inode, inode->i_size);
 
+	ret = btrfs_orphan_add(trans, inode);
+	if (ret)
+		goto out;
 	/* FIXME, add redo link to tree so we don't leak on crash */
 	ret = btrfs_truncate_in_trans(trans, root, inode,
 				      BTRFS_EXTENT_DATA_KEY);
 	btrfs_update_inode(trans, root, inode);
+
+	ret = btrfs_orphan_del(trans, inode);
+	BUG_ON(ret);
+
+out:
 	nr = trans->blocks_used;
-
 	ret = btrfs_end_transaction_throttle(trans, root);
 	BUG_ON(ret);
 	btrfs_btree_balance_dirty(root, nr);
@@ -2916,6 +3133,7 @@ struct inode *btrfs_alloc_inode(struct s
 	btrfs_ordered_inode_tree_init(&ei->ordered_tree);
 	ei->i_acl = BTRFS_ACL_NOT_CACHED;
 	ei->i_default_acl = BTRFS_ACL_NOT_CACHED;
+	INIT_LIST_HEAD(&ei->i_orphan);
 	return &ei->vfs_inode;
 }
 
@@ -2931,6 +3149,14 @@ void btrfs_destroy_inode(struct inode *i
 	if (BTRFS_I(inode)->i_default_acl &&
 	    BTRFS_I(inode)->i_default_acl != BTRFS_ACL_NOT_CACHED)
 		posix_acl_release(BTRFS_I(inode)->i_default_acl);
+
+	spin_lock(&BTRFS_I(inode)->root->orphan_lock);
+	if (!list_empty(&BTRFS_I(inode)->i_orphan)) {
+		printk(KERN_ERR "BTRFS: inode %lu: inode still on the orphan"
+		       " list\n", inode->i_ino);
+		dump_stack();
+	}
+	spin_unlock(&BTRFS_I(inode)->root->orphan_lock);
 
 	while(1) {
 		ordered = btrfs_lookup_first_ordered_extent(inode, (u64)-1);
@@ -3072,6 +3298,11 @@ static int btrfs_rename(struct inode * o
 		ret = btrfs_unlink_trans(trans, root, new_dir, new_dentry);
 		if (ret)
 			goto out_fail;
+		if (new_inode->i_nlink == 0) {
+			ret = btrfs_orphan_add(trans, new_inode);
+			if (ret)
+				goto out_fail;
+		}
 	}
 	ret = btrfs_add_link(trans, new_dentry, old_inode, 1);
 	if (ret)
diff -r 704bbd0d8f9b orphan.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/orphan.c	Fri Jul 18 19:42:53 2008 -0400
@@ -0,0 +1,67 @@
+/*
+ * Copyright (C) 2008 Red Hat.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#include "ctree.h"
+#include "disk-io.h"
+
+int btrfs_insert_orphan_item(struct btrfs_trans_handle *trans,
+			     struct btrfs_root *root, u64 offset)
+{
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	int ret = 0;
+
+	key.objectid = BTRFS_ORPHAN_OBJECTID;
+	btrfs_set_key_type(&key, BTRFS_ORPHAN_ITEM_KEY);
+	key.offset = offset;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	ret = btrfs_insert_empty_item(trans, root, path, &key, 0);
+
+	btrfs_free_path(path);
+	return ret;
+}
+
+int btrfs_del_orphan_item(struct btrfs_trans_handle *trans,
+			  struct btrfs_root *root, u64 offset)
+{
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	int ret = 0;
+
+	key.objectid = BTRFS_ORPHAN_OBJECTID;
+	btrfs_set_key_type(&key, BTRFS_ORPHAN_ITEM_KEY);
+	key.offset = offset;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+	if (ret)
+		goto out;
+
+	ret = btrfs_del_item(trans, root, path);
+
+out:
+	btrfs_free_path(path);
+	return ret;
+}
