Return-Path: <SRS0=YqDN=N6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E22E9C169D4
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 09:38:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B48DD20823
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 09:38:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B48DD20823
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbeKSUBo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Nov 2018 15:01:44 -0500
Received: from mx2.suse.de ([195.135.220.15]:60180 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727450AbeKSUBn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Nov 2018 15:01:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 05740AF4F
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Nov 2018 09:38:36 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v2 5/5] btrfs: use EXPORT_FOR_TESTS for conditionally shared functions
Date:   Mon, 19 Nov 2018 10:38:17 +0100
Message-Id: <20181119093817.9291-6-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20181119093817.9291-1-jthumshirn@suse.de>
References: <20181119093817.9291-1-jthumshirn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Several functions in BTRFS are only used inside the source file they are
declared if CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not defined. However if
CONFIG_BTRFS_FS_RUN_SANITY_TESTS is defined these functions are shared with
the unit tests code.

Before the introduction of the EXPORT_FOR_TESTS macro, these functions
could not be declared as static and the compiler had a harder task when
optimizing and inlining them.

As we have EXPORT_FOR_TESTS now, use it where appropriate to support the
compiler.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 fs/btrfs/extent_io.c             | 14 ++------------
 fs/btrfs/extent_io.h             |  7 +++----
 fs/btrfs/free-space-tree.c       |  8 ++++++--
 fs/btrfs/tests/extent-io-tests.c | 10 +++++-----
 4 files changed, 16 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 926bf30c2f2e..16344d5b8d68 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1556,7 +1556,8 @@ static noinline int lock_delalloc_pages(struct inode *inode,
  *
  * 1 is returned if we find something, 0 if nothing was in the tree
  */
-static noinline_for_stack u64 find_lock_delalloc_range(struct inode *inode,
+EXPORT_FOR_TESTS
+noinline_for_stack u64 find_lock_delalloc_range(struct inode *inode,
 				    struct extent_io_tree *tree,
 				    struct page *locked_page, u64 *start,
 				    u64 *end, u64 max_bytes)
@@ -1636,17 +1637,6 @@ static noinline_for_stack u64 find_lock_delalloc_range(struct inode *inode,
 	return found;
 }
 
-#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
-u64 btrfs_find_lock_delalloc_range(struct inode *inode,
-				    struct extent_io_tree *tree,
-				    struct page *locked_page, u64 *start,
-				    u64 *end, u64 max_bytes)
-{
-	return find_lock_delalloc_range(inode, tree, locked_page, start, end,
-			max_bytes);
-}
-#endif
-
 static int __process_pages_contig(struct address_space *mapping,
 				  struct page *locked_page,
 				  pgoff_t start_index, pgoff_t end_index,
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index d96fd534f144..a03204a81751 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -522,10 +522,9 @@ int free_io_failure(struct extent_io_tree *failure_tree,
 		    struct extent_io_tree *io_tree,
 		    struct io_failure_record *rec);
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
-u64 btrfs_find_lock_delalloc_range(struct inode *inode,
-				      struct extent_io_tree *tree,
-				      struct page *locked_page, u64 *start,
-				      u64 *end, u64 max_bytes);
+u64 find_lock_delalloc_range(struct inode *inode, struct extent_io_tree *tree,
+			     struct page *locked_page, u64 *start,
+			     u64 *end, u64 max_bytes);
 #endif
 struct extent_buffer *alloc_test_extent_buffer(struct btrfs_fs_info *fs_info,
 					       u64 start);
diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index d6736595ec57..cacdebc26fa0 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -74,7 +74,7 @@ static int add_new_free_space_info(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-struct btrfs_free_space_info *
+EXPORT_FOR_TESTS struct btrfs_free_space_info *
 search_free_space_info(struct btrfs_trans_handle *trans,
 		       struct btrfs_fs_info *fs_info,
 		       struct btrfs_block_group_cache *block_group,
@@ -176,6 +176,7 @@ static void le_bitmap_set(unsigned long *map, unsigned int start, int len)
 	}
 }
 
+EXPORT_FOR_TESTS
 int convert_free_space_to_bitmaps(struct btrfs_trans_handle *trans,
 				  struct btrfs_block_group_cache *block_group,
 				  struct btrfs_path *path)
@@ -315,6 +316,7 @@ int convert_free_space_to_bitmaps(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+EXPORT_FOR_TESTS
 int convert_free_space_to_extents(struct btrfs_trans_handle *trans,
 				  struct btrfs_block_group_cache *block_group,
 				  struct btrfs_path *path)
@@ -487,6 +489,7 @@ static int update_free_space_extent_count(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+EXPORT_FOR_TESTS
 int free_space_test_bit(struct btrfs_block_group_cache *block_group,
 			struct btrfs_path *path, u64 offset)
 {
@@ -775,6 +778,7 @@ static int remove_free_space_extent(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+EXPORT_FOR_TESTS
 int __remove_from_free_space_tree(struct btrfs_trans_handle *trans,
 				  struct btrfs_block_group_cache *block_group,
 				  struct btrfs_path *path, u64 start, u64 size)
@@ -968,7 +972,7 @@ static int add_free_space_extent(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-int __add_to_free_space_tree(struct btrfs_trans_handle *trans,
+EXPORT_FOR_TESTS int __add_to_free_space_tree(struct btrfs_trans_handle *trans,
 			     struct btrfs_block_group_cache *block_group,
 			     struct btrfs_path *path, u64 start, u64 size)
 {
diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index a99dc04331b4..ab7771b2a5fb 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -107,7 +107,7 @@ static int test_find_delalloc(u32 sectorsize)
 	set_extent_delalloc(&tmp, 0, sectorsize - 1, 0, NULL);
 	start = 0;
 	end = 0;
-	found = btrfs_find_lock_delalloc_range(inode, &tmp, locked_page, &start,
+	found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
 					 &end, max_bytes);
 	if (!found) {
 		test_err("should have found at least one delalloc");
@@ -138,7 +138,7 @@ static int test_find_delalloc(u32 sectorsize)
 	set_extent_delalloc(&tmp, sectorsize, max_bytes - 1, 0, NULL);
 	start = test_start;
 	end = 0;
-	found = btrfs_find_lock_delalloc_range(inode, &tmp, locked_page, &start,
+	found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
 					 &end, max_bytes);
 	if (!found) {
 		test_err("couldn't find delalloc in our range");
@@ -172,7 +172,7 @@ static int test_find_delalloc(u32 sectorsize)
 	}
 	start = test_start;
 	end = 0;
-	found = btrfs_find_lock_delalloc_range(inode, &tmp, locked_page, &start,
+	found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
 					 &end, max_bytes);
 	if (found) {
 		test_err("found range when we shouldn't have");
@@ -193,7 +193,7 @@ static int test_find_delalloc(u32 sectorsize)
 	set_extent_delalloc(&tmp, max_bytes, total_dirty - 1, 0, NULL);
 	start = test_start;
 	end = 0;
-	found = btrfs_find_lock_delalloc_range(inode, &tmp, locked_page, &start,
+	found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
 					 &end, max_bytes);
 	if (!found) {
 		test_err("didn't find our range");
@@ -234,7 +234,7 @@ static int test_find_delalloc(u32 sectorsize)
 	 * this changes at any point in the future we will need to fix this
 	 * tests expected behavior.
 	 */
-	found = btrfs_find_lock_delalloc_range(inode, &tmp, locked_page, &start,
+	found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
 					 &end, max_bytes);
 	if (!found) {
 		test_err("didn't find our range");
-- 
2.16.4

