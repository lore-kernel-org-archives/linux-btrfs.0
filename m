Return-Path: <SRS0=cBAG=QG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74427C282D9
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 14:51:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EE3F20989
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 14:51:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731437AbfA3OvJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 30 Jan 2019 09:51:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:38124 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731408AbfA3OvH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Jan 2019 09:51:07 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EBBB6B0C4
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2019 14:51:05 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     jeffm@suse.com, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 06/15] btrfs: Rename and export clear_btree_io_tree
Date:   Wed, 30 Jan 2019 16:50:53 +0200
Message-Id: <20190130145102.4708-7-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190130145102.4708-1-nborisov@suse.com>
References: <20190130145102.4708-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This function is going to be used to clear out the device extent
allocation information. Give it a more generic name and export it. This
is in preparation to replacing the pending/pinned chunk lists with an
extent tree. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent_io.c   | 28 ++++++++++++++++++++++++++++
 fs/btrfs/extent_io.h   |  1 +
 fs/btrfs/transaction.c | 37 ++++---------------------------------
 3 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 01f596d42f59..ab1c81a1918e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -210,6 +210,34 @@ void extent_io_tree_init(struct extent_io_tree *tree,
 	tree->private_data = private_data;
 }
 
+void extent_io_tree_release(struct extent_io_tree *tree)
+{
+	spin_lock(&tree->lock);
+	/*
+	 * Do a single barrier for the waitqueue_active check here, the state
+	 * of the waitqueue should not change once clear_btree_io_tree is
+	 * called.
+	 */
+	smp_mb();
+	while (!RB_EMPTY_ROOT(&tree->state)) {
+		struct rb_node *node;
+		struct extent_state *state;
+
+		node = rb_first(&tree->state);
+		state = rb_entry(node, struct extent_state, rb_node);
+		rb_erase(&state->rb_node, &tree->state);
+		RB_CLEAR_NODE(&state->rb_node);
+		/*
+		 * btree io trees aren't supposed to have tasks waiting for
+		 * changes in the flags of extent states ever.
+		 */
+		ASSERT(!waitqueue_active(&state->wq));
+		free_extent_state(state);
+
+		cond_resched_lock(&tree->lock);
+	}
+	spin_unlock(&tree->lock);
+}
 static struct extent_state *alloc_extent_state(gfp_t mask)
 {
 	struct extent_state *state;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 08749e0b9c32..d7beb2b3bc7d 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -240,6 +240,7 @@ typedef struct extent_map *(get_extent_t)(struct btrfs_inode *inode,
 					  int create);
 
 void extent_io_tree_init(struct extent_io_tree *tree, void *private_data);
+void extent_io_tree_release(struct extent_io_tree *tree);
 int try_release_extent_mapping(struct page *page, gfp_t mask);
 int try_release_extent_buffer(struct page *page);
 int lock_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 8d340957f7d6..0f5c8d9b50d7 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -80,35 +80,6 @@ void btrfs_put_transaction(struct btrfs_transaction *transaction)
 	}
 }
 
-static void clear_btree_io_tree(struct extent_io_tree *tree)
-{
-	spin_lock(&tree->lock);
-	/*
-	 * Do a single barrier for the waitqueue_active check here, the state
-	 * of the waitqueue should not change once clear_btree_io_tree is
-	 * called.
-	 */
-	smp_mb();
-	while (!RB_EMPTY_ROOT(&tree->state)) {
-		struct rb_node *node;
-		struct extent_state *state;
-
-		node = rb_first(&tree->state);
-		state = rb_entry(node, struct extent_state, rb_node);
-		rb_erase(&state->rb_node, &tree->state);
-		RB_CLEAR_NODE(&state->rb_node);
-		/*
-		 * btree io trees aren't supposed to have tasks waiting for
-		 * changes in the flags of extent states ever.
-		 */
-		ASSERT(!waitqueue_active(&state->wq));
-		free_extent_state(state);
-
-		cond_resched_lock(&tree->lock);
-	}
-	spin_unlock(&tree->lock);
-}
-
 static noinline void switch_commit_roots(struct btrfs_transaction *trans)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
@@ -122,7 +93,7 @@ static noinline void switch_commit_roots(struct btrfs_transaction *trans)
 		root->commit_root = btrfs_root_node(root);
 		if (is_fstree(root->root_key.objectid))
 			btrfs_unpin_free_ino(root);
-		clear_btree_io_tree(&root->dirty_log_pages);
+		extent_io_tree_release(&root->dirty_log_pages);
 	}
 
 	/* We can free old roots now. */
@@ -938,7 +909,7 @@ int btrfs_write_marked_extents(struct btrfs_fs_info *fs_info,
 		 * superblock that points to btree nodes/leafs for which
 		 * writeback hasn't finished yet (and without errors).
 		 * We cleanup any entries left in the io tree when committing
-		 * the transaction (through clear_btree_io_tree()).
+		 * the transaction (through extent_io_tree_release()).
 		 */
 		if (err == -ENOMEM) {
 			err = 0;
@@ -983,7 +954,7 @@ static int __btrfs_wait_marked_extents(struct btrfs_fs_info *fs_info,
 		 * left in the io tree. For a log commit, we don't remove them
 		 * after committing the log because the tree can be accessed
 		 * concurrently - we do it only at transaction commit time when
-		 * it's safe to do it (through clear_btree_io_tree()).
+		 * it's safe to do it (through extent_io_tree_release()).
 		 */
 		err = clear_extent_bit(dirty_pages, start, end,
 				       EXTENT_NEED_WAIT, 0, 0, &cached_state);
@@ -1061,7 +1032,7 @@ static int btrfs_write_and_wait_transaction(struct btrfs_trans_handle *trans)
 	blk_finish_plug(&plug);
 	ret2 = btrfs_wait_extents(fs_info, dirty_pages);
 
-	clear_btree_io_tree(&trans->transaction->dirty_pages);
+	extent_io_tree_release(&trans->transaction->dirty_pages);
 
 	if (ret)
 		return ret;
-- 
2.17.1

