Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49632 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755964AbdLGPtJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Dec 2017 10:49:09 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9E692AE11
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Dec 2017 15:49:08 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 4/4] btrfs: unify extent_page_data type passed as void
Date: Thu,  7 Dec 2017 16:47:09 +0100
Message-Id: <60e9d1bc997e3a29d70509c5ba4ca26acedc5a6b.1512661509.git.dsterba@suse.com>
In-Reply-To: <cover.1512661509.git.dsterba@suse.com>
References: <cover.1512661509.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Functions called from extent_write_cache_pages used void* as generic
callback data, but all of them convert it to extent_page_data, or use it
directly.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 47435256a8c3..6cfb25c30a2d 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -138,7 +138,7 @@ static void add_extent_changeset(struct extent_state *state, unsigned bits,
 	BUG_ON(ret < 0);
 }
 
-static void flush_write_bio(void *data);
+static void flush_write_bio(struct extent_page_data *epd);
 
 static inline struct btrfs_fs_info *
 tree_fs_info(struct extent_io_tree *tree)
@@ -3456,10 +3456,9 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
  * and the end_io handler clears the writeback ranges
  */
 static int __extent_writepage(struct page *page, struct writeback_control *wbc,
-			      void *data)
+			      struct extent_page_data *epd)
 {
 	struct inode *inode = page->mapping->host;
-	struct extent_page_data *epd = data;
 	u64 start = page_offset(page);
 	u64 page_end = start + PAGE_SIZE - 1;
 	int ret;
@@ -3905,7 +3904,7 @@ int btree_write_cache_pages(struct address_space *mapping,
  */
 static int extent_write_cache_pages(struct address_space *mapping,
 			     struct writeback_control *wbc,
-			     void *data)
+			     struct extent_page_data *epd)
 {
 	struct inode *inode = mapping->host;
 	int ret = 0;
@@ -3969,7 +3968,7 @@ static int extent_write_cache_pages(struct address_space *mapping,
 			 * mapping
 			 */
 			if (!trylock_page(page)) {
-				flush_write_bio(data);
+				flush_write_bio(epd);
 				lock_page(page);
 			}
 
@@ -3980,7 +3979,7 @@ static int extent_write_cache_pages(struct address_space *mapping,
 
 			if (wbc->sync_mode != WB_SYNC_NONE) {
 				if (PageWriteback(page))
-					flush_write_bio(data);
+					flush_write_bio(epd);
 				wait_on_page_writeback(page);
 			}
 
@@ -3990,7 +3989,7 @@ static int extent_write_cache_pages(struct address_space *mapping,
 				continue;
 			}
 
-			ret = __extent_writepage(page, wbc, data);
+			ret = __extent_writepage(page, wbc, epd);
 
 			if (unlikely(ret == AOP_WRITEPAGE_ACTIVATE)) {
 				unlock_page(page);
@@ -4038,10 +4037,8 @@ static int extent_write_cache_pages(struct address_space *mapping,
 	return ret;
 }
 
-static void flush_write_bio(void *data)
+static void flush_write_bio(struct extent_page_data *epd)
 {
-	struct extent_page_data *epd = data;
-
 	if (epd->bio) {
 		int ret;
 
-- 
2.15.1

