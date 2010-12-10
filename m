From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: do not BUG if we fail to remove the orphan item for dead snapshots UPDATED
Date: Fri, 10 Dec 2010 10:06:25 -0500
Message-ID: <1291993585-1782-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Not being able to delete an orphan item isn't a horrible thing.  The worst that
happens is the next time around we try and do the orphan cleanup and we can't
find the referenced object and just delete the item and move on.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
V1->V2: Added a comment to explain what we'r doing.
 fs/btrfs/extent-tree.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8aed05e..d2add51 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6352,9 +6352,14 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 					   NULL, NULL);
 		BUG_ON(ret < 0);
 		if (ret > 0) {
+			/*
+			 * Don't bother checking the return value, either we
+			 * succeeded or we did not, either way the orphan item
+			 * will get cleaned up properly, wether its now or on
+			 * the next mount.
+			 */
 			ret = btrfs_del_orphan_item(trans, tree_root,
 						    root->root_key.objectid);
-			BUG_ON(ret);
 		}
 	}
 
-- 
1.6.6.1

