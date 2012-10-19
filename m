Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:21707 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308Ab2JSMxT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Oct 2012 08:53:19 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: list.btrfs@jan-o-sch.net
Subject: [PATCH V2 4/4] Btrfs: cleanup unused arguments
Date: Fri, 19 Oct 2012 20:52:15 +0800
Message-Id: <1350651135-4549-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

'disk_key' is not used at all.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v1->v2: update the functions' caller.

 fs/btrfs/ctree.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 235831f..a794c6f 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -772,8 +772,7 @@ tree_mod_log_eb_move(struct btrfs_fs_info *fs_info, struct extent_buffer *dst,
 
 static noinline void
 tree_mod_log_set_node_key(struct btrfs_fs_info *fs_info,
-			  struct extent_buffer *eb,
-			  struct btrfs_disk_key *disk_key, int slot, int atomic)
+			  struct extent_buffer *eb, int slot, int atomic)
 {
 	int ret;
 
@@ -1797,7 +1796,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 			struct btrfs_disk_key right_key;
 			btrfs_node_key(right, &right_key, 0);
 			tree_mod_log_set_node_key(root->fs_info, parent,
-						  &right_key, pslot + 1, 0);
+						  pslot + 1, 0);
 			btrfs_set_node_key(parent, &right_key, pslot + 1);
 			btrfs_mark_buffer_dirty(parent);
 		}
@@ -1841,7 +1840,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		/* update the parent key to reflect our changes */
 		struct btrfs_disk_key mid_key;
 		btrfs_node_key(mid, &mid_key, 0);
-		tree_mod_log_set_node_key(root->fs_info, parent, &mid_key,
+		tree_mod_log_set_node_key(root->fs_info, parent,
 					  pslot, 0);
 		btrfs_set_node_key(parent, &mid_key, pslot);
 		btrfs_mark_buffer_dirty(parent);
@@ -1941,7 +1940,7 @@ static noinline int push_nodes_for_insert(struct btrfs_trans_handle *trans,
 			orig_slot += left_nr;
 			btrfs_node_key(mid, &disk_key, 0);
 			tree_mod_log_set_node_key(root->fs_info, parent,
-						  &disk_key, pslot, 0);
+						  pslot, 0);
 			btrfs_set_node_key(parent, &disk_key, pslot);
 			btrfs_mark_buffer_dirty(parent);
 			if (btrfs_header_nritems(left) > orig_slot) {
@@ -1994,7 +1993,7 @@ static noinline int push_nodes_for_insert(struct btrfs_trans_handle *trans,
 
 			btrfs_node_key(right, &disk_key, 0);
 			tree_mod_log_set_node_key(root->fs_info, parent,
-						  &disk_key, pslot + 1, 0);
+						  pslot + 1, 0);
 			btrfs_set_node_key(parent, &disk_key, pslot + 1);
 			btrfs_mark_buffer_dirty(parent);
 
@@ -2878,7 +2877,7 @@ static void fixup_low_keys(struct btrfs_trans_handle *trans,
 		if (!path->nodes[i])
 			break;
 		t = path->nodes[i];
-		tree_mod_log_set_node_key(root->fs_info, t, key, tslot, 1);
+		tree_mod_log_set_node_key(root->fs_info, t, tslot, 1);
 		btrfs_set_node_key(t, key, tslot);
 		btrfs_mark_buffer_dirty(path->nodes[i]);
 		if (tslot != 0)
-- 
1.7.7.6

