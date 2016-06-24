Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37864 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbcFXWPb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 18:15:31 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 2990CADCA
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 22:15:27 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 13/31] btrfs: add btrfs_trans_handle->fs_info pointer
Date: Fri, 24 Jun 2016 18:15:06 -0400
Message-Id: <1466806524-27508-14-git-send-email-jeffm@suse.com>
In-Reply-To: <1466806524-27508-1-git-send-email-jeffm@suse.com>
References: <1466806524-27508-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

btrfs_trans_handle->root is documented as for use for confirming
that the root passed in to start the transaction is the same as the
one ending it.  It's used in several places when an fs_info pointer
is needed, so let's just add an fs_info pointer directly.  Eventually,
the root pointer can be removed.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent-tree.c | 6 +++---
 fs/btrfs/qgroup.c      | 2 +-
 fs/btrfs/transaction.c | 1 +
 fs/btrfs/transaction.h | 1 +
 4 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e4af375..2081ed4 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4562,7 +4562,7 @@ out:
 	 */
 	if (trans->can_flush_pending_bgs &&
 	    trans->chunk_bytes_reserved >= (u64)SZ_2M) {
-		btrfs_create_pending_block_groups(trans, trans->root);
+		btrfs_create_pending_block_groups(trans, extent_root);
 		btrfs_trans_release_chunk_metadata(trans);
 	}
 	return ret;
@@ -5527,7 +5527,7 @@ void btrfs_trans_release_metadata(struct btrfs_trans_handle *trans,
  */
 void btrfs_trans_release_chunk_metadata(struct btrfs_trans_handle *trans)
 {
-	struct btrfs_fs_info *fs_info = trans->root->fs_info;
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 
 	if (!trans->chunk_bytes_reserved)
 		return;
@@ -8318,7 +8318,7 @@ static int record_one_subtree_extent(struct btrfs_trans_handle *trans,
 
 	delayed_refs = &trans->transaction->delayed_refs;
 	spin_lock(&delayed_refs->lock);
-	if (btrfs_qgroup_insert_dirty_extent(trans->root->fs_info,
+	if (btrfs_qgroup_insert_dirty_extent(trans->fs_info,
 					     delayed_refs, qrecord))
 		kfree(qrecord);
 	spin_unlock(&delayed_refs->lock);
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 3a83631..93ee1c1 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2196,7 +2196,7 @@ void assert_qgroups_uptodate(struct btrfs_trans_handle *trans)
 {
 	if (list_empty(&trans->qgroup_ref_list) && !trans->delayed_ref_elem.seq)
 		return;
-	btrfs_err(trans->root->fs_info,
+	btrfs_err(trans->fs_info,
 		"qgroups not uptodate in trans handle %p:  list is%s empty, "
 		"seq is %#x.%x",
 		trans, list_empty(&trans->qgroup_ref_list) ? "" : " not",
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index db26eff..db0eb1f 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -561,6 +561,7 @@ again:
 	h->transaction = cur_trans;
 	h->root = root;
 	h->use_count = 1;
+	h->fs_info = root->fs_info;
 
 	h->type = type;
 	h->can_flush_pending_bgs = true;
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index c5abee4..efb1226 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -128,6 +128,7 @@ struct btrfs_trans_handle {
 	 * Subvolume quota depends on this
 	 */
 	struct btrfs_root *root;
+	struct btrfs_fs_info *fs_info;
 	struct seq_list delayed_ref_elem;
 	struct list_head qgroup_ref_list;
 	struct list_head new_bgs;
-- 
2.7.1

