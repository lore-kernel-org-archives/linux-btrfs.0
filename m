Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:65316 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab2JOLCA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Oct 2012 07:02:00 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so4742092pad.19
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Oct 2012 04:02:00 -0700 (PDT)
From: Li Dongyang <jerry87905@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: try harder when we merge holes
Date: Mon, 15 Oct 2012 22:03:51 +1100
Message-Id: <1350299031-2854-2-git-send-email-Jerry87905@gmail.com>
In-Reply-To: <1350299031-2854-1-git-send-email-Jerry87905@gmail.com>
References: <1350299031-2854-1-git-send-email-Jerry87905@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We should look at path->slots[0] rather than path->slots[0]+1 while trying to
merge with the hole behind us.
Also this patch will delete the the latter one if we can merge with both front
and back, leaving one hole covers all three.

Signed-off-by: Li Dongyang <Jerry87905@gmail.com>
---
 fs/btrfs/file.c | 133 ++++++++++++++++++++++++++++++++------------------------
 1 file changed, 76 insertions(+), 57 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 9ab1bed..d41805a 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1663,89 +1663,108 @@ static int btrfs_file_mmap(struct file	*filp, struct vm_area_struct *vma)
 	return 0;
 }
 
-static int hole_mergeable(struct inode *inode, struct extent_buffer *leaf,
-			  int slot, u64 start, u64 end)
-{
-	struct btrfs_file_extent_item *fi;
-	struct btrfs_key key;
-
-	if (slot < 0 || slot >= btrfs_header_nritems(leaf))
-		return 0;
-
-	btrfs_item_key_to_cpu(leaf, &key, slot);
-	if (key.objectid != btrfs_ino(inode) ||
-	    key.type != BTRFS_EXTENT_DATA_KEY)
-		return 0;
-
-	fi = btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
-
-	if (btrfs_file_extent_type(leaf, fi) != BTRFS_FILE_EXTENT_REG)
-		return 0;
-
-	if (btrfs_file_extent_disk_bytenr(leaf, fi))
-		return 0;
-
-	if (key.offset == end)
-		return 1;
-	if (key.offset + btrfs_file_extent_num_bytes(leaf, fi) == start)
-		return 1;
-	return 0;
-}
-
-static int fill_holes(struct btrfs_trans_handle *trans, struct inode *inode,
-		      struct btrfs_path *path, u64 offset, u64 end)
+static int merge_holes(struct btrfs_trans_handle *trans, struct inode *inode,
+		       struct btrfs_path *path, u64 offset, u64 end)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct extent_buffer *leaf;
-	struct btrfs_file_extent_item *fi;
-	struct extent_map *hole_em;
-	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
+	struct btrfs_file_extent_item *back_fi, *front_fi;
 	struct btrfs_key key;
 	int ret;
+	bool front_mergeable = false;
+	bool back_mergeable = false;
 
 	key.objectid = btrfs_ino(inode);
 	key.type = BTRFS_EXTENT_DATA_KEY;
 	key.offset = offset;
 
-
 	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
 	if (ret < 0)
 		return ret;
 	BUG_ON(!ret);
 
 	leaf = path->nodes[0];
-	if (hole_mergeable(inode, leaf, path->slots[0]-1, offset, end)) {
-		u64 num_bytes;
+	if (path->slots[0] != 0) {
+		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]-1);
+		if (key.objectid == btrfs_ino(inode) &&
+		    key.type == BTRFS_EXTENT_DATA_KEY) {
+			front_fi = btrfs_item_ptr(leaf, path->slots[0]-1,
+						struct btrfs_file_extent_item);
+			if (btrfs_file_extent_type(leaf, front_fi) ==
+			    BTRFS_FILE_EXTENT_REG &&
+			    btrfs_file_extent_disk_bytenr(leaf,
+							  front_fi) == 0 &&
+			    key.offset +
+			    btrfs_file_extent_num_bytes(leaf, front_fi) ==
+			    offset) {
+				front_mergeable = true;
+			}
+		}
+	}
 
-		path->slots[0]--;
-		fi = btrfs_item_ptr(leaf, path->slots[0],
-				    struct btrfs_file_extent_item);
-		num_bytes = btrfs_file_extent_num_bytes(leaf, fi) +
-			end - offset;
-		btrfs_set_file_extent_num_bytes(leaf, fi, num_bytes);
-		btrfs_set_file_extent_ram_bytes(leaf, fi, num_bytes);
-		btrfs_set_file_extent_offset(leaf, fi, 0);
-		btrfs_mark_buffer_dirty(leaf);
-		goto out;
+	btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+	if (key.objectid == btrfs_ino(inode) &&
+	    key.type == BTRFS_EXTENT_DATA_KEY) {
+		back_fi = btrfs_item_ptr(leaf, path->slots[0],
+					 struct btrfs_file_extent_item);
+		if (btrfs_file_extent_type(leaf, back_fi) ==
+		    BTRFS_FILE_EXTENT_REG &&
+		    btrfs_file_extent_disk_bytenr(leaf, back_fi) == 0 &&
+		    key.offset == end) {
+			back_mergeable = true;
+		}
 	}
 
-	if (hole_mergeable(inode, leaf, path->slots[0]+1, offset, end)) {
+	if (front_mergeable) {
+		u64 num_bytes = 0;
+
+		if (back_mergeable) {
+			num_bytes = btrfs_file_extent_num_bytes(leaf, back_fi);
+
+			ret = btrfs_del_item(trans, root, path);
+			if (ret)
+				goto out;
+		}
+
+		num_bytes += btrfs_file_extent_num_bytes(leaf, front_fi) +
+			end - offset;
+		btrfs_set_file_extent_num_bytes(leaf, front_fi, num_bytes);
+		btrfs_set_file_extent_ram_bytes(leaf, front_fi, num_bytes);
+		btrfs_set_file_extent_offset(leaf, front_fi, 0);
+		btrfs_mark_buffer_dirty(leaf);
+		ret = 0;
+	} else if (back_mergeable) {
 		u64 num_bytes;
 
-		path->slots[0]++;
 		key.offset = offset;
 		btrfs_set_item_key_safe(trans, root, path, &key);
-		fi = btrfs_item_ptr(leaf, path->slots[0],
-				    struct btrfs_file_extent_item);
-		num_bytes = btrfs_file_extent_num_bytes(leaf, fi) + end -
-			offset;
-		btrfs_set_file_extent_num_bytes(leaf, fi, num_bytes);
-		btrfs_set_file_extent_ram_bytes(leaf, fi, num_bytes);
-		btrfs_set_file_extent_offset(leaf, fi, 0);
+		num_bytes = btrfs_file_extent_num_bytes(leaf, back_fi) +
+			end - offset;
+		btrfs_set_file_extent_num_bytes(leaf, back_fi, num_bytes);
+		btrfs_set_file_extent_ram_bytes(leaf, back_fi, num_bytes);
+		btrfs_set_file_extent_offset(leaf, back_fi, 0);
 		btrfs_mark_buffer_dirty(leaf);
-		goto out;
+		ret = 0;
 	}
+
+out:
 	btrfs_release_path(path);
+	return ret;
+}
+
+static int fill_holes(struct btrfs_trans_handle *trans, struct inode *inode,
+		      struct btrfs_path *path, u64 offset, u64 end)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct extent_map *hole_em;
+	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
+	int ret;
+
+	ret = merge_holes(trans, inode, path, offset, end);
+	if (ret < 0)
+		return ret;
+	if (!ret)
+		goto out;
 
 	ret = btrfs_insert_file_extent(trans, root, btrfs_ino(inode), offset,
 				       0, 0, end - offset, 0, end - offset,
-- 
1.7.12.3

