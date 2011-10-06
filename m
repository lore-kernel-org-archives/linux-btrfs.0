From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH v0 16/18] btrfs: hooks to reserve qgroup space
Date: Thu,  6 Oct 2011 17:54:26 +0200
Message-ID: <bd8344937ae679fb7462cbe02ce4ebfd99caf079.1317915011.git.sensille@gmx.net>
References: <cover.1317915010.git.sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1317915010.git.sensille@gmx.net>
In-Reply-To: <cover.1317915010.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

Like block reserves, reserve a small piece of space on each
transaction start and for delalloc. These are the hooks that
can actually return EDQUOT to the user.
The amount of space reserved is tracked in the transaction
handle.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/extent-tree.c |   13 +++++++++++++
 fs/btrfs/transaction.c |   16 ++++++++++++++++
 fs/btrfs/transaction.h |    1 +
 3 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 7fb9650..a2400c4 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4093,6 +4093,14 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	spin_unlock(&BTRFS_I(inode)->lock);
 
 	to_reserve += calc_csum_metadata_size(inode, num_bytes);
+
+	if (root->fs_info->quota_enabled) {
+		ret = btrfs_qgroup_reserve(root, num_bytes +
+					   nr_extents * root->leafsize);
+		if (ret)
+			return ret;
+	}
+
 	ret = reserve_metadata_bytes(NULL, root, block_rsv, to_reserve, 1);
 	if (ret) {
 		unsigned dropped;
@@ -4123,6 +4131,11 @@ void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes)
 	if (dropped > 0)
 		to_free += btrfs_calc_trans_metadata_size(root, dropped);
 
+	if (root->fs_info->quota_enabled) {
+		btrfs_qgroup_free(root, num_bytes +
+					dropped * root->leafsize);
+	}
+
 	btrfs_block_rsv_release(root, &root->fs_info->delalloc_block_rsv,
 				to_free);
 }
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 1ae856e..a8b7668 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -260,6 +260,7 @@ static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
 	struct btrfs_transaction *cur_trans;
 	u64 num_bytes = 0;
 	int ret;
+	u64 qgroup_reserved = 0;
 
 	if (root->fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR)
 		return ERR_PTR(-EROFS);
@@ -278,6 +279,14 @@ static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
 	 * the appropriate flushing if need be.
 	 */
 	if (num_items > 0 && root != root->fs_info->chunk_root) {
+		if (root->fs_info->quota_enabled &&
+		    is_fstree(root->root_key.objectid)) {
+			qgroup_reserved = num_items * root->leafsize;
+			ret = btrfs_qgroup_reserve(root, qgroup_reserved);
+			if (ret)
+				return ERR_PTR(ret);
+		}
+
 		num_bytes = btrfs_calc_trans_metadata_size(root, num_items);
 		ret = btrfs_block_rsv_add(NULL, root,
 					  &root->fs_info->trans_block_rsv,
@@ -315,6 +324,7 @@ again:
 	h->use_count = 1;
 	h->block_rsv = NULL;
 	h->orig_rsv = NULL;
+	h->qgroup_reserved = qgroup_reserved;
 
 	smp_mb();
 	if (cur_trans->blocked && may_wait_transaction(root, type)) {
@@ -463,6 +473,12 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	 * end_transaction. Subvolume quota depends on this.
 	 */
 	WARN_ON(trans->root != root);
+
+	if (trans->qgroup_reserved) {
+		btrfs_qgroup_free(root, trans->qgroup_reserved);
+		trans->qgroup_reserved = 0;
+	}
+
 	while (count < 4) {
 		unsigned long cur = trans->delayed_ref_updates;
 		trans->delayed_ref_updates = 0;
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index b120126..5f5d216 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -48,6 +48,7 @@ struct btrfs_transaction {
 struct btrfs_trans_handle {
 	u64 transid;
 	u64 bytes_reserved;
+	u64 qgroup_reserved;
 	unsigned long use_count;
 	unsigned long blocks_reserved;
 	unsigned long blocks_used;
-- 
1.7.3.4

