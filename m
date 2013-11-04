Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.microon.de ([37.252.125.21]:37982 "EHLO gattino.microon.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751558Ab3KDVg6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Nov 2013 16:36:58 -0500
From: Valentina Giusti <valentina.giusti@microon.de>
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/9] btrfs: remove unused variable from btrfs_new_inode
Date: Mon,  4 Nov 2013 22:34:22 +0100
Message-Id: <1383600869-10085-3-git-send-email-valentina.giusti@microon.de>
In-Reply-To: <1383600869-10085-1-git-send-email-valentina.giusti@microon.de>
References: <1383600869-10085-1-git-send-email-valentina.giusti@microon.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Variable owner in btrfs_new_inode is unused since commit
d82a6f1d7e8b61ed5996334d0db66651bb43641d
(Btrfs: kill BTRFS_I(inode)->block_group)

Signed-off-by: Valentina Giusti <valentina.giusti@microon.de>
---
 fs/btrfs/inode.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3b4ffaf..7e09eff 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5347,7 +5347,6 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	u32 sizes[2];
 	unsigned long ptr;
 	int ret;
-	int owner;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -5393,11 +5392,6 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	 */
 	set_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &BTRFS_I(inode)->runtime_flags);
 
-	if (S_ISDIR(mode))
-		owner = 0;
-	else
-		owner = 1;
-
 	key[0].objectid = objectid;
 	btrfs_set_key_type(&key[0], BTRFS_INODE_ITEM_KEY);
 	key[0].offset = 0;
-- 
1.7.10.4

