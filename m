Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47932 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388924AbeIUMdM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Sep 2018 08:33:12 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 34C10ACEF
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Sep 2018 06:45:25 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: relocation: Cleanup while() loop using for()
Date: Fri, 21 Sep 2018 14:45:20 +0800
Message-Id: <20180921064521.13102-1-wqu@suse.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

And add one line comment explaining what we're doing for each loop.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/relocation.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 8783a1776540..d7f5a11dde20 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2997,27 +2997,25 @@ int relocate_tree_blocks(struct btrfs_trans_handle *trans,
 		goto out_free_blocks;
 	}
 
-	rb_node = rb_first(blocks);
-	while (rb_node) {
+	/* Kick in readahead for tree blocks with missing keys */
+	for (rb_node = rb_first(blocks); rb_node; rb_node = rb_next(rb_node)) {
 		block = rb_entry(rb_node, struct tree_block, rb_node);
 		if (!block->key_ready)
 			readahead_tree_block(fs_info, block->bytenr);
-		rb_node = rb_next(rb_node);
 	}
 
-	rb_node = rb_first(blocks);
-	while (rb_node) {
+	/* Get first keys */
+	for (rb_node = rb_first(blocks); rb_node; rb_node = rb_next(rb_node)) {
 		block = rb_entry(rb_node, struct tree_block, rb_node);
 		if (!block->key_ready) {
 			err = get_tree_block_key(fs_info, block);
 			if (err)
 				goto out_free_path;
 		}
-		rb_node = rb_next(rb_node);
 	}
 
-	rb_node = rb_first(blocks);
-	while (rb_node) {
+	/* Do tree relocation */
+	for (rb_node = rb_first(blocks); rb_node; rb_node = rb_next(rb_node)) {
 		block = rb_entry(rb_node, struct tree_block, rb_node);
 
 		node = build_backref_tree(rc, &block->key,
@@ -3034,7 +3032,6 @@ int relocate_tree_blocks(struct btrfs_trans_handle *trans,
 				err = ret;
 			goto out;
 		}
-		rb_node = rb_next(rb_node);
 	}
 out:
 	err = finish_pending_nodes(trans, rc, path, err);
-- 
2.19.0
