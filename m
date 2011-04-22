From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 10/12] btrfs: drop gfp parameter from find_extent_buffer
Date: Fri, 22 Apr 2011 11:42:55 +0200
Message-ID: <afe7275470f11f99fbcb684175c81729e07ca7c7.1303398927.git.dsterba@suse.cz>
References: <cover.1303398927.git.dsterba@suse.cz>
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1303398927.git.dsterba@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

pass GFP_NOFS directly to kmem_cache_alloc

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/disk-io.c   |    4 ++--
 fs/btrfs/extent_io.c |    3 +--
 fs/btrfs/extent_io.h |    3 +--
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1fb8e0c..11a3890 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -963,7 +963,7 @@ struct extent_buffer *btrfs_find_tree_block(struct btrfs_root *root,
 	struct inode *btree_inode = root->fs_info->btree_inode;
 	struct extent_buffer *eb;
 	eb = find_extent_buffer(&BTRFS_I(btree_inode)->io_tree,
-				bytenr, blocksize, GFP_NOFS);
+				bytenr, blocksize);
 	return eb;
 }
 
@@ -2696,7 +2696,7 @@ int btree_lock_page_hook(struct page *page)
 		goto out;
 
 	len = page->private >> 2;
-	eb = find_extent_buffer(io_tree, bytenr, len, GFP_NOFS);
+	eb = find_extent_buffer(io_tree, bytenr, len);
 	if (!eb)
 		goto out;
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 7a36b75..8eea107 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3377,8 +3377,7 @@ free_eb:
 }
 
 struct extent_buffer *find_extent_buffer(struct extent_io_tree *tree,
-					 u64 start, unsigned long len,
-					  gfp_t mask)
+					 u64 start, unsigned long len)
 {
 	struct extent_buffer *eb;
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index e9cfe8d..ff220c3 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -263,8 +263,7 @@ struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
 					  struct page *page0,
 					  gfp_t mask);
 struct extent_buffer *find_extent_buffer(struct extent_io_tree *tree,
-					 u64 start, unsigned long len,
-					  gfp_t mask);
+					 u64 start, unsigned long len);
 void free_extent_buffer(struct extent_buffer *eb);
 int read_extent_buffer_pages(struct extent_io_tree *tree,
 			     struct extent_buffer *eb, u64 start, int wait,
-- 
1.7.5.rc3

