Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43541 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S969240AbeE1Px7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 May 2018 11:53:59 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E08CFAE55
        for <linux-btrfs@vger.kernel.org>; Mon, 28 May 2018 15:53:56 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 06/11] btrfs-progs: Remove unused argument from clean_tree_block
Date: Mon, 28 May 2018 09:36:45 +0300
Message-Id: <1527489410-3564-7-git-send-email-nborisov@suse.com>
In-Reply-To: <1527489410-3564-1-git-send-email-nborisov@suse.com>
References: <1527489410-3564-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function actually uses only the extent_buffer arg but takes 3
arguments. Furthermore, it's current interface doesn't even mirror
the kernel counterpart. Just remove the extra arguments.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 ctree.c           | 12 ++++++------
 disk-io.c         |  3 +--
 disk-io.h         |  3 +--
 extent-tree.c     |  2 +-
 free-space-tree.c |  2 +-
 5 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/ctree.c b/ctree.c
index 2c3ba70b000c..e79d7aa32319 100644
--- a/ctree.c
+++ b/ctree.c
@@ -251,7 +251,7 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 			ret = btrfs_dec_ref(trans, root, buf, 1);
 			BUG_ON(ret);
 		}
-		clean_tree_block(trans, root, buf);
+		clean_tree_block(buf);
 	}
 	return 0;
 }
@@ -717,7 +717,7 @@ static int balance_level(struct btrfs_trans_handle *trans,
 		root->node = child;
 		add_root_to_dirty_list(root);
 		path->nodes[level] = NULL;
-		clean_tree_block(trans, root, mid);
+		clean_tree_block(mid);
 		/* once for the path */
 		free_extent_buffer(mid);
 
@@ -770,7 +770,7 @@ static int balance_level(struct btrfs_trans_handle *trans,
 			u64 bytenr = right->start;
 			u32 blocksize = right->len;
 
-			clean_tree_block(trans, root, right);
+			clean_tree_block(right);
 			free_extent_buffer(right);
 			right = NULL;
 			wret = btrfs_del_ptr(root, path, level + 1, pslot + 1);
@@ -816,7 +816,7 @@ static int balance_level(struct btrfs_trans_handle *trans,
 		/* we've managed to empty the middle node, drop it */
 		u64 bytenr = mid->start;
 		u32 blocksize = mid->len;
-		clean_tree_block(trans, root, mid);
+		clean_tree_block(mid);
 		free_extent_buffer(mid);
 		mid = NULL;
 		wret = btrfs_del_ptr(root, path, level + 1, pslot);
@@ -2739,7 +2739,7 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		if (leaf == root->node) {
 			btrfs_set_header_level(leaf, 0);
 		} else {
-			clean_tree_block(trans, root, leaf);
+			clean_tree_block(leaf);
 			wret = btrfs_del_leaf(trans, root, path, leaf);
 			BUG_ON(ret);
 			if (wret)
@@ -2775,7 +2775,7 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 			}
 
 			if (btrfs_header_nritems(leaf) == 0) {
-				clean_tree_block(trans, root, leaf);
+				clean_tree_block(leaf);
 				path->slots[1] = slot;
 				ret = btrfs_del_leaf(trans, root, path, leaf);
 				BUG_ON(ret);
diff --git a/disk-io.c b/disk-io.c
index 72d44531a1b5..456b354cb727 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1684,8 +1684,7 @@ int close_ctree_fs_info(struct btrfs_fs_info *fs_info)
 	return err;
 }
 
-int clean_tree_block(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		     struct extent_buffer *eb)
+int clean_tree_block(struct extent_buffer *eb)
 {
 	return clear_extent_buffer_dirty(eb);
 }
diff --git a/disk-io.h b/disk-io.h
index c4496155771f..36fb68cdb86a 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -131,8 +131,7 @@ struct extent_buffer* btrfs_find_create_tree_block(
 
 void btrfs_setup_root(struct btrfs_root *root, struct btrfs_fs_info *fs_info,
 		      u64 objectid);
-int clean_tree_block(struct btrfs_trans_handle *trans,
-		     struct btrfs_root *root, struct extent_buffer *buf);
+int clean_tree_block(struct extent_buffer *buf);
 
 void btrfs_free_fs_info(struct btrfs_fs_info *fs_info);
 struct btrfs_fs_info *btrfs_new_fs_info(int writable, u64 sb_bytenr);
diff --git a/extent-tree.c b/extent-tree.c
index 8e7f888b5ce5..e06fe56b5ca8 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -2129,7 +2129,7 @@ static int pin_down_bytes(struct btrfs_trans_handle *trans,
 		if (header_owner != BTRFS_TREE_LOG_OBJECTID &&
 		    header_transid == trans->transid &&
 		    !btrfs_header_flag(buf, BTRFS_HEADER_FLAG_WRITTEN)) {
-			clean_tree_block(NULL, root, buf);
+			clean_tree_block(buf);
 			free_extent_buffer(buf);
 			return 1;
 		}
diff --git a/free-space-tree.c b/free-space-tree.c
index 69a4eca8a74f..139a031e8483 100644
--- a/free-space-tree.c
+++ b/free-space-tree.c
@@ -135,7 +135,7 @@ int btrfs_clear_free_space_tree(struct btrfs_fs_info *fs_info)
 
 	list_del(&free_space_root->dirty_list);
 
-	ret = clean_tree_block(trans, tree_root, free_space_root->node);
+	ret = clean_tree_block(free_space_root->node);
 	if (ret)
 		goto abort;
 	ret = btrfs_free_tree_block(trans, free_space_root,
-- 
2.7.4

