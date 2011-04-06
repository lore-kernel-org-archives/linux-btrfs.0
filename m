From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: reuse the extent_map we found when calling btrfs_get_extent
Date: Wed,  6 Apr 2011 14:56:39 -0400
Message-ID: <1302116199-3418-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs_get_block_direct we call btrfs_get_extent to lookup the extent for the
range that we are looking for.  If we don't find an extent, btrfs_get_extent
will insert a extent_map for that area and mark it as a hole.  So it does the
job of allocating a new extent map and inserting it into the io tree.  But if
we're creating a new extent we free it up and redo all of that work.  So instead
pass the em to btrfs_new_extent_direct(), and if it will work just allocate the
disk space and set it up properly and bypass the freeing/allocating of a new
extent map and the expensive operation of inserting the thing into the io_tree.
Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |   36 ++++++++++++++++++++++++++++--------
 1 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 93ed346..032e8fb 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5443,17 +5443,30 @@ out:
 }
 
 static struct extent_map *btrfs_new_extent_direct(struct inode *inode,
+						  struct extent_map *em,
 						  u64 start, u64 len)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_trans_handle *trans;
-	struct extent_map *em;
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
 	struct btrfs_key ins;
 	u64 alloc_hint;
 	int ret;
+	bool insert = false;
 
-	btrfs_drop_extent_cache(inode, start, start + len - 1, 0);
+	/*
+	 * Ok if the extent map we looked up is a hole and is for the exact
+	 * range we want, there is no reason to allocate a new one, however if
+	 * it is not right then we need to free this one and drop the cache for
+	 * our range.
+	 */
+	if (em->block_start != EXTENT_MAP_HOLE || em->start != start ||
+	    em->len != len) {
+		free_extent_map(em);
+		em = NULL;
+		insert = true;
+		btrfs_drop_extent_cache(inode, start, start + len - 1, 0);
+	}
 
 	trans = btrfs_join_transaction(root, 0);
 	if (IS_ERR(trans))
@@ -5469,10 +5482,12 @@ static struct extent_map *btrfs_new_extent_direct(struct inode *inode,
 		goto out;
 	}
 
-	em = alloc_extent_map(GFP_NOFS);
 	if (!em) {
-		em = ERR_PTR(-ENOMEM);
-		goto out;
+		em = alloc_extent_map(GFP_NOFS);
+		if (!em) {
+			em = ERR_PTR(-ENOMEM);
+			goto out;
+		}
 	}
 
 	em->start = start;
@@ -5482,9 +5497,15 @@ static struct extent_map *btrfs_new_extent_direct(struct inode *inode,
 	em->block_start = ins.objectid;
 	em->block_len = ins.offset;
 	em->bdev = root->fs_info->fs_devices->latest_bdev;
+
+	/*
+	 * We need to do this because if we're using the original em we searched
+	 * for, we could have EXTENT_FLAG_VACANCY set, and we don't want that.
+	 */
+	em->flags = 0;
 	set_bit(EXTENT_FLAG_PINNED, &em->flags);
 
-	while (1) {
+	while (insert) {
 		write_lock(&em_tree->lock);
 		ret = add_extent_mapping(em_tree, em);
 		write_unlock(&em_tree->lock);
@@ -5702,8 +5723,7 @@ must_cow:
 	 * it above
 	 */
 	len = bh_result->b_size;
-	free_extent_map(em);
-	em = btrfs_new_extent_direct(inode, start, len);
+	em = btrfs_new_extent_direct(inode, em, start, len);
 	if (IS_ERR(em))
 		return PTR_ERR(em);
 	len = min(len, em->len - (start - em->start));
-- 
1.7.2.3

