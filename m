From: Josef Bacik <jbacik@redhat.com>
Subject: Re: [PATCH] btrfs orphan support
Date: Thu, 10 Jul 2008 15:29:31 -0400
Message-ID: <20080710192931.GA23720@unused.rdu.redhat.com>
References: <20080709184316.GO2088@unused.rdu.redhat.com> <1215695044.24425.207.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <jbacik@redhat.com>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1215695044.24425.207.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 10, 2008 at 09:04:04AM -0400, Chris Mason wrote:
> On Wed, 2008-07-09 at 14:43 -0400, Josef Bacik wrote:
> > Hello,
> > 
> > This patch makes it so btrfs can handle unlink's and truncates that are
> > interrupted.  On unlink/truncate an orphan item is added with the location of
> > the inode.  When the truncation/deletion is completed the orphan item is
> > removed.  If a crash happens in between the orphaned inodes are processed at
> > root lookup time.  This also catches the case where the inode deletion may have
> > occured but the orphan item wasn't removed.  Tested with a bunch of stuff to
> > make sure everything is working.  Thank you,
> > 
> 
> Fantastic, thanks Josef.  A few comments below.
> > d so it also defines (optimal)
> > @@ -621,6 +625,10 @@ struct btrfs_root {
> >  
> >  	/* the dirty list is only used by non-reference counted roots */
> >  	struct list_head dirty_list;
> > +
> > +	/* orphan crap */
> 
> Crap is worse than no comments at all ;)
> 
> >  
> > +int btrfs_insert_orphan_item(struct btrfs_trans_handle *trans,
> > +			     struct btrfs_root *root, u64 offset,
> > +			     struct btrfs_key *location)
> > +{
> > +	struct btrfs_disk_key disk_key;
> > +	struct btrfs_dir_item *dir_item;
> > +	struct btrfs_path *path;
> > +	struct btrfs_key key;
> > +	struct extent_buffer *leaf;
> > +	int ret = 0;
> > +	u32 data_size;
> > +
> > +	key.objectid = BTRFS_ORPHAN_OBJECTID;
> > +	btrfs_set_key_type(&key, BTRFS_ORPHAN_ITEM_KEY);
> > +	key.offset = offset;
> > +
> > +	path = btrfs_alloc_path();
> > +	if (!path)
> > +		return -ENOMEM;
> > +
> > +	data_size = sizeof(*dir_item);
> > +	dir_item = insert_with_overflow(trans, root, path, &key,
> > +					data_size, "", 0);
> 
> I thought your plan to move away from dir items would use a new item
> type completely.
> 
> We only really need to store the objectid of the inode, which is already
> encoded in the key offset field.  So, you could try an 0 length item and
> we can fix up any problems that result in the btree code (I think it'll
> tolerate this).
> 
> > +int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
> > +{
> > +	struct btrfs_root *root = BTRFS_I(inode)->root;
> > +	struct btrfs_key key;
> > +	int ret = 0;
> > +
> > +	mutex_lock(&root->orphan_mutex);
> 
> This orphan mutex is going to serialize things pretty badly, since you
> could be doing IO with it held.  Could you please make this a spin lock
> held only during list manipulation?
> 
> The inode i_mutex should protect us from inserting/removing the same
> inode at the same time into the orphan index.
>

Hello,

Ok I've updated my patch with your suggestions.  It also has the bugfix for
insert empty item I tripped over.  Thanks much,

Josef

 
diff -r 4c1c1ae077ef Makefile
--- a/Makefile	Tue Jul 08 21:08:39 2008 -0400
+++ b/Makefile	Thu Jul 10 22:36:24 2008 -0400
@@ -6,7 +6,7 @@ btrfs-y := super.o ctree.o extent-tree.o
 	   hash.o file-item.o inode-item.o inode-map.o disk-io.o \
 	   transaction.o bit-radix.o inode.o file.o tree-defrag.o \
 	   extent_map.o sysfs.o struct-funcs.o xattr.o ordered-data.o \
-	   extent_io.o volumes.o async-thread.o ioctl.o locking.o
+	   extent_io.o volumes.o async-thread.o ioctl.o locking.o orphan.o
 
 btrfs-$(CONFIG_FS_POSIX_ACL)	+= acl.o
 else
diff -r 4c1c1ae077ef btrfs_inode.h
--- a/btrfs_inode.h	Tue Jul 08 21:08:39 2008 -0400
+++ b/btrfs_inode.h	Thu Jul 10 22:36:24 2008 -0400
@@ -37,6 +37,9 @@ struct btrfs_inode {
 	struct posix_acl *i_acl;
 	struct posix_acl *i_default_acl;
 
+	/* for keeping track of orphaned inodes */
+	struct list_head i_orphan;
+
 	u64 ordered_trans;
 	/*
 	 * transid of the trans_handle that last modified this inode
diff -r 4c1c1ae077ef ctree.c
--- a/ctree.c	Tue Jul 08 21:08:39 2008 -0400
+++ b/ctree.c	Thu Jul 10 22:36:24 2008 -0400
@@ -2626,7 +2626,7 @@ int btrfs_insert_empty_items(struct btrf
 		total_data += data_size[i];
 	}
 
-	total_size = total_data + (nr - 1) * sizeof(struct btrfs_item);
+	total_size = total_data + (nr * sizeof(struct btrfs_item));
 	ret = btrfs_search_slot(trans, root, cpu_key, path, total_size, 1);
 	if (ret == 0) {
 		return -EEXIST;
diff -r 4c1c1ae077ef ctree.h
--- a/ctree.h	Tue Jul 08 21:08:39 2008 -0400
+++ b/ctree.h	Thu Jul 10 22:36:24 2008 -0400
@@ -67,6 +67,9 @@ extern struct kmem_cache *btrfs_path_cac
 
 /* directory objectid inside the root tree */
 #define BTRFS_ROOT_TREE_DIR_OBJECTID 6ULL
+
+/* orhpan objectid for tracking unlinked/truncated files */
+#define BTRFS_ORPHAN_OBJECTID -5ULL
 
 /*
  * All files have objectids higher than this.
@@ -621,6 +624,9 @@ struct btrfs_root {
 
 	/* the dirty list is only used by non-reference counted roots */
 	struct list_head dirty_list;
+
+	spinlock_t orphan_lock;
+	struct list_head orphan_list;
 };
 
 /*
@@ -632,6 +638,7 @@ struct btrfs_root {
 #define BTRFS_INODE_ITEM_KEY		1
 #define BTRFS_INODE_REF_KEY		2
 #define BTRFS_XATTR_ITEM_KEY		8
+#define BTRFS_ORPHAN_ITEM_KEY		9
 /* reserve 2-15 close to the inode for later flexibility */
 
 /*
@@ -1523,6 +1530,13 @@ struct btrfs_dir_item *btrfs_lookup_xatt
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
diff -r 4c1c1ae077ef disk-io.c
--- a/disk-io.c	Tue Jul 08 21:08:39 2008 -0400
+++ b/disk-io.c	Thu Jul 10 22:36:24 2008 -0400
@@ -728,7 +728,9 @@ static int __setup_root(u32 nodesize, u3
 	root->in_sysfs = 0;
 
 	INIT_LIST_HEAD(&root->dirty_list);
+	INIT_LIST_HEAD(&root->orphan_list);
 	spin_lock_init(&root->node_lock);
+	spin_lock_init(&root->orphan_lock);
 	mutex_init(&root->objectid_mutex);
 	memset(&root->root_key, 0, sizeof(root->root_key));
 	memset(&root->root_item, 0, sizeof(root->root_item));
diff -r 4c1c1ae077ef inode.c
--- a/inode.c	Tue Jul 08 21:08:39 2008 -0400
+++ b/inode.c	Thu Jul 10 22:36:24 2008 -0400
@@ -76,6 +76,8 @@ static unsigned char btrfs_type_by_mode[
 	[S_IFSOCK >> S_SHIFT]	= BTRFS_FT_SOCK,
 	[S_IFLNK >> S_SHIFT]	= BTRFS_FT_SYMLINK,
 };
+
+static void btrfs_truncate(struct inode *inode);
 
 int btrfs_check_free_space(struct btrfs_root *root, u64 num_required,
 			   int for_del)
@@ -598,6 +600,190 @@ zeroit:
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
@@ -848,15 +1034,18 @@ static int btrfs_unlink(struct inode *di
 
 	btrfs_set_trans_block_group(trans, dir);
 	ret = btrfs_unlink_trans(trans, root, dir, dentry);
-	nr = trans->blocks_used;
 
 	if (inode->i_nlink == 0) {
+		ret = btrfs_orphan_add(trans, inode);
+
 		/* if the inode isn't linked anywhere,
 		 * we don't need to worry about
 		 * data=ordered
 		 */
 		btrfs_del_ordered_inode(inode, 1);
 	}
+
+	nr = trans->blocks_used;
 
 	btrfs_end_transaction_throttle(trans, root);
 fail:
@@ -884,12 +1073,17 @@ static int btrfs_rmdir(struct inode *dir
 	trans = btrfs_start_transaction(root, 1);
 	btrfs_set_trans_block_group(trans, dir);
 
+	err = btrfs_orphan_add(trans, inode);
+	if (err)
+		goto fail_trans;
+
 	/* now the directory is empty */
 	err = btrfs_unlink_trans(trans, root, dir, dentry);
 	if (!err) {
 		inode->i_size = 0;
 	}
 
+fail_trans:
 	nr = trans->blocks_used;
 	ret = btrfs_end_transaction_throttle(trans, root);
 fail:
@@ -907,6 +1101,9 @@ fail:
  *
  * csum items that cross the new i_size are truncated to the new size
  * as well.
+ *
+ * min_type is the minimum key type to truncate down to.  If set to 0, this
+ * will kill all the items on this inode, including the INODE_ITEM_KEY.
  */
 static int btrfs_truncate_in_trans(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root,
@@ -1264,6 +1461,7 @@ void btrfs_delete_inode(struct inode *in
 
 	truncate_inode_pages(&inode->i_data, 0);
 	if (is_bad_inode(inode)) {
+		btrfs_orphan_del(NULL, inode);
 		goto no_delete;
 	}
 
@@ -1272,8 +1470,12 @@ void btrfs_delete_inode(struct inode *in
 
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
@@ -1453,7 +1655,7 @@ static struct dentry *btrfs_lookup(struc
 	struct btrfs_root *root = bi->root;
 	struct btrfs_root *sub_root = root;
 	struct btrfs_key location;
-	int ret;
+	int ret, do_orphan = 0;
 
 	if (dentry->d_name.len > BTRFS_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
@@ -1471,6 +1673,7 @@ static struct dentry *btrfs_lookup(struc
 			return ERR_PTR(ret);
 		if (ret > 0)
 			return ERR_PTR(-ENOENT);
+
 		inode = btrfs_iget_locked(dir->i_sb, location.objectid,
 					  sub_root);
 		if (!inode)
@@ -1480,6 +1683,7 @@ static struct dentry *btrfs_lookup(struc
 			if (sub_root != root) {
 				igrab(inode);
 				sub_root->inode = inode;
+				do_orphan = 1;
 			}
 			BTRFS_I(inode)->root = sub_root;
 			memcpy(&BTRFS_I(inode)->location, &location,
@@ -1488,6 +1692,10 @@ static struct dentry *btrfs_lookup(struc
 			unlock_new_inode(inode);
 		}
 	}
+
+	if (unlikely(do_orphan))
+		btrfs_orphan_cleanup(sub_root);
+
 	return d_splice_alias(inode, dentry);
 }
 
@@ -2601,12 +2809,19 @@ static void btrfs_truncate(struct inode 
 	trans = btrfs_start_transaction(root, 1);
 	btrfs_set_trans_block_group(trans, inode);
 
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
@@ -2686,6 +2901,7 @@ struct inode *btrfs_alloc_inode(struct s
 	ei->ordered_trans = 0;
 	ei->i_acl = BTRFS_ACL_NOT_CACHED;
 	ei->i_default_acl = BTRFS_ACL_NOT_CACHED;
+	INIT_LIST_HEAD(&ei->i_orphan);
 
 	return &ei->vfs_inode;
 }
@@ -2701,6 +2917,14 @@ void btrfs_destroy_inode(struct inode *i
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
 
 	btrfs_drop_extent_cache(inode, 0, (u64)-1);
 	kmem_cache_free(btrfs_inode_cachep, BTRFS_I(inode));
@@ -2830,6 +3054,11 @@ static int btrfs_rename(struct inode * o
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
diff -r 4c1c1ae077ef orphan.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/orphan.c	Thu Jul 10 22:36:24 2008 -0400
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
