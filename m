From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix delayed insertion reservations
Date: Fri,  4 Nov 2011 14:52:18 -0400
Message-ID: <1320432738-4065-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We all keep getting those stupid warnings from use_block_rsv when running
stress.sh, and it's because the delayed insertion stuff is being stupid.  It's
not the delayed insertion stuffs fault, it's all just stupid.  When marking an
inode dirty for oh say updating the time on it, we just do a
btrfs_join_transaction, which doesn't reserve any space.  This is stupid because
we're going to have to have space reserve to make this change, but we do it
because it's fast because chances are we're going to call it over and over again
and it doesn't matter.  Well thanks to the delayed insertion stuff this is
mostly the case, so we do actually need to make this reservation.  So if
trans->bytes_reserved is 0 then try to do a normal reservation.  If not return
ENOSPC which will make the btrfs_dirty_inode start a proper transaction which
will let it do the whole ENOSPC dance and reserve enough space for the delayed
insertion to steal the reservation from the transaction.

The other stupid thing we do is not reserve space for the inode when writing to
the thing.  Usually this is ok since we have to update the time so we'd have
already done all this work before we get to the endio stuff, so it doesn't
matter.  But this is stupid because we could write the data after the
transaction commits where we changed the mtime of the inode so we have to cow
all the way down to the inode anyway.  This used to be masked by the delalloc
reservation stuff, but because we delay the update it doesn't get masked in this
case.  So again the delayed insertion stuff bites us in the ass.  So if our
trans->block_rsv is delalloc, just steal the reservation from the delalloc
reserve.  Hopefully this won't bite us in the ass, but I've said that before.

With this patch stress.sh no longer spits out those stupid warnings (famous last
words).  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/delayed-inode.c |   36 ++++++++++++++++++++++++++++--------
 1 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index fc4026a..ef6efe7 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -624,13 +624,36 @@ static int btrfs_delayed_inode_reserve_metadata(
 	u64 num_bytes;
 	int ret;
 
-	if (!trans->bytes_reserved)
-		return 0;
-
 	src_rsv = trans->block_rsv;
 	dst_rsv = &root->fs_info->delayed_block_rsv;
 
 	num_bytes = btrfs_calc_trans_metadata_size(root, 1);
+
+	/*
+	 * btrfs_dirty_inode will update the inode under btrfs_join_transaction
+	 * which doesn't reserve space for speed.  This is a problem since we
+	 * still need to reserve space for this update, so try to reserve the
+	 * space.
+	 *
+	 * Now if src_rsv == delalloc_block_rsv we'll let it just steal since
+	 * we're accounted for.
+	 */
+	if (!trans->bytes_reserved &&
+	    src_rsv != &root->fs_info->delalloc_block_rsv) {
+		ret = btrfs_block_rsv_add(root, dst_rsv, num_bytes);
+		/*
+		 * Since we're under a transaction reserve_metadata_bytes could
+		 * try to commit the transaction which will make it return
+		 * EAGAIN to make us stop the transaction we have, so return
+		 * ENOSPC instead so that btrfs_dirty_inode knows what to do.
+		 */
+		if (ret == -EAGAIN)
+			ret = -ENOSPC;
+		if (!ret)
+			node->bytes_reserved = num_bytes;
+		return ret;
+	}
+
 	ret = btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes);
 	if (!ret)
 		node->bytes_reserved = num_bytes;
@@ -1686,11 +1709,8 @@ int btrfs_delayed_update_inode(struct btrfs_trans_handle *trans,
 	}
 
 	ret = btrfs_delayed_inode_reserve_metadata(trans, root, delayed_node);
-	/*
-	 * we must reserve enough space when we start a new transaction,
-	 * so reserving metadata failure is impossible
-	 */
-	BUG_ON(ret);
+	if (ret)
+		goto release_node;
 
 	fill_stack_inode_item(trans, &delayed_node->inode_item, inode);
 	delayed_node->inode_dirty = 1;
-- 
1.7.5.2

