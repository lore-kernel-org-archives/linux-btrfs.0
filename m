Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626Ab2EYOKI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 May 2012 10:10:08 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q4PEA82l006569
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 25 May 2012 10:10:08 -0400
Received: from localhost.localdomain.com (vpn-8-136.rdu.redhat.com [10.11.8.136])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q4PEA7c1001599
	for <linux-btrfs@vger.kernel.org>; Fri, 25 May 2012 10:10:08 -0400
From: Josef Bacik <josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix how we deal with the orphan block rsv
Date: Fri, 25 May 2012 10:10:07 -0400
Message-Id: <1337955007-3466-1-git-send-email-josef@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ceph was hitting this race where we would remove an inode from the per-root
orphan list before we would release the space we had reserved for the inode.
We actually don't need a list or anything, we just need to make sure the
root doesn't try to free up the orphan reserve until after the inodes have
released their reservations.  So use an atomic counter instead of a list on
the root and only decrement the counter after we've released our
reservation.  I've tested this as well as several others and we no longer
see the warnings that you would see while running ceph.  Thanks,
Btrfs: fix how we deal with the orphan block rsv

Ceph was hitting this race where we would remove an inode from the per-root
orphan list before we would release the space we had reserved for the inode.
We actually don't need a list or anything, we just need to make sure the
root doesn't try to free up the orphan reserve until after the inodes have
released their reservations.  So use an atomic counter instead of a list on
the root and only decrement the counter after we've released our
reservation.  I've tested this as well as several others and we no longer
see the warnings that you would see while running ceph.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/btrfs_inode.h |    4 +---
 fs/btrfs/ctree.h       |    2 +-
 fs/btrfs/disk-io.c     |    2 +-
 fs/btrfs/inode.c       |   38 +++++++++++++++++++++-----------------
 4 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 6265edb..ce2c9d6 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -36,6 +36,7 @@
 #define BTRFS_INODE_DUMMY			2
 #define BTRFS_INODE_IN_DEFRAG			3
 #define BTRFS_INODE_DELALLOC_META_RESERVED	4
+#define BTRFS_INODE_HAS_ORPHAN_ITEM		5
 
 /* in memory btrfs inode */
 struct btrfs_inode {
@@ -70,9 +71,6 @@ struct btrfs_inode {
 	/* used to order data wrt metadata */
 	struct btrfs_ordered_inode_tree ordered_tree;
 
-	/* for keeping track of orphaned inodes */
-	struct list_head i_orphan;
-
 	/* list of all the delalloc inodes in the FS.  There are times we need
 	 * to write all the delalloc pages to disk, and this list is used
 	 * to walk them all.
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
index 0cf8ef2..297e5a8 100644
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
index 2a5ca50..cd51968 100644
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
+	if (!test_and_set_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
+			      &BTRFS_I(inode)->runtime_flags)) {
 #if 0
 		/*
 		 * For proper ENOSPC handling, we should do orphan
@@ -2180,6 +2180,7 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
 			insert = 1;
 #endif
 		insert = 1;
+		atomic_dec(&root->orphan_inodes);
 	}
 
 	if (!test_and_set_bit(BTRFS_INODE_ORPHAN_META_RESERVED,
@@ -2197,6 +2198,8 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
 	if (insert >= 1) {
 		ret = btrfs_insert_orphan_item(trans, root, btrfs_ino(inode));
 		if (ret && ret != -EEXIST) {
+			clear_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
+				  &BTRFS_I(inode)->runtime_flags);
 			btrfs_abort_transaction(trans, root, ret);
 			return ret;
 		}
@@ -2227,10 +2230,9 @@ int btrfs_orphan_del(struct btrfs_trans_handle *trans, struct inode *inode)
 	int ret = 0;
 
 	spin_lock(&root->orphan_lock);
-	if (!list_empty(&BTRFS_I(inode)->i_orphan)) {
-		list_del_init(&BTRFS_I(inode)->i_orphan);
+	if (test_and_clear_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
+			       &BTRFS_I(inode)->runtime_flags))
 		delete_item = 1;
-	}
 
 	if (test_and_clear_bit(BTRFS_INODE_ORPHAN_META_RESERVED,
 			       &BTRFS_I(inode)->runtime_flags))
@@ -2242,8 +2244,10 @@ int btrfs_orphan_del(struct btrfs_trans_handle *trans, struct inode *inode)
 		BUG_ON(ret); /* -ENOMEM or corruption (JDM: Recheck) */
 	}
 
-	if (release_rsv)
+	if (release_rsv) {
 		btrfs_orphan_release_metadata(inode);
+		atomic_dec(&root->orphan_inodes);
+	}
 
 	return 0;
 }
@@ -2371,6 +2375,8 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 				ret = PTR_ERR(trans);
 				goto out;
 			}
+			printk(KERN_ERR "auto deleting %Lu\n",
+			       found_key.objectid);
 			ret = btrfs_del_orphan_item(trans, root,
 						    found_key.objectid);
 			BUG_ON(ret); /* -ENOMEM or corruption (JDM: Recheck) */
@@ -2382,9 +2388,8 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 		 * add this inode to the orphan list so btrfs_orphan_del does
 		 * the proper thing when we hit it
 		 */
-		spin_lock(&root->orphan_lock);
-		list_add(&BTRFS_I(inode)->i_orphan, &root->orphan_list);
-		spin_unlock(&root->orphan_lock);
+		set_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
+			&BTRFS_I(inode)->runtime_flags);
 
 		/* if we have links, this was a truncate, lets do that */
 		if (inode->i_nlink) {
@@ -3706,7 +3711,8 @@ void btrfs_evict_inode(struct inode *inode)
 	btrfs_wait_ordered_range(inode, 0, (u64)-1);
 
 	if (root->fs_info->log_root_recovering) {
-		BUG_ON(!list_empty(&BTRFS_I(inode)->i_orphan));
+		BUG_ON(!test_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
+				 &BTRFS_I(inode)->runtime_flags));
 		goto no_delete;
 	}
 
@@ -6875,7 +6881,6 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	mutex_init(&ei->log_mutex);
 	mutex_init(&ei->delalloc_mutex);
 	btrfs_ordered_inode_tree_init(&ei->ordered_tree);
-	INIT_LIST_HEAD(&ei->i_orphan);
 	INIT_LIST_HEAD(&ei->delalloc_inodes);
 	INIT_LIST_HEAD(&ei->ordered_operations);
 	RB_CLEAR_NODE(&ei->rb_node);
@@ -6920,13 +6925,12 @@ void btrfs_destroy_inode(struct inode *inode)
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
-- 
1.7.7.6

