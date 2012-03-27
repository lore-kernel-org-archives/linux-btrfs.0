From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 10/10] Btrfs: drop cache with VACANCY em when we fail to start a transaction
Date: Tue, 27 Mar 2012 14:44:38 +0800
Message-ID: <1332830678-3992-11-git-send-email-liubo2009@cn.fujitsu.com>
References: <1332830678-3992-1-git-send-email-liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1332830678-3992-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

We need to clean a VACANCY em(if we have) when we fail to start a transaction.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/inode.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index bacf441..2b2f0b6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3406,9 +3406,6 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
 				break;
 			}
 
-			btrfs_drop_extent_cache(inode, hole_start,
-					last_byte - 1, 0);
-
 			btrfs_update_inode(trans, root, inode);
 			btrfs_end_transaction(trans, root);
 		}
@@ -3419,6 +3416,9 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
 			break;
 	}
 
+	if (em && test_bit(EXTENT_FLAG_VACANCY, &em->flags))
+		btrfs_drop_extent_cache(inode, hole_start, last_byte - 1, 0);
+
 	free_extent_map(em);
 	unlock_extent_cached(io_tree, hole_start, block_end - 1, &cached_state,
 			     GFP_NOFS);
-- 
1.6.5.2

