Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:26485 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab2JVODt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Oct 2012 10:03:49 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q9ME3mas030952
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2012 14:03:49 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q9ME3lit005448
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2012 14:03:48 GMT
Received: from abhmt111.oracle.com (abhmt111.oracle.com [141.146.116.63])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q9ME3lHs027769
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2012 09:03:47 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix a tree mod bug while inserting a new root
Date: Mon, 22 Oct 2012 22:02:52 +0800
Message-Id: <1350914572-4205-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

According to btree's balance algorithm, when we split a root into two parts,
we insert a new one to be their parent:

                                                 new root
            node A                            /              \
      | x1 x2 x3 x4 x5 x6 |   =>          node A             node A'
                                    | x1 x2 x3 - - - |  | x4 x5 x6 - - - |
                             split

The original root won't be freed because it becomes a child of the new root,
and a move to keep balance is needed then.

So we should not add REMOVE_WHILE_FREEING keys for the old root, otherwise,
we will hit use-after-free since we first add REMOVE_WHILE_FREEING keys and
then add REMOVE keys, which is invalid.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index b334362..26987ef 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -639,7 +639,8 @@ __tree_mod_log_free_eb(struct btrfs_fs_info *fs_info, struct extent_buffer *eb)
 static noinline int
 tree_mod_log_insert_root(struct btrfs_fs_info *fs_info,
 			 struct extent_buffer *old_root,
-			 struct extent_buffer *new_root, gfp_t flags)
+			 struct extent_buffer *new_root,
+			 gfp_t flags, int free_old)
 {
 	struct tree_mod_elem *tm;
 	int ret;
@@ -647,7 +648,8 @@ tree_mod_log_insert_root(struct btrfs_fs_info *fs_info,
 	if (tree_mod_dont_log(fs_info, NULL))
 		return 0;
 
-	__tree_mod_log_free_eb(fs_info, old_root);
+	if (free_old)
+		__tree_mod_log_free_eb(fs_info, old_root);
 
 	ret = tree_mod_alloc(fs_info, flags, &tm);
 	if (ret < 0)
@@ -797,11 +799,11 @@ tree_mod_log_free_eb(struct btrfs_fs_info *fs_info, struct extent_buffer *eb)
 
 static noinline void
 tree_mod_log_set_root_pointer(struct btrfs_root *root,
-			      struct extent_buffer *new_root_node)
+			      struct extent_buffer *new_root_node, int free_old)
 {
 	int ret;
 	ret = tree_mod_log_insert_root(root->fs_info, root->node,
-				       new_root_node, GFP_NOFS);
+				       new_root_node, GFP_NOFS, free_old);
 	BUG_ON(ret < 0);
 }
 
@@ -1029,7 +1031,7 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 			parent_start = 0;
 
 		extent_buffer_get(cow);
-		tree_mod_log_set_root_pointer(root, cow);
+		tree_mod_log_set_root_pointer(root, cow, 1);
 		rcu_assign_pointer(root->node, cow);
 
 		btrfs_free_tree_block(trans, root, buf, parent_start,
@@ -1725,7 +1727,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 			goto enospc;
 		}
 
-		tree_mod_log_set_root_pointer(root, child);
+		tree_mod_log_set_root_pointer(root, child, 1);
 		rcu_assign_pointer(root->node, child);
 
 		add_root_to_dirty_list(root);
@@ -3107,7 +3109,7 @@ static noinline int insert_new_root(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(c);
 
 	old = root->node;
-	tree_mod_log_set_root_pointer(root, c);
+	tree_mod_log_set_root_pointer(root, c, 0);
 	rcu_assign_pointer(root->node, c);
 
 	/* the super has an extra ref to root->node */
-- 
1.7.7.6

