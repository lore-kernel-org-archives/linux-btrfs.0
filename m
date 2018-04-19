Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54141 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751210AbeDSHqn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 03:46:43 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C119BADCC
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Apr 2018 07:46:41 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/6] btrfs: Sink extent_tree arguments in try_release_extent_mapping
Date: Thu, 19 Apr 2018 10:46:34 +0300
Message-Id: <1524123999-4220-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function already gets the page from which the two extent trees
are referenced. Simplify its signature by moving the code getting the
trees inside the function. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent_io.c | 6 +++---
 fs/btrfs/extent_io.h | 4 +---
 fs/btrfs/inode.c     | 8 +-------
 3 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index fb32394fd830..9e72e4048acd 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4238,13 +4238,13 @@ static int try_release_extent_state(struct extent_map_tree *map,
  * in the range corresponding to the page, both state records and extent
  * map records are removed
  */
-int try_release_extent_mapping(struct extent_map_tree *map,
-			       struct extent_io_tree *tree, struct page *page,
-			       gfp_t mask)
+int try_release_extent_mapping(struct page *page, gfp_t mask)
 {
 	struct extent_map *em;
 	u64 start = page_offset(page);
 	u64 end = start + PAGE_SIZE - 1;
+	struct extent_io_tree *tree = &BTRFS_I(page->mapping->host)->io_tree;
+	struct extent_map_tree *map = &BTRFS_I(page->mapping->host)->extent_tree;
 
 	if (gfpflags_allow_blocking(mask) &&
 	    page->mapping->host->i_size > SZ_16M) {
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index a53009694b16..cf131fcbecc1 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -278,9 +278,7 @@ typedef struct extent_map *(get_extent_t)(struct btrfs_inode *inode,
 					  int create);
 
 void extent_io_tree_init(struct extent_io_tree *tree, void *private_data);
-int try_release_extent_mapping(struct extent_map_tree *map,
-			       struct extent_io_tree *tree, struct page *page,
-			       gfp_t mask);
+int try_release_extent_mapping(struct page *page, gfp_t mask);
 int try_release_extent_buffer(struct page *page);
 int lock_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
 		     struct extent_state **cached);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1c6e997d1d3c..a5b8229aa2d8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8746,13 +8746,7 @@ btrfs_readpages(struct file *file, struct address_space *mapping,
 }
 static int __btrfs_releasepage(struct page *page, gfp_t gfp_flags)
 {
-	struct extent_io_tree *tree;
-	struct extent_map_tree *map;
-	int ret;
-
-	tree = &BTRFS_I(page->mapping->host)->io_tree;
-	map = &BTRFS_I(page->mapping->host)->extent_tree;
-	ret = try_release_extent_mapping(map, tree, page, gfp_flags);
+	int ret = try_release_extent_mapping(page, gfp_flags);
 	if (ret == 1) {
 		ClearPagePrivate(page);
 		set_page_private(page, 0);
-- 
2.7.4

