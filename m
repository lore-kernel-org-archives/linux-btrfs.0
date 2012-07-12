Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:33254 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933585Ab2GLJnu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jul 2012 05:43:50 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net
Subject: [PATCH v1 10/15] Btrfs: call the qgroup accounting functions
Date: Thu, 12 Jul 2012 11:43:42 +0200
Message-Id: <edf39272db4810282360f7362d43ade1d524c913.1342083345.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
References: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
References: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/extent-tree.c |    3 +++
 fs/btrfs/transaction.c |   14 ++++++++++++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 1a63b83..c08337a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2479,6 +2479,8 @@ int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 		       2 * 1024 * 1024, btrfs_get_alloc_profile(root, 0),
 		       CHUNK_ALLOC_NO_FORCE);
 
+	btrfs_delayed_refs_qgroup_accounting(trans, root->fs_info);
+
 	delayed_refs = &trans->transaction->delayed_refs;
 	INIT_LIST_HEAD(&cluster);
 again:
@@ -2588,6 +2590,7 @@ again:
 	}
 out:
 	spin_unlock(&delayed_refs->lock);
+	assert_qgroups_uptodate(trans);
 	return 0;
 }
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 0d6c881..d20d2e2 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -512,6 +512,11 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 		return 0;
 	}
 
+	/*
+	 * do the qgroup accounting as early as possible
+	 */
+	err = btrfs_delayed_refs_qgroup_accounting(trans, info);
+
 	btrfs_trans_release_metadata(trans, root);
 	trans->block_rsv = NULL;
 	/*
@@ -571,6 +576,7 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	    root->fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR) {
 		err = -EIO;
 	}
+	assert_qgroups_uptodate(trans);
 
 	memset(trans, 0, sizeof(*trans));
 	kmem_cache_free(btrfs_trans_handle_cachep, trans);
@@ -1356,6 +1362,13 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 			goto cleanup_transaction;
 
 		/*
+		 * running the delayed items may have added new refs. account
+		 * them now so that they hinder processing of more delayed refs
+		 * as little as possible.
+		 */
+		btrfs_delayed_refs_qgroup_accounting(trans, root->fs_info);
+
+		/*
 		 * rename don't use btrfs_join_transaction, so, once we
 		 * set the transaction to blocked above, we aren't going
 		 * to get any new ordered operations.  We can safely run
@@ -1467,6 +1480,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 			    root->fs_info->chunk_root->node);
 	switch_commit_root(root->fs_info->chunk_root);
 
+	assert_qgroups_uptodate(trans);
 	update_super_roots(root);
 
 	if (!root->fs_info->log_root_recovering) {
-- 
1.7.3.4

