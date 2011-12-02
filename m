From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: protect orphan block rsv with spin_lock
Date: Fri,  2 Dec 2011 15:44:36 -0500
Message-ID: <1322858676-4278-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org, sage@newdream.net
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We've been seeing warnings coming out of the orphan commit stuff forever from
ceph.  Turns out it's because we're racing with checking if the orphan block
reserve is set, because we clear it outside of the spin_lock.  So leave the
normal fastpath checks where they are, but take the spin_lock and _recheck_ to
make sure we haven't had an orphan block rsv added in the meantime.  Then clear
the root's orphan block rsv and release the lock.  With this patch a user said
the warnings went away and they usually showed up pretty soon after he started
ceph.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9ae9c2e..9de15f1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1951,12 +1951,28 @@ enum btrfs_orphan_cleanup_state {
 void btrfs_orphan_commit_root(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root)
 {
+	struct btrfs_block_rsv *block_rsv;
 	int ret;
 
 	if (!list_empty(&root->orphan_list) ||
 	    root->orphan_cleanup_state != ORPHAN_CLEANUP_DONE)
 		return;
 
+	spin_lock(&root->orphan_lock);
+	if (!list_empty(&root->orphan_list)) {
+		spin_unlock(&root->orphan_lock);
+		return;
+	}
+
+	if (root->orphan_cleanup_state != ORPHAN_CLEANUP_DONE) {
+		spin_unlock(&root->orphan_lock);
+		return;
+	}
+
+	block_rsv = root->orphan_block_rsv;
+	root->orphan_block_rsv = NULL;
+	spin_unlock(&root->orphan_lock);
+
 	if (root->orphan_item_inserted &&
 	    btrfs_root_refs(&root->root_item) > 0) {
 		ret = btrfs_del_orphan_item(trans, root->fs_info->tree_root,
@@ -1965,10 +1981,9 @@ void btrfs_orphan_commit_root(struct btrfs_trans_handle *trans,
 		root->orphan_item_inserted = 0;
 	}
 
-	if (root->orphan_block_rsv) {
-		WARN_ON(root->orphan_block_rsv->size > 0);
-		btrfs_free_block_rsv(root, root->orphan_block_rsv);
-		root->orphan_block_rsv = NULL;
+	if (block_rsv) {
+		WARN_ON(block_rsv->size > 0);
+		btrfs_free_block_rsv(root, block_rsv);
 	}
 }
 
-- 
1.7.5.2

