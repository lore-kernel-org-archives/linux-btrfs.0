Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55116 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751033AbeEPWDZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 18:03:25 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 737C7AF5D
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 22:03:24 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/2] btrfs: tests: drop newline from test_msg strings
Date: Thu, 17 May 2018 00:00:44 +0200
Message-Id: <414a5c51fe26120101bc6721c75590dd95d133e1.1526507933.git.dsterba@suse.com>
In-Reply-To: <cover.1526507933.git.dsterba@suse.com>
References: <cover.1526507933.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now that test_err strings do not need the newline, remove them also from
the test_msg.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/tests/btrfs-tests.h           |  2 +-
 fs/btrfs/tests/extent-buffer-tests.c   |  4 ++--
 fs/btrfs/tests/extent-io-tests.c       |  8 ++++----
 fs/btrfs/tests/extent-map-tests.c      |  4 ++--
 fs/btrfs/tests/free-space-tests.c      | 12 ++++++------
 fs/btrfs/tests/free-space-tree-tests.c |  2 +-
 fs/btrfs/tests/inode-tests.c           |  6 +++---
 fs/btrfs/tests/qgroup-tests.c          |  6 +++---
 8 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/tests/btrfs-tests.h b/fs/btrfs/tests/btrfs-tests.h
index 47b5d2eac790..70ff9f9d86a1 100644
--- a/fs/btrfs/tests/btrfs-tests.h
+++ b/fs/btrfs/tests/btrfs-tests.h
@@ -9,7 +9,7 @@
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 int btrfs_run_sanity_tests(void);
 
-#define test_msg(fmt, ...) pr_info("BTRFS: selftest: " fmt, ##__VA_ARGS__)
+#define test_msg(fmt, ...) pr_info("BTRFS: selftest: " fmt "\n", ##__VA_ARGS__)
 #define test_err(fmt, ...) pr_err("BTRFS: selftest: " fmt "\n", ##__VA_ARGS__)
 
 struct btrfs_root;
diff --git a/fs/btrfs/tests/extent-buffer-tests.c b/fs/btrfs/tests/extent-buffer-tests.c
index 2fa440cf7874..7d72eab6d32c 100644
--- a/fs/btrfs/tests/extent-buffer-tests.c
+++ b/fs/btrfs/tests/extent-buffer-tests.c
@@ -26,7 +26,7 @@ static int test_btrfs_split_item(u32 sectorsize, u32 nodesize)
 	u32 value_len = strlen(value);
 	int ret = 0;
 
-	test_msg("running btrfs_split_item tests\n");
+	test_msg("running btrfs_split_item tests");
 
 	fs_info = btrfs_alloc_dummy_fs_info(nodesize, sectorsize);
 	if (!fs_info) {
@@ -220,6 +220,6 @@ static int test_btrfs_split_item(u32 sectorsize, u32 nodesize)
 
 int btrfs_test_extent_buffer_operations(u32 sectorsize, u32 nodesize)
 {
-	test_msg("running extent buffer operation tests\n");
+	test_msg("running extent buffer operation tests");
 	return test_btrfs_split_item(sectorsize, nodesize);
 }
diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index f17e2e31d64f..d9269a531a4d 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -68,7 +68,7 @@ static int test_find_delalloc(u32 sectorsize)
 	u64 found;
 	int ret = -EINVAL;
 
-	test_msg("running find delalloc tests\n");
+	test_msg("running find delalloc tests");
 
 	inode = btrfs_new_test_inode();
 	if (!inode) {
@@ -377,7 +377,7 @@ static int test_eb_bitmaps(u32 sectorsize, u32 nodesize)
 	struct extent_buffer *eb;
 	int ret;
 
-	test_msg("running extent buffer bitmap tests\n");
+	test_msg("running extent buffer bitmap tests");
 
 	/*
 	 * In ppc64, sectorsize can be 64K, thus 4 * 64K will be larger than
@@ -425,7 +425,7 @@ int btrfs_test_extent_io(u32 sectorsize, u32 nodesize)
 {
 	int ret;
 
-	test_msg("running extent I/O tests\n");
+	test_msg("running extent I/O tests");
 
 	ret = test_find_delalloc(sectorsize);
 	if (ret)
@@ -433,6 +433,6 @@ int btrfs_test_extent_io(u32 sectorsize, u32 nodesize)
 
 	ret = test_eb_bitmaps(sectorsize, nodesize);
 out:
-	test_msg("extent I/O tests finished\n");
+	test_msg("extent I/O tests finished");
 	return ret;
 }
diff --git a/fs/btrfs/tests/extent-map-tests.c b/fs/btrfs/tests/extent-map-tests.c
index d55266e01cad..385a5316e4bf 100644
--- a/fs/btrfs/tests/extent-map-tests.c
+++ b/fs/btrfs/tests/extent-map-tests.c
@@ -341,7 +341,7 @@ int btrfs_test_extent_map(void)
 	struct btrfs_fs_info *fs_info = NULL;
 	struct extent_map_tree *em_tree;
 
-	test_msg("running extent_map tests\n");
+	test_msg("running extent_map tests");
 
 	/*
 	 * Note: the fs_info is not set up completely, we only need
@@ -349,7 +349,7 @@ int btrfs_test_extent_map(void)
 	 */
 	fs_info = btrfs_alloc_dummy_fs_info(PAGE_SIZE, PAGE_SIZE);
 	if (!fs_info) {
-		test_msg("Couldn't allocate dummy fs info\n");
+		test_msg("Couldn't allocate dummy fs info");
 		return -ENOMEM;
 	}
 
diff --git a/fs/btrfs/tests/free-space-tests.c b/fs/btrfs/tests/free-space-tests.c
index 7cbad3e666d3..5c2f77e9439b 100644
--- a/fs/btrfs/tests/free-space-tests.c
+++ b/fs/btrfs/tests/free-space-tests.c
@@ -20,7 +20,7 @@ static int test_extents(struct btrfs_block_group_cache *cache)
 {
 	int ret = 0;
 
-	test_msg("running extent only tests\n");
+	test_msg("running extent only tests");
 
 	/* First just make sure we can remove an entire entry */
 	ret = btrfs_add_free_space(cache, 0, SZ_4M);
@@ -92,7 +92,7 @@ static int test_bitmaps(struct btrfs_block_group_cache *cache,
 	u64 next_bitmap_offset;
 	int ret;
 
-	test_msg("running bitmap only tests\n");
+	test_msg("running bitmap only tests");
 
 	ret = test_add_free_space_entry(cache, 0, SZ_4M, 1);
 	if (ret) {
@@ -161,7 +161,7 @@ static int test_bitmaps_and_extents(struct btrfs_block_group_cache *cache,
 	u64 bitmap_offset = (u64)(BITS_PER_BITMAP * sectorsize);
 	int ret;
 
-	test_msg("running bitmap and extent tests\n");
+	test_msg("running bitmap and extent tests");
 
 	/*
 	 * First let's do something simple, an extent at the same offset as the
@@ -404,7 +404,7 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache,
 	};
 	const struct btrfs_free_space_op *orig_free_space_ops;
 
-	test_msg("running space stealing from bitmap to extent\n");
+	test_msg("running space stealing from bitmap to extent");
 
 	/*
 	 * For this test, we want to ensure we end up with an extent entry
@@ -832,7 +832,7 @@ int btrfs_test_free_space_cache(u32 sectorsize, u32 nodesize)
 	struct btrfs_root *root = NULL;
 	int ret = -ENOMEM;
 
-	test_msg("running btrfs free space cache tests\n");
+	test_msg("running btrfs free space cache tests");
 	fs_info = btrfs_alloc_dummy_fs_info(nodesize, sectorsize);
 	if (!fs_info)
 		return -ENOMEM;
@@ -874,6 +874,6 @@ int btrfs_test_free_space_cache(u32 sectorsize, u32 nodesize)
 	btrfs_free_dummy_block_group(cache);
 	btrfs_free_dummy_root(root);
 	btrfs_free_dummy_fs_info(fs_info);
-	test_msg("free space cache tests finished\n");
+	test_msg("free space cache tests finished");
 	return ret;
 }
diff --git a/fs/btrfs/tests/free-space-tree-tests.c b/fs/btrfs/tests/free-space-tree-tests.c
index 8c0b395257ea..89346da890cf 100644
--- a/fs/btrfs/tests/free-space-tree-tests.c
+++ b/fs/btrfs/tests/free-space-tree-tests.c
@@ -578,7 +578,7 @@ int btrfs_test_free_space_tree(u32 sectorsize, u32 nodesize)
 	 */
 	bitmap_alignment = BTRFS_FREE_SPACE_BITMAP_BITS * PAGE_SIZE;
 
-	test_msg("running free space tree tests\n");
+	test_msg("running free space tree tests");
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		int ret;
 
diff --git a/fs/btrfs/tests/inode-tests.c b/fs/btrfs/tests/inode-tests.c
index 2f2f9dc30f4c..64043f028820 100644
--- a/fs/btrfs/tests/inode-tests.c
+++ b/fs/btrfs/tests/inode-tests.c
@@ -1119,14 +1119,14 @@ int btrfs_test_inodes(u32 sectorsize, u32 nodesize)
 	set_bit(EXTENT_FLAG_COMPRESSED, &compressed_only);
 	set_bit(EXTENT_FLAG_PREALLOC, &prealloc_only);
 
-	test_msg("running btrfs_get_extent tests\n");
+	test_msg("running btrfs_get_extent tests");
 	ret = test_btrfs_get_extent(sectorsize, nodesize);
 	if (ret)
 		return ret;
-	test_msg("running hole first btrfs_get_extent test\n");
+	test_msg("running hole first btrfs_get_extent test");
 	ret = test_hole_first(sectorsize, nodesize);
 	if (ret)
 		return ret;
-	test_msg("running outstanding_extents tests\n");
+	test_msg("running outstanding_extents tests");
 	return test_extent_accounting(sectorsize, nodesize);
 }
diff --git a/fs/btrfs/tests/qgroup-tests.c b/fs/btrfs/tests/qgroup-tests.c
index 578c6c461897..ace94db09d29 100644
--- a/fs/btrfs/tests/qgroup-tests.c
+++ b/fs/btrfs/tests/qgroup-tests.c
@@ -215,7 +215,7 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 
 	btrfs_init_dummy_trans(&trans, fs_info);
 
-	test_msg("qgroup basic add\n");
+	test_msg("qgroup basic add");
 	ret = btrfs_create_qgroup(NULL, fs_info, BTRFS_FS_TREE_OBJECTID);
 	if (ret) {
 		test_err("couldn't create a qgroup %d", ret);
@@ -316,7 +316,7 @@ static int test_multiple_refs(struct btrfs_root *root,
 
 	btrfs_init_dummy_trans(&trans, fs_info);
 
-	test_msg("qgroup multiple refs test\n");
+	test_msg("qgroup multiple refs test");
 
 	/*
 	 * We have BTRFS_FS_TREE_OBJECTID created already from the
@@ -522,7 +522,7 @@ int btrfs_test_qgroups(u32 sectorsize, u32 nodesize)
 		goto out;
 	}
 
-	test_msg("running qgroup tests\n");
+	test_msg("running qgroup tests");
 	ret = test_no_shared_qgroup(root, sectorsize, nodesize);
 	if (ret)
 		goto out;
-- 
2.16.2

