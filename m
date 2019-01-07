Return-Path: <SRS0=zk84=PP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B52EC43172
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Jan 2019 05:42:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9A8820854
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Jan 2019 05:42:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfAGFmP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 7 Jan 2019 00:42:15 -0500
Received: from mx2.suse.de ([195.135.220.15]:52670 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725300AbfAGFmO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 Jan 2019 00:42:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E02F7AD4C
        for <linux-btrfs@vger.kernel.org>; Mon,  7 Jan 2019 05:42:11 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v3.1 5/7] btrfs: qgroup: Introduce per-root swapped blocks infrastructure
Date:   Mon,  7 Jan 2019 13:41:49 +0800
Message-Id: <20190107054151.18662-6-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190107054151.18662-1-wqu@suse.com>
References: <20190107054151.18662-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

To allow delayed subtree swap rescan, btrfs needs to record per-root
info about which tree blocks get swapped.

So this patch introduces per-root btrfs_qgroup_swapped_blocks structure,
which records which tree blocks get swapped.

The designed workflow will be:

1) Record the subtree root block get swapped.

   During subtree swap:
   O = Old tree blocks
   N = New tree blocks
         reloc tree                         file tree X
            Root                               Root
           /    \                             /    \
         NA     OB                          OA      OB
       /  |     |  \                      /  |      |  \
     NC  ND     OE  OF                   OC  OD     OE  OF

  In these case, NA and OA is going to be swapped, record (NA, OA) into
  file tree X.

2) After subtree swap.
         reloc tree                         file tree X
            Root                               Root
           /    \                             /    \
         OA     OB                          NA      OB
       /  |     |  \                      /  |      |  \
     OC  OD     OE  OF                   NC  ND     OE  OF

3a) CoW happens for OB
    If we are going to CoW tree block OB, we check OB's bytenr against
    tree X's swapped_blocks structure.
    It doesn't fit any one, nothing will happen.

3b) CoW happens for NA
    Check NA's bytenr against tree X's swapped_blocks, and get a hit.
    Then we do subtree scan on both subtree OA and NA.
    Resulting 6 tree blocks to be scanned (OA, OC, OD, NA, NC, ND).

    Then no matter what we do to file tree X, qgroup numbers will
    still be correct.
    Then NA's record get removed from X's swapped_blocks.

4)  Transaction commit
    Any record in X's swapped_blocks get removed, since there is no
    modification to swapped subtrees, no need to trigger heavy qgroup
    subtree rescan for them.

This will introduce 128 bytes overhead for each btrfs_root even qgroup
is not enabled.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ctree.h       |  14 +++++
 fs/btrfs/disk-io.c     |   1 +
 fs/btrfs/qgroup.c      | 130 +++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/qgroup.h      |  99 +++++++++++++++++++++++++++++++
 fs/btrfs/relocation.c  |   7 +++
 fs/btrfs/transaction.c |   1 +
 6 files changed, 252 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index a669fa1bda7b..f7ab20901bc3 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1198,6 +1198,17 @@ enum {
 	BTRFS_ROOT_DEAD_RELOC_TREE,
 };
 
+/*
+ * Record swapped tree blocks of a file/subvolume tree for delayed subtree
+ * trace code. For detail check comment in fs/btrfs/qgroup.c.
+ */
+struct btrfs_qgroup_swapped_blocks {
+	spinlock_t lock;
+	struct rb_root blocks[BTRFS_MAX_LEVEL];
+	/* RM_EMPTY_ROOT() of above blocks[] */
+	bool swapped;
+};
+
 /*
  * in ram representation of the tree.  extent_root is used for all allocations
  * and for the extent tree extent_root root.
@@ -1325,6 +1336,9 @@ struct btrfs_root {
 	/* Number of active swapfiles */
 	atomic_t nr_swapfiles;
 
+	/* Record pairs of swapped blocks for qgroup */
+	struct btrfs_qgroup_swapped_blocks swapped_blocks;
+
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 	u64 alloc_bytenr;
 #endif
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8da2f380d3c0..0163887e2e4a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1218,6 +1218,7 @@ static void __setup_root(struct btrfs_root *root, struct btrfs_fs_info *fs_info,
 	root->anon_dev = 0;
 
 	spin_lock_init(&root->root_item_lock);
+	btrfs_qgroup_init_swapped_blocks(&root->swapped_blocks);
 }
 
 static struct btrfs_root *btrfs_alloc_root(struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 8fe6ebe9aef8..cb45640b05d1 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3797,3 +3797,133 @@ void btrfs_qgroup_check_reserved_leak(struct inode *inode)
 	}
 	extent_changeset_release(&changeset);
 }
+
+/*
+ * Delete all swapped blocks record of @root.
+ * Every record here means we skipped a full subtree scan for qgroup.
+ *
+ * Get called when commit one transaction.
+ */
+void btrfs_qgroup_clean_swapped_blocks(struct btrfs_root *root)
+{
+	struct btrfs_qgroup_swapped_blocks *swapped_blocks;
+	int i;
+
+	swapped_blocks = &root->swapped_blocks;
+
+	spin_lock(&swapped_blocks->lock);
+	if (!swapped_blocks->swapped)
+		goto out;
+	for (i = 0; i < BTRFS_MAX_LEVEL; i++) {
+		struct rb_root *cur_root = &swapped_blocks->blocks[i];
+		struct btrfs_qgroup_swapped_block *entry;
+		struct btrfs_qgroup_swapped_block *next;
+
+		rbtree_postorder_for_each_entry_safe(entry, next, cur_root,
+						     node)
+			kfree(entry);
+		swapped_blocks->blocks[i] = RB_ROOT;
+	}
+	swapped_blocks->swapped = false;
+out:
+	spin_unlock(&swapped_blocks->lock);
+}
+
+/*
+ * Adding subtree roots record into @file_root.
+ *
+ * @file_root:		tree root of the file tree get swapped
+ * @bg:			block group under balance
+ * @file_parent/slot:	pointer to the subtree root in file tree
+ * @reloc_parent/slot:	pointer to the subtree root in reloc tree
+ *			BOTH POINTERS ARE BEFORE TREE SWAP
+ * @last_snapshot:	last snapshot generation of the file tree
+ */
+int btrfs_qgroup_add_swapped_blocks(struct btrfs_trans_handle *trans,
+		struct btrfs_root *file_root,
+		struct btrfs_block_group_cache *bg,
+		struct extent_buffer *file_parent, int file_slot,
+		struct extent_buffer *reloc_parent, int reloc_slot,
+		u64 last_snapshot)
+{
+	int level = btrfs_header_level(file_parent) - 1;
+	struct btrfs_qgroup_swapped_blocks *blocks = &file_root->swapped_blocks;
+	struct btrfs_fs_info *fs_info = file_root->fs_info;
+	struct btrfs_qgroup_swapped_block *block;
+	struct rb_node **p = &blocks->blocks[level].rb_node;
+	struct rb_node *parent = NULL;
+	int ret = 0;
+
+	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags))
+		return 0;
+
+	if (btrfs_node_ptr_generation(file_parent, file_slot) >
+		btrfs_node_ptr_generation(reloc_parent, reloc_slot)) {
+		btrfs_err_rl(fs_info,
+		"%s: bad parameter order, file_gen=%llu reloc_gen=%llu",
+			__func__,
+			btrfs_node_ptr_generation(file_parent, file_slot),
+			btrfs_node_ptr_generation(reloc_parent, reloc_slot));
+		return -EUCLEAN;
+	}
+
+	block = kmalloc(sizeof(*block), GFP_NOFS);
+	if (!block) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/*
+	 * @reloc_parent/slot is still *BEFORE* swap, while @block is going to
+	 * record the bytenr *AFTER* swap, so we do the swap here.
+	 */
+	block->file_bytenr = btrfs_node_blockptr(reloc_parent, reloc_slot);
+	block->file_generation = btrfs_node_ptr_generation(reloc_parent,
+							   reloc_slot);
+	block->reloc_bytenr = btrfs_node_blockptr(file_parent, file_slot);
+	block->reloc_generation = btrfs_node_ptr_generation(file_parent,
+							    file_slot);
+	block->last_snapshot = last_snapshot;
+	block->level = level;
+	if (bg->flags & BTRFS_BLOCK_GROUP_DATA)
+		block->trace_leaf = true;
+	else
+		block->trace_leaf = false;
+	btrfs_node_key_to_cpu(reloc_parent, &block->first_key, reloc_slot);
+
+	/* Insert @block into @blocks */
+	spin_lock(&blocks->lock);
+	while (*p) {
+		struct btrfs_qgroup_swapped_block *entry;
+
+		parent = *p;
+		entry = rb_entry(parent, struct btrfs_qgroup_swapped_block,
+				 node);
+
+		if (entry->file_bytenr < block->file_bytenr)
+			p = &(*p)->rb_left;
+		else if (entry->file_bytenr > block->file_bytenr)
+			p = &(*p)->rb_right;
+		else {
+			if (entry->file_generation != block->file_generation ||
+			    entry->reloc_bytenr != block->reloc_bytenr ||
+			    entry->reloc_generation !=
+			    block->reloc_generation) {
+				WARN_ON_ONCE(1);
+				ret = -EEXIST;
+			}
+			kfree(block);
+			goto out_unlock;
+		}
+	}
+	rb_link_node(&block->node, parent, p);
+	rb_insert_color(&block->node, &blocks->blocks[level]);
+	blocks->swapped = true;
+out_unlock:
+	spin_unlock(&blocks->lock);
+out:
+	if (ret < 0)
+		fs_info->qgroup_flags |=
+			BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
+	return ret;
+}
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 226956f0bd73..b190997ea7cd 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -6,6 +6,8 @@
 #ifndef BTRFS_QGROUP_H
 #define BTRFS_QGROUP_H
 
+#include <linux/spinlock.h>
+#include <linux/rbtree.h>
 #include "ulist.h"
 #include "delayed-ref.h"
 
@@ -37,6 +39,66 @@
  *    Normally at qgroup rescan and transaction commit time.
  */
 
+/*
+ * Special performance hack for balance.
+ *
+ * For balance, we need to swap subtree of file and reloc tree.
+ * In theory, we need to trace all subtree blocks of both file and reloc tree,
+ * since their owner has changed during such swap.
+ *
+ * However since balance has ensured that both subtrees are containing the
+ * same contents and have the same tree structures, such swap won't cause
+ * qgroup number change.
+ *
+ * But there is a race window between subtree swap and transaction commit,
+ * during that window, if we increase/decrease tree level or merge/split tree
+ * blocks, we still needs to trace original subtrees.
+ *
+ * So for balance, we use a delayed subtree trace, whose workflow is:
+ *
+ * 1) Record the subtree root block get swapped.
+ *
+ *    During subtree swap:
+ *    O = Old tree blocks
+ *    N = New tree blocks
+ *          reloc tree                         file tree X
+ *             Root                               Root
+ *            /    \                             /    \
+ *          NA     OB                          OA      OB
+ *        /  |     |  \                      /  |      |  \
+ *      NC  ND     OE  OF                   OC  OD     OE  OF
+ *
+ *   In these case, NA and OA is going to be swapped, record (NA, OA) into
+ *   file tree X.
+ *
+ * 2) After subtree swap.
+ *          reloc tree                         file tree X
+ *             Root                               Root
+ *            /    \                             /    \
+ *          OA     OB                          NA      OB
+ *        /  |     |  \                      /  |      |  \
+ *      OC  OD     OE  OF                   NC  ND     OE  OF
+ *
+ * 3a) CoW happens for OB
+ *     If we are going to CoW tree block OB, we check OB's bytenr against
+ *     tree X's swapped_blocks structure.
+ *     It doesn't fit any one, nothing will happen.
+ *
+ * 3b) CoW happens for NA
+ *     Check NA's bytenr against tree X's swapped_blocks, and get a hit.
+ *     Then we do subtree scan on both subtree OA and NA.
+ *     Resulting 6 tree blocks to be scanned (OA, OC, OD, NA, NC, ND).
+ *
+ *     Then no matter what we do to file tree X, qgroup numbers will
+ *     still be correct.
+ *     Then NA's record get removed from X's swapped_blocks.
+ *
+ * 4)  Transaction commit
+ *     Any record in X's swapped_blocks get removed, since there is no
+ *     modification to swapped subtrees, no need to trigger heavy qgroup
+ *     subtree rescan for them.
+ */
+
 /*
  * Record a dirty extent, and info qgroup to update quota on it
  * TODO: Use kmem cache to alloc it.
@@ -59,6 +121,24 @@ struct btrfs_qgroup_extent_record {
 	struct ulist *old_roots;
 };
 
+struct btrfs_qgroup_swapped_block {
+	struct rb_node node;
+
+	bool trace_leaf;
+	int level;
+
+	/* bytenr/generation of the tree block in file tree after swap */
+	u64 file_bytenr;
+	u64 file_generation;
+
+	/* bytenr/generation of the tree block in reloc tree after swap */
+	u64 reloc_bytenr;
+	u64 reloc_generation;
+
+	u64 last_snapshot;
+	struct btrfs_key first_key;
+};
+
 /*
  * Qgroup reservation types:
  *
@@ -301,4 +381,23 @@ void btrfs_qgroup_convert_reserved_meta(struct btrfs_root *root, int num_bytes);
 
 void btrfs_qgroup_check_reserved_leak(struct inode *inode);
 
+/* btrfs_qgroup_swapped_blocks related functions */
+static inline void btrfs_qgroup_init_swapped_blocks(
+		struct btrfs_qgroup_swapped_blocks *swapped_blocks)
+{
+	int i;
+
+	spin_lock_init(&swapped_blocks->lock);
+	for (i = 0; i < BTRFS_MAX_LEVEL; i++)
+		swapped_blocks->blocks[i] = RB_ROOT;
+	swapped_blocks->swapped = false;
+}
+
+void btrfs_qgroup_clean_swapped_blocks(struct btrfs_root *root);
+int btrfs_qgroup_add_swapped_blocks(struct btrfs_trans_handle *trans,
+		struct btrfs_root *file_root,
+		struct btrfs_block_group_cache *bg,
+		struct extent_buffer *file_parent, int file_slot,
+		struct extent_buffer *reloc_parent, int reloc_slot,
+		u64 last_snapshot);
 #endif
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 8109c28c2ecc..9b8a15e90ab0 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1913,6 +1913,13 @@ int replace_path(struct btrfs_trans_handle *trans, struct reloc_control *rc,
 		if (ret < 0)
 			break;
 
+		btrfs_node_key_to_cpu(parent, &first_key, slot);
+		ret = btrfs_qgroup_add_swapped_blocks(trans, dest,
+				rc->block_group, parent, slot,
+				path->nodes[level], path->slots[level],
+				last_snapshot);
+		if (ret < 0)
+			break;
 		/*
 		 * swap blocks in fs tree and reloc tree.
 		 */
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 127fa1535f58..22b0dacae003 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -122,6 +122,7 @@ static noinline void switch_commit_roots(struct btrfs_transaction *trans)
 		if (is_fstree(root->root_key.objectid))
 			btrfs_unpin_free_ino(root);
 		clear_btree_io_tree(&root->dirty_log_pages);
+		btrfs_qgroup_clean_swapped_blocks(root);
 	}
 
 	/* We can free old roots now. */
-- 
2.20.1

