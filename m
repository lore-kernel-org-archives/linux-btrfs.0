Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.139]:30354 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754908Ab3HWIer (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Aug 2013 04:34:47 -0400
Received: from pizpot.store ([192.168.43.236])
 by josoe.store (RZmta 31.45 OK) with ESMTP id p05afcp7N0sIFv
 for <linux-btrfs@vger.kernel.org>;
 Fri, 23 Aug 2013 10:34:43 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] Btrf: cleanup: don't check for root_refs == 0 twice
Date: Fri, 23 Aug 2013 10:34:43 +0200
Message-Id: <1377246883-28772-2-git-send-email-sbehrens@giantdisaster.de>
In-Reply-To: <1377246883-28772-1-git-send-email-sbehrens@giantdisaster.de>
References: <1377246883-28772-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_read_fs_root_no_name() already checks if btrfs_root_refs()
is zero and returns ENOENT in this case. There is no need to do
it again in three more places.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/file.c       | 5 -----
 fs/btrfs/relocation.c | 3 ---
 fs/btrfs/scrub.c      | 5 -----
 3 files changed, 13 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 5c63229..fce83dd 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -310,11 +310,6 @@ static int __btrfs_run_defrag_inode(struct btrfs_fs_info *fs_info,
 		goto cleanup;
 	}
 
-	if (btrfs_root_refs(&inode_root->root_item) == 0) {
-		ret = -ENOENT;
-		goto cleanup;
-	}
-
 	key.objectid = defrag->ino;
 	btrfs_set_key_type(&key, BTRFS_INODE_ITEM_KEY);
 	key.offset = 0;
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index cf5e30f..aacc212 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2354,9 +2354,6 @@ again:
 			if (IS_ERR(root))
 				continue;
 
-			if (btrfs_root_refs(&root->root_item) == 0)
-				continue;
-
 			trans = btrfs_join_transaction(root);
 			BUG_ON(IS_ERR(trans));
 
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index ec6a33a..0afcd45 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3217,11 +3217,6 @@ static int copy_nocow_pages_for_inode(u64 inum, u64 offset, u64 root, void *ctx)
 		return PTR_ERR(local_root);
 	}
 
-	if (btrfs_root_refs(&local_root->root_item) == 0) {
-		srcu_read_unlock(&fs_info->subvol_srcu, srcu_index);
-		return -ENOENT;
-	}
-
 	key.type = BTRFS_INODE_ITEM_KEY;
 	key.objectid = inum;
 	key.offset = 0;
-- 
1.8.3.4

