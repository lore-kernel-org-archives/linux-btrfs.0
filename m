Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:62865
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754324Ab2KCK6x (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 3 Nov 2012 06:58:53 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Chris Mason <chris.mason@fusionio.com>
Cc: kernel-janitors@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 13/16] fs/btrfs: use WARN
Date: Sat,  3 Nov 2012 11:58:34 +0100
Message-Id: <1351940317-14812-14-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1351940317-14812-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1351940317-14812-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Julia Lawall <Julia.Lawall@lip6.fr>

Use WARN rather than printk followed by WARN_ON(1), for conciseness.

A simplified version of the semantic patch that makes this transformation
is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression list es;
@@

-printk(
+WARN(1,
  es);
-WARN_ON(1);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Many of these end up with the form
if (somewhat_complex_condition) WARN(1, ...)
They could also be converted to WARN(somewhat_complex_condition, ...)
if that would be preferred.

 fs/btrfs/ctree.c       |   19 +++++++------------
 fs/btrfs/disk-io.c     |    6 ++----
 fs/btrfs/extent-tree.c |    7 +++----
 fs/btrfs/extent_io.c   |    9 +++------
 fs/btrfs/inode.c       |    3 +--
 fs/btrfs/transaction.c |   12 ++++--------
 fs/btrfs/volumes.c     |    3 +--
 7 files changed, 21 insertions(+), 38 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index cdfb4c4..adfa929 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1361,19 +1361,16 @@ noinline int btrfs_cow_block(struct btrfs_trans_handle *trans,
 	u64 search_start;
 	int ret;
 
-	if (trans->transaction != root->fs_info->running_transaction) {
-		printk(KERN_CRIT "trans %llu running %llu\n",
+	if (trans->transaction != root->fs_info->running_transaction)
+		WARN(1, KERN_CRIT "trans %llu running %llu\n",
 		       (unsigned long long)trans->transid,
 		       (unsigned long long)
 		       root->fs_info->running_transaction->transid);
-		WARN_ON(1);
-	}
-	if (trans->transid != root->fs_info->generation) {
-		printk(KERN_CRIT "trans %llu running %llu\n",
+
+	if (trans->transid != root->fs_info->generation)
+		WARN(1, KERN_CRIT "trans %llu running %llu\n",
 		       (unsigned long long)trans->transid,
 		       (unsigned long long)root->fs_info->generation);
-		WARN_ON(1);
-	}
 
 	if (!should_cow_block(trans, root, buf)) {
 		*cow_ret = buf;
@@ -3642,11 +3639,9 @@ static noinline int __push_leaf_left(struct btrfs_trans_handle *trans,
 	btrfs_set_header_nritems(left, old_left_nritems + push_items);
 
 	/* fixup right node */
-	if (push_items > right_nritems) {
-		printk(KERN_CRIT "push items %d nr %u\n", push_items,
+	if (push_items > right_nritems)
+		WARN(1, KERN_CRIT "push items %d nr %u\n", push_items,
 		       right_nritems);
-		WARN_ON(1);
-	}
 
 	if (push_items < right_nritems) {
 		push_space = btrfs_item_offset_nr(right, push_items - 1) -
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 22a0439..1769e7d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3383,14 +3383,12 @@ void btrfs_mark_buffer_dirty(struct extent_buffer *buf)
 	int was_dirty;
 
 	btrfs_assert_tree_locked(buf);
-	if (transid != root->fs_info->generation) {
-		printk(KERN_CRIT "btrfs transid mismatch buffer %llu, "
+	if (transid != root->fs_info->generation)
+		WARN(1, KERN_CRIT "btrfs transid mismatch buffer %llu, "
 		       "found %llu running %llu\n",
 			(unsigned long long)buf->start,
 			(unsigned long long)transid,
 			(unsigned long long)root->fs_info->generation);
-		WARN_ON(1);
-	}
 	was_dirty = set_extent_buffer_dirty(buf);
 	if (!was_dirty) {
 		spin_lock(&root->fs_info->delalloc_lock);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3d3e2c1..37353eb 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6292,10 +6292,9 @@ use_block_rsv(struct btrfs_trans_handle *trans,
 		static DEFINE_RATELIMIT_STATE(_rs,
 				DEFAULT_RATELIMIT_INTERVAL,
 				/*DEFAULT_RATELIMIT_BURST*/ 2);
-		if (__ratelimit(&_rs)) {
-			printk(KERN_DEBUG "btrfs: block rsv returned %d\n", ret);
-			WARN_ON(1);
-		}
+		if (__ratelimit(&_rs))
+			WARN(1, KERN_DEBUG "btrfs: block rsv returned %d\n",
+			     ret);
 		ret = reserve_metadata_bytes(root, block_rsv, blocksize, 0);
 		if (!ret) {
 			return block_rsv;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 472873a..3c062c8 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -341,12 +341,10 @@ static int insert_state(struct extent_io_tree *tree,
 {
 	struct rb_node *node;
 
-	if (end < start) {
-		printk(KERN_ERR "btrfs end < start %llu %llu\n",
+	if (end < start)
+		WARN(1, KERN_ERR "btrfs end < start %llu %llu\n",
 		       (unsigned long long)end,
 		       (unsigned long long)start);
-		WARN_ON(1);
-	}
 	state->start = start;
 	state->end = end;
 
@@ -4721,10 +4719,9 @@ int map_private_extent_buffer(struct extent_buffer *eb, unsigned long start,
 	}
 
 	if (start + min_len > eb->len) {
-		printk(KERN_ERR "btrfs bad mapping eb start %llu len %lu, "
+		WARN(1, KERN_ERR "btrfs bad mapping eb start %llu len %lu, "
 		       "wanted %lu %lu\n", (unsigned long long)eb->start,
 		       eb->len, start, min_len);
-		WARN_ON(1);
 		return -EINVAL;
 	}
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 95542a1..505357b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5439,8 +5439,7 @@ again:
 				    extent_map_end(em) - 1, NULL, GFP_NOFS);
 		goto insert;
 	} else {
-		printk(KERN_ERR "btrfs unknown found_type %d\n", found_type);
-		WARN_ON(1);
+		WARN(1, KERN_ERR "btrfs unknown found_type %d\n", found_type);
 	}
 not_found:
 	em->start = start;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 04bbfb1..d57cf89 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -145,16 +145,12 @@ loop:
 	 * the log must never go across transaction boundaries.
 	 */
 	smp_mb();
-	if (!list_empty(&fs_info->tree_mod_seq_list)) {
-		printk(KERN_ERR "btrfs: tree_mod_seq_list not empty when "
+	if (!list_empty(&fs_info->tree_mod_seq_list))
+		WARN(1, KERN_ERR "btrfs: tree_mod_seq_list not empty when "
 			"creating a fresh transaction\n");
-		WARN_ON(1);
-	}
-	if (!RB_EMPTY_ROOT(&fs_info->tree_mod_log)) {
-		printk(KERN_ERR "btrfs: tree_mod_log rb tree not empty when "
+	if (!RB_EMPTY_ROOT(&fs_info->tree_mod_log))
+		WARN(1, KERN_ERR "btrfs: tree_mod_log rb tree not empty when "
 			"creating a fresh transaction\n");
-		WARN_ON(1);
-	}
 	atomic_set(&fs_info->tree_mod_seq, 0);
 
 	spin_lock_init(&cur_trans->commit_lock);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0f5ebb7..2705ce0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3347,9 +3347,8 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		cur = cur->next;
 
 		if (!device->writeable) {
-			printk(KERN_ERR
+			WARN(1, KERN_ERR
 			       "btrfs: read-only device in alloc_list\n");
-			WARN_ON(1);
 			continue;
 		}
 

