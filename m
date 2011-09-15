From: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 13/20] btrfs: Go readonly on tree errors in balance_level
Date: Thu, 15 Sep 2011 10:34:52 -0700
Message-ID: <1316108099-5099-14-git-send-email-mfasheh@suse.de>
References: <1316108099-5099-1-git-send-email-mfasheh@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>,
	Mark Fasheh <mfasheh@suse.de>, Mark Fasheh <mfasheh@suse.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1316108099-5099-1-git-send-email-mfasheh@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

From: Mark Fasheh <mfasheh@suse.com>

balace_level() seems to deal with missing tree nodes by BUG_ON(). Instead,
we can easily just set the file system readonly and bubble -EROFS back up
the stack.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/btrfs/ctree.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 011cab3..dfb061b 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -918,7 +918,12 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 
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
@@ -1019,7 +1024,11 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
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
1.7.6

