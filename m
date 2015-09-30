Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:40349 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932444AbbI3K34 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Sep 2015 06:29:56 -0400
Received: from /spool/local
	by e23smtp06.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 30 Sep 2015 20:29:54 +1000
Received: from d23relay06.au.ibm.com (d23relay06.au.ibm.com [9.185.63.219])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id 199093578052
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2015 20:29:52 +1000 (EST)
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay06.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8UATeH243647116
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2015 20:29:48 +1000
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8UATIVf023726
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2015 20:29:19 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, jbacik@fb.com, clm@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, quwenruo@cn.fujitsu.com,
        chandan@mykolab.com
Subject: [PATCH V5 07/13] Btrfs: Use (eb->start, seq) as search key for tree modification log
Date: Wed, 30 Sep 2015 15:58:26 +0530
Message-Id: <1443608912-31667-8-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1443608912-31667-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1443608912-31667-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In subpagesize-blocksize a page can map multiple extent buffers and hence
using (page index, seq) as the search key is incorrect. For example, searching
through tree modification log tree can return an entry associated with the
first extent buffer mapped by the page (if such an entry exists), when we are
actually searching for entries associated with extent buffers that are mapped
at position 2 or more in the page.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/ctree.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 5f745ea..719ed3c 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -311,7 +311,7 @@ struct tree_mod_root {
 
 struct tree_mod_elem {
 	struct rb_node node;
-	u64 index;		/* shifted logical */
+	u64 logical;
 	u64 seq;
 	enum mod_log_op op;
 
@@ -435,11 +435,11 @@ void btrfs_put_tree_mod_seq(struct btrfs_fs_info *fs_info,
 
 /*
  * key order of the log:
- *       index -> sequence
+ *       node/leaf start address -> sequence
  *
- * the index is the shifted logical of the *new* root node for root replace
- * operations, or the shifted logical of the affected block for all other
- * operations.
+ * The 'start address' is the logical address of the *new* root node
+ * for root replace operations, or the logical address of the affected
+ * block for all other operations.
  *
  * Note: must be called with write lock (tree_mod_log_write_lock).
  */
@@ -460,9 +460,9 @@ __tree_mod_log_insert(struct btrfs_fs_info *fs_info, struct tree_mod_elem *tm)
 	while (*new) {
 		cur = container_of(*new, struct tree_mod_elem, node);
 		parent = *new;
-		if (cur->index < tm->index)
+		if (cur->logical < tm->logical)
 			new = &((*new)->rb_left);
-		else if (cur->index > tm->index)
+		else if (cur->logical > tm->logical)
 			new = &((*new)->rb_right);
 		else if (cur->seq < tm->seq)
 			new = &((*new)->rb_left);
@@ -523,7 +523,7 @@ alloc_tree_mod_elem(struct extent_buffer *eb, int slot,
 	if (!tm)
 		return NULL;
 
-	tm->index = eb->start >> PAGE_CACHE_SHIFT;
+	tm->logical = eb->start;
 	if (op != MOD_LOG_KEY_ADD) {
 		btrfs_node_key(eb, &tm->key, slot);
 		tm->blockptr = btrfs_node_blockptr(eb, slot);
@@ -588,7 +588,7 @@ tree_mod_log_insert_move(struct btrfs_fs_info *fs_info,
 		goto free_tms;
 	}
 
-	tm->index = eb->start >> PAGE_CACHE_SHIFT;
+	tm->logical = eb->start;
 	tm->slot = src_slot;
 	tm->move.dst_slot = dst_slot;
 	tm->move.nr_items = nr_items;
@@ -699,7 +699,7 @@ tree_mod_log_insert_root(struct btrfs_fs_info *fs_info,
 		goto free_tms;
 	}
 
-	tm->index = new_root->start >> PAGE_CACHE_SHIFT;
+	tm->logical = new_root->start;
 	tm->old_root.logical = old_root->start;
 	tm->old_root.level = btrfs_header_level(old_root);
 	tm->generation = btrfs_header_generation(old_root);
@@ -739,16 +739,15 @@ __tree_mod_log_search(struct btrfs_fs_info *fs_info, u64 start, u64 min_seq,
 	struct rb_node *node;
 	struct tree_mod_elem *cur = NULL;
 	struct tree_mod_elem *found = NULL;
-	u64 index = start >> PAGE_CACHE_SHIFT;
 
 	tree_mod_log_read_lock(fs_info);
 	tm_root = &fs_info->tree_mod_log;
 	node = tm_root->rb_node;
 	while (node) {
 		cur = container_of(node, struct tree_mod_elem, node);
-		if (cur->index < index) {
+		if (cur->logical < start) {
 			node = node->rb_left;
-		} else if (cur->index > index) {
+		} else if (cur->logical > start) {
 			node = node->rb_right;
 		} else if (cur->seq < min_seq) {
 			node = node->rb_left;
@@ -1230,9 +1229,10 @@ __tree_mod_log_oldest_root(struct btrfs_fs_info *fs_info,
 		return NULL;
 
 	/*
-	 * the very last operation that's logged for a root is the replacement
-	 * operation (if it is replaced at all). this has the index of the *new*
-	 * root, making it the very first operation that's logged for this root.
+	 * the very last operation that's logged for a root is the
+	 * replacement operation (if it is replaced at all). this has
+	 * the logical address of the *new* root, making it the very
+	 * first operation that's logged for this root.
 	 */
 	while (1) {
 		tm = tree_mod_log_search_oldest(fs_info, root_logical,
@@ -1336,7 +1336,7 @@ __tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
 		if (!next)
 			break;
 		tm = container_of(next, struct tree_mod_elem, node);
-		if (tm->index != first_tm->index)
+		if (tm->logical != first_tm->logical)
 			break;
 	}
 	tree_mod_log_read_unlock(fs_info);
-- 
2.1.0

