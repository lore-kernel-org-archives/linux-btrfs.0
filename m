From: Sage Weil <sage@newdream.net>
Subject: [PATCH] Btrfs: avoid BUG when dropping root and reference in same transaction
Date: Mon, 17 May 2010 10:15:27 -0700
Message-ID: <1274116527-12361-1-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If btrfs_ioctl_snap_destroy() deletes a snapshot but finishes
with end_transaction(), the cleaner kthread may come in and
drop the root in the same transaction.  If that's the case, the
root's refs still == 1 in the tree when btrfs_del_root() deletes
the item, because commit_fs_roots() hasn't updated it yet (that
happens during the commit).

This wasn't a problem before only because
btrfs_ioctl_snap_destroy() would commit the transaction before dropping
the dentry reference, so the dead root wouldn't get queued up until
after the fs root item was updated in the btree.

Since it is not an error to drop the root reference and the root in the
same transaction, just drop the BUG_ON() in btrfs_del_root().

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/root-tree.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 67fa2d2..7cb5041 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -313,7 +313,6 @@ int btrfs_del_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 {
 	struct btrfs_path *path;
 	int ret;
-	u32 refs;
 	struct btrfs_root_item *ri;
 	struct extent_buffer *leaf;
 
@@ -327,8 +326,6 @@ int btrfs_del_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	leaf = path->nodes[0];
 	ri = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_root_item);
 
-	refs = btrfs_disk_root_refs(leaf, ri);
-	BUG_ON(refs != 0);
 	ret = btrfs_del_item(trans, root, path);
 out:
 	btrfs_free_path(path);
-- 
1.6.6.1

