From: Sage Weil <sage@newdream.net>
Subject: [PATCH 1/2] Btrfs: refactor btrfs_check_data_free_space
Date: Fri, 25 Sep 2009 14:10:55 -0700
Message-ID: <1253913056-8385-1-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Pull out the actual free space check, so setting an inode's initial
space_info is done by the caller instead of a wonky goto.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/extent-tree.c |   81 +++++++++++++++++++++++++++++------------------
 1 files changed, 50 insertions(+), 31 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 63d86ae..cb50944 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2830,25 +2830,33 @@ alloc:
 	return 0;
 }
 
-/*
- * This will check the space that the inode allocates from to make sure we have
- * enough space for bytes.
- */
-int btrfs_check_data_free_space(struct btrfs_root *root, struct inode *inode,
-				u64 bytes)
+static int __alloc_chunk(struct btrfs_root *root, u64 bytes)
 {
-	struct btrfs_space_info *data_sinfo;
-	int ret = 0, committed = 0;
+	int ret;
+	u64 alloc_target;
+	struct btrfs_trans_handle *trans;
 
-	/* make sure bytes are sectorsize aligned */
-	bytes = (bytes + root->sectorsize - 1) & ~((u64)root->sectorsize - 1);
+	alloc_target = btrfs_get_alloc_profile(root, 1);
+	trans = btrfs_start_transaction(root, 1);
+	if (!trans)
+		return -ENOMEM;
 
-	data_sinfo = BTRFS_I(inode)->space_info;
-	if (!data_sinfo)
-		goto alloc;
+	ret = do_chunk_alloc(trans, root->fs_info->extent_root,
+			     bytes + 2 * 1024 * 1024,
+			     alloc_target, 0);
+	btrfs_end_transaction(trans, root);
+	return ret;
+}
+
+int btrfs_check_data_free_space_info(struct btrfs_root *root,
+				     struct btrfs_space_info *data_sinfo,
+				     u64 bytes,
+				     struct inode *inode)
+{
+	int ret = 0, committed = 0;
 
-again:
 	/* make sure we have enough space to handle the data first */
+again:
 	spin_lock(&data_sinfo->lock);
 	if (data_sinfo->total_bytes - data_sinfo->bytes_used -
 	    data_sinfo->bytes_delalloc - data_sinfo->bytes_reserved -
@@ -2861,27 +2869,11 @@ again:
 		 * to alloc a new chunk.
 		 */
 		if (!data_sinfo->full) {
-			u64 alloc_target;
-
 			data_sinfo->force_alloc = 1;
 			spin_unlock(&data_sinfo->lock);
-alloc:
-			alloc_target = btrfs_get_alloc_profile(root, 1);
-			trans = btrfs_start_transaction(root, 1);
-			if (!trans)
-				return -ENOMEM;
-
-			ret = do_chunk_alloc(trans, root->fs_info->extent_root,
-					     bytes + 2 * 1024 * 1024,
-					     alloc_target, 0);
-			btrfs_end_transaction(trans, root);
+			ret = __alloc_chunk(root, bytes);
 			if (ret)
 				return ret;
-
-			if (!data_sinfo) {
-				btrfs_set_inode_space_info(root, inode);
-				data_sinfo = BTRFS_I(inode)->space_info;
-			}
 			goto again;
 		}
 		spin_unlock(&data_sinfo->lock);
@@ -2914,7 +2906,34 @@ alloc:
 	data_sinfo->bytes_may_use += bytes;
 	BTRFS_I(inode)->reserved_bytes += bytes;
 	spin_unlock(&data_sinfo->lock);
+	return 0;
+}
 
+/*
+ * This will check the space that the inode allocates from to make sure we have
+ * enough space for bytes.
+ */
+int btrfs_check_data_free_space(struct btrfs_root *root, struct inode *inode,
+				u64 bytes)
+{
+	struct btrfs_space_info *data_sinfo;
+	int ret;
+
+	/* make sure bytes are sectorsize aligned */
+	bytes = (bytes + root->sectorsize - 1) & ~((u64)root->sectorsize - 1);
+
+	data_sinfo = BTRFS_I(inode)->space_info;
+	if (!data_sinfo) {
+		ret = __alloc_chunk(root, bytes);
+		if (ret)
+			return ret;
+		btrfs_set_inode_space_info(root, inode);
+		data_sinfo = BTRFS_I(inode)->space_info;
+	}
+
+	ret = btrfs_check_data_free_space_info(root, data_sinfo, bytes, inode);
+	if (ret)
+		return ret;
 	return btrfs_check_metadata_free_space(root);
 }
 
-- 
1.5.6.5

