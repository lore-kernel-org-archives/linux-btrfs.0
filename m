Return-Path: <SRS0=Zypw=MJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 819E7C43382
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 06:42:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41C372156D
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 06:42:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 41C372156D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbeI0M71 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Sep 2018 08:59:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:38026 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726698AbeI0M70 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Sep 2018 08:59:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 97988B124
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Sep 2018 06:42:44 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v4 2/7] btrfs: qgroup: Introduce function to trace two swaped extents
Date:   Thu, 27 Sep 2018 14:42:30 +0800
Message-Id: <20180927064235.7432-3-wqu@suse.com>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20180927064235.7432-1-wqu@suse.com>
References: <20180927064235.7432-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Introduce a new function, qgroup_trace_extent_swap(), which will be used
later for balance qgroup speedup.

The basis idea of balance is swapping tree blocks between reloc tree and
the real file tree.

The swap will happen in highest tree block, but there may be a lot of
tree blocks involved.

For example:
 OO = Old tree blocks
 NN = New tree blocks allocated during balance

          File tree (257)                  Reloc tree for 257
L2              OO                                NN
              /    \                            /    \
L1          OO      OO (a)                    OO      NN (a)
           / \     / \                       / \     / \
L0       OO   OO OO   OO                   OO   OO NN   NN
                 (b)  (c)                          (b)  (c)

When calling qgroup_trace_extent_swap(), we will pass:
@src_eb = OO(a)
@dst_path = [ nodes[1] = NN(a), nodes[0] = NN(c) ]
@dst_level = 0
@root_level = 1

In that case, qgroup_trace_extent_swap() will search from OO(a) to
reach OO(c), then mark both OO(c) and NN(c) as qgroup dirty.

The main work of qgroup_trace_extent_swap() can be split into 3 parts:

1) Tree search from @src_eb
   It should acts as a simplified btrfs_search_slot().
   The key for search can be extracted from @dst_path->nodes[dst_level]
   (first key).

2) Mark the final tree blocks in @src_path and @dst_path qgroup dirty
   NOTE: In above case, OO(a) and NN(a) won't be marked qgroup dirty.
   They should be marked during preivous (@dst_level = 1) iteration.

3) Mark file extents in leaves dirty
   We don't have good way to pick out new file extents only.
   So we still follow the old method by scanning all file extents in
   the leave.

This function can free us from keeping two pathes, thus later we only need
to care about how to iterate all new tree blocks in reloc tree.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c | 126 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 126 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 5977eedc00d8..5155fb42ce79 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1713,6 +1713,132 @@ static int adjust_slots_upwards(struct btrfs_path *path, int root_level)
 	return 0;
 }
 
+/*
+ * helper function to trace a subtree tree block swap.
+ *
+ * The swapped tree block is marked by @dst_path->nodes[level].
+ * Thus @dst_path should have been populated already.
+ *
+ * While for src tree block, we only need the root eb as @src_eb.
+ * The needed path and search will done by this function.
+ */
+static int qgroup_trace_extent_swap(struct btrfs_trans_handle* trans,
+				    struct extent_buffer *src_eb,
+				    struct btrfs_path *dst_path,
+				    int dst_level, int root_level)
+{
+	struct btrfs_key key;
+	struct btrfs_path *src_path;
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	u32 nodesize = fs_info->nodesize;
+	int cur_level = root_level;
+	int ret;
+
+	BUG_ON(dst_level > root_level);
+	/* Level mismatch */
+	if (btrfs_header_level(src_eb) != root_level)
+		return -EINVAL;
+
+	src_path = btrfs_alloc_path();
+	if (!src_path) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	if (dst_level)
+		btrfs_node_key_to_cpu(dst_path->nodes[dst_level], &key, 0);
+	else
+		btrfs_item_key_to_cpu(dst_path->nodes[dst_level], &key, 0);
+
+	/* For src_path */
+	extent_buffer_get(src_eb);
+	src_path->nodes[root_level] = src_eb;
+	src_path->slots[root_level] = dst_path->slots[root_level];
+	src_path->locks[root_level] = 0;
+
+	/* A simplified version of btrfs_search_slot() */
+	while (cur_level >= dst_level) {
+		struct btrfs_key src_key;
+		struct btrfs_key dst_key;
+
+		if (src_path->nodes[cur_level] == NULL) {
+			struct btrfs_key first_key;
+			struct extent_buffer *eb;
+			int parent_slot;
+			u64 child_gen;
+			u64 child_bytenr;
+
+			eb = src_path->nodes[cur_level + 1];
+			parent_slot = src_path->slots[cur_level + 1];
+			child_bytenr = btrfs_node_blockptr(eb, parent_slot);
+			child_gen = btrfs_node_ptr_generation(eb, parent_slot);
+			btrfs_node_key_to_cpu(eb, &first_key, parent_slot);
+
+			eb = read_tree_block(fs_info, child_bytenr, child_gen,
+					     cur_level, &first_key);
+			if (IS_ERR(eb)) {
+				ret = PTR_ERR(eb);
+				goto out;
+			} else if (!extent_buffer_uptodate(eb)) {
+				free_extent_buffer(eb);
+				ret = -EIO;
+				goto out;
+			}
+
+			src_path->nodes[cur_level] = eb;
+
+			btrfs_tree_read_lock(eb);
+			btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
+			src_path->locks[cur_level] = BTRFS_READ_LOCK_BLOCKING;
+		}
+
+		src_path->slots[cur_level] = dst_path->slots[cur_level];
+		if (cur_level) {
+			btrfs_node_key_to_cpu(dst_path->nodes[cur_level], &dst_key,
+					      dst_path->slots[cur_level]);
+			btrfs_node_key_to_cpu(src_path->nodes[cur_level], &src_key,
+					      src_path->slots[cur_level]);
+		} else {
+			btrfs_item_key_to_cpu(dst_path->nodes[cur_level], &dst_key,
+					      dst_path->slots[cur_level]);
+			btrfs_item_key_to_cpu(src_path->nodes[cur_level], &src_key,
+					      src_path->slots[cur_level]);
+		}
+		/* Content mismatch, something went wrong */
+		if (btrfs_comp_cpu_keys(&dst_key, &src_key)) {
+			ret = -ENOENT;
+			goto out;
+		}
+		cur_level--;
+	}
+
+	/*
+	 * Now both @dst_path and @src_path have been populated, record the tree
+	 * blocks for qgroup accounting.
+	 */
+	ret = btrfs_qgroup_trace_extent(trans,
+			src_path->nodes[dst_level]->start,
+			nodesize, GFP_NOFS);
+	if (ret < 0)
+		goto out;
+	ret = btrfs_qgroup_trace_extent(trans,
+			dst_path->nodes[dst_level]->start,
+			nodesize, GFP_NOFS);
+	if (ret < 0)
+		goto out;
+
+	/* Record leaf file extents */
+	if (dst_level == 0) {
+		ret = btrfs_qgroup_trace_leaf_items(trans, src_path->nodes[0]);
+		if (ret < 0)
+			goto out;
+		ret = btrfs_qgroup_trace_leaf_items(trans, dst_path->nodes[0]);
+	}
+out:
+	btrfs_free_path(src_path);
+	return ret;
+}
+
 int btrfs_qgroup_trace_subtree(struct btrfs_trans_handle *trans,
 			       struct extent_buffer *root_eb,
 			       u64 root_gen, int root_level)
-- 
2.19.0

