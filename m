Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47982 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935502AbeFZO1N (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Jun 2018 10:27:13 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3295FABDF
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Jun 2018 14:27:12 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: nborisov@suse.com, David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: annotate unlikely branches after V0 extent type removal
Date: Tue, 26 Jun 2018 16:24:14 +0200
Message-Id: <20180626142414.12874-1-dsterba@suse.com>
In-Reply-To: <1530021456-20749-1-git-send-email-nborisov@suse.com>
References: <1530021456-20749-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The v0 extent type checks are the right case for the unlikely
annotations as we don't expect to ever see them, so let's give the
compiler some hint.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent-tree.c | 8 ++++----
 fs/btrfs/print-tree.c  | 2 +-
 fs/btrfs/relocation.c  | 8 ++++----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8713a1693dfc..d3f7afe3a548 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1310,7 +1310,7 @@ static noinline int remove_extent_data_ref(struct btrfs_trans_handle *trans,
 		ref2 = btrfs_item_ptr(leaf, path->slots[0],
 				      struct btrfs_shared_data_ref);
 		num_refs = btrfs_shared_data_ref_count(leaf, ref2);
-	} else if (key.type == BTRFS_EXTENT_REF_V0_KEY) {
+	} else if (unlikely(key.type == BTRFS_EXTENT_REF_V0_KEY)) {
 		btrfs_print_v0_err(fs_info);
 		btrfs_abort_transaction(trans, -EINVAL);
 		return -EINVAL;
@@ -1563,7 +1563,7 @@ int lookup_inline_extent_backref(struct btrfs_trans_handle *trans,
 
 	leaf = path->nodes[0];
 	item_size = btrfs_item_size_nr(leaf, path->slots[0]);
-	if (item_size < sizeof(*ei)) {
+	if (unlikely(item_size < sizeof(*ei))) {
 		err = -EINVAL;
 		btrfs_print_v0_err(fs_info);
 		btrfs_abort_transaction(trans, err);
@@ -2269,7 +2269,7 @@ static int run_delayed_extent_op(struct btrfs_trans_handle *trans,
 	leaf = path->nodes[0];
 	item_size = btrfs_item_size_nr(leaf, path->slots[0]);
 
-	if (item_size < sizeof(*ei)) {
+	if (unlikely(item_size < sizeof(*ei))) {
 		err = -EINVAL;
 		btrfs_print_v0_err(fs_info);
 		btrfs_abort_transaction(trans, err);
@@ -6811,7 +6811,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 
 	leaf = path->nodes[0];
 	item_size = btrfs_item_size_nr(leaf, extent_slot);
-	if (item_size < sizeof(*ei)) {
+	if (unlikely(item_size < sizeof(*ei))) {
 		ret = -EINVAL;
 		btrfs_print_v0_err(info);
 		btrfs_abort_transaction(trans, ret);
diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index 772560eecfa6..0dd44d161935 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -52,7 +52,7 @@ static void print_extent_item(struct extent_buffer *eb, int slot, int type)
 	u64 offset;
 	int ref_index = 0;
 
-	if (item_size < sizeof(*ei)) {
+	if (unlikely(item_size < sizeof(*ei))) {
 		btrfs_print_v0_err(eb->fs_info);
 		btrfs_handle_fs_error(eb->fs_info, -EINVAL, NULL);
 	}
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index a8dddefaae99..381bd3c24249 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -832,7 +832,7 @@ struct backref_node *build_backref_tree(struct reloc_control *rc,
 			goto next;
 		} else if (key.type != BTRFS_TREE_BLOCK_REF_KEY) {
 			goto next;
-		} else if (key.type == BTRFS_EXTENT_REF_V0_KEY) {
+		} else if (unlikely(key.type == BTRFS_EXTENT_REF_V0_KEY)) {
 			err = -EINVAL;
 			btrfs_print_v0_err(rc->extent_root->fs_info);
 			btrfs_handle_fs_error(rc->extent_root->fs_info, err,
@@ -3325,7 +3325,7 @@ static int add_tree_block(struct reloc_control *rc,
 			level = (int)extent_key->offset;
 		}
 		generation = btrfs_extent_generation(eb, ei);
-	} else if (item_size == sizeof(struct btrfs_extent_item_v0)) {
+	} else if (unlikely(item_size == sizeof(struct btrfs_extent_item_v0))) {
 		btrfs_print_v0_err(eb->fs_info);
 		btrfs_handle_fs_error(eb->fs_info, -EINVAL, NULL);
 		return -EINVAL;
@@ -3742,7 +3742,7 @@ int add_data_references(struct reloc_control *rc,
 					      struct btrfs_extent_data_ref);
 			ret = find_data_references(rc, extent_key,
 						   eb, dref, blocks);
-		} else if (key.type == BTRFS_EXTENT_REF_V0_KEY) {
+		} else if (unlikely(key.type == BTRFS_EXTENT_REF_V0_KEY)) {
 			btrfs_print_v0_err(eb->fs_info);
 			btrfs_handle_fs_error(eb->fs_info, -EINVAL, NULL);
 			ret = -EINVAL;
@@ -3984,7 +3984,7 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
 			flags = btrfs_extent_flags(path->nodes[0], ei);
 			ret = check_extent_flags(flags);
 			BUG_ON(ret);
-		} else if (item_size == sizeof(struct btrfs_extent_item_v0)) {
+		} else if (unlikely(item_size == sizeof(struct btrfs_extent_item_v0))) {
 			err = -EINVAL;
 			btrfs_print_v0_err(trans->fs_info);
 			btrfs_abort_transaction(trans, err);
-- 
2.17.0

