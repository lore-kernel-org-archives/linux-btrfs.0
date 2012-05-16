Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760349Ab2EPTUv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 May 2012 15:20:51 -0400
Date: Wed, 16 May 2012 15:20:36 -0400
From: Josef Bacik <josef@redhat.com>
To: Josef Bacik <josef@redhat.com>
Cc: Martin Mailand <martin@tuxadero.com>,
        Christian Brunner <christian@brunner-muc.de>,
        Sage Weil <sage@newdream.net>, linux-btrfs@vger.kernel.org,
        ceph-devel@vger.kernel.org
Subject: Re: Ceph on btrfs 3.4rc
Message-ID: <20120516192035.GA1910@localhost.localdomain>
References: <CAJafhzSVZ3+1ApgJU=sQu6gM62BeWVGG4mqFPNYRHx79czYJtQ@mail.gmail.com>
 <20120424152141.GB3326@localhost.localdomain>
 <Pine.LNX.4.64.1204240922040.29159@cobra.newdream.net>
 <CAJafhzSgaQ3sx=Af0Ru0CiwQH37V5y8jgjoTo_8yozcjo9rpPA@mail.gmail.com>
 <20120510203523.GD2061@localhost.localdomain>
 <20120511133124.GB2089@localhost.localdomain>
 <4FAD5B7E.5040801@tuxadero.com>
 <20120511191623.GB3503@localhost.localdomain>
 <4FB11479.8060408@tuxadero.com>
 <20120514142048.GA3260@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120514142048.GA3260@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 14, 2012 at 10:20:48AM -0400, Josef Bacik wrote:
> On Mon, May 14, 2012 at 04:19:37PM +0200, Martin Mailand wrote:
> > Hi Josef,
> > 
> > Am 11.05.2012 21:16, schrieb Josef Bacik:
> > >Heh duh, sorry, try this one instead.  Thanks,
> > 
> > With this patch I got this Bug:
> 
> Yeah Christian reported the same thing on Friday.  I'm going to work on a patch
> and actually run it here to make sure it doesn't blow up and then send it to the
> list when I think I've got something that works.  Thanks,
> 

Hrm ok so I finally got some time to try and debug it and let the test run a
good long while (5 hours almost) and I couldn't hit either the original bug or
the one you guys were hitting.  So either my extra little bit of locking did the
trick or I get to keep my "Worst reproducer ever" award.  Can you guys give this
one a whirl and if it panics send the entire dmesg since it should spit out a
WARN_ON() to let me know what I thought was the problem was it.  Thanks,

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
index 54ae3df..c0cff20 100644
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
@@ -2166,8 +2166,8 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
 		block_rsv = NULL;
 	}
 
-	if (list_empty(&BTRFS_I(inode)->i_orphan)) {
-		list_add(&BTRFS_I(inode)->i_orphan, &root->orphan_list);
+	if (!BTRFS_I(inode)->has_orphan_item) {
+		BTRFS_I(inode)->has_orphan_item = 1;
 #if 0
 		/*
 		 * For proper ENOSPC handling, we should do orphan
@@ -2180,6 +2180,7 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
 			insert = 1;
 #endif
 		insert = 1;
+		atomic_inc(&root->orphan_inodes);
 	}
 
 	if (!BTRFS_I(inode)->orphan_meta_reserved) {
@@ -2198,6 +2199,9 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
 	if (insert >= 1) {
 		ret = btrfs_insert_orphan_item(trans, root, btrfs_ino(inode));
 		if (ret && ret != -EEXIST) {
+			spin_lock(&root->orphan_lock);
+			BTRFS_I(inode)->has_orphan_item = 0;
+			spin_unlock(&root->orphan_lock);
 			btrfs_abort_transaction(trans, root, ret);
 			return ret;
 		}
@@ -2227,9 +2231,13 @@ int btrfs_orphan_del(struct btrfs_trans_handle *trans, struct inode *inode)
 	int release_rsv = 0;
 	int ret = 0;
 
+	/*
+	 * evict_inode gets called without holding the i_mutex so we need to
+	 * take the orphan lock to make sure we are safe in messing with these.
+	 */
 	spin_lock(&root->orphan_lock);
-	if (!list_empty(&BTRFS_I(inode)->i_orphan)) {
-		list_del_init(&BTRFS_I(inode)->i_orphan);
+	if (BTRFS_I(inode)->has_orphan_item) {
+		BTRFS_I(inode)->has_orphan_item = 0;
 		delete_item = 1;
 	}
 
@@ -2247,6 +2255,9 @@ int btrfs_orphan_del(struct btrfs_trans_handle *trans, struct inode *inode)
 	if (release_rsv)
 		btrfs_orphan_release_metadata(inode);
 
+	if (trans && delete_item)
+		atomic_dec(&root->orphan_inodes);
+
 	return 0;
 }
 
@@ -2385,7 +2396,9 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 		 * the proper thing when we hit it
 		 */
 		spin_lock(&root->orphan_lock);
-		list_add(&BTRFS_I(inode)->i_orphan, &root->orphan_list);
+		atomic_inc(&root->orphan_inodes);
+		WARN_ON(BTRFS_I(inode)->has_orphan_item);
+		BTRFS_I(inode)->has_orphan_item = 1;
 		spin_unlock(&root->orphan_lock);
 
 		/* if we have links, this was a truncate, lets do that */
@@ -3707,7 +3720,7 @@ void btrfs_evict_inode(struct inode *inode)
 	btrfs_wait_ordered_range(inode, 0, (u64)-1);
 
 	if (root->fs_info->log_root_recovering) {
-		BUG_ON(!list_empty(&BTRFS_I(inode)->i_orphan));
+		BUG_ON(!BTRFS_I(inode)->has_orphan_item);
 		goto no_delete;
 	}
 
@@ -6866,6 +6879,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	ei->dummy_inode = 0;
 	ei->in_defrag = 0;
 	ei->delalloc_meta_reserved = 0;
+	ei->has_orphan_item = 0;
 	ei->force_compress = BTRFS_COMPRESS_NONE;
 
 	ei->delayed_node = NULL;
@@ -6879,7 +6893,6 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	mutex_init(&ei->log_mutex);
 	mutex_init(&ei->delalloc_mutex);
 	btrfs_ordered_inode_tree_init(&ei->ordered_tree);
-	INIT_LIST_HEAD(&ei->i_orphan);
 	INIT_LIST_HEAD(&ei->delalloc_inodes);
 	INIT_LIST_HEAD(&ei->ordered_operations);
 	RB_CLEAR_NODE(&ei->rb_node);
@@ -6924,13 +6937,11 @@ void btrfs_destroy_inode(struct inode *inode)
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
