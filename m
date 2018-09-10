Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55104 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728021AbeIJWRt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Sep 2018 18:17:49 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A062EAF44
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Sep 2018 17:22:41 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/4] btrfs: tests: add separate stub for find_lock_delalloc_range
Date: Mon, 10 Sep 2018 19:22:24 +0200
Message-Id: <42d07540b52556af89366c9fee628829148bffac.1536599879.git.dsterba@suse.com>
In-Reply-To: <cover.1536599879.git.dsterba@suse.com>
References: <cover.1536599879.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The helper find_lock_delalloc_range is now conditionally built static,
dpending on whether the self-tests are enabled or not. There's a macro
that is suppsed to hide the export, used only once. To discourage
further use, drop it an add a public stub for the helper required by
tests.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h                 |  6 ------
 fs/btrfs/extent_io.c             | 13 ++++++++++++-
 fs/btrfs/extent_io.h             |  2 +-
 fs/btrfs/tests/extent-io-tests.c | 10 +++++-----
 4 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2cddfe7806a4..45b7029d0f23 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -41,12 +41,6 @@ extern struct kmem_cache *btrfs_path_cachep;
 extern struct kmem_cache *btrfs_free_space_cachep;
 struct btrfs_ordered_sum;
 
-#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
-#define STATIC noinline
-#else
-#define STATIC static noinline
-#endif
-
 #define BTRFS_MAGIC 0x4D5F53665248425FULL /* ascii _BHRfS_M, no null */
 
 #define BTRFS_MAX_MIRRORS 3
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 4dd6faab02bb..06e280d8750c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1568,7 +1568,7 @@ static noinline int lock_delalloc_pages(struct inode *inode,
  *
  * 1 is returned if we find something, 0 if nothing was in the tree
  */
-STATIC u64 find_lock_delalloc_range(struct inode *inode,
+static u64 find_lock_delalloc_range(struct inode *inode,
 				    struct extent_io_tree *tree,
 				    struct page *locked_page, u64 *start,
 				    u64 *end, u64 max_bytes)
@@ -1648,6 +1648,17 @@ STATIC u64 find_lock_delalloc_range(struct inode *inode,
 	return found;
 }
 
+#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
+u64 btrfs_find_lock_delalloc_range(struct inode *inode,
+				    struct extent_io_tree *tree,
+				    struct page *locked_page, u64 *start,
+				    u64 *end, u64 max_bytes)
+{
+	return find_lock_delalloc_range(inode, tree, locked_page, start, end,
+			max_bytes);
+}
+#endif
+
 static int __process_pages_contig(struct address_space *mapping,
 				  struct page *locked_page,
 				  pgoff_t start_index, pgoff_t end_index,
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index b4d03e677e1d..1a7fdcbca49b 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -546,7 +546,7 @@ int free_io_failure(struct extent_io_tree *failure_tree,
 		    struct extent_io_tree *io_tree,
 		    struct io_failure_record *rec);
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
-noinline u64 find_lock_delalloc_range(struct inode *inode,
+u64 btrfs_find_lock_delalloc_range(struct inode *inode,
 				      struct extent_io_tree *tree,
 				      struct page *locked_page, u64 *start,
 				      u64 *end, u64 max_bytes);
diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index d9269a531a4d..9e0f4a01be14 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -106,7 +106,7 @@ static int test_find_delalloc(u32 sectorsize)
 	set_extent_delalloc(&tmp, 0, sectorsize - 1, 0, NULL);
 	start = 0;
 	end = 0;
-	found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
+	found = btrfs_find_lock_delalloc_range(inode, &tmp, locked_page, &start,
 					 &end, max_bytes);
 	if (!found) {
 		test_err("should have found at least one delalloc");
@@ -137,7 +137,7 @@ static int test_find_delalloc(u32 sectorsize)
 	set_extent_delalloc(&tmp, sectorsize, max_bytes - 1, 0, NULL);
 	start = test_start;
 	end = 0;
-	found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
+	found = btrfs_find_lock_delalloc_range(inode, &tmp, locked_page, &start,
 					 &end, max_bytes);
 	if (!found) {
 		test_err("couldn't find delalloc in our range");
@@ -171,7 +171,7 @@ static int test_find_delalloc(u32 sectorsize)
 	}
 	start = test_start;
 	end = 0;
-	found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
+	found = btrfs_find_lock_delalloc_range(inode, &tmp, locked_page, &start,
 					 &end, max_bytes);
 	if (found) {
 		test_err("found range when we shouldn't have");
@@ -192,7 +192,7 @@ static int test_find_delalloc(u32 sectorsize)
 	set_extent_delalloc(&tmp, max_bytes, total_dirty - 1, 0, NULL);
 	start = test_start;
 	end = 0;
-	found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
+	found = btrfs_find_lock_delalloc_range(inode, &tmp, locked_page, &start,
 					 &end, max_bytes);
 	if (!found) {
 		test_err("didn't find our range");
@@ -233,7 +233,7 @@ static int test_find_delalloc(u32 sectorsize)
 	 * this changes at any point in the future we will need to fix this
 	 * tests expected behavior.
 	 */
-	found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
+	found = btrfs_find_lock_delalloc_range(inode, &tmp, locked_page, &start,
 					 &end, max_bytes);
 	if (!found) {
 		test_err("didn't find our range");
-- 
2.18.0
