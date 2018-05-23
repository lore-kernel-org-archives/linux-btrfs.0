Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f175.google.com ([209.85.216.175]:36199 "EHLO
        mail-qt0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754671AbeEWP6m (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 May 2018 11:58:42 -0400
Received: by mail-qt0-f175.google.com with SMTP id q6-v6so28722884qtn.3
        for <linux-btrfs@vger.kernel.org>; Wed, 23 May 2018 08:58:42 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH 3/4] btrfs: clean up the left over logged_list usage
Date: Wed, 23 May 2018 11:58:35 -0400
Message-Id: <20180523155836.4622-3-josef@toxicpanda.com>
In-Reply-To: <20180523155836.4622-1-josef@toxicpanda.com>
References: <20180523155836.4622-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

We no longer use this list we've passed around so remove it everywhere.
Also remove the extra checks for ordered/filemap errors as this is
handled higher up now that we're waiting on ordered_extents before
getting to the tree log code.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/tree-log.c | 32 ++------------------------------
 1 file changed, 2 insertions(+), 30 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 791b5a731456..ef1b1a071bba 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4133,7 +4133,6 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 			  struct btrfs_inode *inode, struct btrfs_root *root,
 			  const struct extent_map *em,
 			  struct btrfs_path *path,
-			  const struct list_head *logged_list,
 			  struct btrfs_log_ctx *ctx)
 {
 	struct btrfs_root *log = root->log_root;
@@ -4145,17 +4144,11 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 	u64 block_len;
 	int ret;
 	int extent_inserted = 0;
-	bool ordered_io_err = false;
 
 	ret = log_extent_csums(trans, inode, root, em);
 	if (ret)
 		return ret;
 
-	if (ordered_io_err) {
-		ctx->io_err = -EIO;
-		return ctx->io_err;
-	}
-
 	btrfs_init_map_token(&token);
 
 	ret = __btrfs_drop_extents(trans, log, &inode->vfs_inode, path, em->start,
@@ -4226,7 +4219,6 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 				     struct btrfs_root *root,
 				     struct btrfs_inode *inode,
 				     struct btrfs_path *path,
-				     struct list_head *logged_list,
 				     struct btrfs_log_ctx *ctx,
 				     const u64 start,
 				     const u64 end)
@@ -4302,20 +4294,6 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 	}
 
 	list_sort(NULL, &extents, extent_cmp);
-	btrfs_get_logged_extents(inode, logged_list, logged_start, logged_end);
-	/*
-	 * Some ordered extents started by fsync might have completed
-	 * before we could collect them into the list logged_list, which
-	 * means they're gone, not in our logged_list nor in the inode's
-	 * ordered tree. We want the application/user space to know an
-	 * error happened while attempting to persist file data so that
-	 * it can take proper action. If such error happened, we leave
-	 * without writing to the log tree and the fsync must report the
-	 * file data write error and not commit the current transaction.
-	 */
-	ret = filemap_check_errors(inode->vfs_inode.i_mapping);
-	if (ret)
-		ctx->io_err = ret;
 process:
 	while (!list_empty(&extents)) {
 		em = list_entry(extents.next, struct extent_map, list);
@@ -4334,8 +4312,7 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 
 		write_unlock(&tree->lock);
 
-		ret = log_one_extent(trans, inode, root, em, path, logged_list,
-				     ctx);
+		ret = log_one_extent(trans, inode, root, em, path, ctx);
 		write_lock(&tree->lock);
 		clear_em_logging(tree, em);
 		free_extent_map(em);
@@ -4717,7 +4694,6 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 	struct btrfs_key min_key;
 	struct btrfs_key max_key;
 	struct btrfs_root *log = root->log_root;
-	LIST_HEAD(logged_list);
 	u64 last_extent = 0;
 	int err = 0;
 	int ret;
@@ -5047,7 +5023,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 	}
 	if (fast_search) {
 		ret = btrfs_log_changed_extents(trans, root, inode, dst_path,
-						&logged_list, ctx, start, end);
+						ctx, start, end);
 		if (ret) {
 			err = ret;
 			goto out_unlock;
@@ -5098,10 +5074,6 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 	inode->last_log_commit = inode->last_sub_trans;
 	spin_unlock(&inode->lock);
 out_unlock:
-	if (unlikely(err))
-		btrfs_put_logged_extents(&logged_list);
-	else
-		btrfs_submit_logged_extents(&logged_list, log);
 	mutex_unlock(&inode->log_mutex);
 
 	btrfs_free_path(path);
-- 
2.14.3

