Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:7564 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751369AbdCCJ2y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Mar 2017 04:28:54 -0500
From: Elena Reshetova <elena.reshetova@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        peterz@infradead.org, gregkh@linuxfoundation.org, jbacik@fb.com,
        clm@fb.com, dsterba@suse.com,
        Elena Reshetova <elena.reshetova@intel.com>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>
Subject: [PATCH 07/17] fs, btrfs: convert btrfs_delayed_node.refs from atomic_t to refcount_t
Date: Fri,  3 Mar 2017 10:55:16 +0200
Message-Id: <1488531326-21271-8-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1488531326-21271-1-git-send-email-elena.reshetova@intel.com>
References: <1488531326-21271-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 fs/btrfs/delayed-inode.c | 28 ++++++++++++++--------------
 fs/btrfs/delayed-inode.h |  3 ++-
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 1aff676..7396c36 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -52,7 +52,7 @@ static inline void btrfs_init_delayed_node(
 {
 	delayed_node->root = root;
 	delayed_node->inode_id = inode_id;
-	atomic_set(&delayed_node->refs, 0);
+	refcount_set(&delayed_node->refs, 0);
 	delayed_node->ins_root = RB_ROOT;
 	delayed_node->del_root = RB_ROOT;
 	mutex_init(&delayed_node->mutex);
@@ -81,7 +81,7 @@ static struct btrfs_delayed_node *btrfs_get_delayed_node(
 
 	node = READ_ONCE(btrfs_inode->delayed_node);
 	if (node) {
-		atomic_inc(&node->refs);
+		refcount_inc(&node->refs);
 		return node;
 	}
 
@@ -89,14 +89,14 @@ static struct btrfs_delayed_node *btrfs_get_delayed_node(
 	node = radix_tree_lookup(&root->delayed_nodes_tree, ino);
 	if (node) {
 		if (btrfs_inode->delayed_node) {
-			atomic_inc(&node->refs);	/* can be accessed */
+			refcount_inc(&node->refs);	/* can be accessed */
 			BUG_ON(btrfs_inode->delayed_node != node);
 			spin_unlock(&root->inode_lock);
 			return node;
 		}
 		btrfs_inode->delayed_node = node;
 		/* can be accessed and cached in the inode */
-		atomic_add(2, &node->refs);
+		refcount_add(2, &node->refs);
 		spin_unlock(&root->inode_lock);
 		return node;
 	}
@@ -125,7 +125,7 @@ static struct btrfs_delayed_node *btrfs_get_or_create_delayed_node(
 	btrfs_init_delayed_node(node, root, ino);
 
 	/* cached in the btrfs inode and can be accessed */
-	atomic_add(2, &node->refs);
+	refcount_set(&node->refs, 2);
 
 	ret = radix_tree_preload(GFP_NOFS);
 	if (ret) {
@@ -166,7 +166,7 @@ static void btrfs_queue_delayed_node(struct btrfs_delayed_root *root,
 	} else {
 		list_add_tail(&node->n_list, &root->node_list);
 		list_add_tail(&node->p_list, &root->prepare_list);
-		atomic_inc(&node->refs);	/* inserted into list */
+		refcount_inc(&node->refs);	/* inserted into list */
 		root->nodes++;
 		set_bit(BTRFS_DELAYED_NODE_IN_LIST, &node->flags);
 	}
@@ -180,7 +180,7 @@ static void btrfs_dequeue_delayed_node(struct btrfs_delayed_root *root,
 	spin_lock(&root->lock);
 	if (test_bit(BTRFS_DELAYED_NODE_IN_LIST, &node->flags)) {
 		root->nodes--;
-		atomic_dec(&node->refs);	/* not in the list */
+		refcount_dec(&node->refs);	/* not in the list */
 		list_del_init(&node->n_list);
 		if (!list_empty(&node->p_list))
 			list_del_init(&node->p_list);
@@ -201,7 +201,7 @@ static struct btrfs_delayed_node *btrfs_first_delayed_node(
 
 	p = delayed_root->node_list.next;
 	node = list_entry(p, struct btrfs_delayed_node, n_list);
-	atomic_inc(&node->refs);
+	refcount_inc(&node->refs);
 out:
 	spin_unlock(&delayed_root->lock);
 
@@ -228,7 +228,7 @@ static struct btrfs_delayed_node *btrfs_next_delayed_node(
 		p = node->n_list.next;
 
 	next = list_entry(p, struct btrfs_delayed_node, n_list);
-	atomic_inc(&next->refs);
+	refcount_inc(&next->refs);
 out:
 	spin_unlock(&delayed_root->lock);
 
@@ -253,11 +253,11 @@ static void __btrfs_release_delayed_node(
 		btrfs_dequeue_delayed_node(delayed_root, delayed_node);
 	mutex_unlock(&delayed_node->mutex);
 
-	if (atomic_dec_and_test(&delayed_node->refs)) {
+	if (refcount_dec_and_test(&delayed_node->refs)) {
 		bool free = false;
 		struct btrfs_root *root = delayed_node->root;
 		spin_lock(&root->inode_lock);
-		if (atomic_read(&delayed_node->refs) == 0) {
+		if (refcount_read(&delayed_node->refs) == 0) {
 			radix_tree_delete(&root->delayed_nodes_tree,
 					  delayed_node->inode_id);
 			free = true;
@@ -286,7 +286,7 @@ static struct btrfs_delayed_node *btrfs_first_prepared_delayed_node(
 	p = delayed_root->prepare_list.next;
 	list_del_init(p);
 	node = list_entry(p, struct btrfs_delayed_node, p_list);
-	atomic_inc(&node->refs);
+	refcount_inc(&node->refs);
 out:
 	spin_unlock(&delayed_root->lock);
 
@@ -1621,7 +1621,7 @@ bool btrfs_readdir_get_delayed_items(struct inode *inode,
 	 * insert/delete delayed items in this period. So we also needn't
 	 * requeue or dequeue this delayed node.
 	 */
-	atomic_dec(&delayed_node->refs);
+	refcount_dec(&delayed_node->refs);
 
 	return true;
 }
@@ -1963,7 +1963,7 @@ void btrfs_kill_all_delayed_nodes(struct btrfs_root *root)
 		inode_id = delayed_nodes[n - 1]->inode_id + 1;
 
 		for (i = 0; i < n; i++)
-			atomic_inc(&delayed_nodes[i]->refs);
+			refcount_inc(&delayed_nodes[i]->refs);
 		spin_unlock(&root->inode_lock);
 
 		for (i = 0; i < n; i++) {
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index 40327cc..d234974 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -26,6 +26,7 @@
 #include <linux/list.h>
 #include <linux/wait.h>
 #include <linux/atomic.h>
+#include <linux/refcount.h>
 
 #include "ctree.h"
 
@@ -67,7 +68,7 @@ struct btrfs_delayed_node {
 	struct rb_root del_root;
 	struct mutex mutex;
 	struct btrfs_inode_item inode_item;
-	atomic_t refs;
+	refcount_t refs;
 	u64 index_cnt;
 	unsigned long flags;
 	int count;
-- 
2.7.4

