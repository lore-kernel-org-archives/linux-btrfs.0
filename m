From: Sage Weil <sage@newdream.net>
Subject: [PATCH] Btrfs: fix deadlock with free space handling and user
 transactions
Date: Thu, 24 Sep 2009 14:58:07 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0909241456470.5597@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

If an ioctl-initiated transaction is open, we can't force a commit during 
the free space checks in order to free up pinned extents or else we 
deadlock.  Just ENOSPC instead.

A more satisfying solution that reserves space for the entire user
transaction up front is forthcoming...

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/extent-tree.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 90d314e..63d86ae 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2813,7 +2813,7 @@ alloc:
 		}
 		spin_unlock(&meta_sinfo->lock);
 
-		if (!committed) {
+		if (!committed && !root->fs_info->open_ioctl_trans) {
 			committed = 1;
 			trans = btrfs_join_transaction(root, 1);
 			if (!trans)
@@ -2887,7 +2887,7 @@ alloc:
 		spin_unlock(&data_sinfo->lock);
 
 		/* commit the current transaction and try again */
-		if (!committed) {
+		if (!committed && !root->fs_info->open_ioctl_trans) {
 			committed = 1;
 			trans = btrfs_join_transaction(root, 1);
 			if (!trans)
-- 
1.5.6.5

