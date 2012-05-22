Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759947Ab2EVReF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 May 2012 13:34:05 -0400
Date: Tue, 22 May 2012 13:33:44 -0400
From: Josef Bacik <josef@redhat.com>
To: Christian Brunner <christian@brunner-muc.de>
Cc: miaox@cn.fujitsu.com, Josef Bacik <josef@redhat.com>,
        Martin Mailand <martin@tuxadero.com>, Sage Weil <sage@newdream.net>,
        linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: Re: Ceph on btrfs 3.4rc
Message-ID: <20120522173344.GB1890@localhost.localdomain>
References: <20120517144306.GA3011@dhcp231-144.rdu.redhat.com>
 <4FB51577.5090100@tuxadero.com>
 <20120517194358.GA9846@dhcp231-144.rdu.redhat.com>
 <CAJafhzTQJchdd600DiEnooUH-P9ZcLvW+oEczCMNskd+Ud4BmQ@mail.gmail.com>
 <4FB56B21.7070800@tuxadero.com>
 <20120518144759.GA1892@localhost.localdomain>
 <4FB685C9.2050607@tuxadero.com>
 <20120518190105.GB1892@localhost.localdomain>
 <4FB9BDBA.2030806@cn.fujitsu.com>
 <CAJafhzSmLC9yUwrxsJEz5vKYnfP0DSWdMnA0oXmLT_4CQFc1oQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CAJafhzSmLC9yUwrxsJEz5vKYnfP0DSWdMnA0oXmLT_4CQFc1oQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 22, 2012 at 12:29:59PM +0200, Christian Brunner wrote:
> 2012/5/21 Miao Xie <miaox@cn.fujitsu.com>:
> > Hi Josef,
> >
> > On fri, 18 May 2012 15:01:05 -0400, Josef Bacik wrote:
> >> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> >> index 9b9b15f..492c74f 100644
> >> --- a/fs/btrfs/btrfs_inode.h
> >> +++ b/fs/btrfs/btrfs_inode.h
> >> @@ -57,9 +57,6 @@ struct btrfs_inode {
> >>       /* used to order data wrt metadata */
> >>       struct btrfs_ordered_inode_tree ordered_tree;
> >>
> >> -     /* for keeping track of orphaned inodes */
> >> -     struct list_head i_orphan;
> >> -
> >>       /* list of all the delalloc inodes in the FS.  There are times we need
> >>        * to write all the delalloc pages to disk, and this list is used
> >>        * to walk them all.
> >> @@ -156,6 +153,8 @@ struct btrfs_inode {
> >>       unsigned dummy_inode:1;
> >>       unsigned in_defrag:1;
> >>       unsigned delalloc_meta_reserved:1;
> >> +     unsigned has_orphan_item:1;
> >> +     unsigned doing_truncate:1;
> >
> > I think the problem is we should not use the different lock to protect the bit fields which
> > are stored in the same machine word. Or some bit fields may be covered by the others when
> > someone change those fields. Could you try to declare ->delalloc_meta_reserved and ->has_orphan_item
> > as a integer?
> 
> I have tried changing it to:
> 
> struct btrfs_inode {
>         unsigned orphan_meta_reserved:1;
>         unsigned dummy_inode:1;
>         unsigned in_defrag:1;
> -       unsigned delalloc_meta_reserved:1;
> +       int delalloc_meta_reserved;
> +       int has_orphan_item;
> +       int doing_truncate;
> 
> The strange thing is, that I'm no longer hitting the BUG_ON, but the
> old WARNING (no additional messages):
> 

Yeah you would also need to change orphan_meta_reserved.  I fixed this by just
taking the BTRFS_I(inode)->lock when messing with these since we don't want to
take up all that space in the inode just for a marker.  I ran this patch for 3
hours with no issues, let me know if it works for you.  Thanks,

Josef


diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 3771b85..559e716 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -57,9 +57,6 @@ struct btrfs_inode {
 	/* used to order data wrt metadata */
 	struct btrfs_ordered_inode_tree ordered_tree;
 
-	/* for keeping track of orphaned inodes */
-	struct list_head i_orphan;
-
 	/* list of all the delalloc inodes in the FS.  There are times we need
 	 * to write all the delalloc pages to disk, and this list is used
 	 * to walk them all.
@@ -153,6 +150,7 @@ struct btrfs_inode {
 	unsigned dummy_inode:1;
 	unsigned in_defrag:1;
 	unsigned delalloc_meta_reserved:1;
+	unsigned has_orphan_item:1;
 
 	/*
 	 * always compress this one file
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index ba8743b..72cdf98 100644
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
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 19f5b45..25dba7a 100644
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
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 54ae3df..54f1b30 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2104,12 +2104,12 @@ void btrfs_orphan_commit_root(struct btrfs_trans_handle *trans,
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
@@ -2166,8 +2166,9 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
 		block_rsv = NULL;
 	}
 
-	if (list_empty(&BTRFS_I(inode)->i_orphan)) {
-		list_add(&BTRFS_I(inode)->i_orphan, &root->orphan_list);
+	spin_lock(&BTRFS_I(inode)->lock);
+	if (!BTRFS_I(inode)->has_orphan_item) {
+		BTRFS_I(inode)->has_orphan_item = 1;
 #if 0
 		/*
 		 * For proper ENOSPC handling, we should do orphan
@@ -2180,12 +2181,14 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
 			insert = 1;
 #endif
 		insert = 1;
+		atomic_inc(&root->orphan_inodes);
 	}
 
 	if (!BTRFS_I(inode)->orphan_meta_reserved) {
 		BTRFS_I(inode)->orphan_meta_reserved = 1;
 		reserve = 1;
 	}
+	spin_unlock(&BTRFS_I(inode)->lock);
 	spin_unlock(&root->orphan_lock);
 
 	/* grab metadata reservation from transaction handle */
@@ -2198,6 +2201,9 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
 	if (insert >= 1) {
 		ret = btrfs_insert_orphan_item(trans, root, btrfs_ino(inode));
 		if (ret && ret != -EEXIST) {
+			spin_lock(&BTRFS_I(inode)->lock);
+			BTRFS_I(inode)->has_orphan_item = 0;
+			spin_unlock(&BTRFS_I(inode)->lock);
 			btrfs_abort_transaction(trans, root, ret);
 			return ret;
 		}
@@ -2227,26 +2233,41 @@ int btrfs_orphan_del(struct btrfs_trans_handle *trans, struct inode *inode)
 	int release_rsv = 0;
 	int ret = 0;
 
-	spin_lock(&root->orphan_lock);
-	if (!list_empty(&BTRFS_I(inode)->i_orphan)) {
-		list_del_init(&BTRFS_I(inode)->i_orphan);
-		delete_item = 1;
+	/*
+	 * evict_inode gets called without holding the i_mutex so we need to
+	 * take the orphan lock to make sure we are safe in messing with these.
+	 */
+	spin_lock(&BTRFS_I(inode)->lock);
+	if (BTRFS_I(inode)->has_orphan_item) {
+		if (trans) {
+			BTRFS_I(inode)->has_orphan_item = 0;
+			delete_item = 1;
+		} else {
+			WARN_ON(1);
+		}
 	}
 
-	if (BTRFS_I(inode)->orphan_meta_reserved) {
+	if (trans && BTRFS_I(inode)->orphan_meta_reserved) {
 		BTRFS_I(inode)->orphan_meta_reserved = 0;
 		release_rsv = 1;
 	}
-	spin_unlock(&root->orphan_lock);
+	spin_unlock(&BTRFS_I(inode)->lock);
 
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
 
@@ -2373,6 +2394,8 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 				ret = PTR_ERR(trans);
 				goto out;
 			}
+			printk(KERN_ERR "auto deleting %Lu\n",
+			       found_key.objectid);
 			ret = btrfs_del_orphan_item(trans, root,
 						    found_key.objectid);
 			BUG_ON(ret); /* -ENOMEM or corruption (JDM: Recheck) */
@@ -2384,9 +2407,11 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 		 * add this inode to the orphan list so btrfs_orphan_del does
 		 * the proper thing when we hit it
 		 */
-		spin_lock(&root->orphan_lock);
-		list_add(&BTRFS_I(inode)->i_orphan, &root->orphan_list);
-		spin_unlock(&root->orphan_lock);
+		spin_lock(&BTRFS_I(inode)->lock);
+		atomic_inc(&root->orphan_inodes);
+		WARN_ON(BTRFS_I(inode)->has_orphan_item);
+		BTRFS_I(inode)->has_orphan_item = 1;
+		spin_unlock(&BTRFS_I(inode)->lock);
 
 		/* if we have links, this was a truncate, lets do that */
 		if (inode->i_nlink) {
@@ -3707,7 +3732,7 @@ void btrfs_evict_inode(struct inode *inode)
 	btrfs_wait_ordered_range(inode, 0, (u64)-1);
 
 	if (root->fs_info->log_root_recovering) {
-		BUG_ON(!list_empty(&BTRFS_I(inode)->i_orphan));
+		BUG_ON(!BTRFS_I(inode)->has_orphan_item);
 		goto no_delete;
 	}
 
@@ -6638,7 +6663,7 @@ static int btrfs_truncate(struct inode *inode)
 
 	ret = btrfs_truncate_page(inode->i_mapping, inode->i_size);
 	if (ret)
-		return ret;
+		goto real_out;
 
 	btrfs_wait_ordered_range(inode, inode->i_size & (~mask), (u64)-1);
 	btrfs_ordered_update_i_size(inode, inode->i_size, NULL);
@@ -6680,8 +6705,10 @@ static int btrfs_truncate(struct inode *inode)
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
@@ -6800,7 +6827,7 @@ end_trans:
 
 out:
 	btrfs_free_block_rsv(root, rsv);
-
+real_out:
 	if (ret && !err)
 		err = ret;
 
@@ -6866,6 +6893,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	ei->dummy_inode = 0;
 	ei->in_defrag = 0;
 	ei->delalloc_meta_reserved = 0;
+	ei->has_orphan_item = 0;
 	ei->force_compress = BTRFS_COMPRESS_NONE;
 
 	ei->delayed_node = NULL;
@@ -6879,7 +6907,6 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	mutex_init(&ei->log_mutex);
 	mutex_init(&ei->delalloc_mutex);
 	btrfs_ordered_inode_tree_init(&ei->ordered_tree);
-	INIT_LIST_HEAD(&ei->i_orphan);
 	INIT_LIST_HEAD(&ei->delalloc_inodes);
 	INIT_LIST_HEAD(&ei->ordered_operations);
 	RB_CLEAR_NODE(&ei->rb_node);
@@ -6924,13 +6951,11 @@ void btrfs_destroy_inode(struct inode *inode)
 		spin_unlock(&root->fs_info->ordered_extent_lock);
 	}
 
-	spin_lock(&root->orphan_lock);
-	if (!list_empty(&BTRFS_I(inode)->i_orphan)) {
+	if (BTRFS_I(inode)->has_orphan_item) {
 		printk(KERN_INFO "BTRFS: inode %llu still on the orphan list\n",
 		       (unsigned long long)btrfs_ino(inode));
-		list_del_init(&BTRFS_I(inode)->i_orphan);
+		atomic_dec(&root->orphan_inodes);
 	}
-	spin_unlock(&root->orphan_lock);
 
 	while (1) {
 		ordered = btrfs_lookup_first_ordered_extent(inode, (u64)-1);
