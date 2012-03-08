From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: set page->private to the eb
Date: Thu, 8 Mar 2012 13:37:00 -0500
Message-ID: <20120308183659.GA2648@dhcp231-144.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We spend a lot of time looking up extent buffers from pages when we could just
store the pointer to the eb the page is associated with in page->private.  This
patch does just that, and it makes things a little simpler and reduces a bit of
CPU overhead involved with doing metadata IO.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/disk-io.c   |   92 ++++++++++++-------------------------------------
 fs/btrfs/extent_io.c |   92 ++++++++++++++++++++++++++++++++++++-------------
 fs/btrfs/extent_io.h |    1 +
 3 files changed, 91 insertions(+), 94 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 33114bc..6f97129 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -403,39 +403,28 @@ static int csum_dirty_buffer(struct btrfs_root *root, struct page *page)
 	struct extent_io_tree *tree;
 	u64 start = (u64)page->index << PAGE_CACHE_SHIFT;
 	u64 found_start;
-	unsigned long len;
 	struct extent_buffer *eb;
 
 	tree = &BTRFS_I(page->mapping->host)->io_tree;
 
-	if (page->private == EXTENT_PAGE_PRIVATE)
-		goto out;
-	if (!page->private) {
-		WARN_ON(1);
-		goto out;
-	}
-	len = page->private >> 2;
-	WARN_ON(len == 0);
-
-	eb = find_extent_buffer(tree, start, len);
+	eb = (struct extent_buffer *)page->private;
+	if (page != eb->pages[0])
+		return 0;
 
 	found_start = btrfs_header_bytenr(eb);
 	if (found_start != start) {
 		WARN_ON(1);
-		goto err;
+		return 0;
 	}
 	if (eb->pages[0] != page) {
 		WARN_ON(1);
-		goto err;
+		return 0;
 	}
 	if (!PageUptodate(page)) {
 		WARN_ON(1);
-		goto err;
+		return 0;
 	}
 	csum_tree_block(root, eb, 0);
-err:
-	free_extent_buffer(eb);
-out:
 	return 0;
 }
 
@@ -566,7 +555,6 @@ static int btree_readpage_end_io_hook(struct page *page, u64 start, u64 end,
 	struct extent_io_tree *tree;
 	u64 found_start;
 	int found_level;
-	unsigned long len;
 	struct extent_buffer *eb;
 	struct btrfs_root *root = BTRFS_I(page->mapping->host)->root;
 	int ret = 0;
@@ -576,13 +564,8 @@ static int btree_readpage_end_io_hook(struct page *page, u64 start, u64 end,
 		goto out;
 
 	tree = &BTRFS_I(page->mapping->host)->io_tree;
-	len = page->private >> 2;
+	eb = (struct extent_buffer *)page->private;
 
-	eb = find_eb_for_page(tree, page, max(root->leafsize, root->nodesize));
-	if (!eb) {
-		ret = -EIO;
-		goto out;
-	}
 	reads_done = atomic_dec_and_test(&eb->pages_reading);
 	if (!reads_done)
 		goto err;
@@ -631,7 +614,6 @@ err:
 
 	if (ret && eb)
 		clear_extent_buffer_uptodate(tree, eb, NULL);
-	free_extent_buffer(eb);
 out:
 	return ret;
 }
@@ -640,31 +622,17 @@ static int btree_io_failed_hook(struct bio *failed_bio,
 			 struct page *page, u64 start, u64 end,
 			 int mirror_num, struct extent_state *state)
 {
-	struct extent_io_tree *tree;
-	unsigned long len;
 	struct extent_buffer *eb;
 	struct btrfs_root *root = BTRFS_I(page->mapping->host)->root;
 
-	tree = &BTRFS_I(page->mapping->host)->io_tree;
-	if (page->private == EXTENT_PAGE_PRIVATE)
-		goto out;
-	if (!page->private)
-		goto out;
-
-	len = page->private >> 2;
-	WARN_ON(len == 0);
-
-	eb = alloc_extent_buffer(tree, start, len);
-	if (eb == NULL)
-		goto out;
+	eb = (struct extent_buffer *)page->private;
+	if (page != eb->pages[0])
+		return -EIO;
 
 	if (test_bit(EXTENT_BUFFER_READAHEAD, &eb->bflags)) {
 		clear_bit(EXTENT_BUFFER_READAHEAD, &eb->bflags);
 		btree_readahead_hook(root, eb, eb->start, -EIO);
 	}
-	free_extent_buffer(eb);
-
-out:
 	return -EIO;	/* we fixed nothing */
 }
 
@@ -955,10 +923,8 @@ static int btree_readpage(struct file *file, struct page *page)
 
 static int btree_releasepage(struct page *page, gfp_t gfp_flags)
 {
-	struct extent_io_tree *tree;
 	struct extent_map_tree *map;
-	struct extent_buffer *eb;
-	struct btrfs_root *root;
+	struct extent_io_tree *tree;
 	int ret;
 
 	if (PageWriteback(page) || PageDirty(page))
@@ -967,26 +933,11 @@ static int btree_releasepage(struct page *page, gfp_t gfp_flags)
 	tree = &BTRFS_I(page->mapping->host)->io_tree;
 	map = &BTRFS_I(page->mapping->host)->extent_tree;
 
-	root = BTRFS_I(page->mapping->host)->root;
-	if (page->private == EXTENT_PAGE_PRIVATE) {
-		eb = find_eb_for_page(tree, page, max(root->leafsize, root->nodesize));
-		free_extent_buffer(eb);
-		if (eb)
-			return 0;
-	}
-
 	ret = try_release_extent_state(map, tree, page, gfp_flags);
 	if (!ret)
 		return 0;
 
-	ret = try_release_extent_buffer(tree, page);
-	if (ret == 1) {
-		ClearPagePrivate(page);
-		set_page_private(page, 0);
-		page_cache_release(page);
-	}
-
-	return ret;
+	return try_release_extent_buffer(tree, page);
 }
 
 static void btree_invalidatepage(struct page *page, unsigned long offset)
@@ -3173,17 +3124,21 @@ static int btree_lock_page_hook(struct page *page, void *data,
 {
 	struct inode *inode = page->mapping->host;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct extent_buffer *eb;
-	unsigned long len;
-	u64 bytenr = page_offset(page);
 
-	if (page->private == EXTENT_PAGE_PRIVATE)
+	/*
+	 * We culled this eb but the page is still hanging out on the mapping,
+	 * carry on.
+	 */
+	if (!PagePrivate(page))
 		goto out;
 
-	len = page->private >> 2;
-	eb = find_extent_buffer(io_tree, bytenr, len);
-	if (!eb)
+	eb = (struct extent_buffer *)page->private;
+	if (!eb) {
+		WARN_ON(1);
+		goto out;
+	}
+	if (page != eb->pages[0])
 		goto out;
 
 	if (!btrfs_try_tree_write_lock(eb)) {
@@ -3202,7 +3157,6 @@ static int btree_lock_page_hook(struct page *page, void *data,
 	}
 
 	btrfs_tree_unlock(eb);
-	free_extent_buffer(eb);
 out:
 	if (!trylock_page(page)) {
 		flush_fn(data);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d4795fc..197595a 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2462,19 +2462,24 @@ static int submit_extent_page(int rw, struct extent_io_tree *tree,
 	return ret;
 }
 
-void set_page_extent_mapped(struct page *page)
+void attach_extent_buffer_page(struct extent_buffer *eb, struct page *page)
 {
 	if (!PagePrivate(page)) {
 		SetPagePrivate(page);
 		page_cache_get(page);
-		set_page_private(page, EXTENT_PAGE_PRIVATE);
+		set_page_private(page, (unsigned long)eb);
+	} else {
+		WARN_ON(page->private != (unsigned long)eb);
 	}
 }
 
-static void set_page_extent_head(struct page *page, unsigned long len)
+void set_page_extent_mapped(struct page *page)
 {
-	WARN_ON(!PagePrivate(page));
-	set_page_private(page, EXTENT_PAGE_PRIVATE_FIRST_PAGE | len << 2);
+	if (!PagePrivate(page)) {
+		SetPagePrivate(page);
+		page_cache_get(page);
+		set_page_private(page, EXTENT_PAGE_PRIVATE);
+	}
 }
 
 /*
@@ -3567,6 +3572,7 @@ static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
 		return NULL;
 	eb->start = start;
 	eb->len = len;
+	eb->tree = tree;
 	rwlock_init(&eb->lock);
 	atomic_set(&eb->write_locks, 0);
 	atomic_set(&eb->read_locks, 0);
@@ -3619,8 +3625,31 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb,
 	do {
 		index--;
 		page = extent_buffer_page(eb, index);
-		if (page)
+		if (page) {
+			spin_lock(&page->mapping->private_lock);
+			/*
+			 * We do this since we'll remove the pages after we've
+			 * removed the eb from the radix tree, so we could race
+			 * and have this page now attached to the new eb.  So
+			 * only clear page_private if it's still connected to
+			 * this eb.
+			 */
+			if (PagePrivate(page) &&
+			    page->private == (unsigned long)eb) {
+				/*
+				 * We need to make sure we haven't be attached
+				 * to a new eb.
+				 */
+				ClearPagePrivate(page);
+				set_page_private(page, 0);
+				/* One for the page private */
+				page_cache_release(page);
+			}
+			spin_unlock(&page->mapping->private_lock);
+
+			/* One for when we alloced the page */
 			page_cache_release(page);
+		}
 	} while (index != start_idx);
 }
 
@@ -3665,6 +3694,32 @@ struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
 			WARN_ON(1);
 			goto free_eb;
 		}
+
+		spin_lock(&mapping->private_lock);
+		if (PagePrivate(p)) {
+			/*
+			 * We could have already allocated an eb for this page
+			 * and attached one so lets see if we can get a ref on
+			 * the existing eb, and if we can we know it's good and
+			 * we can just return that one, else we know we can just
+			 * overwrite page->private.
+			 */
+			exists = (struct extent_buffer *)p->private;
+			if (atomic_inc_not_zero(&exists->refs)) {
+				spin_unlock(&mapping->private_lock);
+				unlock_page(p);
+				goto free_eb;
+			}
+
+			/* 
+			 * Do this so attach doesn't complain and we need to
+			 * drop the ref the old guy had.
+			 */
+			ClearPagePrivate(p);
+			page_cache_release(p);
+		}
+		attach_extent_buffer_page(eb, p);
+		spin_unlock(&mapping->private_lock);
 		mark_page_accessed(p);
 		eb->pages[i] = p;
 		if (!PageUptodate(p))
@@ -3687,7 +3742,6 @@ struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
 	if (ret == -EEXIST) {
 		exists = radix_tree_lookup(&tree->buffer,
 						start >> PAGE_CACHE_SHIFT);
-		/* add one reference for the caller */
 		atomic_inc(&exists->refs);
 		spin_unlock(&tree->buffer_lock);
 		radix_tree_preload_end();
@@ -3707,12 +3761,9 @@ struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
 	 * after the extent buffer is in the radix tree so
 	 * it doesn't get lost
 	 */
-	set_page_extent_mapped(eb->pages[0]);
-	set_page_extent_head(eb->pages[0], eb->len);
 	SetPageChecked(eb->pages[0]);
 	for (i = 1; i < num_pages; i++) {
 		p = extent_buffer_page(eb, i);
-		set_page_extent_mapped(p);
 		ClearPageChecked(p);
 		unlock_page(p);
 	}
@@ -3776,10 +3827,6 @@ int clear_extent_buffer_dirty(struct extent_io_tree *tree,
 		lock_page(page);
 		WARN_ON(!PagePrivate(page));
 
-		set_page_extent_mapped(page);
-		if (i == 0)
-			set_page_extent_head(page, eb->len);
-
 		clear_page_dirty_for_io(page);
 		spin_lock_irq(&page->mapping->tree_lock);
 		if (!PageDirty(page)) {
@@ -3991,9 +4038,6 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 	atomic_set(&eb->pages_reading, num_reads);
 	for (i = start_i; i < num_pages; i++) {
 		page = extent_buffer_page(eb, i);
-		set_page_extent_mapped(page);
-		if (i == 0)
-			set_page_extent_head(page, eb->len);
 		if (!PageUptodate(page)) {
 			ClearPageError(page);
 			err = __extent_read_full_page(tree, page,
@@ -4376,22 +4420,19 @@ static inline void btrfs_release_extent_buffer_rcu(struct rcu_head *head)
 	struct extent_buffer *eb =
 			container_of(head, struct extent_buffer, rcu_head);
 
-	btrfs_release_extent_buffer(eb);
+	__free_extent_buffer(eb);
 }
 
 int try_release_extent_buffer(struct extent_io_tree *tree, struct page *page)
 {
 	u64 start = page_offset(page);
-	struct extent_buffer *eb;
+	struct extent_buffer *eb = (struct extent_buffer *)page->private;
 	int ret = 1;
 
-	spin_lock(&tree->buffer_lock);
-	eb = radix_tree_lookup(&tree->buffer, start >> PAGE_CACHE_SHIFT);
-	if (!eb) {
-		spin_unlock(&tree->buffer_lock);
-		return ret;
-	}
+	if (!PagePrivate(page) || !eb)
+		return 1;
 
+	spin_lock(&tree->buffer_lock);
 	if (atomic_read(&eb->refs) > 1 ||
 	    test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags)) {
 		ret = 0;
@@ -4407,6 +4448,7 @@ int try_release_extent_buffer(struct extent_io_tree *tree, struct page *page)
 		goto out;
 	}
 	radix_tree_delete(&tree->buffer, start >> PAGE_CACHE_SHIFT);
+	btrfs_release_extent_buffer_page(eb, 0);
 out:
 	spin_unlock(&tree->buffer_lock);
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 9b6c8f3..f030a2d 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -127,6 +127,7 @@ struct extent_buffer {
 	unsigned long map_start;
 	unsigned long map_len;
 	unsigned long bflags;
+	struct extent_io_tree *tree;
 	atomic_t refs;
 	atomic_t pages_reading;
 	struct list_head leak_list;
-- 
1.7.7.5

