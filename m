From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: convert refs and pages_reading to ints
Date: Fri,  9 Mar 2012 11:06:37 -0500
Message-ID: <1331309197-5389-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I need to be able to safely deal with refs in my next patch, so convert refs and
pages_reading to ints and introduce an eb_lock spinlock so I can use this to
safely manipulate the refs count when marking eb's as stale.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/backref.c           |    4 +-
 fs/btrfs/disk-io.c           |    8 +++++-
 fs/btrfs/extent_io.c         |   49 ++++++++++++++++++++++-------------------
 fs/btrfs/extent_io.h         |   22 ++++++++++++++++--
 include/trace/events/btrfs.h |    2 +-
 5 files changed, 54 insertions(+), 31 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index b9a8432..04cf24d 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -904,7 +904,7 @@ static char *iref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
 		eb = path->nodes[0];
 		/* make sure we can use eb after releasing the path */
 		if (eb != eb_in)
-			atomic_inc(&eb->refs);
+			extent_buffer_get(eb);
 		btrfs_release_path(path);
 
 		iref = btrfs_item_ptr(eb, slot, struct btrfs_inode_ref);
@@ -1251,7 +1251,7 @@ static int iterate_irefs(u64 inum, struct btrfs_root *fs_root,
 		slot = path->slots[0];
 		eb = path->nodes[0];
 		/* make sure we can use eb after releasing the path */
-		atomic_inc(&eb->refs);
+		extent_buffer_get(eb);
 		btrfs_release_path(path);
 
 		item = btrfs_item_nr(eb, slot);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6f97129..b8f2284 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -566,7 +566,9 @@ static int btree_readpage_end_io_hook(struct page *page, u64 start, u64 end,
 	tree = &BTRFS_I(page->mapping->host)->io_tree;
 	eb = (struct extent_buffer *)page->private;
 
-	reads_done = atomic_dec_and_test(&eb->pages_reading);
+	spin_lock(&eb->eb_lock);
+	reads_done = (--eb->pages_reading == 0);
+	spin_unlock(&eb->eb_lock);
 	if (!reads_done)
 		goto err;
 
@@ -3391,7 +3393,9 @@ static int btrfs_destroy_marked_extents(struct btrfs_root *root,
 			if (eb) {
 				ret = test_and_clear_bit(EXTENT_BUFFER_DIRTY,
 							 &eb->bflags);
-				atomic_set(&eb->refs, 1);
+				spin_lock(&eb->eb_lock);
+				eb->refs = 1;
+				spin_unlock(&eb->eb_lock);
 			}
 			if (PageWriteback(page))
 				end_page_writeback(page);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 6d948eb..f6f31b6 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -94,7 +94,7 @@ void extent_io_exit(void)
 		eb = list_entry(buffers.next, struct extent_buffer, leak_list);
 		printk(KERN_ERR "btrfs buffer leak start %llu len %lu "
 		       "refs %d\n", (unsigned long long)eb->start,
-		       eb->len, atomic_read(&eb->refs));
+		       eb->len, eb->refs);
 		list_del(&eb->leak_list);
 		kmem_cache_free(extent_buffer_cache, eb);
 	}
@@ -3573,6 +3573,7 @@ static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
 	eb->start = start;
 	eb->len = len;
 	eb->tree = tree;
+	spin_lock_init(&eb->eb_lock);
 	rwlock_init(&eb->lock);
 	atomic_set(&eb->write_locks, 0);
 	atomic_set(&eb->read_locks, 0);
@@ -3589,8 +3590,8 @@ static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
 	list_add(&eb->leak_list, &buffers);
 	spin_unlock_irqrestore(&leak_lock, flags);
 #endif
-	atomic_set(&eb->refs, 1);
-	atomic_set(&eb->pages_reading, 0);
+	eb->refs = 1;
+	eb->pages_reading = 0;
 
 	if (len > MAX_INLINE_EXTENT_BUFFER_SIZE) {
 		struct page **pages;
@@ -3677,7 +3678,7 @@ struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
 
 	rcu_read_lock();
 	eb = radix_tree_lookup(&tree->buffer, start >> PAGE_CACHE_SHIFT);
-	if (eb && atomic_inc_not_zero(&eb->refs)) {
+	if (eb && extent_buffer_inc_not_zero(eb)) {
 		rcu_read_unlock();
 		mark_page_accessed(eb->pages[0]);
 		return eb;
@@ -3705,7 +3706,7 @@ struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
 			 * overwrite page->private.
 			 */
 			exists = (struct extent_buffer *)p->private;
-			if (atomic_inc_not_zero(&exists->refs)) {
+			if (extent_buffer_inc_not_zero(exists)) {
 				spin_unlock(&mapping->private_lock);
 				unlock_page(p);
 				goto free_eb;
@@ -3742,7 +3743,7 @@ again:
 	if (ret == -EEXIST) {
 		exists = radix_tree_lookup(&tree->buffer,
 						start >> PAGE_CACHE_SHIFT);
-		if (!atomic_inc_not_zero(&exists->refs)) {
+		if (!extent_buffer_inc_not_zero(exists)) {
 			spin_unlock(&tree->buffer_lock);
 			radix_tree_preload_end();
 			synchronize_rcu();
@@ -3754,7 +3755,7 @@ again:
 		goto free_eb;
 	}
 	/* add one reference for the tree */
-	atomic_inc(&eb->refs);
+	extent_buffer_get(eb);
 	spin_unlock(&tree->buffer_lock);
 	radix_tree_preload_end();
 
@@ -3782,8 +3783,7 @@ free_eb:
 			unlock_page(eb->pages[i]);
 	}
 
-	if (!atomic_dec_and_test(&eb->refs))
-		return exists;
+	/* The ref count of eb can only be 1 at this point, just release it */
 	btrfs_release_extent_buffer(eb);
 	return exists;
 }
@@ -3795,7 +3795,7 @@ struct extent_buffer *find_extent_buffer(struct extent_io_tree *tree,
 
 	rcu_read_lock();
 	eb = radix_tree_lookup(&tree->buffer, start >> PAGE_CACHE_SHIFT);
-	if (eb && atomic_inc_not_zero(&eb->refs)) {
+	if (eb && extent_buffer_inc_not_zero(eb)) {
 		rcu_read_unlock();
 		mark_page_accessed(eb->pages[0]);
 		return eb;
@@ -3810,8 +3810,12 @@ void free_extent_buffer(struct extent_buffer *eb)
 	if (!eb)
 		return;
 
-	if (!atomic_dec_and_test(&eb->refs))
+	spin_lock(&eb->eb_lock);
+	if (--eb->refs != 0) {
+		spin_unlock(&eb->eb_lock);
 		return;
+	}
+	spin_unlock(&eb->eb_lock);
 
 	WARN_ON(1);
 }
@@ -4041,7 +4045,9 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 		goto unlock_exit;
 	}
 
-	atomic_set(&eb->pages_reading, num_reads);
+	spin_lock(&eb->eb_lock);
+	eb->pages_reading = num_reads;
+	spin_unlock(&eb->eb_lock);
 	for (i = start_i; i < num_pages; i++) {
 		page = extent_buffer_page(eb, i);
 		if (!PageUptodate(page)) {
@@ -4434,32 +4440,29 @@ int try_release_extent_buffer(struct extent_io_tree *tree, struct page *page)
 	u64 start = page_offset(page);
 	struct extent_buffer *eb = (struct extent_buffer *)page->private;
 	int ret = 1;
+	int release = 0;
 
 	if (!PagePrivate(page) || !eb)
 		return 1;
 
 	spin_lock(&tree->buffer_lock);
-	if (atomic_read(&eb->refs) > 1 ||
-	    test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags)) {
+	spin_lock(&eb->eb_lock);
+	if (eb->refs > 1 || test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags)) {
+		spin_unlock(&eb->eb_lock);
 		ret = 0;
 		goto out;
 	}
+	eb->refs--;
+	release = 1;
+	spin_unlock(&eb->eb_lock);
 
-	/*
-	 * set @eb->refs to 0 if it is already 1, and then release the @eb.
-	 * Or go back.
-	 */
-	if (atomic_cmpxchg(&eb->refs, 1, 0) != 1) {
-		ret = 0;
-		goto out;
-	}
 	radix_tree_delete(&tree->buffer, start >> PAGE_CACHE_SHIFT);
 	btrfs_release_extent_buffer_page(eb, 0);
 out:
 	spin_unlock(&tree->buffer_lock);
 
 	/* at this point we can safely release the extent buffer */
-	if (atomic_read(&eb->refs) == 0)
+	if (release)
 		call_rcu(&eb->rcu_head, btrfs_release_extent_buffer_rcu);
 	return ret;
 }
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index f030a2d..d11e872 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -128,8 +128,9 @@ struct extent_buffer {
 	unsigned long map_len;
 	unsigned long bflags;
 	struct extent_io_tree *tree;
-	atomic_t refs;
-	atomic_t pages_reading;
+	spinlock_t eb_lock;
+	int refs;
+	int pages_reading;
 	struct list_head leak_list;
 	struct rcu_head rcu_head;
 	pid_t lock_owner;
@@ -272,7 +273,22 @@ struct page *extent_buffer_page(struct extent_buffer *eb, unsigned long i);
 
 static inline void extent_buffer_get(struct extent_buffer *eb)
 {
-	atomic_inc(&eb->refs);
+	spin_lock(&eb->eb_lock);
+	eb->refs++;
+	spin_unlock(&eb->eb_lock);
+}
+
+static inline int extent_buffer_inc_not_zero(struct extent_buffer *eb)
+{
+	int ret = 0;
+
+	spin_lock(&eb->eb_lock);
+	if (eb->refs) {
+		eb->refs++;
+		ret = 1;
+	}
+	spin_unlock(&eb->eb_lock);
+	return ret;
 }
 
 int memcmp_extent_buffer(struct extent_buffer *eb, const void *ptrv,
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 84f3001..b4b04e7 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -618,7 +618,7 @@ TRACE_EVENT(btrfs_cow_block,
 	TP_fast_assign(
 		__entry->root_objectid	= root->root_key.objectid;
 		__entry->buf_start	= buf->start;
-		__entry->refs		= atomic_read(&buf->refs);
+		__entry->refs		= buf->refs;
 		__entry->cow_start	= cow->start;
 		__entry->buf_level	= btrfs_header_level(buf);
 		__entry->cow_level	= btrfs_header_level(cow);
-- 
1.7.5.2

