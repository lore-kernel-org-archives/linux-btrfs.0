Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28CCFC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7FC420700
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730199AbfCYSpX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 14:45:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:38974 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728991AbfCYSpW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 14:45:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 149A1AF94
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 18:45:21 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 75E7FDA98F; Mon, 25 Mar 2019 19:46:34 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 09/30] btrfs: get fs_info from eb in btrfs_leaf_free_space
Date:   Mon, 25 Mar 2019 19:46:34 +0100
Message-Id: <59ae7cb43b2885c151e683f6578e15f31505cf31.1553539114.git.dsterba@suse.com>
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
 fs/btrfs/ctree.c         | 58 +++++++++++++++++++---------------------
 fs/btrfs/ctree.h         |  3 +--
 fs/btrfs/delayed-inode.c |  3 +--
 fs/btrfs/file-item.c     |  4 +--
 fs/btrfs/file.c          |  2 +-
 fs/btrfs/print-tree.c    |  2 +-
 fs/btrfs/xattr.c         |  2 +-
 7 files changed, 35 insertions(+), 39 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 76e57a8c98df..597337b07afa 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2716,7 +2716,6 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		      const struct btrfs_key *key, struct btrfs_path *p,
 		      int ins_len, int cow)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct extent_buffer *b;
 	int slot;
 	int ret;
@@ -2914,7 +2913,7 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		} else {
 			p->slots[level] = slot;
 			if (ins_len > 0 &&
-			    btrfs_leaf_free_space(fs_info, b) < ins_len) {
+			    btrfs_leaf_free_space(b) < ins_len) {
 				if (write_lock_level < 1) {
 					write_lock_level = 1;
 					btrfs_release_path(p);
@@ -3574,9 +3573,9 @@ static int leaf_space_used(struct extent_buffer *l, int start, int nr)
  * the start of the leaf data.  IOW, how much room
  * the leaf has left for both items and data
  */
-noinline int btrfs_leaf_free_space(struct btrfs_fs_info *fs_info,
-				   struct extent_buffer *leaf)
+noinline int btrfs_leaf_free_space(struct extent_buffer *leaf)
 {
+	struct btrfs_fs_info *fs_info = leaf->fs_info;
 	int nritems = btrfs_header_nritems(leaf);
 	int ret;
 
@@ -3635,7 +3634,8 @@ static noinline int __push_leaf_right(struct btrfs_fs_info *fs_info,
 			if (path->slots[0] > i)
 				break;
 			if (path->slots[0] == i) {
-				int space = btrfs_leaf_free_space(fs_info, left);
+				int space = btrfs_leaf_free_space(left);
+
 				if (space + push_space * 2 > free_space)
 					break;
 			}
@@ -3778,7 +3778,7 @@ static int push_leaf_right(struct btrfs_trans_handle *trans, struct btrfs_root
 	btrfs_tree_lock(right);
 	btrfs_set_lock_blocking_write(right);
 
-	free_space = btrfs_leaf_free_space(fs_info, right);
+	free_space = btrfs_leaf_free_space(right);
 	if (free_space < data_size)
 		goto out_unlock;
 
@@ -3788,7 +3788,7 @@ static int push_leaf_right(struct btrfs_trans_handle *trans, struct btrfs_root
 	if (ret)
 		goto out_unlock;
 
-	free_space = btrfs_leaf_free_space(fs_info, right);
+	free_space = btrfs_leaf_free_space(right);
 	if (free_space < data_size)
 		goto out_unlock;
 
@@ -3858,7 +3858,8 @@ static noinline int __push_leaf_left(struct btrfs_fs_info *fs_info,
 			if (path->slots[0] < i)
 				break;
 			if (path->slots[0] == i) {
-				int space = btrfs_leaf_free_space(fs_info, right);
+				int space = btrfs_leaf_free_space(right);
+
 				if (space + push_space * 2 > free_space)
 					break;
 			}
@@ -4012,7 +4013,7 @@ static int push_leaf_left(struct btrfs_trans_handle *trans, struct btrfs_root
 	btrfs_tree_lock(left);
 	btrfs_set_lock_blocking_write(left);
 
-	free_space = btrfs_leaf_free_space(fs_info, left);
+	free_space = btrfs_leaf_free_space(left);
 	if (free_space < data_size) {
 		ret = 1;
 		goto out;
@@ -4028,7 +4029,7 @@ static int push_leaf_left(struct btrfs_trans_handle *trans, struct btrfs_root
 		goto out;
 	}
 
-	free_space = btrfs_leaf_free_space(fs_info, left);
+	free_space = btrfs_leaf_free_space(left);
 	if (free_space < data_size) {
 		ret = 1;
 		goto out;
@@ -4124,7 +4125,6 @@ static noinline int push_for_double_split(struct btrfs_trans_handle *trans,
 					  struct btrfs_path *path,
 					  int data_size)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	int ret;
 	int progress = 0;
 	int slot;
@@ -4133,7 +4133,7 @@ static noinline int push_for_double_split(struct btrfs_trans_handle *trans,
 
 	slot = path->slots[0];
 	if (slot < btrfs_header_nritems(path->nodes[0]))
-		space_needed -= btrfs_leaf_free_space(fs_info, path->nodes[0]);
+		space_needed -= btrfs_leaf_free_space(path->nodes[0]);
 
 	/*
 	 * try to push all the items after our slot into the
@@ -4154,14 +4154,14 @@ static noinline int push_for_double_split(struct btrfs_trans_handle *trans,
 	if (path->slots[0] == 0 || path->slots[0] == nritems)
 		return 0;
 
-	if (btrfs_leaf_free_space(fs_info, path->nodes[0]) >= data_size)
+	if (btrfs_leaf_free_space(path->nodes[0]) >= data_size)
 		return 0;
 
 	/* try to push all the items before our slot into the next leaf */
 	slot = path->slots[0];
 	space_needed = data_size;
 	if (slot > 0)
-		space_needed -= btrfs_leaf_free_space(fs_info, path->nodes[0]);
+		space_needed -= btrfs_leaf_free_space(path->nodes[0]);
 	ret = push_leaf_left(trans, root, path, 1, space_needed, 0, slot);
 	if (ret < 0)
 		return ret;
@@ -4210,7 +4210,7 @@ static noinline int split_leaf(struct btrfs_trans_handle *trans,
 		int space_needed = data_size;
 
 		if (slot < btrfs_header_nritems(l))
-			space_needed -= btrfs_leaf_free_space(fs_info, l);
+			space_needed -= btrfs_leaf_free_space(l);
 
 		wret = push_leaf_right(trans, root, path, space_needed,
 				       space_needed, 0, 0);
@@ -4219,8 +4219,7 @@ static noinline int split_leaf(struct btrfs_trans_handle *trans,
 		if (wret) {
 			space_needed = data_size;
 			if (slot > 0)
-				space_needed -= btrfs_leaf_free_space(fs_info,
-								      l);
+				space_needed -= btrfs_leaf_free_space(l);
 			wret = push_leaf_left(trans, root, path, space_needed,
 					      space_needed, 0, (u32)-1);
 			if (wret < 0)
@@ -4229,7 +4228,7 @@ static noinline int split_leaf(struct btrfs_trans_handle *trans,
 		l = path->nodes[0];
 
 		/* did the pushes work? */
-		if (btrfs_leaf_free_space(fs_info, l) >= data_size)
+		if (btrfs_leaf_free_space(l) >= data_size)
 			return 0;
 	}
 
@@ -4336,7 +4335,7 @@ static noinline int split_leaf(struct btrfs_trans_handle *trans,
 push_for_double:
 	push_for_double_split(trans, root, path, data_size);
 	tried_avoid_double = 1;
-	if (btrfs_leaf_free_space(fs_info, path->nodes[0]) >= data_size)
+	if (btrfs_leaf_free_space(path->nodes[0]) >= data_size)
 		return 0;
 	goto again;
 }
@@ -4345,7 +4344,6 @@ static noinline int setup_leaf_for_split(struct btrfs_trans_handle *trans,
 					 struct btrfs_root *root,
 					 struct btrfs_path *path, int ins_len)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_key key;
 	struct extent_buffer *leaf;
 	struct btrfs_file_extent_item *fi;
@@ -4359,7 +4357,7 @@ static noinline int setup_leaf_for_split(struct btrfs_trans_handle *trans,
 	BUG_ON(key.type != BTRFS_EXTENT_DATA_KEY &&
 	       key.type != BTRFS_EXTENT_CSUM_KEY);
 
-	if (btrfs_leaf_free_space(fs_info, leaf) >= ins_len)
+	if (btrfs_leaf_free_space(leaf) >= ins_len)
 		return 0;
 
 	item_size = btrfs_item_size_nr(leaf, path->slots[0]);
@@ -4386,7 +4384,7 @@ static noinline int setup_leaf_for_split(struct btrfs_trans_handle *trans,
 		goto err;
 
 	/* the leaf has  changed, it now has room.  return now */
-	if (btrfs_leaf_free_space(fs_info, path->nodes[0]) >= ins_len)
+	if (btrfs_leaf_free_space(path->nodes[0]) >= ins_len)
 		goto err;
 
 	if (key.type == BTRFS_EXTENT_DATA_KEY) {
@@ -4425,7 +4423,7 @@ static noinline int split_item(struct btrfs_fs_info *fs_info,
 	struct btrfs_disk_key disk_key;
 
 	leaf = path->nodes[0];
-	BUG_ON(btrfs_leaf_free_space(fs_info, leaf) < sizeof(struct btrfs_item));
+	BUG_ON(btrfs_leaf_free_space(leaf) < sizeof(struct btrfs_item));
 
 	btrfs_set_path_blocking(path);
 
@@ -4474,7 +4472,7 @@ static noinline int split_item(struct btrfs_fs_info *fs_info,
 			    item_size - split_offset);
 	btrfs_mark_buffer_dirty(leaf);
 
-	BUG_ON(btrfs_leaf_free_space(fs_info, leaf) < 0);
+	BUG_ON(btrfs_leaf_free_space(leaf) < 0);
 	kfree(buf);
 	return 0;
 }
@@ -4642,7 +4640,7 @@ void btrfs_truncate_item(struct btrfs_fs_info *fs_info,
 	btrfs_set_item_size(leaf, item, new_size);
 	btrfs_mark_buffer_dirty(leaf);
 
-	if (btrfs_leaf_free_space(fs_info, leaf) < 0) {
+	if (btrfs_leaf_free_space(leaf) < 0) {
 		btrfs_print_leaf(leaf);
 		BUG();
 	}
@@ -4671,7 +4669,7 @@ void btrfs_extend_item(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 	nritems = btrfs_header_nritems(leaf);
 	data_end = leaf_data_end(leaf);
 
-	if (btrfs_leaf_free_space(fs_info, leaf) < data_size) {
+	if (btrfs_leaf_free_space(leaf) < data_size) {
 		btrfs_print_leaf(leaf);
 		BUG();
 	}
@@ -4710,7 +4708,7 @@ void btrfs_extend_item(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 	btrfs_set_item_size(leaf, item, old_size + data_size);
 	btrfs_mark_buffer_dirty(leaf);
 
-	if (btrfs_leaf_free_space(fs_info, leaf) < 0) {
+	if (btrfs_leaf_free_space(leaf) < 0) {
 		btrfs_print_leaf(leaf);
 		BUG();
 	}
@@ -4749,10 +4747,10 @@ void setup_items_for_insert(struct btrfs_root *root, struct btrfs_path *path,
 	nritems = btrfs_header_nritems(leaf);
 	data_end = leaf_data_end(leaf);
 
-	if (btrfs_leaf_free_space(fs_info, leaf) < total_size) {
+	if (btrfs_leaf_free_space(leaf) < total_size) {
 		btrfs_print_leaf(leaf);
 		btrfs_crit(fs_info, "not enough freespace need %u have %d",
-			   total_size, btrfs_leaf_free_space(fs_info, leaf));
+			   total_size, btrfs_leaf_free_space(leaf));
 		BUG();
 	}
 
@@ -4803,7 +4801,7 @@ void setup_items_for_insert(struct btrfs_root *root, struct btrfs_path *path,
 	btrfs_set_header_nritems(leaf, nritems + nr);
 	btrfs_mark_buffer_dirty(leaf);
 
-	if (btrfs_leaf_free_space(fs_info, leaf) < 0) {
+	if (btrfs_leaf_free_space(leaf) < 0) {
 		btrfs_print_leaf(leaf);
 		BUG();
 	}
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 9465e5360c3f..9528eb7c93d7 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3011,8 +3011,7 @@ static inline int btrfs_next_item(struct btrfs_root *root, struct btrfs_path *p)
 {
 	return btrfs_next_old_item(root, p, 0);
 }
-int btrfs_leaf_free_space(struct btrfs_fs_info *fs_info,
-			  struct extent_buffer *leaf);
+int btrfs_leaf_free_space(struct extent_buffer *leaf);
 int __must_check btrfs_drop_snapshot(struct btrfs_root *root,
 				     struct btrfs_block_rsv *block_rsv,
 				     int update_ref, int for_reloc);
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index c669f250d4a0..ccba129577c8 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -691,7 +691,6 @@ static int btrfs_batch_insert_items(struct btrfs_root *root,
 				    struct btrfs_path *path,
 				    struct btrfs_delayed_item *item)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_delayed_item *curr, *next;
 	int free_space;
 	int total_data_size = 0, total_size = 0;
@@ -708,7 +707,7 @@ static int btrfs_batch_insert_items(struct btrfs_root *root,
 	BUG_ON(!path->nodes[0]);
 
 	leaf = path->nodes[0];
-	free_space = btrfs_leaf_free_space(fs_info, leaf);
+	free_space = btrfs_leaf_free_space(leaf);
 	INIT_LIST_HEAD(&head);
 
 	next = item;
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index aa40e66df1e1..3038054bbd2b 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -821,11 +821,11 @@ int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
 		u32 diff;
 		u32 free_space;
 
-		if (btrfs_leaf_free_space(fs_info, leaf) <
+		if (btrfs_leaf_free_space(leaf) <
 				 sizeof(struct btrfs_item) + csum_size * 2)
 			goto insert;
 
-		free_space = btrfs_leaf_free_space(fs_info, leaf) -
+		free_space = btrfs_leaf_free_space(leaf) -
 					 sizeof(struct btrfs_item) - csum_size;
 		tmp = sums->len - total_bytes;
 		tmp >>= fs_info->sb->s_blocksize_bits;
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 5e6aee84daee..15cc3b861346 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1050,7 +1050,7 @@ int __btrfs_drop_extents(struct btrfs_trans_handle *trans,
 	if (!ret && replace_extent && leafs_visited == 1 &&
 	    (path->locks[0] == BTRFS_WRITE_LOCK_BLOCKING ||
 	     path->locks[0] == BTRFS_WRITE_LOCK) &&
-	    btrfs_leaf_free_space(fs_info, leaf) >=
+	    btrfs_leaf_free_space(leaf) >=
 	    sizeof(struct btrfs_item) + extent_item_size) {
 
 		key.objectid = ino;
diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index df49931ffe92..1141ca5fae6a 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -189,7 +189,7 @@ void btrfs_print_leaf(struct extent_buffer *l)
 	btrfs_info(fs_info,
 		   "leaf %llu gen %llu total ptrs %d free space %d owner %llu",
 		   btrfs_header_bytenr(l), btrfs_header_generation(l), nr,
-		   btrfs_leaf_free_space(fs_info, l), btrfs_header_owner(l));
+		   btrfs_leaf_free_space(l), btrfs_header_owner(l));
 	print_eb_refs_lock(l);
 	for (i = 0 ; i < nr ; i++) {
 		item = btrfs_item_nr(i);
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 58579a4d2f22..5532036f2530 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -176,7 +176,7 @@ int btrfs_setxattr(struct btrfs_trans_handle *trans, struct inode *inode,
 		char *ptr;
 
 		if (size > old_data_len) {
-			if (btrfs_leaf_free_space(fs_info, leaf) <
+			if (btrfs_leaf_free_space(leaf) <
 			    (size - old_data_len)) {
 				ret = -ENOSPC;
 				goto out;
-- 
2.21.0

