Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51618 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727795AbeIUNII (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Sep 2018 09:08:08 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 38FB4AE23
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Sep 2018 07:20:34 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/2] btrfs: relocation: Cleanup while() loop using rbtree_postorder_for_each_entry_safe()
Date: Fri, 21 Sep 2018 15:20:29 +0800
Message-Id: <20180921072030.20531-1-wqu@suse.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

And add one line comment explaining what we're doing for each loop.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
changelog:
v2:
  Use rbtree_postorder_for_each_entry_safe() to replace for() loop.
---
 fs/btrfs/relocation.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 8783a1776540..94aa148ccde6 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2987,7 +2987,7 @@ int relocate_tree_blocks(struct btrfs_trans_handle *trans,
 	struct backref_node *node;
 	struct btrfs_path *path;
 	struct tree_block *block;
-	struct rb_node *rb_node;
+	struct tree_block *next;
 	int ret;
 	int err = 0;
 
@@ -2997,29 +2997,23 @@ int relocate_tree_blocks(struct btrfs_trans_handle *trans,
 		goto out_free_blocks;
 	}
 
-	rb_node = rb_first(blocks);
-	while (rb_node) {
-		block = rb_entry(rb_node, struct tree_block, rb_node);
+	/* Kick in readahead for tree blocks with missing keys */
+	rbtree_postorder_for_each_entry_safe(block, next, blocks, rb_node) {
 		if (!block->key_ready)
 			readahead_tree_block(fs_info, block->bytenr);
-		rb_node = rb_next(rb_node);
 	}
 
-	rb_node = rb_first(blocks);
-	while (rb_node) {
-		block = rb_entry(rb_node, struct tree_block, rb_node);
+	/* Get first keys */
+	rbtree_postorder_for_each_entry_safe(block, next, blocks, rb_node) {
 		if (!block->key_ready) {
 			err = get_tree_block_key(fs_info, block);
 			if (err)
 				goto out_free_path;
 		}
-		rb_node = rb_next(rb_node);
 	}
 
-	rb_node = rb_first(blocks);
-	while (rb_node) {
-		block = rb_entry(rb_node, struct tree_block, rb_node);
-
+	/* Do tree relocation */
+	rbtree_postorder_for_each_entry_safe(block, next, blocks, rb_node) {
 		node = build_backref_tree(rc, &block->key,
 					  block->level, block->bytenr);
 		if (IS_ERR(node)) {
@@ -3030,11 +3024,11 @@ int relocate_tree_blocks(struct btrfs_trans_handle *trans,
 		ret = relocate_tree_block(trans, rc, node, &block->key,
 					  path);
 		if (ret < 0) {
-			if (ret != -EAGAIN || rb_node == rb_first(blocks))
+			if (ret != -EAGAIN || &block->rb_node ==
+					      rb_first(blocks))
 				err = ret;
 			goto out;
 		}
-		rb_node = rb_next(rb_node);
 	}
 out:
 	err = finish_pending_nodes(trans, rc, path, err);
-- 
2.19.0
