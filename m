From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix how we do space reservation for truncate
Date: Tue,  3 May 2011 10:44:32 -0400
Message-ID: <1304433872-32368-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The ceph guys keep running into problems where we have space reserved in our
orphan block rsv when freeing it up.  This is because they tend to do snapshots
alot, so their truncates tend to use a bunch of space, so when we go to do
things like update the inode we have to steal reservation space in order to make
the reservation happen.  This happens because truncate can use as much space as
it freaking feels like, but we still have to hold space for removing the orphan
item and updating the inode, which will definitely always happen.  So in order
to fix this we need to split all of the reservation stuf up.  So with this patch
we have

1) The orphan block reserve which only holds the space for deleting our orphan
item when everything is over.

2) The truncate block reserve which gets allocated and used specifically for the
space that the truncate will use on a per truncate basis.

3) The transaction will always have 1 item's worth of data reserved so we can
update the inode normally.

Hopefully this will make the ceph problem go away.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.h       |    3 +
 fs/btrfs/extent-tree.c |   46 +++++++++++++++----
 fs/btrfs/inode.c       |  111 ++++++++++++++++++++++++++++++++++++------------
 3 files changed, 123 insertions(+), 37 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index d2991c8..1a41d77 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2223,6 +2223,9 @@ int btrfs_block_rsv_migrate(struct btrfs_block_rsv *src_rsv,
 void btrfs_block_rsv_release(struct btrfs_root *root,
 			     struct btrfs_block_rsv *block_rsv,
 			     u64 num_bytes);
+int btrfs_truncate_reserve_metadata(struct btrfs_trans_handle *trans,
+				    struct btrfs_root *root,
+				    struct btrfs_block_rsv *rsv);
 int btrfs_set_block_group_ro(struct btrfs_root *root,
 			     struct btrfs_block_group_cache *cache);
 int btrfs_set_block_group_rw(struct btrfs_root *root,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a33d9a3..64d2514 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3934,6 +3934,37 @@ static u64 calc_trans_metadata_size(struct btrfs_root *root, int num_items)
 		3 * num_items;
 }
 
+int btrfs_truncate_reserve_metadata(struct btrfs_trans_handle *trans,
+				    struct btrfs_root *root,
+				    struct btrfs_block_rsv *rsv)
+{
+	struct btrfs_block_rsv *trans_rsv = &root->fs_info->trans_block_rsv;
+	u64 num_bytes;
+	int ret;
+
+	/*
+	 * Truncate should be freeing data, but give us 2 items just in case it
+	 * needs to use some space.  We may want to be smarter about this in the
+	 * future.
+	 */
+	num_bytes = calc_trans_metadata_size(root, 2);
+
+	/* We already have enough bytes, just return */
+	if (rsv->reserved >= num_bytes)
+		return 0;
+
+	num_bytes -= rsv->reserved;
+
+	/*
+	 * You should have reserved enough space before hand to do this, so this
+	 * should not fail.
+	 */
+	ret = block_rsv_migrate_bytes(trans_rsv, rsv, num_bytes);
+	BUG_ON(ret);
+
+	return 0;
+}
+
 int btrfs_trans_reserve_metadata(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root,
 				 int num_items)
@@ -3974,23 +4005,18 @@ int btrfs_orphan_reserve_metadata(struct btrfs_trans_handle *trans,
 	struct btrfs_block_rsv *dst_rsv = root->orphan_block_rsv;
 
 	/*
-	 * one for deleting orphan item, one for updating inode and
-	 * two for calling btrfs_truncate_inode_items.
-	 *
-	 * btrfs_truncate_inode_items is a delete operation, it frees
-	 * more space than it uses in most cases. So two units of
-	 * metadata space should be enough for calling it many times.
-	 * If all of the metadata space is used, we can commit
-	 * transaction and use space it freed.
+	 * We need to hold space in order to delete our orphan item once we've
+	 * added it, so this takes the reservation so we can release it later
+	 * when we are truly done with the orphan item.
 	 */
-	u64 num_bytes = calc_trans_metadata_size(root, 4);
+	u64 num_bytes = calc_trans_metadata_size(root, 1);
 	return block_rsv_migrate_bytes(src_rsv, dst_rsv, num_bytes);
 }
 
 void btrfs_orphan_release_metadata(struct inode *inode)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	u64 num_bytes = calc_trans_metadata_size(root, 4);
+	u64 num_bytes = calc_trans_metadata_size(root, 1);
 	btrfs_block_rsv_release(root, root->orphan_block_rsv, num_bytes);
 }
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3217919..1aa8cc0 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6591,6 +6591,7 @@ out:
 static int btrfs_truncate(struct inode *inode)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_block_rsv *rsv;
 	int ret;
 	int err = 0;
 	struct btrfs_trans_handle *trans;
@@ -6604,28 +6605,83 @@ static int btrfs_truncate(struct inode *inode)
 	btrfs_wait_ordered_range(inode, inode->i_size & (~mask), (u64)-1);
 	btrfs_ordered_update_i_size(inode, inode->i_size, NULL);
 
-	trans = btrfs_start_transaction(root, 5);
-	if (IS_ERR(trans))
-		return PTR_ERR(trans);
+	/*
+	 * Yes ladies and gentelment, this is indeed ugly.  The fact is we have
+	 * 3 things going on here
+	 *
+	 * 1) We need to reserve space for our orphan item and the space to
+	 * delete our orphan item.  Lord knows we don't want to have a dangling
+	 * orphan item because we didn't reserve space to remove it.
+	 *
+	 * 2) We need to reserve space to update our inode.
+	 *
+	 * 3) We need to have something to cache all the space that is going to
+	 * be free'd up by the truncate operation, but also have some slack
+	 * space reserved in case it uses space during the truncate (thank you
+	 * very much snapshotting).
+	 *
+	 * And we need these to all be seperate.  The fact is we can use alot of
+	 * space doing the truncate, and we have no earthly idea how much space
+	 * we will use, so we need the truncate reservation to be seperate so it
+	 * doesn't end up using space reserved for updating the inode or
+	 * removing the orphan item.  We also need to be able to stop the
+	 * transaction and start a new one, which means we need to be able to
+	 * update the inode several times, and we have no idea of knowing how
+	 * many times that will be, so we can't just reserve 1 item for the
+	 * entirety of the opration, so that has to be done seperately as well.
+	 * Then there is the orphan item, which does indeed need to be held on
+	 * to for the whole operation, and we need nobody to touch this reserved
+	 * space except the orphan code.
+	 *
+	 * So that leaves us with
+	 *
+	 * 1) root->orphan_block_rsv - for the orphan deletion.
+	 * 2) rsv - for the truncate reservation, which we will steal from the
+	 * transaction reservation.
+	 * 3) fs_info->trans_block_rsv - this will have 1 items worth left for
+	 * updating the inode.
+	 */
+	rsv = btrfs_alloc_block_rsv(root);
+	if (!rsv)
+		return -ENOMEM;
+	btrfs_add_durable_block_rsv(root->fs_info, rsv);
+
+	trans = btrfs_start_transaction(root, 4);
+	if (IS_ERR(trans)) {
+		err = PTR_ERR(trans);
+		goto out;
+	}
 
 	btrfs_set_trans_block_group(trans, inode);
 
+	/*
+	 * Reserve space for the truncate process.  Truncate should be adding
+	 * space, but if there are snapshots it may end up using space.
+	 */
+	ret = btrfs_truncate_reserve_metadata(trans, root, rsv);
+	BUG_ON(ret);
+
 	ret = btrfs_orphan_add(trans, inode);
 	if (ret) {
 		btrfs_end_transaction(trans, root);
-		return ret;
+		goto out;
 	}
 
 	nr = trans->blocks_used;
 	btrfs_end_transaction(trans, root);
 	btrfs_btree_balance_dirty(root, nr);
 
-	/* Now start a transaction for the truncate */
-	trans = btrfs_start_transaction(root, 0);
-	if (IS_ERR(trans))
-		return PTR_ERR(trans);
+	/*
+	 * Ok so we've already migrated our bytes over for the truncate, so here
+	 * just reserve the one slot we need for updating the inode.
+	 */
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		err = PTR_ERR(trans);
+		goto out;
+	}
 	btrfs_set_trans_block_group(trans, inode);
-	trans->block_rsv = root->orphan_block_rsv;
+	trans->block_rsv = rsv;
 
 	/*
 	 * setattr is responsible for setting the ordered_data_close flag,
@@ -6649,24 +6705,18 @@ static int btrfs_truncate(struct inode *inode)
 
 	while (1) {
 		if (!trans) {
-			trans = btrfs_start_transaction(root, 0);
-			if (IS_ERR(trans))
-				return PTR_ERR(trans);
-			btrfs_set_trans_block_group(trans, inode);
-			trans->block_rsv = root->orphan_block_rsv;
-		}
+			trans = btrfs_start_transaction(root, 3);
+			if (IS_ERR(trans)) {
+				err = PTR_ERR(trans);
+				goto out;
+			}
 
-		ret = btrfs_block_rsv_check(trans, root,
-					    root->orphan_block_rsv, 0, 5);
-		if (ret == -EAGAIN) {
-			ret = btrfs_commit_transaction(trans, root);
-			if (ret)
-				return ret;
-			trans = NULL;
-			continue;
-		} else if (ret) {
-			err = ret;
-			break;
+			ret = btrfs_truncate_reserve_metadata(trans, root,
+							      rsv);
+			BUG_ON(ret);
+
+			btrfs_set_trans_block_group(trans, inode);
+			trans->block_rsv = rsv;
 		}
 
 		ret = btrfs_truncate_inode_items(trans, root, inode,
@@ -6677,6 +6727,7 @@ static int btrfs_truncate(struct inode *inode)
 			break;
 		}
 
+		trans->block_rsv = &root->fs_info->trans_block_rsv;
 		ret = btrfs_update_inode(trans, root, inode);
 		if (ret) {
 			err = ret;
@@ -6690,6 +6741,7 @@ static int btrfs_truncate(struct inode *inode)
 	}
 
 	if (ret == 0 && inode->i_nlink > 0) {
+		trans->block_rsv = root->orphan_block_rsv;
 		ret = btrfs_orphan_del(trans, inode);
 		if (ret)
 			err = ret;
@@ -6701,15 +6753,20 @@ static int btrfs_truncate(struct inode *inode)
 		ret = btrfs_orphan_del(NULL, inode);
 	}
 
+	trans->block_rsv = &root->fs_info->trans_block_rsv;
 	ret = btrfs_update_inode(trans, root, inode);
 	if (ret && !err)
 		err = ret;
 
 	nr = trans->blocks_used;
 	ret = btrfs_end_transaction_throttle(trans, root);
+	btrfs_btree_balance_dirty(root, nr);
+
+out:
+	btrfs_free_block_rsv(root, rsv);
+
 	if (ret && !err)
 		err = ret;
-	btrfs_btree_balance_dirty(root, nr);
 
 	return err;
 }
-- 
1.7.2.3

