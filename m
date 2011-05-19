From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] Btrfs: BUG_ON is deleted from the caller of btrfs_truncate_item & btrfs_extend_item
Date: Thu, 19 May 2011 14:19:08 +0900
Message-ID: <201105190519.AA00021@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Currently, btrfs_truncate_item and btrfs_extend_item returns only 0.
So, the check by BUG_ON in the caller is unnecessary.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/ctree.c       |    8 ++------
 fs/btrfs/dir-item.c    |    1 -
 fs/btrfs/extent-tree.c |    3 ---
 fs/btrfs/file-item.c   |    3 ---
 fs/btrfs/inode-item.c  |    2 --
 fs/btrfs/inode.c       |    1 -
 fs/btrfs/tree-log.c    |    1 -
 7 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 84d7ca1..6f1a59c 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3216,7 +3216,6 @@ int btrfs_truncate_item(struct btrfs_trans_handle *trans,
 			struct btrfs_path *path,
 			u32 new_size, int from_end)
 {
-	int ret = 0;
 	int slot;
 	struct extent_buffer *leaf;
 	struct btrfs_item *item;
@@ -3314,12 +3313,11 @@ int btrfs_truncate_item(struct btrfs_trans_handle *trans,
 	btrfs_set_item_size(leaf, item, new_size);
 	btrfs_mark_buffer_dirty(leaf);
 
-	ret = 0;
 	if (btrfs_leaf_free_space(root, leaf) < 0) {
 		btrfs_print_leaf(root, leaf);
 		BUG();
 	}
-	return ret;
+	return 0;
 }
 
 /*
@@ -3329,7 +3327,6 @@ int btrfs_extend_item(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root, struct btrfs_path *path,
 		      u32 data_size)
 {
-	int ret = 0;
 	int slot;
 	struct extent_buffer *leaf;
 	struct btrfs_item *item;
@@ -3394,12 +3391,11 @@ int btrfs_extend_item(struct btrfs_trans_handle *trans,
 	btrfs_set_item_size(leaf, item, old_size + data_size);
 	btrfs_mark_buffer_dirty(leaf);
 
-	ret = 0;
 	if (btrfs_leaf_free_space(root, leaf) < 0) {
 		btrfs_print_leaf(root, leaf);
 		BUG();
 	}
-	return ret;
+	return 0;
 }
 
 /*
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index c62f02f..8fd7a58 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -50,7 +50,6 @@ static struct btrfs_dir_item *insert_with_overflow(struct btrfs_trans_handle
 		if (di)
 			return ERR_PTR(-EEXIST);
 		ret = btrfs_extend_item(trans, root, path, data_size);
-		WARN_ON(ret > 0);
 	}
 	if (ret < 0)
 		return ERR_PTR(ret);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9ee6bd5..53681d0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -947,7 +947,6 @@ static int convert_extent_item_v0(struct btrfs_trans_handle *trans,
 	BUG_ON(ret);
 
 	ret = btrfs_extend_item(trans, root, path, new_size);
-	BUG_ON(ret);
 
 	leaf = path->nodes[0];
 	item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_item);
@@ -1555,7 +1554,6 @@ int setup_inline_extent_backref(struct btrfs_trans_handle *trans,
 	size = btrfs_extent_inline_ref_size(type);
 
 	ret = btrfs_extend_item(trans, root, path, size);
-	BUG_ON(ret);
 
 	ei = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_item);
 	refs = btrfs_extent_refs(leaf, ei);
@@ -1684,7 +1682,6 @@ int update_inline_extent_backref(struct btrfs_trans_handle *trans,
 					      end - ptr - size);
 		item_size -= size;
 		ret = btrfs_truncate_item(trans, root, path, item_size, 1);
-		BUG_ON(ret);
 	}
 	btrfs_mark_buffer_dirty(leaf);
 	return 0;
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index a6a9d4e..fe01a76 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -495,7 +495,6 @@ static noinline int truncate_one_csum(struct btrfs_trans_handle *trans,
 		u32 new_size = (bytenr - key->offset) >> blocksize_bits;
 		new_size *= csum_size;
 		ret = btrfs_truncate_item(trans, root, path, new_size, 1);
-		BUG_ON(ret);
 	} else if (key->offset >= bytenr && csum_end > end_byte &&
 		   end_byte > key->offset) {
 		/*
@@ -508,7 +507,6 @@ static noinline int truncate_one_csum(struct btrfs_trans_handle *trans,
 		new_size *= csum_size;
 
 		ret = btrfs_truncate_item(trans, root, path, new_size, 0);
-		BUG_ON(ret);
 
 		key->offset = end_byte;
 		ret = btrfs_set_item_key_safe(trans, root, path, key);
@@ -761,7 +759,6 @@ again:
 			goto insert;
 
 		ret = btrfs_extend_item(trans, root, path, diff);
-		BUG_ON(ret);
 		goto csum;
 	}
 
diff --git a/fs/btrfs/inode-item.c b/fs/btrfs/inode-item.c
index 64f1150..baa74f3 100644
--- a/fs/btrfs/inode-item.c
+++ b/fs/btrfs/inode-item.c
@@ -130,7 +130,6 @@ int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
 			      item_size - (ptr + sub_item_len - item_start));
 	ret = btrfs_truncate_item(trans, root, path,
 				  item_size - sub_item_len, 1);
-	BUG_ON(ret);
 out:
 	btrfs_free_path(path);
 	return ret;
@@ -167,7 +166,6 @@ int btrfs_insert_inode_ref(struct btrfs_trans_handle *trans,
 
 		old_size = btrfs_item_size_nr(path->nodes[0], path->slots[0]);
 		ret = btrfs_extend_item(trans, root, path, ins_len);
-		BUG_ON(ret);
 		ref = btrfs_item_ptr(path->nodes[0], path->slots[0],
 				     struct btrfs_inode_ref);
 		ref = (struct btrfs_inode_ref *)((unsigned long)ref + old_size);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 870869a..c769153 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3427,7 +3427,6 @@ search_again:
 				    btrfs_file_extent_calc_inline_size(size);
 				ret = btrfs_truncate_item(trans, root, path,
 							  size, 1);
-				BUG_ON(ret);
 			} else if (root->ref_cows) {
 				inode_sub_bytes(inode, item_end + 1 -
 						found_key.offset);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f997ec0..02803d0 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -382,7 +382,6 @@ insert:
 		} else if (found_size < item_size) {
 			ret = btrfs_extend_item(trans, root, path,
 						item_size - found_size);
-			BUG_ON(ret);
 		}
 	} else if (ret) {
 		return ret;


