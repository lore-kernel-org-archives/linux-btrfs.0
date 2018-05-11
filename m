Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:36098 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751620AbeEKALl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 20:11:41 -0400
Received: by mail-pl0-f68.google.com with SMTP id v24-v6so2225204plo.3
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 17:11:40 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH v2 07/12] Btrfs: refactor btrfs_evict_inode() reserve refill dance
Date: Thu, 10 May 2018 17:11:17 -0700
Message-Id: <c5a39f489bcada1ea0fc455f8917effb482b2d18.1525997057.git.osandov@fb.com>
In-Reply-To: <cover.1525997057.git.osandov@fb.com>
References: <cover.1525997057.git.osandov@fb.com>
In-Reply-To: <cover.1525997057.git.osandov@fb.com>
References: <cover.1525997057.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

The truncate loop in btrfs_evict_inode() does two things at once:

- It refills the temporary block reserve, potentially stealing from the
  global reserve or committing
- It calls btrfs_truncate_inode_items()

The tangle of continues hides the fact that these two steps are actually
separate. Split the first step out into a separate function both for
clarity and so that we can reuse it in a later patch.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/inode.c | 113 ++++++++++++++++++-----------------------------
 1 file changed, 42 insertions(+), 71 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9a6a4e626e01..348dc57920f5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5224,13 +5224,52 @@ static void evict_inode_truncate_pages(struct inode *inode)
 	spin_unlock(&io_tree->lock);
 }
 
+static struct btrfs_trans_handle *evict_refill_and_join(struct btrfs_root *root,
+							struct btrfs_block_rsv *rsv,
+							u64 min_size)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
+	int failures = 0;
+
+	for (;;) {
+		struct btrfs_trans_handle *trans;
+		int ret;
+
+		ret = btrfs_block_rsv_refill(root, rsv, min_size,
+					     BTRFS_RESERVE_FLUSH_LIMIT);
+
+		if (ret && ++failures > 2) {
+			btrfs_warn(fs_info,
+				   "could not allocate space for a delete; will truncate on mount");
+			return ERR_PTR(-ENOSPC);
+		}
+
+		trans = btrfs_join_transaction(root);
+		if (IS_ERR(trans) || !ret)
+			return trans;
+
+		/*
+		 * Try to steal from the global reserve if there is space for
+		 * it.
+		 */
+		if (!btrfs_check_space_for_delayed_refs(trans, fs_info) &&
+		    !btrfs_block_rsv_migrate(global_rsv, rsv, min_size, 0))
+			return trans;
+
+		/* If not, commit and try again. */
+		ret = btrfs_commit_transaction(trans);
+		if (ret)
+			return ERR_PTR(ret);
+	}
+}
+
 void btrfs_evict_inode(struct inode *inode)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct btrfs_block_rsv *rsv, *global_rsv;
-	int steal_from_global = 0;
+	struct btrfs_block_rsv *rsv;
 	u64 min_size;
 	int ret;
 
@@ -5286,85 +5325,17 @@ void btrfs_evict_inode(struct inode *inode)
 	}
 	rsv->size = min_size;
 	rsv->failfast = 1;
-	global_rsv = &fs_info->global_block_rsv;
 
 	btrfs_i_size_write(BTRFS_I(inode), 0);
 
-	/*
-	 * This is a bit simpler than btrfs_truncate since we've already
-	 * reserved our space for our orphan item in the unlink, so we just
-	 * need to reserve some slack space in case we add bytes and update
-	 * inode item when doing the truncate.
-	 */
 	while (1) {
-		ret = btrfs_block_rsv_refill(root, rsv, min_size,
-					     BTRFS_RESERVE_FLUSH_LIMIT);
-
-		/*
-		 * Try and steal from the global reserve since we will
-		 * likely not use this space anyway, we want to try as
-		 * hard as possible to get this to work.
-		 */
-		if (ret)
-			steal_from_global++;
-		else
-			steal_from_global = 0;
-		ret = 0;
-
-		/*
-		 * steal_from_global == 0: we reserved stuff, hooray!
-		 * steal_from_global == 1: we didn't reserve stuff, boo!
-		 * steal_from_global == 2: we've committed, still not a lot of
-		 * room but maybe we'll have room in the global reserve this
-		 * time.
-		 * steal_from_global == 3: abandon all hope!
-		 */
-		if (steal_from_global > 2) {
-			btrfs_warn(fs_info,
-				   "Could not get space for a delete, will truncate on mount %d",
-				   ret);
-			btrfs_orphan_del(NULL, BTRFS_I(inode));
-			btrfs_free_block_rsv(fs_info, rsv);
-			goto no_delete;
-		}
-
-		trans = btrfs_join_transaction(root);
+		trans = evict_refill_and_join(root, rsv, min_size);
 		if (IS_ERR(trans)) {
 			btrfs_orphan_del(NULL, BTRFS_I(inode));
 			btrfs_free_block_rsv(fs_info, rsv);
 			goto no_delete;
 		}
 
-		/*
-		 * We can't just steal from the global reserve, we need to make
-		 * sure there is room to do it, if not we need to commit and try
-		 * again.
-		 */
-		if (steal_from_global) {
-			if (!btrfs_check_space_for_delayed_refs(trans, fs_info))
-				ret = btrfs_block_rsv_migrate(global_rsv, rsv,
-							      min_size, 0);
-			else
-				ret = -ENOSPC;
-		}
-
-		/*
-		 * Couldn't steal from the global reserve, we have too much
-		 * pending stuff built up, commit the transaction and try it
-		 * again.
-		 */
-		if (ret) {
-			ret = btrfs_commit_transaction(trans);
-			if (ret) {
-				btrfs_orphan_del(NULL, BTRFS_I(inode));
-				btrfs_free_block_rsv(fs_info, rsv);
-				goto no_delete;
-			}
-			continue;
-		} else {
-			steal_from_global = 0;
-		}
-
 		trans->block_rsv = rsv;
 
 		ret = btrfs_truncate_inode_items(trans, root, inode, 0, 0);
-- 
2.17.0

