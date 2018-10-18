Return-Path: <SRS0=wNEY=M6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0E61C5ACCC
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 11:17:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0B8B2087A
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 11:17:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A0B8B2087A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbeJRTSQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Oct 2018 15:18:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:42904 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727668AbeJRTSQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Oct 2018 15:18:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2C87AAD18
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Oct 2018 11:17:41 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 3/6] btrfs: qgroup: Refactor btrfs_qgroup_trace_subtree_swap()
Date:   Thu, 18 Oct 2018 19:17:26 +0800
Message-Id: <20181018111729.11128-4-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181018111729.11128-1-wqu@suse.com>
References: <20181018111729.11128-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Refactor btrfs_qgroup_trace_subtree_swap() into
qgroup_trace_subtree_swap(), which only needs two extent buffer and some
other bool to control the behavior.

Also, allow depending functions to accept parameter @exec_post to
determine whether we need to trigger backref walk.

This provides the basis for later delayed subtree scan work.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c | 101 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 70 insertions(+), 31 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index aaa3657266b0..e40d5991c438 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1756,7 +1756,7 @@ static int qgroup_trace_extent_swap(struct btrfs_trans_handle* trans,
 				    struct extent_buffer *src_eb,
 				    struct btrfs_path *dst_path,
 				    int dst_level, int root_level,
-				    bool trace_leaf)
+				    bool trace_leaf, bool exec_post)
 {
 	struct btrfs_key key;
 	struct btrfs_path *src_path;
@@ -1847,23 +1847,23 @@ static int qgroup_trace_extent_swap(struct btrfs_trans_handle* trans,
 	 * Now both @dst_path and @src_path have been populated, record the tree
 	 * blocks for qgroup accounting.
 	 */
-	ret = btrfs_qgroup_trace_extent(trans,
-			src_path->nodes[dst_level]->start,
-			nodesize, GFP_NOFS);
+	ret = qgroup_trace_extent(trans, src_path->nodes[dst_level]->start,
+				  nodesize, GFP_NOFS, exec_post);
 	if (ret < 0)
 		goto out;
-	ret = btrfs_qgroup_trace_extent(trans,
-			dst_path->nodes[dst_level]->start,
-			nodesize, GFP_NOFS);
+	ret = qgroup_trace_extent(trans, dst_path->nodes[dst_level]->start,
+				  nodesize, GFP_NOFS, exec_post);
 	if (ret < 0)
 		goto out;
 
 	/* Record leaf file extents */
 	if (dst_level == 0 && trace_leaf) {
-		ret = btrfs_qgroup_trace_leaf_items(trans, src_path->nodes[0]);
+		ret = qgroup_trace_leaf_items(trans, src_path->nodes[0],
+					      exec_post);
 		if (ret < 0)
 			goto out;
-		ret = btrfs_qgroup_trace_leaf_items(trans, dst_path->nodes[0]);
+		ret = qgroup_trace_leaf_items(trans, dst_path->nodes[0],
+					      exec_post);
 	}
 out:
 	btrfs_free_path(src_path);
@@ -1896,7 +1896,8 @@ static int qgroup_trace_new_subtree_blocks(struct btrfs_trans_handle* trans,
 					   struct extent_buffer *src_eb,
 					   struct btrfs_path *dst_path,
 					   int cur_level, int root_level,
-					   u64 last_snapshot, bool trace_leaf)
+					   u64 last_snapshot, bool trace_leaf,
+					   bool exec_post)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct extent_buffer *eb;
@@ -1968,7 +1969,7 @@ static int qgroup_trace_new_subtree_blocks(struct btrfs_trans_handle* trans,
 
 	/* Now record this tree block and its counter part for qgroups */
 	ret = qgroup_trace_extent_swap(trans, src_eb, dst_path, cur_level,
-				       root_level, trace_leaf);
+				       root_level, trace_leaf, exec_post);
 	if (ret < 0)
 		goto cleanup;
 
@@ -1985,7 +1986,7 @@ static int qgroup_trace_new_subtree_blocks(struct btrfs_trans_handle* trans,
 			/* Recursive call (at most 7 times) */
 			ret = qgroup_trace_new_subtree_blocks(trans, src_eb,
 					dst_path, cur_level - 1, root_level,
-					last_snapshot, trace_leaf);
+					last_snapshot, trace_leaf, exec_post);
 			if (ret < 0)
 				goto cleanup;
 		}
@@ -2005,6 +2006,61 @@ static int qgroup_trace_new_subtree_blocks(struct btrfs_trans_handle* trans,
 	return ret;
 }
 
+static int qgroup_trace_subtree_swap(struct btrfs_trans_handle *trans,
+				struct extent_buffer *src_eb,
+				struct extent_buffer *dst_eb,
+				u64 last_snapshot, bool trace_leaf,
+				bool exec_post)
+{
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct btrfs_path *dst_path = NULL;
+	int level;
+	int ret;
+
+	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags))
+		return 0;
+
+	/* Wrong parameter order */
+	if (btrfs_header_generation(src_eb) > btrfs_header_generation(dst_eb)) {
+		btrfs_err_rl(fs_info,
+		"%s: bad parameter order, src_gen=%llu dst_gen=%llu", __func__,
+			     btrfs_header_generation(src_eb),
+			     btrfs_header_generation(dst_eb));
+		return -EUCLEAN;
+	}
+
+	if (!extent_buffer_uptodate(src_eb) || !extent_buffer_uptodate(dst_eb)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	level = btrfs_header_level(dst_eb);
+	dst_path = btrfs_alloc_path();
+	if (!dst_path) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	/* For dst_path */
+	extent_buffer_get(dst_eb);
+	dst_path->nodes[level] = dst_eb;
+	dst_path->slots[level] = 0;
+	dst_path->locks[level] = 0;
+
+	/* Do the generation aware breadth-first search */
+	ret = qgroup_trace_new_subtree_blocks(trans, src_eb, dst_path, level,
+					      level, last_snapshot, trace_leaf,
+					      exec_post);
+	if (ret < 0)
+		goto out;
+	ret = 0;
+
+out:
+	btrfs_free_path(dst_path);
+	if (ret < 0)
+		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
+	return ret;
+}
+
 /*
  * Inform qgroup to trace subtree swap used in balance.
  *
@@ -2030,14 +2086,12 @@ int btrfs_qgroup_trace_subtree_swap(struct btrfs_trans_handle *trans,
 				u64 last_snapshot)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
-	struct btrfs_path *dst_path = NULL;
 	struct btrfs_key first_key;
 	struct extent_buffer *src_eb = NULL;
 	struct extent_buffer *dst_eb = NULL;
 	bool trace_leaf = false;
 	u64 child_gen;
 	u64 child_bytenr;
-	int level;
 	int ret;
 
 	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags))
@@ -2088,21 +2142,9 @@ int btrfs_qgroup_trace_subtree_swap(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
-	level = btrfs_header_level(dst_eb);
-	dst_path = btrfs_alloc_path();
-	if (!dst_path) {
-		ret = -ENOMEM;
-		goto out;
-	}
-	/* For dst_path */
-	extent_buffer_get(dst_eb);
-	dst_path->nodes[level] = dst_eb;
-	dst_path->slots[level] = 0;
-	dst_path->locks[level] = 0;
-
 	/* Do the generation aware breadth-first search */
-	ret = qgroup_trace_new_subtree_blocks(trans, src_eb, dst_path, level,
-					      level, last_snapshot, trace_leaf);
+	ret = qgroup_trace_subtree_swap(trans, src_eb, dst_eb, last_snapshot,
+					trace_leaf, true);
 	if (ret < 0)
 		goto out;
 	ret = 0;
@@ -2110,9 +2152,6 @@ int btrfs_qgroup_trace_subtree_swap(struct btrfs_trans_handle *trans,
 out:
 	free_extent_buffer(src_eb);
 	free_extent_buffer(dst_eb);
-	btrfs_free_path(dst_path);
-	if (ret < 0)
-		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
 	return ret;
 }
 
-- 
2.19.1

