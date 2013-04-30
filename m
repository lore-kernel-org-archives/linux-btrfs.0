Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:46895 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759848Ab3D3M7Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Apr 2013 08:59:16 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 3D5FA7C067E
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Apr 2013 06:59:15 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id JXQ7g8SfKWmkgN8u (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 30 Apr 2013 06:59:14 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: cleanup destroy_marked_extents V3
Date: Tue, 30 Apr 2013 08:59:12 -0400
Message-ID: <1367326752-7707-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can just look up the extent_buffers for the range and free stuff that way.
This makes the cleanup a bit cleaner and we can make sure to evict the
extent_buffers pretty quickly by marking them as stale.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
V2->V3: I wanted to use root->leafsize, I knew thats what I needed and thats
what I typed, but for some reason my hands translated that to eb->len so here we
are again.

 fs/btrfs/disk-io.c   |   40 +++++++++-------------------------------
 fs/btrfs/extent_io.c |    2 +-
 fs/btrfs/extent_io.h |    1 +
 3 files changed, 11 insertions(+), 32 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8be8d5e..618497a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3804,13 +3804,9 @@ static int btrfs_destroy_marked_extents(struct btrfs_root *root,
 					int mark)
 {
 	int ret;
-	struct page *page;
-	struct inode *btree_inode = root->fs_info->btree_inode;
 	struct extent_buffer *eb;
 	u64 start = 0;
 	u64 end;
-	u64 offset;
-	unsigned long index;
 
 	while (1) {
 		ret = find_first_extent_bit(dirty_pages, start, &start, &end,
@@ -3820,35 +3816,17 @@ static int btrfs_destroy_marked_extents(struct btrfs_root *root,
 
 		clear_extent_bits(dirty_pages, start, end, mark, GFP_NOFS);
 		while (start <= end) {
-			index = start >> PAGE_CACHE_SHIFT;
-			start = (u64)(index + 1) << PAGE_CACHE_SHIFT;
-			page = find_get_page(btree_inode->i_mapping, index);
-			if (!page)
+			eb = btrfs_find_tree_block(root, start,
+						   root->leafsize);
+			start += root->leafsize;
+			if (!eb)
 				continue;
-			offset = page_offset(page);
-
-			spin_lock(&dirty_pages->buffer_lock);
-			eb = radix_tree_lookup(
-			     &(&BTRFS_I(page->mapping->host)->io_tree)->buffer,
-					       offset >> PAGE_CACHE_SHIFT);
-			spin_unlock(&dirty_pages->buffer_lock);
-			if (eb)
-				ret = test_and_clear_bit(EXTENT_BUFFER_DIRTY,
-							 &eb->bflags);
-			lock_page(page);
-
-			wait_on_page_writeback(page);
-			if (PageDirty(page)) {
-				clear_page_dirty_for_io(page);
-				spin_lock_irq(&page->mapping->tree_lock);
-				radix_tree_tag_clear(&page->mapping->page_tree,
-							page_index(page),
-							PAGECACHE_TAG_DIRTY);
-				spin_unlock_irq(&page->mapping->tree_lock);
-			}
+			wait_on_extent_buffer_writeback(eb);
 
-			unlock_page(page);
-			page_cache_release(page);
+			if (test_and_clear_bit(EXTENT_BUFFER_DIRTY,
+					       &eb->bflags))
+				clear_extent_buffer_dirty(eb);
+			free_extent_buffer_stale(eb);
 		}
 	}
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 2107a06..d9a82f2 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3162,7 +3162,7 @@ static int eb_wait(void *word)
 	return 0;
 }
 
-static void wait_on_extent_buffer_writeback(struct extent_buffer *eb)
+void wait_on_extent_buffer_writeback(struct extent_buffer *eb)
 {
 	wait_on_bit(&eb->bflags, EXTENT_BUFFER_WRITEBACK, eb_wait,
 		    TASK_UNINTERRUPTIBLE);
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index db009d8..fa86861 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -282,6 +282,7 @@ void free_extent_buffer_stale(struct extent_buffer *eb);
 int read_extent_buffer_pages(struct extent_io_tree *tree,
 			     struct extent_buffer *eb, u64 start, int wait,
 			     get_extent_t *get_extent, int mirror_num);
+void wait_on_extent_buffer_writeback(struct extent_buffer *eb);
 
 static inline unsigned long num_extent_pages(u64 start, u64 len)
 {
-- 
1.7.7.6

