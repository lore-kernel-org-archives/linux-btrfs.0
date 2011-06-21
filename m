From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 10/12 v3] Btrfs: deal with EEXIST after iput
Date: Tue, 21 Jun 2011 16:49:51 +0800
Message-ID: <1308646193-7086-11-git-send-email-liubo2009@cn.fujitsu.com>
References: <1308646193-7086-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <dave@jikos.cz>, <chris.mason@oracle.com>, <josef@redhat.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1308646193-7086-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

There are two cases when BTRFS_I(inode)->logged_trans is zero:
a) an inode is just allocated;
b) iput an inode and reread it.

However, in b) if btrfs is not committed yet, and this inode _may_ still remain
in log tree.

So we need to check the log tree to get logged_trans a right value
in case it hits a EEXIST while logging.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/inode.c    |    9 +++------
 fs/btrfs/tree-log.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0007ae3..6eff806 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1786,12 +1786,9 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 	add_pending_csums(trans, inode, ordered_extent->file_offset,
 			  &ordered_extent->list);
 
-	ret = btrfs_ordered_update_i_size(inode, 0, ordered_extent);
-	if (!ret) {
-		ret = btrfs_update_inode(trans, root, inode);
-		BUG_ON(ret);
-	} else
-		btrfs_set_inode_last_trans(trans, inode);
+	btrfs_ordered_update_i_size(inode, 0, ordered_extent);
+	ret = btrfs_update_inode(trans, root, inode);
+	BUG_ON(ret);
 	ret = 0;
 out:
 	if (nolock) {
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f1e95bf..3cf7ed2 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3063,6 +3063,37 @@ out:
 	return ret;
 }
 
+static int check_logged_trans(struct btrfs_trans_handle *trans,
+			      struct btrfs_root *root, struct inode *inode)
+{
+	struct btrfs_inode_item *inode_item;
+	struct btrfs_path *path;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	ret = btrfs_search_slot(trans, root,
+				&BTRFS_I(inode)->location, path, 0, 0);
+	if (ret) {
+		if (ret > 0)
+			ret = 0;
+		goto out;
+	}
+
+	btrfs_unlock_up_safe(path, 1);
+	inode_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
+				    struct btrfs_inode_item);
+
+	BTRFS_I(inode)->logged_trans = btrfs_inode_transid(path->nodes[0],
+							   inode_item);
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
+
 static int inode_in_log(struct btrfs_trans_handle *trans,
 		 struct inode *inode)
 {
@@ -3115,6 +3146,18 @@ int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto end_no_trans;
 
+	/*
+	 * After we iput a inode and reread it from disk, logged_trans is 0.
+	 * However, this inode _may_ still remain in log tree and not be
+	 * committed yet.
+	 * So we need to check the log tree to get logged_trans a right value.
+	 */
+	if (!BTRFS_I(inode)->logged_trans && root->log_root) {
+		ret = check_logged_trans(trans, root->log_root, inode);
+		if (ret)
+			goto end_no_trans;
+	}
+
 	if (inode_in_log(trans, inode)) {
 		ret = BTRFS_NO_LOG_SYNC;
 		goto end_no_trans;
-- 
1.6.5.2

