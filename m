From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix our reservations for updating an inode when completing io
Date: Tue,  8 Nov 2011 15:32:25 -0500
Message-ID: <1320784345-6128-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

People have been reporting ENOSPC crashes in finish_ordered_io.  This is because
we try to steal from the delalloc block rsv to satisfy a reservation to update
the inode.  There are a few problems with this

1) We don't explicitly save space for updating the inode when doing delalloc.
This is kind of a problem, and we've gotten away with this because usually an
inode is updated by the mtime update and then when we write out the data it's
already been touched so we don't use any space trying to update the inode.  And
then when the delayed inode stuff came along it just stole from the global
reserve, which wasn't right either.  So to fix this we reserve space if this is
the first delalloc extent we're writing, and release it if we need to update due
to an i_size change or we don't have anymore delalloc extents.

2) We don't usually use space when updating the inode in finish_ordered_io.
This is because we either updated the same leaf when inserting our extent for
the io we just completed, or we had updated the leaf when we updated the inode
when we changed the mtime.  So in the delayed inode stuff, just return 0 if
we've updated the inode since the last transaction was committed.

With this patch I ran xfstests 13 in a loop for a couple of hours and didn't see
any problems.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/btrfs_inode.h   |    4 +--
 fs/btrfs/delayed-inode.c |   74 ++++++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/extent-tree.c   |   22 ++++++++++++--
 fs/btrfs/inode.c         |    1 +
 4 files changed, 92 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 5a5d325..634608d 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -147,14 +147,12 @@ struct btrfs_inode {
 	 * the btrfs file release call will add this inode to the
 	 * ordered operations list so that we make sure to flush out any
 	 * new data the application may have written before commit.
-	 *
-	 * yes, its silly to have a single bitflag, but we might grow more
-	 * of these.
 	 */
 	unsigned ordered_data_close:1;
 	unsigned orphan_meta_reserved:1;
 	unsigned dummy_inode:1;
 	unsigned in_defrag:1;
+	unsigned delalloc_meta_reserved:1;
 
 	/*
 	 * always compress this one file
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index bbe8496..956f5a6 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -617,12 +617,23 @@ static void btrfs_delayed_item_release_metadata(struct btrfs_root *root,
 static int btrfs_delayed_inode_reserve_metadata(
 					struct btrfs_trans_handle *trans,
 					struct btrfs_root *root,
+					struct inode *inode,
 					struct btrfs_delayed_node *node)
 {
 	struct btrfs_block_rsv *src_rsv;
 	struct btrfs_block_rsv *dst_rsv;
 	u64 num_bytes;
 	int ret;
+	int release = false;
+
+	/*
+	 * If last trans is greater than the last trans committed then we know
+	 * we've already modified this inode in this transaction and so we won't
+	 * use any space on any subsequent updates to this inode in this
+	 * transaction.
+	 */
+	if (BTRFS_I(inode)->last_trans > root->fs_info->last_trans_committed)
+		return 0;
 
 	src_rsv = trans->block_rsv;
 	dst_rsv = &root->fs_info->delayed_block_rsv;
@@ -652,11 +663,67 @@ static int btrfs_delayed_inode_reserve_metadata(
 		if (!ret)
 			node->bytes_reserved = num_bytes;
 		return ret;
+	} else if (src_rsv == &root->fs_info->delalloc_block_rsv) {
+		spin_lock(&BTRFS_I(inode)->lock);
+		if (BTRFS_I(inode)->delalloc_meta_reserved) {
+			BTRFS_I(inode)->delalloc_meta_reserved = 0;
+			spin_unlock(&BTRFS_I(inode)->lock);
+			release = true;
+			goto migrate;
+		}
+		spin_unlock(&BTRFS_I(inode)->lock);
+
+		/* Ok we didn't have space pre-reserved.  This shouldn't happen
+		 * too often but it can happen if we do delalloc to an existing
+		 * inode which gets dirtied because of the time update, and then
+		 * isn't touched again until after the transaction commits and
+		 * then we try to write out the data.  First try to be nice and
+		 * reserve something strictly for us.  If not be a pain and try
+		 * to steal from the delalloc block rsv.
+		 */
+		ret = btrfs_block_rsv_add_noflush(root, dst_rsv, num_bytes);
+		if (!ret)
+			goto out;
+
+		ret = btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes);
+		if (!ret)
+			goto out;
+
+		/*
+		 * Ok this is a problem, let's just steal from the global rsv
+		 * since this really shouldn't happen that often.
+		 */
+		WARN_ON(1);
+		ret = btrfs_block_rsv_migrate(&root->fs_info->global_block_rsv,
+					      dst_rsv, num_bytes);
+		goto out;
 	}
 
+migrate:
 	ret = btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes);
-	if (!ret)
-		node->bytes_reserved = num_bytes;
+	if (unlikely(ret)) {
+		/* This shouldn't happen */
+		BUG_ON(release);
+		return ret;
+	}
+
+out:
+	/*
+	 * Migrate only takes a reservation, it doesn't touch the size of the
+	 * block_rsv.  This is to simplify people who don't normally have things
+	 * migrated from their block rsv.  If they go to release their
+	 * reservation, that will decrease the size as well, so if migrate
+	 * reduced size we'd end up with a negative size.  But for the
+	 * delalloc_meta_reserved stuff we will only know to drop 1 reservation,
+	 * but we could in fact do this reserve/migrate dance several times
+	 * between the time we did the original reservation and we'd clean it
+	 * up.  So to take care of this, release the space for the meta
+	 * reservation here.  I think it may be time for a documentation page on
+	 * how block rsvs. work.
+	 */
+	if (release)
+		btrfs_block_rsv_release(root, src_rsv, num_bytes);
+	node->bytes_reserved = num_bytes;
 
 	return ret;
 }
@@ -1708,7 +1775,8 @@ int btrfs_delayed_update_inode(struct btrfs_trans_handle *trans,
 		goto release_node;
 	}
 
-	ret = btrfs_delayed_inode_reserve_metadata(trans, root, delayed_node);
+	ret = btrfs_delayed_inode_reserve_metadata(trans, root, inode,
+						   delayed_node);
 	if (ret)
 		goto release_node;
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 18ea90c..0b044e5 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4063,23 +4063,30 @@ int btrfs_snap_reserve_metadata(struct btrfs_trans_handle *trans,
  */
 static unsigned drop_outstanding_extent(struct inode *inode)
 {
+	unsigned drop_inode_space = 0;
 	unsigned dropped_extents = 0;
 
 	BUG_ON(!BTRFS_I(inode)->outstanding_extents);
 	BTRFS_I(inode)->outstanding_extents--;
 
+	if (BTRFS_I(inode)->outstanding_extents == 0 &&
+	    BTRFS_I(inode)->delalloc_meta_reserved) {
+		drop_inode_space = 1;
+		BTRFS_I(inode)->delalloc_meta_reserved = 0;
+	}
+
 	/*
 	 * If we have more or the same amount of outsanding extents than we have
 	 * reserved then we need to leave the reserved extents count alone.
 	 */
 	if (BTRFS_I(inode)->outstanding_extents >=
 	    BTRFS_I(inode)->reserved_extents)
-		return 0;
+		return drop_inode_space;
 
 	dropped_extents = BTRFS_I(inode)->reserved_extents -
 		BTRFS_I(inode)->outstanding_extents;
 	BTRFS_I(inode)->reserved_extents -= dropped_extents;
-	return dropped_extents;
+	return dropped_extents + drop_inode_space;
 }
 
 /**
@@ -4165,9 +4172,18 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 		nr_extents = BTRFS_I(inode)->outstanding_extents -
 			BTRFS_I(inode)->reserved_extents;
 		BTRFS_I(inode)->reserved_extents += nr_extents;
+	}
 
-		to_reserve = btrfs_calc_trans_metadata_size(root, nr_extents);
+	/*
+	 * Add an item to reserve for updating the inode when we complete the
+	 * delalloc io.
+	 */
+	if (!BTRFS_I(inode)->delalloc_meta_reserved) {
+		nr_extents++;
+		BTRFS_I(inode)->delalloc_meta_reserved = 1;
 	}
+
+	to_reserve = btrfs_calc_trans_metadata_size(root, nr_extents);
 	to_reserve += calc_csum_metadata_size(inode, num_bytes, 1);
 	spin_unlock(&BTRFS_I(inode)->lock);
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9d0eaa5..faf8a60 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6605,6 +6605,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	ei->orphan_meta_reserved = 0;
 	ei->dummy_inode = 0;
 	ei->in_defrag = 0;
+	ei->delalloc_meta_reserved = 0;
 	ei->force_compress = BTRFS_COMPRESS_NONE;
 
 	ei->delayed_node = NULL;
-- 
1.7.5.2

