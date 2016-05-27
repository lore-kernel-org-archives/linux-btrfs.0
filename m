Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1511 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755035AbcE0HBr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 May 2016 03:01:47 -0400
Received: from pps.filterd (m0049461.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u4R6xPFu036351
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 03:01:46 -0400
Message-Id: <201605270701.u4R6xPFu036351@mx0a-001b2d01.pphosted.com>
Received: from e28smtp06.in.ibm.com (e28smtp06.in.ibm.com [125.16.236.6])
	by mx0a-001b2d01.pphosted.com with ESMTP id 236aym8vrp-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 03:01:44 -0400
Received: from localhost
	by e28smtp06.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <xufeifei@linux.vnet.ibm.com>;
	Fri, 27 May 2016 12:31:39 +0530
Received: from d28relay01.in.ibm.com (d28relay01.in.ibm.com [9.184.220.58])
	by d28dlp02.in.ibm.com (Postfix) with ESMTP id DACDF394006D
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 12:31:35 +0530 (IST)
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay01.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u4R71UV419988516
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 12:31:30 +0530
Received: from d28av03.in.ibm.com (localhost [127.0.0.1])
	by d28av03.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u4R71SCb021829
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 12:31:29 +0530
From: Feifei Xu <xufeifei@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: steve.capper@linaro.org, chandan@mykolab.com, jbacik@fb.com,
        dsterba@suse.com, feifeixu.sh@gmail.com,
        Feifei Xu <xufeifei@linux.vnet.ibm.com>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH 3/5] Btrfs: self-tests: Support non-4k page size
Date: Fri, 27 May 2016 15:00:36 +0800
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <201605270701.u4R6xXUw031405@mx0a-001b2d01.pphosted.com>

self-tests code assumes 4k as the sectorsize and nodesize. This commit
enables the self-tests code to be executed on non-4k page sized
systems (e.g. ppc64).

To test all possible sectorsizes, this commit adds a sectorsize
array. This commit executes the tests for all possible sectorsizes and
nodesizes.

Signed-off-by: Feifei Xu <xufeifei@linux.vnet.ibm.com>
Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/ctree.c                       |   6 +-
 fs/btrfs/disk-io.c                     |   9 +-
 fs/btrfs/disk-io.h                     |   3 +-
 fs/btrfs/extent_io.c                   |  10 +-
 fs/btrfs/extent_io.h                   |   4 +-
 fs/btrfs/free-space-cache.c            |   2 +-
 fs/btrfs/super.c                       |  62 ++++--
 fs/btrfs/tests/btrfs-tests.c           |   6 +-
 fs/btrfs/tests/btrfs-tests.h           |  27 +--
 fs/btrfs/tests/extent-buffer-tests.c   |  13 +-
 fs/btrfs/tests/extent-io-tests.c       |  85 ++++----
 fs/btrfs/tests/free-space-tests.c      |  67 +++---
 fs/btrfs/tests/free-space-tree-tests.c |  30 +--
 fs/btrfs/tests/inode-tests.c           | 379 ++++++++++++++++++---------------
 fs/btrfs/tests/qgroup-tests.c          | 111 ++++++----
 15 files changed, 462 insertions(+), 352 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index decd0a3..dcb9b8d 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1373,7 +1373,8 @@ tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 
 	if (tm->op == MOD_LOG_KEY_REMOVE_WHILE_FREEING) {
 		BUG_ON(tm->slot != 0);
-		eb_rewin = alloc_dummy_extent_buffer(fs_info, eb->start);
+		eb_rewin = alloc_dummy_extent_buffer(fs_info, eb->start,
+						eb->len);
 		if (!eb_rewin) {
 			btrfs_tree_read_unlock_blocking(eb);
 			free_extent_buffer(eb);
@@ -1454,7 +1455,8 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
 	} else if (old_root) {
 		btrfs_tree_read_unlock(eb_root);
 		free_extent_buffer(eb_root);
-		eb = alloc_dummy_extent_buffer(root->fs_info, logical);
+		eb = alloc_dummy_extent_buffer(root->fs_info, logical,
+					root->nodesize);
 	} else {
 		btrfs_set_lock_blocking_rw(eb_root, BTRFS_READ_LOCK);
 		eb = btrfs_clone_extent_buffer(eb_root);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 91d1239..9f85f1e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1147,7 +1147,8 @@ struct extent_buffer *btrfs_find_create_tree_block(struct btrfs_root *root,
 						 u64 bytenr)
 {
 	if (btrfs_test_is_dummy_root(root))
-		return alloc_test_extent_buffer(root->fs_info, bytenr);
+		return alloc_test_extent_buffer(root->fs_info, bytenr,
+				root->nodesize);
 	return alloc_extent_buffer(root->fs_info, bytenr);
 }
 
@@ -1314,14 +1315,16 @@ static struct btrfs_root *btrfs_alloc_root(struct btrfs_fs_info *fs_info,
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 /* Should only be used by the testing infrastructure */
-struct btrfs_root *btrfs_alloc_dummy_root(void)
+struct btrfs_root *
+btrfs_alloc_dummy_root(u32 sectorsize, u32 nodesize)
 {
 	struct btrfs_root *root;
 
 	root = btrfs_alloc_root(NULL, GFP_KERNEL);
 	if (!root)
 		return ERR_PTR(-ENOMEM);
-	__setup_root(4096, 4096, 4096, root, NULL, 1);
+	__setup_root(nodesize, sectorsize, sectorsize, root, NULL,
+		BTRFS_ROOT_TREE_OBJECTID);
 	set_bit(BTRFS_ROOT_DUMMY_ROOT, &root->state);
 	root->alloc_bytenr = 0;
 
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 8e79d00..2223361 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -90,7 +90,8 @@ void btrfs_drop_and_free_fs_root(struct btrfs_fs_info *fs_info,
 void btrfs_free_fs_root(struct btrfs_root *root);
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
-struct btrfs_root *btrfs_alloc_dummy_root(void);
+struct btrfs_root *
+btrfs_alloc_dummy_root(u32 sectorsize, u32 nodesize);
 #endif
 
 /*
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 2f83448..7ada3b8 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4714,16 +4714,16 @@ err:
 }
 
 struct extent_buffer *alloc_dummy_extent_buffer(struct btrfs_fs_info *fs_info,
-						u64 start)
+						u64 start, u32 alt_nodesize)
 {
 	unsigned long len;
 
 	if (!fs_info) {
 		/*
 		 * Called only from tests that don't always have a fs_info
-		 * available, but we know that nodesize is 4096
+		 * available
 		 */
-		len = 4096;
+		len = alt_nodesize;
 	} else {
 		len = fs_info->tree_root->nodesize;
 	}
@@ -4819,7 +4819,7 @@ struct extent_buffer *find_extent_buffer(struct btrfs_fs_info *fs_info,
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 struct extent_buffer *alloc_test_extent_buffer(struct btrfs_fs_info *fs_info,
-					       u64 start)
+					u64 start, u32 alt_nodesize)
 {
 	struct extent_buffer *eb, *exists = NULL;
 	int ret;
@@ -4827,7 +4827,7 @@ struct extent_buffer *alloc_test_extent_buffer(struct btrfs_fs_info *fs_info,
 	eb = find_extent_buffer(fs_info, start);
 	if (eb)
 		return eb;
-	eb = alloc_dummy_extent_buffer(fs_info, start);
+	eb = alloc_dummy_extent_buffer(fs_info, start, alt_nodesize);
 	if (!eb)
 		return NULL;
 	eb->fs_info = fs_info;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 981f402..bb0f01f 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -348,7 +348,7 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 struct extent_buffer *__alloc_dummy_extent_buffer(struct btrfs_fs_info *fs_info,
 						  u64 start, unsigned long len);
 struct extent_buffer *alloc_dummy_extent_buffer(struct btrfs_fs_info *fs_info,
-						u64 start);
+						u64 start, u32 nodesize);
 struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src);
 struct extent_buffer *find_extent_buffer(struct btrfs_fs_info *fs_info,
 					 u64 start);
@@ -468,5 +468,5 @@ noinline u64 find_lock_delalloc_range(struct inode *inode,
 				      u64 *end, u64 max_bytes);
 #endif
 struct extent_buffer *alloc_test_extent_buffer(struct btrfs_fs_info *fs_info,
-					       u64 start);
+					       u64 start, u32 nodesize);
 #endif
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 95ee9e8..410ce87 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1661,7 +1661,7 @@ static void recalculate_thresholds(struct btrfs_free_space_ctl *ctl)
 	 * sure we don't go over our overall goal of MAX_CACHE_BYTES_PER_GIG as
 	 * we add more bitmaps.
 	 */
-	bitmap_bytes = (ctl->total_bitmaps + 1) * PAGE_SIZE;
+	bitmap_bytes = (ctl->total_bitmaps + 1) * ctl->unit;
 
 	if (bitmap_bytes >= max_bytes) {
 		ctl->extents_thresh = 0;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index bf71071..c97c250 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2318,28 +2318,54 @@ static void btrfs_print_mod_info(void)
 
 static int btrfs_run_sanity_tests(void)
 {
-	int ret;
-
+	int ret, i;
+	u32 sectorsize, nodesize;
+	u32 test_sectorsize[] = {
+		PAGE_SIZE,
+	};
 	ret = btrfs_init_test_fs();
 	if (ret)
 		return ret;
+	for (i = 0; i < ARRAY_SIZE(test_sectorsize); i++) {
+		/* Validate sectorsize. */
+		sectorsize = test_sectorsize[i];
+		if (!is_power_of_2(sectorsize) || sectorsize < SZ_4K ||
+			sectorsize > PAGE_SIZE) {
+			continue;
+		}
 
-	ret = btrfs_test_free_space_cache();
-	if (ret)
-		goto out;
-	ret = btrfs_test_extent_buffer_operations();
-	if (ret)
-		goto out;
-	ret = btrfs_test_extent_io();
-	if (ret)
-		goto out;
-	ret = btrfs_test_inodes();
-	if (ret)
-		goto out;
-	ret = btrfs_test_qgroups();
-	if (ret)
-		goto out;
-	ret = btrfs_test_free_space_tree();
+		for (nodesize = sectorsize;
+		     nodesize <= BTRFS_MAX_METADATA_BLOCKSIZE;
+		     nodesize <<= 1) {
+			/* Validate nodesize.*/
+			if (!is_power_of_2(nodesize) || nodesize < sectorsize ||
+				nodesize > SZ_64K){
+				pr_info("Invalid nodesize %u\n", nodesize);
+				continue;
+			}
+			pr_info("Btrfs: Sanity tests sectorsize %u  nodesize %u\n",
+				sectorsize, nodesize);
+			ret = btrfs_test_free_space_cache(sectorsize, nodesize);
+			if (ret)
+				goto out;
+			ret = btrfs_test_extent_buffer_operations(sectorsize,
+				nodesize);
+			if (ret)
+				goto out;
+			ret = btrfs_test_extent_io(sectorsize, nodesize);
+			if (ret)
+				goto out;
+			ret = btrfs_test_inodes(sectorsize, nodesize);
+			if (ret)
+				goto out;
+			ret = btrfs_test_qgroups(sectorsize, nodesize);
+			if (ret)
+				goto out;
+			ret = btrfs_test_free_space_tree(sectorsize, nodesize);
+			if (ret)
+				goto out;
+		}
+	}
 out:
 	btrfs_destroy_test_fs();
 	return ret;
diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c
index f54bf45..10eb249 100644
--- a/fs/btrfs/tests/btrfs-tests.c
+++ b/fs/btrfs/tests/btrfs-tests.c
@@ -175,7 +175,7 @@ void btrfs_free_dummy_root(struct btrfs_root *root)
 }
 
 struct btrfs_block_group_cache *
-btrfs_alloc_dummy_block_group(unsigned long length)
+btrfs_alloc_dummy_block_group(unsigned long length, u32 sectorsize)
 {
 	struct btrfs_block_group_cache *cache;
 
@@ -192,8 +192,8 @@ btrfs_alloc_dummy_block_group(unsigned long length)
 	cache->key.objectid = 0;
 	cache->key.offset = length;
 	cache->key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
-	cache->sectorsize = 4096;
-	cache->full_stripe_len = 4096;
+	cache->sectorsize = sectorsize;
+	cache->full_stripe_len = sectorsize;
 
 	INIT_LIST_HEAD(&cache->list);
 	INIT_LIST_HEAD(&cache->cluster_list);
diff --git a/fs/btrfs/tests/btrfs-tests.h b/fs/btrfs/tests/btrfs-tests.h
index 054b8c7..66fb6b70 100644
--- a/fs/btrfs/tests/btrfs-tests.h
+++ b/fs/btrfs/tests/btrfs-tests.h
@@ -26,27 +26,28 @@
 struct btrfs_root;
 struct btrfs_trans_handle;
 
-int btrfs_test_free_space_cache(void);
-int btrfs_test_extent_buffer_operations(void);
-int btrfs_test_extent_io(void);
-int btrfs_test_inodes(void);
-int btrfs_test_qgroups(void);
-int btrfs_test_free_space_tree(void);
+int btrfs_test_free_space_cache(u32 sectorsize, u32 nodesize);
+int btrfs_test_extent_buffer_operations(u32 sectorsize, u32 nodesize);
+int btrfs_test_extent_io(u32 sectorsize, u32 nodesize);
+int btrfs_test_inodes(u32 sectorsize, u32 nodesize);
+int btrfs_test_qgroups(u32 sectorsize, u32 nodesize);
+int btrfs_test_free_space_tree(u32 sectorsize, u32 nodesize);
 int btrfs_init_test_fs(void);
 void btrfs_destroy_test_fs(void);
 struct inode *btrfs_new_test_inode(void);
 struct btrfs_fs_info *btrfs_alloc_dummy_fs_info(void);
 void btrfs_free_dummy_root(struct btrfs_root *root);
 struct btrfs_block_group_cache *
-btrfs_alloc_dummy_block_group(unsigned long length);
+btrfs_alloc_dummy_block_group(unsigned long length, u32 sectorsize);
 void btrfs_free_dummy_block_group(struct btrfs_block_group_cache *cache);
 void btrfs_init_dummy_trans(struct btrfs_trans_handle *trans);
 #else
-static inline int btrfs_test_free_space_cache(void)
+static inline int btrfs_test_free_space_cache(u32 sectorsize, u32 nodesize)
 {
 	return 0;
 }
-static inline int btrfs_test_extent_buffer_operations(void)
+static inline int btrfs_test_extent_buffer_operations(u32 sectorsize,
+	u32 nodesize)
 {
 	return 0;
 }
@@ -57,19 +58,19 @@ static inline int btrfs_init_test_fs(void)
 static inline void btrfs_destroy_test_fs(void)
 {
 }
-static inline int btrfs_test_extent_io(void)
+static inline int btrfs_test_extent_io(u32 sectorsize, u32 nodesize)
 {
 	return 0;
 }
-static inline int btrfs_test_inodes(void)
+static inline int btrfs_test_inodes(u32 sectorsize, u32 nodesize)
 {
 	return 0;
 }
-static inline int btrfs_test_qgroups(void)
+static inline int btrfs_test_qgroups(u32 sectorsize, u32 nodesize)
 {
 	return 0;
 }
-static inline int btrfs_test_free_space_tree(void)
+static inline int btrfs_test_free_space_tree(u32 sectorsize, u32 nodesize)
 {
 	return 0;
 }
diff --git a/fs/btrfs/tests/extent-buffer-tests.c b/fs/btrfs/tests/extent-buffer-tests.c
index f51963a..4f8cbd1 100644
--- a/fs/btrfs/tests/extent-buffer-tests.c
+++ b/fs/btrfs/tests/extent-buffer-tests.c
@@ -22,7 +22,7 @@
 #include "../extent_io.h"
 #include "../disk-io.h"
 
-static int test_btrfs_split_item(void)
+static int test_btrfs_split_item(u32 sectorsize, u32 nodesize)
 {
 	struct btrfs_path *path;
 	struct btrfs_root *root;
@@ -40,7 +40,7 @@ static int test_btrfs_split_item(void)
 
 	test_msg("Running btrfs_split_item tests\n");
 
-	root = btrfs_alloc_dummy_root();
+	root = btrfs_alloc_dummy_root(sectorsize, nodesize);
 	if (IS_ERR(root)) {
 		test_msg("Could not allocate root\n");
 		return PTR_ERR(root);
@@ -53,7 +53,8 @@ static int test_btrfs_split_item(void)
 		return -ENOMEM;
 	}
 
-	path->nodes[0] = eb = alloc_dummy_extent_buffer(NULL, 4096);
+	path->nodes[0] = eb = alloc_dummy_extent_buffer(NULL, nodesize,
+							nodesize);
 	if (!eb) {
 		test_msg("Could not allocate dummy buffer\n");
 		ret = -ENOMEM;
@@ -222,8 +223,8 @@ out:
 	return ret;
 }
 
-int btrfs_test_extent_buffer_operations(void)
+int btrfs_test_extent_buffer_operations(u32 sectorsize, u32 nodesize)
 {
-	test_msg("Running extent buffer operation tests");
-	return test_btrfs_split_item();
+	test_msg("Running extent buffer operation tests\n");
+	return test_btrfs_split_item(sectorsize, nodesize);
 }
diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index 70948b1..b06b13a 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -21,6 +21,7 @@
 #include <linux/slab.h>
 #include <linux/sizes.h>
 #include "btrfs-tests.h"
+#include "../ctree.h"
 #include "../extent_io.h"
 
 #define PROCESS_UNLOCK		(1 << 0)
@@ -65,7 +66,7 @@ static noinline int process_page_range(struct inode *inode, u64 start, u64 end,
 	return count;
 }
 
-static int test_find_delalloc(void)
+static int test_find_delalloc(u32 sectorsize)
 {
 	struct inode *inode;
 	struct extent_io_tree tmp;
@@ -113,7 +114,7 @@ static int test_find_delalloc(void)
 	 * |--- delalloc ---|
 	 * |---  search  ---|
 	 */
-	set_extent_delalloc(&tmp, 0, 4095, NULL, GFP_KERNEL);
+	set_extent_delalloc(&tmp, 0, sectorsize - 1, NULL, GFP_KERNEL);
 	start = 0;
 	end = 0;
 	found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
@@ -122,9 +123,9 @@ static int test_find_delalloc(void)
 		test_msg("Should have found at least one delalloc\n");
 		goto out_bits;
 	}
-	if (start != 0 || end != 4095) {
-		test_msg("Expected start 0 end 4095, got start %Lu end %Lu\n",
-			 start, end);
+	if (start != 0 || end != (sectorsize - 1)) {
+		test_msg("Expected start 0 end %u, got start %llu end %llu\n",
+			sectorsize - 1, start, end);
 		goto out_bits;
 	}
 	unlock_extent(&tmp, start, end);
@@ -144,7 +145,7 @@ static int test_find_delalloc(void)
 		test_msg("Couldn't find the locked page\n");
 		goto out_bits;
 	}
-	set_extent_delalloc(&tmp, 4096, max_bytes - 1, NULL, GFP_KERNEL);
+	set_extent_delalloc(&tmp, sectorsize, max_bytes - 1, NULL, GFP_KERNEL);
 	start = test_start;
 	end = 0;
 	found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
@@ -154,8 +155,9 @@ static int test_find_delalloc(void)
 		goto out_bits;
 	}
 	if (start != test_start || end != max_bytes - 1) {
-		test_msg("Expected start %Lu end %Lu, got start %Lu, end "
-			 "%Lu\n", test_start, max_bytes - 1, start, end);
+		test_msg("Expected start %llu end %llu, "
+			"got start %llu, end %llu\n",
+			test_start, max_bytes - 1, start, end);
 		goto out_bits;
 	}
 	if (process_page_range(inode, start, end,
@@ -172,7 +174,7 @@ static int test_find_delalloc(void)
 	 * |--- delalloc ---|
 	 *                    |--- search ---|
 	 */
-	test_start = max_bytes + 4096;
+	test_start = max_bytes + sectorsize;
 	locked_page = find_lock_page(inode->i_mapping, test_start >>
 				     PAGE_SHIFT);
 	if (!locked_page) {
@@ -209,8 +211,9 @@ static int test_find_delalloc(void)
 		goto out_bits;
 	}
 	if (start != test_start || end != total_dirty - 1) {
-		test_msg("Expected start %Lu end %Lu, got start %Lu end %Lu\n",
-			 test_start, total_dirty - 1, start, end);
+		test_msg("Expected start %llu end %llu "
+			"got start %llu end %llu\n",
+			test_start, total_dirty - 1, start, end);
 		goto out_bits;
 	}
 	if (process_page_range(inode, start, end,
@@ -250,9 +253,9 @@ static int test_find_delalloc(void)
 		goto out_bits;
 	}
 	if (start != test_start && end != test_start + PAGE_SIZE - 1) {
-		test_msg("Expected start %Lu end %Lu, got start %Lu end %Lu\n",
-			 test_start, test_start + PAGE_SIZE - 1, start,
-			 end);
+		test_msg("Expected start %llu end %llu, "
+			"got start %llu end %llu\n",
+			test_start, test_start + PAGE_SIZE - 1, start, end);
 		goto out_bits;
 	}
 	if (process_page_range(inode, start, end, PROCESS_TEST_LOCKED |
@@ -298,25 +301,28 @@ static int __test_eb_bitmaps(unsigned long *bitmap, struct extent_buffer *eb,
 		return -EINVAL;
 	}
 
-	bitmap_set(bitmap, (PAGE_SIZE - sizeof(long) / 2) * BITS_PER_BYTE,
-		   sizeof(long) * BITS_PER_BYTE);
-	extent_buffer_bitmap_set(eb, PAGE_SIZE - sizeof(long) / 2, 0,
-				 sizeof(long) * BITS_PER_BYTE);
-	if (memcmp_extent_buffer(eb, bitmap, 0, len) != 0) {
-		test_msg("Setting straddling pages failed\n");
-		return -EINVAL;
-	}
+	if (len > PAGE_SIZE) {
+		bitmap_set(bitmap,
+			(PAGE_SIZE - sizeof(long) / 2) * BITS_PER_BYTE,
+			sizeof(long) * BITS_PER_BYTE);
+		extent_buffer_bitmap_set(eb, PAGE_SIZE - sizeof(long) / 2, 0,
+					sizeof(long) * BITS_PER_BYTE);
+		if (memcmp_extent_buffer(eb, bitmap, 0, len) != 0) {
+			test_msg("Setting straddling pages failed\n");
+			return -EINVAL;
+		}
 
-	bitmap_set(bitmap, 0, len * BITS_PER_BYTE);
-	bitmap_clear(bitmap,
-		     (PAGE_SIZE - sizeof(long) / 2) * BITS_PER_BYTE,
-		     sizeof(long) * BITS_PER_BYTE);
-	extent_buffer_bitmap_set(eb, 0, 0, len * BITS_PER_BYTE);
-	extent_buffer_bitmap_clear(eb, PAGE_SIZE - sizeof(long) / 2, 0,
-				   sizeof(long) * BITS_PER_BYTE);
-	if (memcmp_extent_buffer(eb, bitmap, 0, len) != 0) {
-		test_msg("Clearing straddling pages failed\n");
-		return -EINVAL;
+		bitmap_set(bitmap, 0, len * BITS_PER_BYTE);
+		bitmap_clear(bitmap,
+			(PAGE_SIZE - sizeof(long) / 2) * BITS_PER_BYTE,
+			sizeof(long) * BITS_PER_BYTE);
+		extent_buffer_bitmap_set(eb, 0, 0, len * BITS_PER_BYTE);
+		extent_buffer_bitmap_clear(eb, PAGE_SIZE - sizeof(long) / 2, 0,
+					sizeof(long) * BITS_PER_BYTE);
+		if (memcmp_extent_buffer(eb, bitmap, 0, len) != 0) {
+			test_msg("Clearing straddling pages failed\n");
+			return -EINVAL;
+		}
 	}
 
 	/*
@@ -351,15 +357,18 @@ static int __test_eb_bitmaps(unsigned long *bitmap, struct extent_buffer *eb,
 	return 0;
 }
 
-static int test_eb_bitmaps(void)
+static int test_eb_bitmaps(u32 sectorsize, u32 nodesize)
 {
-	unsigned long len = PAGE_SIZE * 4;
+	unsigned long len;
 	unsigned long *bitmap;
 	struct extent_buffer *eb;
 	int ret;
 
 	test_msg("Running extent buffer bitmap tests\n");
 
+	len = (sectorsize < BTRFS_MAX_METADATA_BLOCKSIZE)
+		? sectorsize * 4 : sectorsize;
+
 	bitmap = kmalloc(len, GFP_KERNEL);
 	if (!bitmap) {
 		test_msg("Couldn't allocate test bitmap\n");
@@ -379,7 +388,7 @@ static int test_eb_bitmaps(void)
 
 	/* Do it over again with an extent buffer which isn't page-aligned. */
 	free_extent_buffer(eb);
-	eb = __alloc_dummy_extent_buffer(NULL, PAGE_SIZE / 2, len);
+	eb = __alloc_dummy_extent_buffer(NULL, nodesize / 2, len);
 	if (!eb) {
 		test_msg("Couldn't allocate test extent buffer\n");
 		kfree(bitmap);
@@ -393,17 +402,17 @@ out:
 	return ret;
 }
 
-int btrfs_test_extent_io(void)
+int btrfs_test_extent_io(u32 sectorsize, u32 nodesize)
 {
 	int ret;
 
 	test_msg("Running extent I/O tests\n");
 
-	ret = test_find_delalloc();
+	ret = test_find_delalloc(sectorsize);
 	if (ret)
 		goto out;
 
-	ret = test_eb_bitmaps();
+	ret = test_eb_bitmaps(sectorsize, nodesize);
 out:
 	test_msg("Extent I/O tests finished\n");
 	return ret;
diff --git a/fs/btrfs/tests/free-space-tests.c b/fs/btrfs/tests/free-space-tests.c
index f568630..6ec1bd0 100644
--- a/fs/btrfs/tests/free-space-tests.c
+++ b/fs/btrfs/tests/free-space-tests.c
@@ -99,7 +99,8 @@ static int test_extents(struct btrfs_block_group_cache *cache)
 	return 0;
 }
 
-static int test_bitmaps(struct btrfs_block_group_cache *cache)
+static int test_bitmaps(struct btrfs_block_group_cache *cache,
+			u32 sectorsize)
 {
 	u64 next_bitmap_offset;
 	int ret;
@@ -139,7 +140,7 @@ static int test_bitmaps(struct btrfs_block_group_cache *cache)
 	 * The first bitmap we have starts at offset 0 so the next one is just
 	 * at the end of the first bitmap.
 	 */
-	next_bitmap_offset = (u64)(BITS_PER_BITMAP * 4096);
+	next_bitmap_offset = (u64)(BITS_PER_BITMAP * sectorsize);
 
 	/* Test a bit straddling two bitmaps */
 	ret = test_add_free_space_entry(cache, next_bitmap_offset - SZ_2M,
@@ -167,9 +168,10 @@ static int test_bitmaps(struct btrfs_block_group_cache *cache)
 }
 
 /* This is the high grade jackassery */
-static int test_bitmaps_and_extents(struct btrfs_block_group_cache *cache)
+static int test_bitmaps_and_extents(struct btrfs_block_group_cache *cache,
+				    u32 sectorsize)
 {
-	u64 bitmap_offset = (u64)(BITS_PER_BITMAP * 4096);
+	u64 bitmap_offset = (u64)(BITS_PER_BITMAP * sectorsize);
 	int ret;
 
 	test_msg("Running bitmap and extent tests\n");
@@ -400,7 +402,8 @@ static int check_cache_empty(struct btrfs_block_group_cache *cache)
  * extent entries, both for clustered and non-clustered allocation requests.
  */
 static int
-test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache)
+test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache,
+				       u32 sectorsize)
 {
 	int ret;
 	u64 offset;
@@ -538,7 +541,7 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache)
 	 * The goal is to test that the bitmap entry space stealing doesn't
 	 * steal this space region.
 	 */
-	ret = btrfs_add_free_space(cache, SZ_128M + SZ_16M, 4096);
+	ret = btrfs_add_free_space(cache, SZ_128M + SZ_16M, sectorsize);
 	if (ret) {
 		test_msg("Error adding free space: %d\n", ret);
 		return ret;
@@ -596,8 +599,8 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache)
 		return -ENOENT;
 	}
 
-	if (cache->free_space_ctl->free_space != (SZ_1M + 4096)) {
-		test_msg("Cache free space is not 1Mb + 4Kb\n");
+	if (cache->free_space_ctl->free_space != (SZ_1M + sectorsize)) {
+		test_msg("Cache free space is not 1Mb + %u\n", sectorsize);
 		return -EINVAL;
 	}
 
@@ -610,22 +613,25 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache)
 		return -EINVAL;
 	}
 
-	/* All that remains is a 4Kb free space region in a bitmap. Confirm. */
+	/*
+	 * All that remains is a sectorsize free space region in a bitmap.
+	 * Confirm.
+	 */
 	ret = check_num_extents_and_bitmaps(cache, 1, 1);
 	if (ret)
 		return ret;
 
-	if (cache->free_space_ctl->free_space != 4096) {
-		test_msg("Cache free space is not 4Kb\n");
+	if (cache->free_space_ctl->free_space != sectorsize) {
+		test_msg("Cache free space is not %u\n", sectorsize);
 		return -EINVAL;
 	}
 
 	offset = btrfs_find_space_for_alloc(cache,
-					    0, 4096, 0,
+					    0, sectorsize, 0,
 					    &max_extent_size);
 	if (offset != (SZ_128M + SZ_16M)) {
-		test_msg("Failed to allocate 4Kb from space cache, returned offset is: %llu\n",
-			 offset);
+		test_msg("Failed to allocate %u, returned offset:%llu\n",
+			 sectorsize, offset);
 		return -EINVAL;
 	}
 
@@ -732,7 +738,7 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache)
 	 * The goal is to test that the bitmap entry space stealing doesn't
 	 * steal this space region.
 	 */
-	ret = btrfs_add_free_space(cache, SZ_32M, 8192);
+	ret = btrfs_add_free_space(cache, SZ_32M, 2 * sectorsize);
 	if (ret) {
 		test_msg("Error adding free space: %d\n", ret);
 		return ret;
@@ -756,7 +762,7 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache)
 
 	/*
 	 * Confirm that our extent entry didn't stole all free space from the
-	 * bitmap, because of the small 8Kb free space region.
+	 * bitmap, because of the small 2 * sectorsize free space region.
 	 */
 	ret = check_num_extents_and_bitmaps(cache, 2, 1);
 	if (ret)
@@ -782,8 +788,8 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache)
 		return -ENOENT;
 	}
 
-	if (cache->free_space_ctl->free_space != (SZ_1M + 8192)) {
-		test_msg("Cache free space is not 1Mb + 8Kb\n");
+	if (cache->free_space_ctl->free_space != (SZ_1M + 2 * sectorsize)) {
+		test_msg("Cache free space is not 1Mb + %u\n", 2*sectorsize);
 		return -EINVAL;
 	}
 
@@ -795,21 +801,24 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache)
 		return -EINVAL;
 	}
 
-	/* All that remains is a 8Kb free space region in a bitmap. Confirm. */
+	/*
+	 * All that remains is 2 * sectorsize free space region
+	 * in a bitmap. Confirm.
+	 */
 	ret = check_num_extents_and_bitmaps(cache, 1, 1);
 	if (ret)
 		return ret;
 
-	if (cache->free_space_ctl->free_space != 8192) {
-		test_msg("Cache free space is not 8Kb\n");
+	if (cache->free_space_ctl->free_space != 2 * sectorsize) {
+		test_msg("Cache free space is not %u\n", 2 * sectorsize);
 		return -EINVAL;
 	}
 
 	offset = btrfs_find_space_for_alloc(cache,
-					    0, 8192, 0,
+					    0, 2 * sectorsize, 0,
 					    &max_extent_size);
 	if (offset != SZ_32M) {
-		test_msg("Failed to allocate 8Kb from space cache, returned offset is: %llu\n",
+		test_msg("Failed to allocate %u, offset:%llu\n", 2 * sectorsize,
 			 offset);
 		return -EINVAL;
 	}
@@ -824,7 +833,7 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache)
 	return 0;
 }
 
-int btrfs_test_free_space_cache(void)
+int btrfs_test_free_space_cache(u32 sectorsize, u32 nodesize)
 {
 	struct btrfs_block_group_cache *cache;
 	struct btrfs_root *root = NULL;
@@ -832,13 +841,13 @@ int btrfs_test_free_space_cache(void)
 
 	test_msg("Running btrfs free space cache tests\n");
 
-	cache = btrfs_alloc_dummy_block_group(1024 * 1024 * 1024);
+	cache = btrfs_alloc_dummy_block_group(1024 * 1024 * 1024, sectorsize);
 	if (!cache) {
 		test_msg("Couldn't run the tests\n");
 		return 0;
 	}
 
-	root = btrfs_alloc_dummy_root();
+	root = btrfs_alloc_dummy_root(sectorsize, nodesize);
 	if (IS_ERR(root)) {
 		ret = PTR_ERR(root);
 		goto out;
@@ -854,14 +863,14 @@ int btrfs_test_free_space_cache(void)
 	ret = test_extents(cache);
 	if (ret)
 		goto out;
-	ret = test_bitmaps(cache);
+	ret = test_bitmaps(cache, sectorsize);
 	if (ret)
 		goto out;
-	ret = test_bitmaps_and_extents(cache);
+	ret = test_bitmaps_and_extents(cache, sectorsize);
 	if (ret)
 		goto out;
 
-	ret = test_steal_space_from_bitmap_to_extent(cache);
+	ret = test_steal_space_from_bitmap_to_extent(cache, sectorsize);
 out:
 	btrfs_free_dummy_block_group(cache);
 	btrfs_free_dummy_root(root);
diff --git a/fs/btrfs/tests/free-space-tree-tests.c b/fs/btrfs/tests/free-space-tree-tests.c
index 7cea446..aac5070 100644
--- a/fs/btrfs/tests/free-space-tree-tests.c
+++ b/fs/btrfs/tests/free-space-tree-tests.c
@@ -16,6 +16,7 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#include <linux/types.h>
 #include "btrfs-tests.h"
 #include "../ctree.h"
 #include "../disk-io.h"
@@ -30,7 +31,7 @@ struct free_space_extent {
  * The test cases align their operations to this in order to hit some of the
  * edge cases in the bitmap code.
  */
-#define BITMAP_RANGE (BTRFS_FREE_SPACE_BITMAP_BITS * 4096)
+#define BITMAP_RANGE (BTRFS_FREE_SPACE_BITMAP_BITS * PAGE_SIZE)
 
 static int __check_free_space_extents(struct btrfs_trans_handle *trans,
 				      struct btrfs_fs_info *fs_info,
@@ -439,7 +440,8 @@ typedef int (*test_func_t)(struct btrfs_trans_handle *,
 			   struct btrfs_block_group_cache *,
 			   struct btrfs_path *);
 
-static int run_test(test_func_t test_func, int bitmaps)
+static int run_test(test_func_t test_func, int bitmaps,
+		u32 sectorsize, u32 nodesize)
 {
 	struct btrfs_root *root = NULL;
 	struct btrfs_block_group_cache *cache = NULL;
@@ -447,7 +449,7 @@ static int run_test(test_func_t test_func, int bitmaps)
 	struct btrfs_path *path = NULL;
 	int ret;
 
-	root = btrfs_alloc_dummy_root();
+	root = btrfs_alloc_dummy_root(sectorsize, nodesize);
 	if (IS_ERR(root)) {
 		test_msg("Couldn't allocate dummy root\n");
 		ret = PTR_ERR(root);
@@ -466,7 +468,8 @@ static int run_test(test_func_t test_func, int bitmaps)
 	root->fs_info->free_space_root = root;
 	root->fs_info->tree_root = root;
 
-	root->node = alloc_test_extent_buffer(root->fs_info, 4096);
+	root->node = alloc_test_extent_buffer(root->fs_info,
+		nodesize, nodesize);
 	if (!root->node) {
 		test_msg("Couldn't allocate dummy buffer\n");
 		ret = -ENOMEM;
@@ -474,9 +477,9 @@ static int run_test(test_func_t test_func, int bitmaps)
 	}
 	btrfs_set_header_level(root->node, 0);
 	btrfs_set_header_nritems(root->node, 0);
-	root->alloc_bytenr += 8192;
+	root->alloc_bytenr += 2 * nodesize;
 
-	cache = btrfs_alloc_dummy_block_group(8 * BITMAP_RANGE);
+	cache = btrfs_alloc_dummy_block_group(8 * BITMAP_RANGE, sectorsize);
 	if (!cache) {
 		test_msg("Couldn't allocate dummy block group cache\n");
 		ret = -ENOMEM;
@@ -534,17 +537,18 @@ out:
 	return ret;
 }
 
-static int run_test_both_formats(test_func_t test_func)
+static int run_test_both_formats(test_func_t test_func,
+	u32 sectorsize, u32 nodesize)
 {
 	int ret;
 
-	ret = run_test(test_func, 0);
+	ret = run_test(test_func, 0, sectorsize, nodesize);
 	if (ret)
 		return ret;
-	return run_test(test_func, 1);
+	return run_test(test_func, 1, sectorsize, nodesize);
 }
 
-int btrfs_test_free_space_tree(void)
+int btrfs_test_free_space_tree(u32 sectorsize, u32 nodesize)
 {
 	test_func_t tests[] = {
 		test_empty_block_group,
@@ -561,9 +565,11 @@ int btrfs_test_free_space_tree(void)
 
 	test_msg("Running free space tree tests\n");
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
-		int ret = run_test_both_formats(tests[i]);
+		int ret = run_test_both_formats(tests[i], sectorsize,
+			nodesize);
 		if (ret) {
-			test_msg("%pf failed\n", tests[i]);
+			test_msg("%pf : sectorsize %u failed\n",
+				tests[i], sectorsize);
 			return ret;
 		}
 	}
diff --git a/fs/btrfs/tests/inode-tests.c b/fs/btrfs/tests/inode-tests.c
index 863a6a3..461b20c 100644
--- a/fs/btrfs/tests/inode-tests.c
+++ b/fs/btrfs/tests/inode-tests.c
@@ -16,6 +16,7 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#include <linux/types.h>
 #include "btrfs-tests.h"
 #include "../ctree.h"
 #include "../btrfs_inode.h"
@@ -86,19 +87,19 @@ static void insert_inode_item_key(struct btrfs_root *root)
  * diagram of how the extents will look though this may not be possible we still
  * want to make sure everything acts normally (the last number is not inclusive)
  *
- * [0 - 5][5 -  6][6 - 10][10 - 4096][  4096 - 8192 ][8192 - 12288]
- * [hole ][inline][ hole ][ regular ][regular1 split][    hole    ]
+ * [0 - 5][5 -  6][     6 - 4096     ][ 4096 - 4100][4100 - 8195][8195 - 12291]
+ * [hole ][inline][hole but no extent][  hole   ][   regular ][regular1 split]
  *
- * [ 12288 - 20480][20480 - 24576][  24576 - 28672  ][28672 - 36864][36864 - 45056]
- * [regular1 split][   prealloc1 ][prealloc1 written][   prealloc1 ][ compressed  ]
+ * [12291 - 16387][16387 - 24579][24579 - 28675][ 28675 - 32771][32771 - 36867 ]
+ * [    hole    ][regular1 split][   prealloc ][   prealloc1  ][prealloc1 written]
  *
- * [45056 - 49152][49152-53248][53248-61440][61440-65536][     65536+81920   ]
- * [ compressed1 ][  regular  ][compressed1][  regular  ][ hole but no extent]
+ * [36867 - 45059][45059 - 53251][53251 - 57347][57347 - 61443][61443- 69635]
+ * [  prealloc1  ][ compressed  ][ compressed1 ][    regular  ][ compressed1]
  *
- * [81920-86016]
- * [  regular  ]
+ * [69635-73731][   73731 - 86019   ][86019-90115]
+ * [  regular  ][ hole but no extent][  regular  ]
  */
-static void setup_file_extents(struct btrfs_root *root)
+static void setup_file_extents(struct btrfs_root *root, u32 sectorsize)
 {
 	int slot = 0;
 	u64 disk_bytenr = SZ_1M;
@@ -119,7 +120,7 @@ static void setup_file_extents(struct btrfs_root *root)
 	insert_extent(root, offset, 1, 1, 0, 0, 0, BTRFS_FILE_EXTENT_INLINE, 0,
 		      slot);
 	slot++;
-	offset = 4096;
+	offset = sectorsize;
 
 	/* Now another hole */
 	insert_extent(root, offset, 4, 4, 0, 0, 0, BTRFS_FILE_EXTENT_REG, 0,
@@ -128,99 +129,106 @@ static void setup_file_extents(struct btrfs_root *root)
 	offset += 4;
 
 	/* Now for a regular extent */
-	insert_extent(root, offset, 4095, 4095, 0, disk_bytenr, 4096,
-		      BTRFS_FILE_EXTENT_REG, 0, slot);
+	insert_extent(root, offset, sectorsize - 1, sectorsize - 1, 0,
+		      disk_bytenr, sectorsize, BTRFS_FILE_EXTENT_REG, 0, slot);
 	slot++;
-	disk_bytenr += 4096;
-	offset += 4095;
+	disk_bytenr += sectorsize;
+	offset += sectorsize - 1;
 
 	/*
 	 * Now for 3 extents that were split from a hole punch so we test
 	 * offsets properly.
 	 */
-	insert_extent(root, offset, 4096, 16384, 0, disk_bytenr, 16384,
-		      BTRFS_FILE_EXTENT_REG, 0, slot);
+	insert_extent(root, offset, sectorsize, 4 * sectorsize, 0, disk_bytenr,
+		      4 * sectorsize, BTRFS_FILE_EXTENT_REG, 0, slot);
 	slot++;
-	offset += 4096;
-	insert_extent(root, offset, 4096, 4096, 0, 0, 0, BTRFS_FILE_EXTENT_REG,
-		      0, slot);
+	offset += sectorsize;
+	insert_extent(root, offset, sectorsize, sectorsize, 0, 0, 0,
+		      BTRFS_FILE_EXTENT_REG, 0, slot);
 	slot++;
-	offset += 4096;
-	insert_extent(root, offset, 8192, 16384, 8192, disk_bytenr, 16384,
+	offset += sectorsize;
+	insert_extent(root, offset, 2 * sectorsize, 4 * sectorsize,
+		      2 * sectorsize, disk_bytenr, 4 * sectorsize,
 		      BTRFS_FILE_EXTENT_REG, 0, slot);
 	slot++;
-	offset += 8192;
-	disk_bytenr += 16384;
+	offset += 2 * sectorsize;
+	disk_bytenr += 4 * sectorsize;
 
 	/* Now for a unwritten prealloc extent */
-	insert_extent(root, offset, 4096, 4096, 0, disk_bytenr, 4096,
-		      BTRFS_FILE_EXTENT_PREALLOC, 0, slot);
+	insert_extent(root, offset, sectorsize, sectorsize, 0, disk_bytenr,
+		sectorsize, BTRFS_FILE_EXTENT_PREALLOC, 0, slot);
 	slot++;
-	offset += 4096;
+	offset += sectorsize;
 
 	/*
 	 * We want to jack up disk_bytenr a little more so the em stuff doesn't
 	 * merge our records.
 	 */
-	disk_bytenr += 8192;
+	disk_bytenr += 2 * sectorsize;
 
 	/*
 	 * Now for a partially written prealloc extent, basically the same as
 	 * the hole punch example above.  Ram_bytes never changes when you mark
 	 * extents written btw.
 	 */
-	insert_extent(root, offset, 4096, 16384, 0, disk_bytenr, 16384,
-		      BTRFS_FILE_EXTENT_PREALLOC, 0, slot);
+	insert_extent(root, offset, sectorsize, 4 * sectorsize, 0, disk_bytenr,
+		      4 * sectorsize, BTRFS_FILE_EXTENT_PREALLOC, 0, slot);
 	slot++;
-	offset += 4096;
-	insert_extent(root, offset, 4096, 16384, 4096, disk_bytenr, 16384,
-		      BTRFS_FILE_EXTENT_REG, 0, slot);
+	offset += sectorsize;
+	insert_extent(root, offset, sectorsize, 4 * sectorsize, sectorsize,
+		      disk_bytenr, 4 * sectorsize, BTRFS_FILE_EXTENT_REG, 0,
+		      slot);
 	slot++;
-	offset += 4096;
-	insert_extent(root, offset, 8192, 16384, 8192, disk_bytenr, 16384,
+	offset += sectorsize;
+	insert_extent(root, offset, 2 * sectorsize, 4 * sectorsize,
+		      2 * sectorsize, disk_bytenr, 4 * sectorsize,
 		      BTRFS_FILE_EXTENT_PREALLOC, 0, slot);
 	slot++;
-	offset += 8192;
-	disk_bytenr += 16384;
+	offset += 2 * sectorsize;
+	disk_bytenr += 4 * sectorsize;
 
 	/* Now a normal compressed extent */
-	insert_extent(root, offset, 8192, 8192, 0, disk_bytenr, 4096,
-		      BTRFS_FILE_EXTENT_REG, BTRFS_COMPRESS_ZLIB, slot);
+	insert_extent(root, offset, 2 * sectorsize, 2 * sectorsize, 0,
+		      disk_bytenr, sectorsize, BTRFS_FILE_EXTENT_REG,
+		      BTRFS_COMPRESS_ZLIB, slot);
 	slot++;
-	offset += 8192;
+	offset += 2 * sectorsize;
 	/* No merges */
-	disk_bytenr += 8192;
+	disk_bytenr += 2 * sectorsize;
 
 	/* Now a split compressed extent */
-	insert_extent(root, offset, 4096, 16384, 0, disk_bytenr, 4096,
-		      BTRFS_FILE_EXTENT_REG, BTRFS_COMPRESS_ZLIB, slot);
+	insert_extent(root, offset, sectorsize, 4 * sectorsize, 0, disk_bytenr,
+		      sectorsize, BTRFS_FILE_EXTENT_REG,
+		      BTRFS_COMPRESS_ZLIB, slot);
 	slot++;
-	offset += 4096;
-	insert_extent(root, offset, 4096, 4096, 0, disk_bytenr + 4096, 4096,
+	offset += sectorsize;
+	insert_extent(root, offset, sectorsize, sectorsize, 0,
+		      disk_bytenr + sectorsize, sectorsize,
 		      BTRFS_FILE_EXTENT_REG, 0, slot);
 	slot++;
-	offset += 4096;
-	insert_extent(root, offset, 8192, 16384, 8192, disk_bytenr, 4096,
+	offset += sectorsize;
+	insert_extent(root, offset, 2 * sectorsize, 4 * sectorsize,
+		      2 * sectorsize, disk_bytenr, sectorsize,
 		      BTRFS_FILE_EXTENT_REG, BTRFS_COMPRESS_ZLIB, slot);
 	slot++;
-	offset += 8192;
-	disk_bytenr += 8192;
+	offset += 2 * sectorsize;
+	disk_bytenr += 2 * sectorsize;
 
 	/* Now extents that have a hole but no hole extent */
-	insert_extent(root, offset, 4096, 4096, 0, disk_bytenr, 4096,
-		      BTRFS_FILE_EXTENT_REG, 0, slot);
+	insert_extent(root, offset, sectorsize, sectorsize, 0, disk_bytenr,
+		      sectorsize, BTRFS_FILE_EXTENT_REG, 0, slot);
 	slot++;
-	offset += 16384;
-	disk_bytenr += 4096;
-	insert_extent(root, offset, 4096, 4096, 0, disk_bytenr, 4096,
-		      BTRFS_FILE_EXTENT_REG, 0, slot);
+	offset += 4 * sectorsize;
+	disk_bytenr += sectorsize;
+	insert_extent(root, offset, sectorsize, sectorsize, 0, disk_bytenr,
+		      sectorsize, BTRFS_FILE_EXTENT_REG, 0, slot);
 }
 
 static unsigned long prealloc_only = 0;
 static unsigned long compressed_only = 0;
 static unsigned long vacancy_only = 0;
 
-static noinline int test_btrfs_get_extent(void)
+static noinline int test_btrfs_get_extent(u32 sectorsize, u32 nodesize)
 {
 	struct inode *inode = NULL;
 	struct btrfs_root *root = NULL;
@@ -240,7 +248,7 @@ static noinline int test_btrfs_get_extent(void)
 	BTRFS_I(inode)->location.objectid = BTRFS_FIRST_FREE_OBJECTID;
 	BTRFS_I(inode)->location.offset = 0;
 
-	root = btrfs_alloc_dummy_root();
+	root = btrfs_alloc_dummy_root(sectorsize, nodesize);
 	if (IS_ERR(root)) {
 		test_msg("Couldn't allocate root\n");
 		goto out;
@@ -256,7 +264,7 @@ static noinline int test_btrfs_get_extent(void)
 		goto out;
 	}
 
-	root->node = alloc_dummy_extent_buffer(NULL, 4096);
+	root->node = alloc_dummy_extent_buffer(NULL, nodesize, nodesize);
 	if (!root->node) {
 		test_msg("Couldn't allocate dummy buffer\n");
 		goto out;
@@ -273,7 +281,7 @@ static noinline int test_btrfs_get_extent(void)
 
 	/* First with no extents */
 	BTRFS_I(inode)->root = root;
-	em = btrfs_get_extent(inode, NULL, 0, 0, 4096, 0);
+	em = btrfs_get_extent(inode, NULL, 0, 0, sectorsize, 0);
 	if (IS_ERR(em)) {
 		em = NULL;
 		test_msg("Got an error when we shouldn't have\n");
@@ -295,7 +303,7 @@ static noinline int test_btrfs_get_extent(void)
 	 * setup_file_extents, so if you change anything there you need to
 	 * update the comment and update the expected values below.
 	 */
-	setup_file_extents(root);
+	setup_file_extents(root, sectorsize);
 
 	em = btrfs_get_extent(inode, NULL, 0, 0, (u64)-1, 0);
 	if (IS_ERR(em)) {
@@ -307,8 +315,8 @@ static noinline int test_btrfs_get_extent(void)
 		goto out;
 	}
 	if (em->start != 0 || em->len != 5) {
-		test_msg("Unexpected extent wanted start 0 len 5, got start "
-			 "%llu len %llu\n", em->start, em->len);
+		test_msg("Unexpected extent wanted start 0 len 5, "
+			"got start %llu len %llu\n", em->start, em->len);
 		goto out;
 	}
 	if (em->flags != 0) {
@@ -318,7 +326,7 @@ static noinline int test_btrfs_get_extent(void)
 	offset = em->start + em->len;
 	free_extent_map(em);
 
-	em = btrfs_get_extent(inode, NULL, 0, offset, 4096, 0);
+	em = btrfs_get_extent(inode, NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
 		test_msg("Got an error when we shouldn't have\n");
 		goto out;
@@ -327,9 +335,11 @@ static noinline int test_btrfs_get_extent(void)
 		test_msg("Expected an inline, got %llu\n", em->block_start);
 		goto out;
 	}
-	if (em->start != offset || em->len != 4091) {
-		test_msg("Unexpected extent wanted start %llu len 1, got start "
-			 "%llu len %llu\n", offset, em->start, em->len);
+
+	if (em->start != offset || em->len != (sectorsize - 5)) {
+		test_msg("Unexpected extent wanted start %llu len 1, "
+			"got start %llu len %llu\n",
+			offset, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != 0) {
@@ -344,7 +354,7 @@ static noinline int test_btrfs_get_extent(void)
 	offset = em->start + em->len;
 	free_extent_map(em);
 
-	em = btrfs_get_extent(inode, NULL, 0, offset, 4096, 0);
+	em = btrfs_get_extent(inode, NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
 		test_msg("Got an error when we shouldn't have\n");
 		goto out;
@@ -354,8 +364,9 @@ static noinline int test_btrfs_get_extent(void)
 		goto out;
 	}
 	if (em->start != offset || em->len != 4) {
-		test_msg("Unexpected extent wanted start %llu len 4, got start "
-			 "%llu len %llu\n", offset, em->start, em->len);
+		test_msg("Unexpected extent wanted start %llu len 4, "
+			"got start %llu len %llu\n",
+			offset, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != 0) {
@@ -366,7 +377,7 @@ static noinline int test_btrfs_get_extent(void)
 	free_extent_map(em);
 
 	/* Regular extent */
-	em = btrfs_get_extent(inode, NULL, 0, offset, 4096, 0);
+	em = btrfs_get_extent(inode, NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
 		test_msg("Got an error when we shouldn't have\n");
 		goto out;
@@ -375,9 +386,10 @@ static noinline int test_btrfs_get_extent(void)
 		test_msg("Expected a real extent, got %llu\n", em->block_start);
 		goto out;
 	}
-	if (em->start != offset || em->len != 4095) {
-		test_msg("Unexpected extent wanted start %llu len 4095, got "
-			 "start %llu len %llu\n", offset, em->start, em->len);
+	if (em->start != offset || em->len != sectorsize - 1) {
+		test_msg("Unexpected extent wanted start %llu len 4095, "
+			"got start %llu len %llu\n",
+			offset, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != 0) {
@@ -385,15 +397,15 @@ static noinline int test_btrfs_get_extent(void)
 		goto out;
 	}
 	if (em->orig_start != em->start) {
-		test_msg("Wrong orig offset, want %llu, have %llu\n", em->start,
-			 em->orig_start);
+		test_msg("Wrong orig offset, want %llu, have %llu\n",
+			em->start, em->orig_start);
 		goto out;
 	}
 	offset = em->start + em->len;
 	free_extent_map(em);
 
 	/* The next 3 are split extents */
-	em = btrfs_get_extent(inode, NULL, 0, offset, 4096, 0);
+	em = btrfs_get_extent(inode, NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
 		test_msg("Got an error when we shouldn't have\n");
 		goto out;
@@ -402,9 +414,10 @@ static noinline int test_btrfs_get_extent(void)
 		test_msg("Expected a real extent, got %llu\n", em->block_start);
 		goto out;
 	}
-	if (em->start != offset || em->len != 4096) {
-		test_msg("Unexpected extent wanted start %llu len 4096, got "
-			 "start %llu len %llu\n", offset, em->start, em->len);
+	if (em->start != offset || em->len != sectorsize) {
+		test_msg("Unexpected extent start %llu len %u, "
+			"got start %llu len %llu\n",
+			offset, sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != 0) {
@@ -421,7 +434,7 @@ static noinline int test_btrfs_get_extent(void)
 	offset = em->start + em->len;
 	free_extent_map(em);
 
-	em = btrfs_get_extent(inode, NULL, 0, offset, 4096, 0);
+	em = btrfs_get_extent(inode, NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
 		test_msg("Got an error when we shouldn't have\n");
 		goto out;
@@ -430,9 +443,10 @@ static noinline int test_btrfs_get_extent(void)
 		test_msg("Expected a hole, got %llu\n", em->block_start);
 		goto out;
 	}
-	if (em->start != offset || em->len != 4096) {
-		test_msg("Unexpected extent wanted start %llu len 4096, got "
-			 "start %llu len %llu\n", offset, em->start, em->len);
+	if (em->start != offset || em->len != sectorsize) {
+		test_msg("Unexpected extent wanted start %llu len %u, "
+			"got start %llu len %llu\n",
+			offset, sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != 0) {
@@ -442,7 +456,7 @@ static noinline int test_btrfs_get_extent(void)
 	offset = em->start + em->len;
 	free_extent_map(em);
 
-	em = btrfs_get_extent(inode, NULL, 0, offset, 4096, 0);
+	em = btrfs_get_extent(inode, NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
 		test_msg("Got an error when we shouldn't have\n");
 		goto out;
@@ -451,9 +465,10 @@ static noinline int test_btrfs_get_extent(void)
 		test_msg("Expected a real extent, got %llu\n", em->block_start);
 		goto out;
 	}
-	if (em->start != offset || em->len != 8192) {
-		test_msg("Unexpected extent wanted start %llu len 8192, got "
-			 "start %llu len %llu\n", offset, em->start, em->len);
+	if (em->start != offset || em->len != 2 * sectorsize) {
+		test_msg("Unexpected extent wanted start %llu len %u, "
+			"got start %llu len %llu\n",
+			offset, 2 * sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != 0) {
@@ -475,7 +490,7 @@ static noinline int test_btrfs_get_extent(void)
 	free_extent_map(em);
 
 	/* Prealloc extent */
-	em = btrfs_get_extent(inode, NULL, 0, offset, 4096, 0);
+	em = btrfs_get_extent(inode, NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
 		test_msg("Got an error when we shouldn't have\n");
 		goto out;
@@ -484,9 +499,10 @@ static noinline int test_btrfs_get_extent(void)
 		test_msg("Expected a real extent, got %llu\n", em->block_start);
 		goto out;
 	}
-	if (em->start != offset || em->len != 4096) {
-		test_msg("Unexpected extent wanted start %llu len 4096, got "
-			 "start %llu len %llu\n", offset, em->start, em->len);
+	if (em->start != offset || em->len != sectorsize) {
+		test_msg("Unexpected extent wanted start %llu len %u, "
+			"got start %llu len %llu\n",
+			offset, sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != prealloc_only) {
@@ -503,7 +519,7 @@ static noinline int test_btrfs_get_extent(void)
 	free_extent_map(em);
 
 	/* The next 3 are a half written prealloc extent */
-	em = btrfs_get_extent(inode, NULL, 0, offset, 4096, 0);
+	em = btrfs_get_extent(inode, NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
 		test_msg("Got an error when we shouldn't have\n");
 		goto out;
@@ -512,9 +528,10 @@ static noinline int test_btrfs_get_extent(void)
 		test_msg("Expected a real extent, got %llu\n", em->block_start);
 		goto out;
 	}
-	if (em->start != offset || em->len != 4096) {
-		test_msg("Unexpected extent wanted start %llu len 4096, got "
-			 "start %llu len %llu\n", offset, em->start, em->len);
+	if (em->start != offset || em->len != sectorsize) {
+		test_msg("Unexpected extent wanted start %llu, len %u, "
+			"got start %llu len %llu\n",
+			offset, sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != prealloc_only) {
@@ -523,8 +540,8 @@ static noinline int test_btrfs_get_extent(void)
 		goto out;
 	}
 	if (em->orig_start != em->start) {
-		test_msg("Wrong orig offset, want %llu, have %llu\n", em->start,
-			 em->orig_start);
+		test_msg("Wrong orig offset, want %llu, have %llu\n",
+			em->start, em->orig_start);
 		goto out;
 	}
 	disk_bytenr = em->block_start;
@@ -532,7 +549,7 @@ static noinline int test_btrfs_get_extent(void)
 	offset = em->start + em->len;
 	free_extent_map(em);
 
-	em = btrfs_get_extent(inode, NULL, 0, offset, 4096, 0);
+	em = btrfs_get_extent(inode, NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
 		test_msg("Got an error when we shouldn't have\n");
 		goto out;
@@ -541,9 +558,10 @@ static noinline int test_btrfs_get_extent(void)
 		test_msg("Expected a real extent, got %llu\n", em->block_start);
 		goto out;
 	}
-	if (em->start != offset || em->len != 4096) {
-		test_msg("Unexpected extent wanted start %llu len 4096, got "
-			 "start %llu len %llu\n", offset, em->start, em->len);
+	if (em->start != offset || em->len != sectorsize) {
+		test_msg("Unexpected extent wanted start %llu, len %u, "
+			"got start %llu len %llu\n",
+			offset, sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != 0) {
@@ -564,7 +582,7 @@ static noinline int test_btrfs_get_extent(void)
 	offset = em->start + em->len;
 	free_extent_map(em);
 
-	em = btrfs_get_extent(inode, NULL, 0, offset, 4096, 0);
+	em = btrfs_get_extent(inode, NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
 		test_msg("Got an error when we shouldn't have\n");
 		goto out;
@@ -573,13 +591,14 @@ static noinline int test_btrfs_get_extent(void)
 		test_msg("Expected a real extent, got %llu\n", em->block_start);
 		goto out;
 	}
-	if (em->start != offset || em->len != 8192) {
-		test_msg("Unexpected extent wanted start %llu len 8192, got "
-			 "start %llu len %llu\n", offset, em->start, em->len);
+	if (em->start != offset || em->len != 2 * sectorsize) {
+		test_msg("Unexpected extent wanted start %llu, len %u, "
+			"got start %llu len %llu\n",
+			offset, 2 * sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != prealloc_only) {
-		test_msg("Unexpected flags set, want %lu have %lu\n",
+		test_msg("Unexpected flags set, want %lu, have %lu\n",
 			 prealloc_only, em->flags);
 		goto out;
 	}
@@ -598,7 +617,7 @@ static noinline int test_btrfs_get_extent(void)
 	free_extent_map(em);
 
 	/* Now for the compressed extent */
-	em = btrfs_get_extent(inode, NULL, 0, offset, 4096, 0);
+	em = btrfs_get_extent(inode, NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
 		test_msg("Got an error when we shouldn't have\n");
 		goto out;
@@ -607,13 +626,14 @@ static noinline int test_btrfs_get_extent(void)
 		test_msg("Expected a real extent, got %llu\n", em->block_start);
 		goto out;
 	}
-	if (em->start != offset || em->len != 8192) {
-		test_msg("Unexpected extent wanted start %llu len 8192, got "
-			 "start %llu len %llu\n", offset, em->start, em->len);
+	if (em->start != offset || em->len != 2 * sectorsize) {
+		test_msg("Unexpected extent wanted start %llu, len %u,"
+			"got start %llu len %llu\n",
+			offset, 2 * sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != compressed_only) {
-		test_msg("Unexpected flags set, want %lu have %lu\n",
+		test_msg("Unexpected flags set, want %lu, have %lu\n",
 			 compressed_only, em->flags);
 		goto out;
 	}
@@ -631,7 +651,7 @@ static noinline int test_btrfs_get_extent(void)
 	free_extent_map(em);
 
 	/* Split compressed extent */
-	em = btrfs_get_extent(inode, NULL, 0, offset, 4096, 0);
+	em = btrfs_get_extent(inode, NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
 		test_msg("Got an error when we shouldn't have\n");
 		goto out;
@@ -640,9 +660,10 @@ static noinline int test_btrfs_get_extent(void)
 		test_msg("Expected a real extent, got %llu\n", em->block_start);
 		goto out;
 	}
-	if (em->start != offset || em->len != 4096) {
-		test_msg("Unexpected extent wanted start %llu len 4096, got "
-			 "start %llu len %llu\n", offset, em->start, em->len);
+	if (em->start != offset || em->len != sectorsize) {
+		test_msg("Unexpected extent wanted start %llu len %u,"
+			"got start %llu len %llu\n",
+			offset, sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != compressed_only) {
@@ -665,7 +686,7 @@ static noinline int test_btrfs_get_extent(void)
 	offset = em->start + em->len;
 	free_extent_map(em);
 
-	em = btrfs_get_extent(inode, NULL, 0, offset, 4096, 0);
+	em = btrfs_get_extent(inode, NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
 		test_msg("Got an error when we shouldn't have\n");
 		goto out;
@@ -674,9 +695,10 @@ static noinline int test_btrfs_get_extent(void)
 		test_msg("Expected a real extent, got %llu\n", em->block_start);
 		goto out;
 	}
-	if (em->start != offset || em->len != 4096) {
-		test_msg("Unexpected extent wanted start %llu len 4096, got "
-			 "start %llu len %llu\n", offset, em->start, em->len);
+	if (em->start != offset || em->len != sectorsize) {
+		test_msg("Unexpected extent wanted start %llu len %u, "
+			"got start %llu len %llu\n",
+			offset, sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != 0) {
@@ -691,7 +713,7 @@ static noinline int test_btrfs_get_extent(void)
 	offset = em->start + em->len;
 	free_extent_map(em);
 
-	em = btrfs_get_extent(inode, NULL, 0, offset, 4096, 0);
+	em = btrfs_get_extent(inode, NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
 		test_msg("Got an error when we shouldn't have\n");
 		goto out;
@@ -701,9 +723,10 @@ static noinline int test_btrfs_get_extent(void)
 			 disk_bytenr, em->block_start);
 		goto out;
 	}
-	if (em->start != offset || em->len != 8192) {
-		test_msg("Unexpected extent wanted start %llu len 8192, got "
-			 "start %llu len %llu\n", offset, em->start, em->len);
+	if (em->start != offset || em->len != 2 * sectorsize) {
+		test_msg("Unexpected extent wanted start %llu len %u, "
+			"got start %llu len %llu\n",
+			offset, 2 * sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != compressed_only) {
@@ -725,7 +748,7 @@ static noinline int test_btrfs_get_extent(void)
 	free_extent_map(em);
 
 	/* A hole between regular extents but no hole extent */
-	em = btrfs_get_extent(inode, NULL, 0, offset + 6, 4096, 0);
+	em = btrfs_get_extent(inode, NULL, 0, offset + 6, sectorsize, 0);
 	if (IS_ERR(em)) {
 		test_msg("Got an error when we shouldn't have\n");
 		goto out;
@@ -734,9 +757,10 @@ static noinline int test_btrfs_get_extent(void)
 		test_msg("Expected a real extent, got %llu\n", em->block_start);
 		goto out;
 	}
-	if (em->start != offset || em->len != 4096) {
-		test_msg("Unexpected extent wanted start %llu len 4096, got "
-			 "start %llu len %llu\n", offset, em->start, em->len);
+	if (em->start != offset || em->len != sectorsize) {
+		test_msg("Unexpected extent wanted start %llu len %u, "
+			"got start %llu len %llu\n",
+			offset, sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != 0) {
@@ -765,9 +789,10 @@ static noinline int test_btrfs_get_extent(void)
 	 * length of the actual hole, if this changes we'll have to change this
 	 * test.
 	 */
-	if (em->start != offset || em->len != 12288) {
-		test_msg("Unexpected extent wanted start %llu len 12288, got "
-			 "start %llu len %llu\n", offset, em->start, em->len);
+	if (em->start != offset || em->len != 3 * sectorsize) {
+		test_msg("Unexpected extent wanted start %llu len %u, "
+			"got start %llu len %llu\n",
+			offset, 3 * sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != vacancy_only) {
@@ -776,14 +801,14 @@ static noinline int test_btrfs_get_extent(void)
 		goto out;
 	}
 	if (em->orig_start != em->start) {
-		test_msg("Wrong orig offset, want %llu, have %llu\n", em->start,
-			 em->orig_start);
+		test_msg("Wrong orig offset, want %llu, have %llu\n",
+			em->start, em->orig_start);
 		goto out;
 	}
 	offset = em->start + em->len;
 	free_extent_map(em);
 
-	em = btrfs_get_extent(inode, NULL, 0, offset, 4096, 0);
+	em = btrfs_get_extent(inode, NULL, 0, offset, sectorsize, 0);
 	if (IS_ERR(em)) {
 		test_msg("Got an error when we shouldn't have\n");
 		goto out;
@@ -792,9 +817,10 @@ static noinline int test_btrfs_get_extent(void)
 		test_msg("Expected a real extent, got %llu\n", em->block_start);
 		goto out;
 	}
-	if (em->start != offset || em->len != 4096) {
-		test_msg("Unexpected extent wanted start %llu len 4096, got "
-			 "start %llu len %llu\n", offset, em->start, em->len);
+	if (em->start != offset || em->len != sectorsize) {
+		test_msg("Unexpected extent wanted start %llu len %u,"
+			"got start %llu len %llu\n",
+			offset, sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != 0) {
@@ -815,7 +841,7 @@ out:
 	return ret;
 }
 
-static int test_hole_first(void)
+static int test_hole_first(u32 sectorsize, u32 nodesize)
 {
 	struct inode *inode = NULL;
 	struct btrfs_root *root = NULL;
@@ -832,7 +858,7 @@ static int test_hole_first(void)
 	BTRFS_I(inode)->location.objectid = BTRFS_FIRST_FREE_OBJECTID;
 	BTRFS_I(inode)->location.offset = 0;
 
-	root = btrfs_alloc_dummy_root();
+	root = btrfs_alloc_dummy_root(sectorsize, nodesize);
 	if (IS_ERR(root)) {
 		test_msg("Couldn't allocate root\n");
 		goto out;
@@ -844,7 +870,7 @@ static int test_hole_first(void)
 		goto out;
 	}
 
-	root->node = alloc_dummy_extent_buffer(NULL, 4096);
+	root->node = alloc_dummy_extent_buffer(NULL, nodesize, nodesize);
 	if (!root->node) {
 		test_msg("Couldn't allocate dummy buffer\n");
 		goto out;
@@ -861,9 +887,9 @@ static int test_hole_first(void)
 	 * btrfs_get_extent.
 	 */
 	insert_inode_item_key(root);
-	insert_extent(root, 4096, 4096, 4096, 0, 4096, 4096,
-		      BTRFS_FILE_EXTENT_REG, 0, 1);
-	em = btrfs_get_extent(inode, NULL, 0, 0, 8192, 0);
+	insert_extent(root, sectorsize, sectorsize, sectorsize, 0, sectorsize,
+		      sectorsize, BTRFS_FILE_EXTENT_REG, 0, 1);
+	em = btrfs_get_extent(inode, NULL, 0, 0, 2 * sectorsize, 0);
 	if (IS_ERR(em)) {
 		test_msg("Got an error when we shouldn't have\n");
 		goto out;
@@ -872,9 +898,10 @@ static int test_hole_first(void)
 		test_msg("Expected a hole, got %llu\n", em->block_start);
 		goto out;
 	}
-	if (em->start != 0 || em->len != 4096) {
-		test_msg("Unexpected extent wanted start 0 len 4096, got start "
-			 "%llu len %llu\n", em->start, em->len);
+	if (em->start != 0 || em->len != sectorsize) {
+		test_msg("Unexpected extent wanted start 0 len %u, "
+			"got start %llu len %llu\n",
+			sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != vacancy_only) {
@@ -884,18 +911,19 @@ static int test_hole_first(void)
 	}
 	free_extent_map(em);
 
-	em = btrfs_get_extent(inode, NULL, 0, 4096, 8192, 0);
+	em = btrfs_get_extent(inode, NULL, 0, sectorsize, 2 * sectorsize, 0);
 	if (IS_ERR(em)) {
 		test_msg("Got an error when we shouldn't have\n");
 		goto out;
 	}
-	if (em->block_start != 4096) {
+	if (em->block_start != sectorsize) {
 		test_msg("Expected a real extent, got %llu\n", em->block_start);
 		goto out;
 	}
-	if (em->start != 4096 || em->len != 4096) {
-		test_msg("Unexpected extent wanted start 4096 len 4096, got "
-			 "start %llu len %llu\n", em->start, em->len);
+	if (em->start != sectorsize || em->len != sectorsize) {
+		test_msg("Unexpected extent wanted start %u len %u, "
+			"got start %llu len %llu\n",
+			sectorsize, sectorsize, em->start, em->len);
 		goto out;
 	}
 	if (em->flags != 0) {
@@ -912,7 +940,7 @@ out:
 	return ret;
 }
 
-static int test_extent_accounting(void)
+static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 {
 	struct inode *inode = NULL;
 	struct btrfs_root *root = NULL;
@@ -924,7 +952,7 @@ static int test_extent_accounting(void)
 		return ret;
 	}
 
-	root = btrfs_alloc_dummy_root();
+	root = btrfs_alloc_dummy_root(sectorsize, nodesize);
 	if (IS_ERR(root)) {
 		test_msg("Couldn't allocate root\n");
 		goto out;
@@ -954,10 +982,11 @@ static int test_extent_accounting(void)
 		goto out;
 	}
 
-	/* [BTRFS_MAX_EXTENT_SIZE][4k] */
+	/* [BTRFS_MAX_EXTENT_SIZE][sectorsize] */
 	BTRFS_I(inode)->outstanding_extents++;
 	ret = btrfs_set_extent_delalloc(inode, BTRFS_MAX_EXTENT_SIZE,
-					BTRFS_MAX_EXTENT_SIZE + 4095, NULL);
+					BTRFS_MAX_EXTENT_SIZE + sectorsize - 1,
+					NULL);
 	if (ret) {
 		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
 		goto out;
@@ -969,10 +998,10 @@ static int test_extent_accounting(void)
 		goto out;
 	}
 
-	/* [BTRFS_MAX_EXTENT_SIZE/2][4K HOLE][the rest] */
+	/* [BTRFS_MAX_EXTENT_SIZE/2][sectorsize HOLE][the rest] */
 	ret = clear_extent_bit(&BTRFS_I(inode)->io_tree,
 			       BTRFS_MAX_EXTENT_SIZE >> 1,
-			       (BTRFS_MAX_EXTENT_SIZE >> 1) + 4095,
+			       (BTRFS_MAX_EXTENT_SIZE >> 1) + sectorsize - 1,
 			       EXTENT_DELALLOC | EXTENT_DIRTY |
 			       EXTENT_UPTODATE | EXTENT_DO_ACCOUNTING, 0, 0,
 			       NULL, GFP_KERNEL);
@@ -987,10 +1016,11 @@ static int test_extent_accounting(void)
 		goto out;
 	}
 
-	/* [BTRFS_MAX_EXTENT_SIZE][4K] */
+	/* [BTRFS_MAX_EXTENT_SIZE][sectorsize] */
 	BTRFS_I(inode)->outstanding_extents++;
 	ret = btrfs_set_extent_delalloc(inode, BTRFS_MAX_EXTENT_SIZE >> 1,
-					(BTRFS_MAX_EXTENT_SIZE >> 1) + 4095,
+					(BTRFS_MAX_EXTENT_SIZE >> 1)
+					+ sectorsize - 1,
 					NULL);
 	if (ret) {
 		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
@@ -1004,16 +1034,17 @@ static int test_extent_accounting(void)
 	}
 
 	/*
-	 * [BTRFS_MAX_EXTENT_SIZE+4K][4K HOLE][BTRFS_MAX_EXTENT_SIZE+4K]
+	 *[BTRFS_MAX_EXTENT_SIZE+sectorsize][sectorsize HOLE][BTRFS_MAX_EXTENT_SIZE+sectorsize]
 	 *
 	 * I'm artificially adding 2 to outstanding_extents because in the
 	 * buffered IO case we'd add things up as we go, but I don't feel like
 	 * doing that here, this isn't the interesting case we want to test.
 	 */
 	BTRFS_I(inode)->outstanding_extents += 2;
-	ret = btrfs_set_extent_delalloc(inode, BTRFS_MAX_EXTENT_SIZE + 8192,
-					(BTRFS_MAX_EXTENT_SIZE << 1) + 12287,
-					NULL);
+	ret = btrfs_set_extent_delalloc(inode,
+			BTRFS_MAX_EXTENT_SIZE + 2 * sectorsize,
+			(BTRFS_MAX_EXTENT_SIZE << 1) + 3 * sectorsize - 1,
+			NULL);
 	if (ret) {
 		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
 		goto out;
@@ -1025,10 +1056,13 @@ static int test_extent_accounting(void)
 		goto out;
 	}
 
-	/* [BTRFS_MAX_EXTENT_SIZE+4k][4k][BTRFS_MAX_EXTENT_SIZE+4k] */
+	/*
+	*[BTRFS_MAX_EXTENT_SIZE+sectorsize][sectorsize][BTRFS_MAX_EXTENT_SIZE+sectorsize]
+	*/
 	BTRFS_I(inode)->outstanding_extents++;
-	ret = btrfs_set_extent_delalloc(inode, BTRFS_MAX_EXTENT_SIZE+4096,
-					BTRFS_MAX_EXTENT_SIZE+8191, NULL);
+	ret = btrfs_set_extent_delalloc(inode,
+			BTRFS_MAX_EXTENT_SIZE+sectorsize,
+			BTRFS_MAX_EXTENT_SIZE+2*sectorsize-1, NULL);
 	if (ret) {
 		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
 		goto out;
@@ -1042,8 +1076,8 @@ static int test_extent_accounting(void)
 
 	/* [BTRFS_MAX_EXTENT_SIZE+4k][4K HOLE][BTRFS_MAX_EXTENT_SIZE+4k] */
 	ret = clear_extent_bit(&BTRFS_I(inode)->io_tree,
-			       BTRFS_MAX_EXTENT_SIZE+4096,
-			       BTRFS_MAX_EXTENT_SIZE+8191,
+			       BTRFS_MAX_EXTENT_SIZE+sectorsize,
+			       BTRFS_MAX_EXTENT_SIZE+2*sectorsize-1,
 			       EXTENT_DIRTY | EXTENT_DELALLOC |
 			       EXTENT_DO_ACCOUNTING | EXTENT_UPTODATE, 0, 0,
 			       NULL, GFP_KERNEL);
@@ -1063,8 +1097,9 @@ static int test_extent_accounting(void)
 	 * might fail and I'd rather satisfy my paranoia at this point.
 	 */
 	BTRFS_I(inode)->outstanding_extents++;
-	ret = btrfs_set_extent_delalloc(inode, BTRFS_MAX_EXTENT_SIZE+4096,
-					BTRFS_MAX_EXTENT_SIZE+8191, NULL);
+	ret = btrfs_set_extent_delalloc(inode,
+			BTRFS_MAX_EXTENT_SIZE+sectorsize,
+			BTRFS_MAX_EXTENT_SIZE+2*sectorsize-1, NULL);
 	if (ret) {
 		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
 		goto out;
@@ -1103,7 +1138,7 @@ out:
 	return ret;
 }
 
-int btrfs_test_inodes(void)
+int btrfs_test_inodes(u32 sectorsize, u32 nodesize)
 {
 	int ret;
 
@@ -1112,13 +1147,13 @@ int btrfs_test_inodes(void)
 	set_bit(EXTENT_FLAG_PREALLOC, &prealloc_only);
 
 	test_msg("Running btrfs_get_extent tests\n");
-	ret = test_btrfs_get_extent();
+	ret = test_btrfs_get_extent(sectorsize, nodesize);
 	if (ret)
 		return ret;
 	test_msg("Running hole first btrfs_get_extent test\n");
-	ret = test_hole_first();
+	ret = test_hole_first(sectorsize, nodesize);
 	if (ret)
 		return ret;
 	test_msg("Running outstanding_extents tests\n");
-	return test_extent_accounting();
+	return test_extent_accounting(sectorsize, nodesize);
 }
diff --git a/fs/btrfs/tests/qgroup-tests.c b/fs/btrfs/tests/qgroup-tests.c
index 8ea5d34..221652d 100644
--- a/fs/btrfs/tests/qgroup-tests.c
+++ b/fs/btrfs/tests/qgroup-tests.c
@@ -16,6 +16,7 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#include <linux/types.h>
 #include "btrfs-tests.h"
 #include "../ctree.h"
 #include "../transaction.h"
@@ -216,7 +217,8 @@ static int remove_extent_ref(struct btrfs_root *root, u64 bytenr,
 	return ret;
 }
 
-static int test_no_shared_qgroup(struct btrfs_root *root)
+static int test_no_shared_qgroup(struct btrfs_root *root,
+		u32 sectorsize, u32 nodesize)
 {
 	struct btrfs_trans_handle trans;
 	struct btrfs_fs_info *fs_info = root->fs_info;
@@ -227,7 +229,7 @@ static int test_no_shared_qgroup(struct btrfs_root *root)
 	btrfs_init_dummy_trans(&trans);
 
 	test_msg("Qgroup basic add\n");
-	ret = btrfs_create_qgroup(NULL, fs_info, 5);
+	ret = btrfs_create_qgroup(NULL, fs_info, BTRFS_FS_TREE_OBJECTID);
 	if (ret) {
 		test_msg("Couldn't create a qgroup %d\n", ret);
 		return ret;
@@ -238,18 +240,19 @@ static int test_no_shared_qgroup(struct btrfs_root *root)
 	 * we can only call btrfs_qgroup_account_extent() directly to test
 	 * quota.
 	 */
-	ret = btrfs_find_all_roots(&trans, fs_info, 4096, 0, &old_roots);
+	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots);
 	if (ret) {
 		ulist_free(old_roots);
 		test_msg("Couldn't find old roots: %d\n", ret);
 		return ret;
 	}
 
-	ret = insert_normal_tree_ref(root, 4096, 4096, 0, 5);
+	ret = insert_normal_tree_ref(root, nodesize, nodesize, 0,
+				BTRFS_FS_TREE_OBJECTID);
 	if (ret)
 		return ret;
 
-	ret = btrfs_find_all_roots(&trans, fs_info, 4096, 0, &new_roots);
+	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots);
 	if (ret) {
 		ulist_free(old_roots);
 		ulist_free(new_roots);
@@ -257,32 +260,33 @@ static int test_no_shared_qgroup(struct btrfs_root *root)
 		return ret;
 	}
 
-	ret = btrfs_qgroup_account_extent(&trans, fs_info, 4096, 4096,
-					  old_roots, new_roots);
+	ret = btrfs_qgroup_account_extent(&trans, fs_info, nodesize,
+					  nodesize, old_roots, new_roots);
 	if (ret) {
 		test_msg("Couldn't account space for a qgroup %d\n", ret);
 		return ret;
 	}
 
-	if (btrfs_verify_qgroup_counts(fs_info, 5, 4096, 4096)) {
+	if (btrfs_verify_qgroup_counts(fs_info, BTRFS_FS_TREE_OBJECTID,
+					nodesize, nodesize)) {
 		test_msg("Qgroup counts didn't match expected values\n");
 		return -EINVAL;
 	}
 	old_roots = NULL;
 	new_roots = NULL;
 
-	ret = btrfs_find_all_roots(&trans, fs_info, 4096, 0, &old_roots);
+	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots);
 	if (ret) {
 		ulist_free(old_roots);
 		test_msg("Couldn't find old roots: %d\n", ret);
 		return ret;
 	}
 
-	ret = remove_extent_item(root, 4096, 4096);
+	ret = remove_extent_item(root, nodesize, nodesize);
 	if (ret)
 		return -EINVAL;
 
-	ret = btrfs_find_all_roots(&trans, fs_info, 4096, 0, &new_roots);
+	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots);
 	if (ret) {
 		ulist_free(old_roots);
 		ulist_free(new_roots);
@@ -290,14 +294,14 @@ static int test_no_shared_qgroup(struct btrfs_root *root)
 		return ret;
 	}
 
-	ret = btrfs_qgroup_account_extent(&trans, fs_info, 4096, 4096,
-					  old_roots, new_roots);
+	ret = btrfs_qgroup_account_extent(&trans, fs_info, nodesize,
+					  nodesize, old_roots, new_roots);
 	if (ret) {
 		test_msg("Couldn't account space for a qgroup %d\n", ret);
 		return -EINVAL;
 	}
 
-	if (btrfs_verify_qgroup_counts(fs_info, 5, 0, 0)) {
+	if (btrfs_verify_qgroup_counts(fs_info, BTRFS_FS_TREE_OBJECTID, 0, 0)) {
 		test_msg("Qgroup counts didn't match expected values\n");
 		return -EINVAL;
 	}
@@ -310,7 +314,8 @@ static int test_no_shared_qgroup(struct btrfs_root *root)
  * right, also remove one of the roots and make sure the exclusive count is
  * adjusted properly.
  */
-static int test_multiple_refs(struct btrfs_root *root)
+static int test_multiple_refs(struct btrfs_root *root,
+		u32 sectorsize, u32 nodesize)
 {
 	struct btrfs_trans_handle trans;
 	struct btrfs_fs_info *fs_info = root->fs_info;
@@ -322,25 +327,29 @@ static int test_multiple_refs(struct btrfs_root *root)
 
 	test_msg("Qgroup multiple refs test\n");
 
-	/* We have 5 created already from the previous test */
-	ret = btrfs_create_qgroup(NULL, fs_info, 256);
+	/*
+	 * We have BTRFS_FS_TREE_OBJECTID created already from the
+	 * previous test.
+	*/
+	ret = btrfs_create_qgroup(NULL, fs_info, BTRFS_FIRST_FREE_OBJECTID);
 	if (ret) {
 		test_msg("Couldn't create a qgroup %d\n", ret);
 		return ret;
 	}
 
-	ret = btrfs_find_all_roots(&trans, fs_info, 4096, 0, &old_roots);
+	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots);
 	if (ret) {
 		ulist_free(old_roots);
 		test_msg("Couldn't find old roots: %d\n", ret);
 		return ret;
 	}
 
-	ret = insert_normal_tree_ref(root, 4096, 4096, 0, 5);
+	ret = insert_normal_tree_ref(root, nodesize, nodesize, 0,
+				BTRFS_FS_TREE_OBJECTID);
 	if (ret)
 		return ret;
 
-	ret = btrfs_find_all_roots(&trans, fs_info, 4096, 0, &new_roots);
+	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots);
 	if (ret) {
 		ulist_free(old_roots);
 		ulist_free(new_roots);
@@ -348,30 +357,32 @@ static int test_multiple_refs(struct btrfs_root *root)
 		return ret;
 	}
 
-	ret = btrfs_qgroup_account_extent(&trans, fs_info, 4096, 4096,
-					  old_roots, new_roots);
+	ret = btrfs_qgroup_account_extent(&trans, fs_info, nodesize,
+					  nodesize, old_roots, new_roots);
 	if (ret) {
 		test_msg("Couldn't account space for a qgroup %d\n", ret);
 		return ret;
 	}
 
-	if (btrfs_verify_qgroup_counts(fs_info, 5, 4096, 4096)) {
+	if (btrfs_verify_qgroup_counts(fs_info, BTRFS_FS_TREE_OBJECTID,
+				       nodesize, nodesize)) {
 		test_msg("Qgroup counts didn't match expected values\n");
 		return -EINVAL;
 	}
 
-	ret = btrfs_find_all_roots(&trans, fs_info, 4096, 0, &old_roots);
+	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots);
 	if (ret) {
 		ulist_free(old_roots);
 		test_msg("Couldn't find old roots: %d\n", ret);
 		return ret;
 	}
 
-	ret = add_tree_ref(root, 4096, 4096, 0, 256);
+	ret = add_tree_ref(root, nodesize, nodesize, 0,
+			   BTRFS_FIRST_FREE_OBJECTID);
 	if (ret)
 		return ret;
 
-	ret = btrfs_find_all_roots(&trans, fs_info, 4096, 0, &new_roots);
+	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots);
 	if (ret) {
 		ulist_free(old_roots);
 		ulist_free(new_roots);
@@ -379,35 +390,38 @@ static int test_multiple_refs(struct btrfs_root *root)
 		return ret;
 	}
 
-	ret = btrfs_qgroup_account_extent(&trans, fs_info, 4096, 4096,
-					  old_roots, new_roots);
+	ret = btrfs_qgroup_account_extent(&trans, fs_info, nodesize,
+					  nodesize, old_roots, new_roots);
 	if (ret) {
 		test_msg("Couldn't account space for a qgroup %d\n", ret);
 		return ret;
 	}
 
-	if (btrfs_verify_qgroup_counts(fs_info, 5, 4096, 0)) {
+	if (btrfs_verify_qgroup_counts(fs_info, BTRFS_FS_TREE_OBJECTID,
+				       nodesize, 0)) {
 		test_msg("Qgroup counts didn't match expected values\n");
 		return -EINVAL;
 	}
 
-	if (btrfs_verify_qgroup_counts(fs_info, 256, 4096, 0)) {
+	if (btrfs_verify_qgroup_counts(fs_info, BTRFS_FIRST_FREE_OBJECTID,
+					nodesize, 0)) {
 		test_msg("Qgroup counts didn't match expected values\n");
 		return -EINVAL;
 	}
 
-	ret = btrfs_find_all_roots(&trans, fs_info, 4096, 0, &old_roots);
+	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots);
 	if (ret) {
 		ulist_free(old_roots);
 		test_msg("Couldn't find old roots: %d\n", ret);
 		return ret;
 	}
 
-	ret = remove_extent_ref(root, 4096, 4096, 0, 256);
+	ret = remove_extent_ref(root, nodesize, nodesize, 0,
+				BTRFS_FIRST_FREE_OBJECTID);
 	if (ret)
 		return ret;
 
-	ret = btrfs_find_all_roots(&trans, fs_info, 4096, 0, &new_roots);
+	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots);
 	if (ret) {
 		ulist_free(old_roots);
 		ulist_free(new_roots);
@@ -415,19 +429,21 @@ static int test_multiple_refs(struct btrfs_root *root)
 		return ret;
 	}
 
-	ret = btrfs_qgroup_account_extent(&trans, fs_info, 4096, 4096,
-					  old_roots, new_roots);
+	ret = btrfs_qgroup_account_extent(&trans, fs_info, nodesize,
+					  nodesize, old_roots, new_roots);
 	if (ret) {
 		test_msg("Couldn't account space for a qgroup %d\n", ret);
 		return ret;
 	}
 
-	if (btrfs_verify_qgroup_counts(fs_info, 256, 0, 0)) {
+	if (btrfs_verify_qgroup_counts(fs_info, BTRFS_FIRST_FREE_OBJECTID,
+				       0, 0)) {
 		test_msg("Qgroup counts didn't match expected values\n");
 		return -EINVAL;
 	}
 
-	if (btrfs_verify_qgroup_counts(fs_info, 5, 4096, 4096)) {
+	if (btrfs_verify_qgroup_counts(fs_info, BTRFS_FS_TREE_OBJECTID,
+					nodesize, nodesize)) {
 		test_msg("Qgroup counts didn't match expected values\n");
 		return -EINVAL;
 	}
@@ -435,13 +451,13 @@ static int test_multiple_refs(struct btrfs_root *root)
 	return 0;
 }
 
-int btrfs_test_qgroups(void)
+int btrfs_test_qgroups(u32 sectorsize, u32 nodesize)
 {
 	struct btrfs_root *root;
 	struct btrfs_root *tmp_root;
 	int ret = 0;
 
-	root = btrfs_alloc_dummy_root();
+	root = btrfs_alloc_dummy_root(sectorsize, nodesize);
 	if (IS_ERR(root)) {
 		test_msg("Couldn't allocate root\n");
 		return PTR_ERR(root);
@@ -468,7 +484,8 @@ int btrfs_test_qgroups(void)
 	 * Can't use bytenr 0, some things freak out
 	 * *cough*backref walking code*cough*
 	 */
-	root->node = alloc_test_extent_buffer(root->fs_info, 4096);
+	root->node = alloc_test_extent_buffer(root->fs_info, nodesize,
+					nodesize);
 	if (!root->node) {
 		test_msg("Couldn't allocate dummy buffer\n");
 		ret = -ENOMEM;
@@ -476,16 +493,16 @@ int btrfs_test_qgroups(void)
 	}
 	btrfs_set_header_level(root->node, 0);
 	btrfs_set_header_nritems(root->node, 0);
-	root->alloc_bytenr += 8192;
+	root->alloc_bytenr += 2 * nodesize;
 
-	tmp_root = btrfs_alloc_dummy_root();
+	tmp_root = btrfs_alloc_dummy_root(sectorsize, nodesize);
 	if (IS_ERR(tmp_root)) {
 		test_msg("Couldn't allocate a fs root\n");
 		ret = PTR_ERR(tmp_root);
 		goto out;
 	}
 
-	tmp_root->root_key.objectid = 5;
+	tmp_root->root_key.objectid = BTRFS_FS_TREE_OBJECTID;
 	root->fs_info->fs_root = tmp_root;
 	ret = btrfs_insert_fs_root(root->fs_info, tmp_root);
 	if (ret) {
@@ -493,14 +510,14 @@ int btrfs_test_qgroups(void)
 		goto out;
 	}
 
-	tmp_root = btrfs_alloc_dummy_root();
+	tmp_root = btrfs_alloc_dummy_root(sectorsize, nodesize);
 	if (IS_ERR(tmp_root)) {
 		test_msg("Couldn't allocate a fs root\n");
 		ret = PTR_ERR(tmp_root);
 		goto out;
 	}
 
-	tmp_root->root_key.objectid = 256;
+	tmp_root->root_key.objectid = BTRFS_FIRST_FREE_OBJECTID;
 	ret = btrfs_insert_fs_root(root->fs_info, tmp_root);
 	if (ret) {
 		test_msg("Couldn't insert fs root %d\n", ret);
@@ -508,10 +525,10 @@ int btrfs_test_qgroups(void)
 	}
 
 	test_msg("Running qgroup tests\n");
-	ret = test_no_shared_qgroup(root);
+	ret = test_no_shared_qgroup(root, sectorsize, nodesize);
 	if (ret)
 		goto out;
-	ret = test_multiple_refs(root);
+	ret = test_multiple_refs(root, sectorsize, nodesize);
 out:
 	btrfs_free_dummy_root(root);
 	return ret;
-- 
2.7.4

