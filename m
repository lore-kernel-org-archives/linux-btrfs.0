From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: don't use delalloc block rsv for free space inodes
Date: Mon, 29 Aug 2011 11:19:07 -0400
Message-ID: <1314631147-13434-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In tracking down this "not enough space" warning with checksums, it seems that
we were running out of space partly because we do not reserve space for our free
space inodes.  Since this is technically metadata anyway go ahead and use the
global_block_rsv for our free space inodes.  We shouldn't be modifying too much
other metadata since this will be a preallocated extent and that was already
accounted for earlier.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |   32 ++++++++++++--------------------
 1 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0ee0677..bb65b13 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1717,7 +1717,6 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 	struct extent_state *cached_state = NULL;
 	int compress_type = 0;
 	int ret;
-	bool nolock;
 
 	ret = btrfs_dec_test_ordered_pending(inode, &ordered_extent, start,
 					     end - start + 1);
@@ -1725,18 +1724,20 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 		return 0;
 	BUG_ON(!ordered_extent);
 
-	nolock = btrfs_is_free_space_inode(root, inode);
+	if (btrfs_is_free_space_inode(root, inode)) {
+		trans = btrfs_join_transaction_nolock(root);
+		BUG_ON(IS_ERR(trans));
+		trans->block_rsv = &root->fs_info->global_block_rsv;
+	} else{
+		trans = btrfs_join_transaction(root);
+		BUG_ON(IS_ERR(trans));
+		trans->block_rsv = &root->fs_info->delalloc_block_rsv;
+	}
 
 	if (test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags)) {
 		BUG_ON(!list_empty(&ordered_extent->list));
 		ret = btrfs_ordered_update_i_size(inode, 0, ordered_extent);
 		if (!ret) {
-			if (nolock)
-				trans = btrfs_join_transaction_nolock(root);
-			else
-				trans = btrfs_join_transaction(root);
-			BUG_ON(IS_ERR(trans));
-			trans->block_rsv = &root->fs_info->delalloc_block_rsv;
 			ret = btrfs_update_inode(trans, root, inode);
 			BUG_ON(ret);
 		}
@@ -1747,13 +1748,6 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 			 ordered_extent->file_offset + ordered_extent->len - 1,
 			 0, &cached_state, GFP_NOFS);
 
-	if (nolock)
-		trans = btrfs_join_transaction_nolock(root);
-	else
-		trans = btrfs_join_transaction(root);
-	BUG_ON(IS_ERR(trans));
-	trans->block_rsv = &root->fs_info->delalloc_block_rsv;
-
 	if (test_bit(BTRFS_ORDERED_COMPRESSED, &ordered_extent->flags))
 		compress_type = ordered_extent->compress_type;
 	if (test_bit(BTRFS_ORDERED_PREALLOC, &ordered_extent->flags)) {
@@ -1792,13 +1786,11 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 	}
 	ret = 0;
 out:
-	if (nolock) {
-		if (trans)
-			btrfs_end_transaction_nolock(trans, root);
+	if (btrfs_is_free_space_inode(root, inode)) {
+		btrfs_end_transaction_nolock(trans, root);
 	} else {
 		btrfs_delalloc_release_metadata(inode, ordered_extent->len);
-		if (trans)
-			btrfs_end_transaction(trans, root);
+		btrfs_end_transaction(trans, root);
 	}
 
 	/* once for us */
-- 
1.7.5.2

