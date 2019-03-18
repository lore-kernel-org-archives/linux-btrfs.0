Return-Path: <SRS0=8Q4i=RV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D1B9C10F00
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:49:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3846820854
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbfCRQtV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Mar 2019 12:49:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:55984 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727130AbfCRQtU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Mar 2019 12:49:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 180D3AD3A
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2019 16:49:18 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4DD55DA8A7; Mon, 18 Mar 2019 17:50:33 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 12/22] btrfs: tests: return errors from extent map tests
Date:   Mon, 18 Mar 2019 17:50:33 +0100
Message-Id: <23a81dfb418d0352beb0ea2dd75c9b1209ce8bf6.1552927639.git.dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1552927639.git.dsterba@suse.com>
References: <cover.1552927639.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The individual testcases for extent maps do not return an error on
allocation failures. This is not a big problem as the allocation don't
fail in general but there are functional tests handled with ASSERTS.
This makes tests dependent on them and it's not reliable.

This patch adds the allocation failure handling and allows for the
conversion of the asserts to proper error handling and reporting.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/tests/extent-map-tests.c | 68 +++++++++++++++++++++----------
 1 file changed, 46 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/tests/extent-map-tests.c b/fs/btrfs/tests/extent-map-tests.c
index 662b718506b9..c31b1ac3bc2d 100644
--- a/fs/btrfs/tests/extent-map-tests.c
+++ b/fs/btrfs/tests/extent-map-tests.c
@@ -47,7 +47,7 @@ static void free_extent_map_tree(struct extent_map_tree *em_tree)
  *                                    ->add_extent_mapping(0, 16K)
  *                                    -> #handle -EEXIST
  */
-static void test_case_1(struct btrfs_fs_info *fs_info,
+static int test_case_1(struct btrfs_fs_info *fs_info,
 		struct extent_map_tree *em_tree)
 {
 	struct extent_map *em;
@@ -57,8 +57,7 @@ static void test_case_1(struct btrfs_fs_info *fs_info,
 
 	em = alloc_extent_map();
 	if (!em)
-		/* Skip the test on error. */
-		return;
+		return -ENOMEM;
 
 	/* Add [0, 16K) */
 	em->start = 0;
@@ -71,8 +70,10 @@ static void test_case_1(struct btrfs_fs_info *fs_info,
 
 	/* Add [16K, 20K) following [0, 16K)  */
 	em = alloc_extent_map();
-	if (!em)
+	if (!em) {
+		ret = -ENOMEM;
 		goto out;
+	}
 
 	em->start = SZ_16K;
 	em->len = SZ_4K;
@@ -83,8 +84,10 @@ static void test_case_1(struct btrfs_fs_info *fs_info,
 	free_extent_map(em);
 
 	em = alloc_extent_map();
-	if (!em)
+	if (!em) {
+		ret = -ENOMEM;
 		goto out;
+	}
 
 	/* Add [0, 8K), should return [0, 16K) instead. */
 	em->start = start;
@@ -102,9 +105,12 @@ static void test_case_1(struct btrfs_fs_info *fs_info,
 			 start, start + len, ret, em->start, em->len,
 			 em->block_start, em->block_len);
 	free_extent_map(em);
+	ret = 0;
 out:
 	/* free memory */
 	free_extent_map_tree(em_tree);
+
+	return ret;
 }
 
 /*
@@ -113,7 +119,7 @@ static void test_case_1(struct btrfs_fs_info *fs_info,
  * Reading the inline ending up with EEXIST, ie. read an inline
  * extent and discard page cache and read it again.
  */
-static void test_case_2(struct btrfs_fs_info *fs_info,
+static int test_case_2(struct btrfs_fs_info *fs_info,
 		struct extent_map_tree *em_tree)
 {
 	struct extent_map *em;
@@ -121,8 +127,7 @@ static void test_case_2(struct btrfs_fs_info *fs_info,
 
 	em = alloc_extent_map();
 	if (!em)
-		/* Skip the test on error. */
-		return;
+		return -ENOMEM;
 
 	/* Add [0, 1K) */
 	em->start = 0;
@@ -135,8 +140,10 @@ static void test_case_2(struct btrfs_fs_info *fs_info,
 
 	/* Add [4K, 4K) following [0, 1K)  */
 	em = alloc_extent_map();
-	if (!em)
+	if (!em) {
+		ret = -ENOMEM;
 		goto out;
+	}
 
 	em->start = SZ_4K;
 	em->len = SZ_4K;
@@ -147,8 +154,10 @@ static void test_case_2(struct btrfs_fs_info *fs_info,
 	free_extent_map(em);
 
 	em = alloc_extent_map();
-	if (!em)
+	if (!em) {
+		ret = -ENOMEM;
 		goto out;
+	}
 
 	/* Add [0, 1K) */
 	em->start = 0;
@@ -166,12 +175,15 @@ static void test_case_2(struct btrfs_fs_info *fs_info,
 			 ret, em->start, em->len, em->block_start,
 			 em->block_len);
 	free_extent_map(em);
+	ret = 0;
 out:
 	/* free memory */
 	free_extent_map_tree(em_tree);
+
+	return ret;
 }
 
-static void __test_case_3(struct btrfs_fs_info *fs_info,
+static int __test_case_3(struct btrfs_fs_info *fs_info,
 		struct extent_map_tree *em_tree, u64 start)
 {
 	struct extent_map *em;
@@ -180,8 +192,7 @@ static void __test_case_3(struct btrfs_fs_info *fs_info,
 
 	em = alloc_extent_map();
 	if (!em)
-		/* Skip this test on error. */
-		return;
+		return -ENOMEM;
 
 	/* Add [4K, 8K) */
 	em->start = SZ_4K;
@@ -193,8 +204,10 @@ static void __test_case_3(struct btrfs_fs_info *fs_info,
 	free_extent_map(em);
 
 	em = alloc_extent_map();
-	if (!em)
+	if (!em) {
+		ret = -ENOMEM;
 		goto out;
+	}
 
 	/* Add [0, 16K) */
 	em->start = 0;
@@ -217,9 +230,12 @@ static void __test_case_3(struct btrfs_fs_info *fs_info,
 			 start, start + len, ret, em->start, em->len,
 			 em->block_start, em->block_len);
 	free_extent_map(em);
+	ret = 0;
 out:
 	/* free memory */
 	free_extent_map_tree(em_tree);
+
+	return ret;
 }
 
 /*
@@ -246,7 +262,7 @@ static void test_case_3(struct btrfs_fs_info *fs_info,
 	__test_case_3(fs_info, em_tree, (12 * 1024ULL));
 }
 
-static void __test_case_4(struct btrfs_fs_info *fs_info,
+static int __test_case_4(struct btrfs_fs_info *fs_info,
 		struct extent_map_tree *em_tree, u64 start)
 {
 	struct extent_map *em;
@@ -255,8 +271,7 @@ static void __test_case_4(struct btrfs_fs_info *fs_info,
 
 	em = alloc_extent_map();
 	if (!em)
-		/* Skip this test on error. */
-		return;
+		return -ENOMEM;
 
 	/* Add [0K, 8K) */
 	em->start = 0;
@@ -268,8 +283,10 @@ static void __test_case_4(struct btrfs_fs_info *fs_info,
 	free_extent_map(em);
 
 	em = alloc_extent_map();
-	if (!em)
+	if (!em) {
+		ret = -ENOMEM;
 		goto out;
+	}
 
 	/* Add [8K, 24K) */
 	em->start = SZ_8K;
@@ -281,8 +298,10 @@ static void __test_case_4(struct btrfs_fs_info *fs_info,
 	free_extent_map(em);
 
 	em = alloc_extent_map();
-	if (!em)
+	if (!em) {
+		ret = -ENOMEM;
 		goto out;
+	}
 	/* Add [0K, 32K) */
 	em->start = 0;
 	em->len = SZ_32K;
@@ -299,9 +318,12 @@ static void __test_case_4(struct btrfs_fs_info *fs_info,
 			 start, len, ret, em->start, em->len, em->block_start,
 			 em->block_len);
 	free_extent_map(em);
+	ret = 0;
 out:
 	/* free memory */
 	free_extent_map_tree(em_tree);
+
+	return ret;
 }
 
 /*
@@ -340,6 +362,7 @@ int btrfs_test_extent_map(void)
 {
 	struct btrfs_fs_info *fs_info = NULL;
 	struct extent_map_tree *em_tree;
+	int ret = 0;
 
 	test_msg("running extent_map tests");
 
@@ -354,9 +377,10 @@ int btrfs_test_extent_map(void)
 	}
 
 	em_tree = kzalloc(sizeof(*em_tree), GFP_KERNEL);
-	if (!em_tree)
-		/* Skip the test on error. */
+	if (!em_tree) {
+		ret = -ENOMEM;
 		goto out;
+	}
 
 	extent_map_tree_init(em_tree);
 
@@ -369,5 +393,5 @@ int btrfs_test_extent_map(void)
 out:
 	btrfs_free_dummy_fs_info(fs_info);
 
-	return 0;
+	return ret;
 }
-- 
2.21.0

