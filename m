From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 78/99] btrfs: btrfs_free_extent void return prep
Date: Wed, 23 Nov 2011 19:36:51 -0500
Message-ID: <20111124004228.847090667@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 btrfs_free_extent has no error conditions, but is used via process_func
 in __btrfs_mod_ref which requires it to return an int.

 This patch cleans up the callers to eliminate error handling that will
 never be used. The next patch makes both btrfs_free_extent and the other
 function used via process_func, btrfs_inc_extent_ref, return void.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent-tree.c |    8 +++-----
 fs/btrfs/file.c        |   23 +++++++++--------------
 fs/btrfs/inode.c       |    9 ++++-----
 fs/btrfs/relocation.c  |   23 +++++++++--------------
 4 files changed, 25 insertions(+), 38 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index fe95f37..dc91e4d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4805,13 +4805,12 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 		      u64 bytenr, u64 num_bytes, u64 parent,
 		      u64 root_objectid, u64 owner, u64 offset)
 {
-	int ret;
-
 	/*
 	 * tree log blocks never actually go into the extent allocation
 	 * tree, just update pinning info and exit early.
 	 */
 	if (root_objectid == BTRFS_TREE_LOG_OBJECTID) {
+		int ret;
 		WARN_ON(owner >= BTRFS_FIRST_FREE_OBJECTID);
 		/* unlocks the pinned mutex */
 		ret = btrfs_pin_extent(root, bytenr, num_bytes, 1);
@@ -6142,9 +6141,8 @@ skip:
 			parent = 0;
 		}
 
-		ret = btrfs_free_extent(trans, root, bytenr, blocksize, parent,
-					root->root_key.objectid, level - 1, 0);
-		BUG_ON(ret);
+		btrfs_free_extent(trans, root, bytenr, blocksize, parent,
+				  root->root_key.objectid, level - 1, 0);
 	}
 	btrfs_tree_unlock(next);
 	free_extent_buffer(next);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 314c08e..fa8f83e 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -747,12 +747,11 @@ next_slot:
 				extent_end = ALIGN(extent_end,
 						   root->sectorsize);
 			} else if (disk_bytenr > 0) {
-				ret = btrfs_free_extent(trans, root,
-						disk_bytenr, num_bytes, 0,
-						root->root_key.objectid,
-						key.objectid, key.offset -
-						extent_offset);
-				BUG_ON(ret);
+				btrfs_free_extent(trans, root,
+						  disk_bytenr, num_bytes, 0,
+						  root->root_key.objectid,
+						  key.objectid, key.offset -
+						  extent_offset);
 				inode_sub_bytes(inode,
 						extent_end - key.offset);
 				*hint_byte = disk_bytenr;
@@ -984,10 +983,8 @@ again:
 		extent_end = other_end;
 		del_slot = path->slots[0] + 1;
 		del_nr++;
-		ret = btrfs_free_extent(trans, root, bytenr, num_bytes,
-					0, root->root_key.objectid,
-					ino, orig_offset);
-		BUG_ON(ret);
+		btrfs_free_extent(trans, root, bytenr, num_bytes, 0,
+				  root->root_key.objectid, ino, orig_offset);
 	}
 	other_start = 0;
 	other_end = start;
@@ -1001,10 +998,8 @@ again:
 		key.offset = other_start;
 		del_slot = path->slots[0];
 		del_nr++;
-		ret = btrfs_free_extent(trans, root, bytenr, num_bytes,
-					0, root->root_key.objectid,
-					ino, orig_offset);
-		BUG_ON(ret);
+		btrfs_free_extent(trans, root, bytenr, num_bytes, 0,
+				  root->root_key.objectid, ino, orig_offset);
 	}
 	if (del_nr == 0) {
 		fi = btrfs_item_ptr(leaf, path->slots[0],
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 46f3d4a..d8bb54e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3270,11 +3270,10 @@ delete:
 		if (found_extent && (root->ref_cows ||
 				     root == root->fs_info->tree_root)) {
 			btrfs_set_path_blocking(path);
-			ret = btrfs_free_extent(trans, root, extent_start,
-						extent_num_bytes, 0,
-						btrfs_header_owner(leaf),
-						ino, extent_offset);
-			BUG_ON(ret);
+			btrfs_free_extent(trans, root, extent_start,
+					  extent_num_bytes, 0,
+					  btrfs_header_owner(leaf),
+					  ino, extent_offset);
 		}
 
 		if (found_type == BTRFS_INODE_ITEM_KEY)
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 4c65c4e..c59eb2c 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1633,10 +1633,9 @@ int replace_file_extents(struct btrfs_trans_handle *trans,
 				     btrfs_header_owner(leaf),
 				     key.objectid, key.offset);
 
-		ret = btrfs_free_extent(trans, root, bytenr, num_bytes,
-					parent, btrfs_header_owner(leaf),
-					key.objectid, key.offset);
-		BUG_ON(ret);
+		btrfs_free_extent(trans, root, bytenr, num_bytes,
+				  parent, btrfs_header_owner(leaf),
+				  key.objectid, key.offset);
 	}
 	if (dirty)
 		btrfs_mark_buffer_dirty(leaf);
@@ -1807,16 +1806,12 @@ again:
 				     src->root_key.objectid, level - 1, 0);
 		btrfs_inc_extent_ref(trans, dest, new_bytenr, blocksize,
 				     0, dest->root_key.objectid, level - 1, 0);
-		ret = btrfs_free_extent(trans, src, new_bytenr, blocksize,
-					path->nodes[level]->start,
-					src->root_key.objectid, level - 1, 0);
-		BUG_ON(ret);
-
-		ret = btrfs_free_extent(trans, dest, old_bytenr, blocksize,
-					0, dest->root_key.objectid, level - 1,
-					0);
-		BUG_ON(ret);
-
+		btrfs_free_extent(trans, src, new_bytenr, blocksize,
+				  path->nodes[level]->start,
+				  src->root_key.objectid, level - 1, 0);
+		btrfs_free_extent(trans, dest, old_bytenr, blocksize,
+				  0, dest->root_key.objectid, level - 1,
+				  0);
 		btrfs_unlock_up_safe(path, 0);
 
 		ret = level;



