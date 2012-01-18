From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: remove search_start and search_end from find_free_extent and callers
Date: Wed, 18 Jan 2012 10:57:50 -0500
Message-ID: <1326902270-3092-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We have been passing nothing but (u64)-1 to find_free_extent for search_end in
all of the callers, so it's completely useless, and we've always been passing 0
in as search_start, so just remove them as function arguments and move
search_start into find_free_extent.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.h       |    3 +--
 fs/btrfs/extent-tree.c |   16 ++++------------
 fs/btrfs/inode.c       |    9 ++++-----
 3 files changed, 9 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 3c2cbf7..d62a00b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2466,8 +2466,7 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 				  struct btrfs_root *root,
 				  u64 num_bytes, u64 min_alloc_size,
 				  u64 empty_size, u64 hint_byte,
-				  u64 search_end, struct btrfs_key *ins,
-				  u64 data);
+				  struct btrfs_key *ins, u64 data);
 int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		  struct extent_buffer *buf, int full_backref, int for_cow);
 int btrfs_dec_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 2288674..26f99ac 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5267,7 +5267,6 @@ enum btrfs_loop_type {
 static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 				     struct btrfs_root *orig_root,
 				     u64 num_bytes, u64 empty_size,
-				     u64 search_start, u64 search_end,
 				     u64 hint_byte, struct btrfs_key *ins,
 				     u64 data)
 {
@@ -5276,6 +5275,7 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 	struct btrfs_free_cluster *last_ptr = NULL;
 	struct btrfs_block_group_cache *block_group = NULL;
 	struct btrfs_block_group_cache *used_block_group;
+	u64 search_start = 0;
 	int empty_cluster = 2 * 1024 * 1024;
 	int allowed_chunk_alloc = 0;
 	int done_chunk_alloc = 0;
@@ -5559,11 +5559,6 @@ unclustered_alloc:
 		}
 checks:
 		search_start = stripe_align(root, offset);
-		/* move on to the next group */
-		if (search_start + num_bytes >= search_end) {
-			btrfs_add_free_space(used_block_group, offset, num_bytes);
-			goto loop;
-		}
 
 		/* move on to the next group */
 		if (search_start + num_bytes >
@@ -5711,11 +5706,9 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root,
 			 u64 num_bytes, u64 min_alloc_size,
 			 u64 empty_size, u64 hint_byte,
-			 u64 search_end, struct btrfs_key *ins,
-			 u64 data)
+			 struct btrfs_key *ins, u64 data)
 {
 	int ret;
-	u64 search_start = 0;
 
 	data = btrfs_get_alloc_profile(root, data);
 again:
@@ -5730,8 +5723,7 @@ again:
 
 	WARN_ON(num_bytes < root->sectorsize);
 	ret = find_free_extent(trans, root, num_bytes, empty_size,
-			       search_start, search_end, hint_byte,
-			       ins, data);
+			       hint_byte, ins, data);
 
 	if (ret == -ENOSPC && num_bytes > min_alloc_size) {
 		num_bytes = num_bytes >> 1;
@@ -6123,7 +6115,7 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 		return ERR_CAST(block_rsv);
 
 	ret = btrfs_reserve_extent(trans, root, blocksize, blocksize,
-				   empty_size, hint, (u64)-1, &ins, 0);
+				   empty_size, hint, &ins, 0);
 	if (ret) {
 		unuse_block_rsv(root->fs_info, block_rsv, blocksize);
 		return ERR_PTR(ret);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5977987..4c58efe 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -634,8 +634,7 @@ retry:
 		ret = btrfs_reserve_extent(trans, root,
 					   async_extent->compressed_size,
 					   async_extent->compressed_size,
-					   0, alloc_hint,
-					   (u64)-1, &ins, 1);
+					   0, alloc_hint, &ins, 1);
 		btrfs_end_transaction(trans, root);
 
 		if (ret) {
@@ -838,7 +837,7 @@ static noinline int cow_file_range(struct inode *inode,
 		cur_alloc_size = disk_num_bytes;
 		ret = btrfs_reserve_extent(trans, root, cur_alloc_size,
 					   root->sectorsize, 0, alloc_hint,
-					   (u64)-1, &ins, 1);
+					   &ins, 1);
 		BUG_ON(ret);
 
 		em = alloc_extent_map();
@@ -5386,7 +5385,7 @@ static struct extent_map *btrfs_new_extent_direct(struct inode *inode,
 
 	alloc_hint = get_extent_allocation_hint(inode, start, len);
 	ret = btrfs_reserve_extent(trans, root, len, root->sectorsize, 0,
-				   alloc_hint, (u64)-1, &ins, 1);
+				   alloc_hint, &ins, 1);
 	if (ret) {
 		em = ERR_PTR(ret);
 		goto out;
@@ -7280,7 +7279,7 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 		}
 
 		ret = btrfs_reserve_extent(trans, root, num_bytes, min_size,
-					   0, *alloc_hint, (u64)-1, &ins, 1);
+					   0, *alloc_hint, &ins, 1);
 		if (ret) {
 			if (own_trans)
 				btrfs_end_transaction(trans, root);
-- 
1.7.5.2

