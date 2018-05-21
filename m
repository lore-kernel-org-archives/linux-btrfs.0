Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43613 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751732AbeEUJ1c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 May 2018 05:27:32 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 87AAAAEFE
        for <linux-btrfs@vger.kernel.org>; Mon, 21 May 2018 09:27:31 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 4/4] btrfs: Streamline shared ref check in alloc_reserved_tree_block
Date: Mon, 21 May 2018 12:27:23 +0300
Message-Id: <1526894843-8732-5-git-send-email-nborisov@suse.com>
In-Reply-To: <1526894843-8732-1-git-send-email-nborisov@suse.com>
References: <1526894843-8732-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Instead of setting "parent" to ref->parent only when dealing with
a shared ref and subsequently performing another check to see
if (parent > 0), check the "node->type" directly and act accordingly.
This makes the code more streamline. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4d092d14cbe9..9e8786a7555f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8142,17 +8142,11 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 	struct btrfs_delayed_tree_ref *ref;
 	u32 size = sizeof(*extent_item) + sizeof(*iref);
 	u64 num_bytes;
-	u64 parent;
 	u64 flags = extent_op->flags_to_set;
 	bool skinny_metadata = btrfs_fs_incompat(fs_info, SKINNY_METADATA);
 
 	ref = btrfs_delayed_node_to_tree_ref(node);
 
-	if (node->type == BTRFS_SHARED_BLOCK_REF_KEY)
-		parent = ref->parent;
-	else
-		parent = 0;
-
 	extent_key.objectid = node->bytenr;
 	if (skinny_metadata) {
 		extent_key.offset = ref->level;
@@ -8201,11 +8195,11 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 		iref = (struct btrfs_extent_inline_ref *)(block_info + 1);
 	}
 
-	if (parent > 0) {
+	if (node->type == BTRFS_SHARED_BLOCK_REF_KEY) {
 		BUG_ON(!(flags & BTRFS_BLOCK_FLAG_FULL_BACKREF));
 		btrfs_set_extent_inline_ref_type(leaf, iref,
 						 BTRFS_SHARED_BLOCK_REF_KEY);
-		btrfs_set_extent_inline_ref_offset(leaf, iref, parent);
+		btrfs_set_extent_inline_ref_offset(leaf, iref, ref->parent);
 	} else {
 		btrfs_set_extent_inline_ref_type(leaf, iref,
 						 BTRFS_TREE_BLOCK_REF_KEY);
-- 
2.7.4

