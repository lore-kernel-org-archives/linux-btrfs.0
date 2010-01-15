From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH] btrfs: Fix race in btrfs_mark_extent_written
Date: Fri, 15 Jan 2010 16:43:09 +0800
Message-ID: <4B502A9D.8090807@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Fix bug reported by Johannes Hirte. The reason of that bug
is btrfs_del_items is called after btrfs_duplicate_item and
btrfs_del_items triggers tree balance. The fix is check that
case and call btrfs_search_slot when needed.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 1/fs/btrfs/file.c 2/fs/btrfs/file.c
--- 1/fs/btrfs/file.c	2009-12-28 12:23:42.081546961 +0800
+++ 2/fs/btrfs/file.c	2010-01-11 13:02:08.082735125 +0800
@@ -506,7 +506,8 @@ next_slot:
 }
 
 static int extent_mergeable(struct extent_buffer *leaf, int slot,
-			    u64 objectid, u64 bytenr, u64 *start, u64 *end)
+			    u64 objectid, u64 bytenr, u64 orig_offset,
+			    u64 *start, u64 *end)
 {
 	struct btrfs_file_extent_item *fi;
 	struct btrfs_key key;
@@ -522,6 +523,7 @@ static int extent_mergeable(struct exten
 	fi = btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
 	if (btrfs_file_extent_type(leaf, fi) != BTRFS_FILE_EXTENT_REG ||
 	    btrfs_file_extent_disk_bytenr(leaf, fi) != bytenr ||
+	    btrfs_file_extent_offset(leaf, fi) != key.offset - orig_offset ||
 	    btrfs_file_extent_compression(leaf, fi) ||
 	    btrfs_file_extent_encryption(leaf, fi) ||
 	    btrfs_file_extent_other_encoding(leaf, fi))
@@ -561,6 +563,7 @@ int btrfs_mark_extent_written(struct btr
 	u64 split;
 	int del_nr = 0;
 	int del_slot = 0;
+	int recow;
 	int ret;
 
 	btrfs_drop_extent_cache(inode, start, end - 1, 0);
@@ -568,6 +571,7 @@ int btrfs_mark_extent_written(struct btr
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
 again:
+	recow = 0;
 	split = start;
 	key.objectid = inode->i_ino;
 	key.type = BTRFS_EXTENT_DATA_KEY;
@@ -591,12 +595,60 @@ again:
 	bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
 	num_bytes = btrfs_file_extent_disk_num_bytes(leaf, fi);
 	orig_offset = key.offset - btrfs_file_extent_offset(leaf, fi);
+	memcpy(&new_key, &key, sizeof(new_key));
+
+	if (start == key.offset && end < extent_end) {
+		other_start = 0;
+		other_end = start;
+		if (extent_mergeable(leaf, path->slots[0] - 1,
+				     inode->i_ino, bytenr, orig_offset,
+				     &other_start, &other_end)) {
+			new_key.offset = end;
+			btrfs_set_item_key_safe(trans, root, path, &new_key);
+			fi = btrfs_item_ptr(leaf, path->slots[0],
+					    struct btrfs_file_extent_item);
+			btrfs_set_file_extent_num_bytes(leaf, fi,
+							extent_end - end);
+			btrfs_set_file_extent_offset(leaf, fi,
+						     end - orig_offset);
+			fi = btrfs_item_ptr(leaf, path->slots[0] - 1,
+					    struct btrfs_file_extent_item);
+			btrfs_set_file_extent_num_bytes(leaf, fi,
+							end - other_start);
+			btrfs_mark_buffer_dirty(leaf);
+			goto out;
+		}
+	}
+
+	if (start > key.offset && end == extent_end) {
+		other_start = end;
+		other_end = 0;
+		if (extent_mergeable(leaf, path->slots[0] + 1,
+				     inode->i_ino, bytenr, orig_offset,
+				     &other_start, &other_end)) {
+			fi = btrfs_item_ptr(leaf, path->slots[0],
+					    struct btrfs_file_extent_item);
+			btrfs_set_file_extent_num_bytes(leaf, fi,
+							start - key.offset);
+			path->slots[0]++;
+			new_key.offset = start;
+			btrfs_set_item_key_safe(trans, root, path, &new_key);
+
+			fi = btrfs_item_ptr(leaf, path->slots[0],
+					    struct btrfs_file_extent_item);
+			btrfs_set_file_extent_num_bytes(leaf, fi,
+							other_end - start);
+			btrfs_set_file_extent_offset(leaf, fi,
+						     start - orig_offset);
+			btrfs_mark_buffer_dirty(leaf);
+			goto out;
+		}
+	}
 
 	while (start > key.offset || end < extent_end) {
 		if (key.offset == start)
 			split = end;
 
-		memcpy(&new_key, &key, sizeof(new_key));
 		new_key.offset = split;
 		ret = btrfs_duplicate_item(trans, root, path, &new_key);
 		if (ret == -EAGAIN) {
@@ -631,15 +683,18 @@ again:
 			path->slots[0]--;
 			extent_end = end;
 		}
+		recow = 1;
 	}
 
-	fi = btrfs_item_ptr(leaf, path->slots[0],
-			    struct btrfs_file_extent_item);
-
 	other_start = end;
 	other_end = 0;
-	if (extent_mergeable(leaf, path->slots[0] + 1, inode->i_ino,
-			     bytenr, &other_start, &other_end)) {
+	if (extent_mergeable(leaf, path->slots[0] + 1,
+			     inode->i_ino, bytenr, orig_offset,
+			     &other_start, &other_end)) {
+		if (recow) {
+			btrfs_release_path(root, path);
+			goto again;
+		}
 		extent_end = other_end;
 		del_slot = path->slots[0] + 1;
 		del_nr++;
@@ -650,8 +705,13 @@ again:
 	}
 	other_start = 0;
 	other_end = start;
-	if (extent_mergeable(leaf, path->slots[0] - 1, inode->i_ino,
-			     bytenr, &other_start, &other_end)) {
+	if (extent_mergeable(leaf, path->slots[0] - 1,
+			     inode->i_ino, bytenr, orig_offset,
+			     &other_start, &other_end)) {
+		if (recow) {
+			btrfs_release_path(root, path);
+			goto again;
+		}
 		key.offset = other_start;
 		del_slot = path->slots[0];
 		del_nr++;
@@ -660,22 +720,22 @@ again:
 					inode->i_ino, orig_offset);
 		BUG_ON(ret);
 	}
+	fi = btrfs_item_ptr(leaf, path->slots[0],
+			   struct btrfs_file_extent_item);
 	if (del_nr == 0) {
 		btrfs_set_file_extent_type(leaf, fi,
 					   BTRFS_FILE_EXTENT_REG);
 		btrfs_mark_buffer_dirty(leaf);
-		goto out;
-	}
-
-	fi = btrfs_item_ptr(leaf, del_slot - 1,
-			    struct btrfs_file_extent_item);
-	btrfs_set_file_extent_type(leaf, fi, BTRFS_FILE_EXTENT_REG);
-	btrfs_set_file_extent_num_bytes(leaf, fi,
-					extent_end - key.offset);
-	btrfs_mark_buffer_dirty(leaf);
+	} else {
+		btrfs_set_file_extent_type(leaf, fi,
+					   BTRFS_FILE_EXTENT_REG);
+		btrfs_set_file_extent_num_bytes(leaf, fi,
+						extent_end - key.offset);
+		btrfs_mark_buffer_dirty(leaf);
 
-	ret = btrfs_del_items(trans, root, path, del_slot, del_nr);
-	BUG_ON(ret);
+		ret = btrfs_del_items(trans, root, path, del_slot, del_nr);
+		BUG_ON(ret);
+	}
 out:
 	btrfs_free_path(path);
 	return 0;
