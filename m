Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:54493 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab3LWLxJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Dec 2013 06:53:09 -0500
Received: by mail-we0-f179.google.com with SMTP id q59so4705574wes.24
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Dec 2013 03:53:08 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: reduce btree node locking duration on item update
Date: Mon, 23 Dec 2013 11:53:02 +0000
Message-Id: <1387799582-8469-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we do a btree search with the goal of updating an existing item
without changing its size (ins_len == 0 and cow == 1), then we never
need to hold locks on upper level nodes (even when slot == 0) after we
COW their child nodes/leaves, as we won't have node splits or merges
in this scenario (that is, no key additions, removals or shifts on any
nodes or leaves).

Therefore release the locks immediately after COWing the child nodes/leaves
while navigating the btree, even if their parent slot is 0, instead of
returning a path to the caller with those nodes locked, which would get
released only when the caller releases or frees the path (or if it calls
btrfs_unlock_up_safe).

This is a common scenario, for example when updating inode items in fs
trees and block group items in the extent tree.

The following benchmarks were performed on a quad core machine with 32Gb
of ram, using a leaf/node size of 4Kb (to generate deeper fs trees more
quickly).

  sysbench --test=fileio --file-num=131072 --file-total-size=8G \
    --file-test-mode=seqwr --num-threads=512 --file-block-size=8192 \
    --max-requests=100000 --file-io-mode=sync [prepare|run]

Before this change:  49.85Mb/s (average of 5 runs)
After this change:   50.38Mb/s (average of 5 runs)

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/ctree.c         |   23 ++++++++++++++---------
 fs/btrfs/delayed-inode.c |    1 -
 fs/btrfs/inode.c         |    1 -
 3 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 062438d..9e9de68 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2731,6 +2731,7 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
 	lowest_level = p->lowest_level;
 	WARN_ON(lowest_level && ins_len > 0);
 	WARN_ON(p->nodes[0] != NULL);
+	BUG_ON(!cow && ins_len);
 
 	if (ins_len < 0) {
 		lowest_unlock = 2;
@@ -2839,8 +2840,6 @@ again:
 			}
 		}
 cow_done:
-		BUG_ON(!cow && ins_len);
-
 		p->nodes[level] = b;
 		btrfs_clear_path_blocking(p, NULL, 0);
 
@@ -2850,13 +2849,19 @@ cow_done:
 		 * It is safe to drop the lock on our parent before we
 		 * go through the expensive btree search on b.
 		 *
-		 * If cow is true, then we might be changing slot zero,
-		 * which may require changing the parent.  So, we can't
-		 * drop the lock until after we know which slot we're
-		 * operating on.
+		 * If we're inserting or deleting (ins_len != 0), then we might
+		 * be changing slot zero, which may require changing the parent.
+		 * So, we can't drop the lock until after we know which slot
+		 * we're operating on.
 		 */
-		if (!cow)
-			btrfs_unlock_up_safe(p, level + 1);
+		if (!ins_len && !p->keep_locks) {
+			int u = level + 1;
+
+			if (u < BTRFS_MAX_LEVEL && p->locks[u]) {
+				btrfs_tree_unlock_rw(p->nodes[u], p->locks[u]);
+				p->locks[u] = 0;
+			}
+		}
 
 		ret = key_search(b, key, level, &prev_cmp, &slot);
 
@@ -2884,7 +2889,7 @@ cow_done:
 			 * which means we must have a write lock
 			 * on the parent
 			 */
-			if (slot == 0 && cow &&
+			if (slot == 0 && ins_len &&
 			    write_lock_level < level + 1) {
 				write_lock_level = level + 1;
 				btrfs_release_path(p);
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 222ca8c..6368bf5 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1037,7 +1037,6 @@ static int __btrfs_update_delayed_inode(struct btrfs_trans_handle *trans,
 		return ret;
 	}
 
-	btrfs_unlock_up_safe(path, 1);
 	leaf = path->nodes[0];
 	inode_item = btrfs_item_ptr(leaf, path->slots[0],
 				    struct btrfs_inode_item);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 06bcf5b..26a1d53 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3490,7 +3490,6 @@ static noinline int btrfs_update_inode_item(struct btrfs_trans_handle *trans,
 		goto failed;
 	}
 
-	btrfs_unlock_up_safe(path, 1);
 	leaf = path->nodes[0];
 	inode_item = btrfs_item_ptr(leaf, path->slots[0],
 				    struct btrfs_inode_item);
-- 
1.7.9.5

