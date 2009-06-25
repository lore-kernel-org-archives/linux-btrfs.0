From: Sage Weil <sage@newdream.net>
Subject: [PATCH] btrfs: make flushoncommit correctly wait on ordered_extents
Date: Thu, 25 Jun 2009 14:39:13 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0906221427300.9993@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

The commit_transaction call to wait_ordered_extents when snap_pending 
passes nocow_only=1 to process only NOCOW or PREALLOC extents.  This isn't 
correct for the 'flushoncommit' mode, as it skips extents we just started 
IO on in start_delalloc_inodes.

So, in the flushoncommit case, wait on all ordered extents.  Otherwise,
only pass the nocow_only flag to wait_ordered_extents if snap_pending.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/transaction.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 2e177d7..762e766 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -941,9 +941,11 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 
 		mutex_unlock(&root->fs_info->trans_mutex);
 
-		if (flush_on_commit || snap_pending) {
-			if (flush_on_commit)
-				btrfs_start_delalloc_inodes(root);
+		if (flush_on_commit) {
+			btrfs_start_delalloc_inodes(root);
+			ret = btrfs_wait_ordered_extents(root, 0);
+			BUG_ON(ret);
+		} else if (snap_pending) {
 			ret = btrfs_wait_ordered_extents(root, 1);
 			BUG_ON(ret);
 		}
-- 
1.5.6.5

