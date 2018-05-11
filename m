Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:44011 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752209AbeEKH4Z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 03:56:25 -0400
Received: by mail-pg0-f68.google.com with SMTP id k11-v6so2096582pgo.10
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 00:56:25 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v3 04/11] Btrfs: stop creating orphan items for truncate
Date: Fri, 11 May 2018 00:56:09 -0700
Message-Id: <bc3b880668e4102f32f2400dcf7945bb3a784050.1526025007.git.osandov@fb.com>
In-Reply-To: <cover.1526025007.git.osandov@fb.com>
References: <cover.1526025007.git.osandov@fb.com>
In-Reply-To: <cover.1526025007.git.osandov@fb.com>
References: <cover.1526025007.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Currently, we insert an orphan item during a truncate so that if there's
a crash, we don't leak extents past the on-disk i_size. However, since
commit 7f4f6e0a3f6d ("Btrfs: only update disk_i_size as we remove
extents"), we keep disk_i_size in sync with the extent items as we
truncate, so orphan cleanup will never have any extents to remove. Don't
bother with the superfluous orphan item.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/free-space-cache.c |   6 +-
 fs/btrfs/inode.c            | 159 +++++++++++-------------------------
 2 files changed, 51 insertions(+), 114 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index e5b569bebc73..d5f80cb300be 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -253,10 +253,8 @@ int btrfs_truncate_free_space_cache(struct btrfs_trans_handle *trans,
 	truncate_pagecache(inode, 0);
 
 	/*
-	 * We don't need an orphan item because truncating the free space cache
-	 * will never be split across transactions.
-	 * We don't need to check for -EAGAIN because we're a free space
-	 * cache inode
+	 * We skip the throttling logic for free space cache inodes, so we don't
+	 * need to check for -EAGAIN.
 	 */
 	ret = btrfs_truncate_inode_items(trans, root, inode,
 					 0, BTRFS_EXTENT_DATA_KEY);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index bd4975476f0e..1460823951d7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3341,8 +3341,8 @@ void btrfs_orphan_commit_root(struct btrfs_trans_handle *trans,
 }
 
 /*
- * This creates an orphan entry for the given inode in case something goes
- * wrong in the middle of an unlink/truncate.
+ * This creates an orphan entry for the given inode in case something goes wrong
+ * in the middle of an unlink.
  *
  * NOTE: caller of this function should reserve 5 units of metadata for
  *	 this function.
@@ -3405,7 +3405,7 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans,
 		}
 	}
 
-	/* insert an orphan item to track this unlinked/truncated file */
+	/* insert an orphan item to track this unlinked file */
 	if (insert) {
 		ret = btrfs_insert_orphan_item(trans, root, btrfs_ino(inode));
 		if (ret) {
@@ -3434,8 +3434,8 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans,
 }
 
 /*
- * We have done the truncate/delete so we can go ahead and remove the orphan
- * item for this particular inode.
+ * We have done the delete so we can go ahead and remove the orphan item for
+ * this particular inode.
  */
 static int btrfs_orphan_del(struct btrfs_trans_handle *trans,
 			    struct btrfs_inode *inode)
@@ -3479,7 +3479,7 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 	struct btrfs_trans_handle *trans;
 	struct inode *inode;
 	u64 last_objectid = 0;
-	int ret = 0, nr_unlink = 0, nr_truncate = 0;
+	int ret = 0, nr_unlink = 0;
 
 	if (cmpxchg(&root->orphan_cleanup_state, 0, ORPHAN_CLEANUP_STARTED))
 		return 0;
@@ -3579,12 +3579,31 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 				key.offset = found_key.objectid - 1;
 				continue;
 			}
+
 		}
+
 		/*
-		 * Inode is already gone but the orphan item is still there,
-		 * kill the orphan item.
+		 * If we have an inode with links, there are a couple of
+		 * possibilities. Old kernels (before v3.12) used to create an
+		 * orphan item for truncate indicating that there were possibly
+		 * extent items past i_size that needed to be deleted. In v3.12,
+		 * truncate was changed to update i_size in sync with the extent
+		 * items, but the (useless) orphan item was still created. Since
+		 * v4.18, we don't create the orphan item for truncate at all.
+		 *
+		 * So, this item could mean that we need to do a truncate, but
+		 * only if this filesystem was last used on a pre-v3.12 kernel
+		 * and was not cleanly unmounted. The odds of that are quite
+		 * slim, and it's a pain to do the truncate now, so just delete
+		 * the orphan item.
+		 *
+		 * It's also possible that this orphan item was supposed to be
+		 * deleted but wasn't. The inode number may have been reused,
+		 * but either way, we can delete the orphan item.
 		 */
-		if (ret == -ENOENT) {
+		if (ret == -ENOENT || inode->i_nlink) {
+			if (!ret)
+				iput(inode);
 			trans = btrfs_start_transaction(root, 1);
 			if (IS_ERR(trans)) {
 				ret = PTR_ERR(trans);
@@ -3608,34 +3627,7 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 			&BTRFS_I(inode)->runtime_flags);
 		atomic_inc(&root->orphan_inodes);
 
-		/* if we have links, this was a truncate, lets do that */
-		if (inode->i_nlink) {
-			if (WARN_ON(!S_ISREG(inode->i_mode))) {
-				iput(inode);
-				continue;
-			}
-			nr_truncate++;
-
-			/* 1 for the orphan item deletion. */
-			trans = btrfs_start_transaction(root, 1);
-			if (IS_ERR(trans)) {
-				iput(inode);
-				ret = PTR_ERR(trans);
-				goto out;
-			}
-			ret = btrfs_orphan_add(trans, BTRFS_I(inode));
-			btrfs_end_transaction(trans);
-			if (ret) {
-				iput(inode);
-				goto out;
-			}
-
-			ret = btrfs_truncate(inode, false);
-			if (ret)
-				btrfs_orphan_del(NULL, BTRFS_I(inode));
-		} else {
-			nr_unlink++;
-		}
+		nr_unlink++;
 
 		/* this will do delete_inode and everything for us */
 		iput(inode);
@@ -3660,8 +3652,6 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 
 	if (nr_unlink)
 		btrfs_debug(fs_info, "unlinked %d orphans", nr_unlink);
-	if (nr_truncate)
-		btrfs_debug(fs_info, "truncated %d orphans", nr_truncate);
 
 out:
 	if (ret)
@@ -5087,29 +5077,6 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
 			set_bit(BTRFS_INODE_ORDERED_DATA_CLOSE,
 				&BTRFS_I(inode)->runtime_flags);
 
-		/*
-		 * 1 for the orphan item we're going to add
-		 * 1 for the orphan item deletion.
-		 */
-		trans = btrfs_start_transaction(root, 2);
-		if (IS_ERR(trans))
-			return PTR_ERR(trans);
-
-		/*
-		 * We need to do this in case we fail at _any_ point during the
-		 * actual truncate.  Once we do the truncate_setsize we could
-		 * invalidate pages which forces any outstanding ordered io to
-		 * be instantly completed which will give us extents that need
-		 * to be truncated.  If we fail to get an orphan inode down we
-		 * could have left over extents that were never meant to live,
-		 * so we need to guarantee from this point on that everything
-		 * will be consistent.
-		 */
-		ret = btrfs_orphan_add(trans, BTRFS_I(inode));
-		btrfs_end_transaction(trans);
-		if (ret)
-			return ret;
-
 		truncate_setsize(inode, newsize);
 
 		/* Disable nonlocked read DIO to avoid the end less truncate */
@@ -5121,29 +5088,16 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
 		if (ret && inode->i_nlink) {
 			int err;
 
-			/* To get a stable disk_i_size */
-			err = btrfs_wait_ordered_range(inode, 0, (u64)-1);
-			if (err) {
-				btrfs_orphan_del(NULL, BTRFS_I(inode));
-				return err;
-			}
-
 			/*
-			 * failed to truncate, disk_i_size is only adjusted down
-			 * as we remove extents, so it should represent the true
-			 * size of the inode, so reset the in memory size and
-			 * delete our orphan entry.
+			 * Truncate failed, so fix up the in-memory size. We
+			 * adjusted disk_i_size down as we removed extents, so
+			 * wait for disk_i_size to be stable and then update the
+			 * in-memory size to match.
 			 */
-			trans = btrfs_join_transaction(root);
-			if (IS_ERR(trans)) {
-				btrfs_orphan_del(NULL, BTRFS_I(inode));
-				return ret;
-			}
-			i_size_write(inode, BTRFS_I(inode)->disk_i_size);
-			err = btrfs_orphan_del(trans, BTRFS_I(inode));
+			err = btrfs_wait_ordered_range(inode, 0, (u64)-1);
 			if (err)
-				btrfs_abort_transaction(trans, err);
-			btrfs_end_transaction(trans);
+				return err;
+			i_size_write(inode, BTRFS_I(inode)->disk_i_size);
 		}
 	}
 
@@ -9048,39 +9002,31 @@ static int btrfs_truncate(struct inode *inode, bool skip_writeback)
 	}
 
 	/*
-	 * Yes ladies and gentlemen, this is indeed ugly.  The fact is we have
-	 * 3 things going on here
-	 *
-	 * 1) We need to reserve space for our orphan item and the space to
-	 * delete our orphan item.  Lord knows we don't want to have a dangling
-	 * orphan item because we didn't reserve space to remove it.
+	 * Yes ladies and gentlemen, this is indeed ugly.  We have a couple of
+	 * things going on here:
 	 *
-	 * 2) We need to reserve space to update our inode.
+	 * 1) We need to reserve space to update our inode.
 	 *
-	 * 3) We need to have something to cache all the space that is going to
+	 * 2) We need to have something to cache all the space that is going to
 	 * be free'd up by the truncate operation, but also have some slack
 	 * space reserved in case it uses space during the truncate (thank you
 	 * very much snapshotting).
 	 *
-	 * And we need these to all be separate.  The fact is we can use a lot of
+	 * And we need these to be separate.  The fact is we can use a lot of
 	 * space doing the truncate, and we have no earthly idea how much space
 	 * we will use, so we need the truncate reservation to be separate so it
-	 * doesn't end up using space reserved for updating the inode or
-	 * removing the orphan item.  We also need to be able to stop the
-	 * transaction and start a new one, which means we need to be able to
-	 * update the inode several times, and we have no idea of knowing how
-	 * many times that will be, so we can't just reserve 1 item for the
-	 * entirety of the operation, so that has to be done separately as well.
-	 * Then there is the orphan item, which does indeed need to be held on
-	 * to for the whole operation, and we need nobody to touch this reserved
-	 * space except the orphan code.
+	 * doesn't end up using space reserved for updating the inode.  We also
+	 * need to be able to stop the transaction and start a new one, which
+	 * means we need to be able to update the inode several times, and we
+	 * have no idea of knowing how many times that will be, so we can't just
+	 * reserve 1 item for the entirety of the operation, so that has to be
+	 * done separately as well.
 	 *
 	 * So that leaves us with
 	 *
-	 * 1) root->orphan_block_rsv - for the orphan deletion.
-	 * 2) rsv - for the truncate reservation, which we will steal from the
+	 * 1) rsv - for the truncate reservation, which we will steal from the
 	 * transaction reservation.
-	 * 3) fs_info->trans_block_rsv - this will have 1 items worth left for
+	 * 2) fs_info->trans_block_rsv - this will have 1 items worth left for
 	 * updating the inode.
 	 */
 	rsv = btrfs_alloc_block_rsv(fs_info, BTRFS_BLOCK_RSV_TEMP);
@@ -9168,13 +9114,6 @@ static int btrfs_truncate(struct inode *inode, bool skip_writeback)
 		btrfs_ordered_update_i_size(inode, inode->i_size, NULL);
 	}
 
-	if (ret == 0 && inode->i_nlink > 0) {
-		trans->block_rsv = root->orphan_block_rsv;
-		ret = btrfs_orphan_del(trans, BTRFS_I(inode));
-		if (ret)
-			err = ret;
-	}
-
 	if (trans) {
 		trans->block_rsv = &fs_info->trans_block_rsv;
 		ret = btrfs_update_inode(trans, root, inode);
-- 
2.17.0

