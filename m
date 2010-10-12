From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 2/2] btrfs: Switching the extent buffer rbtree into a unlock
 radix tree
Date: Tue, 12 Oct 2010 17:43:14 +0800
Message-ID: <4CB42DB2.5080906@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch reduces the CPU time spent in the extent buffer search by using the
radix tree instead of the rbtree and using the rcu lock instead of the spin
lock.

I did a quick test by the benchmark tool[1] and found the patch improve the
file creation/deletion performance problem that I have reported[2].

Before applying this patch:
Create files:
	Total files: 50000
	Total time: 0.971531
	Average time: 0.000019
Delete files:
	Total files: 50000
	Total time: 1.366761
	Average time: 0.000027

After applying this patch:
Create files:
	Total files: 50000
	Total time: 0.927455
	Average time: 0.000019
Delete files:
	Total files: 50000
	Total time: 1.292280
	Average time: 0.000026


[1] http://marc.info/?l=linux-btrfs&m=128212635122920&q=p3
[2] http://marc.info/?l=linux-btrfs&m=128212635122920&w=2

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c |  114 ++++++++++++++++++++-----------------------------
 fs/btrfs/extent_io.h |    4 +-
 2 files changed, 49 insertions(+), 69 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 70b7cc5..c0663c1 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -104,7 +104,7 @@ void extent_io_tree_init(struct extent_io_tree *tree,
 			  struct address_space *mapping, gfp_t mask)
 {
 	tree->state = RB_ROOT;
-	tree->buffer = RB_ROOT;
+	INIT_RADIX_TREE(&tree->buffer, GFP_ATOMIC);
 	tree->ops = NULL;
 	tree->dirty_bytes = 0;
 	spin_lock_init(&tree->lock);
@@ -235,50 +235,6 @@ static inline struct rb_node *tree_search(struct extent_io_tree *tree,
 	return ret;
 }
 
-static struct extent_buffer *buffer_tree_insert(struct extent_io_tree *tree,
-					  u64 offset, struct rb_node *node)
-{
-	struct rb_root *root = &tree->buffer;
-	struct rb_node **p = &root->rb_node;
-	struct rb_node *parent = NULL;
-	struct extent_buffer *eb;
-
-	while (*p) {
-		parent = *p;
-		eb = rb_entry(parent, struct extent_buffer, rb_node);
-
-		if (offset < eb->start)
-			p = &(*p)->rb_left;
-		else if (offset > eb->start)
-			p = &(*p)->rb_right;
-		else
-			return eb;
-	}
-
-	rb_link_node(node, parent, p);
-	rb_insert_color(node, root);
-	return NULL;
-}
-
-static struct extent_buffer *buffer_search(struct extent_io_tree *tree,
-					   u64 offset)
-{
-	struct rb_root *root = &tree->buffer;
-	struct rb_node *n = root->rb_node;
-	struct extent_buffer *eb;
-
-	while (n) {
-		eb = rb_entry(n, struct extent_buffer, rb_node);
-		if (offset < eb->start)
-			n = n->rb_left;
-		else if (offset > eb->start)
-			n = n->rb_right;
-		else
-			return eb;
-	}
-	return NULL;
-}
-
 static void merge_cb(struct extent_io_tree *tree, struct extent_state *new,
 		     struct extent_state *other)
 {
@@ -3075,6 +3031,7 @@ static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
 	eb->len = len;
 	spin_lock_init(&eb->lock);
 	init_waitqueue_head(&eb->lock_wq);
+	INIT_RCU_HEAD(&eb->rcu_head);
 
 #if LEAK_DEBUG
 	spin_lock_irqsave(&leak_lock, flags);
@@ -3143,16 +3100,16 @@ struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
 	struct page *p;
 	struct address_space *mapping = tree->mapping;
 	int uptodate = 1;
+	int ret;
 
-	spin_lock(&tree->buffer_lock);
-	eb = buffer_search(tree, start);
-	if (eb) {
-		atomic_inc(&eb->refs);
-		spin_unlock(&tree->buffer_lock);
+	rcu_read_lock();
+	eb = radix_tree_lookup(&tree->buffer, start >> PAGE_CACHE_SHIFT);
+	if (eb && atomic_inc_not_zero(&eb->refs)) {
+		rcu_read_unlock();
 		mark_page_accessed(eb->first_page);
 		return eb;
 	}
-	spin_unlock(&tree->buffer_lock);
+	rcu_read_unlock();
 
 	eb = __alloc_extent_buffer(tree, start, len, mask);
 	if (!eb)
@@ -3191,17 +3148,25 @@ struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
 	if (uptodate)
 		set_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
 
+	ret = radix_tree_preload(GFP_NOFS & ~__GFP_HIGHMEM);
+	if (ret)
+		goto free_eb;
+
 	spin_lock(&tree->buffer_lock);
-	exists = buffer_tree_insert(tree, start, &eb->rb_node);
-	if (exists) {
+	ret = radix_tree_insert(&tree->buffer, start >> PAGE_CACHE_SHIFT, eb);
+	if (ret == -EEXIST) {
+		exists = radix_tree_lookup(&tree->buffer,
+						start >> PAGE_CACHE_SHIFT);
 		/* add one reference for the caller */
 		atomic_inc(&exists->refs);
 		spin_unlock(&tree->buffer_lock);
+		radix_tree_preload_end();
 		goto free_eb;
 	}
 	/* add one reference for the tree */
 	atomic_inc(&eb->refs);
 	spin_unlock(&tree->buffer_lock);
+	radix_tree_preload_end();
 	return eb;
 
 free_eb:
@@ -3217,16 +3182,16 @@ struct extent_buffer *find_extent_buffer(struct extent_io_tree *tree,
 {
 	struct extent_buffer *eb;
 
-	spin_lock(&tree->buffer_lock);
-	eb = buffer_search(tree, start);
-	if (eb)
-		atomic_inc(&eb->refs);
-	spin_unlock(&tree->buffer_lock);
-
-	if (eb)
+	rcu_read_lock();
+	eb = radix_tree_lookup(&tree->buffer, start >> PAGE_CACHE_SHIFT);
+	if (eb && atomic_inc_not_zero(&eb->refs)) {
+		rcu_read_unlock();
 		mark_page_accessed(eb->first_page);
+		return eb;
+	}
+	rcu_read_unlock();
 
-	return eb;
+	return NULL;
 }
 
 void free_extent_buffer(struct extent_buffer *eb)
@@ -3856,6 +3821,14 @@ void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 	}
 }
 
+static inline void btrfs_release_extent_buffer_rcu(struct rcu_head *head)
+{
+	struct extent_buffer *eb =
+			container_of(head, struct extent_buffer, rcu_head);
+
+	btrfs_release_extent_buffer(eb);
+}
+
 int try_release_extent_buffer(struct extent_io_tree *tree, struct page *page)
 {
 	u64 start = page_offset(page);
@@ -3863,23 +3836,30 @@ int try_release_extent_buffer(struct extent_io_tree *tree, struct page *page)
 	int ret = 1;
 
 	spin_lock(&tree->buffer_lock);
-	eb = buffer_search(tree, start);
+	eb = radix_tree_lookup(&tree->buffer, start >> PAGE_CACHE_SHIFT);
 	if (!eb)
 		goto out;
 
-	if (atomic_read(&eb->refs) > 1) {
+	if (test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags)) {
 		ret = 0;
 		goto out;
 	}
-	if (test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags)) {
+
+	/*
+	 * set @eb->refs to 0 if it is already 1, and then release the @eb.
+	 * Or go back.
+	 */
+	if (atomic_cmpxchg(&eb->refs, 1, 0) != 1) {
 		ret = 0;
 		goto out;
 	}
 
-	rb_erase(&eb->rb_node, &tree->buffer);
-	/* at this point we can safely release the extent buffer */
-	btrfs_release_extent_buffer(eb);
+	radix_tree_delete(&tree->buffer, start >> PAGE_CACHE_SHIFT);
 out:
 	spin_unlock(&tree->buffer_lock);
+
+	/* at this point we can safely release the extent buffer */
+	if (atomic_read(&eb->refs) == 0)
+		call_rcu(&eb->rcu_head, btrfs_release_extent_buffer_rcu);
 	return ret;
 }
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 5691c7b..1c6d4f3 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -85,7 +85,7 @@ struct extent_io_ops {
 
 struct extent_io_tree {
 	struct rb_root state;
-	struct rb_root buffer;
+	struct radix_tree_root buffer;
 	struct address_space *mapping;
 	u64 dirty_bytes;
 	spinlock_t lock;
@@ -123,7 +123,7 @@ struct extent_buffer {
 	unsigned long bflags;
 	atomic_t refs;
 	struct list_head leak_list;
-	struct rb_node rb_node;
+	struct rcu_head rcu_head;
 
 	/* the spinlock is used to protect most operations */
 	spinlock_t lock;
-- 
1.7.0.1
