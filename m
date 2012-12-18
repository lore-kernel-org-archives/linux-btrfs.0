Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:47868 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754135Ab2LRUpl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Dec 2012 15:45:41 -0500
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id NMC34JSNFYQmBssF (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 18 Dec 2012 13:45:40 -0700 (MST)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: don't bother updating the inode when evicting
Date: Tue, 18 Dec 2012 15:51:57 -0500
Message-ID: <1355863917-16932-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We're deleting the stupid thing, no sense in updating the inode for the new
size.  We're running into having 50-100 orphans left over with xfstests 83
because of ENOSPC when trying to start the transaction for the inode update.
This patch fixes this problem.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/inode.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f33269a..ac7f471 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3898,7 +3898,7 @@ void btrfs_evict_inode(struct inode *inode)
 			goto no_delete;
 		}
 
-		trans = btrfs_start_transaction_lflush(root, 1);
+		trans = btrfs_join_transaction(root);
 		if (IS_ERR(trans)) {
 			btrfs_orphan_del(NULL, inode);
 			btrfs_free_block_rsv(root, rsv);
@@ -3911,10 +3911,6 @@ void btrfs_evict_inode(struct inode *inode)
 		if (ret != -ENOSPC)
 			break;
 
-		trans->block_rsv = &root->fs_info->trans_block_rsv;
-		ret = btrfs_update_inode(trans, root, inode);
-		BUG_ON(ret);
-
 		btrfs_end_transaction(trans, root);
 		trans = NULL;
 		btrfs_btree_balance_dirty(root);
-- 
1.7.7.6

