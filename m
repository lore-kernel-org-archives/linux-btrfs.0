Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.synology.com ([59.124.41.242]:64075 "EHLO
	mail.synology.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932677AbbBBIIz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Feb 2015 03:08:55 -0500
From: Forrest Liu <forrestl@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Forrest Liu <forrestl@synology.com>
Subject: [PATCH] Btrfs: fix BUG_ON in btrfs_orphan_add() when delete unused block group
Date: Mon,  2 Feb 2015 16:08:48 +0800
Message-Id: <1422864528-8625-1-git-send-email-forrestl@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_orphan_reserve_metadata() will grab metadata reservation from
transaction handle, and the transaction handle was passed from
btrfs_delete_unused_bgs() when delete unused block group.

Repace btrfs_join_transaction() with btrfs_start_transaction() in
btrfs_delete_unused_bgs() to prevent BUG_ON() in btrfs_orphan_add()

Signed-off-by: Forrest Liu <forrestl@synology.com>
---
 fs/btrfs/extent-tree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 53294da..61a3255 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9548,7 +9548,8 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 		 * Want to do this before we do anything else so we can recover
 		 * properly if we fail to join the transaction.
 		 */
-		trans = btrfs_join_transaction(root);
+		/* 1 for btrfs_orphan_reserve_metadata() */
+		trans = btrfs_start_transaction(root, 1);
 		if (IS_ERR(trans)) {
 			btrfs_set_block_group_rw(root, block_group);
 			ret = PTR_ERR(trans);
-- 
1.9.1

