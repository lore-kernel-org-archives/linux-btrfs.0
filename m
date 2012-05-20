Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mort.rzone.de ([81.169.144.234]:33917 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756331Ab2ETQGj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 May 2012 12:06:39 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 22/24] Btrfs: hooks to reserve qgroup space
Date: Sun, 20 May 2012 18:06:33 +0200
Message-Id: <4c8c388161710ab0f502f942c18cf276bbca7ac3.1337525292.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
References: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
References: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Arne Jansen <sensille@gmx.net>

Like block reserves, reserve a small piece of space on each
transaction start and for delalloc. These are the hooks that
can actually return EDQUOT to the user.
The amount of space reserved is tracked in the transaction
handle.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/extent-tree.c |   12 ++++++++++++
 fs/btrfs/transaction.c |   16 ++++++++++++++++
 fs/btrfs/transaction.h |    1 +
 3 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a7f980b..855a3ff 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4524,6 +4524,13 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	csum_bytes = BTRFS_I(inode)->csum_bytes;
 	spin_unlock(&BTRFS_I(inode)->lock);
 
+	if (root->fs_info->quota_enabled) {
+		ret = btrfs_qgroup_reserve(root, num_bytes +
+					   nr_extents * root->leafsize);
+		if (ret)
+			return ret;
+	}
+
 	ret = reserve_metadata_bytes(root, block_rsv, to_reserve, flush);
 	if (ret) {
 		u64 to_free = 0;
@@ -4601,6 +4608,11 @@ void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes)
 
 	trace_btrfs_space_reservation(root->fs_info, "delalloc",
 				      btrfs_ino(inode), to_free, 0);
+	if (root->fs_info->quota_enabled) {
+		btrfs_qgroup_free(root, num_bytes +
+					dropped * root->leafsize);
+	}
+
 	btrfs_block_rsv_release(root, &root->fs_info->delalloc_block_rsv,
 				to_free);
 }
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 2a5e75c..69b52bd 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -285,6 +285,7 @@ static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
 	struct btrfs_transaction *cur_trans;
 	u64 num_bytes = 0;
 	int ret;
+	u64 qgroup_reserved = 0;
 
 	if (root->fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR)
 		return ERR_PTR(-EROFS);
@@ -303,6 +304,14 @@ static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
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
 		ret = btrfs_block_rsv_add(root,
 					  &root->fs_info->trans_block_rsv,
@@ -341,6 +350,7 @@ again:
 	h->block_rsv = NULL;
 	h->orig_rsv = NULL;
 	h->aborted = 0;
+	h->qgroup_reserved = qgroup_reserved;
 
 	smp_mb();
 	if (cur_trans->blocked && may_wait_transaction(root, type)) {
@@ -507,6 +517,12 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	 * end_transaction. Subvolume quota depends on this.
 	 */
 	WARN_ON(trans->root != root);
+
+	if (trans->qgroup_reserved) {
+		btrfs_qgroup_free(root, trans->qgroup_reserved);
+		trans->qgroup_reserved = 0;
+	}
+
 	while (count < 2) {
 		unsigned long cur = trans->delayed_ref_updates;
 		trans->delayed_ref_updates = 0;
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 0107294..addfa2d 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -49,6 +49,7 @@ struct btrfs_transaction {
 struct btrfs_trans_handle {
 	u64 transid;
 	u64 bytes_reserved;
+	u64 qgroup_reserved;
 	unsigned long use_count;
 	unsigned long blocks_reserved;
 	unsigned long blocks_used;
-- 
1.7.3.4

