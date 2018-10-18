Return-Path: <SRS0=wNEY=M6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A51CEC5ACCC
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 11:17:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D4DA2087A
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 11:17:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6D4DA2087A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728163AbeJRTSV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Oct 2018 15:18:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:42928 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727668AbeJRTSV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Oct 2018 15:18:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8802FAD18
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Oct 2018 11:17:46 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 5/6] btrfs: qgroup: Use delayed subtree rescan for balance
Date:   Thu, 18 Oct 2018 19:17:28 +0800
Message-Id: <20181018111729.11128-6-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181018111729.11128-1-wqu@suse.com>
References: <20181018111729.11128-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Before this patch, qgroup code trace the whole subtree of file and reloc
trees unconditionally.

This makes qgroup numbers consistent, but it could cause tons of
unnecessary extent trace, which cause a lot of overhead.

However for subtree swap of balance, since both subtree contains the
same content and tree structures, just swap them won't change qgroup
numbers.

It's the race window between subtree swap and transaction commit could
cause qgroup number change.

This patch will delay the qgroup subtree scan until CoW happens for the
subtree root.

So if there is no other operations for the fs, balance won't cause extra
qgroup overhead. (best case scenario)
And depends on the workload, most of the subtree scan can still be
avoided.

Only for worst case scenario, it will fall back to old subtree swap
overhead. (scan all swapped subtrees)

[[Benchmark]]
Hardware:
	VM 4G vRAM, 8 vCPUs,
	disk is using 'unsafe' cache mode,
	backing device is SAMSUNG 850 evo SSD.
	Host has 16G ram.

Mkfs parameter:
	--nodesize 4K (To bump up tree size)

Initial subvolume contents:
	4G data copied from /usr and /lib.
	(With enough regular small files)

Snapshots:
	16 snapshots of the original subvolume.
	each snapshot has 3 random files modified.

balance parameter:
	-m

So the content should be pretty similar to a real world root fs layout.

And after file system population, there is no other activity, so it
should be the best case scenario.

                     | prev optimization(*) | w/ patchset    | diff
-----------------------------------------------------------------------
relocated extents    | 22958                | 22983          | +0.1%
qgroup dirty extents | 129282               | 54630          | -57.8%
time (sys)           | 37.807s              | 27.038s        | -28.5%
time (real)          | 45.446s              | 34.015s        | -25.2%

*: Previous submitted patch, titled
   "[PATCH v4 0/7] btrfs: qgroup: Reduce dirty extents for metadata".
   Still based on v4.19-rc1

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ctree.c      |  8 ++++
 fs/btrfs/qgroup.c     | 87 +++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/qgroup.h     |  2 +
 fs/btrfs/relocation.c | 14 +++----
 4 files changed, 102 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index d436fb4c002e..8891ea05cdf3 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -12,6 +12,7 @@
 #include "transaction.h"
 #include "print-tree.h"
 #include "locking.h"
+#include "qgroup.h"
 
 static int split_node(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, struct btrfs_path *path, int level);
@@ -1482,6 +1483,13 @@ noinline int btrfs_cow_block(struct btrfs_trans_handle *trans,
 		btrfs_set_lock_blocking(parent);
 	btrfs_set_lock_blocking(buf);
 
+	/*
+	 * Before CoWing this block for later modification, check if it's
+	 * the subtree root and do the delayed subtree trace if needed.
+	 *
+	 * Also We don't care about the error, as it's handled internally.
+	 */
+	btrfs_qgroup_trace_subtree_after_cow(trans, root, buf);
 	ret = __btrfs_cow_block(trans, root, buf, parent,
 				 parent_slot, cow_ret, search_start, 0);
 
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 146956fa8574..896711b1671a 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3937,3 +3937,90 @@ int btrfs_qgroup_add_swapped_blocks(struct btrfs_trans_handle *trans,
 			BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
 	return ret;
 }
+
+/*
+ * Check if the tree block is a subtree root, and if so do the needed
+ * delayed subtree trace for qgroup.
+ *
+ * This is called during btrfs_cow_block().
+ */
+int btrfs_qgroup_trace_subtree_after_cow(struct btrfs_trans_handle *trans,
+		struct btrfs_root *root, struct extent_buffer *file_eb)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_qgroup_swapped_blocks *blocks = &root->swapped_blocks;
+	struct btrfs_qgroup_swapped_block *block;
+	struct extent_buffer *reloc_eb = NULL;
+	struct rb_node *n;
+	bool found = false;
+	bool swapped = false;
+	int level = btrfs_header_level(file_eb);
+	int ret = 0;
+	int i;
+
+	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags))
+		return 0;
+	if (!is_fstree(root->root_key.objectid) || !root->reloc_root)
+		return 0;
+
+	spin_lock(&blocks->lock);
+	if (!blocks->swapped) {
+		spin_unlock(&blocks->lock);
+		goto out;
+	}
+	n = blocks->blocks[level].rb_node;
+
+	while (n) {
+		block = rb_entry(n, struct btrfs_qgroup_swapped_block, node);
+		if (block->file_bytenr < file_eb->start)
+			n = n->rb_left;
+		else if (block->file_bytenr > file_eb->start)
+			n = n->rb_right;
+		else {
+			found = true;
+			break;
+		}
+	}
+	if (!found) {
+		spin_unlock(&blocks->lock);
+		goto out;
+	}
+	/* Found one, remove it from @blocks first and update blocks->swapped */
+	rb_erase(&block->node, &blocks->blocks[level]);
+	for (i = 0; i < BTRFS_MAX_LEVEL; i++) {
+		if (RB_EMPTY_ROOT(&blocks->blocks[i])) {
+			swapped = true;
+			break;
+		}
+	}
+	blocks->swapped = swapped;
+	spin_unlock(&blocks->lock);
+
+	/* Read out reloc subtree root */
+	reloc_eb = read_tree_block(fs_info, block->reloc_bytenr,
+				   block->reloc_generation, block->level,
+				   &block->first_key);
+	if (IS_ERR(reloc_eb)) {
+		ret = PTR_ERR(file_eb);
+		reloc_eb = NULL;
+		goto free_out;
+	}
+	if (!extent_buffer_uptodate(reloc_eb)) {
+		ret = -EIO;
+		goto free_out;
+	}
+
+	ret = qgroup_trace_subtree_swap(trans, reloc_eb, file_eb,
+			block->last_snapshot, block->trace_leaf, false);
+free_out:
+	kfree(block);
+	free_extent_buffer(reloc_eb);
+out:
+	if (ret < 0) {
+		btrfs_err_rl(fs_info,
+			     "failed to account subtree at bytenr %llu: %d",
+			     file_eb->start, ret); 
+		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
+	}
+	return ret;
+}
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index fab6ca96f677..145787be3f70 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -422,4 +422,6 @@ int btrfs_qgroup_add_swapped_blocks(struct btrfs_trans_handle *trans,
 		struct extent_buffer *file_parent, int file_slot,
 		struct extent_buffer *reloc_parent, int reloc_slot,
 		u64 last_snapshot);
+int btrfs_qgroup_trace_subtree_after_cow(struct btrfs_trans_handle *trans,
+		struct btrfs_root *root, struct extent_buffer *eb);
 #endif
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 86b8d82b62d8..a308b4728b87 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1876,16 +1876,12 @@ int replace_path(struct btrfs_trans_handle *trans, struct reloc_control *rc,
 		 *    If not traced, we will leak data numbers
 		 * 2) Fs subtree
 		 *    If not traced, we will double count old data
-		 *    and tree block numbers, if current trans doesn't free
-		 *    data reloc tree inode.
+		 *
+		 * We don't scan the subtree right now, but only record
+		 * the swapped tree blocks.
+		 * The real subtree rescan is delayed until we have new
+		 * CoW on the subtree root node before transaction commit.
 		 */
-		ret = btrfs_qgroup_trace_subtree_swap(trans, rc->block_group,
-				parent, slot, path->nodes[level],
-				path->slots[level], last_snapshot);
-		if (ret < 0)
-			break;
-
-		btrfs_node_key_to_cpu(parent, &first_key, slot);
 		ret = btrfs_qgroup_add_swapped_blocks(trans, dest,
 				rc->block_group, parent, slot,
 				path->nodes[level], path->slots[level],
-- 
2.19.1

