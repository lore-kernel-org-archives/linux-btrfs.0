Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17887 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab3GaPiJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Jul 2013 11:38:09 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r6VFc7H9014404
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 31 Jul 2013 15:38:08 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6VFc6qB025144
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 31 Jul 2013 15:38:07 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6VFc6I4005980
	for <linux-btrfs@vger.kernel.org>; Wed, 31 Jul 2013 15:38:06 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH v5 3/5] Btrfs: introduce a head ref rbtree
Date: Wed, 31 Jul 2013 23:37:43 +0800
Message-Id: <1375285066-14173-4-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1375285066-14173-1-git-send-email-bo.li.liu@oracle.com>
References: <1375285066-14173-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The way how we process delayed refs is
1)get a bunch of head refs,
2)pick up one head ref,
3)go one node back for any delayed ref updates.

The head ref is also linked in the same rbtree as the delayed ref is,
so in 1) stage, we have to walk one by one including not only head refs, but
delayed refs.

When we have a great number of delayed refs pending to process,
this'll cost time a lot.

Here we introduce a head ref specific rbtree, it only has head refs, so troubles
go away.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/delayed-ref.c |  124 ++++++++++++++++++++++++++++--------------------
 fs/btrfs/delayed-ref.h |    5 ++
 fs/btrfs/disk-io.c     |    3 +
 fs/btrfs/extent-tree.c |   21 +++++---
 fs/btrfs/transaction.c |    4 +-
 5 files changed, 98 insertions(+), 59 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 15ca775..8aad3fb 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -161,35 +161,61 @@ static struct btrfs_delayed_ref_node *tree_insert(struct rb_root *root,
 	return NULL;
 }
 
+/* insert a new ref to head ref rbtree */
+static struct btrfs_delayed_ref_head *htree_insert(struct rb_root *root,
+						   struct rb_node *node)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent_node = NULL;
+	struct btrfs_delayed_ref_head *entry;
+	struct btrfs_delayed_ref_head *ins;
+	u64 bytenr;
+
+	ins = rb_entry(node, struct btrfs_delayed_ref_head, href_node);
+	bytenr = ins->node.bytenr;
+	while (*p) {
+		parent_node = *p;
+		entry = rb_entry(parent_node, struct btrfs_delayed_ref_head,
+				 href_node);
+
+		if (bytenr < entry->node.bytenr)
+			p = &(*p)->rb_left;
+		else if (bytenr > entry->node.bytenr)
+			p = &(*p)->rb_right;
+		else
+			return entry;
+	}
+
+	rb_link_node(node, parent_node, p);
+	rb_insert_color(node, root);
+	return NULL;
+}
+
 /*
  * find an head entry based on bytenr. This returns the delayed ref
  * head if it was able to find one, or NULL if nothing was in that spot.
  * If return_bigger is given, the next bigger entry is returned if no exact
  * match is found.
  */
-static struct btrfs_delayed_ref_node *find_ref_head(struct rb_root *root,
-				  u64 bytenr,
-				  struct btrfs_delayed_ref_node **last,
-				  int return_bigger)
+static struct btrfs_delayed_ref_head *
+find_ref_head(struct rb_root *root, u64 bytenr,
+	      struct btrfs_delayed_ref_head **last, int return_bigger)
 {
 	struct rb_node *n;
-	struct btrfs_delayed_ref_node *entry;
+	struct btrfs_delayed_ref_head *entry;
 	int cmp = 0;
 
 again:
 	n = root->rb_node;
 	entry = NULL;
 	while (n) {
-		entry = rb_entry(n, struct btrfs_delayed_ref_node, rb_node);
-		WARN_ON(!entry->in_tree);
+		entry = rb_entry(n, struct btrfs_delayed_ref_head, href_node);
 		if (last)
 			*last = entry;
 
-		if (bytenr < entry->bytenr)
+		if (bytenr < entry->node.bytenr)
 			cmp = -1;
-		else if (bytenr > entry->bytenr)
-			cmp = 1;
-		else if (!btrfs_delayed_ref_is_head(entry))
+		else if (bytenr > entry->node.bytenr)
 			cmp = 1;
 		else
 			cmp = 0;
@@ -203,12 +229,12 @@ again:
 	}
 	if (entry && return_bigger) {
 		if (cmp > 0) {
-			n = rb_next(&entry->rb_node);
+			n = rb_next(&entry->href_node);
 			if (!n)
 				n = rb_first(root);
-			entry = rb_entry(n, struct btrfs_delayed_ref_node,
-					 rb_node);
-			bytenr = entry->bytenr;
+			entry = rb_entry(n, struct btrfs_delayed_ref_head,
+					 href_node);
+			bytenr = entry->node.bytenr;
 			return_bigger = 0;
 			goto again;
 		}
@@ -246,6 +272,12 @@ static void inline drop_delayed_ref(struct btrfs_trans_handle *trans,
 				    struct btrfs_delayed_ref_node *ref)
 {
 	rb_erase(&ref->rb_node, &delayed_refs->root);
+	if (btrfs_delayed_ref_is_head(ref)) {
+		struct btrfs_delayed_ref_head *head;
+
+		head = btrfs_delayed_node_to_head(ref);
+		rb_erase(&head->href_node, &delayed_refs->href_root);
+	}
 	ref->in_tree = 0;
 	btrfs_put_delayed_ref(ref);
 	delayed_refs->num_entries--;
@@ -386,42 +418,35 @@ int btrfs_find_ref_cluster(struct btrfs_trans_handle *trans,
 	int count = 0;
 	struct btrfs_delayed_ref_root *delayed_refs;
 	struct rb_node *node;
-	struct btrfs_delayed_ref_node *ref;
-	struct btrfs_delayed_ref_head *head;
+	struct btrfs_delayed_ref_head *head = NULL;
 
 	delayed_refs = &trans->transaction->delayed_refs;
-	if (start == 0) {
-		node = rb_first(&delayed_refs->root);
-	} else {
-		ref = NULL;
-		find_ref_head(&delayed_refs->root, start + 1, &ref, 1);
-		if (ref) {
-			node = &ref->rb_node;
-		} else
-			node = rb_first(&delayed_refs->root);
+	node = rb_first(&delayed_refs->href_root);
+
+	if (start) {
+		find_ref_head(&delayed_refs->href_root, start + 1, &head, 1);
+		if (head)
+			node = &head->href_node;
 	}
 again:
 	while (node && count < 32) {
-		ref = rb_entry(node, struct btrfs_delayed_ref_node, rb_node);
-		if (btrfs_delayed_ref_is_head(ref)) {
-			head = btrfs_delayed_node_to_head(ref);
-			if (list_empty(&head->cluster)) {
-				list_add_tail(&head->cluster, cluster);
-				delayed_refs->run_delayed_start =
-					head->node.bytenr;
-				count++;
+		head = rb_entry(node, struct btrfs_delayed_ref_head, href_node);
+		if (list_empty(&head->cluster)) {
+			list_add_tail(&head->cluster, cluster);
+			delayed_refs->run_delayed_start =
+				head->node.bytenr;
+			count++;
 
-				WARN_ON(delayed_refs->num_heads_ready == 0);
-				delayed_refs->num_heads_ready--;
-			} else if (count) {
-				/* the goal of the clustering is to find extents
-				 * that are likely to end up in the same extent
-				 * leaf on disk.  So, we don't want them spread
-				 * all over the tree.  Stop now if we've hit
-				 * a head that was already in use
-				 */
-				break;
-			}
+			WARN_ON(delayed_refs->num_heads_ready == 0);
+			delayed_refs->num_heads_ready--;
+		} else if (count) {
+			/* the goal of the clustering is to find extents
+			 * that are likely to end up in the same extent
+			 * leaf on disk.  So, we don't want them spread
+			 * all over the tree.  Stop now if we've hit
+			 * a head that was already in use
+			 */
+			break;
 		}
 		node = rb_next(node);
 	}
@@ -433,7 +458,7 @@ again:
 		 * clusters.  start from the beginning and try again
 		 */
 		start = 0;
-		node = rb_first(&delayed_refs->root);
+		node = rb_first(&delayed_refs->href_root);
 		goto again;
 	}
 	return 1;
@@ -629,6 +654,7 @@ static noinline void add_delayed_ref_head(struct btrfs_fs_info *fs_info,
 		 */
 		kmem_cache_free(btrfs_delayed_ref_head_cachep, head_ref);
 	} else {
+		htree_insert(&delayed_refs->href_root, &head_ref->href_node);
 		delayed_refs->num_heads++;
 		delayed_refs->num_heads_ready++;
 		delayed_refs->num_entries++;
@@ -886,14 +912,10 @@ int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
 struct btrfs_delayed_ref_head *
 btrfs_find_delayed_ref_head(struct btrfs_trans_handle *trans, u64 bytenr)
 {
-	struct btrfs_delayed_ref_node *ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
 
 	delayed_refs = &trans->transaction->delayed_refs;
-	ref = find_ref_head(&delayed_refs->root, bytenr, NULL, 0);
-	if (ref)
-		return btrfs_delayed_node_to_head(ref);
-	return NULL;
+	return find_ref_head(&delayed_refs->href_root, bytenr, NULL, 0);
 }
 
 void btrfs_delayed_ref_exit(void)
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index 9377b27..6a0295b 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -83,6 +83,8 @@ struct btrfs_delayed_ref_head {
 
 	struct list_head cluster;
 
+	struct rb_node href_node;
+
 	struct btrfs_delayed_extent_op *extent_op;
 
 	int add_cnt;
@@ -121,6 +123,9 @@ struct btrfs_delayed_data_ref {
 struct btrfs_delayed_ref_root {
 	struct rb_root root;
 
+	/* head ref rbtree */
+	struct rb_root href_root;
+
 	/* this spin lock protects the rbtree and the entries inside */
 	spinlock_t lock;
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3c2886c..b6d597a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3793,6 +3793,9 @@ int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 
 		ref->in_tree = 0;
 		rb_erase(&ref->rb_node, &delayed_refs->root);
+		if (head)
+			rb_erase(&head->href_node, &delayed_refs->href_root);
+
 		delayed_refs->num_entries--;
 		spin_unlock(&delayed_refs->lock);
 		if (head) {
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f40f0d9..10a5c72 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2418,6 +2418,11 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
 
 		ref->in_tree = 0;
 		rb_erase(&ref->rb_node, &delayed_refs->root);
+		if (btrfs_delayed_ref_is_head(ref)) {
+			BUG_ON(!locked_ref);
+			rb_erase(&locked_ref->href_node,
+				 &delayed_refs->href_root);
+		}
 		delayed_refs->num_entries--;
 		if (!btrfs_delayed_ref_is_head(ref)) {
 			/*
@@ -2619,7 +2624,7 @@ int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 {
 	struct rb_node *node;
 	struct btrfs_delayed_ref_root *delayed_refs;
-	struct btrfs_delayed_ref_node *ref;
+	struct btrfs_delayed_ref_head *head;
 	struct list_head cluster;
 	int ret;
 	u64 delayed_start;
@@ -2749,18 +2754,19 @@ again:
 			spin_lock(&delayed_refs->lock);
 		}
 
-		node = rb_first(&delayed_refs->root);
+		node = rb_first(&delayed_refs->href_root);
 		if (!node)
 			goto out;
 		count = (unsigned long)-1;
 
 		while (node) {
-			ref = rb_entry(node, struct btrfs_delayed_ref_node,
-				       rb_node);
-			if (btrfs_delayed_ref_is_head(ref)) {
-				struct btrfs_delayed_ref_head *head;
+			head = rb_entry(node, struct btrfs_delayed_ref_head,
+					href_node);
+			BUG_ON(!btrfs_delayed_ref_is_head(&head->node));
+			{
+				struct btrfs_delayed_ref_node *ref;
 
-				head = btrfs_delayed_node_to_head(ref);
+				ref = &head->node;
 				atomic_inc(&ref->refs);
 
 				spin_unlock(&delayed_refs->lock);
@@ -5898,6 +5904,7 @@ static noinline int check_ref_cleanup(struct btrfs_trans_handle *trans,
 	 */
 	head->node.in_tree = 0;
 	rb_erase(&head->node.rb_node, &delayed_refs->root);
+	rb_erase(&head->href_node, &delayed_refs->href_root);
 
 	delayed_refs->num_entries--;
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index d58cce7..db0dd41 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -62,7 +62,8 @@ static void put_transaction(struct btrfs_transaction *transaction)
 	WARN_ON(atomic_read(&transaction->use_count) == 0);
 	if (atomic_dec_and_test(&transaction->use_count)) {
 		BUG_ON(!list_empty(&transaction->list));
-		WARN_ON(transaction->delayed_refs.root.rb_node);
+		WARN_ON(!RB_EMPTY_ROOT(&transaction->delayed_refs.root));
+		WARN_ON(!RB_EMPTY_ROOT(&transaction->delayed_refs.href_root));
 		while (!list_empty(&transaction->pending_chunks)) {
 			struct extent_map *em;
 
@@ -184,6 +185,7 @@ loop:
 	cur_trans->start_time = get_seconds();
 
 	cur_trans->delayed_refs.root = RB_ROOT;
+	cur_trans->delayed_refs.href_root = RB_ROOT;
 	cur_trans->delayed_refs.num_entries = 0;
 	cur_trans->delayed_refs.num_heads_ready = 0;
 	cur_trans->delayed_refs.num_heads = 0;
-- 
1.7.7

