Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:44504 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752191AbeEKH4a (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 03:56:30 -0400
Received: by mail-pf0-f194.google.com with SMTP id q22-v6so2337565pff.11
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 00:56:30 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v3 09/11] Btrfs: fix ENOSPC caused by orphan items reservations
Date: Fri, 11 May 2018 00:56:14 -0700
Message-Id: <1b1d16312885156c62b5eaba4d3d59b41a59d2e0.1526025007.git.osandov@fb.com>
In-Reply-To: <cover.1526025007.git.osandov@fb.com>
References: <cover.1526025007.git.osandov@fb.com>
In-Reply-To: <cover.1526025007.git.osandov@fb.com>
References: <cover.1526025007.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Currently, we keep space reserved for all inode orphan items until the
inode is evicted (i.e., all references to it are dropped). We hit an
issue where an application would keep a bunch of deleted files open (by
design) and thus keep a large amount of space reserved, causing ENOSPC
errors when other operations tried to reserve space. This long-standing
reservation isn't absolutely necessary for a couple of reasons:

- We can almost always make the reservation we need or steal from the
  global reserve for the orphan item
- If we can't, it's not the end of the world if we drop the orphan item
  on the floor and let the next mount clean it up

So, get rid of persistent reservation and just reserve space in
btrfs_evict_inode().

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/btrfs_inode.h |  17 +++--
 fs/btrfs/inode.c       | 158 ++++++++++-------------------------------
 2 files changed, 46 insertions(+), 129 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index a81112706cd5..bbbe7f308d68 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -20,15 +20,14 @@
  * new data the application may have written before commit.
  */
 #define BTRFS_INODE_ORDERED_DATA_CLOSE		0
-#define BTRFS_INODE_ORPHAN_META_RESERVED	1
-#define BTRFS_INODE_DUMMY			2
-#define BTRFS_INODE_IN_DEFRAG			3
-#define BTRFS_INODE_HAS_ASYNC_EXTENT		4
-#define BTRFS_INODE_NEEDS_FULL_SYNC		5
-#define BTRFS_INODE_COPY_EVERYTHING		6
-#define BTRFS_INODE_IN_DELALLOC_LIST		7
-#define BTRFS_INODE_READDIO_NEED_LOCK		8
-#define BTRFS_INODE_HAS_PROPS		        9
+#define BTRFS_INODE_DUMMY			1
+#define BTRFS_INODE_IN_DEFRAG			2
+#define BTRFS_INODE_HAS_ASYNC_EXTENT		3
+#define BTRFS_INODE_NEEDS_FULL_SYNC		4
+#define BTRFS_INODE_COPY_EVERYTHING		5
+#define BTRFS_INODE_IN_DELALLOC_LIST		6
+#define BTRFS_INODE_READDIO_NEED_LOCK		7
+#define BTRFS_INODE_HAS_PROPS		        8
 
 /* in memory btrfs inode */
 struct btrfs_inode {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7ca55af8aa17..b64c4189e2c0 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3331,77 +3331,16 @@ void btrfs_orphan_commit_root(struct btrfs_trans_handle *trans,
 /*
  * This creates an orphan entry for the given inode in case something goes wrong
  * in the middle of an unlink.
- *
- * NOTE: caller of this function should reserve 5 units of metadata for
- *	 this function.
  */
 int btrfs_orphan_add(struct btrfs_trans_handle *trans,
-		struct btrfs_inode *inode)
+		     struct btrfs_inode *inode)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
-	struct btrfs_root *root = inode->root;
-	struct btrfs_block_rsv *block_rsv = NULL;
-	int reserve = 0;
 	int ret;
 
-	if (!root->orphan_block_rsv) {
-		block_rsv = btrfs_alloc_block_rsv(fs_info,
-						  BTRFS_BLOCK_RSV_TEMP);
-		if (!block_rsv)
-			return -ENOMEM;
-	}
-
-	if (!test_and_set_bit(BTRFS_INODE_ORPHAN_META_RESERVED,
-			      &inode->runtime_flags))
-		reserve = 1;
-
-	spin_lock(&root->orphan_lock);
-	/* If someone has created ->orphan_block_rsv, be happy to use it. */
-	if (!root->orphan_block_rsv) {
-		root->orphan_block_rsv = block_rsv;
-	} else if (block_rsv) {
-		btrfs_free_block_rsv(fs_info, block_rsv);
-		block_rsv = NULL;
-	}
-
-	atomic_inc(&root->orphan_inodes);
-	spin_unlock(&root->orphan_lock);
-
-	/* grab metadata reservation from transaction handle */
-	if (reserve) {
-		ret = btrfs_orphan_reserve_metadata(trans, inode);
-		ASSERT(!ret);
-		if (ret) {
-			/*
-			 * dec doesn't need spin_lock as ->orphan_block_rsv
-			 * would be released only if ->orphan_inodes is
-			 * zero.
-			 */
-			atomic_dec(&root->orphan_inodes);
-			clear_bit(BTRFS_INODE_ORPHAN_META_RESERVED,
-				  &inode->runtime_flags);
-			return ret;
-		}
-	}
-
-	/* insert an orphan item to track this unlinked file */
-	ret = btrfs_insert_orphan_item(trans, root, btrfs_ino(inode));
-	if (ret) {
-		if (reserve) {
-			clear_bit(BTRFS_INODE_ORPHAN_META_RESERVED,
-				  &inode->runtime_flags);
-			btrfs_orphan_release_metadata(inode);
-		}
-		/*
-		 * btrfs_orphan_commit_root may race with us and set
-		 * ->orphan_block_rsv to zero, in order to avoid that,
-		 * decrease ->orphan_inodes after everything is done.
-		 */
-		atomic_dec(&root->orphan_inodes);
-		if (ret != -EEXIST) {
-			btrfs_abort_transaction(trans, ret);
-			return ret;
-		}
+	ret = btrfs_insert_orphan_item(trans, inode->root, btrfs_ino(inode));
+	if (ret && ret != -EEXIST) {
+		btrfs_abort_transaction(trans, ret);
+		return ret;
 	}
 
 	return 0;
@@ -3414,24 +3353,7 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans,
 static int btrfs_orphan_del(struct btrfs_trans_handle *trans,
 			    struct btrfs_inode *inode)
 {
-	struct btrfs_root *root = inode->root;
-	int ret = 0;
-
-	if (trans)
-		ret = btrfs_del_orphan_item(trans, root, btrfs_ino(inode));
-
-	if (test_and_clear_bit(BTRFS_INODE_ORPHAN_META_RESERVED,
-			       &inode->runtime_flags))
-		btrfs_orphan_release_metadata(inode);
-
-	/*
-	 * btrfs_orphan_commit_root may race with us and set ->orphan_block_rsv
-	 * to zero, in order to avoid that, decrease ->orphan_inodes after
-	 * everything is done.
-	 */
-	atomic_dec(&root->orphan_inodes);
-
-	return ret;
+	return btrfs_del_orphan_item(trans, inode->root, btrfs_ino(inode));
 }
 
 /*
@@ -3587,8 +3509,6 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 			continue;
 		}
 
-		atomic_inc(&root->orphan_inodes);
-
 		nr_unlink++;
 
 		/* this will do delete_inode and everything for us */
@@ -5255,10 +5175,8 @@ void btrfs_evict_inode(struct inode *inode)
 	     btrfs_is_free_space_inode(BTRFS_I(inode))))
 		goto no_delete;
 
-	if (is_bad_inode(inode)) {
-		btrfs_orphan_del(NULL, BTRFS_I(inode));
+	if (is_bad_inode(inode))
 		goto no_delete;
-	}
 	/* do we really want it for ->i_nlink > 0 and zero btrfs_root_refs? */
 	if (!special_file(inode->i_mode))
 		btrfs_wait_ordered_range(inode, 0, (u64)-1);
@@ -5275,16 +5193,12 @@ void btrfs_evict_inode(struct inode *inode)
 	}
 
 	ret = btrfs_commit_inode_delayed_inode(BTRFS_I(inode));
-	if (ret) {
-		btrfs_orphan_del(NULL, BTRFS_I(inode));
+	if (ret)
 		goto no_delete;
-	}
 
 	rsv = btrfs_alloc_block_rsv(fs_info, BTRFS_BLOCK_RSV_TEMP);
-	if (!rsv) {
-		btrfs_orphan_del(NULL, BTRFS_I(inode));
+	if (!rsv)
 		goto no_delete;
-	}
 	rsv->size = min_size;
 	rsv->failfast = 1;
 
@@ -5292,46 +5206,50 @@ void btrfs_evict_inode(struct inode *inode)
 
 	while (1) {
 		trans = evict_refill_and_join(root, rsv, min_size);
-		if (IS_ERR(trans)) {
-			btrfs_orphan_del(NULL, BTRFS_I(inode));
-			btrfs_free_block_rsv(fs_info, rsv);
-			goto no_delete;
-		}
+		if (IS_ERR(trans))
+			goto free_rsv;
 
 		trans->block_rsv = rsv;
 
 		ret = btrfs_truncate_inode_items(trans, root, inode, 0, 0);
-		if (ret) {
-			trans->block_rsv = &fs_info->trans_block_rsv;
-			btrfs_end_transaction(trans);
-			btrfs_btree_balance_dirty(fs_info);
-			if (ret != -ENOSPC && ret != -EAGAIN) {
-				btrfs_orphan_del(NULL, BTRFS_I(inode));
-				btrfs_free_block_rsv(fs_info, rsv);
-				goto no_delete;
-			}
-		} else {
+		trans->block_rsv = &fs_info->trans_block_rsv;
+		btrfs_end_transaction(trans);
+		btrfs_btree_balance_dirty(fs_info);
+		if (ret && ret != -ENOSPC && ret != -EAGAIN)
+			goto free_rsv;
+		else if (!ret)
 			break;
-		}
 	}
 
-	btrfs_free_block_rsv(fs_info, rsv);
-
 	/*
-	 * Errors here aren't a big deal, it just means we leave orphan items
-	 * in the tree.  They will be cleaned up on the next mount.
+	 * Errors here aren't a big deal, it just means we leave orphan items in
+	 * the tree. They will be cleaned up on the next mount. If the inode
+	 * number gets reused, cleanup deletes the orphan item without doing
+	 * anything, and unlink reuses the existing orphan item.
+	 *
+	 * If it turns out that we are dropping too many of these, we might want
+	 * to add a mechanism for retrying these after a commit.
 	 */
-	trans->block_rsv = root->orphan_block_rsv;
-	btrfs_orphan_del(trans, BTRFS_I(inode));
+	trans = evict_refill_and_join(root, rsv, min_size);
+	if (!IS_ERR(trans)) {
+		trans->block_rsv = rsv;
+		btrfs_orphan_del(trans, BTRFS_I(inode));
+		trans->block_rsv = &fs_info->trans_block_rsv;
+		btrfs_end_transaction(trans);
+	}
 
-	trans->block_rsv = &fs_info->trans_block_rsv;
 	if (!(root == fs_info->tree_root ||
 	      root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID))
 		btrfs_return_ino(root, btrfs_ino(BTRFS_I(inode)));
 
-	btrfs_end_transaction(trans);
-	btrfs_btree_balance_dirty(fs_info);
+free_rsv:
+	btrfs_free_block_rsv(fs_info, rsv);
 no_delete:
+	/*
+	 * If we didn't successfully delete, the orphan item will still be in
+	 * the tree and we'll retry on the next mount. Again, we might also want
+	 * to retry these periodically in the future.
+	 */
 	btrfs_remove_delayed_node(BTRFS_I(inode));
 	clear_inode(inode);
 }
-- 
2.17.0

