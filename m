From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 11/12] btrfs: drop gfp parameter from alloc_extent_buffer
Date: Fri, 22 Apr 2011 11:43:18 +0200
Message-ID: <4ba4f50d4dbdbb93b96039ddf6ca517f994d7fd9.1303398927.git.dsterba@suse.cz>
References: <cover.1303398927.git.dsterba@suse.cz>
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1303398927.git.dsterba@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

pass GFP_NOFS directly to kmem_cache_alloc

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/disk-io.c   |    6 +++---
 fs/btrfs/extent_io.c |    7 +++----
 fs/btrfs/extent_io.h |    3 +--
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 11a3890..10ce730 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -380,7 +380,7 @@ static int csum_dirty_buffer(struct btrfs_root *root, struct page *page)
 	len = page->private >> 2;
 	WARN_ON(len == 0);
 
-	eb = alloc_extent_buffer(tree, start, len, page, GFP_NOFS);
+	eb = alloc_extent_buffer(tree, start, len, page);
 	if (eb == NULL) {
 		WARN_ON(1);
 		goto out;
@@ -525,7 +525,7 @@ static int btree_readpage_end_io_hook(struct page *page, u64 start, u64 end,
 	len = page->private >> 2;
 	WARN_ON(len == 0);
 
-	eb = alloc_extent_buffer(tree, start, len, page, GFP_NOFS);
+	eb = alloc_extent_buffer(tree, start, len, page);
 	if (eb == NULL) {
 		ret = -EIO;
 		goto out;
@@ -974,7 +974,7 @@ struct extent_buffer *btrfs_find_create_tree_block(struct btrfs_root *root,
 	struct extent_buffer *eb;
 
 	eb = alloc_extent_buffer(&BTRFS_I(btree_inode)->io_tree,
-				 bytenr, blocksize, NULL, GFP_NOFS);
+				 bytenr, blocksize, NULL);
 	return eb;
 }
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8eea107..2f01e0c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3266,8 +3266,7 @@ static inline void btrfs_release_extent_buffer(struct extent_buffer *eb)
 
 struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
 					  u64 start, unsigned long len,
-					  struct page *page0,
-					  gfp_t mask)
+					  struct page *page0)
 {
 	unsigned long num_pages = num_extent_pages(start, len);
 	unsigned long i;
@@ -3288,7 +3287,7 @@ struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
 	}
 	rcu_read_unlock();
 
-	eb = __alloc_extent_buffer(tree, start, len, mask);
+	eb = __alloc_extent_buffer(tree, start, len, GFP_NOFS);
 	if (!eb)
 		return NULL;
 
@@ -3305,7 +3304,7 @@ struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
 		i = 0;
 	}
 	for (; i < num_pages; i++, index++) {
-		p = find_or_create_page(mapping, index, mask | __GFP_HIGHMEM);
+		p = find_or_create_page(mapping, index, GFP_NOFS | __GFP_HIGHMEM);
 		if (!p) {
 			WARN_ON(1);
 			goto free_eb;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index ff220c3..3c3be74 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -260,8 +260,7 @@ void set_page_extent_mapped(struct page *page);
 
 struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
 					  u64 start, unsigned long len,
-					  struct page *page0,
-					  gfp_t mask);
+					  struct page *page0);
 struct extent_buffer *find_extent_buffer(struct extent_io_tree *tree,
 					 u64 start, unsigned long len);
 void free_extent_buffer(struct extent_buffer *eb);
-- 
1.7.5.rc3

