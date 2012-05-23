Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755188Ab2EWPDA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 May 2012 11:03:00 -0400
Date: Wed, 23 May 2012 11:02:36 -0400
From: Josef Bacik <josef@redhat.com>
To: Christian Brunner <christian@brunner-muc.de>
Cc: Josef Bacik <josef@redhat.com>, miaox@cn.fujitsu.com,
        Martin Mailand <martin@tuxadero.com>, Sage Weil <sage@newdream.net>,
        linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: Re: Ceph on btrfs 3.4rc
Message-ID: <20120523150235.GB2127@localhost.localdomain>
References: <20120517194358.GA9846@dhcp231-144.rdu.redhat.com>
 <CAJafhzTQJchdd600DiEnooUH-P9ZcLvW+oEczCMNskd+Ud4BmQ@mail.gmail.com>
 <4FB56B21.7070800@tuxadero.com>
 <20120518144759.GA1892@localhost.localdomain>
 <4FB685C9.2050607@tuxadero.com>
 <20120518190105.GB1892@localhost.localdomain>
 <4FB9BDBA.2030806@cn.fujitsu.com>
 <CAJafhzSmLC9yUwrxsJEz5vKYnfP0DSWdMnA0oXmLT_4CQFc1oQ@mail.gmail.com>
 <20120522173344.GB1890@localhost.localdomain>
 <CAJafhzQGHsSA6dUwOqTJERj7SgVmKFuVDHk5R+i7n0FuhUAj_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CAJafhzQGHsSA6dUwOqTJERj7SgVmKFuVDHk5R+i7n0FuhUAj_g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 23, 2012 at 02:34:43PM +0200, Christian Brunner wrote:
> 2012/5/22 Josef Bacik <josef@redhat.com>:
> >>
> >
> > Yeah you would also need to change orphan_meta_reserved.  I fixed this by just
> > taking the BTRFS_I(inode)->lock when messing with these since we don't want to
> > take up all that space in the inode just for a marker.  I ran this patch for 3
> > hours with no issues, let me know if it works for you.  Thanks,
> 
> Compared to the last runs, I had to run it much longer, but somehow I
> managed to hit a BUG_ON again:
> 

Ok give this a shot, it should do it.  Thanks,

Josef


diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 9b9b15f..41ddec8 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -24,6 +24,22 @@
 #include "ordered-data.h"
 #include "delayed-inode.h"
 
+/*
+ * ordered_data_close is set by truncate when a file that used
+ * to have good data has been truncated to zero.  When it is set
+ * the btrfs file release call will add this inode to the
+ * ordered operations list so that we make sure to flush out any
+ * new data the application may have written before commit.
+ */
+#define BTRFS_INODE_ORDERED_DATA_CLOSE		0
+#define BTRFS_INODE_ORPHAN_META_RESERVED	1
+#define BTRFS_INODE_DUMMY			2
+#define BTRFS_INODE_IN_DEFRAG			3
+#define BTRFS_INODE_DELALLOC_META_RESERVED	4
+#define BTRFS_INODE_HAS_ORPHAN_ITEM		5
+#define BTRFS_INODE_FORCE_ZLIB			6
+#define BTRFS_INODE_FORCE_LZO			7
+
 /* in memory btrfs inode */
 struct btrfs_inode {
 	/* which subvolume this inode belongs to */
@@ -57,9 +73,6 @@ struct btrfs_inode {
 	/* used to order data wrt metadata */
 	struct btrfs_ordered_inode_tree ordered_tree;
 
-	/* for keeping track of orphaned inodes */
-	struct list_head i_orphan;
-
 	/* list of all the delalloc inodes in the FS.  There are times we need
 	 * to write all the delalloc pages to disk, and this list is used
 	 * to walk them all.
@@ -143,24 +156,7 @@ struct btrfs_inode {
 	 */
 	unsigned outstanding_extents;
 	unsigned reserved_extents;
-
-	/*
-	 * ordered_data_close is set by truncate when a file that used
-	 * to have good data has been truncated to zero.  When it is set
-	 * the btrfs file release call will add this inode to the
-	 * ordered operations list so that we make sure to flush out any
-	 * new data the application may have written before commit.
-	 */
-	unsigned ordered_data_close:1;
-	unsigned orphan_meta_reserved:1;
-	unsigned dummy_inode:1;
-	unsigned in_defrag:1;
-	unsigned delalloc_meta_reserved:1;
-
-	/*
-	 * always compress this one file
-	 */
-	unsigned force_compress:4;
+	unsigned long runtime_flags;
 
 	struct btrfs_delayed_node *delayed_node;
 
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8fd7233..aad2600 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1375,7 +1375,7 @@ struct btrfs_root {
 	struct list_head root_list;
 
 	spinlock_t orphan_lock;
-	struct list_head orphan_list;
+	atomic_t orphan_inodes;
 	struct btrfs_block_rsv *orphan_block_rsv;
 	int orphan_item_inserted;
 	int orphan_cleanup_state;
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 03e3748..5190861 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -669,8 +669,8 @@ static int btrfs_delayed_inode_reserve_metadata(
 		return ret;
 	} else if (src_rsv == &root->fs_info->delalloc_block_rsv) {
 		spin_lock(&BTRFS_I(inode)->lock);
-		if (BTRFS_I(inode)->delalloc_meta_reserved) {
-			BTRFS_I(inode)->delalloc_meta_reserved = 0;
+		if (test_and_clear_bit(BTRFS_INODE_DELALLOC_META_RESERVED,
+				       &BTRFS_I(inode)->runtime_flags)) {
 			spin_unlock(&BTRFS_I(inode)->lock);
 			release = true;
 			goto migrate;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a7ffc88..0ddeb0d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1153,7 +1153,6 @@ static void __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 	root->orphan_block_rsv = NULL;
 
 	INIT_LIST_HEAD(&root->dirty_list);
-	INIT_LIST_HEAD(&root->orphan_list);
 	INIT_LIST_HEAD(&root->root_list);
 	spin_lock_init(&root->orphan_lock);
 	spin_lock_init(&root->inode_lock);
@@ -1166,6 +1165,7 @@ static void __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 	atomic_set(&root->log_commit[0], 0);
 	atomic_set(&root->log_commit[1], 0);
 	atomic_set(&root->log_writers, 0);
+	atomic_set(&root->orphan_inodes, 0);
 	root->log_batch = 0;
 	root->log_transid = 0;
 	root->last_log_commit = 0;
@@ -2001,7 +2001,8 @@ int open_ctree(struct super_block *sb,
 	BTRFS_I(fs_info->btree_inode)->root = tree_root;
 	memset(&BTRFS_I(fs_info->btree_inode)->location, 0,
 	       sizeof(struct btrfs_key));
-	BTRFS_I(fs_info->btree_inode)->dummy_inode = 1;
+	set_bit(BTRFS_INODE_DUMMY,
+		&BTRFS_I(fs_info->btree_inode)->runtime_flags);
 	insert_inode_hash(fs_info->btree_inode);
 
 	spin_lock_init(&fs_info->block_group_cache_lock);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 49fd7b6..b372040 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4355,10 +4355,9 @@ static unsigned drop_outstanding_extent(struct inode *inode)
 	BTRFS_I(inode)->outstanding_extents--;
 
 	if (BTRFS_I(inode)->outstanding_extents == 0 &&
-	    BTRFS_I(inode)->delalloc_meta_reserved) {
+	    test_and_clear_bit(BTRFS_INODE_DELALLOC_META_RESERVED,
+			       &BTRFS_I(inode)->runtime_flags))
 		drop_inode_space = 1;
-		BTRFS_I(inode)->delalloc_meta_reserved = 0;
-	}
 
 	/*
 	 * If we have more or the same amount of outsanding extents than we have
@@ -4465,7 +4464,8 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	 * Add an item to reserve for updating the inode when we complete the
 	 * delalloc io.
 	 */
-	if (!BTRFS_I(inode)->delalloc_meta_reserved) {
+	if (!test_bit(BTRFS_INODE_DELALLOC_META_RESERVED,
+		      &BTRFS_I(inode)->runtime_flags)) {
 		nr_extents++;
 		extra_reserve = 1;
 	}
@@ -4511,7 +4511,8 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 
 	spin_lock(&BTRFS_I(inode)->lock);
 	if (extra_reserve) {
-		BTRFS_I(inode)->delalloc_meta_reserved = 1;
+		set_bit(BTRFS_INODE_DELALLOC_META_RESERVED,
+			&BTRFS_I(inode)->runtime_flags);
 		nr_extents--;
 	}
 	BTRFS_I(inode)->reserved_extents += nr_extents;
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 53bf2d7..2f19fe9 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -103,7 +103,7 @@ static void __btrfs_add_inode_defrag(struct inode *inode,
 			goto exists;
 		}
 	}
-	BTRFS_I(inode)->in_defrag = 1;
+	set_bit(BTRFS_INODE_IN_DEFRAG, &BTRFS_I(inode)->runtime_flags);
 	rb_link_node(&defrag->rb_node, parent, p);
 	rb_insert_color(&defrag->rb_node, &root->fs_info->defrag_inodes);
 	return;
@@ -131,7 +131,7 @@ int btrfs_add_inode_defrag(struct btrfs_trans_handle *trans,
 	if (btrfs_fs_closing(root->fs_info))
 		return 0;
 
-	if (BTRFS_I(inode)->in_defrag)
+	if (test_bit(BTRFS_INODE_IN_DEFRAG, &BTRFS_I(inode)->runtime_flags))
 		return 0;
 
 	if (trans)
@@ -148,7 +148,7 @@ int btrfs_add_inode_defrag(struct btrfs_trans_handle *trans,
 	defrag->root = root->root_key.objectid;
 
 	spin_lock(&root->fs_info->defrag_inodes_lock);
-	if (!BTRFS_I(inode)->in_defrag)
+	if (!test_bit(BTRFS_INODE_IN_DEFRAG, &BTRFS_I(inode)->runtime_flags))
 		__btrfs_add_inode_defrag(inode, defrag);
 	else
 		kfree(defrag);
@@ -252,7 +252,7 @@ int btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info)
 			goto next;
 
 		/* do a chunk of defrag */
-		BTRFS_I(inode)->in_defrag = 0;
+		clear_bit(BTRFS_INODE_IN_DEFRAG, &BTRFS_I(inode)->runtime_flags);
 		range.start = defrag->last_offset;
 		num_defrag = btrfs_defrag_file(inode, NULL, &range, defrag->transid,
 					       defrag_batch);
@@ -1466,8 +1466,8 @@ int btrfs_release_file(struct inode *inode, struct file *filp)
 	 * flush down new bytes that may have been written if the
 	 * application were using truncate to replace a file in place.
 	 */
-	if (BTRFS_I(inode)->ordered_data_close) {
-		BTRFS_I(inode)->ordered_data_close = 0;
+	if (test_and_clear_bit(BTRFS_INODE_ORDERED_DATA_CLOSE,
+			       &BTRFS_I(inode)->runtime_flags)) {
 		btrfs_add_ordered_operation(NULL, BTRFS_I(inode)->root, inode);
 		if (inode->i_size > BTRFS_ORDERED_OPERATIONS_FLUSH_LIMIT)
 			filemap_flush(inode->i_mapping);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 61b16c6..1d42dba 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -109,6 +109,15 @@ static int btrfs_init_inode_security(struct btrfs_trans_handle *trans,
 	return err;
 }
 
+static int btrfs_inode_force_compress(struct inode *inode)
+{
+	if (test_bit(BTRFS_INODE_FORCE_ZLIB, &BTRFS_I(inode)->runtime_flags))
+		return BTRFS_COMPRESS_ZLIB;
+	if (test_bit(BTRFS_INODE_FORCE_LZO, &BTRFS_I(inode)->runtime_flags))
+		return BTRFS_COMPRESS_LZO;
+	return BTRFS_COMPRESS_NONE;
+}
+
 /*
  * this does all the hard work for inserting an inline extent into
  * the btree.  The caller should have done a btrfs_drop_extents so that
@@ -396,7 +405,7 @@ again:
 	 */
 	if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS) &&
 	    (btrfs_test_opt(root, COMPRESS) ||
-	     (BTRFS_I(inode)->force_compress) ||
+	     btrfs_inode_force_compress(inode) ||
 	     (BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS))) {
 		WARN_ON(pages);
 		pages = kzalloc(sizeof(struct page *) * nr_pages, GFP_NOFS);
@@ -405,8 +414,8 @@ again:
 			goto cont;
 		}
 
-		if (BTRFS_I(inode)->force_compress)
-			compress_type = BTRFS_I(inode)->force_compress;
+		if (btrfs_inode_force_compress(inode))
+			compress_type = btrfs_inode_force_compress(inode);
 
 		ret = btrfs_compress_pages(compress_type,
 					   inode->i_mapping, start,
@@ -514,7 +523,7 @@ cont:
 
 		/* flag the file so we don't compress in the future */
 		if (!btrfs_test_opt(root, FORCE_COMPRESS) &&
-		    !(BTRFS_I(inode)->force_compress)) {
+		    !btrfs_inode_force_compress(inode)) {
 			BTRFS_I(inode)->flags |= BTRFS_INODE_NOCOMPRESS;
 		}
 	}
@@ -1365,7 +1374,7 @@ static int run_delalloc_range(struct inode *inode, struct page *locked_page,
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 0, nr_written);
 	else if (!btrfs_test_opt(root, COMPRESS) &&
-		 !(BTRFS_I(inode)->force_compress) &&
+		 !btrfs_inode_force_compress(inode) &&
 		 !(BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS))
 		ret = cow_file_range(inode, locked_page, start, end,
 				      page_started, nr_written, 1);
@@ -2072,12 +2081,12 @@ void btrfs_orphan_commit_root(struct btrfs_trans_handle *trans,
 	struct btrfs_block_rsv *block_rsv;
 	int ret;
 
-	if (!list_empty(&root->orphan_list) ||
+	if (atomic_read(&root->orphan_inodes) ||
 	    root->orphan_cleanup_state != ORPHAN_CLEANUP_DONE)
 		return;
 
 	spin_lock(&root->orphan_lock);
-	if (!list_empty(&root->orphan_list)) {
+	if (atomic_read(&root->orphan_inodes)) {
 		spin_unlock(&root->orphan_lock);
 		return;
 	}
@@ -2134,8 +2143,8 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
 		block_rsv = NULL;
 	}
 
-	if (list_empty(&BTRFS_I(inode)->i_orphan)) {
-		list_add(&BTRFS_I(inode)->i_orphan, &root->orphan_list);
+	if (!test_and_set_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
+			      &BTRFS_I(inode)->runtime_flags)) {
 #if 0
 		/*
 		 * For proper ENOSPC handling, we should do orphan
@@ -2148,12 +2157,12 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
 			insert = 1;
 #endif
 		insert = 1;
+		atomic_inc(&root->orphan_inodes);
 	}
 
-	if (!BTRFS_I(inode)->orphan_meta_reserved) {
-		BTRFS_I(inode)->orphan_meta_reserved = 1;
+	if (!test_and_set_bit(BTRFS_INODE_ORPHAN_META_RESERVED,
+			      &BTRFS_I(inode)->runtime_flags))
 		reserve = 1;
-	}
 	spin_unlock(&root->orphan_lock);
 
 	/* grab metadata reservation from transaction handle */
@@ -2166,6 +2175,8 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
 	if (insert >= 1) {
 		ret = btrfs_insert_orphan_item(trans, root, btrfs_ino(inode));
 		if (ret && ret != -EEXIST) {
+			clear_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
+				  &BTRFS_I(inode)->runtime_flags);
 			btrfs_abort_transaction(trans, root, ret);
 			return ret;
 		}
@@ -2195,26 +2206,33 @@ int btrfs_orphan_del(struct btrfs_trans_handle *trans, struct inode *inode)
 	int release_rsv = 0;
 	int ret = 0;
 
-	spin_lock(&root->orphan_lock);
-	if (!list_empty(&BTRFS_I(inode)->i_orphan)) {
-		list_del_init(&BTRFS_I(inode)->i_orphan);
+	/*
+	 * evict_inode gets called without holding the i_mutex so we need to
+	 * take the orphan lock to make sure we are safe in messing with these.
+	 */
+	if (trans && test_and_clear_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
+					&BTRFS_I(inode)->runtime_flags))
 		delete_item = 1;
-	}
 
-	if (BTRFS_I(inode)->orphan_meta_reserved) {
-		BTRFS_I(inode)->orphan_meta_reserved = 0;
+	if (trans && test_and_clear_bit(BTRFS_INODE_ORPHAN_META_RESERVED,
+					&BTRFS_I(inode)->runtime_flags))
 		release_rsv = 1;
-	}
-	spin_unlock(&root->orphan_lock);
 
 	if (trans && delete_item) {
 		ret = btrfs_del_orphan_item(trans, root, btrfs_ino(inode));
+		if (ret)
+			printk(KERN_ERR "couldn't find orphan item for %Lu, nlink %d, root %Lu, root being deleted %s\n",
+			       btrfs_ino(inode), inode->i_nlink, root->objectid,
+			       root->orphan_item_inserted ? "yes" : "no");
 		BUG_ON(ret); /* -ENOMEM or corruption (JDM: Recheck) */
 	}
 
 	if (release_rsv)
 		btrfs_orphan_release_metadata(inode);
 
+	if (trans && delete_item)
+		atomic_dec(&root->orphan_inodes);
+
 	return 0;
 }
 
@@ -2341,6 +2359,8 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 				ret = PTR_ERR(trans);
 				goto out;
 			}
+			printk(KERN_ERR "auto deleting %Lu\n",
+			       found_key.objectid);
 			ret = btrfs_del_orphan_item(trans, root,
 						    found_key.objectid);
 			BUG_ON(ret); /* -ENOMEM or corruption (JDM: Recheck) */
@@ -2352,9 +2372,9 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 		 * add this inode to the orphan list so btrfs_orphan_del does
 		 * the proper thing when we hit it
 		 */
-		spin_lock(&root->orphan_lock);
-		list_add(&BTRFS_I(inode)->i_orphan, &root->orphan_list);
-		spin_unlock(&root->orphan_lock);
+		set_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
+			&BTRFS_I(inode)->runtime_flags);
+		atomic_inc(&root->orphan_inodes);
 
 		/* if we have links, this was a truncate, lets do that */
 		if (inode->i_nlink) {
@@ -3607,7 +3627,8 @@ static int btrfs_setsize(struct inode *inode, loff_t newsize)
 		 * any new writes get down to disk quickly.
 		 */
 		if (newsize == 0)
-			BTRFS_I(inode)->ordered_data_close = 1;
+			set_bit(BTRFS_INODE_ORDERED_DATA_CLOSE,
+				&BTRFS_I(inode)->runtime_flags);
 
 		/* we don't support swapfiles, so vmtruncate shouldn't fail */
 		truncate_setsize(inode, newsize);
@@ -3671,7 +3692,8 @@ void btrfs_evict_inode(struct inode *inode)
 	btrfs_wait_ordered_range(inode, 0, (u64)-1);
 
 	if (root->fs_info->log_root_recovering) {
-		BUG_ON(!list_empty(&BTRFS_I(inode)->i_orphan));
+		BUG_ON(!test_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
+				 &BTRFS_I(inode)->runtime_flags));
 		goto no_delete;
 	}
 
@@ -4066,7 +4088,7 @@ static struct inode *new_simple_dir(struct super_block *s,
 
 	BTRFS_I(inode)->root = root;
 	memcpy(&BTRFS_I(inode)->location, key, sizeof(*key));
-	BTRFS_I(inode)->dummy_inode = 1;
+	set_bit(BTRFS_INODE_DUMMY, &BTRFS_I(inode)->runtime_flags);
 
 	inode->i_ino = BTRFS_EMPTY_SUBVOL_DIR_OBJECTID;
 	inode->i_op = &btrfs_dir_ro_inode_operations;
@@ -4370,7 +4392,7 @@ int btrfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 	int ret = 0;
 	bool nolock = false;
 
-	if (BTRFS_I(inode)->dummy_inode)
+	if (test_bit(BTRFS_INODE_DUMMY, &BTRFS_I(inode)->runtime_flags))
 		return 0;
 
 	if (btrfs_fs_closing(root->fs_info) && btrfs_is_free_space_inode(root, inode))
@@ -4403,7 +4425,7 @@ int btrfs_dirty_inode(struct inode *inode)
 	struct btrfs_trans_handle *trans;
 	int ret;
 
-	if (BTRFS_I(inode)->dummy_inode)
+	if (test_bit(BTRFS_INODE_DUMMY, &BTRFS_I(inode)->runtime_flags))
 		return 0;
 
 	trans = btrfs_join_transaction(root);
@@ -6685,7 +6707,7 @@ static int btrfs_truncate(struct inode *inode)
 
 	ret = btrfs_truncate_page(inode->i_mapping, inode->i_size);
 	if (ret)
-		return ret;
+		goto real_out;
 
 	btrfs_wait_ordered_range(inode, inode->i_size & (~mask), (u64)-1);
 	btrfs_ordered_update_i_size(inode, inode->i_size, NULL);
@@ -6727,8 +6749,10 @@ static int btrfs_truncate(struct inode *inode)
 	 * updating the inode.
 	 */
 	rsv = btrfs_alloc_block_rsv(root);
-	if (!rsv)
-		return -ENOMEM;
+	if (!rsv) {
+		ret = -ENOMEM;
+		goto real_out;
+	}
 	rsv->size = min_size;
 
 	/*
@@ -6771,7 +6795,8 @@ static int btrfs_truncate(struct inode *inode)
 	 * using truncate to replace the contents of the file will
 	 * end up with a zero length file after a crash.
 	 */
-	if (inode->i_size == 0 && BTRFS_I(inode)->ordered_data_close)
+	if (inode->i_size == 0 && test_bit(BTRFS_INODE_ORDERED_DATA_CLOSE,
+					   &BTRFS_I(inode)->runtime_flags))
 		btrfs_add_ordered_operation(trans, root, inode);
 
 	while (1) {
@@ -6847,7 +6872,7 @@ end_trans:
 
 out:
 	btrfs_free_block_rsv(root, rsv);
-
+real_out:
 	if (ret && !err)
 		err = ret;
 
@@ -6909,12 +6934,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	ei->outstanding_extents = 0;
 	ei->reserved_extents = 0;
 
-	ei->ordered_data_close = 0;
-	ei->orphan_meta_reserved = 0;
-	ei->dummy_inode = 0;
-	ei->in_defrag = 0;
-	ei->delalloc_meta_reserved = 0;
-	ei->force_compress = BTRFS_COMPRESS_NONE;
+	ei->runtime_flags = 0;
 
 	ei->delayed_node = NULL;
 
@@ -6927,7 +6947,6 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	mutex_init(&ei->log_mutex);
 	mutex_init(&ei->delalloc_mutex);
 	btrfs_ordered_inode_tree_init(&ei->ordered_tree);
-	INIT_LIST_HEAD(&ei->i_orphan);
 	INIT_LIST_HEAD(&ei->delalloc_inodes);
 	INIT_LIST_HEAD(&ei->ordered_operations);
 	RB_CLEAR_NODE(&ei->rb_node);
@@ -6972,13 +6991,12 @@ void btrfs_destroy_inode(struct inode *inode)
 		spin_unlock(&root->fs_info->ordered_extent_lock);
 	}
 
-	spin_lock(&root->orphan_lock);
-	if (!list_empty(&BTRFS_I(inode)->i_orphan)) {
+	if (test_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
+		     &BTRFS_I(inode)->runtime_flags)) {
 		printk(KERN_INFO "BTRFS: inode %llu still on the orphan list\n",
 		       (unsigned long long)btrfs_ino(inode));
-		list_del_init(&BTRFS_I(inode)->i_orphan);
+		atomic_dec(&root->orphan_inodes);
 	}
-	spin_unlock(&root->orphan_lock);
 
 	while (1) {
 		ordered = btrfs_lookup_first_ordered_extent(inode, (u64)-1);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 14f8e1f..a901654 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1039,6 +1039,21 @@ out:
 
 }
 
+static void btrfs_set_inode_force_compress(struct inode *inode,
+					   int compress_type)
+{
+	if (compress_type == BTRFS_COMPRESS_ZLIB) {
+		set_bit(BTRFS_INODE_FORCE_ZLIB, &BTRFS_I(inode)->runtime_flags);
+	} else if (compress_type == BTRFS_COMPRESS_LZO) {
+		set_bit(BTRFS_INODE_FORCE_LZO, &BTRFS_I(inode)->runtime_flags);
+	} else if (compress_type == BTRFS_COMPRESS_NONE) {
+		clear_bit(BTRFS_INODE_FORCE_ZLIB,
+			  &BTRFS_I(inode)->runtime_flags);
+		clear_bit(BTRFS_INODE_FORCE_LZO,
+			  &BTRFS_I(inode)->runtime_flags);
+	}
+}
+
 int btrfs_defrag_file(struct inode *inode, struct file *file,
 		      struct btrfs_ioctl_defrag_range_args *range,
 		      u64 newer_than, unsigned long max_to_defrag)
@@ -1162,7 +1177,7 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 		}
 
 		if (range->flags & BTRFS_DEFRAG_RANGE_COMPRESS)
-			BTRFS_I(inode)->force_compress = compress_type;
+			btrfs_set_inode_force_compress(inode, compress_type);
 
 		if (i + cluster > ra_index) {
 			ra_index = max(i, ra_index);
@@ -1230,7 +1245,7 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 		atomic_dec(&root->fs_info->async_submit_draining);
 
 		mutex_lock(&inode->i_mutex);
-		BTRFS_I(inode)->force_compress = BTRFS_COMPRESS_NONE;
+		btrfs_set_inode_force_compress(inode, BTRFS_COMPRESS_NONE);
 		mutex_unlock(&inode->i_mutex);
 	}
 
