From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 82/99] btrfs: btrfs_truncate_item should return void
Date: Wed, 23 Nov 2011 19:36:55 -0500
Message-ID: <20111124004229.309786403@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 btrfs_truncate_item has no error conditions and should return void.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.c       |   11 +++++------
 fs/btrfs/ctree.h       |    8 ++++----
 fs/btrfs/dir-item.c    |    4 ++--
 fs/btrfs/extent-tree.c |    3 +--
 fs/btrfs/file-item.c   |    4 ++--
 fs/btrfs/inode-item.c  |    3 +--
 fs/btrfs/inode.c       |    4 ++--
 7 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index bdaf3ad..12c66ea 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3193,10 +3193,10 @@ int btrfs_duplicate_item(struct btrfs_trans_handle *trans,
  * off the end of the item or if we shift the item to chop bytes off
  * the front.
  */
-int btrfs_truncate_item(struct btrfs_trans_handle *trans,
-			struct btrfs_root *root,
-			struct btrfs_path *path,
-			u32 new_size, int from_end)
+void btrfs_truncate_item(struct btrfs_trans_handle *trans,
+			 struct btrfs_root *root,
+			 struct btrfs_path *path,
+			 u32 new_size, int from_end)
 {
 	int slot;
 	struct extent_buffer *leaf;
@@ -3213,7 +3213,7 @@ int btrfs_truncate_item(struct btrfs_trans_handle *trans,
 
 	old_size = btrfs_item_size_nr(leaf, slot);
 	if (old_size == new_size)
-		return 0;
+		return;
 
 	nritems = btrfs_header_nritems(leaf);
 	data_end = leaf_data_end(root, leaf);
@@ -3286,7 +3286,6 @@ int btrfs_truncate_item(struct btrfs_trans_handle *trans,
 		btrfs_print_leaf(root, leaf);
 		BUG();
 	}
-	return 0;
 }
 
 /*
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 51f2840..5d1e06c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2307,10 +2307,10 @@ int btrfs_block_can_be_shared(struct btrfs_root *root,
 			      struct extent_buffer *buf);
 int btrfs_extend_item(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, struct btrfs_path *path, u32 data_size);
-int btrfs_truncate_item(struct btrfs_trans_handle *trans,
-			struct btrfs_root *root,
-			struct btrfs_path *path,
-			u32 new_size, int from_end);
+void btrfs_truncate_item(struct btrfs_trans_handle *trans,
+			 struct btrfs_root *root,
+			 struct btrfs_path *path,
+			 u32 new_size, int from_end);
 int btrfs_split_item(struct btrfs_trans_handle *trans,
 		     struct btrfs_root *root,
 		     struct btrfs_path *path,
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 31d84e7..c95fc70 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -383,8 +383,8 @@ int btrfs_delete_one_dir_name(struct btrfs_trans_handle *trans,
 		start = btrfs_item_ptr_offset(leaf, path->slots[0]);
 		memmove_extent_buffer(leaf, ptr, ptr + sub_item_len,
 			item_len - (ptr + sub_item_len - start));
-		ret = btrfs_truncate_item(trans, root, path,
-					  item_len - sub_item_len, 1);
+		btrfs_truncate_item(trans, root, path,
+				    item_len - sub_item_len, 1);
 	}
 	return ret;
 }
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index fac996d..4ab965d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1666,7 +1666,6 @@ int update_inline_extent_backref(struct btrfs_trans_handle *trans,
 	u32 item_size;
 	int size;
 	int type;
-	int ret;
 	u64 refs;
 
 	leaf = path->nodes[0];
@@ -1708,7 +1707,7 @@ int update_inline_extent_backref(struct btrfs_trans_handle *trans,
 			memmove_extent_buffer(leaf, ptr, ptr + size,
 					      end - ptr - size);
 		item_size -= size;
-		ret = btrfs_truncate_item(trans, root, path, item_size, 1);
+		btrfs_truncate_item(trans, root, path, item_size, 1);
 	}
 	btrfs_mark_buffer_dirty(leaf);
 	return 0;
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 8d5272d..319129e 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -514,7 +514,7 @@ static noinline int truncate_one_csum(struct btrfs_trans_handle *trans,
 		 */
 		u32 new_size = (bytenr - key->offset) >> blocksize_bits;
 		new_size *= csum_size;
-		ret = btrfs_truncate_item(trans, root, path, new_size, 1);
+		btrfs_truncate_item(trans, root, path, new_size, 1);
 	} else if (key->offset >= bytenr && csum_end > end_byte &&
 		   end_byte > key->offset) {
 		/*
@@ -526,7 +526,7 @@ static noinline int truncate_one_csum(struct btrfs_trans_handle *trans,
 		u32 new_size = (csum_end - end_byte) >> blocksize_bits;
 		new_size *= csum_size;
 
-		ret = btrfs_truncate_item(trans, root, path, new_size, 0);
+		btrfs_truncate_item(trans, root, path, new_size, 0);
 
 		key->offset = end_byte;
 		ret = btrfs_set_item_key_safe(trans, root, path, key);
diff --git a/fs/btrfs/inode-item.c b/fs/btrfs/inode-item.c
index baa74f3..c04018c 100644
--- a/fs/btrfs/inode-item.c
+++ b/fs/btrfs/inode-item.c
@@ -128,8 +128,7 @@ int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
 	item_start = btrfs_item_ptr_offset(leaf, path->slots[0]);
 	memmove_extent_buffer(leaf, ptr, ptr + sub_item_len,
 			      item_size - (ptr + sub_item_len - item_start));
-	ret = btrfs_truncate_item(trans, root, path,
-				  item_size - sub_item_len, 1);
+	btrfs_truncate_item(trans, root, path, item_size - sub_item_len, 1);
 out:
 	btrfs_free_path(path);
 	return ret;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d8bb54e..96a0fbd 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3243,8 +3243,8 @@ search_again:
 				}
 				size =
 				    btrfs_file_extent_calc_inline_size(size);
-				ret = btrfs_truncate_item(trans, root, path,
-							  size, 1);
+				btrfs_truncate_item(trans, root, path,
+						    size, 1);
 			} else if (root->ref_cows) {
 				inode_sub_bytes(inode, item_end + 1 -
 						found_key.offset);



