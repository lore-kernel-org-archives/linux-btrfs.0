Return-Path: <SRS0=zk84=PP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6823FC43174
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Jan 2019 05:42:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 429D220854
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Jan 2019 05:42:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbfAGFmU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 7 Jan 2019 00:42:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:52740 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725300AbfAGFmU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 Jan 2019 00:42:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 987EDAD4C
        for <linux-btrfs@vger.kernel.org>; Mon,  7 Jan 2019 05:42:18 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v3.1 7/7] btrfs: qgroup: Cleanup old subtree swap code
Date:   Mon,  7 Jan 2019 13:41:51 +0800
Message-Id: <20190107054151.18662-8-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190107054151.18662-1-wqu@suse.com>
References: <20190107054151.18662-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Since it's replaced by new delayed subtree swap code, remove the
original code.

The cleanup is small since most of its core function is still used by
delayed subtree swap trace.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c | 94 -----------------------------------------------
 fs/btrfs/qgroup.h |  6 ---
 2 files changed, 100 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 4aedf17b7e55..f16de81c7732 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2048,100 +2048,6 @@ static int qgroup_trace_subtree_swap(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-/*
- * Inform qgroup to trace subtree swap used in balance.
- *
- * Unlike btrfs_qgroup_trace_subtree(), this function will only trace
- * new tree blocks whose generation is equal to (or larger than) @last_snapshot.
- *
- * Will go down the tree block pointed by @dst_eb (pointed by @dst_parent and
- * @dst_slot), and find any tree blocks whose generation is at @last_snapshot,
- * and then go down @src_eb (pointed by @src_parent and @src_slot) to find
- * the counterpart of the tree block, then mark both tree blocks as qgroup dirty,
- * and skip all tree blocks whose generation is smaller than last_snapshot.
- *
- * This would skip tons of tree blocks of original btrfs_qgroup_trace_subtree(),
- * which could be the cause of very slow balance if the file tree is large.
- *
- * @src_parent, @src_slot: pointer to src (file tree) eb.
- * @dst_parent, @dst_slot: pointer to dst (reloc tree) eb.
- */
-int btrfs_qgroup_trace_subtree_swap(struct btrfs_trans_handle *trans,
-				struct btrfs_block_group_cache *bg_cache,
-				struct extent_buffer *src_parent, int src_slot,
-				struct extent_buffer *dst_parent, int dst_slot,
-				u64 last_snapshot)
-{
-	struct btrfs_fs_info *fs_info = trans->fs_info;
-	struct btrfs_key first_key;
-	struct extent_buffer *src_eb = NULL;
-	struct extent_buffer *dst_eb = NULL;
-	bool trace_leaf = false;
-	u64 child_gen;
-	u64 child_bytenr;
-	int ret;
-
-	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags))
-		return 0;
-
-	/* Check parameter order */
-	if (btrfs_node_ptr_generation(src_parent, src_slot) >
-	    btrfs_node_ptr_generation(dst_parent, dst_slot)) {
-		btrfs_err_rl(fs_info,
-		"%s: bad parameter order, src_gen=%llu dst_gen=%llu", __func__,
-			btrfs_node_ptr_generation(src_parent, src_slot),
-			btrfs_node_ptr_generation(dst_parent, dst_slot));
-		return -EUCLEAN;
-	}
-
-	/*
-	 * Only trace leaf if we're relocating data block groups, this could
-	 * reduce tons of data extents tracing for meta/sys bg relocation.
-	 */
-	if (bg_cache->flags & BTRFS_BLOCK_GROUP_DATA)
-		trace_leaf = true;
-	/* Read out real @src_eb, pointed by @src_parent and @src_slot */
-	child_bytenr = btrfs_node_blockptr(src_parent, src_slot);
-	child_gen = btrfs_node_ptr_generation(src_parent, src_slot);
-	btrfs_node_key_to_cpu(src_parent, &first_key, src_slot);
-
-	src_eb = read_tree_block(fs_info, child_bytenr, child_gen,
-			btrfs_header_level(src_parent) - 1, &first_key);
-	if (IS_ERR(src_eb)) {
-		ret = PTR_ERR(src_eb);
-		goto out;
-	}
-
-	/* Read out real @dst_eb, pointed by @src_parent and @src_slot */
-	child_bytenr = btrfs_node_blockptr(dst_parent, dst_slot);
-	child_gen = btrfs_node_ptr_generation(dst_parent, dst_slot);
-	btrfs_node_key_to_cpu(dst_parent, &first_key, dst_slot);
-
-	dst_eb = read_tree_block(fs_info, child_bytenr, child_gen,
-			btrfs_header_level(dst_parent) - 1, &first_key);
-	if (IS_ERR(dst_eb)) {
-		ret = PTR_ERR(dst_eb);
-		goto out;
-	}
-
-	if (!extent_buffer_uptodate(src_eb) || !extent_buffer_uptodate(dst_eb)) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	/* Do the generation aware breadth-first search */
-	ret = qgroup_trace_subtree_swap(trans, src_eb, dst_eb, last_snapshot,
-					trace_leaf);
-	if (ret < 0)
-		goto out;
-	ret = 0;
-
-out:
-	free_extent_buffer(src_eb);
-	free_extent_buffer(dst_eb);
-	return ret;
-}
-
 int btrfs_qgroup_trace_subtree(struct btrfs_trans_handle *trans,
 			       struct extent_buffer *root_eb,
 			       u64 root_gen, int root_level)
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 285b70ed4c75..a35be351fb5c 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -301,12 +301,6 @@ int btrfs_qgroup_trace_leaf_items(struct btrfs_trans_handle *trans,
 int btrfs_qgroup_trace_subtree(struct btrfs_trans_handle *trans,
 			       struct extent_buffer *root_eb,
 			       u64 root_gen, int root_level);
-
-int btrfs_qgroup_trace_subtree_swap(struct btrfs_trans_handle *trans,
-				struct btrfs_block_group_cache *bg_cache,
-				struct extent_buffer *src_parent, int src_slot,
-				struct extent_buffer *dst_parent, int dst_slot,
-				u64 last_snapshot);
 int btrfs_qgroup_account_extent(struct btrfs_trans_handle *trans, u64 bytenr,
 				u64 num_bytes, struct ulist *old_roots,
 				struct ulist *new_roots);
-- 
2.20.1

