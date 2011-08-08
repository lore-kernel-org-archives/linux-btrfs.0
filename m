From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: kill btrfs_truncate_reserve_metadata
Date: Mon,  8 Aug 2011 14:25:04 -0400
Message-ID: <1312827904-16656-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Since we've optimized the truncate path, we no longer require this function.

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.h       |    3 ---
 fs/btrfs/extent-tree.c |   31 -------------------------------
 2 files changed, 0 insertions(+), 34 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index edc1cf0..a8d8762 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2242,9 +2242,6 @@ int btrfs_block_rsv_migrate(struct btrfs_block_rsv *src_rsv,
 void btrfs_block_rsv_release(struct btrfs_root *root,
 			     struct btrfs_block_rsv *block_rsv,
 			     u64 num_bytes);
-int btrfs_truncate_reserve_metadata(struct btrfs_trans_handle *trans,
-				    struct btrfs_root *root,
-				    struct btrfs_block_rsv *rsv);
 int btrfs_set_block_group_ro(struct btrfs_root *root,
 			     struct btrfs_block_group_cache *cache);
 int btrfs_set_block_group_rw(struct btrfs_root *root,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9e602d8..6557966 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3858,37 +3858,6 @@ static void release_global_block_rsv(struct btrfs_fs_info *fs_info)
 	WARN_ON(fs_info->chunk_block_rsv.reserved > 0);
 }
 
-int btrfs_truncate_reserve_metadata(struct btrfs_trans_handle *trans,
-				    struct btrfs_root *root,
-				    struct btrfs_block_rsv *rsv)
-{
-	struct btrfs_block_rsv *trans_rsv = &root->fs_info->trans_block_rsv;
-	u64 num_bytes;
-	int ret;
-
-	/*
-	 * Truncate should be freeing data, but give us 2 items just in case it
-	 * needs to use some space.  We may want to be smarter about this in the
-	 * future.
-	 */
-	num_bytes = btrfs_calc_trans_metadata_size(root, 2);
-
-	/* We already have enough bytes, just return */
-	if (rsv->reserved >= num_bytes)
-		return 0;
-
-	num_bytes -= rsv->reserved;
-
-	/*
-	 * You should have reserved enough space before hand to do this, so this
-	 * should not fail.
-	 */
-	ret = block_rsv_migrate_bytes(trans_rsv, rsv, num_bytes);
-	BUG_ON(ret);
-
-	return 0;
-}
-
 void btrfs_trans_release_metadata(struct btrfs_trans_handle *trans,
 				  struct btrfs_root *root)
 {
-- 
1.7.5.2

