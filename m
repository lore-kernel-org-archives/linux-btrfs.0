Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411Ab2EYOJr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 May 2012 10:09:47 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q4PE9l0i030915
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 25 May 2012 10:09:47 -0400
Received: from localhost.localdomain.com (vpn-8-136.rdu.redhat.com [10.11.8.136])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q4PE9kBl023507
	for <linux-btrfs@vger.kernel.org>; Fri, 25 May 2012 10:09:46 -0400
From: Josef Bacik <josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: convert the inode bit field to use the actual bit operations
Date: Fri, 25 May 2012 10:09:45 -0400
Message-Id: <1337954985-3425-1-git-send-email-josef@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Miao pointed this out while I was working on an orphan problem that messing
with a bitfield where different ranges are protected by different locks
doesn't work out right.  Turns out we've been doing this forever where we
have different parts of the bit field protected by either no lock at all or
different locks which could cause all sorts of weird problems including the
issue I was hitting.  So instead make a runtime_flags thing that we use the
normal bit operations on that are all atomic so we can keep having our
no/different locking for the different flags and then make force_compress
it's own thing so it can be treated normally.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/btrfs_inode.h   |   30 ++++++++++++++++--------------
 fs/btrfs/delayed-inode.c |    4 ++--
 fs/btrfs/disk-io.c       |    3 ++-
 fs/btrfs/extent-tree.c   |   11 ++++++-----
 fs/btrfs/file.c          |   12 ++++++------
 fs/btrfs/inode.c         |   28 ++++++++++++----------------
 6 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 3771b85..6265edb 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -24,6 +24,19 @@
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
+
 /* in memory btrfs inode */
 struct btrfs_inode {
 	/* which subvolume this inode belongs to */
@@ -78,6 +91,8 @@ struct btrfs_inode {
 	/* the space_info for where this inode's data allocations are done */
 	struct btrfs_space_info *space_info;
 
+	unsigned long runtime_flags;
+
 	/* full 64 bit generation number, struct vfs_inode doesn't have a big
 	 * enough field for this.
 	 */
@@ -142,22 +157,9 @@ struct btrfs_inode {
 	unsigned reserved_extents;
 
 	/*
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
 	 * always compress this one file
 	 */
-	unsigned force_compress:4;
+	unsigned force_compress;
 
 	struct btrfs_delayed_node *delayed_node;
 
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index bcd40c7..c18d044 100644
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
index 19f5b45..0cf8ef2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
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
index 59ae191..1902726 100644
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
index c9e2bf5..cdc68ff 100644
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
@@ -1465,8 +1465,8 @@ int btrfs_release_file(struct inode *inode, struct file *filp)
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
index 54ae3df..2a5ca50 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2182,10 +2182,9 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
 		insert = 1;
 	}
 
-	if (!BTRFS_I(inode)->orphan_meta_reserved) {
-		BTRFS_I(inode)->orphan_meta_reserved = 1;
+	if (!test_and_set_bit(BTRFS_INODE_ORPHAN_META_RESERVED,
+			      &BTRFS_I(inode)->runtime_flags))
 		reserve = 1;
-	}
 	spin_unlock(&root->orphan_lock);
 
 	/* grab metadata reservation from transaction handle */
@@ -2233,10 +2232,9 @@ int btrfs_orphan_del(struct btrfs_trans_handle *trans, struct inode *inode)
 		delete_item = 1;
 	}
 
-	if (BTRFS_I(inode)->orphan_meta_reserved) {
-		BTRFS_I(inode)->orphan_meta_reserved = 0;
+	if (test_and_clear_bit(BTRFS_INODE_ORPHAN_META_RESERVED,
+			       &BTRFS_I(inode)->runtime_flags))
 		release_rsv = 1;
-	}
 	spin_unlock(&root->orphan_lock);
 
 	if (trans && delete_item) {
@@ -3642,7 +3640,8 @@ static int btrfs_setsize(struct inode *inode, loff_t newsize)
 		 * any new writes get down to disk quickly.
 		 */
 		if (newsize == 0)
-			BTRFS_I(inode)->ordered_data_close = 1;
+			set_bit(BTRFS_INODE_ORDERED_DATA_CLOSE,
+				&BTRFS_I(inode)->runtime_flags);
 
 		/* we don't support swapfiles, so vmtruncate shouldn't fail */
 		truncate_setsize(inode, newsize);
@@ -4102,7 +4101,7 @@ static struct inode *new_simple_dir(struct super_block *s,
 
 	BTRFS_I(inode)->root = root;
 	memcpy(&BTRFS_I(inode)->location, key, sizeof(*key));
-	BTRFS_I(inode)->dummy_inode = 1;
+	set_bit(BTRFS_INODE_DUMMY, &BTRFS_I(inode)->runtime_flags);
 
 	inode->i_ino = BTRFS_EMPTY_SUBVOL_DIR_OBJECTID;
 	inode->i_op = &btrfs_dir_ro_inode_operations;
@@ -4406,7 +4405,7 @@ int btrfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 	int ret = 0;
 	bool nolock = false;
 
-	if (BTRFS_I(inode)->dummy_inode)
+	if (test_bit(BTRFS_INODE_DUMMY, &BTRFS_I(inode)->runtime_flags))
 		return 0;
 
 	if (btrfs_fs_closing(root->fs_info) && btrfs_is_free_space_inode(root, inode))
@@ -4439,7 +4438,7 @@ int btrfs_dirty_inode(struct inode *inode)
 	struct btrfs_trans_handle *trans;
 	int ret;
 
-	if (BTRFS_I(inode)->dummy_inode)
+	if (test_bit(BTRFS_INODE_DUMMY, &BTRFS_I(inode)->runtime_flags))
 		return 0;
 
 	trans = btrfs_join_transaction(root);
@@ -6724,7 +6723,8 @@ static int btrfs_truncate(struct inode *inode)
 	 * using truncate to replace the contents of the file will
 	 * end up with a zero length file after a crash.
 	 */
-	if (inode->i_size == 0 && BTRFS_I(inode)->ordered_data_close)
+	if (inode->i_size == 0 && test_bit(BTRFS_INODE_ORDERED_DATA_CLOSE,
+					   &BTRFS_I(inode)->runtime_flags))
 		btrfs_add_ordered_operation(trans, root, inode);
 
 	while (1) {
@@ -6861,11 +6861,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	ei->outstanding_extents = 0;
 	ei->reserved_extents = 0;
 
-	ei->ordered_data_close = 0;
-	ei->orphan_meta_reserved = 0;
-	ei->dummy_inode = 0;
-	ei->in_defrag = 0;
-	ei->delalloc_meta_reserved = 0;
+	ei->runtime_flags = 0;
 	ei->force_compress = BTRFS_COMPRESS_NONE;
 
 	ei->delayed_node = NULL;
-- 
1.7.7.6

