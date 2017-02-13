Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41533 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751878AbdBMJeL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 04:34:11 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8CE5CABD3
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 09:33:59 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 03/29] btrfs: remove unused parameter from clean_tree_block
Date: Mon, 13 Feb 2017 10:33:30 +0100
Message-Id: <8355cfcbb71b4862fd6d78166a2c4897b3d4043f.1486977711.git.dsterba@suse.com>
In-Reply-To: <cover.1486977711.git.dsterba@suse.com>
References: <cover.1486977711.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Added but never needed.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.c           | 16 ++++++++--------
 fs/btrfs/disk-io.c         |  3 +--
 fs/btrfs/disk-io.h         |  3 +--
 fs/btrfs/extent-tree.c     |  4 ++--
 fs/btrfs/free-space-tree.c |  2 +-
 fs/btrfs/qgroup.c          |  2 +-
 fs/btrfs/tree-log.c        |  6 +++---
 7 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 35e22349c139..d509dafdb20c 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1074,7 +1074,7 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 			ret = btrfs_dec_ref(trans, root, buf, 1);
 			BUG_ON(ret); /* -ENOMEM */
 		}
-		clean_tree_block(trans, fs_info, buf);
+		clean_tree_block(fs_info, buf);
 		*last_ref = 1;
 	}
 	return 0;
@@ -1938,7 +1938,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 
 		path->locks[level] = 0;
 		path->nodes[level] = NULL;
-		clean_tree_block(trans, fs_info, mid);
+		clean_tree_block(fs_info, mid);
 		btrfs_tree_unlock(mid);
 		/* once for the path */
 		free_extent_buffer(mid);
@@ -1999,7 +1999,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		if (wret < 0 && wret != -ENOSPC)
 			ret = wret;
 		if (btrfs_header_nritems(right) == 0) {
-			clean_tree_block(trans, fs_info, right);
+			clean_tree_block(fs_info, right);
 			btrfs_tree_unlock(right);
 			del_ptr(root, path, level + 1, pslot + 1);
 			root_sub_used(root, right->len);
@@ -2043,7 +2043,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		BUG_ON(wret == 1);
 	}
 	if (btrfs_header_nritems(mid) == 0) {
-		clean_tree_block(trans, fs_info, mid);
+		clean_tree_block(fs_info, mid);
 		btrfs_tree_unlock(mid);
 		del_ptr(root, path, level + 1, pslot);
 		root_sub_used(root, mid->len);
@@ -3705,7 +3705,7 @@ static noinline int __push_leaf_right(struct btrfs_trans_handle *trans,
 	if (left_nritems)
 		btrfs_mark_buffer_dirty(left);
 	else
-		clean_tree_block(trans, fs_info, left);
+		clean_tree_block(fs_info, left);
 
 	btrfs_mark_buffer_dirty(right);
 
@@ -3717,7 +3717,7 @@ static noinline int __push_leaf_right(struct btrfs_trans_handle *trans,
 	if (path->slots[0] >= left_nritems) {
 		path->slots[0] -= left_nritems;
 		if (btrfs_header_nritems(path->nodes[0]) == 0)
-			clean_tree_block(trans, fs_info, path->nodes[0]);
+			clean_tree_block(fs_info, path->nodes[0]);
 		btrfs_tree_unlock(path->nodes[0]);
 		free_extent_buffer(path->nodes[0]);
 		path->nodes[0] = right;
@@ -3946,7 +3946,7 @@ static noinline int __push_leaf_left(struct btrfs_trans_handle *trans,
 	if (right_nritems)
 		btrfs_mark_buffer_dirty(right);
 	else
-		clean_tree_block(trans, fs_info, right);
+		clean_tree_block(fs_info, right);
 
 	btrfs_item_key(right, &disk_key, 0);
 	fixup_low_keys(fs_info, path, &disk_key, 1);
@@ -5009,7 +5009,7 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 			btrfs_set_header_level(leaf, 0);
 		} else {
 			btrfs_set_path_blocking(path);
-			clean_tree_block(trans, fs_info, leaf);
+			clean_tree_block(fs_info, leaf);
 			btrfs_del_leaf(trans, root, path, leaf);
 		}
 	} else {
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 89cd597883fd..48846d215e97 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1248,8 +1248,7 @@ struct extent_buffer *read_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
 
 }
 
-void clean_tree_block(struct btrfs_trans_handle *trans,
-		      struct btrfs_fs_info *fs_info,
+void clean_tree_block(struct btrfs_fs_info *fs_info,
 		      struct extent_buffer *buf)
 {
 	if (btrfs_header_generation(buf) ==
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 44dcd9af6b7c..1864e7ce9c70 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -52,8 +52,7 @@ int reada_tree_block_flagged(struct btrfs_fs_info *fs_info, u64 bytenr,
 struct extent_buffer *btrfs_find_create_tree_block(
 						struct btrfs_fs_info *fs_info,
 						u64 bytenr);
-void clean_tree_block(struct btrfs_trans_handle *trans,
-		      struct btrfs_fs_info *fs_info, struct extent_buffer *buf);
+void clean_tree_block(struct btrfs_fs_info *fs_info, struct extent_buffer *buf);
 int open_ctree(struct super_block *sb,
 	       struct btrfs_fs_devices *fs_devices,
 	       char *options);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0992cd1393a6..9e8d6c2e7a64 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8253,7 +8253,7 @@ btrfs_init_new_buffer(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	btrfs_set_header_generation(buf, trans->transid);
 	btrfs_set_buffer_lockdep_class(root->root_key.objectid, buf, level);
 	btrfs_tree_lock(buf);
-	clean_tree_block(trans, fs_info, buf);
+	clean_tree_block(fs_info, buf);
 	clear_bit(EXTENT_BUFFER_STALE, &buf->bflags);
 
 	btrfs_set_lock_blocking(buf);
@@ -8874,7 +8874,7 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
 			btrfs_set_lock_blocking(eb);
 			path->locks[level] = BTRFS_WRITE_LOCK_BLOCKING;
 		}
-		clean_tree_block(trans, fs_info, eb);
+		clean_tree_block(fs_info, eb);
 	}
 
 	if (eb == root->node) {
diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index ff0c55337c2e..dd7fb22a955a 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -1269,7 +1269,7 @@ int btrfs_clear_free_space_tree(struct btrfs_fs_info *fs_info)
 	list_del(&free_space_root->dirty_list);
 
 	btrfs_tree_lock(free_space_root->node);
-	clean_tree_block(trans, fs_info, free_space_root->node);
+	clean_tree_block(fs_info, free_space_root->node);
 	btrfs_tree_unlock(free_space_root->node);
 	btrfs_free_tree_block(trans, free_space_root, free_space_root->node,
 			      0, 1);
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 8496dbf3f38b..6d106e623604 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1019,7 +1019,7 @@ int btrfs_quota_disable(struct btrfs_trans_handle *trans,
 	list_del(&quota_root->dirty_list);
 
 	btrfs_tree_lock(quota_root->node);
-	clean_tree_block(trans, fs_info, quota_root->node);
+	clean_tree_block(fs_info, quota_root->node);
 	btrfs_tree_unlock(quota_root->node);
 	btrfs_free_tree_block(trans, quota_root, quota_root->node, 0, 1);
 
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 010cf7685677..cea93ba1f099 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2472,7 +2472,7 @@ static noinline int walk_down_log_tree(struct btrfs_trans_handle *trans,
 				if (trans) {
 					btrfs_tree_lock(next);
 					btrfs_set_lock_blocking(next);
-					clean_tree_block(trans, fs_info, next);
+					clean_tree_block(fs_info, next);
 					btrfs_wait_tree_block_writeback(next);
 					btrfs_tree_unlock(next);
 				}
@@ -2552,7 +2552,7 @@ static noinline int walk_up_log_tree(struct btrfs_trans_handle *trans,
 				if (trans) {
 					btrfs_tree_lock(next);
 					btrfs_set_lock_blocking(next);
-					clean_tree_block(trans, fs_info, next);
+					clean_tree_block(fs_info, next);
 					btrfs_wait_tree_block_writeback(next);
 					btrfs_tree_unlock(next);
 				}
@@ -2630,7 +2630,7 @@ static int walk_log_tree(struct btrfs_trans_handle *trans,
 			if (trans) {
 				btrfs_tree_lock(next);
 				btrfs_set_lock_blocking(next);
-				clean_tree_block(trans, fs_info, next);
+				clean_tree_block(fs_info, next);
 				btrfs_wait_tree_block_writeback(next);
 				btrfs_tree_unlock(next);
 			}
-- 
2.10.1

