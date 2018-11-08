Return-Path: <SRS0=SsiO=NT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B267C32789
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 05:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C40AF20857
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 05:49:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C40AF20857
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbeKHPXS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 8 Nov 2018 10:23:18 -0500
Received: from mx2.suse.de ([195.135.220.15]:46112 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726363AbeKHPXS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Nov 2018 10:23:18 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 92C64AFBF
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Nov 2018 05:49:28 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/6] btrfs: qgroup: Refactor btrfs_qgroup_trace_subtree_swap()
Date:   Thu,  8 Nov 2018 13:49:15 +0800
Message-Id: <20181108054919.18253-4-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181108054919.18253-1-wqu@suse.com>
References: <20181108054919.18253-1-wqu@suse.com>
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
 fs/btrfs/qgroup.c | 104 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 72 insertions(+), 32 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 6c674ac29b90..c50c369d5f16 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1793,7 +1793,7 @@ static int qgroup_trace_extent_swap(struct btrfs_trans_handle* trans,
 				    struct extent_buffer *src_eb,
 				    struct btrfs_path *dst_path,
 				    int dst_level, int root_level,
-				    bool trace_leaf)
+				    bool trace_leaf, bool exec_post)
 {
 	struct btrfs_key key;
 	struct btrfs_path *src_path;
@@ -1884,22 +1884,23 @@ static int qgroup_trace_extent_swap(struct btrfs_trans_handle* trans,
 	 * Now both @dst_path and @src_path have been populated, record the tree
 	 * blocks for qgroup accounting.
 	 */
-	ret = btrfs_qgroup_trace_extent(trans, src_path->nodes[dst_level]->start,
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
@@ -1932,7 +1933,8 @@ static int qgroup_trace_new_subtree_blocks(struct btrfs_trans_handle* trans,
 					   struct extent_buffer *src_eb,
 					   struct btrfs_path *dst_path,
 					   int cur_level, int root_level,
-					   u64 last_snapshot, bool trace_leaf)
+					   u64 last_snapshot, bool trace_leaf,
+					   bool exec_post)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct extent_buffer *eb;
@@ -2004,7 +2006,7 @@ static int qgroup_trace_new_subtree_blocks(struct btrfs_trans_handle* trans,
 
 	/* Now record this tree block and its counter part for qgroups */
 	ret = qgroup_trace_extent_swap(trans, src_eb, dst_path, cur_level,
-				       root_level, trace_leaf);
+				       root_level, trace_leaf, exec_post);
 	if (ret < 0)
 		goto cleanup;
 
@@ -2021,7 +2023,7 @@ static int qgroup_trace_new_subtree_blocks(struct btrfs_trans_handle* trans,
 			/* Recursive call (at most 7 times) */
 			ret = qgroup_trace_new_subtree_blocks(trans, src_eb,
 					dst_path, cur_level - 1, root_level,
-					last_snapshot, trace_leaf);
+					last_snapshot, trace_leaf, exec_post);
 			if (ret < 0)
 				goto cleanup;
 		}
@@ -2041,6 +2043,62 @@ static int qgroup_trace_new_subtree_blocks(struct btrfs_trans_handle* trans,
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
+	if (!extent_buffer_uptodate(src_eb) ||
+	    !extent_buffer_uptodate(dst_eb)) {
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
@@ -2066,14 +2124,12 @@ int btrfs_qgroup_trace_subtree_swap(struct btrfs_trans_handle *trans,
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
@@ -2124,22 +2180,9 @@ int btrfs_qgroup_trace_subtree_swap(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
-	level = btrfs_header_level(dst_eb);
-	dst_path = btrfs_alloc_path();
-	if (!dst_path) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	/* For dst_path */
-	extent_buffer_get(dst_eb);
-	dst_path->nodes[level] = dst_eb;
-	dst_path->slots[level] = 0;
-	dst_path->locks[level] = 0;
-
-	/* Do the generation-aware breadth-first search */
-	ret = qgroup_trace_new_subtree_blocks(trans, src_eb, dst_path, level,
-					      level, last_snapshot, trace_leaf);
+	/* Do the generation aware breadth-first search */
+	ret = qgroup_trace_subtree_swap(trans, src_eb, dst_eb, last_snapshot,
+					trace_leaf, true);
 	if (ret < 0)
 		goto out;
 	ret = 0;
@@ -2147,9 +2190,6 @@ int btrfs_qgroup_trace_subtree_swap(struct btrfs_trans_handle *trans,
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

