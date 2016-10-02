Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37748 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751802AbcJBNZo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 2 Oct 2016 09:25:44 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u92DNCxc034542
        for <linux-btrfs@vger.kernel.org>; Sun, 2 Oct 2016 09:25:43 -0400
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
        by mx0a-001b2d01.pphosted.com with ESMTP id 25t99vcb6n-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Oct 2016 09:25:43 -0400
Received: from localhost
        by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Sun, 2 Oct 2016 07:25:43 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH V21 09/19] Btrfs: subpage-blocksize: Compute free space tree BITMAP_RANGE based on sectorsize
Date: Sun,  2 Oct 2016 18:54:18 +0530
In-Reply-To: <1475414668-25954-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1475414668-25954-1-git-send-email-chandan@linux.vnet.ibm.com>
Message-Id: <1475414668-25954-10-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The default bitmap length computation in free space tree sanity tests
assumes PAGE_SIZE as the sectorsize. This commit fixes this by using a
variable sectorsize to calculate BITMAP_RANGE.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/tests/free-space-tree-tests.c | 79 ++++++++++++++++++----------------
 1 file changed, 43 insertions(+), 36 deletions(-)

diff --git a/fs/btrfs/tests/free-space-tree-tests.c b/fs/btrfs/tests/free-space-tree-tests.c
index 3bf5df1..11d9fb0 100644
--- a/fs/btrfs/tests/free-space-tree-tests.c
+++ b/fs/btrfs/tests/free-space-tree-tests.c
@@ -31,7 +31,7 @@ struct free_space_extent {
  * The test cases align their operations to this in order to hit some of the
  * edge cases in the bitmap code.
  */
-#define BITMAP_RANGE (BTRFS_FREE_SPACE_BITMAP_BITS * PAGE_SIZE)
+#define BITMAP_RANGE(sectorsize) (BTRFS_FREE_SPACE_BITMAP_BITS * (sectorsize))
 
 static int __check_free_space_extents(struct btrfs_trans_handle *trans,
 				      struct btrfs_fs_info *fs_info,
@@ -203,14 +203,15 @@ static int test_remove_beginning(struct btrfs_trans_handle *trans,
 				 struct btrfs_block_group_cache *cache,
 				 struct btrfs_path *path)
 {
+	u64 bitmap_range = BITMAP_RANGE(fs_info->tree_root->sectorsize);
 	struct free_space_extent extents[] = {
-		{cache->key.objectid + BITMAP_RANGE,
-			cache->key.offset - BITMAP_RANGE},
+		{cache->key.objectid + bitmap_range,
+			cache->key.offset - bitmap_range},
 	};
 	int ret;
 
 	ret = __remove_from_free_space_tree(trans, fs_info, cache, path,
-					    cache->key.objectid, BITMAP_RANGE);
+					    cache->key.objectid, bitmap_range);
 	if (ret) {
 		test_msg("Could not remove free space\n");
 		return ret;
@@ -226,15 +227,16 @@ static int test_remove_end(struct btrfs_trans_handle *trans,
 			   struct btrfs_block_group_cache *cache,
 			   struct btrfs_path *path)
 {
+	u64 bitmap_range = BITMAP_RANGE(fs_info->tree_root->sectorsize);
 	struct free_space_extent extents[] = {
-		{cache->key.objectid, cache->key.offset - BITMAP_RANGE},
+		{cache->key.objectid, cache->key.offset - bitmap_range},
 	};
 	int ret;
 
 	ret = __remove_from_free_space_tree(trans, fs_info, cache, path,
 					    cache->key.objectid +
-					    cache->key.offset - BITMAP_RANGE,
-					    BITMAP_RANGE);
+					    cache->key.offset - bitmap_range,
+					    bitmap_range);
 	if (ret) {
 		test_msg("Could not remove free space\n");
 		return ret;
@@ -249,16 +251,17 @@ static int test_remove_middle(struct btrfs_trans_handle *trans,
 			      struct btrfs_block_group_cache *cache,
 			      struct btrfs_path *path)
 {
+	u64 bitmap_range = BITMAP_RANGE(fs_info->tree_root->sectorsize);
 	struct free_space_extent extents[] = {
-		{cache->key.objectid, BITMAP_RANGE},
-		{cache->key.objectid + 2 * BITMAP_RANGE,
-			cache->key.offset - 2 * BITMAP_RANGE},
+		{cache->key.objectid, bitmap_range},
+		{cache->key.objectid + 2 * bitmap_range,
+			cache->key.offset - 2 * bitmap_range},
 	};
 	int ret;
 
 	ret = __remove_from_free_space_tree(trans, fs_info, cache, path,
-					    cache->key.objectid + BITMAP_RANGE,
-					    BITMAP_RANGE);
+					    cache->key.objectid + bitmap_range,
+					    bitmap_range);
 	if (ret) {
 		test_msg("Could not remove free space\n");
 		return ret;
@@ -273,8 +276,9 @@ static int test_merge_left(struct btrfs_trans_handle *trans,
 			   struct btrfs_block_group_cache *cache,
 			   struct btrfs_path *path)
 {
+	u64 bitmap_range = BITMAP_RANGE(fs_info->tree_root->sectorsize);
 	struct free_space_extent extents[] = {
-		{cache->key.objectid, 2 * BITMAP_RANGE},
+		{cache->key.objectid, 2 * bitmap_range},
 	};
 	int ret;
 
@@ -287,15 +291,15 @@ static int test_merge_left(struct btrfs_trans_handle *trans,
 	}
 
 	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
-				       cache->key.objectid, BITMAP_RANGE);
+				       cache->key.objectid, bitmap_range);
 	if (ret) {
 		test_msg("Could not add free space\n");
 		return ret;
 	}
 
 	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
-				       cache->key.objectid + BITMAP_RANGE,
-				       BITMAP_RANGE);
+				       cache->key.objectid + bitmap_range,
+				       bitmap_range);
 	if (ret) {
 		test_msg("Could not add free space\n");
 		return ret;
@@ -310,8 +314,9 @@ static int test_merge_right(struct btrfs_trans_handle *trans,
 			   struct btrfs_block_group_cache *cache,
 			   struct btrfs_path *path)
 {
+	u64 bitmap_range = BITMAP_RANGE(fs_info->tree_root->sectorsize);
 	struct free_space_extent extents[] = {
-		{cache->key.objectid + BITMAP_RANGE, 2 * BITMAP_RANGE},
+		{cache->key.objectid + bitmap_range, 2 * bitmap_range},
 	};
 	int ret;
 
@@ -324,16 +329,16 @@ static int test_merge_right(struct btrfs_trans_handle *trans,
 	}
 
 	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
-				       cache->key.objectid + 2 * BITMAP_RANGE,
-				       BITMAP_RANGE);
+				       cache->key.objectid + 2 * bitmap_range,
+				       bitmap_range);
 	if (ret) {
 		test_msg("Could not add free space\n");
 		return ret;
 	}
 
 	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
-				       cache->key.objectid + BITMAP_RANGE,
-				       BITMAP_RANGE);
+				       cache->key.objectid + bitmap_range,
+				       bitmap_range);
 	if (ret) {
 		test_msg("Could not add free space\n");
 		return ret;
@@ -348,8 +353,9 @@ static int test_merge_both(struct btrfs_trans_handle *trans,
 			   struct btrfs_block_group_cache *cache,
 			   struct btrfs_path *path)
 {
+	u64 bitmap_range = BITMAP_RANGE(fs_info->tree_root->sectorsize);
 	struct free_space_extent extents[] = {
-		{cache->key.objectid, 3 * BITMAP_RANGE},
+		{cache->key.objectid, 3 * bitmap_range},
 	};
 	int ret;
 
@@ -362,23 +368,23 @@ static int test_merge_both(struct btrfs_trans_handle *trans,
 	}
 
 	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
-				       cache->key.objectid, BITMAP_RANGE);
+				       cache->key.objectid, bitmap_range);
 	if (ret) {
 		test_msg("Could not add free space\n");
 		return ret;
 	}
 
 	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
-				       cache->key.objectid + 2 * BITMAP_RANGE,
-				       BITMAP_RANGE);
+				       cache->key.objectid + 2 * bitmap_range,
+				       bitmap_range);
 	if (ret) {
 		test_msg("Could not add free space\n");
 		return ret;
 	}
 
 	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
-				       cache->key.objectid + BITMAP_RANGE,
-				       BITMAP_RANGE);
+				       cache->key.objectid + bitmap_range,
+				       bitmap_range);
 	if (ret) {
 		test_msg("Could not add free space\n");
 		return ret;
@@ -393,10 +399,11 @@ static int test_merge_none(struct btrfs_trans_handle *trans,
 			   struct btrfs_block_group_cache *cache,
 			   struct btrfs_path *path)
 {
+	u64 bitmap_range = BITMAP_RANGE(fs_info->tree_root->sectorsize);
 	struct free_space_extent extents[] = {
-		{cache->key.objectid, BITMAP_RANGE},
-		{cache->key.objectid + 2 * BITMAP_RANGE, BITMAP_RANGE},
-		{cache->key.objectid + 4 * BITMAP_RANGE, BITMAP_RANGE},
+		{cache->key.objectid, bitmap_range},
+		{cache->key.objectid + 2 * bitmap_range, bitmap_range},
+		{cache->key.objectid + 4 * bitmap_range, bitmap_range},
 	};
 	int ret;
 
@@ -409,23 +416,23 @@ static int test_merge_none(struct btrfs_trans_handle *trans,
 	}
 
 	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
-				       cache->key.objectid, BITMAP_RANGE);
+				       cache->key.objectid, bitmap_range);
 	if (ret) {
 		test_msg("Could not add free space\n");
 		return ret;
 	}
 
 	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
-				       cache->key.objectid + 4 * BITMAP_RANGE,
-				       BITMAP_RANGE);
+				       cache->key.objectid + 4 * bitmap_range,
+				       bitmap_range);
 	if (ret) {
 		test_msg("Could not add free space\n");
 		return ret;
 	}
 
 	ret = __add_to_free_space_tree(trans, fs_info, cache, path,
-				       cache->key.objectid + 2 * BITMAP_RANGE,
-				       BITMAP_RANGE);
+				       cache->key.objectid + 2 * bitmap_range,
+				       bitmap_range);
 	if (ret) {
 		test_msg("Could not add free space\n");
 		return ret;
@@ -480,7 +487,7 @@ static int run_test(test_func_t test_func, int bitmaps,
 	btrfs_set_header_nritems(root->node, 0);
 	root->alloc_bytenr += 2 * nodesize;
 
-	cache = btrfs_alloc_dummy_block_group(8 * BITMAP_RANGE, sectorsize);
+	cache = btrfs_alloc_dummy_block_group(8 * BITMAP_RANGE(sectorsize), sectorsize);
 	if (!cache) {
 		test_msg("Couldn't allocate dummy block group cache\n");
 		ret = -ENOMEM;
-- 
2.5.5

