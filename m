Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from condef003-v.nifty.com ([210.131.4.240]:54499 "EHLO
        condef003-v.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751644AbcILTj3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 15:39:29 -0400
Received: from conuserg-07.nifty.com ([10.26.8.70])by condef003-v.nifty.com with ESMTP id u8CJaWss004090
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Sep 2016 04:36:32 +0900
From: Masahiro Yamada <yamada.masahiro@socionext.com>
To: linux-btrfs@vger.kernel.org
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>,
        Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: squash lines for simple wrapper functions
Date: Tue, 13 Sep 2016 04:35:52 +0900
Message-Id: <1473708952-1007-1-git-send-email-yamada.masahiro@socionext.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove unneeded variables and assignments.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

 fs/btrfs/check-integrity.c |  7 ++-----
 fs/btrfs/ctree.c           |  4 +---
 fs/btrfs/delayed-inode.c   |  5 +----
 fs/btrfs/extent-tree.c     | 12 ++----------
 fs/btrfs/send.c            |  8 ++------
 5 files changed, 8 insertions(+), 28 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 6678947..183c98f 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -2849,11 +2849,8 @@ static void btrfsic_cmp_log_and_dev_bytenr(struct btrfsic_state *state,
 static struct btrfsic_dev_state *btrfsic_dev_state_lookup(
 		struct block_device *bdev)
 {
-	struct btrfsic_dev_state *ds;
-
-	ds = btrfsic_dev_state_hashtable_lookup(bdev,
-						&btrfsic_dev_state_hashtable);
-	return ds;
+	return btrfsic_dev_state_hashtable_lookup(bdev,
+						  &btrfsic_dev_state_hashtable);
 }
 
 int btrfsic_submit_bh(int op, int op_flags, struct buffer_head *bh)
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index d1c56c9..381e9ad 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -45,9 +45,7 @@ static int tree_mod_log_free_eb(struct btrfs_fs_info *fs_info,
 
 struct btrfs_path *btrfs_alloc_path(void)
 {
-	struct btrfs_path *path;
-	path = kmem_cache_zalloc(btrfs_path_cachep, GFP_NOFS);
-	return path;
+	return kmem_cache_zalloc(btrfs_path_cachep, GFP_NOFS);
 }
 
 /*
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 3eeb9cd..403b2af 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -385,11 +385,8 @@ static struct btrfs_delayed_item *__btrfs_lookup_delayed_insertion_item(
 					struct btrfs_delayed_node *delayed_node,
 					struct btrfs_key *key)
 {
-	struct btrfs_delayed_item *item;
-
-	item = __btrfs_lookup_delayed_item(&delayed_node->ins_root, key,
+	return __btrfs_lookup_delayed_item(&delayed_node->ins_root, key,
 					   NULL, NULL);
-	return item;
 }
 
 static int __btrfs_add_delayed_item(struct btrfs_delayed_node *delayed_node,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 38c2df8..3fe8fdc 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -730,11 +730,7 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
 static struct btrfs_block_group_cache *
 btrfs_lookup_first_block_group(struct btrfs_fs_info *info, u64 bytenr)
 {
-	struct btrfs_block_group_cache *cache;
-
-	cache = block_group_cache_tree_search(info, bytenr, 0);
-
-	return cache;
+	return block_group_cache_tree_search(info, bytenr, 0);
 }
 
 /*
@@ -744,11 +740,7 @@ struct btrfs_block_group_cache *btrfs_lookup_block_group(
 						 struct btrfs_fs_info *info,
 						 u64 bytenr)
 {
-	struct btrfs_block_group_cache *cache;
-
-	cache = block_group_cache_tree_search(info, bytenr, 1);
-
-	return cache;
+	return block_group_cache_tree_search(info, bytenr, 1);
 }
 
 static struct btrfs_space_info *__find_space_info(struct btrfs_fs_info *info,
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index a87675f..bc7185c 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4398,12 +4398,8 @@ static int process_new_xattr(struct send_ctx *sctx)
 
 static int process_deleted_xattr(struct send_ctx *sctx)
 {
-	int ret;
-
-	ret = iterate_dir_item(sctx->parent_root, sctx->right_path,
-			       sctx->cmp_key, __process_deleted_xattr, sctx);
-
-	return ret;
+	return iterate_dir_item(sctx->parent_root, sctx->right_path,
+				sctx->cmp_key, __process_deleted_xattr, sctx);
 }
 
 struct find_xattr_ctx {
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo
