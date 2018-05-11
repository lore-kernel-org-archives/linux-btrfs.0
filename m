Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:44893 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752383AbeEKH41 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 03:56:27 -0400
Received: by mail-pg0-f67.google.com with SMTP id x145-v6so2097719pgx.11
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 00:56:27 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v3 07/11] Btrfs: don't return ino to ino cache if inode item removal fails
Date: Fri, 11 May 2018 00:56:12 -0700
Message-Id: <0e9c1fa80282b022c459fa763f5a0f364b5e7ee2.1526025007.git.osandov@fb.com>
In-Reply-To: <cover.1526025007.git.osandov@fb.com>
References: <cover.1526025007.git.osandov@fb.com>
In-Reply-To: <cover.1526025007.git.osandov@fb.com>
References: <cover.1526025007.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

In btrfs_evict_inode(), if btrfs_truncate_inode_items() fails, the inode
item will still be in the tree but we still return the ino to the ino
cache. That will blow up later when someone tries to allocate that ino,
so don't return it to the cache.

Fixes: 581bb050941b ("Btrfs: Cache free inode numbers in memory")
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/inode.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 6110387f0218..73bc66d153ef 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5330,13 +5330,18 @@ void btrfs_evict_inode(struct inode *inode)
 		trans->block_rsv = rsv;
 
 		ret = btrfs_truncate_inode_items(trans, root, inode, 0, 0);
-		if (ret != -ENOSPC && ret != -EAGAIN)
+		if (ret) {
+			trans->block_rsv = &fs_info->trans_block_rsv;
+			btrfs_end_transaction(trans);
+			btrfs_btree_balance_dirty(fs_info);
+			if (ret != -ENOSPC && ret != -EAGAIN) {
+				btrfs_orphan_del(NULL, BTRFS_I(inode));
+				btrfs_free_block_rsv(fs_info, rsv);
+				goto no_delete;
+			}
+		} else {
 			break;
-
-		trans->block_rsv = &fs_info->trans_block_rsv;
-		btrfs_end_transaction(trans);
-		trans = NULL;
-		btrfs_btree_balance_dirty(fs_info);
+		}
 	}
 
 	btrfs_free_block_rsv(fs_info, rsv);
@@ -5345,12 +5350,8 @@ void btrfs_evict_inode(struct inode *inode)
 	 * Errors here aren't a big deal, it just means we leave orphan items
 	 * in the tree.  They will be cleaned up on the next mount.
 	 */
-	if (ret == 0) {
-		trans->block_rsv = root->orphan_block_rsv;
-		btrfs_orphan_del(trans, BTRFS_I(inode));
-	} else {
-		btrfs_orphan_del(NULL, BTRFS_I(inode));
-	}
+	trans->block_rsv = root->orphan_block_rsv;
+	btrfs_orphan_del(trans, BTRFS_I(inode));
 
 	trans->block_rsv = &fs_info->trans_block_rsv;
 	if (!(root == fs_info->tree_root ||
-- 
2.17.0

