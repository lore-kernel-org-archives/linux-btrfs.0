Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:41250 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752329AbeEKH40 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 03:56:26 -0400
Received: by mail-pf0-f196.google.com with SMTP id v63-v6so2336043pfk.8
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 00:56:26 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v3 05/11] Btrfs: get rid of BTRFS_INODE_HAS_ORPHAN_ITEM
Date: Fri, 11 May 2018 00:56:10 -0700
Message-Id: <844bfe29a31c7943053202c36a7990efd2437c69.1526025007.git.osandov@fb.com>
In-Reply-To: <cover.1526025007.git.osandov@fb.com>
References: <cover.1526025007.git.osandov@fb.com>
In-Reply-To: <cover.1526025007.git.osandov@fb.com>
References: <cover.1526025007.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Now that we don't add orphan items for truncate, there can't be races on
adding or deleting an orphan item, so this bit is unnecessary.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/btrfs_inode.h | 13 ++++----
 fs/btrfs/inode.c       | 76 +++++++++++-------------------------------
 2 files changed, 26 insertions(+), 63 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 234bae55b85d..a81112706cd5 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -23,13 +23,12 @@
 #define BTRFS_INODE_ORPHAN_META_RESERVED	1
 #define BTRFS_INODE_DUMMY			2
 #define BTRFS_INODE_IN_DEFRAG			3
-#define BTRFS_INODE_HAS_ORPHAN_ITEM		4
-#define BTRFS_INODE_HAS_ASYNC_EXTENT		5
-#define BTRFS_INODE_NEEDS_FULL_SYNC		6
-#define BTRFS_INODE_COPY_EVERYTHING		7
-#define BTRFS_INODE_IN_DELALLOC_LIST		8
-#define BTRFS_INODE_READDIO_NEED_LOCK		9
-#define BTRFS_INODE_HAS_PROPS		        10
+#define BTRFS_INODE_HAS_ASYNC_EXTENT		4
+#define BTRFS_INODE_NEEDS_FULL_SYNC		5
+#define BTRFS_INODE_COPY_EVERYTHING		6
+#define BTRFS_INODE_IN_DELALLOC_LIST		7
+#define BTRFS_INODE_READDIO_NEED_LOCK		8
+#define BTRFS_INODE_HAS_PROPS		        9
 
 /* in memory btrfs inode */
 struct btrfs_inode {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1460823951d7..e22f8c9f6459 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3354,7 +3354,6 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans,
 	struct btrfs_root *root = inode->root;
 	struct btrfs_block_rsv *block_rsv = NULL;
 	int reserve = 0;
-	bool insert = false;
 	int ret;
 
 	if (!root->orphan_block_rsv) {
@@ -3364,10 +3363,6 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans,
 			return -ENOMEM;
 	}
 
-	if (!test_and_set_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
-			      &inode->runtime_flags))
-		insert = true;
-
 	if (!test_and_set_bit(BTRFS_INODE_ORPHAN_META_RESERVED,
 			      &inode->runtime_flags))
 		reserve = 1;
@@ -3381,8 +3376,7 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans,
 		block_rsv = NULL;
 	}
 
-	if (insert)
-		atomic_inc(&root->orphan_inodes);
+	atomic_inc(&root->orphan_inodes);
 	spin_unlock(&root->orphan_lock);
 
 	/* grab metadata reservation from transaction handle */
@@ -3398,36 +3392,28 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans,
 			atomic_dec(&root->orphan_inodes);
 			clear_bit(BTRFS_INODE_ORPHAN_META_RESERVED,
 				  &inode->runtime_flags);
-			if (insert)
-				clear_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
-					  &inode->runtime_flags);
 			return ret;
 		}
 	}
 
 	/* insert an orphan item to track this unlinked file */
-	if (insert) {
-		ret = btrfs_insert_orphan_item(trans, root, btrfs_ino(inode));
-		if (ret) {
-			if (reserve) {
-				clear_bit(BTRFS_INODE_ORPHAN_META_RESERVED,
-					  &inode->runtime_flags);
-				btrfs_orphan_release_metadata(inode);
-			}
-			/*
-			 * btrfs_orphan_commit_root may race with us and set
-			 * ->orphan_block_rsv to zero, in order to avoid that,
-			 * decrease ->orphan_inodes after everything is done.
-			 */
-			atomic_dec(&root->orphan_inodes);
-			if (ret != -EEXIST) {
-				clear_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
-					  &inode->runtime_flags);
-				btrfs_abort_transaction(trans, ret);
-				return ret;
-			}
+	ret = btrfs_insert_orphan_item(trans, root, btrfs_ino(inode));
+	if (ret) {
+		if (reserve) {
+			clear_bit(BTRFS_INODE_ORPHAN_META_RESERVED,
+				  &inode->runtime_flags);
+			btrfs_orphan_release_metadata(inode);
+		}
+		/*
+		 * btrfs_orphan_commit_root may race with us and set
+		 * ->orphan_block_rsv to zero, in order to avoid that,
+		 * decrease ->orphan_inodes after everything is done.
+		 */
+		atomic_dec(&root->orphan_inodes);
+		if (ret != -EEXIST) {
+			btrfs_abort_transaction(trans, ret);
+			return ret;
 		}
-		ret = 0;
 	}
 
 	return 0;
@@ -3441,14 +3427,9 @@ static int btrfs_orphan_del(struct btrfs_trans_handle *trans,
 			    struct btrfs_inode *inode)
 {
 	struct btrfs_root *root = inode->root;
-	int delete_item = 0;
 	int ret = 0;
 
-	if (test_and_clear_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
-			       &inode->runtime_flags))
-		delete_item = 1;
-
-	if (delete_item && trans)
+	if (trans)
 		ret = btrfs_del_orphan_item(trans, root, btrfs_ino(inode));
 
 	if (test_and_clear_bit(BTRFS_INODE_ORPHAN_META_RESERVED,
@@ -3460,8 +3441,7 @@ static int btrfs_orphan_del(struct btrfs_trans_handle *trans,
 	 * to zero, in order to avoid that, decrease ->orphan_inodes after
 	 * everything is done.
 	 */
-	if (delete_item)
-		atomic_dec(&root->orphan_inodes);
+	atomic_dec(&root->orphan_inodes);
 
 	return ret;
 }
@@ -3619,12 +3599,6 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 			continue;
 		}
 
-		/*
-		 * add this inode to the orphan list so btrfs_orphan_del does
-		 * the proper thing when we hit it
-		 */
-		set_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
-			&BTRFS_I(inode)->runtime_flags);
 		atomic_inc(&root->orphan_inodes);
 
 		nr_unlink++;
@@ -5264,11 +5238,8 @@ void btrfs_evict_inode(struct inode *inode)
 
 	btrfs_free_io_failure_record(BTRFS_I(inode), 0, (u64)-1);
 
-	if (test_bit(BTRFS_FS_LOG_RECOVERING, &fs_info->flags)) {
-		BUG_ON(test_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
-				 &BTRFS_I(inode)->runtime_flags));
+	if (test_bit(BTRFS_FS_LOG_RECOVERING, &fs_info->flags))
 		goto no_delete;
-	}
 
 	if (inode->i_nlink > 0) {
 		BUG_ON(btrfs_root_refs(&root->root_item) != 0 &&
@@ -9265,13 +9236,6 @@ void btrfs_destroy_inode(struct inode *inode)
 	if (!root)
 		goto free;
 
-	if (test_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
-		     &BTRFS_I(inode)->runtime_flags)) {
-		btrfs_info(fs_info, "inode %llu still on the orphan list",
-			   btrfs_ino(BTRFS_I(inode)));
-		atomic_dec(&root->orphan_inodes);
-	}
-
 	while (1) {
 		ordered = btrfs_lookup_first_ordered_extent(inode, (u64)-1);
 		if (!ordered)
-- 
2.17.0

