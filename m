Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:63432 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbaKLEnm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Nov 2014 23:43:42 -0500
From: Daniel Dressler <danieru.dressler@gmail.com>
To: danieru.dressler@gmail.com
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org (open list:BTRFS FILE SYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] Btrfs: ctree: reduce args where only fs_info used
Date: Wed, 12 Nov 2014 13:43:09 +0900
Message-Id: <1415767389-29722-1-git-send-email-danieru.dressler@gmail.com>
In-Reply-To: <danieru.dressler@gmail.com>
References: <danieru.dressler@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch is part of a larger project to cleanup
btrfs's internal usage of struct btrfs_root. Many
functions take btrfs_root only to grab a pointer
to fs_info.

This causes programmers to ponder which root can
be passed. Since only the fs_info is read affected
functions can accept any root, except this is only
obvious upon inspection.

This patch reduces the specificty of such functions
to accept the fs_info directly.

This patch does not address the two functions in
ctree.c (insert_ptr, and split_item) which only
use root for BUG_ONs in ctree.c

This patch affects the following functions:
  1) fixup_low_keys
  2) btrfs_set_item_key_safe

Signed-off-by: Daniel Dressler <danieru.dressler@gmail.com>
---
 fs/btrfs/ctree.c     | 27 +++++++++++++++------------
 fs/btrfs/ctree.h     |  3 ++-
 fs/btrfs/file-item.c |  2 +-
 fs/btrfs/file.c      |  8 ++++----
 4 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 19bc616..db5a60f 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3139,7 +3139,8 @@ again:
  * higher levels
  *
  */
-static void fixup_low_keys(struct btrfs_root *root, struct btrfs_path *path,
+static void fixup_low_keys(struct btrfs_fs_info *fs_info,
+			   struct btrfs_path *path,
 			   struct btrfs_disk_key *key, int level)
 {
 	int i;
@@ -3150,7 +3151,7 @@ static void fixup_low_keys(struct btrfs_root *root, struct btrfs_path *path,
 		if (!path->nodes[i])
 			break;
 		t = path->nodes[i];
-		tree_mod_log_set_node_key(root->fs_info, t, tslot, 1);
+		tree_mod_log_set_node_key(fs_info, t, tslot, 1);
 		btrfs_set_node_key(t, key, tslot);
 		btrfs_mark_buffer_dirty(path->nodes[i]);
 		if (tslot != 0)
@@ -3164,7 +3165,8 @@ static void fixup_low_keys(struct btrfs_root *root, struct btrfs_path *path,
  * This function isn't completely safe. It's the caller's responsibility
  * that the new key won't break the order
  */
-void btrfs_set_item_key_safe(struct btrfs_root *root, struct btrfs_path *path,
+void btrfs_set_item_key_safe(struct btrfs_fs_info *fs_info,
+			     struct btrfs_path *path,
 			     struct btrfs_key *new_key)
 {
 	struct btrfs_disk_key disk_key;
@@ -3186,7 +3188,7 @@ void btrfs_set_item_key_safe(struct btrfs_root *root, struct btrfs_path *path,
 	btrfs_set_item_key(eb, &disk_key, slot);
 	btrfs_mark_buffer_dirty(eb);
 	if (slot == 0)
-		fixup_low_keys(root, path, &disk_key, 1);
+		fixup_low_keys(fs_info, path, &disk_key, 1);
 }
 
 /*
@@ -3944,7 +3946,7 @@ static noinline int __push_leaf_left(struct btrfs_trans_handle *trans,
 		clean_tree_block(trans, root, right);
 
 	btrfs_item_key(right, &disk_key, 0);
-	fixup_low_keys(root, path, &disk_key, 1);
+	fixup_low_keys(root->fs_info, path, &disk_key, 1);
 
 	/* then fixup the leaf pointer in the path */
 	if (path->slots[0] < push_items) {
@@ -4181,6 +4183,7 @@ static noinline int split_leaf(struct btrfs_trans_handle *trans,
 	int mid;
 	int slot;
 	struct extent_buffer *right;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	int ret = 0;
 	int wret;
 	int split;
@@ -4284,10 +4287,10 @@ again:
 	btrfs_set_header_backref_rev(right, BTRFS_MIXED_BACKREF_REV);
 	btrfs_set_header_owner(right, root->root_key.objectid);
 	btrfs_set_header_level(right, 0);
-	write_extent_buffer(right, root->fs_info->fsid,
+	write_extent_buffer(right, fs_info->fsid,
 			    btrfs_header_fsid(), BTRFS_FSID_SIZE);
 
-	write_extent_buffer(right, root->fs_info->chunk_tree_uuid,
+	write_extent_buffer(right, fs_info->chunk_tree_uuid,
 			    btrfs_header_chunk_tree_uuid(right),
 			    BTRFS_UUID_SIZE);
 
@@ -4310,7 +4313,7 @@ again:
 			path->nodes[0] = right;
 			path->slots[0] = 0;
 			if (path->slots[1] == 0)
-				fixup_low_keys(root, path, &disk_key, 1);
+				fixup_low_keys(fs_info, path, &disk_key, 1);
 		}
 		btrfs_mark_buffer_dirty(right);
 		return ret;
@@ -4626,7 +4629,7 @@ void btrfs_truncate_item(struct btrfs_root *root, struct btrfs_path *path,
 		btrfs_set_disk_key_offset(&disk_key, offset + size_diff);
 		btrfs_set_item_key(leaf, &disk_key, slot);
 		if (slot == 0)
-			fixup_low_keys(root, path, &disk_key, 1);
+			fixup_low_keys(root->fs_info, path, &disk_key, 1);
 	}
 
 	item = btrfs_item_nr(slot);
@@ -4727,7 +4730,7 @@ void setup_items_for_insert(struct btrfs_root *root, struct btrfs_path *path,
 
 	if (path->slots[0] == 0) {
 		btrfs_cpu_key_to_disk(&disk_key, cpu_key);
-		fixup_low_keys(root, path, &disk_key, 1);
+		fixup_low_keys(root->fs_info, path, &disk_key, 1);
 	}
 	btrfs_unlock_up_safe(path, 1);
 
@@ -4899,7 +4902,7 @@ static void del_ptr(struct btrfs_root *root, struct btrfs_path *path,
 		struct btrfs_disk_key disk_key;
 
 		btrfs_node_key(parent, &disk_key, 0);
-		fixup_low_keys(root, path, &disk_key, level + 1);
+		fixup_low_keys(root->fs_info, path, &disk_key, level + 1);
 	}
 	btrfs_mark_buffer_dirty(parent);
 }
@@ -5001,7 +5004,7 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 			struct btrfs_disk_key disk_key;
 
 			btrfs_item_key(leaf, &disk_key, 0);
-			fixup_low_keys(root, path, &disk_key, 1);
+			fixup_low_keys(root->fs_info, path, &disk_key, 1);
 		}
 
 		/* delete the leaf if it is mostly empty */
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index fe69edd..99c101b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3438,7 +3438,8 @@ int btrfs_previous_item(struct btrfs_root *root,
 			int type);
 int btrfs_previous_extent_item(struct btrfs_root *root,
 			struct btrfs_path *path, u64 min_objectid);
-void btrfs_set_item_key_safe(struct btrfs_root *root, struct btrfs_path *path,
+void btrfs_set_item_key_safe(struct btrfs_fs_info *fs_info,
+			     struct btrfs_path *path,
 			     struct btrfs_key *new_key);
 struct extent_buffer *btrfs_root_node(struct btrfs_root *root);
 struct extent_buffer *btrfs_lock_root_node(struct btrfs_root *root);
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 84a2d18..fc00332 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -553,7 +553,7 @@ static noinline void truncate_one_csum(struct btrfs_root *root,
 		btrfs_truncate_item(root, path, new_size, 0);
 
 		key->offset = end_byte;
-		btrfs_set_item_key_safe(root, path, key);
+		btrfs_set_item_key_safe(root->fs_info, path, key);
 	} else {
 		BUG();
 	}
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index a18ceab..3d8e144 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -868,7 +868,7 @@ next_slot:
 
 			memcpy(&new_key, &key, sizeof(new_key));
 			new_key.offset = end;
-			btrfs_set_item_key_safe(root, path, &new_key);
+			btrfs_set_item_key_safe(root->fs_info, path, &new_key);
 
 			extent_offset += end - key.offset;
 			btrfs_set_file_extent_offset(leaf, fi, extent_offset);
@@ -1126,7 +1126,7 @@ again:
 				     ino, bytenr, orig_offset,
 				     &other_start, &other_end)) {
 			new_key.offset = end;
-			btrfs_set_item_key_safe(root, path, &new_key);
+			btrfs_set_item_key_safe(root->fs_info, path, &new_key);
 			fi = btrfs_item_ptr(leaf, path->slots[0],
 					    struct btrfs_file_extent_item);
 			btrfs_set_file_extent_generation(leaf, fi,
@@ -1160,7 +1160,7 @@ again:
 							 trans->transid);
 			path->slots[0]++;
 			new_key.offset = start;
-			btrfs_set_item_key_safe(root, path, &new_key);
+			btrfs_set_item_key_safe(root->fs_info, path, &new_key);
 
 			fi = btrfs_item_ptr(leaf, path->slots[0],
 					    struct btrfs_file_extent_item);
@@ -2164,7 +2164,7 @@ static int fill_holes(struct btrfs_trans_handle *trans, struct inode *inode,
 		u64 num_bytes;
 
 		key.offset = offset;
-		btrfs_set_item_key_safe(root, path, &key);
+		btrfs_set_item_key_safe(root->fs_info, path, &key);
 		fi = btrfs_item_ptr(leaf, path->slots[0],
 				    struct btrfs_file_extent_item);
 		num_bytes = btrfs_file_extent_num_bytes(leaf, fi) + end -
-- 
2.1.0

