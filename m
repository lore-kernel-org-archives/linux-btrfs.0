From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 1/2] Btrfs: do transaction space reservation before joining the transaction
Date: Tue,  7 Jun 2011 16:44:08 -0400
Message-ID: <1307479449-14765-2-git-send-email-josef@redhat.com>
References: <1307479449-14765-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1307479449-14765-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

We have to do weird things when handling enospc in the transaction joining code.
Because we've already joined the transaction we cannot commit the transaction
within the reservation code since it will deadlock, so we have to return EAGAIN
and then make sure we don't retry too many times.  Instead of doing this, just
do the reservation the normal way before we join the transaction, that way we
can do whatever we want to try and reclaim space, and then if it fails we know
for sure we are out of space and we can return ENOSPC.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.h       |    3 ---
 fs/btrfs/extent-tree.c |   20 --------------------
 fs/btrfs/transaction.c |   36 +++++++++++++++++-------------------
 3 files changed, 17 insertions(+), 42 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0c62c6c..6034a23 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2205,9 +2205,6 @@ void btrfs_set_inode_space_info(struct btrfs_root *root, struct inode *ionde);
 void btrfs_clear_space_info_full(struct btrfs_fs_info *info);
 int btrfs_check_data_free_space(struct inode *inode, u64 bytes);
 void btrfs_free_reserved_data_space(struct inode *inode, u64 bytes);
-int btrfs_trans_reserve_metadata(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root,
-				int num_items);
 void btrfs_trans_release_metadata(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root);
 int btrfs_orphan_reserve_metadata(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index aa2b592a..b1c3ff7 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3878,26 +3878,6 @@ int btrfs_truncate_reserve_metadata(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-int btrfs_trans_reserve_metadata(struct btrfs_trans_handle *trans,
-				 struct btrfs_root *root,
-				 int num_items)
-{
-	u64 num_bytes;
-	int ret;
-
-	if (num_items == 0 || root->fs_info->chunk_root == root)
-		return 0;
-
-	num_bytes = btrfs_calc_trans_metadata_size(root, num_items);
-	ret = btrfs_block_rsv_add(trans, root, &root->fs_info->trans_block_rsv,
-				  num_bytes);
-	if (!ret) {
-		trans->bytes_reserved += num_bytes;
-		trans->block_rsv = &root->fs_info->trans_block_rsv;
-	}
-	return ret;
-}
-
 void btrfs_trans_release_metadata(struct btrfs_trans_handle *trans,
 				  struct btrfs_root *root)
 {
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index dd71966..c277448 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -203,7 +203,7 @@ static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
 {
 	struct btrfs_trans_handle *h;
 	struct btrfs_transaction *cur_trans;
-	int retries = 0;
+	u64 num_bytes = 0;
 	int ret;
 
 	if (root->fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR)
@@ -217,6 +217,19 @@ static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
 		h->block_rsv = NULL;
 		goto got_it;
 	}
+
+	/*
+	 * Do the reservation before we join the transaction so we can do all
+	 * the appropriate flushing if need be.
+	 */
+	if (num_items > 0 && root != root->fs_info->chunk_root) {
+		num_bytes = btrfs_calc_trans_metadata_size(root, num_items);
+		ret = btrfs_block_rsv_add(NULL, root,
+					  &root->fs_info->trans_block_rsv,
+					  num_bytes);
+		if (ret)
+			return ERR_PTR(ret);
+	}
 again:
 	h = kmem_cache_alloc(btrfs_trans_handle_cachep, GFP_NOFS);
 	if (!h)
@@ -253,24 +266,9 @@ again:
 		goto again;
 	}
 
-	if (num_items > 0) {
-		ret = btrfs_trans_reserve_metadata(h, root, num_items);
-		if (ret == -EAGAIN && !retries) {
-			retries++;
-			btrfs_commit_transaction(h, root);
-			goto again;
-		} else if (ret == -EAGAIN) {
-			/*
-			 * We have already retried and got EAGAIN, so really we
-			 * don't have space, so set ret to -ENOSPC.
-			 */
-			ret = -ENOSPC;
-		}
-
-		if (ret < 0) {
-			btrfs_end_transaction(h, root);
-			return ERR_PTR(ret);
-		}
+	if (num_bytes) {
+		h->block_rsv = &root->fs_info->trans_block_rsv;
+		h->bytes_reserved = num_bytes;
 	}
 
 got_it:
-- 
1.7.2.3

