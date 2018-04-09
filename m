Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35786 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752214AbeDIMBb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Apr 2018 08:01:31 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A8A99AEF8
        for <linux-btrfs@vger.kernel.org>; Mon,  9 Apr 2018 12:01:29 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 6/7] btrfs: tests: pass fs_info to extent_map tests
Date: Mon,  9 Apr 2018 13:58:57 +0200
Message-Id: <33be620e8f584afacd804333acbbd5952a1f76d3.1523275048.git.dsterba@suse.com>
In-Reply-To: <cover.1523275048.git.dsterba@suse.com>
References: <cover.1523275048.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Preparatory work to pass fs_info to btrfs_add_extent_mapping so we can
get a better tracepoint message. Extent maps do not need fs_info for
anything so we only add a dummy one without any other initialization.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/tests/extent-map-tests.c | 52 +++++++++++++++++++++++++++------------
 1 file changed, 36 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/tests/extent-map-tests.c b/fs/btrfs/tests/extent-map-tests.c
index c23bd00bdd92..33760a7f580d 100644
--- a/fs/btrfs/tests/extent-map-tests.c
+++ b/fs/btrfs/tests/extent-map-tests.c
@@ -60,7 +60,8 @@ static void free_extent_map_tree(struct extent_map_tree *em_tree)
  *                                    ->add_extent_mapping(0, 16K)
  *                                    -> #handle -EEXIST
  */
-static void test_case_1(struct extent_map_tree *em_tree)
+static void test_case_1(struct btrfs_fs_info *fs_info,
+		struct extent_map_tree *em_tree)
 {
 	struct extent_map *em;
 	u64 start = 0;
@@ -125,7 +126,8 @@ static void test_case_1(struct extent_map_tree *em_tree)
  * Reading the inline ending up with EEXIST, ie. read an inline
  * extent and discard page cache and read it again.
  */
-static void test_case_2(struct extent_map_tree *em_tree)
+static void test_case_2(struct btrfs_fs_info *fs_info,
+		struct extent_map_tree *em_tree)
 {
 	struct extent_map *em;
 	int ret;
@@ -182,7 +184,8 @@ static void test_case_2(struct extent_map_tree *em_tree)
 	free_extent_map_tree(em_tree);
 }
 
-static void __test_case_3(struct extent_map_tree *em_tree, u64 start)
+static void __test_case_3(struct btrfs_fs_info *fs_info,
+		struct extent_map_tree *em_tree, u64 start)
 {
 	struct extent_map *em;
 	u64 len = SZ_4K;
@@ -248,14 +251,16 @@ static void __test_case_3(struct extent_map_tree *em_tree, u64 start)
  *   -> add_extent_mapping()
  *                            -> add_extent_mapping()
  */
-static void test_case_3(struct extent_map_tree *em_tree)
+static void test_case_3(struct btrfs_fs_info *fs_info,
+		struct extent_map_tree *em_tree)
 {
-	__test_case_3(em_tree, 0);
-	__test_case_3(em_tree, SZ_8K);
-	__test_case_3(em_tree, (12 * 1024ULL));
+	__test_case_3(fs_info, em_tree, 0);
+	__test_case_3(fs_info, em_tree, SZ_8K);
+	__test_case_3(fs_info, em_tree, (12 * 1024ULL));
 }
 
-static void __test_case_4(struct extent_map_tree *em_tree, u64 start)
+static void __test_case_4(struct btrfs_fs_info *fs_info,
+		struct extent_map_tree *em_tree, u64 start)
 {
 	struct extent_map *em;
 	u64 len = SZ_4K;
@@ -337,30 +342,45 @@ static void __test_case_4(struct extent_map_tree *em_tree, u64 start)
  *                                             # handle -EEXIST when adding
  *                                             # [0, 32K)
  */
-static void test_case_4(struct extent_map_tree *em_tree)
+static void test_case_4(struct btrfs_fs_info *fs_info,
+		struct extent_map_tree *em_tree)
 {
-	__test_case_4(em_tree, 0);
-	__test_case_4(em_tree, SZ_4K);
+	__test_case_4(fs_info, em_tree, 0);
+	__test_case_4(fs_info, em_tree, SZ_4K);
 }
 
 int btrfs_test_extent_map(void)
 {
+	struct btrfs_fs_info *fs_info = NULL;
 	struct extent_map_tree *em_tree;
 
 	test_msg("Running extent_map tests\n");
 
+	/*
+	 * Note: the fs_info is not set up completely, we only need
+	 * fs_info::fsid for the tracepoint.
+	 */
+	fs_info = btrfs_alloc_dummy_fs_info(PAGE_SIZE, PAGE_SIZE);
+	if (!fs_info) {
+		test_msg("Couldn't allocate dummy fs info\n");
+		return -ENOMEM;
+	}
+
 	em_tree = kzalloc(sizeof(*em_tree), GFP_KERNEL);
 	if (!em_tree)
 		/* Skip the test on error. */
-		return 0;
+		goto out;
 
 	extent_map_tree_init(em_tree);
 
-	test_case_1(em_tree);
-	test_case_2(em_tree);
-	test_case_3(em_tree);
-	test_case_4(em_tree);
+	test_case_1(fs_info, em_tree);
+	test_case_2(fs_info, em_tree);
+	test_case_3(fs_info, em_tree);
+	test_case_4(fs_info, em_tree);
 
 	kfree(em_tree);
+out:
+	btrfs_free_dummy_fs_info(fs_info);
+
 	return 0;
 }
-- 
2.16.2

