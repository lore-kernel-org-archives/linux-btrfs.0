Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mort.rzone.de ([81.169.144.234]:12979 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757452Ab2F0RZB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jun 2012 13:25:01 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 7/7] Btrfs: resolve tree mod log locking issue in btrfs_next_leaf
Date: Wed, 27 Jun 2012 19:24:59 +0200
Message-Id: <1340817899-16343-8-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1340817899-16343-1-git-send-email-list.btrfs@jan-o-sch.net>
References: <1340817899-16343-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With the tree mod log, we may end up with two roots (the current root and a
rewinded version of it) both pointing to two leaves, l1 and l2, of which l2
had already been cow-ed in the current transaction. If we don't rewind any
tree blocks, we cannot have two roots both pointing to an already cowed tree
block.

Now there is btrfs_next_leaf, which has a leaf locked and wants a lock on
the next (right) leaf. And there is push_leaf_left, which has a (cowed!)
leaf locked and wants a lock on the previous (left) leaf.

In order to solve this dead lock situation, we use try_lock in
btrfs_next_leaf (only in case it's called with a tree mod log time_seq
paramter) and if we fail to get a lock on the next leaf, we give up our lock
on the current leaf and retry from the very beginning.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/ctree.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index b98f860..8206b39 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -5119,6 +5119,18 @@ again:
 
 		if (!path->skip_locking) {
 			ret = btrfs_try_tree_read_lock(next);
+			if (!ret && time_seq) {
+				/*
+				 * If we don't get the lock, we may be racing
+				 * with push_leaf_left, holding that lock while
+				 * itself waiting for the leaf we've currently
+				 * locked. To solve this situation, we give up
+				 * on our lock and cycle.
+				 */
+				btrfs_release_path(path);
+				cond_resched();
+				goto again;
+			}
 			if (!ret) {
 				btrfs_set_path_blocking(path);
 				btrfs_tree_read_lock(next);
-- 
1.7.3.4

