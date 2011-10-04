From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 56/65] btrfs: btrfs_inc_extent_ref void return prep
Date: Mon, 03 Oct 2011 23:23:26 -0400
Message-ID: <20111004032306.333658589@suse.com>
References: <20111004032230.458853274@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: BtrFS List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 btrfs_inc_extent_ref has no error conditions, but is used via
 process_func in __btrfs_mod_ref which requires it to return an int.

 This patch cleans up the callers to eliminate error handling that will
 never be used. A later patch in this series makes both
 btrfs_inc_extent_ref and the other function used via process_func,
 btrfs_inc_extent_ref, return void.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/file.c       |   18 ++++++++----------
 fs/btrfs/ioctl.c      |    3 +--
 fs/btrfs/relocation.c |   34 ++++++++++++++--------------------
 fs/btrfs/tree-log.c   |    9 ++++-----
 4 files changed, 27 insertions(+), 37 deletions(-)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -673,12 +673,11 @@ next_slot:
 			btrfs_mark_buffer_dirty(leaf);
 
 			if (disk_bytenr > 0) {
-				ret = btrfs_inc_extent_ref(trans, root,
-						disk_bytenr, num_bytes, 0,
-						root->root_key.objectid,
-						new_key.objectid,
-						start - extent_offset);
-				BUG_ON(ret);
+				btrfs_inc_extent_ref(trans, root,
+						     disk_bytenr, num_bytes, 0,
+						     root->root_key.objectid,
+						     new_key.objectid,
+						     start - extent_offset);
 				*hint_byte = disk_bytenr;
 			}
 			key.offset = start;
@@ -959,10 +958,9 @@ again:
 						extent_end - split);
 		btrfs_mark_buffer_dirty(leaf);
 
-		ret = btrfs_inc_extent_ref(trans, root, bytenr, num_bytes, 0,
-					   root->root_key.objectid,
-					   ino, orig_offset);
-		BUG_ON(ret);
+		btrfs_inc_extent_ref(trans, root, bytenr, num_bytes, 0,
+				     root->root_key.objectid,
+				     ino, orig_offset);
 
 		if (split == start) {
 			key.offset = start;
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2396,12 +2396,11 @@ static noinline long btrfs_ioctl_clone(s
 								datal);
 				if (disko) {
 					inode_add_bytes(inode, datal);
-					ret = btrfs_inc_extent_ref(trans, root,
+					btrfs_inc_extent_ref(trans, root,
 							disko, diskl, 0,
 							root->root_key.objectid,
 							btrfs_ino(inode),
 							new_key.offset - datao);
-					BUG_ON(ret);
 				}
 			} else if (type == BTRFS_FILE_EXTENT_INLINE) {
 				u64 skip = 0;
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1607,11 +1607,10 @@ int replace_file_extents(struct btrfs_tr
 		dirty = 1;
 
 		key.offset -= btrfs_file_extent_offset(leaf, fi);
-		ret = btrfs_inc_extent_ref(trans, root, new_bytenr,
-					   num_bytes, parent,
-					   btrfs_header_owner(leaf),
-					   key.objectid, key.offset);
-		BUG_ON(ret);
+		btrfs_inc_extent_ref(trans, root, new_bytenr,
+				     num_bytes, parent,
+				     btrfs_header_owner(leaf),
+				     key.objectid, key.offset);
 
 		ret = btrfs_free_extent(trans, root, bytenr, num_bytes,
 					parent, btrfs_header_owner(leaf),
@@ -1782,15 +1781,11 @@ again:
 					      path->slots[level], old_ptr_gen);
 		btrfs_mark_buffer_dirty(path->nodes[level]);
 
-		ret = btrfs_inc_extent_ref(trans, src, old_bytenr, blocksize,
-					path->nodes[level]->start,
-					src->root_key.objectid, level - 1, 0);
-		BUG_ON(ret);
-		ret = btrfs_inc_extent_ref(trans, dest, new_bytenr, blocksize,
-					0, dest->root_key.objectid, level - 1,
-					0);
-		BUG_ON(ret);
-
+		btrfs_inc_extent_ref(trans, src, old_bytenr, blocksize,
+				     path->nodes[level]->start,
+				     src->root_key.objectid, level - 1, 0);
+		btrfs_inc_extent_ref(trans, dest, new_bytenr, blocksize,
+				     0, dest->root_key.objectid, level - 1, 0);
 		ret = btrfs_free_extent(trans, src, new_bytenr, blocksize,
 					path->nodes[level]->start,
 					src->root_key.objectid, level - 1, 0);
@@ -2568,12 +2563,11 @@ static int do_relocation(struct btrfs_tr
 						      trans->transid);
 			btrfs_mark_buffer_dirty(upper->eb);
 
-			ret = btrfs_inc_extent_ref(trans, root,
-						node->eb->start, blocksize,
-						upper->eb->start,
-						btrfs_header_owner(upper->eb),
-						node->level, 0);
-			BUG_ON(ret);
+			btrfs_inc_extent_ref(trans, root,
+					     node->eb->start, blocksize,
+					     upper->eb->start,
+					     btrfs_header_owner(upper->eb),
+					     node->level, 0);
 
 			ret = btrfs_drop_subtree(trans, root, eb, upper->eb);
 			BUG_ON(ret);
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -588,11 +588,10 @@ static noinline int replay_one_extent(st
 			ret = btrfs_lookup_extent(root, ins.objectid,
 						ins.offset);
 			if (ret == 0) {
-				ret = btrfs_inc_extent_ref(trans, root,
-						ins.objectid, ins.offset,
-						0, root->root_key.objectid,
-						key->objectid, offset);
-				BUG_ON(ret);
+				btrfs_inc_extent_ref(trans, root, ins.objectid,
+						     ins.offset, 0,
+						     root->root_key.objectid,
+						     key->objectid, offset);
 			} else {
 				/*
 				 * insert the extent pointer in the extent



