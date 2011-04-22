From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 04/12] btrfs: unify checking of IS_ERR and null
Date: Fri, 22 Apr 2011 11:41:44 +0200
Message-ID: <2b3c6d55af77e02173521a2a22b58138da498f6d.1303398927.git.dsterba@suse.cz>
References: <cover.1303398927.git.dsterba@suse.cz>
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1303398927.git.dsterba@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

use IS_ERR_OR_NULL when possible, done by this coccinelle script:

@ match @
identifier id;
@@
(
- BUG_ON(IS_ERR(id) || !id);
+ BUG_ON(IS_ERR_OR_NULL(id));
|
- IS_ERR(id) || !id
+ IS_ERR_OR_NULL(id)
|
- !id || IS_ERR(id)
+ IS_ERR_OR_NULL(id)
)

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/acl.c        |    2 +-
 fs/btrfs/extent_io.c  |   12 ++++++------
 fs/btrfs/file.c       |    2 +-
 fs/btrfs/inode.c      |   12 ++++++------
 fs/btrfs/relocation.c |    2 +-
 fs/btrfs/tree-log.c   |    4 ++--
 6 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 5d505aa..1a21c99 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -287,7 +287,7 @@ int btrfs_acl_chmod(struct inode *inode)
 		return 0;
 
 	acl = btrfs_get_acl(inode, ACL_TYPE_ACCESS);
-	if (IS_ERR(acl) || !acl)
+	if (IS_ERR_OR_NULL(acl))
 		return PTR_ERR(acl);
 
 	clone = posix_acl_clone(acl, GFP_KERNEL);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 5fc8f37..29909b1 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2056,7 +2056,7 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 		}
 		em = get_extent(inode, page, pg_offset, cur,
 				end - cur + 1, 0);
-		if (IS_ERR(em) || !em) {
+		if (IS_ERR_OR_NULL(em)) {
 			SetPageError(page);
 			unlock_extent(tree, cur, end, GFP_NOFS);
 			break;
@@ -2341,7 +2341,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 		}
 		em = epd->get_extent(inode, page, pg_offset, cur,
 				     end - cur + 1, 1);
-		if (IS_ERR(em) || !em) {
+		if (IS_ERR_OR_NULL(em)) {
 			SetPageError(page);
 			break;
 		}
@@ -2769,7 +2769,7 @@ int extent_prepare_write(struct extent_io_tree *tree,
 	while (block_start <= block_end) {
 		em = get_extent(inode, page, pg_offset, block_start,
 				block_end - block_start + 1, 1);
-		if (IS_ERR(em) || !em)
+		if (IS_ERR_OR_NULL(em))
 			goto err;
 
 		cur_end = min(block_end, extent_map_end(em) - 1);
@@ -2899,7 +2899,7 @@ int try_release_extent_mapping(struct extent_map_tree *map,
 			len = end - start + 1;
 			write_lock(&map->lock);
 			em = lookup_extent_mapping(map, start, len);
-			if (!em || IS_ERR(em)) {
+			if (IS_ERR_OR_NULL(em)) {
 				write_unlock(&map->lock);
 				break;
 			}
@@ -2942,7 +2942,7 @@ sector_t extent_bmap(struct address_space *mapping, sector_t iblock,
 	em = get_extent(inode, NULL, 0, start, blksize, 0);
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, start,
 			     start + blksize - 1, &cached_state, GFP_NOFS);
-	if (!em || IS_ERR(em))
+	if (IS_ERR_OR_NULL(em))
 		return 0;
 
 	if (em->block_start > EXTENT_MAP_LAST_BYTE)
@@ -2976,7 +2976,7 @@ static struct extent_map *get_extent_skip_holes(struct inode *inode,
 			break;
 		len = (len + sectorsize - 1) & ~(sectorsize - 1);
 		em = get_extent(inode, NULL, 0, offset, len, 0);
-		if (!em || IS_ERR(em))
+		if (IS_ERR_OR_NULL(em))
 			return em;
 
 		/* if this isn't a hole return it */
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 75899a0..83abd27 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1375,7 +1375,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 	while (1) {
 		em = btrfs_get_extent(inode, NULL, 0, cur_offset,
 				      alloc_end - cur_offset, 0);
-		BUG_ON(IS_ERR(em) || !em);
+		BUG_ON(IS_ERR_OR_NULL(em));
 		last_byte = min(extent_map_end(em), alloc_end);
 		last_byte = (last_byte + mask) & ~mask;
 		if (em->block_start == EXTENT_MAP_HOLE ||
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b9a98d1..f1dc7a8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1854,7 +1854,7 @@ static int btrfs_io_failed_hook(struct bio *failed_bio,
 		}
 		read_unlock(&em_tree->lock);
 
-		if (!em || IS_ERR(em)) {
+		if (IS_ERR_OR_NULL(em)) {
 			kfree(failrec);
 			return -EIO;
 		}
@@ -3005,7 +3005,7 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 
 	di = btrfs_lookup_dir_item(trans, root, path, dir->i_ino,
 				   name, name_len, -1);
-	BUG_ON(!di || IS_ERR(di));
+	BUG_ON(IS_ERR_OR_NULL(di));
 
 	leaf = path->nodes[0];
 	btrfs_dir_item_key_to_cpu(leaf, di, &key);
@@ -3021,7 +3021,7 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 		BUG_ON(ret != -ENOENT);
 		di = btrfs_search_dir_index_item(root, path, dir->i_ino,
 						 name, name_len);
-		BUG_ON(!di || IS_ERR(di));
+		BUG_ON(IS_ERR_OR_NULL(di));
 
 		leaf = path->nodes[0];
 		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
@@ -3031,7 +3031,7 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 
 	di = btrfs_lookup_dir_index_item(trans, root, path, dir->i_ino,
 					 index, name, name_len, -1);
-	BUG_ON(!di || IS_ERR(di));
+	BUG_ON(IS_ERR_OR_NULL(di));
 
 	leaf = path->nodes[0];
 	btrfs_dir_item_key_to_cpu(leaf, di, &key);
@@ -3634,7 +3634,7 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
 	while (1) {
 		em = btrfs_get_extent(inode, NULL, 0, cur_offset,
 				block_end - cur_offset, 0);
-		BUG_ON(IS_ERR(em) || !em);
+		BUG_ON(IS_ERR_OR_NULL(em));
 		last_byte = min(extent_map_end(em), block_end);
 		last_byte = (last_byte + mask) & ~mask;
 		if (!test_bit(EXTENT_FLAG_PREALLOC, &em->flags)) {
@@ -3840,7 +3840,7 @@ static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
 	if (IS_ERR(di))
 		ret = PTR_ERR(di);
 
-	if (!di || IS_ERR(di))
+	if (IS_ERR_OR_NULL(di))
 		goto out_err;
 
 	btrfs_dir_item_key_to_cpu(path->nodes[0], di, location);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 199a801..fed0aae 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3220,7 +3220,7 @@ static int delete_block_group_cache(struct btrfs_fs_info *fs_info,
 	key.offset = 0;
 
 	inode = btrfs_iget(fs_info->sb, &key, root, NULL);
-	if (!inode || IS_ERR(inode) || is_bad_inode(inode)) {
+	if (IS_ERR_OR_NULL(inode) || is_bad_inode(inode)) {
 		if (inode && !IS_ERR(inode))
 			iput(inode);
 		return -ENOENT;
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c50271a..6377ff6 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1205,7 +1205,7 @@ static noinline int replay_one_name(struct btrfs_trans_handle *trans,
 	} else {
 		BUG();
 	}
-	if (!dst_di || IS_ERR(dst_di)) {
+	if (IS_ERR_OR_NULL(dst_di)) {
 		/* we need a sequence number to insert, so we only
 		 * do inserts for the BTRFS_DIR_INDEX_KEY types
 		 */
@@ -1426,7 +1426,7 @@ again:
 						     dir_key->offset,
 						     name, name_len, 0);
 		}
-		if (!log_di || IS_ERR(log_di)) {
+		if (IS_ERR_OR_NULL(log_di)) {
 			btrfs_dir_item_key_to_cpu(eb, di, &location);
 			btrfs_release_path(root, path);
 			btrfs_release_path(log, log_path);
-- 
1.7.5.rc3

