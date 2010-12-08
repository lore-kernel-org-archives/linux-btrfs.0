From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: do not BUG if we fail to remove the orphan item for dead snapshots
Date: Wed,  8 Dec 2010 12:25:42 -0500
Message-ID: <1291829142-22255-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Not being able to delete an orphan item isn't a horrible thing.  The worst that
happens is the next time around we try and do the orphan cleanup and we can't
find the referenced object and just delete the item and move on.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8aed05e..8c26441 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6354,7 +6354,6 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 		if (ret > 0) {
 			ret = btrfs_del_orphan_item(trans, tree_root,
 						    root->root_key.objectid);
-			BUG_ON(ret);
 		}
 	}
 
-- 
1.6.6.1

