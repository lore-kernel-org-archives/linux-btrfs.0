Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:47382 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab3EISex (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 May 2013 14:34:53 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 165FF7C065C
	for <linux-btrfs@vger.kernel.org>; Thu,  9 May 2013 12:34:53 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id rC3XlR5QaXYfgNuE (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 09 May 2013 12:34:52 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: handle running extent ops with skinny metadata V2
Date: Thu, 9 May 2013 14:34:50 -0400
Message-ID: <1368124490-4247-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris hit a bug where we weren't finding extent records when running extent ops.
This is because we use the delayed_ref_head when running the extent op, which
means we can't use the ->type checks to see if we are metadata.  We also lose
the level of the metadata we are working on.  So to fix this we can just check
the ->is_data section of the extent_op, and we can store the level of the buffer
we were modifying in the extent_op.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
V1->V2: Just store the level in the extent op, we may not have other delayed
refs for this bytenr which could screw us.

 fs/btrfs/ctree.c       |    4 +++-
 fs/btrfs/ctree.h       |    2 +-
 fs/btrfs/delayed-ref.h |    1 +
 fs/btrfs/extent-tree.c |   15 +++++++--------
 4 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index e625d00..17dffe33 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -951,10 +951,12 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 			BUG_ON(ret); /* -ENOMEM */
 		}
 		if (new_flags != 0) {
+			int level = btrfs_header_level(buf);
+
 			ret = btrfs_set_disk_extent_flags(trans, root,
 							  buf->start,
 							  buf->len,
-							  new_flags, 0);
+							  new_flags, level, 0);
 			if (ret)
 				return ret;
 		}
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index f415377..1ccc99c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3080,7 +3080,7 @@ int btrfs_dec_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 int btrfs_set_disk_extent_flags(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
 				u64 bytenr, u64 num_bytes, u64 flags,
-				int is_data);
+				int level, int is_data);
 int btrfs_free_extent(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root,
 		      u64 bytenr, u64 num_bytes, u64 parent, u64 root_objectid,
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index f75fcaf..70b962c 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -60,6 +60,7 @@ struct btrfs_delayed_ref_node {
 struct btrfs_delayed_extent_op {
 	struct btrfs_disk_key key;
 	u64 flags_to_set;
+	int level;
 	unsigned int update_key:1;
 	unsigned int update_flags:1;
 	unsigned int is_data:1;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 2305b5c..c4c94b3 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2070,8 +2070,7 @@ static int run_delayed_extent_op(struct btrfs_trans_handle *trans,
 	u32 item_size;
 	int ret;
 	int err = 0;
-	int metadata = (node->type == BTRFS_TREE_BLOCK_REF_KEY ||
-			node->type == BTRFS_SHARED_BLOCK_REF_KEY);
+	int metadata = !extent_op->is_data;
 
 	if (trans->aborted)
 		return 0;
@@ -2086,11 +2085,8 @@ static int run_delayed_extent_op(struct btrfs_trans_handle *trans,
 	key.objectid = node->bytenr;
 
 	if (metadata) {
-		struct btrfs_delayed_tree_ref *tree_ref;
-
-		tree_ref = btrfs_delayed_node_to_tree_ref(node);
 		key.type = BTRFS_METADATA_ITEM_KEY;
-		key.offset = tree_ref->level;
+		key.offset = extent_op->level;
 	} else {
 		key.type = BTRFS_EXTENT_ITEM_KEY;
 		key.offset = node->num_bytes;
@@ -2719,7 +2715,7 @@ out:
 int btrfs_set_disk_extent_flags(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
 				u64 bytenr, u64 num_bytes, u64 flags,
-				int is_data)
+				int level, int is_data)
 {
 	struct btrfs_delayed_extent_op *extent_op;
 	int ret;
@@ -2732,6 +2728,7 @@ int btrfs_set_disk_extent_flags(struct btrfs_trans_handle *trans,
 	extent_op->update_flags = 1;
 	extent_op->update_key = 0;
 	extent_op->is_data = is_data ? 1 : 0;
+	extent_op->level = level;
 
 	ret = btrfs_add_delayed_extent_op(root->fs_info, trans, bytenr,
 					  num_bytes, extent_op);
@@ -6763,6 +6760,7 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 			extent_op->update_key = 1;
 		extent_op->update_flags = 1;
 		extent_op->is_data = 0;
+		extent_op->level = level;
 
 		ret = btrfs_add_delayed_tree_ref(root->fs_info, trans,
 					ins.objectid,
@@ -6934,7 +6932,8 @@ static noinline int walk_down_proc(struct btrfs_trans_handle *trans,
 		ret = btrfs_dec_ref(trans, root, eb, 0, wc->for_reloc);
 		BUG_ON(ret); /* -ENOMEM */
 		ret = btrfs_set_disk_extent_flags(trans, root, eb->start,
-						  eb->len, flag, 0);
+						  eb->len, flag,
+						  btrfs_header_level(eb), 0);
 		BUG_ON(ret); /* -ENOMEM */
 		wc->flags[level] |= flag;
 	}
-- 
1.7.7.6

