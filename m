From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: release metadata from global reserve if we have to fallback for unlink
Date: Tue,  1 Nov 2011 13:52:16 -0400
Message-ID: <1320169936-5074-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I fixed a problem where we weren't reserving space for an orphan item when we
had to fallback to using the global reserve for an unlink, but I introduced
another problem.  I was migrating the bytes from the transaction reserve to the
global reserve and then releasing from the global reserve in
btrfs_end_transaction().  The problem with this is that a migrate will jack up
the size for the destination, but leave the size alone for the source, with the
idea that you can do a release normally on the source and it all washes out, and
then you can do a release again on the destination and it works out right.  My
way was skipping the release on the trans_block_rsv which still had the jacked
up size from our original reservation.  So instead release manually from the
global reserve if this transaction was using it, and then set the
trans->block_rsv back to the trans_block_rsv so that btrfs_end_transaction
cleans everything up properly.  With this patch xfstest 83 doesn't emit warnings
about leaking space.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f12747c..3dd2d5d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2900,7 +2900,7 @@ out:
 	if (!err)
 		err = btrfs_block_rsv_migrate(trans->block_rsv,
 				&root->fs_info->global_block_rsv,
-				btrfs_calc_trans_metadata_size(root, 1));
+				trans->bytes_reserved);
 
 	if (err) {
 		btrfs_end_transaction(trans, root);
@@ -2916,6 +2916,9 @@ static void __unlink_end_trans(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root)
 {
 	if (trans->block_rsv == &root->fs_info->global_block_rsv) {
+		btrfs_block_rsv_release(root, trans->block_rsv,
+					trans->bytes_reserved);
+		trans->block_rsv = &root->fs_info->trans_block_rsv;
 		BUG_ON(!root->fs_info->enospc_unlink);
 		root->fs_info->enospc_unlink = 0;
 	}
-- 
1.7.5.2

