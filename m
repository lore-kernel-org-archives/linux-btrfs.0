From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 63/66] btrfs: btrfs_extend_item should return void
Date: Mon, 24 Oct 2011 21:03:39 -0400
Message-ID: <20111025010857.791659349@suse.com>
References: <20111025010236.322699279@suse.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 btrfs_extend_item has no error conditions and should return void.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.c       |    7 +++----
 fs/btrfs/ctree.h       |    5 +++--
 fs/btrfs/dir-item.c    |    5 ++---
 fs/btrfs/extent-tree.c |    5 ++---
 fs/btrfs/file-item.c   |    2 +-
 fs/btrfs/inode-item.c  |    2 +-
 fs/btrfs/tree-log.c    |    9 ++++-----
 7 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 12c66ea..4c9dc73 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3291,9 +3291,9 @@ void btrfs_truncate_item(struct btrfs_trans_handle *trans,
 /*
  * make the item pointed to by the path bigger, data_size is the new size.
  */
-int btrfs_extend_item(struct btrfs_trans_handle *trans,
-		      struct btrfs_root *root, struct btrfs_path *path,
-		      u32 data_size)
+void btrfs_extend_item(struct btrfs_trans_handle *trans,
+		       struct btrfs_root *root, struct btrfs_path *path,
+		       u32 data_size)
 {
 	int slot;
 	struct extent_buffer *leaf;
@@ -3351,7 +3351,6 @@ int btrfs_extend_item(struct btrfs_trans_handle *trans,
 		btrfs_print_leaf(root, leaf);
 		BUG();
 	}
-	return 0;
 }
 
 /*
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 5d1e06c..5dee97f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2305,8 +2305,9 @@ int btrfs_copy_root(struct btrfs_trans_handle *trans,
 		      struct extent_buffer **cow_ret, u64 new_root_objectid);
 int btrfs_block_can_be_shared(struct btrfs_root *root,
 			      struct extent_buffer *buf);
-int btrfs_extend_item(struct btrfs_trans_handle *trans, struct btrfs_root
-		      *root, struct btrfs_path *path, u32 data_size);
+void btrfs_extend_item(struct btrfs_trans_handle *trans,
+		       struct btrfs_root *root, struct btrfs_path *path,
+		       u32 data_size);
 void btrfs_truncate_item(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root,
 			 struct btrfs_path *path,
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index c95fc70..7674330 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -49,9 +49,8 @@ static struct btrfs_dir_item *insert_with_overflow(struct btrfs_trans_handle
 		di = btrfs_match_dir_item_name(root, path, name, name_len);
 		if (di)
 			return ERR_PTR(-EEXIST);
-		ret = btrfs_extend_item(trans, root, path, data_size);
-	}
-	if (ret < 0)
+		btrfs_extend_item(trans, root, path, data_size);
+	} else if (ret < 0)
 		return ERR_PTR(ret);
 	WARN_ON(ret > 0);
 	leaf = path->nodes[0];
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4ab965d..201822d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -974,7 +974,7 @@ static int convert_extent_item_v0(struct btrfs_trans_handle *trans,
 		return ret;
 	BUG_ON(ret);
 
-	ret = btrfs_extend_item(trans, root, path, new_size);
+	btrfs_extend_item(trans, root, path, new_size);
 
 	leaf = path->nodes[0];
 	item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_item);
@@ -1572,7 +1572,6 @@ void setup_inline_extent_backref(struct btrfs_trans_handle *trans,
 	u64 refs;
 	int size;
 	int type;
-	int ret;
 
 	leaf = path->nodes[0];
 	ei = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_item);
@@ -1581,7 +1580,7 @@ void setup_inline_extent_backref(struct btrfs_trans_handle *trans,
 	type = extent_ref_type(parent, owner);
 	size = btrfs_extent_inline_ref_size(type);
 
-	ret = btrfs_extend_item(trans, root, path, size);
+	btrfs_extend_item(trans, root, path, size);
 
 	ei = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_item);
 	refs = btrfs_extent_refs(leaf, ei);
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 319129e..4a73745 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -778,7 +778,7 @@ again:
 		if (diff != csum_size)
 			goto insert;
 
-		ret = btrfs_extend_item(trans, root, path, diff);
+		btrfs_extend_item(trans, root, path, diff);
 		goto csum;
 	}
 
diff --git a/fs/btrfs/inode-item.c b/fs/btrfs/inode-item.c
index c04018c..9f0d038 100644
--- a/fs/btrfs/inode-item.c
+++ b/fs/btrfs/inode-item.c
@@ -164,7 +164,7 @@ int btrfs_insert_inode_ref(struct btrfs_trans_handle *trans,
 			goto out;
 
 		old_size = btrfs_item_size_nr(path->nodes[0], path->slots[0]);
-		ret = btrfs_extend_item(trans, root, path, ins_len);
+		btrfs_extend_item(trans, root, path, ins_len);
 		ref = btrfs_item_ptr(path->nodes[0], path->slots[0],
 				     struct btrfs_inode_ref);
 		ref = (struct btrfs_inode_ref *)((unsigned long)ref + old_size);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index feb4575..22e7da6 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -380,12 +380,11 @@ insert:
 		u32 found_size;
 		found_size = btrfs_item_size_nr(path->nodes[0],
 						path->slots[0]);
-		if (found_size > item_size) {
+		if (found_size > item_size)
 			btrfs_truncate_item(trans, root, path, item_size, 1);
-		} else if (found_size < item_size) {
-			ret = btrfs_extend_item(trans, root, path,
-						item_size - found_size);
-		}
+		else if (found_size < item_size)
+			btrfs_extend_item(trans, root, path,
+					  item_size - found_size);
 	} else if (ret) {
 		return ret;
 	}



