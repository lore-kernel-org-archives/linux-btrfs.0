Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.141]:19473 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753716Ab3EMNxi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 May 2013 09:53:38 -0400
Received: from pizpot.store ([192.168.43.236])
	by josoe.store (josoe xp2) (RZmta 31.27 OK)
	with ESMTP id g030d0p4D7wWBc for <linux-btrfs@vger.kernel.org>;
	Mon, 13 May 2013 15:53:35 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] Btrfs: delete unused function
Date: Mon, 13 May 2013 15:53:33 +0200
Message-Id: <676d20ba0e8d57c6070014b301445038be5dd768.1368450252.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1368450252.git.sbehrens@giantdisaster.de>
References: <cover.1368450252.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1368450252.git.sbehrens@giantdisaster.de>
References: <cover.1368450252.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/delayed-inode.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index f26f38c..5615eac 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -535,20 +535,6 @@ static struct btrfs_delayed_item *__btrfs_next_delayed_item(
 	return next;
 }
 
-static inline struct btrfs_root *btrfs_get_fs_root(struct btrfs_root *root,
-						   u64 root_id)
-{
-	struct btrfs_key root_key;
-
-	if (root->objectid == root_id)
-		return root;
-
-	root_key.objectid = root_id;
-	root_key.type = BTRFS_ROOT_ITEM_KEY;
-	root_key.offset = (u64)-1;
-	return btrfs_read_fs_root_no_name(root->fs_info, &root_key);
-}
-
 static int btrfs_delayed_item_reserve_metadata(struct btrfs_trans_handle *trans,
 					       struct btrfs_root *root,
 					       struct btrfs_delayed_item *item)
-- 
1.8.2.2

