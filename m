Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:50964 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750895AbbDUGVo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Apr 2015 02:21:44 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t3L6KS6B025400
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Apr 2015 14:20:28 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 05/18] btrfs: extent-tree: Use ref_node to replace unneeded parameters in __inc_extent_ref() and __free_extent()
Date: Tue, 21 Apr 2015 14:21:21 +0800
Message-ID: <1429597294-11875-6-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1429597294-11875-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1429597294-11875-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

__btrfs_inc_extent_ref() and __btrfs_free_extent() have already had too
many parameters, but three of them can be extracted from
btrfs_delayed_ref_node struct.

So use btrfs_delayed_ref_node struct as a single parameter to replace
the bytenr/num_byte/no_quota parameters.

The real objective of this patch is to allow btrfs_qgroup_record_ref()
get the delayed_ref_node in incoming qgroup patches.

Other functions calling btrfs_qgroup_record_ref() are not affected since
the rest will only add/sub exclusive extents, where node is not used.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e0d3fcc..dd6e47e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -79,11 +79,10 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 			      u64 num_bytes, int alloc);
 static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
-				u64 bytenr, u64 num_bytes, u64 parent,
+				struct btrfs_delayed_ref_node *node, u64 parent,
 				u64 root_objectid, u64 owner_objectid,
 				u64 owner_offset, int refs_to_drop,
-				struct btrfs_delayed_extent_op *extra_op,
-				int no_quota);
+				struct btrfs_delayed_extent_op *extra_op);
 static void __run_delayed_extent_op(struct btrfs_delayed_extent_op *extent_op,
 				    struct extent_buffer *leaf,
 				    struct btrfs_extent_item *ei);
@@ -1967,10 +1966,9 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 
 static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 				  struct btrfs_root *root,
-				  u64 bytenr, u64 num_bytes,
+				  struct btrfs_delayed_ref_node *node,
 				  u64 parent, u64 root_objectid,
 				  u64 owner, u64 offset, int refs_to_add,
-				  int no_quota,
 				  struct btrfs_delayed_extent_op *extent_op)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
@@ -1978,8 +1976,11 @@ static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	struct extent_buffer *leaf;
 	struct btrfs_extent_item *item;
 	struct btrfs_key key;
+	u64 bytenr = node->bytenr;
+	u64 num_bytes = node->num_bytes;
 	u64 refs;
 	int ret;
+	int no_quota = node->no_quota;
 	enum btrfs_qgroup_operation_type type = BTRFS_QGROUP_OPER_ADD_EXCL;
 
 	path = btrfs_alloc_path();
@@ -2087,17 +2088,15 @@ static int run_delayed_data_ref(struct btrfs_trans_handle *trans,
 						 ref->objectid, ref->offset,
 						 &ins, node->ref_mod);
 	} else if (node->action == BTRFS_ADD_DELAYED_REF) {
-		ret = __btrfs_inc_extent_ref(trans, root, node->bytenr,
-					     node->num_bytes, parent,
+		ret = __btrfs_inc_extent_ref(trans, root, node, parent,
 					     ref_root, ref->objectid,
 					     ref->offset, node->ref_mod,
-					     node->no_quota, extent_op);
+					     extent_op);
 	} else if (node->action == BTRFS_DROP_DELAYED_REF) {
-		ret = __btrfs_free_extent(trans, root, node->bytenr,
-					  node->num_bytes, parent,
+		ret = __btrfs_free_extent(trans, root, node, parent,
 					  ref_root, ref->objectid,
 					  ref->offset, node->ref_mod,
-					  extent_op, node->no_quota);
+					  extent_op);
 	} else {
 		BUG();
 	}
@@ -2255,15 +2254,14 @@ static int run_delayed_tree_ref(struct btrfs_trans_handle *trans,
 						ref->level, &ins,
 						node->no_quota);
 	} else if (node->action == BTRFS_ADD_DELAYED_REF) {
-		ret = __btrfs_inc_extent_ref(trans, root, node->bytenr,
-					     node->num_bytes, parent, ref_root,
-					     ref->level, 0, 1, node->no_quota,
+		ret = __btrfs_inc_extent_ref(trans, root, node,
+					     parent, ref_root,
+					     ref->level, 0, 1,
 					     extent_op);
 	} else if (node->action == BTRFS_DROP_DELAYED_REF) {
-		ret = __btrfs_free_extent(trans, root, node->bytenr,
-					  node->num_bytes, parent, ref_root,
-					  ref->level, 0, 1, extent_op,
-					  node->no_quota);
+		ret = __btrfs_free_extent(trans, root, node,
+					  parent, ref_root,
+					  ref->level, 0, 1, extent_op);
 	} else {
 		BUG();
 	}
@@ -5806,11 +5804,10 @@ static void add_pinned_bytes(struct btrfs_fs_info *fs_info, u64 num_bytes,
 
 static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
-				u64 bytenr, u64 num_bytes, u64 parent,
+				struct btrfs_delayed_ref_node *node, u64 parent,
 				u64 root_objectid, u64 owner_objectid,
 				u64 owner_offset, int refs_to_drop,
-				struct btrfs_delayed_extent_op *extent_op,
-				int no_quota)
+				struct btrfs_delayed_extent_op *extent_op)
 {
 	struct btrfs_key key;
 	struct btrfs_path *path;
@@ -5824,8 +5821,11 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 	int extent_slot = 0;
 	int found_extent = 0;
 	int num_to_del = 1;
+	int no_quota = node->no_quota;
 	u32 item_size;
 	u64 refs;
+	u64 bytenr = node->bytenr;
+	u64 num_bytes = node->num_bytes;
 	int last_ref = 0;
 	enum btrfs_qgroup_operation_type type = BTRFS_QGROUP_OPER_SUB_EXCL;
 	bool skinny_metadata = btrfs_fs_incompat(root->fs_info,
-- 
2.3.5

