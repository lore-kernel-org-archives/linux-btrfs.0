From: Sage Weil <sage@newdream.net>
Subject: [PATCH 2/4] Btrfs: fix deadlock with free space handling and user transactions
Date: Tue, 29 Sep 2009 11:50:03 -0700
Message-ID: <1254250205-8175-2-git-send-email-sage@newdream.net>
References: <1254250205-8175-1-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1254250205-8175-1-git-send-email-sage@newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

If an ioctl-initiated transaction is open, we can't force a commit during
the free space checks in order to free up pinned extents or else we
deadlock.  Just ENOSPC instead.

A more satisfying solution that reserves space for the entire user
transaction up front is forthcoming...

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/extent-tree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a4b2b03..d119c03 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3168,7 +3168,7 @@ alloc:
 		spin_unlock(&data_sinfo->lock);
 
 		/* commit the current transaction and try again */
-		if (!committed) {
+		if (!committed && !root->fs_info->open_ioctl_trans) {
 			committed = 1;
 			trans = btrfs_join_transaction(root, 1);
 			if (!trans)
-- 
1.5.6.5

