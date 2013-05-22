Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30123 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027Ab3EVMHZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 May 2013 08:07:25 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r4MC7NPG025082
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 22 May 2013 12:07:24 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4MC7MtM009509
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Wed, 22 May 2013 12:07:22 GMT
Received: from abhmt105.oracle.com (abhmt105.oracle.com [141.146.116.57])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4MC7MUH008098
	for <linux-btrfs@vger.kernel.org>; Wed, 22 May 2013 12:07:22 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] Btrfs: dont do log_removal in insert_new_root
Date: Wed, 22 May 2013 20:06:51 +0800
Message-Id: <1369224411-4503-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As for splitting a leaf, root is just the leaf, and tree mod log does not apply
on leaf, so in this case, we don't do log_removal.

As for splitting a node, the old root is kept as a normal node and we have nicely
put records in tree mod log for moving keys and items, so in this case we don't do
that either.

As above, insert_new_root can get rid of log_removal.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 02fae7f..c07b6ea 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3143,7 +3143,7 @@ static int balance_node_right(struct btrfs_trans_handle *trans,
  */
 static noinline int insert_new_root(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
-			   struct btrfs_path *path, int level, int log_removal)
+			   struct btrfs_path *path, int level)
 {
 	u64 lower_gen;
 	struct extent_buffer *lower;
@@ -3194,7 +3194,7 @@ static noinline int insert_new_root(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(c);
 
 	old = root->node;
-	tree_mod_log_set_root_pointer(root, c, log_removal);
+	tree_mod_log_set_root_pointer(root, c, 0);
 	rcu_assign_pointer(root->node, c);
 
 	/* the super has an extra ref to root->node */
@@ -3278,14 +3278,14 @@ static noinline int split_node(struct btrfs_trans_handle *trans,
 		/*
 		 * trying to split the root, lets make a new one
 		 *
-		 * tree mod log: We pass 0 as log_removal parameter to
+		 * tree mod log: We don't log_removal old root in
 		 * insert_new_root, because that root buffer will be kept as a
 		 * normal node. We are going to log removal of half of the
 		 * elements below with tree_mod_log_eb_copy. We're holding a
 		 * tree lock on the buffer, which is why we cannot race with
 		 * other tree_mod_log users.
 		 */
-		ret = insert_new_root(trans, root, path, level + 1, 0);
+		ret = insert_new_root(trans, root, path, level + 1);
 		if (ret)
 			return ret;
 	} else {
@@ -4005,7 +4005,7 @@ static noinline int split_leaf(struct btrfs_trans_handle *trans,
 	}
 
 	if (!path->nodes[1]) {
-		ret = insert_new_root(trans, root, path, 1, 1);
+		ret = insert_new_root(trans, root, path, 1);
 		if (ret)
 			return ret;
 	}
-- 
1.7.7.6

