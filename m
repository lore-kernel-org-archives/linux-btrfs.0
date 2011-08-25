From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] Btrfs: fix error handling of create_reloc_root() and btrfs_copy_root()
Date: Thu, 25 Aug 2011 18:19:38 +0900
Message-ID: <201108250919.AA00033@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If kmalloc() or btrfs_copy_root() in create_reloc_root() failed,
error is returned to the caller instead of BUG_ON().
and, error handling of btrfs_copy_root() is corrected properly.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/ctree.c       |    5 ++++-
 fs/btrfs/relocation.c  |   16 +++++++++++++---
 fs/btrfs/transaction.c |    3 ++-
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 011cab3..837ff58 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -265,8 +265,11 @@ int btrfs_copy_root(struct btrfs_trans_handle *trans,
 	else
 		ret = btrfs_inc_ref(trans, root, cow, 0);
 
-	if (ret)
+	if (ret) {
+		btrfs_tree_unlock(cow);
+		free_extent_buffer(cow);
 		return ret;
+	}
 
 	btrfs_mark_buffer_dirty(cow);
 	*cow_ret = cow;
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 59bb176..57b6a57 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1268,7 +1268,8 @@ static struct btrfs_root *create_reloc_root(struct btrfs_trans_handle *trans,
 	int ret;
 
 	root_item = kmalloc(sizeof(*root_item), GFP_NOFS);
-	BUG_ON(!root_item);
+	if (!root_item)
+		return ERR_PTR(-ENOMEM);
 
 	root_key.objectid = BTRFS_TREE_RELOC_OBJECTID;
 	root_key.type = BTRFS_ROOT_ITEM_KEY;
@@ -1278,7 +1279,8 @@ static struct btrfs_root *create_reloc_root(struct btrfs_trans_handle *trans,
 		/* called by btrfs_init_reloc_root */
 		ret = btrfs_copy_root(trans, root, root->commit_root, &eb,
 				      BTRFS_TREE_RELOC_OBJECTID);
-		BUG_ON(ret);
+		if (ret)
+			goto out;
 
 		btrfs_set_root_last_snapshot(&root->root_item,
 					     trans->transid - 1);
@@ -1292,7 +1294,8 @@ static struct btrfs_root *create_reloc_root(struct btrfs_trans_handle *trans,
 		 */
 		ret = btrfs_copy_root(trans, root, root->node, &eb,
 				      BTRFS_TREE_RELOC_OBJECTID);
-		BUG_ON(ret);
+		if (ret)
+			goto out;
 	}
 
 	memcpy(root_item, &root->root_item, sizeof(*root_item));
@@ -1320,6 +1323,10 @@ static struct btrfs_root *create_reloc_root(struct btrfs_trans_handle *trans,
 	BUG_ON(IS_ERR(reloc_root));
 	reloc_root->last_trans = trans->transid;
 	return reloc_root;
+
+out:
+	kfree(root_item);
+	return ERR_PTR(ret);
 }
 
 /*
@@ -1348,6 +1355,8 @@ int btrfs_init_reloc_root(struct btrfs_trans_handle *trans,
 		clear_rsv = 1;
 	}
 	reloc_root = create_reloc_root(trans, root, root->root_key.objectid);
+	BUG_ON(IS_ERR(reloc_root));
+
 	if (clear_rsv)
 		trans->block_rsv = NULL;
 
@@ -4403,6 +4412,7 @@ void btrfs_reloc_post_snapshot(struct btrfs_trans_handle *trans,
 	new_root = pending->snap;
 	reloc_root = create_reloc_root(trans, root->reloc_root,
 				       new_root->root_key.objectid);
+	BUG_ON(IS_ERR(reloc_root));
 
 	__add_reloc_root(reloc_root);
 	new_root->reloc_root = reloc_root;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 7dc36fa..bdcc320 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -972,9 +972,10 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	btrfs_cow_block(trans, root, old, NULL, 0, &old);
 	btrfs_set_lock_blocking(old);
 
-	btrfs_copy_root(trans, root, old, &tmp, objectid);
+	ret = btrfs_copy_root(trans, root, old, &tmp, objectid);
 	btrfs_tree_unlock(old);
 	free_extent_buffer(old);
+	BUG_ON(ret);
 
 	btrfs_set_root_node(new_root_item, tmp);
 	/* record when the snapshot was created in key.offset */

