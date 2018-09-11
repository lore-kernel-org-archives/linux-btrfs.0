Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:41373 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727762AbeILDII (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 23:08:08 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: skip setting path to blocking mode if balance is not needed
Date: Wed, 12 Sep 2018 06:06:24 +0800
Message-Id: <1536703587-94565-5-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

balance_level() may return early in some cases, but these checks don't
have to be done with blocking write lock.

This puts together these checks into a helper and the benefit is to
avoid switching spinning locks to blocking locks (in these paticular
cases) which slows down btrfs overall.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 fs/btrfs/ctree.c | 41 ++++++++++++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 858085490e23..ba267a069ca1 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1758,6 +1758,29 @@ static void root_sub_used(struct btrfs_root *root, u32 size)
 	return eb;
 }
 
+static bool need_balance_level(struct btrfs_fs_info *fs_info,
+			      struct btrfs_trans_handle *trans,
+			      struct btrfs_path *path, int level)
+{
+	struct extent_buffer *mid;
+
+	mid = path->nodes[level];
+
+	WARN_ON(path->locks[level] != BTRFS_WRITE_LOCK &&
+		path->locks[level] != BTRFS_WRITE_LOCK_BLOCKING);
+	WARN_ON(btrfs_header_generation(mid) != trans->transid);
+
+	/* If mid is the root node. */
+	if (level < BTRFS_MAX_LEVEL - 1 && path->nodes[level + 1] == NULL)
+		if (btrfs_header_nritems(mid) != 1)
+			return false;
+
+	if (btrfs_header_nritems(mid) > BTRFS_NODEPTRS_PER_BLOCK(fs_info) / 4)
+		return false;
+
+	return true;
+}
+
 /*
  * node level balancing, used to make sure nodes are in proper order for
  * item deletion.  We balance from the top down, so we have to make sure
@@ -1780,10 +1803,6 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 
 	mid = path->nodes[level];
 
-	WARN_ON(path->locks[level] != BTRFS_WRITE_LOCK &&
-		path->locks[level] != BTRFS_WRITE_LOCK_BLOCKING);
-	WARN_ON(btrfs_header_generation(mid) != trans->transid);
-
 	orig_ptr = btrfs_node_blockptr(mid, orig_slot);
 
 	if (level < BTRFS_MAX_LEVEL - 1) {
@@ -1798,9 +1817,6 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 	if (!parent) {
 		struct extent_buffer *child;
 
-		if (btrfs_header_nritems(mid) != 1)
-			return 0;
-
 		/* promote the child to a root */
 		child = read_node_slot(fs_info, mid, 0);
 		if (IS_ERR(child)) {
@@ -1838,9 +1854,6 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		free_extent_buffer_stale(mid);
 		return 0;
 	}
-	if (btrfs_header_nritems(mid) >
-	    BTRFS_NODEPTRS_PER_BLOCK(fs_info) / 4)
-		return 0;
 
 	left = read_node_slot(fs_info, parent, pslot - 1);
 	if (IS_ERR(left))
@@ -2460,14 +2473,20 @@ noinline void btrfs_unlock_up_safe(struct btrfs_path *path, int level)
 			goto again;
 		}
 
+		/* Skip setting path to blocking if balance is not needed. */
+		if (!need_balance_level(fs_info, trans, p, level)) {
+			ret = 0;
+			goto done;
+		}
+
 		btrfs_set_path_blocking(p);
 		reada_for_balance(fs_info, p, level);
 		sret = balance_level(trans, root, p, level);
-
 		if (sret) {
 			ret = sret;
 			goto done;
 		}
+
 		b = p->nodes[level];
 		if (!b) {
 			btrfs_release_path(p);
-- 
1.8.3.1
