From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] Btrfs: try committing transaction before returning ENOSPC
Date: Thu, 19 Feb 2009 13:13:15 -0500
Message-ID: <1235067195-13106-1-git-send-email-jbacik@redhat.com>
Cc: Josef Bacik <jbacik@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <>
List-ID: <linux-btrfs.vger.kernel.org>

This fixes a problem where we could return -ENOSPC when we may actually have
plenty of space, the space is just pinned.  Instead of returning -ENOSPC
immediately, commit the transaction first and then try and do the allocation
again.  This patch also does chunk allocation for metadata if we pass the 80%
threshold for metadata space.  This will help with stack usage since the chunk
allocation will happen early on, instead of when the allocation is happening.

Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 fs/btrfs/extent-tree.c |   57 +++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 47 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 22cedbd..d4bdb2a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2270,26 +2270,49 @@ int btrfs_check_metadata_free_space(struct btrfs_root *root)
 	struct btrfs_fs_info *info = root->fs_info;
 	struct btrfs_space_info *meta_sinfo;
 	u64 alloc_target, thresh;
+	int committed = 0, ret;
 
 	/* get the space info for where the metadata will live */
 	alloc_target = btrfs_get_alloc_profile(root, 0);
 	meta_sinfo = __find_space_info(info, alloc_target);
 
-	/*
-	 * if the metadata area isn't maxed out then there is no sense in
-	 * checking how much is used, since we can always allocate a new chunk
-	 */
-	if (!meta_sinfo->full)
-		return 0;
-
+again:
 	spin_lock(&meta_sinfo->lock);
-	thresh = meta_sinfo->total_bytes * 95;
+	if (!meta_sinfo->full)
+		thresh = meta_sinfo->total_bytes * 80;
+	else
+		thresh = meta_sinfo->total_bytes * 95;
 
 	do_div(thresh, 100);
 
 	if (meta_sinfo->bytes_used + meta_sinfo->bytes_reserved +
 	    meta_sinfo->bytes_pinned + meta_sinfo->bytes_readonly > thresh) {
+		struct btrfs_trans_handle *trans;
+		if (!meta_sinfo->full) {
+			meta_sinfo->force_alloc = 1;
+			spin_unlock(&meta_sinfo->lock);
+
+			trans = btrfs_start_transaction(root, 1);
+			if (!trans)
+				return -ENOMEM;
+
+			ret = do_chunk_alloc(trans, root->fs_info->extent_root,
+					     2 * 1024 * 1024, alloc_target, 0);
+			btrfs_end_transaction(trans, root);
+			goto again;
+		}
 		spin_unlock(&meta_sinfo->lock);
+
+		if (!committed) {
+			committed = 1;
+			trans = btrfs_join_transaction(root, 1);
+			if (!trans)
+				return -ENOMEM;
+			ret = btrfs_commit_transaction(trans, root);
+			if (ret)
+				return ret;
+			goto again;
+		}
 		return -ENOSPC;
 	}
 	spin_unlock(&meta_sinfo->lock);
@@ -2305,7 +2328,7 @@ int btrfs_check_data_free_space(struct btrfs_root *root, struct inode *inode,
 				u64 bytes)
 {
 	struct btrfs_space_info *data_sinfo;
-	int ret = 0;
+	int ret = 0, committed = 0;
 
 	/* make sure bytes are sectorsize aligned */
 	bytes = (bytes + root->sectorsize - 1) & ~((u64)root->sectorsize - 1);
@@ -2318,13 +2341,14 @@ again:
 	    data_sinfo->bytes_delalloc - data_sinfo->bytes_reserved -
 	    data_sinfo->bytes_pinned - data_sinfo->bytes_readonly -
 	    data_sinfo->bytes_may_use < bytes) {
+		struct btrfs_trans_handle *trans;
+
 		/*
 		 * if we don't have enough free bytes in this space then we need
 		 * to alloc a new chunk.
 		 */
 		if (!data_sinfo->full) {
 			u64 alloc_target;
-			struct btrfs_trans_handle *trans;
 
 			data_sinfo->force_alloc = 1;
 			spin_unlock(&data_sinfo->lock);
@@ -2343,6 +2367,19 @@ again:
 			goto again;
 		}
 		spin_unlock(&data_sinfo->lock);
+
+		/* commit the current transaction and try again */
+		if (!committed) {
+			committed = 1;
+			trans = btrfs_join_transaction(root, 1);
+			if (!trans)
+				return -ENOMEM;
+			ret = btrfs_commit_transaction(trans, root);
+			if (ret)
+				return ret;
+			goto again;
+		}
+
 		printk(KERN_ERR "no space left, need %llu, %llu delalloc bytes"
 		       ", %llu bytes_used, %llu bytes_reserved, "
 		       "%llu bytes_pinned, %llu bytes_readonly, %llu may use"
-- 
1.5.4.3

