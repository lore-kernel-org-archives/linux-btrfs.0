Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:35397 "EHLO
	mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbcGNXbW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jul 2016 19:31:22 -0400
Received: by mail-pf0-f169.google.com with SMTP id c2so34823962pfa.2
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Jul 2016 16:31:21 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 3/3] Btrfs: expand free space tree sanity tests to catch endianness bug
Date: Thu, 14 Jul 2016 16:31:08 -0700
Message-Id: <cb4b1ce6e2a419db84fbc9cc5356951fa49953d2.1468538030.git.osandov@fb.com>
In-Reply-To: <cover.1468538030.git.osandov@fb.com>
References: <cover.1468538030.git.osandov@fb.com>
In-Reply-To: <cover.1468538030.git.osandov@fb.com>
References: <cover.1468538030.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

The free space tree format conversion functions were broken on
big-endian systems, but the sanity tests didn't catch it because all of
the operations were aligned to multiple words. This was meant to catch
any bugs in the extent buffer code's handling of high memory, but it
ended up hiding the endianness bug. Expand the tests to do both
sector-aligned and page-aligned operations.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/tests/free-space-tree-tests.c | 164 +++++++++++++++++++--------------
 1 file changed, 96 insertions(+), 68 deletions(-)

diff --git a/fs/btrfs/tests/free-space-tree-tests.c b/fs/btrfs/tests/free-space-tree-tests.c
index aac507085ab0..d837b9e422d8 100644
--- a/fs/btrfs/tests/free-space-tree-tests.c
+++ b/fs/btrfs/tests/free-space-tree-tests.c
@@ -27,12 +27,6 @@ struct free_space_extent {
 	u64 start, length;
 };
 
-/*
- * The test cases align their operations to this in order to hit some of the
- * edge cases in the bitmap code.
- */
-#define BITMAP_RANGE (BTRFS_FREE_SPACE_BITMAP_BITS * PAGE_SIZE)
-
 static int __check_free_space_extents(struct btrfs_trans_handle *trans,
 				      struct btrfs_fs_info *fs_info,
 				      struct btrfs_block_group_cache *cache,
@@ -168,7 +162,8 @@ static int check_free_space_extents(struct btrfs_trans_handle *trans,
 static int test_empty_block_group(struct btrfs_trans_handle *trans,
 				  struct btrfs_fs_info *fs_info,
 				  struct btrfs_block_group_cache *cache,
-				  struct btrfs_path *path)
+				  struct btrfs_path *path,
+				  u32 alignment)
 {
 	struct free_space_extent extents[] = {
 		{cache->key.objectid, cache->key.offset},
@@ -181,7 +176,8 @@ static int test_empty_block_group(struct btrfs_trans_handle *trans,
 static int test_remove_all(struct btrfs_trans_handle *trans,
 			   struct btrfs_fs_info *fs_info,
 			   struct btrfs_block_group_cache *cache,
-			   struct btrfs_path *path)
+			   struct btrfs_path *path,
+			   u32 alignment)
 {
 	struct free_space_extent extents[] = {};
 	int ret;
@@ -201,16 +197,17 @@ static int test_remove_all(struct btrfs_trans_handle *trans,
 static int test_remove_beginning(struct btrfs_trans_handle *trans,
 				 struct btrfs_fs_info *fs_info,
 				 struct btrfs_block_group_cache *cache,
-				 struct btrfs_path *path)
+				 struct btrfs_path *path,
+				 u32 alignment)
 {
 	struct free_space_extent extents[] = {
-		{cache->key.objectid + BITMAP_RANGE,
-			cache->key.offset - BITMAP_RANGE},
+		{cache->key.objectid + alignment,
+			cache->key.offset - alignment},
 	};
 	int ret;
 
 	ret = __remove_from_free_space_tree(trans, fs_info, cache, path,
-					    cache->key.objectid, BITMAP_RANGE);
+					    cache->key.objectid, alignment);
 	if (ret) {
 		test_msg("Could not remove free space\n");
 		return ret;
@@ -224,17 +221,18 @@ static int test_remove_beginning(struct btrfs_trans_handle *trans,
 static int test_remove_end(struct btrfs_trans_handle *trans,
 			   struct btrfs_fs_info *fs_info,
 			   struct btrfs_block_group_cache *cache,
-			   struct btrfs_path *path)
+			   struct btrfs_path *path,
+			   u32 alignment)
 {
 	struct free_space_extent extents[] = {
-		{cache->key.objectid, cache->key.offset - BITMAP_RANGE},
+		{cache->key.objectid, cache->key.offset - alignment},
 	};
 	int ret;
 
 	ret = __remove_from_free_space_tree(trans, fs_info, cache, path,
 					    cache->key.objectid +
-					    cache->key.offset - BITMAP_RANGE,
-					    BITMAP_RANGE);
+					    cache->key.offset - alignment,
+					    alignment);
 	if (ret) {
 		test_msg("Could not remove free space\n");
 		return ret;
@@ -247,18 +245,19 @@ static int test_remove_end(struct btrfs_trans_handle *trans,
 static int test_remove_middle(struct btrfs_trans_handle *trans,
 			      struct btrfs_fs_info *fs_info,
 			      struct btrfs_block_group_cache *cache,
-			      struct btrfs_path *path)
+			      struct btrfs_path *path,
+			      u32 alignment)
 {
 	struct free_space_extent extents[] = {
-		{cache->key.objectid, BITMAP_RANGE},
-		{cache->key.objectid + 2 * BITMAP_RANGE,
-			cache->key.offset - 2 * BITMAP_RANGE},
+		{cache->key.objectid, alignment},
+		{cache->key.objectid + 2 * alignment,
+			cache->key.offset - 2 * alignment},
 	};
 	int ret;
 
 	ret = __remove_from_free_space_tree(trans, fs_info, cache, path,
-					    cache->key.objectid + BITMAP_RANGE,
-					    BITMAP_RANGE);
+					    cache->key.objectid + alignment,
+					    alignment);
 	if (ret) {
 		test_msg("Could not remove free space\n");
 		return ret;
@@ -271,10 +270,11 @@ static int test_remove_middle(struct btrfs_trans_handle *trans,
 static int test_merge_left(struct btrfs_trans_handle *trans,
 			   struct btrfs_fs_info *fs_info,
 			   struct btrfs_block_group_cache *cache,
-			   struct btrfs_path *path)
+			   struct btrfs_path *path,
+			   u32 alignment)
 {
 	struct free_space_extent extents[] = {
-		{cache->key.objectid, 2 * BITMAP_RANGE},
+		{cache->key.objectid, 2 * alignment},
 	};
 	int ret;
 
@@ -287,15 +287,15 @@ static int test_merge_left(struct btrfs_trans_handle *trans,
 	}
 
 	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
-				       cache->key.objectid, BITMAP_RANGE);
+				       cache->key.objectid, alignment);
 	if (ret) {
 		test_msg("Could not add free space\n");
 		return ret;
 	}
 
 	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
-				       cache->key.objectid + BITMAP_RANGE,
-				       BITMAP_RANGE);
+				       cache->key.objectid + alignment,
+				       alignment);
 	if (ret) {
 		test_msg("Could not add free space\n");
 		return ret;
@@ -308,10 +308,11 @@ static int test_merge_left(struct btrfs_trans_handle *trans,
 static int test_merge_right(struct btrfs_trans_handle *trans,
 			   struct btrfs_fs_info *fs_info,
 			   struct btrfs_block_group_cache *cache,
-			   struct btrfs_path *path)
+			   struct btrfs_path *path,
+			   u32 alignment)
 {
 	struct free_space_extent extents[] = {
-		{cache->key.objectid + BITMAP_RANGE, 2 * BITMAP_RANGE},
+		{cache->key.objectid + alignment, 2 * alignment},
 	};
 	int ret;
 
@@ -324,16 +325,16 @@ static int test_merge_right(struct btrfs_trans_handle *trans,
 	}
 
 	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
-				       cache->key.objectid + 2 * BITMAP_RANGE,
-				       BITMAP_RANGE);
+				       cache->key.objectid + 2 * alignment,
+				       alignment);
 	if (ret) {
 		test_msg("Could not add free space\n");
 		return ret;
 	}
 
 	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
-				       cache->key.objectid + BITMAP_RANGE,
-				       BITMAP_RANGE);
+				       cache->key.objectid + alignment,
+				       alignment);
 	if (ret) {
 		test_msg("Could not add free space\n");
 		return ret;
@@ -346,10 +347,11 @@ static int test_merge_right(struct btrfs_trans_handle *trans,
 static int test_merge_both(struct btrfs_trans_handle *trans,
 			   struct btrfs_fs_info *fs_info,
 			   struct btrfs_block_group_cache *cache,
-			   struct btrfs_path *path)
+			   struct btrfs_path *path,
+			   u32 alignment)
 {
 	struct free_space_extent extents[] = {
-		{cache->key.objectid, 3 * BITMAP_RANGE},
+		{cache->key.objectid, 3 * alignment},
 	};
 	int ret;
 
@@ -362,23 +364,23 @@ static int test_merge_both(struct btrfs_trans_handle *trans,
 	}
 
 	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
-				       cache->key.objectid, BITMAP_RANGE);
+				       cache->key.objectid, alignment);
 	if (ret) {
 		test_msg("Could not add free space\n");
 		return ret;
 	}
 
 	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
-				       cache->key.objectid + 2 * BITMAP_RANGE,
-				       BITMAP_RANGE);
+				       cache->key.objectid + 2 * alignment,
+				       alignment);
 	if (ret) {
 		test_msg("Could not add free space\n");
 		return ret;
 	}
 
 	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
-				       cache->key.objectid + BITMAP_RANGE,
-				       BITMAP_RANGE);
+				       cache->key.objectid + alignment,
+				       alignment);
 	if (ret) {
 		test_msg("Could not add free space\n");
 		return ret;
@@ -391,12 +393,13 @@ static int test_merge_both(struct btrfs_trans_handle *trans,
 static int test_merge_none(struct btrfs_trans_handle *trans,
 			   struct btrfs_fs_info *fs_info,
 			   struct btrfs_block_group_cache *cache,
-			   struct btrfs_path *path)
+			   struct btrfs_path *path,
+			   u32 alignment)
 {
 	struct free_space_extent extents[] = {
-		{cache->key.objectid, BITMAP_RANGE},
-		{cache->key.objectid + 2 * BITMAP_RANGE, BITMAP_RANGE},
-		{cache->key.objectid + 4 * BITMAP_RANGE, BITMAP_RANGE},
+		{cache->key.objectid, alignment},
+		{cache->key.objectid + 2 * alignment, alignment},
+		{cache->key.objectid + 4 * alignment, alignment},
 	};
 	int ret;
 
@@ -409,23 +412,23 @@ static int test_merge_none(struct btrfs_trans_handle *trans,
 	}
 
 	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
-				       cache->key.objectid, BITMAP_RANGE);
+				       cache->key.objectid, alignment);
 	if (ret) {
 		test_msg("Could not add free space\n");
 		return ret;
 	}
 
 	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
-				       cache->key.objectid + 4 * BITMAP_RANGE,
-				       BITMAP_RANGE);
+				       cache->key.objectid + 4 * alignment,
+				       alignment);
 	if (ret) {
 		test_msg("Could not add free space\n");
 		return ret;
 	}
 
 	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
-				       cache->key.objectid + 2 * BITMAP_RANGE,
-				       BITMAP_RANGE);
+				       cache->key.objectid + 2 * alignment,
+				       alignment);
 	if (ret) {
 		test_msg("Could not add free space\n");
 		return ret;
@@ -438,10 +441,11 @@ static int test_merge_none(struct btrfs_trans_handle *trans,
 typedef int (*test_func_t)(struct btrfs_trans_handle *,
 			   struct btrfs_fs_info *,
 			   struct btrfs_block_group_cache *,
-			   struct btrfs_path *);
+			   struct btrfs_path *,
+			   u32 alignment);
 
-static int run_test(test_func_t test_func, int bitmaps,
-		u32 sectorsize, u32 nodesize)
+static int run_test(test_func_t test_func, int bitmaps, u32 sectorsize,
+		    u32 nodesize, u32 alignment)
 {
 	struct btrfs_root *root = NULL;
 	struct btrfs_block_group_cache *cache = NULL;
@@ -479,7 +483,7 @@ static int run_test(test_func_t test_func, int bitmaps,
 	btrfs_set_header_nritems(root->node, 0);
 	root->alloc_bytenr += 2 * nodesize;
 
-	cache = btrfs_alloc_dummy_block_group(8 * BITMAP_RANGE, sectorsize);
+	cache = btrfs_alloc_dummy_block_group(8 * alignment, sectorsize);
 	if (!cache) {
 		test_msg("Couldn't allocate dummy block group cache\n");
 		ret = -ENOMEM;
@@ -513,7 +517,7 @@ static int run_test(test_func_t test_func, int bitmaps,
 		}
 	}
 
-	ret = test_func(&trans, root->fs_info, cache, path);
+	ret = test_func(&trans, root->fs_info, cache, path, alignment);
 	if (ret)
 		goto out;
 
@@ -537,15 +541,27 @@ out:
 	return ret;
 }
 
-static int run_test_both_formats(test_func_t test_func,
-	u32 sectorsize, u32 nodesize)
+static int run_test_both_formats(test_func_t test_func, u32 sectorsize,
+				 u32 nodesize, u32 alignment)
 {
+	int test_ret = 0;
 	int ret;
 
-	ret = run_test(test_func, 0, sectorsize, nodesize);
-	if (ret)
-		return ret;
-	return run_test(test_func, 1, sectorsize, nodesize);
+	ret = run_test(test_func, 0, sectorsize, nodesize, alignment);
+	if (ret) {
+		test_msg("%pf failed with extents, sectorsize=%u, nodesize=%u, alignment=%u\n",
+			 test_func, sectorsize, nodesize, alignment);
+		test_ret = ret;
+	}
+
+	ret = run_test(test_func, 1, sectorsize, nodesize, alignment);
+	if (ret) {
+		test_msg("%pf failed with bitmaps, sectorsize=%u, nodesize=%u, alignment=%u\n",
+			 test_func, sectorsize, nodesize, alignment);
+		test_ret = ret;
+	}
+
+	return test_ret;
 }
 
 int btrfs_test_free_space_tree(u32 sectorsize, u32 nodesize)
@@ -561,18 +577,30 @@ int btrfs_test_free_space_tree(u32 sectorsize, u32 nodesize)
 		test_merge_both,
 		test_merge_none,
 	};
+	u32 bitmap_alignment;
+	int test_ret = 0;
 	int i;
 
+	/*
+	 * Align some operations to a page to flush out bugs in the extent
+	 * buffer bitmap handling of highmem.
+	 */
+	bitmap_alignment = BTRFS_FREE_SPACE_BITMAP_BITS * PAGE_SIZE;
+
 	test_msg("Running free space tree tests\n");
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
-		int ret = run_test_both_formats(tests[i], sectorsize,
-			nodesize);
-		if (ret) {
-			test_msg("%pf : sectorsize %u failed\n",
-				tests[i], sectorsize);
-			return ret;
-		}
+		int ret;
+
+		ret = run_test_both_formats(tests[i], sectorsize, nodesize,
+					    sectorsize);
+		if (ret)
+			test_ret = ret;
+
+		ret = run_test_both_formats(tests[i], sectorsize, nodesize,
+					    bitmap_alignment);
+		if (ret)
+			test_ret = ret;
 	}
 
-	return 0;
+	return test_ret;
 }
-- 
2.9.0

