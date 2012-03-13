From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: introduce free_extent_buffer_stale
Date: Tue, 13 Mar 2012 09:51:30 -0400
Message-ID: <20120313135130.GC5023@dhcp231-144.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Because btrfs cow's we can end up with extent buffers that are no longer
necessary just sitting around in memory.  So instead of evicting these pages, we
could end up evicting things we actually care about.  Thus we have
free_extent_buffer_stale for use when we are freeing tree blocks.  This will
make it so that the ref for the eb being in the radix tree is dropped as soon as
possible and then is freed when the refcount hits 0 instead of waiting to be
released by releasepage.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.c       |   31 +++++++---
 fs/btrfs/disk-io.c     |   14 +----
 fs/btrfs/extent-tree.c |    4 -
 fs/btrfs/extent_io.c   |  157 ++++++++++++++++++++++++++++++++++++++----------
 fs/btrfs/extent_io.h   |    5 +-
 5 files changed, 152 insertions(+), 59 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 0639a55..fbf0f12 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -156,10 +156,23 @@ struct extent_buffer *btrfs_root_node(struct btrfs_root *root)
 {
 	struct extent_buffer *eb;
 
-	rcu_read_lock();
-	eb = rcu_dereference(root->node);
-	extent_buffer_get(eb);
-	rcu_read_unlock();
+	while (1) {
+		rcu_read_lock();
+		eb = rcu_dereference(root->node);
+
+		/*
+		 * RCU really hurts here, we could free up the root node because
+		 * it was cow'ed but we may not get the new root node yet so do
+		 * the inc_not_zero dance and if it doesn't work then
+		 * synchronize_rcu and try again.
+		 */
+		if (extent_buffer_inc_not_zero(eb)) {
+			rcu_read_unlock();
+			break;
+		}
+		rcu_read_unlock();
+		synchronize_rcu();
+	}
 	return eb;
 }
 
@@ -504,7 +517,7 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 	}
 	if (unlock_orig)
 		btrfs_tree_unlock(buf);
-	free_extent_buffer(buf);
+	free_extent_buffer_stale(buf);
 	btrfs_mark_buffer_dirty(cow);
 	*cow_ret = cow;
 	return 0;
@@ -959,7 +972,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 		root_sub_used(root, mid->len);
 		btrfs_free_tree_block(trans, root, mid, 0, 1, 0);
 		/* once for the root ptr */
-		free_extent_buffer(mid);
+		free_extent_buffer_stale(mid);
 		return 0;
 	}
 	if (btrfs_header_nritems(mid) >
@@ -1016,7 +1029,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 				ret = wret;
 			root_sub_used(root, right->len);
 			btrfs_free_tree_block(trans, root, right, 0, 1, 0);
-			free_extent_buffer(right);
+			free_extent_buffer_stale(right);
 			right = NULL;
 		} else {
 			struct btrfs_disk_key right_key;
@@ -1056,7 +1069,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 			ret = wret;
 		root_sub_used(root, mid->len);
 		btrfs_free_tree_block(trans, root, mid, 0, 1, 0);
-		free_extent_buffer(mid);
+		free_extent_buffer_stale(mid);
 		mid = NULL;
 	} else {
 		/* update the parent key to reflect our changes */
@@ -3781,7 +3794,9 @@ static noinline int btrfs_del_leaf(struct btrfs_trans_handle *trans,
 
 	root_sub_used(root, leaf->len);
 
+	extent_buffer_get(leaf);
 	btrfs_free_tree_block(trans, root, leaf, 0, 1, 0);
+	free_extent_buffer_stale(leaf);
 	return 0;
 }
 /*
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b8f2284..a3c9166 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -925,21 +925,9 @@ static int btree_readpage(struct file *file, struct page *page)
 
 static int btree_releasepage(struct page *page, gfp_t gfp_flags)
 {
-	struct extent_map_tree *map;
-	struct extent_io_tree *tree;
-	int ret;
-
 	if (PageWriteback(page) || PageDirty(page))
 		return 0;
-
-	tree = &BTRFS_I(page->mapping->host)->io_tree;
-	map = &BTRFS_I(page->mapping->host)->extent_tree;
-
-	ret = try_release_extent_state(map, tree, page, gfp_flags);
-	if (!ret)
-		return 0;
-
-	return try_release_extent_buffer(tree, page);
+	return try_release_extent_buffer(page, gfp_flags);
 }
 
 static void btree_invalidatepage(struct page *page, unsigned long offset)
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e5111d5..4f7cc56 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5011,10 +5011,6 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 		if (is_data) {
 			ret = btrfs_del_csums(trans, root, bytenr, num_bytes);
 			BUG_ON(ret);
-		} else {
-			invalidate_mapping_pages(info->btree_inode->i_mapping,
-			     bytenr >> PAGE_CACHE_SHIFT,
-			     (bytenr + num_bytes - 1) >> PAGE_CACHE_SHIFT);
 		}
 
 		ret = update_block_group(trans, root, bytenr, num_bytes, 0);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index f6f31b6..41596a7 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3637,6 +3637,8 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb,
 			 */
 			if (PagePrivate(page) &&
 			    page->private == (unsigned long)eb) {
+				BUG_ON(PageDirty(page));
+				BUG_ON(PageWriteback(page));
 				/*
 				 * We need to make sure we haven't be attached
 				 * to a new eb.
@@ -3755,7 +3757,10 @@ again:
 		goto free_eb;
 	}
 	/* add one reference for the tree */
-	extent_buffer_get(eb);
+	spin_lock(&eb->eb_lock);
+	eb->refs++;
+	set_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags);
+	spin_unlock(&eb->eb_lock);
 	spin_unlock(&tree->buffer_lock);
 	radix_tree_preload_end();
 
@@ -3805,19 +3810,116 @@ struct extent_buffer *find_extent_buffer(struct extent_io_tree *tree,
 	return NULL;
 }
 
+static inline void btrfs_release_extent_buffer_rcu(struct rcu_head *head)
+{
+	struct extent_buffer *eb =
+			container_of(head, struct extent_buffer, rcu_head);
+
+	__free_extent_buffer(eb);
+}
+
+static int extent_buffer_under_io(struct extent_buffer *eb,
+				  struct page *locked_page)
+{
+	unsigned long num_pages, i;
+
+	num_pages = num_extent_pages(eb->start, eb->len);
+	for (i = 0; i < num_pages; i++) {
+		struct page *page = eb->pages[i];
+		int need_unlock = 0;
+
+		if (!page)
+			continue;
+
+		if (page != locked_page) {
+			if (!trylock_page(page))
+				return 1;
+			need_unlock = 1;
+		}
+
+		if (PageDirty(page) || PageWriteback(page)) {
+			if (need_unlock)
+				unlock_page(page);
+			return 1;
+		}
+		if (need_unlock)
+			unlock_page(page);
+	}
+
+	return 0;
+}
+
+/* Expects to have eb->eb_lock already held */
+static void release_extent_buffer(struct extent_buffer *eb, gfp_t mask)
+{
+	if (--eb->refs == 0) {
+		struct extent_io_tree *tree = eb->tree;
+		int ret;
+
+		spin_unlock(&eb->eb_lock);
+
+		might_sleep_if(mask & __GFP_WAIT);
+		ret = clear_extent_bit(tree, eb->start,
+				       eb->start + eb->len - 1, -1, 0, 0,
+				       NULL, mask);
+		if (ret < 0) {
+			/*
+			 * We failed to clear the state bits which likely means
+			 * ENOMEM, so just re-up the eb ref and continue, we
+			 * will get freed later on via releasepage or something
+			 * else and will be ok.
+			 */
+			spin_lock(&eb->eb_lock);
+			set_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags);
+			eb->refs++;
+			spin_unlock(&eb->eb_lock);
+			return;
+		}
+
+		spin_lock(&tree->buffer_lock);
+		radix_tree_delete(&tree->buffer,
+				  eb->start >> PAGE_CACHE_SHIFT);
+		spin_unlock(&tree->buffer_lock);
+
+		/* Should be safe to release our pages at this point */
+		btrfs_release_extent_buffer_page(eb, 0);
+
+		call_rcu(&eb->rcu_head, btrfs_release_extent_buffer_rcu);
+		return;
+	}
+	spin_unlock(&eb->eb_lock);
+}
+
 void free_extent_buffer(struct extent_buffer *eb)
 {
 	if (!eb)
 		return;
 
 	spin_lock(&eb->eb_lock);
-	if (--eb->refs != 0) {
-		spin_unlock(&eb->eb_lock);
+	if (test_bit(EXTENT_BUFFER_STALE, &eb->bflags) &&
+	    !extent_buffer_under_io(eb, NULL) &&
+	    test_and_clear_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags))
+		eb->refs--;
+
+	/*
+	 * I know this is terrible, but it's temporary until we stop tracking
+	 * the uptodate bits and such for the extent buffers.
+	 */
+	release_extent_buffer(eb, GFP_ATOMIC);
+}
+
+void free_extent_buffer_stale(struct extent_buffer *eb)
+{
+	if (!eb)
 		return;
-	}
-	spin_unlock(&eb->eb_lock);
 
-	WARN_ON(1);
+	spin_lock(&eb->eb_lock);
+	set_bit(EXTENT_BUFFER_STALE, &eb->bflags);
+
+	if (!extent_buffer_under_io(eb, NULL) &&
+	    test_and_clear_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags))
+		eb->refs--;
+	release_extent_buffer(eb, GFP_NOFS);
 }
 
 int clear_extent_buffer_dirty(struct extent_io_tree *tree,
@@ -4427,42 +4529,31 @@ void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 	}
 }
 
-static inline void btrfs_release_extent_buffer_rcu(struct rcu_head *head)
-{
-	struct extent_buffer *eb =
-			container_of(head, struct extent_buffer, rcu_head);
-
-	__free_extent_buffer(eb);
-}
-
-int try_release_extent_buffer(struct extent_io_tree *tree, struct page *page)
+int try_release_extent_buffer(struct page *page, gfp_t mask)
 {
-	u64 start = page_offset(page);
 	struct extent_buffer *eb = (struct extent_buffer *)page->private;
-	int ret = 1;
-	int release = 0;
 
 	if (!PagePrivate(page) || !eb)
 		return 1;
 
-	spin_lock(&tree->buffer_lock);
 	spin_lock(&eb->eb_lock);
-	if (eb->refs > 1 || test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags)) {
+	if (eb->refs > 1 || extent_buffer_under_io(eb, page)) {
 		spin_unlock(&eb->eb_lock);
-		ret = 0;
-		goto out;
+		return 0;
 	}
-	eb->refs--;
-	release = 1;
-	spin_unlock(&eb->eb_lock);
 
-	radix_tree_delete(&tree->buffer, start >> PAGE_CACHE_SHIFT);
-	btrfs_release_extent_buffer_page(eb, 0);
-out:
-	spin_unlock(&tree->buffer_lock);
+	if ((mask & GFP_NOFS) == GFP_NOFS)
+		mask = GFP_NOFS;
 
-	/* at this point we can safely release the extent buffer */
-	if (release)
-		call_rcu(&eb->rcu_head, btrfs_release_extent_buffer_rcu);
-	return ret;
+	/*
+	 * If tree ref isn't set then we know the ref on this eb is a real ref,
+	 * so just return, this page will likely be freed soon anyway.
+	 */
+	if (!test_and_clear_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags)) {
+		spin_unlock(&eb->eb_lock);
+		return 0;
+	}
+	release_extent_buffer(eb, mask);
+
+	return 1;
 }
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index f0d6973..b244ec1 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -35,6 +35,8 @@
 #define EXTENT_BUFFER_DIRTY 2
 #define EXTENT_BUFFER_CORRUPT 3
 #define EXTENT_BUFFER_READAHEAD 4	/* this got triggered by readahead */
+#define EXTENT_BUFFER_TREE_REF 5
+#define EXTENT_BUFFER_STALE 6
 
 /* these are flags for extent_clear_unlock_delalloc */
 #define EXTENT_CLEAR_UNLOCK_PAGE 0x1
@@ -190,7 +192,7 @@ void extent_io_tree_init(struct extent_io_tree *tree,
 int try_release_extent_mapping(struct extent_map_tree *map,
 			       struct extent_io_tree *tree, struct page *page,
 			       gfp_t mask);
-int try_release_extent_buffer(struct extent_io_tree *tree, struct page *page);
+int try_release_extent_buffer(struct page *page, gfp_t mask);
 int try_release_extent_state(struct extent_map_tree *map,
 			     struct extent_io_tree *tree, struct page *page,
 			     gfp_t mask);
@@ -267,6 +269,7 @@ struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
 struct extent_buffer *find_extent_buffer(struct extent_io_tree *tree,
 					 u64 start, unsigned long len);
 void free_extent_buffer(struct extent_buffer *eb);
+void free_extent_buffer_stale(struct extent_buffer *eb);
 #define WAIT_NONE	0
 #define WAIT_COMPLETE	1
 #define WAIT_PAGE_LOCK	2
-- 
1.7.5.2

