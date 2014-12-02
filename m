Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:38557 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932488AbaLBSIC (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Tue, 2 Dec 2014 13:08:02 -0500
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 2/2] Btrfs: fix unprotected deletion from pending_chunks list
Date: Tue,  2 Dec 2014 18:07:49 +0000
Message-Id: <1417543669-22685-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On block group remove if the corresponding extent map was on the
transaction->pending_chunks list, we were deleting the extent map
from that list, through remove_extent_mapping(), without any
synchronization with chunk allocation (which iterates that list
and adds new elements to it). Fix this by ensure that this is done
while the chunk mutex is held, since that's the mutex that protects
the list in the chunk allocation code path.

This applies on top (depends on) of my previous patch titled:
"Btrfs: fix race between fs trimming and block group remove/allocation"

But the issue in fact was already present before that change, it only
became easier to hit after Josef's 3.18 patch that added automatic
removal of empty block groups.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/extent-tree.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 17d429d..a7b81b4 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9524,19 +9524,25 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 		list_move_tail(&em->list, &root->fs_info->pinned_chunks);
 	}
 	spin_unlock(&block_group->lock);
-	unlock_chunks(root);
 
 	if (remove_em) {
 		struct extent_map_tree *em_tree;
 
 		em_tree = &root->fs_info->mapping_tree.map_tree;
 		write_lock(&em_tree->lock);
+		/*
+		 * The em might be in the pending_chunks list, so make sure the
+		 * chunk mutex is locked, since remove_extent_mapping() will
+		 * delete us from that list.
+		 */
 		remove_extent_mapping(em_tree, em);
 		write_unlock(&em_tree->lock);
 		/* once for the tree */
 		free_extent_map(em);
 	}
 
+	unlock_chunks(root);
+
 	btrfs_put_block_group(block_group);
 	btrfs_put_block_group(block_group);
 
-- 
2.1.3

