Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:50678 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932478AbbKMPVp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 10:21:45 -0500
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 2/2] Btrfs: fix the number of transaction units needed to remove a block group
Date: Fri, 13 Nov 2015 15:20:32 +0000
Message-Id: <1447428032-1872-3-git-send-email-fdmanana@kernel.org>
In-Reply-To: <1447428032-1872-1-git-send-email-fdmanana@kernel.org>
References: <1447428032-1872-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

We were using only 1 transaction unit when attempting to delete an unused
block group but in reality we need 3 units. We were accounting only for
the addition of the orphan item (for the block group's free space cache
inode) but we were not accounting that we need to delete one block group
item from the extent tree and one free space item from the tree of tree
roots.

While one unit is not enough, it worked most of the time because for each
single unit we are too pessimistic and assume an entire tree path, with
the highest possible height (8), needs to be COWed with eventual node
splits at every possible level in the tree, so there was usually enough
reserved space for removing the block group and free space items after
adding the orphan.

However after adding the orphan item, writepages() can by called by the VM
subsystem against the btree inode when we are under memory pressure, which
causes writeback to start for the nodes we COWed before, this forces the
operation to remove the free space item to COW again some (or all of) the
same nodes (in the tree of tree roots). Even without writepages() being
called, we could fail with ENOSPC because the block group item is located
in a different tree (the extent tree) and it can have a big enough heigth
and require enough node/leaf splits to blow up the reserved space that did
not ended up getting used for adding the orphan and removing the free
space cache item.

In the kernel 4.0 release, commit 3d84be799194 ("Btrfs: fix BUG_ON in
btrfs_orphan_add() when delete unused block group"), we attempted to fix
a BUG_ON due to ENOSPC when trying to add the orphan item by making the
cleaner kthread reserve one transaction unit before attempting to remove
the block group, but this was not enough. We had a couple user reports
still hitting the same BUG_ON after 4.0, like Stefan Priebe's report on
a 4.2-rc6 kernel for example:

    http://www.spinics.net/lists/linux-btrfs/msg46070.html

So fix this by reserving the neceasary 3 units of metadata.

Reported-by: Stefan Priebe <s.priebe@profihost.ag>
Fixes: 3d84be799194 ("Btrfs: fix BUG_ON in btrfs_orphan_add() when delete unused block group")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/extent-tree.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 7820093..cc54c3f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10260,11 +10260,24 @@ struct btrfs_trans_handle *
 btrfs_start_trans_remove_block_group(struct btrfs_fs_info *fs_info)
 {
 	/*
+	 * We need to reserve 3 units from the metadata space info in order
+	 * to remove a block group (done at btrfs_remove_block_group()), which
+	 * are used for:
+	 *
 	 * 1 unit for adding the free space inode's orphan (located in the tree
 	 * of tree roots).
+	 * 1 unit for deleting the block group item (located in the extent
+	 * tree).
+	 * 1 unit for deleting the free space item (located in tree of tree
+	 * roots).
+	 *
+	 * In order to remove a block group we also need to reserve units in the
+	 * system space info in order to update the chunk tree (update one or
+	 * more device items and remove one chunk item), but this is done at
+	 * btrfs_remove_chunk() through a call to check_system_chunk().
 	 */
 	return btrfs_start_transaction_fallback_global_rsv(fs_info->extent_root,
-							   1, 1);
+							   3, 1);
 }
 
 /*
-- 
2.1.3

