Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:36725
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753643Ab2KCUad (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 3 Nov 2012 16:30:33 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Chris Mason <chris.mason@fusionio.com>
Cc: kernel-janitors@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] fs/btrfs: drop if around WARN_ON
Date: Sat,  3 Nov 2012 21:30:18 +0100
Message-Id: <1351974625-10282-2-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1351974625-10282-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1351974625-10282-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Julia Lawall <Julia.Lawall@lip6.fr>

Just use WARN_ON rather than an if containing only WARN_ON(1).

A simplified version of the semantic patch that makes this transformation
is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e;
@@
- if (e) WARN_ON(1);
+ WARN_ON(e);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 fs/btrfs/backref.c |    3 +--
 fs/btrfs/ctree.c   |    9 +++------
 fs/btrfs/inode.c   |    3 +--
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 208d8aa..a321952 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -890,8 +890,7 @@ again:
 	while (!list_empty(&prefs)) {
 		ref = list_first_entry(&prefs, struct __prelim_ref, list);
 		list_del(&ref->list);
-		if (ref->count < 0)
-			WARN_ON(1);
+		WARN_ON(ref->count < 0);
 		if (ref->count && ref->root_id && ref->parent == 0) {
 			/* no parent == root of tree */
 			ret = ulist_add(roots, ref->root_id, 0, GFP_NOFS);
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index cdfb4c4..8ecb995 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1469,10 +1469,8 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 	if (cache_only && parent_level != 1)
 		return 0;
 
-	if (trans->transaction != root->fs_info->running_transaction)
-		WARN_ON(1);
-	if (trans->transid != root->fs_info->generation)
-		WARN_ON(1);
+	WARN_ON(trans->transaction != root->fs_info->running_transaction);
+	WARN_ON(trans->transid != root->fs_info->generation);
 
 	parent_nritems = btrfs_header_nritems(parent);
 	blocksize = btrfs_level_size(root, parent_level - 1);
@@ -3403,8 +3401,7 @@ static noinline int __push_leaf_right(struct btrfs_trans_handle *trans,
 	if (push_items == 0)
 		goto out_unlock;
 
-	if (!empty && push_items == left_nritems)
-		WARN_ON(1);
+	WARN_ON(!empty && push_items == left_nritems);
 
 	/* push left to right */
 	right_nritems = btrfs_header_nritems(right);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 95542a1..0d169ab 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1657,8 +1657,7 @@ static noinline int add_pending_csums(struct btrfs_trans_handle *trans,
 int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
 			      struct extent_state **cached_state)
 {
-	if ((end & (PAGE_CACHE_SIZE - 1)) == 0)
-		WARN_ON(1);
+	WARN_ON((end & (PAGE_CACHE_SIZE - 1)) == 0);
 	return set_extent_delalloc(&BTRFS_I(inode)->io_tree, start, end,
 				   cached_state, GFP_NOFS);
 }

