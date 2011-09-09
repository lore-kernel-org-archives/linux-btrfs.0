From: jeffm@suse.com
Subject: [patch v3 12/23] btrfs: extent_io.c: Make functions with no error conditions return void
Date: Thu, 08 Sep 2011 20:22:52 -0400
Message-ID: <20110909002732.013387483@suse.com>
References: <20110909002240.141223014@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: btrfs list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 wait_on_state, wait_extent_bit, __unlock_for_delalloc, check_page_uptodate,
 check_page_locked, check_page_writeback, and clear_extent_buffer_dirty
 have no error conditions and should return void.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent_io.c |   29 ++++++++++-------------------
 fs/btrfs/extent_io.h |    6 +++---
 2 files changed, 13 insertions(+), 22 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -613,8 +613,8 @@ search_again:
 	goto again;
 }
 
-static int wait_on_state(struct extent_io_tree *tree,
-			 struct extent_state *state)
+static void wait_on_state(struct extent_io_tree *tree,
+			  struct extent_state *state)
 		__releases(tree->lock)
 		__acquires(tree->lock)
 {
@@ -624,7 +624,6 @@ static int wait_on_state(struct extent_i
 	schedule();
 	spin_lock(&tree->lock);
 	finish_wait(&state->wq, &wait);
-	return 0;
 }
 
 /*
@@ -632,7 +631,7 @@ static int wait_on_state(struct extent_i
  * The range [start, end] is inclusive.
  * The tree lock is taken by this function
  */
-int wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits)
+void wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits)
 {
 	struct extent_state *state;
 	struct rb_node *node;
@@ -669,7 +668,6 @@ again:
 	}
 out:
 	spin_unlock(&tree->lock);
-	return 0;
 }
 
 static void set_state_bits(struct extent_io_tree *tree,
@@ -1197,7 +1195,7 @@ out:
 	return found;
 }
 
-static noinline int __unlock_for_delalloc(struct inode *inode,
+static noinline void __unlock_for_delalloc(struct inode *inode,
 					  struct page *locked_page,
 					  u64 start, u64 end)
 {
@@ -1209,7 +1207,7 @@ static noinline int __unlock_for_delallo
 	int i;
 
 	if (index == locked_page->index && end_index == index)
-		return 0;
+		return;
 
 	while (nr_pages > 0) {
 		ret = find_get_pages_contig(inode->i_mapping, index,
@@ -1224,7 +1222,6 @@ static noinline int __unlock_for_delallo
 		index += ret;
 		cond_resched();
 	}
-	return 0;
 }
 
 static noinline int lock_delalloc_pages(struct inode *inode,
@@ -1619,39 +1616,34 @@ int test_range_bit(struct extent_io_tree
  * helper function to set a given page up to date if all the
  * extents in the tree for that page are up to date
  */
-static int check_page_uptodate(struct extent_io_tree *tree,
-			       struct page *page)
+static void check_page_uptodate(struct extent_io_tree *tree, struct page *page)
 {
 	u64 start = (u64)page->index << PAGE_CACHE_SHIFT;
 	u64 end = start + PAGE_CACHE_SIZE - 1;
 	if (test_range_bit(tree, start, end, EXTENT_UPTODATE, 1, NULL))
 		SetPageUptodate(page);
-	return 0;
 }
 
 /*
  * helper function to unlock a page if all the extents in the tree
  * for that page are unlocked
  */
-static int check_page_locked(struct extent_io_tree *tree,
-			     struct page *page)
+static void check_page_locked(struct extent_io_tree *tree, struct page *page)
 {
 	u64 start = (u64)page->index << PAGE_CACHE_SHIFT;
 	u64 end = start + PAGE_CACHE_SIZE - 1;
 	if (!test_range_bit(tree, start, end, EXTENT_LOCKED, 0, NULL))
 		unlock_page(page);
-	return 0;
 }
 
 /*
  * helper function to end page writeback if all the extents
  * in the tree for that page are done with writeback
  */
-static int check_page_writeback(struct extent_io_tree *tree,
-			     struct page *page)
+static void check_page_writeback(struct extent_io_tree *tree,
+				 struct page *page)
 {
 	end_page_writeback(page);
-	return 0;
 }
 
 /* lots and lots of room for performance fixes in the end_bio funcs */
@@ -3251,7 +3243,7 @@ void free_extent_buffer(struct extent_bu
 	WARN_ON(1);
 }
 
-int clear_extent_buffer_dirty(struct extent_io_tree *tree,
+void clear_extent_buffer_dirty(struct extent_io_tree *tree,
 			      struct extent_buffer *eb)
 {
 	unsigned long i;
@@ -3282,7 +3274,6 @@ int clear_extent_buffer_dirty(struct ext
 		spin_unlock_irq(&page->mapping->tree_lock);
 		unlock_page(page);
 	}
-	return 0;
 }
 
 int set_extent_buffer_dirty(struct extent_io_tree *tree,
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -274,9 +274,9 @@ void memmove_extent_buffer(struct extent
 			   unsigned long src_offset, unsigned long len);
 void memset_extent_buffer(struct extent_buffer *eb, char c,
 			  unsigned long start, unsigned long len);
-int wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits);
-int clear_extent_buffer_dirty(struct extent_io_tree *tree,
-			      struct extent_buffer *eb);
+void wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits);
+void clear_extent_buffer_dirty(struct extent_io_tree *tree,
+			       struct extent_buffer *eb);
 int set_extent_buffer_dirty(struct extent_io_tree *tree,
 			     struct extent_buffer *eb);
 int set_extent_buffer_uptodate(struct extent_io_tree *tree,


