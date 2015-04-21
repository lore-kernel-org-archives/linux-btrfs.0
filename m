Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39263 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752005AbbDUGVq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Apr 2015 02:21:46 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t3L6KVvq025413
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Apr 2015 14:20:31 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 08/18] btrfs: qgroup: Record possible quota-related extent for qgroup.
Date: Tue, 21 Apr 2015 14:21:24 +0800
Message-ID: <1429597294-11875-9-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1429597294-11875-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1429597294-11875-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add hook in add_delayed_ref_head() to record quota-related extent record
into delayed_ref_root->dirty_extent_record rb-tree for later qgroup
accounting.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/delayed-ref.c | 58 ++++++++++++++++++++++++++++++++++++++++++++------
 fs/btrfs/delayed-ref.h |  3 +++
 fs/btrfs/qgroup.c      | 26 ++++++++++++++++++++++
 fs/btrfs/qgroup.h      | 17 +++++++++++++++
 fs/btrfs/transaction.c |  1 +
 5 files changed, 98 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 197f45b..72de81e 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -22,6 +22,7 @@
 #include "ctree.h"
 #include "delayed-ref.h"
 #include "transaction.h"
+#include "qgroup.h"
 
 struct kmem_cache *btrfs_delayed_ref_head_cachep;
 struct kmem_cache *btrfs_delayed_tree_ref_cachep;
@@ -405,12 +406,14 @@ update_existing_head_ref(struct btrfs_delayed_ref_node *existing,
 static noinline struct btrfs_delayed_ref_head *
 add_delayed_ref_head(struct btrfs_fs_info *fs_info,
 		     struct btrfs_trans_handle *trans,
-		     struct btrfs_delayed_ref_node *ref, u64 bytenr,
-		     u64 num_bytes, int action, int is_data)
+		     struct btrfs_delayed_ref_node *ref,
+		     struct btrfs_qgroup_extent_record *qrecord,
+		     u64 bytenr, u64 num_bytes, int action, int is_data)
 {
 	struct btrfs_delayed_ref_head *existing;
 	struct btrfs_delayed_ref_head *head_ref = NULL;
 	struct btrfs_delayed_ref_root *delayed_refs;
+	struct btrfs_qgroup_extent_record *qexisting;
 	int count_mod = 1;
 	int must_insert_reserved = 0;
 
@@ -458,6 +461,18 @@ add_delayed_ref_head(struct btrfs_fs_info *fs_info,
 	INIT_LIST_HEAD(&head_ref->ref_list);
 	head_ref->processing = 0;
 
+	/* Record qgroup extent info if provided */
+	if (qrecord) {
+		qrecord->bytenr = bytenr;
+		qrecord->num_bytes = num_bytes;
+		qrecord->old_roots = NULL;
+
+		qexisting = btrfs_qgroup_insert_dirty_extent(delayed_refs,
+							     qrecord);
+		if (qexisting)
+			kfree(qrecord);
+	}
+
 	spin_lock_init(&head_ref->lock);
 	mutex_init(&head_ref->mutex);
 
@@ -606,6 +621,7 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 	struct btrfs_delayed_tree_ref *ref;
 	struct btrfs_delayed_ref_head *head_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
+	struct btrfs_qgroup_extent_record *record = NULL;
 
 	if (!is_fstree(ref_root) || !fs_info->quota_enabled)
 		no_quota = 0;
@@ -621,6 +637,15 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 		return -ENOMEM;
 	}
 
+	if (is_fstree(ref_root)) {
+		record = kmalloc(sizeof(*record), GFP_NOFS);
+		if (!record) {
+			kmem_cache_free(btrfs_delayed_tree_ref_cachep, ref);
+			kmem_cache_free(btrfs_delayed_ref_head_cachep, ref);
+			return -ENOMEM;
+		}
+	}
+
 	head_ref->extent_op = extent_op;
 
 	delayed_refs = &trans->transaction->delayed_refs;
@@ -630,7 +655,7 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 	 * insert both the head node and the new ref without dropping
 	 * the spin lock
 	 */
-	head_ref = add_delayed_ref_head(fs_info, trans, &head_ref->node,
+	head_ref = add_delayed_ref_head(fs_info, trans, &head_ref->node, record,
 					bytenr, num_bytes, action, 0);
 
 	add_delayed_tree_ref(fs_info, trans, head_ref, &ref->node, bytenr,
@@ -655,6 +680,7 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	struct btrfs_delayed_data_ref *ref;
 	struct btrfs_delayed_ref_head *head_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
+	struct btrfs_qgroup_extent_record *record = NULL;
 
 	if (!is_fstree(ref_root) || !fs_info->quota_enabled)
 		no_quota = 0;
@@ -670,6 +696,16 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 		return -ENOMEM;
 	}
 
+	if (is_fstree(ref_root)) {
+		record = kmalloc(sizeof(*record), GFP_NOFS);
+		if (!record) {
+			kmem_cache_free(btrfs_delayed_data_ref_cachep, ref);
+			kmem_cache_free(btrfs_delayed_ref_head_cachep,
+					head_ref);
+			return -ENOMEM;
+		}
+	}
+
 	head_ref->extent_op = extent_op;
 
 	delayed_refs = &trans->transaction->delayed_refs;
@@ -679,7 +715,7 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	 * insert both the head node and the new ref without dropping
 	 * the spin lock
 	 */
-	head_ref = add_delayed_ref_head(fs_info, trans, &head_ref->node,
+	head_ref = add_delayed_ref_head(fs_info, trans, &head_ref->node, record,
 					bytenr, num_bytes, action, 1);
 
 	add_delayed_data_ref(fs_info, trans, head_ref, &ref->node, bytenr,
@@ -697,19 +733,27 @@ int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
 {
 	struct btrfs_delayed_ref_head *head_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
+	struct btrfs_qgroup_extent_record *record;
 
 	head_ref = kmem_cache_alloc(btrfs_delayed_ref_head_cachep, GFP_NOFS);
 	if (!head_ref)
 		return -ENOMEM;
 
+	/* TODO: Skip this for non-fs tree root and quota disabled case */
+	record = kmalloc(sizeof(*record), GFP_NOFS);
+	if (!record) {
+		kmem_cache_free(btrfs_delayed_ref_head_cachep, head_ref);
+		return -ENOMEM;
+	}
+
 	head_ref->extent_op = extent_op;
 
 	delayed_refs = &trans->transaction->delayed_refs;
 	spin_lock(&delayed_refs->lock);
 
-	add_delayed_ref_head(fs_info, trans, &head_ref->node, bytenr,
-				   num_bytes, BTRFS_UPDATE_DELAYED_HEAD,
-				   extent_op->is_data);
+	add_delayed_ref_head(fs_info, trans, &head_ref->node, record, bytenr,
+			     num_bytes, BTRFS_UPDATE_DELAYED_HEAD,
+			     extent_op->is_data);
 
 	spin_unlock(&delayed_refs->lock);
 	return 0;
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index a5f6a66..6481de2 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -140,6 +140,9 @@ struct btrfs_delayed_ref_root {
 	/* head ref rbtree */
 	struct rb_root href_root;
 
+	/* dirty extent records */
+	struct rb_root dirty_extent_root;
+
 	/* this spin lock protects the rbtree and the entries inside */
 	spinlock_t lock;
 
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index a780f8f..505f6f3 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1403,6 +1403,32 @@ int btrfs_qgroup_record_ref(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
+struct btrfs_qgroup_extent_record
+*btrfs_qgroup_insert_dirty_extent(struct btrfs_delayed_ref_root *delayed_refs,
+				  struct btrfs_qgroup_extent_record *record)
+{
+	struct rb_node **p = &delayed_refs->dirty_extent_root.rb_node;
+	struct rb_node *parent_node = NULL;
+	struct btrfs_qgroup_extent_record *entry;
+	u64 bytenr = record->bytenr;
+
+	while (*p) {
+		parent_node = *p;
+		entry = rb_entry(parent_node, struct btrfs_qgroup_extent_record,
+				 node);
+		if (bytenr < entry->bytenr)
+			p = &(*p)->rb_left;
+		else if (bytenr > entry->bytenr)
+			p = &(*p)->rb_right;
+		else
+			return entry;
+	}
+
+	rb_link_node(&record->node, parent_node, p);
+	rb_insert_color(&record->node, &delayed_refs->dirty_extent_root);
+	return NULL;
+}
+
 /*
  * The easy accounting, if we are adding/removing the only ref for an extent
  * then this qgroup and all of the parent qgroups get their refrence and
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 18cc68c..7754d08 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -19,6 +19,9 @@
 #ifndef __BTRFS_QGROUP__
 #define __BTRFS_QGROUP__
 
+#include "ulist.h"
+#include "delayed-ref.h"
+
 /*
  * A description of the operations, all of these operations only happen when we
  * are adding the 1st reference for that subvolume in the case of adding space
@@ -58,6 +61,17 @@ struct btrfs_qgroup_operation {
 	struct list_head list;
 };
 
+/*
+ * Record a dirty extent, and info qgroup to update quota on it
+ * TODO: Use kmem cache to alloc it.
+ */
+struct btrfs_qgroup_extent_record {
+	struct rb_node node;
+	u64 bytenr;
+	u64 num_bytes;
+	struct ulist *old_roots;
+};
+
 int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 		       struct btrfs_fs_info *fs_info);
 int btrfs_quota_disable(struct btrfs_trans_handle *trans,
@@ -85,6 +99,9 @@ int btrfs_qgroup_record_ref(struct btrfs_trans_handle *trans,
 			    u64 bytenr, u64 num_bytes,
 			    enum btrfs_qgroup_operation_type type,
 			    int mod_seq);
+struct btrfs_qgroup_extent_record
+*btrfs_qgroup_insert_dirty_extent(struct btrfs_delayed_ref_root *delayed_refs,
+				  struct btrfs_qgroup_extent_record *record);
 int btrfs_delayed_qgroup_accounting(struct btrfs_trans_handle *trans,
 				    struct btrfs_fs_info *fs_info);
 void btrfs_remove_qgroup_operation(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 8be4278..871b405 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -224,6 +224,7 @@ loop:
 	cur_trans->start_time = get_seconds();
 
 	cur_trans->delayed_refs.href_root = RB_ROOT;
+	cur_trans->delayed_refs.dirty_extent_root = RB_ROOT;
 	atomic_set(&cur_trans->delayed_refs.num_entries, 0);
 	cur_trans->delayed_refs.num_heads_ready = 0;
 	cur_trans->delayed_refs.num_heads = 0;
-- 
2.3.5

