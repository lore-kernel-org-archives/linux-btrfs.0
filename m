Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:51748 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697Ab2I0VRe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Sep 2012 17:17:34 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id f4SFc1o5mISP6hZF (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 27 Sep 2012 15:17:33 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: cache extent state when writing out dirty metadata pages
Date: Thu, 27 Sep 2012 17:23:01 -0400
Message-ID: <1348780981-5871-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Everytime we write out dirty pages we search for an offset in the tree,
convert the bits in the state, and then when we wait we search for the
offset again and clear the bits.  So for every dirty range in the io tree we
are doing 4 rb searches, which is suboptimal.  With this patch we are only
doing 2 searches for every cycle (modulo weird things happening).  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/disk-io.c          |    4 ++--
 fs/btrfs/extent-tree.c      |    5 +++--
 fs/btrfs/extent_io.c        |   43 +++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/extent_io.h        |    6 ++++--
 fs/btrfs/free-space-cache.c |    2 +-
 fs/btrfs/relocation.c       |    2 +-
 fs/btrfs/transaction.c      |   14 +++++++++-----
 fs/btrfs/tree-log.c         |    3 ++-
 8 files changed, 63 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c47a3ae..032cce2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3569,7 +3569,7 @@ static int btrfs_destroy_marked_extents(struct btrfs_root *root,
 
 	while (1) {
 		ret = find_first_extent_bit(dirty_pages, start, &start, &end,
-					    mark);
+					    mark, NULL);
 		if (ret)
 			break;
 
@@ -3624,7 +3624,7 @@ static int btrfs_destroy_pinned_extent(struct btrfs_root *root,
 again:
 	while (1) {
 		ret = find_first_extent_bit(unpin, 0, &start, &end,
-					    EXTENT_DIRTY);
+					    EXTENT_DIRTY, NULL);
 		if (ret)
 			break;
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index efb044e..65941d7 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -313,7 +313,8 @@ static u64 add_new_free_space(struct btrfs_block_group_cache *block_group,
 	while (start < end) {
 		ret = find_first_extent_bit(info->pinned_extents, start,
 					    &extent_start, &extent_end,
-					    EXTENT_DIRTY | EXTENT_UPTODATE);
+					    EXTENT_DIRTY | EXTENT_UPTODATE,
+					    NULL);
 		if (ret)
 			break;
 
@@ -5028,7 +5029,7 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 
 	while (1) {
 		ret = find_first_extent_bit(unpin, 0, &start, &end,
-					    EXTENT_DIRTY);
+					    EXTENT_DIRTY, NULL);
 		if (ret)
 			break;
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8f0f03b..1038f85 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -937,6 +937,7 @@ int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits,
  * @end:	the end offset in bytes (inclusive)
  * @bits:	the bits to set in this range
  * @clear_bits:	the bits to clear in this range
+ * @cached_state:	state that we're going to cache
  * @mask:	the allocation mask
  *
  * This will go through and set bits for the given range.  If any states exist
@@ -946,7 +947,8 @@ int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits,
  * boundary bits like LOCK.
  */
 int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
-		       int bits, int clear_bits, gfp_t mask)
+		       int bits, int clear_bits,
+		       struct extent_state **cached_state, gfp_t mask)
 {
 	struct extent_state *state;
 	struct extent_state *prealloc = NULL;
@@ -963,6 +965,15 @@ again:
 	}
 
 	spin_lock(&tree->lock);
+	if (cached_state && *cached_state) {
+		state = *cached_state;
+		if (state->start <= start && state->end > start &&
+		    state->tree) {
+			node = &state->rb_node;
+			goto hit_next;
+		}
+	}
+
 	/*
 	 * this search will find all the extents that end after
 	 * our range starts.
@@ -993,6 +1004,7 @@ hit_next:
 	 */
 	if (state->start == start && state->end <= end) {
 		set_state_bits(tree, state, &bits);
+		cache_state(state, cached_state);
 		state = clear_state_bit(tree, state, &clear_bits, 0);
 		if (last_end == (u64)-1)
 			goto out;
@@ -1033,6 +1045,7 @@ hit_next:
 			goto out;
 		if (state->end <= end) {
 			set_state_bits(tree, state, &bits);
+			cache_state(state, cached_state);
 			state = clear_state_bit(tree, state, &clear_bits, 0);
 			if (last_end == (u64)-1)
 				goto out;
@@ -1071,6 +1084,7 @@ hit_next:
 				   &bits);
 		if (err)
 			extent_io_tree_panic(tree, err);
+		cache_state(prealloc, cached_state);
 		prealloc = NULL;
 		start = this_end + 1;
 		goto search_again;
@@ -1093,6 +1107,7 @@ hit_next:
 			extent_io_tree_panic(tree, err);
 
 		set_state_bits(tree, prealloc, &bits);
+		cache_state(prealloc, cached_state);
 		clear_state_bit(tree, prealloc, &clear_bits, 0);
 		prealloc = NULL;
 		goto out;
@@ -1297,18 +1312,42 @@ out:
  * If nothing was found, 1 is returned. If found something, return 0.
  */
 int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
-			  u64 *start_ret, u64 *end_ret, int bits)
+			  u64 *start_ret, u64 *end_ret, int bits,
+			  struct extent_state **cached_state)
 {
 	struct extent_state *state;
+	struct rb_node *n;
 	int ret = 1;
 
 	spin_lock(&tree->lock);
+	if (cached_state && *cached_state) {
+		state = *cached_state;
+		if (state->end == start - 1 && state->tree) {
+			n = rb_next(&state->rb_node);
+			while (n) {
+				state = rb_entry(n, struct extent_state,
+						 rb_node);
+				if (state->state & bits)
+					goto got_it;
+				n = rb_next(n);
+			}
+			free_extent_state(*cached_state);
+			*cached_state = NULL;
+			goto out;
+		}
+		free_extent_state(*cached_state);
+		*cached_state = NULL;
+	}
+
 	state = find_first_extent_bit_state(tree, start, bits);
+got_it:
 	if (state) {
+		cache_state(state, cached_state);
 		*start_ret = state->start;
 		*end_ret = state->end;
 		ret = 0;
 	}
+out:
 	spin_unlock(&tree->lock);
 	return ret;
 }
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index a69dea2..7aeb310 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -233,13 +233,15 @@ int set_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
 int clear_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
 		       gfp_t mask);
 int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
-		       int bits, int clear_bits, gfp_t mask);
+		       int bits, int clear_bits,
+		       struct extent_state **cached_state, gfp_t mask);
 int set_extent_delalloc(struct extent_io_tree *tree, u64 start, u64 end,
 			struct extent_state **cached_state, gfp_t mask);
 int set_extent_defrag(struct extent_io_tree *tree, u64 start, u64 end,
 		      struct extent_state **cached_state, gfp_t mask);
 int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
-			  u64 *start_ret, u64 *end_ret, int bits);
+			  u64 *start_ret, u64 *end_ret, int bits,
+			  struct extent_state **cached_state);
 struct extent_state *find_first_extent_bit_state(struct extent_io_tree *tree,
 						 u64 start, int bits);
 int extent_invalidatepage(struct extent_io_tree *tree,
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index b107e68..1027b85 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -966,7 +966,7 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 			       block_group->key.offset)) {
 		ret = find_first_extent_bit(unpin, start,
 					    &extent_start, &extent_end,
-					    EXTENT_DIRTY);
+					    EXTENT_DIRTY, NULL);
 		if (ret) {
 			ret = 0;
 			break;
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 6e530bb..776f0aa 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3621,7 +3621,7 @@ next:
 
 		ret = find_first_extent_bit(&rc->processed_blocks,
 					    key.objectid, &start, &end,
-					    EXTENT_DIRTY);
+					    EXTENT_DIRTY, NULL);
 
 		if (ret == 0 && start <= key.objectid) {
 			btrfs_release_path(path);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 69139a3..77db875 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -687,13 +687,15 @@ int btrfs_write_marked_extents(struct btrfs_root *root,
 	int err = 0;
 	int werr = 0;
 	struct address_space *mapping = root->fs_info->btree_inode->i_mapping;
+	struct extent_state *cached_state = NULL;
 	u64 start = 0;
 	u64 end;
 
 	while (!find_first_extent_bit(dirty_pages, start, &start, &end,
-				      mark)) {
-		convert_extent_bit(dirty_pages, start, end, EXTENT_NEED_WAIT, mark,
-				   GFP_NOFS);
+				      mark, &cached_state)) {
+		convert_extent_bit(dirty_pages, start, end, EXTENT_NEED_WAIT,
+				   mark, &cached_state, GFP_NOFS);
+		cached_state = NULL;
 		err = filemap_fdatawrite_range(mapping, start, end);
 		if (err)
 			werr = err;
@@ -717,12 +719,14 @@ int btrfs_wait_marked_extents(struct btrfs_root *root,
 	int err = 0;
 	int werr = 0;
 	struct address_space *mapping = root->fs_info->btree_inode->i_mapping;
+	struct extent_state *cached_state = NULL;
 	u64 start = 0;
 	u64 end;
 
 	while (!find_first_extent_bit(dirty_pages, start, &start, &end,
-				      EXTENT_NEED_WAIT)) {
-		clear_extent_bits(dirty_pages, start, end, EXTENT_NEED_WAIT, GFP_NOFS);
+				      EXTENT_NEED_WAIT, &cached_state)) {
+		clear_extent_bit(dirty_pages, start, end, EXTENT_NEED_WAIT,
+				 0, 0, &cached_state, GFP_NOFS);
 		err = filemap_fdatawait_range(mapping, start, end);
 		if (err)
 			werr = err;
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 806a8ff..4e468a0 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2434,7 +2434,8 @@ static void free_log_tree(struct btrfs_trans_handle *trans,
 
 	while (1) {
 		ret = find_first_extent_bit(&log->dirty_log_pages,
-				0, &start, &end, EXTENT_DIRTY | EXTENT_NEW);
+				0, &start, &end, EXTENT_DIRTY | EXTENT_NEW,
+				NULL);
 		if (ret)
 			break;
 
-- 
1.7.7.6

