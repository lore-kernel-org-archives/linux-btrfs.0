Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:34162 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762276Ab2FVPVZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jun 2012 11:21:25 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id NGbNrVeEzErOTE7j (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 22 Jun 2012 09:21:23 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: flush delayed inodes if we're short on space V2
Date: Fri, 22 Jun 2012 11:26:01 -0400
Message-ID: <1340378761-8705-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Those crazy gentoo guys have been complaining about ENOSPC errors on their
portage volumes.  This is because doing things like untar tends to create
lots of new files which will soak up all the reservation space in the
delayed inodes.  Usually this gets papered over by the fact that we will try
and commit the transaction, however if this happens in the wrong spot or we
choose not to commit the transaction you will be screwed.  So add the
ability to expclitly flush delayed inodes to free up space.  Please test
this out guys to make sure it works since as usual I cannot reproduce.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
V1->V2:
-got rid of an unused variable
-fixed the nr calculation to take into account how much space we want to free.
I added a printk to see how often we had to fall back on a full flush and it
didn't start happening at all until the volume was very full, so it seems to be
the best bet in this case.
 fs/btrfs/delayed-inode.c |   22 +++++++++-
 fs/btrfs/delayed-inode.h |    2 +
 fs/btrfs/extent-tree.c   |   98 +++++++++++++++++++++++++++++-----------------
 3 files changed, 83 insertions(+), 39 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 2399f40..21d91a8 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1113,8 +1113,8 @@ static int btrfs_update_delayed_inode(struct btrfs_trans_handle *trans,
  * Returns < 0 on error and returns with an aborted transaction with any
  * outstanding delayed items cleaned up.
  */
-int btrfs_run_delayed_items(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root)
+static int __btrfs_run_delayed_items(struct btrfs_trans_handle *trans,
+				     struct btrfs_root *root, int nr)
 {
 	struct btrfs_root *curr_root = root;
 	struct btrfs_delayed_root *delayed_root;
@@ -1122,6 +1122,7 @@ int btrfs_run_delayed_items(struct btrfs_trans_handle *trans,
 	struct btrfs_path *path;
 	struct btrfs_block_rsv *block_rsv;
 	int ret = 0;
+	bool count = (nr > 0);
 
 	if (trans->aborted)
 		return -EIO;
@@ -1137,7 +1138,7 @@ int btrfs_run_delayed_items(struct btrfs_trans_handle *trans,
 	delayed_root = btrfs_get_delayed_root(root);
 
 	curr_node = btrfs_first_delayed_node(delayed_root);
-	while (curr_node) {
+	while (curr_node && (!count || (count && nr--))) {
 		curr_root = curr_node->root;
 		ret = btrfs_insert_delayed_items(trans, path, curr_root,
 						 curr_node);
@@ -1149,6 +1150,7 @@ int btrfs_run_delayed_items(struct btrfs_trans_handle *trans,
 						path, curr_node);
 		if (ret) {
 			btrfs_release_delayed_node(curr_node);
+			curr_node = NULL;
 			btrfs_abort_transaction(trans, root, ret);
 			break;
 		}
@@ -1158,12 +1160,26 @@ int btrfs_run_delayed_items(struct btrfs_trans_handle *trans,
 		btrfs_release_delayed_node(prev_node);
 	}
 
+	if (curr_node)
+		btrfs_release_delayed_node(curr_node);
 	btrfs_free_path(path);
 	trans->block_rsv = block_rsv;
 
 	return ret;
 }
 
+int btrfs_run_delayed_items(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root)
+{
+	return __btrfs_run_delayed_items(trans, root, -1);
+}
+
+int btrfs_run_delayed_items_nr(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *root, int nr)
+{
+	return __btrfs_run_delayed_items(trans, root, nr);
+}
+
 static int __btrfs_commit_inode_delayed_items(struct btrfs_trans_handle *trans,
 					      struct btrfs_delayed_node *node)
 {
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index f5aa402..4f808e1 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -107,6 +107,8 @@ int btrfs_inode_delayed_dir_index_count(struct inode *inode);
 
 int btrfs_run_delayed_items(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root);
+int btrfs_run_delayed_items_nr(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *root, int nr);
 
 void btrfs_balance_delayed_items(struct btrfs_root *root);
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4b5a1e1..4053e3e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3727,6 +3727,62 @@ commit:
 	return btrfs_commit_transaction(trans, root);
 }
 
+enum flush_state {
+	FLUSH_DELALLOC		=	1,
+	FLUSH_DELALLOC_WAIT	=	2,
+	FLUSH_DELAYED_ITEMS_NR	=	3,
+	FLUSH_DELAYED_ITEMS	=	4,
+	COMMIT_TRANS		=	5,
+};
+
+static int flush_space(struct btrfs_root *root,
+		       struct btrfs_space_info *space_info, u64 num_bytes,
+		       u64 orig_bytes, int *state)
+{
+	struct btrfs_trans_handle *trans;
+	int nr;
+	int ret;
+
+	switch (*state) {
+	case FLUSH_DELALLOC:
+	case FLUSH_DELALLOC_WAIT:
+		ret = shrink_delalloc(root, num_bytes,
+				      *state == FLUSH_DELALLOC_WAIT);
+		if (ret > 0)
+			ret = 0;
+		break;
+	case FLUSH_DELAYED_ITEMS_NR:
+	case FLUSH_DELAYED_ITEMS:
+		if (*state == FLUSH_DELAYED_ITEMS_NR) {
+			u64 bytes = btrfs_calc_trans_metadata_size(root, 1);
+
+			nr = (int)div64_u64(num_bytes, bytes);
+			if (!nr)
+				nr = 1;
+			nr *= 2;
+		} else {
+			nr = -1;
+		}
+		trans = btrfs_join_transaction(root);
+		if (IS_ERR(trans)) {
+			ret = PTR_ERR(trans);
+			break;
+		}
+		ret = btrfs_run_delayed_items_nr(trans, root, nr);
+		btrfs_end_transaction(trans, root);
+		break;
+	case COMMIT_TRANS:
+		ret = may_commit_transaction(root, space_info, orig_bytes, 0);
+		break;
+	default:
+		ret = -ENOSPC;
+		break;
+	}
+
+	if (!ret)
+		(*state)++;
+	return ret;
+}
 /**
  * reserve_metadata_bytes - try to reserve bytes from the block_rsv's space
  * @root - the root we're allocating for
@@ -3748,11 +3804,10 @@ static int reserve_metadata_bytes(struct btrfs_root *root,
 	struct btrfs_space_info *space_info = block_rsv->space_info;
 	u64 used;
 	u64 num_bytes = orig_bytes;
-	int retries = 0;
+	int flush_state = FLUSH_DELALLOC;
 	int ret = 0;
-	bool committed = false;
 	bool flushing = false;
-	bool wait_ordered = false;
+	bool committed = false;
 
 again:
 	ret = 0;
@@ -3811,9 +3866,8 @@ again:
 		 * amount plus the amount of bytes that we need for this
 		 * reservation.
 		 */
-		wait_ordered = true;
 		num_bytes = used - space_info->total_bytes +
-			(orig_bytes * (retries + 1));
+			(orig_bytes * 2);
 	}
 
 	if (ret) {
@@ -3866,8 +3920,6 @@ again:
 			trace_btrfs_space_reservation(root->fs_info,
 				"space_info", space_info->flags, orig_bytes, 1);
 			ret = 0;
-		} else {
-			wait_ordered = true;
 		}
 	}
 
@@ -3886,36 +3938,10 @@ again:
 	if (!ret || !flush)
 		goto out;
 
-	/*
-	 * We do synchronous shrinking since we don't actually unreserve
-	 * metadata until after the IO is completed.
-	 */
-	ret = shrink_delalloc(root, num_bytes, wait_ordered);
-	if (ret < 0)
-		goto out;
-
-	ret = 0;
-
-	/*
-	 * So if we were overcommitted it's possible that somebody else flushed
-	 * out enough space and we simply didn't have enough space to reclaim,
-	 * so go back around and try again.
-	 */
-	if (retries < 2) {
-		wait_ordered = true;
-		retries++;
-		goto again;
-	}
-
-	ret = -ENOSPC;
-	if (committed)
-		goto out;
-
-	ret = may_commit_transaction(root, space_info, orig_bytes, 0);
-	if (!ret) {
-		committed = true;
+	ret = flush_space(root, space_info, num_bytes, orig_bytes,
+			  &flush_state);
+	if (!ret)
 		goto again;
-	}
 
 out:
 	if (flushing) {
-- 
1.7.7.6

