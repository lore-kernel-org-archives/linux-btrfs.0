Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55282 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726274AbeIKKgw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 06:36:52 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 48361B08D
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 05:39:15 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 6/7] btrfs: delayed-ref: Introduce new parameter for btrfs_add_delayed_tree_ref() to reduce unnecessary qgroup tracing
Date: Tue, 11 Sep 2018 13:38:17 +0800
Message-Id: <20180911053818.10191-7-wqu@suse.com>
In-Reply-To: <20180911053818.10191-1-wqu@suse.com>
References: <20180911053818.10191-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For btrfs_add_delayed_tree_ref(), its ref_root parameter can be
different from its real root.
This is pretty common for reloc tree, in that case @ref_root is passed
as the original tree owner (source file tree).

However btrfs_add_delayed_tree_ref() uses @ref_root to determine whether
we should do heavy qgroup tracing for it, so for balance this could
cause a lot of unnecessary extent tracing.

This patch will introduce a parameter, @root for qgroup code to
determine whether we really need to do the heavy-lifting tracing work.

This patch would reduce the qgroup dirty extent number from 'number of
extents being relocated' to 0 for the transaction before real tree swap.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/delayed-ref.c |  5 +++--
 fs/btrfs/delayed-ref.h |  1 +
 fs/btrfs/extent-tree.c | 17 ++++++++++-------
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 62ff545ba1f7..7f681dd36e7f 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -710,8 +710,9 @@ static void init_delayed_ref_common(struct btrfs_fs_info *fs_info,
  * transaction commits.
  */
 int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *root,
 			       u64 bytenr, u64 num_bytes, u64 parent,
-			       u64 ref_root,  int level, int action,
+			       u64 ref_root, int level, int action,
 			       struct btrfs_delayed_extent_op *extent_op,
 			       int *old_ref_mod, int *new_ref_mod)
 {
@@ -737,7 +738,7 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 	}
 
 	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags) &&
-	    is_fstree(ref_root)) {
+	    is_fstree(root->root_key.objectid)) {
 		record = kmalloc(sizeof(*record), GFP_NOFS);
 		if (!record) {
 			kmem_cache_free(btrfs_delayed_tree_ref_cachep, ref);
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index d9f2a4ebd5db..a51560a3cb66 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -235,6 +235,7 @@ static inline void btrfs_put_delayed_ref_head(struct btrfs_delayed_ref_head *hea
 }
 
 int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *root,
 			       u64 bytenr, u64 num_bytes, u64 parent,
 			       u64 ref_root, int level, int action,
 			       struct btrfs_delayed_extent_op *extent_op,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4588153f414c..7a3c650b11f8 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2040,9 +2040,10 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 			   owner, offset, BTRFS_ADD_DELAYED_REF);
 
 	if (owner < BTRFS_FIRST_FREE_OBJECTID) {
-		ret = btrfs_add_delayed_tree_ref(trans, bytenr,
+		ret = btrfs_add_delayed_tree_ref(trans, root, bytenr,
 						 num_bytes, parent,
-						 root_objectid, (int)owner,
+						 root_objectid,
+						 (int)owner,
 						 BTRFS_ADD_DELAYED_REF, NULL,
 						 &old_ref_mod, &new_ref_mod);
 	} else {
@@ -6993,7 +6994,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 				   root->root_key.objectid,
 				   btrfs_header_level(buf), 0,
 				   BTRFS_DROP_DELAYED_REF);
-		ret = btrfs_add_delayed_tree_ref(trans, buf->start,
+		ret = btrfs_add_delayed_tree_ref(trans, root, buf->start,
 						 buf->len, parent,
 						 root->root_key.objectid,
 						 btrfs_header_level(buf),
@@ -7072,9 +7073,10 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 		old_ref_mod = new_ref_mod = 0;
 		ret = 0;
 	} else if (owner < BTRFS_FIRST_FREE_OBJECTID) {
-		ret = btrfs_add_delayed_tree_ref(trans, bytenr,
+		ret = btrfs_add_delayed_tree_ref(trans, root, bytenr,
 						 num_bytes, parent,
-						 root_objectid, (int)owner,
+						 root_objectid,
+						 (int)owner,
 						 BTRFS_DROP_DELAYED_REF, NULL,
 						 &old_ref_mod, &new_ref_mod);
 	} else {
@@ -8293,9 +8295,10 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 		btrfs_ref_tree_mod(root, ins.objectid, ins.offset, parent,
 				   root_objectid, level, 0,
 				   BTRFS_ADD_DELAYED_EXTENT);
-		ret = btrfs_add_delayed_tree_ref(trans, ins.objectid,
+		ret = btrfs_add_delayed_tree_ref(trans, root, ins.objectid,
 						 ins.offset, parent,
-						 root_objectid, level,
+						 root_objectid,
+						 level,
 						 BTRFS_ADD_DELAYED_EXTENT,
 						 extent_op, NULL, NULL);
 		if (ret)
-- 
2.18.0
