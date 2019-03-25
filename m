Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74596C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54FBC20700
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730149AbfCYSpV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 14:45:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:38950 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728991AbfCYSpU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 14:45:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BEC7CB005
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 18:45:18 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 2ABFEDA98F; Mon, 25 Mar 2019 19:46:32 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 08/30] btrfs: get fs_info from eb in clean_tree_block
Date:   Mon, 25 Mar 2019 19:46:32 +0100
Message-Id: <e081b3128da6c38f50e3df16dc943dd865c6d41d.1553539114.git.dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1553539114.git.dsterba@suse.com>
References: <cover.1553539114.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We can read fs_info from extent buffer and can drop it from the
parameters.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.c           | 16 ++++++++--------
 fs/btrfs/disk-io.c         |  4 ++--
 fs/btrfs/disk-io.h         |  2 +-
 fs/btrfs/extent-tree.c     |  6 +++---
 fs/btrfs/free-space-tree.c |  2 +-
 fs/btrfs/qgroup.c          |  2 +-
 fs/btrfs/tree-log.c        |  6 +++---
 7 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index b83627a372b1..76e57a8c98df 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -970,7 +970,7 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 			if (ret)
 				return ret;
 		}
-		clean_tree_block(fs_info, buf);
+		btrfs_clean_tree_block(buf);
 		*last_ref = 1;
 	}
 	return 0;
@@ -1888,7 +1888,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 
 		path->locks[level] = 0;
 		path->nodes[level] = NULL;
-		clean_tree_block(fs_info, mid);
+		btrfs_clean_tree_block(mid);
 		btrfs_tree_unlock(mid);
 		/* once for the path */
 		free_extent_buffer(mid);
@@ -1949,7 +1949,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		if (wret < 0 && wret != -ENOSPC)
 			ret = wret;
 		if (btrfs_header_nritems(right) == 0) {
-			clean_tree_block(fs_info, right);
+			btrfs_clean_tree_block(right);
 			btrfs_tree_unlock(right);
 			del_ptr(root, path, level + 1, pslot + 1);
 			root_sub_used(root, right->len);
@@ -1994,7 +1994,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		BUG_ON(wret == 1);
 	}
 	if (btrfs_header_nritems(mid) == 0) {
-		clean_tree_block(fs_info, mid);
+		btrfs_clean_tree_block(mid);
 		btrfs_tree_unlock(mid);
 		del_ptr(root, path, level + 1, pslot);
 		root_sub_used(root, mid->len);
@@ -3704,7 +3704,7 @@ static noinline int __push_leaf_right(struct btrfs_fs_info *fs_info,
 	if (left_nritems)
 		btrfs_mark_buffer_dirty(left);
 	else
-		clean_tree_block(fs_info, left);
+		btrfs_clean_tree_block(left);
 
 	btrfs_mark_buffer_dirty(right);
 
@@ -3716,7 +3716,7 @@ static noinline int __push_leaf_right(struct btrfs_fs_info *fs_info,
 	if (path->slots[0] >= left_nritems) {
 		path->slots[0] -= left_nritems;
 		if (btrfs_header_nritems(path->nodes[0]) == 0)
-			clean_tree_block(fs_info, path->nodes[0]);
+			btrfs_clean_tree_block(path->nodes[0]);
 		btrfs_tree_unlock(path->nodes[0]);
 		free_extent_buffer(path->nodes[0]);
 		path->nodes[0] = right;
@@ -3944,7 +3944,7 @@ static noinline int __push_leaf_left(struct btrfs_fs_info *fs_info,
 	if (right_nritems)
 		btrfs_mark_buffer_dirty(right);
 	else
-		clean_tree_block(fs_info, right);
+		btrfs_clean_tree_block(right);
 
 	btrfs_item_key(right, &disk_key, 0);
 	fixup_low_keys(path, &disk_key, 1);
@@ -5005,7 +5005,7 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 			btrfs_set_header_level(leaf, 0);
 		} else {
 			btrfs_set_path_blocking(path);
-			clean_tree_block(fs_info, leaf);
+			btrfs_clean_tree_block(leaf);
 			btrfs_del_leaf(trans, root, path, leaf);
 		}
 	} else {
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b7d512e5f4a1..a642c8219271 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1119,9 +1119,9 @@ struct extent_buffer *read_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
 
 }
 
-void clean_tree_block(struct btrfs_fs_info *fs_info,
-		      struct extent_buffer *buf)
+void btrfs_clean_tree_block(struct extent_buffer *buf)
 {
+	struct btrfs_fs_info *fs_info = buf->fs_info;
 	if (btrfs_header_generation(buf) ==
 	    fs_info->running_transaction->transid) {
 		btrfs_assert_tree_locked(buf);
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index a94ce82a2be0..917634f2bae9 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -51,7 +51,7 @@ int reada_tree_block_flagged(struct btrfs_fs_info *fs_info, u64 bytenr,
 struct extent_buffer *btrfs_find_create_tree_block(
 						struct btrfs_fs_info *fs_info,
 						u64 bytenr);
-void clean_tree_block(struct btrfs_fs_info *fs_info, struct extent_buffer *buf);
+void btrfs_clean_tree_block(struct extent_buffer *buf);
 int open_ctree(struct super_block *sb,
 	       struct btrfs_fs_devices *fs_devices,
 	       char *options);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 44fd4553004b..aa52b0995fba 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8557,7 +8557,7 @@ btrfs_init_new_buffer(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 
 	btrfs_set_buffer_lockdep_class(root->root_key.objectid, buf, level);
 	btrfs_tree_lock(buf);
-	clean_tree_block(fs_info, buf);
+	btrfs_clean_tree_block(buf);
 	clear_bit(EXTENT_BUFFER_STALE, &buf->bflags);
 
 	btrfs_set_lock_blocking_write(buf);
@@ -9252,14 +9252,14 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
 					     ret);
 			}
 		}
-		/* make block locked assertion in clean_tree_block happy */
+		/* make block locked assertion in btrfs_clean_tree_block happy */
 		if (!path->locks[level] &&
 		    btrfs_header_generation(eb) == trans->transid) {
 			btrfs_tree_lock(eb);
 			btrfs_set_lock_blocking_write(eb);
 			path->locks[level] = BTRFS_WRITE_LOCK_BLOCKING;
 		}
-		clean_tree_block(fs_info, eb);
+		btrfs_clean_tree_block(eb);
 	}
 
 	if (eb == root->node) {
diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index e5089087eaa6..4859e09d2af0 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -1248,7 +1248,7 @@ int btrfs_clear_free_space_tree(struct btrfs_fs_info *fs_info)
 	list_del(&free_space_root->dirty_list);
 
 	btrfs_tree_lock(free_space_root->node);
-	clean_tree_block(fs_info, free_space_root->node);
+	btrfs_clean_tree_block(free_space_root->node);
 	btrfs_tree_unlock(free_space_root->node);
 	btrfs_free_tree_block(trans, free_space_root, free_space_root->node,
 			      0, 1);
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index e659d9d61107..95361ccaa488 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1101,7 +1101,7 @@ int btrfs_quota_disable(struct btrfs_fs_info *fs_info)
 	list_del(&quota_root->dirty_list);
 
 	btrfs_tree_lock(quota_root->node);
-	clean_tree_block(fs_info, quota_root->node);
+	btrfs_clean_tree_block(quota_root->node);
 	btrfs_tree_unlock(quota_root->node);
 	btrfs_free_tree_block(trans, quota_root, quota_root->node, 0, 1);
 
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 4cb61cb72c4e..79f75bec9f40 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2736,7 +2736,7 @@ static noinline int walk_down_log_tree(struct btrfs_trans_handle *trans,
 				if (trans) {
 					btrfs_tree_lock(next);
 					btrfs_set_lock_blocking_write(next);
-					clean_tree_block(fs_info, next);
+					btrfs_clean_tree_block(next);
 					btrfs_wait_tree_block_writeback(next);
 					btrfs_tree_unlock(next);
 				} else {
@@ -2820,7 +2820,7 @@ static noinline int walk_up_log_tree(struct btrfs_trans_handle *trans,
 				if (trans) {
 					btrfs_tree_lock(next);
 					btrfs_set_lock_blocking_write(next);
-					clean_tree_block(fs_info, next);
+					btrfs_clean_tree_block(next);
 					btrfs_wait_tree_block_writeback(next);
 					btrfs_tree_unlock(next);
 				} else {
@@ -2902,7 +2902,7 @@ static int walk_log_tree(struct btrfs_trans_handle *trans,
 			if (trans) {
 				btrfs_tree_lock(next);
 				btrfs_set_lock_blocking_write(next);
-				clean_tree_block(fs_info, next);
+				btrfs_clean_tree_block(next);
 				btrfs_wait_tree_block_writeback(next);
 				btrfs_tree_unlock(next);
 			} else {
-- 
2.21.0

