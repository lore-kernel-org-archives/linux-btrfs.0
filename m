From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 4/5] Btrfs: filter shared blocks in should_cow_block
Date: Mon, 21 Nov 2011 18:10:23 +0800
Message-ID: <1321870224-20241-5-git-send-email-liubo2009@cn.fujitsu.com>
References: <1321870224-20241-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <chris.mason@oracle.com>, <sensille@gmx.net>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1321870224-20241-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

We've suffered some transid mismatches by using sub transid,
here is a case:

before:
   parent A (gen = x)     parent B(gen = x)
           \                    /
            \                  /
             \                /
              block C (gen = x)

After We can update block C via parent A:
   parent A (gen = x + 1)     parent B(gen = x)
           \                    /
            \                  /
             \                /
              block C (gen = x + 1)

We'll get a mismatch between parent B and block C.

Fix it by:
COW the block if it can be shared and its gen is not same with sub transid.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/ctree.c |   32 +++++++++++++++++++++-----------
 1 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 2b38acd..6cc9529 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -575,23 +575,33 @@ static inline int should_cow_block(struct btrfs_trans_handle *trans,
 	smp_rmb();
 
 	/*
-	 * We do not need to cow a block if
-	 * 1) this block is not created or changed in this transaction;
-	 * 2) this block does not belong to TREE_RELOC tree;
-	 * 3) the root is not forced COW.
+	 * We should cow a block if
+	 * 1) the root is forced COW,
+	 * 2) this block has not been updated in the current transaction,
+	 * 3) this block has been writeback on disk in the current transactoin,
+	 * 4) this block belongs to TREE_RELOC tree.
+	 * 5) this block may be shared, and its generation is not transid
+	 *    (we need to ensure every parents has a proper node_ptr_gen)
 	 *
 	 * What is forced COW:
 	 *    when we create snapshot during commiting the transaction,
 	 *    after we've finished coping src root, we must COW the shared
 	 *    block to ensure the metadata consistency.
 	 */
-	if (btrfs_header_generation(buf) >= trans->transaction->transid &&
-	    !btrfs_header_flag(buf, BTRFS_HEADER_FLAG_WRITTEN) &&
-	    !(root->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID &&
-	      btrfs_header_flag(buf, BTRFS_HEADER_FLAG_RELOC)) &&
-	    !root->force_cow)
-		return 0;
-	return 1;
+	if (root->force_cow)
+		return 1;
+	if (btrfs_header_generation(buf) < trans->transaction->transid)
+		return 1;
+	if (btrfs_header_flag(buf, BTRFS_HEADER_FLAG_WRITTEN))
+		return 1;
+	if (root->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID &&
+	    btrfs_header_flag(buf, BTRFS_HEADER_FLAG_RELOC))
+		return 1;
+	if (btrfs_block_can_be_shared(root, buf) &&
+	    must_update_generation(trans, root, buf))
+		return 1;
+
+	return 0;
 }
 
 /*
-- 
1.6.5.2

