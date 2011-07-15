From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: don't flush delalloc arbitrarily
Date: Fri, 15 Jul 2011 12:01:03 -0400
Message-ID: <1310745663-17155-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Kill the check to see if we have 512mb of reserved space in delalloc and
shrink_delalloc if we do.  This causes unexpected latencies and we have other
logic to see if we need to throttle.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c6a2daa..2e0f87b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4019,9 +4019,6 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 
 	block_rsv_add_bytes(block_rsv, to_reserve, 1);
 
-	if (block_rsv->size > 512 * 1024 * 1024)
-		shrink_delalloc(NULL, root, to_reserve, 0);
-
 	return 0;
 }
 
-- 
1.7.5.2

