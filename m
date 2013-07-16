Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42524 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab3GPLDq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Jul 2013 07:03:46 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r6GB3jVj003220
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Jul 2013 11:03:46 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6GB3ive002460
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Jul 2013 11:03:45 GMT
Received: from abhmt102.oracle.com (abhmt102.oracle.com [141.146.116.54])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6GB3iig028761
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Jul 2013 11:03:44 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs/tracepoint: update delayed ref tracepoints
Date: Tue, 16 Jul 2013 19:03:36 +0800
Message-Id: <1373972616-4006-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This shows exactly how btrfs processes the delayed refs onto disks,
which is very helpful on understanding delayed ref mechanism and
debugging related bugs.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/delayed-ref.c       |    6 ++--
 fs/btrfs/extent-tree.c       |    6 ++++
 include/trace/events/btrfs.h |   60 +++++++++++++++++++++++++++++++++++++++--
 3 files changed, 66 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index c219463..f7be9f7 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -600,7 +600,7 @@ static noinline void add_delayed_ref_head(struct btrfs_fs_info *fs_info,
 	INIT_LIST_HEAD(&head_ref->cluster);
 	mutex_init(&head_ref->mutex);
 
-	trace_btrfs_delayed_ref_head(ref, head_ref, action);
+	trace_add_delayed_ref_head(ref, head_ref, action);
 
 	existing = tree_insert(&delayed_refs->root, &ref->rb_node);
 
@@ -661,7 +661,7 @@ static noinline void add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 		ref->type = BTRFS_TREE_BLOCK_REF_KEY;
 	full_ref->level = level;
 
-	trace_btrfs_delayed_tree_ref(ref, full_ref, action);
+	trace_add_delayed_tree_ref(ref, full_ref, action);
 
 	existing = tree_insert(&delayed_refs->root, &ref->rb_node);
 
@@ -722,7 +722,7 @@ static noinline void add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	full_ref->objectid = owner;
 	full_ref->offset = offset;
 
-	trace_btrfs_delayed_data_ref(ref, full_ref, action);
+	trace_add_delayed_data_ref(ref, full_ref, action);
 
 	existing = tree_insert(&delayed_refs->root, &ref->rb_node);
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 2796622..70002ea 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2022,6 +2022,8 @@ static int run_delayed_data_ref(struct btrfs_trans_handle *trans,
 	ins.type = BTRFS_EXTENT_ITEM_KEY;
 
 	ref = btrfs_delayed_node_to_data_ref(node);
+	trace_run_delayed_data_ref(node, ref, node->action);
+
 	if (node->type == BTRFS_SHARED_DATA_REF_KEY)
 		parent = ref->parent;
 	else
@@ -2165,6 +2167,8 @@ static int run_delayed_tree_ref(struct btrfs_trans_handle *trans,
 						 SKINNY_METADATA);
 
 	ref = btrfs_delayed_node_to_tree_ref(node);
+	trace_run_delayed_tree_ref(node, ref, node->action);
+
 	if (node->type == BTRFS_SHARED_BLOCK_REF_KEY)
 		parent = ref->parent;
 	else
@@ -2223,6 +2227,8 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 		 */
 		BUG_ON(extent_op);
 		head = btrfs_delayed_node_to_head(node);
+		trace_run_delayed_ref_head(node, head, node->action);
+
 		if (insert_reserved) {
 			btrfs_pin_extent(root, node->bytenr,
 					 node->num_bytes, 1);
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 2902657..45702c3 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -439,7 +439,7 @@ TRACE_EVENT(btrfs_sync_fs,
 		{ BTRFS_UPDATE_DELAYED_HEAD, "UPDATE_DELAYED_HEAD" })
 			
 
-TRACE_EVENT(btrfs_delayed_tree_ref,
+DECLARE_EVENT_CLASS(btrfs_delayed_tree_ref,
 
 	TP_PROTO(struct btrfs_delayed_ref_node *ref,
 		 struct btrfs_delayed_tree_ref *full_ref,
@@ -481,7 +481,25 @@ TRACE_EVENT(btrfs_delayed_tree_ref,
 		  (unsigned long long)__entry->seq)
 );
 
-TRACE_EVENT(btrfs_delayed_data_ref,
+DEFINE_EVENT(btrfs_delayed_tree_ref,  add_delayed_tree_ref,
+
+	TP_PROTO(struct btrfs_delayed_ref_node *ref,
+		 struct btrfs_delayed_tree_ref *full_ref,
+		 int action),
+
+	TP_ARGS(ref, full_ref, action)
+);
+
+DEFINE_EVENT(btrfs_delayed_tree_ref,  run_delayed_tree_ref,
+
+	TP_PROTO(struct btrfs_delayed_ref_node *ref,
+		 struct btrfs_delayed_tree_ref *full_ref,
+		 int action),
+
+	TP_ARGS(ref, full_ref, action)
+);
+
+DECLARE_EVENT_CLASS(btrfs_delayed_data_ref,
 
 	TP_PROTO(struct btrfs_delayed_ref_node *ref,
 		 struct btrfs_delayed_data_ref *full_ref,
@@ -527,7 +545,25 @@ TRACE_EVENT(btrfs_delayed_data_ref,
 		  (unsigned long long)__entry->seq)
 );
 
-TRACE_EVENT(btrfs_delayed_ref_head,
+DEFINE_EVENT(btrfs_delayed_data_ref,  add_delayed_data_ref,
+
+	TP_PROTO(struct btrfs_delayed_ref_node *ref,
+		 struct btrfs_delayed_data_ref *full_ref,
+		 int action),
+
+	TP_ARGS(ref, full_ref, action)
+);
+
+DEFINE_EVENT(btrfs_delayed_data_ref,  run_delayed_data_ref,
+
+	TP_PROTO(struct btrfs_delayed_ref_node *ref,
+		 struct btrfs_delayed_data_ref *full_ref,
+		 int action),
+
+	TP_ARGS(ref, full_ref, action)
+);
+
+DECLARE_EVENT_CLASS(btrfs_delayed_ref_head,
 
 	TP_PROTO(struct btrfs_delayed_ref_node *ref,
 		 struct btrfs_delayed_ref_head *head_ref,
@@ -556,6 +592,24 @@ TRACE_EVENT(btrfs_delayed_ref_head,
 		  __entry->is_data)
 );
 
+DEFINE_EVENT(btrfs_delayed_ref_head,  add_delayed_ref_head,
+
+	TP_PROTO(struct btrfs_delayed_ref_node *ref,
+		 struct btrfs_delayed_ref_head *head_ref,
+		 int action),
+
+	TP_ARGS(ref, head_ref, action)
+);
+
+DEFINE_EVENT(btrfs_delayed_ref_head,  run_delayed_ref_head,
+
+	TP_PROTO(struct btrfs_delayed_ref_node *ref,
+		 struct btrfs_delayed_ref_head *head_ref,
+		 int action),
+
+	TP_ARGS(ref, head_ref, action)
+);
+
 #define show_chunk_type(type)					\
 	__print_flags(type, "|",				\
 		{ BTRFS_BLOCK_GROUP_DATA, 	"DATA"	},	\
-- 
1.7.7

