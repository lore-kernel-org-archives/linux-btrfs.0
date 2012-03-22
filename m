From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 25/35] btrfs: Go readonly on tree errors in balance_level
Date: Wed, 21 Mar 2012 21:11:29 -0400
Message-ID: <20120322011136.505943093@suse.com>
References: <20120322011104.212214639@suse.com>
Cc: David Sterba <dsterba@suse.com>, Mark Fasheh <mfasheh@suse.com>
To: Linux Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

balace_level() seems to deal with missing tree nodes by BUG_ON(). Instead,
we can easily just set the file system readonly and bubble -EROFS back up
the stack.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/btrfs/ctree.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 36e16bd..651a26a 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -944,7 +944,12 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 
 		/* promote the child to a root */
 		child = read_node_slot(root, mid, 0);
-		BUG_ON(!child);
+		if (!child) {
+			ret = -EROFS;
+			btrfs_std_error(root->fs_info, ret);
+			goto enospc;
+		}
+
 		btrfs_tree_lock(child);
 		btrfs_set_lock_blocking(child);
 		ret = btrfs_cow_block(trans, root, child, mid, 0, &child);
@@ -1042,7 +1047,11 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		 * otherwise we would have pulled some pointers from the
 		 * right
 		 */
-		BUG_ON(!left);
+		if (!left) {
+			ret = -EROFS;
+			btrfs_std_error(root->fs_info, ret);
+			goto enospc;
+		}
 		wret = balance_node_right(trans, root, mid, left);
 		if (wret < 0) {
 			ret = wret;
-- 
1.7.9



