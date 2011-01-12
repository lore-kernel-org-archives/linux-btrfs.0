From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: don't warn if we get ENOSPC in btrfs_block_rsv_check
Date: Wed, 12 Jan 2011 16:04:22 -0500
Message-ID: <1294866262-16693-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If we run low on space we could get a bunch of warnings out of
btrfs_block_rsv_check, but this is mostly just called via the transaction code
to see if we need to end the transaction, it expects to see failures, so let's
not WARN and freak everybody out for no reason.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d2add51..c93293a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3720,11 +3720,6 @@ int btrfs_block_rsv_check(struct btrfs_trans_handle *trans,
 		return 0;
 	}
 
-	WARN_ON(1);
-	printk(KERN_INFO"block_rsv size %llu reserved %llu freed %llu %llu\n",
-		block_rsv->size, block_rsv->reserved,
-		block_rsv->freed[0], block_rsv->freed[1]);
-
 	return -ENOSPC;
 }
 
-- 
1.6.6.1

